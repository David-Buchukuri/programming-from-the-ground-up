.section .data
.section .text
.globl _start

_start:

# push second argument
pushl $2

# push first argument   
pushl $5      

# call the function
call power

# move the stack pointer back
addl $8, %esp


# save the first answer before calling the next function
pushl %eax

# push second argument
pushl $2

# push first argument  
pushl $3

# call the function
call power

# move the stack pointer back
addl $8, %esp



# The second answer is already
# in %eax. We saved the
# first answer onto the stack,
# so now we can just pop it
# out into %ebx
popl %ebx



# add them together
# the result is in %ebx
addl %eax, %ebx


# exit (%ebx is returned)
movl $1, %eax
int $0x80 





# PURPOSE: This function is used to compute the value of a number raised to a power.

# INPUT:
# First argument - the base number
# Second argument - the power to raise it to

# OUTPUT: Will give the result as a return value

# VARIABLES:
# %ebx - holds the base number
# %ecx - holds the power
# -4(%ebp) - holds the current result
# %eax is used for temporary storage

.type power, @function

power:
# save old base pointer
pushl %ebp

# make base pointer same as stack pointer
movl %esp, %ebp

# get room for our local storage
subl $4, %esp

# put first argument in %eax
movl 8(%ebp), %ebx 

# put second argument in %ecx
movl 12(%ebp), %ecx


# store current result
movl %ebx, -4(%ebp) 


power_loop_start:
# if the power is 1, we are done
cmpl $1, %ecx
je end_power

# move the current result into %eax
movl -4(%ebp), %eax

# multiply the current result by the base number
imull %ebx, %eax

# store the current result
movl %eax, -4(%ebp)

# decrease the power
decl %ecx

# run for the next power
jmp power_loop_start



end_power:
# return value goes in %eax
movl -4(%ebp), %eax

# restore the stack pointer
movl %ebp, %esp

# restore the base pointer
popl %ebp

ret


