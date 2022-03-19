// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_EXCEPTION_H
#define VINLIB_EXCEPTION_H

#include <vinlib/string.h>

enum ExceptionClass { ecSilentException,ecException,ecUnknown,ecBreakException,ecLangException }; // ecAlt,

// Стандартный класс исключения отстой, и он не поддерживает UNICODE.

class Exception {
protected:
  struct Exception1 {
    int len;           
    ExceptionClass cls;  // Класс ошибки
    char_t* what;        // Текст ошибки
    char_t* module;      // Модуль
    int line;            // Строка в модуле
  };
  Exception1* e; // Надо что бы исключение занимало как можно меньше памяти, иначе интерпретатор, в котором тясяча исключений, съедает весь стек. Для этого и применен указатель.
public:
  Exception(const char_t* what=_T("Неизвестная ошибка"), const char_t* module=_T(""), int line=0, ExceptionClass cls=ecException) throw();
  Exception(const Exception& src) throw();  
  void operator = (const Exception& src) throw();
  const char_t* what() const throw();
  const char_t* module() const throw();
  int line() const  throw();
  ExceptionClass cls() const  throw(); 
  void raise() const; // Единственный метод вызывающий исключение
  ~Exception() throw();
};

// Вывести исключение пользователю и продолжить выполнение программы
#define BEGIN_PROCESS_EXCEPTION try {
#define END_PROCESS_EXCEPTION } catch(Exception& e) { ::error(&e,0); } catch(...) { ::error(0,0); }
#define END_PROCESS_EXCEPTION_ADDR(A) } catch(Exception& e) { ::error(&e,A); } catch(...) { ::error(0,A); }

// Блок, в котором не должно быть исключений
#define BEGIN_NO_EXCEPTION try {
#define END_NO_EXCEPTION } catch(Exception& e) { fatal(&e,0); } catch(...) { fatal(0,0); }
#define END_NO_EXCEPTION_ADDR(A) } catch(Exception& e) { fatal(&e,_T(A)); } catch(...) { fatal(0,_T(A)); }

// Добавить в текст исключения строку
#define BEGIN_EXT_EXCEPTION try {
#define END_EXT_EXCEPTION(text) \
  } catch(Exception& e) { \
    string tmp; /*! Заменить на статический буфер*/ \
    cat(tmp, text, _T("\n"), e.what()); \
    raise(tmp.c_str(), e.module(), e.line(), e.cls()); \
    throw Exception(); \
  } catch(...) { \
    raise((string)text + _T("\nНеизвестная ошибка"));  /*! Заменить на статический буфер*/ \
    throw Exception(); \
  }

// Обычно нажатие кнопки Break. Такие исключения в виртуальной машине игнорирует блок except, что 
// бы предотвратить бесконечный цикл.

class BreakException : public Exception {
public:
  inline BreakException(const char_t* what, const char_t* module=_T(""), int l=0) :  Exception(what,module,l,ecBreakException) {}
};

class LangException : public Exception {
public:
  inline LangException(const char_t* what, const char_t* module=_T(""), int l=0) :  Exception(what,module,l,ecLangException) {}
};

class SilentException : public Exception {
public:
  inline SilentException(const char_t* what, const char_t* module=_T(""), int l=0) :  Exception(what,module,l,ecSilentException) {}
};

// Генерация исключения
void error(Exception* e, const char_t* str);
inline void raise(const char_t* str) { Exception e(str); throw e; }
inline void raise(cstring str) { raise(str.c_str()); }

// Эта функция должна быть описана в программе
void warning(cstring errorText);

// Эта функция должна быть описана в программе
void fatal(Exception* e, const char* fn);

#endif