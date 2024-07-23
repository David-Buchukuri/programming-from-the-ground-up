# Create a program to find the largest age in the file and return that age as thestatus code of the program.

.include "../record-def.asm"
.include "../linux.asm"

.section .data
    file_path: .ascii "test.dat\0"

.section .bss
    .lcomm record_buffer, RECORD_SIZE

.section .text

.global _start

_start:
    movl %esp, %ebp
    subl $4, %esp

    # open file
    movl $SYS_OPEN, %eax
    movl $file_path, %ebx
    movl $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    # save the file descriptor in the stack
    movl %eax, -4(%ebp)

    # we will use edi register to store the maximum value
    # initializing max value to zero
    movl $0, %edi

    read_loop:
        # read record in a buffer
        pushl -4(%ebp)
        pushl $record_buffer
        call read_record
        addl $8, %esp

        # if number of bytes read is not same as the record size,
        # we either have an error, or there are no more records to read, so we to exit in this case
        cmpl $RECORD_SIZE, %eax
        jne exit

        # if current age is grater than max, update max age with this value
        movl record_buffer + RECORD_AGE, %ecx
        pushl %ecx
        pushl %edi
        call max
        addl $8, %esp
        movl %eax, %edi

        jmp read_loop


exit:
    movl %edi, %ebx
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL

