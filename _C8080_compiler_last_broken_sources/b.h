#include "nodes.h"
#include <functional>
#include "assembler.h"

struct State {
  struct Reg {
    NodeVariable* in;  // В этом регистре сейчас находится переменная
    bool changed;      // Эта переменная изменена, т.е. отличается от памяти и её надо сохранить
    NodeVariable* tmp; // В этом регистре значение переменной (копия).  //! Надо сбрасывать TMP при изменении этой переменной!
    bool used;         // Регистр был использован в коде
    bool const_;       // Регистр содержит число
    int const_value;   // Регистр содержит число
    int delta;         // Если in!=0, то значение переменной, которая хранится сейчас в HL, увеличено от нормы. Если in==0 && tmp!=0, то временное значение, переменной tmp, увеличено от нормы    

    inline void operator =  (const Reg& b) { memcpy(this, &b, sizeof(*this)); }
    inline bool operator == (const Reg& b) { return 0==memcmp(this, &b, sizeof(*this)); }
    inline bool operator != (const Reg& b) { return 0!=memcmp(this, &b, sizeof(*this)); }
  };
  Reg a;
  Reg hl;
  Reg de;

  inline void operator =  (const State& b) { memcpy(this, &b, sizeof(*this)); }
  inline bool operator == (const State& b) { return 0==memcmp(this, &b, sizeof(*this)); }
  inline bool operator != (const State& b) { return 0!=memcmp(this, &b, sizeof(*this)); }

  void clear() {
    memset(this, 0, sizeof(*this));
  }
};

extern State s;

class ChangeCode {
public:
  int ptr;
  Assembler::Item old;

  inline ChangeCode(int _ptr, int timings, Assembler::Cmd ncmd, int na=0, int nb=0) { 
    ptr = _ptr;
    auto& x = out.items[ptr];
    old = x;
    x.cmd = ncmd;
    x.a = na;
    x.b = nb;
    //! Скоректировать тайминги
  }

  inline ~ChangeCode() {
    out.items[ptr] = old;
    //! Скоректировать тайминги
  }
};

// ?

bool zFlagForA();
void saveRegAAndUsed();
void saveRegHLAndUsed();
void saveRegDEAndUsed();
void saveRegs(int reg = -1, bool dontForgot=false);
bool loadInDE(NodeConst* nc, bool neg, const std::function<bool()>& result);
void setHlConst(int value);
void saveAllRegsAndUsed();
//void setDeUsed(bool v);
//void setAUsed(bool v);
//void setHlUsed(bool v);
Assembler::Reg8 toAsmReg8(Reg reg);
Assembler::Reg16 toAsmReg16(Reg reg);
void loadInAreal(NodeVariable* var);
void loadInHLreal(NodeVariable* var);
void normalizeDeltaDE();
void normalizeDeltaHL();

// b_saveRegs.cpp

void saveGlobalRegs();

// b_load.cpp

bool loadInA(NodeVariable* var);
void loadInAreal(NodeVariable* var);
bool loadInHL(NodeVariable* var);
void loadInHLreal(NodeVariable* var);
bool loadInDE(NodeVariable* var);

// b_fork.cpp

extern int deepLimit;
extern int cmdLimit;

bool fork(int n, const std::function<bool(int)>& variant);

// b_zFlagFor8.cpp

bool zFlagFor8(Assembler::Reg8 reg);

// b_writeJmp.cpp

void writeJmp(bool swap, bool inverse, Operator o, int l);

// saveState

class SaveState {
public:
  State saved;

  int _out_ptr;
  int t;
  int incorrectFork;

  SaveState() {
    saved = s;
    _out_ptr = out.ptr;
    t = out.t;
    incorrectFork = out.incorrectFork;
  }

  /*
  bool operator == (const SaveState& b) const {
    if(s != saved) return false;
    return true;
  }
  */

  void restoreRegs() {
    s = saved;    
  }

  void restore() {
    restoreRegs();
    out.ptr = _out_ptr;
    out.t = t;
    out.incorrectFork = incorrectFork;
  }
};

// b_combineState.cpp

bool combineState_(const State& saved);

// Set

template<class T>
class Set {
public:
  T old;
  T& var;
  Set(T& _var, T newVal) : var(_var) { old = var, var = newVal; }
  ~Set() { var = old; }
};

// b_needFunction.cpp

extern std::vector<string> needFunctions;
extern std::map<string, int> needFunctionsIdx;

void needFunction(string name);
