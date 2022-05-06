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


.global str_cpy

# IN:
# %rdi - dst
# %rsi - rst
# OUT:
# %rax = 0
str_cpy:
	#enter
	push %rdi
	push %rsi
	push %rax
str_cpy_loop:
	xor %rax,	%rax
	mov (%rsi),	%al
	mov %al,	(%rdi)
	cmp $0,		%al
	jz str_cpy_exit
	inc %rdi
	inc %rsi
	jmp str_cpy_loop

str_cpy_exit:
	pop %rax
	pop %rdi
	pop %rsi
	#leave
	ret
