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

# Pass "clean" or "build" to this script to build/clean AVP64 Linux bootcode

set -euo pipefail

# Get directory of script itself
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do 
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the
    # path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

BOOTCODE_SRC_DIR=$DIR/../../linux_bootcode
BUILD_DIR=$DIR/../../BUILD

docker run                                                                          \
    -e APP_UID=$(id -u)                                                             \
    -e APP_GID=$(id -g)                                                             \
    -v "$BOOTCODE_SRC_DIR":/app/linux_bootcode:ro                                   \
    -v "$BUILD_DIR":/app/build                                                      \
    -v "$DIR/docker_entrypoint_linux_bootcode_el1el2.sh":/app/docker_entrypoint.sh  \
    avp64_linux_bootcode_el1el2 "$1"
