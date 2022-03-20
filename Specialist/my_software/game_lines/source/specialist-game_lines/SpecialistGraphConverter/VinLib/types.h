// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#ifndef VINLIB_TYPES_H
#define VINLIB_TYPES_H

#include <vector>
#include <list>

typedef char byte_t;
typedef unsigned int uint;

// Добавить элемент в конец массива и вернуть ссылку на него
template<class T>
inline T& add(std::vector<T>& a) { int n=a.size(); a.resize(n+1); return a[n]; }

// Добавить элемент в конец списка и вернуть ссылку на него
template<class T>
inline T& add(std::list<T>& a) { a.push_back(T()); return a.back(); }

#endif