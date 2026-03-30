extern printf
extern scanf

; zaimportowalam by uzywac printf oraz scanf z jezyka C

; rezerwowanie pamieci dla stalych liczb oraz lancucha znakow
; DANE ZAINICJALIZOWANE
section .data
    msg db "Podaj dwie liczby: ", 0
    ; msg - adres w pamieci
    ; db - 8 bitow na znak
    ; 0 - znak NULL, dla funkcji printf
    fmt1 db "%ld %ld", 0
    ; %ld - long int - 64bitowe liczby calkowite

    fmt2 db "NWD(%ld, %ld) = %ld", 10, 0
    ; 10 - kod ASCII \n

; DANE NIEZAINICJALIZOWANE
section .bss
    ; block started by symbol - miejsce zostanie przydzielone podczas uruchomienia programu i wypelnione zerami

    number1 resq 1 ; typ danych bss - rezerwuje 1 poczwórne słowo do przechowywania pierwszej liczby
    number2 resq 1

section .text
    global main

main:

    push rbp ; wskaznik bazowy

    mov rbp, rsp ; kopiuje (mov) i ustawiam wskaznik bazowy na aktualny wierzcholek stosu (rsp)

    push rbx
    push rcx ; wyrownanie stosu

    ; Wyswietlenie pytania o wartosci liczb

    mov rdi, msg ; pierwszy argument trafia do rejestru rdi - przekazuje adres msg
    mov rax, 0 ; liczba rejestrow zmiennoprzecinkowych
    call printf ; wywolanie funkcji printf

    ; Wczytanie liczb

    mov rdi, fmt1 ; przekazuje do rdi adres %ld %ld
    mov rsi, number1 ; przekazuje adres zmiennej number1, pod ktory scanf ma wpisac dane?
    mov rdx, number2 ; przekazuje adres zmiennej number2
    mov rax, 0 ; brak wartosci zmiennoprzecinkowych - 0
    call scanf ; wywolanie funkcji scanf

    ; ALGORYTM NWD

    mov rax, [number1] ; zabranie z adresu number1 wartosci, ktora sie tam znajduje
    mov rbx, [number2]

    ; PETLA

NWDloop:

    cmp rbx, 0; cmp (compare) porownuje wartosc w rbx z 0 | while(b!=0) | robi to za pomoca odejmowania
    je exit ; skocz jesli rowne, jesli rbx to 0 program idzie do exit

    mov rdx, 0 ; zeruje liczbe, by przy dzieleniu uniknac bledu spowodowanego losowymi liczbami, ktore moga sie znajdowac w tym rejestrze
    idiv rbx ; dziele rejest rdx:rax przez rbx, wynik trafia do rejestru rax, a reszta z dzielenia (mod) trafia do rdx
    mov rax, rbx ; a = pom - kopiuje b z rej rbx do 'a' (rax)
    mov rbx, rdx ; b = a % b - kopiuje reszte z dzielnia z rdx do b
    jmp NWDloop ; skok do poczatku petli

; WYPISANIE WYNIKU

exit: ; wynik znajduje sie w rej rax

    mov rdi, fmt2 ; adres z formatem wypisania
    mov rsi, [number1] ; pobieram z pamieci pierwszej wpisanej wartosci
    mov rdx, [number2] ; pobieram z pamieci drugiej wpisanej wartosci
    mov rcx, rax ; przenosze wynik NWD z rax do rcx
    mov rax, 0 ; prtinf wymaga ilu rejestrow xmm (zmiennoprzecinkowych liczb) bede uzywac - w tym przypadku 0
    call printf

    pop rcx ;  zdejmuje pusty rejestr
    pop rbx ; 
    mov rsp, rbp ; przywracam wskaznik stosu, bo inaczej pobierze ze stosu losowe liczby
    pop rbp ; zdejmuje liczby ze stosu
    mov rax, 0 ; kod wyjscia - sukces
    ret
