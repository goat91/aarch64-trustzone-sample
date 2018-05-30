.global	cpu_save_context
.global cpu_restore_context

#include "smc.h"
/* SP refers to SP_EL3, which points to the current cpu context */
cpu_save_context:
	stp		x0, x1, [sp, #CTX_GPX0_OFFSET]
	stp		x2, x3, [sp, #CTX_GPX2_OFFSET]

	mrs		x0, spsr_el3
	mrs		x1, scr_el3
	mrs		x2, elr_el3
	mrs		x3, sctlr_el3

	stp		x0, x1, [sp, #CTX_SPSR_OFFSET]
	stp		x2, x3, [sp, #CTX_ELR_OFFSET]

	mrs		x0, sp_el0
	mrs		x1, sp_el1

	stp		x0, x1, [sp, #CTX_SPEL0_OFFSET]

	stp		x4, x5, [sp, #CTX_GPX4_OFFSET]
	stp		x6, x7, [sp, #CTX_GPX6_OFFSET]
	stp		x8, x9, [sp, #CTX_GPX8_OFFSET]
	stp		x10, x11, [sp, #CTX_GPX10_OFFSET]
	stp		x12, x13, [sp, #CTX_GPX12_OFFSET]
	stp		x14, x15, [sp, #CTX_GPX14_OFFSET]
	stp		x16, x17, [sp, #CTX_GPX16_OFFSET]
	stp		x18, x19, [sp, #CTX_GPX18_OFFSET]
	stp		x20, x21, [sp, #CTX_GPX20_OFFSET]
	stp		x22, x23, [sp, #CTX_GPX22_OFFSET]
	stp		x24, x25, [sp, #CTX_GPX24_OFFSET]
	stp		x26, x27, [sp, #CTX_GPX26_OFFSET]
	stp		x28, x29, [sp, #CTX_GPX28_OFFSET]

	ret

cpu_restore_context:
	ldp		x0, x1, [sp, #CTX_SPSR_OFFSET]
	ldp		x2, x3, [sp, #CTX_ELR_OFFSET]
	msr		spsr_el3, x0
	msr		scr_el3, x1
	msr		elr_el3, x2
	msr		sctlr_el3, x3
	
	ldp		x0, x1, [sp, #CTX_SPEL0_OFFSET]	
	msr		sp_el0, x0
	msr		sp_el1, x1

	ldp		x0, x1, [sp, #CTX_GPX0_OFFSET]
	ldp		x2, x3, [sp, #CTX_GPX2_OFFSET]
	ldp		x4, x5, [sp, #CTX_GPX4_OFFSET]
	ldp		x6, x7, [sp, #CTX_GPX6_OFFSET]
	ldp		x8, x9, [sp, #CTX_GPX8_OFFSET]
	ldp		x10, x11, [sp, #CTX_GPX10_OFFSET]
	ldp		x12, x13, [sp, #CTX_GPX12_OFFSET]
	ldp		x14, x15, [sp, #CTX_GPX14_OFFSET]
	ldp		x16, x17, [sp, #CTX_GPX16_OFFSET]
	ldp		x18, x19, [sp, #CTX_GPX18_OFFSET]
	ldp		x20, x21, [sp, #CTX_GPX20_OFFSET]
	ldp		x22, x23, [sp, #CTX_GPX22_OFFSET]
	ldp		x24, x25, [sp, #CTX_GPX24_OFFSET]
	ldp		x26, x27, [sp, #CTX_GPX26_OFFSET]
	ldp		x28, x29, [sp, #CTX_GPX28_OFFSET]
	ldr		x30, [sp, #CTX_GPX30_OFFSET]

	eret
