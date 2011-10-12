// yufangbin
#include <stdio.h>
#include <iostream>
#include "bar.h"

using namespace std;

#define D_HELLO_WORLD "Hello World!"

void foo(int a, char *b)
{
    printf("foo: %d, %s\n", a, b);
    return;
}

int
main()
{
    int *p = new int[4];

    cout << "Hello World!\n";

    foo(2, "foo_arg");

    bar(3, "bar_arg");

    int *pp = NULL;
    *pp = 1;

    cout << D_HELLO_WORLD << endl;

    //delete [] p;
    return 0;
}
