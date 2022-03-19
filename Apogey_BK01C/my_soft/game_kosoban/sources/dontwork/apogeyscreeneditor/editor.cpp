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

Gdiplus::Bitmap* bmp2;
char font[128*8];
char scr[64*64*2];
int cx=0, cy=0, cx1=0, cy1=0;
HBRUSH transBrush;
HPEN cursorPen;
bool firstNum;
int firstNum_v;
char clipboard[64*64*2];
int clipboardW, clipboardH;
bool hilight;

void save() {
  { int h = _lcreat("scr.bin",0);
    _lwrite(h, scr, 64*64*2);
    _lclose(h);
  }
  int prevC=0x80;
  string buf;
  for(int y=0; y<9; y++) {
    int sc = prevC;
    std::vector<unsigned char> d;
    for(int x=0; x<8; x++)
      d.push_back(0);
    for(int x=0; x<64; x++) {
      if(scr[x+y*64]!=0) {
        int c = ((unsigned char)scr[x+y*64+64*64] & 0x9F) | 0x80;
        if(c!=prevC) {
          d.push_back(c);
          prevC=c;
        }
      }
      d.push_back((unsigned char)scr[x+y*64]);
    }
    for(int x=0; x<6; x++)
      d.push_back(0);

    for(int s=1; d.size()<94; s+=2) {
      if(d[s]>=0x80) { sc=d[s]; continue; }
      d.insert(d.begin()+s, sc);
    }
    for(int i=0; i<d.size(); i++) {
      buf += i2s(d[i]);
      buf += ",";
    }
    buf += "\r\n";
  }      
  { int h = _lcreat("scr.c",0);
    _lwrite(h, buf.c_str(), buf.size());
    _lclose(h);
  }
}

LRESULT CALLBACK wndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
  if(message==WM_ERASEBKGND)
    return 0;
  if(message==WM_PAINT) {
    PAINTSTRUCT ps;
    BeginPaint(hWnd, &ps);
    Bitmap bmp;
    bmp.create(64*6, 54*4);
    for(int y=0; y<52; y++)
      for(int x=0; x<64; x++) {
        int bg = (hilight && ((x^y)&1)!=0 ? 0x202020 : 0);
        int *c = (int*)bmp.ptr32 + (bmp.height-4-y*4)*bmp.width + x*6;
        char* s = font + scr[x+y*64]*8;
        int a = (unsigned char)scr[x+y*64+64*64];
        int cl=0xFFFFFF;
        bool inv = (a&0x10); a&=~0x10;
        switch(a) {
          case 0x81: cl=0x00FFFF; break; // cyan 3
          case 0x88: cl=0xFF00FF; break;
          case 0x84: cl=0xFFFF00; break;
          case 0x89: cl=0x0000FF; break;
          case 0x85: cl=0x00FF00; break;
          case 0x8C: cl=0xFF0000; break;
        }        
        if(inv) std::swap(cl, bg);
        for(int cy=0; cy<4; cy++)
          for(int cx=0; cx<6; cx++)
            c[cx+cy*bmp.width] = s[3-cy] & (0x20 >> cx) ? cl : bg;
      }
    auto cdc = CreateCompatibleDC(ps.hdc);
    auto o = SelectObject(cdc, bmp.handle);
    
    RECT r;
    GetClientRect(hWnd, &r);
    int k = min(r.right/bmp.width, r.bottom/bmp.height);
    StretchBlt(ps.hdc, 0, 0, bmp.width*k, bmp.height*k, cdc, 0, 0, bmp.width, bmp.height, SRCCOPY);
    SelectObject(ps.hdc, transBrush);
    SelectObject(ps.hdc, cursorPen);
    int x0=cx, x1=cx1;
    if(x0>x1) std::swap(x0,x1);
    int y0=cy, y1=cy1;
    if(y0>y1) std::swap(y0,y1);
    Rectangle(ps.hdc, x0*6*k-1, y0*4*k-1, (x1+1)*6*k, (y1+1)*4*k);
    SelectObject(cdc, o);
    DeleteDC(cdc);
    EndPaint(hWnd, &ps);
    return 0;
  }
  if(message==WM_KEYDOWN) {
    bool c = (GetKeyState(VK_CONTROL)&0x80)!=0;
    bool v = (GetKeyState(VK_SHIFT)&0x80)!=0;
    if(hilight!=v) { hilight=v; InvalidateRect(hWnd,0,1); }
    if(c) {
      switch(wParam) {
        case 'Q': scr[cx+cy*64]--; save(); InvalidateRect(hWnd,0,1); break;
        case 'W': scr[cx+cy*64]++; save(); InvalidateRect(hWnd,0,1); break;
        case 'C': {
          int x0=cx, x1=cx1;
          if(x0>x1) std::swap(x0,x1);
          int y0=cy, y1=cy1;
          if(y0>y1) std::swap(y0,y1);
          clipboardW = x1-x0+1;
          clipboardH = y1-y0+1;
          for(int iy=y0; iy<=y1; iy++)
            for(int ix=x0; ix<=x1; ix++) {
              clipboard[ix-x0+(iy-y0)*64] = scr[ix+iy*64];
              clipboard[ix-x0+(iy-y0)*64+64*64] = scr[ix+iy*64+64*64];
            }
          break;
        }
        case 'V': {
          for(int iy=0; iy<clipboardH; iy++)
            for(int ix=0; ix<clipboardW; ix++) {
              scr[ix+cx+(iy+cy)*64] = clipboard[ix+iy*64];
              scr[ix+cx+(iy+cy)*64+64*64] = clipboard[ix+iy*64+64*64];
            }
          InvalidateRect(hWnd,0,1);
          break;
        }
        case 'S': save(); MessageBox(0,"saved","",0); return 0;
      }
      return 0;
    }
    if((wParam>='0' && wParam<='9') || (wParam>='A' && wParam<='H')) {
      int n = wParam-'0';
      if(n>=10) n-='A'-'0'-10;
      if(!firstNum) { firstNum=true, firstNum_v=n; return 0; }
      firstNum = false;
      n = firstNum_v*16 + n;

      int x0=cx, x1=cx1;
      if(x0>x1) std::swap(x0,x1);
      int y0=cy, y1=cy1;
      if(y0>y1) std::swap(y0,y1);
      for(int iy=y0; iy<=y1; iy++)
        for(int ix=x0; ix<=x1; ix++) {
          if(n<128) scr[ix+iy*64] = n; else
          if(n>=0x80 && n<0xC0) scr[ix+iy*64 + 64*64] = n;
        }
//      save();
      InvalidateRect(hWnd,0,1);
      return 0;
    }
    switch(wParam) {
      case 'Q': scr[cx+cy*64]--; InvalidateRect(hWnd,0,1); break;
      case 'W': scr[cx+cy*64]++; InvalidateRect(hWnd,0,1); break;
//      case 'E': scr[64*64+cx+cy*64]--; InvalidateRect(hWnd,0,1); break;
      //case 'R': scr[64*64+cx+cy*64]++; InvalidateRect(hWnd,0,1); break;
      case VK_UP:    cy--; InvalidateRect(hWnd,0,1);  break;
      case VK_DOWN:  cy++; InvalidateRect(hWnd,0,1); break;
      case VK_LEFT:  cx--; InvalidateRect(hWnd,0,1); break;
      case VK_RIGHT: cx++; InvalidateRect(hWnd,0,1); break;
    }
    SetWindowText(hWnd, ("x="+i2s(cx)+" y="+i2s(cy)+" char="+i2s(scr[cx+cy*64])).c_str());
    if(!v) cx1=cx, cy1=cy;
  }
  return DefWindowProc(hWnd, message, wParam, lParam);
}


void error(Exception* e, const char* fn) {
	FatalAppExit(0, e->what());
}


int cmain(int, const char**) {
  { int h = _lopen("SYMGEN.BIN",0);
    _llseek(h, 0x2400, 0);
    _lread(h, font, 128*8);
    _lclose(h);
  }

  { int h = _lopen("scr.bin",0);
    _lread(h, scr, 64*64*2);
    _lclose(h);
  }

  LOGBRUSH b;
  b.lbStyle = BS_NULL;
  b.lbColor = 0;
  b.lbHatch = 0;
  transBrush = CreateBrushIndirect(&b);

  cursorPen = CreatePen(PS_SOLID, 0, 0xFFC080);
  
  Gdiplus::GdiplusStartupInput gdiplusStartupInput; 
  ULONG_PTR gdiplusToken; 
  Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

  bmp2 = new Gdiplus::Bitmap(192, 102);

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

  while(true) {
    MSG msg;
    bool r=GetMessage(&msg, NULL, 0, 0)!=0;
    if(!r) break;
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
  
  return 0;
}