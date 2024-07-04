## Know the Concepts

#### Describe the fetch-execute cycle.

Fetch execute cycle is a process in which cpu fetches instructions from memory and executes them. Pc(program counter register) is used to determine address of the next memory register(word) which holds the instruction.

#### What is a register? How would computation be more difficult without registers?

A register is a fixed block of memory, usually 8, 16, 32, or 64 bits long, that can hold data temporarily. When we say "register," we usually refer to CPU registers, though the term can also apply to RAM registers or other types of registers.

CPU registers provide very fast data access because they are located close to the ALU (Arithmetic Logic Unit). There are only a few registers, which means addressing them is extremely fast due to the minimal circuitry required for read and write operations. In contrast, RAM can have billions of storage locations, so selecting a particular memory location requires electrical signals to travel through relatively long wires, making the process slower.

The ALU is designed to receive inputs from a fixed number of registers, and much of its logic relies on this configuration. Without registers, the CPU's instruction set and architecture would be much more complex and less efficient.

#### How do you represent numbers larger than 255?

To represent numbers larger than 255, multiple bytes are used together. Fortunately it is handled on hardware level. For example in x86-32 architecture 32 bit registers are provided. They can be used to store 32 bit numbers.

#### How big are the registers on the machines we will be using?

32 bits.

#### How does a computer know how to interpret a given byte or set of bytes of memory?

For a computer it's impossible to know what a particular byte represents. It's our job to process every byte in a proper way. Usually we divide memory in several parts and in each part we store bytes and process them in different ways. For example there is a separate part of memory where cpu instructions are stored. We organize it in a way that memory located there in not overwritten. PC register points to that location, allowing the CPU to fetch and execute bytes interpreted as instructions. Even if PC was pointed to some other memory which is not an instruction, it would be fetched by CPU and executed anyways, potentially leading to errors.

#### What are the addressing modes and what are they used for?

Addressing modes are different ways by which CPUs can access data. They can be used to specify operands location.

For example if we have an array with 10 elements in memory and each element is 4 bytes in size, using indexed addressing mode would be convenient.
In indexed addressing mode we provide base memory address, and use index register to offset this address. We can write a simple loop where we increment this register and it will give us different memory address in each iteration. Additionally, using a multiplier for the index allows us to access the full 4 bytes of each integer in the array.

#### What does the instruction pointer do?

Instruction pointer holds the instruction's address which the CPU needs to fetch and execute next.

<br>
<br>

## Use the Concepts

#### What data would you use in an employee record? How would you lay it out in memory?

To store customer records in memory I would use pointers as discussed in chapter 1. Every pointer would be 4 bytes(1 word) long because we are working in 32 bit system and addressable memory ranges from 0 to 2^32 - 1(inclusive).

First word(4 byte) would be a pointer to customer's name. The second word to address. Third one to age. And the fourth one to an id number.

#### If I had the pointer the the beginning of the employee record above, and wanted to access a particular piece of data inside of it, what addressing mode would I use?

We would likely use base pointer addressing mode.
It's similar to indirect addressing mode in a way that, it allows us to specify an address, take the value from this address and use this value to address another word and load it's value. Beyond that, base pointer addressing mode allows us to specify base address and offset which suits our case.

In our case we have an array of pointers. To work with an array we want an addressing mode which will allow us to access elements based on base address and an offset. To dereference those elements we want features of indirect addressing as well. All of these are provided in base pointer addressing mode.

#### In base pointer addressing mode, if you have a register holding the value 3122, and an offset of 20, what address would you be trying to access?

First we will read a word with address of base + offset which is 3142. We will try to access address which is the value of the word with address of 3142.

#### In indexed addressing mode, if the base address is 6512, the index register has a 5, and the multiplier is 4, what address would you be trying to access?

6512 + 5 \* 4 which is 6532

#### In indexed addressing mode, if the base address is 123472, the index register has a 0, and the multiplier is 4, what address would you be trying to access?

123472 + 0 \* 4 which is 123472

#### In indexed addressing mode, if the base address is 9123478, the index register has a 20, and the multiplier is 1, what address would you be trying to access?

9123478 + 20 \* 1 which is 9123498

<br>
<br>

## Going Further

#### What are the minimum number of addressing modes needed for computation?

I think 1 is enough, because we can imitate other modes ourselves if we can just write and read from registers.

#### Why include addressing modes that aren’t strictly needed?

It's true that we don't always need all the modes, but when we need functionality that those modes provide(and we often need it), we don't have to write lots of code from scratch to get needed functionality. We can use standard, structured approach provided by those modes which are often more efficient as well.

#### Research and then describe how pipelining (or one of the other complicating factors) affects the fetch-execute cycle.

Pipelining drastically speeds up the processing of instructions by dividing instruction execution into several stages, allowing multiple instructions to be processed simultaneously. For example, a RISC CPU typically has five stages of instruction processing:

- Stage 1 (Instruction Fetch) - In this stage the CPU reads instructions from the address in the memory whose value is present in the program counter.
- Stage 2 - (Instruction Decode) In this stage, instruction is decoded and the register file is accessed to get the values from the registers used in the instruction.
- Stage 3 - (Instruction Execute) In this stage, ALU operations are performed.
- Stage 4 - (Memory Access) In this stage, memory operands are read and written from/to the memory that is present in the instruction.
- Stage 5 - (Write Back) In this stage, computed/fetched value is written back to the register present in the instructions.

Lets assume that each stage takes 1 clock cycle to finish. Without pipelining, to process k instructions we would need to spend k \* 5 clock cycles.

How does pipelining work and why it speeds up processing time.

In a non-pipelined CPU, after the first instruction completes stage 1, the CPU must wait for all remaining stages to complete before fetching the next instruction. This results in significant inefficiencies, as each stage remains idle for a substantial portion of the time.
We can observe that, in instruction processing when stage 1 is finished, nothing happens on stage 1 for 4 cpu cycles. Same can be said for every single stage. To resolve this inefficiency we can fetch another instruction and do stage 1 processing on it while first instruction is on stage 2. When first instruction goes to stage 3, second instruction moves to stage 2 processing and a new instruction is being processed in stage 1. This is the reason why pipelining speeds up processing. Basically it allows different instructions to be processed simultaneously.

source:
https://www.geeksforgeeks.org/computer-organization-and-architecture-pipelining-set-1-execution-stages-and-throughput/

#### Research and then describe the tradeoffs between fixed-length instructions and variable-length instructions.

Fixed length instructions are simple to decode but they might occupy more bits than needed, thus wasting some memory.

On the other hand, fixed length instructions are more memory efficient because they only occupy number of bits that are actually needed for the instruction. However, because of their variable length, they are harder to decode, leading to more complicated cpu design.
