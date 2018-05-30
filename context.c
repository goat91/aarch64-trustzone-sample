#include "context.h"

static cpu_context_t smc_ctx[2];
static smc_inited;

extern void nsecure_init(void);
extern void std_smc_handler(void);
extern uint64_t runtime_sp;

cpu_context_t *cpu_get_context(int state)
{
	cpu_context_t *ctx;
	if (state != SECURE || state != NONSECURE)
		return 0;

	return &smc_ctx[state];
}

void cpu_set_next_context(int state)
{
	cpu_context_t *ctx;

	ctx = cpu_get_context(state);
	if (!ctx)
		return;

	__asm__("msr spsel, #1; \n\r"
			"mov sp, %0;\n\r"
			"msr spsel, #0;"
			:
			: "r"(ctx));
}

void cpu_init_context(int state)
{
	cpu_context_t *ctx;

	ctx = cpu_get_context(state);
	if (!ctx)
		return;

	ctx->spsr_el3 =	0x5;
	if (state == SECURE) {
		ctx->scr_el3 = 0x400;	
	} else {
		int i;

		for (i = 0; i < 4; i++)
			ctx->x[i] = i + 1;
		ctx->elr_el3 = nsecure_init;
		ctx->scr_el3 = 0x401;
	}
	ctx->sp_el0 = 0x80000000;
}

void my_smc_handler(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint64_t x4, int flag)
{
	cpu_context_t *ctx, *ctx2;

	if (flag == NONSECURE) {
		//assert(smc_inited == 1);
		ctx = cpu_get_context(SECURE);
		ctx2 = cpu_get_context(NONSECURE);
		cpu_set_next_context(SECURE);

		ctx->x[0] = x0;	
		ctx->x[1] = x1;	
		ctx->x[2] = x2;	
		ctx->x[3] = x3;	
		ctx->x[4] = x4;	
		ctx->x[5] = ctx2->x[5];	
		ctx->x[6] = ctx2->x[6];	

		ctx->elr_el3 = std_smc_handler;

	} else {
		ctx = cpu_get_context(NONSECURE);
		cpu_set_next_context(NONSECURE);
		switch(x0) {
			case SMC_SECURE_INIT_DONE:
				smc_inited = 1;
				break;	
			case SMC_SECURE_SMC_RETURN:
				ctx->x[0] = x1;			
				ctx->x[1] = x2;			
				ctx->x[2] = x3;			
				ctx->x[3] = x4;			
				break;
		}
	}
}

