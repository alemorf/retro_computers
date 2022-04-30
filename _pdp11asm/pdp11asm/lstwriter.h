// PDP11 Assembler (c) 15-01-2015 vinxru

#pragma once
#include <string>
#include "output.h"
#include "parser.h"
#include <fstream>

class LstWriter {
public:
  std::string buffer;
  size_t prev_writePtr;
  const char* prev_sigCursor;
  Output* out;
  Parser* p;
  bool hexMode;

  inline LstWriter() { hexMode=false; prev_writePtr=0; prev_sigCursor=0; out=0; p=0; }
  void beforeCompileLine();
  void afterCompileLine();

  void writeFile(const std::string& fileName) { writeFile2<std::string>(fileName, ".lst"); }
  void writeFile(const std::wstring& fileName) { writeFile2<std::wstring>(fileName, L".lst"); }
  
  template<class A>
  void writeFile2(const A& fileName, const A& ext) {
    A fileName2 = removeExtension(fileName) + ext;
    if(fileName != fileName2) {
      std::ofstream file;
      file.open(fileName2.c_str());
      if(!file.is_open()) throw std::runtime_error("Can't create lst file");
      file << buffer;
    }
  }

protected:
  void appendBuffer(const char* data, size_t size);
  inline void appendBuffer(const char* data) { appendBuffer(data, strlen(data)); }
};
