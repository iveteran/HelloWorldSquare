cython c1.pyx
gcc -c -fPIC -I/usr/include/python2.7/ c1.c
gcc -shared c1.o -o c1.so

cython c2.pyx
gcc -c -fPIC -I/usr/include/python2.7/ c2.c
gcc -shared c2.o -o c2.so

cython c3.pyx
gcc -c -fPIC -I/usr/include/python2.7/ c3.c
gcc -shared c3.o -o c3.so

gcc -lm -o ctest ctest.c

echo "###################"
python test.py
echo "###################"
pypy pypy_test.py
echo "###################"
time ./ctest
