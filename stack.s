.data
stackbuf:
    .space 256
stackcount:
    .byte 0

.text

.global put
put:    # %rdi - value
    push %rsi
    xor %rax, %rax
    movb stackcount, %al
    cmp $32, %al
    jz put_error
    mov $stackbuf, %rsi
    add %rax, %rsi
    mov %rdi, (%rsi)
    add $8, %al
    movb %al, stackcount
    mov $0, %rax
    jmp put_exit

put_error:
    mov $-1, %rax
put_exit:
    pop %rsi
    ret

.global get
get:        # %rax - '-1' error / '0' ok ; %rdx - the value from stack 
    xor %rax, %rax
    movb stackcount, %al
    cmp $0, %al
    jz get_error    # the stack  is empty

    sub $8, %al
    movb %al, stackcount
    mov $stackbuf, %rdi
    add %rdi, %rax
    mov (%rax), %rdx
    xor %rax, %rax
    jmp get_exit
get_error:
    mov $-1, %rax
get_exit:
    ret
