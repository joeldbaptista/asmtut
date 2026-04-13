
ex01: ex01.o sum.o
	gcc -o ex01 ex01.o sum.o

ex01.o: ex01.c
	gcc -c ex01.c -o ex01.o

sum.o: sum.s
	as -c sum.s -o sum.o

ex02: ex02.o sumsqr.o
	gcc -o ex02 ex02.o sumsqr.o

ex02.o: ex02.c
	gcc -c ex02.c -o ex02.o

sumsqr.o: sumsqr.s
	as -c sumsqr.s -o sumsqr.o

sumf.o: sumf.s
	as -c sumf.s -o sumf.o

ex03.o: ex03.c
	gcc -c ex03.c -o ex03.o

ex03: ex03.o sumf.o
	gcc -o ex03 ex03.o sumf.o

clean:
	rm -f *.o ex01 ex02 ex03
