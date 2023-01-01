# average.s
.equ maxNb, 100         # maximal numbers to be read
.section .text
.globl main             # run in C 'environment' 
main:
    addi sp, sp, -16    # store ra (return address) and saved regs on stack
    sd ra, 0(sp)
    sd s0, 8(sp)

    li s0, 0            # counter numbers: i
.L0input:               # read in numbers
    la a0, scanfmt
    la a1, buffer
    slli t0, s0, 2      # next input in buffer+4*i
    add a1, a1, t0
    call scanf          # read float number
    blez a0, .L0avg     # if no number could be read anymore, continue..
    addi s0, s0, 1      # count numbers read in s0: i = i + 1
    li t0, maxNb        # if i < maxNb, continue reading
    blt s0, t0, .L0input

.L0avg:
    beqz s0, .L0err     # check if at least one number is read, otherwise exit

    fcvt.s.w ft0, s0    # divider: convert from int in s0 to float
    fcvt.s.w ft1, x0    # sum: init with zero, convert from x0
.L0avgloop:
    beqz s0, .L0out     # count down s0 to zero: i = i - 1
    addi s0, s0, -1

    slli t1, s0, 2      # compute address to float number in memory
    la t0, buffer
    add  t0, t0, t1

    flw ft2, 0(t0)      # load from memory to float register ft2
    fadd.s ft1, ft1, ft2    # sum in ft1
    j .L0avgloop
.L0out:
    fdiv.s ft1, ft1, ft0    # average in ft1

    la a0, resultfmt    # print result using printf
    fcvt.d.s ft1, ft1   # need to prepare for printf, expand to double size
    fmv.x.d a1, ft1     # move from ft1 to a1
    call printf         # and print

.L0err:
    li a0, 0

    ld s0, 8(sp)
    ld ra, 0(sp)        # restore ra
    addi sp, sp,16
    ret                 # return to caller

.section .rodata
scanfmt:
.asciz "%f"
resultfmt:
.asciz "Average: %f\n"

.section .bss
buffer:
.zero 4*maxNb
