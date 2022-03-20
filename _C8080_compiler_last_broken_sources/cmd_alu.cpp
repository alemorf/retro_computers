//! Заменить команды ld bc, hl - alu (hl)  на ld a, (bc) - ld d, a - alu d

#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

// Стек можнт быть только вторым и только в паре с A или HL

Place simpleArg8(Place p);

void cmd_alu_raise(Place ap, Place bp) {
  raise("cmd_alu "+i2s(ap)+" "+ i2s(bp));
}

void cmd_alu_self_raise(Place ap, Place bp) {
  raise("cmd_alu_self "+i2s(ap)+" "+ i2s(bp));
}

void cmd_alu(Opcode op, bool self, bool flags) {
  Stack& a = stack[stack.size()-2];
  Stack& b = stack[stack.size()-1];

  Place ap = simpleArg8(a.place);
  Place bp = simpleArg8(b.place);

  bc().remark("Арифметика "+i2s(ap)+"/"+i2s(bp));

  Writer& w = bc();

  if(ap!=pA && bp!=pA) 
    useA();

  switch(ap) {
    case pA:
      switch(bp) {
        case pB:                          w.alu_b(op); break;
        case pC:                          w.alu_c(op); break;
        case pHL:                         w.alu_l(op); break;
        case pConst:                      w.alu(op, b); break;
        case pConstRef8:         useHL(); w.ld_hl(b).alu_HL(op); break;
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.alu_HL(op); break;
        case pBCRef8:            useHL(); w.ld_hl_bc().alu_HL(op); break;
        case pStack8:                     w.pop_de().alu_d(op); break;
        case pStack16:                    w.pop_de().alu_e(op); break;
        case pStackRef8:
        case pStackRef16:        chkHL(); w.pop_hl().alu_HL(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pB:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_b().alu_d(op); break;
        case pB:                          w.ld_a_b().alu_b(op); break;
        case pC:                          w.ld_a_b().alu_c(op); break;
        case pHL:                         w.ld_a_b().alu_l(op); break;
        case pConst:                      w.ld_a_b().alu(op, b); break;
        case pConstRef8:                  w.ld_a_b().ld_hl(b).alu_HL(op); break;
        case pConstStrRefRef8:   useHL(); w.ld_a_b().ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.ld_a_b().alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_b().alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pC:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_c().alu_d(op); break;
        case pB:                          w.ld_a_c().alu_b(op); break;
        case pC:                          w.ld_a_c().alu_c(op); break;
        case pHL:                         w.ld_a_c().alu_l(op); break;
        case pConst:                      w.ld_a_c().alu(op, b); break;
        case pConstRef8:                  w.ld_a_c().ld_hl(b).alu_HL(op); break;
        case pConstStrRefRef8:   useHL(); w.ld_a_c().ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.ld_a_c().alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_b().alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pHL:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_l().alu_d(op); break;
        case pB:                          w.ld_a_l().alu_b(op); break;
        case pC:                          w.ld_a_l().alu_c(op); break;
        case pConst:                      w.ld_a_l().alu(op, b); break;
        case pConstRef8:                  w.ld_a_l().ld_hl(b).alu_HL(op); break;
        case pConstStrRefRef8:            w.ld_a_l().ld_hl_ref(b).alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_l().alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pConst:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a(a).alu_d(op); break;
        case pB:                          w.ld_a(a).alu_b(op); break;
        case pC:                          w.ld_a(a).alu_c(op); break;
        case pHL:                         w.ld_a(a).alu_l(op); break;
        case pConstRef8: if(lastHL==-1) { w.ld_hl(b).ld_a(a).alu_HL(op); break; } // 10+7+7=24 
                                          w.ld_a_ref(b).ld_d_a().ld_a(a).alu_d(op); break; // 13+5+7+7=32
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_a(a).alu_HL(op); break;
        case pHLRef8:                     w.ld_a(a).alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a(a).alu_d(op); break; // это 7+5+7+4=23, против ld_hl_bc().ld_a(a).alu_HL(op), которым еще нужен HL
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pConstRef8:
      switch(bp) {
        case pA:                          w.ld_d_a().ld_a_ref(a).alu_d(op); break;
        case pB:                          w.ld_a_ref(a).alu_b(op); break;
        case pC:                          w.ld_a_ref(a).alu_c(op); break;
        case pHL:                         w.ld_a_ref(a).alu_l(op); break;
        case pConst:                      w.ld_a_ref(a).alu(op, b); break;
        case pConstRef8: if(lastHL==-1) { w.ld_hl(b).ld_a_ref(a).alu_HL(op); break; } // 10+13+7=30
                                          w.ld_a_ref(b).ld_d_a().ld_a_ref(a).alu_d(op); break; // 13+5+13+4=35
        case pConstStrRefRef8:   useHL(); w.ld_hl_ref(b).ld_a_ref(a).alu_HL(op); break; // 16+13+7=36
        case pHLRef8:                     w.ld_a_ref(a).alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().ld_a_ref(a).alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pConstStrRefRef8:
      switch(bp) {
        case  pA:               useHL(); w.ld_d_a()                         .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        case  pB:               useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu_b(op); break;
        case  pC:               useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu_c(op); break;
        case  pHL:                       w.ld_d_l()                         .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        case  pConst:           useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu(op,b); break;
        case  pConstRef8:       useHL(); if(self) { w.ld_hl(a)    .ld_d_HL().ld_hl_ref(a).ld_a_HL().alu_d(op); break; } // 10+7+16+7+4 = 44
                                w.ld_hl_ref(a).ld_a_HL().ld_hl(b).alu_HL(op); break;                                    // 16+7+10+7   = 40
        case  pConstStrRefRef8: useHL(); if(self) { w.ld_hl_ref(a).ld_d_HL().ld_hl_ref(a).ld_a_HL().alu_d(op); break; } // 16+7+16+7+4 = 50
                                w.ld_hl_ref(a).ld_a_HL().ld_hl_ref(b).alu_HL(op); break;                                // 16+7+16+7   = 46
        case  pHLRef8:                   w.ld_d_HL()                        .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        case  pBCRef8:          useHL(); w.ld_a_BC().ld_d_a()               .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      a.place = a.place==pConstStrRefRef8 ? pHLRef8 : pHLRef16; // Оптимизация
      lastHL = stack.size()-2;
      break;
    case pHLRef8: // Если self, то HL изменять нельзя
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_HL().alu_d(op); break;
        case pB:                        w                       .ld_a_HL().alu_b(op); break;
        case pC:                        w                       .ld_a_HL().alu_c(op); break;
        case pConst:                    w                       .ld_a_HL().alu(op,b); break;
        case pConstRef8:                w.ld_a_ref(b).ld_d_a()  .ld_a_HL(); break;
        case pConstStrRefRef8:if(self){ w.ex_hl_de().ld_hl_ref(b).ld_h_HL().ex_hl_de().ld_a_HL().alu_d(op); break; }
                                        w.ld_a_HL().ld_hl_ref(b).alu_HL(op); break;
        case pBCRef8:                   w.ld_a_BC().ld_d_a()    .ld_a_HL().alu_d(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pBCRef8:
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_BC().alu_d(op);  break;
        case pB:                        w                       .ld_a_BC().alu_b(op);  break;
        case pC:                        w                       .ld_a_BC().alu_c(op);  break;
        case pHL:                       w                       .ld_a_BC().alu_l(op);  break;
        case pConst:                    w                       .ld_a_BC().alu(op,b);  break;
        case pConstRef8:if(lastHL==-1){ w.ld_hl(b)              .ld_a_BC().alu_HL(op); break; } // 10+7+7 = 24
                                        w.ld_a_ref(b).ld_d_a()  .ld_a_BC().alu_d(op);  break; // 13+5+7+4 = 29                             
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b)          .ld_a_BC().alu_HL(op); break;
        case pHLRef8:                   w                       .ld_a_BC().alu_HL(op); break;
        case pBCRef8:                   w                       .ld_a_BC().alu_a(op);  break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pStack8:
      switch(bp) {
        case pA:                          w.ld_d_a().pop_af().alu_d(op); break;
        case pB:                          w.pop_af().alu_b(op); break;
        case pC:                          w.pop_af().alu_c(op); break;
        case pHL:                         w.pop_af().alu_l(op); break;
        case pConst:                      w.pop_af().alu(op, b); break;
        case pConstRef8:         chkHL(); w.pop_af().ld_hl(b).alu_HL(op); break;
        case pConstStrRefRef8:   chkHL(); w.pop_af().ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.pop_af().alu_HL(op); break;
        case pBCRef8:                     w.ld_a_BC().ld_d_a().pop_af().alu_d(op); break; // 7+5+5 = 17, против 10+7 у pop_af().ld_hl_bc().alu_HL(op)
        default: cmd_alu_raise(ap, bp);
      }
      break;
    default: cmd_alu_raise(ap, bp);
  }
  if(self) {
    switch(a.place) {
      case pConstStrRef8:
      case pConstRef8: w.ld_ref_a(a); break;
      case pHLRef8:    w.ld_HL_a();   break;
      case pBCRef8:    w.ld_BC_a();   break;
      case pB:         w.ld_b_a();    break;
      case pC:         w.ld_c_a();    break;
      default: cmd_alu_self_raise(a.place, bp);
    }
    asm_pop();
    if(flags) raise("flags!");
  } else {
    asm_pop();
    asm_pop();
    if(flags) add(stack).place = pFlags;
         else popTmpA();
  }
}

bool cmd_alu_swap(Opcode op, bool self, bool flags) {
  Stack& a = stack[stack.size()-2];
  Stack& b = stack[stack.size()-1];

  Place ap = simpleArg8(a.place);
  Place bp = simpleArg8(b.place);

  bool sw1=false;
  if(bp > ap) { std::swap(a,b); std::swap(ap,bp); sw1=true; }

  Writer& w = bc();

  if(ap!=pA && bp!=pA) 
    useA();

//  bool swap = false;

  switch(ap) {
    // A-A не бывает
    case pB:
      switch(bp) {
        case pA:                          w.alu_b(op); sw1=!sw1; break;
        case pB:                          w.ld_a_b().alu_b(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pC:
      switch(bp) {
        case pA:                          w.alu_c(op); sw1=!sw1; break;
        case pB:                          w.ld_a_c().alu_b(op); break;
        case pC:                          w.ld_a_c().alu_c(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pHL:
      switch(bp) {
        case pA:                          w.alu_l(op); sw1=!sw1; break;
        case pB:                          w.ld_a_l().alu_b(op); break;
        case pC:                          w.ld_a_l().alu_c(op); break;
        // HL-HL не бывает
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pConst:
      switch(bp) {
        case pA:                          if(op==c_add_r && a.place==pConst) {
                                            if(a.value==1) { w.inc_a(); break; }
                                            if((a.value&0xFF)==0xFF) { w.dec_a(); break; }
                                          }
                                          w.alu(op, a); sw1=!sw1; break;
        case pB:                          w.ld_a(a).alu_b(op); break;
        case pC:                          w.ld_a(a).alu_c(op); break;
        case pHL:                         w.ld_a(a).alu_l(op); break;
        // CONST-CONST не бывает
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pConstRef8:
      switch(bp) {
        case pA:         if(lastHL==-1) { w.ld_hl(a).alu_HL(op); sw1=!sw1; break; } // 10+7 = 17 
                                          w.ld_d_a().ld_a_ref(a).alu_d(op); break; // 5+13+5 = 23                           
        case pB:                          w.ld_a_ref(a).alu_b(op); break;
        case pC:                          w.ld_a_ref(a).alu_c(op); break;
        case pHL:                         w.ld_a_ref(a).alu_l(op); break;
        case pConst:                      if(op==c_add_r && b.place==pConst) {
                                            if(b.value==1   ) { w.ld_a_ref(a).inc_a(); break; }
                                            if(b.value==0xFF) { w.ld_a_ref(a).dec_a(); break; }
                                          }
                                          if(op==c_sub_r && b.place==pConst) {
                                            if(b.value==1   ) { w.ld_a_ref(a).dec_a(); break; }
                                            if(b.value==0xFF) { w.ld_a_ref(a).inc_a(); break; }
                                          }
                                          w.ld_a_ref(a).alu(op, b); break;
        case pConstRef8: if(lastHL==-1) { w.ld_hl(b).ld_a_ref(a).alu_HL(op); break; } // 10+13+7=30
                                          w.ld_a_ref(b).ld_d_a().ld_a_ref(a).alu_d(op); break; // 13+5+13+4=35
        default: cmd_alu_raise(ap, bp);   
      }
      break;
    case pConstStrRefRef8:
      switch(bp) {
        case  pA:               useHL(); w.ld_d_a()                         .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        case  pB:               useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu_b(op); break;
        case  pC:               useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu_c(op); break;
        case  pHL:                       w.ld_d_l()                         .ld_hl_ref(a).ld_a_HL().alu_d(op); break;
        case  pConst:           useHL(); w                                  .ld_hl_ref(a).ld_a_HL().alu(op,b); break;
        case  pConstRef8:       useHL(); if(self) { w.ld_hl(a)    .ld_d_HL().ld_hl_ref(a).ld_a_HL().alu_d(op); break; } // 10+7+16+7+4 = 44
                                w.ld_hl_ref(a).ld_a_HL().ld_hl(b).alu_HL(op); break;                                    // 16+7+10+7   = 40
        case  pConstStrRefRef8: useHL(); if(self) { w.ld_hl_ref(a).ld_d_HL().ld_hl_ref(a).ld_a_HL().alu_d(op); break; } // 16+7+16+7+4 = 50
                                w.ld_hl_ref(a).ld_a_HL().ld_hl_ref(b).alu_HL(op); break;                                // 16+7+16+7   = 46
        default: cmd_alu_raise(ap, bp);
      }
      a.place = a.place==pConstStrRefRef8 ? pHLRef8 : pHLRef16; // Оптимизация
      lastHL = stack.size()-2;
      break;
    case pHLRef8: // Если self, то HL изменять нельзя
      switch(bp) {
        case pA:                        w.alu_HL(op); sw1=!sw1; break;
        case pB:                        w.ld_a_HL().alu_b(op); break;
        case pC:                        w.ld_a_HL().alu_c(op); break;
        case pConst:                    w.ld_a_HL().alu(op,b); break;
        case pConstRef8:                w.ld_a_ref(b).alu_HL(op); sw1=!sw1; break;
        case pConstStrRefRef8:if(self){ w.ex_hl_de().ld_hl_ref(b).ld_a_HL().ex_hl_de().alu_HL(op); sw1=!sw1; break; }
                                        w.ld_a_HL().ld_hl_ref(b).alu_HL(op); break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pBCRef8:
      switch(bp) {
        case pA:                        w.ld_d_a()              .ld_a_BC().alu_d(op);  break;
        case pB:                        w                       .ld_a_BC().alu_b(op);  break;
        case pC:                        w                       .ld_a_BC().alu_c(op);  break;
        case pHL:                       w                       .ld_a_BC().alu_l(op);  break;
        case pConst:                    w                       .ld_a_BC().alu(op,b);  break;
        case pConstRef8:if(lastHL==-1){ w.ld_hl(b)              .ld_a_BC().alu_HL(op); break; } // 10+7+7 = 24
                                        w.ld_a_ref(b).ld_d_a()  .ld_a_BC().alu_d(op);  break; // 13+5+7+4 = 29                             
        case pConstStrRefRef8: useHL(); w.ld_hl_ref(b)          .ld_a_BC().alu_HL(op); break;
        case pHLRef8:                   w                       .ld_a_BC().alu_HL(op); break;
        case pBCRef8:                   w                       .ld_a_BC().alu_a(op);  break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pStack8:
      switch(bp) {
        case pA:                          w.pop_de().alu_d(op); sw1=!sw1; break;
        case pB:                          w.pop_af().alu_b(op); break;
        case pC:                          w.pop_af().alu_c(op); break;
        case pHL:                         w.pop_af().alu_l(op); break;
        case pConst:                      w.pop_af().alu(op, b); break;
        case pConstRef8:                  w.pop_de().ld_a_ref(b).alu_d(op); sw1=!sw1; break;
        case pConstStrRefRef8:   chkHL(); w.pop_af().ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.pop_af().alu_HL(op); break;
        case pBCRef8:                     w.pop_de().ld_a_BC().alu_d(op); sw1=!sw1; break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    case pStackRef8:
      switch(bp) { // Оптимизировать этот кусок
        case pA:                          w.pop_de().alu_d(op); sw1=!sw1; break;
        case pB:                          w.pop_de().ld_a_DE().alu_b(op); break;
        case pC:                          w.pop_de().ld_a_DE().alu_c(op); break;
        case pHL:                         w.pop_de().ld_a_DE().alu_l(op); break;
        case pConst:                      w.pop_de().ld_a_DE().alu(op, b); break;
        case pConstRef8:                  w.pop_de().ld_a_DE().ld_d_a().ld_a_ref(b).alu_d(op); sw1=!sw1; break;
        case pConstStrRefRef8:   chkHL(); w.pop_de().ld_a_DE().ld_hl_ref(b).alu_HL(op); break;
        case pHLRef8:                     w.pop_de().ld_a_DE().alu_HL(op); break;
        case pBCRef8:                     w.pop_de().ld_a_DE().ld_d_a().ld_a_BC().alu_d(op); sw1=!sw1; break;
        default: cmd_alu_raise(ap, bp);
      }
      break;
    default: cmd_alu_raise(ap, bp);
  }
  if(self) {
    Stack& aa = sw1 ? b : a;
    switch(aa.place) {
      case pConstStrRef8:
      case pConstRef8: w.ld_ref_a(aa); break;
      case pHLRef8:    w.ld_HL_a();   break;
      case pBCRef8:    w.ld_BC_a();   break;
      default: cmd_alu_self_raise(aa.place, bp);
    }
    asm_pop();
    if(flags) raise("flags!");
  } else {
    asm_pop();
    asm_pop();
    if(flags) add(stack).place = pFlags;
         else popTmpA();
  }
  return sw1;
}
