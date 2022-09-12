# main.s
.include "src/linkedlist_struct.s"
.section .text
.globl main
main:
    addi sp, sp, -8
    sd ra, 0(sp)
    # new head of list
    li s0, 0

    mv a0, s0
    li a1, 0x12
    call linkedlist_push

    li a1, 0x23
    call linkedlist_push

    li a1, 0x45
    call linkedlist_push

    call linkedlist_pop

    li a1, 0x56
    call linkedlist_push

    call linkedlist_print

    call linkedlist_pop
    call linkedlist_pop
    call linkedlist_pop

    ld ra, 0(sp)
    addi sp, sp, 8
    ret
