#include <iostream>

using namespace std;

template<typename T, typename... Args>
void MyPrint(T first, Args... rest)
{
    cout << first;
    // c++17 折叠表达式
    (cout << ... << rest) << endl;
}

int main()
{
    MyPrint("Hello");
    MyPrint("Hello ", "World");
    MyPrint("Hello ", "Hope ", 123);

    return 0;
}
