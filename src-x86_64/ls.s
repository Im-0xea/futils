.equ buf_s, 4096

.bss
buf:
	.space buf_s

.data
local:
	.string "."

.text

.globl _start

_start:
	mov (%rsp), %r13        # get argc
	add $16, %rsp           # offset argv pointer
	
	cmp $1, %r13            # check if there is any arguments
	jne .file_loop
	lea local, %rdi         # if not load '.' into path
	jmp .open
	.file_loop:
		cmp $1, %r13        # check if argc is under 2
		je .file_end        # end program
		pop %rdi            # pop argument pointer
		dec %r13
	.open:
		mov $0x10000, %rsi  # set open mode for directory
		mov $2, %rax
		syscall             # call open
		test %rax, %rax
		js .fail            # fail check
		
		mov %rax, %rdi      # store fd for folder
		mov %rax, %r8       # store fd for folder
	.getdirents:
		lea buf, %rsi       # load buffer address
		mov $buf_s, %rdx    # load buffer size to count
		mov $217, %rax
		syscall             # call getdents
		test %rax, %rax
		js .fail            # fail check
		
		mov %rsi, %r12      # move buffer address to r12
	.dirent_loop:
		#mov (%r12), %r8    # get d_ino
		movzx 16(%r12), %r9 # get d_reclen
		lea 19(%r12), %r10  # get d_name
		test %r9, %r9
		jz .dirent_end      # if d_reclen is 0 end loop
		add %r9, %r12       # add d_reclen to pointer
		mov %r9, %r13
		sub $22, %r13
		movb $'\n', (%r13,%r10)  # add line break
		inc %r13
		movb $'\0', (%r13,%r10)  # add line break
	.print:
		mov $1, %rdi        # to STDOUT
		mov %r10, %rsi      # get d_name pointer
		mov $1, %rax
		syscall             # call write syscall
		jmp .dirent_loop
	.dirent_end:
		cmp $buf_s, %r12    # check if eob
		je .getdirents      # if so read more dirents
	mov %r8, %rdi           # get fd
	mov $3, %rax
	syscall                 # call close syscall
	jmp .file_loop
	.file_end:
	
	xor %rdi, %rdi
	mov $60, %rax
	syscall                 # call exit syscall
	
	.fail:
	mov $1, %rdi
	mov $60, %rax
	syscall                 # call exit syscall
