// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/winapi_exception.h"
#include "vinlib/exception.h"
#include <windows.h>

// Получение текста ошибки Windows 
void getOsErrorMessage(const char* prefix, string& error) {
  if(prefix || prefix[0]!=0) error=prefix, error+=": ";
                        else error = "";
  int e = GetLastError();
  if(e!=0) {
    char buf[1024];
    if(FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,0,e,0,buf,sizeof(buf),0)) {
      for(int i=0; buf[i]; i++)
        if(buf[i]==13 || buf[i]==10) buf[i]=32;
      error += buf;
      return;
    }
  }
  error += "Неизвестная ошибка";
}

// Генерация исключения с добавлением текста ошибки Windows
void raise_os(const char* preFix) {
  string text;
  getOsErrorMessage(preFix, text);
  raise(text);
}

// Предупреждение с добавлением текста ошибки Windows
void warning_os(const char* preFix) {
  string text;
  getOsErrorMessage(preFix, text);
  warning(text);
}

// Обработка исключений
#ifndef _CONSOLE
int __stdcall WinMain(HINSTANCE,HINSTANCE,LPSTR cmdLine,int) {
  try {
    return main(cmdLine);
#else
int main(int argc, const char** argv) {
  try {
    return cmain(argc, argv);
#endif
  } catch(Exception& e) {
    MessageBox(0, e.what(), 0, MB_ICONEXCLAMATION);
    return 1;
  } catch(...) {
    MessageBox(0, "Неопределенная ошибка", 0, MB_ICONEXCLAMATION);
    return 1;
  } 
}
