// Вычесть из 32-х битного 16-битное

void sub32_16(ulong* a, ushort b) {
  asm {
    lhld sub32_16_1
    xchg
    lhld sub32_16_2
  
    ldax d
    sub l
    stax d
   
    inx d
    ldax d
    sbb h
    stax d

    inx d
    ldax d
    sbi 0
    stax d

    inx d
    ldax d
    sbi 0
    stax d
  }
}  