######################################################################################
# GNU GCC ARM Embeded Toolchain base directories and binaries
######################################################################################
GCC_BASE = /usr/
GCC_BIN  = $(GCC_BASE)bin/
GCC_LIB  = $(GCC_BASE)arm-none-eabi/lib/
GCC_INC  = $(GCC_BASE)arm-none-eabi/include/
AS       = $(GCC_BIN)arm-none-eabi-as
CC       = $(GCC_BIN)arm-none-eabi-gcc
CPP      = $(GCC_BIN)arm-none-eabi-g++
LD       = $(GCC_BIN)arm-none-eabi-gcc
OBJCOPY  = $(GCC_BIN)arm-none-eabi-objcopy


######################################################################################
# Custom options for cortex-m and cortex-r processors
######################################################################################
RPI_CC_FLAGS    = -mcpu=arm1176jzf-s


######################################################################################
# Main makefile project configuration
#    PROJECT      = <name of the target to be built>
#    MCU_CC_FLAGS = <one of the CC_FLAGS above>
#    MCU_LIB_PATH = <one of the LIB_PATH above>
#    OPTIMIZE_FOR = < SIZE or nothing >
#    DEBUG_LEVEL  = < -g compiler option or nothing >
#    OPTIM_LEVEL  = < -O compiler option or nothing >
######################################################################################
PROJECT           = piKernel
MCU_CC_FLAGS      = $(RPI_CC_FLAGS)
OPTIMIZE_FOR      =
DEBUG_LEVEL       =
OPTIM_LEVEL       =
LINKER_SCRIPT     = ./cortex-rm.ld
PROJECT_OBJECTS   = boot.o kernel.o
PROJECT_INC_PATHS = -I.
PROJECT_LIB_PATHS = -L.
PROJECT_LIBRARIES =
PROJECT_SYMBOLS   = -DTOOLCHAIN_GCC_ARM -DNO_RELOC='0'


###############################################################################
# Command line building
###############################################################################
CC_FLAGS          = -fpic -ffreestanding


###############################################################################
# Makefile execution
###############################################################################

all: $(BULD_TARGET).bin

clean:
	rm -f $(BULD_TARGET).bin $(BULD_TARGET).elf $(PROJECT_OBJECTS)

.s.o:
	$(AS) $(MCU_CC_FLAGS) -o $@ $<

.c.o:
	$(CC)  $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu99   $(INCLUDE_PATHS) -o $@ $<

.cpp.o:
	$(CPP) $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu++98 $(INCLUDE_PATHS) -o $@ $<

$(BULD_TARGET).elf: $(PROJECT_OBJECTS) $(SYS_OBJECTS)
	$(LD) $(LD_FLAGS) -T$(LINKER_SCRIPT) $(LIBRARY_PATHS) -o $@ $^ $(PROJECT_LIBRARIES) $(SYS_LIBRARIES) $(PROJECT_LIBRARIES) $(SYS_LIBRARIES)

$(BULD_TARGET).bin: $(BULD_TARGET).elf
	$(OBJCOPY) -O binary $< $@
