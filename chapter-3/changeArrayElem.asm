.section .data
array: .long 1, 2, 3

.section .text
.global _start

_start:
# move desired index to register
movl $2, %ebx

# change element on that index
movl $164, array(, %ebx, 4)

# save changed array element to exit status register
movl array(, %ebx, 4), %ebx

# exit
movl $1, %eax
int $0x80



