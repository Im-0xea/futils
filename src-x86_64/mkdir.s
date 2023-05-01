.section .text

.globl _start

_start:
	mov (%rsp), %rdx    # get argc
	add $16, %rsp       # offset argv pointer
	
	.file_loop:
		cmp $1, %rdx    # check if argc is under 2
		je .file_end    # end program
		dec %rdx        # decrement argc
		pop %rdi        # get argument pointer
		mov $0777, %rsi # set new directory mode to 0777
		mov $83, %rax
		syscall         # call mkdir syscall
		test %rax, %rax
		js .fail
		jmp .file_loop
	.file_end:
	xor %rdi, %rdi
	mov $60, %rax
	syscall             # call exit syscall
	
	.fail:
	mov $1, %rdi
	mov $60, %rax
	syscall             # call exit syscall
