uchar rand_seed = 0xFA;

uchar rand() {
  asm {
    LDA rand_seed
    mov e,a
    add a
    add a
    add e
    inr a
    sta rand_seed
  }
}
