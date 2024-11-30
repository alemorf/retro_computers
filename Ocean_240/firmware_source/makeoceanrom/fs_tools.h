// File tools, MISRA
// Copyright 17-Mar-2022 Alemorf, aleksey.f.morozov@yandex.ru

#ifndef FS_TOOLS_H_
#define FS_TOOLS_H_

#include <dirent.h>

#include <functional>
#include <string>
#include <vector>
#include <stdexcept>

namespace FsTools {

void LoadFile(const std::string &file_name, std::function<void *(size_t)> allocate);
void LoadFile(const std::string &file_name, size_t max_file_size, std::vector<uint8_t> *out);

inline void LoadFile(const std::string &file_name, size_t max_file_size, std::string *out) {
    if (out == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out = nullptr"));
    }

    FsTools::LoadFile(file_name, [file_name, out, max_file_size](size_t size) {
        if (size > max_file_size) {
            throw std::runtime_error(std::string("File ") + file_name + " longer then " +
                                     std::to_string(max_file_size) + " bytes");
        }
        out->resize(size);
        return out->data();
    });
}

inline size_t LoadFile(const std::string &file_name, size_t max_file_size, void *out) {
    if (out == nullptr) {
        throw std::runtime_error(std::string(__func__) + std::string(": Incorrect parameter out = nullptr"));
    }

    size_t result = 0;
    FsTools::LoadFile(file_name, [&result, file_name, out, max_file_size](size_t size) {
        if (size > max_file_size) {
            throw std::runtime_error(std::string("File ") + file_name + " longer then " +
                                     std::to_string(max_file_size) + " bytes");
        }
        result = size;
        return out;
    });
    return result;
}

void SaveFile(const std::string &file_name, const void *data, size_t size);
void SaveFile(const std::string &file_name, const std::string &out);

inline void SaveFile(const std::string &file_name, const std::vector<uint8_t> &out) {
    SaveFile(file_name, out.data(), out.size());
}

inline void SaveFile(const std::string &file_name, const std::string &out) {
    SaveFile(file_name, out.data(), out.size());
}

}  // namespace FsTools

#endif  // FS_TOOLS_H_
