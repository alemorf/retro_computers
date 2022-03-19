void setColor(char c) {
  asm { 
    STA 0FFFEh
  }
}
