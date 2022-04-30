// PDP11 Assembler (c) 15-01-2015 vinxru

#include "stdafx.h"
#include "compiler.h"
#include <iostream>

#ifdef WIN32
int _tmain(int argc, _TCHAR* argv[]) {
    setlocale(LC_ALL, "RUSSIAN");
#else
int main(int argc, char** argv) {
#endif
  try {
    // Ожидается один аргумент
    if(argc != 2) {
      std::cout << "Specify one file name on the command line" << std::endl;
      return 0;
    }
    
    // Компиляция
    Compiler c;
    c.compileFile(argv[1]);

    // Выход без ошибок
    std::cout << "Done" << std::endl;
    return 0;

    // Выход с ошибками
  } catch(std::exception& e) {
    std::cout << e.what() << std::endl;
#ifdef _DEBUG
    char x; std::cin >> x;
#endif
    return 1;
  }
}
