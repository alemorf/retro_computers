// Прибавить к 32-х битному числу 16-битное

void add32_32(ulong* a, ulong* b) {
  asm {   
    ; hl = add32_32_2   
    xchg
    lhld add32_32_1
    xchg

    ldax d
    add  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
  }
}  