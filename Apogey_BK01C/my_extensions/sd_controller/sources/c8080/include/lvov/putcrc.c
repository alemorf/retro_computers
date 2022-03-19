void putCrc(void* start, void* end) {
  asm {  
    xchg
    lhld putCrc_1
    call 0F815h
  }
}