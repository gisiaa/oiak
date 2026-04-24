#include <stdio.h>

// importuje funkcjie z Asemblera
extern double add(double a, long b);
extern double substract(double a, long b);
extern double multiply(double a, long b);
extern double divide(double a, long b);

int main() {
    double zmiennoprzecinkowa;
    long calkowita;

    printf("Podaj liczbe zmiennoprzecinkowa: ");
    scanf("%lf", &zmiennoprzecinkowa); // %lf - format dla double, &zmiennoprzecinkowa - adres zmiennej, gdzie scanf zapisze wczytana wartosc

    printf("Podaj liczbe calkowita: ");
    scanf("%ld", &calkowita);

    printf("\n wynik dodawania: %.2f\n", add(zmiennoprzecinkowa, calkowita));
    printf(" wynik odejmowania: %.2f\n", substract(zmiennoprzecinkowa, calkowita));
    printf(" wynik mnozenia: %.2f\n", multiply(zmiennoprzecinkowa, calkowita));
    printf(" wynik dzielenia: %.2f\n", divide(zmiennoprzecinkowa, calkowita));

    return 0;
}