/*
* brief: 用ucontext实现的用户级线程框架
* author: kenny huang
* date: 2009/10/13
* email: huangweilook@21cn.com
* http://www.cnblogs.com/sniperHW/archive/2012/04/02/2429644.html
*/
#ifndef _UTHREAD_H
#define _UTHREAD_H
#include <ucontext.h>
#include <stdio.h>
#include <string.h>
#include <list>
#include <pthread.h>
#include <signal.h>
#include "socketwrapper.h"

#define MAX_UTHREAD 128

void int_signal_handler(int sig);
//用户态线程的当前状态
enum thread_status
{
    ACTIVED = 0,//可运行的
    BLOCKED,//被阻塞
    SLEEP,//主动休眠
    DIE,//死死亡
};

typedef int (*uthread_func)(void*);

class Scheduler;
class u_thread;

typedef struct
{
    int index;//在Scheduler::threads中的下标
    u_thread *p_uthread;
    ucontext_t *p_context; 
}uthread_id;

/*
* 用户态线程
*/
class u_thread
{
    friend class Scheduler;
private:
    u_thread(unsigned int ssize,int index,uthread_id parent)
        :ssize(ssize),_status(BLOCKED),parent_context(parent.p_context)
        {
            stack = new char[ssize];
            ucontext.uc_stack.ss_sp = stack;
            ucontext.uc_stack.ss_size = ssize;
            getcontext(&ucontext);
            uid.index = index;
            uid.p_uthread = this;
            uid.p_context = &ucontext;

        }
    ~u_thread()
    {
        delete []stack;
    }
    static void star_routine(int uthread,int func,int arg);
    
public:
    ucontext_t* GetParentContext()
    {
        return parent_context;
    }
    ucontext_t *GetContext()
    {
        return &ucontext;
    }
    void SetStatus(thread_status _status)
    {
        this->_status = _status;
    }
    thread_status GetStatus()
    {
        return _status;
    }
    uthread_id GetUid()
    {
        return uid;
    }

private:
    ucontext_t ucontext;
    ucontext_t *parent_context;//父亲的context
    char *stack;//coroutine使用的栈
    unsigned int ssize;//栈的大小
    thread_status _status;
    uthread_id uid;
};

void BeginRun();
bool cSpawn(uthread_func func,void *arg,unsigned int stacksize);
int  cRecv(int sock,char *buf,int len);
int  cSend(int sock,char *buf,int len);
int  cListen(int sock);
void cSleep(int t);

class beat;

/*
* 任务调度器
*/
class Scheduler
{
    friend class beat;
    friend class u_thread;
    friend void BeginRun();
    friend bool cSpawn(uthread_func func,void *arg,unsigned int stacksize);
    friend int  cRecv(int sock,char *buf,int len);
    friend int  cSend(int sock,char *buf,int len);
    friend int  cListen(int sock);
    friend void cSleep(int t);
public:
    static void scheduler_init();
    static void int_sig();

    

private:

    //休眠time时间
    static void sleep(int t);
    static void check_Network();
    static void schedule();
    static bool spawn(uthread_func func,void *arg,unsigned int stacksize);
    static int recv(int sock,char *buf,int len);
    static int send(int sock,char *buf,int len);
    static int listen(int sock);

private:
    static std::list<u_thread*> activeList;//可运行uthread列表
    
    static std::list<std::pair<u_thread*,time_t> > sleepList;//正在睡眠uthread列表
    static volatile bool block_signal; 
    static  char stack[4096];
    
    static     ucontext_t ucontext;//Scheduler的context
    
    static uthread_id uid_current;//当前正获得运行权的context

    static uthread_id uid_self;

    static  u_thread *threads[MAX_UTHREAD];
    static  int total_count;
    static  int epollfd;
    const static int maxsize = 10;
};
/*心跳发射器，发射器必须运行在一个独立的线程中，以固定的间隔
* 往所有运行着coroutine的线程发送中断信号
*/
class beat
{
public:
    beat(unsigned int interval):interval(interval)
    {}
    void setThread(pthread_t id)
    {
        thread_scheduler = id;
    }
    void loop()
    {
        while(true)
        {
            //每隔固定时间向所有线程发中断信号
            ::usleep(1000 * interval);
            while(1)
            {
                if(!Scheduler::block_signal)
                {
                    pthread_kill(thread_scheduler,SIGUSR1);
                    break;
                }
            }

        }
    }
private:
    unsigned int interval;//发送中断的间隔(豪秒)
    pthread_t thread_scheduler;
};


bool initcoroutine(unsigned int interval);


#endif
