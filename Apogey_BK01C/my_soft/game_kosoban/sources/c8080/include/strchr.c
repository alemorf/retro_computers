const char* strchr(const char* d, char s) {
  asm {
    mov d, a
    lhld strchr_1
strchr_l1:
    ; *dest = *src    
    mov a, m
    cmp d
    rz
    inx h
    ora a
    jnz strchr_l1
    mov h, a
    mov l, a
  }
}