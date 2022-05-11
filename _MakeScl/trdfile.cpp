// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "trdfile.h"
#include <string.h>
#include <limits>

TrdFileWriter::TrdFileWriter()
{
    disk = { };
    disk.info.diskType = TrdFileStruct::diskType80d;
    disk.info.id10 = 0x10;
    disk.info.firstFreeTrack = 1;
    disk.info.freeBlocksCount = TrdFileStruct::maxPayloadBlocks;
}

bool TrdFileWriter::pushBack(const char* name, char ext, uint16_t start, const void* data, size_t dataSize)
{
    // Ограничение кол-ва файлов
    if (disk.info.filesCount >= TrdFileStruct::maxFiles) return false;

    // Ограничение длины файла и расчет кол-ва секторов
    if (dataSize == 0 || dataSize > TrdFileStruct::maxFileSize) return false;
    unsigned sizeBlocks = ((unsigned)dataSize + TrdFileStruct::bytesPerSector - 1) / TrdFileStruct::bytesPerSector;
    if (sizeBlocks > TrdFileStruct::maxBlocksPerFile) return false;

    // Запись данных
    if (disk.info.firstFreeTrack == 0) return false;
    unsigned fileBlock = disk.info.firstFreeSector + (disk.info.firstFreeTrack - 1) * TrdFileStruct::sectorsPerTrack;
    unsigned offset = fileBlock * TrdFileStruct::bytesPerSector;
    if (offset + dataSize > sizeof(disk.payload)) return false;
    memcpy(&disk.payload[offset], data, dataSize);

    // Запись имени файла
    static_assert(sizeof(disk.items) / sizeof(disk.items[0]) >= TrdFileStruct::maxFiles, "");
    TrdFileStruct::Item& i = disk.items[disk.info.filesCount];
    size_t nameLength = strlen(name);
    if (nameLength > sizeof(i.name)) return false;
    memset(i.name, ' ', sizeof(i.name));
    memcpy(i.name, name, nameLength);
    i.ext = ext;
    static_assert(TrdFileStruct::maxFileSize <= std::numeric_limits<typeof(i.size)>::max(), "");
    i.size = (typeof(i.size))dataSize;
    i.start = start;
    static_assert(TrdFileStruct::maxBlocksPerFile <= std::numeric_limits<typeof(i.sectors)>::max(), "");
    i.sectors = (typeof(i.sectors))sizeBlocks;
    i.sector = disk.info.firstFreeSector;
    i.track = disk.info.firstFreeTrack;

    // Применение
    disk.info.filesCount++;
    unsigned firstFreeBlock = fileBlock + sizeBlocks;
    disk.info.firstFreeSector = firstFreeBlock % TrdFileStruct::sectorsPerTrack;
    disk.info.firstFreeTrack  = firstFreeBlock / TrdFileStruct::sectorsPerTrack + 1;
    disk.info.freeBlocksCount = TrdFileStruct::maxPayloadBlocks - firstFreeBlock;

    return true;
}

void TrdFileWriter::serialize(std::vector<uint8_t>& output)
{
    output.assign((uint8_t*)&disk, (uint8_t*)(&disk+1));
}
