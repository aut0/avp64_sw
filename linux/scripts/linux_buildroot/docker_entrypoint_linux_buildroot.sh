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

export CURRENT_BUILD_VERSION=$2
export BR2_DEFCONFIG=/app/files/avp64-buildroot-defconfig

if [ "$1" == "build" ]; then
	echo "Building AVP64 Linux buildroot"
	# Run buildroot for linux
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ defconfig
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ all
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ sdk
	cp /app/build/buildroot/output/linux/images/aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz /app/images/
elif [ "$1" == "clean" ]; then
	echo "Cleaning AVP64 Linux buildroot"
	# Clean buildroot for linux
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ clean
elif [ "$1" == "menuconfig" ]; then
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ defconfig
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ menuconfig
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ savedefconfig
elif [ "$1" == "linux-menuconfig" ]; then
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ defconfig
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ linux-menuconfig
	make O=/app/build/buildroot/output/linux -C /app/buildroot/ linux-savedefconfig
	cp /app/build/buildroot/output/linux/build/linux-*/defconfig /app/files/avp64-linux-defconfig
else
	echo "Unsupported argument"
fi


