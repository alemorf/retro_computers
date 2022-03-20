const char* memchr8(const void* d, uchar s, uchar l) {
  asm {
    ; lda memchr8_3
    mov d, a
    lda memchr8_2
    lhld memchr8_1
memchr8_l1:
    ; *dest = *src    
    cmp m
    rz
    inx h
    dcr d
    jnz memchr8_l1
    xra a
    mov h, a
    mov l, a
  }
}