# Write a program that will create a file called heynow.txt and write the words
# "Hey diddle diddle!" into it.

.equ LINUX_SYSCALL, 0x80
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_WRITE, 4
.equ SYS_EXIT, 1
.equ O_CREAT_WRONLY_TRUNC, 03101
.equ PERMISSION, 0666


.section .data
file_name: .ascii "heynow.txt\0"
message: .ascii "Hey diddle diddle!"
message_length: .long 18

.section .text

.global _start
_start:

    # open a file
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx
    movl $PERMISSION, %edx
    int $LINUX_SYSCALL

    # write to the file
    movl %eax, %ebx
    movl $SYS_WRITE, %eax
    movl $message, %ecx
    movl message_length, %edx
    int $LINUX_SYSCALL

    # close the file
    movl $SYS_CLOSE, %eax
    int $LINUX_SYSCALL

# exit
movl $SYS_EXIT, %eax
int $LINUX_SYSCALL

