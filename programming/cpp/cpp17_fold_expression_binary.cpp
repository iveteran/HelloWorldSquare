#include <iostream>

//二元右折叠表达式
template<typename... T>
auto sumR(T... args) {
    return (args + ... + 0);
}

//二元左折叠表达式
template<typename... T>
auto sumL(T... args) {
    return (0 + ... + args);
}

int main() {
    std::cout << sumR() << std::endl; //0
    std::cout << sumL() << std::endl; //0
    std::cout << sumR(1, 2, 3, 4, 5) << std::endl; //15
    std::cout << sumL(1, 2, 3, 4, 5) << std::endl; //15
    return 0;
}
