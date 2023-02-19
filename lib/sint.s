; .equ X, 123456789
; .section .data
; .comm out, 16, 1

.section .text
.globl _start

sint:
	push %rbp
	mov %rsp, %rbp
	
	xor %rcx, %rcx
	.digit_loop:
		xor %rdx, %rdx
		mov $10, %rbx
		div %rbx
		pushq %rdx
		inc %rcx
		test %rax, %rax
		jnz .digit_loop
	mov %rcx, %rbx
	xor %rcx, %rcx
	movb $0, (%rbx, %rdi)
	dec %rbx
	.digit_output_loop:
		popq %rax
		add $48, %al
		movb %al, (%rcx, %rdi)
		inc %rcx
		cmp %rcx, %rbx
		jge .digit_output_loop
	
	pop %rbp
	ret
