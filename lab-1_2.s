.data

greetings:
	.asciz "\nHello! :)\n\nЛабораторная работа номер 2 (класс стэк)\n\n"
menu:
	.asciz "-------------------------\n1. Добавить в список(add)\n2. Найти элемент(find)\n3. Отсортировать(sort)\n4. Распечатать(print)\n-------------------------\n5. Удаление(delete)\n-------------------------\n0. Выход(exit)\n> "
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
menu_5:
    .asciz "5. Удаление\n"

name:
    .asciz "Имя: "
janr:
    .asciz "Жанр: "
year:
    .asciz "Год: "

empty_stack:
    .asciz "<< Сеэк пуст >>\n"

has_been_sorted:
    .asciz "\n\n++ Стэк отсортирован ++\n\n"

record_is_notfound:
    .asciz "\n-----------------------\nТакой записи не найдено\n-----------------------\n\n"
record_is_found:
    .asciz "\n-----------------------\nЗапись найдена:\n"

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
    jz find_a_record_function
    cmpb $'3', (%rsi)
    jz sort_the_list
    cmpb $'4', (%rsi)
    jz print_all
    cmpb $'5', (%rsi)
    jz print_delete_record
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
    push %rdi
    call str_cpy

    lea tmpjanr,    %rsi    # janr
    pop %rdi
    add $256,       %rdi
    push %rdi
    call str_cpy

    lea tmpyear,    %rsi    # year
    pop %rdi
    add $256,       %rdi
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
find_a_record_function:
    call find_a_record
    cmp $0, %rax
    jz exit_find_a_record_function
    push %r9 
    mov %rax, %r9
    lea record_is_found, %rdi
    call print
    mov %r9,  %rdi
    call print_one_record
    pop %r9
exit_find_a_record_function:
    jmp main_loop

find_a_record:
    push %rsi
    push %rdi
    push %r9

    lea  name,    %rdi
    call print
    mov  $255,    %rdi   # длина буфера
    lea  tmpname, %rsi   # адрес буфера
    call read

    movq (head),     %r9    # current record
    cmp $0,          %r9
    jnz find_a_record_loop
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
    cmpq $0,     (%r9)
    jz record_not_found
    mov  %r9,    %rdi
    movq  (%rdi), %r9
    jmp find_a_record_loop

record_not_found:
    lea record_is_notfound, %rdi
    call print
    xor  %rax,    %rax
    jmp l_find_a_record_exit

l_found_a_record:
    mov %r9,  %rax
l_find_a_record_exit:
    pop %r9
    pop %rdi
    pop %rsi
    ret
#
#
################################################################################


print_delete_record:
    call find_a_record
    cmp $0, %rax
    jz exit_print_delete_record
    push %rdi
    mov %rax, %rdi
    call delete_one_record
    pop %rdi
exit_print_delete_record:
    jmp main_loop

# %rdi - current
delete_one_record:
    push %r8            # next
    push %r9            # prev
    push %r10

    mov (%rdi),   %r8
    mov 8(%rdi),  %r9

    cmp $0,       %r8   # means %rdi is last
    jz delete_last_record 
    cmp $0,       %r9   # means %rdi is first and not last
    jz delete_the_first_record
    # we are in the middle of the list
    mov %r8,     (%r9)   # prev->next = current->next
    mov 8(%rdi), %r10
    mov %r10,    8(%r8)  # next->prev = current->prev
    call delete
    jmp exit_delete_one_record

delete_the_first_record:
    mov %r8, (head)
    movq $0,  8(%r8)
    call delete              # %rdi
    jmp exit_delete_one_record

delete_last_record:
    cmp $0, %r9
    jz delete_the_only_last_record
    mov %r9, (last)
    movq $0, (%r9)
    call delete              # %rdi
    jmp exit_delete_one_record
delete_the_only_last_record:
    movq $0, (head)
    movq $0, (last)
    call delete              # %rdi

exit_delete_one_record:
    pop %r10
    pop %r9
    pop %r8
    ret

################################################################################
#NOT READY
sort_the_list:
    call do_sort_the_list
    jmp main_loop

do_sort_the_list:
    push %r9
    push %r10
    push %r11
    push %rdi
    push %rsi

    movq (head),  %r9    # current record
    movq (last),  %r10
    cmp  %r10,    %r9
    jnz sort_the_list__nonempty
    lea empty_stack, %rdi
    call print

    jmp exit_sort_the_list

sort_the_list__nonempty:
    movq (%r9), %r10    # %r10 - next
    cmpq $0,    %r10
    jz print_has_been_sorted
    #mov 16(%r9),  %rsi   # не понятность
    #mov 16(%r10), %rdi
    mov %r10,   %rsi    # point ot the next
    add $16,    %rsi    # next->name
    mov %r9   , %r11    # this
    add $16,    %r11    # this->name
    mov %r11,   %rdi    # -//-

    call str_cmp        # next-> name vs this->name
    jb sort_the_list__swap
    mov %r10, %r9
    jmp sort_the_list__nonempty

sort_the_list__swap:
    ################
    # 1. swap name #
    # 2. swap janr #
    # 3. swap year #
    ################

    # memswap
    # %rdi - pointer to 1
    # %rsi - pointer to 2
    # %rdx - number of bytes
    # %rcx - tmpbuf

    # 1
    mov %r9,  %rdi
    add $16,  %rdi
    mov %r10, %rsi
    add $16,  %rsi
    mov $256, %rdx
    lea tmpname, %rcx
    call memswap

    # 2
    add $256, %rdi
    add $256, %rsi
    call memswap

    # 3
    add $256, %rdi
    add $256, %rsi
    mov $32,  %rdx
    call memswap

    movq (head),  %r9
    jmp sort_the_list__nonempty

print_has_been_sorted:
    lea has_been_sorted, %rdi
    call print

exit_sort_the_list:
    pop %rsi
    pop %rdi
    pop %r11
    pop %r10
    pop %r9
    ret
