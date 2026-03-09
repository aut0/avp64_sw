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

FROM ubuntu:24.04
WORKDIR /app
RUN apt-get update && apt-get -y install \
	build-essential \
	libncurses-dev \
	file \
	wget \
	cpio \
	python3 \
	unzip \
	rsync \
	bc \
	git \
	libssl-dev \
	device-tree-compiler

# baremetal toolchain for bootcode
RUN wget "https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz" && tar -xf gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz && rm gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz
ENV PATH="/app/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf/bin:${PATH}"

ENTRYPOINT ["/app/docker_entrypoint.sh"]
