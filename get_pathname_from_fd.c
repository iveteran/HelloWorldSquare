#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
int get_pathname_from_fd(int fd, char pathname[], int n)
{
        char buf[1024];
        pid_t  pid;
        bzero(buf, 1024);
        pid = getpid();
        snprintf(buf, 1024, "/proc/%i/fd/%i", pid, fd);
        return readlink(buf, pathname, n);
}
int main(void)
{
        int fd;
        char pathname[4096];
        bzero(pathname, 4096);
        fd = open("/tmp/foo", O_CREAT|O_RDONLY);
        get_pathname_from_fd(fd, pathname, 4096);
        printf("fd=%d; pathname=%s\n", fd, pathname);
        close(fd);
        return 0;
}
