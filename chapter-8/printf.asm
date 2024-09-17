.include "../linux.asm"

.section .data
    format: .ascii "Hello! this is the example of using %s printf function. number -> %d, number -> %d, character -> %c\n\0"
    adjective: .ascii "amazing\0"
    number: .long 2
    character: .byte 'P'

.section .text
.global _start

_start:
    pushl character
    pushl number
    pushl $1
    pushl $adjective
    pushl $format
    call printf

    addl $20, %esp

    pushl $0
    call exit




