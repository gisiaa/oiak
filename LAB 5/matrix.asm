section .data                                  ; dane
    align 32                                   ; wyrownuje do 32 bajtow
    matrixA     dq     1.,  3.,  5.,  7.       
                dq     9., 11., 13., 15.       
                dq    17., 19., 21., 23.       
                dq    25., 27., 29., 31.       

    matrixB     dq     2.,  4.,  6.,  8.       
                dq    10., 12., 14., 16.       
                dq    18., 20., 22., 24.       
                dq    26., 28., 30., 32.       

section .bss                                   ; rezerwuje miejsce w pamieci
    alignb 32                                  ; wyrownuje rezerwowane miejsce do 32 bajtow
    matrixC_seq resq    16                     ; rezerwuje miejsce na wynik wersji skalarnej
    matrixC_avx resq    16                     ; rezerwuje miejsce na wynik wersji AVX

section .text                                  
    global run_seq                             ; do uzycia w C
    global run_avx                             
    global compare_matrices                    


run_seq:                                       ; wersja skalarna
    push rbp                                   ; zapisuje stare rbp na stosie
    mov  rbp, rsp                              ; ustawiam rbp jako baze stosu
    push rbx                                   ; zabezpieczam rbx przed zmiana
    sub  rsp, 40                               ; rezerwuje miejsce na stosie (40 bajtow)

    mov  [rbp-16], rdi                         ; zapisuje liczbe powtorzen

    ; zaczynam pomiar czasu
    xor  eax, eax                              ; zeruje eax
    cpuid                                      ; porzadkuje instrukcje i pobieram informacje o CPU
    rdtsc                                      ; pobieram licznik cykli na starcie
    shl  rdx, 32                               ; przesuwam starsza czesc wyniku
    or   rax, rdx                              ; skladam licznik cykli w calosc
    mov  [rbp-24], rax                         ; zapisuje czas startowy

    ; ustawiam argumenty dopiero po rdtsc, bo cpuid niszczy czesc rejestrow
    mov  rdi, matrixA                          ; ustawiam adres macierzy A
    mov  rsi, matrixB                          ; ustawiam adres macierzy B
    mov  rdx, matrixC_seq                      ; ustawiam adres wyniku skalarnego
    mov  rcx, [rbp-16]                         ; ustawiam licznik powtorzen

.loop_seq:                                     ; zaczynam petle powtorzen wersji skalarnej
    ; zabezpieczam argumenty, zeby kolejne powtorzenia zawsze mialy te same adresy
    push rcx                                   ; zapisuje licznik petli
    push rdx                                   ; zapisuje adres wyniku
    push rsi                                   ; zapisuje adres macierzy B
    push rdi                                   ; zapisuje adres macierzy A
    call seq_multi4x4                          ; wywoluje wersje skalarna
    pop  rdi                                   ; przywracam adres macierzy A
    pop  rsi                                   ; przywracam adres macierzy B
    pop  rdx                                   ; przywracam adres wyniku
    pop  rcx                                   ; przywracam licznik petli

    dec  rcx                                   ; wykonuje ten krok programu
    jnz  .loop_seq                             ; wracam do petli jesli jeszcze nie koniec

    ; koncze pomiar czasu
    rdtscp                                     ; pobieram licznik cykli na koncu
    shl  rdx, 32                               ; przesuwam starsza czesc wyniku (shift left 32 bity w lewo)
    or   rax, rdx                              ; skladam licznik cykli w calosc (mlodze bity z rax, starsze z rdx)
    mov  [rbp-32], rax                         ; zapisuje albo pobieram czas koncowy
    xor  eax, eax                              ; zeruje eax
    cpuid                                      ; porzadkuje instrukcje i pobieram info o CPU

    mov  rax, [rbp-32]                         ; zapisuje albo pobieram czas koncowy
    sub  rax, [rbp-24]                         ; licze roznice cykli

    add  rsp, 40                               ; zwalniam miejsce na stosie
    pop  rbx                                   ; przywracam rbx
    pop  rbp                                   ; przywracam rbp
    ret                                        ; wracam do funkcji wywolujacej


run_avx:                                       ; zaczynam funkcje dla wersji AVX
    push rbp                                   ; zapisuje stare rbp na stosie
    mov  rbp, rsp                              ; ustawiam rbp jako baze stosu
    push rbx                                   ; zabezpieczam rbx przed zmiana
    sub  rsp, 40                               ; rezerwuje miejsce na stosie

    mov  [rbp-16], rdi                         ; zapisuje liczbe powtorzen

    call check_avx_fma                         ; sprawdzam czy AVX/FMA jest dostepne
    cmp  rax, 0                                ; sprawdzam wynik poprzedniej funkcji
    je   .no_avx                               ; skacze jesli warunek jest spelniony

    ; zaczynam pomiar czasu
    xor  eax, eax                              ; zeruje eax
    cpuid                                      ; porzadkuje instrukcje i pobieram info o CPU
    rdtsc                                      ; pobieram licznik cykli na starcie
    shl  rdx, 32                               ; przesuwam starsza czesc wyniku
    or   rax, rdx                              ; skladam licznik cykli w calosc
    mov  [rbp-24], rax                         ; zapisuje czas startowy

    ; ustawiam argumenty dopiero po rdtsc, bo cpuid niszczy czesc rejestrow
    mov  rdi, matrixA                          ; ustawiam adres macierzy A
    mov  rsi, matrixB                          ; ustawiam adres macierzy B
    mov  rdx, matrixC_avx                      ; ustawiam adres wyniku AVX
    mov  rcx, [rbp-16]                         ; ustawiam licznik powtorzen

.loop_avx:                                     ; zaczynam petle powtorzen wersji AVX
    ; zabezpieczam argumenty, bo avx_multi4x4 przesuwa rsi podczas czytania macierzy B
    push rcx                                   ; zapisuje licznik petli
    push rdx                                   ; zapisuje adres wyniku
    push rsi                                   ; zapisuje adres macierzy B
    push rdi                                   ; zapisuje adres macierzy A
    call avx_multi4x4                          ; wywoluje wersje AVX
    pop  rdi                                   ; przywracam adres macierzy A
    pop  rsi                                   ; przywracam adres macierzy B
    pop  rdx                                   ; przywracam adres wyniku
    pop  rcx                                   ; przywracam licznik petli

    dec  rcx                                   ; wykonuje ten krok programu
    jnz  .loop_avx                             ; wracam do petli jesli jeszcze nie koniec

    ; koncze pomiar czasu
    rdtscp                                     ; pobieram licznik cykli na koncu
    shl  rdx, 32                               ; przesuwam starsza czesc wyniku
    or   rax, rdx                              ; skladam licznik cykli w calosc
    mov  [rbp-32], rax                         ; zapisuje albo pobieram czas koncowy
    xor  eax, eax                              ; zeruje eax
    cpuid                                      ; porzadkuje instrukcje i pobieram info o CPU
    vzeroupper                                 ; czyszcze gorna czesc rejestrow AVX

    mov  rax, [rbp-32]                         ; zapisuje albo pobieram czas koncowy
    sub  rax, [rbp-24]                         ; licze roznice cykli
    jmp  .done                                 ; przeskakuje do wskazanego fragmentu

.no_avx:                                       ; trafiam tutaj gdy AVX/FMA nie dziala
    xor  rax, rax                              ; zeruje rax

.done:                                         ; wspolne zakonczenie funkcji
    add  rsp, 40                               ; zwalniam miejsce na stosie
    pop  rbx                                   ; przywracam rbx
    pop  rbp                                   ; przywracam rbp
    ret                                        ; wracam do funkcji wywolujacej

; porownuje 16 elementow macierzy wynikowej
compare_matrices:                              ; zaczynam porownywanie macierzy
    mov  rdi, matrixC_seq                      ; ustawiam pierwsza macierz do porownania
    mov  rsi, matrixC_avx                      ; ustawiam druga macierz do porownania
    mov  rcx, 16                               ; ustawiam 16 elementow do sprawdzenia

.loop_cmp:                                     ; zaczynam petle porownywania elementow
    mov  r8, [rdi]                             ; pobieram element z pierwszej macierzy
    mov  r9, [rsi]                             ; pobieram element z drugiej macierzy

    cmp  r8, r9                                ; porownuje dwa elementy
    jne  .not_equal                            ; skacze jesli wartosci sa rozne

    add  rdi, 8                                ; przechodze do kolejnego elementu pierwszej macierzy
    add  rsi, 8                                ; przechodze do kolejnego elementu drugiej macierzy
    loop .loop_cmp                             ; zmniejszam rcx i wracam do petli

    mov  eax, 1                                ; zwracam 1 jako sukces
    ret                                        ; wracam do funkcji wywolujacej

.not_equal:                                    ; trafiam tutaj gdy macierze sa rozne
    xor  eax, eax                              ; zeruje eax
    ret                                        ; wracam do funkcji wywolujacej


; sprawdzam AVX, FMA, OSXSAVE i stan XMM/YMM w XCR0
check_avx_fma:                                 ; zaczynam sprawdzanie AVX i FMA
    push rbx                                   ; zabezpieczam rbx przed zmiana

    mov  eax, 1                                ; zwracam 1 jako sukces
    cpuid                                      ; porzadkuje instrukcje i pobieram info o CPU

    bt   ecx, 27                               ; sprawdzam bit OSXSAVE
    jnc  .no                                   ; skacze jesli bit nie byl ustawiony

    bt   ecx, 28                               ; sprawdzam bit AVX
    jnc  .no                                   ; skacze jesli bit nie byl ustawiony

    bt   ecx, 12                               ; sprawdzam bit FMA
    jnc  .no                                   ; skacze jesli bit nie byl ustawiony

    xor  ecx, ecx                              ; zeruje ecx przed xgetbv
    xgetbv                                     ; sprawdzam ustawienia systemu dla AVX
    and  eax, 6                                ; zostawiam tylko bity XMM i YMM
    cmp  eax, 6                                ; sprawdzam czy XMM i YMM sa wlaczone
    jne  .no                                   ; skacze jesli wartosci sa rozne

    mov  eax, 1                                ; zwracam 1 jako sukces
    pop  rbx                                   ; przywracam rbx
    ret                                        ; wracam do funkcji wywolujacej

.no:                                           ; trafiam tutaj gdy czegos brakuje
    xor  eax, eax                              ; zeruje eax
    pop  rbx                                   ; przywracam rbx
    ret                                        ; wracam do funkcji wywolujacej


; funkcja do wolnego mnozenia macierzy 4x4
; wersja skalarna: operacje na pojedynczych elementach double
seq_multi4x4:                                  ; zaczynam skalarne mnozenie macierzy
    push rbp                                   ; zapisuje stare rbp na stosie
    mov  rbp, rsp                              ; ustawiam rbp jako baze stosu

    mov  r8, 0                                 ; ustawiam i na 0

.loop_i:                                       ; zaczynam petle po wierszach
    cmp  r8, 4                                 ; sprawdzam czy i doszlo do 4
    jge  .done_seq                             ; skacze gdy licznik doszedl do konca

    mov  r9, 0                                 ; ustawiam j na 0

.loop_j:                                       ; zaczynam petle po kolumnach
    cmp  r9, 4                                 ; sprawdzam czy j doszlo do 4
    jge  .next_i                               ; skacze gdy licznik doszedl do konca

    pxor xmm0, xmm0                            ; zeruje sume w xmm0
    mov  r10, 0                                ; ustawiam k na 0

.loop_k:                                       ; zaczynam petle po k
    cmp  r10, 4                                ; sprawdzam czy k doszlo do 4
    jge  .store_seq                            ; skacze gdy licznik doszedl do konca

    ; adres A[i][k]
    mov  rax, rdi                              ; biore adres macierzy A
    mov  r11, r8                               ; kopiuje i do rejestru pomocniczego
    imul r11, 32                               ; licze przesuniecie wiersza
    add  rax, r11                              ; dodaje przesuniecie do adresu
    mov  r11, r10                              ; kopiuje k do rejestru pomocniczego
    shl  r11, 3                                ; licze przesuniecie elementu double
    add  rax, r11                              ; dodaje przesuniecie do adresu
    movsd xmm1, qword [rax]                    ; wczytuje element z macierzy A

    ; adres B[k][j]
    mov  rax, rsi                              ; biore adres macierzy B
    mov  r11, r10                              ; kopiuje k do rejestru pomocniczego
    imul r11, 32                               ; licze przesuniecie wiersza
    add  rax, r11                              ; dodaje przesuniecie do adresu
    mov  r11, r9                               ; kopiuje j do rejestru pomocniczego
    shl  r11, 3                                ; licze przesuniecie elementu double
    add  rax, r11                              ; dodaje przesuniecie do adresu
    movsd xmm2, qword [rax]                    ; wczytuje element z macierzy B

    mulsd xmm1, xmm2                           ; mnoze dwa elementy
    addsd xmm0, xmm1                           ; dodaje iloczyn do sumy

    inc  r10                                   ; zwiekszam k
    jmp  .loop_k                               ; przeskakuje do wskazanego fragmentu

.store_seq:                                    ; zapisuje gotowy element macierzy C
    ; adres C[i][j]
    mov  rax, rdx                              ; biore adres macierzy C
    mov  r11, r8                               ; kopiuje i do rejestru pomocniczego
    imul r11, 32                               ; licze przesuniecie wiersza
    add  rax, r11                              ; dodaje przesuniecie do adresu
    mov  r11, r9                               ; kopiuje j do rejestru pomocniczego
    shl  r11, 3                                ; licze przesuniecie elementu double
    add  rax, r11                              ; dodaje przesuniecie do adresu
    movsd qword [rax], xmm0                    ; zapisuje obliczony wynik do macierzy C

    inc  r9                                    ; zwiekszam j
    jmp  .loop_j                               ; przeskakuje do wskazanego fragmentu

.next_i:                                       ; przechodze do nastepnego wiersza
    inc  r8                                    ; zwiekszam i
    jmp  .loop_i                               ; przeskakuje do wskazanego fragmentu

.done_seq:                                     ; koncze wersje skalarna
    pop  rbp                                   ; przywracam rbp
    ret                                        ; wracam do funkcji wywolujacej


; funkcja do wektorowego mnozenia macierzy
; wersja AVX/FMA: jednoczesnie licze cale wiersze macierzy C
avx_multi4x4:                                  ; zaczynam wektorowe mnozenie macierzy
    push rbp                                   ; zapisuje stare rbp na stosie
    mov  rbp, rsp                              ; ustawiam rbp jako baze stosu

    xor  rax, rax                              ; zeruje rax
    mov  rcx, 4                                ; ustawiam licznik na 4

    vxorpd ymm12, ymm12, ymm12                 ; zeruje pierwszy wiersz wyniku
    vxorpd ymm13, ymm13, ymm13                 ; zeruje drugi wiersz wyniku
    vxorpd ymm14, ymm14, ymm14                 ; zeruje trzeci wiersz wyniku
    vxorpd ymm15, ymm15, ymm15                 ; zeruje czwarty wiersz wyniku

.loop_avx_calc:                                ; zaczynam petle obliczen AVX
    vmovapd ymm0, [rsi]                        ; wczytuje caly wiersz macierzy B

    vbroadcastsd ymm1, [rdi+rax]               ; rozrzucam element z pierwszego wiersza A
    vfmadd231pd ymm12, ymm1, ymm0              ; dodaje iloczyn do pierwszego wiersza C

    vbroadcastsd ymm1, [rdi+32+rax]            ; rozrzucam element z drugiego wiersza A
    vfmadd231pd ymm13, ymm1, ymm0              ; dodaje iloczyn do drugiego wiersza C

    vbroadcastsd ymm1, [rdi+64+rax]            ; rozrzucam element z trzeciego wiersza A
    vfmadd231pd ymm14, ymm1, ymm0              ; dodaje iloczyn do trzeciego wiersza C

    vbroadcastsd ymm1, [rdi+96+rax]            ; rozrzucam element z czwartego wiersza A
    vfmadd231pd ymm15, ymm1, ymm0              ; dodaje iloczyn do czwartego wiersza C

    add  rax, 8                                ; przechodze do kolejnego elementu A
    add  rsi, 32                               ; przechodze do kolejnego wiersza B
    loop .loop_avx_calc                        ; zmniejszam rcx i wracam do petli

    vmovapd [rdx], ymm12                       ; zapisuje pierwszy wiersz wyniku
    vmovapd [rdx+32], ymm13                    ; zapisuje drugi wiersz wyniku
    vmovapd [rdx+64], ymm14                    ; zapisuje trzeci wiersz wyniku
    vmovapd [rdx+96], ymm15                    ; zapisuje czwarty wiersz wyniku

    pop  rbp                                   ; przywracam rbp
    ret                                        ; wracam do funkcji wywolujacej
