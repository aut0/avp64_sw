#!/bin/bash
##############################################################################
#                                                                            #
# Copyright 2022 Nils Bosbach, Lukas Jünger                                  #
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
    echo "Building $2"
    mkdir -p /app/build/$2
    make -C /app/benchmark/$2 O=/app/build/$2
    /app/postprocess.bash $2
elif [ "$1" == "clean" ]; then
    echo "Cleaning $2"
    make -C /app/benchmark/$2 O=/app/build/$2 clean
    rm -rf /app/build/$2
else
    echo "Unsupported argument"
fi
