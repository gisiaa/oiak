compile: main.o CFunctions.o
	gcc -g -o compile main.o CFunctions.o -no-pie

main.o: main.asm
	nasm -f elf64 -g -F dwarf main.asm -l main.lst

CFunctions.o: CFunctions.c
	gcc -c -g CFunctions.c