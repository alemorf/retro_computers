void putchAll(char c) {
  asm {
    push b
    mov c, a
    call 0F80Fh
    pop b
  }
}