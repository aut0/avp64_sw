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

# Pass "clean" or "build" to this script to build/clean AVP64 Linux buildroot

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

BUILDROOT_DIR="$DIR/../../buildroot"
BOOTCODE_DIR="$DIR/../../linux_bootcode"
IMAGES_DIR="$DIR/../../../images"
FILES_DIR="$DIR/../../files/"
BUILD_DIR="$DIR/../../BUILD"

DOCKER_FLAGS=""

if [[ "$(docker --version)" == *"podman"* ]]; then
    echo "Using podman"
    DOCKER_FLAGS="--userns keep-id"
else
    echo "Using docker"
    DOCKER_FLAGS="--user $(id -u):$(id -g)"
fi

mkdir -p "${BUILD_DIR}"
mkdir -p "${IMAGES_DIR}"

docker run \
    --rm \
    $DOCKER_FLAGS \
	-v "$BUILDROOT_DIR":/app/buildroot:Z \
	-v "$BOOTCODE_DIR":/app/bootcode:ro,Z \
	-v "$IMAGES_DIR":/app/images:Z \
	-v "$FILES_DIR":/app/files:ro,Z \
	-v "$BUILD_DIR":/app/build:Z \
	-v "$FILES_DIR/overlay_$2":/app/overlay:ro,Z \
	-v "$DIR/docker_entrypoint_linux_buildroot.sh":/app/docker_entrypoint.sh:ro,Z \
	avp64_linux_buildroot "$1" "$2"
