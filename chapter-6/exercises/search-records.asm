# Program which takes user input and prints records which have names starting with provided N characters

.include "../linux.asm"
.include "../record-def.asm"
.equ CHAR_COUNT, 5

.section .data
    record_file_path: .ascii "../test.dat\0" 
    error_message_input_too_short: .ascii "input is too short\n"
    error_message_input_too_short_length: .long 19
    error_message_cant_open_a_file: .ascii "can not open the file\n"
    error_message_cant_open_a_file_length: .long 22

.section .bss
    .lcomm name_to_search, CHAR_COUNT + 1
    .lcomm record_buffer, RECORD_SIZE

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
    je open_file

    call consume_stdin

    open_file:
    # open the records file
    movl  $SYS_OPEN, %eax
    movl  $record_file_path, %ebx
    movl  $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL 
    pushl %eax  

    cmpl $3, %eax
    jl exit_error_cant_open_a_file 
    
    loop:
        movl $SYS_READ, %eax
        movl (%esp), %ebx
        movl $record_buffer, %ecx
        movl $RECORD_SIZE, %edx
        int  $LINUX_SYSCALL 
    
        cmpl $0, %eax
        jle exit
    
        # compare record's first name to user input
        pushl $CHAR_COUNT
        pushl $name_to_search
        pushl $record_buffer
    
        call compare
        addl $12, %esp
    
        # if they match print the record
        cmpl $1, %eax
        jne loop

        pushl $record_buffer
        call print_record
        addl $4, %esp

        jmp loop

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


exit_error_cant_open_a_file:
    movl $1, %ebx

    # print message
    movl $SYS_WRITE, %eax
    movl $STDERR, %ebx
    movl $error_message_cant_open_a_file, %ecx
    movl error_message_cant_open_a_file_length, %edx
    int  $LINUX_SYSCALL
    
    jmp exit
