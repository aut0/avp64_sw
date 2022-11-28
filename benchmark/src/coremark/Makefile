SRCDIR           ?= $(dir $(firstword $(MAKEFILE_LIST)))

O                ?= $(PWD)/build
P                ?= $(O)/install

ITERATIONS 	     := 30000
HAS_FLOAT        := 0
CC               := aarch64-none-elf-gcc
LD               := aarch64-none-elf-gcc
CFLAGS           := -ffreestanding

CFLAGS           += -O3

OBJCPY           := aarch64-none-elf-objcopy
FLAGS_STR         = "$(CFLAGS)"
CFLAGS           += -I./ -DFLAGS_STR=\"$(FLAGS_STR)\" -DITERATIONS=$(ITERATIONS) -DHAS_FLOAT=$(HAS_FLOAT)
LFLAGS           := -nostartfiles -T link.ld -Wl,--build-id=none

PROGRAM          := $(O)/coremark.elf
BIN_PROGRAM      := $(O)/coremark.bin
OBJECTS          := $(O)/boot.o                                               \
                    $(O)/core_list_join.o                                     \
                    $(O)/core_main.o                                          \
                    $(O)/core_matrix.o                                        \
                    $(O)/core_portme.o                                        \
                    $(O)/core_state.o                                         \
                    $(O)/core_util.o                                          \
                    $(O)/ee_printf.o                                          \

.PHONY: all clean install install_dirs install_program

all: $(PROGRAM)

install: $(PROGRAM)
	$(S) echo -e "  INSTALL\t$(notdir $(PROGRAM))"
	$(S) install -m 755 $(PROGRAM) $(P)
	$(S) echo -e "  INSTALL\t$(notdir $(BIN_PROGRAM))"
	$(S) install -m 755 $(BIN_PROGRAM) $(P)

clean:
	$(S) echo -e "  CLEAN"
	$(S) $(RM) $(OBJECTS) $(PROGRAM) $(BIN_PROGRAM)

$(PROGRAM): $(OBJECTS)
	$(S) echo -e "  LINK\t$(notdir $@)"
	$(S) $(LD) $(LFLAGS) -o $@ $^
	$(S) $(OBJCPY) -O binary $(PROGRAM) $(BIN_PROGRAM)

$(O)/%.o: %.c
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) mkdir -p $(dir $@)
	$(S) $(CC) $(CFLAGS) -c -o $@ $<

$(O)/%.o: %.S
	$(S) echo -e "  CC\t$(notdir $@)"
	$(S) mkdir -p $(dir $@)
	$(S) $(CC) $(CFLAGS) -c -o $@ $<
