# excerpt from the book
# "So, what files are we opening? In this example, we will be opening the files
# specified on the command-line. Fortunately, command-line parameters are already
# stored by Linux in an easy-to-access location, and are already null-terminated.
# When a Linux program begins, all pointers to command-line arguments are stored
# on the stack. The number of arguments is stored at 8(%esp) , the name of the
# program is stored at 12(%esp) , and the arguments are stored from 16(%esp) on."

# actually argc is at %esp, and argv pointer array starts at 4(%esp).







# program which accepts arguments and prints them

.equ LINUX_SYSCALL, 0x80
.equ SYS_EXIT, 1

.section .data
new_line: .ascii "\n\0"

.section .text

.global _start

_start:
# edi will hold number of arguments printed
movl $0, %edi
loop:
    # if number of args printed == num of args given, exit
    cmpl (%esp), %edi
    je main_exit

    # print argument and new line
    pushl 4(%esp, %edi, 4)
    call print_string
    addl $4, %esp

    pushl $new_line
    call print_string
    addl $4, %esp

    # increment number of args printed
    incl %edi
    jmp loop

# exiting and saving number of arguments as the return status code
main_exit:
    movl (%esp), %ebx
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL

















# function which accepts starting address of the string, iterates through it unless it reachs null terminated character, 
# and based on the characters counted, prints it using write system call. 

.equ NULL_CHAR, 0

print_string:
    pushl %ebp
    movl %esp, %ebp

    # saving registers' values
    pushl %eax
    pushl %ebx
    pushl %edx
    pushl %ecx
    pushl %edi



    # index will be held in %edi register
    movl $0, %edi

    movl 8(%ebp), %ecx

    print_string_loop:
        # get current char and compare it to null character
        movb (%ecx, %edi, 1), %al
        cmpb $NULL_CHAR, %al

        # if they are equal, jump to exit
        je exit

        # else, increment char count and continue the loop
        incl %edi
        jmp print_string_loop
    
    exit:
        # print
        pushl %edi
        pushl 8(%ebp)
        call print
        addl $8, %esp

        # function return
        popl %edi
        popl %ecx
        popl %edx
        popl %ebx
        popl %eax

        movl %ebp, %esp
        popl %ebp
        ret

# function which accepts string's starting address and length as arguments and prints the string

.equ SYS_WRITE, 4
.equ STDOUT_DESCRIPTOR, 1

print:
    pushl %ebp
    movl %esp, %ebp

    #save all used registers' values
    pushl %eax
    pushl %ebx
    pushl %edx
    pushl %ecx

    movl $SYS_WRITE, %eax
    movl $STDOUT_DESCRIPTOR, %ebx
    movl 12(%ebp), %edx
    movl 8(%ebp), %ecx
    int $LINUX_SYSCALL

    popl %ecx
    popl %edx
    popl %ebx
    popl %eax

    popl %ebp
    ret
