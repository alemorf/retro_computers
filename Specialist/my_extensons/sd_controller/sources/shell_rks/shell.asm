  .include "stdlib8080.inc"
printName:
  shld printName_2
  ; 33 print1(a, 0, 8, name); 
  lhld printName_1
  shld print1_1
  xra a
  sta print1_2
  mvi a, 8
  sta print1_3
  lhld printName_2
  call print1
  ; 34 print1(a + 0x600, 1, 3, name + 8); Сложение
  lhld printName_1
  lxi d, 1536
  dad d
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 3
  sta print1_3
  ; Сложение
  lhld printName_2
  lxi d, 8
  dad d
  jmp print1
absolutePath:
  lda (cmdline)+(0)
  cpi 47
  jnz l0
  ; 40 strcpy(cmdline, cmdline+1);
  lxi h, cmdline
  shld strcpy_1
  lxi h, (cmdline)+(1)
  call strcpy
  jmp l1
l0:
  ; 42 l = strlen(panelA.path+1);
  lxi h, ((panelA)+(7))+(1)
  call strlen
  shld absolutePath_l
  ; 43 if(l != 0) l++;Сложение с константой 0
  mov a, l
  ora h
  jz l2
  ; 43 l++;
  mov d, h
  mov e, l
  inx h
  shld absolutePath_l
  xchg
l2:
  ; 44 memcpy_back(cmdline+l, cmdline, strlen(cmdline)+1);Сложение
  lhld absolutePath_l
  lxi d, cmdline
  dad d
  shld memcpy_back_1
  lxi h, cmdline
  shld memcpy_back_2
  call strlen
  ; Сложение с константой 1
  inx h
  call memcpy_back
  ; 45 memcpy(cmdline, panelA.path+1, l);
  lxi h, cmdline
  shld memcpy_1
  lxi h, ((panelA)+(7))+(1)
  shld memcpy_2
  lhld absolutePath_l
  call memcpy
  ; 46 if(l != 0) cmdline[l-1] = '/';Сложение с константой 0
  lhld absolutePath_l
  mov a, l
  ora h
  jz l3
  ; 46 cmdline[l-1] = '/';Сложение с константой -1
  dcx h
  ; Сложение
  lxi d, cmdline
  dad d
  mvi m, 47
l3:
l1:
  ret
  ; --- drawColumn_ -----------------------------------------------------------------
drawColumn_:
  push b
  sta drawColumn__1
  ; 52 3+i*15, y;<x>
  mvi d, 15
  call op_mul
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  mov a, l
  sta drawColumn__x
  ; 54 panelA.offset+i*ROWS_CNT;<n>
  mvi d, 18
  lda drawColumn__1
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(5)
  dad d
  mov b, h
  mov c, l
  ; 55 panelA.files1 + n;  <f>
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  shld drawColumn__f
  ; 57 graph0();
  call graph0
  ; 59 a = TEXTCOORDS(x,2);
  mvi d, 3
  lda drawColumn__x
  call op_mul
  lxi d, 4
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  lxi d, 36885
  dad d
  shld drawColumn__a
  ; 60 for(y=0; y!=ROWS_CNT; ++y, a+=10) {
  xra a
  sta drawColumn__y
l4:
  lda drawColumn__y
  cpi 18
  jz l5
  ; 61 if(n>=panelA.cnt) {
  lhld (panelA)+(263)
  mov d, b
  mov e, c
  call op_cmp16
  jz l8
  jnc l7
l8:
  ; 62 fillRect1(a,8,255,255,(ROWS_CNT-y)*10);
  lhld drawColumn__a
  shld fillRect1_1
  lxi h, 8
  shld fillRect1_2
  mvi a, 255
  sta fillRect1_3
  sta fillRect1_4
  ; Арифметика 3/4
  lxi h, drawColumn__y
  mvi a, 18
  sub m
  mvi d, 10
  call op_mul
  mov a, l
  call fillRect1
  ; 63 break;
  jmp l5
l7:
  ; 65 printName(a, f->fname);
  lhld drawColumn__a
  shld printName_1
  lhld drawColumn__f
  call printName
  ; 66 ++f; ++n;
  lhld drawColumn__f
  lxi d, 20
  dad d
  shld drawColumn__f
  ; 66 ++n;
  inx b
l6:
  lxi h, drawColumn__y
  inr m
  ; Сложение
  lxi d, 10
  lhld drawColumn__a
  dad d
  shld drawColumn__a
  jmp l4
l5:
  pop b
  ret
  ; --- drawFiles_ -----------------------------------------------------------------
drawFiles_:
  xra a
  call drawColumn_
  ; 72 drawColumn_(1);
  mvi a, 1
  jmp drawColumn_
drawFile1:
  push b
  sta drawFile1_3
  ; 76 panelA.offset+y+x*ROWS_CNT;<n>Сложение
  lhld (panelA)+(5)
  xchg
  mov l, a
  mvi h, 0
  dad d
  push h
  mvi d, 18
  lda drawFile1_2
  call op_mul
  ; Сложение
  pop d
  dad d
  mov b, h
  mov c, l
  ; 77 graph0();
  call graph0
  ; 78 if(n<panelA.cnt) printName(a, panelA.files1[n].fname); //print1(a, 0, 11, panelA.files1[n].fname);
  lhld (panelA)+(263)
  mov d, b
  mov e, c
  call op_cmp16
  jc l9
  jz l9
  ; 78 printName(a, panelA.files1[n].fname); //print1(a, 0, 11, panelA.files1[n].fname);
  lhld drawFile1_1
  shld printName_1
  mov h, b
  mov l, c
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  call printName
  jmp l10
l9:
  ; 79 print1(a, 0, 11|0x80, "");
  lhld drawFile1_1
  shld print1_1
  xra a
  sta print1_2
  mvi a, 139
  sta print1_3
  lxi h, string0
  call print1
l10:
  pop b
  ret
  ; --- drawFile -----------------------------------------------------------------
drawFile:
  sta drawFile_2
  ; 83 drawFile1(TEXTCOORDS(3+x*15, 2+y), x, y);
  adi 2
  mvi d, 10
  call op_mul
  ; Сложение
  lxi d, 36865
  dad d
  push h
  mvi d, 15
  lda drawFile_1
  call op_mul
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  lxi d, 3
  call op_mul16
  lxi d, 4
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  pop d
  dad d
  shld drawFile1_1
  lda drawFile_1
  sta drawFile1_2
  lda drawFile_2
  jmp drawFile1
hideCursor_:
  lhld cursorX1
  mov a, l
  ora h
  jz l11
  ; 88 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 89 graphXor();
  call graphXor
  ; 90 fillRect(cursorX1-3, cursorY1, cursorX1-1, cursorY1+9);Сложение с константой -3
  lhld cursorX1
  dcx h
  dcx h
  dcx h
  shld fillRect_1
  lda cursorY1
  sta fillRect_2
  ; Сложение с константой -1
  lhld cursorX1
  dcx h
  shld fillRect_3
  lda cursorY1
  adi 9
  call fillRect
  ; 91 fillRect(cursorX1+(12*6)+1, cursorY1, cursorX1+(12*6)+3, cursorY1+9);Сложение
  lhld cursorX1
  lxi d, 72
  dad d
  ; Сложение с константой 1
  inx h
  shld fillRect_1
  lda cursorY1
  sta fillRect_2
  ; Сложение
  lhld cursorX1
  lxi d, 72
  dad d
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  shld fillRect_3
  lda cursorY1
  adi 9
  call fillRect
  ; 92 setColor(COLOR_WHITE);
  xra a
  call setColor
  ; 93 fillRect(cursorX1, cursorY1, cursorX1+(12*6), cursorY1+9);
  lhld cursorX1
  shld fillRect_1
  lda cursorY1
  sta fillRect_2
  ; Сложение
  lhld cursorX1
  lxi d, 72
  dad d
  shld fillRect_3
  lda cursorY1
  adi 9
  call fillRect
  ; 94 cursorX1 = 0;
  lxi h, 0
  shld cursorX1
l11:
  ret
  ; --- normalizeFileName -----------------------------------------------------------------
normalizeFileName:
  shld normalizeFileName_2
  ; 100 for(i=0; i!=11; ++i, ++s) {
  xra a
  sta normalizeFileName_i
l12:
  lda normalizeFileName_i
  cpi 11
  jz l13
  ; 101 if(i==8) *d = '.', ++d;
  cpi 8
  jnz l15
  ; 101 *d = '.', ++d;
  lhld normalizeFileName_1
  mvi m, 46
  inx h
  shld normalizeFileName_1
l15:
  ; 102 if(*s!=' ') *d = *s, ++d;
  lhld normalizeFileName_2
  mov a, m
  cpi 32
  jz l16
  ; 102 *d = *s, ++d;
  mov a, m
  lhld normalizeFileName_1
  mov m, a
  lhld normalizeFileName_1
  inx h
  shld normalizeFileName_1
l16:
l14:
  lxi h, normalizeFileName_i
  inr m
  lhld normalizeFileName_2
  inx h
  shld normalizeFileName_2
  jmp l12
l13:
  ; 104 if(d[-1]=='.') --d;Сложение с константой -1
  lhld normalizeFileName_1
  dcx h
  mov a, m
  cpi 46
  jnz l17
  ; 104 --d;
  lhld normalizeFileName_1
  dcx h
  shld normalizeFileName_1
l17:
  ; 105 *d = 0;
  lhld normalizeFileName_1
  mvi m, 0
  ret
  ; --- getSelectedName -----------------------------------------------------------------
getSelectedName:
  shld getSelectedName_1
  ; 110 n = panelA.offset+panelA.cursorY+panelA.cursorX*ROWS_CNT;Сложение
  lhld (panelA)+(5)
  xchg
  lhld (panelA)+(3)
  mvi h, 0
  dad d
  push h
  mvi d, 18
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  pop d
  dad d
  shld getSelectedName_n
  ; 111 if(n>=panelA.cnt) { name[0]=0; return; }
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jz l19
  jnc l18
l19:
  ; 111 name[0]=0; return; }Сложение с константой 0
  lhld getSelectedName_1
  mvi m, 0
  ; 111 return; }
  ret
l18:
  ; 112 normalizeFileName(name, panelA.files1[n].fname);
  lhld getSelectedName_1
  shld normalizeFileName_1
  lhld getSelectedName_n
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  jmp normalizeFileName
drawFileInfo_:
  xra a
  call setColor
  ; 121 graph0();
  call graph0
  ; 123 n = panelA.offset+panelA.cursorY+panelA.cursorX*ROWS_CNT;Сложение
  lhld (panelA)+(5)
  xchg
  lhld (panelA)+(3)
  mvi h, 0
  dad d
  push h
  mvi d, 18
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  pop d
  dad d
  shld drawFileInfo__n
  ; 124 if(n>=panelA.cnt) f = (FileInfo*)parentDir;
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jz l21
  jnc l20
l21:
  ; 124 f = (FileInfo*)parentDir;
  lxi h, parentDir
  shld drawFileInfo__f
  jmp l22
l20:
  ; 125 f = panelA.files1 + n;
  lhld drawFileInfo__n
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  shld drawFileInfo__f
l22:
  ; 127 if(f->fattrib & 0x10) {Сложение
  lhld drawFileInfo__f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l23
  ; 128 print1(PRINTARGS(3,21), 10, "     \x10DIR\x11");
  lxi h, 37587
  shld print1_1
  mvi a, 3
  sta print1_2
  mvi a, 10
  sta print1_3
  lxi h, string1
  call print1
  jmp l24
l23:
  ; 130 i2s32(buf, 10, &f->fsize, ' ');           
  lxi h, drawFileInfo__buf
  shld i2s32_1
  lxi h, 10
  shld i2s32_2
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 12
  dad d
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 131 print1(PRINTARGS(3,21), 10, buf);
  lxi h, 37587
  shld print1_1
  mvi a, 3
  sta print1_2
  mvi a, 10
  sta print1_3
  lxi h, drawFileInfo__buf
  call print1
l24:
  ; 138 if(f->fdate==0 && f->ftime==0) {Сложение
  lhld drawFileInfo__f
  lxi d, 18
  dad d
  ; Сложение с константой 0
  mov e, m
  inx h
  mov d, m
  xchg
  mov a, l
  ora h
  jnz l25
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 16
  dad d
  ; Сложение с константой 0
  mov e, m
  inx h
  mov d, m
  xchg
  mov a, l
  ora h
  jnz l25
  ; 139 print1(PRINTARGS(14,21), 16|0x80, "");
  lxi h, 39635
  shld print1_1
  mvi a, 2
  sta print1_2
  mvi a, 144
  sta print1_3
  lxi h, string0
  call print1
  jmp l26
l25:
  ; 141 i2s(buf, f->fdate & 31, 2, ' ');  
  lxi h, drawFileInfo__buf
  shld i2s_1
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 18
  dad d
  ; 16 битная арифметическая операция с константой
  mov e, m
  inx h
  mov d, m
  xchg
  mov a, l
  ani 31
  mov l, a
  mvi h, 0
  shld i2s_2
  mvi l, 2
  shld i2s_3
  mvi a, 32
  call i2s
  ; 142 buf[2] = '-';
  mvi a, 45
  sta (drawFileInfo__buf)+(2)
  ; 143 i2s(buf+3, (f->fdate>>5) & 15, 2, '0');
  lxi h, (drawFileInfo__buf)+(3)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 18
  dad d
  ; Сдвиг вправо
  mov e, m
  inx h
  mov d, m
  xchg
  lxi d, 5
  call op_shr16
  ; 16 битная арифметическая операция с константой
  mov a, l
  ani 15
  mov l, a
  mvi h, 0
  shld i2s_2
  mvi l, 2
  shld i2s_3
  mvi a, 48
  call i2s
  ; 144 buf[5] = '-';
  mvi a, 45
  sta (drawFileInfo__buf)+(5)
  ; 145 i2s(buf+6, (f->fdate>>9)+1980, 4, '0');
  lxi h, (drawFileInfo__buf)+(6)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 18
  dad d
  ; Сдвиг вправо
  mov e, m
  inx h
  mov d, m
  xchg
  lxi d, 9
  call op_shr16
  ; Сложение
  lxi d, 1980
  dad d
  shld i2s_2
  lxi h, 4
  shld i2s_3
  mvi a, 48
  call i2s
  ; 146 buf[10] = ' ';
  mvi a, 32
  sta (drawFileInfo__buf)+(10)
  ; 147 i2s(buf+11, f->ftime>>11, 2, '0');
  lxi h, (drawFileInfo__buf)+(11)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 16
  dad d
  ; Сдвиг вправо
  mov e, m
  inx h
  mov d, m
  xchg
  lxi d, 11
  call op_shr16
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
  ; 148 buf[13] = ':';
  mvi a, 58
  sta (drawFileInfo__buf)+(13)
  ; 149 i2s(buf+14, (f->ftime>>5)&63, 2, '0');
  lxi h, (drawFileInfo__buf)+(14)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo__f
  lxi d, 16
  dad d
  ; Сдвиг вправо
  mov e, m
  inx h
  mov d, m
  xchg
  lxi d, 5
  call op_shr16
  ; 16 битная арифметическая операция с константой
  mov a, l
  ani 63
  mov l, a
  mvi h, 0
  shld i2s_2
  mvi l, 2
  shld i2s_3
  mvi a, 48
  call i2s
  ; 150 print1(PRINTARGS(14,21), 32, buf);
  lxi h, 39635
  shld print1_1
  mvi a, 2
  sta print1_2
  mvi a, 32
  sta print1_3
  lxi h, drawFileInfo__buf
  call print1
l26:
  ret
  ; --- moveCursor_ -----------------------------------------------------------------
moveCursor_:
  call hideCursor_
  ; 161 cursorX1 = panelA.cursorX*88+16;
  mvi d, 88
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  lxi d, 16
  dad d
  shld cursorX1
  ; 162 cursorY1 = (panelA.cursorY+2)*10;
  lda (panelA)+(3)
  adi 2
  mvi d, 10
  call op_mul
  mov a, l
  sta cursorY1
  ; 164 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 165 graphXor();
  call graphXor
  ; 166 fillRect(cursorX1-3, cursorY1, cursorX1+(12*6)+3, cursorY1+9);Сложение с константой -3
  lhld cursorX1
  dcx h
  dcx h
  dcx h
  shld fillRect_1
  lda cursorY1
  sta fillRect_2
  ; Сложение
  lhld cursorX1
  lxi d, 72
  dad d
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  shld fillRect_3
  lda cursorY1
  adi 9
  call fillRect
  ; 168 drawFileInfo_();
  jmp drawFileInfo_
swapPanels:
  lhld panelGraphOffset
  mvi a, 0
  sub l
  mov l, a
  mvi a, 23
  sbb h
  mov h, a
  shld panelGraphOffset
  ; 173 memswap(&panelA, &panelB, sizeof(struct Panel));  
  lxi h, panelA
  shld memswap_1
  lxi h, panelB
  shld memswap_2
  lxi h, 265
  jmp memswap
clearCmdLine:
  lxi h, 0
  shld cmdline_pos
  ; 178 drawCmdLine();
  jmp drawCmdLine
drawPathInCmdLine:
  call graph0
  ; 184 setColor(COLOR_WHITE);  
  xra a
  call setColor
  ; 185 fillrect1(FILLRECTARGS(0,230,383,239));
  lxi h, 37094
  shld fillRect1_1
  lxi h, 48
  shld fillRect1_2
  mvi a, 255
  sta fillRect1_3
  xra a
  sta fillRect1_4
  mvi a, 10
  call fillRect1
  ; 186 l = strlen(panelA.path);
  lxi h, (panelA)+(7)
  call strlen
  shld drawPathInCmdLine_l
  ; 187 if(l>=30) o=l-30, l=30; else o=0;Сложение
  lxi d, 65506
  dad d
  jnc l27
  ; 187 o=l-30, l=30; else o=0;Сложение
  lhld drawPathInCmdLine_l
  lxi d, 65506
  dad d
  shld drawPathInCmdLine_o
  lxi h, 30
  shld drawPathInCmdLine_l
  jmp l28
l27:
  ; 187 o=0;
  lxi h, 0
  shld drawPathInCmdLine_o
l28:
  ; 188 print1(PRINTARGS(1, 23), l, panelA.path+o);
  lxi h, 37095
  shld print1_1
  mvi a, 1
  sta print1_2
  lda drawPathInCmdLine_l
  sta print1_3
  ; Сложение
  lhld drawPathInCmdLine_o
  lxi d, (panelA)+(7)
  dad d
  call print1
  ; 189 panelA.cmdLineOff = 2+l;Сложение с константой 2
  lhld drawPathInCmdLine_l
  inx h
  inx h
  mov a, l
  sta (panelA)+(4)
  ; 190 print1(PRINTARGS(panelA.cmdLineOff-1, 23), 1, ">");
  dcr a
  mvi d, 3
  call op_mul
  lxi d, 4
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  lxi d, 37095
  dad d
  shld print1_1
  lda (panelA)+(4)
  dcr a
  ani 3
  sta print1_2
  mvi a, 1
  sta print1_3
  lxi h, string2
  call print1
  ; 191 drawCmdLine();
  jmp drawCmdLine
drawPath_:
  sta drawPath__1
  ; 199 p  = panelA.path;
  lxi h, (panelA)+(7)
  shld drawPath__p
  ; 201 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 203 x1 = 18;
  lxi h, 18
  shld drawPath__x1
  ; 204 x3 = x1+6*27;Сложение
  lxi d, 162
  dad d
  shld drawPath__x3
  ; 205 graph0();
  call graph0
  ; 206 fillRect(x1,0,x3,9);
  lhld drawPath__x1
  shld fillRect_1
  xra a
  sta fillRect_2
  lhld drawPath__x3
  shld fillRect_3
  mvi a, 9
  call fillRect
  ; 207 graph1();
  call graph1
  ; 208 fillRect(x1,3,x3,3);
  lhld drawPath__x1
  shld fillRect_1
  mvi a, 3
  sta fillRect_2
  lhld drawPath__x3
  shld fillRect_3
  call fillRect
  ; 209 fillRect(x1,5,x3,5);
  lhld drawPath__x1
  shld fillRect_1
  mvi a, 5
  sta fillRect_2
  lhld drawPath__x3
  shld fillRect_3
  call fillRect
  ; 211 if(active) graph1(); else graph0();convertToConfition
  lda drawPath__1
  ora a
  jz l29
  ; 211 graph1(); else graph0();
  call graph1
  jmp l30
l29:
  ; 211 graph0();
  call graph0
l30:
  ; 213 l = strlen(p);
  lhld drawPath__p
  call strlen
  shld drawPath__l
  ; 214 if(l>=25) p=panelA.path+(l-25), l=25;Сложение
  lxi d, 65511
  dad d
  jnc l31
  ; 214 p=panelA.path+(l-25), l=25;Сложение
  lhld drawPath__l
  lxi d, 65511
  dad d
  ; Сложение
  lxi d, (panelA)+(7)
  dad d
  shld drawPath__p
  lxi h, 25
  shld drawPath__l
l31:
  ; 215 x = (32*3-l*3)/4;
  lhld drawPath__l
  lxi d, 3
  call op_mul16
  ; 16 битная арифметическая операция с константой
  mvi a, 96
  sub l
  mov l, a
  mvi a, 0
  sbb h
  mov h, a
  lxi d, 4
  call op_div16
  shld drawPath__x
  ; 216 fillRect(x*4-3, 0, x*4+l*6+6, 9);
  lxi d, 4
  call op_mul16
  ; Сложение с константой -3
  dcx h
  dcx h
  dcx h
  shld fillRect_1
  xra a
  sta fillRect_2
  lhld drawPath__x
  lxi d, 4
  call op_mul16
  push h
  lhld drawPath__l
  lxi d, 6
  call op_mul16
  ; Сложение
  pop d
  dad d
  ; Сложение
  lxi d, 6
  dad d
  shld fillRect_3
  mvi a, 9
  call fillRect
  ; 217 print1(PIXELCOORDS((x/2), 0), (((uchar)x)&1) ? 1 : 3, l, p);
  lxi d, 2
  lhld drawPath__x
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  lxi d, 36865
  dad d
  shld print1_1
  lda drawPath__x
  ani 1
  jz l32
  mov a, e
  jmp l33
l32:
  mvi a, 3
l33:
  sta print1_2
  lda drawPath__l
  sta print1_3
  lhld drawPath__p
  call print1
  ; 219 setColor(COLOR_WHITE);  
  xra a
  jmp setColor
drawCmdLine:
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  mvi m, 0
  ; 227 graph0();
  call graph0
  ; 228 drawInput(PRINTARGS(panelA.cmdLineOff, 23), 62-panelA.cmdLineOff);
  mvi d, 3
  lda (panelA)+(4)
  call op_mul
  lxi d, 4
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  lxi d, 37095
  dad d
  shld drawInput_1
  lda (panelA)+(4)
  ani 3
  sta drawInput_2
  ; Арифметика 3/4
  lxi h, (panelA)+(4)
  mvi a, 62
  sub m
  jmp drawInput
cmpFileInfo:
  shld cmpFileInfo_2
  ; 235 i = (a->fattrib&0x10);Сложение
  lhld cmpFileInfo_1
  lxi d, 11
  dad d
  mov a, m
  ani 16
  sta cmpFileInfo_i
  ; 236 j = (b->fattrib&0x10);Сложение
  lhld cmpFileInfo_2
  lxi d, 11
  dad d
  mov a, m
  ani 16
  sta cmpFileInfo_j
  ; 237 if(i<j) return 1;
  lxi h, cmpFileInfo_j
  lda cmpFileInfo_i
  cmp m
  jnc l34
  ; 237 return 1;
  mvi a, 1
  ret
l34:
  ; 238 if(j<i) return 0;
  lxi h, cmpFileInfo_i
  lda cmpFileInfo_j
  cmp m
  jnc l35
  ; 238 return 0;
  xra a
  ret
l35:
  ; 239 if(1==memcmp(a->fname, b->fname, sizeof(a->fname))) return 1;
  lhld cmpFileInfo_1
  shld memcmp_1
  lhld cmpFileInfo_2
  shld memcmp_2
  lxi h, 11
  call memcmp
  cpi 1
  jnz l36
  ; 239 return 1;
  mvi a, 1
  ret
l36:
  ; 240 return 0;
  xra a
  ret
  ; --- sort -----------------------------------------------------------------
sort:
  shld sort_2
  ; 245 st_;<st>
  lxi h, sort_st_
  shld sort_st
  ; 246 0;<stc>
  xra a
  sta sort_stc
  ; 247 while(1) {
l37:
  ; 248 i = low;
  lhld sort_1
  shld sort_i
  ; 249 j = high;
  lhld sort_2
  shld sort_j
  ; 250 x = low + (high-low)/2;16 битная арифметическая операция с константой
  lhld sort_1
  xchg
  lhld sort_2
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  lxi d, 20
  call op_div16
  lxi d, 2
  call op_div16
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld sort_1
  dad d
  shld sort_x
  ; 251 while(1) {
l39:
  ; 252 while(0!=cmpFileInfo(x, i)) i++;
l41:
  lhld sort_x
  shld cmpFileInfo_1
  lhld sort_i
  call cmpFileInfo
  ora a
  jz l42
  ; 252 i++;
  lhld sort_i
  push h
  lxi d, 20
  dad d
  shld sort_i
  pop h
  jmp l41
l42:
  ; 253 while(0!=cmpFileInfo(j, x)) j--;
l43:
  lhld sort_j
  shld cmpFileInfo_1
  lhld sort_x
  call cmpFileInfo
  ora a
  jz l44
  ; 253 j--;
  lhld sort_j
  push h
  lxi d, 65516
  dad d
  shld sort_j
  pop h
  jmp l43
l44:
  ; 254 if(i <= j) {
  lhld sort_i
  xchg
  lhld sort_j
  call op_cmp16
  jc l45
  ; 255 memswap(i, j, sizeof(FileInfo));
  lhld sort_i
  shld memswap_1
  lhld sort_j
  shld memswap_2
  lxi h, 20
  call memswap
  ; 256 if(x==i) x=j; else if(x==j) x=i;
  lhld sort_x
  xchg
  lhld sort_i
  call op_cmp16
  jnz l46
  ; 256 x=j; else if(x==j) x=i;
  lhld sort_j
  shld sort_x
  jmp l47
l46:
  ; 256 if(x==j) x=i;
  lhld sort_x
  xchg
  lhld sort_j
  call op_cmp16
  jnz l48
  ; 256 x=i;
  lhld sort_i
  shld sort_x
l48:
l47:
  ; 257 i++; j--;   
  lhld sort_i
  push h
  lxi d, 20
  dad d
  shld sort_i
  pop h
  ; 257 j--;   
  lhld sort_j
  push h
  lxi d, 65516
  dad d
  shld sort_j
  pop h
l45:
  ; 259 if(j<=i) break;
  lhld sort_j
  xchg
  lhld sort_i
  call op_cmp16
  jnc l40
  jmp l39
l40:
  ; 261 if(i < high) {
  lhld sort_i
  xchg
  lhld sort_2
  call op_cmp16
  jc l50
  jz l50
  ; 262 if(low < j) if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
  lhld sort_1
  xchg
  lhld sort_j
  call op_cmp16
  jc l51
  jz l51
  ; 262 if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
  lda sort_stc
  cpi 32
  jz l52
  ; 262 *st = low, ++st, *st = j, ++st, ++stc;
  lhld sort_1
  xchg
  lhld sort_st
  mov m, e
  inx h
  mov m, d
  lhld sort_st
  inx h
  inx h
  shld sort_st
  lhld sort_j
  xchg
  lhld sort_st
  mov m, e
  inx h
  mov m, d
  lhld sort_st
  inx h
  inx h
  shld sort_st
  lxi h, sort_stc
  inr m
l52:
l51:
  ; 263 low = i; 
  lhld sort_i
  shld sort_1
  ; 264 continue;
  jmp l37
l50:
  ; 266 if(low < j) { 
  lhld sort_1
  xchg
  lhld sort_j
  call op_cmp16
  jc l53
  jz l53
  ; 267 high = j;
  lhld sort_j
  shld sort_2
  ; 268 continue; 
  jmp l37
l53:
  ; 270 if(stc==0) break;
  lda sort_stc
  ora a
  jz l38
  lxi h, sort_stc
  dcr m
  lhld sort_st
  dcx h
  dcx h
  shld sort_st
  mov e, m
  inx h
  mov d, m
  xchg
  shld sort_2
  lhld sort_st
  dcx h
  dcx h
  shld sort_st
  mov e, m
  inx h
  mov d, m
  xchg
  shld sort_1
  jmp l37
l38:
  ret
  ; --- prepareFileName -----------------------------------------------------------------
prepareFileName:
  shld prepareFileName_2
  ; 279 memset(buf, ' ', 11);    
  lhld prepareFileName_1
  shld memset_1
  mvi a, 32
  sta memset_2
  lxi h, 11
  call memset
  ; 280 i = 0; ni = 8;
  xra a
  sta prepareFileName_i
  ; 280 ni = 8;
  mvi a, 8
  sta prepareFileName_ni
  ; 281 while(1) {
l55:
  ; 282 c = *path; ++path;
  lhld prepareFileName_2
  mov a, m
  sta prepareFileName_c
  ; 282 ++path;
  inx h
  shld prepareFileName_2
  ; 283 if(c == 0) return;
  ora a
  jnz l57
  ; 283 return;
  ret
l57:
  ; 284 if(c == '.') { i = 8; ni = 11; continue; }                 
  lda prepareFileName_c
  cpi 46
  jnz l58
  ; 284 i = 8; ni = 11; continue; }                 
  mvi a, 8
  sta prepareFileName_i
  ; 284 ni = 11; continue; }                 
  mvi a, 11
  sta prepareFileName_ni
  ; 284 continue; }                 
  jmp l55
l58:
  ; 285 if(i == ni) continue;
  lxi h, prepareFileName_ni
  lda prepareFileName_i
  cmp m
  jz l55
  lda prepareFileName_c
  lhld prepareFileName_1
  mov m, a
  ; 286 ++buf;
  lhld prepareFileName_1
  inx h
  shld prepareFileName_1
  jmp l55
l56:
  ret
  ; --- getFiles -----------------------------------------------------------------
getFiles:
  lxi h, 0
  shld (panelA)+(263)
  ; 298 panelA.offset = 0;
  shld (panelA)+(5)
  ; 299 panelA.cursorX = 0;
  xra a
  sta (panelA)+(2)
  ; 300 panelA.cursorY = 0;
  sta (panelA)+(3)
  ; 302 f = panelA.files1;
  lhld panelA
  shld getFiles_f
  ; 303 if((panelA.path[0]!='/' || panelA.path[1]!=0)) {
  lda ((panelA)+(7))+(0)
  cpi 47
  jnz l61
  lda ((panelA)+(7))+(1)
  ora a
  jz l62
l61:
  mvi a, 1
  jmp l63
l62:
  xra a
l63:
  ; convertToConfition
  ora a
  jz l60
  ; 304 memcpy(f, parentDir, sizeof(FileInfo));
  lhld getFiles_f
  shld memcpy_1
  lxi h, parentDir
  shld memcpy_2
  lxi h, 20
  call memcpy
  ; 305 ++f;
  lhld getFiles_f
  lxi d, 20
  dad d
  shld getFiles_f
  ; 306 ++panelA.cnt;    
  lhld (panelA)+(263)
  inx h
  shld (panelA)+(263)
l60:
  ; 308 st = f;
  lhld getFiles_f
  shld getFiles_st
  ; 309 i = fs_findfirst(panelA.path, f, MAX_FILES-panelA.cnt);  
  lxi h, (panelA)+(7)
  shld fs_findfirst_1
  lhld getFiles_f
  shld fs_findfirst_2
  ; 16 битная арифметическая операция с константой
  lhld (panelA)+(263)
  mvi a, 102
  sub l
  mov l, a
  mvi a, 1
  sbb h
  mov h, a
  call fs_findfirst
  sta getFiles_i
  ; 310 if(i==ERR_MAX_FILES) i=0;
  cpi 10
  jnz l64
  ; 310 i=0;
  xra a
  sta getFiles_i
l64:
  ; 311 if(i==0) {
  ora a
  jnz l65
  ; 312 f += fs_low;
  lhld fs_low
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld getFiles_f
  dad d
  shld getFiles_f
  ; 313 panelA.cnt += fs_low;Сложение
  lhld fs_low
  xchg
  lhld (panelA)+(263)
  dad d
  shld (panelA)+(263)
  jmp l66
l65:
  ; 315 drawError("Џ®«гзҐ­ЁҐ бЇЁбЄ  д ©«®ў", i);
  lxi h, string3
  shld drawError_1
  lda getFiles_i
  call drawError
l66:
  ; 318 for(j=panelA.cnt, f=panelA.files1; j; --j, ++f) {
  lhld (panelA)+(263)
  shld getFiles_j
  lhld panelA
  shld getFiles_f
l67:
  ; convertToConfition
  lhld getFiles_j
  mov a, l
  ora h
  jz l68
  ; 319 if((f->fattrib & 0x10)==0)Сложение
  lhld getFiles_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jnz l70
  ; 320 for(i=12, n=f->fname; i; --i, ++n)
  mvi a, 12
  sta getFiles_i
  lhld getFiles_f
  shld getFiles_n
l71:
  ; convertToConfition
  lda getFiles_i
  ora a
  jz l72
  ; 321 if((uchar)*n>='A' && (uchar)*n<='Z')
  mov a, m
  cpi 65
  jc l74
  mov a, m
  cpi 90
  jz l75
  jnc l74
l75:
  ; 322 *n = *n-('A'-'a');Арифметика 9/3
  lhld getFiles_n
  mov a, m
  sui -32
  mov m, a
l74:
l73:
  lxi h, getFiles_i
  dcr m
  lhld getFiles_n
  inx h
  shld getFiles_n
  jmp l71
l72:
l70:
l69:
  lhld getFiles_j
  dcx h
  shld getFiles_j
  lhld getFiles_f
  lxi d, 20
  dad d
  shld getFiles_f
  jmp l67
l68:
  ; 325 if(panelA.cnt > 1)Сложение с константой -2
  lhld (panelA)+(263)
  dcx h
  dcx h
  jz l77
  jnc l76
l77:
  ; 326 sort(st, ((FileInfo*)panelA.files1) + (panelA.cnt-1));
  lhld getFiles_st
  shld sort_1
  ; Сложение с константой -1
  lhld (panelA)+(263)
  dcx h
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  call sort
l76:
  ret
  ; --- reloadFiles -----------------------------------------------------------------
reloadFiles:
  shld reloadFiles_1
  ; 333 graphOffset = panelGraphOffset;
  lhld panelGraphOffset
  shld graphOffset
  ; 334 drawPath_(1);   
  mvi a, 1
  call drawPath_
  ; 335 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ; 337 drawPathInCmdLine();
  call drawPathInCmdLine
  ; 339 getFiles();
  call getFiles
  ; 342 if(back)convertToConfition
  lhld reloadFiles_1
  mov a, l
  ora h
  jz l78
  ; 343 for(l=0, f=panelA.files1; l<panelA.cnt; ++l, ++f) {
  lxi h, 0
  shld reloadFiles_l
  lhld panelA
  shld reloadFiles_f
l79:
  lhld reloadFiles_l
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jc l80
  jz l80
  ; 344 if(0==memcmp(f->fname, back, 11)) {
  lhld reloadFiles_f
  shld memcmp_1
  lhld reloadFiles_1
  shld memcmp_2
  lxi h, 11
  call memcmp
  ora a
  jnz l82
  ; 346 if(l>=2*ROWS_CNT) {Сложение
  lhld reloadFiles_l
  lxi d, 65500
  dad d
  jnc l83
  ; 347 panelA.offset = l-ROWS_CNT-(l%ROWS_CNT);Сложение
  lhld reloadFiles_l
  lxi d, 65518
  dad d
  lxi d, 18
  push h
  lhld reloadFiles_l
  call op_mod16
  ; 16 битная арифметическая операция с константой
  xchg
  pop h
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld (panelA)+(5)
  ; 348 l-=panelA.offset;16 битная арифметическая операция с константой
  xchg
  lhld reloadFiles_l
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld reloadFiles_l
l83:
  ; 351 panelA.cursorX = l/ROWS_CNT;
  lxi d, 18
  lhld reloadFiles_l
  call op_div16
  mov a, l
  sta (panelA)+(2)
  ; 352 panelA.cursorY = op_div16_mod;
  lda op_div16_mod
  sta (panelA)+(3)
  ; 353 break;
  jmp l80
l82:
l81:
  lhld reloadFiles_l
  inx h
  shld reloadFiles_l
  lhld reloadFiles_f
  lxi d, 20
  dad d
  shld reloadFiles_f
  jmp l79
l80:
l78:
  ; 358 graphOffset = panelGraphOffset;
  lhld panelGraphOffset
  shld graphOffset
  ; 359 hideCursor_();
  call hideCursor_
  ; 360 drawFiles_();
  call drawFiles_
  ; 361 moveCursor_();
  call moveCursor_
  ; 362 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- dropPath -----------------------------------------------------------------
dropPath:
  lxi h, (panelA)+(7)
  call strlen
  shld dropPath_l
  ; Сложение
  lxi d, (panelA)+(7)
  dad d
  shld dropPath_p
l84:
  ; 373 if(*p=='/') { 
  mov a, m
  cpi 47
  jnz l87
  ; 374 prepareFileName(buf, p+1);
  lxi h, dropPath_buf
  shld prepareFileName_1
  ; Сложение с константой 1
  lhld dropPath_p
  inx h
  call prepareFileName
  ; 375 if(l==0) ++p;Сложение с константой 0
  lhld dropPath_l
  mov a, l
  ora h
  jnz l88
  ; 375 ++p;
  lhld dropPath_p
  inx h
  shld dropPath_p
l88:
  ; 376 *p=0;
  lhld dropPath_p
  mvi m, 0
  ; 377 break;
  jmp l85
l87:
  ; 379 if(l==0) return;Сложение с константой 0
  lhld dropPath_l
  mov a, l
  ora h
  jnz l89
  ; 379 return;
  ret
l89:
l86:
  lhld dropPath_l
  dcx h
  shld dropPath_l
  lhld dropPath_p
  dcx h
  shld dropPath_p
  jmp l84
l85:
  ; 382 reloadFiles(buf);
  lxi h, dropPath_buf
  jmp reloadFiles
addPath1:
  sta addPath1_1
  ; 427 if(panelA.cnt == 0) return 1;Сложение с константой 0
  lhld (panelA)+(263)
  mov a, l
  ora h
  jnz l90
  ; 427 return 1;
  mvi a, 1
  ret
l90:
  ; 430 f = panelA.files1 + (panelA.offset + panelA.cursorY + panelA.cursorX*ROWS_CNT);Сложение
  lhld (panelA)+(5)
  xchg
  lhld (panelA)+(3)
  mvi h, 0
  dad d
  push h
  mvi d, 18
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  pop d
  dad d
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  xchg
  lhld panelA
  dad d
  shld addPath1_f
  ; 431 s = f->fname;
  shld addPath1_s
  ; 439 if(s[0] == '.') { Сложение с константой 0
  mov a, m
  cpi 46
  jnz l91
  ; 440 if(mode != A_ENTER) return 1;
  lda addPath1_1
  ora a
  jz l92
  ; 440 return 1;
  mvi a, 1
  ret
l92:
  ; 441 dropPath(); 
  call dropPath
  ; 442 return 0; 
  xra a
  ret
l91:
  ; 446 normalizeFileName(buf, s);
  lxi h, addPath1_buf
  shld normalizeFileName_1
  lhld addPath1_s
  call normalizeFileName
  ; 449 o = strlen(panelA.path);
  lxi h, (panelA)+(7)
  call strlen
  shld addPath1_o
  ; 452 d = panelA.path + o;Сложение
  lxi d, (panelA)+(7)
  dad d
  shld addPath1_d
  ; 453 if(o != 1) {Сложение с константой -1
  lhld addPath1_o
  dcx h
  mov a, l
  ora h
  jz l93
  ; 454 if(o + strlen(buf) >= 254) return 1; // Слишком длинный путь
  lxi h, addPath1_buf
  call strlen
  ; Сложение
  lhld addPath1_o
  mov d, h
  mov e, l
  dad d
  ; Сложение
  lxi d, 65282
  dad d
  jnc l94
  ; 454 return 1; // Слишком длинный путь
  mvi a, 1
  ret
l94:
  ; 455 *d = '/'; ++d;
  lhld addPath1_d
  mvi m, 47
  ; 455 ++d;
  inx h
  shld addPath1_d
l93:
  ; 457 strcpy(d, buf);    
  lhld addPath1_d
  shld strcpy_1
  lxi h, addPath1_buf
  call strcpy
  ; 460 if(mode == A_ENTER) {
  lda addPath1_1
  ora a
  jnz l95
  ; 461 if(f->fattrib & 0x10) { Сложение
  lhld addPath1_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l96
  ; 462 reloadFiles(0);
  lxi h, 0
  call reloadFiles
  ; 463 return 0;
  xra a
  ret
l96:
l95:
  ; 468 strcpy(cmdline, panelA.path);
  lxi h, cmdline
  shld strcpy_1
  lxi h, (panelA)+(7)
  call strcpy
  ; 469 cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  call strlen
  shld cmdline_pos
  ; 470 panelA.path[o] = 0;Сложение
  lhld addPath1_o
  lxi d, (panelA)+(7)
  dad d
  mvi m, 0
  ; 473 absolutePath();
  call absolutePath
  ; 476 if(mode == A_ENTER) {
  lda addPath1_1
  ora a
  jnz l97
  ; 477 cmd_run2(cmdline, "");
  lxi h, cmdline
  shld cmd_run2_1
  lxi h, string0
  call cmd_run2
  ; 478 clearCmdLine();
  call clearCmdLine
l97:
  ; 481 return 0;
  xra a
  ret
  ; --- drawAll_ -----------------------------------------------------------------
drawAll_:
  call graph1
  ; 486 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 487 rect1(RECTARGS(6,3,186,45+ROWS_CNT*10));
  lxi h, 36867
  shld rect1_1
  lxi h, 23
  shld rect1_2
  mvi a, 2
  sta rect1_3
  mvi a, 16
  sta rect1_4
  mvi a, 3
  sta rect1_5
  mvi a, 224
  sta rect1_6
  dcr a
  call rect1
  ; 488 rect1(RECTARGS(8,5,184,43+ROWS_CNT*10));
  lxi h, 37125
  shld rect1_1
  lxi h, 22
  shld rect1_2
  mvi a, 128
  sta rect1_3
  mvi a, 64
  sta rect1_4
  mvi a, 255
  sta rect1_5
  mvi a, 128
  sta rect1_6
  mvi a, 219
  call rect1
  ; 489 fillRect1(FILLRECTARGS(96,6,96,24+ROWS_CNT*10));
  lxi h, 39942
  shld fillRect1_1
  lxi h, 0
  shld fillRect1_2
  mvi a, 255
  sta fillRect1_3
  mvi a, 128
  sta fillRect1_4
  mvi a, 199
  call fillRect1
  ; 490 fillRect1(FILLRECTARGS(9,25+ROWS_CNT*10,184,25+ROWS_CNT*10));
  lxi h, 37325
  shld fillRect1_1
  lxi h, 22
  shld fillRect1_2
  mvi a, 127
  sta fillRect1_3
  cma
  sta fillRect1_4
  mvi a, 1
  call fillRect1
  ; 491 setColor(COLOR_YELLOW);
  mvi a, 16
  call setColor
  ; 492 graph0();
  call graph0
  ; 493 print1(TEXTCOORDS(7,1), 0, 4, "Name");
  lxi h, 38155
  shld print1_1
  xra a
  sta print1_2
  mvi a, 4
  sta print1_3
  lxi h, string4
  call print1
  ; 494 print1(TEXTCOORDS(22,1), 0, 4, "Name");
  lxi h, 40971
  shld print1_1
  xra a
  sta print1_2
  mvi a, 4
  sta print1_3
  lxi h, string4
  call print1
  ; 495 setColor(COLOR_WHITE);
  xra a
  jmp setColor
drawHelp:
  call graph0
  ; 503 setColor(COLOR_WHITE);
  xra a
  call setColor
  ; 505 print1(TEXTCOORDS(1, 24), 3, 64, "1FREE   2NEW    3VIEW   4EDIT   5COPY   6REN    7DIR    8DEL"); 
  lxi h, 37105
  shld print1_1
  mvi a, 3
  sta print1_2
  mvi a, 64
  sta print1_3
  lxi h, string5
  call print1
  ; 507 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 508 graphXor();
  call graphXor
  ; 509 for(i=0, d = TEXTCOORDS(2, 24)-1; i<8; i++, d+=0x600)
  xra a
  sta drawHelp_i
  lxi h, 37360
  shld drawHelp_d
l98:
  lda drawHelp_i
  cpi 8
  jnc l99
  ; 510 fillRect1(d, 3, 255, 255, 10);
  shld fillRect1_1
  lxi h, 3
  shld fillRect1_2
  mvi a, 255
  sta fillRect1_3
  sta fillRect1_4
  mvi a, 10
  call fillRect1
l100:
  lxi h, drawHelp_i
  mov a, m
  inr m
  ; Сложение
  lxi d, 1536
  lhld drawHelp_d
  dad d
  shld drawHelp_d
  jmp l98
l99:
  ret
  ; --- dupPanel -----------------------------------------------------------------
dupPanel:
  lhld panelA
  shld memcpy_1
  lhld panelB
  shld memcpy_2
  lhld (panelB)+(263)
  lxi d, 20
  call op_mul16
  call memcpy
  ; 515 panelA.cnt = panelB.cnt; 
  lhld (panelB)+(263)
  shld (panelA)+(263)
  ret
  ; --- drawFiles2_go -----------------------------------------------------------------
drawFiles2_go:
  lhld panelGraphOffset
  shld graphOffset
  ; 519 hideCursor_(); drawFiles_(); moveCursor_();
  call hideCursor_
  ; 519 drawFiles_(); moveCursor_();
  call drawFiles_
  ; 519 moveCursor_();
  call moveCursor_
  ; 520 swapPanels();
  call swapPanels
  ; 521 graphOffset = panelGraphOffset; drawFiles_(); drawFileInfo_();
  lhld panelGraphOffset
  shld graphOffset
  ; 521 drawFiles_(); drawFileInfo_();
  call drawFiles_
  ; 521 drawFileInfo_();
  call drawFileInfo_
  ; 522 swapPanels();
  call swapPanels
  ; 523 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- repairScreen -----------------------------------------------------------------
repairScreen:
  sta repairScreen_1
  ; 527 graph0();
  call graph0
  ; 530 clrscr10(PIXELCOORDS(0,23), 48, 23);
  lxi h, 37095
  shld clrscr10_1
  mvi a, 48
  sta clrscr10_2
  mvi a, 23
  call clrscr10
  ; 536 cmdline[0] = 0;
  xra a
  sta (cmdline)+(0)
  ; 537 cmdline_pos = 0;
  lxi h, 0
  shld cmdline_pos
  ; 538 drawPathInCmdLine();
  call drawPathInCmdLine
  ; 541 graphOffset = 0;      drawAll_();
  lxi h, 0
  shld graphOffset
  ; 541 drawAll_();
  call drawAll_
  ; 542 graphOffset = 0x1700; drawAll_();
  lxi h, 5888
  shld graphOffset
  ; 542 drawAll_();
  call drawAll_
  ; 545 graphOffset = panelGraphOffset; drawPath_(1);
  lhld panelGraphOffset
  shld graphOffset
  ; 545 drawPath_(1);
  mvi a, 1
  call drawPath_
  ; 546 swapPanels();
  call swapPanels
  ; 547 graphOffset = panelGraphOffset; drawPath_(0);
  lhld panelGraphOffset
  shld graphOffset
  ; 547 drawPath_(0);
  xra a
  call drawPath_
  ; 548 swapPanels();
  call swapPanels
  ; 551 cursorX1 = 0;
  lxi h, 0
  shld cursorX1
  ; 554 if(!dontDrawFiles) drawFiles2_go();convertToConfition
  lda repairScreen_1
  ora a
  cz drawFiles2_go
  lxi h, 0
  shld graphOffset
  ret
  ; --- cursor_left -----------------------------------------------------------------
cursor_left:
  lhld panelGraphOffset
  shld graphOffset
  ; 562 if(panelA.cursorX) { convertToConfition
  lda (panelA)+(2)
  ora a
  jz l102
  ; 563 --panelA.cursorX; 
  lxi h, (panelA)+(2)
  dcr m
  jmp l103
l102:
  ; 565 if(panelA.offset) { convertToConfition
  lhld (panelA)+(5)
  mov a, l
  ora h
  jz l104
  ; 566 if(ROWS_CNT > panelA.offset) { Сложение
  lxi d, 65518
  dad d
  jc l105
  jz l105
  ; 567 panelA.offset = 0; 
  lxi h, 0
  shld (panelA)+(5)
  ; 568 hideCursor_();
  call hideCursor_
  ; 569 drawFiles_();
  call drawFiles_
  jmp l106
l105:
  ; 571 panelA.offset -= ROWS_CNT; 16 битная арифметическая операция с константой
  lhld (panelA)+(5)
  mov a, l
  sui 18
  mov l, a
  mov a, h
  sbi 0
  mov h, a
  shld (panelA)+(5)
  ; 572 hideCursor_();
  call hideCursor_
  ; 573 scroll((char*)0x9D14, (char*)0x9214, 10, ROWS_CNT*10);
  lxi h, 40212
  shld scroll_1
  mvi h, 146
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 180
  call scroll
  ; 574 drawColumn_(0);
  xra a
  call drawColumn_
l106:
  jmp l107
l104:
  ; 577 if(panelA.cursorY) {convertToConfition
  lda (panelA)+(3)
  ora a
  jz l108
  ; 578 panelA.cursorY = 0; 
  xra a
  sta (panelA)+(3)
l108:
l107:
l103:
  ; 581 moveCursor_();
  call moveCursor_
  ; 583 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- cursor_right -----------------------------------------------------------------
cursor_right:
  lhld panelGraphOffset
  shld graphOffset
  ; 592 w = panelA.offset + panelA.cursorY + panelA.cursorX*22;Сложение
  lhld (panelA)+(5)
  xchg
  lhld (panelA)+(3)
  mvi h, 0
  dad d
  push h
  mvi d, 22
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  pop d
  dad d
  shld cursor_right_w
  ; 593 if(w + ROWS_CNT >= panelA.cnt) { //! перепутаны > и >=Сложение
  lxi d, 18
  dad d
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jz l110
  jnc l109
l110:
  ; 595 if(w + 1 >= panelA.cnt) { Сложение с константой 1
  lhld cursor_right_w
  inx h
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jz l112
  jnc l111
l112:
  ; 596 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ; 597 return;
  ret
l111:
  ; 600 panelA.cursorY = panelA.cnt - (panelA.offset + panelA.cursorX*ROWS_CNT + 1);
  mvi d, 18
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(5)
  dad d
  ; Сложение с константой 1
  inx h
  ; 16 битная арифметическая операция с константой
  xchg
  lhld (panelA)+(263)
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  mov a, l
  sta (panelA)+(3)
  ; 602 if(panelA.cursorY>ROWS_CNT-1) {
  cpi 17
  jc l113
  jz l113
  ; 603 panelA.cursorY -= ROWS_CNT;Арифметика 4/3
  sui 18
  sta (panelA)+(3)
  ; 604 if(panelA.cursorX == 1) { 
  lda (panelA)+(2)
  cpi 1
  jnz l114
  ; 605 panelA.offset += ROWS_CNT;Сложение
  lxi d, 18
  lhld (panelA)+(5)
  dad d
  shld (panelA)+(5)
  ; 606 hideCursor_();
  call hideCursor_
  ; 607 drawFiles_();
  call drawFiles_
  jmp l115
l114:
  ; 609 panelA.cursorX++; 
  lxi h, (panelA)+(2)
  inr m
l115:
l113:
  jmp l116
l109:
  ; 613 if(panelA.cursorX == 1) { 
  lda (panelA)+(2)
  cpi 1
  jnz l117
  ; 614 panelA.offset += ROWS_CNT;Сложение
  lxi d, 18
  lhld (panelA)+(5)
  dad d
  shld (panelA)+(5)
  ; 615 hideCursor_();
  call hideCursor_
  ; 616 scroll((char*)0x9214, (char*)0x9D14, 10, ROWS_CNT*10);
  lxi h, 37396
  shld scroll_1
  mvi h, 157
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 180
  call scroll
  ; 617 drawColumn_(1);
  mvi a, 1
  call drawColumn_
  jmp l118
l117:
  ; 619 panelA.cursorX++;
  lxi h, (panelA)+(2)
  inr m
l118:
l116:
  ; 622 moveCursor_();
  call moveCursor_
  ; 624 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- cursor_up -----------------------------------------------------------------
cursor_up:
  lhld panelGraphOffset
  shld graphOffset
  ; 630 if(panelA.cursorY) { convertToConfition
  lda (panelA)+(3)
  ora a
  jz l119
  ; 631 --panelA.cursorY;
  lxi h, (panelA)+(3)
  dcr m
  jmp l120
l119:
  ; 633 if(panelA.cursorX) { convertToConfition
  lda (panelA)+(2)
  ora a
  jz l121
  ; 634 --panelA.cursorX;
  lxi h, (panelA)+(2)
  dcr m
  ; 635 panelA.cursorY = ROWS_CNT-1; 
  mvi a, 17
  sta (panelA)+(3)
  jmp l122
l121:
  ; 637 if(panelA.offset) {convertToConfition
  lhld (panelA)+(5)
  mov a, l
  ora h
  jz l123
  ; 638 --panelA.offset; 
  dcx h
  shld (panelA)+(5)
  ; 639 hideCursor_();
  call hideCursor_
  ; 640 scroll((char*)(0x9214+10), (char*)0x9214, 10, (ROWS_CNT-1)*10);
  lxi h, 37406
  shld scroll_1
  mvi l, 20
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 170
  call scroll
  ; 641 scroll((char*)(0x9D14+10), (char*)0x9D14, 10, (ROWS_CNT-1)*10);
  lxi h, 40222
  shld scroll_1
  mvi l, 20
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 170
  call scroll
  ; 642 drawFile(0, 0);
  xra a
  sta drawFile_1
  call drawFile
  ; 643 drawFile(1, 0);
  mvi a, 1
  sta drawFile_1
  xra a
  call drawFile
l123:
l122:
l120:
  ; 646 moveCursor_();
  call moveCursor_
  ; 648 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- cursor_down -----------------------------------------------------------------
cursor_down:
  mvi d, 18
  lda (panelA)+(2)
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(5)
  dad d
  ; Сложение
  xchg
  lhld (panelA)+(3)
  mvi h, 0
  dad d
  ; Сложение с константой 1
  inx h
  xchg
  lhld (panelA)+(263)
  call op_cmp16
  jz l125
  jnc l124
l125:
  ; 652 return;
  ret
l124:
  ; 654 graphOffset = panelGraphOffset;
  lhld panelGraphOffset
  shld graphOffset
  ; 656 if(panelA.cursorY < ROWS_CNT-1) {
  lda (panelA)+(3)
  cpi 17
  jnc l126
  ; 657 ++panelA.cursorY;
  lxi h, (panelA)+(3)
  inr m
  jmp l127
l126:
  ; 659 if(panelA.cursorX == 0) {
  lda (panelA)+(2)
  ora a
  jnz l128
  ; 660 panelA.cursorY = 0;
  xra a
  sta (panelA)+(3)
  ; 661 ++panelA.cursorX; 
  lxi h, (panelA)+(2)
  inr m
  jmp l129
l128:
  ; 663 ++panelA.offset; 
  lhld (panelA)+(5)
  inx h
  shld (panelA)+(5)
  ; 664 hideCursor_();
  call hideCursor_
  ; 665 scroll((char*)0x9214, (char*)(0x9214+10), 10, (ROWS_CNT-1)*10);
  lxi h, 37396
  shld scroll_1
  mvi l, 30
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 170
  call scroll
  ; 666 scroll((char*)0x9D14, (char*)(0x9D14+10), 10, (ROWS_CNT-1)*10);
  lxi h, 40212
  shld scroll_1
  mvi l, 30
  shld scroll_2
  mvi a, 10
  sta scroll_3
  mvi a, 170
  call scroll
  ; 667 drawFile(0, ROWS_CNT-1);
  xra a
  sta drawFile_1
  mvi a, 17
  call drawFile
  ; 668 drawFile(1, ROWS_CNT-1);
  mvi a, 1
  sta drawFile_1
  mvi a, 17
  call drawFile
l129:
l127:
  ; 671 moveCursor_();
  call moveCursor_
  ; 673 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ret
  ; --- cmd_tab -----------------------------------------------------------------
cmd_tab:
  lhld panelGraphOffset
  shld graphOffset
  ; 678 hideCursor_();
  call hideCursor_
  ; 679 drawPath_(0);
  xra a
  call drawPath_
  ; 680 swapPanels();
  call swapPanels
  ; 681 graphOffset = panelGraphOffset; 
  lhld panelGraphOffset
  shld graphOffset
  ; 682 moveCursor_();
  call moveCursor_
  ; 683 drawPath_(1);
  mvi a, 1
  call drawPath_
  ; 684 graphOffset = 0; 
  lxi h, 0
  shld graphOffset
  ; 685 drawPathInCmdLine();
  jmp drawPathInCmdLine
cmd_char:
  sta cmd_char_1
  ; 689 if(cmdline_pos == 255) return; Сложение
  lhld cmdline_pos
  lxi d, 65281
  dad d
  mov a, l
  ora h
  jnz l130
  ; 689 return; 
  ret
l130:
  ; 690 cmdline[cmdline_pos] = c;Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  lda cmd_char_1
  mov m, a
  ; 691 ++cmdline_pos;
  lhld cmdline_pos
  inx h
  shld cmdline_pos
  ; 692 drawCmdLine();
  jmp drawCmdLine
cmd_bkspc:
  lhld cmdline_pos
  mov a, l
  ora h
  jnz l131
  ; 696 return;
  ret
l131:
  ; 697 --cmdline_pos;    
  dcx h
  shld cmdline_pos
  ; 698 drawCmdLine();
  jmp drawCmdLine
alt:
  lhld cmdline_pos
  mov a, l
  ora h
  jnz l132
  ; 702 return 0;
  xra a
  ret
l132:
  ; 703 return shiftPressed();
  jmp shiftPressed
  ret
  ; --- main -----------------------------------------------------------------
main:
  call fs_init
  ; 713 setColorAutoDisable();
  call setColorAutoDisable
  ; 715 panelA.files1 = (FileInfo*)START_FILE_BUFFER;
  lxi h, 16384
  shld panelA
  ; 716 panelB.files1 = ((FileInfo*)START_FILE_BUFFER)+MAX_FILES;
  lxi h, 23544
  shld panelB
  ; 718 clrscr();
  call clrscr
  ; 724 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ; 725 cursorX1=0;
  shld cursorX1
  ; 728 strcpy(panelA.path, "/");
  lxi h, (panelA)+(7)
  shld strcpy_1
  lxi h, string6
  call strcpy
  ; 729 strcpy(panelB.path, "/");
  lxi h, (panelB)+(7)
  shld strcpy_1
  lxi h, string6
  call strcpy
  ; 730 drawHelp();           
  call drawHelp
  ; 731 repairScreen(0);
  xra a
  call repairScreen
  ; 734 getFiles();
  call getFiles
  ; 735 memcpy(panelB.files1, panelA.files1, panelA.cnt*sizeof(*panelA.files1));
  lhld panelB
  shld memcpy_1
  lhld panelA
  shld memcpy_2
  lhld (panelA)+(263)
  lxi d, 20
  call op_mul16
  call memcpy
  ; 736 panelB.cnt = panelA.cnt;
  lhld (panelA)+(263)
  shld (panelB)+(263)
  ; 739 drawFiles2_go();
  call drawFiles2_go
  ; 741 while(1) {
l133:
  ; 742 c = getch1();
  call getch1
  sta main_c
  ; 743 switch(c) {
  cpi 8
  jz l136
  cpi 49
  jz l137
  cpi 243
  jz l139
  cpi 50
  jz l140
  cpi 244
  jz l142
  cpi 51
  jz l143
  cpi 245
  jz l145
  cpi 52
  jz l146
  cpi 246
  jz l148
  cpi 53
  jz l151
  cpi 247
  jz l153
  cpi 54
  jz l154
  cpi 248
  jz l156
  cpi 55
  jz l157
  cpi 249
  jz l159
  cpi 56
  jz l160
  cpi 250
  jz l162
  cpi 13
  jz l163
  cpi 27
  jz l166
  cpi 25
  jz l169
  cpi 24
  jz l170
  cpi 26
  jz l171
  cpi 23
  jz l172
  cpi 9
  jz l173
  jmp l135
l136:
  ; 744 cmd_bkspc(); continue;
  call cmd_bkspc
  ; 744 continue;
  jmp l133
l137:
  ; 745 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l139:
  ; 746 cmd_freespace(); continue;
  call cmd_freespace
  ; 746 continue;
  jmp l133
l140:
  ; 747 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l142:
  ; 748 cmd_new(0); continue;
  xra a
  call cmd_new
  ; 748 continue;
  jmp l133
l143:
  ; 749 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l145:
  ; 750 cmd_run("view.rks", 1); continue;
  lxi h, string7
  shld cmd_run_1
  mvi a, 1
  call cmd_run
  ; 750 continue;
  jmp l133
l146:
  ; 751 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l148:
  ; 752 if(shiftPressed()) cmd_new(0); else cmd_run("edit.rks", 1); continue;
  call shiftPressed
  ; convertToConfition
  ora a
  jz l149
  ; 752 cmd_new(0); else cmd_run("edit.rks", 1); continue;
  xra a
  call cmd_new
  jmp l150
l149:
  ; 752 cmd_run("edit.rks", 1); continue;
  lxi h, string8
  shld cmd_run_1
  mvi a, 1
  call cmd_run
l150:
  ; 752 continue;
  jmp l133
l151:
  ; 753 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l153:
  ; 754 cmd_copymove(1); continue;
  mvi a, 1
  call cmd_copymove
  ; 754 continue;
  jmp l133
l154:
  ; 755 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l156:
  ; 756 cmd_copymove(0); continue;
  xra a
  call cmd_copymove
  ; 756 continue;
  jmp l133
l157:
  ; 757 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l159:
  ; 758 cmd_new(1); continue;
  mvi a, 1
  call cmd_new
  ; 758 continue;
  jmp l133
l160:
  ; 759 if(!alt()) break;      
  call alt
  ; convertToConfition
  ora a
  jz l135
l162:
  ; 760 cmd_delete(); continue;
  call cmd_delete
  ; 760 continue;
  jmp l133
l163:
  ; 761 if(cmdline_pos) cmd_run(0, 0); else addPath1(A_ENTER); continue;convertToConfition
  lhld cmdline_pos
  mov a, l
  ora h
  jz l164
  ; 761 cmd_run(0, 0); else addPath1(A_ENTER); continue;
  lxi h, 0
  shld cmd_run_1
  xra a
  call cmd_run
  jmp l165
l164:
  ; 761 addPath1(A_ENTER); continue;
  xra a
  call addPath1
l165:
  ; 761 continue;
  jmp l133
l166:
  ; 762 if(cmdline_pos) clearCmdLine(); else dropPath(); continue;convertToConfition
  lhld cmdline_pos
  mov a, l
  ora h
  jz l167
  ; 762 clearCmdLine(); else dropPath(); continue;
  call clearCmdLine
  jmp l168
l167:
  ; 762 dropPath(); continue;
  call dropPath
l168:
  ; 762 continue;
  jmp l133
l169:
  ; 763 cursor_left(); continue;
  call cursor_left
  ; 763 continue;
  jmp l133
l170:
  ; 764 cursor_right(); continue; 
  call cursor_right
  ; 764 continue; 
  jmp l133
l171:
  ; 765 cursor_down(); continue;
  call cursor_down
  ; 765 continue;
  jmp l133
l172:
  ; 766 cursor_up(); continue; 
  call cursor_up
  ; 766 continue; 
  jmp l133
l173:
  ; 767 cmd_tab();  continue; 
  call cmd_tab
  ; 767 continue; 
  jmp l133
l135:
  ; 770 cmd_char(c);
  lda main_c
  call cmd_char
  jmp l133
l134:
  ret
  ; --- graphXor -----------------------------------------------------------------
graphXor:
    lxi h, 0FEh ; CPI
    mvi a, 0AAh
    jmp graph1_l1
  
  ret
  ; --- graph0 -----------------------------------------------------------------
graph0:
    lxi h, 0E6h ; ANI
    mvi a, 0A2h
    sta fillRect1_int_cmd
    mvi a, 02Fh
    jmp graph1_l2
  
  ret
  ; --- graph1 -----------------------------------------------------------------
graph1:
    lxi h, 02FE6h ; ORI !
    mvi a, 0B2h
graph1_l1:
    sta fillRect1_int_cmd
    xra a
graph1_l2:
    sta fillRect1_int_cmd2
    mov a, l
    sta print_mode1
    sta print_mode2
    sta print_mode3
    sta print_mode4
    sta print_mode5
    sta print_mode6
    mov a, h
    sta print_mode1A
    sta print_mode2A
    sta print_mode3A
    sta print_mode4A
    sta print_mode5A
  
  ret
  ; --- clrscr10 -----------------------------------------------------------------
clrscr10:
  sta clrscr10_3
  ; 49 asm {
    push b
    lxi  h, 0
    dad  sp     
    shld clrscr10_saveHl+1
    lda  clrscr10_2
    mov  c, a
    lda  clrscr10_3
    lhld clrscr10_1        
    dcx  h
    lxi  d, 0
clrscr10_l2:
    sphl
    mov  b, a
clrscr10_l1:
    push d         ; 10
    push d         ; 10
    push d         ; 10
    push d         ; 10
    push d         ; 10
    dcr b
    jnz clrscr10_l1 ; 10 = 15   
    inr h
    dcr c
    jnz clrscr10_l2
clrscr10_saveHl:
    lxi h, 0
    sphl
    pop b
  
  ret
  ; --- fillRect1_int -----------------------------------------------------------------
fillRect1_int:
  shld fillRect1_int_3
  ; 82 asm {
    lda fillRect1_int_2
fillRect1_int_cmd2:
    nop          ; CMA = 2F NOP = 00
    mov d, a
    lda fillRect1_int_1
    mov e, a
fillRect1_int_l0:
    mov a, m
fillRect1_int_cmd:
    ora d        ; XRA D = AA, ANA D = A2, ORA D = B2
    mov m, a
    inx h
    dcr e
    jnz fillRect1_int_l0
  
  ret
  ; --- fillRect1 -----------------------------------------------------------------
fillRect1:
  sta fillRect1_5
  ; 101 a += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld fillRect1_1
  dad d
  shld fillRect1_1
  ; 102 if(c==0) {Сложение с константой 0
  lhld fillRect1_2
  mov a, l
  ora h
  jnz l174
  ; 103 fillRect1_int(h, l & r, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lxi h, fillRect1_4
  lda fillRect1_3
  ana m
  sta fillRect1_int_2
  lhld fillRect1_1
  jmp fillRect1_int
  ; 104 return;
l174:
  ; 106 --c;  
  lhld fillRect1_2
  dcx h
  shld fillRect1_2
  ; 107 fillRect1_int(h, l, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lda fillRect1_3
  sta fillRect1_int_2
  lhld fillRect1_1
  call fillRect1_int
  ; 108 a += 0x100;Сложение
  lxi d, 256
  lhld fillRect1_1
  dad d
  shld fillRect1_1
  ; 109 for(; c; --c) {  
l175:
  ; convertToConfition
  lhld fillRect1_2
  mov a, l
  ora h
  jz l176
  ; 110 fillRect1_int(h, 0xFF, a);
  lda fillRect1_5
  sta fillRect1_int_1
  mvi a, 255
  sta fillRect1_int_2
  lhld fillRect1_1
  call fillRect1_int
  ; 111 a += 0x100;Сложение
  lxi d, 256
  lhld fillRect1_1
  dad d
  shld fillRect1_1
l177:
  lhld fillRect1_2
  dcx h
  shld fillRect1_2
  jmp l175
l176:
  ; 113 fillRect1_int(h, r, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lda fillRect1_4
  sta fillRect1_int_2
  lhld fillRect1_1
  jmp fillRect1_int
fillRect:
  sta fillRect_4
  ; 117 fillRect1(HORZALINEARGS(x0, y0, x1), y1-y0+1);
  lxi d, 8
  lhld fillRect_1
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  xchg
  lhld fillRect_2
  mvi h, 0
  dad d
  ; Сложение
  lxi d, 36864
  dad d
  shld fillRect1_1
  ; Сложение с константой 1
  lhld fillRect_3
  inx h
  lxi d, 8
  call op_div16
  lxi d, 8
  push h
  lhld fillRect_1
  call op_div16
  ; 16 битная арифметическая операция с константой
  xchg
  pop h
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld fillRect1_2
  lda fillRect_1
  ani 7
  mov d, a
  mvi a, 255
  call op_shr
  sta fillRect1_3
  ; Сложение с константой 1
  lhld fillRect_3
  inx h
  mov a, l
  ani 7
  mov d, a
  mvi a, 255
  call op_shr
  xri 255
  sta fillRect1_4
  ; Арифметика 4/4
  lxi h, fillRect_2
  lda fillRect_4
  sub m
  inr a
  jmp fillRect1
print_p1:
    XCHG
    LHLD print_p1_1
    PUSH B
    MVI C, 8
print1_l:
    LDAX D
print_mode1A:
    NOP
    ADD A
    ADD A
    MOV B, A
    MOV A, M
print_mode1:
    ANI 3
    XRA B
    MOV M, A

    INX D
    INX H
    DCR C
    JNZ print1_l
    POP B
  
  ret
  ; --- print_p2 -----------------------------------------------------------------
print_p2:
    XCHG
    LHLD print_p2_1
    PUSH B
    MVI C, 8
print2_l:
    LDAX D    
print_mode2A:
    NOP
    ADD A
    ADC A
    ADC A
    ADC A
    PUSH PSW
    ADC A
    ANI 00000011b
    MOV B, A
    MOV A, M
print_mode2:
    ANI 0FCh
    XRA B
    MOV M, A

    INR H

    POP PSW
    ANI 011110000b
    MOV B, A
    MOV A, M
print_mode3:
    ANI 00Fh
    XRA B
    MOV M, A

    DCR H

    INX D
    INX H
    DCR C
    JNZ print2_l

    POP B
  
  ret
  ; --- print_p3 -----------------------------------------------------------------
print_p3:
    XCHG
    LHLD print_p3_1
    PUSH B
    MVI C, 8
print3_l:
    LDAX D    
print_mode3A:
    NOP
    RAR
    RAR
    ANI 00001111b
    MOV B, A
    MOV A, M
print_mode4:
    ANI 0F0h
    XRA B
    MOV M, A

    INR H

    LDAX D    
print_mode4A:
    NOP
    RAR
    RAR
    RAR
    ANI 11000000b
    MOV B, A
    MOV A, M
print_mode5:
    ANI 03Fh
    XRA B
    MOV M, A

    DCR H

    INX D
    INX H
    DCR C
    JNZ print3_l

    POP B
  
  ret
  ; --- print_p4 -----------------------------------------------------------------
print_p4:
    XCHG
    LHLD print_p4_1
    PUSH B
    MVI C, 8
print4_l:
    LDAX D    
print_mode5A:
    NOP
    ANI 03Fh
    MOV B, A
    MOV A, M
print_mode6:
    ANI 0C0h
    XRA B
    MOV M, A
    INX D
    INX H
    DCR C
    JNZ print4_l
    POP B
  
  ret
  ; --- print1 -----------------------------------------------------------------
print1:
  shld print1_4
  ; 270 d += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld print1_1
  dad d
  shld print1_1
  ; 271 e = n&0x80; n&=0x7F;
  lda print1_3
  ani 128
  sta print1_e
  ; 271 n&=0x7F;
  lda print1_3
  ani 127
  sta print1_3
  ; 272 while(1) { 
l178:
  ; 273 if(n == 0) return;     
  lda print1_3
  ora a
  jnz l180
  ; 273 return;     
  ret
l180:
  ; 274 c = *text;
  lhld print1_4
  mov a, m
  sta print1_c
  ; 275 if(c) ++text; else if(!e) return;convertToConfition
  ora a
  jz l181
  ; 275 ++text; else if(!e) return;
  inx h
  shld print1_4
  jmp l182
l181:
  ; 275 if(!e) return;convertToConfition
  lda print1_e
  ora a
  jnz l183
  ; 275 return;
  ret
l183:
l182:
  ; 276 s = chargen + c*8;
  lhld print1_c
  mvi h, 0
  ; Умножение HL на 8
  dad h
  dad h
  dad h
  ; Сложение
  lxi d, chargen
  dad d
  shld print1_s
  ; 277 switch(st) {
  lda print1_2
  ora a
  jz l185
  cpi 1
  jz l186
  cpi 2
  jz l187
  cpi 3
  jz l188
  jmp l184
l185:
  ; 278 print_p1(d, s); ++st; break;
  lhld print1_1
  shld print_p1_1
  lhld print1_s
  call print_p1
  ; 278 ++st; break;
  lxi h, print1_2
  inr m
  ; 278 break;
  jmp l184
l186:
  ; 279 print_p2(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p2_1
  lhld print1_s
  call print_p2
  ; 279 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 279 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 279 break;
  jmp l184
l187:
  ; 280 print_p3(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p3_1
  lhld print1_s
  call print_p3
  ; 280 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 280 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 280 break;
  jmp l184
l188:
  ; 281 print_p4(d, s); st=0; d += 0x100; break;
  lhld print1_1
  shld print_p4_1
  lhld print1_s
  call print_p4
  ; 281 st=0; d += 0x100; break;
  xra a
  sta print1_2
  ; 281 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 281 break;
l184:
  ; 283 --n;
  lxi h, print1_3
  dcr m
  jmp l178
l179:
  ret
  ; --- rect1 -----------------------------------------------------------------
rect1:
  sta rect1_7
  ; 288 fillRect1(a, c, l, r, 1);
  lhld rect1_1
  shld fillRect1_1
  lhld rect1_2
  shld fillRect1_2
  lda rect1_5
  sta fillRect1_3
  lda rect1_6
  sta fillRect1_4
  mvi a, 1
  call fillRect1
  ; 289 fillRect1(a, 0, ll, ll, h);
  lhld rect1_1
  shld fillRect1_1
  lxi h, 0
  shld fillRect1_2
  lda rect1_3
  sta fillRect1_3
  lda rect1_3
  sta fillRect1_4
  lda rect1_7
  call fillRect1
  ; 290 fillRect1(a+c*256, 0, rr, rr, h);
  lhld rect1_2
  lxi d, 256
  call op_mul16
  ; Сложение
  xchg
  lhld rect1_1
  dad d
  shld fillRect1_1
  lxi h, 0
  shld fillRect1_2
  lda rect1_4
  sta fillRect1_3
  lda rect1_4
  sta fillRect1_4
  lda rect1_7
  call fillRect1
  ; 291 fillRect1(a+h-1, c, l, r, 1);Сложение
  lhld rect1_1
  xchg
  lhld rect1_7
  mvi h, 0
  dad d
  ; Сложение с константой -1
  dcx h
  shld fillRect1_1
  lhld rect1_2
  shld fillRect1_2
  lda rect1_5
  sta fillRect1_3
  lda rect1_6
  sta fillRect1_4
  mvi a, 1
  jmp fillRect1
rect:
  sta rect_4
  ; 295 rect1(RECTARGS(x, y, x1, y1));
  lxi d, 8
  lhld rect_1
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  xchg
  lhld rect_2
  mvi h, 0
  dad d
  ; Сложение
  lxi d, 36864
  dad d
  shld rect1_1
  ; Сложение с константой 1
  lhld rect_3
  inx h
  lxi d, 8
  call op_div16
  lxi d, 8
  push h
  lhld rect_1
  call op_div16
  ; 16 битная арифметическая операция с константой
  xchg
  pop h
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld rect1_2
  lda rect_1
  ani 7
  mov d, a
  mvi a, 128
  call op_shr
  sta rect1_3
  ; Сложение с константой 1
  lhld rect_3
  inx h
  mov a, l
  ani 7
  mov d, a
  mvi a, 128
  call op_shr
  sta rect1_4
  lda rect_1
  ani 7
  mov d, a
  mvi a, 255
  call op_shr
  sta rect1_5
  ; Сложение с константой 1
  lhld rect_3
  inx h
  mov a, l
  ani 7
  mov d, a
  mvi a, 255
  call op_shr
  xri 255
  sta rect1_6
  ; Арифметика 4/4
  lxi h, rect_2
  lda rect_4
  sub m
  inr a
  jmp rect1
print:
  shld print_4
  ; 299 print1(PRINTARGS(x, y), n, text);
  mvi d, 10
  lda print_2
  call op_mul
  ; Сложение
  lxi d, 36865
  dad d
  push h
  mvi d, 3
  lda print_1
  call op_mul
  lxi d, 4
  call op_div16
  lxi d, 256
  call op_mul16
  ; Сложение
  pop d
  dad d
  shld print1_1
  lda print_1
  ani 3
  sta print1_2
  lda print_3
  sta print1_3
  lhld print_4
  jmp print1
scroll:
  sta scroll_4
  ; 303 d += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld scroll_1
  dad d
  shld scroll_1
  ; 304 s += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld scroll_2
  dad d
  shld scroll_2
  ; 305 if(d>s) {
  lhld scroll_1
  xchg
  lhld scroll_2
  call op_cmp16
  jnc l189
  ; 307 for(; w; --w, d+=0x100, s+=0x100)
l190:
  ; convertToConfition
  lda scroll_3
  ora a
  jz l191
  ; 308 memcpy_back(d, s, h);
  lhld scroll_1
  shld memcpy_back_1
  lhld scroll_2
  shld memcpy_back_2
  lhld scroll_4
  mvi h, 0
  call memcpy_back
l192:
  lxi h, scroll_3
  dcr m
  ; Сложение
  lxi d, 256
  lhld scroll_1
  dad d
  shld scroll_1
  ; Сложение
  lxi d, 256
  lhld scroll_2
  dad d
  shld scroll_2
  jmp l190
l191:
l189:
  ; 310 for(; w; --w, d+=0x100, s+=0x100)
l193:
  ; convertToConfition
  lda scroll_3
  ora a
  jz l194
  ; 311 memcpy(d, s, h);
  lhld scroll_1
  shld memcpy_1
  lhld scroll_2
  shld memcpy_2
  lhld scroll_4
  mvi h, 0
  call memcpy
l195:
  lxi h, scroll_3
  dcr m
  ; Сложение
  lxi d, 256
  lhld scroll_1
  dad d
  shld scroll_1
  ; Сложение
  lxi d, 256
  lhld scroll_2
  dad d
  shld scroll_2
  jmp l193
l194:
  ret
  ; --- numberOfBit -----------------------------------------------------------------
numberOfBit:
  sta numberOfBit_1
  ; 41 asm {
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
  
  ret
  ; --- getch1 -----------------------------------------------------------------
getch1:
  push b
  ; 1 (*(uchar*)0xF803)
  lxi h, 63491
  mvi m, 145
l196:
  ; 65 while(1) {
l197:
  ; 66 i = 6;
  mvi b, 6
  ; 67 while(1) {
l199:
  ; 68 --i;
  dcr b
  ; 1 (*(uchar*)0xF801)Сложение
  mvi h, 0
  mov l, b
  lxi d, scan
  dad d
  mov a, m
  sta 63489
  ; 70 b = KEYB0;
  lda 63488
  sta getch1_b
  ; 71 if(b != 0xFF) { u = 4; break; }
  cpi 255
  jz l201
  ; 71 u = 4; break; }
  mvi c, 4
  ; 71 break; }
  jmp l200
l201:
  ; 72 b = KEYB2 | 0xF0;
  lda 63490
  ori 240
  sta getch1_b
  ; 73 if(b != 0xFF) { u = -4; break; }
  cpi 255
  jz l202
  ; 73 u = -4; break; }
  mvi c, 252
  ; 73 break; }
  jmp l200
l202:
  ; 74 if(i) continue;convertToConfition
  mov a, b
  ora a
  jnz l199
  mvi b, 6
  ; 76 prevCh = -1;
  mvi a, 255
  sta prevCh
  jmp l199
l200:
  ; 78 b = numberOfBit(b) + u + i $ 12;
  lda getch1_b
  call numberOfBit
  add c
  mvi d, 12
  push psw
  mov a, b
  call op_mul
  ; Сложение
  pop d
  mov e, d
  mvi d, 0
  dad d
  mov a, l
  sta getch1_b
  ; 79 if(prevCh != b) break;
  lxi h, getch1_b
  lda prevCh
  cmp m
  jnz l198
  jmp l197
l198:
  ; 82 prevCh = b;
  lda getch1_b
  sta prevCh
  ; 84 if(b==12) {
  lda getch1_b
  cpi 12
  jnz l205
  ; 85 rus = !rus;convertToConfition
  lda rus
  ora a
  sui 1
  sbb a
  sta rus
  jmp l196
l205:
  ; 89 if(b>=24) {
  lda getch1_b
  cpi 24
  jc l206
  ; 90 if(shiftPressed()) b += 12*4;
  call shiftPressed
  ; convertToConfition
  ora a
  jz l207
  ; 90 b += 12*4;
  lda getch1_b
  adi 48
  sta getch1_b
l207:
  ; 91 if(rus) b += 12*8;convertToConfition
  lda rus
  ora a
  jz l208
  ; 91 b += 12*8;
  lda getch1_b
  adi 96
  sta getch1_b
l208:
l206:
  ; 94 return scanCodes[b];Сложение
  lhld getch1_b
  mvi h, 0
  lxi d, scanCodes
  dad d
  mov a, m
  pop b
  ret
  ; --- shiftPressed -----------------------------------------------------------------
shiftPressed:
  lxi h, 63491
  mvi m, 130
  ; 99 return ~KEYB1 & 2;
  lda 63489
  cma
  ani 2
  ret
  ; --- cmd_copy -----------------------------------------------------------------
cmd_copy:
  shld cmd_copy_2
  ; 8 1, e;<flag>
  mvi a, 1
  sta cmd_copy_flag
  ; 11 progress_l = progress_h = 0;
  lxi h, 0
  shld cmd_copy_progress_h
  shld cmd_copy_progress_l
  ; 14 if(e = fs_open(from)) { drawError("ЌҐў®§¬®¦­® ®вЄалвм Ёбе®¤­л© д ©«", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lhld cmd_copy_1
  call fs_open
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l209
  ; 14 drawError("ЌҐў®§¬®¦­® ®вЄалвм Ёбе®¤­л© д ©«", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lxi h, string9
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 14 return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  mvi a, 1
  ret
l209:
  ; 17 drawWindow(" Љ®ЇЁа®ў ­ЁҐ ");
  lxi h, string10
  call drawWindow
  ; 18 print1(PRINTARGS(13, 9), 64, "€§:");
  lxi h, 39259
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 64
  sta print1_3
  lxi h, string11
  call print1
  ; 19 print1(PRINTARGS(17, 9), 34, from);
  lxi h, 40027
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 34
  sta print1_3
  lhld cmd_copy_1
  call print1
  ; 20 print1(PRINTARGS(13,10), 64, "‚:");
  lxi h, 39269
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 64
  sta print1_3
  lxi h, string12
  call print1
  ; 21 print1(PRINTARGS(17,10), 34, to);
  lxi h, 40037
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 34
  sta print1_3
  lhld cmd_copy_2
  call print1
  ; 22 print1(PRINTARGS(28,13), 32, "[ ESC ]");
  lxi h, 42371
  shld print1_1
  xra a
  sta print1_2
  mvi a, 32
  sta print1_3
  lxi h, string13
  call print1
  ; 25 if(e = fs_getsize()) { drawError("ЋиЁЎЄ  звҐ­Ёп д ©« ", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  call fs_getsize
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l210
  ; 25 drawError("ЋиЁЎЄ  звҐ­Ёп д ©« ", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lxi h, string14
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 25 return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  mvi a, 1
  ret
l210:
  ; 26 i2s32(buf, 10, &fs_result, ' ');
  lxi h, cmd_copy_buf
  shld i2s32_1
  lxi h, 10
  shld i2s32_2
  lxi h, fs_low
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 27 print1(PRINTARGS(13,11), 64, "‘Є®ЇЁа®ў ­®           /           Ў ©в");
  lxi h, 39279
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 64
  sta print1_3
  lxi h, string15
  call print1
  ; 28 print1(PRINTARGS(36,11), 10, buf); 
  lxi h, 43887
  shld print1_1
  xra a
  sta print1_2
  mvi a, 10
  sta print1_3
  lxi h, cmd_copy_buf
  call print1
  ; 31 if(e = fs_swap()) { drawError("ЋиЁЎЄ  fs_swap 1", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  call fs_swap
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l211
  ; 31 drawError("ЋиЁЎЄ  fs_swap 1", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lxi h, string16
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 31 return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  mvi a, 1
  ret
l211:
  ; 32 if(e = fs_create(to)) { drawError("ЌҐў®§¬®¦­® б®§¤ вм д ©«", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lhld cmd_copy_2
  call fs_create
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l212
  ; 32 drawError("ЌҐў®§¬®¦­® б®§¤ вм д ©«", e); return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  lxi h, string17
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 32 return 1 /*ЃҐ§ ЇҐаҐ§ Јаг§ЄЁ д ©«®ў*/; } 
  mvi a, 1
  ret
l212:
  ; 35 while(1) {
l213:
  ; 39 i2s32(buf, 10, (ulong*)&progress_l, ' ');
  lxi h, cmd_copy_buf
  shld i2s32_1
  lxi h, 10
  shld i2s32_2
  lxi h, cmd_copy_progress_l
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 40 print1(PRINTARGS(25,11), 10, buf); 
  lxi h, 41583
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 10
  sta print1_3
  lxi h, cmd_copy_buf
  call print1
  ; 43 if(e = fs_swap()) { drawError("ЋиЁЎЄ  fs_swap 3", e); break; }
  call fs_swap
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l215
  ; 43 drawError("ЋиЁЎЄ  fs_swap 3", e); break; }
  lxi h, string18
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 43 break; }
  jmp l214
l215:
  ; 44 if(e = fs_read(panelA.files1, (MAX_FILES*sizeof(FileInfo)) & ~511) ) { drawError("ЋиЁЎЄ  звҐ­Ёп д ©« ", e); break; }
  lhld panelA
  shld fs_read_1
  lxi h, 6656
  call fs_read
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l216
  ; 44 drawError("ЋиЁЎЄ  звҐ­Ёп д ©« ", e); break; }
  lxi h, string14
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 44 break; }
  jmp l214
l216:
  ; 45 if(fs_low == 0) return 0; /* ‘ ЇҐаҐ§ Јаг§Є®© д ©«®ў */;Сложение с константой 0
  lhld fs_low
  mov a, l
  ora h
  jnz l217
  ; 45 return 0; /* ‘ ЇҐаҐ§ Јаг§Є®© д ©«®ў */;
  xra a
  ret
l217:
  ; 46 if(e = fs_swap()) { drawError("ЋиЁЎЄ  fs_swap 2", e); break; }
  call fs_swap
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l218
  ; 46 drawError("ЋиЁЎЄ  fs_swap 2", e); break; }
  lxi h, string19
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 46 break; }
  jmp l214
l218:
  ; 47 if(e = fs_write(panelA.files1, fs_low)) { drawError("ЋиЁЎЄ  § ЇЁбЁ д ©« ", e); break; }
  lhld panelA
  shld fs_write_1
  lhld fs_low
  call fs_write
  sta cmd_copy_e
  ; convertToConfition
  ora a
  jz l219
  ; 47 drawError("ЋиЁЎЄ  § ЇЁбЁ д ©« ", e); break; }
  lxi h, string20
  shld drawError_1
  lda cmd_copy_e
  call drawError
  ; 47 break; }
  jmp l214
l219:
  ; 50 asm {
      lhld fs_low
      xchg
      lhld cmd_copy_progress_l
      dad d
      shld cmd_copy_progress_l
      jnc fs_copy_l2
      lhld cmd_copy_progress_h
      inx h
      shld cmd_copy_progress_h
fs_copy_l2:
    
  jmp l213
l214:
  ; 65 fs_delete(to);
  lhld cmd_copy_2
  call fs_delete
  ; 67 return 0 /* ‘ ЇҐаҐ§ Јаг§Є®© д ©«®ў */;
  xra a
  ret
  ; --- getName -----------------------------------------------------------------
getName:
  shld getName_1
  ; 74 for(p = name; *p; p++)
  shld getName_p
l220:
  ; convertToConfition
  lhld getName_p
  xra a
  ora m
  jz l221
  ; 75 if(*p == '/')
  mov a, m
  cpi 47
  jnz l223
  ; 76 name = p+1;Сложение с константой 1
  inx h
  shld getName_1
l223:
l222:
  lhld getName_p
  mov d, h
  mov e, l
  inx h
  shld getName_p
  xchg
  jmp l220
l221:
  ; 77 return name;
  lhld getName_1
  ret
  ; --- cmd_copymove -----------------------------------------------------------------
cmd_copymove:
  sta cmd_copymove_1
  ; 88 title = copymode ? " Љ®ЇЁа®ў ­ЁҐ " : " ЏҐаҐЁ¬Ґ­®ў ­ЁҐ/ЏҐаҐ­®б ";
  ora a
  jz l224
  lxi h, string10
  jmp l225
l224:
  lxi h, string21
l225:
  shld cmd_copymove_title
  ; 91 addPath1(A_CMDLINE);
  mvi a, 1
  call addPath1
  ; 92 if(cmdline[0] == 0) return;
  lda (cmdline)+(0)
  ora a
  jnz l226
  ; 92 return;
  ret
l226:
  ; 94 strcpy(buf, cmdline);
  lxi h, cmd_copymove_buf
  shld strcpy_1
  lxi h, cmdline
  call strcpy
  ; 96 if(shiftPressed()) {
  call shiftPressed
  ; convertToConfition
  ora a
  jz l227
  ; 98 getSelectedName(cmdLine);
  lxi h, cmdline
  call getSelectedName
  ; 99 cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  call strlen
  shld cmdline_pos
  jmp l228
l227:
  ; 102 strcpy(cmdline, panelB.path);
  lxi h, cmdline
  shld strcpy_1
  lxi h, (panelB)+(7)
  call strcpy
  ; 103 cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  call strlen
  shld cmdline_pos
  ; 107 if(cmdline_pos != 1) {Сложение с константой -1
  dcx h
  mov a, l
  ora h
  jz l229
  ; 108 if(cmdline_pos == 255) { // ЃгдҐа ЇҐаҐЇ®«­Ґ­ Сложение
  lhld cmdline_pos
  lxi d, 65281
  dad d
  mov a, l
  ora h
  jnz l230
  ; 109 drawError(title, ERR_RECV_STRING);
  lhld cmd_copymove_title
  shld drawError_1
  mvi a, 11
  call drawError
  jmp l231
l230:
  ; 112 strcpy(cmdline+cmdline_pos, "/");Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  shld strcpy_1
  lxi h, string6
  call strcpy
  ; 113 ++cmdline_pos;
  lhld cmdline_pos
  inx h
  shld cmdline_pos
l229:
l228:
  ; 118 e=1; 
  mvi a, 1
  sta cmd_copymove_e
  ; 121 if(inputBox(title)) {
  lhld cmd_copymove_title
  call inputBox
  ; convertToConfition
  ora a
  jz l232
  ; 124 if(cmdline[cmdline_pos - 1] == '/') {      Сложение с константой -1
  lhld cmdline_pos
  dcx h
  ; Сложение
  lxi d, cmdline
  dad d
  mov a, m
  cpi 47
  jnz l233
  ; 125 name = getName(buf);
  lxi h, cmd_copymove_buf
  call getName
  shld cmd_copymove_name
  ; 126 if(strlen(name) + cmdline_pos >= 256) { 
  call strlen
  ; Сложение
  xchg
  lhld cmdline_pos
  dad d
  ; Сложение
  lxi d, 65280
  dad d
  jnc l234
  ; 127 drawError(title, ERR_RECV_STRING);
  lhld cmd_copymove_title
  shld drawError_1
  mvi a, 11
  call drawError
  jmp l231
l234:
  ; 130 strcpy(cmdline + cmdline_pos, name);Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  shld strcpy_1
  lhld cmd_copymove_name
  call strcpy
l233:
  ; 134 absolutePath();
  call absolutePath
  ; 136 if(copymode) {convertToConfition
  lda cmd_copymove_1
  ora a
  jz l235
  ; 137 e = cmd_copy(buf, cmdline);
  lxi h, cmd_copymove_buf
  shld cmd_copy_1
  lxi h, cmdline
  call cmd_copy
  sta cmd_copymove_e
  jmp l236
l235:
  ; 140 e = fs_move(buf, cmdline);
  lxi h, cmd_copymove_buf
  shld fs_move_1
  lxi h, cmdline
  call fs_move
  sta cmd_copymove_e
  ; 143 drawError("ЋиЁЎЄ  ЇҐаҐ­®б /ЇҐаҐЁ¬Ґ­®ў ­Ёп", e);
  lxi h, string22
  shld drawError_1
  call drawError
l236:
l232:
  ; 150 if(!e) {convertToConfition
  lda cmd_copymove_e
  ora a
  jnz l237
  ; 151 getFiles();
  call getFiles
  ; 152 swapPanels(); getFiles(); swapPanels();
  call swapPanels
  ; 152 getFiles(); swapPanels();
  call getFiles
  ; 152 swapPanels();
  call swapPanels
l237:
l231:
  ; 157 repairScreen(0);
  xra a
  jmp repairScreen
cmd_run2:
  shld cmd_run2_2
  ; 7 e = fs_exec(prog, cmdLine);
  lhld cmd_run2_1
  shld fs_exec_1
  lhld cmd_run2_2
  call fs_exec
  sta cmd_run2_e
  ; 10 drawError(prog, e); 
  lhld cmd_run2_1
  shld drawError_1
  call drawError
  ; 13 repairScreen(0);
  xra a
  jmp repairScreen
cmd_run:
  sta cmd_run_2
  ; 19 if(selectedFile) getSelectedName(cmdline);convertToConfition
  ora a
  jz l238
  ; 19 getSelectedName(cmdline);
  lxi h, cmdline
  call getSelectedName
l238:
  ; 22 c = cmdLine;
  lxi h, cmdline
  shld cmd_run_c
  ; 25 if(prog == 0)  {Сложение с константой 0
  lhld cmd_run_1
  mov a, l
  ora h
  jnz l239
  ; 28 absolutePath();
  call absolutePath
  ; 31 prog = cmdLine;
  lxi h, cmdline
  shld cmd_run_1
  ; 32 c = strchr(prog, 32);
  shld strchr_1
  mvi a, 32
  call strchr
  shld cmd_run_c
  ; 33 if(c) *c=0, ++c; else c="";convertToConfition
  mov a, l
  ora h
  jz l240
  ; 33 *c=0, ++c; else c="";
  mvi m, 0
  inx h
  shld cmd_run_c
  jmp l241
l240:
  ; 33 c="";
  lxi h, string0
  shld cmd_run_c
l241:
l239:
  ; 36 cmd_run2(prog, c);
  lhld cmd_run_1
  shld cmd_run2_1
  lhld cmd_run_c
  jmp cmd_run2
cmd_new:
  sta cmd_new_1
  ; 9 clearCmdLine();
  call clearCmdLine
  ; 12 title = dir ? " ‘®§¤ ­ЁҐ Ї ЇЄЁ " : " ‘®§¤ ­ЁҐ д ©«  ";
  lda cmd_new_1
  ora a
  jz l242
  lxi h, string23
  jmp l243
l242:
  lxi h, string24
l243:
  shld cmd_new_title
  ; 13 if(inputBox(title)) {
  call inputBox
  ; convertToConfition
  ora a
  jz l244
  ; 16 if(cmdline_pos) {    convertToConfition
  lhld cmdline_pos
  mov a, l
  ora h
  jz l245
  ; 19 absolutePath();
  call absolutePath
  ; 21 if(dir) {convertToConfition
  lda cmd_new_1
  ora a
  jz l246
  ; 23 e = fs_mkdir(cmdline);
  lxi h, cmdline
  call fs_mkdir
  sta cmd_new_e
  ; 26 if(!e) getFiles();convertToConfition
  ora a
  cz getFiles
  lxi h, string25
  shld drawError_1
  lda cmd_new_e
  call drawError
  jmp l248
l246:
  ; 32 if(cmdline_pos==255) { Сложение
  lhld cmdline_pos
  lxi d, 65281
  dad d
  mov a, l
  ora h
  jnz l249
  ; 33 drawError("ЋиЁЎЄ  б®§¤ ­Ёп д ©« ", ERR_RECV_STRING);
  lxi h, string26
  shld drawError_1
  mvi a, 11
  call drawError
  jmp l250
l249:
  ; 39 drawError("ЋиЁЎЄ  б®§¤ ­Ёп д ©« ", fs_create(cmdline));
  lxi h, string26
  shld drawError_1
  lxi h, cmdline
  call fs_create
  jmp drawError
  ; 42 return; // ’ ¬ ўл§лў Ґвбп repairScreen
l250:
l248:
l245:
l244:
  ; 52 repairScreen(0);
  xra a
  jmp repairScreen
cmd_freespace_1:
  shld cmd_freespace_1_2
  ; 5 i2s32(buf, 10, (ulong*)&fs_low, ' ');
  lxi h, cmd_freespace_1_buf
  shld i2s32_1
  lxi h, 10
  shld i2s32_2
  lxi h, fs_low
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 6 memcpy_back(buf+10, buf+7, 3); buf[9]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(10)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(7)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 6 buf[9]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(9)
  ; 7 memcpy_back(buf+6,  buf+4, 3); buf[5]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(6)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(4)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 7 buf[5]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(5)
  ; 8 memcpy_back(buf+2,  buf+1, 3); buf[1]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(2)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(1)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 8 buf[1]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(1)
  ; 9 strcpy(buf+13, " ЊЎ");
  lxi h, (cmd_freespace_1_buf)+(13)
  shld strcpy_1
  lxi h, string27
  call strcpy
  ; 10 print(19,    y, 64, text);  
  mvi a, 19
  sta print_1
  lda cmd_freespace_1_1
  sta print_2
  mvi a, 64
  sta print_3
  lhld cmd_freespace_1_2
  call print
  ; 11 print(19+10, y, 64, buf);
  mvi a, 29
  sta print_1
  lda cmd_freespace_1_1
  sta print_2
  mvi a, 64
  sta print_3
  lxi h, cmd_freespace_1_buf
  jmp print
cmd_freespace:
  lxi h, string28
  call drawWindow
  ; 19 print(27, 13, 32, "[ ANY KEY ]");
  mvi a, 27
  sta print_1
  mvi a, 13
  sta print_2
  mvi a, 32
  sta print_3
  lxi h, string29
  call print
  ; 20 print(19, 10, 64, "Џ®¤бзҐв бў®Ў®¤­®Ј® ¬Ґбв ...");  
  mvi a, 19
  sta print_1
  mvi a, 10
  sta print_2
  mvi a, 64
  sta print_3
  lxi h, string30
  call print
  ; 22 if(e = fs_getfree()) { 
  call fs_getfree
  sta cmd_freespace_e
  ; convertToConfition
  ora a
  jz l251
  ; 23 drawError("ЋиЁЎЄ  звҐ­Ёп ¤ЁбЄ ", e);
  lxi h, string31
  shld drawError_1
  lda cmd_freespace_e
  call drawError
  jmp l252
l251:
  ; 27 graph1();
  call graph1
  ; 28 print(19, 10, 27|0x80, "");
  mvi a, 19
  sta print_1
  mvi a, 10
  sta print_2
  mvi a, 155
  sta print_3
  lxi h, string0
  call print
  ; 29 cmd_freespace_1(11, "‘ў®Ў®¤­®:");
  mvi a, 11
  sta cmd_freespace_1_1
  lxi h, string32
  call cmd_freespace_1
  ; 32 if(!fs_gettotal()) cmd_freespace_1(10, "‚бҐЈ®:");
  call fs_gettotal
  ; convertToConfition
  ora a
  jnz l253
  ; 32 cmd_freespace_1(10, "‚бҐЈ®:");
  mvi a, 10
  sta cmd_freespace_1_1
  lxi h, string33
  call cmd_freespace_1
l253:
  ; 35 getch1();
  call getch1
l252:
  ; 39 repairScreen(0);
  xra a
  jmp repairScreen
cmd_delete:
  lxi h, cmdline
  call getSelectedName
  ; 8 if(cmdline[0]==0) { 
  lda (cmdline)+(0)
  ora a
  jnz l254
  ; 9 clearCmdLine();
  jmp clearCmdLine
  ; 10 return;
l254:
  ; 12 cmdLine_pos = strlen(cmdLine);
  lxi h, cmdline
  call strlen
  shld cmdline_pos
  ; 15 if(inputBox(" “¤ «Ґ­ЁҐ ")) {
  lxi h, string34
  call inputBox
  ; convertToConfition
  ora a
  jz l255
  ; 18 absolutePath();
  call absolutePath
  ; 21 e = fs_delete(cmdline);
  lxi h, cmdline
  call fs_delete
  sta cmd_delete_e
  ; 24 if(!e) getFiles();convertToConfition
  ora a
  cz getFiles
  lxi h, string35
  shld drawError_1
  lda cmd_delete_e
  call drawError
l255:
  ; 31 repairScreen(0);
  xra a
  jmp repairScreen
drawWindow:
  shld drawWindow_1
  ; 8 graph1();
  call graph1
  ; 9 i = 48;
  lxi h, 48
  shld drawWindow_i
  ; 10 while(1) {
l257:
  ; 12 fillRect(56+i+i, 60+i, 326-i-i, 165-i);Сложение
  lxi d, 56
  dad d
  ; Сложение
  xchg
  lhld drawWindow_i
  dad d
  shld fillRect_1
  ; Сложение
  lhld drawWindow_i
  lxi d, 60
  dad d
  mov a, l
  sta fillRect_2
  ; 16 битная арифметическая операция с константой
  lhld drawWindow_i
  mvi a, 70
  sub l
  mov l, a
  mvi a, 1
  sbb h
  mov h, a
  ; 16 битная арифметическая операция с константой
  xchg
  lhld drawWindow_i
  xchg
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld fillRect_3
  ; 16 битная арифметическая операция с константой
  lhld drawWindow_i
  mvi a, 165
  sub l
  mov l, a
  mvi a, 0
  sbb h
  mov h, a
  mov a, l
  call fillRect
  ; 13 if(i==0) break;Сложение с константой 0
  lhld drawWindow_i
  mov a, l
  ora h
  jz l258
  mov a, l
  sui 8
  mov l, a
  mov a, h
  sbi 0
  mov h, a
  shld drawWindow_i
  jmp l257
l258:
  ; 16 graph0();
  call graph0
  ; 17 rect1(RECTARGS(70,85-10,314,140+10));
  lxi h, 38987
  shld rect1_1
  lxi h, 31
  shld rect1_2
  mvi a, 2
  sta rect1_3
  mvi a, 16
  sta rect1_4
  mvi a, 3
  sta rect1_5
  mvi a, 224
  sta rect1_6
  mvi a, 76
  call rect1
  ; 18 rect1(RECTARGS(68,83-10,316,142+10));
  lxi h, 38985
  shld rect1_1
  lxi h, 31
  shld rect1_2
  mvi a, 8
  sta rect1_3
  mvi a, 4
  sta rect1_4
  mvi a, 15
  sta rect1_5
  mvi a, 248
  sta rect1_6
  mvi a, 80
  call rect1
  ; 19 graph1();
  call graph1
  ; 20 print((64-strlen(title)) >> 1, 7, 32, title);
  lhld drawWindow_1
  call strlen
  ; 16 битная арифметическая операция с константой
  mvi a, 64
  sub l
  mov l, a
  mvi a, 0
  sbb h
  mov h, a
  ; Сдвиг на 1 вправо
  mov a, h
  cmp a
  rar
  mov h, a
  mov a, l
  rar
  mov l, a
  mov a, l
  sta print_1
  mvi a, 7
  sta print_2
  mvi a, 32
  sta print_3
  lhld drawWindow_1
  jmp print
drawInput:
  sta drawInput_3
  ; 26 old = graphOffset;
  lhld graphOffset
  shld drawInput_old
  ; 27 graphOffset = 0;
  lxi h, 0
  shld graphOffset
  ; 29 --max;
  lxi h, drawInput_3
  dcr m
  ; 30 if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  lhld cmdline_pos
  xchg
  lhld drawInput_3
  mvi h, 0
  call op_cmp16
  jc l260
  jz l260
  ; 30 cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  lxi h, 0
  shld cmdline_offset
  jmp l261
l260:
  ; 30 cmdline_offset = cmdline_pos-max;16 битная арифметическая операция с константой
  lhld drawInput_3
  mvi h, 0
  xchg
  lhld cmdline_pos
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld cmdline_offset
l261:
  ; 31 c1 = cmdline_pos - cmdline_offset;16 битная арифметическая операция с константой
  lhld cmdline_offset
  xchg
  lhld cmdline_pos
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld drawInput_c1
  ; 32 cmdline[cmdline_pos] = '_';Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  mvi m, 95
  ; 33 cmdline[cmdline_pos+1] = 0;Сложение с константой 1
  lhld cmdline_pos
  inx h
  ; Сложение
  lxi d, cmdline
  dad d
  mvi m, 0
  ; 34 ++c1;
  lhld drawInput_c1
  inx h
  shld drawInput_c1
  ; 35 if(c1 > max) c1 = max;
  xchg
  lhld drawInput_3
  mvi h, 0
  call op_cmp16
  jnc l262
  ; 35 c1 = max;
  lhld drawInput_3
  mvi h, 0
  shld drawInput_c1
l262:
  ; 36 ++c1;
  lhld drawInput_c1
  inx h
  shld drawInput_c1
  ; 37 ++max;
  lxi h, drawInput_3
  inr m
  ; 38 print1(a, a1, max|0x80, cmdline + cmdline_offset);
  lhld drawInput_1
  shld print1_1
  lda drawInput_2
  sta print1_2
  lda drawInput_3
  ori 128
  sta print1_3
  ; Сложение
  lhld cmdline_offset
  lxi d, cmdline
  dad d
  call print1
  ; 39 cmdline[cmdline_pos] = 0;Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  mvi m, 0
  ; 41 graphOffset = old;
  lhld drawInput_old
  shld graphOffset
  ret
  ; --- processInput -----------------------------------------------------------------
processInput:
  sta processInput_1
  ; 45 if(c==8) {
  cpi 8
  jnz l263
  ; 46 if(cmdline_pos==0) return;Сложение с константой 0
  lhld cmdline_pos
  mov a, l
  ora h
  jnz l264
  ; 46 return;
  ret
l264:
  ; 47 --cmdline_pos;    
  dcx h
  shld cmdline_pos
  ; 48 cmdline[cmdline_pos] = 0;Сложение
  lxi d, cmdline
  dad d
  mvi m, 0
l263:
  ; 50 if(c>=32 && c<0xF0) {
  lda processInput_1
  cpi 32
  jc l265
  cpi 240
  jnc l265
  ; 51 if(cmdline_pos==255) return; Сложение
  lhld cmdline_pos
  lxi d, 65281
  dad d
  mov a, l
  ora h
  jnz l266
  ; 51 return; 
  ret
l266:
  ; 52 cmdline[cmdline_pos] = c;Сложение
  lhld cmdline_pos
  lxi d, cmdline
  dad d
  lda processInput_1
  mov m, a
  ; 53 ++cmdline_pos;
  lhld cmdline_pos
  inx h
  shld cmdline_pos
  ; 54 cmdline[cmdline_pos] = 0;Сложение
  lxi d, cmdline
  dad d
  mvi m, 0
l265:
  ret
  ; --- drawError -----------------------------------------------------------------
drawError:
  sta drawError_2
  ; 73 if(e==0) return;
  ora a
  jnz l267
  ; 73 return;
  ret
l267:
  ; 75 old=graphOffset;
  lhld graphOffset
  shld drawError_old
  ; 76 graphOffset=0;
  lxi h, 0
  shld graphOffset
  ; 78 setColor(COLOR_RED);
  mvi a, 80
  call setColor
  ; 79 drawWindow(" ЋиЁЎЄ  ");
  lxi h, string44
  call drawWindow
  ; 80 print1(PRINTARGS(27,13), 32, "[ ANY KEY ]");
  lxi h, 42115
  shld print1_1
  mvi a, 3
  sta print1_2
  mvi a, 32
  sta print1_3
  lxi h, string29
  call print1
  ; 81 print1(PRINTARGS(13,09), 34, text);
  lxi h, 39259
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 34
  sta print1_3
  lhld drawError_1
  call print1
  ; 85 i2s(buf, e, 3, '0');
  lxi h, drawError_buf
  shld i2s_1
  lhld drawError_2
  mvi h, 0
  shld i2s_2
  mvi l, 3
  shld i2s_3
  mvi a, 48
  call i2s
  ; 86 text = buf;
  lxi h, drawError_buf
  shld drawError_1
  ; 90 print1(PRINTARGS(13,11), 34, text);
  lxi h, 39279
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 34
  sta print1_3
  lhld drawError_1
  call print1
  ; 91 getch1();
  call getch1
  ; 93 graphOffset=old;
  lhld drawError_old
  shld graphOffset
  ret
  ; --- inputBox -----------------------------------------------------------------
inputBox:
  shld inputBox_1
  ; 100 old=graphOffset;
  lhld graphOffset
  shld inputBox_old
  ; 101 graphOffset=0;
  lxi h, 0
  shld graphOffset
  ; 103 drawWindow(title);
  lhld inputBox_1
  call drawWindow
  ; 104 print1(PRINTARGS(23,13), 32, "[ ENTER ]   [ ESC ]");
  lxi h, 41347
  shld print1_1
  mvi a, 3
  sta print1_2
  mvi a, 32
  sta print1_3
  lxi h, string45
  call print1
  ; 106 graph0();  
  call graph0
  ; 107 fillRect1(FILLRECTARGS(88,109,294,120));
  lxi h, 39789
  shld fillRect1_1
  lxi h, 25
  shld fillRect1_2
  mvi a, 255
  sta fillRect1_3
  add a
  sta fillRect1_4
  mvi a, 12
  call fillRect1
  ; 111 while(1) {
l268:
  ; 112 graph0();
  call graph0
  ; 113 setColor(COLOR_CYAN);
  mvi a, 128
  call setColor
  ; 114 drawInput(PRINTARGS(16, 11), 32);
  lxi h, 40047
  shld drawInput_1
  xra a
  sta drawInput_2
  mvi a, 32
  call drawInput
  ; 116 c = getch1();
  call getch1
  sta inputBox_c
  ; 117 if(c==13) { graphOffset=old; return 1; }
  cpi 13
  jnz l270
  ; 117 graphOffset=old; return 1; }
  lhld inputBox_old
  shld graphOffset
  ; 117 return 1; }
  mvi a, 1
  ret
l270:
  ; 118 if(c==27) { graphOffset=old; return 0; }
  lda inputBox_c
  cpi 27
  jnz l271
  ; 118 graphOffset=old; return 0; }
  lhld inputBox_old
  shld graphOffset
  ; 118 return 0; }
  xra a
  ret
l271:
  ; 119 processInput(c);
  lda inputBox_c
  call processInput
  jmp l268
l269:
  ret
  ; --- inputBoxR -----------------------------------------------------------------
inputBoxR:
  shld inputBoxR_1
  ; 124 inputBox(title);<r>
  call inputBox
  sta inputBoxR_r
  ; 125 repairScreen(0);  
  xra a
  call repairScreen
  ; 126 return r;
  lda inputBoxR_r
  ret
  ; --- strcpy -----------------------------------------------------------------
strcpy:
  shld strcpy_2
  ; 2 asm {
    ; de = src
    xchg
    ; hl = to
    lhld strcpy_1
strcpy_l1:
    ; *dest = *src
    ldax d
    mov m, a
    ora a
    inx h
    inx d
    jnz strcpy_l1
    dcx h
  
  ret
  ; --- strlen -----------------------------------------------------------------
strlen:
  shld strlen_1
  ; 2 asm { 
 
    lxi d, -1
strlen_l1:
    xra a
    ora m
    inx d
    inx h
    jnz strlen_l1
    xchg
  
  ret
  ; --- memcpy_back -----------------------------------------------------------------
memcpy_back:
  shld memcpy_back_3
  ; 2 asm {
    ; if(cnt==0) return
    mov a, h
    ora l
    rz
    ; start
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memcpy_back_2
    dad d
    mov c, l
    mov b, h
    ; hl = to
    lhld memcpy_back_1
    dad d
    ; enter loop
    inr d
    xra a
    ora e
    jz memcpy_back_l2
memcpy_back_l1:
    ; dest--, src--
    dcx h
    dcx b
    ; *dest = *src
    ldax b
    mov m, a
    ; while(cnt)
    dcr e
    jnz memcpy_back_l1
memcpy_back_l2:
    dcr d
    jnz memcpy_back_l1
    pop b
  
  ret
  ; --- memcpy -----------------------------------------------------------------
memcpy:
  shld memcpy_3
  ; 2 asm {
    ; if(cnt==0) return
    mov a, h
    ora l
    rz
    ; start
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memcpy_2
    mov c, l
    mov b, h
    ; hl = to
    lhld memcpy_1
    ; enter loop
    inr d
    xra a
    ora e
    jz memcpy_l2
memcpy_l1:
    ; *dest = *src
    ldax b
    mov m, a
    ; dest++, src++
    inx h
    inx b
    ; while(--cnt)
    dcr e
    jnz memcpy_l1
memcpy_l2:
    dcr d
    jnz memcpy_l1
    pop b
  
  ret
  ; --- op_mul -----------------------------------------------------------------
op_mul:
  push b
  lxi h, 0
  mov e, d  ; de=d
  mov d, l  
  mvi c, 8
op_mul1:
  dad h
  add a
  jnc op_mul2
    dad d
op_mul2:
  dcr c
  jnz op_mul1
pop_bc_ret:
  pop b

  ret
  ; --- op_div16 -----------------------------------------------------------------
op_div16:
        PUSH B
        XCHG
        CALL _DIV0
        XCHG
        SHLD op_div16_mod
        XCHG
        POP B
        RET

_DIV0:
_DIV:	MOV A,H
	ORA L
	RZ
	LXI B,0000
	PUSH B
_DIV1:	MOV A,E
	SUB L
	MOV A,D
	SBB H
	JC _DIV2
	PUSH H
	DAD H
	JNC _DIV1
_DIV2:	LXI H,0000
_DIV3:	POP B
	MOV A,B
	ORA C
	RZ
	DAD H
	PUSH D
	MOV A,E
	SUB C
	MOV E,A
	MOV A,D
	SBB B
	MOV D,A
	JC _DIV4
	INX H
	POP B
	JMP _DIV3
_DIV4:	POP D
	JMP _DIV3  
  
  ret
  ; --- op_mul16 -----------------------------------------------------------------
op_mul16:
  push b
  mov b, h
  mov c, l
  lxi h, 0
  mvi a, 17
op_mul16_1:
  dcr a
  jz pop_bc_ret
  dad h
  xchg
  jnc op_mul16_2
  dad h
  inx h
  jmp op_mul16_3
op_mul16_2:
  dad h
op_mul16_3:
  xchg
  jnc op_mul16_1
  dad b
  jnc op_mul16_1
  inx d
  jmp op_mul16_1

  ret
  ; --- op_cmp16 -----------------------------------------------------------------
op_cmp16:
    mov a, h
    cmp d
    rnz
    mov a, l
    cmp e
  
  ret
  ; --- setColor -----------------------------------------------------------------
setColor:
  sta setColor_1
  ; 2 asm { 
 
    STA 0FFFEh
  
  ret
  ; --- i2s32 -----------------------------------------------------------------
i2s32:
  sta i2s32_4
  ; 5 buf += n;  Сложение
  lhld i2s32_2
  xchg
  lhld i2s32_1
  dad d
  shld i2s32_1
  ; 6 *buf = 0;
  mvi m, 0
  ; 8 div32_l = ((ushort*)val)[0];Сложение с константой 0
  lhld i2s32_3
  mov e, m
  inx h
  mov d, m
  xchg
  shld div32_l
  ; 9 div32_h = ((ushort*)val)[1];Сложение с константой 2
  lhld i2s32_3
  inx h
  inx h
  mov e, m
  inx h
  mov d, m
  xchg
  shld div32_h
  ; 11 while(1) {
l272:
  ; 12 div32(10);
  lxi h, 10
  call div32
  ; 13 --buf;
  lhld i2s32_1
  dcx h
  shld i2s32_1
  ; 14 *buf = "0123456789ABCDEF"[op_div16_mod];Сложение
  lhld op_div16_mod
  lxi d, string46
  dad d
  mov a, m
  lhld i2s32_1
  mov m, a
  ; 15 if(--n==0) return;
  lhld i2s32_2
  dcx h
  shld i2s32_2
  ; Сложение с константой 0
  mov a, l
  ora h
  jnz l274
  ; 15 return;
  ret
l274:
  ; 16 if(div32_l == 0 && div32_h == 0) break;Сложение с константой 0
  lhld div32_l
  mov a, l
  ora h
  jnz l275
  ; Сложение с константой 0
  lhld div32_h
  mov a, l
  ora h
  jz l273
l275:
  jmp l272
l273:
  ; 19 while(1) {
l276:
  ; 20 --buf;
  lhld i2s32_1
  dcx h
  shld i2s32_1
  ; 21 *buf = spc;
  lda i2s32_4
  mov m, a
  ; 22 if(--n == 0) break;
  lhld i2s32_2
  dcx h
  shld i2s32_2
  ; Сложение с константой 0
  mov a, l
  ora h
  jz l277
  jmp l276
l277:
  ret
  ; --- i2s -----------------------------------------------------------------
i2s:
  sta i2s_4
  ; 4 buf += n;  Сложение
  lhld i2s_3
  xchg
  lhld i2s_1
  dad d
  shld i2s_1
  ; 5 *buf = 0;
  mvi m, 0
  ; 6 while(1) {
l279:
  ; 7 v /= 10;
  lxi d, 10
  lhld i2s_2
  call op_div16
  shld i2s_2
  ; 8 --buf;
  lhld i2s_1
  dcx h
  shld i2s_1
  ; 9 *buf = "0123456789ABCDEF"[op_div16_mod];Сложение
  lhld op_div16_mod
  lxi d, string46
  dad d
  mov a, m
  lhld i2s_1
  mov m, a
  ; 10 --n;
  lhld i2s_3
  dcx h
  shld i2s_3
  ; 11 if(n == 0) return;Сложение с константой 0
  mov a, l
  ora h
  jnz l281
  ; 11 return;
  ret
l281:
  ; 12 if(v == 0) break;Сложение с константой 0
  lhld i2s_2
  mov a, l
  ora h
  jz l280
  jmp l279
l280:
  ; 14 while(1) {
l283:
  ; 15 --buf;
  lhld i2s_1
  dcx h
  shld i2s_1
  ; 16 *buf = spc;
  lda i2s_4
  mov m, a
  ; 17 if(--n == 0) break;
  lhld i2s_3
  dcx h
  shld i2s_3
  ; Сложение с константой 0
  mov a, l
  ora h
  jz l284
  jmp l283
l284:
  ret
  ; --- op_shr16 -----------------------------------------------------------------
op_shr16:
  inr e
op_shr16_l:
  dcr e
  rz
  sub a
  ora h 
  rar
  mov h, a
  mov a, l
  rar
  mov l, a
  jmp op_shr16_l

  ret
  ; --- memswap -----------------------------------------------------------------
memswap:
  shld memswap_3
  ; 2 asm {
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memswap_2
    mov c, l
    mov b, h
    ; hl = to
    lhld memswap_1
memswap_l1:
    ; if(cnt==0) return
    mov a, d
    ora e
    jz memswap_l2
    ; *dest = *src
    ldax b
    sta memswap_v1
    mov a, m
    stax b
    .db 36h ; mvi m, 0
memswap_v1:
    .db 0    
    ; dest++, src++, cnt--
    inx h
    inx b
    dcx d
    ; loop
    jmp memswap_l1
memswap_l2:
    pop b
  
  ret
  ; --- memcmp -----------------------------------------------------------------
memcmp:
  shld memcmp_3
  ; 2 asm {
    ; if(len==0) return 0;
    mov a, l
    ora h
    rz
    push b
    ; de = len
    xchg
    ; bc = d
    lhld memcmp_1
    mov b, h
    mov c, l
    ; hl = s
    lhld memcmp_2
    ; loop
memcmp_l1:
      ldax b
      cmp m
      jnz memcmp_stop
      inx h
      inx b
      dcx d
      mov a, d
      ora e
    jnz memcmp_l1
    pop b
    ; a=0
    ret
memcmp_stop:
    pop b
    sbb a
    rc
    inr a
    ret
  
  ret
  ; --- memset -----------------------------------------------------------------
memset:
  shld memset_3
  ; 2 asm {
    push b
    lda memset_2
    xchg
    lhld memset_1
    xchg
    lxi b, -1    
memset_l1:
    dad b
    jnc memset_l2
    stax d
    inx d
    jmp memset_l1
memset_l2:
    pop b
  
  ret
  ; --- fs_findfirst -----------------------------------------------------------------
fs_findfirst:
  shld fs_findfirst_3
  ; 4 if(path[0] == '/') path++;Сложение с константой 0
  lhld fs_findfirst_1
  mov a, m
  cpi 47
  jnz l286
  ; 4 path++;
  mov d, h
  mov e, l
  inx h
  shld fs_findfirst_1
  xchg
l286:
  ; 5 asm {
    PUSH B
    ; hl = fs_findfirst_3
    XCHG
    LHLD fs_findfirst_2
    MOV  B, H  
    MOV  C, L
    LHLD fs_findfirst_1 
    MVI  A, 1
    CALL fs_entry
    SHLD fs_low
    POP  B
  
  ret
  ; --- op_mod16 -----------------------------------------------------------------
op_mod16:
  call op_div16
  ; 5 asm {
    lhld op_div16_mod;
  
  ret
  ; --- fs_init -----------------------------------------------------------------
fs_init:
    SHLD fs_cmdLine
    XCHG
    SHLD fs_selfName
    MOV H, B
    MOV L, C
    SHLD fs_entry_n+1
  
  ret
  ; --- fs_entry -----------------------------------------------------------------
fs_entry:
fs_entry_n:
    JMP 0000h
  
  ret
  ; --- setColorAutoDisable -----------------------------------------------------------------
setColorAutoDisable:
  lxi h, 49152
  shld memchr8_1
  mvi a, 251
  sta memchr8_2
  mvi a, 16
  call memchr8
  ; Сложение с константой 0
  mov a, l
  ora h
  jnz l287
  ; 5 asm {
      MVI A, 0C9h
      STA setColor
    
l287:
  ret
  ; --- clrscr -----------------------------------------------------------------
clrscr:
  mvi a, 31
  jmp putch
op_shr:
  inr d
op_shr_2:
  dcr d
  rz
  cmp a
  rar
  jmp op_shr_2

  ret
  ; --- fs_open -----------------------------------------------------------------
fs_open:
  shld fs_open_1
  ; 5 return fs_open0(name, O_OPEN);
  shld fs_open0_1
  xra a
  jmp fs_open0
  ret
  ; --- fs_getsize -----------------------------------------------------------------
fs_getsize:
  lxi h, 0
  shld fs_seek_1
  shld fs_seek_2
  mvi a, 100
  jmp fs_seek
  ret
  ; --- fs_swap -----------------------------------------------------------------
fs_swap:
  lxi h, string0
  shld fs_open0_1
  mvi a, 101
  jmp fs_open0
  ret
  ; --- fs_create -----------------------------------------------------------------
fs_create:
  shld fs_create_1
  ; 5 return fs_open0(name, O_CREATE);
  shld fs_open0_1
  mvi a, 1
  jmp fs_open0
  ret
  ; --- fs_read -----------------------------------------------------------------
fs_read:
  shld fs_read_2
  ; 4 asm {
    PUSH B
    ; hl = fs_read_2
    XCHG
    LHLD fs_read_1
    XCHG
    MVI  A, 4
    CALL fs_entry ; HL-размер, DE-адрес / HL-сколько загрузили, A-код ошибки
    SHLD fs_low
    POP  B    
  
  ret
  ; --- fs_write -----------------------------------------------------------------
fs_write:
  shld fs_write_2
  ; 4 asm {
    PUSH B
    ; hl = fs_write_2
    XCHG
    LHLD fs_write_1
    XCHG
    LDA  fs_addr
    MVI  A, 5
    CALL fs_entry ; HL-размер, DE-адрес / A-код ошибки
    POP  B    
  
  ret
  ; --- fs_delete -----------------------------------------------------------------
fs_delete:
  shld fs_delete_1
  ; 5 return fs_open0(name, O_DELETE);
  shld fs_open0_1
  mvi a, 100
  jmp fs_open0
  ret
  ; --- fs_move -----------------------------------------------------------------
fs_move:
  shld fs_move_2
  ; 4 asm {
    PUSH B
    XCHG
    LHLD fs_move_1
    MVI  A, 6
    CALL fs_entry ; HL-из, DE-в / A-код ошибки
    POP  B
  
  ret
  ; --- fs_exec -----------------------------------------------------------------
fs_exec:
  shld fs_exec_2
  ; 4 asm {    
    
    PUSH B
    XCHG
    LHLD fs_exec_1
    XRA  A
    CALL fs_entry
    POP  B
  
  ret
  ; --- strchr -----------------------------------------------------------------
strchr:
  sta strchr_2
  ; 2 asm {
    mov d, a
    lhld strchr_1
strchr_l1:
    ; *dest = *src    
    mov a, m
    cmp d
    rz
    inx h
    ora a
    jnz strchr_l1
    mov h, a
    mov l, a
  
  ret
  ; --- fs_mkdir -----------------------------------------------------------------
fs_mkdir:
  shld fs_mkdir_1
  ; 5 return fs_open0(name, O_MKDIR);
  shld fs_open0_1
  mvi a, 2
  jmp fs_open0
  ret
  ; --- fs_getfree -----------------------------------------------------------------
fs_getfree:
  lxi h, 0
  shld fs_seek_1
  shld fs_seek_2
  mvi a, 102
  jmp fs_seek
  ret
  ; --- fs_gettotal -----------------------------------------------------------------
fs_gettotal:
  lxi h, 0
  shld fs_seek_1
  shld fs_seek_2
  mvi a, 101
  jmp fs_seek
  ret
  ; --- div32 -----------------------------------------------------------------
div32:
  shld div32_1
  ; 9 div32_h /= v;
  xchg
  lhld div32_h
  call op_div16
  shld div32_h
  ; 10 ((uchar*)&tmp)[1] = op_div16_mod;
  lda op_div16_mod
  sta (div32_tmp)+(1)
  ; 11 ((uchar*)&tmp)[0] = ((uchar*)&div32_l)[1];
  lda (div32_l)+(1)
  sta (div32_tmp)+(0)
  ; 12 ((uchar*)&div32_l)[1] = tmp / v;
  lhld div32_1
  xchg
  lhld div32_tmp
  call op_div16
  mov a, l
  sta (div32_l)+(1)
  ; 13 ((uchar*)&tmp)[1] = op_div16_mod;
  lda op_div16_mod
  sta (div32_tmp)+(1)
  ; 14 ((uchar*)&tmp)[0] = ((uchar*)&div32_l)[0];
  lda (div32_l)+(0)
  sta (div32_tmp)+(0)
  ; 15 ((uchar*)&div32_l)[0] = tmp / v;
  lhld div32_1
  xchg
  lhld div32_tmp
  call op_div16
  mov a, l
  sta (div32_l)+(0)
  ret
  ; --- memchr8 -----------------------------------------------------------------
memchr8:
  sta memchr8_3
  ; 2 asm {
    ; lda memchr8_3
    mov d, a
    lda memchr8_2
    lhld memchr8_1
memchr8_l1:
    ; *dest = *src    
    cmp m
    rz
    inx h
    dcr d
    jnz memchr8_l1
    xra a
    mov h, a
    mov l, a
  
  ret
  ; --- putch -----------------------------------------------------------------
putch:
    mov c, a
    call 0C809h
  
  ret
  ; --- fs_open0 -----------------------------------------------------------------
fs_open0:
  sta fs_open0_2
  ; 5 asm {      
      
    PUSH B
    ; a = fs_open0_2
    MOV  D, A 
    LHLD fs_open0_1
    MVI  A, 2
    CALL fs_entry
    POP  B
  
  ret
  ; --- fs_seek -----------------------------------------------------------------
fs_seek:
  sta fs_seek_3
  ; 4 asm {
    PUSH B
    ; a = fs_seek_3
    MOV  B, A
    LHLD fs_seek_2
    XCHG
    LHLD fs_seek_1
    MVI  A, 3
    CALL fs_entry ; B-режим, DE:HL-имя файла / A-код ошибки, DE:HL-позиция
    SHLD fs_low
    XCHG
    SHLD fs_high
    POP  B
  
  ret
panelA:
 .ds 265
panelB:
 .ds 265
panelGraphOffset:
 .ds 2
parentDir:
 .db 46
 .db 46
 .db 32
 .db 32
 .db 32
 .db 32
 .db 32
 .db 32
 .db 32
 .db 32
 .db 32
 .db 16
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0

test:
 .ds 256
cursorX1:
 .ds 2
cursorY1:
 .ds 1
cmdline:
 .ds 256
cmdline_pos:
 .dw 0

printName_1:
 .ds 2
printName_2:
 .ds 2
absolutePath_l:
 .ds 2
drawColumn__1:
 .ds 1
drawColumn__a:
 .ds 2
drawColumn__x:
 .ds 1
drawColumn__y:
 .ds 1
drawColumn__xx:
 .ds 2
drawColumn__f:
 .ds 2
drawFile1_1:
 .ds 2
drawFile1_2:
 .ds 1
drawFile1_3:
 .ds 1
drawFile_1:
 .ds 1
drawFile_2:
 .ds 1
normalizeFileName_1:
 .ds 2
normalizeFileName_2:
 .ds 2
normalizeFileName_i:
 .ds 1
getSelectedName_1:
 .ds 2
getSelectedName_n:
 .ds 2
drawFileInfo__n:
 .ds 2
drawFileInfo__f:
 .ds 2
drawFileInfo__buf:
 .ds 16
drawPathInCmdLine_o:
 .ds 2
drawPathInCmdLine_l:
 .ds 2
drawPathInCmdLine_old:
 .ds 2
drawPath__1:
 .ds 1
drawPath__l:
 .ds 2
drawPath__x:
 .ds 2
drawPath__x1:
 .ds 2
drawPath__x2:
 .ds 2
drawPath__x3:
 .ds 2
drawPath__p:
 .ds 2
cmpFileInfo_1:
 .ds 2
cmpFileInfo_2:
 .ds 2
cmpFileInfo_i:
 .ds 1
cmpFileInfo_j:
 .ds 1
sort_1:
 .ds 2
sort_2:
 .ds 2
sort_i:
 .ds 2
sort_j:
 .ds 2
sort_x:
 .ds 2
sort_st_:
 .ds 128
sort_st:
 .ds 2
sort_stc:
 .ds 1
prepareFileName_1:
 .ds 2
prepareFileName_2:
 .ds 2
prepareFileName_c:
 .ds 1
prepareFileName_ni:
 .ds 1
prepareFileName_i:
 .ds 1
getFiles_f:
 .ds 2
getFiles_st:
 .ds 2
getFiles_n:
 .ds 2
getFiles_i:
 .ds 1
getFiles_j:
 .ds 2
getFiles_dir:
 .ds 20
reloadFiles_1:
 .ds 2
reloadFiles_l:
 .ds 2
reloadFiles_f:
 .ds 2
dropPath_l:
 .ds 2
dropPath_buf:
 .ds 11
dropPath_p:
 .ds 2
dropPath_f:
 .ds 2
addPath1_1:
 .ds 1
addPath1_buf:
 .ds 13
addPath1_d:
 .ds 2
addPath1_s:
 .ds 2
addPath1_i:
 .ds 1
addPath1_f:
 .ds 2
addPath1_l:
 .ds 2
addPath1_o:
 .ds 2
drawHelp_i:
 .ds 1
drawHelp_d:
 .ds 2
repairScreen_1:
 .ds 1
cursor_right_w:
 .ds 2
cmd_char_1:
 .ds 1
main_c:
 .ds 1
main_y:
 .ds 1
main_w:
 .ds 1
main_r:
 .ds 1
main_e:
 .ds 2
main_l:
 .ds 2
graphOffset:
 .ds 2
clrscr10_1:
 .ds 2
clrscr10_2:
 .ds 1
clrscr10_3:
 .ds 1
fillRect1_int_1:
 .ds 1
fillRect1_int_2:
 .ds 1
fillRect1_int_3:
 .ds 2
fillRect1_1:
 .ds 2
fillRect1_2:
 .ds 2
fillRect1_3:
 .ds 1
fillRect1_4:
 .ds 1
fillRect1_5:
 .ds 1
fillRect_1:
 .ds 2
fillRect_2:
 .ds 1
fillRect_3:
 .ds 2
fillRect_4:
 .ds 1
print_p1_1:
 .ds 2
print_p1_2:
 .ds 2
print_p2_1:
 .ds 2
print_p2_2:
 .ds 2
print_p3_1:
 .ds 2
print_p3_2:
 .ds 2
print_p4_1:
 .ds 2
print_p4_2:
 .ds 2
print1_1:
 .ds 2
print1_2:
 .ds 1
print1_3:
 .ds 1
print1_4:
 .ds 2
print1_s:
 .ds 2
print1_c:
 .ds 1
print1_e:
 .ds 1
rect1_1:
 .ds 2
rect1_2:
 .ds 2
rect1_3:
 .ds 1
rect1_4:
 .ds 1
rect1_5:
 .ds 1
rect1_6:
 .ds 1
rect1_7:
 .ds 1
rect_1:
 .ds 2
rect_2:
 .ds 1
rect_3:
 .ds 2
rect_4:
 .ds 1
print_1:
 .ds 1
print_2:
 .ds 1
print_3:
 .ds 1
print_4:
 .ds 2
scroll_1:
 .ds 2
scroll_2:
 .ds 2
scroll_3:
 .ds 1
scroll_4:
 .ds 1
scanCodes:
 .db 243
 .db 244
 .db 245
 .db 246
 .db 247
 .db 248
 .db 249
 .db 250
 .db 251
 .db 252
 .db 253
 .db 254
 .db 1
 .db 12
 .db 23
 .db 26
 .db 9
 .db 27
 .db 32
 .db 25
 .db 2
 .db 24
 .db 10
 .db 13
 .db 59
 .db 49
 .db 50
 .db 51
 .db 52
 .db 53
 .db 54
 .db 55
 .db 56
 .db 57
 .db 48
 .db 45
 .db 106
 .db 99
 .db 117
 .db 107
 .db 101
 .db 110
 .db 103
 .db 91
 .db 93
 .db 122
 .db 104
 .db 42
 .db 102
 .db 121
 .db 119
 .db 97
 .db 112
 .db 114
 .db 111
 .db 108
 .db 100
 .db 118
 .db 92
 .db 46
 .db 113
 .db 94
 .db 115
 .db 109
 .db 105
 .db 116
 .db 120
 .db 98
 .db 64
 .db 44
 .db 47
 .db 8
 .db 43
 .db 33
 .db 34
 .db 35
 .db 36
 .db 37
 .db 94
 .db 38
 .db 42
 .db 40
 .db 41
 .db 61
 .db 74
 .db 67
 .db 85
 .db 75
 .db 69
 .db 78
 .db 71
 .db 123
 .db 125
 .db 90
 .db 72
 .db 58
 .db 70
 .db 89
 .db 87
 .db 65
 .db 80
 .db 82
 .db 79
 .db 76
 .db 68
 .db 86
 .db 92
 .db 62
 .db 81
 .db 94
 .db 83
 .db 77
 .db 73
 .db 84
 .db 88
 .db 66
 .db 64
 .db 60
 .db 63
 .db 8
 .db 59
 .db 49
 .db 50
 .db 51
 .db 52
 .db 53
 .db 54
 .db 55
 .db 56
 .db 57
 .db 48
 .db 45
 .db 169
 .db 230
 .db 227
 .db 170
 .db 165
 .db 173
 .db 163
 .db 232
 .db 233
 .db 167
 .db 229
 .db 42
 .db 228
 .db 235
 .db 162
 .db 160
 .db 175
 .db 224
 .db 174
 .db 171
 .db 164
 .db 166
 .db 237
 .db 46
 .db 239
 .db 231
 .db 225
 .db 172
 .db 168
 .db 226
 .db 236
 .db 161
 .db 238
 .db 44
 .db 47
 .db 8
 .db 43
 .db 33
 .db 34
 .db 35
 .db 36
 .db 37
 .db 94
 .db 38
 .db 42
 .db 40
 .db 41
 .db 61
 .db 137
 .db 150
 .db 147
 .db 138
 .db 133
 .db 141
 .db 131
 .db 152
 .db 153
 .db 135
 .db 149
 .db 58
 .db 148
 .db 155
 .db 130
 .db 128
 .db 143
 .db 144
 .db 142
 .db 139
 .db 132
 .db 134
 .db 157
 .db 62
 .db 159
 .db 151
 .db 145
 .db 140
 .db 136
 .db 146
 .db 156
 .db 129
 .db 158
 .db 60
 .db 63
 .db 8

numberOfBit_1:
 .ds 1
rus:
 .ds 1
prevCh:
 .ds 1
scan:
 .db 124
 .db 248
 .db 188
 .db 220
 .db 236
 .db 244

getch1_b:
 .ds 1
cmd_copy_1:
 .ds 2
cmd_copy_2:
 .ds 2
cmd_copy_readed:
 .ds 2
cmd_copy_buf:
 .ds 16
cmd_copy_flag:
 .ds 1
cmd_copy_e:
 .ds 1
cmd_copy_progress_l:
 .ds 2
cmd_copy_progress_h:
 .ds 2
getName_1:
 .ds 2
getName_p:
 .ds 2
cmd_copymove_1:
 .ds 1
cmd_copymove_name:
 .ds 2
cmd_copymove_e:
 .ds 1
cmd_copymove_title:
 .ds 2
cmd_copymove_l:
 .ds 2
cmd_copymove_old:
 .ds 2
cmd_copymove_buf:
 .ds 256
cmd_run2_1:
 .ds 2
cmd_run2_2:
 .ds 2
cmd_run2_e:
 .ds 1
cmd_run_1:
 .ds 2
cmd_run_2:
 .ds 1
cmd_run_p:
 .ds 2
cmd_run_c:
 .ds 2
cmd_new_1:
 .ds 1
cmd_new_e:
 .ds 1
cmd_new_title:
 .ds 2
cmd_freespace_1_1:
 .ds 1
cmd_freespace_1_2:
 .ds 2
cmd_freespace_1_buf:
 .ds 16
cmd_freespace_e:
 .ds 1
cmd_delete_e:
 .ds 1
cmdline_offset:
 .dw 0

drawWindow_1:
 .ds 2
drawWindow_i:
 .ds 2
drawInput_1:
 .ds 2
drawInput_2:
 .ds 1
drawInput_3:
 .ds 1
drawInput_c:
 .ds 2
drawInput_c1:
 .ds 2
drawInput_old:
 .ds 2
processInput_1:
 .ds 1
errors:
 .db (string36) & 255
 .db (string37) & 255
 .db (string38) & 255
 .db (string39) & 255
 .db (string40) & 255
 .db (string41) & 255
 .db (string42) & 255
 .db (string43) & 255

 .ds 8
drawError_1:
 .ds 2
drawError_2:
 .ds 1
drawError_buf:
 .ds 16
drawError_old:
 .ds 2
inputBox_1:
 .ds 2
inputBox_c:
 .ds 1
inputBox_old:
 .ds 2
inputBoxR_1:
 .ds 2
inputBoxR_r:
 .ds 1
strcpy_1:
 .ds 2
strcpy_2:
 .ds 2
strlen_1:
 .ds 2
memcpy_back_1:
 .ds 2
memcpy_back_2:
 .ds 2
memcpy_back_3:
 .ds 2
memcpy_1:
 .ds 2
memcpy_2:
 .ds 2
memcpy_3:
 .ds 2
op_div16_mod:
 .ds 2
setColor_1:
 .ds 1
i2s32_1:
 .ds 2
i2s32_2:
 .ds 2
i2s32_3:
 .ds 2
i2s32_4:
 .ds 1
i2s_1:
 .ds 2
i2s_2:
 .ds 2
i2s_3:
 .ds 2
i2s_4:
 .ds 1
memswap_1:
 .ds 2
memswap_2:
 .ds 2
memswap_3:
 .ds 2
memcmp_1:
 .ds 2
memcmp_2:
 .ds 2
memcmp_3:
 .ds 2
memset_1:
 .ds 2
memset_2:
 .ds 1
memset_3:
 .ds 2
fs_findfirst_1:
 .ds 2
fs_findfirst_2:
 .ds 2
fs_findfirst_3:
 .ds 2
fs_cmdLine:
 .dw $+2
 .ds 1
fs_selfName:
 .dw $+2
 .ds 1
fs_low:
 .ds 2
fs_high:
 .ds 2
fs_addr:
 .ds 1
fs_open_1:
 .ds 2
fs_create_1:
 .ds 2
fs_read_1:
 .ds 2
fs_read_2:
 .ds 2
fs_write_1:
 .ds 2
fs_write_2:
 .ds 2
fs_delete_1:
 .ds 2
fs_move_1:
 .ds 2
fs_move_2:
 .ds 2
fs_exec_1:
 .ds 2
fs_exec_2:
 .ds 2
strchr_1:
 .ds 2
strchr_2:
 .ds 1
fs_mkdir_1:
 .ds 2
div32_l:
 .ds 2
div32_h:
 .ds 2
div32_1:
 .ds 2
div32_tmp:
 .ds 2
div32_am:
 .ds 1
memchr8_1:
 .ds 2
memchr8_2:
 .ds 1
memchr8_3:
 .ds 1
putch_1:
 .ds 1
fs_open0_1:
 .ds 2
fs_open0_2:
 .ds 1
fs_seek_1:
 .ds 2
fs_seek_2:
 .ds 2
fs_seek_3:
 .ds 1
string0:
 .db 0
string1:
 .db 32,32,32,32,32,16,68,73,82,17,0
string10:
 .db 32,138,174,175,168,224,174,162,160,173,168,165,32,0
string27:
 .db 32,140,161,0
string44:
 .db 32,142,232,168,161,170,160,32,0
string21:
 .db 32,143,165,224,165,168,172,165,173,174,162,160,173,168,165,47,143,165,224,165,173,174,225,32,0
string28:
 .db 32,145,162,174,161,174,164,173,174,32,173,160,32,164,168,225,170,165,32,0
string23:
 .db 32,145,174,167,164,160,173,168,165,32,175,160,175,170,168,32,0
string24:
 .db 32,145,174,167,164,160,173,168,165,32,228,160,169,171,160,32,0
string34:
 .db 32,147,164,160,171,165,173,168,165,32,0
string6:
 .db 47,0
string46:
 .db 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,0
string5:
 .db 49,70,82,69,69,32,32,32,50,78,69,87,32,32,32,32,51,86,73,69,87,32,32,32,52,69,68,73,84,32,32,32,53,67,79,80,89,32,32,32,54,82,69,78,32,32,32,32,55,68,73,82,32,32,32,32,56,68,69,76,0
string2:
 .db 62,0
string4:
 .db 78,97,109,101,0
string29:
 .db 91,32,65,78,89,32,75,69,89,32,93,0
string45:
 .db 91,32,69,78,84,69,82,32,93,32,32,32,91,32,69,83,67,32,93,0
string13:
 .db 91,32,69,83,67,32,93,0
string8:
 .db 101,100,105,116,46,114,107,115,0
string7:
 .db 118,105,101,119,46,114,107,115,0
string12:
 .db 130,58,0
string33:
 .db 130,225,165,163,174,58,0
string41:
 .db 132,168,225,170,32,167,160,175,174,171,173,165,173,0
string11:
 .db 136,167,58,0
string40:
 .db 140,160,170,225,168,172,227,172,32,228,160,169,171,174,162,32,162,32,175,160,175,170,165,0
string9:
 .db 141,165,162,174,167,172,174,166,173,174,32,174,226,170,224,235,226,236,32,168,225,229,174,164,173,235,169,32,228,160,169,171,0
string17:
 .db 141,165,162,174,167,172,174,166,173,174,32,225,174,167,164,160,226,236,32,228,160,169,171,0
string16:
 .db 142,232,168,161,170,160,32,102,115,95,115,119,97,112,32,49,0
string19:
 .db 142,232,168,161,170,160,32,102,115,95,115,119,97,112,32,50,0
string18:
 .db 142,232,168,161,170,160,32,102,115,95,115,119,97,112,32,51,0
string37:
 .db 142,232,168,161,170,160,32,164,168,225,170,160,0
string20:
 .db 142,232,168,161,170,160,32,167,160,175,168,225,168,32,228,160,169,171,160,0
string22:
 .db 142,232,168,161,170,160,32,175,165,224,165,173,174,225,160,47,175,165,224,165,168,172,165,173,174,162,160,173,168,239,0
string25:
 .db 142,232,168,161,170,160,32,225,174,167,164,160,173,168,239,32,175,160,175,170,168,0
string26:
 .db 142,232,168,161,170,160,32,225,174,167,164,160,173,168,239,32,228,160,169,171,160,0
string35:
 .db 142,232,168,161,170,160,32,227,164,160,171,165,173,168,239,32,228,160,169,171,160,0
string31:
 .db 142,232,168,161,170,160,32,231,226,165,173,168,239,32,164,168,225,170,160,0
string14:
 .db 142,232,168,161,170,160,32,231,226,165,173,168,239,32,228,160,169,171,160,0
string42:
 .db 143,160,175,170,160,32,173,165,32,175,227,225,226,160,0
string30:
 .db 143,174,164,225,231,165,226,32,225,162,174,161,174,164,173,174,163,174,32,172,165,225,226,160,46,46,46,0
string3:
 .db 143,174,171,227,231,165,173,168,165,32,225,175,168,225,170,160,32,228,160,169,171,174,162,0
string39:
 .db 143,227,226,236,32,173,165,32,173,160,169,164,165,173,0
string32:
 .db 145,162,174,161,174,164,173,174,58,0
string15:
 .db 145,170,174,175,168,224,174,162,160,173,174,32,32,32,32,32,32,32,32,32,32,32,47,32,32,32,32,32,32,32,32,32,32,32,161,160,169,226,0
string38:
 .db 148,160,169,171,32,173,165,32,174,226,170,224,235,226,0
string43:
 .db 148,160,169,171,32,225,227,233,165,225,226,162,227,165,226,0
string36:
 .db 148,160,169,171,174,162,160,239,32,225,168,225,226,165,172,160,32,173,165,32,173,160,169,164,165,173,160,0
  .end
