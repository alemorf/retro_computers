#ifndef VINLIB_BITMAP_H
#define VINLIB_BITMAP_H

#include <vinlib/std.h>

class Bitmap {
protected:
  inline void _init() { width=height=0; handle=0; alpha=false; ptr32=0; }
  void checkSize(int w, int h);

public:
  int     width;
  int     height;
  HBITMAP handle;
  bool    alpha;
  void*   ptr32;

  inline Bitmap() {
    _init(); 
  }

  inline Bitmap(int id) { 
    _init(); 
    try {
      void loadBitmapFromResource(Bitmap& bmp, int id); // Если мы не используем этот конструктор, то не требуется подключать loadimage.cpp
      loadBitmapFromResource(*this, id);
    } catch(...) {
      free();
      throw; 
    } 
  }

  inline Bitmap(int width, int height, const void* buf, int bufSize) {
    _init();
    try {
      create(width,height,false);
      loadRGB(buf,bufSize,24);
    } catch(...) {
      free();
      throw;
    }
  }

  inline void swap(Bitmap& a) {
    std::swap(width,  a.width);
    std::swap(height, a.height);
    std::swap(handle, a.handle);
    std::swap(alpha,  a.alpha);
    std::swap(ptr32,  a.ptr32);
  }

  inline bool able() {
    return handle!=0; 
  }

  void create(int w, int h, bool alpha=false);
  void resize(int w, int h);
  void saveRGB32(std::vector<byte_t>& data) const;
  void loadRGB(const void* data, int size, int bpl);
  void loadRGB(std::vector<byte_t>& d, int bpl) { loadRGB(&d[0], d.size(), bpl); }
  inline void loadRGB(const std::vector<byte_t>& data, int bpl) { loadRGB(&data[0], data.size(), bpl); }
  void free();
  ~Bitmap();
};

#endif