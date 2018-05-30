#include "smc.h"

.text
.global secure_init
.global std_smc_handler
.align 4

secure_init:
	ldr		x0, =s_sp_start
	mov		sp, x0

	mov		x0, #SMC_SECURE_INIT_DONE
	mov		x1, #3
	mov		x2, #5
	mov		x3, #4
	mrs		x4, sp_el0
	smc		#0

std_smc_handler:
	add		x1, x1, x2
	add		x1, x1, x3
	add		x1, x1, x4
	add		x1, x1, x5

	mov		x0, #SMC_SECURE_SMC_RETURN
	mov		x2, #0	
	mov		x3, #0	
	mov		x4, #0	
	smc		#0
	b		.
