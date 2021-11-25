all: native normal c

TARGET:=cpu_intensive
ERL_SOURCES:=cpu_intensive.erl
C_SOURCES:=cpu_intensive.c

native: $(ERL_SOURCES)
	erlc +native $(ERL_SOURCES)

normal: $(ERL_SOURCES)
	erlc $(ERL_SOURCES)

c: $(C_SOURCES)
	gcc -O0 -o $(TARGET) $(C_SOURCES)

run:
	@echo ""
	@echo "Fibonacci Erlang native code"
	@time erl -noshell -s cpu_intensive fib_test -s erlang halt
	@echo ""
	@echo "Fibonacci Erlang non-native code"
	@time erl -noshell -s cpu_intensive fib_test -s erlang halt
	@echo ""
	@echo "Fibonacci written in C without optimizations"
	@time ./cpu_intensive

clean:
	@rm -rf *.o *.beam $(TARGET)
