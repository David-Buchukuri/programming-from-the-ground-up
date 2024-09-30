# PURPOSE: Program to manage memory usage - allocates and deallocates memory as requested

# NOTES: The programs using these routines will ask
# for a certain size of memory. We actually
# use more than that size, but we put it
# at the beginning, before the pointer
# we hand back. We add a size field and
# an AVAILABLE/UNAVAILABLE marker. So, the
# memory looks like this
#
# #########################################################
# # Available Marker # Size of memory # Actual memory locations #
# #########################################################
#                                       ^--Returned pointer points here
.include "../linux.asm"

.section .data

# GLOBAL VARIABLES
    # The beginning of the memory we are managing
    heap_begin: .long 0
    # The location past the memory we are managing
    current_break: .long 0

# STRUCTURE INFORMATION
    # Size of space for memory region header
    .equ HEADER_SIZE, 8
    # Location of the "available" flag in the header
    .equ HDR_AVAIL_OFFSET, 0
    # Location of the size field in the header
    .equ HDR_SIZE_OFFSET, 4

# CONSTANTS
    # This is the number we will use to mark space that has been given out
    .equ UNAVAILABLE, 0
    # This is the number we will use to mark space that has been freed, and is available for giving 
    .equ AVAILABLE, 1 

.section .text

## FUNCTIONS ##

# allocate_init #
# PURPOSE: call this function to initialize the heap_begin and current_break variables. 
# This has no parameters and no return value.

.globl allocate_init
.type allocate_init,@function
allocate_init:
    pushl %ebp
    movl %esp, %ebp

    # If the brk system call is called with 0 in %ebx, it returns the last valid usable address
    movl $SYS_BRK, %eax #find out where the break is
    movl $0, %ebx
    int $LINUX_SYSCALL

    # %eax now has the last valid address, and we want the memory location after that
    incl %eax 
    movl %eax, current_break
    movl %eax, heap_begin

    movl %ebp, %esp
    popl %ebp
    ret




# allocate #
# PURPOSE: This function is used to grab a section of memory. It checks to see if there are any
# free blocks, and, if not, it asks Linux for a new one.
#
#PARAMETERS: This function has one parameter - the size of the memory block we want to allocate
#
#RETURN VALUE:
# This function returns the address of the allocated memory in %eax. If there is no
# memory available, it will return 0 in %eax
#
# PROCESSING #
# Variables used:
#
# %ecx - hold the size of the requested memory (first/only parameter)
# %eax - current memory region being examined
# %ebx - current break position
# %edx - size of current memory region
#
# We scan through each memory region starting with heap_begin. We look at the size of each one, and if
# it has been allocated. If it’s big enough for the requested size, and its available, it grabs that one.
# If it does not find a region large enough, it asks Linux for more memory. In that case, it moves
# current_break up

.globl allocate
.type allocate,@function
.equ ST_MEM_SIZE, 8 #stack position of the memory size to allocate

allocate:
    pushl %ebp
    movl %esp, %ebp

    # check if allocate init was not called and call it if that's the case
    cmpl $0, heap_begin
    jne start_allocating
    call allocate_init

   
    # if call to allocate_in_existing_memory_regions function was successfull, 
    # return memory address returned from that function call
    start_allocating:
    pushl ST_MEM_SIZE(%ebp)
    call allocate_in_existing_memory_regions
    addl $4, %esp
    cmpl $0, %eax
    jne return_allocate

    # if we couldn't allocate in existing regions, ask Linux to map more memory for us
    pushl ST_MEM_SIZE(%ebp)
    call allocate_by_moving_break
    addl $4, %esp


    return_allocate:
        movl %ebp, %esp
        popl %ebp
        ret

   

# deallocate #
# PURPOSE:
# The purpose of this function is to give back a region of memory to the pool after we’re done using it.
#
#PARAMETERS:
# The only parameter is the address of the memory we want to return to the memory pool.
#
#RETURN VALUE:
# There is no return value
#
#PROCESSING:
# If you remember, we actually hand the program the start of the memory that they can use, which is
# 8 storage locations after the actual start of the memory region. All we have to do is go back
# 8 locations and mark that memory as available, so that the allocate function knows it can use it.
.globl deallocate
.type deallocate,@function

# stack position of the memory region to free
.equ ST_MEMORY_SEG, 4

deallocate:
    movl ST_MEMORY_SEG(%esp), %eax

    #get the pointer to the real beginning of the memory
    subl $HEADER_SIZE, %eax

    #mark it as available
    movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

    ret



allocate_in_existing_memory_regions:
    pushl %ebp
    movl %esp, %ebp

    # %ecx - the size of requested of a region(the only parameter)
    # %eax - current search location
    # %ebx - the current break
    movl ST_MEM_SIZE(%ebp), %ecx 
    movl heap_begin, %eax 
    movl current_break, %ebx 

    alloc_loop_begin:
        # if these are equal, we dont have any existing memory regions available or big enough
        cmpl %ebx, %eax 
        je valid_region_not_found

        # grab the size of this memory region
        movl HDR_SIZE_OFFSET(%eax), %edx

        # If the space is unavailable, go to the next location
        cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        je next_location 

        # If the space is available, compare the size to the needed size. If its big enough, allocate
        cmpl %edx, %ecx 
        jle allocate_in_existing_memory_region 

        next_location:
            addl $HEADER_SIZE, %eax
            addl %edx, %eax 
            jmp alloc_loop_begin


    valid_region_not_found:
        movl $0, %eax
        jmp return_allocate_in_existing_memory_regions

    allocate_in_existing_memory_region:
        # size left for another memory region is -> size of the current mem region - requested size - 8
        # if the result is positive we can split into 2 regions
        subl %ecx, %edx
        subl $HEADER_SIZE, %edx
        cmpl $0, %edx
        jg split_regions

        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        addl $HEADER_SIZE, %eax
        jmp return_allocate_in_existing_memory_regions

        split_regions:
        # set first header and unavailable and adjust it's size
        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        movl %ecx, HDR_SIZE_OFFSET(%eax)

        # save value of the first header. Later we want to return that + header size
        pushl %eax

        # next address of the header
        addl HDR_SIZE_OFFSET(%eax), %eax
        addl $HEADER_SIZE, %eax

        # set header values fro the second region
        movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
        movl %edx, HDR_SIZE_OFFSET(%eax)

        # calculate return value(pointer to the starting address of the first region)
        popl %eax
        addl $HEADER_SIZE, %eax
        jmp return_allocate_in_existing_memory_regions
        
    
    return_allocate_in_existing_memory_regions:
        movl %ebp, %esp
        popl %ebp
        ret


 allocate_by_moving_break:
    pushl %ebp
    movl %esp, %ebp

    # next breakpoint should be at address of header size + requested size + current break point
    # we ask linux to allocate till that address, write headers on address of previous break point
    # and return previous break point + 8


    # calculating next break address
    movl $HEADER_SIZE, %ebx
    addl current_break, %ebx
    addl ST_MEM_SIZE(%ebp), %ebx
    movl $SYS_BRK, %eax
    int $LINUX_SYSCALL

    # check for error conditions
    cmpl $0, %eax 
    je error

    # set header values
    movl current_break, %edi
    movl $UNAVAILABLE, (%edi)
    movl ST_MEM_SIZE(%ebp), %ecx
    movl %ecx, 4(%edi)

    # store start of usable memory in eax
    movl current_break, %eax
    addl $HEADER_SIZE, %eax

    #save the new break
    movl %ebx, current_break

    return_allocate_by_moving_break:
        movl %ebp, %esp
        popl %ebp
        ret

    error:
        movl $0, %eax #on error, we return zero
        jmp return_allocate_by_moving_break
