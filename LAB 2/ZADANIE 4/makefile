fib: fib.o
	gcc -o fib fib.o -no-pie
fib.o: fib.asm
	nasm -f elf64 -g -F dwarf fib.asm -l fib.lst