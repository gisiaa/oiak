#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// funkcje pomiaru czasu z assembly
extern uint64_t start_timer(void);
extern uint64_t stop_timer(void);

int find_min_1d(int n, int t[]) {
    if (n <= 0) return 0;

    register int min_val = t[0];

    for (register int i = 1; i < n; i++) {
        register int x = t[i];

        if (x < min_val) {
            min_val = x;
        }
    }
    return min_val;
}

int find_max_1d(int n, int t[]) {
    if (n <= 0) return 0;

    register int max_val = t[0];

    for (register int i = 1; i < n; i++) {
        register int x = t[i];

        if (x > max_val) {
            max_val = x;
        }
    }
    return max_val;
}

int find_min_2d(int wiersze, int kolumny, int t[wiersze][kolumny]) {
    if (wiersze <= 0 || kolumny <= 0) return 0;

    register int min_val = t[0][0];

    for (register int i = 0; i < wiersze; i++) {
        for (register int j = 0; j < kolumny; j++) {
            register int x = t[i][j];

            if (x < min_val) {
                min_val = x;
            }
        }
    }
    return min_val;
}

int find_max_2d(int wiersze, int kolumny, int t[wiersze][kolumny]) {
    if (wiersze <= 0 || kolumny <= 0) return 0;

    register int max_val = t[0][0];

    for (register int i = 0; i < wiersze; i++) {
        for (register int j = 0; j < kolumny; j++) {
            register int x = t[i][j];

            if (x > max_val) {
                max_val = x;
            }
        }
    }
    return max_val;
}

int main() {
    int rozmiar_1d = 20000000;
    int wiersze = 4500;
    int kolumny = 4500;
    int minimum, maksimum;

    uint64_t start, stop, czas_1d, czas_2d;

    int *tablica1D = malloc(rozmiar_1d * sizeof(int));
    if (tablica1D == NULL) {
        printf("Pamięć nie została przydzielona dla tablicy jednowymiarowej\n");
        return 1;
    }

    FILE *plik1D = fopen("one-dimensional_array.txt", "r");
    if (plik1D == NULL) {
        printf("Nie udało się otworzyć pliku!\n");
        free(tablica1D);
        return 1;
    }

    for (int i = 0; i < rozmiar_1d; i++) {
        fscanf(plik1D, "%d", &tablica1D[i]);
    }
    fclose(plik1D);

    printf("WYNIKI DLA TABLICY JEDNOWYMIAROWEJ:\n");

    start = start_timer();

    minimum = find_min_1d(rozmiar_1d, tablica1D);
    maksimum = find_max_1d(rozmiar_1d, tablica1D);

    stop = stop_timer();
    czas_1d = stop - start;

    printf("Minimum: %d\nMaksimum: %d\n", minimum, maksimum);
    printf("Liczba cykli dla 1D: %lu\n\n", czas_1d);

    free(tablica1D);

    int (*tablica2D)[kolumny] = malloc(wiersze * kolumny * sizeof(int));
    if (tablica2D == NULL) {
        printf("Nie przydzielono pamieci dla 2D!\n");
        return 1;
    }

    FILE *plik2D = fopen("two-dimensional_array.txt", "r");
    if (plik2D == NULL) {
        printf("Nie udało się otworzyć pliku two-dimensional_array.txt!\n");
        free(tablica2D);
        return 1;
    }

    for (int i = 0; i < wiersze; i++) {
        for (int j = 0; j < kolumny; j++) {
            fscanf(plik2D, "%d", &tablica2D[i][j]);
        }
    }
    fclose(plik2D);

    printf("WYNIKI DLA TABLICY DWUWYMIAROWEJ:\n");

    start = start_timer();

    minimum = find_min_2d(wiersze, kolumny, tablica2D);
    maksimum = find_max_2d(wiersze, kolumny, tablica2D);

    stop = stop_timer();
    czas_2d = stop - start;

    printf("Minimum: %d\nMaksimum: %d\n", minimum, maksimum);
    printf("Liczba cykli dla 2D: %lu\n", czas_2d);

    free(tablica2D);

    return 0;
}