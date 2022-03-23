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

std::wstring toUnicode(const char* src) {
  int s=MultiByteToWideChar(CP_ACP, 0, src, -1, 0, 0);
  std::wstring wc;
  wc.resize(s); 
  MultiByteToWideChar(CP_ACP, 0, src, -1, (LPWSTR)wc.c_str(), s);
  return wc;
}

void v(const char* f1, const char* f2, cstring name) {
  wchar_t n[256];
  Gdiplus::Bitmap bmp(toUnicode(f1).c_str());
  
  std::vector<char> data;
    int bl=0;
    for(int y=0; y<bmp.GetHeight(); y++) {
      //data.push_back(0);
      int lc=0;
      int v = data.size();
      int prevcl=-1;
      for(int x=0; x<bmp.GetWidth(); x+=4) {
        int d = 0;
        for(int sx=0; sx<4; sx++) {
          Gdiplus::Color clr;
          bmp.GetPixel(x+sx, y, &clr);
          int c1;
          if(clr.GetR()==0xFF && clr.GetG()==0x00 && clr.GetB()==0x00) c1=3; else
          if(clr.GetR()==0x00 && clr.GetG()==0xFF && clr.GetB()==0x00) c1=2; else
          if(clr.GetR()==0x00 && clr.GetG()==0x00 && clr.GetB()==0xFF) c1=1; else c1=0, clr=Gdiplus::Color::Black;
          d <<= 1;
          if(c1&1) d |= 0x01;
          if(c1&2) d |= 0x10;
        }
        data.push_back(d);
      }
    }  

    string s="uchar "+name+"["+i2s(data.size())+"] = {\r\n";
    int j=0;
    for(int i=0; i<data.size(); i++) {
      s += "0x";
      if((unsigned char)data[i] < 16) s += "0";
      s += hex(data[i] & 0xFF)+",";
      j++;
      if(j==bmp.GetWidth()/4) j=0, s += "\r\n";
    }
    if(0!=strcmp(s.c_str()+s.size()-2, "\r\n"))
      s += "\r\n";
    s += "};";
    saveFile(f2, fcmCreateAlways, s); 
}

void error(Exception* e, const char* fn) {
	FatalAppExit(0, e->what());
}

int cmain(int argv, const char** args) {
  Gdiplus::GdiplusStartupInput gdiplusStartupInput; 
  ULONG_PTR gdiplusToken; 
  Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

  if(argv!=4) FatalAppExit(1, "Error");
  v(args[1], args[2], args[3]);

  return 0;
}