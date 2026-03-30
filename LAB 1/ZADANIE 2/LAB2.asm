section .bss
    input_buffer  resb 64               ; miejsce na tekst wpisany przez uzytkownika
    output_buffer resb 65               ; miejsce przeznaczone na wypisanie wyniku zera jedynki +1

section .text
    global main                      

main:                                 
    push rbp                            ; prolog
    mov rbp, rsp

    mov rax, 0                          ; odczytanie danych
    mov rdi, 0                          ; klawiatura
    lea rsi, [input_buffer]             ; adresowanie wzgledne, bo adres w pamieci ram sie zmienial
    mov rdx, 64                         ; max liczba znakow
    syscall

    cmp rax, 0                          ; if rax = 0, koniec programu
    jle .koniec

    mov rcx, rax                        ; licznik, ile znakow wpisano
    dec rcx                             ; pozbywamy sie znaku ENTERA

    lea rbx, [input_buffer]             ; pobranie adresu bufora wejsciowego lea wczytuje adres
    mov r8, 0                           ; miejsce na wynik liczby, zaczynam od 0

.read_loop:
    cmp rcx, 0                          ; sprawdzenie wszystkich znakow
    je .print                           ; jesli tak, wypisuje 

    mov r9, 0                           ; czyszcze przed pobraniem nowego znaku
    mov r9b, byte [rbx]                 ; pobieram 1 bajt

    ; Sprawdzam, czy to cyfra czy litera
    cmp r9b, '9'                        
    jg .is_letter                       ; Jeśli kod znaku > 9 to mam litere 

    ; Sprawdzenie dla cyfr
    sub r9b, 48                         ; zamiana na odpowiadajaca cyfre (0-9)
    jmp .add_to_result                   

.is_letter:
    sub r9b, 55                         ; zamiana literek od A do F na liczby

.add_to_result:
    imul r8, 16                         ; przesuniecie w lewo (mnozenie przez 16 to jak przesuniecie w systemie hex)
    add r8, r9                          ; dodanie nowej cyfry

    inc rbx                             ; przejscie do kolejnego znaku
    dec rcx                             ; zmniejszenie licznika petli
    jmp .read_loop                       

; zamiana liczby na tekst
.print:
    mov rax, r8                         ; kopiuje liczbe
    mov r11, 2                          ; dzielnik

    lea rbx, [output_buffer]            ; wczytanie adresu poczatku
    add rbx, 64                         ; przesuniecie na sam koniec bufora

    mov byte [rbx], 10                  ; dodaje znak nowej linii (enter)
    dec rbx                             ; dekrementuje cofajac sie w lewo
    mov r10, 1                          ; licznik gotowych znakow


.divide_loop:
    mov rdx, 0                          ; przed div ZAWSZE trzeba wyzerowac rejestr rdx!
    div r11                             ; dzielenie przez 10 

    add rdx, 48                         ; reszta z dzielenia (w rdx) zamieniana na kod ascii
    mov byte [rbx], dl                  ; zapisanie znaku do bufora

    dec rbx                             ; przesuniecie w lewo dla kolejnej cyferki
    inc r10                             ; zwiekszenie licznika znakow

    cmp rax, 0                          ; czy mamy jeszcze z czego dzielic?
    jne .divide_loop                    ; jesli nie, wracam po kolejna cyfre

.result:
    inc rbx                             ; zwiekszam, bo petla zrobila jedno 'dec' za duzo

    mov rax, 1                          ; wypisanie
    mov rdi, 1                          ; ekrna
    mov rsi, rbx                        ; adres pierwszego wypisywanego znaku
    mov rdx, r10                        ; ilosc znakow
    syscall

.koniec:
    mov rsp, rbp                        ; epilog funkcji
    pop rbp

    mov rax, 60                         ; wyjscie
    mov rdi, 0                          ; sukces
    syscall