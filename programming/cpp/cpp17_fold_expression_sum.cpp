#include <iostream>

// Refer: https://zhxilin.github.io/post/tech_stack/1_programming_language/modern_cpp/cpp17/fold_expressions/

//一元右折叠
template<typename... T>
auto sumR(T... args) {
    return (args + ...);
}

//一元左折叠
template<typename... T>
auto sumL(T... args) {
    return (... + args);
}

int main() {
    std::cout << sumR(1, 2, 3, 4, 5) << std::endl; //15
    std::cout << sumL(1, 2, 3, 4, 5) << std::endl; //15
    return 0;
}
