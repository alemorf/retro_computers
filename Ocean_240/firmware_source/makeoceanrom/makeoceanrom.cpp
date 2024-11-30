// ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
// Поместить файлы в ПЗУ компьютера Океан 240

#include <string>
#include <assert.h>
#include <vector>
#include <filesystem>
#include <iostream>
#include "fs_tools.h"
#include <string.h>

static const unsigned MAX_CPM_DIRECTORY_ITEMS_COUNT = 32;
static const unsigned BLOCK_SIZE = 1024;
static const unsigned EXTENT_SIZE_128 = BLOCK_SIZE * 16 / 128;
static const unsigned FIRST_BLOCK = 0x40;
static const unsigned DIR_BLOCK = 0x40 + 0x28;
static const unsigned END_BLOCK = 0x40 + 0x30;

struct cpm_extent {
    uint8_t user;
    char name[8 + 3];
    uint8_t extent;       // Первые 5 бит содержат номер экстента, т.е. 0 до 31
    uint8_t reserved;     // У нас всегда 0
    uint8_t extent_high;  // У нас всегда 0
    uint8_t size_128;
    uint8_t blocks[16];
};

template <class T>
T div_up(T x, T y) {
    return (x - 1) / y + 1;
}

static std::string to_upper(std::string str) {
    std::transform(str.begin(), str.end(), str.begin(), ::toupper);
    return str;
}

void AddEntry(unsigned &block_number, struct cpm_extent *dir, unsigned max_entry_number, unsigned &entry_number,
              unsigned file_size, const std::string &name) {
    static const int BLOCK_SIZE_128 = BLOCK_SIZE / 128;
    int size_128 = int(div_up(file_size, 128U));
    uint8_t extent = 0;
    do {
        if (entry_number == max_entry_number)
            throw std::runtime_error("В каталоге нет места");
        assert(extent < 32);
        struct cpm_extent &e = dir[entry_number];
        memset(&e, 0, sizeof(e));
        assert(name.size() == sizeof(e.name));
        memcpy(e.name, name.c_str(), name.size());
        static_assert(EXTENT_SIZE_128 < UINT8_MAX);
        e.size_128 = uint8_t(std::min(size_128, int(EXTENT_SIZE_128)));
        e.extent = extent;

        for (unsigned i = 0; i < std::size(e.blocks) && size_128 > 0; i++) {
            e.blocks[i] = block_number < DIR_BLOCK ? block_number
                                                   : (block_number == END_BLOCK - 1 ? DIR_BLOCK : block_number + 1);
            block_number++;
            size_128 -= BLOCK_SIZE_128;
        }
        extent++;
        entry_number++;
    } while (size_128 > 0);
}

int main() {
    static const size_t second_boot_offset = 0x2000;
    static const size_t boot_offset = 0xE000;
    static const size_t boot_size = 0x80;
    static const unsigned files_offset = 0x4000;

    try {
        const char *path = "files";

        uint8_t rom[0x10000];

        memset(rom, 0xE5, sizeof(rom));

        // По адресам 0000..3FFF раположен код.
        FsTools::LoadFile("bios.bin", files_offset, rom);

        // По адресам 4000..АFFF раположена файловая система CP/M
        // с размером блока 1 кБ. Компьютер после перезагрузки
        // начинает выполнение кода c адреса 0xE000. Там находится
        // 128 байт кода, а затем 768 байт каталога. После перезагрузки
        // эти 768 байт копируются в нулевой блок файловой системы,
        // котрый расположен в ОЗУ.
        struct cpm_extent directory[768 / sizeof(struct cpm_extent)];

        memset(directory, 0xE5, sizeof(directory));

        unsigned block_count = FIRST_BLOCK;
        unsigned dir_count = 0;
        for (auto &p : std::filesystem::directory_iterator(path)) {
            const unsigned offset = files_offset + (block_count - FIRST_BLOCK) * BLOCK_SIZE;
            unsigned file_size =
                FsTools::LoadFile(p.path().string(), sizeof(rom) - BLOCK_SIZE - offset, rom + offset);

            std::string name = (to_upper(p.path().stem().string()) + "        ").substr(0, 8);
            std::string ext = to_upper(p.path().extension().string()) + "   ";
            ext = ext.substr(ext[0] == '.' ? 1 : 0, 3);

            const auto prev_block_number = block_count;
            AddEntry(block_count, directory, std::size(directory), dir_count, file_size, name + ext);
            std::cout << name << "." << ext << "  " << file_size << " bytes  " << (block_count - prev_block_number)
                      << " blocks  " << prev_block_number << " pos" << std::endl;
        }
        std::cout << "FREE SPACE " << ((END_BLOCK - block_count - 1) * BLOCK_SIZE) << " bytes" << std::endl;

        assert(block_count < END_BLOCK);
        if (block_count < END_BLOCK)
            AddEntry(block_count, directory, std::size(directory), dir_count, (END_BLOCK - block_count) * 1024,
                     "UNUSED  ROM");

        // Вставляем загрузчик и каталог
        memmove(rom + boot_offset + BLOCK_SIZE, rom + boot_offset, sizeof(rom) - boot_offset - BLOCK_SIZE);
        memcpy(rom + boot_offset, rom + second_boot_offset, boot_size);
        memcpy(rom + boot_offset + boot_size, directory, sizeof(directory));

        FsTools::SaveFile("disk.bin", rom, sizeof(rom));

        uint8_t rom1[0x10000];
        memcpy(rom1 + 0x0000, rom + 0x0000, 0x2000);
        memcpy(rom1 + 0x2000, rom + 0x4000, 0x2000);
        memcpy(rom1 + 0x4000, rom + 0x8000, 0x2000);
        memcpy(rom1 + 0x6000, rom + 0xC000, 0x2000);
        memcpy(rom1 + 0x8000, rom1, 0x8000);
        FsTools::SaveFile("rom1.bin", rom1, sizeof(rom1));

        memcpy(rom1 + 0x0000, rom + 0x2000, 0x2000);
        memcpy(rom1 + 0x2000, rom + 0x6000, 0x2000);
        memcpy(rom1 + 0x4000, rom + 0xA000, 0x2000);
        memcpy(rom1 + 0x6000, rom + 0xE000, 0x2000);
        memcpy(rom1 + 0x8000, rom1, 0x8000);
        FsTools::SaveFile("rom2.bin", rom1, sizeof(rom1));

    } catch (std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }

    return 0;
}
