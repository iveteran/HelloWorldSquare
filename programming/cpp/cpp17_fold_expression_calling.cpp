#include <iostream>

template<typename... T>
bool all(T... args) { return (... && args); }

template<typename... T>
bool any(T... args) { return (... || args); }

template<typename TFunc, typename... Ts>
void for_each(TFunc&& f, Ts&&... args) {
    (f(args), ...);
}

int main() {
    std::cout<< std::boolalpha;

    bool b1 = all();
    std::cout << "all() = " << b1 << std::endl; //true

    bool b2 = all(true, false, true);
    std::cout << "all(true, false, true) = " << b2 << std::endl; //false

    bool b3 = any();
    std::cout << "any() = " << b3 << std::endl; //false

    bool b4 = any(true, false, true);
    std::cout << "any(true, false, true) = " << b4 << std::endl; //true

    for_each([](auto a){ std::cout << a << std::endl; }, 1, 2, 3); //逐行输出
    for_each([](auto a){ std::cout << a << std::endl; }); //没有任何输出

    return 0;
}
