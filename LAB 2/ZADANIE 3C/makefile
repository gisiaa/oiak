sort128: sort128.o
	gcc -o sort128 sort128.o -no-pie
sort128.o: sort128.asm
	nasm -f elf64 -g -F dwarf sort128.asm -l sort128.lst