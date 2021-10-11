.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi, a3, x0, 5          # Set a3 to command line args
    bne a0, a3, args_error   # Branch if a0 has wrong # errors

    # Prologue
    addi sp, sp, -48  # Decrement stack pointer
    sw s0, 0(sp)      # address to first array m0
    sw s1, 4(sp)      # address to second array m1
    sw s2, 8(sp)      # address to third array input
    sw s3, 12(sp)     # File path of arrays (a1)
    sw s4, 16(sp)     # saves (a2) print classification
    sw s5, 20(sp)     # save the rows m0
    sw s6, 24(sp)     # save the columns m0
    sw s7, 28(sp)     # save the rows m1
    sw s8, 32(sp)     # save the columns m1
    sw s9, 36(sp)     # save the rows input
    sw s10, 40(sp)    # save the columns input
    sw ra, 44(sp)     # save ra

    mv s3, a1   # save the file path array pointer to s3 (a1)
    mv s4, a2   # save (a2) to s4 Classification integer

    # Create stack pointers that will hold the address that contains array size.
    addi, sp, sp, -24    # create spots for 6 integers (array size)


	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0
    lw a0, 4(s3)         # set a0 to pointer to first array
    addi sp, sp -8       # create two spots in the stack
    mv a1, sp            # Set a1 to the stack pointer
    addi a2, sp, 4       # set a2 to the stack pointer offset
    jal ra read_matrix   # pass back a0 (pointer to matrix)
    mv s0, a0            # store m0 address as s0
    lw s5, 0(sp)         # set s5 to rows for m0
    lw s6, 4(sp)         # set s6 to columns for m0
    addi sp, sp, 8       # restore stack pointer

    # Load pretrained m1
    lw a0, 8(s3)         # set a0 to pointer to second array m1
    addi sp, sp -8       # create two spots in the stack
    mv a1, sp            # Set a1 to the stack pointer
    addi a2, sp, 4       # set a2 to the stack pointer offset
    jal ra read_matrix   # pass back a0 (pointer to matrix)
    mv s1, a0            # set s1 to address to m1
    lw s7, 0(sp)         # set s7 to rows for m1
    lw s8, 4(sp)         # set s8 to columns for m1
    addi sp, sp, 8       # restore stack pointer

    # Load input matrix
    lw a0, 12(s3)        # set a0 to pointer to third array input
    addi sp, sp -8       # create two spots in the stack
    mv a1, sp            # Set a1 to the stack pointer
    addi a2, sp, 4       # set a2 to the stack pointer offset
    jal ra read_matrix   # pass back a0 (pointer to matrix)
    mv s2, a0            # set s2 to address to input
    lw s9, 0(sp)         # set s9 to rows for input
    lw s10, 4(sp)        # set s10 to columns for input
    addi sp, sp, 8       # restore stack pointer





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
















    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification




    # Print newline afterwards for clarity


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw ra, 44(sp)
    addi sp, sp 48

    ret


args_error:
    addi a1, x0, 72
    call exit2