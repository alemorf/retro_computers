void add32_16(void* a, ushort b) @ "32/add32_16.c";
void add32_32(void* a, ulong* b) @ "32/add32_32.c";
void sub32_16(void* a, ushort b) @ "32/sub32_16.c";
void sub32_32(ulong* a, ulong* b) @ "32/sub32_32.c";
void div32_16(void* a, ushort b) @ "32/div32_16.c";
char cmp32_32(ulong* a, ulong* b) @ "32/cmp32_32.c";
char set32(ulong* a, ulong* b) @ "32/set32.c";

#define SET32IMM(a, b) { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }