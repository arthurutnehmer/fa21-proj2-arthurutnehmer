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
    sw s0, 0(sp)      # address to first array
    sw s1, 4(sp)      # address to second array
    sw s2, 8(sp)      # address to third array
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



    lw a1 0(a0)
    lw a2 4(a0)
    lw a3 12(a0)

    lw a0, 0(sp)
    lw a1, 4(sp)


    addi sp, sp, 8       # restore stack pointer







    # Load pretrained m1






    # Load input matrix






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