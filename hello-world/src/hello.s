.equ write, 64
.equ exit, 93
.section .text
.globl  _start
_start:
        li      a0, 1
        la      a1, msgbegin 
        lbu     a2, msgsize 
        li      a7, write
        ecall
	li	a0, 0
	li	a7, exit
	ecall

.section .rodata
msgbegin:
.ascii  "Hello World!\n"
msgsize:
.byte   .-msgbegin
