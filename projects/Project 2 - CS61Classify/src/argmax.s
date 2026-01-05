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
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    ble a1, zero, exit_with_77

    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)

    mv s0, a0
    li t0, 1            # counter
    lw t1, 0(a0)        # current max
    li a0, 0            # result

loop:
    mv t2, s0           # address of the array
    slli t3, t0, 2
    add t2, t2, t3      # offset the array address by the count
    lw t4, 0(t2)        # load arr[i]
    ble t4, t1, loop_continue   # if arr[i] <= currMax: continue
    mv t1, t4           # else currMax = arr[i]
    mv a0, t0           # result = i
loop_continue:
    addi t0, t0, 1
    bne t0, a1, loop

    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4

    ret

exit_with_77:
    li a0, 17
    li a1, 77
    ecall
