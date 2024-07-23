# returnes maximum from given 2 arguments
.section .text
.global max

max:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    cmpl 12(%ebp), %eax

    # if eax if grater, return eax right away
    # else, save other parameter to eax and return it
    jg return
    movl 12(%ebp), %eax

    return:
        popl %ebp
        ret
        



