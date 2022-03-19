// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_FILE_H
#define VINLIB_FILE_H

#include <windows.h>
#include "vinlib/string.h"

// Режимы создания файла
enum FileCreateMode {
  fcmCreateNew     = 1, // Если файл уже существует, то произойдет ошибка.
  fcmCreateAlways  = 2, // Если файл уже существует, то он будет очищен.
  fcmOpenExisting  = 3, // Если файл не существует, то произойдет ошибка. Существующий файл будет очищен.
};

class File {
public:
  HANDLE handle;

  File();
  ~File();

  // Исключение, если файл не открыт
  void raiseIfNotOpened();

  // Открыть файл
  //   access = любая комбинация GENERIC_READ, GENERIC_WRITE
  //   share  = любая комбинация FILE_SHARE_DELETE, FILE_SHARE_READ, FILE_SHARE_WRITE	
  //   distr  = один из CREATE_NEW, CREATE_ALWAYS, OPEN_EXISTING, OPEN_ALWAYS, TRUNCATE_EXISTING
  void open(const char* fileName, int access, int share, int distr);

  // Открыть файл для чтения
  void openR(const char* fileName); 

  // Открыть файл для чтения/записи
  void openW(const char* fileName);

  // Создать новый файл
  void openC(const char* fileName, FileCreateMode mode=fcmCreateAlways);

  // Читать из файла
  void read(void* buf, int len);

  // Записать в файл
  void write(const void* buf, int len);

  // Узнать размер файла
  __int64 size64();

  // Узнать размер файла. Если размер больше 2^31 байт, то произойдет ошибка.
  int size32();

  // Достигнут конец файла
  bool eof();

  // Установить размер файла
  void setSize(__int64 size);

  // Установить позицию чтения/записи файла
  void setPosition(__int64 pos);

  // Получить позицию чтения/записи файла
  __int64 getPosition64();

  // Получить позицию чтения/записи файла. Если позиция больше 2^31 байт, то произойдет ошибка.
  int getPosition32();

  // Закрыть файл
  void close();

  // Файл открыт?
  bool opened();

  // Поддержка типа данных std::string
  inline void open(cstring fileName, int access, int share, int distr) { open(fileName.c_str(), access, share, distr); }
  inline void openR(cstring fileName) { openR(fileName.c_str()); }
  inline void openC(cstring fileName, FileCreateMode createAlways=fcmCreateAlways) { openC(fileName.c_str(), createAlways); }
  inline void openW(cstring fileName) { openW(fileName.c_str()); }
};

// Сохранить область памяти в файл (и поддержка типа данных std::string)
void saveFile(const char* fileName, FileCreateMode mode, const void* buf, int len);
inline void saveFile(cstring     fileName, FileCreateMode mode, const void* d, int l    ) { saveFile(fileName.c_str(), mode, d, l);                }

// Сохранить массив в файл (и поддержка типа данных std::string)
inline void saveFile(const char* fileName, FileCreateMode mode, const std::vector<char>& d) { saveFile(fileName,         mode, d.size()==0 ? "" : &d[0], d.size()); }
inline void saveFile(cstring     fileName, FileCreateMode mode, const std::vector<char>& d) { saveFile(fileName.c_str(), mode, d.size()==0 ? "" : &d[0], d.size()); }

// Сохранить строку в файл
inline void saveFile(const char* fileName, FileCreateMode mode, cstring     d) { saveFile(fileName,         mode, d.c_str(), d.size()); }
inline void saveFile(cstring     fileName, FileCreateMode mode, cstring     d) { saveFile(fileName.c_str(), mode, d.c_str(), d.size()); }
inline void saveFile(const char* fileName, FileCreateMode mode, const char* d) { saveFile(fileName,         mode, d, strlen(d));        } 
inline void saveFile(cstring     fileName, FileCreateMode mode, const char* d) { saveFile(fileName.c_str(), mode, d, strlen(d));        }

// Загрузить файл в массив
void loadFile(std::vector<char>& out, cstring fileName);

// Загрузить файл в строку
void loadStringFromFile(std::string& out, const std::string& fileName);

// Загрузить строку из файла.
// Более медленная (так как строка возращается в результате), но удобная функция.
inline std::string loadStringFromFile(cstring fileName) {
  std::string str;
  loadStringFromFile(str, fileName);
  return str;
}

#endif