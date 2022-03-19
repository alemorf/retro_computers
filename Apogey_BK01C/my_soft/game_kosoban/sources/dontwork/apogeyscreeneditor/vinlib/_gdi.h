/*---------------------------------------------------------------------------
  VinLib
  Классы GDI (для автоосвобождения ресурсов)
 
  This Software is owned by Aleksey Morozov (vinxru) and is
  protected by copyright law and international copyright treaty.
 
  Copyright (C) 2001-2012 Aleksey Morozov <Aleksey.F.Morozov@gmail.com> 
---------------------------------------------------------------------------*/

#ifndef VINLIB_GDI_H
#define VINLIB_GDI_H

//#include <vinlib/winapi.h>

class DCDisplay {
public:
  HDC hdc;  

  inline DCDisplay() {    
    hdc=GetDC(0);
    if(hdc==0) raise_os(_T("GetDC(0)"));
  }  

  inline ~DCDisplay() throw() {
    BEGIN_NO_EXCEPTION
      if(hdc) if(!ReleaseDC(0, hdc)) warning_os(_T("ReleaseDC(0)"));
    END_NO_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCSetTextColor {
public:
  HDC hdc;
  LONG old;

  inline DCSetTextColor(HDC _hdc, int color) { 
    hdc = _hdc; 
    old = SetTextColor(hdc, color); //! Ошибка не проверяется
  }

  inline ~DCSetTextColor() { 
    BEGIN_PROCESS_EXCEPTION
      SetTextColor(hdc, old); //! Ошибка не проверяется
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCSetBkColor {
public:
  HDC hdc;
  LONG old;

  inline DCSetBkColor(HDC _hdc, int color) { 
    hdc = _hdc;
    old = SetBkColor(hdc, color); //! Ошибка не проверяется
  }

  inline ~DCSetBkColor() { 
    BEGIN_PROCESS_EXCEPTION
      SetBkColor(hdc, old); //! Ошибка не проверяется
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCSelect {
public:
  HDC hdc;
  HGDIOBJ oldhandle;

  inline DCSelect() throw() { 
    oldhandle=0;
  }

  inline DCSelect(HDC _hdc, HANDLE handle) {
    oldhandle=0;
    select(_hdc, handle);
  }

  inline void select(HDC _hdc, HANDLE handle) {
    hdc = _hdc;
    oldhandle = SelectObject(hdc, handle); //! Ошибка не проверяется
  }  

  inline ~DCSelect() {
    BEGIN_PROCESS_EXCEPTION
      if(oldhandle) SelectObject(hdc, oldhandle); //! Ошибка не проверяется 
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCWindow {
public:
  HDC hdc;  
  HWND hwnd;

  inline DCWindow(HWND _hwnd) {    
    hwnd = _hwnd;
    hdc  = GetDC(hwnd);
    if(hdc==0) raise_os(_T("GetDC(0)"));
  }  

  inline ~DCWindow() {
    BEGIN_PROCESS_EXCEPTION
      if(hdc) if(!ReleaseDC(hwnd, hdc)) raise_os(_T("ReleaseDC"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCCompatible {
public:
  HDC hdc;  

  inline DCCompatible(HDC _hdc) {        
    hdc = CreateCompatibleDC(_hdc);
    if(hdc==0) raise_os(_T("CreateCompatibleDC"));
  }

  inline ~DCCompatible() {
    BEGIN_PROCESS_EXCEPTION
      if(hdc) if(!DeleteDC(hdc)) raise_os(_T("DeleteDC"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCPen {
public:
  HDC hdc;
  HGDIOBJ handle, oldhandle;

  inline DCPen(HDC _hdc, int style, int width, int color) {
    hdc = _hdc;
    oldhandle = 0;

    LOGBRUSH lb;
    lb.lbStyle = BS_SOLID;
    lb.lbColor = color;
    lb.lbHatch = 0;

    handle = ExtCreatePen((width==0 ? PS_COSMETIC : PS_GEOMETRIC) | PS_ENDCAP_SQUARE | style, width, &lb, 0, 0);

    if(handle==0) {
      handle = CreatePen(style, width, color);
      if(handle==0) raise_os(_T("ExtCreatePen & CreatePen"));
    }

    oldhandle = SelectObject(hdc, handle); //! Ошибка не проверяется
  }  

  inline ~DCPen() {
    BEGIN_PROCESS_EXCEPTION
      if(oldhandle) SelectObject(hdc, oldhandle); //! Ошибка не проверяется
      if(handle) if(!DeleteObject(handle)) raise_os(_T("DeleteObject"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCBrush {
public:
  HDC hdc;
  HGDIOBJ handle, oldhandle;

  inline DCBrush(HDC _hdc, int color) {
    hdc = _hdc;
    oldhandle = 0;

    handle = CreateSolidBrush(color);
    if(handle==0) raise_os(_T("CreateSolidBrush"));

    oldhandle = SelectObject(hdc, handle); //! Ошибка не проверяется
  }  

  inline ~DCBrush() {
    BEGIN_PROCESS_EXCEPTION
      if(oldhandle) SelectObject(hdc, oldhandle); //! Ошибка не проверяется
      if(handle) if(!DeleteObject(handle)) raise_os(_T("DeleteObject"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class DCNullBrush {
public:
  HDC hdc;
  HGDIOBJ handle, oldhandle;

  inline DCNullBrush(HDC _hdc) {
    hdc = _hdc;
    oldhandle = 0;

    handle = GetStockObject(NULL_BRUSH);
    if(handle==0) raise_os(_T("GetStockObject(NULL_BRUSH)"));

    oldhandle = SelectObject(hdc, handle);
  }  

  inline ~DCNullBrush() {
    BEGIN_PROCESS_EXCEPTION
      if(oldhandle) SelectObject(hdc, oldhandle);
      // if(handle) if(!DeleteObject(handle)) raise_os(_T("DeleteObject"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class CompatibleBitmap {
public:
  HBITMAP handle;

  inline CompatibleBitmap(HDC hdc, int width, int height) {
    handle = CreateCompatibleBitmap(hdc, width, height);
    if(handle==0) raise_os(_T("CreateCompatibleBitmap"));
  }

  inline ~CompatibleBitmap() {
    BEGIN_PROCESS_EXCEPTION
      if(handle!=0) if(!DeleteObject(handle)) raise_os(_T("DeleteObject"));
    END_PROCESS_EXCEPTION
  }
};

//----------------------------------------------------------------------------------------

class Region {
public:
  HRGN handle;

  inline Region(int x, int y, int x1, int y1) { 
    handle = CreateRectRgn(x,y,x1,y1); 
    if(handle==0) raise_os(_T("Region.CreateRectRgn"));
  }

  inline void combine(Region& src, int mode=RGN_OR) {
    int r = CombineRgn(handle, handle, src.handle, mode);
    if(r==ERROR) raise_os(_T("Region.CombineRgn"));
  }

  inline ~Region() { 
    if(handle) if(!DeleteObject(handle)) warning_os(_T("Region.DeleteObject"));
  }
};

#endif