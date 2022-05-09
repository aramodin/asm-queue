.data

greetings:
	.asciz "\nHello! :)\n\nЛабораторная работа номер 2 (класс стэк)\n\n"
menu:
	.asciz "1. Добавить в список(add)\n2. Найти элемент(find)\n3. Отсортировать(sort)\n4. Распечатать(print)\n0. Выход(exit)\n> "
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

record_is_notfound:
    .asciz "\n-----------------------\nТакой записи не найдено\n-----------------------\n\n"

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
    cmpb $'0', (%rsi)
    jz bye
    cmpb $'1', (%rsi)
    jz add_new_record
    cmpb $'2', (%rsi)
    jz find_a_record
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

    movq (head), %rdi
    cmp $0, %rdi
    jz print_all_empty
print_all_loop:
    call print_one_record
    mov %rdi, %rax
    movq (%rax),  %rdi
    cmp $0, %rdi
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
    push %rdi
    push %rdi
    lea name,    %rdi
    call print
    pop %rdi
    add $16, %rdi
    call print
    
    push %rdi
    lea janr,    %rdi
    call print
    pop %rdi
    add $256, %rdi
    call print
    
    push %rdi
    lea year,    %rdi
    call print
    pop %rdi
    add $256,    %rdi
    call println
    pop %rdi
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
    mov %rax,       %r8     # pointer to  new buff

    movq $0,        (%r8)  # next

    lea tmpname,    %rsi    # name
    add $16,        %rax
    mov %rax,       %rdi
    call str_cpy

    lea tmpjanr,    %rsi    # janr
    add $256,       %rax
    mov %rax,       %rdi
    call str_cpy

    lea tmpyear,    %rsi    # year
    add $256,       %rax
    mov %rax,       %rdi
    call str_cpy

    movq (last),    %rax
    cmp $0,         %rax
    jnz insert_new_record_non_empty
    #empty
    movq $0,         8(%r8)  # set prev
    movq %r8,        (last)
    movq %r8,        (head)
    jmp insert_new_record_exit
insert_new_record_non_empty:
    # %rax - last; %r8 - new
    # 1. last->next = %r8
    # 2. %r8->prev = last
    # 3. last = %r8
    movq %r8,    (%rax)  # 1
    movq %rax,   8(%r8)  # 2
    movq %r8,    (last)  # 3

insert_new_record_exit:
    pop %r9
    pop %r8
    pop %rdi
    ret

################################################################################
find_a_record:
    push %rsi
    push %rdi
    push %r9

    lea  name,    %rdi
    call print
    mov  $31,     %rdi   # длина буфера
    lea  tmpname, %rsi   # адрес буфера
    call read

    movq (head),     %r9    # current record
    cmp $0,          %r9
    lea empty_stack, %rdi
    call print
    jmp l_find_a_record_exit

find_a_record_loop:
    mov %r9,      %rdi
    add $16,      %rdi
    ########################
    # %rsi <- s1; %rdi <- s2
    call str_cmp
    cmp $0,       %rax
    jz l_found_a_record

    # go to the next record
    add $560,     %r9
    cmp $0,       %r9
    jnz find_a_record_loop 

# record npt found
    lea record_is_notfound, %rdi
    call print
    xor  %rax,    %rax
    jmp l_find_a_record_exit

l_found_a_record:
    mov %rax,     %rdi
    call print_one_record
l_find_a_record_exit:
    pop %r9
    pop %rdi
    pop %rsi
    jmp main_loop
#
#
################################################################################
