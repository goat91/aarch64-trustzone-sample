	
#include "smc.h"
.data
	.equ	mode, 0x05
	.align	2
	.text
.global	 reset
reset:
	ldr		x0, =exception_vectors
	msr		vbar_el3, x0

init_ns_data:	
	ldr		x0, =ram_ns_sdata
	ldr		x1, =flash_ns_sdata
	ldr		x2, =ns_data_size
	
copy1:
	cmp		x2, #0
	beq		init_s_data

	ldrb	w3, [x1], #1
	strb	w3, [x0], #1
	subs	x2, x2, #1
	b		copy1

init_s_data:
	ldr		x0, =ram_s_sdata
	ldr		x1, =flash_s_sdata
	ldr		x2, =ns_data_size
	ldr		x3, =ram_ns_end
	ldr		x4, =ram_ns_sdata
	sub		x3, x3, x4
	ldr		x4, =flash_ns_sdata
	add		x4, x4, x3
	mov		x1, x4

copy2:
	cmp		x2, #0
	beq		el3_exit

	ldrb	w3, [x1], #1
	strb	w3, [x0], #1
	subs	x2, x2, #1
	b		copy2


el3_exit:	

	mov		x0, #0x400
	msr		scr_el3, x0

	mov		x0, #0
	msr		sctlr_el3, x0

	ldr		x0, =mode
	msr		spsr_el3, x0

	ldr		x1, =secure_init
	msr		elr_el3, x1

init_bss:
	ldr		x0, =s_bss_start
	ldr		x1, =s_bss_size
	mov		x2, #0

	cmp		x1, #0
	bne		zero_fill
	eret

zero_fill:
	mov		x3, #0
	strb	w3, [x0, x2]
	add		x2, x2, #1
	cmp		x2, x1
	bne		zero_fill

	/* Use sp_el0 as runtime sp */
	msr		spsel, #0
	ldr		x0, =runtime_sp
	mov		sp, x0

	/* Init contexts for secure and normal world */
	mov		x0, #SECURE
	bl		cpu_init_context
	mov		x0, #NONSECURE
	bl		cpu_init_context

	/* Set sp_el3 to secure context before enter secure world */
	mov		x0, #SECURE
	bl		cpu_set_next_context
	eret
