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
    addi sp, sp, -28  #decrement stack pointer
    sw s0, 0(sp)   # pointer to filename
    sw s1, 4(sp)   #  pointer to start of matrix
    sw s2, 8(sp)   #  number of rows in matrix.
    sw s3  12(sp)  #  number of columns in matrix.
    sw s4  16(sp)  # The file descriptor
    sw s5  20(sp)  # number of elements to write to file
    sw ra, 24(sp)


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



    addi sp, sp, -4         # decrement stack pointer to store
    sw s2, 0(sp)            # Save s2 at stack pointer
    mv a1, s4               # Set a1 to file descriptor
    mv a2, sp               # Pointer to write to file (the stack pointer)
    addi a3, x0, 1          # Number of elements to write to file
    addi a4, x0, 4          # Size of each element
    mv s5, a3               # Backup number of elements to write to file.
    jal ra fwrite           #  write first rows to matrix
    bne a0, s5, write_error #  branch if an issue
    addi sp, sp, 4          # restore the stack


    addi sp, sp, -4         # decrement stack pointer to store
    sw s3, 0(sp)            # Save s3 at stack pointer (number of columns)
    mv a1, s4               # Set a1 to file descriptor
    mv a2, sp               # Pointer to write to file (the stack pointer)
    addi a3, x0, 1          # Number of elements to write to file
    addi a4, x0, 4          # Size of each element
    mv s5, a3               # Backup number of elements to write to file.
    jal ra fwrite           #  write first rows to matrix
    bne a0, s5, write_error #  branch if an issue
    addi sp, sp, 4          # restore the stack


    mul a1, s2, s3          # Calculate the number of rows and columns
    addi a2, x0, 4           # size of 4 bytes
    mul a1, a2, a1          # size = rows*columns*4
    addi a3, x0, 1          # Number of elements to write to file
    add a4, x0, a1          # Size of each element rows*columns*4
    mv a1, s4               # Set a1 to file descriptor
    mv a2, s1               # Pointer to write to file
    mv s5, a3               # Backup number of elements to write to file.
    jal ra fwrite           #  write first rows to matrix
    bne a0, s5, write_error #  branch if an issue


    mv a1, s4                       # set a1 to file descriptor
    jal ra fclose                   # close the file
    bne a0, x0, close_error        # check if error -1 is present


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp 28

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