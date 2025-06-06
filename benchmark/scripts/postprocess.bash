#!/bin/bash
##############################################################################
#                                                                            #
# Copyright 2025 Nils Bosbach                                                #
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

BENCHMARK=$1

BUILD_DIR=/app/build/$BENCHMARK
TMP_DIR=$BUILD_DIR/tmp
BENCH_DIR=$TMP_DIR/$BENCHMARK

echo "Posprocessing benchmark '$1'"

rm -rf $TMP_DIR
mkdir -p $BENCH_DIR

# create/copy files
cp $BUILD_DIR/$BENCHMARK.{bin,elf} $BENCH_DIR/
sed -e "s/%BENCHMARK%/${BENCHMARK}/g" /app/config/benchmark.cfg > ${TMP_DIR}/${BENCHMARK}.cfg

# create tarball
pushd ${TMP_DIR} > /dev/null
tar -czf /app/images/${BENCHMARK}.tar.gz ./*
popd > /dev/null
