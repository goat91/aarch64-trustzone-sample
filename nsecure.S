.text
.global nsecure_init

.align 4

nsecure_init:
	ldr		x0, =ns_bss_start
	ldr		x1, =ns_bss_size
	mov		x2, #0

	tbz		x1, #0, init_stack

zero:
	mov		x3, #0
	strb	w3, [x0, x2]
	add		x2, x2, #1
	cmp		x2, x1
	bge		zero

init_stack:
	ldr		x0, =ns_sp_start
	mov		sp, x0

	mov		x0, #9
	mov		x1, #4
	mov		x2, #5
	mov		x3, #6
	mov		x4, #7
	mov		x5, #8
	mrs		x6, sp_el0
	
	smc		#0

	b		.
