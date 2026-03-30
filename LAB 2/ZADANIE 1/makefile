nwd: nwd.o
	gcc -o nwd nwd.o -no-pie
nwd.o: nwd.asm
	nasm -f elf64 -g -F dwarf nwd.asm -l nwd.lst