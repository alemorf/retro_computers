//! Заменить команды ld bc, hl - alu (hl)  на ld a, (bc) - ld d, a - alu d

#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

// Стек можнт быть только вторым и только в паре с A или HL

Place simpleArg8(Place p) {
  switch(p) {
    case pConstStr:         return pConst;

    case pConstRef16:
    case pConstStrRef8:
    case pConstStrRef16:    return pConstRef8;

    case pConstStrRefRef16: return pConstStrRefRef8;
    case pHLRef16:          return pHLRef8;
    case pBCRef16:          return pBCRef8;
    case pBC:               return pC;
    case pStackRef16:       return pStackRef8;
  }
  return p;
}

void cmd_call_operator_raise(Place ap, Place bp) {
  raise("cmd_call_operator "+i2s(ap)+" "+ i2s(bp));
}

void cmd_call_operator_self_raise(Place ap, Place bp) {
  raise("cmd_call_operator_self "+i2s(ap)+" "+ i2s(bp));
}

void cmd_call_operator(const char* fn, bool self) {
  Stack& a = stack[stack.size()-2];
  Stack& b = stack[stack.size()-1];

  Place ap = simpleArg8(a.place);
  Place bp = simpleArg8(b.place);

  Writer& w = bc();

  if(ap!=pA && bp!=pA) 
    useA();

  switch(ap) {
    case pA:
      switch(bp) {
        case pB:                          w.ld_d_b(); break;
        case pC:                          w.ld_d_c(); break;
        case pHL:                         w.ld_d_l(); break;
        case pConst:                      w.ld_d(b); break;
        case pConstRef8:         useHL(); w.ld_hl(b).ld_d_HL(); break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL(); break;
        case pHLRef8:                     w.ld_d_HL(); break;
        case pBCRef8:            useHL(); w.ld_hl_bc().ld_d_HL(); break;
        case pStack8:                     w.pop_de(); break;
        case pStack16:                    w.pop_de().ld_d_e(); break;
        case pStackRef8:
        case pStackRef16:        chkHL(); w.pop_hl().ld_d_HL(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pB:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_b(); break;
        case pB:                          w.ld_d_b().ld_a_b(); break;
        case pC:                          w.ld_d_c().ld_a_b(); break;
        case pHL:                         w.ld_d_l().ld_a_b(); break;
        case pConst:                      w.ld_d(b).ld_a_b(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_a().ld_a_b(); break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_b(); break;
        case pHLRef8:                     w.ld_d_HL().ld_a_b(); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_b(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pC:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_c(); break;
        case pB:                          w.ld_d_b().ld_a_c(); break;
        case pC:                          w.ld_d_c().ld_a_c(); break;
        case pHL:                         w.ld_d_l().ld_a_c(); break;
        case pConst:                      w.ld_d(b).ld_a_c(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_a().ld_a_c(); break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_c(); break;
        case pHLRef8:                     w.ld_d_HL().ld_a_c(); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_c(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pHL:
      switch(bp) {
        case pA:                          w.ld_d_a()             .ld_a_l(); break;
        case pB:                          w.ld_d_b()             .ld_a_l(); break;
        case pC:                          w.ld_d_c()             .ld_a_l(); break;
        case pConst:                      w.ld_d(b)              .ld_a_l(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_a() .ld_a_l(); break;
        case pConstStrRefRef8:            w.ld_a_l().ld_hl_ref(b).ld_d_HL(); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a()   .ld_a_l(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConst:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a(a); break;
        case pB:                          w.ld_d_b().ld_a(a); break;
        case pC:                          w.ld_d_c().ld_a(a); break;
        case pHL:                         w.ld_d_l().ld_a(a); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_a().ld_a(a); break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a(a); break;
        case pHLRef8:                     w.ld_d_HL().ld_a(a); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a(a); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConstRef8:
      switch(bp) {
        case pA:                        w.ld_d_a().ld_a_ref(a); break;
        case pB:                        w.ld_d_b().ld_a_ref(a); break;
        case pC:                        w.ld_d_c().ld_a_ref(a); break;
        case pHL:                       w.ld_d_l().ld_a_ref(a); break;
        case pConst:                    w.ld_d(b).ld_a_ref(a); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a().ld_a_ref(a); break;
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_ref(a); break;
        case pHLRef8:                   w.ld_d_HL().ld_a_ref(a); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a().ld_a_ref(a); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConstStrRefRef8:
      switch(bp) {
        case  pA:               useHL(); w.ld_d_a()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pB:               useHL(); w.ld_d_b()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pC:               useHL(); w.ld_d_c()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pHL:                       w.ld_d_l()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pConst:           useHL(); w.ld_d(b)               .ld_hl_ref(a).ld_a_HL(); break;
        case  pConstRef8:       useHL(); w.ld_a_ref(b).ld_d_a()  .ld_hl_ref(a).ld_a_HL(); break;
        case  pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_hl_ref(a).ld_a_HL(); break;
        case  pHLRef8:                   w.ld_d_HL()             .ld_hl_ref(a).ld_a_HL(); break;
        case  pBCRef8:          useHL(); w.ld_a_BC().ld_d_a()    .ld_hl_ref(a).ld_a_HL(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      a.place = a.place==pConstStrRefRef8 ? pHLRef8 : pHLRef16; // Оптимизация
      lastHL = stack.size()-2;
      break;
    case pHLRef8: // Если self, то HL изменять нельзя
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_HL(); break;
        case pB:                        w.ld_d_b()              .ld_a_HL(); break;
        case pC:                        w.ld_d_c()              .ld_a_HL(); break;
        case pConst:                    w.ld_d(b)               .ld_a_HL(); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a()  .ld_a_HL(); break;
        case pConstStrRefRef8:if(self){ w.ex_hl_de().ld_hl_ref(b).ld_h_HL().ex_hl_de().ld_a_HL(); break; }
                                        w.ld_a_HL().ld_hl_ref(b).ld_d_HL(); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a()    .ld_a_HL(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pBCRef8:
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_BC(); break;
        case pB:                        w.ld_d_b()              .ld_a_BC(); break;
        case pC:                        w.ld_d_c()              .ld_a_BC(); break;
        case pHL:                       w.ld_d_l()              .ld_a_BC(); break;
        case pConst:                    w.ld_d(b)               .ld_a_BC(); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a()  .ld_a_BC(); break;
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_BC(); break;
        case pHLRef8:                   w.ld_d_HL()             .ld_a_BC(); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a();               break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    //! Дописать стек
    default: cmd_call_operator_raise(ap, bp);
  }
  needFile(fn);
  w.call(fn);
  if(self) {
    switch(a.place) {
      //! Добавить все вараинты
      case pB:           w.ld_b_a(); break;
      case pConstStrRef8:
      case pConstRef8: w.ld_ref_a(a); break;
      case pHLRef8:    w.ld_HL_a();   break;
      case pBCRef8:    w.ld_BC_a();   break;
      default: cmd_call_operator_self_raise(a.place, bp);
    }
    asm_pop();
  } else {
    asm_pop();
    asm_pop();
    popTmpA();
  }
}

bool pushDA_swap(bool self) {
  Stack& a = stack[stack.size()-2];
  Stack& d = stack[stack.size()-1];
  if(!self && a.place==pConst && d.place==pA) { bc().ld_d(a.value); asm_pop(); asm_pop(); return true; }
  pushD();
  if(self) peekA(); else pushA();
  return false;
}

void cmd_call_operator_swap(const char* fn1, const char* fn2, bool self, bool wordResult) {
 // Stack& a = stack[stack.size()-2];
 // Stack& b = stack[stack.size()-1];

 // Place ap = simpleArg8(a.place);
 // Place bp = simpleArg8(b.place);

  //! Оптимизировать
  Writer& w = bc();

  bool swap = pushDA_swap(self);

  /*
  switch(ap) {
    case pStackRef16:
    case pStackRef8:
      switch(bp) {
        case pA:                          w.pop_de().ld_d_a().ld_a_DE(); break;
        case pB:                          w.pop_de().ld_d_b().ld_a_DE(); break;
        case pC:                          w.pop_de().ld_d_c().ld_a_DE(); break;
        case pHL:                         w.pop_de().ld_d_l().ld_a_DE(); break;
        case pConst:                      w.pop_de().ld_d(b).ld_a_DE(); break;
        case pConstRef8:                  w.pop_de().ld_a_DE().ld_d_a().ld_a_ref(b); break;
        case pConstStrRefRef8:            w.pop_de().ld_a_DE().ld_hl_ref(b).ld_d_HL(); break;
        case pHLRef8:                     w.pop_de().ld_a_DE().ld_d_HL(); break;
        case pBCRef8:                     w.pop_de().ld_a_DE().ld_d_a().ld_a_BC(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pA:
      switch(bp) {
        case pB:                          w.ld_d_b(); break;
        case pC:                          w.ld_d_c(); break;
        case pHL:                         w.ld_d_l(); break;
        case pConst:                      w.ld_d(b); break;
        case pConstRef8:                  w.ld_d_a().ld_a_ref(b); swap=true; break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL(); break;
        case pHLRef8:                     w.ld_d_HL(); break;
        case pBCRef8:                     w.ld_d_a().ld_a_BC(); swap=true; break;
        case pStack8:                     w.pop_de(); break;
        case pStack16:                    w.pop_de().ld_d_e(); break;
        case pStackRef8:
        case pStackRef16:        chkHL(); w.pop_hl().ld_d_HL(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pB:
      switch(bp) {
        case pA:                          w.ld_d_b(); swap=true; break;
        case pB:                          w.ld_d_b().ld_a_b(); break;
        case pC:                          w.ld_d_c().ld_a_b(); break;
        case pHL:                         w.ld_d_l().ld_a_b(); break;
        case pConst:                      w.ld_d(b).ld_a_b(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_b(); swap=true; break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_b(); break;
        case pHLRef8:                     w.ld_d_HL().ld_a_b(); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_b(); swap=true; break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pC:
      switch(bp) {
        case pA:                          w.ld_d_c(); swap=true; break;
        case pB:                          w.ld_d_b().ld_a_c(); break;
        case pC:                          w.ld_d_c().ld_a_c(); break;
        case pHL:                         w.ld_d_l().ld_a_c(); break;
        case pConst:                      w.ld_d(b).ld_a_c(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_c(); swap=true; break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_c(); break;
        case pHLRef8:                     w.ld_d_HL().ld_a_c(); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_c(); swap=true; break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pHL:
      switch(bp) {
        case pA:                          w.ld_d_l(); swap=true; break;
        case pB:                          w.ld_d_b().ld_a_l(); break;
        case pC:                          w.ld_d_c().ld_a_l(); break;
        case pConst:                      w.ld_d(b).ld_a_l(); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d_l(); swap=true; break;
        case pConstStrRefRef8:            w.ld_a_l().ld_hl_ref(b).ld_d_HL(); break; // HL не будет сохранено
        case pBCRef8:                     w.ld_a_BC().ld_d_l(); swap=true; break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConst:
      switch(bp) {
        case pA:                          w.ld_d(a); swap=true; break;
        case pB:                          w.ld_d_b().ld_a(a); break;
        case pC:                          w.ld_d_c().ld_a(a); break;
        case pHL:                         w.ld_d_l().ld_a(a); break;
        case pConstRef8:                  w.ld_a_ref(b).ld_d(a); swap=true; break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a(a); break;
        case pHLRef8:                     w.ld_d_HL().ld_a(a); break;
        case pBCRef8:                     w.ld_a_BC().ld_d(a); swap=true; break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConstRef8:
      switch(bp) {
        case pA:                        w.ld_d_a().ld_a_ref(a); break;
        case pB:                        w.ld_d_b().ld_a_ref(a); break;
        case pC:                        w.ld_d_c().ld_a_ref(a); break;
        case pHL:                       w.ld_d_l().ld_a_ref(a); break;
        case pConst:                    w.ld_d(b).ld_a_ref(a); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a().ld_a_ref(a); break;
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_ref(a); break;
        case pHLRef8:                   w.ld_d_HL().ld_a_ref(a); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a().ld_a_ref(a); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pConstStrRefRef8:
      switch(bp) {
        case  pA:               useHL(); w.ld_d_a()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pB:               useHL(); w.ld_d_b()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pC:               useHL(); w.ld_d_c()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pHL:                       w.ld_d_l()              .ld_hl_ref(a).ld_a_HL(); break;
        case  pConst:           useHL(); w.ld_d(b)               .ld_hl_ref(a).ld_a_HL(); break;
        case  pConstRef8:       useHL(); w.ld_a_ref(b).ld_d_a()  .ld_hl_ref(a).ld_a_HL(); break;
        case  pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_hl_ref(a).ld_a_HL(); break;
        case  pHLRef8:                   w.ld_d_HL()             .ld_hl_ref(a).ld_a_HL(); break;
        case  pBCRef8:          useHL(); w.ld_a_BC().ld_d_a()    .ld_hl_ref(a).ld_a_HL(); break;
        default: cmd_call_operator_raise(ap, bp);
      }
      a.place = a.place==pConstStrRefRef8 ? pHLRef8 : pHLRef16; // Оптимизация
      lastHL = stack.size()-2;
      break;
    case pHLRef8: // Если self, то HL изменять нельзя
      switch(bp) {
        case pA:                        w                       .ld_d_HL(); swap=true; break;
        case pB:                        w.ld_d_b()              .ld_a_HL(); break;
        case pC:                        w.ld_d_c()              .ld_a_HL(); break;
        case pConst:                    w.ld_d(b)               .ld_a_HL(); break;
        case pConstRef8:                w.ld_a_ref(b)           .ld_d_HL(); swap=true; break;
        case pConstStrRefRef8:if(self){ w.ex_hl_de().ld_hl_ref(b).ld_h_HL().ex_hl_de().ld_a_HL(); break; }
                                        w.ld_a_HL().ld_hl_ref(b).ld_d_HL(); break;
        case pBCRef8:                   w.ld_a_BC()             .ld_d_HL(); swap=true; break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    case pBCRef8:
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_BC(); break;
        case pB:                        w.ld_d_b()              .ld_a_BC(); break;
        case pC:                        w.ld_d_c()              .ld_a_BC(); break;
        case pHL:                       w.ld_d_l()              .ld_a_BC(); break;
        case pConst:                    w.ld_d(b)               .ld_a_BC(); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a()  .ld_a_BC(); break;
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b).ld_d_HL().ld_a_BC(); break;
        case pHLRef8:                   w.ld_d_HL()             .ld_a_BC(); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a();               break;
        default: cmd_call_operator_raise(ap, bp);
      }
      break;
    //! Дописать стек
    default: cmd_call_operator_raise(ap, bp);
  } 
  */
  const char* fn = swap && fn2 ? fn2 : fn1;
  needFile(fn);
  w.call(fn);

  if(wordResult) {
    if(self) p.logicError_("не поддерживается");
    popTmpHL();
  } else {
    popTmpPokeA(self);
  }
/*  if(self) {
    switch(a.place) {
      //! Добавить все варианты
      case pB:         w.ld_b_a();    break;
      case pConstStrRef8:
      case pConstRef8: w.ld_ref_a(a); break;
      case pHLRef8:    w.ld_HL_a();   break;
      case pBCRef8:    w.ld_BC_a();   break;
      default: cmd_call_operator_self_raise(a.place, bp);
    }
    asm_pop();
    if(!wordResult) p.logicError_("не поддерживается");
  } else {
    asm_pop();
    asm_pop();
    if(wordResult) popTmpHL(); else popTmpA();
  }*/
}
