# djb2.s
.section .text
.globl main             # run in C 'environment' 
main:
    addi sp, sp, -8    # store ra (return address) on stack
    sd ra, 0(sp)

    la a0, prompt       # printf the prompt string
    call printf

    la a0, scanfmt      # scanf from stdin (console)
    la a1, input        # into buffer input
    call scanf          # with format scanfmt

    la a0, input        # process input with djb2
    call djb2
    mv a1, a0

    la a0, result       # print result 
    call printf

    li a0, 0

    ld ra, 0(sp)        # restore ra
    addi sp, sp,8
    ret                 # return to caller

djb2:                   # compute djb2 
    li t1, 5381         # init hash = 5381
djb2_loop:
    lb t0, 0(a0)        # process every char of input
    beqz t0, dbj2_end   # until zero appears

    mv t2, t1           
    slliw t2, t2, 5     # t2 = hash << 5 = 32 * hash
    addw t1, t1, t2     # t1 = 32 * hash + hash = 33 * hash
    addw t1, t1, t0     # t1 = 33 * hash + char

    addi a0, a0, 1      # next iteration 
    j djb2_loop 
dbj2_end:
    mv a0, t1           # return hash value
    ret

.section .rodata
prompt:
.asciz "Enter text: "
scanfmt:
.asciz "%127[^\n]"          # scanf max 127 chars and end with return
result:
.asciz "Hash is %lu\n"      # write out the parameter als long unsign.
.section .bss
input:                      # storage for input
.zero 128
 
