#include "keyb.h"

struct HiScore {
  char name[14];
  uint score;
};

extern struct HiScore hiScores[9];
extern uchar cursorX, cursorY;

char getch_();
char bioskey_();

#define KEY_SPACE  32
#define KEY_COLOR  KEY_F1
#define KEY_HELP   KEY_F4
#define KEY_PATH   KEY_F2
#define KEY_SOUND  KEY_F3
#define KEY_RECORD KEY_F5
#define KEY_NEW    KEY_F6
                                                                                      
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