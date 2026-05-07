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

#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>
#include <string.h>
#include "megalz.h"
#include "../storage.h"

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

static const unsigned A_ROM_DIRECTORY_COUNT = A_BLOCK_SIZE / sizeof(Entry) * A_ROM_DIRECORY_BLOCKS;

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

static size_t LoadFile(const std::string &file_name, std::vector<uint8_t> &data) {
    std::ifstream f(file_name, std::ios::binary);
    if (!f)
        throw std::runtime_error(std::string("Can't read file ") + file_name);
    f.seekg(0, f.end);
    const auto file_size = f.tellg();
    f.seekg(0, f.beg);
    auto offset = data.size();
    data.resize(offset + file_size);
    f.read(reinterpret_cast<char *>(data.data() + offset), file_size);
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
                     const std::string &name, uint8_t user = 0) {
    Entry e = {};
    MakeCpmName(e, name);
    unsigned size_128 = (file_size + 127) / 128;
    do {
        if (e.extent >= 32)
            throw std::runtime_error("No space in catalog (e.extent >= 32)");
        if (entry_number == A_ROM_DIRECTORY_COUNT)
            throw std::runtime_error("No space in catalog (entry_number == " + std::to_string(A_ROM_DIRECTORY_COUNT) +
                                     ")");
        e.user = user;
        if (A_RAM_BLOCKS + A_ROM_BLOCKS < 0x100) {
            e.size_128 = std::min(size_128, A_BLOCK_SIZE / 128 * unsigned(std::size(e.blocks8)));
            for (auto &i : e.blocks8) {
                if (size_128 > 0) {
                    i = block_number++;
                    size_128 = (size_128 >= A_BLOCK_SIZE / 128) ? (size_128 - A_BLOCK_SIZE / 128) : 0;
                } else {
                    i = 0;
                }
            }
        } else {
            e.size_128 = std::min(size_128, A_BLOCK_SIZE / 128 * unsigned(std::size(e.blocks16)));
            for (auto &i : e.blocks16) {
                if (size_128 > 0) {
                    i = block_number++;
                    size_128 = (size_128 >= A_BLOCK_SIZE / 128) ? (size_128 - A_BLOCK_SIZE / 128) : 0;
                } else {
                    i = 0;
                }
            }
        }
        entry[entry_number++] = e;
        e.extent++;

        //     std::cout << std::string(e.name, sizeof(e.name)) << " extent " << (unsigned)e.extent << " " <<
        //     (e.size_128 * 128)
        //                 << " bytes  " << std::endl;
    } while (size_128 > 0);
}

static void AddUnusedEntry(unsigned &block_counter, struct Entry *directory, unsigned &entry_counter, unsigned block_count) {
    AddEntry(block_counter, directory, entry_counter, block_count * A_BLOCK_SIZE, "UNUSEDDD.ROM", 15);
}

struct Info {
    uint16_t bios_offset_le16;
    uint16_t cpm_offset_le16;
    uint16_t storage_offset_le16;
};

int main() {
    try {
        std::vector<uint8_t> rom;

        // Запись загрузчика в ПЗУ
        LoadFile("loader.bin", rom);
        std::cout << "[LOADER]     " << rom.size() << std::hex << " bytes, offset 0 - 0x" << rom.size() << std::dec
                  << std::endl;

        // Запись BIOS в ПЗУ
        std::vector<uint8_t> bios;
        LoadFile("bios.bin", bios);
        std::vector<uint8_t> packed_bios;
        PackMegaLz(bios.data(), bios.size(), packed_bios);
        auto bios_offset = rom.size();
        rom.insert(rom.end(), packed_bios.begin(), packed_bios.end());
        std::cout << "[BIOS]       " << packed_bios.size() << " bytes, offset 0x" << std::hex << bios_offset << " - 0x"
                  << rom.size() << std::dec << ", unpacked " << bios.size() << " bytes" << std::endl;

        // Запись CP/M в ПЗУ
        std::vector<uint8_t> cpm;
        LoadFile("cpm22.bin", cpm);
        std::vector<uint8_t> packed_cpm;
        PackMegaLz(cpm.data(), cpm.size(), packed_cpm);
        auto cpm_offset = rom.size();
        rom.insert(rom.end(), packed_cpm.begin(), packed_cpm.end());
        std::cout << "[CP/M]       " << packed_cpm.size() << " bytes, offset 0x" << std::hex << cpm_offset << " - 0x"
                  << rom.size() << std::dec << ", unpacked " << cpm.size() << " bytes" << std::endl;

        // Выравнивание начала файловой системы
        while (rom.size() % A_BLOCK_SIZE != 0)
            rom.push_back(0xFF);
        const auto storage_offset = rom.size();
        const auto reserved_blocks = storage_offset / A_BLOCK_SIZE;

        // Запись каталога
        Entry directory[A_ROM_DIRECORY_BLOCKS * A_BLOCK_SIZE / sizeof(Entry)];
        auto directory_offset = rom.size();
        rom.resize(directory_offset + sizeof(directory));

        // Поиск файлов для добавленя и сортировка
        std::vector<std::string> files;
        for (auto &p : std::filesystem::directory_iterator("files"))
            if (p.is_regular_file())
                files.push_back(p.path().string());
        std::sort(files.begin(), files.end());

        // Добавление файлов
        unsigned block_counter = A_ROM_DIRECORY_BLOCKS + A_RAM_DIRECORY_BLOCKS;
        unsigned entry_counter = 0;
        for (auto &p : files) {
            const size_t offset = rom.size();
            size_t file_size = LoadFile(p, rom);

            AddEntry(block_counter, directory, entry_counter, file_size, std::filesystem::path(p).filename());

            std::cout << std::string(directory[entry_counter - 1].name, sizeof(directory[0].name)) << "  " << file_size
                      << " bytes, offset 0x" << std::hex << offset << " - 0x" << rom.size() << std::dec << std::endl;

            // Выравнивание на целый блок
            while (rom.size() % A_BLOCK_SIZE)
                rom.push_back(0xFF);
        }

        // Проверка
        size_t unused_blocks = A_ROM_BLOCKS + A_RAM_DIRECORY_BLOCKS - block_counter;
        auto used_rom_size = rom.size();
        const size_t hardware_rom_size = size_t(A_ROM_BLOCKS) * A_BLOCK_SIZE;
        if (used_rom_size > hardware_rom_size)
            throw std::runtime_error("ROM overflow " + std::to_string(rom.size()) + " > " +
                                     std::to_string(hardware_rom_size));

        std::cout << "Free space " << (hardware_rom_size - used_rom_size) << " of " << hardware_rom_size << " bytes, "
                  << (unused_blocks - reserved_blocks) << " of " << A_ROM_BLOCKS << " blocks, "
                  << (A_ROM_DIRECTORY_COUNT - entry_counter) << " of " << A_ROM_DIRECTORY_COUNT << " entries"
                  << std::endl;

        // Заполнение неиспользуемой части ПЗУ константой
        rom.resize(hardware_rom_size);
        std::fill(rom.begin() + used_rom_size, rom.end(), 0xFF);

        // Нужно забить ПЗУ до конца, что бы CP/M туда не записывала данные
        const size_t max_blocks_per_file = 8 * 32;  // TODO
        while (unused_blocks >= max_blocks_per_file) {
            AddUnusedEntry(block_counter, directory, entry_counter, max_blocks_per_file);
            unused_blocks -= max_blocks_per_file;
        }
        AddUnusedEntry(block_counter, directory, entry_counter, unused_blocks);
        while (entry_counter < A_ROM_DIRECTORY_COUNT)
            AddEntry(block_counter, directory, entry_counter, 0, "UNUSEDDD.ROM", 15);

        // Запись информации для загрузчика
        if (rom.size() < 0x10 + sizeof(Info))
            throw std::runtime_error("Incorrect loader.bin");
        Info *info = (Info *)(rom.data() + 10);
        info->bios_offset_le16 = htole16(bios_offset);
        info->cpm_offset_le16 = htole16(cpm_offset);
        info->storage_offset_le16 = htole16(storage_offset / 128);

        // Запись каталога
        memcpy(rom.data() + directory_offset, directory, sizeof(directory));
        // std::copy((uint8_t*)directory, (uint8_t*)directory + sizeof(directory), rom.begin() + directory_offset);

        // Переворот ROM
        std::vector<uint8_t> rom2;
        static const uint16_t PAGE_SIZE = 0x4000;
        for (size_t i = rom.size() / PAGE_SIZE; i > 0; i--)
            rom2.insert(rom2.end(), rom.data() + (i - 1) * PAGE_SIZE, rom.data() + i * PAGE_SIZE);

        SaveFile("iskra1080cpm.bin", rom2.data(), rom2.size());
    } catch (std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    return 0;
}
