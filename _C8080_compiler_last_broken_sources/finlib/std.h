// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_STD_H
#define VINLIB_STD_H

#include "finlib/types.h"
#include "finlib/exception.h"
#include "finlib/file.h"
//#include "finlib/exec.h"
#include "finlib/findfiles.h"
#include "finlib/string.h"
#include "finlib/winapi_exception.h"

// Сложение с контролем переполнения //! Оптимизировать
inline int add(int a, int b) {
  __int64 r=__int64(a)+__int64(b); // может вылезти тольк один бит
  if(r>(__int64)INT_MAX || r<(__int64)INT_MIN) overflow();
  return int(r);
}

template<class T>
inline void erasei(std::vector<T>& a, unsigned int n) {
  if(n<0 || n>=a.size()) raise("Out of bound");
  a.erase(a.begin()+n);
}

template<class T>
inline void erasei(std::list<T>& a, unsigned int n) {
  if(n<0 || n>=a.size()) raise("Out of bound");
  std::list<T>::iterator x = a.begin();
  while(n--) x++;
  a.erase(x);
}

template<class T>
inline T& get(std::list<T>& a, int n) {
  std::list<T>::iterator x = a.begin();
  while(n--) x++;
  return *x;
}

template<class T>
inline T& insertir(std::list<T>& a, unsigned int n) {
  if(n<0 || n>a.size()) raise("Out of bound");
  a.insert(a.begin()+n, T());
  return *(a.begin()+n);
}

template<class T>
inline T& insertir(std::vector<T>& a, unsigned int n) {
  if(n<0 || n>a.size()) raise("Out of bound");
  a.insert(a.begin()+n, T());
  return *(a.begin()+n);
}

inline void clearString(std::string& str) {
  string tmp;
  str.swap(tmp);
}

template<class T>
T* begin(std::vector<T>& a) {
  if(a.empty()) return 0;
  return &*a.begin();
}


#endif