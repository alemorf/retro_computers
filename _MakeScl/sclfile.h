// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#pragma once

#include <stdint.h>
#include <vector>
#include "abstractfile.h"

namespace SclFileStruct
{
    #pragma pack(push, 1)

    struct Item
    {
        char name[8];
        char ext;
        uint16_t start;
        uint16_t size;
        uint8_t sectors;
    };

    static_assert(sizeof(Item) == 14, "");

    struct Id
    {
        uint8_t bytes[8];
    };
    static_assert(sizeof(Id) == 8, "");

    struct Header
    {
        Id id;
        uint8_t filesCount;
    };

    static_assert(sizeof(Header) == 9, "");

    #pragma pack(pop)

    static uint32_t calcCheckSum(const uint8_t* data, size_t data_size);

    extern const Id id;
    static const unsigned sectorSize = 256;
    static const unsigned maxFiles = 128;
    static const unsigned maxFileSectors = 255;
    static const unsigned maxFileSize = sectorSize * maxFileSectors;
}

class SclFileWriter : public AbstractFileWriter
{
private:
    std::vector<SclFileStruct::Item> items;
    std::vector<uint8_t> payload;

public:
    bool pushBack(const char* name, char ext, uint16_t start, const void* data, size_t dataSize);
    void serialize(std::vector<uint8_t>& output);
    ~SclFileWriter() {}
};

