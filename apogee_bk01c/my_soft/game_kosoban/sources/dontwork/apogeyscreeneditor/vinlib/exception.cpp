// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/types.h"
#include "vinlib/exception.h"

inline bool tryAdd(uint& o, uint a, uint b) {
  __int64 r=(unsigned __int64)a+(unsigned __int64)b; // может вылезти тольк один бит
  if(r>(unsigned __int64)UINT_MAX) return false;
  o = uint(r);
  return true;
}

Exception::Exception(const char_t* what, const char_t* module, int line, ExceptionClass cls) throw() {
  BEGIN_NO_EXCEPTION
    e=0;

    // Необходимый обьем памяти
    uint what_size, module_size, len;
    if(!tryAdd(what_size, _tcslen(what), 1)) return;
    if(!tryAdd(module_size, _tcslen(module), 1)) return;
    if(!tryAdd(len, what_size, module_size)) return;
    if(!tryAdd(len, len, sizeof(Exception1))) return;

    // Выделяем память
    try {
      e = (Exception1*)new char_t[len]; //! Переполнение
    } catch(...) { 
      e = 0;
      return; 
    }

    // Заполняем структуру    
    e->len    = len;
    e->line   = line;
    e->cls    = cls;
    e->what   = (char_t*)e + sizeof(Exception1);
    e->module = e->what + what_size;
    memcpy(e->what, what, what_size*sizeof(char_t)); 
    memcpy(e->module, module, module_size*sizeof(char_t));
  END_NO_EXCEPTION_ADDR("Exception.Exception")
}

//---------------------------------------------------------------------------------------------------------

Exception::Exception(const Exception& src) throw() {
  BEGIN_NO_EXCEPTION
    if(src.e==0) e=0;
            else new(this) Exception(src.e->what, src.e->module, src.e->line, src.e->cls); // no throw
  END_NO_EXCEPTION_ADDR("Exception.Exception=")
}

//---------------------------------------------------------------------------------------------------------

void Exception::operator = (const Exception& src) throw() {
  BEGIN_NO_EXCEPTION
    if(e) {
      delete[] (byte_t*)e;
      e=0;
    }
    if(src.e) {
      try {
        e = (Exception1*)new char[src.e->len];
      } catch(...) {
        e = 0;
        return;
      }
      memcpy(e, src.e, src.e->len);      
      e->what += (byte_t*)e-(byte_t*)src.e;
      e->module += (byte_t*)e-(byte_t*)src.e;
    }
  END_NO_EXCEPTION_ADDR("Exception=")
}

//---------------------------------------------------------------------------------------------------------

const char_t* Exception::what() const throw() { 
  if(e==0) return _T("Out of memory");
  return e->what; 
}

//---------------------------------------------------------------------------------------------------------

const char_t* Exception::module() const throw() { 
  if(e==0) return _T("Out of memory");
  return e->module; 
}

//---------------------------------------------------------------------------------------------------------

ExceptionClass Exception::cls() const throw() { 
  if(e==0) return ecException;
  return e->cls; 
}

//---------------------------------------------------------------------------------------------------------

int Exception::line() const throw() { 
  if(e==0) return 0;
  return e->line; 
}

//---------------------------------------------------------------------------------------------------------

Exception::~Exception() throw() {
  if(e) {
    delete[] (byte_t*)e;
    e=0;
  }
}

//---------------------------------------------------------------------------------------------------------

void raise(const char_t* w, const char_t* m, int l, ExceptionClass c) {
  switch(c) {
    case ecLangException:   { LangException   x(w, m, l); throw x; }
    case ecBreakException:  { BreakException  x(w, m, l); throw x; }
    case ecSilentException: { SilentException x(w, m, l); throw x; }
    default:                { Exception       x(w, m, l); throw x; }
  }
}

//---------------------------------------------------------------------------------------------------------

void Exception::raise() const {
  if(e) ::raise(e->what, e->module, e->line, e->cls);  
   else ::raise(_T("Out of memory"));
}
