// TAP to WAV converter for Iskra 1080 Tartu
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2022-07-27 Alemorf, aleksey.f.morozov@gmail.com, aleksey.f.morozov@yandex.ru

#define _USE_MATH_DEFINES

#include <iostream>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <algorithm>
#include "fs_tools.h"
#include "make_pcm_wav_file.h"

namespace Iskra1080Tape {

static constexpr uint32_t kMaxProgrammSize = 0x10000u;

class Writer {
public:
    static constexpr uint8_t kBitsPerSample = 8u;
    static constexpr uint8_t kSoundChannelsCount = 1u;
    static constexpr uint16_t kOutputFrequencyHz = 48000u;
    static constexpr uint32_t kIskraClockHz = 1200u;
    static constexpr uint32_t kSampleSize = (kOutputFrequencyHz + (kIskraClockHz / 2u)) / kIskraClockHz;
    static constexpr uint32_t kHeaderPilotSize = 5120u;
    static constexpr uint32_t kHeaderDuplicatesCount = 9u;
    static constexpr uint32_t kHeaderPayloadSize = 7u;
    static constexpr uint32_t kPauseSize = 1024u;
    static constexpr uint32_t kSamplesPerByte = 11u;
    static constexpr uint32_t kBodyPilotSize = 1280u;
    static constexpr uint8_t kWavZeroValue = 0x80u;
    static constexpr uint8_t kVolume = 0x70u;

    uint8_t one_sample_[kSampleSize] = {};
    uint8_t zero_sample_[kSampleSize] = {};

    explicit Writer(std::vector<uint8_t>* output);
    void WritePilot(uint32_t length);
    void WriteBit(bool high_bit);
    void WriteByte(uint8_t byte);
    void WritePause();
    static uint32_t CalcSamplesCount(uint32_t programm_size);
    void WriteProgramm(const std::vector<uint8_t>& source, uint32_t data_start, uint32_t data_size);

private:
    std::vector<uint8_t>* output_ = nullptr;
};

Writer::Writer(std::vector<uint8_t>* output) : output_(output) {
    assert(output_ != nullptr);

    for (size_t i = 0u; i < std::size(zero_sample_); i++) {
        const double t = i / (std::size(zero_sample_) / M_PI / 2.0);
        const double a = sin(t * 2.0);
        zero_sample_[i] = static_cast<uint8_t>(round(a * static_cast<double>(kVolume) + static_cast<double>(kWavZeroValue)));
    }

    for (size_t i = 0u; i < std::size(one_sample_); i++) {
        const double t = i / (std::size(one_sample_) / M_PI / 2.0);
        const double a = sin(t);
        one_sample_[i] = static_cast<uint8_t>(round(a * static_cast<double>(kVolume) + static_cast<double>(kWavZeroValue)));
    }
}

void Writer::WritePause() {
    constexpr uint32_t total = kPauseSize * kSampleSize;
    for (uint32_t i = 0u; i < total; i++) {
        output_->push_back(kWavZeroValue);
    }
}

void Writer::WritePilot(uint32_t length) {
    for (uint32_t i = 0u; i < length; i++) {
        WriteBit(true);
    }
}

void Writer::WriteBit(bool high_bit) {
    if (high_bit) {
        (void)output_->insert(output_->end(), zero_sample_, std::end(zero_sample_));
    } else {
        (void)output_->insert(output_->end(), one_sample_, std::end(one_sample_));
    }
}

void Writer::WriteByte(uint8_t byte) {
    WriteBit(false);
    uint8_t shift = byte;
    for (uint8_t i = 0; i < 8u; i++) {
        WriteBit((shift & 1u) != 0u);
        shift >>= 1u;
    }
    WriteBit(true);
    WriteBit(true);
}

uint32_t Writer::CalcSamplesCount(uint32_t programm_size) {
    return (kHeaderPilotSize + (kPauseSize * 3u) + kBodyPilotSize +
            ((kHeaderDuplicatesCount + programm_size) * kSamplesPerByte)) *
           kSampleSize;
}

void Writer::WriteProgramm(const std::vector<uint8_t>& source, uint32_t data_start, uint32_t data_size) {
    // Check parameters
    if ((data_size == 0u) || (data_size < kHeaderPayloadSize) || ((data_start + data_size) < data_start) ||
        ((data_start + data_size) > source.size())) {
        throw std::runtime_error(std::string("Incorrect parameters in ") + __PRETTY_FUNCTION__);
    }

    WritePause();
    WritePilot(kHeaderPilotSize);
    for (uint32_t i = 0; i < kHeaderDuplicatesCount; i++) {
        WriteByte(source[data_start]);
    }
    for (uint32_t i = 0; i < kHeaderPayloadSize; i++) {
        WriteByte(source[data_start + i]);
    }
    WritePause();
    WritePilot(kBodyPilotSize);
    for (uint32_t i = kHeaderPayloadSize; i < data_size; i++) {
        WriteByte(source[data_start + i]);
    }
    WritePause();
}

static constexpr uint32_t kSourceHeaderSize = 9u;
static constexpr uint32_t kMinSourceFileSize = kSourceHeaderSize;
static constexpr uint32_t kMaxSourceFileSize = kSourceHeaderSize + Iskra1080Tape::kMaxProgrammSize;

static constexpr uint8_t kLvovTapeFileHeader[kSourceHeaderSize] = {0x4Cu, 0x56u, 0x4Fu, 0x56u, 0x2Fu,
                                                                   0x32u, 0x2Eu, 0x30u, 0x2Fu};
static constexpr uint8_t kIskra1080TapeFileHeader[kSourceHeaderSize] = {0x49u, 0x53u, 0x4Bu, 0x52u, 0x41u,
                                                                        0x31u, 0x30u, 0x38u, 0x30u};

static void ConvertToWav(const char* source_file_name, const char* dest_file_name) {
    // Load source file
    std::vector<uint8_t> source_file;
    FsTools::LoadFile(source_file_name, kMinSourceFileSize, kMaxSourceFileSize, &source_file);

    // Check source file header
    if ((source_file.size() < sizeof(kIskra1080TapeFileHeader)) ||
        ((0 != memcmp(source_file.data(), kIskra1080TapeFileHeader, sizeof(kIskra1080TapeFileHeader))) &&
         (0 != memcmp(source_file.data(), kLvovTapeFileHeader, sizeof(kLvovTapeFileHeader))))) {
        throw std::runtime_error(std::string("Incorrect input file header ") + std::string(source_file_name));
    }

    // Programm size
    const size_t programm_size = source_file.size() - kSourceHeaderSize;

    // Allocate  memory
    std::vector<uint8_t> output;
    Iskra1080Tape::Writer writer(&output);
    const uint32_t samples_count = writer.CalcSamplesCount(programm_size);
    const uint32_t output_size =
        MakePcmWavFile::CalcFileSize(writer.kBitsPerSample, writer.kSoundChannelsCount, samples_count);
    output.reserve(output_size);

    // Write WAV file header
    output.resize(MakePcmWavFile::kWavFileHeaderSize);
    MakePcmWavFile::MakeHeader(writer.kOutputFrequencyHz, writer.kBitsPerSample, writer.kSoundChannelsCount,
                               samples_count, output.data());

    // Convert
    writer.WriteProgramm(source_file, kSourceHeaderSize, programm_size);
    assert(output.size() == output_size);

    // Save WAV file
    FsTools::SaveFile(dest_file_name, output);
}

}  // namespace Iskra1080Tape

int main(int argc, char* argv[]) {
    assert(argv != nullptr);
    assert(argc >= 1);
    int result = EXIT_FAILURE;
    try {
        std::cout << "Convert a binary programm to a loadable WAV file for Iskra 1080 Tartu computer" << std::endl
                  << "27-Jul-2022 Aleksey Morozov / Alemorf / aleksey.f.morozov@gmail.com" << std::endl
                  << std::endl;

        if (argc != 3) {
            std::cerr << "Usage: " << argv[0] << " input.i1080 output.wav" << std::endl;
            result = EXIT_FAILURE;
        } else {
            const char* const binary_file_name = argv[1];
            const char* const wav_file_name = argv[2];

            assert(binary_file_name != nullptr);
            assert(wav_file_name != nullptr);

            Iskra1080Tape::ConvertToWav(binary_file_name, wav_file_name);

            std::cout << binary_file_name << " is converted successfully to " << wav_file_name << std::endl;

            result = EXIT_SUCCESS;
        }
    } catch (const std::exception& exception) {
        std::cerr << exception.what() << std::endl;
        result = EXIT_FAILURE;
    }

    return result;
}
