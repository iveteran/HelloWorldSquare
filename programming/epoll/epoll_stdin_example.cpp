#include <cstdio>
#include <unistd.h>
#include <sys/epoll.h>
#include <iostream>
#include <string>
 
constexpr int max_events=256;
 
int main()
{
    int efd = epoll_create(1024);
    if (efd == -1) {
        printf("epoll ceate failed");
        return -1;
    }

    epoll_event ev, events[max_events];
    ev.events = EPOLLIN;
    ev.data.fd = STDIN_FILENO;
    if (epoll_ctl(efd, EPOLL_CTL_ADD, STDIN_FILENO, &ev) == -1){
        perror("epoll_ctl: failed");
        return -2;
    }

    for (;;) {
        //int timeout = -1;
        int timeout = 100;  // milliseconds
        int okfdlen = epoll_wait(efd, events, max_events, timeout);
        if (okfdlen == -1) {
            perror("epoll_wait:failed");
            return -1;
        }
        for (int i=0; i<okfdlen; i++){
            if (events[i].data.fd == STDIN_FILENO){
                std::string input;
                if (getline(std::cin, input)) {
                    //std::cout << "bytes: " << input.size() << std::endl;
                    if (! input.empty()) {
                        std::cout << "> " << input << std::endl;
                    }
                } else {
                    std::cout << "Pressed Ctrl-D." << std::endl;
                    std::cin.clear();
                    clearerr(stdin);   // 重置流的状态
                    //std::cout << "Pressed Ctrl-D, exit." << std::endl;
                    //std::exit(1);
                }
                std::cout << "> " << std::flush;
            }
        }
    }
    return 0;
}
// build: g++ -o epoll_stdin_example epoll_stdin_example.cpp
