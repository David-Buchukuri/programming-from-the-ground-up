# Modify the maximum program to use an ending address rather than the number 0 to know when to stop.

#PURPOSE: This program finds the maximum number of a set of data items.

# VARIABLES: The registers have the following uses:
# %edi - Holds the address of the data item being examined
# %ebx - Largest data item found
# %eax - Holds the address of the end of the array
#
# The following memory locations are used:
# data_items - contains the item data.

.section .data

#            0   4    8    12   16      20   24
array: .long 1,  2,   9,   5,   234,    9,   125
array_length: .long 7


.section .text
.global _start

# %edi - Holds the address of the data item being examined
# %ebx - Largest data item found
# %eax - Holds the address of the end of the array

update_max_element:
    movl (%edi), %ebx
    jmp iterate

_start:
leal array, %edi
movl (%edi), %ebx


# calculate address of the end of the array
    # load arr length, elem length and multiply
    movl array_length, %esi
    movl $4, %eax
    imull %esi, %eax

    # calculate end of the array and save in %eax
    addl %edi, %eax


loop:
    cmpl %edi, %eax
    je exit

    cmpl %ebx, (%edi)
    jg update_max_element
    
    iterate:
    addl $4, %edi
    jmp loop

exit:
    movl $1, %eax
    int $0x80
