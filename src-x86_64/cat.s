.equ buf_s, 4096

.section .bss

buf:
	.space buf_s

.section .text

.globl _start

_start:
	mov (%rsp), %r8      # get argc
	add $16, %rsp        # offset argv pointer
	
	.file_loop:
		cmp $1, %r8      # check if argc is under 2
		je .file_end     # end program
		
		dec %r8          # decrement argc
		
		pop %rdi         # load current path into rdi
		xor %rsi, %rsi   # clear flags
		mov $2, %rax
		syscall          # call open syscall
		test %rax, %rax  
		js .fail         # when negative fail
		
		mov %rax, %r9    # get new fd
		lea buf, %rsi    # load buffer address to rsi
	.read_loop:
		mov %r9, %rdi    # load the fd
		mov $buf_s, %rdx # set read count to buffer size
		xor %rax, %rax
		syscall          # call read syscall
		test %rax, %rax  
		jz .read_end     # if eof stop reading
		js .fail         # when negative fail
		
		mov $1, %rdi     # set fd to STDOUT
		mov %rax, %rdx   # set count to the bytes read 
		mov $1, %rax
		syscall          # call write syscall
		cmp $buf_s, %rdx # if read is under size stop
		jge .read_loop
	.read_end:
		mov %r9, %rdi    # get fd
		mov $3, %rax
		syscall          # call close syscall
		jmp .file_loop
	.file_end:
	
	xor %rdi, %rdi       # code 0
	mov $60, %rax
	syscall              # call exit syscall
	
	.fail:
	mov $1, %rdi         # code 1
	mov $60, %rax
	syscall              # call exit syscall
