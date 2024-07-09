# The factorial function can be written non-recursively. Do so.
# Since I already wrote it myself before starting this exercises, I will implement recursive fibonacci
# function instead.

.section .data
.section .text
.global _start

#                    0  1  2  3  4  5  6  7   8
# fibonacci numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21 ... 

_start:

pushl $8
call fib

# reset stack pointer
addl $4, %esp


# exit
movl %eax, %ebx
movl $1, %eax
int $0x80 





fib:
    pushl %ebp
    movl %esp, %ebp

    # since we need to keep result of recursive functions
    # we need to allocate extra word on a stack. I will use it to store 
    # result for the 'left branch'of the recursion. Result of the 'right branch' will be stored in %eax
    # by default so I don't need to allocate extra space for it.
    subl $4, %esp

    # storing argument in %eax. In base case it's convenient to have result stored in %eax. 
    movl 8(%ebp), %eax

    # base case. If argument is 0 or 1, we return whatever value the argument holds
    cmpl $2, 8(%ebp)
    jl end


    # function call to calculate fib(n-1)
    pushl %eax
    decl (%esp)
    call fib
    addl $4, %esp

    # save result in allocated memory
    movl %eax, (%esp)

    # function call to calculate fib(n-2)
    pushl 8(%ebp)
    subl $2, (%esp)
    call fib
    addl $4, %esp


    # add up results and save it in %eax
    addl -4(%ebp), %eax

    end:
        movl %ebp, %esp
        popl %ebp
        ret



