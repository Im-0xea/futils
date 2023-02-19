.equ X, 2
.equ Y, 2

.section .data

.section .text

.global _start

_start:
	mov $X, %rax
	mov %rax, %rbx
	mov $Y, %cx

	.loop:

	mov %rbx, %rdx
	mul %rdx

	dec %cx
	jnz .loop

	mov %rax, %rdi
	mov $60, %rax
	syscall
