#include <stdio.h>

extern int zmienna_asm;
extern const int STALA_ASM;

int main() {
    int wynik = zmienna_asm + STALA_ASM;
    
    printf("Wynik dodawania w C: %d\n", wynik);
    
    return 0;
}
