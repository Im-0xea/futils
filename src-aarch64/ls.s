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
	ldr w30, [sp]           // get argc
	mov x25, 16             // set offset to argv[1]
	
	cmp w30, 1              // check if there is any arguments
	bne .file_loop
	adr x1, local           // load . into path
	b .open
	.file_loop:
		cmp w30, 1          // check
		beq .file_end
		sub w30,w30, 1      // decrement argc
		ldr x1, [sp, x25]   // get argument
		add x25, x25, 8     // move arg pointer
	.open:
		mov x0, -100        // openat workaround fd
		mov x2, 040000      // O_DIRECTORY mode
		
		mov x8, 56
		svc 0               // call openat syscall
		cmp x0, 0
		blt .fail           // fail check
		
		mov x27, x0         // save fd
	.getdirents:
		adr x1, buf         // load buf addr
		mov x2, buf_s       // set count to buf_s
		mov x8, 61
		svc 0               // call getdents64 syscall
		cmp x0, 0
		blt .fail           // fail check
		
		mov x18, x1         // store buffer for parsing
	.dirent_loop:
		ldrb w17, [x18, 16] // get d_reclen for interating
		cmp w17, 0
		beq .dirent_end
		mov x16, x18
		add x16, x16, 19    // seams aarch64 getdents stores d_name in the dirent
		add x18, x17, x18   // add d_reclen to pointer
	.strlen:
		mov x15, x16        // create seperate pointer for length parsing
		mov x14, 1          // start counter at 1 to include \n
		b .count_loop
		.inc_loop:
		add x15, x15, 1     // increment pointer
		add x14, x14, 1     // increment counter
		.count_loop:
		ldrb w12, [x15]     // get char
		cmp w12, 0
		bne .inc_loop       // check if \0
		mov w11, '\n'
		strb w11, [x15]     // add linebreak to end

	.print:
		mov x0, 1           // to stdout
		mov x1, x16         // load stored d_name pointer
		mov x2, x14         // load counter
		mov x8, 64
		svc 0               // call write syscall
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
