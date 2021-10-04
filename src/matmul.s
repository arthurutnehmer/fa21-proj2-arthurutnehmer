.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of A
#	a1 (int)   is the # of rows (height) of A
#	a2 (int)   is the # of columns (width) of A
#	a3 (int*)  is the pointer to the start of B
# 	a4 (int)   is the # of rows (height) of B
#	a5 (int)   is the # of columns (width) of B
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
    bge x0, a1, error_59  # A height
    bge x0, a2, error_59  # A width
    bge x0, a4, error_59  # B height
    bge x0, a5, error_59  # B width
    bne a2, a4, error_59  # width A and height B

    #prologue
    addi sp, sp -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)

    add s0, x0, x0   # set traverse word size to 0
    addi s0, s0, 4   # size to increment by (4 bytes for word)
    mul s0, s0, a2  # size to jump in order to traverse A by row

    mv s1, a3 # set s1 to the address of the beginning of B.

    mv s3, a5  #value for stride of B is s3

loop_start:
    add a3, x0, s1        # restart the address for B back to the beginning
    add a5, x0, x0
    add, a5, x0, s3   #reset the a5 width for B back to zero
    inner_loop_start:


        # have to backup here for call
        addi sp,sp, -36
        sw a0, 0(sp)
        sw a1, 4(sp)
        sw a2, 8(sp)
        sw a3, 12(sp)
        sw a4, 16(sp)
        sw a5, 20(sp)
        sw a6, 24(sp)

                     # a0 is already start of A
        mv a1, a3    # set a1 to pointer for B
                     # a2 already width of the vectors
        add a3, x0, x0    # set a3 to 0
        addi a3, a3, 1 # a3 (A) has a stride of 1
        add a4, x0, s3  # a4  (B) has a stride equal to its width s3

        jal ra dot

        mv t5, a0 # set t5 to ret value


        # call finished now bring back parameters
        lw a0, 0(sp)
        lw a1, 4(sp)
        lw a2, 8(sp)
        lw a3, 12(sp)
        lw a4, 16(sp)
        lw a5, 20(sp)
        lw a6, 24(sp)

        addi sp, sp, 36

        sw t5, 0(a6) # save the value in array

        addi a6, a6, 4    # increment the array d
        addi a3, a3, 4      # increment array address of B by offset (word size * m)
        addi a5, a5, -1     # subtract from height of A
        bgt a5, x0, inner_loop_start  # loop if more index


    add a0, a0, s0      # increment array address of A by offset (word size * m)
    addi a1, a1, -1     # subtract from height of A
	bgt a1, x0, loop_start  # loop if more index


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp,sp, 20
    jr ra


error_59:
    add a1, x0,x0
    addi a1, x0, 59
    call exit2