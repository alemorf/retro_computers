// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "sclfile.h"
#include <limits> // std::numeric_limits
#include <string.h> // strlen, memset, memcpy
#include <assert.h> // static_assert

namespace SclFileStruct
{
    const Id id = { 'S', 'I', 'N', 'C', 'L', 'A', 'I', 'R' };

    uint32_t calcCheckSum(const uint8_t* data, size_t data_size)
    {
        uint32_t checkSum = 0;
        for(const uint8_t* i = data, *ie = i + data_size; i != ie; i++)
            checkSum += *i;
        return checkSum;
    }
}

bool SclFileWriter::pushBack(const char* name, char ext, uint16_t start, const void* data, size_t dataSize)
{
    if (items.size() >= SclFileStruct::maxFiles - 1) return false;

    // Проверка длины файла и расчет кол-ва секторов
    if (dataSize == 0 || dataSize > SclFileStruct::maxFileSize) return false;
    unsigned sizeSectors = ((unsigned)dataSize + SclFileStruct::sectorSize - 1) / SclFileStruct::sectorSize;
    unsigned paddingSize = sizeSectors * SclFileStruct::sectorSize - dataSize;
    if (sizeSectors > SclFileStruct::maxFileSectors) return false;

    // Запись имени файла
    SclFileStruct::Item i;
    size_t nameLength = strlen(name);
    if (nameLength > sizeof(i.name)) return false;
    memset(i.name, ' ', sizeof(i.name));
    memcpy(i.name, name, nameLength);
    i.ext = ext;
    static_assert(SclFileStruct::maxFileSize <= std::numeric_limits<typeof(i.size)>::max(), "");
    i.size = (typeof(i.size))dataSize;
    i.start = start;
    static_assert(SclFileStruct::maxFileSectors <= std::numeric_limits<typeof(i.sectors)>::max(), "");
    i.sectors = (typeof(i.sectors))sizeSectors;
    items.push_back(i);

    // Запись тела файла
    size_t insertPos = payload.size();
    payload.resize(insertPos + dataSize + paddingSize);
    memcpy(payload.data() + insertPos, data, dataSize);
    memset(payload.data() + insertPos + dataSize, 0, paddingSize);

    return true;
}

void SclFileWriter::serialize(std::vector<uint8_t>& output)
{
    size_t itemsSize = sizeof(items[0]) * items.size();
    uint32_t checkSum;
    output.resize(sizeof(SclFileStruct::Header) + itemsSize + payload.size() + sizeof(checkSum));
    SclFileStruct::Header& header = *(SclFileStruct::Header*)output.data();
    header.id = SclFileStruct::id;
    static_assert(SclFileStruct::maxFiles <= std::numeric_limits<typeof(header.filesCount)>::max(), "");
    header.filesCount = (typeof(header.filesCount))items.size();
    memcpy(output.data() + sizeof(header), items.data(), itemsSize);
    memcpy(output.data() + sizeof(header) + itemsSize, payload.data(), payload.size());
    checkSum = SclFileStruct::calcCheckSum(output.data(), output.size() - sizeof(checkSum));
    memcpy(output.data() + output.size() - sizeof(checkSum), &checkSum, sizeof(checkSum));
}
