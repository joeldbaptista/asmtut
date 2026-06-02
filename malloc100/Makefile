CC = gcc
AS = as

malloc100: malloc100.o
	$(CC) -o $@ $^

malloc100.o: malloc100.s
	$(AS) -o $@ $<

clean:
	rm -f malloc100 *.o

.PHONY: clean
