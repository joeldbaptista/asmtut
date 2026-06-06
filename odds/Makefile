CC = gcc
AS = as

odds: odds.o
	$(CC) -o $@ $^

odds.o: odds.s
	$(AS) -o $@ $<

clean:
	rm -f odds *.o

.PHONY: clean
