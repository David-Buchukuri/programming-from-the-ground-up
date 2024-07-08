.section .data
.section .text
.global _start


_start:
    # adding first argument to the stack
    pushl $4

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

.type factorial, @function
factorial:
    # save old base pointer in stack
    pushl %ebp

    # make base pointer same as the stack pointer
    movl %esp, %ebp

    #  ------ algorithm part ------

    # move the first and only argument(target number for the factorial) to the %eax register.
    # We offset by 8 bytes because there is return address between base pointer memory location and the argument.
    movl 8(%ebp), %eax

    # if number < 2: jump to cleanup
    cmpl $2, %eax
    jl end_factorial

    
    # push decremented argument onto the stack for the next recursive function call
    decl %eax
    pushl %eax

    # call factorial function
    call factorial

    # remove pushed arguments
    addl $4, %esp

    # multiply returned result by current argument and save in %eax
    imull 8(%ebp), %eax

    # jump to cleanup(optional)
    jmp cleanup



    end_factorial:
        # result is already in %eax register

        # if result is 0, which will happen only when argument is 0, make result 1
        cmpl $0, %eax
        jne check_for_negative
        movl $1, %eax
        

        # if result is negative, make it -1
        cmpl $0, %eax
        check_for_negative:
            jge cleanup
            movl $-1, %eax
            

        cleanup:
            # deallocate space allocated for additional local variables in the function(reset stack pointer)
            # in our case this doesn't change anything because we don't have additional memory allocated 
            movl %ebp, %esp

            # reset base pointer to it's old value
            popl %ebp

            # pop from stack(should be the return address) and set %eip register to that value, 
            # to continue executing commands from there
            ret
