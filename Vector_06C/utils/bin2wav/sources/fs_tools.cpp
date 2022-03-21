// File tools
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2021-Jul-26 Alemorf, aleksey.f.morozov@gmail.com

#include "fs_tools.h"
#include <assert.h>
#include <sys/stat.h>
#include <string>
#include <iostream>

namespace FsTools {

class AutoCloseFile {
public:
    explicit AutoCloseFile(FILE *file);
    void Close();
    ~AutoCloseFile();

protected:
    FILE *file_ = nullptr;

    AutoCloseFile(const AutoCloseFile &) = delete;
    AutoCloseFile &operator=(const AutoCloseFile &) = delete;
};

AutoCloseFile::AutoCloseFile(FILE *file) {
    file_ = file;
}

void AutoCloseFile::Close() {
    if (file_ != nullptr) {
        if (fclose(file_) != 0) {
            std::cerr << "Failed to close file, errno " << errno << std::endl;
        }
        file_ = nullptr;
    }
}

AutoCloseFile::~AutoCloseFile() {
    Close();
}

void LoadFile(const char file_name[], std::function<void *(size_t)> allocate) {
    // Check parameters
    if (file_name == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter file_name = nullptr"));
    }
    if (!allocate) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter allocate = nullptr"));
    }

    FILE *const file = fopen(file_name, "rb");
    if (file == nullptr) {
        throw std::runtime_error(std::string("Failed to open file ") + std::string(file_name) +
                                 std::string(", errno ") + std::to_string(errno));
    }

    AutoCloseFile auto_close_file(file);

    struct stat buff = {};
    if (fstat(fileno(file), &buff) != 0) {
        throw std::runtime_error(std::string("Can't check file size ") + std::string(file_name) +
                                 std::string(", errno ") + std::to_string(errno));
    }

    if (buff.st_size > SIZE_MAX) {
        throw std::runtime_error(std::string("Too big file ") + std::string(file_name) +
                                 std::string(", current size ") + std::to_string(buff.st_size) +
                                 std::string(", max size ") + std::to_string(SIZE_MAX));
    }

    const size_t buffer_size = buff.st_size;
    void *const buffer = allocate(buffer_size);

    if ((buffer != nullptr) && (buffer_size > 0U)) {
        const auto result = fread(buffer, 1, buffer_size, file);
        if (result != buffer_size) {
            throw std::runtime_error(std::string("Failed to read file ") + std::string(file_name) +
                                     std::string(", errno ") + std::to_string(errno) + std::string(", result ") +
                                     std::to_string(result) + std::string(", bufferSize ") +
                                     std::to_string(buffer_size));
        }
    }
}

void LoadFile(const char file_name[], size_t max_file_size, std::vector<uint8_t> *out) {
    // Check parameters
    if (file_name == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter file_name = nullptr"));
    }
    if (out == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out = nullptr"));
    }

    FsTools::LoadFile(file_name, [file_name, out, max_file_size](size_t size) {
        if (size > max_file_size) {
            throw std::runtime_error(std::string("File ") + std::string(file_name) + std::string(" longer then ") +
                                     std::to_string(max_file_size) + std::string(" bytes"));
        }
        out->resize(size);
        return out->data();
    });
}

void SaveFile(const char file_name[], const std::vector<uint8_t> &out) {
    SaveFile(file_name, out.data(), out.size());
}

void SaveFile(const char file_name[], const void *data, size_t size) {
    // Check parameters
    if (file_name == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter file_name = nullptr"));
    }
    if (data == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter data = nullptr"));
    }

    FILE *const file = fopen(file_name, "wb");

    if (file == nullptr) {
        throw std::runtime_error(std::string("Failed to create file ") + std::string(file_name) +
                                 std::string(", errno ") + std::to_string(errno));
    }

    AutoCloseFile auto_close_file(file);

    if (size != 0U) {
        const auto result0 = fwrite(data, 1, size, file);
        if (result0 != size) {
            const int error_code = errno;

            auto_close_file.Close();

            if (remove(file_name) != 0) {
                std::cerr << "Failed to remove file " << file_name << ", errno " << errno << std::endl;
            }

            throw std::runtime_error(std::string("Failed to  write file ") + std::string(file_name) +
                                     std::string(", errno ") + std::to_string(error_code));
        }
    }
}

}  // namespace FsTools
