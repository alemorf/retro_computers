// File tools, MISRA
// Copyright 17-Mar-2022 Alemorf, aleksey.f.morozov@yandex.ru

#include "fs_tools.h"

#include <assert.h>
#include <errno.h>
#include <sys/stat.h>
#include <unistd.h>

#include <iostream>
#include <string>

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
        auto result = fclose(file_);
        assert(result == 0);
        file_ = nullptr;
    }
}

AutoCloseFile::~AutoCloseFile() {
    Close();
}

void LoadFile(const std::string &file_name, std::function<void *(size_t)> allocate) {
    // Check parameters
    if (!allocate) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter allocate = nullptr"));
    }

    FILE *file = fopen(file_name.c_str(), "rb");
    if (file == nullptr) {
        throw std::runtime_error(std::string("Can't open file ") + std::string(file_name) + std::string(", errno ") +
                                 std::to_string(errno));
    }

    AutoCloseFile autoCloseFile(file);

    struct stat buff;
    auto result0 = fstat(fileno(file), &buff);
    if (result0 != 0) {
        throw std::runtime_error(std::string("Can't check file size ") + std::string(file_name) +
                                 std::string(", errno ") + std::to_string(errno));
    }

    if (buff.st_size > SIZE_MAX) {
        throw std::runtime_error(std::string("Too big file ") + std::string(file_name) +
                                 std::string(", current size ") + std::to_string(buff.st_size) +
                                 std::string(", max size ") + std::to_string(SIZE_MAX));
    }

    const size_t buffer_size = buff.st_size;
    void *buffer = allocate(buffer_size);

    if ((buffer != nullptr) && (buffer_size > 0U)) {
        auto result2 = fread(buffer, 1, buffer_size, file);
        if (result2 != buffer_size) {
            throw std::runtime_error(std::string("Can't read file ") + std::string(file_name) +
                                     std::string(", errno ") + std::to_string(errno) + std::string(", result ") +
                                     std::to_string(result2) + std::string(", bufferSize ") +
                                     std::to_string(buffer_size));
        }
    }
}

void LoadFile(const std::string &file_name, size_t max_file_size, std::vector<uint8_t> *out) {
    // Check parameters
    if (out == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out = nullptr"));
    }

    FsTools::LoadFile(file_name, [out, max_file_size](size_t size) {
        if (size > max_file_size) {
            throw std::runtime_error(std::string("File ") + std::string(" longer then ") +
                                     std::to_string(max_file_size) + std::string(" bytes"));
        }
        out->resize(size);
        return out->data();
    });
}

void SaveFile(const std::string &file_name, const void *data, size_t size) {
    // Check parameters
    if (data == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter data = nullptr"));
    }

    FILE *file = fopen(file_name.c_str(), "wb");

    if (file == nullptr) {
        throw std::runtime_error(std::string("Can't create file ") + std::string(file_name) + std::string(", errno ") +
                                 std::to_string(errno));
    }

    AutoCloseFile auto_close_file(file);

    if (size != 0U) {
        auto result0 = fwrite(data, 1, size, file);
        if (result0 != size) {
            auto_close_file.Close();

            auto result2 = unlink(file_name.c_str());
            assert(result2 == 0);

            throw std::runtime_error(std::string("Can't write file ") + std::string(file_name) +
                                     std::string(", errno ") + std::to_string(errno));
        }
    }
}

FindFiles::FindFiles(const char path[]) {
    // Check parameters
    if (path == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter path = nullptr"));
    }
    // Open dir
    dir_ = opendir(path);
    if (dir_ == nullptr) {
        throw std::runtime_error(std::string("Can't open dir ") + std::string(path) + std::string(", errno ") +
                                 std::to_string(errno));
    }
}

bool FindFiles::Next() {
    for (;;) {
        item_ = readdir64(dir_);
        if ((item_ != nullptr) && (item_->d_name[0] == '.')) {
            if (item_->d_name[1] == '\0') {
                continue;
            }
            if ((item_->d_name[1] == '.') && (item_->d_name[2] == '\0')) {
                continue;
            }
        }
        break;
    }
    return item_ != nullptr;
}

dirent64 *FindFiles::Item() {
    return item_;
}

FindFiles::~FindFiles() {
    if (closedir(dir_) != 0) {
        std::cerr << "Failed to closedir(), errno " << errno << std::endl;
    }
}

}  // namespace FsTools
