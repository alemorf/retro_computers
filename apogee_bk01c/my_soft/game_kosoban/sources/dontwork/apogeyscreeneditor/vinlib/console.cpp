// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/console.h"
#include "vinlib/winapi_exception.h"
#include "vinlib/exception.h"
#include <windows.h>

void writeConsole(const char* src) {
  string dest;
  dest.resize(strlen(src));
  CharToOem(src, const_cast<char*>(dest.c_str()));
  HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
  if(h==INVALID_HANDLE_VALUE) raise_os("GetStdHandle");
  DWORD tmp=0;
  if(!WriteFile(h, dest.c_str(), dest.size(), &tmp, 0)) raise_os("WriteFile");
  if(tmp!=dest.size()) raise("WriteConsole");
}
