// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "fstools.h"
#include <stdio.h> // FILE
#include <sys/stat.h> // fstat
#include <unistd.h> // unlink
#include <iostream>

bool loadFile(std::vector<uint8_t>& output, const std::string& fileName, unsigned maxFileSize)
{
    FILE* o = fopen(fileName.c_str(), "r");
    if (!o)
    {
        std::cerr << "Can't open file " << fileName << std::endl;
        return false;
    }

    struct stat buff;
    if (fstat(fileno (o), &buff))
    {
        std::cerr << "Can't check file size " << fileName << std::endl;;
        return false;
    }

    if (buff.st_size > maxFileSize)
    {
        std::cerr << "Too big file " << fileName << ", current size " << buff.st_size << ", max size " << maxFileSize << std::endl;
        fclose(o);
        return false;
    }

    output.resize(buff.st_size);

    if (buff.st_size)
    {
        if (fread(output.data(), 1, output.size(), o) != output.size())
        {
            fclose(o);
            std::cerr << "Can't read file " << fileName << std::endl;
            return false;
        }
    }

    fclose(o);
    return true;
}

bool saveFile(const char* fileName, const void* data, size_t size)
{
    FILE* o = fopen(fileName, "w");
    if (!o)
    {
        std::cerr << "Can't create file " << fileName << std::endl;
        return false;
    }
    if (size)
    {
        if (fwrite(data, 1, size, o) != size)
        {
            fclose(o);
            unlink(fileName);
            std::cerr << "Can't write file " << fileName << std::endl;
            return false;
        }
    }
    fclose(o);
    return true;
}
