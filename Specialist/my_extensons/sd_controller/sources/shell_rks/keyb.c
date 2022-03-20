#include "keyb.h"

#define KEYB0 (*(uchar*)0xF800)
#define KEYB1 (*(uchar*)0xF801)
#define KEYB2 (*(uchar*)0xF802)
#define KEYB3 (*(uchar*)0xF803)

uchar scanCodes[1] = {
  KEY_F1,KEY_F2,KEY_F3,KEY_F4,KEY_F5,KEY_F6,KEY_F7,KEY_F8,KEY_F9,KEY_F10,KEY_F11,KEY_F12,
  
  0x01,0x0C,0x17,0x1A,0x09,0x1B,' ' ,0x19,0x02,0x18,0x0A,KEY_ENTER,
  
  ';' ,'1' ,'2' ,'3' ,'4' ,'5' ,'6' ,'7' ,'8' ,'9' ,'0' ,'-',
  'j' ,'c' ,'u' ,'k' ,'e' ,'n' ,'g' ,'[' ,']' ,'z' ,'h' ,'*',
  'f' ,'y' ,'w' ,'a' ,'p' ,'r' ,'o' ,'l' ,'d' ,'v' ,'\\','.',
  'q' ,'^' ,'s' ,'m' ,'i' ,'t' ,'x' ,'b' ,'@' ,',' ,'/' ,8  ,

  '+' ,'!' ,'"' ,'#' ,'$' ,'%' ,'^' ,'&' ,'*' ,'(' ,')' ,'=',
  'J' ,'C' ,'U' ,'K' ,'E' ,'N' ,'G' ,'{' ,'}' ,'Z' ,'H' ,':',
  'F' ,'Y' ,'W' ,'A' ,'P' ,'R' ,'O' ,'L' ,'D' ,'V' ,'\\','>',
  'Q' ,'^' ,'S' ,'M' ,'I' ,'T' ,'X' ,'B' ,'@' ,'<' ,'?' ,8  ,

  ';' ,'1' ,'2' ,'3' ,'4' ,'5' ,'6' ,'7' ,'8' ,'9' ,'0' ,'-',
  '©' ,'Ê' ,'„' ,'™' ,'•' ,'≠' ,'£' ,'Ë' ,'È' ,'ß' ,'Â' ,'*',
  '‰' ,'Î' ,'¢' ,'†' ,'Ø' ,'‡' ,'Æ' ,'´' ,'§' ,'¶' ,'Ì' ,'.',
  'Ô' ,'Á' ,'·' ,'¨' ,'®' ,'‚' ,'Ï' ,'°' ,'Ó' ,',' ,'/' ,8  ,

  '+' ,'!' ,'"' ,'#' ,'$' ,'%' ,'^' ,'&' ,'*' ,'(' ,')' ,'=',
  'â' ,'ñ' ,'ì' ,'ä' ,'Ö' ,'ç' ,'É' ,'ò' ,'ô' ,'á' ,'ï' ,':',
  'î' ,'õ' ,'Ç' ,'Ä' ,'è' ,'ê' ,'é' ,'ã' ,'Ñ' ,'Ü' ,'ù' ,'>',
  'ü' ,'ó' ,'ë' ,'å' ,'à' ,'í' ,'ú' ,'Å' ,'û' ,'<' ,'?' ,8  ,
}; 

// 0x80 - CTRL

uchar numberOfBit(uchar b) {
//  uchar u;
//  for(u=8; u; --u, b>>=1, --i)
//    if(b&1)
//      return scanCodes[i];
  asm {
    mvi e, 7
    mvi d, 7
numberOfBit_l:
    rar
    jnc numberOfBit_o
    dcr e
    dcr d
    jnz numberOfBit_l  
numberOfBit_o:  
    mov a, e
  }  
}

uchar rus, prevCh;

uchar scan[6] = { 0x80^~3, 0x04^~3, 0x40^~3, 0x20^~3, 0x10^~3, 0x08^~3 };

uchar getch1() {
  register uchar i, u, b;

  KEYB3 = 0x91; 

retry:
  while(1) {
    i = 6;
    while(1) {
      --i;
      KEYB1 = scan[i];
      b = KEYB0;
      if(b != 0xFF) { u = 4; break; }
      b = KEYB2 | 0xF0;
      if(b != 0xFF) { u = -4; break; }
      if(i) continue;
      i = 6;
      prevCh = -1;
    }
    b = numberOfBit(b) + u + i $ 12;
    if(prevCh != b) break;
  }

  prevCh = b;

  if(b==12) {
    rus = !rus;
    goto retry;
  }

  if(b>=24) {
    if(shiftPressed()) b += 12*4;
    if(rus) b += 12*8;
  }

  return scanCodes[b];
}

uchar shiftPressed() {
  KEYB3 = 0x82; 
  return ~KEYB1 & 2;
}