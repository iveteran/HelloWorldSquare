/* testlsof.c */
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
    int fd = open("/tmp/foo", O_CREAT|O_RDONLY);
    printf("sleep 1200 seconds...\n");
    sleep(1200);
    printf("Got up.");
    close(fd);
    return 0;
}
