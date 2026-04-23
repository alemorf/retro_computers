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

#pragma once

#pragma codepage reset

#pragma codepage('Ю', 0x60)
#pragma codepage('А', 0x61)
#pragma codepage('Б', 0x62)
#pragma codepage('Ц', 0x63)
#pragma codepage('Д', 0x64)
#pragma codepage('Е', 0x65)
#pragma codepage('Ф', 0x66)
#pragma codepage('Г', 0x67)
#pragma codepage('Х', 0x68)
#pragma codepage('И', 0x69)
#pragma codepage('Й', 0x6A)
#pragma codepage('К', 0x6B)
#pragma codepage('Л', 0x6C)
#pragma codepage('М', 0x6D)
#pragma codepage('Н', 0x6E)
#pragma codepage('О', 0x6F)
#pragma codepage('П', 0x70)
#pragma codepage('Я', 0x71)
#pragma codepage('Р', 0x72)
#pragma codepage('С', 0x73)
#pragma codepage('Т', 0x74)
#pragma codepage('У', 0x75)
#pragma codepage('Ж', 0x76)
#pragma codepage('В', 0x77)
#pragma codepage('Ь', 0x78)
#pragma codepage('Ы', 0x79)
#pragma codepage('З', 0x7A)
#pragma codepage('Ш', 0x7B)
#pragma codepage('Э', 0x7C)
#pragma codepage('Щ', 0x7D)
#pragma codepage('Ч', 0x7E)
#pragma codepage('■', 0x7F)

/* Сonvert unsupported lowercase characters to uppercase */

#pragma codepage('a', 0x41)
#pragma codepage('b', 0x42)
#pragma codepage('c', 0x43)
#pragma codepage('d', 0x44)
#pragma codepage('e', 0x45)
#pragma codepage('f', 0x46)
#pragma codepage('g', 0x47)
#pragma codepage('h', 0x48)
#pragma codepage('i', 0x49)
#pragma codepage('j', 0x4A)
#pragma codepage('k', 0x4B)
#pragma codepage('l', 0x4C)
#pragma codepage('m', 0x4D)
#pragma codepage('n', 0x4E)
#pragma codepage('o', 0x4F)
#pragma codepage('p', 0x50)
#pragma codepage('q', 0x51)
#pragma codepage('r', 0x52)
#pragma codepage('s', 0x53)
#pragma codepage('t', 0x54)
#pragma codepage('u', 0x55)
#pragma codepage('v', 0x56)
#pragma codepage('w', 0x57)
#pragma codepage('x', 0x58)
#pragma codepage('y', 0x59)
#pragma codepage('z', 0x5A)
#pragma codepage('{', 0x5B)
#pragma codepage('|', 0x5C)
#pragma codepage('}', 0x5D)
#pragma codepage('~', 0x5E)

#pragma codepage('ю', 0x60)
#pragma codepage('а', 0x61)
#pragma codepage('б', 0x62)
#pragma codepage('ц', 0x63)
#pragma codepage('д', 0x64)
#pragma codepage('е', 0x65)
#pragma codepage('ф', 0x66)
#pragma codepage('г', 0x67)
#pragma codepage('х', 0x68)
#pragma codepage('и', 0x69)
#pragma codepage('й', 0x6A)
#pragma codepage('к', 0x6B)
#pragma codepage('л', 0x6C)
#pragma codepage('м', 0x6D)
#pragma codepage('н', 0x6E)
#pragma codepage('о', 0x6F)
#pragma codepage('п', 0x70)
#pragma codepage('я', 0x71)
#pragma codepage('р', 0x72)
#pragma codepage('с', 0x73)
#pragma codepage('т', 0x74)
#pragma codepage('у', 0x75)
#pragma codepage('ж', 0x76)
#pragma codepage('в', 0x77)
#pragma codepage('ь', 0x78)
#pragma codepage('ы', 0x79)
#pragma codepage('з', 0x7A)
#pragma codepage('ш', 0x7B)
#pragma codepage('э', 0x7C)
#pragma codepage('щ', 0x7D)
#pragma codepage('ч', 0x7E)

/* Сonvert unsupported border characters */

#pragma codepage('─', 0x2D)  // -
#pragma codepage('│', 0x21)  // !
#pragma codepage('┌', 0x2B)  // +
#pragma codepage('┐', 0x2B)  // +
#pragma codepage('└', 0x2B)  // +
#pragma codepage('┘', 0x2B)  // +
#pragma codepage('├', 0x2B)  // +
#pragma codepage('┤', 0x2B)  // +
#pragma codepage('┬', 0x2B)  // +
#pragma codepage('┴', 0x2B)  // +
#pragma codepage('┼', 0x2B)  // +
