SRCDIR           ?= $(dir $(firstword $(MAKEFILE_LIST)))

O                ?= $(PWD)/build
P                ?= $(O)/install

CC               := aarch64-none-elf-gcc
LD               := aarch64-none-elf-gcc
CFLAGS           := -ffreestanding -DHZ=1 -DTIME

CFLAGS           += -O3

OBJCPY           := aarch64-none-elf-objcopy
FLAGS_STR         = "$(CFLAGS)"
LFLAGS           := -nostartfiles -T link.ld -Wl,--build-id=none

PROGRAM          := $(O)/dhrystone.elf
BIN_PROGRAM      := $(O)/dhrystone.bin
OBJECTS          := $(O)/boot.o                                            \
                    $(O)/dhry_1.o                                          \
                    $(O)/dhry_2.o                                          \
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
	$(S) $(LD) $(LFLAGS) -o $@ $^
	$(S) $(OBJCPY) -O binary $(PROGRAM) $(BIN_PROGRAM)

$(O)/%.o: %.c
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) $(CC) $(CFLAGS) -c -o $@ $<

$(O)/%.o: %.S
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) $(CC) $(CFLAGS) -c -o $@ $<
