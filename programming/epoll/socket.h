#ifndef SOCKET_H
#define    SOCKET_H

#include <sys/socket.h>
#include <stdlib.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <fcntl.h>

#define EV_READ 1
#define EV_WRITE 2
#define EV_SIZE (1024*10)

typedef void procEvent(int fd, void *argv);

typedef struct fileEvent
{
    procEvent *readProc;
    procEvent *writeProc;
    void *argv;
} FileEvent;

typedef struct FiredEvent {
    int fd;
    int mask;
} FiredEvent;

typedef struct _event
{
    FileEvent fe[EV_SIZE];
    struct epoll_event events[EV_SIZE];
    FiredEvent fired[EV_SIZE];
    int epfd;
    unsigned char running;
} EventLoop;

int setnonblocking(int fd);
int createSocket(char *host, unsigned short port);
int createEvent(EventLoop *ev, int fd, short mask, procEvent *proc, void *argv);
int deleteEvent(EventLoop *ev, int fd, short mask);
int dispatchEvent(EventLoop *ev);
void stopEvent(EventLoop *ev);
EventLoop *initEvent();

#endif    /* SOCKET_H */
