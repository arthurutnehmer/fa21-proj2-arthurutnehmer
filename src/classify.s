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
    addi sp, sp, -52  # Decrement stack pointer
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
    sw s11, 44(sp)    # our result of mat mul
    sw ra, 48(sp)     # save ra

    mv s3, a1   # save the file path array pointer to s3 (a1)
    mv s4, a2   # save (a2) to s4 Classification integer



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

    mul a0, s5, s10            # set a0 to rows m0 x columns input
    addi a2, x0, 4             # we want to mul by 4 to get size
    mul a0, a0, a2             # mul size by 4 to get the memory size
    jal ra malloc              # get a0 of size
    beq a0, x0, malloc_failed  # error

    mv s11, a0             # set s11 to result array
    mv a6, a0              # set a6 to the result array
    mv a0, s0              # set s0 to m0 address
    mv a1, s5              # set a1 to height of m0
    mv a2, s6              # set a1 to width of m0
    mv a3, s2              # set a3 to input (address)
    mv a4, s9              # set a4 to height of input
    mv a5, s10             # set a5 to width of input
    jal ra matmul          # multiply m0 by input and return as new matrix.

    mv a0, s11             # set a0 to s11
    mul a1, s5, s10        # set a0 to rows m0 x columns input
    jal ra relu            # we then take the rel of s11

    # register for m0 (s0) now becomes the address for 0
    mv a0, s0         # move s0 address to a0 to clear
    jal ra free       # clears memory attached to (s0)



    mul a0, s7, s10            # set a0 to rows m1 x columns h (input)
    addi a2, x0, 4             # we want to mul by 4 to get size
    mul a0, a0, a2             # mul size by 4 to get the memory size
    jal ra malloc              # get a0 of size
    beq a0, x0, malloc_failed  # error
    mv s0, a0                  # s0 is now o from mat mul

    mv a6, a0         # set a6 to the address we got from malloc
    mv a0, s1         # set a0 to m1 address
    mv a1, s7         # set a1 to height of m1
    mv a2, s8         # set a2 to width of m1
    mv a3, s11        # set a3 to h (s11)
    mv a4, s5         # set a4 to rows m0
    mv a5, s10        # set a5 to columns input
    jal ra matmul            # multiply m1 x h


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
     lw a0, 16(s3)     # set a0 to write file path
     mv a1, s0         # set a1 to 0 matrix
     mv a2, s7         # set a2 to rows m1
     mv a3, s10        # set a3 to columns input
     jal ra write_matrix      # write matrix to file




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s0         # set a0 to 0 (s0)
    mul a1, s7, s10  # set a1 to rows m1 x columns input
    jal ra argmax     # compute the argmax
    mv s5, a0         # save argmax as (s1)
    bne x0, s4, next  # go next if no equal to zero

    # Print classification
    mv a1, a0         # move argmax to a1
    jal ra print_int  # print the integer

    # Print newline afterwards for clarity
    addi a1, x0,10
    jal ra print_char # print new line

next:

    mv a0, s0   # free s0
    jal ra free # frees s0

    mv a0, s1   # free s1
    jal ra free # frees s1

    mv a0, s2   # free s2
    jal ra free # frees s2

    mv a0, s3   # free s3
    jal ra free # frees s3

    mv a0, s5  # set a0 to the value we want

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
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp 52

    jr ra


args_error:
    addi a1, x0, 72
    call exit2

malloc_failed:
    addi a1, x0, 88
    call exit2