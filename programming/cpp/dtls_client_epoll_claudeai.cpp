#include <openssl/ssl.h>
#include <openssl/err.h>
#include <sys/epoll.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <iostream>
#include <thread>
#include <signal.h>
#include <functional>

class DTLSClient {
private:
    SSL_CTX* ctx;
    SSL* ssl;
    int sock;
    int epoll_fd;
    struct sockaddr_in server_addr;
    bool running = true;

    void init_openssl() {
        SSL_library_init();
        SSL_load_error_strings();
        OpenSSL_add_ssl_algorithms();
        
        ctx = SSL_CTX_new(DTLS_client_method());
        if (!ctx) {
            std::cerr << "Failed to create SSL context" << std::endl;
            exit(1);
        }

        // Set DTLS 1.2
        SSL_CTX_set_min_proto_version(ctx, DTLS1_2_VERSION);
        SSL_CTX_set_max_proto_version(ctx, DTLS1_2_VERSION);

        // Set cipher list
        const char* cipher_list = "ALL:!COMPLEMENTOFDEFAULT:!eNULL:!aNULL:!ADH:!EXP:!SSLv2:!SSLv3:!TLSv1:!TLSv1.1";
        if (SSL_CTX_set_cipher_list(ctx, cipher_list) != 1) {
            std::cerr << "Failed to set cipher list" << std::endl;
            exit(1);
        }

        // Load certificates (optional for client, but recommended)
        if (SSL_CTX_load_verify_locations(ctx, "certificates/ca-cert.pem", nullptr) != 1) {
            std::cerr << "Failed to load CA certificate" << std::endl;
            ERR_print_errors_fp(stderr);
        }

        SSL_CTX_set_verify_depth(ctx, 1);
        SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, NULL);
    }

    void setup_socket(const char* server_ip, int port) {
        sock = socket(AF_INET, SOCK_DGRAM, 0);
        if (sock < 0) {
            std::cerr << "Failed to create socket" << std::endl;
            exit(1);
        }

        memset(&server_addr, 0, sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        if (inet_pton(AF_INET, server_ip, &server_addr.sin_addr) != 1) {
            std::cerr << "Invalid address" << std::endl;
            exit(1);
        }

        // Setup epoll
        epoll_fd = epoll_create1(0);
        if (epoll_fd < 0) {
            std::cerr << "Failed to create epoll instance" << std::endl;
            exit(1);
        }

        struct epoll_event ev;
        ev.events = EPOLLIN;
        ev.data.fd = sock;
        if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sock, &ev) < 0) {
            std::cerr << "Failed to add socket to epoll" << std::endl;
            exit(1);
        }
    }

    void setup_ssl() {
        ssl = SSL_new(ctx);
        if (!ssl) {
            std::cerr << "Failed to create SSL structure" << std::endl;
            exit(1);
        }

        // Create BIO
        BIO* bio = BIO_new_dgram(sock, BIO_NOCLOSE);
        BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_CONNECTED, 0, &server_addr);

        SSL_set_bio(ssl, bio, bio);
        SSL_set_connect_state(ssl);

        // Set timeout
        struct timeval timeout;
        timeout.tv_sec = 5;
        timeout.tv_usec = 0;
        BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_RECV_TIMEOUT, 0, &timeout);
    }

    void handle_dtls_error(int result) {
        int err = SSL_get_error(ssl, result);
        switch (err) {
            case SSL_ERROR_WANT_READ:
            case SSL_ERROR_WANT_WRITE:
                // Non-blocking operation, just continue
                break;
            case SSL_ERROR_ZERO_RETURN:
                std::cout << "DTLS connection closed" << std::endl;
                break;
            default:
                ERR_print_errors_fp(stderr);
                break;
        }
    }

public:
    DTLSClient(const char* server_ip, int port) {
        init_openssl();
        setup_socket(server_ip, port);
        setup_ssl();
    }

    ~DTLSClient() {
        //SSL_shutdown(ssl);
        SSL_free(ssl);
        SSL_CTX_free(ctx);
        EVP_cleanup();
        close(sock);
        close(epoll_fd);
    }

    bool connect_to_server() {

        // Connect to server
        if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
            perror("Connect failed");
            return false;
        }

        int result = SSL_connect(ssl);
        if (result != 1) {
            std::cout << "SSL_connect failed" << std::endl;
            handle_dtls_error(result);
            return false;
        }
        std::cout << "Connected with " << SSL_get_cipher(ssl) << std::endl;
        return true;
    }


    void graceful_shutdown() {
        std::cout << "\nInitiating graceful shutdown..." << std::endl;

        if (ssl) {
            // Send close_notify alert and wait for the peer's close_notify
            int ret = SSL_shutdown(ssl);
            if (ret == 0) {
                // If ret == 0, call SSL_shutdown() again for bidirectional shutdown
                SSL_shutdown(ssl);
            }
        }
        running = false;
    }

    void run() {
        if (!connect_to_server()) {
            std::cerr << "Failed to connect to server" << std::endl;
            return;
        }

        struct epoll_event events[10];
        char buffer[4096];

        // Start a thread for reading user input
        std::thread input_thread([&]() {
            std::cout << ">> Press quit to quit <<" << std::endl;
            while (running) {
                std::cout << "> ";
                std::string message;
                std::getline(std::cin, message);
                
                if (message == "quit") {
                    graceful_shutdown();
                    running = false;
                    break;
                }

                int written = SSL_write(ssl, message.c_str(), message.length());
                if (written <= 0) {
                    handle_dtls_error(written);
                }
            }
        });

        // Main event loop
        while (running) {
            int nfds = epoll_wait(epoll_fd, events, 10, 100); // 100ms timeout
            if (nfds < 0) {
                std::cerr << "epoll_wait error" << std::endl;
                break;
            }

            for (int i = 0; i < nfds; i++) {
                if (events[i].data.fd == sock) {
                    int len = SSL_read(ssl, buffer, sizeof(buffer) - 1);
                    if (len > 0) {
                        buffer[len] = 0;
                        std::cout << "Received: " << buffer << std::endl;
                    } else if (len < 0) {
                        handle_dtls_error(len);
                    }
                }
            }
        }

        input_thread.join();
    }
};

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <server_ip> <port>" << std::endl;
        return 1;
    }

    try {
        DTLSClient client(argv[1], std::stoi(argv[2]));

        // Setup signal handler
        signal(SIGINT, [](int sig) {
            std::cout << "\nReceived signal " << sig << std::endl;
            //throw std::runtime_error("Signal received");
            //client.graceful_shutdown();
        });

        client.run();
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}

// g++ -g -o dtls_client_epoll_claudeai dtls_client_epoll_claudeai.cpp -lssl -lcrypto
