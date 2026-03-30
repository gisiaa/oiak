extern printf ; funkcje zewnetrzne z biblioteki C
extern scanf

; DANE ZAINICJALIZOWANE - wartosci znane

section .data
    msg1 db "Podaj zakres gorny przedzialu: ", 0
    fmt1 db "%ld", 0 ; ld - 64bitowa liczba calkowita long
    msg2 db "Liczby pierwsze z przedzialu [2...%ld]: ", 10, 0 ; 10 to znak nowej linii, 0 to ENTER
    fmt2 db "%ld ", 0

; DANE NIEZAINICJALIZOWANE    

section .bss
    number resq 1 ; poczworne slowo
    table resb 1000005

section .text
    global main

main: ; 1x8bajtow
    push rbp ; wskaznik na stosu 2x8
    mov rbp, rsp ; zapisuje wskaznik

; REJESTRY NIEULOTNE - uzywam ich poniewaz funkcje z C niszcza warotisc w rejestrach ulotnych
; w ten sposob chce zabezpieczyc zmienne np licznik w petli
; wartosci rejestrow nieulotnych nie da sie zmienic!!!
; ale trzeba zwrocic je w tym samym stanie - taki wymog
    push r12 ; zapisuje 12 na stos, rsp (wskaznik) maleje o 8 bajtow 3x8
    push r13 ; itd. 4x8
    push r14 ; 5x8
    push r15 ; 6x8

; WYROWNANIE STOSU

; stos musi byc wyrownany do wielokrotnosci 16 bajtow
; jest poniewaz 6x8 = 48bajtow - wielokrotnosc 16

; funkcja napisana w C -> kolejnosc przekazywania argumentow: rdi, rsi, rdx, rcx...

mov rdi, msg1
mov rax, 0 ; zeruje rax - brak wartosci zmiennoprzecinkowych
call printf

mov rdi, fmt1 ; %ld
mov rsi, number ; adres pamieci do ktorego wpisze liczbe trafia do rsi
mov rax, 0 ; brak liczb zmiennoprzecinkowych
call scanf

mov r15, [number] ; [] - pobieranie wartosci spod adresu, nie adresu

mov rcx, 2 ; licznik petli (i = 2) c w rcx pochodzi od COUNTER

.ONEloop: ; wypelniam tablice 1
    cmp rcx, r15 ; (compare) porownuje licznik z gornym zakresem N
    jg .TWO ; SKOCZ JESI WIEKSZE i > N

    mov byte [table + rcx], 1 ; byte - 8 bitow, [table + rcx] przesuniecie w pamieci o wartosc z rej rcx
    inc rcx ; inkrementuje licznik

    jmp .ONEloop ; bezwarunkowy skok na poczatek petli

.TWO:
    mov r12, 2 ; wstawiam (kopiujac) 2 do rejestru r12, bo sito liczy od 2 (najmniejsza liczba pierwsza)

.SITOloop:
    mov rax, r12; kopiuje i do rax
    imul rax, r12; mnoze i*i
    cmp rax, r15 ; sprawdzam, czy i*i <=N
    jg .ENDSITOloop ; jesli wynik mnozenia wiekszy, koniec wykreslania wielokrotnosci

    cmp byte [table + r12], 1 ; srpawdzam czy aktualna wartosc liczby jest dalej rowna 1
    jne .SKIPSITOINNERloop ; skocz, jesli nierowne 1

    mov r13, rax; r13 odpowiada teraz j = i*i

.SITOINNERloop:
    cmp r13, r15 ; porownuje wielokrotnosc j z N
    jg .SKIPSITOINNERloop; przerywam petle, jesli j > N 
    mov byte [table + r13], 0 ; wykreslam liczbe z sita, ustawiajac n na 0 (false)
    add r13, r12 ; przechodze do kolejnej wieloktonosci j = j + 1
    jmp .SITOINNERloop

.SKIPSITOINNERloop:
    inc r12 ; zwiekszam licznik petli
    jmp .SITOloop ; powrot do petli zewnetrznej

.ENDSITOloop:
    mov rdi, msg2 ; print
    mov rsi, r15 ; N trafia jako argument liczbowy
    mov rax, 0
    call printf

    mov r12, 2 ; resetuje licznik i na 2

.PRINTloop:
    cmp r12, r15; sprawdzam, czy i <= N
    jg .ENDPRINTloop ; koniec wypisywania, caly zakres sprawdzony

    cmp byte [table + r12], 1; sprawdzam, czy znajduje sie pod tym adresem liczba pierwsza
    jne .SKIPPRINTloop; jesli nie, SKIP

    mov rdi, fmt2 ; %ld
    mov rsi, r12 ; znaleziona liczba pierwsza
    mov rax, 0
    call printf

.SKIPPRINTloop:
    inc r12 ; spr kolejna liczbe w tablicy
    jmp .PRINTloop ; powtarzam

.ENDPRINTloop:
    ; ostatni na wejsciu, pierwszy na wyjsciu
    pop r15 ; zdejmuje r15 ze stosu, wskaznik rsp zwieksza sie o 8 bajtow
    pop r14 ; itd
    pop r13 ;
    pop r12 ;

    mov rsp, rbp ; resetuje wskaznik stosu
    pop rbp ; zdejmuje wskaznik - niszcze ramke stosu, bo bez tego ret pobraloby losowe liczby

    mov rax, 0 ; kod sukcesu, wyjscie z programu
    ret