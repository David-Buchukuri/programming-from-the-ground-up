## Know the Concepts


#### What are the advantages and disadvantages of shared libraries?

Advantages are that we don't need to copy paste code whenever we need to use it. Instead we can can create a shared library and reference it when linking our program. One might think that we can achieve the same result with static linking. For example We could create a file with bunch of functions and whenever we need to use some function from that file, we just statically link that file. The problem with this approach is that we end up with bigger executable file sizes. Why? Because, when linking statically, we basically write binary version of referenced function in our executable. With dynamic linking, the code for the referenced functions is not included in the final binary, but is instead loaded from the shared library at runtime. We just include name of the shared library in the final executable and everything else happens on runtime. This allows us to save some space. Also one more advantage would be that we can update the function and programs which were already using our function from the library wouldn't need recompilation. Additionally, when using shared libraries, we don't only save memory on hard disk, but we save space on ram as well. That's because, even if several programs are using a function from the shared library, the function is loaded in memory once and is reused for the different programs.

Disadvantages would be the overhead on runtime. Also that if we want to update a function in a library, we might brake programs which use that function. Less portability of final programs, caused by the dependency on libraries, could be an issue as well. If you don't have the libraries used by the program on your system, you can't run the program.
<br>
<br>


#### Given a library named ’foo’, what would the library’s filename be?

libfoo.so
<br>
<br>


#### What does the ldd command do?
ldd command checks on which libraries does the dynamically linked program depend.

#### Let’s say we had the files foo.o and bar.o, and you wanted to link them together, and dynamically link them to the library ’kramer’. What would the linking command be to generate the final executable?

ld -shared foo.o bar.o -o libkramer.so
<br>
<br>


#### What is typedef for?
typedef is a way to rename types. For example we can write
`typedef char myCustomName;` in a C program and instead of `char` now I can write `myCustomName` for type definitions. 
<br>
<br>


#### What are structs for?

Structs are for storing multiple items of related data of same or different types in consecutive memory space. 
<br>
<br>


#### What is the difference between a data element of type int and int *? How would you access them differently in your program?

int is an integer type. If we are given a memory block and we know that it's an int, that means integer value is stored at that memory location.

int * is a pointer to integer. That means inside of given word there is an address of different register with value of some integer. Pointers can be accessed using indirect addressing mode.
<br>
<br>


#### If you had a object file called foo.o, what would be the command to create a shared library called ’bar’?
ld -shared foo.o -o libbar.so
<br>
<br>


#### What is the purpose of LD_LIBRARY_PATH?
LD_LIBRARY_PATH is an environment variable which tells linker where on the system are shared libraries stored, in addition to the default locations.