# wordcount.s
.section .text
.globl main             # run in C 'environment' 
main:
    addi sp, sp, -40    # store ra (return address) and saved regs on stack
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)

    li s0, 0            # counter chars
    li s1, 0            # counter line feeds
    li s2, 0            # counter words
    li s3, 0            # indicator if current input is in word

loop:
    call getchar        # get input from stdin in a0
    bltz a0, end       # if end of file (eof is -1) goto end

    addi s0, s0, 1      # count characters

    li t0, 0xa          # is linefeed (ascii 0xa)?
    bne a0, t0, nolf   # no -> continue
    addi s1, s1, 1      # yes -> count
nolf:

                        # is this a word: char digit or alphabet?
    addi t0, a0, -0x30  # digits go from 0x30 to 0x39
    li   t1, 0x9        # if (char-0x30) >= 0 and <= 0x9 then digit
    bleu t0, t1, aldi  # trick: treat negative value as unsigned
                        # value (or neg. as unsign.) > 0x9, continue
    andi t0, a0, ~0x20  # map range > 0x60 to range > 0x40, lower to upper cast
    addi t0, t0, -0x41  # letter go from 0x41 to 0x5a
    li   t1, 0x19       # (char-0x41) >= 0 and <= 0x19, then alphabet
    bleu t0, t1, aldi  # trick again 
                        # reached here, then not in word (anymore)
    add s2, s2, s3      # count word, indicator is one if word else 0
    li s3, 0            # clear indicator
    j loop

aldi:
    li s3, 1            # char is part of word, indicate for word counter update
    j loop
end:
    la a0, result       # print result 
    mv a1, s1
    mv a2, s2
    mv a3, s0
    call printf

    li a0, 0

    ld s3, 32(sp)       # restore saved regs.
    ld s2, 24(sp)
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)        # restore ra
    addi sp, sp,40
    ret                 # return to caller

.section .rodata
result:
.asciz "Lines: %u  Words: %u  Chars: %u\n"      # write out result
 
