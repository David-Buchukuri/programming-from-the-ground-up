.include "../linux.asm"

.section .data
    string_1: .ascii "abcde"
    string_2: .ascii "abcde"

.section .text
.global _start

_start:
    pushl $4
    pushl $string_1
    pushl $string_2

    call compare
    addl $12, %esp

exit:
    movl %eax, %ebx
    movl $1, %eax
    int $LINUX_SYSCALL





