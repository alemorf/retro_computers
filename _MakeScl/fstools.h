// Make TRD/SCL file (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#pragma once

#include <stdint.h>
#include <stddef.h>
#include <vector>
#include <string>

bool loadFile(std::vector<uint8_t>& output, const std::string& fileName, unsigned maxFileSize);
bool saveFile(const char* file_name, const void* data, size_t size);
