.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    bge x0, a2, error_57
    bge x0, a3, error_58
    bge x0, a4, error_58

    # Prologue
    addi sp,sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)

    add s0, x0, x0  # clear s0 (first array num)
    add s1, x0, x0  # clear s1 (second array num)
    add s2, x0, x0  # clear s2 (total sum)

    addi, s0, s0, 4  # multiply word tmp.
    mul a3, a3, s0   # set stride to bit len in bytes for v0
    mul a4, a4, s0   # set stride to word len in bytes for v1
    add s0, x0, x0  # reset to zero

loop_start:

    lw s0, 0(a0)     #load value from v1 address
    lw s1, 0(a1)     #load value from v2 address
    mul s0, s1, s0   #multiply both values at index
    add s2, s0, s2   #add value to sum

    add a0, a0, a3   # increment address of v0
    add a1, a1, a4   # increment address of v1
    addi a2, a2, -1    # sub from index
	bgt a2, x0, loop_start

loop_end:

    mv a0, s2  #set return register to sum value
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    jr ra

error_57:
    add a1, x0, x0
    addi a1, x0, 57
    call exit2


error_58:
    add a1, x0,x0
    addi a1, x0, 58
    call exit2

