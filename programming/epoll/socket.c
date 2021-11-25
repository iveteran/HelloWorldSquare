#include <stdio.h>
#include "socket.h"

int setnonblocking(int fd)
{
    if (fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_NONBLOCK) == -1)
    {
        return -1;
    }
    return 0;
}

int createSocket(char *host, unsigned short port)
{
    struct sockaddr_in addr;
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if(fd == -1)
    {
        return -1;
    }

    if(setnonblocking(fd) == -1)
    {
        close(fd);
        return -1;
    }

    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(host);
    if(bind(fd, (struct sockaddr *)&addr, sizeof(struct sockaddr)) == -1)
    {
        close(fd);
        return -1;
    }

    if (listen(fd, 512) == -1) {
        close(fd);
        return -1;
    }

    return fd;
}

EventLoop *initEvent()
{
    EventLoop *ev = malloc(sizeof(EventLoop));
    int i;

    ev->epfd = epoll_create(1024);
    if(ev->epfd == -1){
        free(ev);
        return NULL;
    }

    for(i = 0; i < EV_SIZE; i++)
    {
        ev->events[i].events = 0;
    }

    return ev;
}

int createEvent(EventLoop *ev, int fd, short mask, procEvent *proc, void *argv)
{
    struct epoll_event ee;
    int op = ev->events[fd].mask == 0 ?
        EPOLL_CTL_ADD : EPOLL_CTL_MOD;

    ee.events = 0;
    ee.data.fd = fd;
    mask |= ev->events[fd].mask; /* Merge old events */
    ev->fe[fd].argv = argv;

    if(mask & EV_READ)
    {
        ee.events|= EPOLLIN;
        ev->fe[fd].readProc = proc;
    }

    if(mask & EV_WRITE)
    {
        ee.events|= EPOLLOUT;
        ev->fe[fd].writeProc = proc;
    }

    if (epoll_ctl(ev->epfd, op, fd, &ee) == -1) return -1;

    return 0;
}

int deleteEvent(EventLoop *ev, int fd, short delmask)
{

    struct epoll_event ee;
    int mask = ev->events[fd].mask & (~delmask);
    ee.events = 0;
    ee.data.fd = fd;

    if(mask & EV_READ) ee.events|= EPOLLIN;
    if(mask & EV_WRITE) ee.events|= EPOLLOUT;

    if(mask != 0){
        epoll_ctl(ev->epfd, EPOLL_CTL_MOD, fd, &ee);
    }else{
        epoll_ctl(ev->epfd, EPOLL_CTL_DEL, fd, &ee);
    }

    return 0;
}

int dispatchEvent(EventLoop *ev)
{
    int nfds, i;
    ev->running = 1;
    while(ev->running)
    {
        nfds = epoll_wait(ev->epfd, ev->events, EV_SIZE, -1);
        for (i = 0; i < nfds; i++)
        {
            struct epoll_event *e = ev->events + i;
            int mask = 0;

            if(e->events & EPOLLIN) mask|= EV_READ;
            if(e->events & EPOLLOUT) mask|= EV_WRITE;
            ev->fired[i].fd = e->data.fd;
            ev->fired[i].mask = mask;
        }

        for(i = 0; i < nfds; i++)
        {
            int mask = ev->fired[i].mask;
            int fd = ev->fired[i].fd;
            FileEvent *fe = &ev->fe[fd];

            if(mask & EV_READ){
                fe->readProc(fd, fe->argv);
            }

            if(mask & EV_WRITE){
                fe->writeProc(fd, fe->argv);
            }
        }
    }
    return 0;
}

void stopEvent(EventLoop *ev)
{
    ev->running = 0;
}
