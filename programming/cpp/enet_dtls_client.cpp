#include <enet/enet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <iostream>
#include <vector>
#include <thread>
#include <atomic>

static void ssl_info_callback(const SSL *ssl, int where, int ret) {
    if (where & SSL_CB_LOOP) {
        std::cout << "SSL state (" << SSL_state_string_long(ssl) << ")" << std::endl;
    } else if (where & SSL_CB_ALERT) {
        std::cout << "SSL alert (" << SSL_alert_type_string_long(ret) << "): "
            << SSL_alert_desc_string_long(ret) << std::endl;
    }
}

class ENetDTLSClient {
private:
    ENetHost* client;
    ENetPeer* peer;
    SSL_CTX* ssl_ctx;
    SSL* ssl;
    bool handshake_done_ = false;
    std::vector<uint8_t> incoming_buffer;
    std::vector<uint8_t> outgoing_buffer;
    std::atomic<bool> running{true};

    // Custom BIO methods
    static BIO_METHOD* create_bio_method() {
        BIO_METHOD* methods = BIO_meth_new(BIO_TYPE_DGRAM, "ENet DTLS Client");
        BIO_meth_set_write(methods, bio_write);
        BIO_meth_set_read(methods, bio_read);
        BIO_meth_set_ctrl(methods, bio_ctrl);
        BIO_meth_set_create(methods, bio_create);
        BIO_meth_set_destroy(methods, bio_destroy);
        return methods;
    }

#if 0
    // BIO callbacks
    static int bio_write(BIO* bio, const char* data, int len) {
        auto* buffer = static_cast<std::vector<uint8_t>*>(BIO_get_data(bio));
        if (!buffer) return -1;

        buffer->insert(buffer->end(), data, data + len);
        BIO_clear_retry_flags(bio);
        return len;
    }

    static int bio_read(BIO* bio, char* data, int len) {
        auto* buffer = static_cast<std::vector<uint8_t>*>(BIO_get_data(bio));
        if (!buffer || buffer->empty()) {
            BIO_set_retry_read(bio);
            return -1;
        }

        int copy_len = std::min(len, static_cast<int>(buffer->size()));
        std::copy(buffer->begin(), buffer->begin() + copy_len, data);
        buffer->erase(buffer->begin(), buffer->begin() + copy_len);
        return copy_len;
    }
#endif

        // Modified BIO callbacks
    static int bio_write(BIO* bio, const char* data, int len) {
        printf("--> bio_write, len: %d\n", len);
        auto* client = static_cast<ENetDTLSClient*>(BIO_get_data(bio));
        if (!client || !client->peer) return -1;

        // Create and send ENet packet
        ENetPacket* packet = enet_packet_create(data, len, ENET_PACKET_FLAG_RELIABLE);
        if (enet_peer_send(client->peer, 0, packet) < 0) {
            enet_packet_destroy(packet);
            return -1;
        }
        enet_host_flush(client->client);
        return len;
    }

    static int bio_read(BIO* bio, char* data, int len) {
        printf("--> bio_read, buf len: %d\n", len);
        auto* client = static_cast<ENetDTLSClient*>(BIO_get_data(bio));
        if (!client || client->incoming_buffer.empty()) {
            BIO_set_retry_read(bio);
            return -1;
        }

        int copy_len = std::min(len, static_cast<int>(client->incoming_buffer.size()));
        printf("--> bio_read, read len: %d\n", copy_len);
        std::copy(client->incoming_buffer.begin(),
                 client->incoming_buffer.begin() + copy_len,
                 data);
        client->incoming_buffer.erase(
            client->incoming_buffer.begin(),
            client->incoming_buffer.begin() + copy_len
        );
        return copy_len;
    }

    static long bio_ctrl(BIO* bio, int cmd, long num, void* ptr) {
        std::cout << "bio_ctrl called with cmd: " << cmd << std::endl;

        auto* client = static_cast<ENetDTLSClient*>(BIO_get_data(bio));
        if (!client) {
            std::cerr << "bio_ctrl: No client data" << std::endl;
            return 0;
        }

        switch (cmd) {
            case BIO_CTRL_DGRAM_SET_NEXT_TIMEOUT:
            case BIO_CTRL_DGRAM_SET_RECV_TIMEOUT:
                return 1;
            case BIO_CTRL_FLUSH:
                enet_host_flush(client->client);
                return 1;
            case BIO_CTRL_DGRAM_QUERY_MTU:
                return 1200; // Return your preferred MTU
            case BIO_CTRL_DGRAM_GET_MTU:
                return 1200;
            default:
                std::cout << "bio_ctrl: Unhandled command " << cmd << std::endl;
                return 0;
        }
    }

    static int bio_create(BIO* bio) {
        BIO_set_init(bio, 1);
        return 1;
    }

    static int bio_destroy(BIO* bio) {
        return 1;
    }

    void init_openssl() {
        SSL_library_init();
        SSL_load_error_strings();
        OpenSSL_add_ssl_algorithms();

        ssl_ctx = SSL_CTX_new(DTLS_client_method());
        if (!ssl_ctx) {
            std::cerr << "Failed to create SSL context" << std::endl;
            exit(1);
        }

        // Set DTLS 1.2
        SSL_CTX_set_min_proto_version(ssl_ctx, DTLS1_2_VERSION);
        SSL_CTX_set_max_proto_version(ssl_ctx, DTLS1_2_VERSION);

        // Load CA certificate for verification
        if (!SSL_CTX_load_verify_locations(ssl_ctx, "../certs/ca-cert.pem", nullptr)) {
            std::cerr << "Failed to load CA certificate" << std::endl;
            exit(1);
        }

        // Set verification mode
        SSL_CTX_set_verify(ssl_ctx, SSL_VERIFY_PEER, nullptr);
        // For testing only - don't use in production!
        SSL_CTX_set_verify_depth(ssl_ctx, 4);

        // Enable debug output
        SSL_CTX_set_info_callback(ssl_ctx, ssl_info_callback);
        //SSL_CTX_set_msg_callback(ssl_ctx, ssl_msg_callback);
    }

    void handle_dtls_error(int result) {
        int err = SSL_get_error(ssl, result);
        switch (err) {
            case SSL_ERROR_WANT_READ:
                std::cerr << "SSL_connect needs more data to read" << std::endl;
                break;
            case SSL_ERROR_WANT_WRITE:
                std::cerr << "SSL_connect needs to write more data" << std::endl;
                break;
            case SSL_ERROR_ZERO_RETURN:
                std::cout << "DTLS connection closed" << std::endl;
                break;
            case SSL_ERROR_SYSCALL:
                std::cerr << "SSL_connect syscall error: " << ERR_error_string(ERR_get_error(), nullptr) << std::endl;
                if (err == 0) {
                    std::cerr << "EOF observed" << std::endl;
                } else {
                    std::cerr << "I/O error: " << strerror(errno) << std::endl;
                }
                break;
            case SSL_ERROR_SSL:
                std::cerr << "SSL_connect protocol error: " << ERR_error_string(ERR_get_error(), nullptr) << std::endl;
                break;
            default:
                std::cerr << "SSL_connect unknown error: " << err << std::endl;
                ERR_print_errors_fp(stderr);
                break;
        }
    }

#if 1
    void flush_outgoing() {
        if (outgoing_buffer.empty() || !peer) return;
        std::cout << "Sending " << outgoing_buffer.size() << " bytes" << std::endl;

        ENetPacket* packet = enet_packet_create(
            outgoing_buffer.data(),
            outgoing_buffer.size(),
            ENET_PACKET_FLAG_RELIABLE
        );

        if (enet_peer_send(peer, 0, packet) < 0) {
            enet_packet_destroy(packet);
        }

        outgoing_buffer.clear();
    }
#else
    void flush_outgoing() {
        if (outgoing_buffer.empty() || !peer) return;

        std::cout << "Sending " << outgoing_buffer.size() << " bytes" << std::endl;

        // Split large buffers into smaller packets if needed
        const size_t max_packet_size = 1200; // DTLS recommended size

        for (size_t offset = 0; offset < outgoing_buffer.size(); offset += max_packet_size) {
            size_t chunk_size = std::min(max_packet_size,
                    outgoing_buffer.size() - offset);

            ENetPacket* packet = enet_packet_create(
                    outgoing_buffer.data() + offset,
                    chunk_size,
                    ENET_PACKET_FLAG_RELIABLE
                    );

            if (enet_peer_send(peer, 0, packet) < 0) {
                std::cerr << "Failed to send packet" << std::endl;
                enet_packet_destroy(packet);
            }
        }

        outgoing_buffer.clear();
    }
#endif

public:
    ENetDTLSClient() : client(nullptr), peer(nullptr), ssl(nullptr) {
        if (enet_initialize() != 0) {
            std::cerr << "Failed to initialize ENet" << std::endl;
            exit(1);
        }
        init_openssl();
    }

    ~ENetDTLSClient() {
        disconnect();
        if (ssl) SSL_free(ssl);
        if (client) enet_host_destroy(client);
        SSL_CTX_free(ssl_ctx);
        EVP_cleanup();
        enet_deinitialize();
    }

#if 0
    bool connect(const char* host, enet_uint16 port) {
        client = enet_host_create(nullptr, 1, 2, 0, 0);
        if (!client) {
            std::cerr << "Failed to create client" << std::endl;
            return false;
        }

        ENetAddress address;
        enet_address_set_host(&address, host);
        address.port = port;

        peer = enet_host_connect(client, &address, 2, 0);
        if (!peer) {
            std::cerr << "Failed to initiate connection" << std::endl;
            return false;
        }

        // Wait for connection establishment
        ENetEvent event;
        if (enet_host_service(client, &event, 5000) > 0 &&
            event.type == ENET_EVENT_TYPE_CONNECT) {
            return true;
            
            // Setup SSL
            ssl = SSL_new(ssl_ctx);
            BIO* bio = BIO_new(create_bio_method());
            BIO_set_data(bio, &outgoing_buffer);

            // Set MTU
            //SSL_set_mtu(ssl, 1500);  // Adjust based on your network

            // Enable cookie exchange (anti-spoofing)
            SSL_set_options(ssl, SSL_OP_COOKIE_EXCHANGE);

            // Set DTLS timeouts
            //DTLSv1_set_initial_timeout_duration(ssl, 1000); // 1 second
#if 0
            struct timeval timeout;
            timeout.tv_sec = 5;
            timeout.tv_usec = 0;
            BIO_ctrl(bio, BIO_CTRL_DGRAM_SET_RECV_TIMEOUT, 0, &timeout);
#endif
            
            SSL_set_bio(ssl, bio, bio);
            SSL_set_connect_state(ssl);

#if 0
            // Perform DTLS handshake
            int ret = SSL_connect(ssl);
            if (ret <= 0) {
                std::cerr << "SSL_connect failed" << std::endl;
                handle_dtls_error(ret);
                return false;
            }
#else
            // Perform handshake with retry loop
            int ret;
            do {
                ret = SSL_connect(ssl);
                if (ret <= 0) {
                    printf("SSL_connect failed\n");
                    int err = SSL_get_error(ssl, ret);
                    /*
                    if (err == SSL_ERROR_WANT_READ || err == SSL_ERROR_WANT_WRITE) {
                        // Process any pending ENet events
                        update();
                        continue;
                    }
                    // Handle other errors
                    handle_dtls_error(ret);
                    return false;
                    */
                    switch (err) {
                        case SSL_ERROR_WANT_READ:
                            {
                                // Need to receive more data
                                ENetEvent event;
                                while (enet_host_service(client, &event, 100) > 0) {
                                    if (event.type == ENET_EVENT_TYPE_RECEIVE) {
                                        // Add to incoming buffer
                                        incoming_buffer.insert(incoming_buffer.end(),
                                                event.packet->data,
                                                event.packet->data + event.packet->dataLength);
                                        enet_packet_destroy(event.packet);
                                    }
                                }
                                flush_outgoing(); // Send any pending handshake data
                                continue;
                            }
                        case SSL_ERROR_WANT_WRITE:
                            flush_outgoing();
                            continue;
                        default:
                            std::cerr << "SSL handshake error: " << err << std::endl;
                            ERR_print_errors_fp(stderr);
                            return false;
                    }
                }
            } while (ret <= 0);
#endif

            // Verify server certificate
            X509* cert = SSL_get_peer_certificate(ssl);
            if (!cert) {
                std::cerr << "No server certificate received" << std::endl;
                return false;
            }
            X509_free(cert);

            if (SSL_get_verify_result(ssl) != X509_V_OK) {
                std::cerr << "Server certificate verification failed" << std::endl;
                return false;
            }

            std::cout << "Secure connection established using " 
                      << SSL_get_cipher(ssl) << std::endl;
            return true;
        }

        //enet_peer_reset(peer);
        return false;
    }
#endif

    bool connect(const char* host, enet_uint16 port) {
        client = enet_host_create(nullptr, 1, 2, 0, 0);
        if (!client) {
            std::cerr << "Failed to create client" << std::endl;
            return false;
        }

        ENetAddress address;
        enet_address_set_host(&address, host);
        address.port = port;

        peer = enet_host_connect(client, &address, 2, 0);
        if (!peer) {
            std::cerr << "Failed to initiate connection" << std::endl;
            return false;
        }
        enet_peer_ping_interval(peer, 2000); // unit: milliseconds

#if 0
        // Wait for ENet connection
        ENetEvent event;
        if (enet_host_service(client, &event, 5000) <= 0 ||
                event.type != ENET_EVENT_TYPE_CONNECT) {
            std::cerr << "Failed to establish ENet connection" << std::endl;
            return false;
        }
#endif

        // Setup SSL
        ssl = SSL_new(ssl_ctx);
        if (!ssl) {
            std::cerr << "Failed to create SSL object" << std::endl;
            return false;
        }

        // Create and configure BIO
        BIO* bio = BIO_new(create_bio_method());
        if (!bio) {
            std::cerr << "Failed to create BIO" << std::endl;
            SSL_free(ssl);
            ssl = nullptr;
            return false;
        }

        BIO_set_data(bio, this); // Store this pointer for callbacks
        SSL_set_bio(ssl, bio, bio);
        SSL_set_connect_state(ssl);

        // Configure DTLS parameters
        SSL_set_mtu(ssl, 1200); // Set MTU for DTLS
        SSL_set_options(ssl, SSL_OP_NO_QUERY_MTU);
        //SSL_set_options(ssl, SSL_OP_COOKIE_EXCHANGE);

        // Enable debugging
        SSL_set_info_callback(ssl, [](const SSL *ssl, int where, int ret) {
                std::cout << "SSL state: " << SSL_state_string_long(ssl) << std::endl;
                });

#if 0
        // Perform handshake
        if (!perform_handshake()) {
            std::cerr << "DTLS handshake failed" << std::endl;
            return false;
        }
#endif

        return true;
    }

    void disconnect() {
        if (ssl) {
            SSL_shutdown(ssl);
            flush_outgoing();
        }
        if (peer) {
            enet_peer_disconnect(peer, 0);
            
            ENetEvent event;
            while (enet_host_service(client, &event, 3000) > 0) {
                switch (event.type) {
                    case ENET_EVENT_TYPE_RECEIVE:
                        enet_packet_destroy(event.packet);
                        break;
                    case ENET_EVENT_TYPE_DISCONNECT:
                        peer = nullptr;
                        return;
                }
            }
            
            enet_peer_reset(peer);
            peer = nullptr;
        }
    }

    bool perform_handshake() {
        std::cout << "Starting DTLS handshake..." << std::endl;

        int ret;
        do {
            std::cout << "SSL_connect..." << std::endl;
            ret = SSL_connect(ssl);
            if (ret <= 0) {
                int err = SSL_get_error(ssl, ret);
                switch (err) {
                    case SSL_ERROR_WANT_READ:
                      {
                          std::cout << "SSL_connect want read..." << std::endl;
                          // Need to receive more data
                          ENetEvent event;
                          while (enet_host_service(client, &event, 100) > 0) {
                              if (event.type == ENET_EVENT_TYPE_RECEIVE) {
                                  // Add to incoming buffer
                                  incoming_buffer.insert(incoming_buffer.end(),
                                          event.packet->data,
                                          event.packet->data + event.packet->dataLength);
                                  enet_packet_destroy(event.packet);
                              }
                          }
                          flush_outgoing(); // Send any pending handshake data
                          continue;
                      }
                    case SSL_ERROR_WANT_WRITE:
                      std::cout << "SSL_connect want write..." << std::endl;
                      flush_outgoing();
                      continue;
                    default:
                      std::cerr << "SSL handshake error: " << err << std::endl;
                      ERR_print_errors_fp(stderr);
                      return false;
                      //std::this_thread::sleep_for(std::chrono::milliseconds(10));
                      //continue;
                }
            }
        } while (ret <= 0);

        std::cout << "DTLS handshake completed successfully" << std::endl;
        return true;
    }

    void update() {
        if (!client || !peer) return;

        ENetEvent event;
        while (enet_host_service(client, &event, 0) > 0) {
            switch (event.type) {
                case ENET_EVENT_TYPE_CONNECT:
                std::cout << "ENet event connected" << std::endl;
                {
#if 0
                    // Setup SSL
                    ssl = SSL_new(ssl_ctx);
                    BIO* bio = BIO_new(create_bio_method());
                    BIO_set_data(bio, this);

                    SSL_set_bio(ssl, bio, bio);
                    SSL_set_connect_state(ssl);

                    ret = SSL_connect(ssl);
                    if (ret <= 0) {
                        printf("ENet connected -> SSL_connect failed, ret: %d\n", ret);
                    }
#endif
                    std::cout << "SSL_connect..." << std::endl;
                    int ret = SSL_connect(ssl);
                    printf("ENet event connect -> SSL_connect ret: %d\n", ret);
                    handle_dtls_error(ret);

                    break;
                }
                case ENET_EVENT_TYPE_RECEIVE: {
                    std::cout << "ENet event receive dataLength: " << event.packet->dataLength << std::endl;

                    // Add received data to incoming buffer
                    incoming_buffer.insert(incoming_buffer.end(),
                                        event.packet->data,
                                        event.packet->data + event.packet->dataLength);

                    if (! handshake_done_) {
#if 1
                        std::cout << "SSL_connect..." << std::endl;
                        int ret = SSL_connect(ssl);
                        if (ret <= 0) {
                            handle_dtls_error(ret);
                            printf("ENet event receive -> SSL_connect failed, ret: %d\n", ret);
                            int err = SSL_get_error(ssl, ret);
                            switch (err) {
                                case SSL_ERROR_WANT_READ:
                                case SSL_ERROR_WANT_WRITE:
                                    printf("ENet event receive -> want read/write\n");
                                    flush_outgoing();
                                    continue;
                                default:
                                    std::cerr << "SSL handshake error: " << err << std::endl;
                                    ERR_print_errors_fp(stderr);
                            }
                        } else {
                            handshake_done_ = true;
                            std::cout << "Handshake done" << std::endl;
                        }
#endif
                    } else {
                        // Process through DTLS
                        char decrypted[4096];
                        int read = SSL_read(ssl, decrypted, sizeof(decrypted));
                        if (read > 0) {
                            decrypted[read] = '\0';
                            std::cout << "Received: " << decrypted << std::endl;
                        } else {
                            handle_dtls_error(read);
                        }
                    }

                    enet_packet_destroy(event.packet);
                    break;
                }

                case ENET_EVENT_TYPE_DISCONNECT:
                    std::cout << "Disconnected from server" << std::endl;
                    peer = nullptr;
                    running = false;
                    break;
            }
        }

        flush_outgoing();
    }

    bool send_message(const std::string& message) {
        if (!ssl || !peer) return false;

        int written = SSL_write(ssl, message.c_str(), message.length());
        if (written <= 0) {
            handle_dtls_error(written);
            return false;
        }

        flush_outgoing();
        return true;
    }

    bool is_running() const {
        return running;
    }
};

int main() {
    ENetDTLSClient client;
    
    if (!client.connect("127.0.0.1", 5000)) {
        std::cerr << "Failed to connect to server" << std::endl;
        return 1;
    }

    // Start input thread
    std::thread input_thread([&client]() {
        std::string message;
        while (client.is_running()) {
            std::getline(std::cin, message);
            if (message == "quit") {
                client.disconnect();
                break;
            }
            client.send_message(message);
        }
    });

    // Main update loop
    while (client.is_running()) {
        client.update();
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    if (input_thread.joinable()) {
        input_thread.join();
    }

    return 0;
}

// g++ enet_dtls_client.cpp -o enet_dtls_client -lenet -lssl -lcrypto
