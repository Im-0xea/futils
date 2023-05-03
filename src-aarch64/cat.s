.equ buf_s, 4096

.section .bss

buf:
	.space buf_s

.section .text

.globl _start

_start:
	ldr w30, [sp]         // get argc
	mov x25, 16           // set arg offset to argv[1]
	
	cmp w30, 1            // check if no arguments where supplied
	bne .file_loop        
	eor x27, x27, x27     // set fd to stdin
	b .read_loop
	.file_loop:
		cmp w30, 1        // check if there are args left
		beq .file_end
		
		sub w30,w30, 1    // decrement argc
		
		ldr x1, [sp, x25] // get current argument
		add x25, x25, 8   // increment arg pointer
		
		eor x2, x2, x2    // zero flags
		mov x0, -100      // clear dir fd
		mov x8, 56
		svc 0             // call openat syscall
		cmp x0, 0
		blt .fail         // fail check
		
		mov x27, x0       // save fd, needed for repeated reads
	.read_loop:
		adr x1, buf      // load buffer address to dest
		mov x0, x27       // get saved fd
		mov w2, buf_s     // load buffer size into count
		mov x8, 63
		svc 0             // call read syscall
		cmp x0, 0
		beq .read_end     // eof check
		blt .fail         // fail check
		
		mov x2, x0        // load count
		mov x0, 1         // fd to stdout
		mov x8, 64
		svc 0             // call write syscall
		cmp x0, buf_s     // check if buffer is full
		beq .read_loop    // next read
	.read_end:
		mov x0, x27       // get fd
		mov x8, 57
		svc 0             // call close syscall
		b .file_loop
	.file_end:
	
	.file_end:
	mov w0, 0             // code 0
	mov x8, 93
	svc 0                 // call exit syscall
	
	.fail:
	mov w0, 1             // code 1
	mov x8, 93
	svc 0                 // call exit syscall
