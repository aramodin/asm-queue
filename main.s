#.include "fmt.s"
#.include "/usr/include/x86_64-linux-gnu/asm/unistd_64.h"

## syscall args
# x86-64        rdi   rsi   rdx   r10   r8    r9
## syscal rets
##                     #      ret1 ret2
# x86-64      syscall rax     rax  rdx

.data

msg:
	.ascii "Hello, Word!\n\0"
	.set len, . - msg
#buf:
#	.space 256	# array of 256 bytes


.text

.global	_start
_start:
	# получить адрес начала области для выделения памяти
# 	mov $12, %rax
# 	xor %rdi, %rdi
# 	syscall
#	mov %rax, %r8	# запомнить адрес начала выделяемой памяти
###############################################################

	#mov $msg, %rsi
	#call print
	#mov $'?', %dl
	#mov %dl, msg+11
	##mov $msg, %rsi
	#call println

#
#	call get
#	mov $18, %rdi
#	call put
#	inc %rdi
#	call put
#	inc %rdi
#	call put
#
#
#	mov $0x1313, %rdi
#	call get
#	call get
#	call get
#	call get

	call test_memory
exit:
	mov $60, %rax		# exit
	xor %rdi, %rdi		# exit code = 0
	syscall
