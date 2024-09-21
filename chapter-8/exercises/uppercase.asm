#PURPOSE: This program converts an input file
# to an output file with all letters
# converted to uppercase.
#
#PROCESSING: 1) Open the input file
# 2) Open the output file
# 4) While we're not at the end of the input file
# a) read part of file into our memory buffer
# b) go through each byte of memory
# if the byte is a lower-case letter,
# convert it to uppercase
# c) write the memory buffer to output file


.section .data
####### CONSTANTS ########
    input_file: .ascii "text.txt\0"
    output_file: .ascii "text-upper.txt\0"
    input_file_open_type: .ascii "r\0"
    output_file_open_type: .ascii "w\0"


# This is the return value of read which means we've hit the end of the file
.equ END_OF_FILE, 0


.section .bss
.equ BUFFER_SIZE, 4
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
# STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FILE_STRUCT_IN, -4
.equ ST_FILE_STRUCT_OUT, -8

.globl _start
_start:
    # save the stack pointer
    movl %esp, %ebp

    # Allocate space for file structs
    subl $ST_SIZE_RESERVE, %esp

    pushl $input_file_open_type
    pushl $input_file
    call fopen
    movl %eax, ST_FILE_STRUCT_IN(%ebp)
    addl $8, %esp

    pushl $output_file_open_type
    pushl $output_file
    call fopen
    movl %eax, ST_FILE_STRUCT_OUT(%ebp)
    addl $8, %esp

    read_loop_begin:
        # READ A BLOCK FROM THE INPUT FILE
        pushl ST_FILE_STRUCT_IN(%ebp)
        pushl $BUFFER_SIZE
        pushl $1
        pushl $BUFFER_DATA
        call fread
        addl $16, %esp

        # EXIT IF WE'VE REACHED THE END
        # check how many bytes was read
        cmpl $END_OF_FILE, %eax

        # if number of bytes read is 0 or less(which indicates some error), go to the end
        jle end_loop


        # CONVERT THE BLOCK TO UPPER CASE
        pushl $BUFFER_DATA              # location of buffer
        pushl %eax                      # number of bytes read ftom the input file and stored in a buffer
        call convert_to_upper
        popl %eax                       # get the size back
        addl $4, %esp                   # restore %esp


        # WRITE THE BLOCK INTO THE OUTPUT FILE
        pushl ST_FILE_STRUCT_OUT(%ebp)
        pushl %eax
        pushl $1
        pushl $BUFFER_DATA 
        call fwrite
        addl $16, %esp


        # CONTINUE THE LOOP
        jmp read_loop_begin


        end_loop:
        # CLOSE THE FILES
        pushl ST_FILE_STRUCT_OUT(%ebp)
        call fclose
        addl $4, %esp

        pushl ST_FILE_STRUCT_IN(%ebp)
        call fclose
        addl $4, %esp

        ###EXIT###
        pushl $0
        call exit




    # PURPOSE: This function actually does the conversion to upper case for a block
    # INPUT: The first parameter is the location of the block of memory to convert.
    # The second parameter is the length of that buffer
    #
    # OUTPUT: This function overwrites the current buffer with the upper-casified version.
    #
    # VARIABLES:
    # %eax - beginning of buffer
    # %ebx - length of buffer
    # %edi - current buffer offset
    # %cl - current byte being examined
    # (first part of %ecx)
    #
    ### CONSTANTS ###
    # The lower boundary of our search
    .equ LOWERCASE_A, 'a'

    # The upper boundary of our search
    .equ LOWERCASE_Z, 'z'

    # Conversion between upper and lower case
    .equ UPPER_CONVERSION, 'A' - 'a'

    ###STACK STUFF###
    .equ ST_BUFFER_LEN, 8 # Length of buffer
    .equ ST_BUFFER, 12 # actual buffer


    convert_to_upper:
        pushl %ebp
        movl %esp, %ebp

        ###SET UP VARIABLES###
        movl ST_BUFFER(%ebp), %eax
        movl ST_BUFFER_LEN(%ebp), %ebx
        movl $0, %edi

        #if a buffer with zero length was given to us, just leave
        cmpl $0, %ebx
        je end_convert_loop

        convert_loop:
            # get the current byte
            movb (%eax,%edi,1), %cl

            # go to the next byte unless it is between 'a' and 'z'
            cmpb $LOWERCASE_A, %cl
            jl next_byte
            cmpb $LOWERCASE_Z, %cl
            jg next_byte

            # otherwise convert the byte to uppercase
            addb $UPPER_CONVERSION, %cl
            # and store it back
            movb %cl, (%eax, %edi, 1)

            next_byte:
                incl %edi # next byte
                cmpl %edi, %ebx # continue unless we've reached the end
                jne convert_loop

        end_convert_loop:
            #no return value, just leave
            movl %ebp, %esp
            popl %ebp
            ret

