# linkedlist_struct.s
# offset to value
.equ node_val, 0
# offset to pointer(address) of next element
.equ node_next, 8
# size of one element
.equ node_size, 16

# calls:
# linkedlist_push 
# input> a0: head, a1: value
# output< a0: head or -1 if error

# linkedlist_pop
# input> a0: head
# output< a0: head, a1: value

# linkedlist_print
# input> a0: head
