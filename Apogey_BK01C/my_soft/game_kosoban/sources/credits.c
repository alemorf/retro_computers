#include <apogey/screen_constrcutor.h>
#include "music.h"

const char* credits =    
"\r\n"
"\r\n"
"                          \x84kosoban\x89\r\n"
"                 \x84dlq kompx`tera apogej bk01c\x89\r\n"
"                         \x8416 awg 2014\x89\r\n"
"\r\n"
"\r\n"
"\r\n"
"                       \x80programmirowanie\x89\r\n"
"                 \x80morozow aleksej AKA VINXRU\x89\r\n"
"                 \x80ALEKSEY.F.MOROZOV@GMAIL.COM\x89\r\n"
"\r\n"
"\r\n"
"\r\n"
"   \x85izobravenie panka bylo najdeno na prostorah interneta\x89\r\n"
"\r\n"
"\r\n"
"\r\n"
"   \x88noty melodii byli wzqty iz fajla SHARE_AND_ENJOY.MOD\x89\r\n"
"\r\n"
"\r\n"
"\r\n"
"     \x8Cideq igry i urowni wzqty s GAMEABOUTSQUARES.COM\x89\r\n"
"          \x8CANDREY SHEVCHUK CAMPUGNATUS@GMAIL.COM\x89\r\n";

void biosInitVideo() @ 0xF82D;


#define BALLS 5
uchar x, y, dx, dy, *p;
uchar buf[6*BALLS];

void randBall() {
  dx = ((uchar)rand()&2) ? 1 : 255;
  dy = ((uchar)rand()&2) ? 1 : 255;
  x = (uchar)rand()&63; 
  y = (uchar)rand()&31; if(y>=25) y-=25;
}

void showCredits() {
  char* s;
  uchar x1, y1, n, *p1, sd, tries;
  uint d;
  d-=d;
  biosInitVideo();
  VG75[1] = 0x80;
  VG75[0] = 0xFF;
  VG75[0] = 0xFF;
  asm { di }
  putch(0x1F);
  putch(0x89);
  s = credits;

  p=0;
  n=0;
  for(x1=BALLS; x1; --x1) {
    randBall(); p=0;
    memswap(&x, buf+n, 6); n+=6; if(n==6*BALLS) n=0;
  }
  randBall(); p=0;

  sd=50;  
  n=0;
  musicStart();
 
  while(bioskey() == 0xFF) {
    for(sd=BALLS+1; sd; sd--) {
    memswap(&x, buf+n, 6); n+=6; if(n==6*BALLS) n=0;

    for(tries=2; tries; tries--) {
      x1=x+dx, y1=y+dy;
      if(y1>=25 || x1>=64) {
        if(y1>=25) dy=0-dy;
        if(x1>=64) dx=0-dx;
        continue;
      }
      p1 = (uchar*)(0xE1D0+3*78+8) + x1 + y1*78;
      if(tries==2)
      if(*p1!=0 && *p1!=32) {  //  && *p1!=0x2F && *p1!=0x5C
        if(rand()&255<16) dx=0-dx; else dy=0-dy; 
        continue;
      }
      if(*p==0xC) *p = 0; //(dx==dy) ? 0x5C : 0x2F;
      p = p1;
      if(*p==0 || *p==32) *p=0xC;
      x=x1, y=y1;
      tries=1;
    }
    }

   musicTick();
 
   // ֲûגמה סטלגמכא
   if(*s) { 
     putch(0x18); 
     putch(0x89); 
      putch(0x08); 
      putch(0x08); 
      putch(*s); 
      s++; 
    }
  }  
  musicStop();
}
