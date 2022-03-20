// stdafx.h: включаемый файл для стандартных системных включаемых файлов
// или включаемых файлов для конкретного проекта, которые часто используются, но
// не часто изменяются
//

#pragma once

#define NO_INET
#define NO_FUNCTION_ARGS
#define WIN32_LEAN_AND_MEAN             // Исключите редко используемые компоненты из заголовков Windows
// Файлы заголовков Windows:
#include <string>
#include <windows.h>

// Файлы заголовков C RunTime
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <tchar.h>

//#define DISABLE_FORK

// TODO: Установите здесь ссылки на дополнительные заголовки, требующиеся для программы
