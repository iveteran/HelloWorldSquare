all:
	swig -python example.i
	python setup.py build_ext --inplace

run:
	@time python test.py

clean:
	rm -rf build example.py example_wrap.c *.so *.pyc
