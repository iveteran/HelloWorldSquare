#include <enet/enet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <iostream>
#include <map>
#include <vector>

class ENetDTLSServer {
private:
    ENetHost* server;
    ENetPeer* peer;
    SSL_CTX* ssl_ctx;
    std::map<ENetPeer*, SSL*> peer_ssl_map;
    bool handshake_done = false;
    
    // Buffer for DTLS operations
    struct PeerBuffer {
        std::vector<uint8_t> incoming;
        std::vector<uint8_t> outgoing;
    };
    std::map<ENetPeer*, PeerBuffer> peer_buffers;

    // Custom BIO methods
    static BIO_METHOD* create_bio_method() {
        BIO_METHOD* methods = BIO_meth_new(BIO_TYPE_DGRAM, "ENet DTLS");
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
        PeerBuffer* buffer = static_cast<PeerBuffer*>(BIO_get_data(bio));
        if (!buffer) return -1;

        buffer->outgoing.insert(buffer->outgoing.end(), data, data + len);
        BIO_clear_retry_flags(bio);
        return len;
    }

    static int bio_read(BIO* bio, char* data, int len) {
        PeerBuffer* buffer = static_cast<PeerBuffer*>(BIO_get_data(bio));
        if (!buffer || buffer->incoming.empty()) {
            BIO_set_retry_read(bio);
            return -1;
        }

        int copy_len = std::min(len, static_cast<int>(buffer->incoming.size()));
        std::copy(buffer->incoming.begin(), 
                 buffer->incoming.begin() + copy_len, 
                 data);
        buffer->incoming.erase(buffer->incoming.begin(), 
                             buffer->incoming.begin() + copy_len);
        return copy_len;
    }
#endif

    // Modified BIO callbacks
    static int bio_write(BIO* bio, const char* data, int len) {
        printf("--> bio_write, len: %d\n", len);
        auto* client = static_cast<ENetDTLSServer*>(BIO_get_data(bio));
        if (!client || !client->peer) return -1;

        // Create and send ENet packet
        ENetPacket* packet = enet_packet_create(data, len, ENET_PACKET_FLAG_RELIABLE);
        if (enet_peer_send(client->peer, 0, packet) < 0) {
            enet_packet_destroy(packet);
            return -1;
        }
        enet_host_flush(client->server);
        return len;
    }

    static int bio_read(BIO* bio, char* data, int len) {
        printf("--> bio_read, buf len: %d\n", len);
        auto* client = static_cast<ENetDTLSServer*>(BIO_get_data(bio));
        PeerBuffer& buffer = client->peer_buffers[client->peer];
        printf("--> bio_read, incoming buf size: %ld\n", buffer.incoming.size());
        if (!client || buffer.incoming.empty()) {
            BIO_set_retry_read(bio);
            return -1;
        }

        int copy_len = std::min(len, static_cast<int>(buffer.incoming.size()));
        printf("--> bio_read, read len: %d\n", copy_len);
        std::copy(buffer.incoming.begin(),
                 buffer.incoming.begin() + copy_len,
                 data);
        buffer.incoming.erase(
            buffer.incoming.begin(),
            buffer.incoming.begin() + copy_len
        );
        return copy_len;
    }

    static long bio_ctrl(BIO* bio, int cmd, long num, void* ptr) {
        std::cout << "bio_ctrl called with cmd: " << cmd << std::endl;

        auto* client = static_cast<ENetDTLSServer*>(BIO_get_data(bio));
        if (!client) {
            std::cerr << "bio_ctrl: No client data" << std::endl;
            return 0;
        }

        switch (cmd) {
            case BIO_CTRL_DGRAM_SET_NEXT_TIMEOUT:
            case BIO_CTRL_DGRAM_SET_RECV_TIMEOUT:
                return 1;
            case BIO_CTRL_FLUSH:
                enet_host_flush(client->server);
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
        
        ssl_ctx = SSL_CTX_new(DTLS_server_method());
        if (!ssl_ctx) {
            std::cerr << "Failed to create SSL context" << std::endl;
            exit(1);
        }

        // Set DTLS 1.2
        SSL_CTX_set_min_proto_version(ssl_ctx, DTLS1_2_VERSION);
        SSL_CTX_set_max_proto_version(ssl_ctx, DTLS1_2_VERSION);

        // Load certificates
        if (SSL_CTX_use_certificate_file(ssl_ctx, "../certs/server-cert.pem", SSL_FILETYPE_PEM) <= 0) {
            std::cerr << "Failed to load certificate" << std::endl;
            exit(1);
        }
        if (SSL_CTX_use_PrivateKey_file(ssl_ctx, "../certs/server-key.pem", SSL_FILETYPE_PEM) <= 0) {
            std::cerr << "Failed to load private key" << std::endl;
            exit(1);
        }
    }

    void handle_dtls_error(SSL* ssl, int result) {
        int err = SSL_get_error(ssl, result);
        switch (err) {
            case SSL_ERROR_WANT_READ:
            case SSL_ERROR_WANT_WRITE:
                // Non-blocking operation in progress
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
    ENetDTLSServer() : server(nullptr) {
        if (enet_initialize() != 0) {
            std::cerr << "Failed to initialize ENet" << std::endl;
            exit(1);
        }
        init_openssl();
    }

    ~ENetDTLSServer() {
        for (auto& pair : peer_ssl_map) {
            SSL_free(pair.second);
        }
        if (server) {
            enet_host_destroy(server);
        }
        SSL_CTX_free(ssl_ctx);
        EVP_cleanup();
        enet_deinitialize();
    }

    bool start(const char* host, enet_uint16 port, size_t max_clients) {
        ENetAddress address;
        address.host = ENET_HOST_ANY;
        address.port = port;

        server = enet_host_create(&address, max_clients, 2, 0, 0);
        if (server == nullptr) {
            std::cerr << "Failed to create ENet server" << std::endl;
            return false;
        }
        return true;
    }

    void update() {
        ENetEvent event;
        while (enet_host_service(server, &event, 0) > 0) {
            switch (event.type) {
                case ENET_EVENT_TYPE_CONNECT: {
                    std::cout << "New client connected" << std::endl;
                    enet_peer_ping_interval(event.peer, 2000);  // unit: milliseconds
                    
                    // Create new SSL session for the client
                    SSL* ssl = SSL_new(ssl_ctx);
                    BIO* bio = BIO_new(create_bio_method());
                    BIO_set_data(bio, this);
                    peer = event.peer;
                    
                    SSL_set_bio(ssl, bio, bio);
                    SSL_set_accept_state(ssl);
                    SSL_set_mtu(ssl, 1200); // Set MTU for DTLS
                    //SSL_set_options(ssl, SSL_OP_COOKIE_EXCHANGE);

                    // Enable debugging
                    SSL_set_info_callback(ssl, [](const SSL *ssl, int where, int ret) {
                            std::cout << "SSL state: " << SSL_state_string_long(ssl) << std::endl;
                            });
                    
                    peer_ssl_map[event.peer] = ssl;
                    
                    // Start DTLS handshake
                    int ret = SSL_accept(ssl);
                    if (ret <= 0) {
                        handle_dtls_error(ssl, ret);
                    }
                    
                    // Send any pending data
                    flush_peer_outgoing(event.peer);
                    break;
                }

                case ENET_EVENT_TYPE_RECEIVE: {
                    SSL* ssl = peer_ssl_map[event.peer];
                    if (!ssl) {
                        std::cerr << "No SSL context for peer" << std::endl;
                        break;
                    }
                    std::cout << "ENet receive dataLength: " << event.packet->dataLength << std::endl;

                    // Add received data to peer's incoming buffer
                    PeerBuffer& buffer = peer_buffers[event.peer];
                    buffer.incoming.insert(buffer.incoming.end(),
                                        event.packet->data,
                                        event.packet->data + event.packet->dataLength);

                    if (! handshake_done) {
                        int ret = SSL_accept(ssl);
                        if (ret <= 0) {
                            handle_dtls_error(ssl, ret);
                        } else {
                            std::cout << "Handshake done" << std::endl;
                            handshake_done = true;
                        }
                    } else {
                        // Process data through DTLS
                        char decrypted[4096];
                        int read = SSL_read(ssl, decrypted, sizeof(decrypted));
                        if (read > 0) {
                            decrypted[read] = '\0';
                            std::cout << "Received: " << decrypted << std::endl;

                            // Echo back
                            int written = SSL_write(ssl, decrypted, read);
                            if (written <= 0) {
                                handle_dtls_error(ssl, written);
                            }
                            
                            // Send any pending data
                            flush_peer_outgoing(event.peer);
                        } else {
                            handle_dtls_error(ssl, read);
                        }
                    }

                    enet_packet_destroy(event.packet);
                    break;
                }

                case ENET_EVENT_TYPE_DISCONNECT: {
                    std::cout << "Client disconnected" << std::endl;
                    
                    // Cleanup SSL and buffers for disconnected peer
                    auto ssl_it = peer_ssl_map.find(event.peer);
                    if (ssl_it != peer_ssl_map.end()) {
                        SSL_shutdown(ssl_it->second);
                        SSL_free(ssl_it->second);
                        peer_ssl_map.erase(ssl_it);
                    }
                    
                    peer_buffers.erase(event.peer);
                    event.peer->data = nullptr;
                    break;
                }
            }
        }
    }

private:
    void flush_peer_outgoing(ENetPeer* peer) {
        PeerBuffer& buffer = peer_buffers[peer];
        printf("flush_peer_outgoing, buffer size: %ld\n", buffer.outgoing.size());

        if (buffer.outgoing.empty()) return;

        // Create and send ENet packet with encrypted data
        ENetPacket* packet = enet_packet_create(
            buffer.outgoing.data(),
            buffer.outgoing.size(),
            ENET_PACKET_FLAG_RELIABLE
        );
        
        if (enet_peer_send(peer, 0, packet) < 0) {
            enet_packet_destroy(packet);
        }
        
        buffer.outgoing.clear();
    }
};

int main() {
    ENetDTLSServer server;
    
    if (!server.start("0.0.0.0", 5000, 32)) {
        return 1;
    }

    std::cout << "Server started on port 1234" << std::endl;

    while (true) {
        server.update();
        // Add any other server logic here
    }

    return 0;
}

// g++ enet_dtls_server.cpp -o enet_dtls_server -lenet -lssl -lcrypto
