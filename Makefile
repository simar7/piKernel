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
SYS_LD_FLAGS	  = -nostdlib
OPTIMIZE_FOR      =
DEBUG_LEVEL       =
OPTIM_LEVEL       = -O2
LINKER_SCRIPT     = linker.ld
PROJECT_INC_PATHS = -I.
PROJECT_LIB_PATHS = -L.
PROJECT_LIBRARIES =
PROJECT_SYMBOLS   = -DTOOLCHAIN_GCC_ARM -DNO_RELOC='0'
PROJECT_SOURCES   = boot.s kernel.c
PROJECT_OBJECTS   = boot.o kernel.o
PROJECT_EXECS     = kernel.o


###############################################################################
# Command line building
###############################################################################
INCLUDE_PATHS = $(PROJECT_INC_LIB) $(SYS_INC_PATHS)
LIBRARY_PATHS = $(PROJECT_LIB_LIB) $(SYS_LIB_PATHS)
CC_FLAGS = $(MCU_CC_FLAGS) -c $(CC_OPTIM_FLAGS) $(CC_DEBUG_FLAGS) -fpic -ffreestanding  -Wall -Wextra
LD_FLAGS = $(MCU_CC_FLAGS) -Wl,--gc-sections $(SYS_LD_FLAGS) -Wl,-Map=$(PROJECT).map
LD_SYS_LIBS = $(SYS_LIBRARIES)

###############################################################################
# Makefile execution
###############################################################################

all: $(PROJECT).bin

.c.o:
	$(CC)  $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu99   $(INCLUDE_PATHS) -o $@ $<

.s.o:
	$(AS) $(RPI_CC_FLAGS) -o $@ $<

$(PROJECT).elf: $(PROJECT_OBJECTS) $(SYS_OBJECTS)
	$(LD) $(LD_FLAGS) -T$(LINKER_SCRIPT) $(LIBRARY_PATHS) -o $@ $^ $(PROJECT_LIBRARIES) $(SYS_LIBRARIES) $(PROJECT_LIBRARIES) $(SYS_LIBRARIES)

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(PROJECT).bin $(PROJECT).elf $(PROJECT_OBJECTS)
