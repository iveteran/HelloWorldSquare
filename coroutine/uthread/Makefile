TARGET = uthread_test
all: $(TARGET)

$(TARGET): uthread_test.cpp uthread.cpp
	g++ -o $(TARGET) uthread_test.cpp uthread.cpp

clean:
	rm -rf *.o $(TARGET)
