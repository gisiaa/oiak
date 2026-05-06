#include <stdio.h>

int zmienna_c = 15;
const int STALA_C = 25;
int tablica_c[5] = {1, 2, 3, 4, 5};

extern void dodaj_do_drugiego_elementu(void);
extern int dodaj_zmienne_w_asm(void);

int main() {
    int wynik;

    printf("Tablica przed zmianami: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", tablica_c[i]);
    }
    printf("\n");

    dodaj_do_drugiego_elementu();

    printf("Tablica po dodaniu elementu: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", tablica_c[i]);
    }
    printf("\n");

    wynik = dodaj_zmienne_w_asm();

    printf("zmienna_c = %d\n", zmienna_c);
    printf("STALA_C = %d\n", STALA_C);
    printf("Wynik dodawania zmiennych = %d\n", wynik);

    printf("Rozmiar int: %zu bajty\n", sizeof(int));

    return 0;
}