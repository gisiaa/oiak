#include <stdio.h>

// zmienna i stala
int zmienna_c = 15;
const int STALA_C = 25;

extern int dodaj_w_asm(void);

int main() {
    int wynik = dodaj_w_asm();
    printf("Wynik dodawania z ASM: %d\n", wynik);
    
    return 0;
}