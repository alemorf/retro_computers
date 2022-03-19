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

LRESULT CALLBACK wndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
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
      int n = min(rect.right/192, rect.bottom/102);
      g.DrawImage(bmp2, (rect.right-192*n)/2, (rect.bottom-102*n)/2, 192*n, 102*n);
    }
    EndPaint(hWnd, &ps);
    return 0;
  }
  return DefWindowProc(hWnd, message, wParam, lParam);
}

void v(const wchar_t* f1, const char* f2) {
  Gdiplus::Bitmap bmp(f1);
  //bmp.FromFile(f1);

  Gdiplus::Graphics g(bmp2);
  g.Clear(Gdiplus::Color(0,0,0));
  
  std::vector<char> data;
    int bl=0;
    for(int y=0; y<bmp.GetHeight(); y+=2) {
      //data.push_back(0);
      int lc=0;
      int v = data.size();
      int prevcl=-1;
      for(int x=0; x<bmp.GetWidth(); x+=3) {
        int c[3][2];
        //int clv[6], clvr[6], clc[6];
        //int cln=0;
        int rc=0, fc=0, c1=0;
        for(int sy=0; sy<2; sy++)
          for(int sx=0; sx<3; sx++) {
            Gdiplus::Color clr;
            bmp.GetPixel(x+sx, y+sy, &clr);
            c1 = int(clr.GetRed()) | (int(clr.GetGreen()) << 8) | (int(clr.GetBlue()) << 16);
            int cc1=c1;
            //int c1r = c1;
            if(c1==0) c1=0; else
            if(c1==0x606060) c1=0x80, bl=1; else
            if(c1==0x006060) c1=0x81, bl=1; else
            if(c1==0x606000) c1=0x84, bl=1; else
            if(c1==0x600000) c1=0x8C, bl=1; else
            if(c1==0x006000) c1=0x85, bl=1; else
            if(c1==0x000060) c1=0x89, bl=1; else
            if(c1==0x600060) c1=0x88, bl=1; else
            if(c1==0xFF8000) c1=0xA0, bl=0; else
            if(c1==0x0080FF) c1=0xA1, bl=0; else
            if(c1==0xFFFFFF) c1=0x80, bl=0; else
            if(c1==0x00FFFF) c1=0x81, bl=0; else
            if(c1==0xFFFF00) c1=0x84, bl=0; else
            if(c1==0xFF0000) c1=0x8C, bl=0; else
            if(c1==0x00FF00) c1=0x85, bl=0; else
            if(c1==0x0000FF) c1=0x89, bl=0; else
            if(c1==0xFF00FF) c1=0x88, bl=0; else { /*MessageBox(0,hex(c1).c_str(),"",0);*/ bl=0, c1=0; /*, c1r=0; /*dc.setPixel(x+sx,y+sy,c1r);*/ }

            if(c1) rc = cc1;
            if(c1) fc = c1;
            c[sx][sy] = c1;
            /* 
            if(c1!=0) {
              int j;
              for(j=0; j<cln; j++) {
                if(clv[j]==c1) {
                  clc[j]++;
                  break;
                }
              }
              if(j==cln) {
                clv[cln] = c1;
                clvr[cln] = c1r;
                clc[cln] = 1;
                cln++;
              }
            }*/
            //raise("Color limit. "+i2s(x)+":"+i2s(y)+"-"+i2s(x+2)+":"+i2s(y+1));
          }
          
          /*
        int fc=0, fcr=0;
        if(cln>=1) {
          int m=0;
          for(int i=0; i<cln; i++)
            if(clc[i]>m) { 
              m=clc[i];
              fc=clv[i]; 
              fcr=clvr[i]; 
            }
          for(int sy=0; sy<2; sy++)
            for(int sx=0; sx<3; sx++) 
              if(c[sx][sy]!=0) {
                c[sx][sy]=fc;
                //dc.setPixel(x+sx,y+sy,fcr);
              }
        }
        */

        Gdiplus::Color c0(rc&0xFF, (rc>>8)&0xFF, (rc>>16)&0xFF);
        for(int sy=0; sy<2; sy++)
          for(int sx=0; sx<3; sx++)
            if(c[sx][sy])
              bmp2->SetPixel(x+sx, y+sy, c0);


        int chr=0;
        if(c[0][0]!=0) chr |= 1;
        if(c[1][0]!=0) chr |= 2;
        if(c[2][0]!=0) chr |= 4;
        if(c[0][1]!=0) chr |= 8;
        if(c[1][1]!=0) chr |= 16;
        if(c[2][1]!=0) chr |= 32;

        if(chr!=0 && prevcl!=fc) {
          data.push_back((fc==0xA0 || fc==0xA1) ? 0x8D : fc);
          lc++;
          prevcl=fc; 
        }
        data.push_back(bl ? 0 : chr);
      }
      if(y<12) {
        int cl = colors(data, v, 36/3, 3, 0x80);
        cl = colors(data, v+36/3+3, 0, 13, cl);
      } else 
      if(y>=12 && y<=83) {
        int cl = colors(data, v, 14, 4, 0x80);
        cl = colors(data, v+14+4, 9*4, 9, cl);
        cl = colors(data, v+14+4+9*5, 0, 3, cl);
      } else {
        int cl = colors(data, v, 112/3, 7, 0x80);
        cl = colors(data, v+112/3+7, 0, 9, cl);
      }
//      while(data.size()>1 && data[data.size()-1]==0)
//        data.pop_back();
     // if(cl!=0xFF && prevcl!=0x80) { 
     //   data.insert(data.end()-1, 0x80); 
     //   prevcl=0x80; 
     // }
      //data.push_back(0xFF);
    }  
    //data.push_back(254);


    string s;
    for(int i=0; i<data.size(); i++) {
      if(i%16==15) s += "\r\n";
      s += "0x"+hex(data[i] & 0xFF)+",";
    }
    saveFile(f2, fcmCreateAlways, s); 

    s="";
    int j=0;
    for(int i=0; i<data.size(); i++) {
      s += "0x";
      if((unsigned char)data[i] < 16) s += "0";
      s += hex(data[i] & 0xFF)+",";
      j++;
      if(j==80) j=0, s += "\r\n";
    }
    saveFile("Screen.txt", fcmCreateAlways, s); 
}

void error(Exception* e, const char* fn) {
	FatalAppExit(0, e->what());
}

int cmain(int, const char**) {
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

  v(L"game.BMP", "game.c");

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