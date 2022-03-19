// ROM-диск Апогей БК01 на основе стандартных ПЗУ
// (с) 6-12-2011 vinxru

#include "vinlib/types.h"

class RomWriter {
public:
  std::vector<byte_t> buf;
  uint ptr;
  uint loader0size;

  void alloc(int s);
  void put(const void* buf, uint len);
  bool put_ne(const void* buf, uint len);
  void randomPut(uint ptr, const void* buf, uint len);
  bool _int(uint& ptr, const void* buf, uint len);

  inline void randomPut(uint ptr, const std::vector<byte_t>& data) { if(data.size()>0) randomPut(ptr, &data[0], data.size()); }
  inline void put(const std::vector<byte_t>& data) { if(data.size()>0) put(&data[0], data.size()); }
};

