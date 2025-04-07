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

FB_LOGO_APP_DIR=/app/fb_logo_app
APP_TARGET_DIR=$TARGET_DIR/root/png_to_fb

echo "Building fb_logo_app"

mkdir -p $APP_TARGET_DIR
cp $FB_LOGO_APP_DIR/assets/mwr_logo.png $APP_TARGET_DIR

pushd $FB_LOGO_APP_DIR/src > /dev/null
aarch64-buildroot-linux-gnu-g++ -o $APP_TARGET_DIR/png_to_fb png_to_fb.cpp -lpng -lz
popd  > /dev/null