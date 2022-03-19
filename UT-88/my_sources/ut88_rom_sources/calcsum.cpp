#include <iostream>
#include <fstream>
#include <sstream>
#include <ios>
#include <stdint.h>
#include <dirent.h>
#include <vector>
#include <algorithm>

bool loadFile(std::string& out, const std::string& fileName)
{
    std::fstream file(fileName, std::ios::in);
    if (!file.is_open()) return false;
    std::ostringstream oss;
    oss << file.rdbuf();
    out = oss.str();
    return true;
}

bool saveFile(const std::string& out, const std::string& fileName)
{
    std::fstream file(fileName, std::ios::out);
    if (!file.is_open()) return false;
    file << out;
    return true;
}

bool findFiles(std::vector<std::string>& output, const std::string& folderName)
{
    DIR* files = opendir(folderName.c_str());
    if (!files) return false;
    for(struct dirent* e; (e = readdir(files)) != nullptr;)
        if (e->d_name[0] != '.')
            output.push_back(e->d_name);
    closedir(files);
    return true;
}

bool packMegaLZ(std::string& out, const std::string& in)
{
    const std::string tmpInFileName = "/tmp/ut88.in";
    const std::string tmpOutFileName = "/tmp/ut88.out";
    saveFile(in, tmpInFileName);
    remove(tmpOutFileName.c_str());
    if (system(("wine bin/megalz.exe " + tmpInFileName + " " + tmpOutFileName).c_str()) != 0)
    {
        remove(tmpOutFileName.c_str());
        remove(tmpInFileName.c_str());
        return false;
    }
    if (!loadFile(out, tmpOutFileName))
    {
        remove(tmpOutFileName.c_str());
        remove(tmpInFileName.c_str());
        return false;
    }
    remove(tmpOutFileName.c_str());
    remove(tmpInFileName.c_str());
    return true;
}

int main(int argc, const char** argv)
{
    if (argc != 2)
    {
        std::cerr << "Incorrect arguments";
        return 1;
    }
    const char* fileName = argv[1];

    std::string file;
    if (!loadFile(file, fileName))
    {
        std::cerr << "Can't load file " << fileName << std::endl;
        return 1;
    }

    const size_t namesOffset = 0xA06;

    size_t fileSize = file.size();
    if (fileSize <= namesOffset)
    {
        std::cerr << "Too short file " << fileName << std::endl;
        return 1;
    }

    unsigned filesEnd = namesOffset;
    for (; filesEnd < file.size(); filesEnd++)
        if (file[filesEnd] != 0)
            break;

    std::cerr << "Space for additional files " << namesOffset << " .. " << filesEnd << std::endl;

    std::vector<std::string> files;
    std::string folderName = "files/";
    if (!findFiles(files, folderName))
    {
        std::cerr << "Can't find files in folder '" << folderName << "'" << std::endl;
        return 1;
    }

    std::sort(files.begin(), files.end());

    std::string names;
    names += "monitor\n";
    for(auto& f : files)
    {
        std::string displayName = f;
        displayName.resize(displayName.find('.'));
        transform(displayName.begin(), displayName.end(), displayName.begin(), toupper);

        names += (displayName);
        names.push_back(10);
    }

    if (names.size() > 0) names.pop_back();
    names.push_back(0);

    std::string info;
    std::string binary;

    const size_t descrOffset = namesOffset + names.size();
    const size_t binaryOffset = descrOffset + files.size() * 4;

    for(auto& f : files)
    {
        std::string fn = (std::string)folderName + f;

        std::string file;
        if (!loadFile(file, fn))
        {
            std::cerr << "Can't load file " << fn << std::endl;
            return 1;
        }

        size_t fileSize = file.size();
        if (fileSize <= sizeof(uint16_t) * 3)
        {
            std::cerr << "Too short file " << fn << std::endl;
            return 1;
        }

        uint8_t* data = (uint8_t*)file.data();
        uint16_t start = (data[0] << 8) + data[1];
        uint16_t end = (data[2] << 8) + data[3];
        unsigned dataSize = end - start + 1;
        if (start > end || dataSize + 4 > file.size() || dataSize >= 0xFFFF)
        {
            std::cerr << "Incorrenct file " << fn << " " << start << " " << end << std::endl;
            return 1;
        }

        size_t romStart = binaryOffset + binary.size();

        info.push_back((char)(romStart >> 8));
        info.push_back((char)romStart);
        info.push_back((char)(start >> 8));
        info.push_back((char)start);

        std::string packedFile;
        if (!packMegaLZ(packedFile, std::string(file.data() + 4, file.data() + 4 + dataSize)))
        {
            std::cerr << "Can't pack file " << fn << std::endl;
            return 1;
        }

        binary += packedFile;

        std::cout << "Добавляю файл " << fn << ", адрес в ПЗУ 0x" << std::hex << romStart << std::dec
                                            << ", размер в ПЗУ " << packedFile.size() << " байт"
                                            << ", адрес в ОЗУ 0x" << std::hex << start << std::dec
                                            << ", размер в ОЗУ " << dataSize << " байт" << std::endl;

        if (binaryOffset + binary.size() > filesEnd)
        {
            std::cout << "Too many files " << binaryOffset + binary.size() << " > " << filesEnd << std::endl;
            return 1;
        }

    }

    std::cout << "В ПЗУ осталось свободно " << filesEnd - (binaryOffset + binary.size()) << " байт" << std::endl;

    for (unsigned i = 0; i < names.size(); i++)
        file[namesOffset + i] = names[i];
    for (unsigned i = 0; i < info.size(); i++)
        file[descrOffset + i] = info[i];
    for (unsigned i = 0; i < binary.size(); i++)
        file[binaryOffset + i] = binary[i];

    unsigned sum = 0;
    uint16_t* i = (uint16_t*)file.data();
    uint16_t* e = i + (fileSize / sizeof(uint16_t));
    for(; i != e; i++)
        sum += *i;

    uint16_t negSum = (uint16_t)(0 - sum);
    ((uint16_t*)file.data())[2] = negSum;

    if (!saveFile(file, fileName))
    {
        std::cerr << "Can't save file " << fileName << std::endl;
        return 1;
    }

    std::cout << "Check sum " << argv[1] << " = 0x" << std::hex << negSum << std::dec << std::endl;

    return 0;
}
