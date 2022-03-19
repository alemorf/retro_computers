struct HiScore {
  char name[14];
  uint score;
};

extern struct HiScore hiScores[9];

void drawSprite(uchar x, uchar y, uchar cl, uchar* s);
void drawText(uchar* d1, char* text);
void initGameScreen();
void drawScore(uint score);
void drawOnOff(uchar n, uchar state);
void redrawNewBalls(uchar a, uchar b, uchar c);
void soundJumpSel();
void soundBadMove();
void showGameOver();
void showRecordScreen(uchar c);
void demo();
void delayHS(uchar f);
void updateTopScore();