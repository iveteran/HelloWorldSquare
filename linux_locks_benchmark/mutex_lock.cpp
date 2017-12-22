

    #include <future>
    #include <iostream>

    std::mutex mutex;
    volatile int value = 0;

    int loop (bool inc, int limit) {
      std::cout << "Started " << inc << " " << limit << std::endl;
      for (int i = 0; i < limit; ++i) {
        std::lock_guard<std::mutex> guard (mutex);
        if (inc) { 
          ++value;
        } else {
          --value;
        }
      }
      return 0;
    }

    int main () {
      auto f = std::async (std::launch::async, std::bind(loop, true, 20000000));
      loop (false, 10000000);
      f.wait ();
      std::cout << value << std::endl;
    }


