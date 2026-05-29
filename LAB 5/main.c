#define _POSIX_C_SOURCE 200112L

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>

extern uint64_t run_seq(double *matrixA, double *matrixB, double *matrixC, int n, uint64_t loops);
extern uint64_t run_avx(double *matrixA, double *matrixB, double *matrixC, int n, uint64_t loops);
extern int compare_matrices(double *matrixC_seq, double *matrixC_avx, int n);


int read_next_double(FILE *file, double *value) {
    char token[128];

    while (fscanf(file, "%127s", token) == 1) {
        char *end;
        double number = strtod(token, &end);

        if (end != token) {
            *value = number;
            return 1;
        }
    }

    return 0;
}


// rezerwuje pamiec wyrownana do 32 bajtow
double *allocate_matrix(int n) {
    double *matrix = NULL;
    size_t bytes = (size_t)n * (size_t)n * sizeof(double);

    if (posix_memalign((void **)&matrix, 32, bytes) != 0) {
        return NULL;
    }

    return matrix;
}


// wypisuje macierz w konsoli
void print_matrix(double *matrix, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%10.2f ", matrix[i * n + j]);
        }
        printf("\n");
    }
}


// wczytuje z pliku rozmiar oraz dwie macierze n x n
int load_matrices_from_file(const char *filename, double **matrixA, double **matrixB, int *n) {
    FILE *file = fopen(filename, "r");

    if (file == NULL) {
        printf("Nie moge otworzyc pliku: %s\n", filename);
        return 0;
    }

    char line[256];

    if (fgets(line, sizeof(line), file) == NULL) {
        printf("Plik jest pusty.\n");
        fclose(file);
        return 0;
    }

    char *equals = strchr(line, '=');

    if (equals == NULL || sscanf(equals + 1, "%d", n) != 1 || *n <= 0) {
        printf("Niepoprawny rozmiar macierzy. Pierwsza linia powinna miec np. n = 4\n");
        fclose(file);
        return 0;
    }

    *matrixA = allocate_matrix(*n);
    *matrixB = allocate_matrix(*n);

    if (*matrixA == NULL || *matrixB == NULL) {
        printf("Blad alokacji pamieci.\n");
        free(*matrixA);
        free(*matrixB);
        fclose(file);
        return 0;
    }

    int count = (*n) * (*n);

    for (int i = 0; i < count; i++) {
        if (!read_next_double(file, &(*matrixA)[i])) {
            printf("Za malo danych dla macierzy A.\n");
            free(*matrixA);
            free(*matrixB);
            fclose(file);
            return 0;
        }
    }

    for (int i = 0; i < count; i++) {
        if (!read_next_double(file, &(*matrixB)[i])) {
            printf("Za malo danych dla macierzy B.\n");
            free(*matrixA);
            free(*matrixB);
            fclose(file);
            return 0;
        }
    }

    fclose(file);
    return 1;
}


int main(int argc, char **argv) {
    char filename[256];
    int n;
    uint64_t loops;
    double *matrixA = NULL;
    double *matrixB = NULL;
    double *matrixC_seq = NULL;
    double *matrixC_avx = NULL;

    if (argc >= 2) {
        strncpy(filename, argv[1], sizeof(filename) - 1);
        filename[sizeof(filename) - 1] = '\0';
    } else {
        printf("Podaj nazwe pliku: ");
        scanf("%255s", filename);
    }

    if (!load_matrices_from_file(filename, &matrixA, &matrixB, &n)) {
        return 1;
    }

    matrixC_seq = allocate_matrix(n);
    matrixC_avx = allocate_matrix(n);

    if (matrixC_seq == NULL || matrixC_avx == NULL) {
        printf("Blad alokacji pamieci na wynik.\n");
        free(matrixA);
        free(matrixB);
        free(matrixC_seq);
        free(matrixC_avx);
        return 1;
    }

    printf("Podaj liczbe powtorzen: ");
    scanf("%" SCNu64, &loops);

    if (loops == 0) {
        loops = 1;
        printf("Niepoprawna liczba powtorzen, ustawiam 1.\n");
    }

    printf("\nRozmiar macierzy: %d x %d\n", n, n);
    printf("Liczba powtorzen: %" PRIu64 "\n", loops);

    uint64_t cycles_seq = run_seq(matrixA, matrixB, matrixC_seq, n, loops);
    uint64_t cycles_avx = run_avx(matrixA, matrixB, matrixC_avx, n, loops);

    printf("Liczba cykli procesora (wynik skalarny): %" PRIu64 "\n", cycles_seq);

    if (cycles_avx == 0) {
        printf("Brak obslugi AVX/FMA albo system nie zapisuje stanu YMM.\n");
        free(matrixA);
        free(matrixB);
        free(matrixC_seq);
        free(matrixC_avx);
        return 0;
    }

    printf("Liczba cykli procesora (wynik AVX/FMA): %" PRIu64 "\n", cycles_avx);

    if (compare_matrices(matrixC_seq, matrixC_avx, n)) {
        printf("Poprawnosc wyniku: macierze sa zgodne\n");
    } else {
        printf("Poprawnosc wyniku: macierze NIE sa zgodne\n");
    }

    printf("\nMacierz po pomnozeniu:\n");
    print_matrix(matrixC_seq, n);

    double speedup = (double)cycles_seq / (double)cycles_avx;

    printf("Szybciej o: %.2f raza/y\n", speedup);

    free(matrixA);
    free(matrixB);
    free(matrixC_seq);
    free(matrixC_avx);

    return 0;
}
