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

# Framebuffer device
FB_DEVICE="/dev/fb1"

# Square parameters
SQUARE_SIZE=100       # Side length of the square in pixels
COLOR="\xff\x00\x00\xff" # BGRA (blue in this case)

# Ensure the framebuffer device exists
if [ ! -e "$FB_DEVICE" ]; then
    echo "Framebuffer device $FB_DEVICE not found!"
    exit 1
fi

# Get framebuffer information
FB_INFO=$(fbset -fb $FB_DEVICE | grep "geometry")
SCREEN_WIDTH=$(echo $FB_INFO | awk '{print $2}')
SCREEN_HEIGHT=$(echo $FB_INFO | awk '{print $3}')

# Ensure the square fits on the screen
if (( SQUARE_SIZE > SCREEN_WIDTH || SQUARE_SIZE > SCREEN_HEIGHT )); then
    echo "Square size exceeds screen dimensions!"
    exit 1
fi

# Create the raw pixel data for the square
TEMP_FILE="/tmp/square.raw"
TEMP_FILE_ROW="/tmp/row.raw"
rm -f "$TEMP_FILE"
rm -f "$TEMP_FILE_ROW"

# Create one row of the square
for (( i = 0; i < SQUARE_SIZE; i++ )); do
    echo -ne "$COLOR" >> "$TEMP_FILE_ROW"
done
for (( i = SQUARE_SIZE; i < SCREEN_WIDTH; i++ )); do
    echo -ne "\x00\x00\x00\x00" >> "$TEMP_FILE_ROW"
done

# Repeat the row to form the square
for (( i = 1; i < SQUARE_SIZE; i++ )); do
    cat "$TEMP_FILE_ROW" >> "$TEMP_FILE"
done

# Write the square to the framebuffer (top-left corner)
dd if="$TEMP_FILE" of="$FB_DEVICE" bs=4 seek=0 conv=notrunc

# Clean up
rm "$TEMP_FILE"
rm "$TEMP_FILE_ROW"
echo "Square drawn on the framebuffer!"
