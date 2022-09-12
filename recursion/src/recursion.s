.globl _start
_start:
        li a0, 5
        call compute

        # exit
        li a7, 93
        ecall
compute:
        # allocate for register ra 
        # RV64 registers are 64 bit = 8 bytes
        addi sp, sp, -8
        sd ra, 0(sp)

        # check if recursion ends, then jump
        beq a0, x0, compend

        # otherwise prepare a(n-1)
        addi a0, a0, -1
        call compute
        addi a0, a0, 5

        j compret
compend:
        li a0, 3
compret:
        # restore ra
        ld ra, 0(sp)
        # free stack
        addi sp, sp, 8
        ret






