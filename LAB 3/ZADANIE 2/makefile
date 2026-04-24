compile: ASMFunctions.o main.o
	gcc -g -o compile ASMFunctions.o main.o -no-pie

ASMFunctions.o: ASMFunctions.asm
	nasm -f elf64 -g -F dwarf ASMFunctions.asm -l ASMFunctions.lst

main.o: main.c
	gcc -c -g main.c