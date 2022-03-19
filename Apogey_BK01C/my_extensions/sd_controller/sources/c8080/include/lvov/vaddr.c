uint vaddr(uchar x, uchar y) {
  asm {
    push b
    lda vaddr_1
    mov c, a
    lda vaddr_2
    call 0F818h
    pop b
  }
}
