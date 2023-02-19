.section .text

.globl _start

_getnum:
	.num_loop:
		movb (%rsi), %dl
		inc %rsi
		test %dl, %dl
		jne .num_loop
	ret

_start:
	mov (%rsp), %rdx
	add $16, %rsp
	
	cmp $2, %rdx
	je .set_last
	# set first
	cmp $3, %rdx
	je .set_last
	# set increment
	
	.set_last
	
