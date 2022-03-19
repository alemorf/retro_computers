// Make RKA file for B2M emulator
// 2021-01-05 Alemorf aleksey.f.morozov@gmail.com
// 2021-01-06 MISRA

#include <stdexcept>
#include <string>
#include <iostream>
#include <vector>
#include <string.h>
#include "fstools.h"
#include <assert.h>

#pragma pack(push, 1)

struct RkaFileHeader
{
    uint8_t loadAddressHigh = 0U;
    uint8_t loadAddressLow = 0U;
    uint8_t endAddressHigh = 0U;
    uint8_t endAddressLow = 0U;
};

struct RkaFileFooter
{
    uint8_t null0   = 0U;
    uint8_t null1   = 0U;
    uint8_t null2   = 0U;
    uint8_t null3   = 0U;
    uint8_t sync    = 0xE6U;
    uint8_t crcHigh = 0U;
    uint8_t crcLow  = 0U;
};

#pragma pack(pop)

static uint16_t apogeySum(const uint8_t* data, const size_t dataSize)
{
    assert(data != nullptr);

    uint16_t result = 0U;
    if (dataSize > 0U)
    {
        unsigned i = 0U;
        for (i = 0U; i < (dataSize - 1U); i++)
        {
            result = static_cast<uint16_t>(result + (data[i] * 257U));
        }
        result = static_cast<uint16_t>((result & 0xFF00U) | ((result + data[i]) & 0x00FFU));
    }
    return result;
}

int main(int argc, const char** argv)
{
    assert(argv != nullptr);
    assert(argv[0] != nullptr);
    assert(argc > 0);

    int result = 1;
    try
    {
        if (argc != 4)
        {
            throw std::runtime_error(std::string("Usage: ") + argv[0] + " <start address> <output file name> <input file name>");
        }

        assert(argv[1] != nullptr);
        assert(argv[2] != nullptr);
        assert(argv[3] != nullptr);

        // Maximal file size
        static const size_t maxFileSize = 0x10000;

        // Load file
        std::vector<uint8_t> buffer;
        loadFile(argv[3], [&](size_t fileSize)
        {
            if (fileSize > maxFileSize)
            {
                throw std::runtime_error("Too big source file");
            }
            buffer.resize(fileSize + sizeof(RkaFileHeader) + sizeof(RkaFileFooter));
            return &buffer[sizeof(RkaFileHeader)];
        });

        const size_t programmSize = buffer.size() - sizeof(RkaFileHeader) - sizeof(RkaFileFooter);

        // Get start address
        char* incorrectStartValue = nullptr;
        const auto loadAddress = strtoul(argv[1], &incorrectStartValue, 0);
        if ((incorrectStartValue[0] != 0) || (loadAddress >= maxFileSize) || (programmSize > (maxFileSize - loadAddress)))
        {
            throw std::runtime_error("Incorrect start address");
        }

        // Write header
        RkaFileHeader rkaFileHeader;
        rkaFileHeader.loadAddressHigh =  static_cast<uint8_t>(loadAddress >> 8U);
        rkaFileHeader.loadAddressLow = static_cast<uint8_t>(loadAddress);
        const unsigned endAddress = loadAddress + programmSize - 1U;
        rkaFileHeader.endAddressHigh = static_cast<uint8_t>(endAddress >> 8U);
        rkaFileHeader.endAddressLow = static_cast<uint8_t>(endAddress);
        (void)memcpy(&buffer[0U], &rkaFileHeader, sizeof(rkaFileHeader));

        // Calc CRC
        const uint16_t crc = apogeySum(&buffer[sizeof(RkaFileHeader)], programmSize);

        // Write footer
        RkaFileFooter rkaFileFooter;
        rkaFileFooter.crcHigh = static_cast<uint8_t>(crc >> 8U);
        rkaFileFooter.crcLow = static_cast<uint8_t>(crc);
        (void)memcpy(&buffer[sizeof(RkaFileHeader) + programmSize], &rkaFileFooter, sizeof(rkaFileFooter));

        // Save file
        saveFile(argv[2], buffer.data(), buffer.size());
        result = 0;

        // Debug
        std::cout << "Created file " << argv[2] << std::hex
                  << ", start address " << loadAddress
                  << ", end address " << endAddress
                  << ", programm size " << programmSize
                  << ", file size " << buffer.size()
                  << ", crc " << crc
                  << std::endl;

        // Exception
    }
    catch(const std::exception& e)
    {
        std::cerr << argv[0] << ": " << e.what() << std::endl;
        result = 1;
    }
    catch(...)
    {
        std::cerr << argv[0] << ": Unknown exception" << std::endl;
        result = 1;
    }
    return result;
}
