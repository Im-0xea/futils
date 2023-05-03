.equ buf_s, 4096

.section .bss
buf:
	.space buf_s

.section .data
local:
	.string "."

.section .text

.globl _start

_start:
	ldr w30, [sp]          // get argc
	mov x25, 16            // set offset to argv[1]
	
	cmp w30, 1             // check if there is any arguments
	bne .file_loop
	adr x1, local         // load . into path
	b .open
	.file_loop:
		cmp w30, 1         // check
		beq .file_end
		sub w30,w30, 1
		ldr x1, [sp, x25]
		add x25, x25, 8
	.open:
		mov x0, -100
		mov x2, 040000
		
		mov x8, 56
		svc 0
		cmp x0, 0
		blt .fail
		
		mov x27, x0
	.getdirents:
		adr x1, buf
		mov x2, buf_s
		mov x8, 61
		svc 0
		cmp x0, 0
		blt .fail
		
		mov x18, x1
	.dirent_loop:
		ldrb w17, [x18, 16]
		ldr x16, [x18, 19]
		//add x16, x16, 1
		cmp w17, 0
		beq .dirent_end
		add x18, x17, x18
	.strlen:
		mov x15, x16
		mov x14, 1
		b .count_loop
		.inc_loop:
		add x15, x15, 1
		add x14, x14, 1
		.count_loop:
		ldr w12, [x15]
		cmp w12, 0
		bne .inc_loop
		mov w11, '\n'
		strb w11, [x15]
	.print:
		mov x0, 1
		mov x1, x16
		mov x2, x14
		mov x8, 64
		svc 0
		b .dirent_loop
	.dirent_end:
		cmp x18, buf_s
		beq .getdirents
	mov x0, x27
	mov x8, 57
	svc 0
	b .file_loop
	.file_end:
	mov w0, 0
	mov x8, 93
	svc 0
	
	.fail:
	mov w0, 1
	mov x8, 93
	svc 0
