char* strcpy(char* d, const char* s) {
  asm {
    ; de = src
    xchg
    ; hl = to
    lhld strcpy_1
strcpy_l1:
    ; *dest = *src
    ldax d
    mov m, a
    ora a
    inx h
    inx d
    jnz strcpy_l1
    dcx h
  }
}