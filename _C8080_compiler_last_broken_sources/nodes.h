#pragma once

#include <finlib/string.h>
#include <finlib/exception.h>
#include <map>
#include "ctype.h"
#include <assert.h>

class NodeOperator;

enum NodeType { 
  ntNop, ntConstI, ntConstS, ntConvert, ntCallI, ntCallS, ntDeaddr, ntSwitch, ntLabel, 
  ntReturn, ntMonoOperator, ntOperator, ntJmp, ntIf, ntAsm, ntCond
};

enum Reg {
  regNone=0, regA=1, regHL=2, regDE=4, regBC=8, regB=16, regC=32, regD=64, regE=128, regH=256, regL=512 
};

enum MonoOperator {
  moNot, moNeg, moAddr, moDeaddr, moPostInc, moPostDec, moInc, moDec, moXor, moIncVoid, moDecVoid 
};

enum Operator { 
  oNone, oDiv, oMod, oMul, oMul8, oAdd, oSub, oShl, oShr, oL, oG, oLE, oGE, oE, oNE, oAnd, oXor,
  oOr, oLAnd, oLOr, oIf, oSet, oSetVoid, oSAdd, oSSub, oSMul, oSDiv, oSMod, oSShl, oSShr, oSAnd, oSXor, oSOr, oCount 
};

class NodeVariable {
public:
  string name;  
  bool stack;  
  Reg reg;
  CType dataType;

  NodeVariable() { stack=false; reg=regNone; }
};

extern std::map<string, NodeVariable*> nodeVars;
extern int intLabels;

class Node {
public:
  NodeType nodeType;
  Node* next;
  string remark;

  Node(NodeType _nodeType=ntNop) { nodeType=_nodeType; next=0; }
  ~Node() { delete next; }
  template<class T> T* cast() { return (T*)this; }
  bool isConst() { return nodeType==ntConstI || nodeType==ntConstS; }
};

class NodeVar : public Node {
public:
  CType dataType;

  Reg isRegVar();
};

NodeVar* addFlag(NodeVar* a);

class NodeCond : public NodeVar {
public:
  NodeVar* a;

  NodeCond(NodeVar* _a) {
    assert(_a->dataType.baseType == cbtFlags);
    nodeType = ntCond;
    assert(!_a->isConst());
    a = _a;
    dataType.baseType = cbtUChar;
    dataType.addr = 0;
  }
};

class NodeSwitch : public Node {
public:
  NodeVar* var;
  Node* body;
  Node* defaultLabel;
  std::map<unsigned int, Node*> cases;

  NodeSwitch(NodeVar* _var) { nodeType = ntSwitch; body = 0; var = _var; defaultLabel=0; }

  void setDefault(Node* label) { defaultLabel = label; }

  void addCase(int value, Node* label) { 
    if(cases.find(value) != cases.end()) raise("case уже был");
    cases[value] = label;
  }
};

class NodeConvert : public NodeVar {
public:
  NodeVar* var;
  NodeConvert(NodeVar* _var, CType _dataType) { 
    assert(_var->dataType.baseType != cbtFlags);
    nodeType = ntConvert;
    var = _var;
    dataType = _dataType; 
  }
};

class NodeReturn : public Node {
public:
  NodeVar* var;
  NodeReturn(NodeVar* _var) { nodeType = ntReturn; var = _var;}
};

class NodeAsm : public Node {
public:
  string text;
  NodeAsm(string _text) { nodeType = ntAsm; text = _text; }
};

class NodeConst : public NodeVar {
public:
  int value;
  NodeVariable* var;

  NodeConst(int _value) { nodeType = ntConstI; value = _value; dataType.baseType = cbtUShort; dataType.addr = 0; }
  NodeConst(int _value, CType _dataType) { nodeType = ntConstI; value = _value; dataType = _dataType; }

  NodeConst(cstring _name, CType _dataType, bool stack=false) { 
    nodeType = ntConstS;
    dataType = _dataType; 
    auto& f = nodeVars[_name];
    if(f == 0) {
      f = new NodeVariable;
      f->stack = stack;
      //if(dataType.addr == 0)
        //p.logicError_("NodeCode !addr");
      f->dataType = dataType;
      //f->dataType.addr--;
      f->name = _name;
    } else {
      //! не проходит! assert(f->dataType.baseType == dataType.baseType && f->dataType.addr == dataType.addr);
    }
    var = f;
  }
};

class NodeCall : public NodeVar {
public:
  std::vector<NodeVar*> args;
  int addr;
  string name;
  
  NodeCall(int _addr, CType _dataType, std::vector<NodeVar*>& _args) { nodeType = ntCallI; addr = _addr; dataType = _dataType; args=_args; }
  NodeCall(cstring _name, CType _dataType, std::vector<NodeVar*>& _args) { nodeType = ntCallS; name = _name; dataType = _dataType; args=_args; }
};

class NodeMonoOperator : public NodeVar {
public:
  MonoOperator o;
  NodeVar* a;

  NodeMonoOperator(NodeVar* _a, MonoOperator _o) { 
    nodeType = ntMonoOperator; a=_a; o = _o; 
    dataType = a->dataType;
  }  
};

class NodeOperator : public NodeVar {
public:
  Operator o;
  NodeVar* a;
  NodeVar* b;
  NodeVar* cond;

  NodeOperator(CType& _dataType, Operator _o, NodeVar* _a, NodeVar* _b, NodeVar* _cond) {
    dataType = _dataType; o=_o; a=_a; b=_b; cond=_cond;    
    nodeType = ntOperator;
  }
};

class NodeLabel : public Node {
public:
  int n;
  NodeLabel() { nodeType = ntLabel; n = intLabels++; }
  ~NodeLabel();
};

class NodeDeaddr : public NodeVar {
public:
  NodeVar* var;

  NodeDeaddr(NodeVar* _var) { 
    nodeType = ntDeaddr;
    var = _var; 
    if(var->dataType.addr==0) 
      raise("Аргумент должен быть указателем");
    dataType = var->dataType;
    dataType.addr--;
  } 
};

class NodeIf : public Node {
public:
  NodeVar* cond;
  Node* t;
  Node* f;

  NodeIf(NodeVar* _cond, Node* _t, Node* _f) {
    nodeType = ntIf; 
    cond = addFlag(_cond);
    t = _t; 
    f = _f; 
    //if(cond->nodeType != ntOperator) cond = nodeOperator(oNE, cond, new NodeConst(0));
    assert(cond->dataType.baseType == cbtFlags);
  }
};

class NodeJmp : public Node {
public:
  Node* label;
  NodeVar* cond;
  bool  ifZero;

  NodeJmp(Node* _label, NodeVar* _cond, bool _ifZero) { 
    nodeType = ntJmp; 
    cond = _cond;
    label = _label; 
    ifZero = _ifZero; 

    // Оптимизация while(const) и подобных
    if(_cond && _cond->nodeType == ntConstI) {
      auto nc = _cond->cast<NodeConst>();
      bool check = nc->value != 0;
      if(_ifZero) check = !check;
      if(!check) nodeType = ntNop;
      delete cond;
      cond = 0;
    }

    if(cond) cond = addFlag(cond);    
  }
};