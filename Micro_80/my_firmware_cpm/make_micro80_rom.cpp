/*
 * Make Micro 80 firmware
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

#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>

static const unsigned BLOCK_SIZE = 1024;
static const unsigned DIRECTORY_BLOCKS = 1;

struct Entry {
    uint8_t user;
    char name[8 + 3];
    uint8_t extent;
    uint8_t reserved;
    uint8_t extent_high;
    uint8_t size_128;
    union {
        uint8_t blocks8[16];
        uint16_t blocks16[8];
    };
};

static const unsigned DIRECTORY_SIZE = BLOCK_SIZE / sizeof(Entry) * DIRECTORY_BLOCKS;

static void SaveFile(const std::string &file_name, const void *data, size_t size) {
    std::ofstream f(file_name, std::ios::binary);
    f.write(static_cast<const char *>(data), size);
    if (!f)
        throw std::runtime_error(std::string("Can't create file ") + file_name);
}

static size_t LoadFile(const std::string &file_name, void *data, size_t size) {
    std::ifstream f(file_name, std::ios::binary);
    if (!f)
        throw std::runtime_error(std::string("Can't read file ") + file_name);
    f.seekg(0, f.end);
    const auto file_size = f.tellg();
    f.seekg(0, f.beg);
    if (size < file_size)
        throw std::runtime_error(std::string("Too big file ") + file_name + ", current size " +
                                 std::to_string(file_size) + ", max size " + std::to_string(size));
    f.read(static_cast<char *>(data), file_size);
    if (!f)
        throw std::runtime_error(std::string("Can't read file ") + file_name);
    return file_size;
}

static void MakeCpmName(struct Entry &e, const std::string &name) {
    std::fill(e.name, std::end(e.name), ' ');
    const char *s = name.c_str();
    for (size_t i = 0; i < 8 && *s != 0 && *s != '.'; i++)
        e.name[i] = toupper(*s++);
    if (*s == '.') {
        s++;
        for (size_t i = 8; i < std::size(e.name) && *s != 0; i++)
            e.name[i] = toupper(*s++);
    }
}

static void AddEntry(unsigned &block_number, struct Entry *entry, unsigned &entry_number, unsigned file_size,
                     const std::string &name) {
    Entry e = {};
    MakeCpmName(e, name);
    unsigned size_128 = (file_size + 127) / 128;
    do {
        if (entry_number == DIRECTORY_SIZE || e.extent >= 32)
            throw std::runtime_error("No space in catalog");
        e.size_128 = std::min(size_128, BLOCK_SIZE / 128 * unsigned(std::size(e.blocks8)));
        for (auto &i : e.blocks8) {
            if (size_128 > 0) {
                i = block_number++;
                size_128 = (size_128 >= BLOCK_SIZE / 128) ? (size_128 - BLOCK_SIZE / 128) : 0;
            } else {
                i = 0;
            }
        }
        entry[entry_number++] = e;
        e.extent++;
    } while (size_128 > 0);
}

int main() {
    try {
        std::vector<uint8_t> rom;
        rom.resize(0x10000);
        std::fill(rom.begin(), rom.end(), 0xE5);

        const size_t loader_size = LoadFile("cpm.bin", rom.data(), rom.size());
        const size_t storage_offset = (loader_size + BLOCK_SIZE - 1) / BLOCK_SIZE * BLOCK_SIZE;
        struct Entry *directory = reinterpret_cast<Entry *>(rom.data() + storage_offset);

        unsigned block_count = DIRECTORY_BLOCKS;
        unsigned entry_count = 0;
        for (auto &p : std::filesystem::directory_iterator("files")) {
            const unsigned offset = storage_offset + block_count * BLOCK_SIZE;
            size_t file_size = LoadFile(p.path().string(), rom.data() + offset, rom.size() - offset);
            AddEntry(block_count, directory, entry_count, file_size, p.path().filename());
            std::cout << std::string(directory[entry_count - 1].name, sizeof(directory[0].name)) << "  " << file_size
                      << " bytes  " << std::endl;
        }
        const unsigned offset = storage_offset + block_count * BLOCK_SIZE;
        std::cout << "FREE SPACE " << (rom.size() - offset) << " bytes" << std::endl;

        static const uint16_t PAGE_SIZE = 0x8000;
        for (size_t i = 0; i + PAGE_SIZE - 1 < rom.size(); i += PAGE_SIZE)
            std::reverse(rom.data() + i, rom.data() + i + PAGE_SIZE);

        SaveFile("micro80cpm.bin", rom.data(), rom.size());
    } catch (std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    return 0;
}
