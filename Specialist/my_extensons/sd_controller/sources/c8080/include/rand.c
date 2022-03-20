uchar rand_seed = 0xFA;

uchar rand() {
  asm {
    LDA rand_seed
    mov b,a
    add a
    add a
    add b
    inr a
    sta rand_seed
  }
}
