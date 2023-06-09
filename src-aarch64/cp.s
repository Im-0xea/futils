.equ buf_s 4096

.bss
buf:
	.space buf_s

.text

.globl _start

_start:
	ldr w30, [sp]
	mov x25, 16
	
	cmp w30, 2
	beq .file_end
	blt .fail
	.file_loop:
		cmp w30, 2
		beq .copy_to
		sub w30, w30, 1
		ldr x1, [sp, x25]
		add x25, x25, 8
	.open:

	
	mov w0, 0                // code 0
	mov x8, 93
	svc 0                    // call exit syscall
	
	.fail:
	mov w0, 1                // code 1
	mov x8, 93
	svc 0                    // call exit syscall
