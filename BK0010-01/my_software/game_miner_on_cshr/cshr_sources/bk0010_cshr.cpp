#include "stdafx.h"
#include "vinlib/std.h"
#include "vinlib/file.h"
#include "vinlib/findfiles.h"
#include "vinlib/exec.h"
#include "vinlib/parser.h"
#include <assert.h>
#include <stdafx.h>
#include "asm.h"
#include "output.h"
#include "bitmap.h"
#include "win2koi.h"
#include "cshl.h"
#include "src.h"

// Не выводим предуспреждения
void warning(cstring) {}
void fatal(Exception* e, const char* fn) { FatalAppExit(1, fn); }

void compileLine2() {
retry:
  ParserLabel l = p.label();
  p.nextToken();
  bool label = 0==strcmp(p.tokenText, ":");
  bool equ   = 0==strcmp(p.tokenText, "equ");
  p.jump(l);

  if(label) {
    p.needIdent();
    if(!step2) labels.push_back(Label(p.buf, writePos));
    p.needToken(":");
    goto retry;
  }

  if(equ) {    
    string name = p.needIdent(); 
    p.needToken("equ");
    readAddr1();
    if(!step2) labels.push_back(Label(name, p.bufInt));
    return;
  }

  if(p.ifToken("org")) {
    writePos = p.needInteger();
    if(writePos<0 || writePos>=65536) p.syntaxError();
    return;
  }

  if(p.ifToken("include")) {
    string fileName = p.needString2();
    p.needToken(";");
    p.include();
    p.loadFromString(loadStringFromFile(fileName).c_str(), fileName.c_str(), true);
    p.token = ttOperator;
    strcpy(p.tokenText, ";");
    return;
  }

  if(p.ifToken("make_bk0010_rom")) {
    string fileName = p.needString2();
    p.needToken(",");
    int start = needAddr();
    p.needToken(",");
    int stop = needAddr();
    if(step2) {
      if(stop<=start || start<0 || stop>=65536) p.syntaxError();
      File f;
      f.openC(fileName,fcmCreateAlways);
      int l = stop-start;
      f.write(&start, 2);
      f.write(&l, 2);
      f.write(writeBuf+start, l);
    }
    return;
  }

  if(p.ifToken("insert_file")) {
    string fileName = p.needString2();
    p.needToken(",");
    int start = needAddr();
    p.needToken(",");
    int size = needAddr();
    if(step2) {
      if(size<0 || writePos+size>=65536) p.syntaxError();
      File f;
      f.openR(fileName);
      f.setPosition(start);
      f.read(writePos+writeBuf, size);
    }
    writePos += size;
    return;
  }

  if(p.ifToken("align")) {
    int n = p.needInteger();
    if(n<1) p.syntaxError();
    writePos = (writePos+n-1)/n*n;
    return;
  }

  if(parse_insert_bitmap()) return;

  if(p.ifToken("db")) {
    while(true) {
      if(readAddr1()) {
        if(p.ifToken("dup")) {
          int c = p.bufInt;
          p.needToken("(");
          int d = needAddr();
          if(d<0 || d>255) p.syntaxError();
          p.needToken(")");
          for(;c>0; c--) write(&d, 1);
        } else {
          if(p.bufInt<0 || p.bufInt>255) p.syntaxError();
          write(&p.bufInt, 1);
        }
      } else {
        p.needString2();
    	  win2koi(p.buf);
        write(p.buf, strlen(p.buf));
      }
      if(!p.ifToken(",")) break;
    }
    return;
  }

  if(p.ifToken("dw")) {
    while(true) {
      needAddr();
      if(p.ifToken("dup")) {
        int c = p.bufInt;
        p.needToken("(");
        int d = needAddr();
        if(d<0 || d>65535) p.syntaxError();
        p.needToken(")");
        for(;c>0; c--) write(&d, 2);
      } else {
        if(p.bufInt<0 || p.bufInt>65535) p.syntaxError();
        write(&p.bufInt, 2);
      }
      if(!p.ifToken(",")) break;
    }
    return;
  }

  if(p.ifToken("asm")) {
    parse_asm();
    return;
  }

  parse_cshl();
}

int main(const char* arg) {
  if(arg[0]==0) {
    MessageBox(0,"В командной строке необходимо указать имя файла.\n\nАссемблер БК0010. Альфа-версия 7-03-2012. (с) vinxru",0,0);
    return 0;
  }

  p.caseSel = false;
  static const char* asmRem[] = { "//", 0 };
  p.rem = asmRem;
  static const char* asmOp[] = { "//", "==", "!=", "<=", ">=", ">>", "<<", "--", "++", "!&", 0 };
  p.operators = asmOp;
  p.loadFromString(loadStringFromFile(arg).c_str(), arg);
  ParserLabel l = p.label();

  writePos = 0;
  step2 = false;
  while(!p.ifToken(ttEof)) {
    compileLine2();
    p.needToken(";");
  }

  p.jump(l);

  writePos = 0;
  step2 = true;
  while(!p.ifToken(ttEof)) {
    compileLine2();
    p.needToken(";");
  }

  return 0;
}          