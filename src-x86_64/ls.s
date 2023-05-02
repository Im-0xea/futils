.equ buf_s, 4096

.section .bss
buf:
	.space buf_s

.section .text

.globl _start

_start:
	mov (%rsp), %rdx   # get argc
	add $16, %rsp      # offset argv pointer
	
	.file_loop:
		cmp $1, %rdx   # check if argc is under 2
		je .file_end   # end program
		pop %rdi
		mov $0x10000, %rsi
		
		mov $2, %rax
		syscall        # call open
		test %rax, %rax
		js .fail
		
		mov %rax, %rdi
	.getdirents:
		lea buf, %rsi
		mov $217, %rax
		mov $buf_s, %rdx
		syscall        # call getdents
		test %rax, %rax
		js .fail
		mov %rax, %r13
		
		lea buf, %r12
	.dirent_loop:
		#mov (%r11), %r8 # get d_ino
		#add $16, %r11
		#movzx 16(%r11), %r9 # get d_reclen
		#add $2, %r11
		#mov 18(%r11), %r10 # get d_name
		mov (%r12), %r8
		movzx 16(%r12), %r9
		lea 18(%r12), %r10
		test %r9, %r9
		jz .dirent_end
		add %r9, %r12
		inc %r10
			# strlen
				mov %r10, %rax
				xor %rdx, %rdx
				jmp .count_loop
				.inc_loop:
					inc %rax
					inc %rdx
				.count_loop:
				movb (%rax), %bl
				test %bl, %bl
				jnz .inc_loop
				movb $'\n', (%rax)
				inc %rdx
				inc %rax
				movb $0, (%rax)
			# print
			mov $1, %rdi
			mov %r10, %rsi
			mov $1, %rax
			syscall
			jmp .dirent_loop
		.dirent_end:
		cmp $buf_s, %r12
		jge .getdirents
	.file_end:
	mov %r8, %rdi
	mov $3, %rax
	syscall       # call close syscall
	
	xor %rdi, %rdi
	mov $60, %rax      # call exit syscall
	syscall
	
	.fail:
	mov $1, %rdi
	mov $60, %rax
	syscall
