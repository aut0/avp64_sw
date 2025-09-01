##############################################################################
#                                                                            #
# Copyright 2025 Lukas Jünger, Nils Bosbach                                  #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License");            #
# you may not use this file except in compliance with the License.           #
# You may obtain a copy of the License at                                    #
#                                                                            #
#     http://www.apache.org/licenses/LICENSE-2.0                             #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#                                                                            #
##############################################################################

O   ?= .
CPP ?= cpp
DTC ?= dtc
NVDLA ?= 0

CPUS := 1 2 4 8

CPPFLAGS := -nostdinc -undef -x assembler-with-cpp

OBJ := $(addprefix ${O}/avp64x,${CPUS:=.dtb})

all: $(OBJ)

clean:
	$(RM) $(OBJ)

${O}/%.dtb: ${O}/%.dts
	@mkdir -p ${O}
	$(DTC) -I dts -O dtb -o $@ $<

${O}/avp64x%.dts: avp64.dts
	@mkdir -p ${O}
	$(CPP) $(CPPFLAGS) -D NRCPU=$* -D NVDLA=${NVDLA} -o $@ $<

.PHONY: all clean
.INTERMEDIATE: $(OBJ:dtb=dts)
