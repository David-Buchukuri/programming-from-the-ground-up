# program to print record's first name, last name and an address 
# parameters: memory address of the start of the record

.include "../record-def.asm"
.include "../linux.asm"

.section .data
    record_separator: .ascii "----------\n"
    record_separator_length: .long 11
    new_line: .ascii "\n"

.section .text
.global print_record

print_record:
    pushl %ebp
    movl %esp, %ebp

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $record_separator, %ecx
    movl record_separator_length, %edx
    int $LINUX_SYSCALL

    # first name
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl 8(%ebp), %ecx
    addl $RECORD_FIRSTNAME, %ecx
    movl $40, %edx
    int $LINUX_SYSCALL

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $new_line, %ecx
    movl $1, %edx
    int $LINUX_SYSCALL

    # last name
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl 8(%ebp), %ecx
    addl $RECORD_LASTNAME, %ecx
    movl $40, %edx
    int $LINUX_SYSCALL

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $new_line, %ecx
    movl $1, %edx
    int $LINUX_SYSCALL

    # address
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl 8(%ebp), %ecx
    addl $RECORD_ADDRESS, %ecx
    movl $240, %edx
    int $LINUX_SYSCALL

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $new_line, %ecx
    movl $1, %edx
    int $LINUX_SYSCALL

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $record_separator, %ecx
    movl record_separator_length, %edx
    int $LINUX_SYSCALL

    popl %ebp
    ret



