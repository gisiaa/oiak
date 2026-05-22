#include <stdio.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif


// sprowadzanie kata do mniejszego zakresu
double reduce_angle(double x) {
    x = fmod(x, 2.0 * M_PI);

    if (x > M_PI) {
        x -= 2.0 * M_PI;
    }

    if (x < -M_PI) {
        x += 2.0 * M_PI;
    }

    return x;
}


// sinus z szeregu Taylora
double taylor_sin(double x, double epsilon) {
    double terms[100];      // rezerwuje 100-elementowa tablice na wyrazy szeregu
    int n = 1;              // n
    int count = 0;          // licznik, by wiedziec ile wyrazow zostalo juz wliczonych

    // sprowadzam x do mniejszego zakresu, zeby szereg szybciej sie zbiegal
    x = reduce_angle(x);

    terms[0] = x;           // pierwszy wyraz to po prostu x
    count = 1;

    double x_sq = x * x;    // x^2
    double current_term = x;

    // petla do wyliczania wyrazow
    while (1) {
        // by nie wyjsc poza tablice
        if (count >= 100) {
            break;
        }

        // mianownik: 2n * (2n+1)
        double mianownik = (2.0 * n) * (2.0 * n + 1.0);

        // wyliczam nowy wyraz na podstawie poprzedniego
        current_term = -current_term * x_sq / mianownik;

        terms[count] = current_term; // zapisuje moj wyliczony wyraz w tablicy
        count++;

        // sprawdzam precyzje - czy wyraz jest mniejszy niz epsilon?
        if (fabs(current_term) < epsilon) {
            break;
        }

        n++;
    }

    // sumuje moj szereg od konca, czyli od najmniejszych wyrazow
    double suma = 0.0;      // wynik

    for (int i = count - 1; i >= 0; i--) {
        suma += terms[i];   // dodaje kolejny wyraz do sumy
    }

    return suma;            // zwracam wynik
}


// cosinus z szeregu Taylora
double taylor_cos(double x, double epsilon) {
    double terms[100];      // rezerwuje 100-elementowa tablice na wyrazy szeregu
    int n = 1;              // n
    int count = 0;          // licznik, by wiedziec ile wyrazow zostalo juz wliczonych

    // sprowadzam x do mniejszego zakresu, zeby szereg szybciej sie zbiegal
    x = reduce_angle(x);

    terms[0] = 1.0;         // pierwszy wyraz cosinusa to 1
    count = 1;

    double x_sq = x * x;    // x^2
    double current_term = 1.0;

    // petla do wyliczania wyrazow
    while (1) {
        // by nie wyjsc poza tablice
        if (count >= 100) {
            break;
        }

        // mianownik: (2n-1) * 2n
        double mianownik = (2.0 * n - 1.0) * (2.0 * n);

        // wyliczam nowy wyraz na podstawie poprzedniego
        current_term = -current_term * x_sq / mianownik;

        terms[count] = current_term; // zapisuje moj wyliczony wyraz w tablicy
        count++;

        // sprawdzam precyzje
        if (fabs(current_term) < epsilon) {
            break;
        }

        n++;
    }

    // sumuje szereg od konca, czyli od najmniejszych wyrazow
    double suma = 0.0;      // wynik

    for (int i = count - 1; i >= 0; i--) {
        suma += terms[i];   // dodaje kolejny wyraz do sumy
    }

    return suma;            // zwracam wynik
}


// MENU wyboru dla calkowania
double my_function(double x, int function_choice) {
    if (function_choice == 1) {
        return taylor_sin(x, 0.000001);
    } else if (function_choice == 2) {
        return taylor_cos(x, 0.000001);
    }

    return 0.0;
}


// calkowanie z sumowaniem Kahana
double integral_kahan(double a, double b, int n, int function_choice) {
    double dx = (b - a) / n;  // szerokosc pojedynczego przedzialu

    // zmienne do algorytmu sumowania Kahana
    double s = 0.0;           // suma calkowita
    double c = 0.0;           // korekta bledu zaokraglen

    // sumuje pola prostokatow
    for (int j = 0; j < n; j++) {
        // licze srodek aktualnego przedzialu
        double x = a + (j + 0.5) * dx;

        // pole pojedynczego prostokata
        double value = my_function(x, function_choice) * dx;

        // algorytm sumowania Kahana
        double y = value - c;     // odejmuje korekte z poprzedniego kroku
        double t = s + y;         // dodaje poprawiona wartosc do sumy
        c = (t - s) - y;          // zapisuje blad zaokraglen jako nowa korekte
        s = t;                    // aktualizuje glowna sume
    }

    return s;                     // zwracam wynik z poprawionym sumowaniem
}


int main() {
    double x;
    double epsilon;
    double a;
    double b;
    double blad;
    int menu;
    int wybor;
    int steps;

    printf("Wybierz rodzaj obliczen:\n");
    printf("1 - szereg Taylora\n");
    printf("2 - calkowanie\n");
    printf("Twoj wybor: ");
    scanf("%d", &menu);

    if (menu == 1) {
        printf("\nWybierz funkcje:\n");
        printf("1 - sinus\n");
        printf("2 - cosinus\n");
        printf("Twoj wybor: ");
        scanf("%d", &wybor);

        printf("Podaj kat w radianach: ");
        scanf("%lf", &x);

        printf("Podaj dokladnosc obliczen: ");
        scanf("%lf", &epsilon);

        if (epsilon <= 0.0) {
            epsilon = 0.000001;
            printf("Niepoprawna dokladnosc, ustawiam domyslnie 0.000001.\n");
        }

        if (wybor == 1) {
            double wynik = taylor_sin(x, epsilon);
            double wynik_systemowy = sin(x);
            blad = fabs(wynik - wynik_systemowy);

            printf("\nObliczony sinus: %.12f\n", wynik);
            printf("Wynik z funkcji sin(): %.12f\n", wynik_systemowy);
            printf("Roznica miedzy wynikami: %.12f\n", blad);

        } else if (wybor == 2) {
            double wynik = taylor_cos(x, epsilon);
            double wynik_systemowy = cos(x);
            blad = fabs(wynik - wynik_systemowy);

            printf("\nObliczony cosinus: %.12f\n", wynik);
            printf("Wynik z funkcji cos(): %.12f\n", wynik_systemowy);
            printf("Roznica miedzy wynikami: %.12f\n", blad);

        } else {
            printf("\nNiepoprawny wybor funkcji.\n");
        }

    } else if (menu == 2) {
        printf("\nWybierz calke:\n");
        printf("1 - calka z sinusa od 0 do pi\n");
        printf("2 - calka z cosinusa od 0 do pi\n");
        printf("Twoj wybor: ");
        scanf("%d", &wybor);

        printf("Podaj liczbe przedzialow: ");
        scanf("%d", &steps);

        if (steps <= 0) {
            steps = 100000;
            printf("Niepoprawna liczba przedzialow, ustawiam domyslnie 100000.\n");
        }

        if (wybor == 1) {
            // Przykladowe przedzialy:
            // 0 do M_PI       -> calka z sinusa wynosi 2
            // 0 do M_PI / 2   -> calka z sinusa wynosi 1
            // 0 do 2 * M_PI   -> calka z sinusa wynosi 0
            a = 0.0;
            b = M_PI;

            double wynik = integral_kahan(a, b, steps, 1);

            printf("\nCalka z sinusa od 0 do pi: %.12f\n", wynik);
            printf("Dokladny wynik matematyczny: 2.000000000000\n");
            printf("Roznica: %.12f\n", fabs(wynik - 2.0));

        } else if (wybor == 2) {
            // Przykladowe przedzialy:
            // 0 do M_PI       -> calka z cosinusa wynosi 0
            // 0 do M_PI / 2   -> calka z cosinusa wynosi 1
            // 0 do 2 * M_PI   -> calka z cosinusa wynosi 0
            //

            a = 0.0;
            b = M_PI;

            double wynik = integral_kahan(a, b, steps, 2);

            printf("\nCalka z cosinusa od 0 do pi: %.12f\n", wynik);
            printf("Dokladny wynik matematyczny: 0.000000000000\n");
            printf("Roznica: %.12f\n", fabs(wynik));

        } else {
            printf("\nNiepoprawny wybor calki.\n");
        }

    } else {
        printf("\nNiepoprawny wybor rodzaju obliczen.\n");
    }

    return 0;
}