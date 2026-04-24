compile: main_c.o main_asm.o
	gcc -g -o compile main_c.o main_asm.o -no-pie

main_c.o: main_c.c
	gcc -c -g main_c.c -o main_c.o

main_asm.o: main_asm.asm
	nasm -f elf64 -g -F dwarf main_asm.asm -o main_asm.o -l main_asm.lst