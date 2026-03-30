sito: sito.o
	gcc -o sito sito.o -no-pie
sito.o: sito.asm
	nasm -f elf64 -g -F dwarf sito.asm -l sito.lst