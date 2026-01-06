.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    ble a1, zero, exit_with_72
    ble a2, zero, exit_with_72
    ble a4, zero, exit_with_73
    ble a5, zero, exit_with_73
    bne a2, a4, exit_with_74

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    mv s0, a0       # m0
    mv s1, a1       # m0 rows
    mv s2, a2       # m0 cols
    mv s3, a3       # m1
    mv s4, a4       # m1 rows
    mv s5, a5       # m1 cols
    mv s6, a6       # output array

    li t0, 0        # i
    li t1, 0        # j

loop:
    mul t2, t0, s2
    slli t2, t2, 2
    add a0, s0, t2  # v0

    mv t2, t1
    slli t2, t2, 2
    add a1, s3, t2  # v1

    mv a2, s2       # length of vectors
    li a3, 1        # stride v0
    mv a4, s5       # stride v1

    sw t0, 32(sp)
    sw t1, 36(sp)
    jal dot
    lw t1, 36(sp)
    lw t0, 32(sp)

    mv t2, t0       # t2 = i * m1_cols + j
    mul t2, t2, s5
    add t2, t2, t1
    slli t2, t2, 2
    mv t3, s6
    add t3, t3, t2
    sw a0, 0(t3)

    addi t1, t1, 1
    blt t1, s5, loop

    li t1, 0
    addi t0, t0, 1
    blt t0, s1, loop

    # Epilogue
    lw ra, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 40

    mv a6, s6
    ret

exit_with_72:
    li a0, 17
    li a1, 72
    ecall

exit_with_73:
    li a0, 17
    li a1, 73
    ecall

exit_with_74:
    li a0, 17
    li a1, 74
    ecall
