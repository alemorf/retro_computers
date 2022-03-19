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

//  if(lc>need) 
//    raise("xxx");
    
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

void putByte(std::vector<char>& data, int ca[3][2], int& cac, int& prevcl, int& lc) {
  int chr=0;
  if(ca[0][0]!=0) chr |= 1;
  if(ca[1][0]!=0) chr |= 2;
  if(ca[2][0]!=0) chr |= 4;
  if(ca[0][1]!=0) chr |= 8;
  if(ca[1][1]!=0) chr |= 16;
  if(ca[2][1]!=0) chr |= 32;

  if(chr!=0 && prevcl!=cac) {
    if(lc<16) {
      data.push_back(cac);
      lc++;
      prevcl=cac; 
    } else {
      chr=0;
      cac=0;
    }
  }
  data.push_back(chr);
}

void v(const wchar_t* f1, const char* f2) {
  Gdiplus::Bitmap bmp(f1);
  Gdiplus::Graphics g(bmp2);
  g.Clear(Gdiplus::Color(0,0,0));  
  std::vector<char> data, data2;
  for(int y=0; y<bmp.GetHeight(); y+=2) {
    int lc=0, lc2=0;
    for(int u=0; u<8; u++) {
      data.push_back(0);
      data2.push_back(0);
    }
    int v = data.size();
    int prevcl=-1, prevcl2=-1;
    for(int x=0; x<bmp.GetWidth(); x+=3) {
      int ca[3][2]; int cac=0;
      int cb[3][2]; int cbc=0;
      for(int xx=0; xx<3; xx++)
        for(int yy=0; yy<2; yy++)
          ca[xx][yy]=cb[xx][yy]=0;

      for(int sy=0; sy<2; sy++)
        for(int sx=0; sx<3; sx++) {
          Gdiplus::Color clr;
          bmp.GetPixel(x+sx, y+sy, &clr);
          int cc1 = int(clr.GetRed()<<16) | (int(clr.GetGreen()) << 8) | (int(clr.GetBlue()));
          int c1, c2;
          if(cc1==0x000000) continue; else
          if(cc1==0xFF0000) c1=0x8C, c2=c1;   else
          if(cc1==0xFF8000) c1=0x8C, c2=0x84; else
          if(cc1==0xFFFF00) c1=0x84, c2=c1;   else
          if(cc1==0x80FF00) c1=0x84, c2=0x85; else
          if(cc1==0x00FF00) c1=0x85, c2=c1;   else
          if(cc1==0x00FF80) c1=0x85, c2=0x81; else
          if(cc1==0x00FFFF) c1=0x81, c2=c1;   else
          if(cc1==0x0080FF) c1=0x81, c2=0x89; else
          if(cc1==0x0000FF) c1=0x89, c2=c1;   else
          if(cc1==0x8000FF) c1=0x89, c2=0x88; else
          if(cc1==0xFF00FF) c1=0x88, c2=c1;   else
          if(cc1==0xFF0080) c1=0x88, c2=0x8C; else
          if(cc1==0x800000) c1=0x8C, c2=0;    else
          if(cc1==0x808000) c1=0x84, c2=0;    else
          if(cc1==0x008000) c1=0x85, c2=0;    else
          if(cc1==0x008080) c1=0x81, c2=0;    else
          if(cc1==0x000080) c1=0x89, c2=0;    else
          if(cc1==0x800080) c1=0x88, c2=0;    else
          if(cc1==0x808080) c1=0x80, c2=0;    else
          if(cc1==0xFF8080) c1=0x8C, c2=0x80; else
          if(cc1==0xFFFF80) c1=0x84, c2=0x80; else
          if(cc1==0x80FF80) c1=0x85, c2=0x80; else
          if(cc1==0x80FFFF) c1=0x81, c2=0x80; else
          if(cc1==0x8080FF) c1=0x89, c2=0x80; else
          if(cc1==0xFF80FF) c1=0x88, c2=0x80; else
          if(cc1==0xFFFFFF) c1=0x80, c2=c1;   else continue;

          int used;
          if(cac==0 || cac==c1) {
            cac = c1;
            ca[sx][sy] = 1;
            used=1;
          } else 
          if(cbc==0 || cbc==c1) {
            cbc = c1;
            cb[sx][sy] = 1;
            used=2;
          } else {
            int x=1;
          }

          if(c2!=0) {
            if(used!=1 && (cac==0 || cac==c2)) {
              cac = c2;
              ca[sx][sy] = 1;
            } else 
            if(used!=2 && (cbc==0 || cbc==c2)) {
              cbc = c2;
              cb[sx][sy] = 1;
            } else {
              int x=1;
            }
          }
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

      putByte(data, ca, cac, prevcl, lc);
      putByte(data2, cb, cbc, prevcl2, lc2);

      if(cac!=0) {
        int ar, ag, ab;
        switch(cac) {
          case 0x80: ar=0x80; ag=0x80; ab=0x80; break;
          case 0x8C: ar=0x80; ag=0x00; ab=0x00; break;
          case 0x84: ar=0x80; ag=0x80; ab=0x00; break;
          case 0x85: ar=0x00; ag=0x80; ab=0x00; break;
          case 0x81: ar=0x00; ag=0x80; ab=0x80; break;
          case 0x89: ar=0x00; ag=0x00; ab=0x80; break;
          case 0x88: ar=0x80; ag=0x00; ab=0x80; break;
          default: raise("x");
        }
        int br, bg, bb;
        switch(cbc) {
          case 0:
          case 0x80: br=0x80; bg=0x80; bb=0x80; break;
          case 0x8C: br=0x80; bg=0x00; bb=0x00; break;
          case 0x84: br=0x80; bg=0x80; bb=0x00; break;
          case 0x85: br=0x00; bg=0x80; bb=0x00; break;
          case 0x81: br=0x00; bg=0x80; bb=0x80; break;
          case 0x89: br=0x00; bg=0x00; bb=0x80; break;
          case 0x88: br=0x80; bg=0x00; bb=0x80; break;
          default: raise("x");
        }

        for(int sy=0; sy<2; sy++)
          for(int sx=0; sx<3; sx++) {
            int r=0, g=0, b=0;
            if(ca[sx][sy]) r += ar, g += ag, b += ab;
            if(cb[sx][sy]) r += br, g += bg, b += bb;
            if(r>255) r=255;
            if(g>255) g=255;
            if(b>255) b=255;
            bmp2->SetPixel(x+sx, y+sy, Gdiplus::Color(r, g, b));
          }
      }

    }
    colors(data, v, 0, 16, 0x80);
    colors(data2, v, 0, 16, 0x80);
    for(int u=0; u<6; u++) {
      data.push_back(0);
      data2.push_back(0);
    }
  }  

  string s;
  for(int i=0; i<data.size(); i++) {
    if(i%16==15) s += "\r\n";
    s += "0x"+hex(data[i] & 0xFF)+",";
  }
  saveFile(f2, fcmCreateAlways, s); 

  s = "0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,\r\n";
  int j=0;
  for(int i=0; i<data.size(); i++) {
    s += "0x";
    if((unsigned char)data[i] < 16) s += "0";
    s += hex(data[i] & 0xFF)+",";
    j++;
    if(j==94) j=0, s += "\r\n";
  }
  s += "0xFF,\r\n";
  s += "0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,0,0xF1,\r\n";
  for(int i=0; i<data2.size(); i++) {
    s += "0x";
    if((unsigned char)data2[i] < 16) s += "0";
    s += hex(data2[i] & 0xFF)+",";
    j++;
    if(j==94) j=0, s += "\r\n";
  }
  s += "0xFF,\r\n";
  saveFile("Screen.txt", fcmCreateAlways, s); 
}

void error(Exception* e, const char* fn) {
	FatalAppExit(0, e->what());
}

__int64 lt;

LRESULT CALLBACK wndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
  if(message==WM_TIMER) {
    WIN32_FIND_DATA fd;
    if(FindFirstFile("game.BMp",&fd)) {
      FindClose(&fd);
      if(lt != *(__int64*)&fd.ftLastWriteTime) {
        lt = *(__int64*)&fd.ftLastWriteTime;
        v(L"game.BMP", "game.c");
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
      int n = min(rect.right/192, rect.bottom/102);
      g.DrawImage(bmp2, (rect.right-192*n)/2, (rect.bottom-102*n)/2, 192*n, 102*n);
    }
    EndPaint(hWnd, &ps);
    return 0;
  }
  return DefWindowProc(hWnd, message, wParam, lParam);
}

int main(const char*) {
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

  SetTimer(h, 1, 1000, 0);

  while(true) {
    MSG msg;
    bool r=GetMessage(&msg, NULL, 0, 0)!=0;
    if(!r) break;
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
  
  return 0;
}