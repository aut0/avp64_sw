#!/usr/bin/env bash
##############################################################################
#                                                                            #
# Copyright 2024 Lukas Jünger, Nils Bosbach                                  #
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


SKIN_DIR=/app/build/buildroot/output/images/xen
SW_DIR=${SKIN_DIR}/xen
BINARIES_DIR_DOM0=/app/build/buildroot/output/dom0/images
TARGET_DIR_DOM0=/app/build/buildroot/output/dom0/target

rm -rf ${SKIN_DIR}
mkdir -p ${SW_DIR}

# copy config files
cp /app/files/config/xen.cfg ${SW_DIR}/
cp /app/files/config/xen-x*.cfg ${SKIN_DIR}/

# copy image
cp /app/build/buildroot/output/dom0/images/Image ${SW_DIR}
gzip -f ${SW_DIR}/Image
cp /app/build/buildroot/output/dom0/build/linux-4.19.4/vmlinux ${SW_DIR}/xen.elf
cp /app/build/buildroot/output/dom0/images/xen ${SW_DIR}/xen.bin

# generate sd card image
GENIMAGE_TMP="${SW_DIR}/genimage.tmp"
genimage \
  --rootpath "${TARGET_DIR_DOM0}" \
  --tmppath "${GENIMAGE_TMP}" \
  --inputpath "${BINARIES_DIR_DOM0}" \
  --outputpath "${SW_DIR}" \
  --config "/app/files/genimage.cfg"
rm -rf "${GENIMAGE_TMP}"

# compile device trees
LINUX_IMAGE_GZ="$SW_DIR/Image.gz"
LINUX_IMAGE_SIZE="$(printf "0x%x\n" `stat -c "%s" $LINUX_IMAGE_GZ`)"
make -C /app/files/dt O=${SW_DIR} LINUX_IMAGE_SIZE=$LINUX_IMAGE_SIZE

# compile bootcode
make -C /app/bootcode/xen_boot O=${SW_DIR}

# create archive
pushd ${SKIN_DIR} > /dev/null
tar -czf /app/images/xen.tar.gz ./*
popd > /dev/null
