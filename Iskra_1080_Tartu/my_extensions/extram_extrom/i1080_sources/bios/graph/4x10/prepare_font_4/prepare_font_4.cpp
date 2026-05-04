/*
 * Iskra 1080 Extension card firmware
 * Prepare a 4 pixel width font for Iskra 1080 expansion card
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

#include <fstream>
#include <iostream>
#include <vector>
#include <string>

static void LoadFile(const std::string &file_name, std::vector<char> &data) {
    std::ifstream f(file_name, std::ios::binary);
    if (!f)
        throw std::runtime_error("Can't open file " + file_name);
    f.seekg(0, f.end);
    const auto file_size = f.tellg();
    f.seekg(0, f.beg);
    data.resize(file_size);
    f.read(data.data(), file_size);
    if (!f)
        throw std::runtime_error("Can't read file " + file_name);
}

static void SaveFile(const std::string &file_name, const std::vector<char> &data) {
    std::ofstream f(file_name, std::ios::binary);
    f.write(reinterpret_cast<const char *>(data.data()), data.size());
    if (!f)
        throw std::runtime_error("Can't create file " + file_name);
}

int main(int argc, char **argv) {
    try {
        if (argc != 3) {
            std::cerr << "Prepare a 4 pixel width font for Iskra 1080 expansion card" << std::endl;
            std::cerr << "Usage: " << argv[0] << " input.bin output.bin" << std::endl;
            return 1;
        }
        std::vector<char> buf;
        LoadFile(argv[1], buf);
        for (auto &i : buf)
            i = (i << 4) | (i & 0x0F);
        SaveFile(argv[2], buf);
    } catch (std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    return 0;
}
