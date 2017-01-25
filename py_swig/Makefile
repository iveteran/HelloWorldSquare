all: _Bit.so

_Bit.so: Bit.i Bit.c Bit.h
	swig -python Bit.i
	gcc -c -fpic Bit.c Bit_wrap.c -I /usr/include/python2.7
	gcc -shared Bit.o Bit_wrap.o -o _Bit.so

run:
	@echo "Test running..."
	@time python ./prime_count.py

clean:
	rm -rf Bit_wrap.c Bit.py *.o *.so *.pyc
