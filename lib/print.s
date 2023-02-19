.section .text

print:
	mov $4, %eax
	mov $1, %ebx
	mov $rdi, %ecx
	mov $14, %edx 
	int $0x80
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
