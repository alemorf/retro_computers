#include <vinlib/std.h>
#include "asm.h"

extern bool step2;
extern int writePos;
extern char writeBuf[65536];

struct Label {
  string name;
  int addr;

  inline Label(string _name="", int _addr=0) { name=_name; addr=_addr; }
};

extern std::vector<Label> labels;

void write(void* data, int n);
void write(int n);

inline void writeExt(Arg& a) {
  if(a.needExt1) 
    write(a.ext - (a.subip ? writePos+2 : 0) );
}

inline void write(int n, Arg& a) {
  write(n);
  writeExt(a);
}

inline void write(int n, Arg& a, Arg& b) {
  write(n);
  writeExt(a);
  writeExt(b);
}
