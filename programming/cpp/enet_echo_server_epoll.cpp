#include <enet/enet.h>
#include <stdio.h>
#include <string.h>
#include <sys/epoll.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>

#define PORT 1234
#define MAX_CLIENTS 32
#define MAX_EVENTS 64

// Helper function to set socket non-blocking
static int set_nonblocking(int fd) {
    int flags = fcntl(fd, F_GETFL, 0);
    if (flags == -1) {
        return -1;
    }
    return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

int main(int argc, char *argv[]) {
    ENetAddress address;
    ENetHost* server;
    ENetEvent event;
    struct epoll_event ev, events[MAX_EVENTS];
    int epoll_fd, nfds;
    
    // Initialize ENet
    if (enet_initialize() != 0) {
        fprintf(stderr, "Error initializing ENet.\n");
        return 1;
    }
    
    // Set up the server address
    address.host = ENET_HOST_ANY;
    address.port = PORT;
    
    // Create a server host
    server = enet_host_create(&address, MAX_CLIENTS, 2, 0, 0);
    if (server == NULL) {
        fprintf(stderr, "Error creating ENet server host.\n");
        return 1;
    }
    
    // Create epoll instance
    epoll_fd = epoll_create1(0);
    if (epoll_fd == -1) {
        fprintf(stderr, "Error creating epoll instance: %s\n", strerror(errno));
        return 1;
    }
    
    // Get the ENet socket and make it non-blocking
    int enet_socket = server->socket;
    if (set_nonblocking(enet_socket) < 0) {
        fprintf(stderr, "Failed to set socket non-blocking: %s\n", strerror(errno));
        return 1;
    }
    
    // Add the ENet socket to epoll
    ev.events = EPOLLIN;
    ev.data.fd = enet_socket;
    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, enet_socket, &ev) == -1) {
        fprintf(stderr, "Error adding ENet socket to epoll: %s\n", strerror(errno));
        return 1;
    }
    
    printf("Server started on port %d\n", PORT);
    
    // Main event loop
    while (1) {
        nfds = epoll_wait(epoll_fd, events, MAX_EVENTS, -1);
        if (nfds == -1) {
            if (errno == EINTR) {
                continue;  // Interrupted system call, try again
            }
            fprintf(stderr, "epoll_wait error: %s\n", strerror(errno));
            break;
        }
        
        for (int n = 0; n < nfds; n++) {
            if (events[n].data.fd == enet_socket) {
                // Handle ENet events
                while (enet_host_service(server, &event, 0) > 0) {
                    switch (event.type) {
                        case ENET_EVENT_TYPE_CONNECT:
                            printf("Client connected from %x:%u\n",
                                   event.peer->address.host,
                                   event.peer->address.port);
                            // You can store additional client data
                            event.peer->data = NULL;
                            break;
                            
                        case ENET_EVENT_TYPE_RECEIVE:
                            printf("Received packet of length %zu on channel %u\n",
                                   event.packet->dataLength,
                                   event.channelID);
                            
                            // Echo the packet back
                            enet_peer_send(event.peer, 0, event.packet);
                            enet_host_flush(server);
                            
                            // Clean up the packet
                            enet_packet_destroy(event.packet);
                            break;
                            
                        case ENET_EVENT_TYPE_DISCONNECT:
                            printf("Client %s disconnected.\n", 
                                   event.peer->data ? (char*)event.peer->data : "unknown");
                            event.peer->data = NULL;
                            break;
                            
                        case ENET_EVENT_TYPE_NONE:
                            break;
                    }
                }
            }
        }
    }
    
    // Cleanup
    close(epoll_fd);
    enet_host_destroy(server);
    enet_deinitialize();
    
    return 0;
}

// g++ -o enet_echo_server_epoll enet_echo_server_epoll.cpp -lenet
