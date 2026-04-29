	.file	"selectionSortO.c"
	.text
	.p2align 4
	.globl	selection_sort_c
	.type	selection_sort_c, @function
selection_sort_c:
.LFB39:
	.cfi_startproc
	endbr64
	cmpl	$1, %edi
	jle	.L10
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$1, %r10d
	leal	-2(%rdi), %ebx
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L6:
	movl	(%rsi,%r9,4), %r11d
	movslq	%r9d, %r8
	cmpl	%r10d, %edi
	jle	.L3
	movq	%r10, %rax
	movl	%r11d, %ecx
	.p2align 4,,10
	.p2align 3
.L5:
	movl	(%rsi,%rax,4), %edx
	cmpl	%ecx, %edx
	jge	.L4
	movl	%edx, %ecx
	movslq	%eax, %r8
.L4:
	addq	$1, %rax
	cmpl	%eax, %edi
	jg	.L5
	cmpl	%r9d, %r8d
	je	.L3
	movl	%r11d, (%rsi,%r8,4)
	movl	%ecx, (%rsi,%r9,4)
.L3:
	leaq	1(%r9), %rax
	addq	$1, %r10
	cmpq	%rbx, %r9
	je	.L14
	movq	%rax, %r9
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L14:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE39:
	.size	selection_sort_c, .-selection_sort_c
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Nie przydzielono pamieci!"
.LC1:
	.string	"r"
.LC2:
	.string	"random_numbers.txt"
.LC3:
	.string	"Nie udalo sie otworzyc pliku!"
.LC4:
	.string	"%d"
.LC5:
	.string	"Pusty plik!"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC6:
	.string	"Wczytano %d liczb z pliku tekstowego.\n"
	.align 8
.LC7:
	.string	"Tablica zostala posortowana - po optymalizacji."
	.align 8
.LC8:
	.string	"Ilosc cykli procesora wynosi: %llu\n\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$2000020, %edi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	call	malloc@PLT
	testq	%rax, %rax
	je	.L24
	leaq	.LC1(%rip), %rsi
	leaq	.LC2(%rip), %rdi
	movq	%rax, %r13
	call	fopen@PLT
	movq	%rax, %r12
	testq	%rax, %rax
	je	.L18
	movq	%r13, %rbx
	xorl	%ebp, %ebp
	leaq	.LC4(%rip), %r14
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L21:
	addl	$1, %ebp
	addq	$4, %rbx
	cmpl	$500005, %ebp
	je	.L20
.L19:
	xorl	%eax, %eax
	movq	%rbx, %rdx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	__isoc99_fscanf@PLT
	cmpl	$1, %eax
	je	.L21
	movq	%r12, %rdi
	call	fclose@PLT
	testl	%ebp, %ebp
	je	.L25
.L22:
	movl	%ebp, %edx
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	xorl	%eax, %eax
	call	start_timer@PLT
	movq	%r13, %rsi
	movl	%ebp, %edi
	movq	%rax, %r12
	call	selection_sort_c
	xorl	%eax, %eax
	call	stop_timer@PLT
	leaq	.LC7(%rip), %rdi
	movq	%rax, %rbx
	call	puts@PLT
	movq	%rbx, %rdx
	movl	$1, %edi
	xorl	%eax, %eax
	subq	%r12, %rdx
	leaq	.LC8(%rip), %rsi
	call	__printf_chk@PLT
	movq	%r13, %rdi
	call	free@PLT
	xorl	%eax, %eax
.L15:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L25:
	.cfi_restore_state
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movq	%r13, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L15
.L20:
	movq	%r12, %rdi
	call	fclose@PLT
	jmp	.L22
.L24:
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L15
.L18:
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	movq	%r13, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L15
	.cfi_endproc
.LFE40:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
