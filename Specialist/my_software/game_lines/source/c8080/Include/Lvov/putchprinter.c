void putchPrinter(char c) {
  asm {
    push b
    mov c, a
    call 0F80Ch
    pop b
  }
}