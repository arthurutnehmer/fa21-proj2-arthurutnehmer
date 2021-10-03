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

    # Prologue
    #save index at beggining
    add a5,x0,x0
    add a5, a1, a5
    #our current word
    add a2, x0,x0
    # out largest index
    add a3, x0,x0
    #our largest word
    add a4, x0,x0
    # check if array is equal to or less than zero
    bge x0, a1, exit_code_error
    # set largest index and word to first
    addi a3, a3, 1
    lw a4, 0(a0)
loop_start:
    # load word into a2
    lw a2, 0(a0)
    # if our current word is largest keep going.
    bge a4, a2 larger
    # if current is largest we save it.
    mv a4, a2
    mv a3, a1

    larger:
    # increment address
    addi a0, a0, 4

    # sub from index
    addi a1, a1, -1

	bgt a1, x0, loop_start

loop_end:
    # Epilogue
    sub a0, a5, a3
	ret

exit_code_error:
    add a0, x0, x0
    addi a0, a0, 57
