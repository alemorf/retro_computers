#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void popB();
void popC();

void set8() {
  // Аргументы
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // pHL, pStackRef, pBCRef, pConstRef
  
  switch(as.place) {
    case pConstRef8:
      switch(bs.place) {
        case pConst: case pConstStr: bc().ld_hl(as).ld_HL(bs); asm_pop(); return; // Оптимизация. Можно заменить MVI A+LHLD+MOV M,A на LHLD+MVI M
      }
      break;      
    case pConstStrRefRef8:
      switch(bs.place) {
        case pB: bc().ld_hl_ref(as).ld_HL_b(); asm_pop(); return;
        case pC: bc().ld_hl_ref(as).ld_HL_c(); asm_pop(); return;
        case pConst: case pConstStr: bc().ld_hl_ref(as).ld_HL(bs); asm_pop(); return; // Оптимизация. Можно заменить MVI A+LHLD+MOV M,A на LHLD+MVI M
      }
      break;
    case pHLRef8:
      switch(bs.place) {
        case pConst: case pConstStr: bc().ld_HL(bs); asm_pop(); return; // Оптимизация. Можно заменить MVI A+MOV M,A на MVI M
      }
      break;
    case pB: popB(); return;
    case pC: popC(); return;
  }
 
  // Стандантная операция
  pushA();
  pokeA();
}

void popB() {
  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pStack16: bc().pop_de().ld_b_e(); break;
    case pStack8:  bc().pop_de().ld_b_d(); break;
    case pA:       bc().ld_b_a(); break;
    case pB:       break;
    case pC:       bc().ld_b_c(); break;
    case pHL:      bc().ld_b_l(); break;
    case pHLRef8: case pHLRef16:  bc().ld_b_HL(); break;
    case pConst:   bc().ld_b(bs.value&0xFF); break;
    case pConstStrRefRef8: case pConstStrRefRef16: useHL(); bc().ld_hl_ref(bs.name).ld_b_HL(); break;
    case pConstRef8: case pConstRef16: useA(); bc().ld_a_ref(bs.value).ld_b_a(); break;
    case pConstStrRef8: case pConstStrRef16: useA(); bc().ld_a_ref(bs.name).ld_b_a(); break;
    default: raise("peekB "+i2s(bs.place));
  }
  asm_pop();
}

// Поместить в регистр C
void popC() {
  Stack& bs = stack.back();
  switch(bs.place) {
    case pStack16: bc().pop_de().ld_c_e(); break;
    case pStack8:  bc().pop_de().ld_c_d(); break;
    case pA:       bc().ld_c_a();          break;
    case pC:       break;
    case pB:       bc().ld_c_b(); break;
    case pHL:      bc().ld_c_l(); break;
    case pHLRef8: case pHLRef16:  bc().ld_c_HL(); break;
    case pConst:   bc().ld_c(bs.value&0xFF); break; 
    case pConstStrRef8: case pConstStrRef16:  useA(); bc().ld_a_ref(bs.name).ld_c_a(); break;
    case pConstStrRefRef8: case pConstStrRefRef16: useHL(); bc().ld_hl_ref(bs.name).ld_c_HL(); break;
    case pConstRef8: case pConstRef16: useA(); bc().ld_a_ref(bs.value).ld_c_a(); break;
    default: raise("popC "+i2s(bs.place));
  }
  asm_pop();
}
