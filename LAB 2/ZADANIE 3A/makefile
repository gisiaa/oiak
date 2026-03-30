sort64: sort64.o
	gcc -o sort64 sort64.o -no-pie
sort64.o: sort64.asm
	nasm -f elf64 -g -F dwarf sort64.asm -l sort64.lst