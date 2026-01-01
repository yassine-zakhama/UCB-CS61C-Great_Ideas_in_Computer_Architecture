.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi t2, x0, 1      # break condition: var == 1
    add t0, x0, a0      # var = n - 1
    sub t0, t0, t2
loop:
    mul a0, a0, t0      # res *= var
    sub t0, t0, t2      # var--
    bne t0, t2, loop    # var != 1
    ret
