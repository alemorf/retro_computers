#include <apogey/screen_constrcutor.h>

void apogeyScreen2a() {
  // MEM_ADDR, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN
  APOGEY_SCREEN_ECONOMY(0xE1D0, 37, 31, 3, 0x77, 75, 1, 0, 0);
}
