# Program which takes user input and prints records which have names starting with provided N characters

.include "../linux.asm"
.equ CHAR_COUNT, 5

.section .data
    string_1: .ascii "abcde"
    string_2: .ascii "abcde"
    error_message_input_too_short: .ascii "input is too short\n"
    error_message_input_too_short_length: .long 19

.section .bss
    .lcomm name_to_search, 6

.section .text
.global _start

_start:
    # read N character from user input into a buffer
    movl $SYS_READ, %eax
    movl $STDIN, %ebx
    movl $name_to_search, %ecx
    movl $CHAR_COUNT + 1, %edx
    int  $LINUX_SYSCALL

    # if eax's val is less or equal than N, meaning user didn't enter more than N chars, exit with error message 
    cmpl $CHAR_COUNT + 1, %eax
    jl exit_error_input_too_short


    # if last character of the buffer is not a newline, meaning the buffer has more characters, 
    # read stdin till the end of the line so that the rest of the buffer is not interpretted as a command
    decl %eax
    cmpb  $'\n', name_to_search(%eax)
    je loop

    call consume_stdin


    loop:
    # start reading records one by one
    # compare name to user input
    # if they match print the record

    # pushl $4
    # pushl $string_1
    # pushl $string_2

    # call compare
    # addl $12, %esp

exit:
    movl $1, %eax
    int $LINUX_SYSCALL


exit_error_input_too_short:
    movl $1, %ebx

    # print message
    movl $SYS_WRITE, %eax
    movl $STDERR, %ebx
    movl $error_message_input_too_short, %ecx
    movl error_message_input_too_short_length, %edx
    int  $LINUX_SYSCALL
    
    jmp exit

