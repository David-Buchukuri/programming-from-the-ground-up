# Modify the maximum program to use the number 255 to end the list rather than the number 0


#PURPOSE: This program finds the maximum number of a set of data items.

# VARIABLES: The registers have the following uses:
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
# data_items - contains the item data. A 255 is used to terminate the data

.section .data

data_array: 
.long 1, 2, 9, 157, 2, 9, 255

.section .text
.global _start


# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item

update_max_element:
    movl %eax, %ebx
    jmp iterate

_start:

movl $0, %edi
movl data_array(, %edi, 4), %ebx
movl %ebx, %eax

loop:
    cmpl $255, %eax
    je exit

    cmpl %ebx, %eax
    jg update_max_element
    
    iterate:
    incl %edi
    movl data_array(, %edi, 4), %eax
    jmp loop


exit:
    movl $1, %eax
    int $0x80
