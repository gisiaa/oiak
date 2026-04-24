; przeslanie funkcji z asemblera, by byly dostepne dla programu w c
section .text
    global add
    global substract
    global multiply
    global divide

add:
    push rbp                                ; zabezpieczenie wskaznika na stosie przed nadpisaniem
    mov  rbp, rsp                           ; wyrowanie stosu
    
    cvtsi2sd xmm1, rdi                      ; zamiana liczby calkowitej z rdi na podwojna precyzje zmiennoprzecinkowa w xmm1
    addsd    xmm0, xmm1                     ; dodawanie rejestrow zmiennoprzecinkowych: xmm0 = xmm0 + xmm1
    
    mov  rsp, rbp                           ; czyszcze ramke stosu
    pop  rbp                                ; przywracam wskaznik stosu dla jezyka c
    ret                                     ; wynik dodawania zwracam do rejestru xmm0

substract:
    push rbp
    mov  rbp, rsp
    
    cvtsi2sd xmm1, rdi
    subsd    xmm0, xmm1                     ; odejmuje rejestry zmiennoprzecinkowe: xmm0 = xmm0 - xmm1
    
    mov  rsp, rbp
    pop  rbp
    ret                                     ; wynik odejmowania trafia do rejestru xmm0

multiply:
    push rbp
    mov  rbp, rsp
    
    cvtsi2sd xmm1, rdi
    mulsd    xmm0, xmm1                     ; mnozenie rejestrow zmiennoprzecinkowych: xmm0 = xmm0 * xmm1
    
    mov  rsp, rbp
    pop  rbp
    ret                                     ; wynik mnozenia trafia do xmm0

divide:
    push rbp
    mov  rbp, rsp
    
    cvtsi2sd xmm1, rdi                      ; dzielnik (liczba calkowita) zamieniam na zmiennoprzecinkowa w xmm1
    divsd    xmm0, xmm1                     ; dzielenie rejestrow zmiennoprzecinkowych: xmm0 = xmm0 / xmm1, wynik dzielenia trafia do xmm0
    
    mov  rsp, rbp                           ; przywracam stos do stanu sprzed prologu
    pop  rbp                                ; przywracam wskaznik stosu
    ret                                     ; zwracam wynik dzielenia w rejestrze xmm0