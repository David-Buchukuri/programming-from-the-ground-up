# Write a function called square which receives one argument and returns the square of that argument.
# Write a program to test your square function.

.section .data
.section .text
.global _start

_start:

pushl $8
call square


# adding to esp to move it before the pushed arguments. Stack is growing downwards, that's why we do addition 
# instead of subtraction
addl $4, %esp

# exit
movl %eax, %ebx
movl $1, %eax
int $0x80


square:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    imull %eax, %eax

    
    # we don't have any local variables so we don't need to reset stack pointer to base pointer
    # at this pointe sp points to the old value of base pointer so we can just pop it and save 
    # it in base pointer register
    
    popl %ebp

    # At this point at the top of the stack function's return address is located.
    # ret instruction will pop the value from the top of the stack and place it into %eip (instruction pointer).   
    # That's exactly what we need. Instruction execution will carry on from the function's return address,
    # which is the next instruction's address after the function call instruction
    ret



