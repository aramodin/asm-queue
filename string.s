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
	xor %rax, %rax
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

####################################################################
# IN:
# %rdi - s1
# %rsi - s2
# OUT:
# %rax = -1 (s1<s2), 0 (s1==s2), 1 (s1>s2)
.global str_cmp
str_cmp:
	push %rdi
	push %rsi
	push %rbx
	push %rcx

	xor %rax, %rax
loop_str_cmp:
	###############################
	# check the end of strings
	cmp $0, %rdi
	jnz   str_cmp_end_continue
	# s1 is \0
	cmp $0, %rsi
	jz str_cmp_exit
	jmp s1_less_s2
str_cmp_end_continue:
	cmp $0, %rsi
	jz s1_greate_s2
	# check the end of strings
	###############################

	movb (%rdi), %bl
	movb (%rsi), %cl
	cmpb %bl, %cl
	jb	s1_less_s2
	ja  s1_greate_s2

	inc %rdi
	inc %rsi
	jmp loop_str_cmp

s1_greate_s2:
	inc %rax
	jmp str_cmp_exit
s1_less_s2:
	dec %rax
str_cmp_exit:
	pop %rcx
	pop %rbx
	pop %rdi
	pop %rsi
	ret
