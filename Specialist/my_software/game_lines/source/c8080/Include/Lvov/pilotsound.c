uchar tmpBE82, tmpBE83;

void pilotSoundStart() {
  tmpBE82 = *(uchar*)0xBE82;
  tmpBE83 = *(uchar*)0xBE83;
}

void pilotSoundStop() {
  *(uchar*)0xBE82 = tmpBE82;
  *(uchar*)0xBE83 = tmpBE83;
}

void pilotSound(uchar period, uint delay) {
  asm {
    push b
    mov c, l
    mov b, h
    lda pilotSound_1    
    sta 0BE82h
    sta 0BE83h
    call 0E28Dh
    pop b
  }
}
