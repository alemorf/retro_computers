/*
 * DWT driver for STM32
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

#include "stm32f4xx_hal.h"

#define SYSTEM_CORE_CLOCK 60000000u

#define US_TO_DWT(US) ((US) * (SYSTEM_CORE_CLOCK / 1000000u))

static inline void DWT_Init(void) {
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}

#define DWT_DELAY_US(T)                                             \
    do {                                                            \
        const uint32_t dwt_timeout = US_TO_DWT(T);                  \
        const uint32_t dwt_start = DWT->CYCCNT;                     \
        while ((uint32_t)(DWT->CYCCNT - dwt_start) < dwt_timeout) { \
        }                                                           \
    } while (0)
