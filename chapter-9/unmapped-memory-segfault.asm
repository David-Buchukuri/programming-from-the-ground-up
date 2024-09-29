.include "../linux.asm"

.section .data
.section .text

.global _start

_start:
    # Getting break address and saving it on the stack
    movl $0, %ebx
    movl $SYS_BRK, %eax
    int $LINUX_SYSCALL
    pushl %eax

    # Mapping memory till the address break start + 40 000
    movl (%esp), %ebx
    addl $40000, %ebx
    movl $SYS_BRK, %eax
    int $LINUX_SYSCALL

    # Maping memory till the address break start + 10, thus, unmapping lots of bytes mapped from previous call
    movl (%esp), %ebx
    addl $10, %ebx
    movl $SYS_BRK, %eax
    int $LINUX_SYSCALL

    # Trying to access unmapped memory on the address break start + 30 000. 
    # This should result in segafult because of unmapped memory
    movl (%esp), %ebx
    addl $30000, %ebx
    movl (%ebx), %eax

    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL





