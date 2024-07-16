## Know the Concepts

#### Describe the lifecycle of a file descriptor.

After open system call file descriptor is given to us via eax register. After that we can use the descriptor to read from a file, write to a file or close a file. After closing the file, we can no longer use the file descriptor.
<br>
<br>

#### What are the standard file descriptors and what are they used for?

Standard file descriptors are 0 for stdin, 1 for stdout, and 2 for stderr.

Stdin is a read only file which represents user's keyboard. It's used for reading user's input.
Stdout is a write only file which represent's user's display.

Stderr is a write only file which represent's user's display. It's used to output errors which might arise during program execution.
<br>
<br>

#### What is a buffer?

Buffer is a block of memory used for storing data temporarily.
<br>
<br>

#### What is the difference between the .data section and the .bss section?

.data section is used for defining static variables which require a specific initial value.

.bss section is used for defining buffers. Here only variable's name and the size is defined.
<br>
<br>

#### What are the system calls related to reading and writing files?

System call number 3 is used for reading from files. To read from the file, additionally we need to store file descriptor in ebx register, buffer's address in ecx and buffer length in edx.

System call number 4 is used for writing to files. Same values used in read sys call should be stored in ebx, ecx and edx registers.

<br>
<br>

## Going Further

#### What difference does the size of the buffer make?
Bigger the buffer, fewer times we need to do system calls for read and write operations, However we need to allocate more memory.
Result is that our program is fast, but uses big amount of memory.

If the buffer is small, we need to use system calls more frequently. This leads to less memory usage, but because of the frequent system calls, programs end up being slow.
<br>
<br>

#### What error results can be returned by each of these system calls?
According to linux man pages, different error results can be returned by each system call. The Linux man pages 
provide detailed information about the error results that can be returned by each system call. 
To view these details, you can use the `man` command in the terminal with the following format: 
`man 2 syscall_name`. 
For example, to see the error codes for the `open` system call, you would execute `man 2 open`.

