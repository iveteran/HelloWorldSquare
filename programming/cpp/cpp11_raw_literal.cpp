#include <iostream>

int main() {
    auto& s0 = "\u4f60\u597d";
    std::cout << "s0 = " << s0 << ", sizeof(s0) = " << sizeof(s0) << std::endl;
    auto& s1 = u8R"(你好)";
    std::cout << "s1 = " << s1 << ", sizeof(s1) = " << sizeof(s1) << std::endl;
    auto& s2 = uR"(你好)";
    std::cout << "s2 = " << s2 << ", sizeof(s2) = " << sizeof(s2) << std::endl;
    auto& s3 = UR"(你好)";
    std::cout << "s3 = " << s3 << ", sizeof(s3) = " << sizeof(s3) << std::endl;

    std::cout << "--------"  << std::endl;

    auto& s4 = u8R"(zhxilin)";
    std::cout << "s4 = " << s4 << ", sizeof(s4) = " << sizeof(s4) << std::endl;
    auto& s5 = uR"(zhxilin)";
    std::cout << "s5 = " << s5 << ", sizeof(s5) = " << sizeof(s5) << std::endl;
    auto& s6 = UR"(zhxilin)";
    std::cout << "s6 = " << s6 << ", sizeof(s6) = " << sizeof(s6) << std::endl;
    return 0;
}
