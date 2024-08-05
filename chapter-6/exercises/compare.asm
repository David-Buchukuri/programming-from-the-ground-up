# Program that compares 2 "strings". It compares 8 byte blocks starting from 2 addresses provided by user n times.
# Arguments: n, address1, address2
# Output: 1 if values of 2 provided addresses are the same up to n characters, else 0.

.section .data
    error_msg_arg_num_of_chars_range: .ascii "number of characters must be grater than 0\n"

.include "../linux.asm"

.equ ARG_ADDRESS_1, 8
.equ ARG_ADDRESS_2, 12
.equ ARG_NUM_OF_CHARS, 16

.section .text
.global compare

compare:
    pushl %ebp
    movl %esp, %ebp

    # Allocating 4 bytes for storing previous values of edi because it will be overwritten
    pushl %edi
    pushl %ebx

    cmpl $0, ARG_NUM_OF_CHARS(%ebp)
    jle exit_error_num_of_chars

    # initializing result and index variables
    movl $1, %eax
    movl $0, %edi

    loop:
        # check if current index is equal to number of chars and exit with result of 1 if that's the case
        cmpl %edi, ARG_NUM_OF_CHARS(%ebp)
        je exit_true

        # compare 2 characters and exit with 0 if they are not equal
        movl ARG_ADDRESS_1(%ebp), %ebx
        movb (%ebx, %edi, 1), %al

        movl ARG_ADDRESS_2(%ebp), %ebx

        cmpb (%ebx, %edi, 1), %al
        jne exit_false

        # increment index and loop
        incl %edi
        jmp loop


exit:
    popl %ebx
    popl %edi
    popl %ebp
    ret

exit_true:
    movl $1, %eax
    jmp exit

exit_false:
    movl $0, %eax
    jmp exit

exit_error_num_of_chars:
    pushl %ecx
    pushl %edx

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $error_msg_arg_num_of_chars_range, %ecx
    movl $43, %edx
    int $LINUX_SYSCALL

    popl %edx
    popl %ecx

    jmp exit_false











