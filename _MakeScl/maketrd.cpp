// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "fstools.h"
#include "sclfile.h"
#include "trdfile.h"
#include <iostream>
#include <stdint.h>
#include <vector>
#include <limits>
#include <string.h>
#include <stdlib.h> // strtoul
#include <libgen.h>
#include <memory>

template<class A, class B>
void set(std::unique_ptr<A>& o, B* n)
{
    std::unique_ptr<A> tmp(n);
    o.swap(tmp);
}

const char* getFileExtension(const char* str)
{
    char* ext = strrchr((char*)str, '.');
    if (!ext) return "";
    if (strchr(ext, '/')) return "";
    return ext + 1;
}

class TrdosFileInfo
{
public:
    char name[9];
    char ext;
    uint16_t start;
};

bool parseTrdosFileInfo(TrdosFileInfo& out, const std::string& srcFullName, uint16_t defaultStart, size_t& ignoreFirstBytes)
{    
    ignoreFirstBytes = 0;
    const char* srcName = basename((char*)srcFullName.c_str());

    char name[strlen(srcName) + 1];
    strcpy(name, srcName);

    char* extPtr = strrchr(name, '.');
    if (!extPtr || extPtr[1] == '\0') return false;
    extPtr[0] = '\0';
    if ((extPtr[1] == '$' || extPtr[1] == 'c') && extPtr[2] == 'c' && extPtr[3] == '\0')
    {
        ignoreFirstBytes = 0x11;
        extPtr[1] = 'C';
    }
    out.ext = extPtr[1];

    out.start = defaultStart;

    if (strlen(name) > sizeof(out.name) - 1) return false;
    strncpy(out.name, name, sizeof(out.name));
    return true;
}

bool parseFileArg(std::string& fileName, uint16_t& addr, const char* arg)
{
    char* e = strchr((char*)arg, '@');
    if (!e)
    {
        fileName = arg;
        addr = 0;
        return true;
    }
    fileName.assign(arg, e - arg);
    char* end = nullptr;
    unsigned long v = strtoul(e + 1, &end, 10);
    if (end[0] != 0 || v > UINT16_MAX) return false;
    return (uint16_t)v;
}

bool makeSclFile(const char* destFileName, unsigned srcFileNamesCount, const char** srcFileNames)
{    
    std::unique_ptr<AbstractFileWriter> fileWriter;

    const char* outputFileExt = getFileExtension(destFileName);
    if (0 == strcasecmp(outputFileExt, "trd"))
    {
        set(fileWriter, new TrdFileWriter);
    }
    else if (0 == strcasecmp(outputFileExt, "scl"))
    {
        set(fileWriter, new SclFileWriter);
    }
    else
    {
        std::cout << "Unsupported file extension " << destFileName << std::endl;
        return false;
    }

    std::vector<uint8_t> file;

    std::cout << "Make file " << destFileName << std::endl;

    for (unsigned i = 0; i < srcFileNamesCount; i++)
    {
        std::string srcFileName;
        uint16_t addr;
        if (!parseFileArg(srcFileName, addr, srcFileNames[i]))
        {
            std::cout << "Incorrect argument " << srcFileNames[i] << std::endl;
            return false;
        }

        // Загружаем файл
        if (!loadFile(file, srcFileName, SclFileStruct::maxFileSize)) return false;

        // Разбор имени
        TrdosFileInfo info;
        size_t ignoreFirstBytes = 0;
        if (!parseTrdosFileInfo(info, srcFileName, (uint16_t)file.size(), ignoreFirstBytes))
        {
            std::cerr << "Incorrenct file name " << srcFileName << std::endl;
            return false;
        }

        // Удаляем заголовок
        if (ignoreFirstBytes > file.size()) ignoreFirstBytes = file.size();
        file.erase(file.begin(), file.begin() + ignoreFirstBytes);

        // Запись файла
        if (!fileWriter->pushBack(info.name, info.ext, info.start, file.data(), file.size()))
        {
            std::cerr << "Can't put file " << srcFileName << std::endl;
            return false;
        }

        // Вывод информации
        std::cout << "+ " << info.name << "." << info.ext << " start " << info.start << " size " << file.size() << " bytes" << std::endl;
    }

    // Сохранение SCL-файла
    fileWriter->serialize(file);
    if (!saveFile(destFileName, file.data(), file.size())) return false;

    // Вывод информации
    std::cout << "Total size " << file.size() << " bytes" << std::endl;
    return true;
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        std::cerr << "Make TRD/SCL file (c) 30-10-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file input_files" << std::endl
                  << "Correct output file name: *.trd or *.scl" << std::endl
                  << "Correct input file name: (0-7 chars).B" << std::endl
                  << "Correct input file name: (0-7 chars).(load address in hex).(1 char)" << std::endl;
        return 1;
    }

    if (!makeSclFile(argv[1], (unsigned)argc - 2, (const char**)argv + 2))
        return 2;

    return 0;
}
