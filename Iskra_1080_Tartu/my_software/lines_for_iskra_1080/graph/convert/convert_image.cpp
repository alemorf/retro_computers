/* 
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
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

#include "png.h"
#include "fs_tools.h"
#include <algorithm>
#include <vector>
#include <map>
#include <string.h>
#include <string>
#include <iostream>
#include <assert.h>
#include "megalz/mhmt-globals.h"
#include "megalz/mhmt-pack.h"

static void PackMegalz(const void* src, size_t src_size, std::vector<uint8_t>& output) {
    init_globals();
    wrk.prelen = 0;
    wrk.inlen = src_size;
    wrk.indata = (const UBYTE*)src;
    wrk.indata_raw = (const UBYTE*)src;
    if (!pack()) {
        throw std::runtime_error("Can't pack");
    }
    output.assign(wrk.output, wrk.output + wrk.output_pos);
}

static std::string truncFileExt(const char* str) {
    char* ext = strrchr((char*)str, '.');
    if (!ext) return str;
    if (strchr(ext, '/')) return str;
    return std::string(str, ext - str);
}

static std::string IdFromFileName(const char fullName[]) {
    assert(fullName != nullptr);
    const char* name = strrchr(fullName, '/');
    if (name == nullptr)
        name = fullName;
    else
        name++;
    const char* end = strchr(name, '.');
    return end == nullptr ? name : std::string(name, end - name);
}

static std::string RemoveExtension(const char fullName[]) {
    assert(fullName != nullptr);
    const char* ext = strrchr(fullName, '.');
    if (ext == nullptr) return fullName;
    const char* folder = strrchr(fullName, '/');
    if (folder != nullptr && folder > ext) return fullName;
    return std::string(fullName, ext - fullName);
}

static std::string MakeCSourceArray(const std::vector<uint8_t>& comressed) {
    std::string result;
    uint8_t l = 0;
    for (uint8_t b : comressed) {
        if (l == 16) {
            l = 0;
            result += "\n";
        }
        if (l == 0) result += "   ";
        char buf[16];
        (void)snprintf(buf, sizeof(buf), " 0x%02X,", b);
        result += buf;
        l++;
    }
    result += "\n";
    return result;
}

static uint32_t FindColor(const uint32_t palette[4], uint32_t color) {
    assert(palette != nullptr);
    uint32_t bestIndex = 0;
    uint32_t bestDist = UINT32_MAX;
    for (uint8_t i = 0; i < 4; i++) {
        int32_t dr = int32_t(palette[i] & 0xFF) - int32_t(color & 0xFF);
        int32_t dg = int32_t((palette[i] >> 8) & 0xFF) - int32_t((color >> 8) & 0xFF);
        int32_t db = int32_t((palette[i] >> 16) & 0xFF) - int32_t((color >> 16) & 0xFF);
        int32_t dist = dr * dr + dg * dg + db * db;
        if (dist < bestDist) {
            bestDist = dist;
            bestIndex = i;
        }
    }
    return bestIndex;
}

bool convert(const char* inputFileName, const uint32_t palette[4]) {
    Png png;
    if (!png.load(inputFileName)) return false;

    std::vector<uint8_t> dataA, dataB;

    for (uint32_t x = png.getWidth(); x >= 8; x -= 8) {
        for (uint32_t y = png.getHeight(); y != 0; y--) {
            uint8_t a = 0, b = 0;
            for (uint32_t p = 0; p < 8; p++) {
                uint32_t color = png.getPixel(x - 8 + p, y - 1);
                int colorIndex = FindColor(palette, color);
                if ((colorIndex & 1) != 0) {
                    a |= (0x80 >> p);
                }
                if ((colorIndex & 2) != 0) {
                    b |= (0x80 >> p);
                }
            }
            dataA.push_back(a);
            dataB.push_back(b);
        }
    }

    std::vector<uint8_t> comressedA;
    PackMegalz(dataA.data(), dataA.size(), comressedA);
    std::vector<uint8_t> comressedB;
    PackMegalz(dataB.data(), dataB.size(), comressedB);
    comressedA.insert(comressedA.begin(), comressedB.begin(), comressedB.end());

    std::string id = IdFromFileName(inputFileName);

    std::string hFile =
        "#include <stdint.h>\n"
        "\n"
        "extern uint8_t " +
        id + "[" + std::to_string(comressedA.size()) + "];\n";

    std::string cFile = "#include \"" + RemoveExtension(basename(inputFileName)) +
                        ".h\"\n"
                        "\n"
                        "uint8_t " +
                        id + "[" + std::to_string(comressedA.size()) + "] = {\n" + MakeCSourceArray(comressedA) +
                        "};\n";

    const std::string nameWoExtension = RemoveExtension(inputFileName);

    FsTools::SaveFile(nameWoExtension + ".c", cFile.data(), cFile.size());
    FsTools::SaveFile(nameWoExtension + ".h", hFile.data(), hFile.size());
    return true;
}

bool convert1(const char* inputFileName, const uint32_t palette[4]) {
    Png png;
    if (!png.load(inputFileName)) return false;

    std::vector<uint8_t> data;
    for (uint32_t y = 0; y + 16 <= png.getHeight(); y += 16) {
        for (uint32_t x = 0; x + 16 <= png.getWidth(); x += 16) {
            for (uint32_t e = 0; e < 2; e++) {
                for (uint32_t ix = 0; ix < 16; ix += 8) {
                    for (uint32_t iy = 0; iy < 16; iy++) {
                        uint8_t a = 0;
                        for (uint32_t p = 0; p < 8; p++) {
                            uint32_t color = png.getPixel(x + ix + p, y + iy);
                            int colorIndex = FindColor(palette, color);
                            if ((colorIndex & (2 >> e)) != 0) {
                                a |= (0x80 >> p);
                            }
                        }
                        data.push_back(a);
                    }
                }
            }
        }
    }

    std::string id = IdFromFileName(inputFileName);

    std::string hFile =
        "#include <stdint.h>\n"
        "\n"
        "extern uint8_t " +
        id + "[" + std::to_string(data.size()) + "];\n";

    std::string cFile = "#include \"" + RemoveExtension(basename(inputFileName)) +
                        ".h\"\n"
                        "\n"
                        "uint8_t " +
                        id + "[" + std::to_string(data.size()) + "] = {\n" + MakeCSourceArray(data) + "};\n";

    const std::string nameWoExtension = RemoveExtension(inputFileName);
    FsTools::SaveFile(nameWoExtension + ".c", cFile.data(), cFile.size());
    FsTools::SaveFile(nameWoExtension + ".h", hFile.data(), hFile.size());
    return true;
}

bool convert2(const char* inputFileName, const uint32_t palette[4]) {
    Png png;
    if (!png.load(inputFileName)) return false;

    std::vector<uint8_t> data;
    for (uint32_t e = 0; e < 2; e++) {
        for (uint32_t x = 0; x + 8 <= png.getWidth(); x += 8) {
            for (uint32_t y = 0; y < png.getHeight(); y++) {
                uint8_t a = 0, b = 0;
                for (uint32_t p = 0; p < 8; p++) {
                    uint32_t color = png.getPixel(x + p, y);
                    int colorIndex = FindColor(palette, color);
                    if ((colorIndex & (2 >> e)) != 0) {
                        a |= (0x80 >> p);
                    }
                }
                data.push_back(a);
            }
        }
    }

    std::string id = IdFromFileName(inputFileName);

    std::string hFile =
        "#include <stdint.h>\n"
        "\n"
        "extern uint8_t " +
        id + "[" + std::to_string(data.size()) + "];\n";

    std::string cFile = "#include \"" + RemoveExtension(basename(inputFileName)) +
                        ".h\"\n"
                        "\n"
                        "uint8_t " +
                        id + "[" + std::to_string(data.size()) + "] = {\n" + MakeCSourceArray(data) + "};\n";

    const std::string nameWoExtension = RemoveExtension(inputFileName);
    FsTools::SaveFile(nameWoExtension + ".c", cFile.data(), cFile.size());
    FsTools::SaveFile(nameWoExtension + ".h", hFile.data(), hFile.size());
    return true;
}

bool convert3(const char* inputFileName, const uint32_t palette[4]) {
    Png png;
    if (!png.load(inputFileName)) return false;

    std::vector<uint8_t> data;
    for (uint32_t y = 0; y + 16 <= png.getHeight(); y += 16) {
        for (uint32_t x = 0; x + 16 <= png.getWidth(); x += 16) {
            for (uint32_t e = 0; e < 2; e++) {
                for (uint32_t ix = 0; ix < 16; ix += 8) {
                    for (uint32_t iy = 0; iy < 16; iy++) {
                        uint8_t orMask = 0, andMask = 0;
                        for (uint32_t p = 0; p < 8; p++) {
                            uint32_t color = png.getPixel(x + ix + p, y + iy);
                            if (color == 0xFF00FF) {
                                andMask |= (0x80 >> p);
                            } else {
                                int colorIndex = FindColor(palette, color);
                                if ((colorIndex & (2 >> e)) != 0) {
                                    orMask |= (0x80 >> p);
                                }
                            }
                        }
                        data.push_back(andMask);
                        data.push_back(orMask);
                    }
                }
            }
        }
    }

    std::string id = IdFromFileName(inputFileName);

    std::string hFile =
        "#include <stdint.h>\n"
        "\n"
        "extern uint8_t " +
        id + "[" + std::to_string(data.size()) + "];\n";

    std::string cFile = "#include \"" + RemoveExtension(basename(inputFileName)) +
                        ".h\"\n"
                        "\n"
                        "uint8_t " +
                        id + "[" + std::to_string(data.size()) + "] = {\n" + MakeCSourceArray(data) + "};\n";

    const std::string nameWoExtension = RemoveExtension(inputFileName);
    FsTools::SaveFile(nameWoExtension + ".c", cFile.data(), cFile.size());
    FsTools::SaveFile(nameWoExtension + ".h", hFile.data(), hFile.size());
    return true;
}

static uint32_t StrToUint32(const char text[], int base = 0) {
    char* end = nullptr;
    const unsigned long value = strtoul(text, &end, base);
    if (end[0] != '\0' || value >= UINT32_MAX)
        throw std::runtime_error(std::string("Can't convert \"") + text + "\" to number");
    return value;
}

int main(int argc, char** argv) {
    try {
        if (argc != 7) {
            std::cerr << "Iskra 1080 graph convertor (c) 2022 Alemorf" << std::endl
                      << "Syntax: " << argv[0] << " algorithm_number input_file.png color0 color1 color2 color3"
                      << std::endl;
            return 1;
        }
        uint32_t algorithm = StrToUint32(argv[1]);
        std::cout << "Convert " << argv[2] << std::endl;
        uint32_t palette[4] = {StrToUint32(argv[3]), StrToUint32(argv[4]), StrToUint32(argv[5]), StrToUint32(argv[6])};
        switch (algorithm) {
            case 0:
                return convert(argv[2], palette) ? 0 : 1;
            case 1:
                return convert1(argv[2], palette) ? 0 : 1;
            case 2:
                return convert2(argv[2], palette) ? 0 : 1;
            case 3:
                return convert3(argv[2], palette) ? 0 : 1;
            default:
                throw std::runtime_error("Unsupported algorithm");
        }
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
}
