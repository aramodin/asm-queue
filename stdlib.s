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
print:	# the *buf is in %rsi
##	push %rbx			# для leave
##	mov %rsp, %rbx		# для leave
##	sub $16, %rsp		# если параметры через стек??

	push %rsi
	push %rdx

	call strlen
	mov %rax, %rdx		# copy the calculated len 
	call print_with_len

	pop %rdx
	pop %rsi

##	leave
	ret

print_with_len:
	###### ДО выполнения функции
##	push %rbx			# для leave
##	mov %rsp, %rbx		# для leave

	# сохраняем значения используемых регистров 
	push %r11	# 1
	push %rcx	# 2
	push %rdi	# 3
	###### тело функции

	mov $1, %rax		# write
	mov $1, %rdi		# f-description
	syscall
	# восстанавливаем значения использованных регистров значениями до вызова функции
	xor %rax, %rax		# код возврата - 0
	pop %rdi	# 3
	pop %rcx	# 2
	pop %r11	# 1
##	leave 				# восстанавливаем содержимое %rsp и %rbx
	ret

.global println
println:
	call print
	push %rsi
	push %rdx
	mov $newline, %rsi
	mov $2, %rdx
	call print
	pop %rdx
	pop %rsi
	ret
