# try to print numbers like characters. will they be interpretted as ascii characters byte by byte?

.section .data
message: .ascii "Hello World\n"
message_length: .long 12

.section .bss

.section .text
.global _start

_start:
# write system call
# syscall number - 4
# file descriptor - should be stored in %ebx
# address of the buffer - should be stored in %ecx
# size of the buffer - should be stored in %edx
# since we are writing to the stdout, we will use file descriptor number 1

# The write system call will give back the number of bytes written in %eax or an error code.

movl $1, %ebx
movl $4, %eax
movl $message, %ecx
movl message_length, %edx
int $0x80

# exit
movl $0, %ebx
movl $1, %eax
int $0x80
