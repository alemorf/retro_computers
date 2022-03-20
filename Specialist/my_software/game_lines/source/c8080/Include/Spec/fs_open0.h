#define O_OPEN   0
#define O_CREATE 1
#define O_MKDIR  2
#define O_DELETE 100
#define O_SWAP   101

uchar fs_open0(const char* name, uchar mode) @ "spec/fs_open0.c";
