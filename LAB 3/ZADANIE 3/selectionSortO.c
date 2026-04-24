#include <stdio.h>
#include <stdlib.h>

extern unsigned long long start_timer();
extern unsigned long long stop_timer();

void selection_sort_c(int n, int t[]) {
    int i, j, k; // i - indeks aktualnie sortowanego elementu, j - indeks elementu porownywanego, k - indeks najmniejszego elementu
    int temp;  // temp - zmienna pomocnicza do zamiany miejscami elementow
    int min_val; // zmienna pomocnicza do przechowywania wartosci najmniejszego elementu, aby uniknac wielokrotnego odczytywania z pamieci (optymalizacja)

    for ( i = 0; i < n - 1; i++ ) { // petla iterujaca po wszystkich elementach tablicy, z wyjatkiem ostatniego elementu, poniewaz po posortowaniu wszystkich poprzednich elementow, ostatni element bedzie automatycznie na swoim miejscu
        k = i; // zakladam, ze najmniejszy element jest aktualnie sortowanym elementem
        min_val = t[i]; // zapisuje wartosc aktualnie sortowanego elementu do zmiennej pomocniczej, aby porownywac z nią wartosci kolejnych 
                        // elementow w petli wewnetrznej, zamiast wielokrotnie odczytywac wartosc z pamieci (optymalizacja)    

        for( j = i + 1; j < n; j++ ) { // petla iterujaca po pozostalych elementach tablicy, zaczynajac od nastepnego elementu po aktualnie sortowanym
            if(t[j] < min_val) { // jesli element porownywany jest mniejszy od najmniejszego elementu (sprawdzamy z rejestrem procesora)
                k = j; // jesli element porownywany jest mniejszy od najmniejszego elementu, to aktualizuje indeks najmniejszego elementu
                min_val = t[j]; // oraz aktualizuje wartosc najmniejszego elementu w rejestrze procesora, aby porownywac z nią kolejne elementy w petli wewnetrznej, 
                                // zamiast wielokrotnie odczytywac wartosc z pamieci (optymalizacja)
            }
        }
        if (k != i) { // jesli indeks najmniejszego elementu jest inny niz indeks aktualnie sortowanego elementu, to zamieniam miejscami te elementy
            temp = t[k]; // zapisuje wartosc najmniejszego elementu do zmiennej pomocniczej
            t[k] = t[i]; // przypisuje wartosc aktualnie sortowanego elementu do miejsca najmniejszego elementu
            t[i] = min_val; // przypisuje wartosc najmniejszego elementu do miejsca aktualnie sortowanego elementu
        }
    }
}

int main() {
    int rozmiar_maksymalny = 500005;
    int *tablica = malloc(rozmiar_maksymalny * sizeof(int)); // alokuje pamiec na tablice o maksymalnym rozmiarze, aby pomiescic wszystkie liczby z pliku tekstowego

    if (tablica == NULL) {
        printf("Nie przydzielono pamieci!\n"); // sprawdzam, czy alokacja pamieci sie powiodla
        return 1;
    }

    FILE *plik = fopen("random_numbers.txt", "r");
    if (plik == NULL) {
        printf("Nie udalo sie otworzyc pliku!\n");
        free(tablica); // zwalniam pamiec przed zakonczeniem programu, aby uniknac wycieku pamieci
        return 1;
    }

    int wczytane = 0; 
    while (fscanf(plik, "%d", &tablica[wczytane]) == 1) {
        wczytane++; 
        if (wczytane >= rozmiar_maksymalny) break; // zabezpieczenie przed przekroczeniem rozmiaru tablicy, jesli plik zawiera wiecej liczb niz maksymalny rozmiar tablicy
    }
    fclose(plik);

    if (wczytane == 0) {
        printf("Pusty plik!\n"); // sprawdzam, czy wczytano jakiekolwiek liczby z pliku tekstowego
        free(tablica);
        return 1;
    }

    printf("Wczytano %d liczb z pliku tekstowego.\n", wczytane); // sprawdzenie dla pewnosci, ile liczb zostalo wczytanych z pliku tekstowego

    unsigned long long start_c = start_timer();
    
    selection_sort_c(wczytane, tablica);
    
    unsigned long long stop_c = stop_timer();
    unsigned long long cykle_c = stop_c - start_c;
    
    printf("Tablica zostala posortowana - po optymalizacji.\n");
    printf("Ilosc cykli procesora wynosi: %llu\n\n", cykle_c);

    free(tablica); 
    return 0;
}