## Know the Concepts

#### What are primitives?

Primitives are "functions" which are provided by operating system. Usually primitives interact with hardware. Often we call primitives system calls.
<br>
<br>

#### What are calling conventions?

Calling conventions are set of rules of how do we set up functions, handle function arguments, return statements, local variables and etc.
<br>
<br>

#### What is the stack?

Stack is a chunk of contiguous memory we programmers use for managing function calls. We use stack to place function arguments, return addresses, local variables, base pointer addresses and even register's values.
<br>
<br>

#### How do pushl and popl affect the stack? What special-purpose register do they affect?

pushl pushes provided value on to the stack. popl pops value from the top of the stack and places popped value in provided address. When using pushl and popl, stack pointer register(%esp) which holds the address to the top of the stack is automatically updated.

It's worth mentioning that stack pointer points to the last element of the stack, not the empty spot after it. When pushl command is fired, first stack pointer is updated and provided value is pushed onto stack. The stack grows from top to bottom, meaning the memory addresses of newly pushed elements will be lower.
<br>
<br>

#### What are local variables and what are they used for?

Local variables are variables which are needed locally in a function. We can access local variables only from inside the function(Technically we can access them from anywhere but we shouldn't). They are dismissed after function returns. On every new function call, new set of local variables are allocated.
<br>
<br>

#### Why are local variables so necessary in recursive functions?

Local variables in recursive functions are essential because, in every new recursive call we need to have fresh local variables, which won't be touched by other function calls.
<br>
<br>

#### What are %ebp and %esp used for?

%ebp and %esp are special purpose CPU registers.

%ebp is a base pointer, which is placed in function's stack frame, between function arguments + return address and function's local variables.
It is used to access function's arguments and local variables.

%esp is stack pointer which always points to the top of the stack. It is used for managing stack basically. Technically it's not strictly required. We can get the job done by using only base pointer, but it's always good for consistency to have pointer to the top of the stack.
<br>
<br>

#### What is a stack frame?

Stack frame is a contiguous chunk of memory allocated for the function call. It includes data like function arguments, return address, local variables, old base pointer address and even register values before calling that function.
<br>
<br>

## Use the Concepts

#### Explain the problems that would arise without a standard calling convention.

If we didn't use standard calling conventions, every programmer would implement function calls in their
own way. It would be hard for other programmers to wrap their had around other's code.
<br>
<br>

## Going Further

#### Do you think it’s better for a system to have a large set of primitives or a small one, assuming that the larger set can be written in terms of the smaller one?

Having both larger and smaller primitives has it's own pros and cons.

Smaller set of primitives helps programmers to understand the system more easily. It provides more flexibility and it's easier to maintain.

On the other hand, larger set of primitives ensures that programmers don't have to 'reinvent the wheel' for the common functionality all the time. Larger set of primitives provide lots of pre implemented functions, which are optimized and don't contain any bugs, eliminating mistakes a programmer could have made when implementing the same functions himself.

I think having larger primitive set but also keeping elementary primitives accessible is the best approach.
<br>
<br>

## Can you build a calling convention without using the stack? What limitations might it have?

We can but, without a stack we won't be able to call functions from inside of other functions.
For each function we need a storage in memory where parameters and local variables will be stored.
Because the number of CPU registers are limited, we need to use ram for that purpose. The memory where we will store that data needs to be managed in a way that local variables, arguments and return addresses of different functions won't be mixed up. The stack does all of this for us.
