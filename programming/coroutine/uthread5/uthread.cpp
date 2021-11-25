#include <stdlib.h>
#include <stdio.h>
#include <ucontext.h>
#include <sys/time.h>

#define STACK_SIZE 4096
#define UTHREAD_MAX_NUM 256
#define INIT_TICKS 10

typedef int uthread_t;
typedef void uthread_attr_t;
uthread_t current = 0;

#define uthread_self() current

struct uthread_struct
{
    int used;
    ucontext_t context;
    char stack[STACK_SIZE];
    void* (*func)(void *arg);
    void *arg;
    void *exit_status;
    int ticks;
};

static struct uthread_struct uthread_slots[UTHREAD_MAX_NUM];

void panic(void)
{
    fprintf(stderr, "Panic, bala bala...\n");
    exit(EXIT_FAILURE);
}

void idle_thread(void)
{
    int i;

    for (i = 1; i < UTHREAD_MAX_NUM; i ++)
        if (uthread_slots[i].used)
            break;

    if (i == UTHREAD_MAX_NUM)
        panic();
    if (current != 0)
        uthread_slots[current].used = 0;
    current = i;
    swapcontext(&uthread_slots[0].context,&uthread_slots[current].context);
}

void uthread_context_init(int tid)
{
    getcontext(&uthread_slots[tid].context);
    uthread_slots[tid].context.uc_stack.ss_sp = uthread_slots[tid].stack;
    uthread_slots[tid].context.uc_stack.ss_size =sizeof(uthread_slots[tid].stack);
    uthread_slots[tid].context.uc_link = &uthread_slots[0].context;
}

void uthread_init(void)
{
    uthread_context_init(0);
    uthread_slots[0].used = 1;
    makecontext(&uthread_slots[0].context, idle_thread, 0);
}

void uthread_schedule(void);

void uthread_exit(void *exit_status)
{
    uthread_slots[current].exit_status = exit_status;
    uthread_slots[current].used = 0;
    uthread_schedule();
}

void uthread_helper(void)
{
    uthread_exit(uthread_slots[current].func(uthread_slots[current].arg));
}

int uthread_create(uthread_t *thread, const uthread_attr_t *attr,
        void* (*start_routine)(void*), const void *arg)
{
    static int last_used = 0;
    int i;

    for (i = (last_used + 1) % UTHREAD_MAX_NUM; i != last_used;
            i = (i + 1) % UTHREAD_MAX_NUM)
        if (!uthread_slots[i].used)
            break;
    if (i == last_used)
        return -1;
    last_used = i;

    if (thread != NULL)
        *thread = i;
    uthread_context_init(i);
    uthread_slots[i].used = 1;
    uthread_slots[i].func = start_routine;
    uthread_slots[i].arg = (void*)arg;
    uthread_slots[i].exit_status = 0;
    uthread_slots[i].ticks = uthread_slots[current].ticks / 2;
    uthread_slots[current].ticks -= uthread_slots[i].ticks;
    makecontext(&uthread_slots[i].context, uthread_helper, 0);

    return 0;
}

void uthread_schedule(void)
{
    int i, prev;

    for (i = (current + 1) % UTHREAD_MAX_NUM; i != current;
            i = (i + 1) % UTHREAD_MAX_NUM)
        if (uthread_slots[i].used)
            break;
    if (i == current)
        panic();

    prev = current;
    current = i;
    swapcontext(&uthread_slots[prev].context,&uthread_slots[current].context);
}

void* thread(void *arg)
{
    int i;

    for (i = 0; i<1000; i ++) {
        if (i % 100 == 0)
            printf("thread/%d(%s): i = %d\n", current, (char*)arg,i);
        uthread_create(NULL, NULL, thread, arg);
        if (i % 1000000 == 0)
            uthread_schedule();
    }
}

void sig_ticks_timer(int signo)
{
    if (--uthread_slots[current].ticks <= 0) {
        uthread_slots[current].ticks = INIT_TICKS;
        uthread_schedule();
    }
}

int main(int argc, char *argv[])
{
    uthread_t tid;
    struct itimerval ticks_timer;

    uthread_init();

    uthread_create(&tid, NULL, thread, "hw1");
    printf("tid is %d\n", tid);
    uthread_create(&tid, NULL, thread, "hw2");
    printf("tid is %d\n", tid);

    signal(SIGALRM, sig_ticks_timer);
    ticks_timer.it_interval.tv_sec = 0;
    ticks_timer.it_interval.tv_usec = 10000;
    ticks_timer.it_value.tv_sec = 0;
    ticks_timer.it_value.tv_usec = 10000;
    setitimer(ITIMER_REAL, &ticks_timer, NULL);

    while (1)
        idle_thread();

    return 0;
}
