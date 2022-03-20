#include <stdafx.h>
#include "b.h"

int combineState_r(State::Reg& s, const State::Reg& saved) {
  // Констатное значение просто забываем
  if(s.const_value != saved.const_value || !saved.const_) s.const_ = false; 

  // Временное значение просто забываем
  if(s.tmp != saved.tmp) s.tmp = 0; 

  if(saved.in && saved.changed) { // Если во второй ветке у нас в регистре несохраненная переменная.
    if(s.in!=saved.in || s.delta!=saved.delta) return 2; // То в основной ветке должна быть та же переменая, иначе компиляция невозможна. //! А можно её загрузить
    s.changed = true; // Причем, в главной ветке она может быть уже сохраненной. Мы восстанавливаем признак.
    return 0;
  }

  // Если в основной ветке у нас в регистре несохраненная переменная.
  if(s.in && s.changed) {
    if(s.in==saved.in && s.delta==saved.delta) return 0; // И во второй была такая же переменная, просто выходим
    // Сохраняем 
    return 1;
  }

  // Не сохраненных значений нет
  return 0;
}

bool combineState_(const State& saved) {
  switch(combineState_r(s.a, saved.a )) {
    case 2: return false;
    case 1: saveRegAAndUsed();
  }
  switch(combineState_r(s.de, saved.de)) {
    case 2: return false;
    case 1: saveRegDEAndUsed();
  }
  switch(combineState_r(s.hl, saved.hl)) {
    case 2: return false;
    case 1: saveRegHLAndUsed();
  }
  return true;
}
