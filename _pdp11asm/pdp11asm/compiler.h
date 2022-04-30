// PDP11 Assembler (c) 15-01-2015 vinxru

#pragma once
#include "lstwriter.h"
#include "parser.h"
#include "output.h"
#include <limits>

class Compiler {
public:
  enum Processor { P_PDP11, P_8080 };

  LstWriter lstWriter;
  Parser p;
  Output out;
  bool need_create_output_file;
  bool step2;
  bool convert1251toKOI8R;  
  Processor processor;
  std::map<std::string, Parser::num_t> labels;
  char lastLabel[Parser::maxTokenText];

  // c_common.cpp
  Compiler();
  void compileFile(syschar_t* fileName);
  bool compileLine2();
  void compileLine();
  bool ifConst3(Parser::num_t& out, bool numIsLabel=false);
  bool ifConst4(Parser::num_t& out, bool numIsLabel=false);
  void makeLocalLabelName();
  void compileByte();
  void compileWord();
  Parser::num_t readConst3(bool numIsLabel=false);
  void compileOrg();

  // c_bitmap.cpp
  bool compileLine_bitmap();

  // c_pdp11.cpp
  struct Arg {
    bool used;
    int  val;
    int  code;  
    bool subip;
  };

  void write(int n, Arg& a);
  void write(int n, Arg& a, Arg& b);
  bool regInParser();
  int readReg();
  void readArg(Arg& a);
  bool compileLine_pdp11();

  // c_8080.cpp
  bool compileLine_8080();
};

//-----------------------------------------------------------------------------

inline size_t ullong2size_t(unsigned long long a) {
  if(a > std::numeric_limits<size_t>::max()) throw std::runtime_error("Too big number");
  return (size_t)a;
}

//-----------------------------------------------------------------------------

template<class A>
A removeExtension(A fileName) {
  int s = fileName.rfind('.');
  if(s==-1 || fileName.find('/', s)!=-1 || fileName.find('\\', s)!=-1) return fileName;
  return fileName.substr(0,s);
}