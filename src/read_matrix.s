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
    addi sp, sp, -16  # Make room on stack
    sw s0, 0(sp)  #  Memory address of the file name (a0)
    sw s1, 4(sp)  #  Memory address of the number of rows (a1)
    sw s2, 8(sp)  #  Memory address of the number of columns (a2)
    sw ra, 12(sp)

    mv s0, a0  #  set s0 to (a0)
    mv s1, a1  #  set s1 to (a1)
    mv s2, a2  #  set s2 to (a2)


    mv a1, a0  # Set a1 to file name
    addi a2, x0, 0 # set a2 to read only
    jal ra fopen # Open the file








    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp 16

    ret
