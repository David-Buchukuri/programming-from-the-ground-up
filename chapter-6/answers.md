## Know the Concepts

#### What is a record?

A record is a structured piece of data which is often saved on a hard disk. It often consists of fixed amount of fields, each taking up certain amount of space in memory.
<br>
<br>


#### What is the advantage of fixed-length records over variable-length records?

They are easier to work with.
<br>
<br>

#### How do you include constants in multiple assembly source files?

To include constants in a source file, we can specify path to the file with .include directive, at the 
start of the source file.
<br>
<br>

#### Why might you want to split up a project into multiple source files?

When different logical parts are divided in multiple files, it's easier to reason about the functionalify of the program.
<br>
<br>

#### What does the instruction incl record_buffer + RECORD_AGE do? What addressing mode is it using? How many operands does the incl instruction have in this case? Which parts are being handled by the assembler and which parts are being handled when the program is run?

`incl record_buffer + RECORD_AGE` increments value at a memory location of `record_buffer + RECORD_AGE`. 
immiediate addresing mode is used. 
in this case, incl instruction has one operand because, `record_buffer + RECORD_AGE` is an expression which returns a single value. That value is the operand of the incl instruction.
<br>
<br>


