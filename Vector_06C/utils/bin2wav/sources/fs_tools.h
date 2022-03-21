// File tools
//
// MISRA, Google style, Clang format
// License GNU2
// Copyright 2021-Jul-26 Alemorf, aleksey.f.morozov@gmail.com

#ifndef FS_TOOLS_H_
#define FS_TOOLS_H_

#include <functional>
#include <vector>

namespace FsTools {

void LoadFile(const char file_name[], std::function<void*(size_t)> allocate);
void LoadFile(const char file_name[], size_t max_file_size, std::vector<uint8_t>* out);
void SaveFile(const char file_name[], const void* data, size_t size);
void SaveFile(const char file_name[], const std::vector<uint8_t>& out);

}  // namespace FsTools

#endif  // FS_TOOLS_H_
