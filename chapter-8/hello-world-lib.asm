.include "../linux.asm"

.section .data
    message: .ascii "hello world with libraries!\n\0"

.section .text
.global _start

_start:
    pushl $message
    call printf

    addl $4, %esp

    pushl $0
    call exit




