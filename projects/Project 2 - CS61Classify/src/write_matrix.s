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
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0           # pointer to filename string
    mv s1, a1           # pointer to matrix
    mv s2, a2           # n of rows
    mv s3, a3           # n of cols

    # Open file with write only permission
    mv a1, s0           # pointer to filename
    li a2, 1            # permission: 1 = write only
    jal fopen
    li t0, -1
    beq a0, t0, exit_with_93
    mv s4, a0           # file descriptor (unique integer tied to file)

    # Write n of rows
    mv a1, s4           # fd
    sw s2, 24(sp)
    addi a2, sp, 24     # address n of rows
    li a3, 1            # n of elements to write out of buffer
    li a4, 4            # size of each buffer element in bytes
    jal fwrite
    li t0, 1
    bne a0, t0, exit_with_94

    # Write n of cols
    mv a1, s4           # fd
    sw s3, 24(sp)
    addi a2, sp, 24     # address of register containing n of cols
    li a3, 1            # n of elements to write out of buffer
    li a4, 4            # size of each buffer element in bytes
    jal fwrite
    li t0, 1
    bne a0, t0, exit_with_94

    # Write matrix
    mv a1, s4           # fd
    mv a2, s1           # matrix start address
    mul a3, s2, s3      # n of elements to write out of buffer
    li a4, 4            # size of each buffer element in bytes
    jal fwrite
    mul t0, s2, s3
    bne a0, t0, exit_with_94

    # Close file
    mv a1, s4           # fd
    jal fclose
    li t0, -1
    beq a0, t0, exit_with_95

    # Epilogue
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 28

    ret

exit_with_93:
    li a0, 17
    li a1, 93
    ecall

exit_with_94:
    li a0, 17
    li a1, 94
    ecall

exit_with_95:
    li a0, 17
    li a1, 95
    ecall
