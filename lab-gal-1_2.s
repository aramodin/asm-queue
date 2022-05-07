.data

greetings:
	.asciz "\nHello! :)\n\nЛабораторная работа номер 2 (класс стэк)\n\n"
menu:
	.asciz "1. Добавить в список(add)\n2. Найти элемент(find)\n3. Отсортировать(sort)\n4. Распечатать(print)\n0. Выход(exit)\n>"
separate_line:
    .asciz "-------------------------\n"
menu_1:
    .asciz "1. Добавить\n"
menu_2:
    .asciz "2. Поиск\n"
menu_3:
    .asciz "3. Сортировка\n"
menu_4:
    .asciz "4. Печать\n"
name:
    .asciz "Имя: "
janr:
    .asciz "Жанр: "
year:
    .asciz "Год: "

empty_stack:
    .asciz "<< Сеэк пуст >>\n"

head:
    .quad 0
last:
    .quad 0
tmpname:
    .space 256
tmpjanr:
    .space 256
tmpyear:
    .space 8


bye_msg:
    .asciz "\nПока :(\n\n"
buf:
    .space 256

.text

.global	_start
_start:

	lea greetings, %rdi
	call print
main_loop:
	lea menu, %rdi
	call print
    # прочитать строку
    mov  $255, %rdi   # длина буфера
    lea  buf,  %rsi   # адрес буфера
    call read
#    lea  buf, %rdi
#    call str2int
    cmpb $'0', (%rsi)
    jz bye
    cmpb $'1', (%rsi)
    jz add_new_record
    cmpb $'4', (%rsi)
    jz print_all
    jmp main_loop



bye:
    lea bye_msg, %rdi
    call print

exit:
	mov $60, %rax		# exit
	xor %rdi, %rdi		# exit code = 0
	syscall

add_new_record:
    lea separate_line,  %rdi
    call print
    lea menu_1,         %rdi
    call print
    lea name,           %rdi
    call print
    mov  $255,          %rdi   # длина буфера
    lea  tmpname,       %rsi   # адрес буфера
    call read

    lea janr,           %rdi
    call print
    mov  $255,          %rdi   # длина буфера
    lea  tmpjanr,       %rsi   # адрес буфера
    call read

    lea year,           %rdi
    call print
    mov  $31,           %rdi   # длина буфера
    lea  tmpyear,       %rsi   # адрес буфера
    call read

    lea separate_line,  %rdi
    call print
    call insert_new_record
    jmp main_loop

print_all:
    lea separate_line,  %rdi
    call print
    lea menu_4,         %rdi
    call print

    movq (head), %rax
    cmp $0, %rax
    jz print_all_empty
print_all_loop:
    lea tmpname,    %rsi    # name
    add $16,        %rax
    mov %rax,       %rdi
    call str_cpy

    lea tmpjanr,    %rsi    # janr
    add $256,       %rax
    mov %rax,       %rdi

    lea tmpyear,    %rsi    # year
    add $256,       %rax
    mov %rax,       %rdi
    call str_cpy

    call print_one_record
    movq (head), %rsi
    movq (%rsi), %rax
    jnz print_all_loop

    jmp print_all_exit

print_all_empty:
    lea empty_stack,    %rdi
    call print
print_all_exit:
    lea separate_line,  %rdi
    call print
    jmp main_loop

print_one_record:
    lea name,    %rdi
    call print
    lea tmpname, %rdi
    call print
    
    lea janr,    %rdi
    call print
    lea tmpjanr, %rdi
    call print
    
    lea year,   %rdi
    call print
    lea tmpyear, %rdi
    call println
    ret

insert_new_record:
#record:
# 8 -   next
# 8 -   prev
# 256 - name
# 256 - жанр
# 32  - год
#----
# 560
    push %rdi
    push %r8
    push %r9

    mov $560, %rdi
    call new
    mov %rax, %r8           # pointer to  new buff

    movq $0,        (%rax)  # next

    lea tmpname,    %rdi    # name
    add $16,        %rax
    mov %rax,       %rsi
    call str_cpy

    lea tmpjanr,    %rdi    # janr
    add $256,       %rax
    mov %rax,       %rsi
    call str_cpy

    lea tmpyear,    %rdi    # year
    add $256,       %rax
    mov %rax,       %rsi

    movq (last),    %rax
    cmp $0,         %rax
    jnz insert_new_record_non_empty
    #empty
    mov %r8,        (%rax)
#    add $8,         %rax
    movq $0,        8(%rax)
    jmp insert_new_record_exit
insert_new_record_non_empty:
    mov (%rax),     %r9     # current last objet (filed 'next')
    mov %r8,       (%r9)

    mov %r9,        (%r8)
    mov %rax,      8(%r8)
    movq %r8,      (last)

insert_new_record_exit:
    pop %r9
    pop %r8
    pop %rdi
    ret
