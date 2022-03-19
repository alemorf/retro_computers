// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/file.h"
#include "vinlib/types.h"
#include "vinlib/winapi_exception.h"
#include "vinlib/exception.h"

File::File() throw() {
  handle = INVALID_HANDLE_VALUE;
}

void File::raiseIfNotOpened() {
  if(handle==INVALID_HANDLE_VALUE) raise("Файл не открыт");
}

int File::size32() {
  raiseIfNotOpened();
  DWORD h;
  int l = GetFileSize(handle, &h);
  if(l<0 || h!=0) raise("Файл слишком большой");
  return l;
}

void File::open(const char* fileName, int access, int share, int distr) {
  close();
  handle=CreateFile(fileName, access, share, 0, distr, 0, 0);
  if(handle==INVALID_HANDLE_VALUE) raise_os((string)"Ошибка создания/открытия файла "+fileName+"\nCreateFile");
}

void File::openR(const char* fileName) {
  close();
  handle=CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0);
  if(handle==INVALID_HANDLE_VALUE) raise_os((string)"Ошибка открытия файла "+fileName+"\nCreateFile");
}

void File::openC(const char* fileName, FileCreateMode mode) {
  close();
  handle=CreateFile(fileName, GENERIC_READ|GENERIC_WRITE, FILE_SHARE_READ, 0,mode, 0, 0);
  if(handle==INVALID_HANDLE_VALUE) raise_os((string)"Ошибка открытия файла "+fileName+"\nCreateFile");
}

void File::read(void* buf, int len0) {
  raiseIfNotOpened();
  if(len0==0) return;
  if(len0<0) raise_os("ReadFile"); 
  unsigned long len=len0; // С уветом верхней проверки ошибок нет, а компилятор счаслив
  unsigned long res;
  if(!ReadFile(handle, buf, len, &res, 0)) raise_os("ReadFile");
  if(res!=len) raise("Ошибка чтения файла");
}

void File::write(const void* buf, int len0) {
  raiseIfNotOpened();
  if(len0==0) return;
  if(len0<0) raise_os("ReadFile"); 
  unsigned long len=len0; // С уветом верхней проверки ошибок нет, а компилятор счаслив
  unsigned long res;
  if(!WriteFile(handle, buf, len, &res, 0))
    raise_os("WriteFile");
  if(res!=len) raise("Ошибка записи в файл");
}

void File::close() {
  if(handle==INVALID_HANDLE_VALUE) return;
  CloseHandle(handle);
  handle=INVALID_HANDLE_VALUE;
}

File::~File() {  
  if(handle!=INVALID_HANDLE_VALUE) 
    if(!CloseHandle(handle))
      warning_os("CloseHandle File");
}

void saveFile(const char* fileName, FileCreateMode mode, const void* buf, int len) {
  File file;
  file.openC(fileName, mode);
  file.write(buf, len);
}

void loadFile(std::vector<byte_t>& out, cstring fileName) {
  File f;
  f.openR(fileName);
  int len = f.size32();
  out.resize(len);
  if(len>0) f.read(&out[0], len);
}

// Только 8-битные файлы
void loadStringFromFile(std::string& out, const string& fileName) {
  std::vector<byte_t> buf;
  loadFile(buf, fileName);
  out.assign(&buf[0], buf.size());
}
