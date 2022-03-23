#if !defined(AFX_STDAFX_H__A9DB83DB_)
#define AFX_STDAFX_H__A9DB83DB_

#include <string>
#include <string.h>
#include <Windows.h>
#include <stdlib.h>

#if _MSC_VER > 1000
#pragma once
#endif

#define WIN32_LEAN_AND_MEAN
#define NO_INET
#define NO_DYN_BLOB

#pragma comment(lib,"kernel32.lib")
#pragma comment(lib,"user32.lib")
#pragma comment(lib,"gdi32.lib")
#pragma comment(lib,"comdlg32.lib")
#pragma comment(lib,"shell32.lib")
#pragma comment(lib,"advapi32.lib")

#endif
