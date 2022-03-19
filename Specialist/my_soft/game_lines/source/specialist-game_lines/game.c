#include <spec/bios.h>
#include <spec/color.h>
#include <stdlib.h>
#include <mem.h>
#include "graph.h"
#include "unmlz.h"
#include "keyb.h"

extern uchar imgTitle[1], imgTitle_colors[1];
extern uchar imgScreen[1], imgScreen_colors[1];
extern uchar imgBalls[1], imgBalls_colors[1];

void colorizer_rand() {
  asm {
    push b
    mvi  b, 0
colorizerr_1:
    call rand
    
    mvi  d, 40h
    mov  e, a
    mvi  h, 90h
    mov  l, a
          
    mvi  c, 48 
colorizerr_2:
    ldax d
    inr  d
    sta  0F802h

    mov  a, m
    mov  m, a
    inr  h    

    dcr  c
    jnz  colorizerr_2

    dcr  b
    jnz  colorizerr_1
    pop  b
  }
}

void drawBall(uchar* d) {
  memcpy(d, imgBalls, 14);
  memcpy(d+0x100, imgBalls+14, 14);
}

void main() {
  uchar x, y;

  rand();

  while(1) {
    clrscr();

//    SET_COLOR(COLOR_BLACK);
//    unmlz((uchar*)0x9000, imgTitle);
//    unmlz((uchar*)0x4000, imgTitle_colors);
//    colorizer_rand();    

    SET_COLOR(COLOR_BLACK);
    unmlz((uchar*)0x9000, imgScreen);
    unmlz((uchar*)0x4000, imgScreen_colors);
    colorizer_rand();
    
    SET_COLOR(COLOR_GREEN);
    print(5,19,8,"‹…˜€");
    print(56,19,8,"‚›");
    print1(PIXELCOORDS(3,7),1,8,"65536");
    print1(PIXELCOORDS(40,7),2,8,"65536");

    for(y=0; y<9; y++) {
      for(x=0; x<9; x++) {
        drawBall(PIXELCOORDS(11+x*3, 28+y*20));
      }
    }
    getch1();  
  }
}
                      