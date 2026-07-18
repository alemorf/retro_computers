/*
 * c8080 stdlib
 * Copyright (c) 2025 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include <string.h>

void *__global memchr(const void *, uint8_t, size_t size) {
    asm {
__a_3_memchr=0
        ex   hl, de           ; de = size
        ld   a, d
        or   e
        jp   nz, memchr_2
__a_1_memchr=$+1
        ld   hl, 0            ; hl = buffer
__a_2_memchr=$+1
        ld   b, 0
memchr_1:
        ld   a, (hl)
        cp   b
        ret  nz
        inc  hl
        dec  de
        jp   nz, memchr_1
memchr_2:
        ld   hl, 0
    }
}