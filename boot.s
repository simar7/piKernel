@bootstrap code
.section ".text.boot"

.globl _start

_start:
    mov sp, #0x8000         @ setup the stack

    ldr r4, =__bss_start    @ clear out bss
    ldr r9, =__bss_end
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    b       2f

1:
    stmia r4!, {r5-r8}      @ store r5-r8 starting at addr r4

2:
    cmp r4, r9
    blo 1b

    ldr r3, =kernel_main
    blx r3

halt:
    wfe
    b halt
