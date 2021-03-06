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

modprobe drm
insmod opendla.ko
BEGIN=$(devmem 0x10008020 64)
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
END=$(devmem 0x10008020 64)
echo "started: $BEGIN"
echo "ended:   $END"
echo "result:"
cat output.dimg
