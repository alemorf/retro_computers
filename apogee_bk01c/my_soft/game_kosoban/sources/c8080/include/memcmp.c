char memcmp(const char* d, const char* s, uint len) {
  asm {
    ; if(len==0) return 0;
    mov a, l
    ora h
    rz
    push b
    ; de = len
    xchg
    ; bc = d
    lhld memcmp_1
    mov b, h
    mov c, l
    ; hl = s
    lhld memcmp_2
    ; loop
memcmp_l1:
      ldax b
      cmp m
      jnz memcmp_stop
      inx h
      inx b
      dcx d
      mov a, d
      ora e
    jnz memcmp_l1
    pop b
    ; a=0
    ret
memcmp_stop:
    pop b
    sbb a
    rc
    inr a
    ret
  }
}