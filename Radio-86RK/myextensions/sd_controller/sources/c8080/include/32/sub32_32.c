// Вычесть из 32-х битного 32-битное

void sub32_32(ulong* a, ulong* b) {
  asm {
    lhld sub32_32_1
    xchg
    lhld sub32_32_2
  
    ldax d
    sub m
    stax d
   
    inx h
    inx d
    ldax d
    sbb m
    stax d
    
    inx h
    inx d
    ldax d
    sbb m
    stax d

    inx h
    inx d
    ldax d
    sbb m
    stax d
  }
}  