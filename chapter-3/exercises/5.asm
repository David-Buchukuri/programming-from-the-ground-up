# Modify the maximum program to use a length count rather than the number 0 to know when to stop.

#PURPOSE: This program finds the maximum number of a set of data items.

# VARIABLES: The registers have the following uses:
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
# data_items - contains the item data.
# array_last_idx - contains the last index of the array. It's used to terminate the data.

# In this program I didn't store some variables in registers. I left them in ram, which slows down the program.

.section .data

data_array: .long 1, 2, 9, 79, 2, 9, 12
array_last_idx: .long 7

.section .text
.global _start


# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found


update_max_element:
    movl data_array(, %edi, 4), %ebx
    jmp iterate

_start:

movl $0, %edi
movl data_array(, %edi, 4), %ebx

loop:
    cmpl array_last_idx, %edi
    je exit

    cmpl %ebx, data_array(, %edi, 4)
    jg update_max_element
    
    iterate:
    incl %edi
    jmp loop

exit:
    movl $1, %eax
    int $0x80
