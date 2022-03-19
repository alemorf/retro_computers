// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

char compareMask1(char* fileName, char* mask, uchar i) {
  register char m;
  for(;;) {
    m = *mask;
    if(m == '*') return 1;
    if(m != '?' && m != *fileName) return 0;  
    --i;
    if(i==0) return 1;
    ++mask, ++fileName;
  }
}

//---------------------------------------------------------------------------

char compareMask(char* fileName, char* mask) {
  if(!compareMask1(fileName, mask, 8)) return 0;
  return compareMask1(fileName+8, mask+8, 3);
}

//---------------------------------------------------------------------------

void cmd_sel(char add) {
  FileInfo* f;
  uint i;
  char buf[11];

  // Спросить у пользователя
  strcpy(cmdLine, "*.*");
  if(inputBox(" pometitx fajly ")) {
    packName(buf, cmdLine);

    for(i=panelA.cnt, f=panelA.files1; i; --i, ++f) {
      if(f->fattrib & 0x10) {
        f->fattrib &= 0x7F;
      } else {
        if(compareMask(f->fname, buf)) {
          if(add) {
            f->fattrib |= 0x80;
          } else {
            f->fattrib &= 0x7F;
          }
        }
      }
    }
  }

  drawScreen();
}
