section .data                                         ; dane zainicjalizowane
    msgZ   db "Podaj liczbe zmiennoprzecinkowa: ", 0  ; rezerwacja bajta (db) na tekst
    fmtZ   db "%lf", 0                                ; long float = double (64 bity)

    msgC   db "Podaj liczbe calkowita: ", 0
    fmtC   db "%ld", 0                                ; ld oznacza wielka liczbe calkowita (long)

    wynikD db "Wynik dodawania: %.2f", 10, 0         ; 10 to enter, 0 to koniec
    wynikO db "Wynik odejmowania: %.2f", 10, 0       ; formatowanie dwoch miejsc po przecinku - %.2f
    wynikM db "Wynik mnozenia: %.2f", 10, 0
    wynikP db "Wynik dzielenia: %.2f", 10, 10, 0

section .bss                                ; pamiec niezainicjalizowana - zostanie przydzielona przez system podczas uruchomienia programu
    liczbaZ resq 1                          ; resq - poczworne slowo (64 bity) dla liczby zmiennoprzecinkowej
    liczbaC resq 1                          ; resq - poczworne slowo (64 bity) dla liczby calkowitej

section .text
    global main                             ; rozpoczecie dzialania programu
    extern printf                           ; uzycie printf
    extern scanf                            ; uzycie scanf itd.
    extern add
    extern substract
    extern multiply
    extern divide

main:
    push rbp                                ; zapisuje wskaznik na stosie, by zabezpieczyc go przed nadpisaniem
    mov  rbp, rsp                           ; wyrownanie stosu

    ; liczba zmiennoprzecinkowa
    mov  rdi, msgZ                          ; wpisujem do rdi adres tekstu
    mov  rax, 0                             ; nie uzywam tu liczb zmiennoprzecinkowych, dlatego podaje 0 w rax, by zabezpieczyc system przed oczekiwaniem na argumenty w rejestrach xmm
    call printf                             ; wyswietlenie tekstu

    mov  rdi, fmtZ                          ; rdi przyjmuje adres formatu odczytu dla liczby zmiennoprzecinkowej (double)
    mov  rsi, liczbaZ                       ; rsi przyjmuje adres zmiennej liczbaZ, gdzie scanf zapisze odczytana liczbe
    mov  rax, 0                             ; nie podaje argumentow w xmm
    call scanf                              ; wywolanie funkcji scanf

    ; liczba calkowita
    mov  rdi, msgC                          ; pytanie o liczbe calkowita, adres tekstu do rdi
    mov  rax, 0                             ; brak liczb zmiennoprzecinkowych, wiec rax = 0
    call printf                             ; wyswietlenie tekstu

    mov  rdi, fmtC                          ; adres formatu odczytu dla liczby calkowitej (long) do rdi
    mov  rsi, liczbaC                       ; kopiujem adres zmiennej liczbaC jako drugi argument do rsi, by scanf mogl zapisac tam odczytana liczbe
    mov  rax, 0                             ; nie uzywam liczb zmiennoprzecinkowych, wiec rax = 0
    call scanf                              ; wywolanie funkcji scanf

    ; dodawanie
    movsd xmm0, qword [liczbaZ]             ; qword -wczytanie 64 bitowej liczby (double) z pamieci pod adresem liczbaZ do rejestru xmm0, gdzie bedzie pierwszy argument dla funkcji dodawania (double)
    mov   rdi, qword [liczbaC]              ; pobieram z pamieci liczbe calkowita i wrzucam ja do rdi, gdzie bedzie drugi argument dla funkcji dodawania (long)
    call  add                               ; funkcja zwroci ulamek w rejestrze xmm0

    mov   rdi, wynikD                       ; wrzucamy do rdi adres tekstu wynikowego dodawania
    mov   rax, 1                            ; ustawiam rax na 1, poniewaz mam 1 argument zmiennoprzecinkowy do wypisania (w xmm0)
    call  printf                            ; wypisanie wyniku dodawania na ekranie, xmm0 jest uzywane przez printf jako argument wynikowy, a rdi jako format tekstu do wypisania, rax jako liczba argumentow zmiennoprzecinkowych do przetworzenia przez printf

    ; odejmowanie
    movsd xmm0, qword [liczbaZ]             ; ponowne zaladowanie liczby zmiennoprzecinkowej do rejestru xmm0
    mov   rdi, qword [liczbaC]              ; ponowne wczytanie liczby calkowitej do rejestru rdi
    call  substract                         ; odejmowanie w c, wynik wraca do rejestru xmm0

    mov   rdi, wynikO                       ; adres tekstu wynikowego odejmowania do rdi
    mov   rax, 1                            ; ustawienie rax na 1, poniewaz mam 1 argument zmiennoprzecinkowy do wypisania (w xmm0)
    call  printf                            ; wypisanie wyniku odejmowania na ekranie, xmm0 jest uzywane przez printf jako argument wynikowy, a rdi jako format tekstu do wypisania, rax jako liczba argumentow zmiennoprzecinkowych do przetworzenia przez printf

    ; mnozenie
    movsd xmm0, qword [liczbaZ]
    mov   rdi, qword [liczbaC]
    call  multiply

    mov   rdi, wynikM
    mov   rax, 1
    call  printf

    ; dzielenie
    movsd xmm0, qword [liczbaZ]
    mov   rdi, qword [liczbaC]
    call  divide

    mov   rdi, wynikP
    mov   rax, 1
    call  printf

    ; koniec programu
    mov  rsp, rbp                           ; przywrocenie wskaznika stosu do stanu sprzed prologu
    pop  rbp                                ; przywrocenie poprzedniej wartosci rbp ze stosu
    mov  rax, 0                             ; ustawienie rax na 0, sukces
    ret                                     ; koniec programu
