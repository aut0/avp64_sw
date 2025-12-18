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

O      ?= .
CPP    ?= cpp
DTC    ?= dtc
NVDLA  ?= 0

CPUS := 1 2 4 8

CPPFLAGS := -nostdinc -undef -x assembler-with-cpp

OUTDIR := $(O)

DTB := \
  $(foreach c,$(CPUS),$(OUTDIR)/avp64x$(c).dtb) \
  $(foreach c,$(CPUS),$(OUTDIR)/avp64x$(c)_minimal.dtb)

all: $(DTB)

clean:
	$(RM) $(DTB)

$(OUTDIR):
	mkdir -p $@

$(OUTDIR)/%.dtb: $(OUTDIR)/%.dts | $(OUTDIR)
	$(DTC) -I dts -O dtb -o $@ $<

$(OUTDIR)/avp64x%.dts: avp64.dts | $(OUTDIR)
	$(CPP) $(CPPFLAGS) \
		-D NRCPU=$* \
		-D NVDLA=$(NVDLA) \
		-o $@ $<

$(OUTDIR)/avp64x%_minimal.dts: avp64_minimal.dts | $(OUTDIR)
	$(CPP) $(CPPFLAGS) \
		-D NRCPU=$* \
		-o $@ $<

.PHONY: all clean

.INTERMEDIATE: $(DTB:.dtb=.dts)
