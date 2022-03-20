//! Если в коде нет чтения из переменной, то и сохранять туда не надо!!

//! Надо запомнить адрес последнего сохраненного HL. И проконтроллировать,что регистр DE не используется!

// Заблокировать переменные из которых не было чтения.

// Оптимизировать inc bc, inc b, inc c

// Еще можео оптимизировать LDAX B
// BC можно грузить и в DE!

// В getName inx распадается на mov+mov+inx+mov+mov

﻿// Переписать strcmp на асм

// Оптимизировать SUB8
//  lhld drawWindowText_1
//  mvi h, 0
//  lxi d, 40
//  call op_sub16
//  mov a, l

//- Выкидывать второй блок IF из программы. Или выкидывать блок оканчивающийся на RET.

//- Разместить функции так, что бы jmp на следующую функцию можно было убрать

// - Оптимизация переходов назад 
// Перед меткой надо выяснить, какие первые переменые используются в HL, DE и А и загрузить их перед меткой.
// И если переход на эту метку имеет те же переменные в регистрах, то переменные обнулять не надо.

// - HL+const должен изменять s.hl.delta

// - 16 битное сравление требующее флаг C можно заменить на LXI + DAD

// - Оптимизировать сравнение с нулем

// Любая операция (кроме inc, dec, cmp8_0) портит либо А, либо HL.

// Можно проще скомпилировать
// f->fattrib ^= 0x80;
//   lhld cmd_inverseOne_f
//   lxi d, 11
//   dad d
//   mov a, m
//   xri 128
//   lhld cmd_inverseOne_f
//   lxi d, 11
//   dad d
//   mov m, a

// + После OR A + JZ помечать, что в регистре A лежит 0

// Учитывать значения переменных увеличенных или умеьншеный на какое то значение

//  lxi h, 30
//  xchg ;3 заменить на lxi d,

// При сравнении с константой избегать конструкций jcc+jcc

// Сравнение указателя с нулем
// Парсить сначала правую часть выражения =
// Конвертирование
// Вычитание указателей
// Уникальность имен
// Не указывать имя аргумента функции
// uchar *= 9 не работает
// Переделать SWITCH на двойной проход
// Отключение макросов для препроцессора
// Обмен аргументов местами в cmd_call_operator

#include "stdafx.h"

//#define DISABLE_FORK

#include "c8080.h"
#include <finlib/file.h>
#include <finlib/findfiles.h>
#include <algorithm>
#include <FinLib/string.h>
#include <finlib/fillbuffer.h>
#include "c_parser.h"
#include "stackLoadSave.h"
#include <assert.h>
#include <functional>
#include "a.h"
#include "b.h"
//#include "asm.h"


bool z80 = false;




NodeVar* nodeConvert(NodeVar* x, CType type);
NodeVar* addFlag(NodeVar* a);




std::map<string, NodeVariable*> nodeVars;




NodeVar* nodeOperator(Operator o, NodeVar* a, NodeVar* b, bool noMul=false, NodeVar* cond=0);

NodeVar* nodeMonoOperator(NodeVar* a, MonoOperator o) {
  if(a->nodeType == ntConstI) {
    auto ac = (NodeConst*)a;
    switch(o) {
      case moNeg: ac->value = -ac->value; return ac;
      case moXor: ac->value = ~ac->value; return ac;        
    }
  }
  // Что бы не получилось куча INX
  if(a->dataType.addr != 0) {
    int s = a->dataType.sizeElement();
    if(s>=3) {
      if(o==moInc || o==moIncVoid) return nodeOperator(oSet, a, nodeOperator(oAdd, a, new NodeConst(s), true));
      if(o==moDec || o==moDecVoid) return nodeOperator(oSet, a, nodeOperator(oSub, a, new NodeConst(s), true));
      if(o==moPostInc) return nodeOperator(oSub, nodeOperator(oSet, a, nodeOperator(oAdd, a, new NodeConst(s), true)), new NodeConst(s), true);
      if(o==moPostDec) return nodeOperator(oAdd, nodeOperator(oSet, a, nodeOperator(oSub, a, new NodeConst(s), true)), new NodeConst(s), true);
    }
  }  
  return new NodeMonoOperator(a, o);
}


int intLabels = 0;


/*
class NodeCond : public NodeVar {
public:
  NodeVar* a;

  NodeCond(NodeVar* _a) { 
    nodeType = ntCond; a=_a;
    dataType.baseType = cbtVoid;
    dataType.addr = 0;
  }  

  Operator getOperator() {
    assert(a->nodeType == ntOperator);
    return a->cast<NodeOperator>()->o;
  }
};
*/
string name_(NodeVar* a) {
  if(a->nodeType == ntConstI) {
    return i2s(a->cast<NodeConst>()->value);
  }
  if(a->nodeType == ntConstS) {
    assert(!a->cast<NodeConst>()->var->name.empty());
    return a->cast<NodeConst>()->var->name;
  }
  assert(0);
  throw;
}

Reg NodeVar::isRegVar() {
  if(nodeType==ntDeaddr && cast<NodeDeaddr>()->var->nodeType==ntConstS) {
    auto v = cast<NodeDeaddr>()->var->cast<NodeConst>();
    if(v->var->reg==regNone) return v->var->reg;
    return v->var->reg;
  }
  return regNone;
}

NodeVar* nodeOperator2(CType type, Operator o, NodeVar* a, NodeVar* b, NodeVar* cond) {
  // Сравнение дает флаги
  switch(o) {
    case oE: 
    case oNE: 
    case oG:
    case oGE:
    case oL:
    case oLE:
      type.baseType = cbtFlags;
      type.addr = 0;        
      break;
  }  

  if(o==oIf) {
    //! Проверить условие на константность!  || cond->nodeType == ntConstS

    if(cond->nodeType == ntConstI) {
      if(cond->cast<NodeConst>()->value) {
        delete cond;
        delete b;
        return a;
      } else {
        delete cond;
        delete a;
        return b;
      }
    }

    return new NodeOperator(type, o, a, b, addFlag(cond));
  } 

  // Вычисление операция между константами на экрапе компиляции
  if((a->nodeType==ntConstI || a->nodeType==ntConstS) && (b->nodeType==ntConstI || b->nodeType==ntConstS)) {
    NodeVar* x = 0;
    if(a->nodeType==ntConstI && b->nodeType==ntConstI) {
      auto ac = (NodeConst*)a, bc = (NodeConst*)b;
      switch(o) {
        case oAdd: x = new NodeConst(ac->value +  bc->value, type); break;
        case oSub: x = new NodeConst(ac->value -  bc->value, type); break;
        case oAnd: x = new NodeConst(ac->value &  bc->value, type); break;
        case oXor: x = new NodeConst(ac->value ^  bc->value, type); break;
        case oMul: x = new NodeConst(ac->value *  bc->value, type); break;
        case oDiv: x = new NodeConst(ac->value /  bc->value, type); break;
        case oShr: x = new NodeConst(ac->value >> bc->value, type); break;
        case oShl: x = new NodeConst(ac->value << bc->value, type); break;
        case oNE:  x = new NodeConst(ac->value != bc->value ? 1 : 0, type); break;
        case oE:   x = new NodeConst(ac->value == bc->value ? 1 : 0, type); break;
        case oGE:  x = new NodeConst(ac->value >= bc->value ? 1 : 0, type); break;
        case oG:   x = new NodeConst(ac->value >  bc->value ? 1 : 0, type); break;
        case oLE:  x = new NodeConst(ac->value <= bc->value ? 1 : 0, type); break;
        case oL:   x = new NodeConst(ac->value <  bc->value ? 1 : 0, type); break;
        case oOr:  x = new NodeConst(ac->value | bc->value); break;        
        default: assert(0);
      }
    } else {
      if(a->nodeType==ntConstS && a->cast<NodeConst>()->var->reg) raise("Нельзя получить адрес регистровой переменной");
      if(b->nodeType==ntConstS && a->cast<NodeConst>()->var->reg) raise("Нельзя получить адрес регистровой переменной");
  //    CType t=type; t.addr++; // NodeConst порождает новую переменную!!! Это плохо. Этот код что бы обойти првоерку.
      switch(o) {
        case oAdd: x = new NodeConst("(" + name_(a) + ")+("  + name_(b) + ")", type); break;
        case oSub: x = new NodeConst("(" + name_(a) + ")-("  + name_(b) + ")", type); break;
        case oAnd: x = new NodeConst("(" + name_(a) + ")&("  + name_(b) + ")", type); break;
        case oXor: x = new NodeConst("(" + name_(a) + ")^("  + name_(b) + ")", type); break;
        case oMul: x = new NodeConst("(" + name_(a) + ")*("  + name_(b) + ")", type); break;
        case oDiv: x = new NodeConst("(" + name_(a) + ")/("  + name_(b) + ")", type); break;
        case oShr: x = new NodeConst("(" + name_(a) + ")>>(" + name_(b) + ")", type); break;
        default: assert(0);
      }
    }
    delete a;
    delete b;
    return x;
  }    

  // Умножение на единицу бессмысленно
  if(o==oMul) {
    if(a->nodeType==ntConstI && ((NodeConst*)a)->value==1) return b;
    if(b->nodeType==ntConstI && ((NodeConst*)b)->value==1) return a;
  }
  // Деление то же
  if(o==oDiv) {
    if(b->nodeType==ntConstI && ((NodeConst*)b)->value==1) return a;
  }

  return new NodeOperator(type, o, a, b, cond);
}

NodeVar* newNodeCond(NodeVar* a) {
  if(a->isConst()) {
    a->dataType.baseType = cbtUShort;
    return a;
  }
  return new NodeCond(a);
}

NodeVar* nodeOperator0(Operator o, NodeVar* a, NodeVar* b, bool noMul, NodeVar* cond) {
  CType type;

  // Сложение указателя и числа
  if(o==oAdd && a->dataType.addr!=0 && b->dataType.addr==0 && b->dataType.isStackType()) {
    if(!noMul) b = nodeOperator(oMul, b, new NodeConst(a->dataType.sizeElement()));
    return nodeOperator2(a->dataType, o, a, b, cond);
  }
  if(o==oAdd && a->dataType.addr==0 && a->dataType.isStackType() && b->dataType.addr!=0) {
    if(!noMul) a = nodeOperator(oMul, a, new NodeConst(b->dataType.sizeElement()));
    return nodeOperator2(b->dataType, o, a, b, cond);
  }

  // Вычитание числа из указателя
  if(o==oSub && a->dataType.addr!=0 && b->dataType.addr==0 && b->dataType.isStackType()) {
    if(!noMul) b = nodeOperator(oMul, b, new NodeConst(a->dataType.sizeElement()));
    return nodeOperator2(a->dataType, o, a, b, cond);
  }

  // Вычитание указателя из указателя
  if(o==oSub && a->dataType.addr!=0 && a->dataType.addr==b->dataType.addr && a->dataType.baseType==b->dataType.baseType) {
    CType stdType;
    stdType.baseType = cbtUShort;
    stdType.addr = 0;
    NodeVar* n = nodeOperator2(stdType, o, a, b, cond);
    if(!noMul) n = nodeOperator(oDiv, n, new NodeConst(a->dataType.sizeElement()));
    return n;
  }

  // Сравнение указателей
  if((o==oE || o==oNE || o==oL || o==oG || o==oLE || o==oGE) && a->dataType.addr!=0 && a->dataType.addr==b->dataType.addr && a->dataType.baseType==b->dataType.baseType) {
    return nodeOperator2(a->dataType, o, a, b, cond); // Тип не важен, но изменится в функции
  }

  // ? для указателей
  //! надо бы привести указатели к VOID* для ?
  if(o==oIf && a->dataType.addr!=0 && a->dataType.addr==b->dataType.addr && a->dataType.baseType==b->dataType.baseType) {
    return nodeOperator2(a->dataType, o, a, b, cond);
  }


  // Преобразование нуля в указатель
  if(a->dataType.addr!=0 && b->nodeType==ntConstI && ((NodeConst*)b)->value==0) {
    return nodeOperator2(a->dataType, o, a, b, cond); // Тип не важен, но изменится в функции
  }
  if(b->dataType.addr!=0 && a->nodeType==ntConstI && ((NodeConst*)a)->value==0) {
    return nodeOperator2(b->dataType, o, a, b, cond); // Тип не важен, но изменится в функции
  }

  // Два условия в LAND и LOR
  if(o==oLAnd || o==oLOr) {
    if(a->dataType.baseType!=cbtFlags || b->dataType.baseType!=cbtFlags) raise("LAND и LOR не правильно сформированы");
    return nodeOperator2(a->dataType, o, a, b, cond);
  }

  // Пеобразование условия в число
  if(a->dataType.baseType==cbtFlags) a = newNodeCond(a);
  if(b->dataType.baseType==cbtFlags) b = newNodeCond(b);

  // Далее только простые числа
  if(!a->dataType.isStackType() || !b->dataType.isStackType()) raise("Поддерживается только 8 и 16 битная арифметика");


  //!!! Это не совсем правильно, так как OR, AND всегда будут давать 8 битный результат

  // Число приводится к типу второго аргумента.
  CType at=a->dataType, bt=b->dataType;
  if(a->nodeType == ntConstI && b->nodeType != ntConstI) at = b->dataType; else
  if(b->nodeType == ntConstI && a->nodeType != ntConstI) bt = a->dataType;

  CType dataType;
  if(o==oSet) {
    //! Проверить типы!!!

    // Запись
    dataType = at;
  } else {
    if(at.addr != 0 || bt.addr != 0) 
      p.logicError_("Такая операция между указателями невозможна");

    // Преобразование меньшего к большему
    bool sig = (at.baseType == cbtChar || at.baseType == cbtShort || bt.baseType == cbtChar || bt.baseType == cbtShort);
    bool is16 = at.is16() || bt.is16();
    dataType = is16 ? (sig ? cbtShort : cbtUShort) : (sig ? cbtChar : cbtUChar);    
  }

  // Арифметические операции между 8 битными числами дают 16 битный результат
  if(dataType.is8()) {
    switch(o) {
      case oAdd: 
      case oSub: 
      case oDiv:
      case oMod:
      case oMul:
        dataType.baseType = dataType.baseType==cbtChar ? cbtShort : cbtUShort;
        break;
    }
  }

  if(o != oSet) {
    if(a->dataType.baseType != dataType.baseType || a->dataType.addr != dataType.addr) a = nodeConvert(a, dataType);
  }
  if(b->dataType.baseType != dataType.baseType || b->dataType.addr != dataType.addr) b = nodeConvert(b, dataType);
  
  return nodeOperator2(dataType, o, a, b, cond);
}

NodeVar* nodeOperator(Operator o, NodeVar* a, NodeVar* b, bool noMul, NodeVar* cond) {  
  switch(o) {
    // Добавляем NodeCond к условным операторам  
    case oIf: if(cond->nodeType != ntOperator) cond = nodeOperator(oNE, cond, new NodeConst(0)); return nodeOperator0(o, a, b, noMul, cond);      
    case oE:  return nodeOperator0(o, a, b, noMul, cond);
    case oNE: return nodeOperator0(o, a, b, noMul, cond);
    case oG:  return nodeOperator0(o, a, b, noMul, cond);
    case oGE: return nodeOperator0(o, a, b, noMul, cond);
    case oL:  return nodeOperator0(o, a, b, noMul, cond);
    case oLE: return nodeOperator0(o, a, b, noMul, cond);
    // В компиляторе оптимизируется лишь сложение
    case oSub: 
      if(b->nodeType == ntConstI) {
        ((NodeConst*)b)->value = -((NodeConst*)b)->value;
        return nodeOperator0(oAdd, a, b, noMul, cond);
      }    
      break;
    // Заменяем операторы += на простые операторы
    case oSAdd: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oAdd, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSSub: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oSub, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSMul: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oMul, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSDiv: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oDiv, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSMod: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oMod, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSShl: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oShl, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSShr: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oShr, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSAnd: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oAnd, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSXor: return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oXor, a, b, noMul, 0), a->dataType), noMul, 0);
    case oSOr:  return nodeOperator0(oSet, a, nodeConvert(nodeOperator(oOr,  a, b, noMul, 0), a->dataType), noMul, 0);
  }
  return nodeOperator0(o, a, b, noMul, cond);
}



NodeVar* nodeAddr(NodeVar* x) {  
  if(x->nodeType != ntDeaddr) p.logicError_("addrNode");
  auto a = ((NodeDeaddr*)x);
  auto result = a->var;
  if(a->nodeType==ntConstS && a->cast<NodeConst>()->var) raise("Нельзя получить адрес регистровой переменной");
  a->var = 0;
  delete a;
  return result;
}

//---------------------------------------------------------------------------

int strsCounter = 1;
std::map<string, int> strs;

Node* readCommand();

const char* stringBuf(const char* str) {
  auto i = strs.find(str);
  if(i == strs.end()) {
    strs[str] = strsCounter++;
    i = strs.find(str);
    assert(i != strs.end());
  }
  return i->first.c_str();
}

// Поместить в стек строку
string regString(const char* str) {
  auto i = strs.find(str);
  if(i != strs.end()) return "str" + i2s(i->second);
  strs[str] = strsCounter++;
  return "str" + i2s(strsCounter-1);
}

/*
void doAddr() {
  stack.back().type.addr++;
}
*/
std::string catPath(const std::string& a, const std::string& b) {
  if(a.size()==0) return b;
  char_t c = a[a.size()-1];
  if(c=='\\' || c=='/') return a+b;
                   else return a+"\\"+b;
}

string getPath(cstring str) {
  int a=str.rfind('/');
  int b=str.rfind('\\');
  if(a==-1 && b==-1) return _T("");
  if(a<b) a=b;
  if(a==2 && str[1]==':' && (str[2]=='/' || str[2]=='\\'))  a++; else 
  if(a==0 && (str[0]=='/' || str[0]=='\\'))  a++;
  return str.substr(0, a);

}

int s2i(const char_t* str) {
  return atoi(str); // no error!
}

bool fileExists(cstring name) {
  WIN32_FIND_DATA data;
  HANDLE h = FindFirstFile(name.c_str(), &data);
  if(h==INVALID_HANDLE_VALUE) return false;
  FindClose(h);
  return true;
}

//void alu16(Operator o, Opcode cmd1, Opcode cmd2, bool canSwap, bool self);
//void explode1(std::vector<string>&, const std::string&, const std::string&);

Parser p;
//int lastA=-1, lastHL=-1;
int labelesCnt = 0;

//std::map<string, int> lastInclude0;
std::map<string, int> lastInclude2;
std::vector<string> lastInclude;
std::vector<string> includeDirs;
std::list<CStruct> structs;
//std::vector<Stack> stack;
//int returnLabel;
CType retType;
string fnName;
//bool retPopBC;

void asm_pop();

string CType::descr() {
  string s;
  switch(baseType) {
    case cbtVoid:   s = "void"; break;
    case cbtChar:   s = "char"; break;
    case cbtShort:  s = "short"; break;
    case cbtLong:   s = "long"; break;
    case cbtUChar:  s = "uchar"; break;
    case cbtUShort: s = "ushort"; break;
    case cbtULong:  s = "ulong"; break;
    case cbtStruct: s = "struct " + get(structs, i).name; break;
    default: raise("CType.descr");
  }
  for(int i=0; i<addr; i++) s += "*";
  return s;
}

int CType::size1() {
  if(addr > 0) return 2;
  switch(baseType) {
    case cbtVoid:   return 0;
    case cbtUChar:  case cbtChar:  return 1;
    case cbtUShort: case cbtShort: return 2;
    case cbtULong:  case cbtLong:  return 4;
    case cbtStruct: return get(structs, i).size;
    default: raise("CType.size"); throw;
  }
}

Operator invert(Operator a) {
  switch(a) {
    case oL:  a=oGE; break;
    case oLE: a=oG;  break;
    case oGE: a=oL;  break;
    case oG:  a=oLE; break;
    case oE:  a=oNE; break;
    case oNE: a=oE;  break;
  }
  return a;
}

int CType::sizeElement() {
  if(addr==0) return size1();
  addr--;
  int s = size1();
  addr++;
  return s;
}

int CType::size() {
  return arr ? arr*sizeElement() : size1();
}


struct Typedef {
  string name;
  CType type;
};

std::list<Typedef> typedefs;

void asm_decl3(FillBuffer& b, cstring name, int additional, std::vector<char>* init=0, int ptr2=0, int ptrStep=0) {    
  b.str(name).str(":");
  bool needEol = true;

  // Необходимо разместить указатели
  for(int j=0, x=2*ptr2; j<ptr2; j++, x+=ptrStep-2) {
    b.str(" .dw $+").i2s(x).str("\r\n");
    needEol = false;
  }

  // Есть данные
  if(init && init->size()>0) {
    int x=0;
    for(size_t i=0; i<init->size(); i++) {
      if(x==16) b.str("\r\n"), x=0;
      if(x==0) b.str(" .db "); else b.str(", ");
      b.i2s((unsigned char)((*init)[i]));
      x++;
    }
    b.str("\r\n");
    needEol = false;
  }

  if(additional>0) {
    b.str(" .ds ").i2s(additional).str("\r\n");
    needEol = false;
  }

  if(needEol) b.str("\r\n");
}

// Описать переменную
void asm_decl(FillBuffer& decl, cstring fn, cstring var, CType type) {
  asm_decl3(decl, fn+"_"+var, type.size()); // str(fn).str("_").str(var).str(" ds ").i2s(type.size()).str("\r\n");
}

/*
// Поместить в виртуальный стек число
void asm_pushInteger(int n) {
  Stack& s = add(stack);
  s.place = pConst;
  s.value = n;
  s.type.i = n;
  if(n < -32768) { s.type.baseType = cbtLong; return; }
  if(n < -128) { s.type.baseType = cbtShort; return; }
  if(n < 0) { s.type.baseType = cbtChar; return; }
  if(n < 256) { s.type.baseType = cbtUChar; return; }
  if(n < 65536) { s.type.baseType = cbtUShort; return; }
  s.type = cbtULong;
}
*/

// Поставить метку
//void asm_label(int l) {
//  code.label(l); // str("l").i2s(l).str(":\r\n");
//}

// Перейти на метку
//void asm_jmp(int l) {
//  code.jmp(l); // str("  jp l").i2s(l).str("\r\n");//
//}


// Перейти на метку, если в стеке 0
// Временные переменные
//int tmpCounter = 0;
//string makeTmpName() { return "tmp"+i2s(tmpCounter++); }

void asm_convert(int l, CType a, CType b);

// Команды: cp, add, sub, or, xor, and

const char* opNameTbl[] = { "?", "/", "%", "*", "$", "+", "-", "<<", ">>", "<", ">", "<=", ">=", "==", "!=", "&", "^", 
  "|", "&&", "||", "?", "=", "+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "^=", "|="  };

const char* opName(Operator o) {
  return o>=0 && o<oCount ? opNameTbl[o] : "?";
}

const char* operatorDescr[] = { "oNone", "oDiv", "oMod", "oMul", "oAdd", "oSub", "oShl", "oShr", "oL", "oG", "oLE", "oGE", "oE", "oNE", "oAnd", "oXor", "oOr", "oLAnd", "oLOr", "oIf", "oSet", "oSAdd", "oSSub", "oSMul", "oSDiv", "oSMod", "oSShl", "oSShr", "oSAnd", "oSXor", "oSOr" };

const char* placeDescr[] = {
   "pA", "pB", "pC", "pConst", "pConstRef8", "pConstRef16", "pConstStr", "pConstStrRef8", "pConstStrRef16",
   "pConstStrRefRef8", "pConstStrRefRef16", "pHL", "pHLRef8", "pHLRef16", "pBC", "pBCRef8", "pBCRef16",
   "pStack8", "pStack16", "pStackRef8", "pStackRef16"
};

struct Var {
  int indexName;
  string name;
  CType type;
  inline Var() { indexName=-1; }
};

std::vector<Function> functions;
Function* curFn;
std::vector<string> globalNames, functionNames;
std::vector<CType>  globalTypes;
std::vector<Var> stackNamesD;
std::map<string, int> stackNamesI;

//------------------------------------------------------------------------------

void error(const Exception* e, const char_t* inFunction) throw() {
  MessageBox(0, (string(_T("EXCEPTION: ")) + (e ? e->what() : _T("NULL"))).c_str(), _T("Ошибка"), MB_ICONEXCLAMATION);
}

void warning(const string& text) throw() {
  MessageBox(0, (string(_T("EXCEPTION: ")) + text).c_str(), _T("Предупреждение"), MB_ICONEXCLAMATION);
}

void fatal(const Exception* e, const char_t* inFunction) throw() {
  error(e,inFunction);
  ExitProcess(0);
}

int parseStruct2(int m);

NodeVar* readVar(int);

NodeVar* nodeConvert(NodeVar* x, CType type) {
  // Преобразовывать не надо
  if(type == x->dataType) return x;
  // Условие
  if(x->dataType.baseType == cbtFlags) {
    x = newNodeCond(x);
  }
  // Константы преобразуются налету
  if(x->isConst()) {
    if(x->nodeType==ntConstI) {
      if(type.is8()) x->cast<NodeConst>()->value &= 0xFF; else
      if(type.is16()) x->cast<NodeConst>()->value &= 0xFFFF;
    }
    x->dataType = type;
    return x;
  }
  // 8 битные арифметические операции
  if(x->nodeType==ntOperator && type.is8()) {
    auto no = x->cast<NodeOperator>();
    if((no->a->nodeType==ntConvert || no->a->isConst()) && (no->b->nodeType==ntConvert || no->b->isConst())) {      
      if(no->o==oAdd || no->o==oSub || no->o==oMul || no->o==oAnd || no->o==oOr || no->o==oXor) { //! Добавить остальные
        // Обрезаем конвертации
        if(no->a->nodeType==ntConvert) no->a->cast<NodeConvert>()->dataType = type; else no->a->dataType = type;
        if(no->b->nodeType==ntConvert) no->b->cast<NodeConvert>()->dataType = type; else no->b->dataType = type;
        no->dataType = type;
        return no;
      }
    }
  }
  // Преобразовывать надо
  return new NodeConvert(x, type);
}

// Чтение константы и преобразование её к определенному типу
int readConst(CType& to) {
  // Эта функция не генерирует код
  NodeVar* n = nodeConvert(readVar(-1), to);

  if(n->nodeType != ntConstI) 
    p.logicError_("Ожидается константа");

  int v = ((NodeConst*)n)->value;
  delete n;
  return v;
}

int readConstV() {  
  CType type2;
  type2.addr = 0;
  type2.baseType = cbtUShort;
  type2.arr = 0;
  return readConst(type2);
}

// Чтение типа данных
CType readType(Parser& p, bool error) {
  bool const1 = p.ifToken("const");
  //! Учесть

  // Простые типы данных

  if(p.ifToken("unsigned")) {
    if(p.ifToken("char")) return cbtUChar;
    if(p.ifToken("short") || p.ifToken("int")) return cbtUShort;
    if(p.ifToken("long")) return cbtULong;
    p.syntaxError();
  }

  if(p.ifToken("void")) return cbtVoid;
  if(p.ifToken("char")) return cbtChar;
  if(p.ifToken("short") || p.ifToken("int")) return cbtShort;
  if(p.ifToken("long")) return cbtLong;
  if(p.ifToken("uchar")) return cbtUChar;
  if(p.ifToken("ushort") || p.ifToken("uint")) return cbtUShort;
  if(p.ifToken("ulong")) return cbtULong;

  // typedef-ы

  for(auto i=typedefs.begin(); i!=typedefs.end(); i++)
    if(p.ifToken(i->name))
      return i->type;

  // Читаем struct или union

  const char* xx[] = { "struct", "union", 0 };
  int su;
  if(p.ifToken(xx,  su)) {
    int i=0;
    for(auto s=structs.begin(); s!=structs.end(); s++, i++) {
      if(p.ifToken(s->name)) {
        if(p.ifToken("{")) p.logicError_("Структура с таким именем уже определена");
        CType type;
        type.baseType = cbtStruct;
        type.i = i;
        return type;
      }
    }
    int si = parseStruct2(su);  

    // Возврат структуры
    CType type;
    type.baseType = cbtStruct;
    type.i = si; 
    return type;
  }

  if(error) p.syntaxError();
  return cbtError;
}

void needFile(const char* fn) {
  if(lastInclude2.find(fn) != lastInclude2.end()) return;
  lastInclude2[fn] = 1;
  lastInclude.push_back(fn);
}

void readModifiers(Parser& p, CType& t) {
  while(p.ifToken("*")) t.addr++;
}

NodeVar* bindVar();

int stackCounter=0;

NodeVar* bindVar_2(Parser& p) {
  // Чтение возможных значений
  if(p.ifToken(ttString2)) { 
    string buf;
    buf += p.buf;
    while(p.ifToken(ttString2))
      buf += p.buf;
    CType type;
    type.addr = 1;
    type.baseType = cbtChar;
    return new NodeConst(regString(buf.c_str()), type);
  }
  if(p.ifToken(ttString1)) {
    return new NodeConst((unsigned char)p.buf[0], cbtChar); 
  }
  if(p.ifToken(ttInteger)) { 
    return new NodeConst(p.bufInt, cbtShort); //! Должен быть неопределенный размер
  }
  if(p.ifToken("sizeof")) {
    p.needToken("(");
    // Если там указан тип, то нет проблем
    CType type1 = readType(p, false);
    if(type1.baseType == cbtError) { 
      NodeVar* a = readVar(-1);
      type1 = a->dataType;
      delete a;
    }
    p.needToken(")");
    return new NodeConst(type1.size(), cbtShort); 
  }

  // Это либо просто скобки, либо преобразование типов
  if(p.ifToken(_T("("))) { 
    // Преобразование типа
    CType type = readType(p, false);
    if(type.baseType != cbtError) {
      readModifiers(p, type);
      p.needToken(")");
      return nodeConvert(bindVar(), type);
    }
    NodeVar* a = readVar(-1);
    p.needToken(_T(")"));    
    return a;
  }

  // Стековая переменная

  int i;
  if(p.ifToken(stackNamesI, i)) {
    auto& x = stackNamesD[i];
    CType t = x.type;
    if(!t.arr) t.addr++;        
    string name;
    if(x.indexName != -1) {
      name = i2s(x.indexName);
    } else {
      name = x.name;
      assert(!name.empty());
    }
    NodeVar* c = new NodeConst(curFn->name+"_"+name, t, /*stack*/true);
    if(!t.arr) c = new NodeDeaddr(c);
    return c;
  }

  // Глобальная переменная

  if(p.ifToken(globalNames, i)) {
    auto& g = globalTypes[i];
    // Если требуется подключить внешний файл
    if(!g.needInclude.empty()) {
      needFile(g.needInclude.c_str());
      clearString(g.needInclude);      
    }
    //if(type.baseType == cbtStruct) type.place = pConstStrRef16;

    // Эта переменная не требует DEADDR
    if(g.arr) return new NodeConst(globalNames[i], g);

    // Переменная описана без адреса. int как int. Но в реальности надо обернуть все переменные в DEADDR
    CType t = g;
    t.addr++;
    return new NodeDeaddr(new NodeConst(globalNames[i], t));
  }

  // Это функция

  if(p.ifToken(functionNames, i)) {
    cstring fnName = functionNames[i];

    // Для вызова функции надо подключить файл
    Function& f = functions[i];
    if(!f.needInclude.empty()) {
      needFile(f.needInclude.c_str());
      clearString(f.needInclude);
    }

    p.needToken("(");

//    if(!f.retType.isVoid() && !f.retType.isStackType()) {
//      string tmpVar = "tmp" + i2s(tmpCnt++);
//      asm_decl(::fnName, tmpVar, f.retType);      
//      new NodeGlobalVar(::fnName, tmpVar, type);
//    }

    // Чтение аргументов
    std::vector<NodeVar*> args;
    for(unsigned int i=0; i<f.args.size(); i++) {
      if(i>0) p.needToken(",");      
      args.push_back(nodeConvert(readVar(-1), f.args[i]));
    }
    p.needToken(")");

    // Вызов функции
    if(f.callAddr) return new NodeCall(f.addr, f.retType, args);
              else return new NodeCall(fnName, f.retType, args);
  }

  p.syntaxError();

/*
  // Чтение идентификатора
  int sy=p.prevLine, sx=p.prevCol;
  int vi = p.needToken(var_names);
  Var& v=vars_x2[vi];
  type = v.type;

  // Перечисление / Константа
  if(v.dest==vdEnum) {
    out.push_i(v.n);
    return;
  } 

  // Переменная
  if(v.dest==vdStack) {
    if(v.dest==vdObject) type = out.pushObjectVar1(v.n);
                    else type = out.pushVar1(v.n);
    return;
  }

  // Метод или функция
  if(v.dest==vdSelfMethod || v.dest==vdGlobal || v.dest==vdLocalFunction) {
    // Поиск альтернативных методов
    vector<Var*> founded;
    bool canStaticCheck1=false;
    getAltFunctions(true, vi, v.name, founded, canStaticCheck1);
    // Статическая проверка
    bool canStaticCheck = false;
    string constArg;
    if(canStaticCheck1) {
      ParserLabel l = p.disableBreak();
      if(p.ifToken(_T("("))) {
        if(p.ifToken(ttString1)) {
          constArg = p.buf;
          if(p.ifToken(_T(")")) || p.ifToken(_T(",")))
            canStaticCheck = true;
        }
      }
      p.jump(l);
    }
    // Поиск подходящей функции    
    Var* vs = readFunctionArgs_only(sx, sy, _T(""), founded, /*index=false, /*dontPushRet=false);
    // Выполнение
    int ac = vs->args.size();
    if(vs->tag!=-1) { out.push_i(vs->tag); ac++; }
    switch(vs->dest) {
      case vdLocalFunction: out.call(vs->label, ac); break;
      case vdSelfMethod: out.callSelfMethod(vs->method, ac, vs->fid); break;
      default: out.callFunction(vs->fn, ac, vs->fid);
    }
    out.pops(ac-1);
    type = vs->args[0].type;

    // Статическая проверка
    if(canStaticCheck && vs->meth && vs->meth->staticCheck.able()) {
      vs->meth->staticCheck(user, constArg, out, type, methodR(this, &PascalCompiler::getExternalClass));
    }

    return;
  }
*/
  raise(_T("PascalCompiler.bindVar_2")); // Что то упустили
  throw;
}

void inverseOperator(NodeOperator* no) {
  if(no->a->nodeType==ntOperator) {
    auto na = no->a->cast<NodeOperator>();
    if(na->o==oLAnd || na->o==oLOr) {
      assert(na->a->nodeType==ntOperator); auto naa = na->a->cast<NodeOperator>();
      assert(na->b->nodeType==ntOperator); auto nab = na->b->cast<NodeOperator>();
      na->o = na->o==oLOr ? oLAnd : oLOr;
      inverseOperator(naa);
      inverseOperator(nab);
      return;
    }
  }
  switch(no->o) {
    case oL:  no->o = oGE; break;
    case oLE: no->o = oG;  break;
    case oG:  no->o = oLE; break;
    case oGE: no->o = oL;  break;
    case oE:  no->o = oNE; break;
    case oNE: no->o = oE;  break;
    case oLAnd: { 
      no->o = oLOr; 
      assert(no->a->nodeType == ntOperator);
      inverseOperator(no->a->cast<NodeOperator>());
      assert(no->b->nodeType == ntOperator);
      inverseOperator(no->b->cast<NodeOperator>());
      break;
    }
    default: raise("neg!");
  }
}

NodeVar* bindVar() {
  // Чтение монооператора, выполнять будем потом
  std::vector<MonoOperator> mo;
  while(true) {
    if(p.ifToken("+" )) continue;
    if(p.ifToken("~" )) { mo.push_back(moXor   ); continue; }
    if(p.ifToken("*" )) { mo.push_back(moDeaddr); continue; }
    if(p.ifToken("&" )) { mo.push_back(moAddr  ); continue; }
    if(p.ifToken("!" )) { mo.push_back(moNot   ); continue; }
    if(p.ifToken("-" )) { mo.push_back(moNeg   ); continue; }
    if(p.ifToken("++")) { mo.push_back(moInc   ); continue; }
    if(p.ifToken("--")) { mo.push_back(moDec   ); continue; }
    break;
  }

  NodeVar* a = bindVar_2(p);

  while(true) {
    retry:
    if(p.ifToken("->")) {
      a = new NodeDeaddr(a);
      goto xx;
    }
    if(p.ifToken(".")) {
xx:   if(a->dataType.baseType!=cbtStruct || a->dataType.addr!=0) raise("Ожидается структура");
      CStruct& s = get(structs, a->dataType.i);
      for(unsigned int i=0; i<s.items.size(); i++)
        if(p.ifToken(s.items[i].name)) {
          a = nodeAddr(a); // new NodeAddr(a);
          if(s.items[i].offset != 0) {
            a = nodeOperator(oAdd, a, new NodeConst(s.items[i].offset), true);
          }
          CType type = s.items[i].type;
          if(type.arr) {
            a = nodeConvert(a, type);          
          } else {
            type.addr++;
            a = nodeConvert(a, type);          
            a = new NodeDeaddr(a);
          }
          goto retry;
        }
      p.syntaxError();
    }
    if(p.ifToken("[")) {
      NodeVar* i = readVar(-1);
      //! Проверка типов
      p.needToken("]");
      if(i->nodeType == ntConstI && ((NodeConst*)i)->value == 0) {
        delete i;
      } else {
        a = nodeOperator(oAdd, a, i);
      } 
      a = new NodeDeaddr(a);
      continue;
    }
    if(p.ifToken("++")) { a = nodeMonoOperator(a, moPostInc); continue; }
    if(p.ifToken("--")) { a = nodeMonoOperator(a, moPostDec); continue; }
    break;
  }

  // Вычисление моно операторов
  for(int i=mo.size()-1; i>=0; i--) {
    switch(mo[i]) {
      case moDeaddr: a = new NodeDeaddr(a); break;
      case moAddr: a = nodeAddr(a); break;
      case moNot: {
        a = addFlag(a);        
        inverseOperator(a->cast<NodeOperator>());
        break;
      }
      default: a = nodeMonoOperator(a, mo[i]);
    }
  }

  return a;
}

//---------------------------------------------------------------------------
// Компиляция математичесского выражения
// - после выполнения в стеке объект

const char_t* operators [] = { "/", "%", "*", "$", "+", "-", "<<", ">>", "<", ">", "<=", ">=", "==", "!=", "&",  "^",  "|", "&&",  "||", "?", "=", "+=", "-=", "*=", "/=", "%=", ">>=", "<<=", "&=", "^=", "|=", 0 };
int           operatorsP[] = { 12,  12,  12,  12,   11,  11,  10,   10,   9,   9,   9,     9,    8,   8,    7,    6,    5,   3,     2,    1,   0,   0,    0,    0,    0,    0,    0,     0,     0,    0,    0       };
Operator      operatorsI[] = { oDiv,oMod,oMul,oMul8,oAdd,oSub,oShl, oShr, oL,  oG,  oLE,  oGE,  oE,   oNE,  oAnd, oXor, oOr, oLAnd, oLOr, oIf, oSet,oSAdd,oSSub,oSMul,oSDiv,oSMod,oSShr, oSShl, oSAnd,oSXor,oSOr    };

Operator findOperator(Parser& p, int level, int& l) {
  for(int j=0; operators[j] && operatorsP[j] > level; j++)
    if(p.ifToken(operators[j])) {
      l = operatorsP[j];
      return operatorsI[j];
    }
  return oNone;
}

Node* postIncOpt(Node* v) {
  // Оптимизация
  if(v->nodeType == ntMonoOperator) {
    auto no = (NodeMonoOperator*)v;
    switch(no->o) {
      case moInc: case moPostInc: no->o=moIncVoid; break;
      case moDec: case moPostDec: no->o=moDecVoid; break;
    }
  }
  // PostInc и PostDec могут преобразовываться в A+константа и A-константа.
  if(v->nodeType == ntOperator) {
    auto no = (NodeOperator*)v;
    if(no->b->isConst()) {
      NodeVar* tmp;
      switch(no->o) {
        case oAdd: tmp = no->a; no->a=0; delete no; return tmp;
        case oSub: tmp = no->a; no->a=0; delete no; return tmp;
      }
    }
    // oSet может быть проще
    if(no->o==oSet) {
      no->o = oSetVoid;
    }
  }
  return v;
}

// a & (b | c)
// if(!a) return
// if(b) 

NodeVar* addFlag(NodeVar* a) {
  if(a->nodeType == ntConstI || a->nodeType == ntConstS) {
    raise("Проблемы с оптимизацией");
  }
  if(a->nodeType == ntOperator && a->dataType.baseType == cbtFlags) return a;
  return nodeOperator(oNE, a, new NodeConst(0));
}

NodeVar* readVar(int level) {
  // Чтение аргумента
  NodeVar* a = bindVar();

  // Чтение оператора
  while(true) {    
    int l=0;
    Operator o = findOperator(p, level, l);
    if(o == oNone) break;

    if(o==oIf) {
      NodeVar* t = readVar(-1);
      p.needToken(_T(":"));
      NodeVar* f = readVar(-1);
      a = nodeOperator(oIf, t, f, false, a);
      continue;
    }

    if(o==oLAnd || o==oLOr) l--;

    NodeVar* b = readVar(l);

    if(o==oLAnd || o==oLOr) {
      a = addFlag(a);
      b = addFlag(b);
    }
    
    a = nodeOperator(o, a, b);

    if(o==oLAnd || o==oLOr) {
      a = addFlag(a);
    }
}

  return  a;
}

Node* breakLabel=0, *continueLabel=0;

struct UserLabel {
  string name;
  int l;
  bool created;
};

std::vector<UserLabel> userLabels;

int bindUserLabel(cstring name, bool place) {
  for(unsigned int i=0; i<userLabels.size(); i++)
    if(userLabels[i].name==name) {
      if(place && userLabels[i].created) p.logicError_("Метка уже устанволена");
      userLabels[i].created = place;
      return userLabels[i].l;
    }
  UserLabel& l = add(userLabels);
  l.name = name;
  l.created = place;
  l.l = labelesCnt++;
  return l.l;
}

string getRemark() {
  const char* e = strchr(p.prevCursor, '\r');
  const char* e2 = strchr(p.prevCursor, '\n');
  if(e==0 || e>e2) e=e2;
  int l;
  if(e==0) l = strlen(p.prevCursor); else l = e-p.prevCursor;
  return i2s(p.line)+" "+string(p.prevCursor, l);
}

void linkNode(Node*& first, Node*& last, Node* element) {
  if(element == 0) return;
  element = postIncOpt(element);
  if(first == 0) {
    first = last = element;
  } else {    
    while(last->next) last = last->next;
    last->next = element;
  }
  while(last->next) last = last->next;
}

Node* readBlock() {
  Node *first = 0, *last = 0;
  while(!p.ifToken("}")) {
    linkNode(first, last, readCommand());
  }
  return first;
}

NodeSwitch* lastSwitch;

Node* readCommand1();

// Проверка, можно ли условие переместить в конец цикла

bool ifOptimization(Node* aFirst, NodeVar* cond) {
  // Пока оптимизируются только условия for(v = ?; v <=> ?

  if(aFirst==0 || cond==0) return false;

  // Константу нельзя передавать в addFlag
  if(cond->isConst()) return false;

  // Приводим к стандартному условию
  cond = addFlag(cond);

  // Если блок инициализации содержит один оператор VAR=CONST
  if(aFirst->next==0 && aFirst->nodeType==ntOperator) {
    auto initOp = aFirst->cast<NodeOperator>();
    if(initOp->o==oSetVoid && initOp->b->nodeType==ntConstI && initOp->a->nodeType==ntDeaddr) {
      auto initX = initOp->a->cast<NodeDeaddr>();
      if(initX->var->nodeType==ntConstS) {
        auto initVal = initOp->b->cast<NodeConst>()->value;
        auto initVar = initX->var->cast<NodeConst>()->var;
        // Если блок условия содержит один оператор VAR<=>CONST
        if(cond->nodeType==ntOperator) {
          auto o = cond->cast<NodeOperator>();
          if(o->b->nodeType==ntConstI) {
            auto condVal = o->b->cast<NodeConst>()->value;
            if(o->a->nodeType==ntDeaddr && o->a->cast<NodeDeaddr>()->var->nodeType==ntConstS && o->a->cast<NodeDeaddr>()->var->cast<NodeConst>()->var == initVar) {
              // Приводим число к нужному типу.
              auto type = o->a->cast<NodeConst>()->dataType.baseType;
              switch(type) {
                case cbtChar:   initVal = (char)initVal; condVal = (char)condVal; break;
                case cbtUChar:  initVal = (unsigned char)initVal; condVal = (unsigned char)condVal; break;
                case cbtShort:  initVal = (short)initVal; condVal = (short)condVal; break;
                case cbtUShort: initVal = (unsigned short)initVal; condVal = (unsigned short)condVal; break;
                default: return false;
              }
              // Сравниваем
              switch(o->o) {
                case oL:  return (initVal <  condVal);
                case oG:  return (initVal >  condVal);
                case oLE: return (initVal <= condVal);
                case oGE: return (initVal >= condVal);
                case oE:  return (initVal == condVal);
                case oNE: return (initVal != condVal);
              }
            }
          }
        }
      }
    }
  }
  return false;
}

Node* readCommand() {
  string r = getRemark();
  Node* n = readCommand1();
  if(n) {
    n->remark = r;
  }
  return n;
}

Node* readCommand1() {
  if(p.ifToken(";")) return 0;

  ParserLabel pl = p.label();
  if(p.cursor[0]==':' && p.ifToken(ttWord)) {
    string t = p.buf; //tokenText;
    if(p.ifToken(":")) {
      //! w.label(bindUserLabel(t, true));
    } else {
      p.jump(pl, false);
    }
  }

  /*
  if(p.ifToken("goto")) {
    const char* l = p.needIdent();
    w.jmp(bindUserLabel(l, false));
    p.needToken(";");
    return;
  }
  */

  if(p.ifToken("{")) {
    return readBlock();
  }

  if(p.ifToken("break")) {
    if(breakLabel == 0) p.logicError_("break без for, do, while, switch");
    p.needToken(";");
    return new NodeJmp(breakLabel, 0, 0);    
  }

  if(p.ifToken("continue")) {
    if(continueLabel == 0) p.logicError_("continue без for, do, while");
    p.needToken(";");
    return new NodeJmp(continueLabel, 0, 0);
  }

  if(p.ifToken("asm")) {
    const char* x = p.prevCursor+1;
    if(x[0]==13) x++;
    if(x[0]==10) x++;
    p.needToken("{");
    p.numbersAsString = true;
    while(p.tokenText[0]!='}' || p.tokenText[1]!=0) {
      if(p.ifToken(ttEof)) p.syntaxError();
      p.nextToken();
    }
    p.numbersAsString = false;
    string s = string(x, p.prevCursor-x);
    p.needToken("}");
    return new NodeAsm(s);
  }

  if(p.ifToken("while")) {
    // Выделяем метки
    auto oldBreakLabel = breakLabel; breakLabel = new NodeLabel;
    auto oldContinueLabel = continueLabel; continueLabel = new NodeLabel;
    // Код
    Node *first=0, *last=0;
    p.needToken("(");    
    linkNode(first, last, continueLabel);
    NodeVar* cond = readVar(-1);
    p.needToken(")"); 
    Node* body = readCommand();
    if(body) {
      linkNode(first, last, new NodeJmp(breakLabel, cond, true));
      linkNode(first, last, body);
      linkNode(first, last, new NodeJmp(continueLabel, 0, 0));
    } else {
      // Если тела нет, то можно обойтись без jmp      
      linkNode(first, last, new NodeJmp(continueLabel, cond, false));
    }
    linkNode(first, last, breakLabel);
    breakLabel    = oldBreakLabel;
    continueLabel = oldContinueLabel;
    return first;
  }

  if(p.ifToken("do")) {
    auto oldBreakLabel = breakLabel; breakLabel = new NodeLabel;
    auto oldContinueLabel = continueLabel; continueLabel = new NodeLabel;
    Node *first=0, *last=0;
    linkNode(first, last, continueLabel);
    linkNode(first, last, readCommand());
    p.needToken("while");
    p.needToken("(");
    linkNode(first, last, new NodeJmp(continueLabel, readVar(-1), false));    
    p.needToken(")");
    breakLabel    = oldBreakLabel;
    continueLabel = oldContinueLabel;
    return first;
  }

  if(p.ifToken("for")) {
    auto oldBreakLabel = breakLabel; breakLabel = new NodeLabel;
    auto oldContinueLabel = continueLabel; continueLabel = new NodeLabel;
    auto startLabel = new NodeLabel;
    auto enterLabel = new NodeLabel;
    p.needToken("(");
    Node *aFirst=0, *aLast=0;
    if(!p.ifToken(";")) {
      do {
        linkNode(aFirst, aLast, readVar(-1));
      } while(p.ifToken(","));
      p.needToken(";");
    }
    NodeVar* cond = 0;
    if(!p.ifToken(";")) {      
      cond = readVar(-1);
      p.needToken(";");
    }
    Node *cFirst=0, *cLast=0;
    if(!p.ifToken(")")) {      
      do {
        linkNode(cFirst, cLast, readVar(-1)); 
      } while(p.ifToken(","));
      p.needToken(")"); 
    }

    Node* cmd = readCommand();

    bool ifOpt = ifOptimization(aFirst, cond);

    if(ifOpt && cond) {
      linkNode(aFirst, aLast, startLabel);
      linkNode(aFirst, aLast, cmd);
      linkNode(aFirst, aLast, continueLabel);
      if(cFirst) linkNode(aFirst, aLast, cFirst);      
      linkNode(aFirst, aLast, new NodeJmp(startLabel, cond, false));
    } else {
      linkNode(aFirst, aLast, startLabel);
      if(!cFirst) linkNode(aFirst, aLast, continueLabel);
      if(cond) linkNode(aFirst, aLast, new NodeJmp(breakLabel, cond, true));
      linkNode(aFirst, aLast, cmd);
      if(cFirst) {
        linkNode(aFirst, aLast, continueLabel);
        linkNode(aFirst, aLast, cFirst);
        linkNode(aFirst, aLast, new NodeJmp(startLabel, 0, 0));
      } else {
        linkNode(aFirst, aLast, new NodeJmp(startLabel, 0, 0));
      }
      linkNode(aFirst, aLast, breakLabel);
    }
    breakLabel    = oldBreakLabel;
    continueLabel = oldContinueLabel;
    return aFirst;
  }

  if(p.ifToken("if")) {
    p.needToken("(");
    NodeVar* cond = readVar(-1);    
    p.needToken(")"); 
    Node* t = readCommand();
    Node* f = 0;
    if(p.ifToken("else")) f = readCommand();

    // Оптимизация //! Условие 1==1
    if(cond->nodeType == ntConstI) {
      if(cond->cast<NodeConst>()->value) {
        delete cond;
        delete f;
        return t;
      } else {
        delete cond;
        delete t;
        return f;
      }
    }

    return new NodeIf(cond, t, f);
  }

  if(p.ifToken("switch")) {
    auto oldBreakLabel = breakLabel; breakLabel = new NodeLabel;
    p.needToken("(");
    NodeVar* var = readVar(-1);
    p.needToken(")"); 
    p.needToken("{");
    auto s = new NodeSwitch(var);
    auto saveSwitch = lastSwitch; lastSwitch = s;
    Node *first=0, *last=0;
    linkNode(first, last, readBlock());
    linkNode(first, last, breakLabel);    
    s->body = first;
    if(!s->defaultLabel) s->defaultLabel = breakLabel;
    lastSwitch = saveSwitch;
    breakLabel = oldBreakLabel;
    return s;
  }

  if(lastSwitch && p.ifToken("default")) {
    p.needToken(":");
    Node* n = new NodeLabel;
    lastSwitch->setDefault(n);
    return n;
  }

  if(lastSwitch && p.ifToken("case")) {         
    int i = readConst(lastSwitch->var->dataType);
    p.needToken(":");
    Node* n = new NodeLabel;
    lastSwitch->addCase(i, n);
    return n;
  }

  if(p.ifToken("return")) {
    if(!retType.isVoid()) return new NodeReturn(nodeConvert(readVar(-1), retType));
    return new NodeReturn(0);
  }

  bool reg = p.ifToken("register");  
  CType t = readType(p, false);    
  if(t.baseType != cbtError) {
    Node *first=0, *last=0;
    do {
      CType t1 = t;
      readModifiers(p, t1);
      const char* n = p.needIdent();
      stackNamesI[n] = stackNamesD.size();
      Var& v = add(stackNamesD);
      v.name = n;
      if(p.ifToken("[")) {
        t1.arr = readConstV(); //p.needInteger();
        if(t1.arr <= 0) raise("[]");
        p.needToken("]");
        t1.addr++;
      }
      //const char* nn = stringBuf(n);
      v.type = t1;
      asm_decl(curFn->decl, fnName, n, t1);
      CType t2 = t1;
      t2.addr++;
      NodeConst nc(fnName+"_"+n, t2, /*stack*/true);
      curFn->localVars.push_back(nc.var);
      if(p.ifToken("=")) {
        //putRemark();
        linkNode(first, last, nodeOperator(oSet, new NodeDeaddr(new NodeConst(fnName+"_"+n, t2, /*stack*/true)), nodeConvert(readVar(-1), t1)));        
      }
    } while(p.ifToken(","));
    p.needToken(";");
    return first;
  }
  if(reg) p.syntaxError();

  // Команды    
  Node *first=0, *last=0;
  
  do {
    linkNode(first, last, readVar(-1));
  } while(p.ifToken(","));
  p.needToken(";");
  return first;
}

const char_t* operators1[] = {
  ".", "..", "...", "++", "--", "/", "%", "*", "$", "+", "-", 
  "<<", ">>", "<", ">", "<=", ">=", "==", "!=", "&",  "^",  "|", "&&",
  "||", "?", "=", "+=", "-=", "*=", "/=", "%=", ">>=", "<<=", "&=", "^=", "|=", 
  "->", "//", "/*", "//", 0 
};

int userStructCnt=0;

void parseStruct(CStruct& s, int m);

int parseStruct2(int m) {
  CStruct& s1 = add(structs);
  int si = structs.size()-1;
  s1.size = 0;
  if(!p.ifToken("{")) {
    s1.name = p.needIdent();
    p.needToken("{");
  } else {
    s1.name = "?"+i2s(userStructCnt++);
  }
  parseStruct(s1, m);
  return si;
}

void parseStruct(CStruct& s, int m) {
  do {
    CType type0;
    const char* xx[] = { "struct", "union", 0 };
    int su;
    if(p.ifToken(xx, su)) {
      int si = parseStruct2(su);  
      if(p.ifToken(";")) {
        CStruct& s1 = get(structs, si);
        int ss = s.items.size();
        for(unsigned int j=0; j<s1.items.size(); j++)
          s.items.push_back(s1.items[j]);
        if(m==0)
          for(unsigned int i=ss; i<s.items.size(); i++)
            s.items[i].offset += s.size;
        int ts = s1.size;
        if(m==0) s.size += ts; else if(s.size < ts) s.size = ts;
        continue;
      }
      type0.baseType = cbtStruct;
      type0.i = si; //tructs.size()-1;
    } else {
      type0 = readType(p, true);
    }
    do {
      CStructItem& si = add(s.items);
      CType type = type0;
      readModifiers(p, type);
      si.type = type;
      si.offset = m==0 ? s.size : 0;
      si.name = p.needIdent();
      if(si.type.arr==0 && p.ifToken("[")) {
        si.type.arr = readConstV();
        p.needToken("]");
        if(si.type.arr<=0) raise("struct size");
      }
      int ts = si.type.size();
      if(m==0) s.size += ts; else if(s.size < ts) s.size = ts;
      if(si.type.arr) si.type.addr++;
    } while(p.ifToken(","));
    p.needToken(";");
  } while(!p.ifToken("}"));
}

Function* findFunction(cstring name) {
  for(auto f=functions.begin(); f!=functions.end(); f++)
    if(f->name == name)
      return &*f;
  return 0;
}

void parseStructHdr(int m) {
  CStruct& s = add(structs);
  s.name = p.needIdent();
  s.size = 0;
  p.needToken("{");
  parseStruct(s, m);
  p.needToken(";");
}

void parseFunction(CType& retType, cstring fnName) {
  std::vector<CType> argTypes;
  if(!p.ifToken(")")) {
    do {
      if(p.ifToken("...")) {
        //! any
        break;
      }

      CType t = readType(p, true);
      readModifiers(p, t);
      if(t.baseType==cbtVoid && t.addr==0) break;      
      if(p.ifToken(ttWord)) {
        //nn = stringBuf(p.buf);
        stackNamesI[p.buf] = stackNamesD.size();
//        argNames.push_back(p.buf);
      } else {
//        argNames.push_back("");
      }
      if(p.ifToken("[")) {
        p.needToken("]");
        t.addr++;
      }
      argTypes.push_back(t);
      Var& v = add(stackNamesD);      
      v.indexName = argTypes.size();
      v.type = t;      
    } while(p.ifToken(","));
    p.needToken(")");
  }

  Function* f = findFunction(fnName);
  if(f == 0) {
    functionNames.push_back(fnName);
    Function& f1 = add(functions);      
    f1.name = fnName;
    f1.args = argTypes;
    f1.retType = retType;
    f = &f1;
  } else {
    // Сранить типы
  }
   
  ::fnName = fnName;
  ::retType = retType;  

  if(p.ifToken("@")) {
    if(p.ifInteger(f->addr)) {
      p.needToken(";");
      f->callAddr = true;
      return;
    }
    f->needInclude = p.needString2();
    p.needToken(";");
    return;
  }

  if(p.ifToken(";")) return; // proto

  //asm_preStartProc(fnName);

  p.needToken("{");

  int opt=0;

  if(!retType.isVoid() && !retType.isStackType()) {
      asm_decl(f->decl, fnName, "0", retType);
  }

  for(unsigned int i=0; i<f->args.size(); i++) {
    //! if(i==f.argNames.size()-1 && f.args[i].isStackType()) break;
    asm_decl(f->decl, fnName, i2s(i+1), f->args[i]);
  }

//  retPopBC = true/*opt!=0*/;
 // int cc = asm_startProc(fnName);

//  if(f.args.size() != 0) {
//    CType t = f.args.back();
//    if(t.isStackType() && stackNamesD[f.args.size()-1].name!=0) {
//      if(t.is8()) w.ld_ref_a (fnName+"_"+i2s(f.args.size()));
//             else w.ld_ref_hl(fnName+"_"+i2s(f.args.size()));
//    }
//  }


//  retPopBC = opt!=0;
//  asm_correctProc(cc, opt!=0);

  //returnLabel = labelesCnt++;
  curFn = f;
  f->rootNode = readBlock();
  curFn = 0;

  if(!f->rootNode) {
    f->rootNode = new NodeReturn(0);
  } else {
    Node* n = f->rootNode;  
    while(n->next) n = n->next;
    if(n->nodeType != ntReturn) {
      n->next = new NodeReturn(0);
    }
  }
  
  //asm_label(returnLabel);

//  asm_endProc(retPopBC);
}

string findDir(string fileName1) {
  string fn;
  for(unsigned int i=0; i<includeDirs.size(); i++) {
    fn = catPath(includeDirs[i], fileName1);
    if(fileExists(fn))
      return fn;
  }
  p.logicError_("Файл "+fileName1+" не найден");  
  throw;
}

const char* getString1(int n) {
  for(auto i=strs.begin(), ie=strs.end(); i!=ie; ++i) {
    if(i->second == n) {
      return i->first.c_str();
    }
  }
  return "";
}

void arrayInit(std::vector<char>& data, CType& fnType) {
  // Эта функция не генерирует код
  NodeVar* c = readVar(-1);

  if(fnType.size()==1) { //|| (fnType.addr==1 && (fnType.baseType==cbtChar || fnType.baseType==cbtUChar))
    if(c->nodeType == ntConstI) {
      data.push_back(c->cast<NodeConst>()->value & 0xFF);
      delete c;
      return;
    }
    raise("not imp");
  }

  if(fnType.addr) { //|| (fnType.addr==1 && (fnType.baseType==cbtChar || fnType.baseType==cbtUChar))
    if(c->nodeType == ntConstI) {
      int v = c->cast<NodeConst>()->value;
      data.push_back(v & 0xFF);
      data.push_back((v >> 8) & 0xFF);
      delete c;
      return;
    }
    raise("not imp");
  }

  /*
  if(fnType.size()==2) {
//    init2.str(" .dw ");
    mask = 0xFFFF;
  } else {
    p.logicError_("Только 8 и 16 бит");
  }
  */

  raise("not imp");
}

FillBuffer outDecl;

void ignoreTo(bool canElse) {
  for(;;) {
    if(p.ifToken(ttEof)) p.syntaxError("Ожидается #endif");
    if(!p.ifToken("#")) { p.nextToken(); continue; }
    if(p.ifToken("endif")) return;
    if(p.ifToken("else")) {
      if(!canElse) p.syntaxError("Тут не может быть #endif");
      return;
    }
    //! Вложенность    
  }    
}

void compileFile(cstring fileName) {
  includeDirs.resize(1);
  includeDirs.push_back(getPath(fileName));

  //!structs.clear(); 
  //!typedefs.clear();
  globalNames.resize(0);
  globalTypes.resize(0);
  structs.resize(0);
  typedefs.resize(0);
  // p.macro
  p.cescape = true;

  string text;
  p.deleteMacro();
  if(z80) p.addMacro("__Z80", "", std::vector<string>());
  p.fileName = fileName;
  loadStringFromFile(text, fileName);		
  p.operators = &operators1[0];
  static const char* rem[] = { "//", 0 };
  p.rem = rem;
  static const char* brem[] = { "/*", 0 };
  p.brem = brem;
  static const char* erem[] = { "*/", 0 };
  p.erem = erem;
  p.preprocessor = [&]() {
    if(p.ifToken("include")) {
      //p.needEol = true;
      string fileName1 = p.readDirective();
      while(fileName1[fileName1.size()-1]==13 || fileName1[fileName1.size()-1]==10)
        fileName1.resize(fileName1.size()-1);
      if((fileName1[0]=='"' && fileName1[fileName1.size()-1]=='"') || (fileName1[0]=='<' && fileName1[fileName1.size()-1]=='>')) { 
        fileName1.assign(fileName1.c_str()+1, fileName1.size()-2);
      } else {
        raise("Имя файла должно быть в скобках");
      }

      string fn = findDir(fileName1);

      string buf = loadStringFromFile(fn);
      //p.needEol = false;
      //p.needToken(ttEol);      
      p.macroOff = false;
      p.enterMacro(0, &buf, -1, false /*, true*/);
      p.fileName = fileName1;
      return;
    };
    if(p.ifToken("define")) {
      string dir = p.readDirective();
      Parser pa;
      pa.loadFromString(dir.c_str());
      ParserLabel pl;
      pl = pa.label();
      bool argsE = (pa.cursor[0]=='(');
      string id = pa.needIdent();
      std::vector<string> args;
      if(argsE) {
        pa.needToken("(");
        do {
          args.push_back(pa.needIdent());
        } while(pa.ifToken(","));
        pl = p.label();
        pa.needToken(")");
      }
      //p.jump(pl, true);
      string body = pa.readDirective();
      p.addMacro(id, body, args);
      return;
    }
    if(p.ifToken("undef")) {
      string id = p.needIdent();
      p.readDirective();
      p.deleteMacro(id);
      return;
    }
    if(p.ifToken("else")) {          
      ignoreTo(false);
      return;
    }
    if(p.ifToken("endif")) {          
      return;
    }
    if(p.ifToken("ifdef")) {
      string id = p.needIdent();
      if(!p.findMacro(id)) {
        ignoreTo(true);
      }
      return;
    }
    p.logicError_("Эта команда препроцессора не реализована");
  };
  p.loadFromString_noBuf(text.c_str());

  while(!p.ifToken(ttEof)) {
    stackNamesI.clear();
    stackNamesD.resize(0);
    //stackTypes.resize(0);

    bool typedef1 = p.ifToken("typedef");
    bool extren1 = !typedef1 && p.ifToken("extern");
    bool static1 = !typedef1 && !extren1 && p.ifToken("static");

    CType fnType1;

    fnType1 = readType(p, true);    

    if(p.ifToken(";")) continue;

    while(1) {
      CType fnType = fnType1;
      readModifiers(p, fnType);
      string fnName = p.needIdent();

      if(p.ifToken("(")) {
        if(typedef1) p.logicError_("typedef не поддерживает функции");
        parseFunction(fnType, fnName);
        break;
      }

//      fnType.place = pConstRef;

      if(fnType.arr==0 && p.ifToken("[")) {
        if(p.ifToken("]")) {
          fnType.arr = 1; 
        } else {
          fnType.arr = readConstV();
          if(fnType.arr <= 0) raise("[]");
          p.needToken("]");
        }
        fnType.addr++;
//        fnType.place = pConst;
        if(p.ifToken("[")) {
          fnType.addr++;
          fnType.arr2 = p.needInteger();
          if(fnType.arr2 <= 0) raise("[]");
          p.needToken("]");
          if(p.ifToken("[")) {
            fnType.addr++;
            fnType.arr3 = p.needInteger();
            if(fnType.arr3 <= 0) raise("[]");
            p.needToken("]");
          }
        }
      }

      if(typedef1) {
        Typedef& t = add(typedefs);
        t.name = fnName;
        t.type = fnType;
      } else {
        if(!extren1) {
          std::vector<char_t> data;
          //bool ptr = fnType.arr==0 && fnType.addr;
          if(p.ifToken("=")) {                   
            string s;
            if(p.ifString2(s)) {
              int ptr = 0;
              do {
                data.resize(ptr+s.size()+1);
                memcpy(&data[ptr], s.c_str(), s.size()+1);
                ptr += s.size();
              } while(p.ifString2(s));              
            } else 
            if(fnType.addr>0 && p.ifToken("{")) {
              CType fnType1 = fnType;
              fnType1.addr--;
              fnType1.arr=0;
              while(1) {
                if(p.ifToken("}")) break;
                if(fnType1.addr==0 && fnType1.arr==0 && fnType1.baseType==cbtStruct) {
                  if(p.ifToken("{")) {
                    CStruct& s = get(structs, fnType1.i);
                    for(unsigned int u=0; u<s.items.size(); u++) {
                      if(u>0) p.needToken(",");
                      arrayInit(data, s.items[u].type);
                    }
                    p.needToken("}");
                  }
                } else {
                  arrayInit(data, fnType1);
                }
                if(p.ifToken("}")) break;
                p.needToken(",");
              }
            } else {
              if(fnType.arr) p.logicError_("Нельзя задавать адрес массива");
              arrayInit(data, fnType);
//              ptr = false;
            }
          }

          if(fnType.arr2!=0) {
            // Указатель на данные
            fnType.addr--;
            asm_decl3(outDecl, fnName, fnType.size()*fnType.arr2 - data.size(), &data, fnType.arr, fnType.size());
            fnType.addr++;
          } else {
            asm_decl3(outDecl, fnName, fnType.size() - data.size(), &data, fnType.arr==0 && fnType.addr!=0);
          }
        } else {
          if(p.ifToken("@")) {
/*            if(p.ifInteger(f.addr)) {
              p.needToken(";");
              f.callAddr = true;
              return;
            }*/
            fnType.needInclude = p.needString2();
          }
        }
        globalNames.push_back(fnName);
        globalTypes.push_back(fnType);
      }

      if(p.ifToken(";")) break;
      p.needToken(",");
    }
  }
}

//===========================================================================
// Ассемблер
//===========================================================================



//-----------------------------------------------------------------------------


/*
bool s.de.used = false;
bool s.hl.used = false;
bool s.a.used  = false;
bool s.a.const_ = false;
bool s.a.changed = false;
int  s.a.const_value;
bool s.hl.const_ = false;
bool s.hl.changed = false;
bool inDE_changed = false;
int  inHL_const_value;
int  s.hl.delta; // Если HL!=0, то значение переменной, которая хранится сейчас в HL, увеличено от нормы. Если HL==0, то временное значение, переменной HL_tmp, увеличено от нормы
bool inDE_const = false;
int  inDE_const_value;
int  inDE_delta = 0;
int  inBC_delta = 0;
NodeVariable* s.hl.tmp; // HL содержит значение переменнйо в памяти, 
NodeVariable* s.a.in;
NodeVariable* s.hl.in;
NodeVariable* s.de.in;
*/

bool argPriority2(NodeVar* a) {
  if(a->isConst()) return true;
  if(a->nodeType == ntDeaddr && a->cast<NodeDeaddr>()->var->isConst()) return true;
  return false;
}

Assembler::Reg8 toAsmReg8(Reg reg) {
  switch(reg) {
    case regA: return Assembler::A;
    case regB: return Assembler::B;
    case regBC:
    case regC: return Assembler::C;
    default: throw Exception("toAsmReg8");
  }
}

Assembler::Reg16 toAsmReg16(Reg reg) {
  switch(reg) {
    case regHL: return Assembler::HL;
    case regDE: return Assembler::DE;
    case regBC: return Assembler::BC;
    default: throw Exception("toAsmReg16");
  }
}



inline void setDeConst(int value) {
  s.de.used = true;
  s.de.const_ = true;
  s.de.const_value = value;
} 

inline void setHlConst(int value) {
  s.hl.used = true;
  s.hl.const_ = true;
  s.hl.const_value = value;
} 

inline void setDeUsed(bool v) { s.de.used = v; s.de.const_ = false; }
inline void setAUsed(bool v) { s.a.used = v; s.a.const_ = false; }
inline void setHlUsed(bool v) { s.hl.used = v; s.hl.const_ = false; }
  


bool loadInDE(NodeConst* nc, bool neg, const std::function<bool()>& result) {
  if(nc->dataType.is8()) {
    if(nc->nodeType == ntConstS) {
      setDeUsed(true);
      if(neg) out.mvin(Assembler::D, nc->var->name.c_str());
         else out.mvi (Assembler::D, nc->var->name.c_str());    
      return result(); 
    }
    if(nc->nodeType == ntConstI) {
      int v = (neg ? -nc->value : nc->value) & 0xFF;
      //!if(inDE_const && (inDE_const_value & 0xFF) == v) return result(); 
      //setDeConst(v);
      setDeUsed(true); // Испорчено DE
      out.mvi(Assembler::D, v);  
      return result(); 
    }
    throw;
  }
  if(nc->dataType.is16()) {
    if(nc->nodeType == ntConstS) {
      setDeUsed(true);
      if(neg) out.lxin(Assembler::DE, nc->var->name.c_str());
         else out.lxi (Assembler::DE, nc->var->name.c_str());    
      return result(); 
    }
    if(nc->nodeType == ntConstI) {
      int v = (neg ? -nc->value : nc->value) & 0xFFFF;
      if(s.de.const_ && (s.de.const_value & 0xFFFF) == v) return result(); 
      setDeConst(v);
      out.lxi(Assembler::DE, v);  
      return result(); 
    }
    throw;
  }
  throw;
};

//===========================================================================
// Копиляция
//===========================================================================

//int deepLimit=0;

/*class DeepException {
public:
  int total;
  DeepException(int _total) { total=_total; }
};*/

#define DEEP { if(out.deepLimit==0) return true; }



//-----------------------------------------------------------------------------







// Компиляция выражения




void firstArg(Function* f, const std::function<void()>& result) {  
  if(f->args.size() == 0) { result(); return; }
  int n = f->args.size()-1;
  auto& t = f->args[n];
  if(!t.isStackType()) { result(); return; }
  if(t.is8()) {
    t.addr++;
    NodeConst nc(f->name+"_"+i2s(n+1), t);    
    loadInA(nc.var);
    s.a.changed = true;
    result();
  } else {    
    t.addr++;
    NodeConst nc(f->name+"_"+i2s(n+1), t);    
    loadInHL(nc.var);    
    s.hl.changed = true;
    result();
  }
}

void calcVarUsing(std::map<NodeVariable*, int>& varUsing, Node* n) {
  for(;n; n=n->next) {
    switch(n->nodeType) {
      case ntConvert: calcVarUsing(varUsing, n->cast<NodeConvert>()->var); break;
      case ntDeaddr: calcVarUsing(varUsing, n->cast<NodeDeaddr>()->var); break;
      case ntReturn: calcVarUsing(varUsing, n->cast<NodeReturn>()->var); break;
      case ntMonoOperator: calcVarUsing(varUsing, n->cast<NodeMonoOperator>()->a); break;
      case ntJmp: calcVarUsing(varUsing, n->cast<NodeJmp>()->cond); break;
      case ntConstS:  {
        auto v = n->cast<NodeConst>()->var;
        if(varUsing.find(v)!=varUsing.end()) varUsing[v]++;
        break;
      }
      case ntCallS:
      case ntCallI: {
        auto c = n->cast<NodeCall>();
        for(auto& a : c->args)
          calcVarUsing(varUsing, a);
        break;
      }
      case ntSwitch: {
        auto c = n->cast<NodeSwitch>();
        calcVarUsing(varUsing, c->var);
        calcVarUsing(varUsing, c->body);
        break;
      }
      case ntOperator: {
        auto c = n->cast<NodeOperator>();
        calcVarUsing(varUsing, c->a);
        calcVarUsing(varUsing, c->b);
        break;
      }
      case ntIf: {
        auto c = n->cast<NodeIf>();
        calcVarUsing(varUsing, c->cond);
        calcVarUsing(varUsing, c->t);
        calcVarUsing(varUsing, c->f);
        break;
      }
      case ntNop:
      case ntConstI:
      case ntLabel:
      case ntAsm:
      case ntCond:
        break;
      default:
        assert(0);
    }
  }
}

bool caclRegVars(Function* f) {
  // Список локальных переменных
  std::map<NodeVariable*, int> varUsing;
  for(auto& v : f->localVars) {
    v->reg = regNone;
    varUsing[v] = 0;
  }

  // Собираем статистику по локальным переменным
  calcVarUsing(varUsing, f->rootNode);
    
  // Ищем переменную с большим кол-вом обращений
  std::map<int, NodeVariable*> varUsing8;
  std::map<int, NodeVariable*> varUsing16;
  for(auto v : varUsing) {
    //if(v.second < 3) continue;
    CType t = v.first->dataType;
    if(t.addr==0 || t.arr!=0 ) 
      continue;
    t.addr--;
    if(t.is8 ()) varUsing8 [-v.second] = v.first; else
    if(t.is16()) varUsing16[-v.second] = v.first;
  }

  // Считаем кол-во обращений
  int total8;
  auto x = varUsing8.begin();
  if(x == varUsing8.end()) total8=0; else { total8 = -x->first; auto x1 = x; x1++; if(x1 != varUsing8.end()) total8 += -x1->first; }

  int last=-1;
  for(auto v : varUsing8) {
    if(last != -1 && last < -v.first) throw;
    last = -v.first;
  }

  int total16;
  auto y = varUsing16.begin();
  if(y == varUsing16.end()) total16 = 0; else total16 = -y->first;

  // Переменные разраем большему
  if(total8 > total16) {
    if(x == varUsing8.end()) return false;
    x->second->reg = regB;
    x++;
    if(x != varUsing8.end()) {
      x->second->reg = regC;
    }
  } else {
    if(y == varUsing16.end()) return false;
    y->second->reg = regBC;
  }
  return true;
}

void buildFunction(FillBuffer& out1, Function* f, bool z80, char* needs) {
  if(f->rootNode) {
    // Очищаем регистры        
    s.hl.in=0; s.hl.const_=false; 
    s.hl.tmp=0;
    s.a.in=0; s.a.const_=false; 
    FillBuffer tmp2;
    FillBuffer tmp;

    Assembler asmBest;
    cmdLimit = -1;
    deepLimit = -1;

    retWithBC = caclRegVars(f);

    if(retWithBC) out.push(Assembler::BC);
    firstArg(&*f, [&]() {
      compile(f->rootNode, [&]() {
        //if(asm1.ptr>0 && asm1.items[asm1.ptr-1].cmd==Assembler::cCALL) {
        //  asm1.items[asm1.ptr-1].cmd = Assembler::cJMP;
       // }
       if(deepLimit>=0) {
         return true;
       }
       //if(asmBest.ptr == 0 || out.ptr < asmBest.ptr) //! Оптимизация по размеру!!!
       if(asmBest.t == 0 || out.t < asmBest.t) //! Оптимизация по размеру!!!
         if(out.incorrectFork==0)
            asmBest.swap(out);
       return false;
      });
    });
    out1.str("; --------------------------------------------------------------\r\n");
    out1.str(f->name).str(":\r\n");        
    if(z80) asmBest.build_z80(out1);    
       else asmBest.build(out1);    

     for(int i=0; i<asmBest.ptr; i++) {
       auto& e = asmBest.items[i];
       if(e.cmd==Assembler::cCALL) {
         assert(e.b>=0 && e.b<need_cnt);
         needs[e.b] = 1;
       }
     }
  }
}

//#include <sstream>
//#include <algorithm>

int main(const char_t* lpCmdLine) {
  /*
  std::string in = "Земля в иллюминаторе земля в иллюминаторе видна. Еще какое то предложение";

  std::string out;  
  for(int start=0; start < in.size();) {
    int end = in.find('.', start);    
    if(end == -1) end = in.size();
    std::string a = in.substr(start, end);
    std::vector<std::string> words = std::vector<std::string>(std::istream_iterator<std::string>(std::istringstream(a)), std::istream_iterator<std::string>());
    int ignore = -1;
    if(words.size() % 2 != 0) ignore = (words.size() / 2);
    for(int i = words.size()-1; i>=0; i--)
      if(i != ignore)
        out += words[i] + " ";
    out += ".";
    start = end + 1;
  }
  MessageBox(0,out.c_str(),"",0);
  */
  try {
    char exeName[MAX_PATH+1];
    GetModuleFileName(GetModuleHandle(0), exeName, MAX_PATH);
    includeDirs.push_back(catPath(getPath(exeName), "Include"));

    std::vector<string> files1;
    explode1(files1, " ", lpCmdLine);

    std::vector<string> files;
    string asmFile;
    z80 = false;
    for(int i=0; i<files1.size(); i++) {
      string& f = files1[i];
      if(f=="-z80") {
        z80=true;
        continue;
      }
      if(f=="-out") {
        if(i+1 >= files1.size()) raise("Incorrect arguments");
        asmFile = files1[i+1];
        i++;
        continue;
      }
      files.push_back(f);
    }

    if(asmFile.empty()) {
      asmFile = files[0];
      int e = asmFile.rfind('.');
      int d = asmFile.rfind('/');
      int d1 = asmFile.rfind('\\');
      if(d!=-1 && d1>d) d = d1;
      if(e>d1) asmFile.resize(e); asmFile += ".asm";
    }

    for(unsigned int i=0; i<files.size(); i++)
      if(!files[i].empty()) {
        string p = getPath(files[i]);
        bool founded = false;
        std::vector<FindData> realFiles;
        findFiles(realFiles, files[i]);
        for(auto& f : realFiles) {
          if(!f.directory) {
            compileFile(p.empty() ? f.name : catPath(p, f.name)); 
            founded = true;
          }
        }
        if(!founded) raise("Файл "+files[i]+" не найден");
      }

    for(unsigned int i=0; i<lastInclude.size(); i++)
      compileFile(findDir(lastInclude[i]));

    FillBuffer out;
    if(!z80) {
      out.str(".include \"stdlib8080.inc\"\r\n");
    } else {
      out.str(" include \"stdlibz80.inc\"\r\n");
    }

    needFunction("main");

    char needs[need_cnt];
    memset(&needs, 0, sizeof(needs));

    for(unsigned int i=0; i<needFunctions.size(); i++) {
      auto& fn = needFunctions[i];
      Function* f = findFunction(fn);
      if(f==0) raise("Функция "+fn+" не найдена");
      buildFunction(out, f, z80, needs);
    }

    out.str("; --------------------------------------------------------------\r\n");
    out.str("; STDLIB\r\n");
    out.str("; --------------------------------------------------------------\r\n");

    // Доп файлы
    if(needs[need_op_cmp16]) out.str(loadStringFromFile(findDir(z80 ? "op_cmp16.z80" : "op_cmp16"))).str("\r\n");
    if(needs[need_op_mul16]) out.str(loadStringFromFile(findDir(z80 ? "op_mul16.z80" : "op_mul16"))).str("\r\n");
    if(needs[need_op_div16]) out.str(loadStringFromFile(findDir(z80 ? "op_div16.z80" : "op_div16"))).str("\r\n");
    if(needs[need_op_sub16]) out.str(loadStringFromFile(findDir(z80 ? "op_sub16.z80" : "op_sub16"))).str("\r\n");
    if(needs[need_op_xor16]) out.str(loadStringFromFile(findDir(z80 ? "op_xor16.z80" : "op_xor16"))).str("\r\n");
    if(needs[need_op_shr16]) out.str(loadStringFromFile(findDir(z80 ? "op_shr16.z80" : "op_shr16"))).str("\r\n");
    if(needs[need_op_shl16]) out.str(loadStringFromFile(findDir(z80 ? "op_shl16.z80" : "op_shl16"))).str("\r\n");
    if(needs[need_op_and16]) out.str(loadStringFromFile(findDir(z80 ? "op_and16.z80" : "op_and16"))).str("\r\n");
    if(needs[need_op_or16 ]) out.str(loadStringFromFile(findDir(z80 ? "op_or16.z80"  : "op_or16" ))).str("\r\n");
    if(needs[need_op_shr8 ]) out.str(loadStringFromFile(findDir(z80 ? "op_shr.z80"   : "op_shr"  ))).str("\r\n");
    if(needs[need_op_shl8 ]) out.str(loadStringFromFile(findDir(z80 ? "op_shl.z80"   : "op_shl"  ))).str("\r\n");
    if(needs[need_op_mul  ]) out.str(loadStringFromFile(findDir(z80 ? "op_mul.z80"   : "op_mul"  ))).str("\r\n");
    //if(need_op_mul  ) out.str(loadStringFromFile(findDir("op_mul"  ))).str("\r\n");
    //if(need_op_add  ) out.str(loadStringFromFile(findDir("op_add"  ))).str("\r\n");
    //if(need_op_div  ) out.str(loadStringFromFile(findDir("op_div"  ))).str("\r\n");
    //if(need_op_sub  ) out.str(loadStringFromFile(findDir("op_sub"  ))).str("\r\n");

    out.str("; --------------------------------------------------------------\r\n");
    out.str("; STRINGS\r\n");
    out.str("; --------------------------------------------------------------\r\n");

    for(auto s=strs.begin(); s!=strs.end(); s++)
      out.str("str").i2s(s->second).str(": .db \"").str(s->first).str("\", 0\r\n");

    out.str("; --------------------------------------------------------------\r\n");
    out.str("; GLOBAL VARS\r\n");
    out.str("; --------------------------------------------------------------\r\n");

    out.str(outDecl);

    out.str("; --------------------------------------------------------------\r\n");
    out.str("; FUNCTION VARS\r\n");
    out.str("; --------------------------------------------------------------\r\n");

    for(unsigned int i=0; i<needFunctions.size(); i++) {
      auto& fn = needFunctions[i];
      Function* f = findFunction(fn);
      if(f==0) raise("Функция "+fn+" не найдена");
      out.str(f->decl); 
    }

    if(z80) {
      out.str(" include \"stdlibz80e.inc\"\r\n");
    } else {
      out.str(".end");
    }

    saveFile(asmFile, fcmCreateAlways, out.buf);
  } catch(Exception& e) {
    fatal(&e, "WinMain");
  } catch(...) {
    fatal(0, "WinMain");
  } 
  return 0;
}

// Обойти по дереву все вызовы функций
// Если функция встречена в первый раз, то помещаем её аругменты память.
// Аргументы можно помещать в эту область, если ни одна вызыающая функция не использует эту область.
// То есть при вызове мы формируем

