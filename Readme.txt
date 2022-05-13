/usr/include/x86_64-linux-gnu/asm/unistd_64.h
/usr/include/asm/unistd.h

    b — байт;
    w — слово;
    l — двойное слово (4 байта);
    q — 8-байтовый операнд.

    .byte — резервирует байт памяти;
    .short — резервирует слово памяти (2 байта);
    .long — резервирует двойное слово (4 байта) ;
    .quad — резервирует 8 байтов памяти.

lo3:
    xor  %rdx, %rdx
    div  %r8
    add  $48, %dl
    mov  %dl, (%rsi)
    inc  %rsi
    cmp $0, %rax
    jnz lo3


syscall:
Таким образом, %rdi, %rsi, %rdx, %rcx, %r8 and %r9 являются регистрами, 
используемыми для передачи параметров целочисленного значения/указателя (то есть класса INTEGER)
в любую функцию libc из сборки.
%rdi используется для первого параметра INTEGER.
%rsi для 2-го,%rdx для 3-го и так далее.
Затем следует дать инструкцию по call.
Стек (%rsp) должен быть выровнен по 16B при выполнении call.
%rcx и %r11 - портятся вызовом syscall
https://code-examples.net/ru/q/26b235


вход и выход из функции:
# сохраняем EBP, копируем ESP в EBP "выделяем" 16 байт
(10+ тактов) enter 16, 0 ==  (1 такт?) push %ebp;  mov %esp, %ebp; sub $16, %esp
(1 такт) leave == 

============== asm из c ==========================
Параметры в x86-64 Linux передаются через регистры в такой последовательности:
rdi , rsi , rdx , rcx , r8 , r9.

as --64 s4000.s -o s4000.o
gcc -c cs4000.c
gcc -no-pie cs4000.o s4000.o -o s4000

#include <stdio.h>
extern char * cops(char *, char *, int);

int main(){
    char s1[] ="Это строка будет скопирована в другую строку";
    char s2[101];
    printf("%s\n", cops(s2, s1, 100));
    printf("%s\n", s2);
    return 0;
}

