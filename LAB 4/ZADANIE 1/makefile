compile: fpu.o fpu_asm.o
	gcc -pg -o compile fpu.o fpu_asm.o -no-pie

fpu.o: fpu.c
	gcc -pg -c fpu.c

fpu_asm.o: fpu.asm
	nasm -f elf64 -g -F dwarf fpu.asm -o fpu_asm.o -l fpu_asm.lst

clean:
	rm -f *.o *.lst compile gmon.out