#include <stdio.h>

double add(double a, long b) {
    return a + (double)b;
}

double substract(double a, long b) {
    return a - (double)b;
}

double multiply(double a, long b) {
    return a * (double)b;
}

double divide(double a, long b) {
    if (b == 0) {
        printf("Dzielenie przez zero!\n");
        return 0.0;
    }
    return a / (double)b;
}