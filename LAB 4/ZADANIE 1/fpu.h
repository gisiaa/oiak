#ifndef FPU_UTILS_H
#define FPU_UTILS_H

#include <stdint.h>

// bity 10 i 11 to zaokraglanie (Round Control)
#define FPU_ROUND_NEAREST 0x0000 // zaokraglam do najblizszej wartosci (to jest domyslne)
#define FPU_ROUND_DOWN    0x0400 // zaokraglam do -inf
#define FPU_ROUND_UP      0x0800 // zaokraglam do +inf
#define FPU_ROUND_ZERO    0x0C00 // po prostu ucinam reszte

// bity 8 i 9 to precyzja (Precision Control)
#define FPU_PRECISION_24B 0x0000 // single precision (24 bity)
#define FPU_PRECISION_53B 0x0200 // double precision (53 bity)
#define FPU_PRECISION_64B 0x0300 // double extended precision (64 bity) - domyslne

// bity 0-5 odpowiadaja za wyjatki
#define FPU_EX_INVALID    0x0001 // zla operacja (invalid)
#define FPU_EX_DENORMAL   0x0002 // moja liczba jest zdenormalizowana
#define FPU_EX_ZERODIVIDE 0x0004 // probuje dzielic przez 0
#define FPU_EX_OVERFLOW   0x0008 // mam przepelnienie
#define FPU_EX_UNDERFLOW  0x0010 // mam niedomiar
#define FPU_EX_PRECISION  0x0020 // trace precyzje

// wszystkie maski wyjatkow razem
// jezeli bit maski ma wartosc 1, to wyjatek jest zamaskowany
// jezeli bit maski ma wartosc 0, to wyjatek jest odmaskowany
#define FPU_EX_ALL_MASKS  0x003F

// funkcje z asemblera
extern uint16_t get_fpu_control(void);
extern uint16_t get_fpu_status(void);
extern void set_fpu_rounding(uint16_t mode);
extern void set_fpu_precision(uint16_t precision);
extern void set_fpu_exceptions_mask(uint16_t mask);
extern void clear_fpu_exceptions(void);

// dzielenie wykonywane przez x87 FPU
extern double fpu_divide(double a, double b);

#endif
