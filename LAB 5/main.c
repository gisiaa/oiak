#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

extern uint64_t run_seq(uint64_t loops);
extern uint64_t run_avx(uint64_t loops);
extern int compare_matrices(void);

int main() {
    uint64_t loops = 100000;

    printf("Liczba powtorzen: %" PRIu64 "\n", loops);

    uint64_t cycles_seq = run_seq(loops);
    uint64_t cycles_avx = run_avx(loops);

    printf("Liczba cykli procesora (wynik skalarny): %" PRIu64 "\n", cycles_seq);

    if (cycles_avx == 0) {
        printf("Brak obslugi AVX/FMA albo system nie zapisuje stanu YMM.\n");
        return 0;
    }

    printf("Liczba cykli procesora (wynik AVX/FMA): %" PRIu64 "\n", cycles_avx);

    if (compare_matrices()) {
        printf("Poprawnosc wyniku: macierze sa zgodne\n");
    } else {
        printf("Poprawnosc wyniku: macierze NIE sa zgodne\n");
    }

    double speedup = (double) cycles_seq / (double) cycles_avx;

    printf("Szybciej o: %.2f raza/y\n", speedup);

    return 0;
}
