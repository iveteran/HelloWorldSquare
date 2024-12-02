#include <iostream>
#include <cstring>
#include <vector>
#include <map>
#include <memory>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/epoll.h>
#include <unistd.h>
#include <fcntl.h>

struct ClientContext {
    std::unique_ptr<SSL, decltype(&SSL_free)> ssl;
    struct sockaddr_in addr;
    socklen_t addr_len;
    bool handshake_complete;

    ClientContext(SSL* ssl_ptr) : 
        ssl(ssl_ptr, SSL_free),
        addr_len(sizeof(addr)),
        handshake_complete(false) {
        memset(&addr, 0, sizeof(addr));
    }
};

class DTLSServer {
private:
    int sock;
    int epoll_fd;
    SSL_CTX* ctx;
    std::map<std::string, std::unique_ptr<ClientContext>> clients;
    const int BUFFER_SIZE = 4096;
    const int MAX_EVENTS = 32;
    
    void init_openssl() {
        SSL_library_init();
        SSL_load_error_strings();
        OpenSSL_add_ssl_algorithms();
    }
    
    void cleanup_openssl() {
        EVP_cleanup();
    }
    
    SSL_CTX* create_context() {
        const SSL_METHOD* method = DTLS_server_method();
        SSL_CTX* ctx = SSL_CTX_new(method);
        if (!ctx) {
            perror("Unable to create SSL context");
            ERR_print_errors_fp(stderr);
            exit(EXIT_FAILURE);
        }
        
        // Set DTLS cookie generation and verification
        SSL_CTX_set_cookie_generate_cb(ctx, generate_cookie);
        SSL_CTX_set_cookie_verify_cb(ctx, verify_cookie);
        
        return ctx;
    }
    
    void configure_context(SSL_CTX* ctx) {
        if (SSL_CTX_use_certificate_file(ctx, "certificates/server-cert.pem", SSL_FILETYPE_PEM) <= 0) {
            ERR_print_errors_fp(stderr);
            exit(EXIT_FAILURE);
        }

        if (SSL_CTX_use_PrivateKey_file(ctx, "certificates/server-key.pem", SSL_FILETYPE_PEM) <= 0) {
            ERR_print_errors_fp(stderr);
            exit(EXIT_FAILURE);
        }

        //SSL_CTX_set_verify_depth(ctx, 1);
        //SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, NULL);
    }

    static std::string get_client_key(const struct sockaddr_in& addr) {
        return std::string(inet_ntoa(addr.sin_addr)) + ":" + std::to_string(ntohs(addr.sin_port));
    }

    // Cookie callbacks for DTLS
    static int generate_cookie(SSL *ssl, unsigned char *cookie, unsigned int *cookie_len) {
        *cookie_len = 16;  // Use a fixed length for simplicity
        memset(cookie, 0x01, *cookie_len);  // Fill with dummy data
        return 1;
    }

    static int verify_cookie(SSL *ssl, const unsigned char *cookie, unsigned int cookie_len) {
        return 1;  // Accept all cookies for simplicity
    }

    void set_nonblocking(int sock) {
        int flags = fcntl(sock, F_GETFL, 0);
        if (flags == -1) {
            perror("fcntl F_GETFL");
            exit(EXIT_FAILURE);
        }
        if (fcntl(sock, F_SETFL, flags | O_NONBLOCK) == -1) {
            perror("fcntl F_SETFL O_NONBLOCK");
            exit(EXIT_FAILURE);
        }
    }

    void handle_new_connection(const std::string& client_key, struct sockaddr_in &client_addr) {

        // Create new SSL instance for this client
        SSL* ssl = SSL_new(ctx);
        if (!ssl) {
            ERR_print_errors_fp(stderr);
            return;
        }

        // Create BIO for the socket
        BIO* bio = BIO_new_dgram(sock, BIO_NOCLOSE);
        //BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_CONNECTED, 0, &client_addr);

        // Set the current client address for this SSL object
        BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_PEER, 0, &client_addr);

        /* Set and activate timeouts */
        struct timeval timeout;
        timeout.tv_sec = 5;
        timeout.tv_usec = 0;

        BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_RECV_TIMEOUT, 0, &timeout);
        SSL_set_bio(ssl, bio, bio);
        SSL_set_options(ssl, SSL_OP_COOKIE_EXCHANGE);

        //connect(sock, (struct sockaddr*)&client_addr, client_len);

        // Create and set up client context
        auto client_ctx = std::make_unique<ClientContext>(ssl);
        client_ctx->addr = client_addr;
        client_ctx->addr_len = sizeof(client_addr);

        // Store client context
        clients[client_key] = std::move(client_ctx);
        
        std::cout << "New client connected: " << client_key << std::endl;
    }

    int handle_client_data(const std::string& client_key) {

        char buffer[BUFFER_SIZE];

        auto& client = clients[client_key];
        SSL* ssl = client->ssl.get();

        char addr_buf[INET_ADDRSTRLEN] = {0};
        inet_ntop(client->addr.sin_family, (void*)&client->addr.sin_addr, addr_buf, sizeof(addr_buf));
        printf("client addr: %s:%d\n", addr_buf, ntohs(client->addr.sin_port));

        if (!client->handshake_complete) {
#if 1
            int ret = 0;
            do { ret = SSL_accept(ssl); }
            while (ret == 0);
            if (ret < 0) {
#else
            int ret = SSL_accept(ssl);
            if (ret <= 0) {
#endif
                int err = SSL_get_error(ssl, ret);
                if (err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE) {
                    return 0;  // Need more data
                }
                // Handle handshake failure
                std::cout << "Handshake failed with client: " << client_key << std::endl;
                //clients.erase(client_key);
                return -1;
            }
            client->handshake_complete = true;
            std::cout << "Handshake completed with client: " << client_key << std::endl;
            return 0;
        }

        // Handle data from established connection
        int len = SSL_read(ssl, buffer, BUFFER_SIZE - 1);
        if (len <= 0) {
            int err = SSL_get_error(ssl, len);
            if (err == SSL_ERROR_ZERO_RETURN || 
                err == SSL_ERROR_SYSCALL || 
                err == SSL_ERROR_SSL) {
                std::cout << "Client disconnected: " << client_key << std::endl;
                //clients.erase(client_key);
                return -1;
            }
            if (err != SSL_ERROR_WANT_READ && err != SSL_ERROR_WANT_WRITE) {
                ERR_print_errors_fp(stderr);
            }
            return 0;
        }

        buffer[len] = '\0';
        std::cout << "Received from " << client_key << ": " << buffer << std::endl;

        // Echo back
        SSL_write(ssl, buffer, len);
        return 0;
    }

public:
    DTLSServer(int port) {
        // Initialize OpenSSL
        init_openssl();
        ctx = create_context();
        configure_context(ctx);
        
        // Create UDP socket
        sock = socket(AF_INET, SOCK_DGRAM, 0);
        if (sock < 0) {
            perror("Socket creation failed");
            exit(EXIT_FAILURE);
        }
        
        // Set socket to non-blocking mode
        set_nonblocking(sock);

        const int on = 1;
        setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (const void*) &on, (socklen_t) sizeof(on));
        
        // Configure server address
        struct sockaddr_in server_addr;
        memset(&server_addr, 0, sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        server_addr.sin_addr.s_addr = INADDR_ANY;
        server_addr.sin_port = htons(port);
        
        // Bind socket
        if (bind(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
            perror("Bind failed");
            exit(EXIT_FAILURE);
        }

        // Create epoll instance
        epoll_fd = epoll_create1(0);
        if (epoll_fd < 0) {
            perror("epoll_create1 failed");
            exit(EXIT_FAILURE);
        }

        // Add server socket to epoll
        struct epoll_event ev;
        ev.events = EPOLLIN | EPOLLET;  // Edge-triggered mode
        ev.data.fd = sock;
        if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sock, &ev) < 0) {
            perror("epoll_ctl failed");
            exit(EXIT_FAILURE);
        }
    }
    
    ~DTLSServer() {
        close(epoll_fd);
        close(sock);
        SSL_CTX_free(ctx);
        cleanup_openssl();
    }
    
    void run() {
        std::cout << "Server started. Waiting for connections..." << std::endl;
        
        struct epoll_event events[MAX_EVENTS];
        
        while (true) {
            int nfds = epoll_wait(epoll_fd, events, MAX_EVENTS, -1);
            if (nfds < 0) {
                if (errno == EINTR) continue;
            }
            std::cout << "epoll wait nfds: " << nfds << std::endl;

            for (int i = 0; i < nfds; i++) {
                if (events[i].data.fd != sock) {
                    continue;
                }

                struct sockaddr_in client_addr = { 0 };
                socklen_t client_len = sizeof(client_addr);
                char buffer[BUFFER_SIZE];
                
                // Receive initial datagram
                int len = recvfrom(sock, buffer, BUFFER_SIZE, MSG_PEEK,
                                  (struct sockaddr*)&client_addr, &client_len);
                if (len < 0) {
                    if (errno != EAGAIN && errno != EWOULDBLOCK) {
                        perror("recvfrom failed");
                    }
                    continue;
                }

                std::string client_key = get_client_key(client_addr);
                std::cout << "client_key: " << client_key << std::endl;
                
                // Check if client already exists
                if (clients.find(client_key) == clients.end()) {
                    // New connection
                    handle_new_connection(client_key, client_addr);
                } else {
                    int status = handle_client_data(client_key);
                    if (status < 0) {
                        clients.erase(client_key);
                        std::cout << "Remove client: " << client_key << std::endl;
                    }
                }
            }
        }
    }
};

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <port>" << std::endl;
        return 1;
    }
    
    int port = std::atoi(argv[1]);
    DTLSServer server(port);
    server.run();
    
    return 0;
}

// g++ -g -o dtls_server_epoll_claudeai dtls_server_epoll_claudeai.cpp -lssl -lcrypto
