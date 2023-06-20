/*
 * SD card SPI driver
 * Copyright (c) 2023 Aleksey Morozov
 * aleksey.f.morozov@gmail.com
 * aleksey.f.morozov@yandex.ru
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <stddef.h>
#include <stdint.h>
#include "diskio.h"

DSTATUS SdcardInit();
DSTATUS SdcardGetStatus();
DRESULT SdcardRead(uint8_t buffer[], uint32_t sector_number, uint32_t sector_count);
DRESULT SdcardWrite(const uint8_t buffer[], uint32_t sector_number, size_t sector_count);
DRESULT SdcardIoctl(uint8_t id, void *buffer);
