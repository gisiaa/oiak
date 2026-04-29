all: selectionSort selectionSortO

selectionSort: selectionSort.o timekeeping.o
	gcc -g -pg -o selectionSort selectionSort.o timekeeping.o -no-pie

selectionSortO: selectionSortO.o timekeeping.o
	gcc -O3 -g -pg -o selectionSortO selectionSortO.o timekeeping.o -no-pie

selectionSort.o: selectionSort.c
	gcc -c -g -pg selectionSort.c

selectionSortO.o: selectionSortO.c
	gcc -O3 -c -g -pg selectionSortO.c

timekeeping.o: timekeeping.asm
	nasm -f elf64 -g -F dwarf timekeeping.asm -l timekeeping.lst