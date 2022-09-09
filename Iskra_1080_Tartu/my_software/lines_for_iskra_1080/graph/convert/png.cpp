// Convert some to ZX some (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "png.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <iostream>

bool Png::load(const char* fileName) {
    if (loaded) {
        std::cerr << "Image already loaded" << std::endl;
        return false;
    }

    FILE* fp = fopen(fileName, "rb");
    if (!fp) {
        std::cerr << "Can't open file " << fileName << std::endl;
        return false;
    }

    unsigned char header[8];
    if (fread(header, 1, 8, fp) != 8) {
        std::cerr << "Can't read file " << fileName << std::endl;
        fclose(fp);
        return false;
    }

    if (png_sig_cmp(header, 0, 8)) {
        std::cerr << "File " << fileName << " is not recognized as a PNG file" << std::endl;
        fclose(fp);
        return false;
    }

    //! Надо ли освобождать память занятую объектом?
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        std::cerr << "png_create_read_struct failed" << std::endl;
        fclose(fp);
        return false;
    }

    //! Надо ли освобождать память занятую объектом?
    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        std::cerr << "png_create_info_struct failed" << std::endl;
        fclose(fp);
        return false;
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        std::cerr << "Error during init_io" << std::endl;
        fclose(fp);
        return false;
    }

    png_init_io(png_ptr, fp);          // no return
    png_set_sig_bytes(png_ptr, 8);     // no return
    png_read_info(png_ptr, info_ptr);  // no return

    width = png_get_image_width(png_ptr, info_ptr);
    height = png_get_image_height(png_ptr, info_ptr);
    color_type = png_get_color_type(png_ptr, info_ptr);
    bit_depth = png_get_bit_depth(png_ptr, info_ptr);
    number_of_passes = png_set_interlace_handling(png_ptr);
    png_read_update_info(png_ptr, info_ptr);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        std::cerr << "Error during read_image" << std::endl;
        fclose(fp);
        return false;
    }

    png_size_t row_size = png_get_rowbytes(png_ptr, info_ptr);

    size_t s1 = sizeof(png_bytep) * height;
    row_pointers = (png_bytep*)malloc(s1 + row_size * height);
    if (!row_pointers) {
        std::cerr << "Out of memory" << std::endl;
        fclose(fp);
        return false;
    }

    for (unsigned y = 0; y < height; y++) row_pointers[y] = (uint8_t*)row_pointers + s1 + row_size * y;

    png_read_image(png_ptr, row_pointers);  // no return

    fclose(fp);

    if (color_type != PNG_COLOR_TYPE_RGB && color_type != PNG_COLOR_TYPE_RGBA) {
        std::cerr << "Unsupported color type" << std::endl;
        return false;
    }

    loaded = true;
    return true;
}

bool Png::save(const char* fileName) const {
    if (!loaded) {
        std::cerr << "Image not loaded" << std::endl;
        return false;
    }

    FILE* fp = fopen(fileName, "wb");
    if (!fp) {
        std::cerr << "Can't create file " << fileName << std::endl;
        return false;
    }

    //! Надо ли освобождать память занятую объектом?
    png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fclose(fp);
        std::cerr << "png_create_write_struct failed" << std::endl;
        return false;
    }

    //! Надо ли освобождать память занятую объектом?
    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        fclose(fp);
        std::cerr << "png_create_info_struct failed" << std::endl;
        return false;
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        std::cerr << "Error during init_io" << std::endl;
        return false;
    }

    png_init_io(png_ptr, fp);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        std::cerr << "Error during writing header" << std::endl;
        return false;
    }

    png_set_IHDR(png_ptr, info_ptr, width, height, bit_depth, color_type, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE,
                 PNG_FILTER_TYPE_BASE);  // no return

    png_write_info(png_ptr, info_ptr);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        std::cerr << "Error during writing bytes" << std::endl;
        return false;
    }

    png_write_image(png_ptr, row_pointers);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        std::cerr << "Error during end of write" << std::endl;
        return false;
    }

    png_write_end(png_ptr, NULL);  // no return;

    fclose(fp);
    return true;
}

uint32_t Png::getPixel(unsigned x, unsigned y) const {
    if (x >= width || y >= height) return 0xFF00FF;
    switch (color_type) {
        case PNG_COLOR_TYPE_RGB:
            return (*(uint32_t*)&row_pointers[y][x * 3]) & 0xFFFFFF;
        case PNG_COLOR_TYPE_RGBA:
            return (*(uint32_t*)&row_pointers[y][x * 4]) & 0xFFFFFF;
    }
    return 0;
}

void Png::setPixel(unsigned x, unsigned y, uint32_t c) {
    uint8_t* a;
    if (x >= width || y >= height) return;
    switch (color_type) {
        case PNG_COLOR_TYPE_RGB:
            a = &row_pointers[y][x * 3];
            *(uint16_t*)a = c;
            *(uint8_t*)(a + 2) = c >> 16;
            break;
        case PNG_COLOR_TYPE_RGBA:
            *(uint32_t*)&row_pointers[y][x * 4] = c;
            break;
    }
}

Png::~Png() {
    free(row_pointers);
}
