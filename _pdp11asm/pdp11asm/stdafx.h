// PDP11 Assembler (c) 15-01-2015 vinxru

#include <string.h>
#include <string>

#ifndef WIN32

// В Windows и Linux называется по разному (знаю, что различия в работе есть)
#define sprintf_s snprintf

// strcpy_s пока не поддерживается в Linux (G++)
inline void strcpy_s(char* a, const char* b) { strcpy(a, b); }

// В Windows и Linux называется по разному
inline int _strcmpi(const char* a, const char* b) { return strcasecmp(a, b); }

// Командная строка в Linux
typedef char syschar_t;
typedef std::string sysstring_t;
#ifndef _T
#define _T(S) S
#endif

#else

// Нужно в Windows
#include <tchar.h>

// Командная строка в Windows
typedef wchar_t syschar_t;
typedef std::wstring sysstring_t;
#ifndef _T
#define _T(S) L##S
#endif

// перечислитель ? в операторе switch с перечислением ? не обрабатывается
#pragma warning(disable:4062) 

#endif