// vinxru

#include "stdafx.h"
#include "vinlib/std.h"
#include "vinlib/file.h"
#include "vinlib/findfiles.h"
#include "vinlib/exec.h"
#include "vinlib/console.h"
#include "vinlib/bitmap.h"
#include <assert.h>

#include <gdiplus.h>
#pragma comment(lib, "gdiplus.lib") 

Gdiplus::Bitmap* bmp2;
bool mode_colors, mode_pack;

//#include "encodepng.h"

// Не выводим предуспреждения
void warning(cstring) {}
void fatal(Exception* e, const char* fn) { FatalAppExit(1, fn); }

string appPath;

void error(const Exception* e, const char_t* inFunction) throw() {
  if(e) FatalAppExit(-1, e->what());
   else FatalAppExit(-1, _T("?"));
}

void fatal(const Exception* e, const char_t* inFunction) throw() {
  if(e) FatalAppExit(-1, e->what());
   else FatalAppExit(-1, _T("?"));
}

//void warning(cstring text) {
//}


bool kill;

#pragma pack(push, 1)

int colors(std::vector<char>& data, int s, int pc, int need, int cl0) {
  int lc=0, rcl=0x80;
  for(int y=s; y<(pc ? s+pc+lc : data.size()); y++)
    if(data[y]&0x80)  {
      lc++;
      rcl = data[y];
    }

  if(lc>need) 
    raise("xxx");
    
  for(;lc<need;) {
    int cl = cl0;
    for(int y=s; y<(pc ? s+pc+lc : data.size()); y++) {
      if(data[y] & 0x80) cl = data[y];
      if((y==s || (data[y-1] & 0x80)==0) && (data[y] & 0x80)==0) {
        data.insert(data.begin()+y, cl);
        lc++;
        goto ok;
      }
    }
    raise("No space");
ok:;
  }
  return rcl;
}

std::wstring toUnicode(const char* src) {
  int s=MultiByteToWideChar(CP_ACP, 0, src, -1, 0, 0);
  std::wstring wc;
  wc.resize(s); 
  MultiByteToWideChar(CP_ACP, 0, src, -1, (LPWSTR)wc.c_str(), s);
  return wc;
}

void pack(cstring f2, std::vector<char>& data) {
  string f3 = f2+".tmp1";
  string f4 = f2+".tmp2";
  saveFile(f3, fcmCreateAlways, data);
  DeleteFile(f4.c_str());
  exec("MegaLZ.exe", (f3+" "+f4).c_str());
  DeleteFile(f3.c_str());
  loadFile(data, f4);
  DeleteFile(f4.c_str());
}

void bin2inc(string& s, cstring name, cstring f2, std::vector<char>& data) {
  if(mode_pack) pack(f2, data);
  s += "uchar "+name+"["+i2s(data.size())+"] = {\r\n";
  int j=0;
  for(int i=0; i<data.size(); i++) {
    s += "0x";
    if((unsigned char)data[i] < 16) s += "0";
    s += hex(data[i] & 0xFF)+",";
    j++;
    if(j==16) j=0, s += "\r\n";
  }
  if(0!=strcmp(s.c_str()+s.size()-2, "\r\n"))
    s += "\r\n";
  s += "};\r\n";
}

uint cd[] = {
  0xFF000000,
  0xFF000080,
  0xFF008000,
  0xFF008080,
  0xFF800000,
  0xFF800080,
  0xFF808000,
  0xFF808080,
  0xFF000000,
  0xFF0000FF,
  0xFF00FF00,
  0xFF00FFFF,
  0xFFFF0000,
  0xFFFF00FF,
  0xFFFFFF00,
  0xFFFFFFFF,
};

void v(const char* f1, const char* f2, const char* name) {
  wchar_t n[256];
  Gdiplus::Bitmap bmp(toUnicode(f1).c_str());
  
  std::vector<char> data;
  std::vector<char> data2;
  int bl=0;
  int pcc=0;
  for(int x=0; x<bmp.GetWidth(); x+=8) {
    int lc=0;
    int v = data.size();
    int prevcl=-1;
    for(int y=0; y<bmp.GetHeight(); y++) {
      int d = 0, ca = -1, cb = -1;
      Gdiplus::Color clr1;
      for(int sx=0; sx<8; sx++) {
        Gdiplus::Color clr;
        bmp.GetPixel(x+sx, y, &clr);
        int c1;
        switch(clr.GetValue() & 0xFFFFFF) {
          case 0xFFFFFF: c1 = 15; break;
          case 0xFFFF00: c1 = 14; break;
          case 0xFF00FF: c1 = 13; break;
          case 0xFF0000: c1 = 12; break;
          case 0x00FFFF: c1 = 11; break;
          case 0x00FF00: c1 = 10; break;
          case 0x0000FF: c1 = 9; break;          
          case 0xC0C0C0: case 0x808080: c1 = 7; break;
          case 0xC0C000: case 0x808000: c1 = 6; break;
          case 0xC000C0: case 0x800080: c1 = 5; break;
          case 0xC00000: case 0x800000: c1 = 4; break;
          case 0x00C0C0: case 0x008080: c1 = 3; break;
          case 0x00C000: case 0x008000: c1 = 2; break;
          case 0x0000C0: case 0x000080: c1 = 1; break;
          default: c1 = 0;
        }
        d <<= 1;
        if(mode_colors) {
          if(c1!=ca && c1!=cb) {
            if(c1==0 && cb==-1) cb=c1; else
            if(ca==-1) ca=c1, d |= 1; else
            if(cb==-1) cb=c1; else
            if(ca!=0) {
              if(c1 < ca) ca = c1;
              d |= 1;
            }
          } else {
            if(c1==ca) d |= 1;
          }
        } else {
          if(c1!=0) d |= 1;
        }
      }
      if(ca==-1) ca=10;
      if(cb==-1) cb=0;
      if(bmp2)
        for(int sx=0; sx<8; sx++) {
          int c = cd[((d & (0x80 >> sx)) ? ca : cb)];          
          bmp2->SetPixel(x+sx, y, Gdiplus::Color((c>>16)&0xFF, (c>>8)&0xFF, c&0xFF));
        }
      pcc = ca + cb*16;
      if(mode_colors) { if(mode_pack) data2.push_back(pcc); else data.push_back(pcc); }
      data.push_back(d);
    }  
  }
  if(f2) {
    // Сжатие
    string s;
    bin2inc(s, name, f2, data);
    if(mode_pack && mode_colors) bin2inc(s, (string)name+"_colors", f2, data2);
    saveFile(f2, fcmCreateAlways, s); 
  }
}

const char* srcFile;

void error(Exception* e, const char* fn) {
	FatalAppExit(0, e->what());
}

__int64 lt;

LRESULT CALLBACK wndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
  if(message==WM_TIMER) {
    WIN32_FIND_DATA fd;
    if(FindFirstFile(srcFile,&fd)) {
      FindClose(&fd);
      if(lt != *(__int64*)&fd.ftLastWriteTime) {
        lt = *(__int64*)&fd.ftLastWriteTime;
          v(srcFile, 0, 0);
        InvalidateRect(hWnd,0,true);
      }
    }
    return 0;
  }
  if(message==WM_ERASEBKGND)
    return 0;
  if(message==WM_PAINT) {
    PAINTSTRUCT ps;
    BeginPaint(hWnd, &ps);
    { Gdiplus::Graphics g(ps.hdc);
      RECT rect;
      GetClientRect(hWnd, &rect);
      g.Clear(Gdiplus::Color(0xC0,0xC0,0xC0));
      g.SetInterpolationMode(Gdiplus::InterpolationModeNearestNeighbor);
      int n = min(rect.right/384, rect.bottom/256);
      g.DrawImage(bmp2, (rect.right-384*n)/2, (rect.bottom-256*n)/2, 384*n, 256*n);
    }
    EndPaint(hWnd, &ps);
    return 0;
  }
  return DefWindowProc(hWnd, message, wParam, lParam);
}

int cmain(int argv, const char** args) {
  Gdiplus::GdiplusStartupInput gdiplusStartupInput; 
  ULONG_PTR gdiplusToken; 
  Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

  while(1) {
    if(argv >= 2 && 0==strcmp(args[1], "-colors")) {
      mode_colors = 1;
      argv--;
      args++;
      continue;
    }
    if(argv >= 2 && 0==strcmp(args[1], "-pack")) {
      mode_pack = 1;
      argv--;
      args++;
      continue;
    }
    break;
  }

  if(argv == 4) {
    v(args[1], args[2], args[3]);
    return 0;
  }

  if(argv == 2) { 
    srcFile = args[1];

    bmp2 = new Gdiplus::Bitmap(384, 256);

    WNDCLASS wnd;
    memset(&wnd, 0, sizeof(wnd));
    WNDCLASS wndclass;
    memset(&wndclass, 0, sizeof(wndclass));
    wndclass.style         = CS_VREDRAW|CS_HREDRAW|CS_DBLCLKS|CS_SAVEBITS;
    wndclass.hInstance     = GetModuleHandle(0);
    wndclass.hIcon         = LoadIcon(0, IDI_APPLICATION);
    wndclass.hCursor       = LoadCursor(0, IDC_ARROW);
    wndclass.hbrBackground = (HBRUSH)COLOR_WINDOW;
    wndclass.lpfnWndProc   = wndProc;
    wndclass.lpszClassName = "WNDPROC";
    if(!RegisterClass(&wndclass)) raise_os(_T("RegisterClass"));

    HWND h = CreateWindow("WNDPROC", "Apogey Color Test", WS_OVERLAPPEDWINDOW|WS_VISIBLE, 100, 100, 640, 480, 0, 0, GetModuleHandle(0), 0);
    if(!h) raise("CreateWindow");

    SetTimer(h, 1, 1000, 0);

    while(true) {
      MSG msg;
      bool r=GetMessage(&msg, NULL, 0, 0)!=0;
      if(!r) break;
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }

  return 0;
}

