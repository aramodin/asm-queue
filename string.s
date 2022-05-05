.text

.global strlen
strlen:
	push %rdx
	xor %rdx, %rdx		# the length
get_len:
	movb (%rsi,%rdx), %al
	cmp $0, %al
	jz exit_strlen
	inc %rdx
	jmp get_len 
exit_strlen:
	mov %rdx, %rax
	pop %rdx
	ret
