# --------------

sumsqr: sumsqr.o sumsqrc.o
	gcc -o sumsqr sumsqr.o sumsqrc.o

sumsqr.o: sumsqr.s
	gcc -c sumsqr.s -o sumsqr.o

sumsqrc.o: sumsqr.c
	gcc -c sumsqr.c -o sumsqrc.o

# ---------------

sumsqr2: sumsqr2.o sumsqr2c.o sqr.o
	gcc -o sumsqr2 sumsqr2.o sqr.o sumsqr2c.o

sqr.o: sqr.s
	gcc -c sqr.s -o sqr.o

sumsqr2.o: sumsqr2.s
	gcc -c sumsqr2.s -o sumsqr2.o

sumsqr2c.o: sumsqr2.c
	gcc -c sumsqr2.c -o sumsqr2c.o

# ----------------

clean:
	rm -f *.o sumsqr sumsqr2
