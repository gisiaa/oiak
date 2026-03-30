READ_NR    equ 0    ; numer wywolania READ
WRITE_NR   equ 1    ; numer wywolania WRITE
EXIT_NR    equ 60   ; numer wywolania EXIT 

STDIN      equ 0    ; wejscie - klawiatura
STDOUT     equ 1    ; wyjscie - ekran

BUFOR_SIZE equ 10
BASE       equ 10

; ZMIENNE ZAINICJALIZOWANE
section .data
    outputBufor db "Fibonacci:                  ", 10
    outputBuforLen equ $ - outputBufor ;od obecnego adresu pamieci odejmuje adres poczatku i otrzymuje dlugosc bufora

; ZMIENNE NIEZAINICJALIZOWANE
section .bss
    bufor resb BUFOR_SIZE ; miejsce na wpisywana liczbe

section .text
    global main

main:
    push rbp ; zapisuje wskaznik na stosie
    mov rbp, rsp ; nowy wskaznik

    call processInputNumber ; wczytuje i parsuje z klaw, N -> rax
    
    mov rdi, rax ; przekazuje argument N do rdi dla wywolania funkcji
    call fibo ; oblicza N-ta liczbe, zwraca wynik -> rax

    call processOutputNumber ; konwertuje rax na tekst do bufora wyjsciowego

.out:
    mov rax, WRITE_NR ; WRITE
    mov rdi, STDOUT ; ekran
    mov rsi, outputBufor ; adres tekstu do wypisania
    mov rdx, outputBuforLen ; limit rozmiaru
    syscall

    mov rax, EXIT_NR ; EXIT
    mov rdi, 0 ; kod sukcesu
    syscall

fibo:
    push rbp ; zapisuje wskaznik na stosie
    mov rbp, rsp ; nowy wskaznik
    
    push rbx ; zachowuje nieulotny rejestr rbx na stosie
    push r12 ; zachowuje nieulotny rejestr r12 na stosie

    cmp rdi, 2 ; sprawdzam czy n < 2
    jl .base_case ; skocz jesli mniejsze (dla 0 i 1 fib(n) = n)

.recur:
    mov rbx, rdi ; zachowuje n w rbx na pozniej
    
    dec rdi ; zmniejszam o 1 (n - 1)
    call fibo ; fibo(n-1)
    mov r12, rax ; zachowuje wynik fibo(n-1) w r12

    mov rdi, rbx ; przywracam pierwotne n do rdi
    sub rdi, 2 ; zmniejszam o 2 (n - 2)
    call fibo ; fibo(n-2)

    add rax, r12 ; fibo(n-2) + fibo(n-1)
    jmp .quit_fibo ; skok by pominac warunek bazowy

.base_case:
    mov rax, rdi ; wynik -> rax

.quit_fibo:
    pop r12 ; przywracam zachowane rejestry w odwrotnej kolejnosci
    pop rbx
    
    mov rsp, rbp ; cofam wskaznik do stanu pierwotnego
    pop rbp
    ret

processInputNumber:
    push rbp 
    mov rbp, rsp 

    mov rax, READ_NR ; READ
    mov rdi, STDIN ; klawiatura
    mov rsi, bufor ; zapis do tablicy
    mov rdx, BUFOR_SIZE ; limit rozmiaru
    syscall

    xor rax, rax ; 0 -> rax (czyszcze przed uzyciem)
    xor rdi, rdi ; 0 -> rdi (czyszcze licznik)
    xor rcx, rcx ; 0 -> rcx (czyszcze rejestr na bajt)
    mov rbx, BASE ; 10 -> rbx (mnoznik)

.L1:
    mov cl, byte [bufor + rdi] ; pobieram jeden znak do cl
    cmp cl, 10 ; sprawdzam czy enter
    je .L2 ; skocz jesli rowne
    cmp cl, 0 ; sprawdzam czy koniec
    je .L2 ; skocz jesli rowne

    sub cl, '0' ; konwertuje kod znaku ascii na cyfre
    mul rbx ; mnoze calosc przez baze (rax * 10)
    add rax, rcx ; dodaje nowa cyfre -> rax

    inc rdi ; j++
    jmp .L1 ; powtarzam

.L2:
    mov rsp, rbp ; cofam wskaznik
    pop rbp
    ret

processOutputNumber:
    push rbp
    mov rbp, rsp

    mov rbx, BASE ; 10 -> rbx (dzielnik)
    mov rcx, outputBuforLen - 2 ; zaczynam od tylu, omijajac \n

.L3:
    xor rdx, rdx ; zeruje rdx przed dzielem, reszta z div trafia tu
    div rbx ; rax / 10 -> reszta do rdx
    add dl, '0' ; konwertuje cyfre na kod ascii
    mov byte [outputBufor + rcx], dl ; zapisuje kod znaku pod adres wyjsciowy
    dec rcx ; cofam o jedno miejsce w lewo
    cmp rax, 0 ; czy wynik dzielenia wynosi 0
    jne .L3 ; skocz jesli nierowne powtarzam tak dlugo az sa jakies cyfry

    mov rsp, rbp ; cofam wskaznik
    pop rbp
    ret