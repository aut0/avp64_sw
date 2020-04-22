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

FROM ubuntu:bionic
WORKDIR /app
RUN apt-get update \
	&& apt-get -y install build-essential \
	wget
RUN wget "https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-elf/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf.tar.xz"
RUN tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf.tar.xz 
ENV PATH="/app/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf/bin:${PATH}"
ENTRYPOINT ["/app/docker_entrypoint.sh"]
