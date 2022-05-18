.text

.global new, delete, memmove

# IN:
# %rdi - number of needed bytes
# OUT:
# %rax - the pointer on the allocated memory. '0' - means error
new:
    #enter
    push %r11   # because of the syscal
    push %rcx   # because of the syscal
    push %rdi
    push %rsi
    push %r8
    push %r9
    push %r10
    push %r15

    add $8,    %rdi    # the mem size + 1
    mov %rdi,   %rax    # резервируемая длина
    mov %rax,   %r15    # запомнить длину файла
    # отобразить файл 
    mov $0,     %rdi    # с начала
    mov %rax,   %rsi    # длина 
    mov $3,     %rdx    # PROT_WRITE|PROT_READ
    mov $33,    %r10    # MAP_SHARED|MAP_ANONYMOUS
    mov $-1,    %r8     # дескриптор файла - игнорируется
    mov $0,     %r9     # игнорируется
    mov $9,     %rax    # номер системного вызова
    syscall             # вызов функции отобразить файл
    cmp $0,     %rax    # нет ли ошибки 
    jz exit_new
    mov %r15,   (%rax)
    add $8,     %rax

exit_new:
    pop %r15
    pop %r10
    pop %r9
    pop %r8
    pop %rsi
    pop %rdi
    pop %rcx
    pop %r11
    #leave
    ret


# IN:
# %rdi - pointer to the memory
# OUT:
# 
delete:
    push %r11   # because of the syscal
    push %rcx   # because of the syscal
    push %rax

    # закрыть отображение
    sub $8,     %rdi  # pointer - %rdi
    mov (%rdi), %rsi  # длина отображенной области
    mov $11,    %rax  # номер системного вызова
    syscall

    pop %rax
    pop %rcx
    pop %r11
    xor %rdi, %rdi
    ret

# IN:
# %rdi - pointer to the dst
# %rsi - pointer to the src
# %rdx - bumber of bytes
# OUT:
# 
# TODO: to rework then
memmove:
    push %rax
    push %rdx
    push %rdi
    push %rsi

_l_memmove:
    dec %rdx
    movb (%rsi,%rdx,1), %al
    movb %al, (%rdi,%rdx,1)
    cmp $0, %rdx
    jnz _l_memmove

    pop %rsi
    pop %rdi
    pop %rdx
    pop %rax
    ret
