void putch(char c) {
  asm {
    push b
    mov c, a
    call 0F809h
    pop b
  }
}