.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -32  # Make room on stack
    sw s0, 0(sp)  #  Memory address of the file name (a0)
    sw s1, 4(sp)  #  number of rows (a1)
    sw s2, 8(sp)  #  number of columns (a2)
    sw s3, 12(sp)  #  8 byte constant
    sw s4, 16(sp)  #  This is the file descriptor
    sw s5, 20(sp)  #  This is the allocation size.
    sw s6, 24(sp)  #  The address of the memory to return .
    sw ra, 28(sp)

    mv s0, a0  #  set s0 to string with file name (a0)
    addi s3, x0, 8 # set s3 to 8 for size of rows/ columns and heap

    mv a1, a0  # Set a1 to file name
    addi a2, x0, 0 # set a2 to read only


    jal ra fopen # Open the file (a0 file descriptor)
    addi a3, x0, -1 # set a3 to -1
    beq a0, a3, fopen_error



    mv s4, a0  # set s4 to a0 (the file descriptor)
    mv a0, s3
    jal ra malloc  # call malloc to allocate 8 bytes of memory for row and column.
    beq a0, x0, exit_malloc  # check return value a0 (pointer to memory)
    mv s6, a0 # save the pointer to s6



    mv a2, s6  # move (a0) memory allocated to a2
    mv a1, s4 # set a1 to file descriptor
    mv a3, s3  # size of 8 bytes
    jal ra fread # read 8 bytes from the file.
    bne a0, s3, read_error
    lw s1, 0(s6)  # save rows to s1
    lw s2, 4(s6)  # save columns to s2



    mul a0, s1, s2  # calculating the size of the malloc for the array.
    addi a2, x0, 4  # set a2 to 4.
    mul a0, a0, a2 # multiply a0 by 4 to get malloc
    mv s5, a0  # save size to s5

    jal ra malloc # allocate memory for the size of the array.
    beq a0, x0, exit_malloc  # check return value a0 (pointer to memory)

    mv a1, s4 # reload the file descriptor
    mv s6, a0 # move pointer to (s6) for memory
    mv a3, s5 # set (a3) to size of array
    mv a2, s6 # set a2 to the memory pointer
    jal ra fread # read the array to heap
    bne a0, s5, read_error





    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp 32
    mv a0, s6 # set a0 to return pointer
    jr ra

 exit_malloc:
    addi a1, x0, 88
    call exit2

fopen_error:
    addi a1, x0, 89
    call exit2

read_error:
    addi a1, x0, 91
    call exit2