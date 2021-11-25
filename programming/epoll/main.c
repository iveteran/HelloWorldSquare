#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include "socket.h"

EventLoop *base;

void onRead(int fd, void *argv)
{
    char buf[MAX_BUFFER_SIZE] = {0};
    int nread = 0;
    nread = read(fd, buf, MAX_BUFFER_SIZE);
}

void onAccept(int fd, void *argv)
{
    struct sockaddr_in addr;
    int len = sizeof(addr);
    int cfd;

    while(1)
    {
        cfd = accept(fd, (struct sockaddr *)&addr, &len);
        if(cfd == -1)
        {
            if (errno == EINTR) continue;
            printf("accept failed\n");
            return ;
        }
        break;
    }
    setnonblocking(cfd);
    printf("new client accept\n");
    createEvent(base, cfd, EV_READ, onRead, NULL);
}

void sigHandle(const int sig)
{
    printf("sighandled\n");
    kill(getpid(), sig);
    exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[])
{
    int fd;
    signal(SIGINT, sigHandle);
    signal(SIGKILL, sigHandle);
    signal(SIGQUIT, sigHandle);
    signal(SIGTERM, sigHandle);
    signal(SIGHUP, sigHandle);

    if((fd = createSocket("0.0.0.0", 7000)) == -1)
    {
        perror("create socket failed\n");
        exit(EXIT_FAILURE);
    }

    base= initEvent();

    if(base == NULL){
        perror("initialize event failed\n");
        exit(EXIT_FAILURE);
    }
    createEvent(base, fd, EV_READ, onAccept, NULL);
    dispatchEvent(base);
    close(fd);
    return 0;
}
