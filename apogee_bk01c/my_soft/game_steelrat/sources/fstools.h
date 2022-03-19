// File tools, MISRA
// 2021-01-06 Alemorf, aleksey.f.morozov@gmail.com

#ifndef FSTOOLS_H
#define FSTOOLS_H

#ifdef __cplusplus

#include <functional>

void loadFile(const char* fileName, std::function<void*(size_t)> allocate);
void saveFile(const char* fileName, const void* data, size_t size);

#endif

#endif

