section .text
    global start_timer
    global stop_timer
    global find_min_1d_asm
    global find_max_1d_asm

start_timer:
    push rbp
    mov  rbp, rsp
    push rbx            ; cpuid zniszczy rbx, wiec go zapisujemy, by go odzyskac pozniej

    ; serializacja instrukcji przed pomiarem czasu, by zapewnic dokladnosc
    mov  eax, 0         ; ustawiam eax na 0, by cpuid nie oczekiwal argumentow w rejestrach xmm, co mogloby znieksztalcic wynik pomiaru czasu
    cpuid               ; serializuje instrukcje przed pomiarem czasu, by upewnic sie, ze wynik z rdtsc nie zostanie znieksztalcony przez instrukcje wykonane przed pomiarem czasu
    
    rdtsc               ; odczyt licznika czasu do rejestru edx:rax, gdzie edx zawiera starsza czesc, a rax mlodsza czesc 64-bitowego wyniku

    ; 64-bitowe scalanie wyniku
    shl  rdx, 32        ; przesuwam starsza czesc rdx o 32 bity w lewo, by zajela gorna polowe 64-bitowego wyniku
    or   rax, rdx       ; lacze mlodsza czesc rax z przesunieta starsza czescia rdx, by otrzymac pelny 64-bitowy wynik w rax

    pop  rbx            ; odzyskuje rbx
    mov  rsp, rbp       ; przywracam stos do stanu sprzed prologu
    pop  rbp            ; przywracam wskaznik stosu
    ret                 ; zwracam 64-bitowy wynik pomiaru czasu w rejestrze rax

stop_timer:
    push rbp            ; zabezpieczenie wskaznika na stosie przed nadpisaniem
    mov  rbp, rsp       ; wyrowanie stosu
    push rbx            ; cpuid zniszczy rbx, wiec go zapisuje, by go odzyskac pozniej

    rdtscp              ; odczyt licznika czasu do rejestru edx:rax, gdzie edx zawiera starsza czesc, a rax mlodsza czesc 64-bitowego wyniku, 
                        ; dodatkowo rdtscp zapisuje do rcx numer rdzenia procesora, na ktorym jest wykonywany program
    
    ; zapisuje czas, by nie zostal nadpisany przez cpuid
    mov  r8, rdx        ; r8 przechowuje starsza czesc 64-bitowego wyniku z rdtscp
    mov  r9, rax        ; r9 przechowuje mlodsza czesc 64-bitowego wyniku z rdtscp


    ; serializacja instrukcji po pomiarze czasu, by zapewnic dokladnosc
    mov  eax, 0  ; ustawiam eax na 0, by cpuid nie oczekiwal argumentow w rejestrach xmm, co mogloby znieksztalcic wynik pomiaru czasu
    cpuid        ; serializuje instrukcje po pomiarze czasu, by upewnic sie, ze wynik z rdtscp nie zostanie znieksztalcony przez dalsze instrukcje        

    ; odzyskuje czas z rejestrow r8 i r9, by przygotowac go do zwrocenia
    mov  rax, r9        ; rax przyjmuje mlodsza czesc 64-bitowego wyniku z rdtscp
    mov  rdx, r8        ; rdx przyjmuje starsza czesc 64-bitowego wyniku z rdtscp

    ; 64-bitowe scalanie wyniku
    shl  rdx, 32        ; przesuwam starsza czesc rdx o 32 bity w lewo, by zajela gorna polowe 64-bitowego wyniku
    or   rax, rdx       ; lacze mlodsza czesc rax z przesunieta starsza czescia rdx, by otrzymac pelny 64-bitowy wynik w rax

    pop  rbx            ; odzyskuje rbx
    mov  rsp, rbp       ; przywracam stos do stanu sprzed prologu
    pop  rbp            ; przywracam wskaznik stosu
    ret                 ; zwracam 64-bitowy wynik pomiaru czasu w rejestrze rax
