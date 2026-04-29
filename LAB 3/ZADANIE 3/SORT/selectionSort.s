	.file	"selectionSort.c"
	.text
	.globl	selection_sort_c
	.type	selection_sort_c, @function
selection_sort_c:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L2
.L7:
	movl	-16(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.L3
.L5:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jge	.L4
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
.L4:
	addl	$1, -12(%rbp)
.L3:
	movl	-12(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L5
	movl	-8(%rbp), %eax
	cmpl	-16(%rbp), %eax
	je	.L6
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
.L6:
	addl	$1, -16(%rbp)
.L2:
	movl	-16(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L7
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	selection_sort_c, .-selection_sort_c
	.section	.rodata
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
	.align 8
.LC6:
	.string	"Wczytano %d liczb z pliku tekstowego.\n"
.LC7:
	.string	"Tablica zostala posortowana."
	.align 8
.LC8:
	.string	"Ilosc cykli procesora wynosi: %llu\n\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	$500005, -44(%rbp)
	movl	-44(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L9
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L10
.L9:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	jne	.L11
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L10
.L11:
	movl	$0, -48(%rbp)
	jmp	.L12
.L14:
	addl	$1, -48(%rbp)
	movl	-48(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jge	.L16
.L12:
	movl	-48(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	cmpl	$1, %eax
	je	.L14
	jmp	.L13
.L16:
	nop
.L13:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	cmpl	$0, -48(%rbp)
	jne	.L15
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L10
.L15:
	movl	-48(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	call	start_timer@PLT
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rdx
	movl	-48(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	selection_sort_c
	movl	$0, %eax
	call	stop_timer@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	subq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
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
