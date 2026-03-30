section .bss

    bufor_wejscie resb 64           ; miejsce na wczytany tekst
    wynik         resq 1            ; miejsce w pamieci ram, przeznaczone dla liczby binarnej
    bufor_wyjscie resb 32           ; miejsce na tekst, ktory zostanie wyswietlony

section .text
    global main

main:
    push rbp                        ; prolog
    mov rbp, rsp

    ; zadanie 5a	
    
    mov rax, 0                      ; odczyt
    mov rdi, 0                      ; klawiatura
    lea rsi, [bufor_wejscie]        ; adres pustego miejsca
    mov rdx, 64                     ; max 64 znaki
    syscall

    mov rcx, rax                    ; licznik wczytanych znakow
    dec rcx                         ; dekrementuje by pozbyc sie entera
    lea rbx, [bufor_wejscie]        ; rbx- wskaznik na wczytywany znak
    mov r8, 0                       ; r8 ustawiam na 0, tu bedzie liczba

.ascii_to_number:

    cmp rcx, 0                      ; sprawdzam czy to wszystkie znaki
    je .save_to_memory              ; tak == zapisuje w pamieci

    mov r9, 0
    mov r9b, byte [rbx]             ; pobieram znak i czyszcze reszte rejestru
    sub r9b, 48                     ; odejmuje 48 by zamienic znak na cyfre
    
    imul r8, 10                     ; mnoze, by stworzyc miejsce
    add r8, r9                      ; dodaje nowa cyfre

    inc rbx                         ; increase ++ (biore nastepny znak)
    dec rcx                         ; decrease -- (zmniejszam licznik liter)
    jmp .ascii_to_number            ; wracam po nastepna cyfre jesli taka jest

.save_to_memory:

    lea r10, [wynik]                ; pobranie adresu zmiennej wynikowej z pamieci
    mov [r10], r8                   ; zapisuje w pamieci


    ; zadanie 5b
    
    
    mov rax, [r10]                  ; pobieram wartosc z pamieci do rax
    mov r11, 10                     ; dziele przez 10

    lea rbx, [bufor_wyjscie]        ; rbx = wskaznik na bufor do wypisania
    add rbx, 31                     ; koniec bufora
    mov byte [rbx], 10              ; dodaje enter
    mov r10, 1                      ; licznik odpowiadajacy za znaki juz zmienione

.number_to_ascii:

    dec rbx                         ; cofam wskaznik w lewo przed zapisem cyfry --
    mov rdx, 0                      ; ZAWSZE zeruje reszte (rdx) przed dzieleniem (div)
    div r11                         ; rax / 10 (wynik idzie do rax, reszta do rdx)

    add rdx, 48                     ; dodaje 48 - zamieniam spowrotem na kod ascii
    mov [rbx], dl                   ; zapisuje literke do bufora

    inc r10                         ; zwiekszam licznik gotowych znakow ++
    cmp rax, 0                      ; sprawdzam czy wszystkie elementy zostaly podzielone
    jne .number_to_ascii            ; if != 0 powtarzam

.print:
    mov rax, 1                      ; wypisanie
    mov rdi, 1                      ; ekran
    mov rsi, rbx                    ; adres poczatku tekstu
    mov rdx, r10                    ; ilosc znakow wraz z enterem
    syscall

.koniec:
    mov rsp, rbp                    ; epilog funkcji
    pop rbp

    mov rax, 60                     ; wyjscie z programu
    mov rdi, 0                      ; sukces
    syscall