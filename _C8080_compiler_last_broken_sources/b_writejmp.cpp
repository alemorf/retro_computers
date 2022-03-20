#include <stdafx.h>
#include "b.h"

void writeJmp(bool swap, bool inverse, Operator o, int l) {  
  if(inverse) {
    switch(o) {
      case oE:  o = oNE; break;
      case oNE: o = oE;  break;
      case oG:  o = oLE; break;
      case oGE: o = oL;  break;
      case oL:  o = oGE; break;
      case oLE: o = oG;  break;
    }
  }
  if(!swap) {
    switch(o) {
      case oGE: o = oLE; break;
      case oG:  o = oL;  break;
      case oL:  o = oG;  break;
      case oLE: o = oGE; break;
    }
  }
  switch(o) {
    case oE:  out.jcc(Assembler::JZ,    l); break;
    case oNE: out.jcc(Assembler::JNZ,   l); break;
    case oL:  out.jcc(Assembler::JC,    l); break;
    case oGE: out.jcc(Assembler::JNC,   l); break;
    case oLE: out.jcc(Assembler::JZC,   l); break;
    case oG:  out.jcc(Assembler::JZNC,  l); break;
    default: assert(0);
  }
}
