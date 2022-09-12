# prime.s
.equ maxnb, 0x100000
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

    blez a0, .Lerr      # input error   

    la  a1, input       # check if input number n fits 
    lw  a1, 0(a1)
    li  t0, maxnb
    bge a1, t0, .Lerr

    la a0, input        # process input with sieve
    call sieve

    bnez a0, .Lp1
.Lp0:
    la a0, outno 
    j  .Lpp
.Lp1:
    la a0, outyes       # print result 
    j  .Lpp
.Lerr: 
    la a0, error    
.Lpp:
    call printf

    li a0, 0

    ld ra, 0(sp)        # restore ra
    addi sp, sp,8
    ret                 # return to caller

sieve:
    # input: register a0 points to number n
    # that is checked if it is a prime.
    # output: if n is prime a0 is one else zero
    # sieve of Erastosthenes
    # init array with numbers
    lw t1, 0(a0)        # nb to check
    li t2, 2            # counter start with 2
    la t3, array        # pointer to array
.Ls0:
    sw   t2, 8(t3)      # set item to index, 8() is begin with index 2
    addi t3, t3, 4      # increment by four for word size
    addi t2, t2, 1      # counter
    ble  t2, t1, .Ls0   # until counter == nb to check

    # array has now the values: 0 0 2 3 4 5 6 7 8 9 10...

    # non-primes are cancelled out
    # by setting their array items to zero
    li t2, 2            # start with 2, t2 is index i
    la t3, array        # t3 is pointer to array
.Ls1:
    lw   t4, 8(t3)      # t4 is current array item (offset by 2) 
    beqz t4, .Ls3       # no prime, continue at .Ls3

    mul t4, t2, t2      # t4 = t2 * t2; t4 is index j
.Ls2:
    slli t5, t4, 2      # t5 = t4 * 4 for offset (words) in array
    add  t5, t3, t5     # t5 = t3 + t5; t5 is address in array for j
    sw   x0, 0(t5)      # set entry to 0, no prime nb, array[j] = 0
    add  t4, t4, t2     # t4 = t4 + t2; j += i
    ble  t4, t1, .Ls2   # cancel out all multiplies of i for i < n

.Ls3:
    addi t2, t2, 1      # continue with next number
    mul  t0, t2, t2     # as long as n*n > index
    ble  t0, t1, .Ls1 

    slli t0, t1, 2      # use n as index
    add  t0, t3, t0     # compute address in array
    lw   t0, 0(t0)      # load its item
    snez a0, t0         # set a0 to 1 if array[n] != 0 

    ret


.section .rodata
prompt:
.asciz "Enter number (<1048576): "
scanfmt:
.asciz "%u"                # scanf an unsigned int number
outyes:
.asciz "is a prime number.\n" 
outno:
.asciz "is not a prime number.\n" 
error:
.asciz "wrong input.\n"
.section .bss
input:                      # storage for numbers 
    .word 0
array:
    .zero 4*maxnb           # max number storage
 
