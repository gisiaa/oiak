section .bss                    ; zmienne w sekcji .bss nie maja zadnej wartosci
                                ; wartosci zostana przypisane po uruchomieniu programu
    bufor resb 256              ; rezerwacja 256 bajtow

section .text
    global main

main:   
    push rbp                    ;
    mov rbp, rsp

                                ; mov(e) kopiuje zrodlo do celu
    mov rax, 0                  ; odczyt (read)
    mov rdi, 0                  ; wejscie (klawiatura)
    lea rsi, [bufor]            ; adres pustego miejsca
    mov rdx, 256                ; ograniczenie wczytania do max 256 znakow
    syscall                     ; wywolanie systemu operacyjnego

    mov r8, rax                 ; dlugosc wczytanego tekstu kopiuje do r8
    mov rcx, rax                ; kopiuje, by uzyc jako licznika w petli
    lea rbx, [bufor]            ; poczatek wczytanego tekstu

    mov r9, 1

    ; flagi:
    ; jl - skocz, jesli mniejsze
    ; jle - skocz, jesli mniejsze lub rowne
    ; je - skocz, jesli rowne

    ; rax - 64bitowy rejest
    ; eax - 32
    ; ax -16
    ; al - 8 bitow = 1bajt = 1literka

.loop_start:                    ; petla
    cmp rcx, 0                  ; warunek - czy 0? compare
    je .print                   ; jesli tak - wypisuje - koncze sprawdzanie
    
    mov al, byte [rbx]          ; pobranie jednego znaku do rejestru al

; Sprawdzenie, czy sa to wielkie litery

    cmp al, 'A'
    jl .skip                    ; jesli znak ma kod ascii przed 'A' - pomijam
    cmp al, 'Z'
    jle .capital_letter         ; jesli znak znajduje sie pomiedzy 'A' a 'Z' wiem ze to wielka litera
    
; Sprawdzenie, czy sa to male litery
; ta sama logika tylko dla malych literek
    cmp al, 'a'
    jl .skip
    cmp al, 'z'
    jle .small_letter

    jmp .skip

.capital_letter:
    cmp r9, 1                   ; sprawdzenie wartosci
    jne .change_value

    add al, 32                  ; zamieniam wielka litere na mala dodajac do jej kodu ascii 32
    mov byte [rbx], al          ; zamieniam znak w pamieci
    jmp .change_value

.small_letter:
    cmp r9, 1
    jne .change_value
    sub al, 32                  ; zamieniam na mala litere odejmujac od kodu ascii litery liczbe 32
    mov byte [rbx], al          ; zamieniam znak w pamieci

.change_value:
    cmp r9, 1
    je .zero                    ; jesli bylo 1 - zamieniam na 0
    mov r9, 1
    jmp .skip

.zero:
    mov r9, 0                   ; zamiana na 0

.skip:
    inc rbx                     ; increase ++
    dec rcx                     ; decrease --
    jmp .loop_start             ; sprawdzam kolejny znak

.print:
    mov rax, 1                  ; wypisanie
    mov rdi, 1                  ; ekran monitora
    lea rsi, [bufor]            ; adres tekstu, ktory zostal przerobiony
    mov rdx, r8                 ; ilosc znakow zapisana wczesniej w r8
    syscall

    mov rsp, rbp                ;
    pop rbp

    mov rax, 60                 ; wyjscie z programu
    mov rdi, 0                  ; sukces
    syscall