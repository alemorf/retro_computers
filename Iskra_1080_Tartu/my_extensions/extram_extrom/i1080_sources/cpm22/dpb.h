/*
 * Iskra 1080 Extension card firmware
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include <stdint.h>

struct DPB {
    uint16_t spt;     /* Number of 128-byte records per track */
    uint8_t bsh;      /* Block shift. 3 => 1k, 4 => 2k, 5 => 4k.... */
    uint8_t blm;      /* Block mask. 7 => 1k, 0Fh => 2k, 1Fh => 4k... */
    uint8_t exm;      /* Extent mask */
    uint16_t dsm;     /* (no. of blocks on the disc) - 1 */
    uint16_t drm;     /* (no. of directory entries) - 1 */
    uint8_t al0, al1; /* AL - Directory allocation bitmap */
    uint16_t cks;     /* Checksum vector size,0 or 8000h for a fixed disc */
    uint16_t off;     /* Offset, number of reserved tracks */
};

struct DPH {
    uint32_t zero0;
    uint32_t zero1;
    uint8_t *dirbuf;
    struct DPB *dpb;
    uint8_t *csv;
    uint8_t *alv;
};

#define DPB_BLM(BLOCKCOUNT, BLOCKSIZE) ((BLOCKCOUNT) < 0x100 ? (BLOCKSIZE) : -(BLOCKSIZE))

#define DPB_FILES_COUNT(BLOCKSIZE, DIRECTORYBLOCKS) (((BLOCKSIZE) / 32) * (DIRECTORYBLOCKS))

#define CSV_SIZE(FIXED_, BLOCK_SIZE_, DIRECTORY_BLOCKS_) \
    ((FIXED_) ? 0 : ((DPB_FILES_COUNT(BLOCK_SIZE_, DIRECTORY_BLOCKS_) + 3) / 4))

#define ALV_SIZE(BLOCK_COUNT_) (((BLOCK_COUNT_) + 7) / 8)

#define DPB_ERROR a

/* clang-format off */

#define MAKE_DPB(SEC_128_PER_TRACK, BLOCK_SIZE, BLOCK_COUNT, DIRECTORY_BLOCKS, FIXED)     \
    {                                                                                     \
        /* SPT - Number of 128-byte records per track */                                  \
        ((SEC_128_PER_TRACK) >= 1 && (SEC_128_PER_TRACK) <= 0xFFFF) ? (SEC_128_PER_TRACK) \
                                                                    : DPB_ERROR,          \
        /* BSH - Block shift. 3 => 1k, 4 => 2k, 5 => 4k.... */                            \
        (BLOCK_SIZE) == 1024    ? 3                                                       \
        : (BLOCK_SIZE) == 2048  ? 4                                                       \
        : (BLOCK_SIZE) == 4096  ? 5                                                       \
        : (BLOCK_SIZE) == 8192  ? 6                                                       \
        : (BLOCK_SIZE) == 16384 ? 7                                                       \
                                : DPB_ERROR,                                              \
        /* BLM - Block mask. 7 => 1k, 0Fh => 2k, 1Fh => 4k... */                          \
        (BLOCK_SIZE) == 1024    ? 0x07                                                    \
        : (BLOCK_SIZE) == 2048  ? 0x0F                                                    \
        : (BLOCK_SIZE) == 4096  ? 0x1F                                                    \
        : (BLOCK_SIZE) == 8192  ? 0x3F                                                    \
        : (BLOCK_SIZE) == 16384 ? 0x7F                                                    \
                                : DPB_ERROR,                                              \
        /* EXM - Extent mask */                                                           \
        DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == 1024     ? 0x00                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == 2048   ? 0x01                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == 4096   ? 0x03                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == 8192   ? 0x07                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == 16384  ? 0x0F                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == -2048  ? 0x00                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == -4096  ? 0x01                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == -8192  ? 0x03                               \
        : DPB_BLM(BLOCK_COUNT, BLOCK_SIZE) == -16384 ? 0x07                               \
                                                     : DPB_ERROR,                         \
        /* DSM - (no. of blocks on the disc) - 1 */                                       \
        ((BLOCK_COUNT) >= 1 && (BLOCK_COUNT) <= 0x10000) ? ((BLOCK_COUNT) - 1)            \
                                                         : DPB_ERROR,                     \
        /* DRM - (no. of directory entries) - 1 */                                        \
        ((DIRECTORY_BLOCKS) >= 1 && (DIRECTORY_BLOCKS) <= 16)                             \
        ? (DPB_FILES_COUNT(BLOCK_SIZE, DIRECTORY_BLOCKS) - 1)                             \
        : DPB_ERROR,                                                                      \
        /* AL0, AL1 - Directory allocation bitmap */                                      \
        (0xFFFF00 >> (DIRECTORY_BLOCKS)) & 0xFF,                                          \
        (0xFF0000 >> (DIRECTORY_BLOCKS)) & 0xFF,                                          \
        /* CKS - Checksum vector size, 0 or 8000h for a fixed disc */                     \
        CSV_SIZE(FIXED, BLOCK_SIZE, DIRECTORY_BLOCKS),                                    \
        /* OFF - Offset, number of reserved tracks */                                     \
        0,                                                                                \
    }

