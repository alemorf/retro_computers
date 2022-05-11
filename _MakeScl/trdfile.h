// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#pragma once

#include <stdint.h>
#include <vector>
#include "abstractfile.h"
#include <assert.h>

namespace TrdFileStruct
{
    static const unsigned bytesPerSector = 256;
    static const unsigned maxFiles = 128;
    static const unsigned maxBlocksPerFile = 255;
    static const unsigned maxFileSize = bytesPerSector * maxBlocksPerFile;
    static const unsigned sectorsPerTrack = 16;
    static const unsigned maxTracks = 160;
    static const unsigned maxBlocks = sectorsPerTrack * maxTracks;
    static const unsigned maxPayloadBlocks = sectorsPerTrack * (maxTracks - 1);
    static const unsigned maxDiskSize = maxBlocks * bytesPerSector; // 655360
    static const unsigned maxDiskPayloadSize = maxPayloadBlocks * bytesPerSector;

    static_assert(maxDiskSize == 655360, "");

    enum DiskType
    {
        diskType80d = 0x16,
        diskType40d = 0x17,
        diskType80s = 0x18,
        diskType40s = 0x19,
    };

    #pragma pack(push, 1)

    struct Item
    {
        char     name[8];
        char     ext;
        uint16_t start;
        uint16_t size;
        uint8_t  sectors;
        uint8_t  sector;
        uint8_t  track;
    };

    static_assert(sizeof(Item) == 16, "");

    struct Info
    {
        uint8_t  id;                // Должно быть равно 0
        uint8_t  unused1[224];      // Hе иcпользуетcя (заполнено байтом 0)
        uint8_t  firstFreeSector;   // Hомеp пеpвого незанятого cектоpа на диcке
        uint8_t  firstFreeTrack;    // Hомеp доpожки пеpвого незанятого cектоpа
        uint8_t  diskType;          // Тип диcкеты
        uint8_t  filesCount;        // Количеcтво файлов
        uint16_t freeBlocksCount;  // Количеcтво cвободных cектоpов
        uint8_t  id10;              // Должно быть 0x10. Идентификационный код TR-DOS.
        uint8_t  unused2[12];       // Hе иcпользуетcя
        uint8_t  deletedFilesCount; // Количеcтво удаленных фай  лов
        uint8_t  diskLabel[8];      // Hазвание диcкеты
        uint8_t  unused3[3];        // Hе иcпользуетcя (заполнено байтом 0)
    };

    static_assert(sizeof(Info) == bytesPerSector, "");

    struct Disk {
    public:
        Item    items[maxFiles];
        Info    info;
        uint8_t unusedSectors[(sectorsPerTrack - 9) * bytesPerSector];
        uint8_t payload[maxDiskPayloadSize];
    };

    static_assert(sizeof(Disk) == maxDiskSize, "");

    #pragma pack(pop)

    static uint32_t calcCheckSum(const uint8_t* data, size_t data_size);
}

class TrdFileWriter : public AbstractFileWriter
{
private:
    TrdFileStruct::Disk disk;

public:
    TrdFileWriter();
    bool pushBack(const char* name, char ext, uint16_t start, const void* data, size_t dataSize);
    void serialize(std::vector<uint8_t>& output);
    ~TrdFileWriter() {}
};

