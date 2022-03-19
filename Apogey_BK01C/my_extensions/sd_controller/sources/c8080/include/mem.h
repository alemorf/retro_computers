//#ifndef __MEM_H
//#define __MEM_H

void memset(void*, char, unsigned int) @ "memset.c";
void memcpy(void*, const void*, unsigned int) @ "memcpy.c";
void* memchr8(const void*, uchar, uchar) @ "memchr8.c";
char memcmp(const void*, const void*, unsigned int) @ "memcmp.c";
void memcpy_back(void*, const void*, unsigned int) @ "memcpy_back.c";
void memswap(void*, const void*, unsigned int) @ "memswap.c";

//#endif