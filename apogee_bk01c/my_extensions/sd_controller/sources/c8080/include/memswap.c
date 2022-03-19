void memswap(void* arg1, void* arg2, uint arg3) {
  asm {
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memswap_2
    mov c, l
    mov b, h
    ; hl = to
    lhld memswap_1
memswap_l1:
    ; if(cnt==0) return
    mov a, d
    ora e
    jz memswap_l2
    ; *dest = *src
    ldax b
    sta memswap_v1
    mov a, m
    stax b
    .db 36h ; mvi m, 0
memswap_v1:
    .db 0    
    ; dest++, src++, cnt--
    inx h
    inx b
    dcx d
    ; loop
    jmp memswap_l1
memswap_l2:
    pop b
  }
}
