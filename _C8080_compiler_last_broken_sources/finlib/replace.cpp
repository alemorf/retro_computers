#include <stdafx.h>
#include "replace.h"

std::string replace(const std::string& f, const std::string& t, const std::string& str) {
  int fl=f.size(), tl=t.size();
  if(fl==0) return str;

  // Оптределение длины строки
  int n=0, c=0;
  while(true) {
    n=str.find(f,n);
    if(n==-1) break;
    n+=fl;
    c++;
  }

  // Итоговый буфер
  std::string out;
  out.resize(str.size()+(tl-fl)*c);
  byte_t* p = const_cast<byte_t*>(out.c_str());

  // Копирование
  const byte_t* tc=t.c_str();
  n=0;
  while(true) {
    int m=str.find(f,n);
    if(m==-1) {
      m=str.size();
      memcpy(p, str.c_str()+n, m-n);
      break;
    }
    memcpy(p, str.c_str()+n, m-n);
    p += m-n;
    memcpy(p, tc, tl);
    p += tl;
    n=m+fl;
  }   
  return out;
}


std::wstring replace(const std::wstring& f, const std::wstring& t, const std::wstring& str) {
  int fl=f.size(), tl=t.size();
  if(fl==0) return str;

  // Оптределение длины строки
  int n=0, c=0;
  while(true) {
    n=str.find(f,n);
    if(n==-1) break;
    n+=fl;
    c++;
  }

  // Итоговый буфер
  std::wstring out;
  out.resize(str.size()+(tl-fl)*c);
  wchar_t* p = const_cast<wchar_t*>(out.c_str());

  // Копирование
  const wchar_t* tc = t.c_str();
  n=0;
  while(true) {
    int m=str.find(f,n);
    if(m==-1) {
      m=str.size();
      memcpy(p, str.c_str()+n, (m-n)*2);
      break;
    }
    memcpy(p, str.c_str()+n, (m-n)*2);
    p += m-n;
    memcpy(p, tc, tl*sizeof(char_t));
    p += tl;
    n=m+fl;
  }   
  return out;
}
