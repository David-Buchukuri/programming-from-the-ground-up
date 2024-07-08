pushl - push on the stack
popl - pop off the stack

stack starts at the top of the memory and grows downwards.
every new element added to the stack will have lesser value
than it's predecessor, because of downward growing feature of the stack.

%esp contains a pointer to the current top of the stack

when using pushl and popl, %esp register automatically gets incremented
or decremented by 4 bytes.

In assembly language, the call
instruction handles passing the return address for you, and ret handles using
that address to return back to where you called the function from.

call does several things: - it pushes next instructions address(function return address) onto the stack - The instruction pointer (%eip in x86-32 or %rip in x86-64) is set to the address of the called function.

When a function is done executing, it does three things:

1. It stores it’s return value in %eax.

2. It resets the stack to what it was when it was called (it gets rid of the current
   stack frame and puts the stack frame of the calling code back into effect).

3. It returns control back to wherever it was called from. This is done using the
   ret instruction, which pops whatever value is at the top of the stack, and sets
   the instruction pointer, %eip , to that value.

So, before a function returns control to the code that called it, it must restore the
previous stack frame. Note also that without doing this, ret wouldn’t work,
because in our current stack frame, the return address is not at the top of the stack.
Therefore, before we return, we have to reset the stack pointer %esp and base
pointer %ebp to what they were when the function began.
Therefore to return from the function you have to do the following:

movl %ebp, %esp
popl %ebp
ret
