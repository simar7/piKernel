piKernel: A custom ARM kernel project for the Raspberry Pi
----------------------------------------------------------

## System Requirements
1. ARM cross compiler: `arm-gcc-eabi-none`
2. `make`

## Notes for OS X
1. homebrew `gdb` only supports x86 debugging, install `arm-none-eabi-gdb` to remotely debug

## Notes for debugging
1. To remotely debug using gdb over TCP in QEMU
    a. Start qemu machine with `-s` and `-S` options
    b. gdb> `target remote localhost:1234`
    c. gdb> `continue`
