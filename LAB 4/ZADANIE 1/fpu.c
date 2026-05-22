#include <stdio.h>
#include <stdint.h>
#include "fpu.h"


void print_fpu_exceptions(uint16_t status) {
    if (status & FPU_EX_INVALID) {
        printf("Wyjatek: INVALID OPERATION\n");
    }

    if (status & FPU_EX_DENORMAL) {
        printf("Wyjatek: DENORMAL\n");
    }

    if (status & FPU_EX_ZERODIVIDE) {
        printf("Wyjatek: DIVIDE BY ZERO\n");
    }

    if (status & FPU_EX_OVERFLOW) {
        printf("Wyjatek: OVERFLOW\n");
    }

    if (status & FPU_EX_UNDERFLOW) {
        printf("Wyjatek: UNDERFLOW\n");
    }

    if (status & FPU_EX_PRECISION) {
        printf("Wyjatek: PRECISION / INEXACT RESULT\n");
    }

    if ((status & 0x003F) == 0) {
        printf("Brak wyjatkow FPU.\n");
    }
}


void choose_rounding_mode(void) {
    int choice;

    printf("Wybierz tryb zaokraglania:\n");
    printf("0 - do najblizszej wartosci\n");
    printf("1 - w dol\n");
    printf("2 - w gore\n");
    printf("3 - do zera\n");
    printf("Twoj wybor: ");
    scanf("%d", &choice);

    if (choice == 0) {
        set_fpu_rounding(FPU_ROUND_NEAREST);
    } else if (choice == 1) {
        set_fpu_rounding(FPU_ROUND_DOWN); // do minus nieskonczonosci
    } else if (choice == 2) {
        set_fpu_rounding(FPU_ROUND_UP); // do plus nieskonczonosci
    } else if (choice == 3) {
        set_fpu_rounding(FPU_ROUND_ZERO); // ucina to, co sie nie miesci w precyzji, czyli zaokragla w strone zera
    } else {
        set_fpu_rounding(FPU_ROUND_NEAREST); // domyslnie do najblizszej wartosci, jak sie wpisze cos innego niz 0-3
        printf("Niepoprawny wybor, ustawiam domyslnie zaokraglanie do najblizszej wartosci.\n");
    }
}


void choose_precision(void) {
    int choice;

    printf("\nWybierz precyzje obliczen:\n"); // ile bitow FPU uzyc do obliczen, czyli ile bitow mantysy, co wplywa na dokladnosc wynikow i zakres liczb, ktore mozna reprezentowac
    printf("0 - 24 bity\n"); // 24 bity to precyzja pojedyncza, czyli float w C
    printf("1 - 53 bity\n"); // 53 bity to precyzja podwojna, czyli double w C
    printf("2 - 64 bity\n"); // 64 bity - wiecej niz double, najwieksza precyzja w FPU
    printf("Twoj wybor: ");
    scanf("%d", &choice);

    if (choice == 0) {
        set_fpu_precision(FPU_PRECISION_24B);
    } else if (choice == 1) {
        set_fpu_precision(FPU_PRECISION_53B);
    } else if (choice == 2) {
        set_fpu_precision(FPU_PRECISION_64B);
    } else {
        set_fpu_precision(FPU_PRECISION_64B);
        printf("Niepoprawny wybor, ustawiam domyslnie precyzje 64 bity.\n");
    }
}


int main() {
    double a;
    double b;
    double result;
    uint16_t status;

    // maskuje wszystkie wyjatki
    // mimo maskowania flaga wyjatku dalej pojawi sie w Status Word
    // status word to rejestr, ktory przechowuje informacje o stanie FPU, w tym o wystapieniu wyjatkow, aktualnym trybie zaokraglania i precyzji, oraz innych ustawieniach
    set_fpu_exceptions_mask(FPU_EX_ALL_MASKS);
    // maskowanie wyjatku - pozwolenie na wykrycie bledu przez FPU, ale nie powoduje to przerwania programu, tylko ustawia odpowiednia flage w Status Word, ktora mozna potem sprawdzic

    choose_rounding_mode();
    choose_precision();

    printf("\nControl Word: 0x%x\n", get_fpu_control()); // ustawiam FPU, czyli jak FPU ma liczyć

    printf("\nPodaj pierwsza liczbe: ");
    scanf("%lf", &a);

    printf("Podaj druga liczbe: ");
    scanf("%lf", &b);

    // czyszcze stare wyjatki
    clear_fpu_exceptions();

    result = fpu_divide(a, b);

    printf("\nWynik: %.17g / %.17g = %.17g\n", a, b, result);

    // sprawdzam status FPU
    status = get_fpu_status();

    printf("Status FPU: 0x%x\n", status);
    print_fpu_exceptions(status);

    clear_fpu_exceptions();

    return 0;
}
