sort96: sort96.o
	gcc -o sort96 sort96.o -no-pie
sort96.o: sort96.asm
	nasm -f elf64 -g -F dwarf sort96.asm -l sort96.lst