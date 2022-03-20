// Прибавить к 32-х битному числу 16-битное

void add32_16(ulong* a, ushort b) {
  asm {
    ; de = *to
    lhld add32_16_1
    mov e, m
    inx h
    mov d, m

    ; hl = de + from
    lhld add32_16_2
    dad d

    ; *hl = de
    xchg
    lhld add32_16_1
    mov m, e
    inx h
    mov m, d     

    ; Если переполнение, то увеличиваем верхний разряд
    rnc
    inx h
    inr m    

    ; Если переполнение, то увеличиваем верхний разряд
    rnz
    inx h
    inr m
  }
}  