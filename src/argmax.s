.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:

    addi sp, sp, -4
    sw ra, 0(sp)  # save ra

    bge x0, a1, exit_code_error   # check if array is equal to or less than zero
    # Prologue
    add a5,x0,x0
    add a5, a1, a5                # save index at beginning
    add a2, x0,x0                 # our current word
    add a3, x0,x0               # out largest index
    add a4, x0,x0              #our largest word

    addi a3, a3, 1                     # set largest index and word to first
    lw a4, 0(a0)
loop_start:
    lw a2, 0(a0)      # load word into a2
    bge a4, a2 larger  # if our current word is largest keep going.
    mv a4, a2         # if current is largest we save it.
    mv a3, a1

    larger:
    addi a0, a0, 4   # increment address

    addi a1, a1, -1    # sub from index

	bgt a1, x0, loop_start

loop_end:
    # Epilogue
    sub a0, a5, a3

    lw ra, 0(sp)
    addi sp, sp 4

	jr ra

exit_code_error:
    add a1, x0, x0
    addi a1, x0, 57
    call exit2

