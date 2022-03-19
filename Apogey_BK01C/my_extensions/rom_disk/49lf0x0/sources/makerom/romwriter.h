// ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
// (с) 5-12-2011 vinxru

#include "vinlib/types.h"

class RomWriter {
public:
  std::vector<byte_t> buf;
  unsigned int ptr;

  void alloc(int s);
  void put(const void* buf, unsigned int len);
  bool put_ne(const void* buf, unsigned int len);
  void randomPut(unsigned int ptr, const void* buf, unsigned int len);
  bool _int(unsigned int& ptr, const void* buf, unsigned int len);

  inline void put(const std::vector<byte_t>& data) { if(data.size()>0) put(&data[0], data.size()); }
};

