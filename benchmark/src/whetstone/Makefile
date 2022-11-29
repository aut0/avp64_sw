SRCDIR           ?= $(dir $(firstword $(MAKEFILE_LIST)))

O                ?= $(PWD)/build
P                ?= $(O)/install

CC               := aarch64-none-elf-gcc
LD               := aarch64-none-elf-gcc
CFLAGS           := -ffreestanding -DPRINTOUT

CFLAGS           += -O3

OBJCPY           := aarch64-none-elf-objcopy
FLAGS_STR         = "$(CFLAGS)"
LFLAGS           := -nostartfiles -T link.ld -Wl,--build-id=none

PROGRAM          := $(O)/whetstone.elf
BIN_PROGRAM      := $(O)/whetstone.bin
OBJECTS          := $(O)/boot.o \
 					$(O)/whetstone.o \
					$(O)/stubs.o

.PHONY: all clean install

all: $(PROGRAM)

clean:
	$(S) echo -e "  CLEAN"
	$(S) $(RM) $(OBJECTS) $(PROGRAM) $(BIN_PROGRAM)

install: $(PROGRAM)
	$(S) echo -e "  INSTALL\t$(notdir $(PROGRAM))"
	$(S) install -m 755 $(PROGRAM) $(P)
	$(S) echo -e "  INSTALL\t$(notdir $(BIN_PROGRAM))"
	$(S) install -m 755 $(BIN_PROGRAM) $(P)

$(PROGRAM): $(OBJECTS)
	$(S) echo -e "  LINK\t$(notdir $@)"
	$(S) $(LD) $(LFLAGS) -o $@ $^ -lm
	$(S) $(OBJCPY) -O binary $(PROGRAM) $(BIN_PROGRAM)

$(O)/%.o: %.c
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) $(CC) $(CFLAGS) -c -o $@ $<

$(O)/%.o: %.S
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) $(CC) $(CFLAGS) -c -o $@ $<
