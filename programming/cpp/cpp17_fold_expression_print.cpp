#include <iostream>

//C++11，应对单参数的递归出口
void print() {
    std::cout << std::endl;
}

template<typename T, typename... Ts>
void print(T arg, Ts... args) {
    std::cout << arg << ", ";
    print(args...);
}

//一元右折叠
template<typename... T>
void printR(T... args) {
    ((std::cout << args << ", "), ...) << std::endl;
}

//一元左折叠
template<typename... T>
void printL(T... args) {
    (..., (std::cout << args << ", ")) << std::endl;
}

int main() {
    print("hello", "zhxilin", 1, 2, 3);
    printR("hello", "zhxilin", 1, 2, 3);
    printL("hello", "zhxilin", 1, 2, 3);
    return 0;
}
