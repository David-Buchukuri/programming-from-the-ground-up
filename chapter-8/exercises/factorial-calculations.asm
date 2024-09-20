.section .data
    printf_first_arg: .ascii "result is %d\n\0"

.section .text
.global _start
_start:
    pushl $6
    call factorial
    addl $4, %esp

    pushl %eax
    pushl $printf_first_arg
    call printf
    addl $8, %esp

    # exit
    pushl $0
    call exit
