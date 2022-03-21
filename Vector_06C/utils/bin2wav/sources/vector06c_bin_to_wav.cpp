// Convert program for the Soviet computer Vector 06C from ROM
// format to WAV format for loading from a music player
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2021-Jul-26 Alemorf, aleksey.f.morozov@gmail.com

#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include <stdint.h>
#include <assert.h>
#include <iostream>
#include "fs_tools.h"
#include "make_pcm_wav_file.h"

// clang-format off

static constexpr uint8_t kVector06cNameBlock[] = {
    // 16 bytes 0x00
    0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u,
    // 4 bytes 0x00
    0x55u, 0x55u, 0x55u, 0x55u,
    // 1 bytes 0xE6
    0xE6u,
    // 4 bytes 0x00
    0x00u, 0x00u, 0x00u, 0x00u,
    // 25 bytes of programm name. Unused bytes filled by 0x20
    0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u,
    0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u, 0x20u,
    // 2 bytes 0x00
    0x00u, 0x00u,
    // 1 byte = load_addr_high
    0x00u,
    // 1 byte = block_count
    0x00u,
    // 1 byte = block_remain
    0x00u,
    // 1 byte = data_sum
    0x00u,
};

constexpr uint8_t kVector06cMaxProgrammNameSize = 25u;

static constexpr uint8_t kVector06cDataBlock[] = {
    // 4 bytes 0x00
    0x00u, 0x00u, 0x00u, 0x00u,
    // 1 bytes 0xE6
    0xE6u,
    // 1 byte = number
    0x00u,
    // 1 byte = header_sum
    0x00u,
    // 32 bytes of programm name. Unused bytes filled by 0x00
    0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u,
    0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u, 0x00u,
    // 1 byte = data_sum
    0x00u,
};
// clang-format on

constexpr uint8_t kVector06cMaxBlockNumber = UINT8_MAX;
constexpr uint16_t kVector06cBlockSize = 0x100u;
constexpr uint16_t kVector06cMaxFileSize = (kVector06cMaxBlockNumber * kVector06cBlockSize);

static void PushIdenticalBytesBack(uint8_t byte, size_t size, std::vector<uint8_t>* data) {
    assert(data != nullptr);
    const size_t pos = data->size();
    data->resize(pos + size);
    std::fill(data->begin() + pos, data->end(), byte);
}

static uint8_t CalculateByteSum(const uint8_t byte_data[], size_t data_size) {
    // Check paremeters
    if (byte_data == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter byte_data = nullptr"));
    }

    // Calc sum
    uint8_t sum = 0;
    for (size_t i = 0; i != data_size; i++) {
        sum += byte_data[i];
    }
    return sum;
}

static void MakeVector06cTape(uint8_t load_address_high, const char file_name[], const uint8_t input[],
                              uint16_t input_size, std::vector<uint8_t>* out_ptr) {
    // Consts
    constexpr uint16_t kVector06cBytesInDataBlock = 32u;
    constexpr uint8_t kVector06cDataBlockCount = 8u;
    static_assert((kVector06cDataBlockCount * kVector06cBytesInDataBlock) == kVector06cBlockSize, "");
    constexpr uint8_t kVector06cPreambleSize1 = 4u;
    constexpr uint8_t kVector06cPreambleSize2 = 25u;
    constexpr uint8_t kVector05cPreambleSize3 = 2u;
    constexpr uint16_t kVector06c256BlockSize =
        sizeof(kVector06cNameBlock) + sizeof(kVector06cDataBlock) * kVector06cDataBlockCount;

    // Check paremeters
    if (file_name == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter file_name = nullptr"));
    }
    if (input == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter input = nullptr"));
    }
    if (input_size > kVector06cMaxFileSize) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter input_size = ") +
                                 std::to_string(input_size));
    }
    if (out_ptr == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out_ptr = nullptr"));
    }

    // Intermediate values
    const uint16_t block_count =
        static_cast<uint16_t>((static_cast<uint32_t>(input_size) + (kVector06cBlockSize - 1u)) / kVector06cBlockSize);

    const uint32_t file_size =
        (static_cast<uint32_t>(kVector06cPreambleSize1) * kVector06cPreambleSize2 * kVector05cPreambleSize3) +
        (static_cast<uint32_t>(kVector06c256BlockSize) * block_count);

    // Reserved memory and free buffer
    std::vector<uint8_t>& out = *out_ptr;
    out.reserve(file_size);
    out.resize(0);

    // Write preamble
    for (uint16_t i = 0; i < kVector06cPreambleSize1; i++) {
        PushIdenticalBytesBack(0x00u, kVector06cPreambleSize2, &out);
        PushIdenticalBytesBack(0x55u, kVector06cPreambleSize2, &out);
    }

    uint16_t input_offset = 0u;
    const size_t file_name_size = std::min(static_cast<size_t>(kVector06cMaxProgrammNameSize), strlen(file_name));
    for (uint32_t i = 0; i < block_count; i++) {
        // Write name block
        const size_t pos = out.size();
        (void)out.insert(out.end(), kVector06cNameBlock, &kVector06cNameBlock[sizeof(kVector06cNameBlock)]);

        // Write parameters
        (void)std::copy(file_name, &file_name[file_name_size], &out[pos + 25u]);
        out[pos + 52u] = load_address_high;
        out[pos + 53u] = block_count;
        out[pos + 54u] = block_count - i;

        // Calculate and write checksum
        const uint8_t header_sum = CalculateByteSum(&out[pos + 25u], 55u - 25u);
        out[pos + 55u] = header_sum;

        // Prevent memory damage
        static_assert(56u == sizeof(kVector06cNameBlock), "");

        // Write all data blocks
        for (uint8_t j = 0; j < kVector06cDataBlockCount; j++) {
            // Write data block
            const size_t data_pos = out.size();
            (void)out.insert(out.end(), kVector06cDataBlock, &kVector06cDataBlock[sizeof(kVector06cDataBlock)]);

            // Write parameters
            out[data_pos + 5u] = 0x80u + j;
            out[data_pos + 6u] = header_sum;

            // Write 32 bytes of data
            const uint16_t remain_size = input_size - input_offset;
            const uint16_t chunk_size = std::min(remain_size, kVector06cBytesInDataBlock);
            (void)std::copy(&input[input_offset], &input[input_offset + chunk_size], &out[data_pos + 7u]);
            input_offset += chunk_size;

            // Calculate and write checksum
            out[data_pos + 39u] = CalculateByteSum(&out[data_pos + 5u], 39u - 5u);

            // Prevent memory damage
            static_assert(40u == sizeof(kVector06cDataBlock), "");
        }
    }

    // Check calculated file size
    assert(out.size() == file_size);
}

static void MakeVector06cWav(const uint8_t data[], uint32_t data_size, std::vector<uint8_t>* result_ptr) {
    // Check paremeters
    if (data == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter data = nullptr"));
    }
    if (data_size >= UINT32_MAX) {  // For for (uint32_t i = 0u; i < data_size; i++)
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter data_size = ") +
                                 std::to_string(data_size));
    }
    if (result_ptr == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter result_ptr = nullptr"));
    }

    // Consts
    constexpr uint8_t speed = 8u;
    constexpr uint8_t ampitude = 32u;
    constexpr uint16_t freq_hz = 22050u;
    constexpr uint32_t silent_length = 8820u;
    constexpr uint8_t bits_per_sample = 8u;
    constexpr uint8_t channels_count = 1u;

    // Intermediate values
    const uint8_t zero_ampitude = (UINT8_MAX + 1u) / 2u;
    const uint8_t negative_amplitude = UINT8_MAX - ampitude;

    std::vector<uint8_t> encoded_0;
    encoded_0.reserve(2u * speed);
    PushIdenticalBytesBack(negative_amplitude, speed, &encoded_0);
    PushIdenticalBytesBack(ampitude, speed, &encoded_0);

    std::vector<uint8_t> encoded_1;
    encoded_1.reserve(2u * speed);
    PushIdenticalBytesBack(ampitude, speed, &encoded_1);
    PushIdenticalBytesBack(negative_amplitude, speed, &encoded_1);

    const uint32_t samples_count = (silent_length * 2u) + (data_size * 8u * encoded_0.size());

    // Write WAV file header
    std::vector<uint8_t>& result = *result_ptr;
    const size_t file_size = MakePcmWavFile::CalcFileSize(bits_per_sample, channels_count, samples_count);
    result.reserve(file_size);
    result.resize(MakePcmWavFile::kWavFileHeaderSize);
    MakePcmWavFile::MakeHeader(freq_hz, bits_per_sample, channels_count, samples_count, result.data());

    // Write silent
    PushIdenticalBytesBack(zero_ampitude, silent_length, &result);

    // Write data
    for (uint32_t i = 0u; i < data_size; i++) {
        const uint8_t byte = data[i];
        for (uint8_t mask = 0x80u; mask != 0u; mask >>= 1u) {
            const auto& for_insert = ((byte & mask) != 0u) ? encoded_1 : encoded_0;
            (void)result.insert(result.end(), for_insert.begin(), for_insert.end());
        }
    }

    // Write silent
    PushIdenticalBytesBack(zero_ampitude, silent_length, &result);

    // Check calculated file size
    assert(file_size == result.size());
}

int main(int argc, char* argv[]) {
    assert(argv != nullptr);
    assert(argc >= 1);
    int result = EXIT_FAILURE;
    try {
        if ((argc != 3) && (argc != 4)) {
            std::cerr << "Convert program for the Soviet computer Vector 06C from ROM" << std::endl
                      << "format to WAV format for loading from a music player" << std::endl
                      << std::endl
                      << "Copyright 2021-Jul-26 Alemorf, aleksey.f.morozov@gmail.com" << std::endl
                      << std::endl
                      << "Usage: " << argv[0] << " input.vec output.wav [programm name]" << std::endl;
            result = EXIT_FAILURE;
        } else {
            constexpr uint8_t load_address_high = 0x01;
            const char* const rom_file_name = argv[1];
            const char* const wav_file_name = argv[2];
            const char* const file_name = (argc > 3) ? argv[3] : rom_file_name;

            assert(rom_file_name != nullptr);
            assert(wav_file_name != nullptr);
            assert(file_name != nullptr);

            // Load programm file
            std::vector<uint8_t> rom_data;
            FsTools::LoadFile(rom_file_name, kVector06cMaxFileSize, &rom_data);

            // Convert programm to tape
            std::vector<uint8_t> vector_06c_tape;
            MakeVector06cTape(load_address_high, file_name, rom_data.data(), rom_data.size(), &vector_06c_tape);

            // Convert tape to wav
            std::vector<uint8_t> wav_data;
            MakeVector06cWav(vector_06c_tape.data(), vector_06c_tape.size(), &wav_data);

            // Save wav file
            FsTools::SaveFile(wav_file_name, wav_data);

            result = EXIT_SUCCESS;
        }
    } catch (const std::exception& exception) {
        std::cerr << exception.what() << std::endl;
        result = EXIT_FAILURE;
    }

    return result;
}
