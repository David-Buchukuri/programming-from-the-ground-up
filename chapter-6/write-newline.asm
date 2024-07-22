.include "linux.asm"

.section .data
newline: .ascii "\n"

.section .text

.global write_newline
.type write_newline, @function

.equ ST_FILE_DESCRIPTOR, 8

write_newline:
    pushl %ebp
    movl %esp, %ebp

    movl $SYS_WRITE, %eax
    movl ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $LINUX_SYSCALL

    popl %ebp
    ret

