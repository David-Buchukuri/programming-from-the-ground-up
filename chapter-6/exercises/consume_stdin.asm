.include "../linux.asm"

.section .bss
    .lcomm temp_buffer, 200

.section .text

.global consume_stdin

consume_stdin:
    pushl %ebp
    movl %esp, %ebp

    loop:
        movl $SYS_READ, %eax
        movl $STDIN, %ebx
        movl $temp_buffer, %ecx
        movl $200, %edx
        int $LINUX_SYSCALL

        cmpl $0, %eax
        jle exit

        # exit if last character is a newline
        decl %eax
        cmpb  $'\n', temp_buffer(%eax)
        je exit

        jmp loop
    
    exit:
        popl %ebp
        ret
