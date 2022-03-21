// Make PCM WAV file
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2021-Jul-26 Alemorf, aleksey.f.morozov@gmail.com

#ifndef MAKE_PCM_WAV_FILE_H_
#define MAKE_PCM_WAV_FILE_H_

#include <stdint.h>
#include <stddef.h>

namespace MakePcmWavFile {

static constexpr uint32_t kWavFileHeaderSize = 44u;

uint32_t CalcFileSize(uint16_t bits_per_sample, uint16_t channels_count, uint32_t samples_count);

void MakeHeader(uint32_t sample_rate_hz, uint16_t bits_per_sample, uint16_t channels_count, uint32_t samples_count,
                uint8_t out[]);

};  // namespace MakePcmWavFile

#endif  // MAKE_PCM_WAV_FILE_H_
