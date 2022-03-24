#include <stdafx.h>
#include "cshl.h"
#include "asm.h"
#include "src.h"
#include "output.h"

struct SimpleCommand {
  const char* name;
  int code;
};

struct ImmCommand {
  const char* name;
  int code, max;
};

std::vector<int> downAddr1;
int downAddrN1;

struct IfCommand {
  const char* name;
  int cmp, jmp_g, jmp_oc;
  int jmp_ug, jmp_uoc;
};

static IfCommand ifCmds[] = {
  //     cmp     goto   {}
  "&",   030000, 00010, 00014, 00010, 00014, 
  "!=",  020000, 00010, 00014, 00010, 00014,  
  "==",  020000, 00014, 00010, 00014, 00010,
  ">=",  020000, 00020, 00020, 01030, 01034, // nc
  "<",   020000, 00024, 00024, 01034, 01030, // c
  ">",   020000, 00030, 00030, 01010, 01014, // nc&nz
  "<=",  020000, 00034, 00034, 01014, 01010,// !(nc&nz)
  0 
};

// 4-5=c+nz 4-4=nc+z 5-4=nc+nz.


struct If {
  int n;
  int argSize;
  Arg a, b;
  bool neg;
  bool uns;
};

void parse_if(If& i) {
  i.uns = p.ifToken("unsigned");
  i.neg = false;
  i.argSize = 0;
  readArg(i.a, i.argSize);
  i.n = p.needToken(ifCmds);
  readArg(i.b, i.argSize);
  if(ifCmds[i.n].cmp == 030000) {
    if(p.ifToken("==")) {
      p.needToken("#");
      if(p.needInteger()!=0) p.syntaxError();
      i.neg = true;
    }
  }
}

void asmIf(If& i, int addr) {
  IfCommand& cmd = ifCmds[i.n];
  write((i.argSize==1 ? 0100000 : 0) | cmd.cmp | (i.a.code<<6) | i.b.code, i.a, i.b);
  asmJmp(i.uns ? (i.neg ? cmd.jmp_uoc : cmd.jmp_ug) : (i.neg ? cmd.jmp_oc : cmd.jmp_g), addr);
}

void parse_block() {
  if(p.ifToken("{")) {
      while(!p.ifToken("}")) {
        compileLine2();
        p.needToken(";");
      }
    } else {
      compileLine2();
    }
}

int breakLabel = -1;

void allocLabel(int& a, int& x) {
  if(!step2) {
    a = downAddr1.size();
    x = writePos;
    downAddr1.push_back(writePos);
  } else {        
    x = downAddr1[downAddrN1++];
  } 
}

void setLabel(int a) {
  if(!step2) downAddr1[a] = writePos;
}

void parse_cshl() {
  int i;
  Arg a, b;
  if(p.ifToken("break")) {
    if(breakLabel==-1) p.syntaxError("break без do");
    asmJmp(00004, breakLabel);
    return;
  }
  if(p.ifToken("if")) {
    p.needToken("(");
   
    If iff; 
    parse_if(iff);

    p.needToken(")");

    bool got;
    int x;
    int a;
    if(got = p.ifToken("goto")) {
      x = needAddr();
    } else {
      iff.neg = !iff.neg;
      allocLabel(a, x);      
    }

    asmIf(iff, x);

    if(!got) {
      parse_block();

      if(p.ifToken("else")) {
        int a2, x2;
        allocLabel(a2, x2);
        asmJmp(00004, x2);
        setLabel(a);
        parse_block();
        setLabel(a2);
      } else {
        setLabel(a);
      }

    }
    return;
  } 
  if(p.ifToken("push")) {
    struct Item {
      Arg arg;
      int argSize;
    };
    std::vector<Item> x;

    do {
      int argSize = 0;
      Item it;
      it.argSize = 0;
      readArg(it.arg, it.argSize);
      write((it.argSize==1 ? 01010046 : 00010046) | (it.arg.code<<6), it.arg);
      x.push_back(it);
    } while(p.ifToken(","));

    if(p.ifToken("{")) {
      while(!p.ifToken("}")) {
        compileLine2();
        p.needToken(";");
      }

      for(int i=x.size()-1; i>=0; i--) {
        Item& it = x[i];
        write((it.argSize==1 ? 01012600 : 00012600) | it.arg.code, it.arg);        
      }
    }
    return;
  }

  static ImmCommand immCommands[] = {
    "emt", 0104000, 0377, "trap", 104400, 0377, 0
  };

  if(p.ifToken(immCommands, i)) {
    int x = p.needInteger();
    if(x<0 || x>immCommands[i].max) p.syntaxError();
    write(immCommands[i].code | x);
    return;
  }

  if(p.ifToken("pop")) {
    do {
      int argSize=0;
      readArg(a, argSize);
      write((argSize=1 ? 01012600 : 00012600) | a.code, a);
    } while(p.ifToken(","));
    return;
  }

  if(p.ifToken("return")) {
    write(0000207);
    return;
  }
  if(p.ifToken("goto")) {
    Arg a;
    int argSize = 2;
    readArg(a, argSize);
    write(0000100|a.code, a);
    return;
  }
  if(p.ifToken("do")) {
    p.needToken("{");
    int l = writePos;
    int pBreakLabel = breakLabel;
    
    int ln;
    allocLabel(ln, breakLabel);

    while(!p.ifToken("}")) {
      compileLine2();
      p.needToken(";");
    }
    if(!p.ifToken("while")) {
      asmJmp(00004, l); // br
    } else {
      p.needToken("(");
      ParserLabel pl = p.label();
      Arg b;
      int argSize = 0;
      readArg(b, argSize);
      if(p.ifToken("++")) {
        p.needToken(")");
        write((argSize==1 ? 0105200 : 0005200) | b.code, b); // inc
        asmJmp(00010, l); // bne
      } else 
      if(p.ifToken("--")) {
        p.needToken(")");
        if(argSize!=1 && b.code<8) {
          asmSob(b.code, l);
        } else {
          write((argSize==1 ? 0105300 : 0005300) | b.code, b); // dec
          asmJmp(00010, l); // bne
        }
      } else {
        p.jump(pl);
        If iff;
        parse_if(iff);
        p.needToken(")");
        asmIf(iff, l);
      }
    }
    setLabel(ln);
    breakLabel = pBreakLabel;
    return;
  }

  int argSize=0;
  readArg(a, argSize);

  for(bool first=true;;first=false) {
    if(p.ifToken("(")) {
      if(argSize==1) raise("Запуск по 8-битному адресу не поддерживается");
      p.needToken(")");
      write(004700 | a.code, a); // jsr
      return;
    }

    if(p.ifToken("^")) {
      if(first) p.needToken("=");
      if(argSize==1) p.syntaxError("XOR поддерживает только 16 битные типы данных");
      argSize=2;
      readArg(b, argSize);
      if(b.code>=8) p.syntaxError("С XOR можно исопльзовать только регистры");
      write(0074000 | (b.code<<6) | a.code, a);
      return;
    }

    if(p.ifToken("++")) {
      write((argSize==1 ? 0105200 : 0005200) | a.code, a); // inc
      continue;
    }

    if(p.ifToken("--")) {
      write((argSize==1 ? 0105300 : 0005300) | a.code, a); // dec
      continue;
    }

    SimpleCommand std[] = { "=", 0010000, "!&", 0040000, "|", 0050000, 0 };

    if(p.ifToken(std, i)) {
      if(i!=0 && first) p.needToken("=");
      readArg(b, argSize);
      if(first && i==0 && a.code==b.code && a.needExt1==b.needExt1 && (!a.needExt1 || (a.subip==b.subip && a.ext==b.ext-(a.subip ? 2 : 0)))) {
        continue;
      }
      if(i==0 && b.code==23 && b.ext==0) {
        write((argSize==1 ? 0105000 : 0005000)|a.code, a); // clr
        continue;
      }
      write((argSize==1 ? 0100000 : 0)|std[i].code|(b.code<<6)|a.code, b, a); // mov
      continue;
    }

    SimpleCommand shift[] = { "<<", 0006300, ">>", 0006200, 0 };
    if(p.ifToken(shift, i)) {
      if(first) p.needToken("=");
      if(argSize==1) p.syntaxError("Сдвиг 8-битных значений не поддерживается");
      p.needToken("#");
      int n = p.needInteger();
      if(n<1 || n>16) p.syntaxError("1..16");
      while(n--) write(shift[i].code | a.code, a);
      continue;
    }

    SimpleCommand addSub[] = { "+", 0060000, "-", 0160000, 0 };
    if(p.ifToken(addSub, i)) {
      if(first) p.needToken("=");
      readArg(b, argSize);
      if(b.code==23 && b.ext==1) {
        write((argSize==1 ? 0100000 : 0)|(i==2 ? 0005300 : 0005200) | a.code, a); // inc
        continue;
      }
      if(argSize==1) 
        p.syntaxError("Сложение 8-битных значений не поддерживается");
      write(addSub[i].code|(b.code<<6)|a.code, b, a); // add
      continue;
    }

    return;
  }
}