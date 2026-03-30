READ_NR equ 0 ; numer wywolania READ
WRITE_NR equ 1 ; numer wywolania WRITE

STDIN equ 0 ; wejscie - klawiatura
STDOUT equ 1 ; weyjscie - ekran

MAX_NUMBERS equ 1024*1024*16
BYTES_PER_NUMBER equ 16 ; 128 bitow -> 16 bajtow
MAX_BYTES equ MAX_NUMBERS * BYTES_PER_NUMBER

; ZMIENNE NIEZAINICJALIZOWANE - miejsce zarezerwowane wypelnione zerami
section .bss
    numbers resb MAX_BYTES ; tablica
    nBytes resq 1 ; 64 bity - poczworne slowo - licznik wczytanych bajtow
    nNumbers resq 1 ; 64 bity - liczba elementow (N)

; ciag liczb do testow: zzzzzzzzzzzzzzzzaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbgggggggggggggggg

section .text
    global main

main:
    push rbp ; zapisuje wskaznik na stosie
    mov rbp, rsp ; nowy wskaznik

    mov rax, READ_NR ; READ
    mov rdi, STDIN ; klawiatura
    mov rsi, numbers ; zapis do tablicy
    mov rdx, MAX_BYTES ; limit rozmiaru
    syscall

    mov [nBytes], rax ; rax - zapisuje liczbe wczytanych bajtow 
    cmp rax, 1
    jl .noDataRead ; skocz, jesli mniejsze rax < 1

    mov rbx, BYTES_PER_NUMBER
    xor rdx, rdx ; 
    div rbx

    cmp rdx, 0
    jne .wrongNumberOfBytes ; skocz jesli nie rowne

    mov [nNumbers], rax ; rax zawiera teraz wyliczone N 

    mov rdi, rax ; rdi - granica N w petli 
    dec rdi ; zmniejszam granice o 1 dekrementujac
    jle .writeResults ; skocz jesli mniejsze lub rowne 0

.sortOuter:
    mov rsi, 0 ; j 
    mov rbx, numbers


.sortInner:
; najwyzsza czesc - bity 96-127, 12
; tu znajduje sie msb - bit znaku
    mov eax, dword [rbx + 12] ; kopiuje gorne 32 bity pierwszego elementu
    cmp eax, dword [rbx + 16 + 12] ; porownuje z gornymi 32 bitami kolejnego elementu

    jl .skipSwap ; skocz jesli mniejsze
    jg .swap ; skocz jesli wieksze -> swapuje

; trzecia czesc - bity 64-95, 8
    mov eax, dword [rbx + 8] 
    cmp eax, dword [rbx + 16 + 8] 

    jb .skipSwap ; skocz jesli nizsze
    ja .swap ; skocz jesli wyzsze

; druga czesc - bity 32-63, 4
    mov eax, dword [rbx + 4] 
    cmp eax, dword [rbx + 16 + 4] 

    jb .skipSwap ; skocz jesli nizsze
    ja .swap ; skocz jesli wyzsze

; najnizsza czesc - bity 0-31, 0
    mov eax, dword [rbx] 
    cmp eax, dword [rbx + 16] 

    jbe .skipSwap ; skocz jesli nizsze badz rowne, odnosi sie do cmp

.swap:

; najnizsza czesc - bity 0-31, 0

; xchg - exchange
    mov eax, dword [rbx] ; kopiuje 4 najnizsze bajty elementu A do eax 
    xchg eax, dword [rbx + 16] ; wymieniam zawartosc eax z najnizszymi 4 bajtami elementu B
    mov dword [rbx], eax ; zapisuje wartosc z B w miejsce A

; druga czesc - bity 32-63, 4

    mov eax, dword [rbx + 4] ; to samo, co powyzej
    xchg eax, dword [rbx + 16 + 4]
    mov dword [rbx + 4], eax

; trzecia czesc - bity 64-95, 8

    mov eax, dword [rbx + 8]
    xchg eax, dword [rbx + 16 + 8]
    mov dword [rbx + 8], eax

; najwyzsza czesc - bity 96-127, 12

    mov eax, dword [rbx + 12]
    xchg eax, dword [rbx + 16 + 12]
    mov dword [rbx + 12], eax

.skipSwap:

    add rbx, BYTES_PER_NUMBER ; przesuwam adres w pamieci, by wskazac kolejny element tab
    inc rsi ; j++
    cmp rsi, rdi ; porownuje j z granica przesuwania N-1
    jb .sortInner ; skocz jesli nizsze j < N - 1
    dec rdi ; dekrementuje by zmniejszyc zakres przeszukiwania omijajac ostatni posortowany juz element
    cmp rdi, 0 ; sprawdzam czy cos jeszcze zostalo do posortowania
    jg .sortOuter ; powtarzam sortowanie

.writeResults:
    mov rax, WRITE_NR
    mov rdi, STDOUT ; deskryptor pliku wyjscie ekran
    mov rsi, numbers ; adres tablicy z posortowanymi liczbami
    mov rdx, [nBytes] ; liczba bajtow do wypisania
    syscall
    mov rax, 0 ; kod sukcesu
    jmp .endProgram

.noDataRead:
    mov rax, 1 ; kod bledu 1 -> rax
    jmp .endProgram

.wrongNumberOfBytes:
    mov rax, 2 ; kod bledu 2 -> rax
    jmp .endProgram

.endProgram:
    mov rsp, rbp ; cofam wskaznik do stanu pierwotnego
    pop rbp 
    ret