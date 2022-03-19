// Shell for Computer "Radio 86RK"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#define VIDEO_BPL 75
#define WINDOW_X 13
#define WINDOW_Y 11
#define ROWS_CNT 22
#define INTERFACE_VIDEO_MODE radio86rkScreen2a();  
#define HARDWARE_CURSOR directCursor(x+1 ? 8+x : 255, 3+y);

//#define VIDEO_BPL 78
//#define WINDOW_X 13
//#define WINDOW_Y 8
//#define ROWS_CNT 16
//#define INTERFACE_VIDEO_MODE
//#define HARDWARE_CURSOR gotoxy(x, y);

extern uchar activePanel;

void drawInit();
void drawSwapPanels();
void hideFileCursor();
void showFileCursor();
void drawScreenInt();
void drawFile(uchar x, uchar y, FileInfo* f);
void drawPanelTitle(uchar active);
void drawColumn(uchar i);
void drawFileInfo1(char* buf);
void drawFileInfoDir();
void drawFileInfo2(char* buf);
void drawCmdLine();
void drawCmdLineWithPath();
void drawWindow(const char* title);
void drawAnyKeyButton();
void drawEscButton();
void drawWindowText(uchar ox, uchar oy, char* text);
void drawWindowProgress(uchar ox, uchar oy, uchar n, char chr);
void drawInput(uchar x, uchar y, uchar max);
void drawFilesCountInt(ulong* total, uint filesCnt);
void hideTextCursor();
void drawWindowInput(uchar x, uchar y, uchar max);
char getch1();
char bioskey1();

// Коды клавиш

#define KEY_F1    0
#define KEY_F2    1
#define KEY_F3    2
#define KEY_F4    3
#define KEY_LEFT  8
#define KEY_TAB   9
#define KEY_ENTER 13
#define KEY_ESC   27
#define KEY_RIGHT 0x18
#define KEY_UP    0x19
#define KEY_DOWN  0x1A
#define KEY_STR   0x1F
#define KEY_SPACE 0x20
#define KEY_BKSPC 0x7F
