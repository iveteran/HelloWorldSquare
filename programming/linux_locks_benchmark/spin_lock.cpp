

#include <future>
#include <iostream>
//#include "boost/smart_ptr/detail/spinlock.hpp"
//boost::detail::spinlock lock;

#include <pthread.h>
pthread_spinlock_t lock;
volatile int value = 0;

int loop (bool inc, int limit) {
  std::cout << "Started " << inc << " " << limit << std::endl;
  for (int i = 0; i < limit; ++i) {
    //std::lock_guard<boost::detail::spinlock> guard(lock);
    pthread_spin_lock(&lock);
    if (inc) { 
      ++value;
    } else {
      --value;
    }
    pthread_spin_unlock(&lock);
  }
  return 0;
}

int main () {
  pthread_spin_init(&lock, 0);
  auto f = std::async (std::launch::async, std::bind (loop, true, 20000000));
  loop (false, 10000000);
  f.wait ();
  std::cout << value << std::endl;
}


