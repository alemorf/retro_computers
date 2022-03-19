// ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "inifile.h"
#include "vinlib/string.h"
#include "vinlib/file.h"
#include "vinlib/exception.h"

static bool isIniSpc(char c) {
  return c==32 || c==13 || c==9;
}

IniFile::IniFile() {
  setDefault();
}

void IniFile::setDefault() {
}

void IniFile::load(const char* fileName) {
  setDefault();
  string ini = loadStringFromFile(fileName);
  const char* s = ini.c_str();
  int line=1;
  while(true) {
    while(isIniSpc(*s)) s++;
    if(*s==';') while(*s!=10 && *s!=0) s++;
    if(*s==0) break;
    if(*s==10) {
      s++;
    } else {
      char* e = const_cast<char*>(strchr(s, '\n'));
      if(e) e[0]=0;
      char* r = const_cast<char*>(strchr(s, ' '));
      if(r==0) raise((string)"Ошибка в файле "+fileName+" в строке "+i2s(line));
      *r=0;
      char* v = r+1;
      while(isIniSpc(*v)) v++;
      int vl = strlen(v);
      while(vl>0 && isIniSpc(v[vl-1])) vl--;
      v[vl]=0;
      loadParam(s,v);
      if(e==0) break;
      s = e+1;
    }
    line++;
  }
}

IniFile::~IniFile() {
}
