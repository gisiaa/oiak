section .text
    global run_seq
    global run_avx
    global compare_matrices


; double *A, double *B, double *C, int n, uint64_t loops
run_seq:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40

    mov  r12, rdi                 ; zapisuje adres macierzy A
    mov  r13, rsi                 ; zapisuje adres macierzy B
    mov  r14, rdx                 ; zapisuje adres macierzy C
    movsxd r15, ecx               ; zapisuje rozmiar macierzy n
    mov  [rbp-48], r8             ; zapisuje liczbe powtorzen

    xor  eax, eax
    cpuid
    rdtsc
    shl  rdx, 32
    or   rax, rdx
    mov  [rbp-56], rax            ; zapisuje czas startowy

.loop_seq:
    mov  rdi, r12                 ; ustawiam adres macierzy A
    mov  rsi, r13                 ; ustawiam adres macierzy B
    mov  rdx, r14                 ; ustawiam adres macierzy C
    mov  rcx, r15                 ; ustawiam rozmiar n
    call seq_multiply             ; licze mnozenie skalarne jeden raz

    dec  qword [rbp-48]           ; zmniejszam liczbe powtorzen
    jnz  .loop_seq                ; wracam, jesli jeszcze nie koniec

    rdtscp
    shl  rdx, 32
    or   rax, rdx
    mov  [rbp-64], rax            ; zapisuje czas koncowy
    xor  eax, eax
    cpuid

    mov  rax, [rbp-64]
    sub  rax, [rbp-56]            ; licze roznice cykli

    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret


; uint64_t run_avx(double *A, double *B, double *C, int n, uint64_t loops)
run_avx:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40

    mov  r12, rdi                 ; zapisuje adres macierzy A
    mov  r13, rsi                 ; zapisuje adres macierzy B
    mov  r14, rdx                 ; zapisuje adres macierzy C
    movsxd r15, ecx               ; zapisuje rozmiar macierzy n
    mov  [rbp-48], r8             ; zapisuje liczbe powtorzen

    call check_avx_fma
    cmp  rax, 0
    je   .no_avx

    xor  eax, eax
    cpuid
    rdtsc
    shl  rdx, 32
    or   rax, rdx
    mov  [rbp-56], rax            ; zapisuje czas startowy

.loop_avx:
    mov  rdi, r12                 ; ustawiam adres macierzy A
    mov  rsi, r13                 ; ustawiam adres macierzy B
    mov  rdx, r14                 ; ustawiam adres macierzy C
    mov  rcx, r15                 ; ustawiam rozmiar n
    call avx_multiply             ; licze mnozenie AVX jeden raz

    dec  qword [rbp-48]           ; zmniejszam liczbe powtorzen
    jnz  .loop_avx                ; wracam, jesli jeszcze nie koniec

    rdtscp
    shl  rdx, 32
    or   rax, rdx
    mov  [rbp-64], rax            ; zapisuje czas koncowy
    xor  eax, eax
    cpuid
    vzeroupper

    mov  rax, [rbp-64]
    sub  rax, [rbp-56]            ; licze roznice cykli
    jmp  .done

.no_avx:
    xor  rax, rax                 ; zwracam 0, gdy AVX/FMA nie dziala

.done:
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret


; int compare_matrices(double *C1, double *C2, int n)
compare_matrices:
    movsxd rdx, edx               ; rozszerzam n do 64 bitow
    mov  rcx, rdx
    imul rcx, rdx                 ; rcx = n * n

.loop_cmp:
    cmp  rcx, 0
    je   .equal

    mov  r8, [rdi]                ; pobieram element z pierwszej macierzy
    mov  r9, [rsi]                ; pobieram element z drugiej macierzy
    cmp  r8, r9
    jne  .not_equal

    add  rdi, 8                   ; przechodze do kolejnego elementu
    add  rsi, 8                   ; przechodze do kolejnego elementu
    dec  rcx
    jmp  .loop_cmp

.equal:
    mov  eax, 1
    ret

.not_equal:
    xor  eax, eax
    ret


; sprawdzam AVX, FMA i stan XMM/YMM
check_avx_fma:
    push rbx

    mov  eax, 1
    cpuid

    bt   ecx, 27                  ; OSXSAVE
    jnc  .no

    bt   ecx, 28                  ; AVX
    jnc  .no

    bt   ecx, 12                  ; FMA
    jnc  .no

    xor  ecx, ecx
    xgetbv
    and  eax, 6
    cmp  eax, 6
    jne  .no

    mov  eax, 1
    pop  rbx
    ret

.no:
    xor  eax, eax
    pop  rbx
    ret


; void seq_multiply(double *A, double *B, double *C, int n)
seq_multiply:
    xor  r8d, r8d                 ; i = 0

.loop_i:
    cmp  r8, rcx
    jge  .done_seq

    xor  r9d, r9d                 ; j = 0

.loop_j:
    cmp  r9, rcx
    jge  .next_i

    pxor xmm0, xmm0               ; suma = 0
    xor  r10d, r10d               ; k = 0

.loop_k:
    cmp  r10, rcx
    jge  .store_seq

    mov  rax, r8
    imul rax, rcx
    add  rax, r10
    shl  rax, 3
    movsd xmm1, qword [rdi+rax]   ; A[i][k]

    mov  rax, r10
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    movsd xmm2, qword [rsi+rax]   ; B[k][j]

    mulsd xmm1, xmm2
    addsd xmm0, xmm1

    inc  r10
    jmp  .loop_k

.store_seq:
    mov  rax, r8
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    movsd qword [rdx+rax], xmm0   ; C[i][j]

    inc  r9
    jmp  .loop_j

.next_i:
    inc  r8
    jmp  .loop_i

.done_seq:
    ret


; void avx_multiply(double *A, double *B, double *C, int n)
avx_multiply:
    xor  r8d, r8d                 ; i = 0

.loop_i_avx:
    cmp  r8, rcx
    jge  .done_avx

    xor  r9d, r9d                 ; j = 0

.loop_j_avx:
    mov  r11, rcx
    sub  r11, 4
    cmp  r9, r11
    jg   .tail_j

    vxorpd ymm0, ymm0, ymm0       ; zeruje sume
    xor  r10d, r10d               ; k = 0

.loop_k_avx:
    cmp  r10, rcx
    jge  .store_avx

    mov  rax, r10
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    vmovupd ymm1, [rsi+rax]       ; wczytuje 4 elementy B[k][j..j+3]

    mov  rax, r8
    imul rax, rcx
    add  rax, r10
    shl  rax, 3
    vbroadcastsd ymm2, [rdi+rax]  ; powielam A[i][k] na caly wektor

    vfmadd231pd ymm0, ymm2, ymm1  ; suma += A[i][k] * B[k][j..j+3]

    inc  r10
    jmp  .loop_k_avx

.store_avx:
    mov  rax, r8
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    vmovupd [rdx+rax], ymm0       ; zapisuje 4 elementy wyniku

    add  r9, 4
    jmp  .loop_j_avx

.tail_j:
    cmp  r9, rcx
    jge  .next_i_avx

    vxorpd xmm0, xmm0, xmm0       ; suma = 0 dla koncowki
    xor  r10d, r10d               ; k = 0

.tail_k:
    cmp  r10, rcx
    jge  .store_tail

    mov  rax, r8
    imul rax, rcx
    add  rax, r10
    shl  rax, 3
    vmovsd xmm1, qword [rdi+rax]  ; A[i][k]

    mov  rax, r10
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    vmovsd xmm2, qword [rsi+rax]  ; B[k][j]

    vmulsd xmm1, xmm1, xmm2
    vaddsd xmm0, xmm0, xmm1

    inc  r10
    jmp  .tail_k

.store_tail:
    mov  rax, r8
    imul rax, rcx
    add  rax, r9
    shl  rax, 3
    vmovsd qword [rdx+rax], xmm0  ; zapisuje pojedynczy element z koncowki

    inc  r9
    jmp  .tail_j

.next_i_avx:
    inc  r8
    jmp  .loop_i_avx

.done_avx:
    ret
