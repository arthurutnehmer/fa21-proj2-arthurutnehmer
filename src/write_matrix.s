.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24  #decrement stack pointer
    sw s0, 0(sp)   # pointer to filename
    sw s1, 4(sp)   #  pointer to start of matrix
    sw s2, 8(sp)   #  number of rows in matrix.
    sw s3  12(sp)  #  number of columns in matrix.
    sw s4  16(sp)  # The file descriptor
    sw ra, 20(sp)


    mv s0, a0  #   Save pointer to filename.
    mv s1, a1  #   Save pointer to start of matrix.
    mv s2, a2  #   Save number of rows in matrix.
    mv s3, a3  #   Save number of columns in matrix.

    addi a2, x0, 1            # set write permission to 1.
    mv a1, a0                 # Set a1 to file string pointer
    jal ra fopen              # Open file with a1 file name
    addi a2, x0, -1           # set a2 to -1
    beq a2, a0, fopen_error   # Branch if error
    mv s4, a0                 # Set s4 to file descriptor

    mv a1, s4               # Set a1 to file descriptor
    mv a2, s1               # Pointer to write to file
    addi a3, x0, 2          # Number of elements to write to file
    addi a4, x0, 4          # Size of each element (4 bytes per object

    jal ra fwrite           #  write first rows to matrix
    bne a0, a3, write_error #  branch if an issue











    mv a1, s4                       # set a1 to file descriptor
    jal ra fclose                   # close the file
    bne a0, x0, close_error        # check if error -1 is present


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp 24

    jr ra


close_error:
    addi a1, x0, 90
    call exit2

fopen_error:
    addi a1, x0, 89
    call exit2

write_error:
    addi a1, x0, 92
    call exit2