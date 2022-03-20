#pragma  once

#include <vector>
#include <assert.h>
#include <FinLib\FillBuffer.h>
#include "nodes.h"

enum {
  need_op_mul16=1,
  need_op_div16,
  need_op_cmp16,
  need_op_sub16,
  need_op_xor16,
  need_op_shr16,
  need_op_shl16,
  need_op_and16,
  need_op_or16,
  need_op_shr8,
  need_op_shl8,
  need_op_mul,
  need_cnt
};

const int TIMINGS_XCHG    = 4;
const int TIMINGS_PUSH    = 11;
const int TIMINGS_MOV_D_A = 5;

class Assembler {
protected:
  Assembler(Assembler& s) { assert(0); }
public:
  enum Cmd { cNop, cDcx, cInx, cDcr, cInr, cSHLD, cSTA, cPUSH, cPOP, cMOV, 
    cXCHG, cSTAX, cLDAX, cALU, cALUI, cMVI, cMVIN, cMVIH, cCALL, cJMP, cJMPL, cLABEL1, cLABEL2, cJCC, cRETCC,
    cLXI, cLXIN, cDAD, cLDA, cLHLD, cRET, cREMARK, cASMBLOCK, cSTAFN, cSHLDFN, cRRC, cCMA };
  enum Reg8 { A, B, C, D, E, H, L, M };
  enum Reg16 { BC, DE, HL, SP, PSW };
  enum Alu { CMP, XOR, OR, AND, SUB, ADD };
  enum CC { JZ, JNZ, JC, JNC, JZC, JZNC };

  struct Item {
    Cmd cmd;
    int a, b;
    const char* s;
  };

  std::vector<Item> items;
  int ptr;
  int t;
  int incorrectFork;

  int size() { return ptr; }
  Assembler() { ptr=0; items.resize(1024); t=0; incorrectFork=0; }
  void swap(Assembler& s) { items.swap(s.items); std::swap(ptr, s.ptr); }
  void reserve() { items.resize(items.size()*2+1); }
  void reg16(FillBuffer& buf, int i);
  void reg16_z80(FillBuffer& buf, int i);
  void reg8(FillBuffer& buf, int i);  
  void reg8_z80(FillBuffer& buf, int i);  
  void addr(FillBuffer& buf, Item& i, int ia);
  void add(Cmd cmd)                       { if(ptr==items.size()) reserve(); auto& x = items[ptr]; x.cmd = cmd; x.s = 0; ptr++; }
  void add(Cmd cmd, int a)                { if(ptr==items.size()) reserve(); auto& x = items[ptr]; x.cmd = cmd; x.a = a; x.s = 0; ptr++; }
  void add(Cmd cmd, int a, int b)         { if(ptr==items.size()) reserve(); auto& x = items[ptr]; x.cmd = cmd; x.a = a; x.b = b; x.s = 0; ptr++; }
  void add(Cmd cmd, int a, const char* s) { if(ptr==items.size()) reserve(); auto& x = items[ptr]; x.cmd = cmd; x.a = a; x.s = s; ptr++; }
  Item* add(Cmd cmd, const char* s)        { if(ptr==items.size()) reserve(); auto& x = items[ptr]; x.cmd = cmd; x.s = s; ptr++; return &x; }

  //void append(Assembler& a) { if(a.items.size()==0) return; while(ptr+a.ptr > items.size()) reserve(); memcpy(&items[ptr], &a.items[0], a.ptr*sizeof(Item)); ptr+=a.ptr; } 

  #define X // { if(cmdLimit==0) return *this; --cmdLimit; }

  Assembler& dcx(Reg16 r) { X t+=5; add(cDcx, r); return *this; }
  Assembler& inx(Reg16 r) { X t+=5; add(cInx, r); return *this; }
  Assembler& dcr(Reg8  r) { X t+=5; if(r==M) t+=5; add(cDcr, r); return *this; }
  Assembler& inr(Reg8  r) { X t+=5; if(r==M) t+=5; add(cInr, r); return *this; }
  Assembler& shld(const char* addr) { X t+=16; add(cSHLD, addr); return *this; }
  Assembler& shld(int addr) { X t+=16; add(cSHLD, addr); return *this; }
  Assembler& sta(const char* addr) { X t+=13; add(cSTA, addr); return *this; }
  Assembler& sta(int addr) { X t+=13; add(cSTA, addr); return *this; }
  Assembler& push(Reg16 r) { X t+=11; add(cPUSH, r); return *this; }
  Assembler& pop(Reg16 r) { X t+=10; add(cPOP, r); return *this; }
  Assembler& mov(Reg8 a, Reg8 b) { X t+=5; if(a==M || b==M) t+=2; add(cMOV, a, b); return *this; }
  Assembler& mvi(Reg8 a, int i) { X t+=7; if(a==M) t+=4; add(cMVI, a, i); return *this; }
  Assembler& mvi(Reg8 a, const char* i) { X t+=7; if(a==M) t+=4; add(cMVI, a, i); return *this; }
  Assembler& mvin(Reg8 a, const char* i) { X t+=7; if(a==M) t+=4; add(cMVIN, a, i); return *this; }
  Assembler& mvi(Reg8 a, NodeConst* nc) { X if(nc->nodeType==ntConstS) mvi(a, nc->var->name.c_str()); else mvi(a, nc->value & 0xFF); return *this; }    
  Assembler& mvih(Reg8 a, const char* i) { X t+=7; if(a==M) t+=4; add(cMVIH, a, i); return *this; }
  Assembler& mvih(Reg8 a, NodeConst* nc) { X if(nc->nodeType==ntConstS) mvih(a, nc->var->name.c_str()); else mvi(a, (nc->value >> 8) & 0xFF); return *this; }  
  Assembler& xchg() { X t+=4; add(cXCHG); return *this; }
  Assembler& stax(Reg16 r) { X t+=7; add(cSTAX, r); return *this; }  
  Assembler& ldax(Reg16 r) { X t+=4; add(cLDAX, r); return *this; }  
  Assembler& alu(Alu alu, Reg8 a) { X t+=4; if(a==M) t+=3; add(cALU, alu, a); return *this; }
  Assembler& alui(Alu alu, int a) { X t+=7; add(cALUI, alu, a); return *this; }  
  Assembler& alui(Alu alu, NodeConst* a) {  X t+=7; if(a->nodeType==ntConstS) add(cALUI, alu, a->var->name.c_str()); else add(cALUI, alu, a->value & 0xFF); return *this; }  
  Assembler& call(const char* addr, int need=0) { X t+=17; add(cCALL, addr)->b = need; return *this; }
  Assembler& call(int addr, int need=0) { X t+=17; add(cCALL, addr, need); return *this; }
  Assembler& jmp_(const char* addr) { X t+=10; add(cJMP, addr); return *this; }
  Assembler& jmpl(int label) { X t+=10; add(cJMPL, label); return *this; }
  Assembler& jmp_(int addr) { X t+=10; add(cJMP, addr); return *this; }
  Assembler& jcc(CC cc, int addr) { X if(cc==JZC || cc==JZNC) t+=10; t+=10; add(cJCC, cc, addr); return *this; }
  Assembler& label1(int addr) { add(cLABEL1, addr); return *this; }
  Assembler& label2(int addr) { add(cLABEL2, addr); return *this; }
  Assembler& lxi(Reg16 a, int i) { X t+=10; add(cLXI, a, i); return *this; }
  Assembler& lxi(Reg16 a, const char* i) { X t+=10; add(cLXI, a, i); return *this; }
  Assembler& lxi(Reg16 a, NodeConst* nc) { X if(nc->nodeType==ntConstS) lxi(a, nc->var->name.c_str()); else lxi(a, nc->value & 0xFFFF); return *this; }    
  Assembler& lxin(Reg16 a, int i) { X t+=10; add(cLXIN, a, i); return *this; }
  Assembler& lxin(Reg16 a, const char* i) { X t+=10; add(cLXIN, a, i); return *this; }
  Assembler& dad(Reg16 a) { X t+=10; add(cDAD, a); return *this; } //! на обум
  Assembler& lhld(const char* addr) { X t+=16; add(cLHLD, addr); return *this; }
  Assembler& lhld(int addr) { X t+=16; add(cLHLD, addr); return *this; }
  Assembler& lda(const char* addr) { X t+=13; add(cLDA, addr); return *this; }
  Assembler& lda(int addr) { X t+=13; add(cLDA, addr); return *this; }
  Assembler& ret() { X t+=10; add(cRET); return *this; }
  Assembler& rrc() { X t+=4; add(cRRC); return *this; }
  Assembler& cma() { X t+=4; add(cCMA); return *this; }
  Assembler& remark(const char* text) { add(cREMARK, text); return *this; }  
  Assembler& asmBlock(const char* text) { add(cASMBLOCK, text); return *this; }    
  Assembler& shldfn(const char* a, int b) { X t+=16; add(cSHLDFN, b, a); return *this; }
  Assembler& stafn(const char* a, int b) { X t+=13; add(cSTAFN, b, a); return *this; }

  #undef X

  void build(FillBuffer& buf);
  void build_z80(FillBuffer& buf);
};

extern Assembler out;