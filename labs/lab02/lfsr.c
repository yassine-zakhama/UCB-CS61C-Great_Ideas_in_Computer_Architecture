#include "lfsr.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned get_bit(unsigned x, unsigned n) {
	return ((1 << n) & x) >> n;
}

void set_bit(unsigned* x, unsigned n, unsigned v) {
	*x &= ~(1 << n);
	*x |= (v << n);
}

void lfsr_calculate(uint16_t* reg) {
	unsigned new_bit = get_bit(*reg, 5) ^ get_bit(*reg, 3) ^ get_bit(*reg, 2) ^
					   get_bit(*reg, 0);
	*reg >>= 1;
	set_bit(reg, 15, new_bit);
}
