section .bss

    input_buffer  resb 64           ; miejsce na tekst wpisany przez uzytkownika
    output_buffer resb 64           ; miejsce na gotowy wynik w szesnastkowym

section .text

    global main

main:
    push rbp                        ; prolog
    mov rbp, rsp

    mov rax, 0                      ; odczytanie danych
    mov rdi, 0                      ; klawiatura
    lea rsi, [input_buffer]         ; adres bufora wejsciowego
    mov rdx, 64                     ; max liczba znakow
    syscall

    cmp rax, 0                      ; if rax = 0, koniec programu
    jle .koniec

    lea rsi, [input_buffer]         ; rsi = wskaznik na pierwsza literke
    mov rcx, rax                    ; licznik, ile znakow wpisano
    dec rcx                         ; dec - decrement - by pozbyc sie znaku ENTERA

    mov rax, 0                      ; zeruje rax
    mov rbx, 10                     ; mnoznik sys dziesietnego

.loop:

    cmp rcx, 0                      ; sprawdzenie, czy wszystkie znaki przerobione
    je .convert_to_hex              ; tak == idziemy zamieniac na hex

    movzx r9, byte [rsi]            ; pobieram 1 bajt zerujac reszte
    cmp r9b, 10                     ; sprawdzam czy to nie enter tak dla pewnosci
    je .convert_to_hex

    sub r9b, 48                     ; 48 to kod zera!!! odjecie daje czysta cyfre

    mul rbx                         ; rax = rax * 10 
    add rax, r9                     ; dodaje pobrana cyfre do calosci

    inc rsi                         ; kolejna literka, inkrementuje ++
    dec rcx                         ; zmniejszam licznik pozostalych liter --
    jmp .loop                       ; wracam

.convert_to_hex:

    lea rdi, [output_buffer]        ; miejsce do zapisu wyniku
    add rdi, 62                     ; ide na koniec bufora by pisac od tylu
    mov byte [rdi], 10              ; enter na koniec
    dec rdi                         ; cofam wskaznik o 1 w lewo

    mov rcx, 16                     ; dzielnik, bo sys 16
    mov r8, 0                       ; licznik dlugosci gotowego tekstu

.hex_loop:

    mov rdx, 0                      ; czyszcze przed dzieleniem
    div rcx                         ; rax = rax / 16, a do rdx wpada reszta z dzielenia!!!

    ; Sprawdzam, czy ta reszta to cyfra albo litera
    cmp dl, 9
    jg .is_letter                   ; jg - skocz jesli wieksze od 9

.is_digit:

    add dl, 48                      ; 48 to kod zera - zamiana na scii
    jmp .save_char

.is_letter:

    add dl, 55                      ; 55 to odleglosc by uzyskac litery od A do F w tabeli 

.save_char:

    mov byte [rdi], dl              ; zapisuje wyliczony znak szesnastkowy
    dec rdi                         ; wskaznik w lewo --, wypisuje od konca
    inc r8                          ; zwiekszam licznik dlugosci tekstu ++

    cmp rax, 0                      ; sprawdzam czy cos z liczby jeszcze zostalo
    jne .hex_loop                   ; jak nie zero to krece sie dalej

.print:

    inc rdi                         ; za duzo w lewo, inkrementuje by poprawic polozenie wskaznika
    inc r8                          ; doliczam enter do dlugosci

    mov rax, 1                      ; wypisanie
    mov rsi, rdi                    ; adres gotowego tekstu (zaczyna sie w rdi, nie na poczatku bufora)
    mov rdi, 1                      ; ekran
    mov rdx, r8                     ; ile znaków wypisac
    syscall

.koniec:
    mov rsp, rbp                    ; epilog funkcji
    pop rbp

    mov rax, 60                     ; wyjscie
    mov rdi, 0                      ; sukces
    syscall