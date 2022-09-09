// Convert some to ZX some (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#pragma once

#include <png.h>
#include <stdint.h>

class Png {
protected:
    bool loaded = false;
    uint32_t width = 0;
    uint32_t height = 0;
    uint8_t color_type = 0;
    uint8_t bit_depth = 0;
    int number_of_passes = 0;
    png_bytep* row_pointers = nullptr;

public:
    bool load(const char* file_name);
    bool save(const char* file_name) const;
    uint32_t getPixel(unsigned x, unsigned y) const;
    void setPixel(unsigned x, unsigned y, uint32_t c);
    inline uint32_t getWidth() const {
        return width;
    };
    inline uint32_t getHeight() const {
        return height;
    };
    ~Png();
};
