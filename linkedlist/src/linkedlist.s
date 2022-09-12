# linkedlist.s
.include "src/linkedlist_struct.s"
.section .text
.globl linkedlist_push
linkedlist_push:
	addi sp, sp, -24
	sd ra, 16(sp)
	sd a0, 8(sp)
	sd a1, 0(sp)

	# alloc memory
	li a0, node_size
	call malloc
	beqz a0, .L0err

	# value
	ld t1, 0(sp)
	sd t1, node_val(a0)
	# insert as new head head
	ld t0, 8(sp)
	sd t0, node_next(a0)

	# || val | next ->|| -> || ... | ... ||
	j .L0exit
.L0err:
	li a0, -1
.L0exit:
	ld ra, 16(sp)
	addi sp, sp, 24
	ret

.globl linkedlist_pop
linkedlist_pop:
	addi sp, sp, -16
	sd ra, 8(sp)
	sd s0, 0(sp)
	# if head is zero
	beqz a0, .L1err

	# return value
	ld a1, node_val(a0)
	# pointer to next element will be new head
	ld s0, node_next(a0)

	# free memory
	call free

	# return new head
	mv a0, s0
	j .L1exit
.L1err:
	li a0, -1
.L1exit:
	ld s0, 0(sp)
	ld ra, 8(sp)
	addi sp, sp, 16	
	ret

.globl linkedlist_print
linkedlist_print:
	addi sp, sp, -24
	sd ra, 16(sp)
	sd a0, 8(sp)
	sd a0, 0(sp)
.L2loop:
	beqz a0, .L2exit

	sd a0, 0(sp)
	ld a1, node_val(a0)
	la a0, .L2prompt
	call printf

	ld a0, 0(sp)
	ld a0, node_next(a0)
	j .L2loop

.L2exit:
	ld a0, 8(sp)
	ld ra, 16(sp)
	addi sp, sp, 24
	ret

.L2prompt: 
	.asciz "%u \n"