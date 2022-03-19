// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

//#include "fs.h"
#include <fs/fs.h>
#include "interface.h"

#define START_FILE_BUFFER 0x3400
#define ERR_USER 128 // Ïנונגאםמ ןמכüחמגאעוכול

typedef struct {
  FileInfo* files1;
  char      path1[256];
  uchar     cursorX, cursorY;
  uint      offset;
  ushort    cnt, cmdLineOff;
} Panel;

extern Panel panelA;
extern Panel panelB;
extern char  cmdline[256];
extern uint  maxFiles;
extern char  editorApp[1];
extern char  viewerApp[1];

FileInfo* getSel();
FileInfo* getSelNoBack();
void drawScreen();
void drawError(const char* text, uchar e);
char inputBox(const char* title);
char confirm(const char* title, const char* text);
void run(const char* prog, const char* cmdLine);
void unpackName(char* d, const char* s);
char catPathAndUnpack(char* str, char* fileName);
char getFirstSelected(char* name);
char getNextSelected(char* name);
void packName(char* buf, char *path);
void getFiles();
char absolutePath(char* str);
const char* getName(const char* name);
void dropPathInt(char* src, char* preparedName);
void dupFiles(uchar reload);

// Â פאיכו cmd_freespace.c
void cmd_freespace();

// Â פאיכו cmd_new.c
void cmd_new(uchar dir);

// Â פאיכו cmd_copymove.c
void cmd_copymove(uchar copymode, uchar shiftPressed);

// Â פאיכו cmd_delete.c
void cmd_delete();

// Â פאיכו cmd_sel.c
void cmd_sel(char add);