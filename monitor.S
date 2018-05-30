.section monitor_vectors

#include "smc.h"

	.align 7
	.global	exception_vectors

exception_vectors:
	b	.
	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.

	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.

	.align 7
	b	sync_handler
	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.


	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.
	.align 7
	b	.

sync_handler:
	str		x30, [sp, CTX_GPX30_OFFSET]		
	mrs		x30, esr_el3

	lsr		x30, x30, #26
	tbz		x30, #0x17, smc64_handler
	b		el3_exit

smc64_handler:
	bl		cpu_save_context
	
	ldp		x0, x1, [sp, CTX_GPX0_OFFSET]
	ldp		x2, x3, [sp, CTX_GPX2_OFFSET]
	ldr		x4, [sp, CTX_GPX4_OFFSET]
	mrs		x5, scr_el3	
	ands	x5, x5, #1		//SCR.NS bit
	
	msr		spsel, #0
	bl		my_smc_handler
	
el3_exit:
	msr		spsel, #1
	b		cpu_restore_context
