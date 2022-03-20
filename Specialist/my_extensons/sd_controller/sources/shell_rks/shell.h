#include <spec/fs.h>

#define START_FILE_BUFFER 0x4000
#define END_FILE_BUFFER 0x7800
#define MAX_FILES ((END_FILE_BUFFER-START_FILE_BUFFER)/sizeof(FileInfo)/2)

struct Panel {
  FileInfo* files1;
  uchar cursorX, cursorY, cmdLineOff;
  uint  offset;
  char path[256];
  ushort cnt;
};

extern struct Panel panelA, panelB;
extern char cmdline[256];
extern uint cmdline_pos;

void getFiles();
void repairScreen(uchar dontDrawFiles);

void cmd_freespace();
void cmd_new(uchar dir);
void cmd_run(const char* prog, uchar sel);
void cmd_run2(const char* prog, const char* cmdLine);
void cmd_copymove(uchar copymode);
void cmd_delete();

void absolutePath();
void getSelectedName(char* out);