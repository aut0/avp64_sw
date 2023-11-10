O   ?= .
CPP ?= cpp
DTC ?= dtc

CPPFLAGS := -nostdinc -undef -x assembler-with-cpp

OBJ := ${O}/avp64x1.dtb ${O}/avp64x2.dtb ${O}/avp64x4.dtb ${O}/avp64x8.dtb

all: $(OBJ)

clean:
	$(RM) $(OBJ)

${O}/%.dtb: ${O}/%.dts
	@mkdir -p ${O}
	$(DTC) -I dts -O dtb -o $@ $<

${O}/avp64x1.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=1 -o $@ $<

${O}/avp64x2.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=2 -o $@ $<

${O}/avp64x4.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=4 -o $@ $<

${O}/avp64x8.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=8 -o $@ $<

.PHONY: all clean
.INTERMEDIATE: $(OBJ:dtb=dts)
