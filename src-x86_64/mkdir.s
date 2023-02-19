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
		mov $83, %rax   # call mkdir syscall
		syscall
		jmp .file_loop
	.file_end:
	xor %rdi, %rdi
	mov $60, %rax       # call exit syscall
	syscall
