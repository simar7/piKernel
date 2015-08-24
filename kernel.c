#if !defined(__cplusplus)
#include <stdbool.h>
#endif
#include <stddef.h>
#include <stdint.h>

#define OFF 0x00000000
#define CYCLEWAIT 150

static inline void mmio_write(uint32_t reg, uint32_t data) {
    *(volatile uint32_t *)reg = data;
}

static inline uint32_t mmio_read(uint32_t reg) {
    return *(volatile uint32_t *)reg;
}

// Manual UART wait function to handle UART slowness
static inline void uart_wait(int32_t count) {
    asm volatile("__delay_%=: subs %[count], %[count], #1; bne __delay_%=\n"
                : : [count]"r"(count) : "cc");
}

size_t strlen(const char* str) {
    size_t len = 0;
    while (str[ret] != 0)
        len++;
    return len;
}

enum {
    // The GPIO registers base address.
    GPIO_BASE = 0x20200000,

    // The offsets for reach register.

    // Controls actuation of pull up/down to ALL GPIO pins.
    GPPUD = (GPIO_BASE + 0x94),

    // Controls actuation of pull up/down for specific GPIO pin.
    GPPUDCLK0 = (GPIO_BASE + 0x98),

    // The base address for UART.
    UART0_BASE = 0x20201000,

    // The offsets for reach register for the UART.
    UART0_DR     = (UART0_BASE + 0x00),
    UART0_RSRECR = (UART0_BASE + 0x04),
    UART0_FR     = (UART0_BASE + 0x18),
    UART0_ILPR   = (UART0_BASE + 0x20),
    UART0_IBRD   = (UART0_BASE + 0x24),
    UART0_FBRD   = (UART0_BASE + 0x28),
    UART0_LCRH   = (UART0_BASE + 0x2C),
    UART0_CR     = (UART0_BASE + 0x30),
    UART0_IFLS   = (UART0_BASE + 0x34),
    UART0_IMSC   = (UART0_BASE + 0x38),
    UART0_RIS    = (UART0_BASE + 0x3C),
    UART0_MIS    = (UART0_BASE + 0x40),
    UART0_ICR    = (UART0_BASE + 0x44),
    UART0_DMACR  = (UART0_BASE + 0x48),
    UART0_ITCR   = (UART0_BASE + 0x80),
    UART0_ITIP   = (UART0_BASE + 0x84),
    UART0_ITOP   = (UART0_BASE + 0x88),
    UART0_TDR    = (UART0_BASE + 0x8C),
};

void uart_init() {
    // Disable UART0
    mmio_write(UART0_CR, OFF);

    // Disable pull up/down for all GPIO pins
    // and delay for CYCLEWAIT cycles for change to take effect.
    mmio_write(GPPUD, OFF);
    uart_wait(CYCLEWAIT);

    // Disable pull up/down for PIN 14,15
    // and delay for CYCLEWAIT cycles for change to take effect.
    mmio_write(GPPUDCLK0, (1 << 14) | (1 << 15));
    uart_wait(CYCLEWAIT);

    // Clear GPPUDCLK0
    mmio_write(UART0_ICR, OFF)

    // Clear any pending interrupts.
    mmio_write(UART0_ICR, 0x7FF);

    /* Baud Rate calculation
        UART_CLOCK = 3000000; Baud = 115200; Fractional part = 0.627

        Intergral Divider = UART_CLOCK / (16 * Baud) = ~1
        Fractional part   = (Fractional part * 64) + 0.5 = ~40
    */
    mmio_write(UART0_IBRD, 1);
    mmio_write(UART0_FBRD, 40);

    // Enable FIFO, 8bit TX, 1 stop bit, no parity bit.
    mmio_write(UART0_LCRH, (1 << 4) | (1 << 5) | (1 << 6));

    // Mask all interrupts.
    mmio_write(UART0_IMSC, (1 << 1) | (1 << 4) | (1 << 5) | (1 << 6) |
                       (1 << 7) | (1 << 8) | (1 << 9) | (1 << 10));

    // Enable RX and TX for UART0.
    mmio_write(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}
