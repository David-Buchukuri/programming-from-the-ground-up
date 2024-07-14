.section .data
file_name: .ascii "text.txt\0"
file_contents_data: .ascii "message from data section"
file_contents_data_length: .long 25


.section .bss

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
movl $03101, %ecx
movl $0666, %edx
int $0x80

# 2. Linux will then return to you a file descriptor in %eax . Remember, this is a
# number that you use to refer to this file throughout your program.


# 3. write system call
# syscall number - 4
# file descriptor - should be stored in %ebx
# address of the buffer - should be stored in %ecx
# size of the buffer - should be stored in %edx

# The write system call will give back the number of bytes written in %eax or an error code.
movl %eax, %ebx
movl $4, %eax
movl $file_contents_data, %ecx
movl file_contents_data_length, %edx
int $0x80


# 4. close system call
# system call number - 6
# file descriptor to close - should be stored in %ebx  

# When you are through with your files, you can then tell Linux to close them.
# Afterwards, your file descriptor is no longer valid. 
movl $6, %eax
int $0x80

# exit
movl $0, %ebx
movl $1, %eax
int $0x80
