CC = gcc
AS = as

TARGETS = fibo01 fibo02

all: $(TARGETS)

fibo01: fibo01.c f01.o
	$(CC) -o $@ $^

fibo02: fibo01.c f02.o
	$(CC) -o $@ $^

fibo03: fibo02.c f03.o
	$(CC) -o $@ $^

%.o: %.s
	$(AS) -o $@ $<

clean:
	rm -f $(TARGETS) *.o

.PHONY: all clean
