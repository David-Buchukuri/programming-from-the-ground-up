.equ LINUX_SYSCALL, 0x80
.equ SYS_EXIT, 1
.equ SYS_WRITE, 4
.equ STDERR_DESCRIPTOR, 2

.section .data
error_message: .ascii "Expected error\n"
error_length: .long 15

.section .text

.global _start

_start:

movl $SYS_WRITE, %eax
movl $STDERR_DESCRIPTOR, %ebx
movl $error_message, %ecx
movl error_length, %edx
int $LINUX_SYSCALL


# exit
movl $SYS_EXIT, %eax
int $LINUX_SYSCALL



