.include "../linux.asm"

.section .data
    message: .ascii "hello world!\n"
    message_length: .long 13

.section .text

.global _start

_start:
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $message, %ecx
    movl message_length, %edx
    int $LINUX_SYSCALL


    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL




