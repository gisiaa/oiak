	.file	"main.c"
	.text
	.globl	find_min_1d
	.type	find_min_1d, @function
find_min_1d:
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
	cmpl	$0, -20(%rbp)
	jg	.L2
	movl	$0, %eax
	jmp	.L3
.L2:
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L4
.L6:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jle	.L5
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
.L5:
	addl	$1, -4(%rbp)
.L4:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L6
	movl	-8(%rbp), %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	find_min_1d, .-find_min_1d
	.globl	find_max_1d
	.type	find_max_1d, @function
find_max_1d:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	cmpl	$0, -20(%rbp)
	jg	.L8
	movl	$0, %eax
	jmp	.L9
.L8:
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L10
.L12:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jge	.L11
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -8(%rbp)
.L11:
	addl	$1, -4(%rbp)
.L10:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L12
	movl	-8(%rbp), %eax
.L9:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	find_max_1d, .-find_max_1d
	.globl	find_min_2d
	.type	find_min_2d, @function
find_min_2d:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -24(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, %rcx
	movl	$0, %ebx
	cmpl	$0, -52(%rbp)
	jle	.L14
	cmpl	$0, -56(%rbp)
	jg	.L15
.L14:
	movl	$0, %eax
	jmp	.L16
.L15:
	movq	-64(%rbp), %rdx
	movl	(%rdx), %edx
	movl	%edx, -36(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L17
.L21:
	movl	$0, -28(%rbp)
	jmp	.L18
.L20:
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	imulq	%rcx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-64(%rbp), %rdx
	addq	%rdx, %rcx
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rcx,%rdx,4), %edx
	cmpl	%edx, -36(%rbp)
	jle	.L19
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	imulq	%rcx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-64(%rbp), %rdx
	addq	%rdx, %rcx
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rcx,%rdx,4), %edx
	movl	%edx, -36(%rbp)
.L19:
	addl	$1, -28(%rbp)
.L18:
	movl	-28(%rbp), %edx
	cmpl	-52(%rbp), %edx
	jl	.L20
	addl	$1, -32(%rbp)
.L17:
	movl	-32(%rbp), %edx
	cmpl	-56(%rbp), %edx
	jl	.L21
	movl	-36(%rbp), %eax
.L16:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	find_min_2d, .-find_min_2d
	.globl	find_max_2d
	.type	find_max_2d, @function
find_max_2d:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -24(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, %rcx
	movl	$0, %ebx
	cmpl	$0, -52(%rbp)
	jle	.L23
	cmpl	$0, -56(%rbp)
	jg	.L24
.L23:
	movl	$0, %eax
	jmp	.L25
.L24:
	movq	-64(%rbp), %rdx
	movl	(%rdx), %edx
	movl	%edx, -36(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L26
.L30:
	movl	$0, -28(%rbp)
	jmp	.L27
.L29:
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	imulq	%rcx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-64(%rbp), %rdx
	addq	%rdx, %rcx
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rcx,%rdx,4), %edx
	cmpl	%edx, -36(%rbp)
	jge	.L28
	movl	-28(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	imulq	%rcx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-64(%rbp), %rdx
	addq	%rdx, %rcx
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rcx,%rdx,4), %edx
	movl	%edx, -36(%rbp)
.L28:
	addl	$1, -28(%rbp)
.L27:
	movl	-28(%rbp), %edx
	cmpl	-52(%rbp), %edx
	jl	.L29
	addl	$1, -32(%rbp)
.L26:
	movl	-32(%rbp), %edx
	cmpl	-56(%rbp), %edx
	jl	.L30
	movl	-36(%rbp), %eax
.L25:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	find_max_2d, .-find_max_2d
	.section	.rodata
	.align 8
.LC0:
	.string	"Pami\304\231\304\207 nie zosta\305\202a przydzielona dla tablicy jednowymiarowej"
.LC1:
	.string	"r"
.LC2:
	.string	"one-dimensional_array.txt"
	.align 8
.LC3:
	.string	"Nie uda\305\202o si\304\231 otworzy\304\207 pliku!"
.LC4:
	.string	"%d"
	.align 8
.LC5:
	.string	"WYNIKI DLA TABLICY JEDNOWYMIAROWEJ:"
.LC6:
	.string	"Minimum: %d\nMaksimum: %d\n"
.LC7:
	.string	"Liczba cykli dla 1D: %lu\n\n"
	.align 8
.LC8:
	.string	"Nie przydzielono pamieci dla 2D!"
.LC9:
	.string	"two-dimensional_array.txt"
	.align 8
.LC10:
	.string	"Nie uda\305\202o si\304\231 otworzy\304\207 pliku two-dimensional_array.txt!"
	.align 8
.LC11:
	.string	"WYNIKI DLA TABLICY DWUWYMIAROWEJ:"
.LC12:
	.string	"Liczba cykli dla 2D: %lu\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$120, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movl	$20000000, -124(%rbp)
	movl	$4500, -120(%rbp)
	movl	$4500, -116(%rbp)
	movl	-124(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -104(%rbp)
	cmpq	$0, -104(%rbp)
	jne	.L32
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L33
.L32:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -96(%rbp)
	cmpq	$0, -96(%rbp)
	jne	.L34
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L33
.L34:
	movl	$0, -136(%rbp)
	jmp	.L35
.L36:
	movl	-136(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-104(%rbp), %rax
	addq	%rax, %rdx
	movq	-96(%rbp), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	addl	$1, -136(%rbp)
.L35:
	movl	-136(%rbp), %eax
	cmpl	-124(%rbp), %eax
	jl	.L36
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	call	start_timer@PLT
	movq	%rax, -88(%rbp)
	movq	-104(%rbp), %rdx
	movl	-124(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	find_min_1d
	movl	%eax, -112(%rbp)
	movq	-104(%rbp), %rdx
	movl	-124(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	find_max_1d
	movl	%eax, -108(%rbp)
	call	stop_timer@PLT
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	subq	-88(%rbp), %rax
	movq	%rax, -72(%rbp)
	movl	-108(%rbp), %edx
	movl	-112(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-72(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	-116(%rbp), %ebx
	movslq	%ebx, %rax
	subq	$1, %rax
	movq	%rax, -64(%rbp)
	movslq	%ebx, %rax
	movq	%rax, %r12
	movl	$0, %r13d
	movl	-120(%rbp), %eax
	imull	-116(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -56(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L37
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L33
.L37:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -48(%rbp)
	cmpq	$0, -48(%rbp)
	jne	.L38
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L33
.L38:
	movl	$0, -132(%rbp)
	jmp	.L39
.L42:
	movl	$0, -128(%rbp)
	jmp	.L40
.L41:
	movl	-132(%rbp), %eax
	movslq	%eax, %rdx
	movslq	%ebx, %rax
	imulq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movl	-128(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movq	-48(%rbp), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	addl	$1, -128(%rbp)
.L40:
	movl	-128(%rbp), %eax
	cmpl	-116(%rbp), %eax
	jl	.L41
	addl	$1, -132(%rbp)
.L39:
	movl	-132(%rbp), %eax
	cmpl	-120(%rbp), %eax
	jl	.L42
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	call	start_timer@PLT
	movq	%rax, -88(%rbp)
	movq	-56(%rbp), %rdx
	movl	-116(%rbp), %ecx
	movl	-120(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	find_min_2d
	movl	%eax, -112(%rbp)
	movq	-56(%rbp), %rdx
	movl	-116(%rbp), %ecx
	movl	-120(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	find_max_2d
	movl	%eax, -108(%rbp)
	call	stop_timer@PLT
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	subq	-88(%rbp), %rax
	movq	%rax, -40(%rbp)
	movl	-108(%rbp), %edx
	movl	-112(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
.L33:
	addq	$120, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
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
