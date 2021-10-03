.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    add a2, x0,x0
    # check if array is equal to or less than zero
    bge x0, a1, exit_code_error

loop_start:
	#load word into a2
    lw a2, 0(a0)
    #greater than 0 dont change. Else change.
	bge a2,x0, positive
    sw x0 0(a0)
    positive:

    #increment address
    addi a0, a0, 4
    #sub from index
    addi a1, a1, -1
    
	bgt a1, x0, loop_start

loop_end:
    # Epilogue
	ret
exit_code_error:
    add a0, x0, x0
    addi a0, a0, 57