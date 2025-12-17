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

LINUX_VERSION=6.5.6
CONFIG=$CURRENT_BUILD_VERSION
BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
NAME="buildroot_${LINUX_VERSION//./_}"

NVDLA=0
if [[ ${CONFIG} != "default" ]]; then
  NAME="${NAME}_${CONFIG}"
fi

if [[ ${CONFIG}  == "nvdla" ]]; then
  NVDLA=1
fi

SKIN_DIR=/app/build/buildroot/output/images/${NAME}
SW_DIR=${SKIN_DIR}/${NAME}

rm -rf ${SKIN_DIR}
mkdir -p ${SW_DIR}

# copy config files
sed -e "s/%NAME%/${NAME}/g" /app/files/config/buildroot.cfg > ${SW_DIR}/${NAME}.cfg
sed -i -e "s/^##config ${CONFIG} //g" ${SW_DIR}/${NAME}.cfg # comment in lines that start with '##config ${CONFIG}'
sed -i '/^##config /d' ${SW_DIR}/${NAME}.cfg # remove all lines that start with ##config

sed -e "s/%NAME%/${NAME}/g" /app/files/config/buildroot-x1.cfg > ${SKIN_DIR}/${NAME}-x1.cfg
sed -e "s/%NAME%/${NAME}/g" /app/files/config/buildroot-x2.cfg > ${SKIN_DIR}/${NAME}-x2.cfg
sed -e "s/%NAME%/${NAME}/g" /app/files/config/buildroot-x4.cfg > ${SKIN_DIR}/${NAME}-x4.cfg
sed -e "s/%NAME%/${NAME}/g" /app/files/config/buildroot-x8.cfg > ${SKIN_DIR}/${NAME}-x8.cfg

# copy image
cp /app/build/buildroot/output/linux/images/vmlinux ${SW_DIR}/buildroot.elf
/app/build/buildroot/output/linux/host/bin/aarch64-buildroot-linux-gnu-objcopy -O binary ${SW_DIR}/buildroot.elf ${SW_DIR}/buildroot.bin

# generate sd card image
rm -rf "${GENIMAGE_TMP}"
genimage \
  --rootpath "${TARGET_DIR}" \
  --tmppath "${GENIMAGE_TMP}" \
  --inputpath "${BINARIES_DIR}" \
  --outputpath "${SW_DIR}" \
  --config "${GENIMAGE_CFG}"

# compile device trees
make -C /app/files/dt O=${SW_DIR} NVDLA=$NVDLA

# compile bootcode
make -C /app/bootcode/el3 O=${SW_DIR}

# p9fs folder
if [[ ${CONFIG}  == "p9fs" ]]; then
  mkdir -p ${SW_DIR}/guest
fi

# create archive
pushd ${SKIN_DIR} > /dev/null
tar -czf /app/images/${NAME}.tar.gz ./*
popd > /dev/null
