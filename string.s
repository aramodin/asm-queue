.text

####################################################################
# IN:
# %rdi - buf
.global strlen
strlen:
	push %rdx
	xor %rdx, %rdx		# the length
get_len:
	movb (%rdi,%rdx), %al
	cmp $0, %al
	jz exit_strlen
	inc %rdx
	jmp get_len 
exit_strlen:
	mov %rdx, %rax
	pop %rdx
	ret


####################################################################
# IN:
# %rdi - dst
# %rsi - src
# OUT:
# %rax = 0
.global str_cpy
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

####################################################################
# IN:
# %rdi - адрес строки
# OUT:
# %rax - число
.global str2int
str2int:
	call strlen         #  получить длину строки -> rax
	push %rdi
	push %r10
	push %r11
	push %r9
	push %rcx
	add  %rax, %rdi
	xor  %r10, %r10
	mov  %rax, %r9
	mov  $1, %r11
	str2int_lo1:
		dec %rdi
		xor %rax, %rax
		movb (%rdi), %al
		subb $48, %al
		mul %r11
		add %rax, %r10
		mov %r11, %rax
		mov $10, %rcx
		mul %rcx
		mov %rax, %r11
		dec %r9
		jnz str2int_lo1
	mov  %r10, %rax
	pop  %rcx
	pop  %r9
	pop  %r11
	pop  %r10
	pop  %rdi
	ret
