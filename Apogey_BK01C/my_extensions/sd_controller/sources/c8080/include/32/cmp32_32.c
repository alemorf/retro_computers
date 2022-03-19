// Сравнить два 32-х битных числа

char cmp32_32(ulong* a, ulong* b) {
  asm {
    lhld cmp32_32_1
    inx h
    inx h
    inx h
    xchg

    lhld cmp32_32_2
    inx h
    inx h
    inx h
  
    ldax d
    cmp m
    jnz cmp32_32_l0
   
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0
    
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0

    dcx h
    dcx d
    ldax d
    cmp m
    rz

cmp32_32_l0:   
    cmc
    sbb a
    ori 1
    ret
  }
}