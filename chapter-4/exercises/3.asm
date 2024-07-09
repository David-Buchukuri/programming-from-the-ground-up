# Convert the maximum program given in the Section called Finding a Maximum
# Value in Chapter 3 so that it is a function which takes a pointer to several values
# and returns their maximum. Write a program that calls maximum with 3
# different lists, and returns the result of the last one as the program’s exit status
# code.


# I suppose I should write a function which takes pointer of an array and array's length 
# as an argument and returns it's maximum.


.section .data
array_1: .long 9, 4, 7, 21, 1, 6
array_1_length: .long 6

array_2: .long 1, 11, 9, 2
array_2_length: .long 4

array_3: .long 1, 11, 7, 5, 9, 17, 4
array_3_length: .long 7

.section .text
.global _start

_start:

pushl array_1_length
pushl $array_1

call max

addl $8, %esp



pushl array_2_length
pushl $array_2

call max

addl $8, %esp



pushl array_3_length
pushl $array_3
call max

addl $8, %esp



movl %eax, %ebx
movl $1, %eax
int $0x80


# function which finds maximum value in an array of longs
# parameters: first  -> address of the array
#             second -> length of the array
max:
    pushl %ebp
    movl %esp, %ebp

    # I am going to use %ebx register to keep track of current index, therefore I will push it's old 
    # value on a stack and restore it after function is done.
    # maximum value will be stored in %eax register so I don't need to allocate extra space for it.
    # also, I will use %ecx register to store passed array's address. It will be useful for getting element
    # values from array using indexed addressing mode.
    pushl %ebx
    pushl %ecx

    # set initial index value
    movl $0, %ebx

    # save array's address in %ecx
    movl 8(%ebp), %ecx

    # set initial max value as the first element of the array
    # this is achieved by using index addressing mode and getting 0'th index
    movl (%ecx), %eax


    loop:
        # compare curr idx with arr length and if it's equal exit
        cmpl %ebx, 12(%ebp)
        je exit

        cmpl (%ecx, %ebx, 4), %eax
        jge increment_index
        movl (%ecx, %ebx, 4), %eax

        increment_index:
            incl %ebx
            jmp loop


    exit:
        # restore %ecx and %ebx registers' values and reset stack pointer
        popl %ecx
        popl %ebx

        # set base pointer to it's old value
        popl %ebp

        # pop return address and continue instruction execution from that address
        ret




     


