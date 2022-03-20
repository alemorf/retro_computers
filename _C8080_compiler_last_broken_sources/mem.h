void memcpy(void* dest, void* src, uint size) {
  asm {
    mov a, h
    ora l
    rz
    push b
    push h
    lhld (memcpy_src)
    xchg
    lhld  (memcpy_dest)
    pop b
memcpy_0:
    ldax d
    inx d
    mov m, a
    inx h
    dcx b
    mov a, b
    ora c
    jnz memcpy_0
    pop b
  }
}

void memset(void* dest, uchar v, uint size) {
  asm {
    mov a, h
    ora l
    rz
    push b
    push h
    lda (memset_v) 
    mov c, a
    lhld (memset_dest)
    pop d
memset_0:
    mov m, c
    inx h
    dcx d
    mov a, d
    ora e
    jnz memset_0
    pop b
  }
}
