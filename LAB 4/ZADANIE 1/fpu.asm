section .text
    global get_fpu_control
    global get_fpu_status
    global set_fpu_rounding
    global set_fpu_precision
    global set_fpu_exceptions_mask
    global clear_fpu_exceptions
    global fpu_divide

get_fpu_control: ; odczytuje Control Word, czyli ustawienia FPU
    push rbp                        ; baza ramki stosu, zabezpieczam stary wskaznik
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu
    sub  rsp, 16                    ; rezerwuje 16 bajtow na stosie, by zapisac tan control word

    fnstcw [rbp-8]                  ; store FPU control word - zapisz Control Word FPU do pamięci - zgrywam slowo kontrolne do pamieci na stosie pod rbp-8
    xor  rax, rax                   ; zeruje rax, by upewnic sie, ze nie mam tu smieci, bo funkcja w C zwraca wynik przez rax, a ja chce zwrocic moj control word, ktory jest 16-bitowy, wiec reszta rax musi byc pusta
    mov  ax, [rbp-8]                ; kopiuje slowo kontrolne do ax, by zwrocic je do funkcji w C

    leave                           ; sprzatam ramke stosu
    ret                             ; wracam do programu w C

get_fpu_status: ; odczytuje Status Word, czyli stan/wyjątki FPU
    push rbp                        ; baza ramki stosu, zabezpieczam stary wskaznik
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu

    xor  rax, rax                   ; zeruje caly rax
    fnstsw ax                       ; wpisuje status FPU bezposrednio do rejestru ax - store FPU status word - zapisz Status Word FPU do ax

    pop  rbp                        ; przywracam stary wskaznik
    ret                             ; wracam do C

; tryb zaokraglania
set_fpu_rounding:
    push rbp                        ; zapisuje wskaznik na stosie
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu
    sub  rsp, 16                    ; rezerwuje miejsce na stosie na moja zmienna

    fnstcw [rbp-8]                  ; pobieram obecny stan slowa kontrolnego
    mov  ax, [rbp-8]                ; kopiuje go do rejestru ax

    and  ax, 0xF3FF                 ; zeruje bity 10 i 11 (te od zaokraglania)
    or   ax, di                     ; wpisuje do ax nowa maske z rdi (konkretnie di)
    mov  [rbp-8], ax                ; zapisuje moj nowy stan z powrotem na stos
    fldcw [rbp-8]                   ; i laduje gotowe ustawienia do FPU

    leave                           ; sprzatam ramke
    ret                             ; koncze

; precyzja
set_fpu_precision:
    push rbp                        ; zapisuje wskaznik na stosie
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu
    sub  rsp, 16                    ; robie miejsce na stosie

    fnstcw [rbp-8]                  ; odczytuje stary control word
    mov  ax, [rbp-8]                ; kopiuje do ax

    and  ax, 0xFCFF                 ; bity 8 i 9 odpowiadaja za precyzje, wiec je czyszcze
    or   ax, di                     ; wstawiam moja nowa precyzje z argumentu w rdi
    mov  [rbp-8], ax                ; zapisuje na stos
    fldcw [rbp-8]                   ; wysylam nowe ustawienia precyzji do FPU

    leave                           ; sprzatam
    ret                             ; koncze

; maskowanie wyjatkow
set_fpu_exceptions_mask:
    push rbp                        ; zapisuje wskaznik na stosie
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu
    sub  rsp, 16                    ; robie miejsce na zmienna

    fnstcw [rbp-8]                  ; odczytuje slowo kontrolne
    mov  ax, [rbp-8]                ; kopiuje slowo kontrolne do ax

    and  ax, 0xFFC0                 ; zeruje bity 0-5 (odpowiedzialne za maski wyjatkow)
    or   ax, di                     ; wpisuje moja nowa maske wyjatkow
    mov  [rbp-8], ax                ; odkladam na stos
    fldcw [rbp-8]                   ; wgrywam wszystko do koprocesora

    leave                           ; sprzatam
    ret                             ; koncze

; czyszczenie wyjatkow
clear_fpu_exceptions:
    push rbp                        ; zapisuje wskaznik na stosie, by go zabezpieczyc
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu

    fnclex                          ; czyszcze wyjatki fpu

    pop  rbp                        ; przywracam stary wskaznik
    ret                             ; wracam

; dzielenie dwoch liczb double przez x87 FPU
; double fpu_divide(double a, double b)
fpu_divide:
    push rbp                        ; zapisuje wskaznik na stosie
    mov  rbp, rsp                   ; ustawiam rbp jako baze ramki stosu
    sub  rsp, 16                    ; rezerwuje miejsce na dwie liczby double

    movsd [rbp-8], xmm0             ; pierwszy argument double zapisuje na stosie jako licznik
    movsd [rbp-16], xmm1            ; drugi argument double zapisuje na stosie jako mianownik

    fld  qword [rbp-8]              ; wrzucam licznik na stos FPU
    fdiv qword [rbp-16]             ; dziele ST(0) przez mianownik, czyli robie a / b

    fstp qword [rbp-8]              ; zapisuje wynik z FPU do pamieci i sciagam go ze stosu FPU
    movsd xmm0, [rbp-8]             ; wynik double zwracam do C przez xmm0

    leave                           ; sprzatam ramke
    ret                             ; wracam
