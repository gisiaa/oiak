compile: mainO.o time.o
	gcc -pg -o compile mainO.o time.o -no-pie

mainO.o: mainO.c
	gcc -pg -c mainO.c

time.o: time.asm
	nasm -f elf64 -g -F dwarf time.asm -l time.lst

clean:
	rm -f *.o *.lst compile gmon.out