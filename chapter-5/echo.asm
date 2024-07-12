# Echo program which reads input from stdin and outputs it to stdout

.equ STDIN_DESCRIPTOR, 0
.equ SYS_READ, 3
.equ STDOUT_DESCRIPTOR, 1
.equ SYS_WRITE, 4

.equ LINUX_SYSCALL, 0x80
.equ SYS_EXIT, 1

.section .data

.section .bss
.equ BUFFER_SIZE, 5
.lcomm input_buffer, BUFFER_SIZE

.section .text
.global _start

_start:
# while number of read bytes are not zero, meaning we haven't reached end of the file, we should continue reading bytes from a file.

loop:
    # read from stdin
    movl $SYS_READ, %eax
    movl $STDIN_DESCRIPTOR, %ebx
    movl $input_buffer, %ecx
    movl $BUFFER_SIZE, %edx
    int $LINUX_SYSCALL

    # if we reached end of the file or some error happened, we jump to exit
    cmpl $0, %eax
    jl exit

    # write to stdout.
    # We should specify how many bytes we want to output. We do that with edx register. 
    # We should save in edx number of bytes read from read system call. 
    # It could be less than the size of the buffer, because for example, we might attempt to read 5 bytes but, 
    # untill end of the file only 3 bytes might be remaining. In that case the buffer will not be fully filled 
    # and 3 will be returned ine eax. 
    movl  %eax, %edx
    movl $SYS_WRITE, %eax
    movl $STDOUT_DESCRIPTOR, %ebx
    int $LINUX_SYSCALL

    jmp loop

exit:
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL

