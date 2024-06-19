O   ?= .
CPP ?= cpp
DTC ?= dtc
LINUX_IMAGE_SIZE ?= 0

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
	$(CPP) $(CPPFLAGS) -D NRCPU=1 -D LINUX_IMAGE_SIZE=${LINUX_IMAGE_SIZE} -o $@ $<

${O}/avp64x2.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=2 -D LINUX_IMAGE_SIZE=${LINUX_IMAGE_SIZE} -o $@ $<

${O}/avp64x4.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=4 -D LINUX_IMAGE_SIZE=${LINUX_IMAGE_SIZE} -o $@ $<

${O}/avp64x8.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=8 -D LINUX_IMAGE_SIZE=${LINUX_IMAGE_SIZE} -o $@ $<

.PHONY: all clean
.INTERMEDIATE: $(OBJ:dtb=dts)
