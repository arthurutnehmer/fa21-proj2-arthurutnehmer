.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    li a1,0x12345678
    j print_hex
    #Return if not negative
	bgt a0, zero, done
    #will negate a0
    sub a0, x0, a0


done:
    ret
