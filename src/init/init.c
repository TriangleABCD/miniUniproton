#include "uart.h"

char init_stk[4096];

void kernel_init(void) {
  uart_init();
  uart_putc('h');
  uart_putc('e');
  uart_putc('l');
  uart_putc('l');
  uart_putc('o');
  uart_putc('\n');
}
