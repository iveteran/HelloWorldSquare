#!/bin/sh

g++ -std=c++11 -O3 -o no_lock no_lock.cpp -lpthread
g++ -std=c++11 -O3 -o asm_lock asm_lock.cpp -lpthread
g++ -std=c++11 -O3 -o atomic_lock atomic_lock.cpp -lpthread
g++ -std=c++11 -O3 -o spin_lock spin_lock.cpp -lpthread
g++ -std=c++11 -O3 -o mutex_lock mutex_lock.cpp -lpthread
