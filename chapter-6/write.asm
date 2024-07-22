.include "linux.asm"
.include "record-def.asm"

# PURPOSE: This function writes a record to the given file descriptor
#
# INPUT: The file descriptor and a buffer
#
# OUTPUT: This function produces a status code
#
# STACK LOCAL VARIABLES

.equ ST_WRITE_BUFFER, 8
.equ ST_FILE_DESCRIPTOR, 12

.section .text
.globl write_record
.type write_record, @function

write_record:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    
    movl  $SYS_WRITE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl  ST_WRITE_BUFFER(%ebp), %ecx
    movl  $RECORD_SIZE, %edx
    int   $LINUX_SYSCALL
    
    # NOTE - %eax has the return value, which we will give back to our calling program
    
    popl  %ebx
    popl  %ebp
    ret


