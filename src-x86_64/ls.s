.equ buf_s 4096

.section .bss
buf:
	.spaces buf_s

.section .text

.globl _start

_start:
	mov (%rsp), %rdx   # get argc
	add $16, %rsp      # offset argv pointer
	
	.file_loop:
		cmp $1, %rdx   # check if argc is under 2
		je .file_end   # end program
		pop %rdi
		mov $0x02004000 , %rsi
		
		mov $2, %rax
		syscall        # call open
	
	.getdirents
		mov %rax, %rdi
		lea $buf_s, %rsi
		mov $78, %rax
		syscall        # call getdents
	.dirent_loop:
		# add offset to rsi (d_reclen)
		# check inode number for zero is yes jmp .dirent_loop
		# print d_name
		cmp %rsi
		# if rsi = buf_s jmp to getdirents again
		# if rsi = buf + rax of getdents
		jmp .dirent_loop
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
