// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_WINAPI_EXCEPTION_H
#define VINLIB_WINAPI_EXCEPTION_H

#include "vinlib/string.h"

// Получение текста ошибки Windows 
void getOsErrorMessage(const char* prefix, string& error);

// Вывод предупреждения
void warning_os(const char* preFix);

// Генерация исключения с добавлением текста ошибки Windows
void raise_os(const char* preFix);
inline void raise_os(cstring text) { raise_os(text.c_str()); }

// Прототип главной функции
int main(const char*);

#endif