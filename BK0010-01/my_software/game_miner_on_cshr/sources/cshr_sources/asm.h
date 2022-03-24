#ifndef ASM_H
#define ASM_H

struct Arg {
  int ext, code;
  bool needExt1, subip;
};

void asmJmp(int code, int i);
void asmSob(int r, int a);

int  readReg (int& argSize);
bool readAddr1();
void readArg (Arg& a, int& argSize); // 0-any 1-byte 2-word
int  needAddr();

void parse_asm();

#endif