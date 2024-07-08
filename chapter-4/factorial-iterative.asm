.section .data
.section .text
.global _start


_start:
    # adding first argument to the stack
    pushl $2

    # calling factorial function
    # this pushes return address to the stack and modifies %eip (instruction pointer with function address)
    call factorial


    # at this point only our pushed arguments are in the stack, we need to reset sp as it was before pushing arguments
    addl $4, %esp


    # save result to %ebx register
    movl %eax, %ebx


    # exit
    movl $1, %eax
    int $0x80

# todo handle negative numbers, 1 and 0 as an arguments
factorial:
    # save old base pointer in stack
    pushl %ebp

    # make base pointer same as the stack pointer
    movl %esp, %ebp


    # allocate 4 byte some memory block to store value which will hold the next 
    # integer to multiply with our current product
    subl $4, %esp



    #  ------ algorithm part ------

    # move the first and only argument(target number for the factorial) to the %eax register
    # offset by 8 bytes because there is return address between base pointer memory location and the argument
    movl 8(%ebp), %eax


    # save the number to multiply by in the first slot of the allocated memory. This is achieved by storing
    # the starting number in the second slot and subtracting 1 from it
    movl %eax, -4(%ebp)
    subl $1, -4(%ebp)



    loop:
        # if we are multiplying by 1, it means we reached the end so we stop
        cmpl $1, -4(%ebp)
        je end_factorial

        # multiply current product by the next number and update it with the resulting product
        imull -4(%ebp), %eax

        # decrement number by which multiplication happens
        decl -4(%ebp)

        jmp loop


    end_factorial:
        # result is already in %eax register

        # deallocate space allocated for additional local variables in the function(reset stack pointer)
        movl %ebp, %esp

        # reset base pointer to it's old value
        popl %ebp

        # pop from stack(should be the return address) and set %eip register to that value, 
        # to continue executing commands from there
        ret
