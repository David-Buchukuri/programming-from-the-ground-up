# This program goes through records and increments ages by 1.
# Usage of lseek system call for manipulating a file pointer manually is demonstrated. 

.include "../linux.asm"
.include "../record-def.asm"

.section .data
    file_path: .ascii "test.dat\0"

.section .bss
    .lcomm age_buffer, 4

.section .text
.global _start

_start:

    # open file in a read write mode, which does not truncate existing data when writing to it
    movl $SYS_OPEN, %eax
    movl $file_path, %ebx
    movl $2, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL


    # save file descriptor in the stack
    pushl %eax

    # run the loop, while number of bytes read is not 0 or error desn't happen, basically stop when eax <= 0
    # we will use absolute mode for lseek. We will use a register to keep appropriate offset from the start of the file
    # we will start with the value RECORD_AGE, and add to it RECORD_SIZE on each iteration

    movl $RECORD_AGE, %edi

    loop:
        # use lseek syscall to move pointer at age position
        movl $SYS_LSEEK, %eax
        movl (%esp), %ebx
        movl %edi, %ecx
        movl $0, %edx
        int $LINUX_SYSCALL

        # read the age and save it to the buffer
        movl $SYS_READ, %eax
        movl (%esp), %ebx
        movl $age_buffer, %ecx
        movl $4, %edx
        int $LINUX_SYSCALL

        # if error occured or there is no more data to read exit
        cmpl $0, %eax
        je exit
        jl error

        # increment the age
        movl age_buffer, %ecx
        incl %ecx
        movl %ecx, age_buffer

        # move back file pointer, after it was moved forward by 4 bytes when reading
        movl $SYS_LSEEK, %eax
        movl (%esp), %ebx
        movl %edi, %ecx
        movl $0, %edx
        int $LINUX_SYSCALL

        # write incremented age back to the file
        movl $SYS_WRITE, %eax
        movl (%esp), %ebx
        movl $age_buffer, %ecx
        movl $4, %edx
        int $LINUX_SYSCALL

        # set edi to next record's age position 
        addl $RECORD_SIZE, %edi

        jmp loop
    
    exit:
        movl $SYS_EXIT, %eax
        movl $33, %ebx
        int $LINUX_SYSCALL

    error:
        movl $SYS_EXIT, %eax
        movl $66, %ebx
        int $LINUX_SYSCALL
