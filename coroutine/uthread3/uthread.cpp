#include "uthread.h"
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/epoll.h>
#include "thread.h"

/*
 * http://www.cnblogs.com/sniperHW/archive/2012/04/02/2429644.html
 */

ucontext_t Scheduler::ucontext;

char Scheduler::stack[4096];

uthread_id Scheduler::uid_current;

uthread_id Scheduler::uid_self;

u_thread *Scheduler::threads[MAX_UTHREAD];

int Scheduler::total_count = 0;

int Scheduler::epollfd = 0;

volatile bool Scheduler::block_signal = true; 

std::list<u_thread*> Scheduler::activeList;

std::list<std::pair<u_thread*,time_t> > Scheduler::sleepList;

struct sock_struct
{
    int sockfd;
    u_thread *uThread;
};

void int_signal_handler(int sig)
{
    Scheduler::int_sig();
}

void u_thread::star_routine(int uthread,int func,int arg)
{
    u_thread *self_uthread = (u_thread *)uthread;
    assert(self_uthread);
    
    self_uthread->SetStatus(ACTIVED);
    ucontext_t *self_context = self_uthread->GetContext();
    swapcontext(self_context,self_uthread->GetParentContext());
    Scheduler::block_signal = false;
    
    uthread_func _func = (uthread_func)func;
    void *_arg = (void*)arg;
    int ret = _func(_arg);
    self_uthread->SetStatus(DIE);
}
void Scheduler::scheduler_init()
{
    for(int i = 0; i < MAX_UTHREAD; ++i)
        threads[i] = 0;
    getcontext(&ucontext);
    ucontext.uc_stack.ss_sp = stack;
    ucontext.uc_stack.ss_size = sizeof(stack);
    ucontext.uc_link = NULL;
    
    //scheduler占用下标0
    makecontext(&ucontext,schedule, 0);    
    
    uid_self.index = 0;
    uid_self.p_uthread = 0;
    uid_self.p_context = &ucontext;
    uid_current = uid_self;

}
int Scheduler::listen(int sock)
{
    u_thread *self_thread = uid_current.p_uthread;

    epoll_event ev;
    sock_struct *ss = new sock_struct;
    ss->uThread = self_thread;
    ss->sockfd = sock;
    ev.data.ptr = (void*)ss;
    ev.events = EPOLLIN;
    int ret;
    TEMP_FAILURE_RETRY(ret = epoll_ctl(epollfd,EPOLL_CTL_ADD,sock,&ev));
    if(ret != 0)
    {
        return -1;
    }

    self_thread->SetStatus(BLOCKED);
    Scheduler::block_signal = true;
    swapcontext(uid_current.p_context,&Scheduler::ucontext);
    Scheduler::block_signal = false;
    return 1;
}

int Scheduler::recv(int sock,char *buf,int len)
{
    if(!buf || !(len > 0))
        return -1;
    u_thread *self_thread = uid_current.p_uthread; 
    sock_struct *ss = new sock_struct;
    ss->uThread = self_thread;
    ss->sockfd = sock;
    epoll_event ev;
    ev.data.ptr = (void*)ss;
    ev.events = EPOLLIN;
    int ret;
    TEMP_FAILURE_RETRY(ret = epoll_ctl(epollfd,EPOLL_CTL_ADD,sock,&ev));
    if(ret != 0)
        return -1;

    self_thread->SetStatus(BLOCKED);
    Scheduler::block_signal = true;
    swapcontext(uid_current.p_context,&Scheduler::ucontext);
    printf("recv return/n");
    Scheduler::block_signal = false;
    ret = read(sock,buf,len);
    return ret;
}
int Scheduler::send(int sock,char *buf,int len)
{
    if(!buf || !(len > 0))
        return -1;

    u_thread *self_thread = uid_current.p_uthread; 

    sock_struct *ss = new sock_struct;
    ss->uThread = self_thread;
    ss->sockfd = sock;
    epoll_event ev;
    ev.data.ptr = (void*)ss;
    ev.events = EPOLLOUT;
    int ret;
    TEMP_FAILURE_RETRY(ret = epoll_ctl(epollfd,EPOLL_CTL_ADD,sock,&ev));
    if(ret != 0)
        return -1;
    self_thread->SetStatus(BLOCKED);
    Scheduler::block_signal = true;
    swapcontext(uid_current.p_context,&Scheduler::ucontext);
    Scheduler::block_signal = false;
    ret = write(sock,buf,len);
    return ret;    
}
void Scheduler::check_Network()
{    
    epoll_event events[maxsize];
    sock_struct *ss;
    int nfds = TEMP_FAILURE_RETRY(epoll_wait(epollfd,events,maxsize,0));
    for( int i = 0 ; i < nfds ; ++i)
    {
        //套接口可读
        if(events[i].events & EPOLLIN)
        {     
            ss = (sock_struct*)events[i].data.ptr;
            printf("a sock can read/n");
            ss->uThread->SetStatus(ACTIVED);
            epoll_event ev;
            ev.data.fd = ss->sockfd;
            if(0 != TEMP_FAILURE_RETRY(epoll_ctl(epollfd,EPOLL_CTL_DEL,ev.data.fd,&ev)))
            {
                printf("error here/n");
                exit(0);
            }
            delete ss;
            continue;
        }
        //套接口可写
        if(events[i].events & EPOLLOUT)
        {
            ss = (sock_struct*)events[i].data.ptr;
            printf("a sock can write/n");
            ss->uThread->SetStatus(ACTIVED);
            epoll_event ev;
            ev.data.fd = ss->sockfd;
            TEMP_FAILURE_RETRY(epoll_ctl(epollfd,EPOLL_CTL_DEL,ev.data.fd,&ev));
            delete ss;
            continue;
        }
    }
}
void Scheduler::schedule()
{
    epollfd = TEMP_FAILURE_RETRY(epoll_create(maxsize)); 
        
    if(epollfd<= 0)
    {
        printf("epoll init error/n");
        return;
    }
            
    while(total_count > 0)
    {
    
        //首先执行active列表中的uthread
        std::list<u_thread*>::iterator it = activeList.begin(); 
        std::list<u_thread*>::iterator end = activeList.end();
        for( ; it != end; ++it)
        {
            if(*it && (*it)->GetStatus() == ACTIVED)
            {
                uid_current = (*it)->GetUid();
                swapcontext(&ucontext,uid_current.p_context);
                uid_current = uid_self;

                int index = (*it)->GetUid().index;
                if((*it)->GetStatus() == DIE)
                {
                    printf("%d die/n",index);
                    delete threads[index];
                    threads[index] = 0;
                    --total_count;
                    activeList.erase(it);
                    break;
                }
                else if((*it)->GetStatus() == SLEEP)
                {
                    printf("%d sleep/n",index);
                    activeList.erase(it);
                    break;
                }
            }
        }
        //检查网络，看看是否有套接口可以操作
        check_Network();
        //看看Sleep列表中是否有uthread该醒来了
        std::list<std::pair<u_thread*,time_t> >::iterator its = sleepList.begin();
        std::list<std::pair<u_thread*,time_t> >::iterator ends = sleepList.end();
        time_t now = time(NULL);
        for( ; its != ends; ++its)
        {
            //可以醒来了
            if(now >= its->second)
            {    
                u_thread *uthread = its->first;
                uthread->SetStatus(ACTIVED);
                activeList.push_back(uthread);
                sleepList.erase(its);
                break;
            }
        }
    }
    printf("scheduler end/n");
}

bool Scheduler::spawn(uthread_func func,void *arg,unsigned int stacksize)
{
    printf("uthread_create/n");
    if(total_count >= MAX_UTHREAD)
        return false;
    int i = 1;
    for( ; i < MAX_UTHREAD; ++i)
    {
        if(threads[i] == 0)
        {
            threads[i] = new u_thread(stacksize,i,uid_current);
            ++total_count;
            ucontext_t *cur_context = threads[i]->GetContext();
            activeList.push_back(threads[i]);
            
            cur_context->uc_link = &ucontext;
            makecontext(cur_context,(void (*)())u_thread::star_routine, 3,(int)&(*threads[i]),(int)func,(int)arg);
            swapcontext(uid_current.p_context, cur_context);
            printf("return from parent/n");
            return true;
        }
    }

    return false;
}
void Scheduler::sleep(int t)
{
    u_thread *self_thread = uid_current.p_uthread; 

    time_t now = time(NULL);
    now += t;
    //插入到sleep列表中
    sleepList.push_back(std::make_pair(self_thread,now));
    
    //保存当前上下文切换回scheduler
    self_thread->SetStatus(SLEEP);
    
    ucontext_t *cur_context = self_thread->GetContext();
    Scheduler::block_signal = true;
    swapcontext(cur_context,&Scheduler::ucontext);
    Scheduler::block_signal = false;
}
void Scheduler::int_sig()
{
    //printf("Scheduler::int_sig()%x/n",uid_current.p_context);
    Scheduler::block_signal = true;
    swapcontext(uid_current.p_context,&Scheduler::ucontext);
    Scheduler::block_signal = false;
}

class HeartBeat : public runnable
{
public:
    HeartBeat(unsigned int interval)
    {
        _beat = new beat(interval);
        _beat->setThread(pthread_self());
    }

    ~HeartBeat()
    {
        delete _beat;
    }

    bool run()
    {
        _beat->loop();
        return true;
    }

private:
    beat *_beat;
};

bool initcoroutine(unsigned int interval)
{
    //初始化信号
    struct sigaction sigusr1;
    sigusr1.sa_flags = 0;
    sigusr1.sa_handler = int_signal_handler;
    sigemptyset(&sigusr1.sa_mask);
    int status = sigaction(SIGUSR1,&sigusr1,NULL);
    if(status == -1)
    {
        printf("error sigaction/n");
        return false;
    }
 
    //首先初始化调度器
    Scheduler::scheduler_init();


    //启动心跳
    static HeartBeat hb(interval);
    static Thread c(&hb);
    c.start();
    return true;
}

void BeginRun()
{
    Scheduler::schedule();
}

bool cSpawn(uthread_func func,void *arg,unsigned int stacksize)
{
    return Scheduler::spawn(func,arg,stacksize);    
}

int cRecv(int sock,char *buf,int len)
{
    return Scheduler::recv(sock,buf,len);    
}

int cSend(int sock,char *buf,int len)
{
    return Scheduler::send(sock,buf,len);    
}

int cListen(int sock)
{
    return Scheduler::listen(sock);
}

void cSleep(int t)
{
    return Scheduler::sleep(t);
}
