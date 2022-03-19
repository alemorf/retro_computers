struct HiScore {
  char name[14];
  uint score;
};

extern struct HiScore hiScores[9];
extern uchar cursorX, cursorY;

char getch_();
char bioskey_();

#define K_SPACE  ' '
#define K_PATH   1
#define K_SOUND  2
#define K_HELP   3
#define K_RECORD 4
#define K_NEW    5
#define K_LEFT   8
#define K_RIGHT  0x18
#define K_UP     0x19
#define K_DOWN   0x1A
#define K_ENTER  0x0D
                                                                                      
void drawCursor();
void drawSprite(uchar x, uchar y, uchar s);
void drawSpriteRemove(uchar x, uchar y, uchar s, uchar n);
void drawSpriteNew(uchar x, uchar y, uchar s, uchar n);
void drawSpriteStep(uchar x, uchar y, uchar n);
void drawSpriteSel(uchar x, uchar y, uchar s, uchar c, uchar t);
void drawScore1();

void drawText(uchar* d1, char* text);
void initGameScreen();
void drawScore(uint score, char* text);
void drawOnOff(uchar n, uchar state);
void redrawNewBalls(uchar a, uchar b, uchar c);
void redrawNewBalls2();
void soundJumpSel();
void soundBadMove();
void showGameOver();
void prepareRecordScreen();
void drawRecordScreen(uchar c);
void intro();
void delayHS(uchar f);
void updateTopScore();
void i2s(char* buf, uint x);
void redrawNewBallsOff();
void drawRecordLastLine();
void drawCells();
void delay(uchar a);

extern uchar showPath, showHelp, playSound;