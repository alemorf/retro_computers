// Make PCM WAV file
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2021-07-26 Alemorf, aleksey.f.morozov@gmail.com, aleksey.f.morozov@yandex.ru

#include "make_pcm_wav_file.h"
#include <stdexcept>
#include <iostream>
#include <string>

namespace MakePcmWavFile {

uint32_t CalcFileSize(uint16_t bits_per_sample, uint16_t channels_count, uint32_t samples_count) {
    // Check parameters

    if ((bits_per_sample != 8u) && (bits_per_sample != 16u)) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter bits_per_sample = ") +
                                 std::to_string(bits_per_sample));
    }

    // Сalculate result

    const uint32_t block_align_32 = static_cast<uint32_t>(bits_per_sample / 8u) * channels_count;

    if (block_align_32 > UINT16_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint64_t data_size_64 = static_cast<uint64_t>(block_align_32) * samples_count;

    if (data_size_64 > UINT32_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint64_t file_size_64 = kWavFileHeaderSize + data_size_64;

    if (file_size_64 > UINT32_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    return static_cast<uint32_t>(file_size_64);
}

void MakeHeader(uint32_t sample_rate_hz, uint16_t bits_per_sample, uint16_t channels_count, uint32_t samples_count,
                uint8_t out[]) {
    // Check parameters

    if ((bits_per_sample != 8u) && (bits_per_sample != 16u)) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter bits_per_sample = ") +
                                 std::to_string(bits_per_sample));
    }

    if (out == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out = nullptr"));
    }

    // Сalculate intermediate values

    const uint32_t block_align_32 = static_cast<uint32_t>(bits_per_sample / 8u) * channels_count;

    if (block_align_32 > UINT16_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint16_t block_align = static_cast<uint16_t>(block_align_32);

    const uint64_t bytes_rate_64 = static_cast<uint64_t>(block_align) * sample_rate_hz;

    if (bytes_rate_64 > UINT32_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint32_t bytes_rate = static_cast<uint32_t>(bytes_rate_64);

    const uint64_t data_size_64 = static_cast<uint64_t>(block_align) * samples_count;

    if (data_size_64 > UINT32_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint32_t data_size = static_cast<uint32_t>(data_size_64);

    const uint64_t file_size_64 = kWavFileHeaderSize + data_size_64;

    if (file_size_64 > UINT32_MAX) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameters"));
    }

    const uint32_t file_size = static_cast<uint32_t>(file_size_64);

    // Write header

    // Chunk id = "RIFF"
    out[0] = 0x52u;
    out[1] = 0x49u;
    out[2] = 0x46u;
    out[3] = 0x46u;

    // Chunk size
    const uint32_t chunk_size = file_size - 8u;
    out[4] = static_cast<uint8_t>(chunk_size);
    out[5] = static_cast<uint8_t>(chunk_size >> 8u);
    out[6] = static_cast<uint8_t>(chunk_size >> 16u);
    out[7] = static_cast<uint8_t>(chunk_size >> 24u);

    // Format = "WAVE"
    out[8] = 0x57u;
    out[9] = 0x41u;
    out[10] = 0x56u;
    out[11] = 0x45u;

    // SubFormat = "fmt "
    out[12] = 0x66u;
    out[13] = 0x6du;
    out[14] = 0x74u;
    out[15] = 0x20u;

    // Sub chunk 1 size
    out[16] = 0x10u;
    out[17] = 0x00u;
    out[18] = 0x00u;
    out[19] = 0x00u;

    // Audio format = 1 = PCM
    out[20] = 0x01u;
    out[21] = 0x00u;

    // Channel count
    out[22] = static_cast<uint8_t>(channels_count);
    out[23] = static_cast<uint8_t>(channels_count >> 8u);

    // Sample rate HZ
    out[24] = static_cast<uint8_t>(sample_rate_hz);
    out[25] = static_cast<uint8_t>(sample_rate_hz >> 8u);
    out[26] = static_cast<uint8_t>(sample_rate_hz >> 16u);
    out[27] = static_cast<uint8_t>(sample_rate_hz >> 24u);

    // Bytes rate
    out[28] = static_cast<uint8_t>(bytes_rate);
    out[29] = static_cast<uint8_t>(bytes_rate >> 8u);
    out[30] = static_cast<uint8_t>(bytes_rate >> 16u);
    out[31] = static_cast<uint8_t>(bytes_rate >> 24u);

    // Block align
    out[32] = static_cast<uint8_t>(block_align);
    out[33] = static_cast<uint8_t>(block_align >> 8u);

    // Block align
    out[34] = static_cast<uint8_t>(bits_per_sample);
    out[35] = static_cast<uint8_t>(bits_per_sample >> 8u);

    // SubFormat "data"
    out[36] = 0x64u;
    out[37] = 0x61u;
    out[38] = 0x74u;
    out[39] = 0x61u;

    // Chunk size
    out[40] = static_cast<uint8_t>(data_size);
    out[41] = static_cast<uint8_t>(data_size >> 8u);
    out[42] = static_cast<uint8_t>(data_size >> 16u);
    out[43] = static_cast<uint8_t>(data_size >> 24u);

    static_assert(kWavFileHeaderSize == 44u, "");
}

}  // namespace MakePcmWavFile
