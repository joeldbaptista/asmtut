ex01: ex01.o memmove.o
	gcc -o ex01 ex01.o memmove.o

ex01.o:
	gcc -c ex01.c -o ex01.o

memcpy.o: memcpy.s
	as -c memcpy.s -o memcpy.o

memset.o: memset.s
	as -c memset.s -o memset.o

memmove.o: memmove.s
	as -c memmove.s -o memmove.o

disassemble: memset.o memmove.o memcpy.o
	objdump -d memset.o > memset.dat
	objdump -d memcpy.o > memcpy.dat
	objdump -d memmove.o > memmove.dat

clean:
	rm -f ex01 *.o *.dat
