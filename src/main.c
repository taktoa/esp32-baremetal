#include <string.h>
#include <stdbool.h>
#include <stdint.h>

extern unsigned int _sbss, _ebss, _sidata, _sdata, _edata;

#define UART_TXFIFO_WR_BYTE *((volatile uint32_t*)(0x3FF40000))
#define UART_STATUS_REG *((volatile uint32_t*)(0x3FF40000 + 0x1C))
#define UART_CLKDIV_REG *((volatile uint32_t*)(0x3FF40000 + 0x14))

#define IO_MUX_U0RXD_REG *((volatile uint32_t*)(0x3FF49084))
#define IO_MUX_U0TXD_REG *((volatile uint32_t*)(0x3FF49088))

static volatile int sisyphus = 0;

bool uart_is_busy() {
    return ((UART_STATUS_REG >> 16) & 0xF) > 8;
}

void uart_putchar(unsigned char c) {
    while(uart_is_busy());
    UART_TXFIFO_WR_BYTE = c;
}

int uart_write(const char *str, int length) {
    for(int i = 0; i < length; i++) {
        uart_putchar(str[i]);
    }
    return length;
}

int main( void ) {
    // {
    //     uint32_t frag = 0x0;
    //     uint32_t div = 0x2B6;
    //
    //     UART_CLKDIV_REG = (frag << 20) | (div << 0);
    // }
    //
    // {
    //     uint32_t mcu_sel = 0;
    //     uint32_t fun_ie = 0;
    //     uint32_t fun_wpu = 1;
    //
    //     IO_MUX_U0TXD_REG = (mcu_sel << 12) | (fun_ie << 9) | (fun_wpu << 8);
    // }

    //UART_TXFIFO_WR_BYTE = 'U';

    // Increment a variable.
    while ( 1 ) {
        char foo[15];
        foo[0] = 'h';
        foo[1] = 'e';
        foo[2] = 'l';
        foo[3] = 'l';
        foo[4] = 'o';
        foo[5] = ',';
        foo[6] = ' ';
        foo[7] = 'w';
        foo[8] = 'o';
        foo[9] = 'r';
        foo[10] = 'l';
        foo[11] = 'd';
        foo[12] = '!';
        foo[13] = '\n';
        foo[14] = '\0';
        uart_write(foo, 14);
        ++sisyphus;
    }
    return 0;
}

// Startup logic; this is the application entry point.
void __attribute__( ( noreturn ) ) call_start_cpu0() {
    // Clear BSS.
    memset( &_sbss, 0, ( &_ebss - &_sbss ) * sizeof( _sbss ) );
    // Copy initialized data.
    memmove( &_sdata, &_sidata, ( &_edata - &_sdata ) * sizeof( _sdata ) );

    // Done, branch to main
    main();
    // (Should never be reached)
    while( 1 ) {}
}
