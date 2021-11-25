TARGET = uthread_test
all: $(TARGET)

$(TARGET): thread.cpp uthread.cpp test.cpp
	g++ -o $(TARGET) thread.cpp uthread.cpp test.cpp -lpthread

clean:
	rm -rf *.o $(TARGET)
