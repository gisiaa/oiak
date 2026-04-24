section .data
    global zmienna_asm     ; eksportuje zmienna, by bylo ja widac w C
    global STALA_ASM
    
    ; definiuje zmienna w pamieci (32-bitowa, bo int w C ma 32 bity), ktora bedzie przechowywac wartosc, do ktorej dodam stala zdefiniowana w C
    ; dd oznacza "define double word", czyli rezerwuje 4 bajty (32 bity) w pamieci dla tej zmiennej, i inicjalizuje ja wartoscia 10
    zmienna_asm dd 10      
    
    ; definiuje stala w pamieci (32-bitowa, bo int w C ma 32 bity), ktora bedzie dodawana do zmiennej_asm w funkcji dodaj_w_asm
    STALA_ASM   dd 90      

section .text
    ; sluzy do wyslania danych