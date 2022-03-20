#ifndef COMMON_H
#define COMMON_H

#include <finLib/std.h>
#include "c_parser.h"
#include "ctype.h"


/*
class Code {
public:
  void decl3(cstring name, int size);
  void label(int n);
  void jmp(int n);

  void alu16_bc_hl_bc(Operator);
  void alu16_bc_hl_hl(Operator);
  void alu16_hl_bc_hl(Operator);
  void alu16_de_hl_hl(Operator);
  void alu16_hl_de_hl(Operator);
  void mvi_l(int);
  void mvi_h(int);
  void alu16_l_const(Operator, cstring);
  void alu16_h_const(Operator, cstring);
  void alu16_const_l(Operator, cstring);
  void alu16_const_h(Operator, cstring);
};

Code code;
*/
enum Place { 
  pVal, pRef, pConst, pConstRef, pConstRefRef
};


struct Stack {
  Place  place;
  CType  type;
  string name;
  union {
    int    value;  
    unsigned int uvalue;
  };
};

class Node;

class NodeVariable;

struct Function {
  CType retType;
  string name;
  std::vector<CType> args;
  string needInclude;
  bool callAddr;
  int addr;
  Node* rootNode;
  FillBuffer decl;
  std::vector<NodeVariable*> localVars;

  Function() { rootNode=0; callAddr=false; }
  //vector<string> argNames;
};
struct CStructItem {
  string name;
  CType type;
  int offset;
};

struct CStruct {
  string name;
  std::vector<CStructItem> items;
  int size;
};

//extern std::vector<Stack> stack;
extern Parser p;

void asm_pop();

//extern int lastA, lastHL;

/*
void popTmpPokeA(bool);
void pushPeekA(bool self);
void popTmpPokeHL(bool);
void pushPeekHL(bool);
void popTmpHL();
void popTmpA();
void pushAasHL_();
void peekAasHL_();

void postIncDec16(int v);
void postIncDec8(bool inc);
void incDec16(int v);
void incDec8(bool inc);
*/
void asm_pushInteger(int n);
void add16(int e, bool self=false);

void needFile(const char* fn);


void chkHL();
void cmd_call_operator(const char* cmd, bool self=false);
void cmd_call_operator_swap(const char* fn1, const char* fn2, bool self=false, bool wordResult=false);
//void cmd_alu(Opcode op, bool self=false, bool flags=false);
//bool cmd_alu_swap(Opcode op, bool self, bool flags=false);

//-------------

extern std::list<CStruct> structs;
const bool optimizeSize = 0;

void mulHL(int x);
void mulA(int x);
void set8();
void set16();
void resultFlags(CType& out, CBaseType t);
//void alu16(Operator o, Opcode cmd1, Opcode cmd2, bool canSwap, bool self);
void asm_convert(int l, CType a, CType b);
void sub16(int e, bool self=false);
//const char* opName(Operator o);
void cmd_shr16_1(bool,int x); 
void cmd_shl16_1(bool,int x); 
void cmd_shr8_1(bool,int x); 
void cmd_shl8_1(bool,int x);
char cmpImm16(CBaseType t, CBaseType t1, CType& a, int delta=0, int delta2=0);
void convertToConfition(CType& type);
void doAddr();
//void asm_callMonoOperator(MonoOperator mo, CType& type);
//void asm_index(CType idxType, CType& arrType);
//void asm_struct(int offset, CType& type, CType& toType);
//void asm_callOperator(Operator o, CType& a, CType b);
void needFile(const char*);

#endif