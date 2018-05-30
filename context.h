#include "smc.h"

typedef unsigned long long uint64_t;

typedef struct {
  uint64_t x[32];
  
  uint64_t spsr_el3;
  uint64_t scr_el3;
  uint64_t elr_el3;
  uint64_t sctlr_el3;

  uint64_t sp_el0;
  uint64_t sp_el1;
  
} cpu_context_t;

