#!/bin/bash
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

set -euo pipefail

if [ "$1" == "build" ]; then
	echo "Building AVP64 Linux buildroot"
	# Run buildroot for linux
	export BR2_DEFCONFIG=/app/files/avp64-linux-nvdla-defconfig
	make O=/app/build/buildroot/output/linux_nvdla -C /app/buildroot/ defconfig
	make O=/app/build/buildroot/output/linux_nvdla -C /app/buildroot/ all
elif [ "$1" == "clean" ]; then
	echo "Cleaning AVP64 Linux buildroot"
	# Clean buildroot for linux
	export BR2_DEFCONFIG=/app/files/avp64-linux-nvdla-defconfig
	make O=/app/build/buildroot/output/linux_nvdla -C /app/buildroot/ clean
else
	echo "Unsupported argument"
fi
