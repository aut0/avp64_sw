#!/usr/bin/env bash
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

# Xen needs a gzip'ed Image file
LINUX_IMAGE="$BINARIES_DIR/Image"
gzip -k -f $LINUX_IMAGE

# We need to insert the size of the Linux image into the device tree
# Hence we build the device tree in a post-image script
DTS_TEMPLATE="/app/files/avp64_xen.dts"
DTS_TEMP="$BUILD_DIR/avp64_xen.dts.tmp"
DTB_OUTPUT="$BINARIES_DIR/avp64_xen.dtb"
LINUX_IMAGE_GZ="$BINARIES_DIR/Image.gz"
LINUX_IMAGE_SIZE="$(printf "0x%x\n" `stat -c "%s" $LINUX_IMAGE_GZ`)"
sed "s/\$LINUX_IMAGE_SIZE/$LINUX_IMAGE_SIZE/g" "$DTS_TEMPLATE" > "$DTS_TEMP"
dtc -o "$DTB_OUTPUT" "$DTS_TEMP"

DTS_TEMPLATE="/app/files/avp64_xen_dualcore.dts"
DTS_TEMP="$BUILD_DIR/avp64_xen.dts.tmp"
DTB_OUTPUT="$BINARIES_DIR/avp64_xen_dualcore.dtb"
LINUX_IMAGE_GZ="$BINARIES_DIR/Image.gz"
LINUX_IMAGE_SIZE="$(printf "0x%x\n" `stat -c "%s" $LINUX_IMAGE_GZ`)"
sed "s/\$LINUX_IMAGE_SIZE/$LINUX_IMAGE_SIZE/g" "$DTS_TEMPLATE" > "$DTS_TEMP"
dtc -o "$DTB_OUTPUT" "$DTS_TEMP"


