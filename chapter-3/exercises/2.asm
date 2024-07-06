# Modify the maximum program to find the minimum instead.

#PURPOSE: This program finds the maximum number of a set of data items.

# VARIABLES: The registers have the following uses:
# %edi - Holds the index of the data item being examined
# %ebx - Smallest data item found
# %eax - Current data item
#
# The following memory locations are used:
# data_items - contains the item data. A 0 is used to terminate the data

.section .data

data_array: 
.long 5, 9, 15, 10, 4, 7, 2, 6, 125, 0

.section .text
.global _start


# %edi - Holds the index of the data item being examined
# %ebx - Smallest data item found
# %eax - Current data item

update_min_element:
    movl %eax, %ebx
    jmp iterate

_start:

movl $0, %edi
movl data_array(, %edi, 4), %ebx
movl %ebx, %eax

loop:
    cmpl $0, %eax
    je exit

    cmpl %ebx, %eax
    jl update_min_element
    
    iterate:
    incl %edi
    movl data_array(, %edi, 4), %eax
    jmp loop


exit:
    movl $1, %eax
    int $0x80
