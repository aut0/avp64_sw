/******************************************************************************
 *                                                                            *
 * Copyright 2025 Niko Zurstraßen, Ruben Brandhofer, Nils Bosbach             *
 *                                                                            *
 * Licensed under the Apache License, Version 2.0 (the "License");            *
 * you may not use this file except in compliance with the License.           *
 * You may obtain a copy of the License at                                    *
 *                                                                            *
 *     http://www.apache.org/licenses/LICENSE-2.0                             *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 *                                                                            *
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cstdint>
#include <fcntl.h>
#include <unistd.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <png.h>

void draw_png_to_framebuffer(const char *png_file, const char *fb_device) {
    int fb_fd = open(fb_device, O_RDWR);
    if (fb_fd < 0) {
        perror("Error opening framebuffer device");
        exit(EXIT_FAILURE);
    }

    struct fb_var_screeninfo vinfo;
    if (ioctl(fb_fd, FBIOGET_VSCREENINFO, &vinfo) < 0) {
        perror("Error reading variable screen info");
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    int screen_width = vinfo.xres;
    int screen_height = vinfo.yres;
    int bytes_per_pixel = vinfo.bits_per_pixel / 8;
    long screensize = screen_width * screen_height * bytes_per_pixel;

    uint8_t *fb_ptr = (uint8_t*) mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fb_fd, 0);
    if (fb_ptr == MAP_FAILED) {
        perror("Error mapping framebuffer device");
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    FILE *png_fp = fopen(png_file, "rb");
    if (!png_fp) {
        perror("Error opening PNG file");
        munmap(fb_ptr, screensize);
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fprintf(stderr, "Error creating PNG read structure\n");
        fclose(png_fp);
        munmap(fb_ptr, screensize);
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        fprintf(stderr, "Error creating PNG info structure\n");
        png_destroy_read_struct(&png_ptr, NULL, NULL);
        fclose(png_fp);
        munmap(fb_ptr, screensize);
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        fprintf(stderr, "Error during PNG read initialization\n");
        png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
        fclose(png_fp);
        munmap(fb_ptr, screensize);
        close(fb_fd);
        exit(EXIT_FAILURE);
    }

    png_init_io(png_ptr, png_fp);
    png_read_info(png_ptr, info_ptr);

    int png_width = png_get_image_width(png_ptr, info_ptr);
    int png_height = png_get_image_height(png_ptr, info_ptr);
    png_byte png_color_type = png_get_color_type(png_ptr, info_ptr);
    png_byte png_bit_depth = png_get_bit_depth(png_ptr, info_ptr);

    if (png_bit_depth == 16)
        png_set_strip_16(png_ptr);

    if (png_color_type == PNG_COLOR_TYPE_PALETTE)
        png_set_palette_to_rgb(png_ptr);

    if (png_color_type == PNG_COLOR_TYPE_GRAY && png_bit_depth < 8)
        png_set_expand_gray_1_2_4_to_8(png_ptr);

    if (png_color_type == PNG_COLOR_TYPE_GRAY || png_color_type == PNG_COLOR_TYPE_GRAY_ALPHA)
        png_set_gray_to_rgb(png_ptr);

    if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS))
        png_set_tRNS_to_alpha(png_ptr);

    png_set_filler(png_ptr, 0xFF, PNG_FILLER_AFTER);
    png_read_update_info(png_ptr, info_ptr);

    png_bytep *row_pointers = (png_bytep *)malloc(sizeof(png_bytep) * png_height);
    for (int y = 0; y < png_height; y++) {
        row_pointers[y] = (png_byte *)malloc(png_get_rowbytes(png_ptr, info_ptr));
    }

    png_read_image(png_ptr, row_pointers);
    fclose(png_fp);

    for (int y = 0; y < png_height && y < screen_height; y++) {
        for (int x = 0; x < png_width && x < screen_width; x++) {
            png_bytep px = &row_pointers[y][x * 4];
            long location = (y * screen_width + x) * bytes_per_pixel;
            if (bytes_per_pixel == 4) {
                *((uint32_t *)(fb_ptr + location)) = (px[4] << 24) | (px[0] << 16) | (px[1] << 8) | px[2];
            }
        }
    }

    for (int y = 0; y < png_height; y++) {
        free(row_pointers[y]);
    }
    free(row_pointers);

    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
    munmap(fb_ptr, screensize);
    close(fb_fd);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <png file> <framebuffer device>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    draw_png_to_framebuffer(argv[1], argv[2]);
    return 0;
}
