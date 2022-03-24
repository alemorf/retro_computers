#include <stdafx.h>
#include "output.h"

bool step2;
int writePos;
char writeBuf[65536];
std::vector<Label> labels;

void write(void* data, int n) {
  if(writePos+n>65536) raise("Программа вылезла за 64Кб");
  memcpy(writeBuf+writePos, data, n);
  writePos += n;
}

void write(int n) {
  write(&n, 2);
}
