.code64

.section .text

.include "const.s"

.globl _exit    # _exit(rax status)
.globl _pow     # rax _pow(rax x, rcx y)
.globl _strlen  # rcx _strlen(rdi str)
.globl _ioat    # _ioat(rax num, rdi dest, rbx base)
.globl _write   # _write(rbx fd, rdi buf, rdx count)
.globl _puts    # _puts(rdi str)
.globl _fputs   # _fputs(rbx fd, rdi str)
.globl _strcat  # _strcat(rdi dest, rsi tgt)
.globl _open    # rax fd _open(rdi path, rsi flags)
.globl _close   # _close(rdi fd)
.globl _read    # rax cou _read(rdi fd, rsi buffer, rdx count)

_pow: # rax _pow(rax x, rcx y)
	mov %rax, %rbx
	.loop:
		mov %rbx, %rdx
		mul %rdx
		dec %cx
		jnz .loop
	ret

_exit: # _exit(rdi status)
	mov $60, %rax
	syscall

_ioat: # _ioat(rax num, rdi dest, rbx base)
	push %rbp
	mov %rsp, %rbp
	
	xor %rcx, %rcx
	.digit_loop:
		xor %rdx, %rdx
		mov $10, %rbx
		div %rbx
		push %rdx
		inc %rcx
		test %rax, %rax
		jnz .digit_loop
	mov %rcx, %rbx
	xor %rcx, %rcx
	dec %rbx
	.digit_output_loop:
		pop %rax
		add $48, %al
		movb %al, (%rcx, %rdi)
		inc %rcx
		cmp %rcx, %rbx
		jge .digit_output_loop
	
	pop %rbp
	ret

_strlen: # rcx _strlen(rsi str)
	mov $0, %rcx
	mov %rsi, %rax
	jmp .count_loop
	.inc_loop:
		add $1, %rax
		add $1, %rcx
	.count_loop:
		movb (%rax), %dl
		test %dl, %dl
		jne .inc_loop
	ret

_strcat: # _strcat(rdi dest, rsi tgt)
	push %rbp
	mov %rsp, %rbp
	
	call _strlen
	
	.cat_loop:
		mov (%rsi), %rax
		test %rax, %rsi
		jnz .cat_inc_loop
		jmp .cat_done
	
	.cat_inc_loop:
		mov %rax, (%rdi)
		
		inc %rsi
		inc %rdi
		jmp .count_loop
	.cat_done:
	
	pop %rbp
	ret

_puts:   # _puts(rsi str)
	mov $STDOUT, %rdi
_fputs:  # _fputs(rbx fd, rdi str)
	call _strlen
	mov %rcx, %rdx
_write:  # _write(rbx fd, rdi buf, rdx count)
	mov $1, %rax
	syscall
	ret

_read: # rax cou _read(rdi fd, rsi buffer, rdx count)
	mov $0, %rax
	syscall
	ret

_open: # rax fd _open(rdi path, rsi flags)
	mov $2, %rax
	syscall
	ret

_close: # _close(rdi fd)
	mov $3, %rax
	syscall
	ret
