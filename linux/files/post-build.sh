#!/usr/bin/env bash
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

TARGET_SW_DIR=/app/target_sw
PNG_TO_FB_DIR=$TARGET_SW_DIR/png_to_fb
APP_TARGET_DIR=$TARGET_DIR/root/png_to_fb

echo "Building png_to_fb"

rm -rf $APP_TARGET_DIR
mkdir -p $APP_TARGET_DIR
cp $PNG_TO_FB_DIR/assets/mwr_logo.png $APP_TARGET_DIR
cp $PNG_TO_FB_DIR/assets/test_card.png $APP_TARGET_DIR

pushd $PNG_TO_FB_DIR/src > /dev/null
aarch64-buildroot-linux-gnu-g++ -o $APP_TARGET_DIR/png_to_fb png_to_fb.cpp -lpng -lz
popd  > /dev/null


echo "Building NPB suite"
NPB_DIR=$TARGET_SW_DIR/NPB3.4-OMP
NPB_TARGET_DIR=$TARGET_DIR/root/npb

cd $NPB_DIR
make suite

rm -rf $NPB_TARGET_DIR
mkdir -p $NPB_TARGET_DIR
cp $NPB_DIR/bin/* $NPB_TARGET_DIR/

make clean
