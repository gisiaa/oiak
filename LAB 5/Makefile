all: compile

compile: main.o matrix.o
	gcc -o compile main.o matrix.o -no-pie

main.o: main.c
	gcc -c main.c

matrix.o: matrix.asm
	nasm -f elf64 -g -F dwarf matrix.asm -o matrix.o -l matrix.lst

clean:
	rm -f *.o *.lst compile
