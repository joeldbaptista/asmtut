sumseq: sumseq.o sumseqc.o
	gcc -o sumseq sumseq.o sumseqc.o

sumseq.o: sumseq.s
	gcc -c sumseq.s -o sumseq.o

sumseqc.o: sumseq.c
	gcc -c sumseq.c -o sumseqc.o

clean:
	rm -f *.o sumseq
