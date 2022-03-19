// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_FINDFILES_H
#define VINLIB_FINDFILES_H

#include "vinlib/string.h"

// Используется функцией findFiles
struct FindData {
  string name;
  __int64 size, creationTime, accessTime, writeTime;
  union {
    int attrib;
    struct {
      int readonly : 1;
      int hidden : 1;
      int system : 1;
      int unknown : 1;
      int directory : 1;
      int archive : 1;
      int encripted : 1;
      int normal : 1;
      int temporary : 1;
      int sparse_file : 1;
      int reparse_point : 1;
      int compressed : 1;
      int offline : 1;
      int content_indexed : 1;
    };
  };
};

// Получение списка файлов в папке в массив (и поддержка типа данных std::string)
void findFiles(std::vector<FindData>& out, const char* mask);
inline void findFiles(std::vector<FindData>& out, cstring mask) { findFiles(out, mask.c_str()); }

#endif