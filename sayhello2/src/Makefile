program=hello

all: $(program)

CC = clang++
CFLAGS = -g -pg
CPPFLAGS = -g -pg

INC = -I../inc
LIBS = -L../lib

llibs = -lm

objects = hello.o bar.o

$(program): $(objects)
	$(CC) -o $@ $^ $(llibs)

.c.o:
	$(CC) $(CPPFLAGS) -c $< $(INC)

.cpp.o:
	$(CC) $(CPPFLAGS) -c $< $(INC)

%.d: %.c
	$(CC) -MM $< > $@

.PHONY: clean install
clean:
	-rm $(program)  $(objects)

install:
	cp  $(program) ../bin/
