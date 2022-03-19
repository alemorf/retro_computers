// File tools, MISRA
// 2021-01-06 Alemorf, aleksey.f.morozov@gmail.com

#include "fstools.h"
#include <sys/stat.h>
#include <unistd.h>
#include <assert.h>

class AutoCloseFile
{
protected:
    FILE* file = nullptr;

    AutoCloseFile(const AutoCloseFile&) = delete;
    AutoCloseFile& operator =(const AutoCloseFile&) = delete;

public:
    explicit AutoCloseFile(FILE* file);
    void close();
    ~AutoCloseFile();
};

AutoCloseFile::AutoCloseFile(FILE* file) : file(file)
{
}

void AutoCloseFile::close()
{
    if (file != nullptr)
    {
        auto result = fclose(file);
        assert(result == 0);
        file = nullptr;
    }
}

AutoCloseFile::~AutoCloseFile()
{
    close();
}

void loadFile(const char* fileName, std::function<void*(size_t)> allocate)
{
    assert(fileName != nullptr);
    assert(allocate);

    FILE* file = fopen(fileName, "r");
    if (file == nullptr)
    {
        throw std::runtime_error(std::string("Can't open file ") + fileName + ", errno " + std::to_string(errno));
    }

    AutoCloseFile autoCloseFile(file);

    struct stat buff;
    auto result0 = fstat(fileno(file), &buff);
    if (result0 != 0)
    {
        throw std::runtime_error(std::string("Can't check file size ") + fileName + ", errno " + std::to_string(errno));
    }

    if (buff.st_size > SIZE_MAX)
    {
        throw std::runtime_error(std::string("Too big file ") + fileName + ", current size "
                                 + std::to_string(buff.st_size) + ", max size " + std::to_string(SIZE_MAX));
    }

    const size_t bufferSize = buff.st_size;
    void* buffer = allocate(bufferSize);

    if ((buffer != nullptr) && (bufferSize > 0U))
    {
        auto result2 = fread(buffer, 1, bufferSize, file);
        if (result2 != bufferSize)
        {
            throw std::runtime_error(std::string("Can't read file ") + fileName + ", errno " + std::to_string(errno));
        }
    }
}

void saveFile(const char* fileName, const void* data, size_t size)
{
    assert(fileName != nullptr);
    assert(data != nullptr);

    FILE* file = fopen(fileName, "w");

    if (file == nullptr)
    {
        throw std::runtime_error(std::string("Can't create file ") + fileName + ", errno " + std::to_string(errno));
    }

    AutoCloseFile autoCloseFile(file);

    if (size != 0U)
    {
        auto result0 = fwrite(data, 1, size, file);
        if (result0 != size)
        {
            autoCloseFile.close();

            auto result2 = unlink(fileName);
            assert(result2 == 0);

            throw std::runtime_error(std::string("Can't write file ") + fileName + ", errno " + std::to_string(errno));
        }
    }
}
