#include <enet/enet.h>
#include <stdio.h>
#include <string.h>

#define SERVER_PORT 1234
#define BUFFER_SIZE 1024

int main(int argc, char *argv[]) {
    ENetHost* client;
    ENetAddress address;
    ENetPeer* peer;
    ENetEvent event;
    char message[BUFFER_SIZE];
    
    // Initialize ENet
    if (enet_initialize() != 0) {
        fprintf(stderr, "Error initializing ENet.\n");
        return 1;
    }
    
    // Create a client host
    client = enet_host_create(NULL,    // create a client host
                            1,         // only allow 1 outgoing connection
                            2,         // allow up 2 channels
                            0,         // assume any amount of incoming bandwidth
                            0);        // assume any amount of outgoing bandwidth
    
    if (client == NULL) {
        fprintf(stderr, "Error creating ENet client host\n");
        return 1;
    }
    
    // Set the address for connection
    enet_address_set_host(&address, "127.0.0.1");  // localhost
    address.port = SERVER_PORT;
    
    // Connect to the server
    peer = enet_host_connect(client, &address, 2, 0);
    if (peer == NULL) {
        fprintf(stderr, "No available peers for initiating an ENet connection\n");
        return 1;
    }
    
    // Wait for the connection to succeed
    if (enet_host_service(client, &event, 5000) > 0 && 
        event.type == ENET_EVENT_TYPE_CONNECT) {
        printf("Connection to server succeeded.\n");
    } else {
        enet_peer_reset(peer);
        fprintf(stderr, "Connection to server failed.\n");
        return 1;
    }
    
    // Main loop
    while (1) {
        printf("Enter message (or 'quit' to exit): ");
        if (fgets(message, BUFFER_SIZE, stdin) == NULL) {
            break;
        }
        
        // Remove trailing newline
        message[strcspn(message, "\n")] = 0;
        
        // Check for quit command
        if (strcmp(message, "quit") == 0) {
            break;
        }
        
        // Create and send the packet
        ENetPacket* packet = enet_packet_create(message, 
                                              strlen(message) + 1, 
                                              ENET_PACKET_FLAG_RELIABLE);
        enet_peer_send(peer, 0, packet);
        
        // Process events
        while (enet_host_service(client, &event, 100) > 0) {
            switch (event.type) {
                case ENET_EVENT_TYPE_RECEIVE:
                    printf("Received response: %s\n", event.packet->data);
                    enet_packet_destroy(event.packet);
                    break;
                
                case ENET_EVENT_TYPE_DISCONNECT:
                    printf("Server disconnected.\n");
                    return 1;
                    
                default:
                    break;
            }
        }
    }
    
    // Disconnect cleanly
    enet_peer_disconnect(peer, 0);
    
    // Wait for the disconnect event
    while (enet_host_service(client, &event, 3000) > 0) {
        switch (event.type) {
            case ENET_EVENT_TYPE_RECEIVE:
                enet_packet_destroy(event.packet);
                break;
            case ENET_EVENT_TYPE_DISCONNECT:
                printf("Disconnection succeeded.\n");
                goto CLEANUP;
            default:
                break;
        }
    }
    
    // Force disconnection if timeout
    enet_peer_reset(peer);
    
CLEANUP:
    enet_host_destroy(client);
    enet_deinitialize();
    
    return 0;
}

// g++ -g -o enet_echo_client enet_echo_client.cpp -lenet
