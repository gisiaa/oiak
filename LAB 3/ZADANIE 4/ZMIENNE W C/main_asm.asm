section .text
    global dodaj_do_drugiego_elementu
    global dodaj_zmienne_w_asm

    extern zmienna_c
    extern STALA_C
    extern tablica_c

dodaj_do_drugiego_elementu:
    push rbp
    mov rbp, rsp

    mov eax, dword [zmienna_c]      ; eax = zmienna_c
    add dword [tablica_c + 4], eax  ; tablica_c[1] = tablica_c[1] + zmienna_c

    mov rsp, rbp
    pop rbp
    ret

dodaj_zmienne_w_asm:
    push rbp
    mov rbp, rsp

    mov eax, dword [zmienna_c]
    add eax, dword [STALA_C]

    mov rsp, rbp
    pop rbp
    ret