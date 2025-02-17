#!/bin/env bash
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

CONTAINER_PROGRAM=""
CONTAINER_PROGRAM_FLAGS=""

if command -v podman &> /dev/null; then
	CONTAINER_PROGRAM="podman"
	CONTAINER_PROGRAM_FLAGS="--userns keep-id"
	echo "Using podman"
elif command -v docker &> /dev/null; then
	CONTAINER_PROGRAM="docker"
	CONTAINER_PROGRAM_FLAGS="--user $(id -u):$(id -g)"
	echo "Using docker"
else
	echo "No program to launch containers found. Please install podman or docker."
	exit 1
fi

export CONTAINER_PROGRAM
export CONTAINER_PROGRAM_FLAGS

# Build Linux buildroot
$CONTAINER_PROGRAM build  --tag avp64_linux_buildroot "$DIR/scripts/linux_buildroot"
"$DIR/scripts/linux_buildroot/docker_run_linux_buildroot.sh" build default

unset CONTAINER_PROGRAM
unset CONTAINER_PROGRAM_FLAGS
