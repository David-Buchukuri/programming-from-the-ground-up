## Know the Concepts


#### Describe the layout of memory when a Linux program starts
At the topmost address there are environment variables. Going downwards we will encounter program arguments(argc and argv).
And then there is a stack. Initially %esp points at argc.
Data, BSS and text sections are on the bottom. In between them there is unmapped memory which our
program can access using brk system call. We have to pass address till which we want to map the memory 
and, if successfull, the system call will return us the address which might or might not be the same as requested address.
That happens because Linux rounds up allocation till the end of the memory page. If not successfull, that syscall returns 0

<br>
<br>

#### What is the heap?
Mapped area of the memory between a stack and text,bss,data sections. We can get access on more heap memory using brk 
syscall and then it's up to us programmers to manage that memory space wisely, minimising number of 
systemcalls and fragmentation. Heap is usually used when we want to use lots of memory or number of bytes needed to allocate is determined on runtime. 

<br>
<br>

#### What is the current break?
Current break is an address till which memory is mapped. If we try to access memory after that address we will get 
segfault because of unmapped memory.

<br>
<br>

#### Which direction does the stack grow in?
Stack grows from top to bottom.

<br>
<br>

#### Which direction does the heap grow in?
Heap grows from bottom to top.

<br>
<br>

#### What happens when you access unmapped memory?
You get segfault.

<br>
<br>

#### How does the operating system prevent processes from writing over eachother’s memory?
Answer to this is virtual memory. 2 proceses can use 2 identical virtual addresses at the same time, but each of them is
mapped to different physical addresses.


<br>
<br>

#### Describe the process that occurs if a piece of memory you are using is currently residing on disk?
One reason why the memory needed for processing would be on hard disk is that RAM is not big enough to contain all the memory
needed by running programs. In that case linux stores some of it's memory on disk instead of RAM. The problem is that cpu
can't process bytes dirtectly from hard disk, those bytes need to be loaded in RAM first. So Linux stores some memory from ram into hard disk and loads the needed memory in the recently freed space. Then Linux adjusts virtual tables so that the program can look up it's memory and resumes the process from the instruction which requested the memory. 

<br>
<br>

#### Why do you need an allocator?
Because it takes care of managing memory. Memory management details should be separated from the main program, because 
it's easy to create bugs when doing that.

<br>
<br>
<br>
<br>

## Going Further

#### Research garbage collection. What advantages and disadvantages does this have over the style of memory management used here?

Garbage collection is process of programming language runtime automatically freeing unused memory. Main advantage of programs written in garbage collected languages is that there are no memory leaks in them. Those type of programming languages are often referred as memory safe languages. 

Downside of these type of languages is speed. To achieve this automatic freeing of memory, of course, there are some procedures executing in runtime. Purpose of those procedures is to determine regions of memory that are unused and free them. Of course that takes extra time.


#### Research reference counting. What advantages and disadvantages does this have over the style of memory management used here?

Reference counting is technique to implement garbage collection. Main idea is that we track number of references to the object during the execution of the program. If it drops to zero, we free the memory. All advantages mentioned above still applies here. It should be mentioned that overhead with this technique is not as big. 

This approach has several disadvantages. For example  circular references, which is basically situation where object A holds reference to object B and vice versa. In this case it's hard to track real number references to the object and this could lead to memory leaks. Also using this technique in a multithreaded environment is problematic, because we have a state(number of references to the objects) and there might occur cases when number of reference is not updated properly do to race conditions.  