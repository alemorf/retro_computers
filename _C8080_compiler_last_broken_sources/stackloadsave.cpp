#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void peekA() {
  Stack& bs = stack.back();

  if(bs.place==pA) return;

  //if(lastA!=-1) 
    //raise("Ошибка, рекурсия стека");

  useA();

  switch(bs.place) {    
    case pStack16:         bc().inc_sp().pop_af().dec_sp(); break;
    case pStack8:          bc().pop_af(); break;    
    case pB:               bc().ld_a_b(); break;
    case pC:               bc().ld_a_c(); break;
    case pHL:              bc().ld_a_l(); break;
    case pConst:           
    case pConstStr:        bc().ld_a(bs); break;    
    case pStackRef8:       case pStackRef16:        useHL(); bc().pop_hl(); bs.place =  bs.place==pStackRef8 ? pHLRef8 : pHLRef16; // continue
    case pHLRef8:          case pHLRef16:           bc().ld_a_HL(); break;    
    case pBCRef8:          case pBCRef16:           bc().ld_a_BC(); break;
    case pConstStrRefRef8: case pConstStrRefRef16:  useHL(); bc().ld_hl_ref(bs.name).ld_a_HL(); break;    
    case pConstStrRef8:    case pConstStrRef16:     bc().ld_a_ref(bs.name);  break;    
    case pConstRef8:       case pConstRef16:        bc().ld_a_ref(bs.value); break;
    default: raise("peekA "+i2s(bs.place));
  }
}

void peekD() {
  Stack& bs = stack.back();

  switch(bs.place) {    
    case pStack16:                     bc().pop_de().ld_d_e(); break;
    case pStack8:                      bc().pop_de(); break;
    case pA:                           bc().ld_d_a(); break;
    case pB:                           bc().ld_d_b(); break;
    case pC:                           bc().ld_d_c(); break;
    case pConst:                       bc().ld_d(bs.value); break;    
    case pStackRef8: case pStackRef16: useHL(); bc().pop_hl(); bs.place = bs.place==pStackRef8 ? pHLRef8 : pHLRef16;
    case pHLRef8:    case pHLRef16:    bc().ld_d_HL();  break;    
    case pBCRef8:    case pBCRef16:    useHL(); bc().ld_hl_bc().ld_d_HL(); break;
    case pConstStrRef8: case pConstStrRef16: useHL(); bc().ld_hl(bs.name).ld_d_HL(); break;    
    case pConstStrRefRef8:      case pConstStrRefRef16: useHL(); bc().ld_hl_ref(bs.name).ld_d_HL(); break;    
    case pConstRef8: case pConstRef16: useHL(); bc().ld_hl_ref(bs.value).ld_d_HL(); break;        
    default: raise("peekD "+i2s(bs.place));
  }
}

void pushA() {
  peekA();
  asm_pop();
}

void pushD() {
  peekD();
  asm_pop();
}

void chkHL() {
  if(lastHL!=-1) raise("chkHL");
}

// Изменить байт в виртуальном стеке
void pokeA() {
  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pA:                        break;
    case pB:                        bc().ld_b_a(); break;
    case pC:                        bc().ld_c_a(); break;
    case pConstStrRef8:             bc().ld_ref_a(bs.name); break;
    case pBCRef8:                   bc().ld_BC_a(); break;
    case pHLRef8:                   bc().ld_HL_a(); break;
    case pConstStrRefRef8: useHL(); bc().ld_hl_ref(bs.name).ld_HL_a(); break;
    case pStackRef8:       chkHL(); bc().pop_hl().ld_HL_a(); break;
    case pConstRef8:                bc().ld_ref_a(bs.value); break;
    default: raise("pokeA "+i2s(bs.place));
  }
}

// Загрузить адрес байта из виртуального стека в регистр HL
// Регистр HL не сохраняется.
void peekAasHL_() {
  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pHLRef8:          case pHLRef16:          break;
    case pConstStrRef8:    case pConstStrRef16:    useHL(); bc().ld_hl(bs.name);     break;
    case pBCRef8:          case pBCRef16:          useHL(); bc().ld_hl_bc();         break;
    case pConstStrRefRef8: case pConstStrRefRef16: useHL(); bc().ld_hl_ref(bs.name); break;
    case pConstRef8:       case pConstRef16:       useHL(); bc().ld_hl(bs.value);    break;
    default: raise("peekAasHL "+i2s(bs.place)); 
  }
}

void pushAasHL_(/*bool de*/) {
  peekAasHL_();
  asm_pop();
}

// Загрузить слово из виртуального стека в регистр HL или DE. 
// Регистры A, HL не сохраняются.
void peekHL(bool saveDE) {
  Stack& bs = stack[stack.size()-1];

retry:
  switch(bs.place) {
    case pHL:
      return;
    case pHLRef16:
      if(saveDE) { useA(); bc().ld_a_HL().inc_hl().ld_h_HL().ld_l_a(); }
            else { bc().ld_e_HL().inc_hl().ld_d_HL().ex_hl_de(); } 
      return;
    case pHLRef8:
      bc().ld_l_HL().ld_h(0);
      return;
  }

  useHL();

  switch(bs.place) {
    case pBCRef16: if(saveDE) { useA(); bc().ld_hl_bc().ld_e_HL().inc_HL().ld_d_HL().ex_hl_de(); break; }
                         else { bc().ld_hl_bc().ld_e_HL().inc_HL().ld_d_HL().ex_hl_de(); break; }
    case pBCRef8:           bc().ld_hl_bc().ld_l_HL().ld_h(0); break;
    case pBC:               bc().ld_hl_bc(); break;  
    case pStackRef8:        bc().pop_hl(); bs.place = pHLRef8;    goto retry;
    case pStackRef16:       bc().pop_hl(); bs.place = pHLRef16;   goto retry;
    case pStack16:          bc().pop_hl(); bs.place = pHL;        goto retry;
    case pStack8:           bc().pop_hl().ld_l_h().ld_h(0); bs.place=pHL; goto retry;
    case pA:                bc().ld_h(0).ld_l_a(); break;
    case pB:                bc().ld_h(0).ld_l_b(); break;
    case pC:                bc().ld_h(0).ld_l_c(); break;
    case pConst:            bc().ld_hl(bs.value); break;
    case pConstStr:         bc().ld_hl(bs.name); break;
    case pConstRef8:        bc().ld_hl_ref(bs.value).ld_h(0); break;
    case pConstRef16:       bc().ld_hl_ref(bs.value); break;
    case pConstStrRef8:     bc().ld_hl_ref(bs.name).ld_h(0); break;
    case pConstStrRef16:    bc().ld_hl_ref(bs.name); break;
    case pConstStrRefRef8:  bc().ld_hl_ref(bs.name).ld_l_HL().ld_h(0); break;
    case pConstStrRefRef16: if(saveDE) { useA(); bc().ld_hl_ref(bs.name).ld_a_HL().inc_hl().ld_h_HL().ld_l_a(); break; }
                                  else { bc().ld_hl_ref(bs.name).ld_e_HL().inc_hl().ld_d_HL().ex_hl_de(); break; }
    default: raise("peekHL "+i2s(bs.place));
  }
}

void peekBC() {
  Stack& bs = stack[stack.size()-1];

  switch(bs.place) {
    case pHL: bc().ld_bc_hl(); break;
    case pHLRef8: bc().ld_c_HL().ld_b(0); break;
    case pHLRef16: bc().ld_c_HL().inc_hl().ld_b_HL(); break;
    case pBCRef16: useHL(); bc().ld_hl_bc().ld_c_HL().inc_hl().ld_b_HL(); break;
    case pBCRef8: useHL(); bc().ld_hl_bc().ld_c_HL().inc_hl().ld_b(0);  break;
    case pBC: break;  
    case pStack16: bc().pop_bc(); break;
    case pStack8: bc().pop_bc().ld_c_b().ld_b(0); break;      
    case pA: bc().ld_c_a().ld_b(0); break;
    case pB: bc().ld_c_b().ld_b(0); break;
    case pC: bc().ld_b(0); break;
    case pConst: bc().ld_bc(bs.value); break;
    case pConstStr: bc().ld_bc(bs.name); break;
    case pConstStrRef8: useA(); bc().ld_a_ref(bs.name).ld_b_a().ld_c(0); break;
    case pConstStrRef16: useHL(); bc().ld_hl_ref(bs.name).ld_bc_hl(); break;
    case pConstStrRefRef8: useHL(); bc().ld_hl_ref(bs.name).ld_c_HL().ld_b(0); break;
    case pConstStrRefRef16: useHL(); bc().ld_hl_ref(bs.name).ld_c_HL().inc_hl().ld_b_HL(); break;
    case pConstRef16: useHL(); bc().ld_hl_ref(bs.value).ld_bc_hl(); break;
    case pConstRef8: useHL(); bc().ld_a_ref(bs.value).ld_l_a().ld_h(0); break;
    default: raise("popBC "+i2s(bs.place));
  }
}

// Загрузить слово из виртуального стека в регистр DE. 
void peekDE(bool canSwap, bool saveHL) {
  if(!saveHL && canSwap) raise("peedDE saveHL");

  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pA:                             bc().ld_e_a().ld_d(0); break;
    case pB:                             bc().ld_e_b().ld_d(0); break;
    case pC:                             bc().ld_e_c().ld_d(0); break;
    case pHL:               if(saveHL) { bc().ld_de_hl(); break; }
                                  else { bc().ex_hl_de(); break; }
    case pHLRef16:          if(saveHL) { bc().ld_e_HL().inc_hl().ld_d_HL().dec_hl(); break; }
                                  else { bc().ld_e_HL().inc_hl().ld_d_HL(); break; }
    case pHLRef8:                        bc().ld_e_HL().ld_d(0); break;
    case pBCRef16:  if(saveHL) { useA(); bc().ld_a_BC().ld_e_a().inc_bc().ld_a_BC().ld_d_a().dec_bc(); break; }
                                  else { bc().ld_hl_bc().ld_e_HL().inc_hl().ld_d_HL(); break; }
    case pBCRef8:                useA(); bc().ld_a_BC().ld_e_a().ld_d(0); break;
    case pBC:                            bc().ld_de_bc(); break;
    case pStack16:                       bc().pop_de(); break;
    case pStack8:                        bc().pop_de().ld_e_d().ld_d(0); break;
    case pConst:                         bc().ld_de(bs.value); break;
    case pConstStr:                      bc().ld_de(bs.name); break;
    case pConstStrRef8:                  bc().ex_hl_de(!saveHL).ld_hl_ref(bs.name).ld_h(0).ex_hl_de(canSwap); break;
    case pConstStrRef16:                 bc().ex_hl_de(!saveHL).ld_hl_ref(bs.name).ex_hl_de(canSwap); break;
    case pConstStrRefRef16: if(saveHL) { useA(); bc().ex_hl_de().ld_hl_ref(bs.name).ld_a_HL().inc_HL().ld_h_HL().ld_l_a().ex_hl_de(canSwap); break; }
                                       { bc().ld_hl_ref(bs.name).ld_e_HL().inc_hl().ld_d_HL(); break; }
    case pConstStrRefRef8:  if(saveHL) { bc().ex_hl_de().ld_hl_ref(bs.name).ld_l_HL().ld_h(0).ex_hl_de(canSwap); break; }
                                  else { bc().ld_hl_ref(bs.name).ld_e_HL().ld_d(0); break; }
    case pConstRef16:                    bc().ex_hl_de(!saveHL).ld_hl_ref(bs.value)        .ex_hl_de(canSwap); break;
    case pConstRef8:                     bc().ex_hl_de(!saveHL).ld_hl_ref(bs.value).ld_h(0).ex_hl_de(canSwap); break;
    default: raise("pushDE "+i2s(bs.place));
  }
}

void pushHL() {
  peekHL();
  asm_pop();
}

void pushBC() {
  peekBC();
  asm_pop();
}

void pushDE(bool canSwap, bool saveHL) {
  peekDE(canSwap, saveHL);
  asm_pop();
}

// Сначала DE, потом HL
bool pushHLDE(bool canSwap, bool self) {
  // Второй аргумент
  Place p = stack[stack.size()-2].place;

  // Оптимизация последовательности lxi h + xchg + lhld
  if(canSwap && (p==pConst || p==pStack8 || p==pStack16 || p==pConstStr || p==pBC)) {
    pushHL();
    peekDE(/*canSwap=*/true, /*saveHL=*/true); if(!self) asm_pop();
    return true;
  }

  // Если команда загрузки DE оканчивается кодом XCHG, то выгоднее DE поместить в стек последним.
  // DE выгоднее класть в стек последним, так как для загрузки HL освобождается регистр DE.
  if(!self && canSwap && lastHL!=stack.size()-1 && lastA!=stack.size()-1) {
    Stack x = stack.back(); stack.pop_back();
    peekHL(/*saveDE=*/false); if(!self) asm_pop();
    stack.push_back(x);
    peekDE(/*canSwap=*/true, /*saveHL=*/true); asm_pop();    
    return true;
  }

  // peekDE поместит значение HL в DE. Или оставит на месте.
  if(p==pHL && !self && canSwap) {
    peekDE(/*canSwap=*/true, /*saveHL=*/true); asm_pop();
    asm_pop();
    return false;
  }

  peekDE(/*canSwap=*/false, /*saveHL=*/lastHL!=-1 && lastHL!=stack.size()-1); asm_pop();
  peekHL(/*saveDE=*/true); if(!self) asm_pop();
  return false;
}

// Сохранить регистр HL в указанное место

void pokeHL() {
  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pBC:               bc().ld_bc_hl(); break;
    case pConstRef16:       bc().ld_ref_hl(bs.value); break;
    case pConstStrRef16:    bc().ld_ref_hl(bs.name); break;
    case pConstStrRefRef16: bc().ex_hl_de().ld_hl_ref(bs.name).ld_HL_d().inc_hl().ld_HL_e(); break;
    case pStackRef16:       bc().pop_de().ex_hl_de().ld_HL_d().inc_hl().ld_HL_e().dec_hl(); bs.place = pHLRef16; break; //+ //! Убрать последнюю, если это POKE
    case pHLRef16:          bc().ld_de_hl().ld_HL_d().inc_hl().ld_HL_e().dec_hl(); break; //! Очень странная команда
    case pStack8:           p.syntaxError("Нельзя записывать в 8 битную переменную");
    default:                raise("pokeHL "+i2s(bs.place));
  }
}

bool pokeHL_checkDE() {
  Stack& bs = stack[stack.size()-1];
  switch(bs.place) {
    case pBC:               return false;
    case pConstRef16:       return false;
    case pConstStrRef16:    return false;
    case pConstStrRefRef16: return true;
    case pStackRef16:       return true;
    case pHLRef16:          return true;
    default:                raise("pokeHL "+i2s(bs.place)); throw;
  }
}

// Вызывается, когда нужен регистр HL
void useA() {
  if(lastA==-1) return;
  if(lastHL!=-1 && lastHL<lastA)
    raise("x"); 
  bc().push_af();
  stack[lastA].place = pStack8;
  lastA = -1;
}

// Вызывается, когда нужен регистр HL
void useHL() {
  if(lastHL==-1) return;
  if(lastA!=-1 && lastA<lastHL)
    raise("x");
  bc().push_hl();
  Stack& s = stack[lastHL];
  switch(s.place) {
    case pHLRef8:    s.place = pStackRef8;  break;
    case pHLRef16:   s.place = pStackRef16; break;
    case pHL:        s.place = pStack16;    break;
    default: raise("useHL");
  }
  lastHL = -1;
}

void popTmpPokeA (bool s) { if(s) pokeA(); else popTmpA(); }
void pushPeekA   (bool s) { peekA(); if(!s) asm_pop(); }
void popTmpPokeHL(bool s) { if(s) pokeHL(); else popTmpHL(); }
void pushPeekHL  (bool s) { peekHL(); if(!s) asm_pop(); }
