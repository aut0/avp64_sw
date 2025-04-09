#!/bin/env bash
##############################################################################
#                                                                            #
# Copyright 2025 Meik Schmidt                                                #
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