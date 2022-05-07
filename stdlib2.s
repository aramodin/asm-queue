#.include "system.inc"

.data

newline:
	.ascii "\n\0"
	.set size_newline, . - newline

.text

#
#    0: stdin
#    1: stdout
#    2: stderr

.global print
####################################################################
# IN:
# %rdi - buf
print:
	push %rsi
	push %rdi

	call strlen
	mov %rax, %rsi		# copy the calculated len 
	call print_with_len
	xor %rax, %rax
	pop %rdi
	pop %rsi
	ret


####################################################################
# IN:
# %rdi - buf
# %rsi - len
print_with_len:
	# сохраняем значения используемых регистров 
	push %r11	# 1
	push %rcx	# 2
	push %rdi	# 3
	push %rsi   # 4
	push %rdx	# 5

	# rsi -  адрес строки, rdx - длина строки
	mov %rsi,  %rdx
	mov %rdi,  %rsi
	mov $1,	   %rax		# write
	mov $1,    %rdi		# f-description
	syscall
	# восстанавливаем значения использованных регистров значениями до вызова функции
	xor %rax, %rax		# код возврата - 0

	pop %rdx	# 5
	pop %rsi	# 4
	pop %rdi	# 3
	pop %rcx	# 2
	pop %r11	# 1
	ret

####################################################################
# IN:
# %rdi - buf
.global println
println:
	call print
	lea newline, %rdi
	call print
	ret


####################################################################
# IN:
# %rdi - size
# %rsi - buf
.global read
read:
	push %rcx
	push %r11
	push %rdx

	mov  %rdi, %rdx
    mov  $0,   %rdi   # stdin
    mov  $0,   %rax   # номер системной функции чтения
    syscall           # системный в

	pop %rdx
	pop %r11
	pop %rcx
	ret
