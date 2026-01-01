.globl main

.data
source:            # source is a word array terminated by 0
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:              # dest is a zero-initialized word array
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
fun:
    addi t0, a0, 1      # x + 1
    sub t1, x0, a0      # -x
    mul a0, t0, t1      # -x * (x + 1)
    jr ra

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    # END PROLOGUE
    addi t0, x0, 0      # k = 0
    addi s0, x0, 0      # sum
    la s1, source       # pointer to source (la = "load address")
    la s2, dest         # pointer to dest
loop:
    slli s3, t0, 2      # Multiply k by 4 (bytes) for array indexing
    add t1, s1, s3      # t1 = &source[k]
    lw t2, 0(t1)        # t2 = source[k]
    beq t2, x0, exit    # break condition: source[k] == 0
    add a0, x0, t2      # x = source[k]
    addi sp, sp, -8     # adjust stack for 2 items
    sw t0, 0(sp)        # save k
    sw t2, 4(sp)        # save source[k]
    jal fun
    lw t0, 0(sp)        # restore k
    lw t2, 4(sp)        # restore source[k]
    addi sp, sp, 8      # free used stack resources
    add t2, x0, a0      # t2 = fun(source[k])
    add t3, s2, s3      # t3 = &dest[k]
    sw t2, 0(t3)        # dest[k] = fun(source[k])
    add s0, s0, t2      # sum += dest[k]
    addi t0, t0, 1      # k++
    jal x0, loop        # loop end
exit:
    add a0, x0, s0
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    # END EPILOGUE
    jr ra
