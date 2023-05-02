
.equ buf_s, 4096

.section .bss

buf:
	.space buf_s

.section .text

.globl _start

_start:
	ldr w30, [sp]
	add sp, sp, 16
	eor x25, x25, x25
	
	cmp w30, 1
	bne .file_loop
	eor x29, x29, x29
	adr x28, buf
	b .read_loop
	.file_loop:
		cmp w30, 1
		beq .file_end
		
		sub w30,w30, 1
		
		ldr x1, [sp, x25]
		add x25, x25, 8
		
		eor x2, x2, x2
		mov x0, -100
		mov x8, 56
		svc 0
		cmp x0, 0
		blt .fail
		
		mov x27, x0
		ldr x1, =buf
	.read_loop:
		mov x0, x27
		mov w2, buf_s
		mov x8, 63
		svc 0
		cmp x0, 0
		beq .read_end
		blt .fail
		
		mov x2, x0
		mov x0, 1
		mov x8, 64
		svc 0
		cmp x0, buf_s
		beq .read_loop
	.read_end:
		mov x0, x27
		mov x8, 57
		svc 0
		b .file_loop
	.file_end:
	
	.file_end:
	mov w0, 0
	mov x8, 93
	svc 0
	
	.fail:
	mov w0, 1
	mov x8, 93
	svc 0
