#include <stdafx.h>
#include <vinlib/bitmap.h>
#include <vinlib/_gdi.h>

void Bitmap::checkSize(int w, int h) {
  if(h<=0 || w<=0 || w>=32767 || h>=32767)
    raise(_T("Bitmap.create: Некорректынй размер"));
}

void Bitmap::create(int w, int h, bool _alpha) {
  free();

  checkSize(w, h);
  
  BITMAPINFO bmi;
  ZeroMemory(&bmi, sizeof(BITMAPINFO));
  bmi.bmiHeader.biSize        = sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth       = w;
  bmi.bmiHeader.biHeight      = h;
  bmi.bmiHeader.biPlanes      = 1;
  bmi.bmiHeader.biBitCount    = 32; 
  bmi.bmiHeader.biCompression = BI_RGB;
  bmi.bmiHeader.biSizeImage   = bmi.bmiHeader.biWidth * bmi.bmiHeader.biHeight * 4;

  DCDisplay dcd;
  DCCompatible cdc(dcd.hdc);

  ptr32 = 0;
  handle = CreateDIBSection(cdc.hdc, &bmi, DIB_RGB_COLORS, &ptr32, NULL, 0x0);
  if(handle==0) raise_os(_T("Bitmap.create: CreateDIBSection"));
  if(ptr32==0) { DeleteObject(handle); handle=0; raise(_T("Bitmap.create: CreateDIBSection ptr32=0")); }

  BEGIN_NO_EXCEPTION
    width  = w;
    height = h;
    alpha  = _alpha;
  END_NO_EXCEPTION
}

void Bitmap::saveRGB32(std::vector<char>& data) const {
  data.resize(width * height * 4);

  // Быстрое копирование
  if(ptr32) {
    memcpy(&(data[0]), ptr32, data.size());
    return;
  }

  BITMAPINFO info;
  info.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
  info.bmiHeader.biWidth         = width;
  info.bmiHeader.biHeight        = height;
  info.bmiHeader.biPlanes        = 1;
  info.bmiHeader.biBitCount      = 32;
  info.bmiHeader.biSizeImage     = data.size();
  info.bmiHeader.biXPelsPerMeter = 1;
  info.bmiHeader.biYPelsPerMeter = 1;

  DCDisplay dcd;
  if(GetDIBits(dcd.hdc, handle, 0, height, &(data[0]), &info, DIB_RGB_COLORS)==0) raise_os(_T("GetDIBits"));
}

//---------------------------------------------------------------------------
// Используется в Bitmap.resize

static void copyBits(Bitmap& to, const Bitmap& from, int x, int y, int w, int h, int sx, int sy) {
  if(w<=0 || h<=0) return;

  if(x<0) w+=x, sx-=x, x=0;
  if(y<0) h+=y, sy-=y, y=0;
  if(sx<0) w+=sx, x-=sx, sx=0;
  if(sy<0) h+=sy, y-=sy, sy=0;

  if(x>=to.width) return;
  if(y>=to.height) return;
  if(sx>=from.width) return;
  if(sy>=from.height) return;

  if(x+w>to.width) w=to.width-x;
  if(y+h>to.height) h=to.height-y;
  if(sx+w>from.width) w=from.width-sx;
  if(sy+h>from.height) h=from.height-sy;

  y=to.height-y-h;
  sy=from.height-sy-h;

  int w4 = w*4;
  int tbpl = to.width*4;
  int fbpl = from.width*4;
  byte_t* t = (byte_t*)to.ptr32 + y*tbpl + x*4;
  byte_t* f = (byte_t*)from.ptr32 + sy*fbpl + sx*4;
  while(h>0) {
    memcpy(t, f, w4);
    t += tbpl;
    f += fbpl;    
    h--;
  }
}

/*void Bitmap::resize(int w, int h) {
  if(!able()) {
    create(w,h);
    return;
  }

  checkSize(w, h);

  // Создание нового
  Bitmap n;
  n.create(w, h, alpha);

  if(ptr32 && n.ptr32) copyBits(n, *this, 0, 0, w, h, 0, 0);
                  else DC(n).copy(0,0,*this);

  swap(n);
}*/

void Bitmap::loadRGB(const void* data, int size, int bpp) {
  BITMAPINFO h;
  memset(&h, 0, sizeof(h));
  h.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
  h.bmiHeader.biWidth         = width;
  h.bmiHeader.biHeight        = height;
  h.bmiHeader.biPlanes        = 1;
  h.bmiHeader.biBitCount      = bpp;
  h.bmiHeader.biSizeImage     = size;
  h.bmiHeader.biXPelsPerMeter = 1;
  h.bmiHeader.biYPelsPerMeter = 1;

  DCDisplay dcd;
  if(!SetDIBits(dcd.hdc, handle, 0, height, data, &h, DIB_RGB_COLORS))
    raise_os(_T("SetBitmapBits"));
}

void Bitmap::free() {
  BEGIN_NO_EXCEPTION
    width  = 0;
    height = 0;
    alpha  = 0;
    ptr32  = 0;

    if(handle) { 
      if(!DeleteObject(handle)) warning_os(_T("Bitmap.DeleteObject"));
      handle = 0; 
    }
  END_NO_EXCEPTION_ADDR("Bitmap.free");
}

Bitmap::~Bitmap() {
  BEGIN_NO_EXCEPTION
    free();
  END_NO_EXCEPTION_ADDR("~Bitmap");
}

