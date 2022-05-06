.data

msg1:
	.asciz "The 1st message"

.text

.global test_memory
test_memory:
    push %rsi
    push %rdi

    lea msg1,   %rsi
    call strlen
    inc %rax                # for the NULL
    mov %rax,   %rdi
    call new                # allocate %rdi bytes
    lea msg1,   %rsi
    mov %rax,   %rdi
    call str_cpy            # %rdi - dst/ %rsi - src
    call delete             # %rdi - pointer to the memory

    pop %rdi
    pop %rsi
    ret
