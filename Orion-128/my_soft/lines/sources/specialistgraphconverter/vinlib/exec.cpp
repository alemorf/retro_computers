// Открытая, бесплатная, ASIS версия библиотеки VinLib. В процессе написания
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/exec.h"
#include "vinlib/winapi_exception.h"
#include <windows.h>

class VinLib_exec_AutoCloseHandle {
  HANDLE& h;
public:
  inline VinLib_exec_AutoCloseHandle(HANDLE& _h) : h(_h) {
  }

  inline ~VinLib_exec_AutoCloseHandle() { 
    if(h!=0) 
      if(!CloseHandle(h))
        warning_os("CloseHandle");
  }
};

int exec(cstring exe, cstring args) {
  STARTUPINFO si;
  memset(&si,0,sizeof(si));
  si.cb = sizeof(si);
  si.wShowWindow = SW_HIDE;
  si.dwFlags = STARTF_USESHOWWINDOW;
  PROCESS_INFORMATION pi;
  memset(&pi, 0, sizeof(pi));
  VinLib_exec_AutoCloseHandle ach1(pi.hProcess);
  VinLib_exec_AutoCloseHandle ach2(pi.hThread);  
  if(!CreateProcess(exe.c_str(), const_cast<char*>((exe+" "+args).c_str()), 0, 0, false, 0, 0, 0, &si, &pi))
    raise_os("CreateProcess");
  WaitForSingleObject(pi.hProcess, INFINITE);
  DWORD c;
  if(!GetExitCodeProcess(pi.hProcess, &c))
    raise_os("GetExitCodeProcess");
  return c;
}
