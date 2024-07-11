# read first byte of the file and return it as a status code

.section .data
file_name: .ascii "text.txt\0"

.section .bss
.lcomm file_contents_buffer, 1

.section .text
.global _start

_start:
# 1. open system call - returns a file descriptor
# syscall number - should be stored in %eax. 5 is for opening files.
# address of the first character of the filename - should be stored in %ebx(it should be null terminated)
# mode - can be read, write, read and write , etc... . should be stored in %ecx. for read we need to set 0, for write 03101.
# permission set - shoudl be stored in %edx. by default we can set it as 0666.

movl $5, %eax
movl $file_name, %ebx
movl $0, %ecx
movl $0666, %edx
int $0x80

cmpl $0, %eax
jl exit

# 2. Linux will then return to you a file descriptor in %eax . Remember, this is a
# number that you use to refer to this file throughout your program.


# 3. read system call
# syscall number - 3
# file descriptor - should be stored in %ebx
# address of the buffer - should be stored in %ecx
# size of the buffer - should be stored in %edx

# read will return with either the number of characters read from the file, 
# or an error code. 
# Error codes can be distinguished because they are always negative numbers

# write is system call 4, and
# it requires the same parameters as the read system call, except that the buffer
# should already be filled with the data to write out. The write system call will
# give back the number of bytes written in %eax or an error code.

movl %eax, %ebx
movl $3, %eax
movl $file_contents_buffer, %ecx
movl $1, %edx
int $0x80

pushl file_contents_buffer

# 4. close system call
# system call number - 6
# file descriptor to close - should be stored in %ebx  

# When you are through with your files, you can then tell Linux to close them.
# Afterwards, your file descriptor is no longer valid. 

movl $6, %eax
int $0x80

# save character we read in ebx and exit
popl %ebx

exit:
movl $1, %eax
int $0x80
