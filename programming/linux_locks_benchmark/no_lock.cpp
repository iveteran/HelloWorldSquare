

#include <future>
#include <iostream>

volatile int value = 0;

int loop (bool inc, int limit) {
  std::cout << "Started " << inc << " " << limit << std::endl;
  for (int i = 0; i < limit; ++i) {
    if (inc) { 
      ++value;
    } else {
      --value;
    }
  }
  return 0;
}

int main () {
  auto f = std::async (std::launch::async, std::bind(loop, true, 20000000));//开启一个线程来执行loop函数，c++11的高级特性
  loop (false, 10000000);
  f.wait ();
  std::cout << value << std::endl;
}


