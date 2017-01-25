// kcoroutine.cpp : 定义控制台应用程序的入口点。
// http://www.cnblogs.com/sniperHW/archive/2012/04/02/2429644.html
//
#include "uthread.h"
#include "thread.h"
int port;
int test(void *arg)
{
    char *name = (char*)arg;
    unsigned long c = 0;
    while(1)
    {
        if(c % 10000 == 0)
        {
            printf("%d/n",c);
            cSleep(1);
        }
        ++c;
    }
}
int echo(void *arg)
{
    int sock = *(int*)arg;
    while(1)
    {
        char buf[1024];
        int ret = cRecv(sock,buf,1024);
        if(ret > 0)
        {
            printf("%s/n",buf);
            ret = cSend(sock,buf,ret);
        }
    }
}
int listener(void *arg)
{
    struct sockaddr_in servaddr;
    int listenfd;
    if(0 > (listenfd = Tcp_Listen("127.0.0.1",port,servaddr,5)))
    {
        printf("listen error/n");
        return 0;
    }
    while(1)
    {
        if(cListen(listenfd) > 0)
        {
            printf("a user comming/n");
            struct sockaddr_in cliaddr;
            socklen_t len;
            int sock = Accept(listenfd,(struct sockaddr*)NULL,NULL);
            if(sock >= 0)
            {
                cSpawn(echo,&sock,4096);
            }
                
        }
    }    
}
int main(int argc, char **argv)
{
    port = atoi(argv[1]);
    if(!initcoroutine(20))
        return 0;
    cSpawn(listener,0,4096);
    char name[10] = "test";
    cSpawn(test,name,4096);
    
    printf("create finish/n");
    
    //开始调度线程的运行
    BeginRun();
    return 0;
}
