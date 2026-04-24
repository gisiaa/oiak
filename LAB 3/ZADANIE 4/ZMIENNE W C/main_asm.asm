section .text
    global dodaj_w_asm     ; eksportuje funkcje, by byla widoczna dla kodu w C
    extern zmienna_c       ; importuje zmienne
    extern STALA_C

dodaj_w_asm:
    push rbp ; zabezpieczenie wskaznika na stosie przed nadpisaniem
    mov rbp, rsp ; wyrowanie stosu

    ; wczytuje wartosc zmiennej z C do rejestru eax, by moc ja przetwarzac w asemblerze
    ; dword, poniewaz zmienna_c jest typu int, czyli 4 bajty (32 bity), a rejestr eax jest 32-bitowy, wiec wczytuje 4 bajty z pamieci do eax
    mov eax, dword [zmienna_c] 
    
    ; dodaje do wartosci w rejestrze eax wartosc stala zdefiniowana w C, ktora jest przechowywana w pamieci pod adresem STALA_C, i zapisuje wynik z powrotem do rejestru eax
    add eax, dword [STALA_C]    
    
    ; zwraca wynik dodawania w rejestrze eax, bo rejestr eax jest uzywany do zwracania wartosci calkowitych (int)
    mov rsp, rbp ; przywracam stos do stanu sprzed prologu
    pop rbp ; przywracam wskaznik stosu
    ret ; zwracam wynik dodawania w rejestrze eax
