##############################################################################
#                                                                            #
# Copyright 2020 Lukas Jünger                                                #
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

CC     := aarch64-none-elf-gcc
OC     := aarch64-none-elf-objcopy
CFLAGS := -Wl,--build-id=none -T link.ld -nostdlib

ELFBIN := boot.elf
RAWBIN := boot.bin

.PHONY: all clean

all: dirs $(O)/$(RAWBIN)

clean:
	$(RM) $(O)/$(RAWBIN) $(O)/$(ELFBIN)

dirs: $(O)

$(O):
	mkdir -p $(O)

$(O)/$(RAWBIN): $(O)/$(ELFBIN)
	$(OC) -O binary $< $@

$(O)/$(ELFBIN): boot.S
	$(CC) $(CFLAGS) $< -o $@
