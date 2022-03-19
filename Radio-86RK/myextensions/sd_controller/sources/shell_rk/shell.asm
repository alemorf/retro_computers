  .include "stdlib8080.inc"
drawFiles:
  call hideFileCursor
  ; 27 drawColumn(0);
  xra a
  call drawColumn
  ; 28 drawColumn(1);
  mvi a, 1
  jmp drawColumn
swapPanels:
  lxi h, panelA
  shld memswap_1
  lxi h, panelB
  shld memswap_2
  lxi h, 266
  call memswap
  ; 36 drawSwapPanels();
  jmp drawSwapPanels
getSel:
  lhld (panelA)+(260)
  xchg
  lhld (panelA)+(259)
  mvi h, 0
  dad d
  push h
  mvi d, 22
  lda (panelA)+(258)
  call op_mul
  ; Сложение
  pop d
  dad d
  shld getSel_n
  ; 43 if(n < panelA.cnt) return panelA.files1 + n;
  xchg
  lhld (panelA)+(262)
  call op_cmp16
  jc l0
  jz l0
  ; 43 return panelA.files1 + n;
  lhld getSel_n
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
  ret
l0:
  ; 44 panelA.offset = 0;
  lxi h, 0
  shld (panelA)+(260)
  ; 45 panelA.cursorY = 0;
  xra a
  sta (panelA)+(259)
  ; 46 panelA.cursorX = 0;
  sta (panelA)+(258)
  ; 47 if(panelA.cnt != 0) return panelA.files1;Сложение с константой 0
  lhld (panelA)+(262)
  mov a, l
  ora h
  jz l1
  ; 47 return panelA.files1;
  lhld panelA
  ret
l1:
  ; 48 return (FileInfo*)parentDir;
  lxi h, parentDir
  ret
  ; --- getSelNoBack -----------------------------------------------------------------
getSelNoBack:
  call getSel
  shld getSelNoBack_f
  ; 55 if(f->fname[0] == '.') f = 0;Сложение с константой 0
  mov a, m
  cpi 46
  jnz l2
  ; 55 f = 0;
  lxi h, 0
  shld getSelNoBack_f
l2:
  ; 56 return f;  
  ret
  ; --- drawFileInfo -----------------------------------------------------------------
drawFileInfo:
  call getSel
  shld drawFileInfo_f
  ; 68 if(f->fattrib & 0x10) {Сложение
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l3
  ; 69 drawFileInfoDir();
  call drawFileInfoDir
  jmp l4
l3:
  ; 71 i2s32(buf, &f->fsize, 10, ' ');           
  lxi h, drawFileInfo_buf
  shld i2s32_1
  ; Сложение
  lhld drawFileInfo_f
  lxi d, 12
  dad d
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 72 drawFileInfo1(buf);
  lxi h, drawFileInfo_buf
  call drawFileInfo1
l4:
  ; 75 if(f->fdate==0 && f->ftime==0) {Сложение
  lhld drawFileInfo_f
  lxi d, 18
  dad d
  ; Сложение с константой 0
  mov e, m
  inx h
  mov d, m
  xchg
  mov a, l
  ora h
  jnz l5
  ; Сложение
  lhld drawFileInfo_f
  lxi d, 16
  dad d
  ; Сложение с константой 0
  mov e, m
  inx h
  mov d, m
  xchg
  mov a, l
  ora h
  jnz l5
  ; 76 buf[0] = 0;
  xra a
  sta (drawFileInfo_buf)+(0)
  jmp l6
l5:
  ; 78 i2s(buf, f->fdate & 31, 2, ' ');  
  lxi h, drawFileInfo_buf
  shld i2s_1
  ; Сложение
  lhld drawFileInfo_f
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
  ; 79 buf[2] = '-';
  mvi a, 45
  sta (drawFileInfo_buf)+(2)
  ; 80 i2s(buf+3, (f->fdate>>5) & 15, 2, '0');
  lxi h, (drawFileInfo_buf)+(3)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo_f
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
  ; 81 buf[5] = '-';
  mvi a, 45
  sta (drawFileInfo_buf)+(5)
  ; 82 i2s(buf+6, (f->fdate>>9)+1980, 4, '0');
  lxi h, (drawFileInfo_buf)+(6)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo_f
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
  ; 83 buf[10] = ' ';
  mvi a, 32
  sta (drawFileInfo_buf)+(10)
  ; 84 i2s(buf+11, f->ftime>>11, 2, '0');
  lxi h, (drawFileInfo_buf)+(11)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo_f
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
  ; 85 buf[13] = ':';
  mvi a, 58
  sta (drawFileInfo_buf)+(13)
  ; 86 i2s(buf+14, (f->ftime>>5)&63, 2, '0');
  lxi h, (drawFileInfo_buf)+(14)
  shld i2s_1
  ; Сложение
  lhld drawFileInfo_f
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
l6:
  ; 88 drawFileInfo2(buf);
  lxi h, drawFileInfo_buf
  jmp drawFileInfo2
showFileCursorAndDrawFileInfo:
  call showFileCursor
  ; 96 drawFileInfo();  
  jmp drawFileInfo
drawFilesCount:
  lxi h, 0
  shld (drawFilesCount_total)+(0)
  ; 1 ((ushort*)a)[1] = (b>>16); }
  shld (drawFilesCount_total)+(2)
  ; 107 filesCnt = 0;
  shld drawFilesCount_filesCnt
  ; 108 for(p = panelA.files1, i = panelA.cnt; i; ++p, --i) {
  lhld panelA
  shld drawFilesCount_p
  lhld (panelA)+(262)
  shld drawFilesCount_i
l7:
  ; convertToConfition
  mov a, l
  ora h
  jz l8
  ; 109 if((p->fattrib & 0x10) == 0) ++filesCnt;Сложение
  lhld drawFilesCount_p
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jnz l10
  ; 109 ++filesCnt;
  lhld drawFilesCount_filesCnt
  inx h
  shld drawFilesCount_filesCnt
l10:
  ; 110 add32_32(&total, &p->fsize);
  lxi h, drawFilesCount_total
  shld add32_32_1
  ; Сложение
  lhld drawFilesCount_p
  lxi d, 12
  dad d
  call add32_32
l9:
  lhld drawFilesCount_p
  lxi d, 20
  dad d
  shld drawFilesCount_p
  lhld drawFilesCount_i
  dcx h
  shld drawFilesCount_i
  jmp l7
l8:
  ; 113 drawFilesCountInt(&total, filesCnt);
  lxi h, drawFilesCount_total
  shld drawFilesCountInt_1
  lhld drawFilesCount_filesCnt
  jmp drawFilesCountInt
drawFiles2:
  call drawFiles
  ; 121 drawFilesCount();
  call drawFilesCount
  ; 122 swapPanels();
  call swapPanels
  ; 123 drawFiles();
  call drawFiles
  ; 124 drawFilesCount();
  call drawFilesCount
  ; 125 drawFileInfo();
  call drawFileInfo
  ; 126 swapPanels();
  call swapPanels
  ; 127 showFileCursorAndDrawFileInfo();
  jmp showFileCursorAndDrawFileInfo
drawScreen:
  xra a
  sta (cmdline)+(0)
  ; 135 drawScreenInt();
  call drawScreenInt
  ; 136 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ; 137 drawFiles2();
  jmp drawFiles2
processInput:
  push b
  sta processInput_1
  ; 144 strlen(cmdline);<cmdline_pos>
  lxi h, cmdline
  call strlen
  mov b, h
  mov c, l
  ; 145 if(c==KEY_BKSPC) {
  lda processInput_1
  cpi 127
  jnz l11
  ; 146 if(cmdline_pos==0) return;Сложение с константой 0
  mov a, l
  ora h
  jnz l12
  ; 146 return;
  pop b
  ret
l12:
  ; 147 --cmdline_pos;    
  dcx b
  ; 148 cmdline[cmdline_pos] = 0;Сложение с BC
  lxi h, cmdline
  dad b
  mvi m, 0
  ; 149 return;
  pop b
  ret
l11:
  ; 151 if(c>=32) {
  lda processInput_1
  cpi 32
  jc l13
  ; 152 if(cmdline_pos==255) return; Сложение с BC
  lxi h, 65281
  dad b
  mov a, l
  ora h
  jnz l14
  ; 152 return; 
  pop b
  ret
l14:
  ; 153 cmdline[cmdline_pos] = c;Сложение с BC
  lxi h, cmdline
  dad b
  lda processInput_1
  mov m, a
  ; 154 ++cmdline_pos;
  inx b
  ; 155 cmdline[cmdline_pos] = 0;Сложение с BC
  lxi h, cmdline
  dad b
  mvi m, 0
l13:
  pop b
  ret
  ; --- drawError -----------------------------------------------------------------
drawError:
  sta drawError_2
  ; 166 if(e == 0) return;
  ora a
  jnz l15
  ; 166 return;
  ret
l15:
  ; 169 drawWindow(" o{ibka ");
  lxi h, string0
  call drawWindow
  ; 170 drawAnyKeyButton();
  call drawAnyKeyButton
  ; 171 drawWindowText(0, 0, text);
  xra a
  sta drawWindowText_1
  sta drawWindowText_2
  lhld drawError_1
  call drawWindowText
  ; 174 switch(e) {
  lda drawError_2
  cpi 1
  jz l17
  cpi 2
  jz l18
  cpi 7
  jz l19
  cpi 3
  jz l20
  cpi 4
  jz l21
  cpi 5
  jz l22
  cpi 6
  jz l23
  cpi 8
  jz l24
  cpi 128
  jz l25
  cpi 11
  jz l26
  jmp l27
l17:
  ; 175 text = "net fajlowoj sistemy"; break;
  lxi h, string1
  shld drawError_1
  ; 175 break;
  jmp l16
l18:
  ; 176 text = "o{ibka nakopitelq"; break;
  lxi h, string2
  shld drawError_1
  ; 176 break;
  jmp l16
l19:
  ; 177 text = "papka ne pusta"; break;
  lxi h, string3
  shld drawError_1
  ; 177 break;
  jmp l16
l20:
  ; 178 text = "fajl ne otkryt"; break;
  lxi h, string4
  shld drawError_1
  ; 178 break;
  jmp l16
l21:
  ; 179 text = "putx ne najden"; break;
  lxi h, string5
  shld drawError_1
  ; 179 break;
  jmp l16
l22:
  ; 180 text = "maksimum fajlow w papke"; break;
  lxi h, string6
  shld drawError_1
  ; 180 break;
  jmp l16
l23:
  ; 181 text = "disk zapolnen"; break;
  lxi h, string7
  shld drawError_1
  ; 181 break;
  jmp l16
l24:
  ; 182 text = "fail su}estwuet"; break;
  lxi h, string8
  shld drawError_1
  ; 182 break;
  jmp l16
l25:
  ; 183 text = "prerwano polxzowatelem"; break;
  lxi h, string9
  shld drawError_1
  ; 183 break;
  jmp l16
l26:
  ; 184 text = "putx bolx{e 255 simwolow"; break;
  lxi h, string10
  shld drawError_1
  ; 184 break;
  jmp l16
l27:
  ; 185 i2s(buf, e, 3, '0'); text = buf; break;
  lxi h, drawError_buf
  shld i2s_1
  lhld drawError_2
  mvi h, 0
  shld i2s_2
  mvi l, 3
  shld i2s_3
  mvi a, 48
  call i2s
  ; 185 text = buf; break;
  lxi h, drawError_buf
  shld drawError_1
  ; 185 break;
l16:
  ; 189 drawWindowText(0, 2, text);
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lhld drawError_1
  call drawWindowText
  ; 192 getch1();
  jmp getch1
inputBox:
  push b
  shld inputBox_1
  ; 200 clearFlag = 1;
  mvi c, 1
  ; 203 drawWindow(title);
  call drawWindow
  ; 204 drawWindowText(3, 1, "imq:");
  mvi a, 3
  sta drawWindowText_1
  mvi a, 1
  sta drawWindowText_2
  lxi h, string11
  call drawWindowText
  ; 205 drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");
  mvi a, 6
  sta drawWindowText_1
  mvi a, 4
  sta drawWindowText_2
  lxi h, string12
  call drawWindowText
  ; 208 while(1) {
l28:
  ; 209 drawWindowInput(3, 2, 32);
  mvi a, 3
  sta drawWindowInput_1
  dcr a
  sta drawWindowInput_2
  mvi a, 32
  call drawWindowInput
  ; 210 c = getch1();
  call getch1
  mov b, a
  ; 211 if(c==KEY_RIGHT) clearFlag = 0;
  mvi a, 24
  cmp b
  jnz l30
  ; 211 clearFlag = 0;
  mvi c, 0
l30:
  ; 212 if(c==KEY_LEFT) clearFlag = 0;
  mvi a, 8
  cmp b
  jnz l31
  ; 212 clearFlag = 0;
  mvi c, 0
l31:
  ; 213 if(c==KEY_ENTER) { hideTextCursor(); return 1; }
  mvi a, 13
  cmp b
  jnz l32
  ; 213 hideTextCursor(); return 1; }
  call hideTextCursor
  ; 213 return 1; }
  mvi a, 1
  pop b
  ret
l32:
  ; 214 if(c==KEY_ESC) { hideTextCursor(); return 0; }
  mvi a, 27
  cmp b
  jnz l33
  ; 214 hideTextCursor(); return 0; }
  call hideTextCursor
  ; 214 return 0; }
  xra a
  pop b
  ret
l33:
  ; 215 if(clearFlag) clearFlag = 0, cmdline[0] = 0;convertToConfition
  mov a, c
  ora a
  jz l34
  ; 215 clearFlag = 0, cmdline[0] = 0;
  mvi c, 0
  xra a
  sta (cmdline)+(0)
l34:
  ; 216 processInput(c);
  mov a, b
  call processInput
  jmp l28
l29:
  pop b
  ret
  ; --- confirm -----------------------------------------------------------------
confirm:
  shld confirm_2
  ; 225 drawWindow(title);
  lhld confirm_1
  call drawWindow
  ; 226 drawWindowText(3, 1, text);
  mvi a, 3
  sta drawWindowText_1
  mvi a, 1
  sta drawWindowText_2
  lhld confirm_2
  call drawWindowText
  ; 227 drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");
  mvi a, 6
  sta drawWindowText_1
  mvi a, 4
  sta drawWindowText_2
  lxi h, string12
  call drawWindowText
  ; 230 while(1) {
l35:
  ; 231 switch(getch1()) {
  call getch1
  cpi 13
  jz l38
  cpi 27
  jz l39
  jmp l37
l38:
  ; 232 return 1;
  mvi a, 1
  ret
l39:
  ; 233 return 0;
  xra a
  ret
l37:
  jmp l35
l36:
  ret
  ; --- unpackName -----------------------------------------------------------------
unpackName:
  push b
  shld unpackName_2
  ; 243 for(i=0; i!=11; ++i, ++s) {
  mvi b, 0
l40:
  mvi a, 11
  cmp b
  jz l41
  ; 244 if(i==8) *d = '.', ++d;
  mvi a, 8
  cmp b
  jnz l43
  ; 244 *d = '.', ++d;
  lhld unpackName_1
  mvi m, 46
  inx h
  shld unpackName_1
l43:
  ; 245 if(*s!=' ') *d = *s, ++d;
  lhld unpackName_2
  mov a, m
  cpi 32
  jz l44
  ; 245 *d = *s, ++d;
  mov a, m
  lhld unpackName_1
  mov m, a
  lhld unpackName_1
  inx h
  shld unpackName_1
l44:
l42:
  inr b
  lhld unpackName_2
  inx h
  shld unpackName_2
  jmp l40
l41:
  ; 247 if(d[-1]=='.') --d;Сложение с константой -1
  lhld unpackName_1
  dcx h
  mov a, m
  cpi 46
  jnz l45
  ; 247 --d;
  lhld unpackName_1
  dcx h
  shld unpackName_1
l45:
  ; 248 *d = 0;
  lhld unpackName_1
  mvi m, 0
  pop b
  ret
  ; --- catPathAndUnpack -----------------------------------------------------------------
catPathAndUnpack:
  shld catPathAndUnpack_2
  ; 254 strlen(str);<len>
  lhld catPathAndUnpack_1
  call strlen
  shld catPathAndUnpack_len
  ; 255 if(len) {convertToConfition
  mov a, l
  ora h
  jz l46
  ; 256 if(len >= 255-13) return 1; // Не влезает разделитель плюс имя файла  Сложение
  lxi d, 65294
  dad d
  jnc l47
  ; 256 return 1; // Не влезает разделитель плюс имя файла  
  mvi a, 1
  ret
l47:
  ; 257 str[len] = '/';  Сложение
  lhld catPathAndUnpack_1
  xchg
  lhld catPathAndUnpack_len
  dad d
  mvi m, 47
  ; 258 str += len+1;Сложение с константой 1
  lhld catPathAndUnpack_len
  inx h
  ; Сложение
  xchg
  lhld catPathAndUnpack_1
  dad d
  shld catPathAndUnpack_1
l46:
  ; 260 unpackName(str, fileName);
  lhld catPathAndUnpack_1
  shld unpackName_1
  lhld catPathAndUnpack_2
  call unpackName
  ; 261 return 0;
  xra a
  ret
  ; --- getFirstSelected -----------------------------------------------------------------
getFirstSelected:
  shld getFirstSelected_1
  ; 272 nextSelectedCnt = panelA.cnt;
  lhld (panelA)+(262)
  shld nextSelectedCnt
  ; 273 nextSelectedFile = panelA.files1;
  lhld panelA
  shld nextSelectedFile
  ; 274 if(type = getNextSelected(name)) return type; 
  lhld getFirstSelected_1
  call getNextSelected
  sta getFirstSelected_type
  ; convertToConfition
  ora a
  jz l48
  ; 274 return type; 
  lda getFirstSelected_type
  ret
l48:
  ; 276 nextSelectedFile = getSelNoBack();
  call getSelNoBack
  shld nextSelectedFile
  ; 277 if(!nextSelectedFile) return 0;convertToConfition
  mov a, l
  ora h
  jnz l49
  ; 277 return 0;
  xra a
  ret
l49:
  ; 278 unpackName(name, nextSelectedFile->fname);
  lhld getFirstSelected_1
  shld unpackName_1
  lhld nextSelectedFile
  call unpackName
  ; 279 if(nextSelectedFile->fattrib & 0x10) return 2;Сложение
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l50
  ; 279 return 2;
  mvi a, 2
  ret
l50:
  ; 280 return 1;
  mvi a, 1
  ret
  ; --- getNextSelected -----------------------------------------------------------------
getNextSelected:
  shld getNextSelected_1
  ; 286 for(;;) {
l51:
  ; 287 if(nextSelectedCnt == 0) return 0;Сложение с константой 0
  lhld nextSelectedCnt
  mov a, l
  ora h
  jnz l54
  ; 287 return 0;
  xra a
  ret
l54:
  ; 288 if(nextSelectedFile->fattrib & 0x80) break;Сложение
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 128
  ; convertToConfition
  jnz l52
  lhld nextSelectedFile
  lxi d, 20
  dad d
  shld nextSelectedFile
  lhld nextSelectedCnt
  dcx h
  shld nextSelectedCnt
l53:
  jmp l51
l52:
  ; 292 nextSelectedFile->fattrib &= 0x7F;Сложение
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
  ; 293 unpackName(name, nextSelectedFile->fname);
  lhld getNextSelected_1
  shld unpackName_1
  lhld nextSelectedFile
  call unpackName
  ; 294 ++nextSelectedFile, --nextSelectedCnt;
  lhld nextSelectedFile
  lxi d, 20
  dad d
  shld nextSelectedFile
  lhld nextSelectedCnt
  dcx h
  shld nextSelectedCnt
  ; 295 if(nextSelectedFile[-1].fattrib & 0x10) return 2;Сложение
  lhld nextSelectedFile
  lxi d, 65516
  dad d
  ; Сложение
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l56
  ; 295 return 2;
  mvi a, 2
  ret
l56:
  ; 296 return 1;
  mvi a, 1
  ret
  ; --- cmpFileInfo -----------------------------------------------------------------
cmpFileInfo:
  push b
  shld cmpFileInfo_2
  ; 305 i = (a->fattrib&0x10);Сложение
  lhld cmpFileInfo_1
  lxi d, 11
  dad d
  mov a, m
  ani 16
  mov b, a
  ; 306 j = (b->fattrib&0x10);Сложение
  lhld cmpFileInfo_2
  lxi d, 11
  dad d
  mov a, m
  ani 16
  mov c, a
  ; 307 if(i<j) return 1;
  mov a, c
  cmp b
  jc l57
  jz l57
  ; 307 return 1;
  mvi a, 1
  pop b
  ret
l57:
  ; 308 if(j<i) return 0;
  mov a, c
  cmp b
  jnc l58
  ; 308 return 0;
  xra a
  pop b
  ret
l58:
  ; 309 if(1==memcmp(a->fname, b->fname, sizeof(a->fname))) return 1;
  lhld cmpFileInfo_1
  shld memcmp_1
  lhld cmpFileInfo_2
  shld memcmp_2
  lxi h, 11
  call memcmp
  cpi 1
  jnz l59
  ; 309 return 1;
  mvi a, 1
  pop b
  ret
l59:
  ; 310 return 0;
  xra a
  pop b
  ret
  ; --- sort -----------------------------------------------------------------
sort:
  shld sort_2
  ; 317 st_;<st>
  lxi h, sort_st_
  shld sort_st
  ; 318 0;<stc>
  xra a
  sta sort_stc
  ; 319 while(1) {
l60:
  ; 320 i = low;
  lhld sort_1
  shld sort_i
  ; 321 j = high;
  lhld sort_2
  shld sort_j
  ; 322 x = low + (high-low)/2;16 битная арифметическая операция с константой
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
  ; 323 while(1) {
l62:
  ; 324 while(0!=cmpFileInfo(x, i)) i++;
l64:
  lhld sort_x
  shld cmpFileInfo_1
  lhld sort_i
  call cmpFileInfo
  ora a
  jz l65
  ; 324 i++;
  lhld sort_i
  push h
  lxi d, 20
  dad d
  shld sort_i
  pop h
  jmp l64
l65:
  ; 325 while(0!=cmpFileInfo(j, x)) j--;
l66:
  lhld sort_j
  shld cmpFileInfo_1
  lhld sort_x
  call cmpFileInfo
  ora a
  jz l67
  ; 325 j--;
  lhld sort_j
  push h
  lxi d, 65516
  dad d
  shld sort_j
  pop h
  jmp l66
l67:
  ; 326 if(i <= j) {
  lhld sort_i
  xchg
  lhld sort_j
  call op_cmp16
  jc l68
  ; 327 memswap(i, j, sizeof(FileInfo));
  lhld sort_i
  shld memswap_1
  lhld sort_j
  shld memswap_2
  lxi h, 20
  call memswap
  ; 328 if(x==i) x=j; else if(x==j) x=i;
  lhld sort_x
  xchg
  lhld sort_i
  call op_cmp16
  jnz l69
  ; 328 x=j; else if(x==j) x=i;
  lhld sort_j
  shld sort_x
  jmp l70
l69:
  ; 328 if(x==j) x=i;
  lhld sort_x
  xchg
  lhld sort_j
  call op_cmp16
  jnz l71
  ; 328 x=i;
  lhld sort_i
  shld sort_x
l71:
l70:
  ; 329 i++; j--;   
  lhld sort_i
  push h
  lxi d, 20
  dad d
  shld sort_i
  pop h
  ; 329 j--;   
  lhld sort_j
  push h
  lxi d, 65516
  dad d
  shld sort_j
  pop h
l68:
  ; 331 if(j<=i) break;
  lhld sort_j
  xchg
  lhld sort_i
  call op_cmp16
  jnc l63
  jmp l62
l63:
  ; 333 if(i < high) {
  lhld sort_i
  xchg
  lhld sort_2
  call op_cmp16
  jc l73
  jz l73
  ; 334 if(low < j) if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
  lhld sort_1
  xchg
  lhld sort_j
  call op_cmp16
  jc l74
  jz l74
  ; 334 if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
  lda sort_stc
  cpi 32
  jz l75
  ; 334 *st = low, ++st, *st = j, ++st, ++stc;
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
l75:
l74:
  ; 335 low = i; 
  lhld sort_i
  shld sort_1
  ; 336 continue;
  jmp l60
l73:
  ; 338 if(low < j) { 
  lhld sort_1
  xchg
  lhld sort_j
  call op_cmp16
  jc l76
  jz l76
  ; 339 high = j;
  lhld sort_j
  shld sort_2
  ; 340 continue; 
  jmp l60
l76:
  ; 342 if(stc==0) break;
  lda sort_stc
  ora a
  jz l61
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
  jmp l60
l61:
  ret
  ; --- packName -----------------------------------------------------------------
packName:
  push b
  shld packName_2
  ; 352 memset(buf, ' ', 11);    
  lhld packName_1
  shld memset_1
  mvi a, 32
  sta memset_2
  lxi h, 11
  call memset
  ; 354 i = 8;
  mvi a, 8
  sta packName_i
  ; 355 f = '.';
  mvi c, 46
  ; 356 for(;;) {
l78:
  ; 357 c = *path;
  lhld packName_2
  mov b, m
  ; 358 if(c == 0) return;
  xra a
  cmp b
  jnz l81
  ; 358 return;
  pop b
  ret
l81:
  ; 359 ++path;
  inx h
  shld packName_2
  ; 360 if(c == f) { buf += i; i = 3; f = 0; continue; }
  mov a, c
  cmp b
  jnz l82
  ; 360 buf += i; i = 3; f = 0; continue; }Сложение
  lhld packName_i
  mvi h, 0
  xchg
  lhld packName_1
  dad d
  shld packName_1
  ; 360 i = 3; f = 0; continue; }
  mvi a, 3
  sta packName_i
  ; 360 f = 0; continue; }
  mov c, d
  ; 360 continue; }
  jmp l80
l82:
  ; 361 if(i) { *buf = c; ++buf; --i; }convertToConfition
  lda packName_i
  ora a
  jz l83
  ; 361 *buf = c; ++buf; --i; }
  lhld packName_1
  mov m, b
  ; 361 ++buf; --i; }
  lhld packName_1
  inx h
  shld packName_1
  ; 361 --i; }
  lxi h, packName_i
  dcr m
l83:
l80:
  jmp l78
l79:
  pop b
  ret
  ; --- getFiles -----------------------------------------------------------------
getFiles:
  call hideTextCursor
  ; 378 panelA.cnt = 0;
  lxi h, 0
  shld (panelA)+(262)
  ; 379 panelA.offset = 0;
  shld (panelA)+(260)
  ; 380 panelA.cursorX = 0;
  xra a
  sta (panelA)+(258)
  ; 381 panelA.cursorY = 0;
  sta (panelA)+(259)
  ; 383 f = panelA.files1;
  lhld panelA
  shld getFiles_f
  ; 386 if(panelA.path1[0]) {convertToConfition
  lda ((panelA)+(2))+(0)
  ora a
  jz l84
  ; 387 memcpy(f, parentDir, sizeof(FileInfo));
  shld memcpy_1
  lxi h, parentDir
  shld memcpy_2
  lxi h, 20
  call memcpy
  ; 388 ++f;
  lhld getFiles_f
  lxi d, 20
  dad d
  shld getFiles_f
  ; 389 ++panelA.cnt;    
  lhld (panelA)+(262)
  inx h
  shld (panelA)+(262)
l84:
  ; 392 st = f;
  lhld getFiles_f
  shld getFiles_st
  ; 393 for(;;) {
l85:
  ; 394 i = fs_findfirst(panelA.path1, f, maxFiles-panelA.cnt);  
  lxi h, (panelA)+(2)
  shld fs_findfirst_1
  lhld getFiles_f
  shld fs_findfirst_2
  ; 16 битная арифметическая операция с константой
  lhld (panelA)+(262)
  xchg
  lhld maxFiles
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  call fs_findfirst
  sta getFiles_i
  ; 395 if(i==ERR_MAX_FILES) i=0; //! Вывести бы ошибки
  cpi 10
  jnz l88
  ; 395 i=0; //! Вывести бы ошибки
  xra a
  sta getFiles_i
l88:
  ; 396 if(i==0) break;    
  ora a
  jz l86
  lda ((panelA)+(2))+(0)
  ora a
  jnz l90
  ; 397 return; //! Вывести бы ошибки
  ret
l90:
  ; 398 panelA.path1[0] = 0;
  xra a
  sta ((panelA)+(2))+(0)
l87:
  jmp l85
l86:
  ; 401 f += fs_low;
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
  ; 402 panelA.cnt += fs_low;Сложение
  lhld fs_low
  xchg
  lhld (panelA)+(262)
  dad d
  shld (panelA)+(262)
  ; 404 for(j=panelA.cnt, f=panelA.files1; j; --j, ++f) { 
  shld getFiles_j
  lhld panelA
  shld getFiles_f
l91:
  ; convertToConfition
  lhld getFiles_j
  mov a, l
  ora h
  jz l92
  ; 405 f->fattrib &= 0x7F;Сложение
  lhld getFiles_f
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
  ; 406 n=f->fname;
  lhld getFiles_f
  shld getFiles_n
  ; 407 for(i=12; i; --i, ++n)
  mvi a, 12
  sta getFiles_i
l94:
  ; convertToConfition
  lda getFiles_i
  ora a
  jz l95
  ; 408 if((uchar)*n>='a' && (uchar)*n<='z')
  mov a, m
  cpi 97
  jc l97
  mov a, m
  cpi 122
  jz l98
  jnc l97
l98:
  ; 409 *n = *n-('a'-'A');Арифметика 9/3
  lhld getFiles_n
  mov a, m
  sui 32
  mov m, a
l97:
l96:
  lxi h, getFiles_i
  dcr m
  lhld getFiles_n
  inx h
  shld getFiles_n
  jmp l94
l95:
l93:
  lhld getFiles_j
  dcx h
  shld getFiles_j
  lhld getFiles_f
  lxi d, 20
  dad d
  shld getFiles_f
  jmp l91
l92:
  ; 412 if(panelA.cnt > 1)Сложение с константой -2
  lhld (panelA)+(262)
  dcx h
  dcx h
  jz l100
  jnc l99
l100:
  ; 413 sort(st, ((FileInfo*)panelA.files1) + (panelA.cnt-1));
  lhld getFiles_st
  shld sort_1
  ; Сложение с константой -1
  lhld (panelA)+(262)
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
l99:
  ret
  ; --- selectFile -----------------------------------------------------------------
selectFile:
  push b
  shld selectFile_1
  ; 421 for(l=0, f=panelA.files1; l<panelA.cnt; ++l, ++f) {
  lxi b, 0
  lhld panelA
  shld selectFile_f
l101:
  lhld (panelA)+(262)
  mov d, b
  mov e, c
  call op_cmp16
  jc l102
  jz l102
  ; 422 if(0==memcmp(f->fname, sfile, 11)) {
  lhld selectFile_f
  shld memcmp_1
  lhld selectFile_1
  shld memcmp_2
  lxi h, 11
  call memcmp
  ora a
  jnz l104
  ; 424 if(l>=2*ROWS_CNT) {Сложение с BC
  lxi h, 65492
  dad b
  jnc l105
  ; 425 panelA.offset = l-ROWS_CNT-(l%ROWS_CNT);Сложение с BC
  lxi h, 65514
  dad b
  lxi d, 22
  push h
  mov h, b
  mov l, c
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
  shld (panelA)+(260)
  ; 426 l-=panelA.offset;Арифметическая операция с BC&
  mov a, c
  sub l
  mov c, a
  mov a, h
  sbb h
  mov b, a
l105:
  ; 429 panelA.cursorX = l/ROWS_CNT;
  lxi d, 22
  mov h, b
  mov l, c
  call op_div16
  mov a, l
  sta (panelA)+(258)
  ; 430 panelA.cursorY = op_div16_mod;
  lda op_div16_mod
  sta (panelA)+(259)
  ; 431 break;
  jmp l102
l104:
l103:
  inx b
  lhld selectFile_f
  lxi d, 20
  dad d
  shld selectFile_f
  jmp l101
l102:
  pop b
  ret
  ; --- reloadFiles -----------------------------------------------------------------
reloadFiles:
  shld reloadFiles_1
  ; 441 drawPanelTitle(1);   
  mvi a, 1
  call drawPanelTitle
  ; 442 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ; 445 getFiles();
  call getFiles
  ; 448 drawPanelTitle(1);   
  mvi a, 1
  call drawPanelTitle
  ; 449 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ; 452 if(sfile) {convertToConfition
  lhld reloadFiles_1
  mov a, l
  ora h
  jz l106
  ; 453 selectFile(sfile);
  call selectFile
l106:
  ; 457 drawFilesCount();
  call drawFilesCount
  ; 458 drawFiles();
  call drawFiles
  ; 459 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  ; 462 drawCmdLine(); 
  jmp drawCmdLine
absolutePath:
  shld absolutePath_1
  ; 472 if(str[0] == '/') {Сложение с константой 0
  mov a, m
  cpi 47
  jnz l107
  ; 473 strcpy(str, str+1);
  shld strcpy_1
  ; Сложение с константой 1
  lhld absolutePath_1
  inx h
  call strcpy
  ; 474 return 1;
  mvi a, 1
  ret
l107:
  ; 478 l = strlen(panelA.path1);
  lxi h, (panelA)+(2)
  call strlen
  shld absolutePath_l
  ; 481 if(l != 0) l++;Сложение с константой 0
  mov a, l
  ora h
  jz l108
  ; 481 l++;
  mov d, h
  mov e, l
  inx h
  shld absolutePath_l
  xchg
l108:
  ; 484 if(strlen(str) + l >= 255) return 0;
  lhld absolutePath_1
  call strlen
  ; Сложение
  xchg
  lhld absolutePath_l
  dad d
  ; Сложение
  lxi d, 65281
  dad d
  jnc l109
  ; 484 return 0;
  xra a
  ret
l109:
  ; 487 memcpy_back(str+l, str, strlen(str)+1);Сложение
  lhld absolutePath_1
  xchg
  lhld absolutePath_l
  dad d
  shld memcpy_back_1
  lhld absolutePath_1
  shld memcpy_back_2
  lhld absolutePath_1
  call strlen
  ; Сложение с константой 1
  inx h
  call memcpy_back
  ; 488 memcpy(str, panelA.path1, l);
  lhld absolutePath_1
  shld memcpy_1
  lxi h, (panelA)+(2)
  shld memcpy_2
  lhld absolutePath_l
  call memcpy
  ; 491 if(l != 0) str[l-1] = '/';Сложение с константой 0
  lhld absolutePath_l
  mov a, l
  ora h
  jz l110
  ; 491 str[l-1] = '/';Сложение с константой -1
  dcx h
  ; Сложение
  xchg
  lhld absolutePath_1
  dad d
  mvi m, 47
l110:
  ; 493 return 1;
  mvi a, 1
  ret
  ; --- getName -----------------------------------------------------------------
getName:
  shld getName_1
  ; 500 for(p = name; *p; p++)
  shld getName_p
l111:
  ; convertToConfition
  lhld getName_p
  xra a
  ora m
  jz l112
  ; 501 if(*p == '/')
  mov a, m
  cpi 47
  jnz l114
  ; 502 name = p+1;Сложение с константой 1
  inx h
  shld getName_1
l114:
l113:
  lhld getName_p
  mov d, h
  mov e, l
  inx h
  shld getName_p
  xchg
  jmp l111
l112:
  ; 503 return name;
  lhld getName_1
  ret
  ; --- dropPathInt -----------------------------------------------------------------
dropPathInt:
  shld dropPathInt_2
  ; 513 p = getname(src);
  lhld dropPathInt_1
  call getName
  shld dropPathInt_p
  ; 516 if(preparedName) packName(preparedName, p);convertToConfition
  lhld dropPathInt_2
  mov a, l
  ora h
  jz l115
  ; 516 packName(preparedName, p);
  shld packName_1
  lhld dropPathInt_p
  call packName
l115:
  ; 519 if(p != src) --p;
  lhld dropPathInt_p
  xchg
  lhld dropPathInt_1
  call op_cmp16
  jz l116
  ; 519 --p;
  lhld dropPathInt_p
  dcx h
  shld dropPathInt_p
l116:
  ; 520 *p = 0;
  lhld dropPathInt_p
  mvi m, 0
  ret
  ; --- dropPath -----------------------------------------------------------------
dropPath:
  lxi h, (panelA)+(2)
  shld dropPathInt_1
  lxi h, dropPath_buf
  call dropPathInt
  ; 529 reloadFiles(buf);
  lxi h, dropPath_buf
  jmp reloadFiles
cursor_left:
  lda (panelA)+(258)
  ora a
  jz l117
  ; 537 --panelA.cursorX; 
  lxi h, (panelA)+(258)
  dcr m
  jmp l118
l117:
  ; 539 if(panelA.offset) { convertToConfition
  lhld (panelA)+(260)
  mov a, l
  ora h
  jz l119
  ; 540 if(ROWS_CNT > panelA.offset) { Сложение
  lxi d, 65514
  dad d
  jc l120
  jz l120
  ; 541 panelA.offset = 0; 
  lxi h, 0
  shld (panelA)+(260)
  ; 542 drawFiles();
  call drawFiles
  jmp l121
l120:
  ; 544 panelA.offset -= ROWS_CNT; 16 битная арифметическая операция с константой
  lhld (panelA)+(260)
  mov a, l
  sui 22
  mov l, a
  mov a, h
  sbi 0
  mov h, a
  shld (panelA)+(260)
  ; 545 drawFiles();
  call drawFiles
l121:
  jmp l122
l119:
  ; 548 if(panelA.cursorY) {convertToConfition
  lda (panelA)+(259)
  ora a
  jz l123
  ; 549 panelA.cursorY = 0; 
  xra a
  sta (panelA)+(259)
l123:
l122:
l118:
  ; 552 showFileCursorAndDrawFileInfo();
  jmp showFileCursorAndDrawFileInfo
cursor_right:
  lhld (panelA)+(260)
  xchg
  lhld (panelA)+(259)
  mvi h, 0
  dad d
  push h
  mvi d, 22
  lda (panelA)+(258)
  call op_mul
  ; Сложение
  pop d
  dad d
  shld cursor_right_w
  ; 563 if(w + ROWS_CNT >= panelA.cnt) { //! перепутаны > и >=Сложение
  lxi d, 22
  dad d
  xchg
  lhld (panelA)+(262)
  call op_cmp16
  jz l125
  jnc l124
l125:
  ; 565 if(w + 1 >= panelA.cnt) { Сложение с константой 1
  lhld cursor_right_w
  inx h
  xchg
  lhld (panelA)+(262)
  call op_cmp16
  jz l127
  jnc l126
l127:
  ; 566 return;
  ret
l126:
  ; 569 panelA.cursorY = panelA.cnt - (panelA.offset + panelA.cursorX*ROWS_CNT + 1);
  mvi d, 22
  lda (panelA)+(258)
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(260)
  dad d
  ; Сложение с константой 1
  inx h
  ; 16 битная арифметическая операция с константой
  xchg
  lhld (panelA)+(262)
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  mov a, l
  sta (panelA)+(259)
  ; 571 if(panelA.cursorY>ROWS_CNT-1) {
  cpi 21
  jc l128
  jz l128
  ; 572 panelA.cursorY -= ROWS_CNT;Арифметика 4/3
  sui 22
  sta (panelA)+(259)
  ; 573 if(panelA.cursorX == 1) { 
  lda (panelA)+(258)
  cpi 1
  jnz l129
  ; 574 panelA.offset += ROWS_CNT;Сложение
  lxi d, 22
  lhld (panelA)+(260)
  dad d
  shld (panelA)+(260)
  ; 575 drawFiles();
  call drawFiles
  jmp l130
l129:
  ; 577 panelA.cursorX++; 
  lxi h, (panelA)+(258)
  inr m
l130:
l128:
  jmp l131
l124:
  ; 581 if(panelA.cursorX == 1) { 
  lda (panelA)+(258)
  cpi 1
  jnz l132
  ; 582 panelA.offset += ROWS_CNT;Сложение
  lxi d, 22
  lhld (panelA)+(260)
  dad d
  shld (panelA)+(260)
  ; 583 drawFiles();
  call drawFiles
  jmp l133
l132:
  ; 585 panelA.cursorX++;
  lxi h, (panelA)+(258)
  inr m
l133:
l131:
  ; 588 showFileCursorAndDrawFileInfo();
  jmp showFileCursorAndDrawFileInfo
cursor_up:
  lda (panelA)+(259)
  ora a
  jz l134
  ; 596 --panelA.cursorY;
  lxi h, (panelA)+(259)
  dcr m
  jmp l135
l134:
  ; 598 if(panelA.cursorX) { convertToConfition
  lda (panelA)+(258)
  ora a
  jz l136
  ; 599 --panelA.cursorX;
  lxi h, (panelA)+(258)
  dcr m
  ; 600 panelA.cursorY = ROWS_CNT-1; 
  mvi a, 21
  sta (panelA)+(259)
  jmp l137
l136:
  ; 602 if(panelA.offset) {convertToConfition
  lhld (panelA)+(260)
  mov a, l
  ora h
  jz l138
  ; 603 --panelA.offset; 
  dcx h
  shld (panelA)+(260)
  ; 604 drawFiles();
  call drawFiles
l138:
l137:
l135:
  ; 607 showFileCursorAndDrawFileInfo();
  jmp showFileCursorAndDrawFileInfo
cursor_down:
  mvi d, 22
  lda (panelA)+(258)
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(260)
  dad d
  ; Сложение
  xchg
  lhld (panelA)+(259)
  mvi h, 0
  dad d
  ; Сложение с константой 1
  inx h
  xchg
  lhld (panelA)+(262)
  call op_cmp16
  jz l140
  jnc l139
l140:
  ; 614 return;
  ret
l139:
  ; 616 if(panelA.cursorY < ROWS_CNT-1) {
  lda (panelA)+(259)
  cpi 21
  jnc l141
  ; 617 ++panelA.cursorY;
  lxi h, (panelA)+(259)
  inr m
  jmp l142
l141:
  ; 619 if(panelA.cursorX == 0) {
  lda (panelA)+(258)
  ora a
  jnz l143
  ; 620 panelA.cursorY = 0;
  xra a
  sta (panelA)+(259)
  ; 621 ++panelA.cursorX; 
  lxi h, (panelA)+(258)
  inr m
  jmp l144
l143:
  ; 623 ++panelA.offset; 
  lhld (panelA)+(260)
  inx h
  shld (panelA)+(260)
  ; 624 drawFiles();
  call drawFiles
l144:
l142:
  ; 627 showFileCursorAndDrawFileInfo();
  jmp showFileCursorAndDrawFileInfo
cmd_tab:
  call hideFileCursor
  ; 635 drawPanelTitle(0);
  xra a
  call drawPanelTitle
  ; 636 swapPanels();
  call swapPanels
  ; 637 showFileCursor();
  call showFileCursor
  ; 638 drawPanelTitle(1);
  mvi a, 1
  call drawPanelTitle
  ; 639 drawCmdLineWithPath();
  jmp drawCmdLineWithPath
runCmdLine:
  push b
  ; 649 if(!absolutePath(cmdline)) return;
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l145
  ; 649 return;
  pop b
  ret
l145:
  ; 652 cmdLine2 = strchr(cmdLine, ' ');
  lxi h, cmdline
  shld strchr_1
  mvi a, 32
  call strchr
  mov b, h
  mov c, l
  ; 653 if(cmdLine2) {convertToConfition
  mov a, l
  ora h
  jz l146
  ; 654 *cmdLine2 = 0;
  xra a
  stax b
  ; 655 ++cmdLine2;
  inx b
  jmp l147
l146:
  ; 657 cmdLine2 = "";
  lxi b, string13
l147:
  ; 661 run(cmdLine, cmdLine2);
  lxi h, cmdline
  shld run_1
  mov h, b
  mov l, c
  call run
  pop b
  ret
  ; --- dupFiles -----------------------------------------------------------------
dupFiles:
  sta dupFiles_1
  ; 667 swapPanels();
  call swapPanels
  ; 669 if(0==strcmp(panelA.path1, panelB.path1)) {
  lxi h, (panelA)+(2)
  shld strcmp_1
  lxi h, (panelB)+(2)
  call strcmp
  ora a
  jnz l148
  ; 670 memcpy(panelA.files1, panelB.files1, maxFiles*sizeof(FileInfo));
  lhld panelA
  shld memcpy_1
  lhld panelB
  shld memcpy_2
  lhld maxFiles
  lxi d, 20
  call op_mul16
  call memcpy
  ; 671 panelA.cnt = panelB.cnt;    
  lhld (panelB)+(262)
  shld (panelA)+(262)
  jmp l149
l148:
  ; 674 if(reload) getFiles();convertToConfition
  lda dupFiles_1
  ora a
  cnz getFiles
l149:
  ; 677 getSel();
  call getSel
  ; 678 swapPanels();
  jmp swapPanels
loadState:
  lhld fs_selfName
  call strlen
  shld loadState_i
  ; 686 if(i < 4) return;Сложение
  lxi d, 65531
  dad d
  jc l151
  ; 686 return;
  ret
l151:
  ; 687 i -= 3;16 битная арифметическая операция с константой
  lhld loadState_i
  mov a, l
  sui 3
  mov l, a
  mov a, h
  sbi 0
  mov h, a
  shld loadState_i
  ; 688 if(0 != strcmp(fs_selfName + i, ".RK")) return;Сложение
  lhld fs_selfName
  xchg
  lhld loadState_i
  dad d
  shld strcmp_1
  lxi h, string14
  call strcmp
  ora a
  jz l152
  ; 688 return;
  ret
l152:
  ; 689 strcpy(fs_selfName + i, ".IN");Сложение
  lhld fs_selfName
  xchg
  lhld loadState_i
  dad d
  shld strcpy_1
  lxi h, string15
  call strcpy
  ; 691 if(fs_open(fs_selfName)) return;
  lhld fs_selfName
  call fs_open
  ; convertToConfition
  ora a
  jz l153
  ; 691 return;
  ret
l153:
  ; 692 fs_read(cmdline, 12);
  lxi h, cmdline
  shld fs_read_1
  lxi h, 12
  call fs_read
  ; 693 if(cmdline[11]) swapPanels();convertToConfition
  lda (cmdline)+(11)
  ora a
  cnz swapPanels
  lxi h, (panelA)+(2)
  shld fs_read_1
  lxi h, 256
  call fs_read
  ; 694 panelA.path1[255] = 0;
  xra a
  sta ((panelA)+(2))+(255)
  ; 695 fs_read(panelB.path1, 256); panelB.path1[255] = 0;
  lxi h, (panelB)+(2)
  shld fs_read_1
  lxi h, 256
  call fs_read
  ; 695 panelB.path1[255] = 0;
  xra a
  sta ((panelB)+(2))+(255)
  ret
  ; --- saveState -----------------------------------------------------------------
saveState:
  lhld fs_selfName
  call fs_create
  ; convertToConfition
  ora a
  jz l155
  lhld fs_selfName
  call fs_open
  ; convertToConfition
  ora a
  jz l155
  ; 701 return;
  ret
l155:
  ; 702 fs_write(getSel()->fname, 11);
  call getSel
  shld fs_write_1
  lxi h, 11
  call fs_write
  ; 703 fs_write(&activePanel, 1);
  lxi h, activePanel
  shld fs_write_1
  lxi h, 1
  call fs_write
  ; 704 fs_write(panelA.path1, 256);
  lxi h, (panelA)+(2)
  shld fs_write_1
  lxi h, 256
  call fs_write
  ; 705 fs_write(panelB.path1, 256);
  lxi h, (panelB)+(2)
  shld fs_write_1
  lxi h, 256
  jmp fs_write
run:
  shld run_2
  ; 713 saveState();
  call saveState
  ; 714 drawError(prog, fs_exec(prog, cmdLine)); 
  lhld run_1
  shld drawError_1
  lhld run_1
  shld fs_exec_1
  lhld run_2
  call fs_exec
  call drawError
  ; 715 drawScreen(); // Там происходит очистка ком строки
  jmp drawScreen
cmd_editview:
  shld cmd_editview_1
  ; 721 getSel();<f>
  call getSel
  shld cmd_editview_f
  ; 722 if(f->fattrib & 0x10) return;Сложение
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l156
  ; 722 return;
  ret
l156:
  ; 723 unpackName(cmdLine, f->fname);
  lxi h, cmdline
  shld unpackName_1
  lhld cmd_editview_f
  call unpackName
  ; 724 if(!absolutePath(cmdLine)) {
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l157
  ; 725 drawScreen();
  jmp drawScreen
  ; 726 return;
l157:
  ; 728 run(app, cmdLine);
  lhld cmd_editview_1
  shld run_1
  lxi h, cmdline
  jmp run
cmd_enter:
  lda (cmdline)+(0)
  ora a
  jz l158
  ; 740 runCmdLine(); // Функция восстановит экран
  jmp runCmdLine
  ; 741 return;
l158:
  ; 745 f = getSelNoBack();
  call getSelNoBack
  shld cmd_enter_f
  ; 748 if(f == 0) { Сложение с константой 0
  mov a, l
  ora h
  jnz l159
  ; 749 dropPath(); 
  jmp dropPath
  ; 750 return; 
l159:
  ; 754 unpackName(cmdLine, f->fname);
  lxi h, cmdline
  shld unpackName_1
  lhld cmd_enter_f
  call unpackName
  ; 755 if(!absolutePath(cmdLine)) { drawScreen(); return; }
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l160
  ; 755 drawScreen(); return; }
  jmp drawScreen
  ; 755 return; }
l160:
  ; 758 if((f->fattrib & 0x10) != 0) { Сложение
  lhld cmd_enter_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jz l161
  ; 759 strcpy(panelA.path1, cmdline);
  lxi h, (panelA)+(2)
  shld strcpy_1
  lxi h, cmdline
  call strcpy
  ; 760 cmdline[0] = 0;
  xra a
  sta (cmdline)+(0)
  ; 761 reloadFiles(0);
  lxi h, 0
  jmp reloadFiles
  ; 762 return;
l161:
  ; 766 run(cmdline, "");
  lxi h, cmdline
  shld run_1
  lxi h, string13
  jmp run
cmd_esc:
  lda (cmdline)+(0)
  ora a
  jz l162
  ; 773 cmdline[0] = 0;
  xra a
  sta (cmdline)+(0)
  ; 774 drawCmdLine();
  jmp drawCmdLine
  ; 775 return;
l162:
  ; 777 dropPath();
  jmp dropPath
cmd_inverseOne:
  call getSelNoBack
  shld cmd_inverseOne_f
  ; 784 if(!f) return;convertToConfition
  mov a, l
  ora h
  jnz l163
  ; 784 return;
  ret
l163:
  ; 785 f->fattrib ^= 0x80;Сложение
  lxi d, 11
  dad d
  mov a, m
  xri 128
  mov m, a
  ; 786 drawFile(panelA.cursorX, panelA.cursorY, f);
  lda (panelA)+(258)
  sta drawFile_1
  lda (panelA)+(259)
  sta drawFile_2
  lhld cmd_inverseOne_f
  call drawFile
  ; 787 cursor_down();
  jmp cursor_down
cmd_inverseAll:
  lhld panelA
  shld cmd_inverseAll_f
  lhld (panelA)+(262)
  shld cmd_inverseAll_i
l164:
  ; convertToConfition
  lhld cmd_inverseAll_i
  mov a, l
  ora h
  jz l165
  ; 796 if(f->fattrib & 0x10) {Сложение
  lhld cmd_inverseAll_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l167
  ; 797 f->fattrib &= 0x7F;Сложение
  lhld cmd_inverseAll_f
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
  jmp l168
l167:
  ; 799 f->fattrib ^= 0x80;Сложение
  lhld cmd_inverseAll_f
  lxi d, 11
  dad d
  mov a, m
  xri 128
  mov m, a
l168:
l166:
  lhld cmd_inverseAll_i
  dcx h
  shld cmd_inverseAll_i
  lhld cmd_inverseAll_f
  lxi d, 20
  dad d
  shld cmd_inverseAll_f
  jmp l164
l165:
  ; 802 drawFiles();
  call drawFiles
  ; 803 showFileCursor();
  jmp showFileCursor
main:
  push b
  ; 813 fs_init();
  call fs_init
  ; 816 drawInit();  
  call drawInit
  ; 819 panelA.files1 = ((FileInfo*)START_FILE_BUFFER);
  lxi h, 13312
  shld panelA
  ; 820 panelB.files1 = ((FileInfo*)START_FILE_BUFFER)+maxFiles;
  lhld maxFiles
  ; Умножение HL на 20
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  ; Сложение
  lxi d, 13312
  dad d
  shld panelB
  ; 823 panelA.path1[0] = 0;
  xra a
  sta ((panelA)+(2))+(0)
  ; 824 panelB.path1[0] = 0;
  sta ((panelB)+(2))+(0)
  ; 827 cmdline[0] = 0;
  sta (cmdline)+(0)
  ; 830 drawScreenInt();
  call drawScreenInt
  ; 831 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ; 834 loadState();
  call loadState
  ; 837 getFiles();
  call getFiles
  ; 840 dupFiles(1);
  mvi a, 1
  call dupFiles
  ; 843 selectFile(cmdline);
  lxi h, cmdline
  call selectFile
  ; 844 cmdline[0] = 0;
  xra a
  sta (cmdline)+(0)
  ; 847 drawPanelTitle(1);
  inr a
  call drawPanelTitle
  ; 848 swapPanels();
  call swapPanels
  ; 849 drawPanelTitle(0);
  xra a
  call drawPanelTitle
  ; 850 swapPanels();
  call swapPanels
  ; 851 drawFiles2();
  call drawFiles2
  ; 852 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ; 855 while(1) {
l169:
  ; 856 c = getch1();
  call getch1
  mov b, a
  ; 858 switch(c) {
  mov a, b
  ora a
  jz l172
  cpi 1
  jz l173
  cpi 2
  jz l174
  cpi 3
  jz l175
  cpi 13
  jz l176
  cpi 27
  jz l177
  cpi 8
  jz l178
  cpi 24
  jz l179
  cpi 26
  jz l180
  cpi 25
  jz l181
  cpi 9
  jz l182
  jmp l171
l172:
  ; 859 cmd_freespace();         continue;
  call cmd_freespace
  ; 859 continue;
  jmp l169
l173:
  ; 860 cmd_new(0);              continue;
  xra a
  call cmd_new
  ; 860 continue;
  jmp l169
l174:
  ; 861 cmd_editview(viewerApp); continue;
  lxi h, viewerApp
  call cmd_editview
  ; 861 continue;
  jmp l169
l175:
  ; 862 cmd_editview(editorApp); continue;
  lxi h, editorApp
  call cmd_editview
  ; 862 continue;
  jmp l169
l176:
  ; 863 cmd_enter();             continue;
  call cmd_enter
  ; 863 continue;
  jmp l169
l177:
  ; 864 cmd_esc();               continue;
  call cmd_esc
  ; 864 continue;
  jmp l169
l178:
  ; 865 cursor_left();           continue;
  call cursor_left
  ; 865 continue;
  jmp l169
l179:
  ; 866 cursor_right();          continue; 
  call cursor_right
  ; 866 continue; 
  jmp l169
l180:
  ; 867 cursor_down();           continue;
  call cursor_down
  ; 867 continue;
  jmp l169
l181:
  ; 868 cursor_up();             continue; 
  call cursor_up
  ; 868 continue; 
  jmp l169
l182:
  ; 869 cmd_tab();               continue; 
  call cmd_tab
  ; 869 continue; 
  jmp l169
l171:
  ; 873 if(!cmdLine[0]) {convertToConfition
  lda (cmdline)+(0)
  ora a
  jnz l183
  ; 874 switch(c) {
  mov a, b
  cpi 49
  jz l185
  cpi 50
  jz l186
  cpi 51
  jz l187
  cpi 52
  jz l188
  cpi 37
  jz l189
  cpi 53
  jz l190
  cpi 38
  jz l191
  cpi 54
  jz l192
  cpi 55
  jz l193
  cpi 56
  jz l194
  cpi 31
  jz l195
  cpi 58
  jz l196
  cpi 59
  jz l197
  cpi 45
  jz l198
  jmp l184
l185:
  ; 875 cmd_freespace();         continue;
  call cmd_freespace
  ; 875 continue;
  jmp l169
l186:
  ; 876 cmd_new(0);              continue;
  xra a
  call cmd_new
  ; 876 continue;
  jmp l169
l187:
  ; 877 cmd_editview(viewerApp); continue;
  lxi h, viewerApp
  call cmd_editview
  ; 877 continue;
  jmp l169
l188:
  ; 878 cmd_editview(editorApp); continue;
  lxi h, editorApp
  call cmd_editview
  ; 878 continue;
  jmp l169
l189:
  ; 879 cmd_copymove(1, 1);      continue;
  mvi a, 1
  sta cmd_copymove_1
  call cmd_copymove
  ; 879 continue;
  jmp l169
l190:
  ; 880 cmd_copymove(1, 0);      continue;
  mvi a, 1
  sta cmd_copymove_1
  xra a
  call cmd_copymove
  ; 880 continue;
  jmp l169
l191:
  ; 881 cmd_copymove(0, 1);      continue;
  xra a
  sta cmd_copymove_1
  inr a
  call cmd_copymove
  ; 881 continue;
  jmp l169
l192:
  ; 882 cmd_copymove(0, 0);      continue;
  xra a
  sta cmd_copymove_1
  call cmd_copymove
  ; 882 continue;
  jmp l169
l193:
  ; 883 cmd_new(1);              continue;
  mvi a, 1
  call cmd_new
  ; 883 continue;
  jmp l169
l194:
  ; 884 cmd_delete();            continue;
  call cmd_delete
  ; 884 continue;
  jmp l169
l195:
  ; 885 cmd_inverseOne();        continue;
  call cmd_inverseOne
  ; 885 continue;
  jmp l169
l196:
  ; 886 cmd_inverseAll();        continue; // *
  call cmd_inverseAll
  ; 886 continue; // *
  jmp l169
l197:
  ; 887 cmd_sel(1);              continue; // +
  mvi a, 1
  call cmd_sel
  ; 887 continue; // +
  jmp l169
l198:
  ; 888 cmd_sel(0);              continue;
  xra a
  call cmd_sel
  ; 888 continue;
  jmp l169
l184:
l183:
  ; 893 processInput(c);
  mov a, b
  call processInput
  ; 894 drawCmdLine();
  call drawCmdLine
  jmp l169
l170:
  pop b
  ret
  ; --- cmd_copyFile -----------------------------------------------------------------
cmd_copyFile:
  shld cmd_copyFile_2
  ; 10 0;<progress_i>
  xra a
  sta cmd_copyFile_progress_i
  ; 15 if(e = fs_open(from)) return e;
  lhld cmd_copyFile_1
  call fs_open
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l199
  ; 15 return e;
  lda cmd_copyFile_e
  ret
l199:
  ; 16 if(e = fs_getsize()) return e;
  call fs_getsize
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l200
  ; 16 return e;
  lda cmd_copyFile_e
  ret
l200:
  ; 19 set32(&progress_step, &fs_result);
  lxi h, cmd_copyFile_progress_step
  shld set32_1
  lxi h, fs_low
  call set32
  ; 20 div32_16(&progress_step, 40);
  lxi h, cmd_copyFile_progress_step
  shld div32_16_1
  lxi h, 40
  call div32_16
  ; 23 drawWindow(" kopirowanie ");
  lxi h, string16
  call drawWindow
  ; 24 drawWindowText(0, 0, "iz:");
  xra a
  sta drawWindowText_1
  sta drawWindowText_2
  lxi h, string17
  call drawWindowText
  ; 25 drawWindowText(4, 0, from);
  mvi a, 4
  sta drawWindowText_1
  xra a
  sta drawWindowText_2
  lhld cmd_copyFile_1
  call drawWindowText
  ; 26 drawWindowText(0, 1, "w:");
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, string18
  call drawWindowText
  ; 27 drawWindowText(4, 1, to);
  mvi a, 4
  sta drawWindowText_1
  mvi a, 1
  sta drawWindowText_2
  lhld cmd_copyFile_2
  call drawWindowText
  ; 28 drawWindowText(0, 2, "skopirowano           /           bajt");
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, string19
  call drawWindowText
  ; 29 drawWindowProgress(0, 3, 40, '#');
  xra a
  sta drawWindowProgress_1
  mvi a, 3
  sta drawWindowProgress_2
  mvi a, 40
  sta drawWindowProgress_3
  mvi a, 35
  call drawWindowProgress
  ; 30 i2s32(buf, &fs_result, 10, ' ');
  lxi h, cmd_copyFile_buf
  shld i2s32_1
  lxi h, fs_low
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 31 drawWindowText(23, 2, buf);
  mvi a, 23
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, cmd_copyFile_buf
  call drawWindowText
  ; 32 drawEscButton();
  call drawEscButton
  ; 35 if(e = fs_swap()) return e;
  call fs_swap
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l201
  ; 35 return e;
  lda cmd_copyFile_e
  ret
l201:
  ; 36 if(e = fs_create(to)) return e;
  lhld cmd_copyFile_2
  call fs_create
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l202
  ; 36 return e;
  lda cmd_copyFile_e
  ret
l202:
  ; 1 ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  lxi h, 0
  shld (cmd_copyFile_progress)+(0)
  ; 1 ((ushort*)a)[1] = (b>>16); }
  shld (cmd_copyFile_progress)+(2)
  ; 1 ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  shld (cmd_copyFile_progress_x)+(0)
  ; 1 ((ushort*)a)[1] = (b>>16); }
  shld (cmd_copyFile_progress_x)+(2)
  ; 41 for(;;) {
l203:
  ; 43 i2s32(buf, &progress, 10, ' ');
  lxi h, cmd_copyFile_buf
  shld i2s32_1
  lxi h, cmd_copyFile_progress
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 44 drawWindowText(12, 2, buf); 
  mvi a, 12
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, cmd_copyFile_buf
  call drawWindowText
  ; 47 if(e = fs_swap()) return e;
  call fs_swap
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l206
  ; 47 return e;
  lda cmd_copyFile_e
  ret
l206:
  ; 48 if(e = fs_read(panelB.files1, 1024) ) return e;
  lhld panelB
  shld fs_read_1
  lxi h, 1024
  call fs_read
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l207
  ; 48 return e;
  lda cmd_copyFile_e
  ret
l207:
  ; 49 if(fs_low == 0) return 0; // ‘ ЇҐаҐ§ Јаг§Є®© д ©«®ўСложение с константой 0
  lhld fs_low
  mov a, l
  ora h
  jnz l208
  ; 49 return 0; // ‘ ЇҐаҐ§ Јаг§Є®© д ©«®ў
  xra a
  ret
l208:
  ; 50 if(e = fs_swap()) return e;
  call fs_swap
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l209
  ; 50 return e;
  lda cmd_copyFile_e
  ret
l209:
  ; 51 if(e = fs_write(panelB.files1, fs_low)) return e;
  lhld panelB
  shld fs_write_1
  lhld fs_low
  call fs_write
  sta cmd_copyFile_e
  ; convertToConfition
  ora a
  jz l210
  ; 51 return e;
  lda cmd_copyFile_e
  ret
l210:
  ; 54 add32_16(&progress, fs_low);
  lxi h, cmd_copyFile_progress
  shld add32_16_1
  lhld fs_low
  call add32_16
  ; 57 add32_16(&progress_x, fs_low);
  lxi h, cmd_copyFile_progress_x
  shld add32_16_1
  lhld fs_low
  call add32_16
  ; 58 while(progress_i < 40 && cmp32_32(&progress_x, &progress_step) != 1) {
l211:
  lda cmd_copyFile_progress_i
  cpi 40
  jnc l212
  lxi h, cmd_copyFile_progress_x
  shld cmp32_32_1
  lxi h, cmd_copyFile_progress_step
  call cmp32_32
  cpi 1
  jz l212
  ; 59 sub32_32(&progress_x, &progress_step);
  lxi h, cmd_copyFile_progress_x
  shld sub32_32_1
  lxi h, cmd_copyFile_progress_step
  call sub32_32
  ; 60 drawWindowText(progress_i, 3, "\x17");
  lda cmd_copyFile_progress_i
  sta drawWindowText_1
  mvi a, 3
  sta drawWindowText_2
  lxi h, string20
  call drawWindowText
  ; 61 ++progress_i;
  lxi h, cmd_copyFile_progress_i
  inr m
  jmp l211
l212:
  ; 65 if(bioskey1() == KEY_ESC) { e = ERR_USER; break; }
  call bioskey1
  cpi 27
  jnz l213
  ; 65 e = ERR_USER; break; }
  mvi a, 128
  sta cmd_copyFile_e
  ; 65 break; }
  jmp l204
l213:
l205:
  jmp l203
l204:
  ; 69 fs_delete(to);
  lhld cmd_copyFile_2
  call fs_delete
  ; 70 return e;
  lda cmd_copyFile_e
  ret
  ; --- applyMask1 -----------------------------------------------------------------
applyMask1:
  push b
  sta applyMask1_3
  ; 77 for(;;) {
l214:
  ; 78 m = *mask;
  lhld applyMask1_2
  mov b, m
  ; 79 if(m == '*') return;
  mvi a, 42
  cmp b
  jnz l217
  ; 79 return;
  pop b
  ret
l217:
  ; 80 if(m != '?') *dest = m;
  mvi a, 63
  cmp b
  jz l218
  ; 80 *dest = m;
  lhld applyMask1_1
  mov m, b
l218:
  ; 81 --i;
  lxi h, applyMask1_3
  dcr m
  ; 82 if(i==0) return;
  lda applyMask1_3
  ora a
  jnz l219
  ; 82 return;
  pop b
  ret
l219:
  ; 83 ++mask, ++dest;
  lhld applyMask1_2
  inx h
  shld applyMask1_2
  lhld applyMask1_1
  inx h
  shld applyMask1_1
l216:
  jmp l214
l215:
  pop b
  ret
  ; --- cmd_copyFolder -----------------------------------------------------------------
cmd_copyFolder:
  shld cmd_copyFolder_2
  ; 94 0;<level>
  xra a
  sta cmd_copyFolder_level
  ; 99 e = fs_mkdir(to); 
  call fs_mkdir
  sta cmd_copyFolder_e
  ; 100 if(e) return e;convertToConfition
  ora a
  jz l220
  ; 100 return e;
  lda cmd_copyFolder_e
  ret
l220:
  ; 102 for(i=0;;++i) {
  lxi h, 0
  shld cmd_copyFolder_i
l221:
  ; 104 if(i == maxFiles) return ERR_MAX_FILES;
  xchg
  lhld maxFiles
  call op_cmp16
  jnz l224
  ; 104 return ERR_MAX_FILES;
  mvi a, 10
  ret
l224:
  ; 108 e = fs_findfirst(from, panelB.files1, i+1);
  lhld cmd_copyFolder_1
  shld fs_findfirst_1
  lhld panelB
  shld fs_findfirst_2
  ; Сложение с константой 1
  lhld cmd_copyFolder_i
  inx h
  call fs_findfirst
  sta cmd_copyFolder_e
  ; 109 if(e != 0 && e != ERR_MAX_FILES) return e; // Њл ўбҐЈ¤  Ўг¤Ґ¬ Ї®«гзЁвм ERR_MAX_FILES
  ora a
  jz l225
  lda cmd_copyFolder_e
  cpi 10
  jz l225
  ; 109 return e; // Њл ўбҐЈ¤  Ўг¤Ґ¬ Ї®«гзЁвм ERR_MAX_FILES
  ret
l225:
  ; 112 if(i >= fs_low) {
  lhld cmd_copyFolder_i
  xchg
  lhld fs_low
  call op_cmp16
  jz l227
  jnc l226
l227:
  ; 114 if(level==0) return 0;
  lda cmd_copyFolder_level
  ora a
  jnz l228
  ; 114 return 0;
  xra a
  ret
l228:
  ; 116 dropPathInt(from, 0);
  lhld cmd_copyFolder_1
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 117 dropPathInt(to, 0);
  lhld cmd_copyFolder_2
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 118 --level;
  lxi h, cmd_copyFolder_level
  dcr m
  ; 119 i = stack[level];
  lhld cmd_copyFolder_level
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, cmd_copyFolder_stack
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  shld cmd_copyFolder_i
  ; 120 continue;
  jmp l223
l226:
  ; 122 f = panelB.files1 + i;
  lhld cmd_copyFolder_i
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
  lhld panelB
  dad d
  shld cmd_copyFolder_f
  ; 125 if(catPathAndUnpack(from, f->fname)) return ERR_RECV_STRING;
  lhld cmd_copyFolder_1
  shld catPathAndUnpack_1
  lhld cmd_copyFolder_f
  call catPathAndUnpack
  ; convertToConfition
  ora a
  jz l229
  ; 125 return ERR_RECV_STRING;
  mvi a, 11
  ret
l229:
  ; 126 if(catPathAndUnpack(to,   f->fname)) return ERR_RECV_STRING;
  lhld cmd_copyFolder_2
  shld catPathAndUnpack_1
  lhld cmd_copyFolder_f
  call catPathAndUnpack
  ; convertToConfition
  ora a
  jz l230
  ; 126 return ERR_RECV_STRING;
  mvi a, 11
  ret
l230:
  ; 129 if(f->fattrib & 0x10) {Сложение
  lhld cmd_copyFolder_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l231
  ; 131 if(level == COPY_STACK-1) return ERR_RECV_STRING;
  lda cmd_copyFolder_level
  cpi 7
  jnz l232
  ; 131 return ERR_RECV_STRING;
  mov a, e
  ret
l232:
  ; 132 stack[level] = i;
  lhld cmd_copyFolder_level
  mov h, d
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, cmd_copyFolder_stack
  dad d
  push h
  lhld cmd_copyFolder_i
  pop d
  xchg
  mov m, e
  inx h
  mov m, d
  dcx h
  ; 133 level++;
  lxi h, cmd_copyFolder_level
  inr m
  ; 135 e = fs_mkdir(to); 
  lhld cmd_copyFolder_2
  call fs_mkdir
  sta cmd_copyFolder_e
  ; 136 if(e) return e;convertToConfition
  ora a
  jz l233
  ; 136 return e;
  lda cmd_copyFolder_e
  ret
l233:
  ; 138 i = -1;
  lxi h, 65535
  shld cmd_copyFolder_i
  ; 139 continue;
  jmp l223
l231:
  ; 143 e = cmd_copyFile(from, to);
  lhld cmd_copyFolder_1
  shld cmd_copyFile_1
  lhld cmd_copyFolder_2
  call cmd_copyFile
  sta cmd_copyFolder_e
  ; 146 dropPathInt(from, 0);
  lhld cmd_copyFolder_1
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 147 dropPathInt(to, 0);
  lhld cmd_copyFolder_2
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 150 if(e) return e;convertToConfition
  lda cmd_copyFolder_e
  ora a
  jz l234
  ; 150 return e;
  lda cmd_copyFolder_e
  ret
l234:
l223:
  lhld cmd_copyFolder_i
  inx h
  shld cmd_copyFolder_i
  jmp l221
l222:
  ret
  ; --- applyMask -----------------------------------------------------------------
applyMask:
  shld applyMask_2
  ; 157 applyMask1(dest, mask, 8);
  lhld applyMask_1
  shld applyMask1_1
  lhld applyMask_2
  shld applyMask1_2
  mvi a, 8
  call applyMask1
  ; 158 applyMask1(dest+8, mask+8, 3);Сложение
  lhld applyMask_1
  lxi d, 8
  dad d
  shld applyMask1_1
  ; Сложение
  lhld applyMask_2
  lxi d, 8
  dad d
  shld applyMask1_2
  mvi a, 3
  jmp applyMask1
cmd_copymove1:
  sta cmd_copymove1_2
  ; 173 if(shiftPressed) {convertToConfition
  ora a
  jz l235
  ; 175 f = getSelNoBack();
  call getSelNoBack
  shld cmd_copymove1_f
  ; 176 if(!f) return 0; // ” ©« ­Ґ ўлЎа ­, ўле®¤Ё¬ ЎҐ§ ®иЁЎЄЁconvertToConfition
  mov a, l
  ora h
  jnz l236
  ; 176 return 0; // ” ©« ­Ґ ўлЎа ­, ўле®¤Ё¬ ЎҐ§ ®иЁЎЄЁ
  xra a
  ret
l236:
  ; 177 unpackName(cmdLine, f->fname);
  lxi h, cmdline
  shld unpackName_1
  lhld cmd_copymove1_f
  call unpackName
  jmp l237
l235:
  ; 180 i = strlen(panelB.path1);
  lxi h, (panelB)+(2)
  call strlen
  shld cmd_copymove1_i
  ; 181 if(i >= 254) return ERR_RECV_STRING; // ’ Є Є Є ЇаЁЎ ўЁ¬ 2 бЁ¬ў®« Сложение
  lxi d, 65282
  dad d
  jnc l238
  ; 181 return ERR_RECV_STRING; // ’ Є Є Є ЇаЁЎ ўЁ¬ 2 бЁ¬ў®« 
  mvi a, 11
  ret
l238:
  ; 182 cmdLine[0] = '/';
  mvi a, 47
  sta (cmdline)+(0)
  ; 183 strcpy(cmdline+1, panelB.path1);
  lxi h, (cmdline)+(1)
  shld strcpy_1
  lxi h, (panelB)+(2)
  call strcpy
  ; 184 if(i != 0) strcpy(cmdline+i+1, "/");Сложение с константой 0
  lhld cmd_copymove1_i
  mov a, l
  ora h
  jz l239
  ; 184 strcpy(cmdline+i+1, "/");Сложение
  lxi d, cmdline
  dad d
  ; Сложение с константой 1
  inx h
  shld strcpy_1
  lxi h, string21
  call strcpy
l239:
l237:
  ; 188 if(!inputBox(copymode ? " kopirowatx " : " pereimenowatx/peremestitx ") && cmdline[0]!=0) return 0;
  lda cmd_copymove1_1
  ora a
  jz l241
  lxi h, string22
  jmp l242
l241:
  lxi h, string23
l242:
  call inputBox
  ; convertToConfition
  ora a
  jnz l240
  lda (cmdline)+(0)
  ora a
  jz l240
  ; 188 return 0;
  xra a
  ret
l240:
  ; 191 if(!absolutePath(cmdline)) return ERR_RECV_STRING;
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l243
  ; 191 return ERR_RECV_STRING;
  mvi a, 11
  ret
l243:
  ; 194 mask[0] = 0;  
  xra a
  sta (cmd_copymove1_mask)+(0)
  ; 195 name = getname(cmdline);
  lxi h, cmdline
  call getName
  shld cmd_copymove1_name
  ; 196 if(name[0] != 0) {Сложение с константой 0
  mov a, m
  ora a
  jz l244
  ; 198 packName(mask, name);
  lxi h, cmd_copymove1_mask
  shld packName_1
  lhld cmd_copymove1_name
  call packName
  ; 200 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  jmp l245
l244:
  ; 204 if(cmdline[0] != 0 && name[0] == 0) name[-1] = 0;
  lda (cmdline)+(0)
  ora a
  jz l246
  ; Сложение с константой 0
  lhld cmd_copymove1_name
  mov a, m
  ora a
  jnz l246
  ; 204 name[-1] = 0;Сложение с константой -1
  dcx h
  mvi m, 0
l246:
l245:
  ; 208 type = getFirstSelected(sourceFile);
  lxi h, cmd_copymove1_sourceFile
  call getFirstSelected
  sta cmd_copymove1_type
  ; 209 if(type == 0) return 0; // ЌҐв ўлЎа ­­ле д ©«®ў
  ora a
  jnz l247
  ; 209 return 0; // ЌҐв ўлЎа ­­ле д ©«®ў
  xra a
  ret
l247:
  ; 211 for(;;) {
l248:
  ; 213 if(!absolutePath(sourceFile)) { e = ERR_RECV_STRING; break; }
  lxi h, cmd_copymove1_sourceFile
  call absolutePath
  ; convertToConfition
  ora a
  jnz l251
  ; 213 e = ERR_RECV_STRING; break; }
  mvi a, 11
  sta cmd_copymove1_e
  ; 213 break; }
  jmp l249
l251:
  ; 216 packName(forMask, getname(sourceFile));
  lxi h, cmd_copymove1_forMask
  shld packName_1
  lxi h, cmd_copymove1_sourceFile
  call getName
  call packName
  ; 217 if(mask[0]) applyMask(forMask, mask);convertToConfition
  lda (cmd_copymove1_mask)+(0)
  ora a
  jz l252
  ; 217 applyMask(forMask, mask);
  lxi h, cmd_copymove1_forMask
  shld applyMask_1
  lxi h, cmd_copymove1_mask
  call applyMask
l252:
  ; 218 if(catPathAndUnpack(cmdline, forMask)) return ERR_RECV_STRING;
  lxi h, cmdline
  shld catPathAndUnpack_1
  lxi h, cmd_copymove1_forMask
  call catPathAndUnpack
  ; convertToConfition
  ora a
  jz l253
  ; 218 return ERR_RECV_STRING;
  mvi a, 11
  ret
l253:
  ; 221 if(0!=strcmp(sourceFile, cmdline)) {
  lxi h, cmd_copymove1_sourceFile
  shld strcmp_1
  lxi h, cmdline
  call strcmp
  ora a
  jz l254
  ; 223 if(copymode) {convertToConfition
  lda cmd_copymove1_1
  ora a
  jz l255
  ; 224 if(type==2) {
  lda cmd_copymove1_type
  cpi 2
  jnz l256
  ; 225 e = cmd_copyFolder(sourceFile, cmdline);
  lxi h, cmd_copymove1_sourceFile
  shld cmd_copyFolder_1
  lxi h, cmdline
  call cmd_copyFolder
  sta cmd_copymove1_e
  jmp l257
l256:
  ; 227 e = cmd_copyFile(sourceFile, cmdline);
  lxi h, cmd_copymove1_sourceFile
  shld cmd_copyFile_1
  lxi h, cmdline
  call cmd_copyFile
  sta cmd_copymove1_e
l257:
  jmp l258
l255:
  ; 231 drawWindow(" pereimenowanie/pereme}enie ");
  lxi h, string24
  call drawWindow
  ; 232 drawWindowText(0, 1, "iz:");
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, string17
  call drawWindowText
  ; 233 drawWindowText(4, 1, sourceFile);
  mvi a, 4
  sta drawWindowText_1
  mvi a, 1
  sta drawWindowText_2
  lxi h, cmd_copymove1_sourceFile
  call drawWindowText
  ; 234 drawWindowText(0, 2, "w:");
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, string18
  call drawWindowText
  ; 235 drawWindowText(4, 2, cmdline);
  mvi a, 4
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, cmdline
  call drawWindowText
  ; 236 drawAnyKeyButton();
  call drawAnyKeyButton
  ; 239 if(bioskey1() == KEY_ESC) { e = ERR_USER; break; }
  call bioskey1
  cpi 27
  jnz l259
  ; 239 e = ERR_USER; break; }
  mvi a, 128
  sta cmd_copymove1_e
  ; 239 break; }
  jmp l249
l259:
  ; 241 e = fs_move(sourceFile, cmdline);    
  lxi h, cmd_copymove1_sourceFile
  shld fs_move_1
  lxi h, cmdline
  call fs_move
  sta cmd_copymove1_e
l258:
  ; 244 if(e) break;convertToConfition
  lda cmd_copymove1_e
  ora a
  jnz l249
l254:
  ; 248 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 251 type = getNextSelected(sourceFile);
  lxi h, cmd_copymove1_sourceFile
  call getNextSelected
  sta cmd_copymove1_type
  ; 252 if(type == 0) { e=0; break; }
  ora a
  jnz l261
  ; 252 e=0; break; }
  xra a
  sta cmd_copymove1_e
  ; 252 break; }
  jmp l249
l261:
l250:
  jmp l248
l249:
  ; 257 getFiles();
  call getFiles
  ; 258 dupFiles(1);
  mvi a, 1
  call dupFiles
  ; 260 return e;
  lda cmd_copymove1_e
  ret
  ; --- cmd_copymove -----------------------------------------------------------------
cmd_copymove:
  sta cmd_copymove_2
  ; 266 drawError(copymode ? "o{ibka kopirowaniq" : "o{ibka pereme}eniq", cmd_copymove1(copymode, shiftPressed));
  lda cmd_copymove_1
  ora a
  jz l262
  lxi h, string25
  jmp l263
l262:
  lxi h, string26
l263:
  shld drawError_1
  lda cmd_copymove_1
  sta cmd_copymove1_1
  lda cmd_copymove_2
  call cmd_copymove1
  call drawError
  ; 267 drawScreen();
  jmp drawScreen
cmd_new1:
  sta cmd_new1_1
  ; 8 cmdLine[0] = 0;
  xra a
  sta (cmdline)+(0)
  ; 11 if(!inputBox(dir ? " sozdatx papku " : " sozdatx fajl ") && cmdline[0]!=0) return 0;
  lda cmd_new1_1
  ora a
  jz l265
  lxi h, string27
  jmp l266
l265:
  lxi h, string28
l266:
  call inputBox
  ; convertToConfition
  ora a
  jnz l264
  lda (cmdline)+(0)
  ora a
  jz l264
  ; 11 return 0;
  xra a
  ret
l264:
  ; 13 if(!absolutePath(cmdline)) return ERR_RECV_STRING;
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l267
  ; 13 return ERR_RECV_STRING;
  mvi a, 11
  ret
l267:
  ; 16 if(!dir) {convertToConfition
  lda cmd_new1_1
  ora a
  jnz l268
  ; 17 if(strlen(cmdline) >= 255) return ERR_RECV_STRING;
  lxi h, cmdline
  call strlen
  ; Сложение
  lxi d, 65281
  dad d
  jnc l269
  ; 17 return ERR_RECV_STRING;
  mvi a, 11
  ret
l269:
  ; 20 memcpy_back(cmdline+1, cmdline, 255);
  lxi h, (cmdline)+(1)
  shld memcpy_back_1
  lxi h, cmdline
  shld memcpy_back_2
  lxi h, 255
  call memcpy_back
  ; 21 cmdline[0] = '*';
  mvi a, 42
  sta (cmdline)+(0)
  ; 24 run(editorApp, cmdLine);
  lxi h, editorApp
  shld run_1
  lxi h, cmdline
  call run
  ; 25 return 0;
  xra a
  ret
l268:
  ; 29 dir = fs_mkdir(cmdline);
  lxi h, cmdline
  call fs_mkdir
  sta cmd_new1_1
  ; 32 if(!dir) {convertToConfition
  ora a
  jnz l270
  ; 33 getFiles();
  call getFiles
  ; 34 dupFiles(0);
  xra a
  call dupFiles
l270:
  ; 37 return dir;
  lda cmd_new1_1
  ret
  ; --- cmd_new -----------------------------------------------------------------
cmd_new:
  sta cmd_new_1
  ; 41 drawError("o{ibka sozdaniq papki", cmd_new1(dir));
  lxi h, string29
  shld drawError_1
  call cmd_new1
  call drawError
  ; 43 drawScreen();
  jmp drawScreen
cmd_freespace_1:
  shld cmd_freespace_1_2
  ; 10 i2s32(buf, (ulong*)&fs_low, 10, ' ');
  lxi h, cmd_freespace_1_buf
  shld i2s32_1
  lxi h, fs_low
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 13 memcpy_back(buf+10, buf+7, 3); buf[9]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(10)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(7)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 13 buf[9]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(9)
  ; 14 memcpy_back(buf+6,  buf+4, 3); buf[5]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(6)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(4)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 14 buf[5]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(5)
  ; 15 memcpy_back(buf+2,  buf+1, 3); buf[1]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(2)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(1)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
  ; 15 buf[1]  = ' ';
  mvi a, 32
  sta (cmd_freespace_1_buf)+(1)
  ; 16 strcpy(buf+13, " mb");
  lxi h, (cmd_freespace_1_buf)+(13)
  shld strcpy_1
  lxi h, string30
  call strcpy
  ; 19 drawWindowText(6, y, text);
  mvi a, 6
  sta drawWindowText_1
  lda cmd_freespace_1_1
  sta drawWindowText_2
  lhld cmd_freespace_1_2
  call drawWindowText
  ; 20 drawWindowText(16, y, buf);
  mvi a, 16
  sta drawWindowText_1
  lda cmd_freespace_1_1
  sta drawWindowText_2
  lxi h, cmd_freespace_1_buf
  jmp drawWindowText
cmd_freespace:
  lxi h, string31
  call drawWindow
  ; 30 drawWindowText(6, 2, "prowerka...");  
  mvi a, 6
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, string32
  call drawWindowText
  ; 33 if(e = fs_getfree()) { 
  call fs_getfree
  sta cmd_freespace_e
  ; convertToConfition
  ora a
  jz l271
  ; 34 drawError("o{ibka ~teniq", e);
  lxi h, string33
  shld drawError_1
  lda cmd_freespace_e
  call drawError
  jmp l272
l271:
  ; 37 cmd_freespace_1(2, "swobodno: ");
  mvi a, 2
  sta cmd_freespace_1_1
  lxi h, string34
  call cmd_freespace_1
  ; 40 if(!fs_gettotal()) cmd_freespace_1(1, "wsego:");
  call fs_gettotal
  ; convertToConfition
  ora a
  jnz l273
  ; 40 cmd_freespace_1(1, "wsego:");
  mvi a, 1
  sta cmd_freespace_1_1
  lxi h, string35
  call cmd_freespace_1
l273:
  ; 43 drawAnyKeyButton();
  call drawAnyKeyButton
  ; 44 getch1();
  call getch1
l272:
  ; 47 drawScreen();
  jmp drawScreen
cmd_deleteFile:
  lxi h, string36
  call drawWindow
  ; 9 drawWindowText(0, 1, cmdline);
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, cmdline
  call drawWindowText
  ; 10 drawEscButton();
  call drawEscButton
  ; 13 if(bioskey1() == KEY_ESC) return ERR_USER;
  call bioskey1
  cpi 27
  jnz l274
  ; 13 return ERR_USER;
  mvi a, 128
  ret
l274:
  ; 16 return fs_delete(cmdline);
  lxi h, cmdline
  jmp fs_delete
  ret
  ; --- cmd_deleteFolder -----------------------------------------------------------------
cmd_deleteFolder:
  xra a
  sta cmd_deleteFolder_level
  ; 29 while(1) {
l275:
  ; 31 e = fs_findfirst(cmdline, panelB.files1, maxFiles);  
  lxi h, cmdline
  shld fs_findfirst_1
  lhld panelB
  shld fs_findfirst_2
  lhld maxFiles
  call fs_findfirst
  sta cmd_deleteFolder_e
  ; 32 if(e != 0 && e != ERR_MAX_FILES) return e;
  ora a
  jz l277
  lda cmd_deleteFolder_e
  cpi 10
  jz l277
  ; 32 return e;
  ret
l277:
  ; 33 panelB.cnt = fs_low;
  lhld fs_low
  shld (panelB)+(262)
  ; 36 e = 0;
  xra a
  sta cmd_deleteFolder_e
  ; 37 for(p=panelB.files1, i=panelB.cnt; i; --i, ++p) {
  lhld panelB
  shld cmd_deleteFolder_p
  lhld (panelB)+(262)
  shld cmd_deleteFolder_i
l278:
  ; convertToConfition
  lhld cmd_deleteFolder_i
  mov a, l
  ora h
  jz l279
  ; 38 if(catPathAndUnpack(cmdLine, p->fname)) return ERR_RECV_STRING;
  lxi h, cmdline
  shld catPathAndUnpack_1
  lhld cmd_deleteFolder_p
  call catPathAndUnpack
  ; convertToConfition
  ora a
  jz l281
  ; 38 return ERR_RECV_STRING;
  mvi a, 11
  ret
l281:
  ; 39 e = cmd_deleteFile();
  call cmd_deleteFile
  sta cmd_deleteFolder_e
  ; 40 if(e == ERR_DIR_NOT_EMPTY) break;
  cpi 7
  jz l279
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  ; 43 if(e) return e;convertToConfition
  lda cmd_deleteFolder_e
  ora a
  jz l283
  ; 43 return e;
  lda cmd_deleteFolder_e
  ret
l283:
l280:
  lhld cmd_deleteFolder_i
  dcx h
  shld cmd_deleteFolder_i
  lhld cmd_deleteFolder_p
  lxi d, 20
  dad d
  shld cmd_deleteFolder_p
  jmp l278
l279:
  ; 47 if(e == ERR_DIR_NOT_EMPTY) { 
  lda cmd_deleteFolder_e
  cpi 7
  jnz l284
  ; 48 ++level;
  lxi h, cmd_deleteFolder_level
  inr m
  ; 49 continue;
  jmp l275
l284:
  ; 53 if(panelB.cnt == maxFiles) continue;
  lhld (panelB)+(262)
  xchg
  lhld maxFiles
  call op_cmp16
  jz l275
  call cmd_deleteFile
  sta cmd_deleteFolder_e
  ; 57 if(e) return e;convertToConfition
  ora a
  jz l286
  ; 57 return e;
  lda cmd_deleteFolder_e
  ret
l286:
  ; 60 if(level == 0) return 0;
  lda cmd_deleteFolder_level
  ora a
  jnz l287
  ; 60 return 0;
  xra a
  ret
l287:
  ; 61 --level;
  lxi h, cmd_deleteFolder_level
  dcr m
  ; 62 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  jmp l275
l276:
  ret
  ; --- cmd_delete -----------------------------------------------------------------
cmd_delete:
  lxi h, string37
  shld confirm_1
  lxi h, string38
  call confirm
  ; convertToConfition
  ora a
  jz l288
  ; 73 needRefresh2 = 0;
  xra a
  sta cmd_delete_needRefresh2
  ; 76 if(getFirstSelected(cmdLine)) {
  lxi h, cmdline
  call getFirstSelected
  ; convertToConfition
  ora a
  jz l289
  ; 77 for(;;) {
l290:
  ; 78 if(!absolutePath(cmdline)) { e = ERR_RECV_STRING; break; }
  lxi h, cmdline
  call absolutePath
  ; convertToConfition
  ora a
  jnz l293
  ; 78 e = ERR_RECV_STRING; break; }
  mvi a, 11
  sta cmd_delete_e
  ; 78 break; }
  jmp l291
l293:
  ; 81 e = cmd_deleteFile();
  call cmd_deleteFile
  sta cmd_delete_e
  ; 84 if(e == ERR_DIR_NOT_EMPTY) {
  cpi 7
  jnz l294
  ; 85 needRefresh2 = 1; // Џа ў п Ї ­Ґ«м Ўг¤Ґв ЁбЇ®азҐ­ 
  mvi a, 1
  sta cmd_delete_needRefresh2
  ; 86 e = cmd_deleteFolder();
  call cmd_deleteFolder
  sta cmd_delete_e
l294:
  ; 88 if(e) break;convertToConfition
  ora a
  jnz l291
  lxi h, cmdline
  call getNextSelected
  ; convertToConfition
  ora a
  jz l291
l292:
  jmp l290
l291:
  ; 95 drawError("o{ibka udaleniq", e);
  lxi h, string39
  shld drawError_1
  lda cmd_delete_e
  call drawError
  ; 98 getFiles();
  call getFiles
  ; 99 dupFiles(needRefresh2);
  lda cmd_delete_needRefresh2
  call dupFiles
l289:
l288:
  ; 103 drawScreen();
  jmp drawScreen
compareMask1:
  push b
  sta compareMask1_3
  ; 8 for(;;) {
l297:
  ; 9 m = *mask;
  lhld compareMask1_2
  mov b, m
  ; 10 if(m == '*') return 1;
  mvi a, 42
  cmp b
  jnz l300
  ; 10 return 1;
  mvi a, 1
  pop b
  ret
l300:
  ; 11 if(m != '?' && m != *fileName) return 0;  
  mvi a, 63
  cmp b
  jz l301
  lhld compareMask1_1
  mov a, m
  cmp b
  jz l301
  ; 11 return 0;  
  xra a
  pop b
  ret
l301:
  ; 12 --i;
  lxi h, compareMask1_3
  dcr m
  ; 13 if(i==0) return 1;
  lda compareMask1_3
  ora a
  jnz l302
  ; 13 return 1;
  mvi a, 1
  pop b
  ret
l302:
  ; 14 ++mask, ++fileName;
  lhld compareMask1_2
  inx h
  shld compareMask1_2
  lhld compareMask1_1
  inx h
  shld compareMask1_1
l299:
  jmp l297
l298:
  pop b
  ret
  ; --- compareMask -----------------------------------------------------------------
compareMask:
  shld compareMask_2
  ; 21 if(!compareMask1(fileName, mask, 8)) return 0;
  lhld compareMask_1
  shld compareMask1_1
  lhld compareMask_2
  shld compareMask1_2
  mvi a, 8
  call compareMask1
  ; convertToConfition
  ora a
  jnz l303
  ; 21 return 0;
  xra a
  ret
l303:
  ; 22 return compareMask1(fileName+8, mask+8, 3);Сложение
  lhld compareMask_1
  lxi d, 8
  dad d
  shld compareMask1_1
  ; Сложение
  lhld compareMask_2
  lxi d, 8
  dad d
  shld compareMask1_2
  mvi a, 3
  jmp compareMask1
  ret
  ; --- cmd_sel -----------------------------------------------------------------
cmd_sel:
  sta cmd_sel_1
  ; 33 strcpy(cmdLine, "*.*");
  lxi h, cmdline
  shld strcpy_1
  lxi h, string40
  call strcpy
  ; 34 if(inputBox(" pometitx fajly ")) {
  lxi h, string41
  call inputBox
  ; convertToConfition
  ora a
  jz l304
  ; 35 packName(buf, cmdLine);
  lxi h, cmd_sel_buf
  shld packName_1
  lxi h, cmdline
  call packName
  ; 37 for(i=panelA.cnt, f=panelA.files1; i; --i, ++f) {
  lhld (panelA)+(262)
  shld cmd_sel_i
  lhld panelA
  shld cmd_sel_f
l305:
  ; convertToConfition
  lhld cmd_sel_i
  mov a, l
  ora h
  jz l306
  ; 38 if(f->fattrib & 0x10) {Сложение
  lhld cmd_sel_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  ; convertToConfition
  jz l308
  ; 39 f->fattrib &= 0x7F;Сложение
  lhld cmd_sel_f
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
  jmp l309
l308:
  ; 41 if(compareMask(f->fname, buf)) {
  lhld cmd_sel_f
  shld compareMask_1
  lxi h, cmd_sel_buf
  call compareMask
  ; convertToConfition
  ora a
  jz l310
  ; 42 if(add) {convertToConfition
  lda cmd_sel_1
  ora a
  jz l311
  ; 43 f->fattrib |= 0x80;Сложение
  lhld cmd_sel_f
  lxi d, 11
  dad d
  mov a, m
  ori 128
  mov m, a
  jmp l312
l311:
  ; 45 f->fattrib &= 0x7F;Сложение
  lhld cmd_sel_f
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
l312:
l310:
l309:
l307:
  lhld cmd_sel_i
  dcx h
  shld cmd_sel_i
  lhld cmd_sel_f
  lxi d, 20
  dad d
  shld cmd_sel_f
  jmp l305
l306:
l304:
  ; 52 drawScreen();
  jmp drawScreen
drawInit:
  call radio86rkScreen2a
  ; 16 maxFiles = getMemTop() - START_FILE_BUFFER;
  call 63536
  ; Сложение
  lxi d, 52224
  dad d
  shld maxFiles
  ; 17 maxFiles /= sizeof(FileInfo)*2;
  lxi d, 40
  call op_div16
  shld maxFiles
  ; 18 activePanel = 0;
  xra a
  sta activePanel
  ; 19 fileCursorAddr = 0;  
  lxi h, 0
  shld fileCursorAddr
  ret
  ; --- showTextCursor -----------------------------------------------------------------
showTextCursor:
  sta showTextCursor_2
  ; 1 directCursor(x+1 ? 8+x : 255, 3+y);
  lda showTextCursor_1
  inr a
  jz l313
  lda showTextCursor_1
  adi 8
  jmp l314
l313:
  mvi a, 255
l314:
  sta directCursor_1
  lda showTextCursor_2
  adi 3
  jmp directCursor
hideTextCursor:
  mvi a, 255
  sta showTextCursor_1
  jmp showTextCursor
drawSwapPanels:
  lxi h, activePanel
  mvi a, 32
  sub m
  sta activePanel
  ret
  ; --- hideFileCursor -----------------------------------------------------------------
hideFileCursor:
  lhld fileCursorAddr
  mov a, l
  ora h
  jnz l315
  ; 44 return;
  ret
l315:
  ; 45 fileCursorAddr[0] = ' ';Сложение с константой 0
  mvi m, 32
  ; 46 fileCursorAddr[13] = ' ';Сложение
  lxi d, 13
  dad d
  mvi m, 32
  ; 47 fileCursorAddr = 0;
  lxi h, 0
  shld fileCursorAddr
  ret
  ; --- showFileCursor -----------------------------------------------------------------
showFileCursor:
  call hideFileCursor
  ; 57 fileCursorAddr = charAddr(panelA.cursorX*15 + 2 + activePanel, 2 + panelA.cursorY);
  mvi d, 15
  lda (panelA)+(258)
  call op_mul
  ; Сложение с константой 2
  inx h
  inx h
  ; Сложение
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta charAddr_1
  lda (panelA)+(259)
  adi 2
  call charAddr
  shld fileCursorAddr
  ; 58 fileCursorAddr[0]  = '[';Сложение с константой 0
  mvi m, 91
  ; 59 fileCursorAddr[13] = ']';Сложение
  lxi d, 13
  dad d
  mvi m, 93
  ret
  ; --- vLine -----------------------------------------------------------------
vLine:
  sta vLine_3
  ; 65 asm {
    push b
    mov d, a
    lda radio86rkVideoBpl
    mov c, a
    mvi b, 0
    lda vLine_2
    mov e, a
    lhld vLine_1
vLine_l0:
    mov m, d
    dad b
    dcr e 
    jnz vLine_l0
    pop b
  
  ret
  ; --- drawRect -----------------------------------------------------------------
drawRect:
  sta drawRect_3
  ; 87 a[0] = 0x04; memset(a+1, 0x1C, w); a[w] = 0x10; a += VIDEO_BPL;Сложение с константой 0
  lhld drawRect_1
  mvi m, 4
  ; 87 memset(a+1, 0x1C, w); a[w] = 0x10; a += VIDEO_BPL;Сложение с константой 1
  inx h
  shld memset_1
  mvi a, 28
  sta memset_2
  lhld drawRect_2
  mvi h, 0
  call memset
  ; 87 a[w] = 0x10; a += VIDEO_BPL;Сложение
  lhld drawRect_1
  xchg
  lhld drawRect_2
  mvi h, 0
  dad d
  mvi m, 16
  ; 87 a += VIDEO_BPL;Сложение
  lxi d, 75
  lhld drawRect_1
  dad d
  shld drawRect_1
  ; 88 for(i=h; i; --i) {
  lda drawRect_3
  sta drawRect_i
l316:
  ; convertToConfition
  lda drawRect_i
  ora a
  jz l317
  ; 89 a[0] = 0x06; a[w] = 0x11; a += VIDEO_BPL;Сложение с константой 0
  lhld drawRect_1
  mvi m, 6
  ; 89 a[w] = 0x11; a += VIDEO_BPL;Сложение
  xchg
  lhld drawRect_2
  mvi h, 0
  dad d
  mvi m, 17
  ; 89 a += VIDEO_BPL;Сложение
  lxi d, 75
  lhld drawRect_1
  dad d
  shld drawRect_1
l318:
  lxi h, drawRect_i
  dcr m
  jmp l316
l317:
  ; 91 a[0] = 0x02; memset(a+1, 0x1C, w); a[w] = 0x01;Сложение с константой 0
  lhld drawRect_1
  mvi m, 2
  ; 91 memset(a+1, 0x1C, w); a[w] = 0x01;Сложение с константой 1
  inx h
  shld memset_1
  mvi a, 28
  sta memset_2
  lhld drawRect_2
  mvi h, 0
  call memset
  ; 91 a[w] = 0x01;Сложение
  lhld drawRect_1
  xchg
  lhld drawRect_2
  mvi h, 0
  dad d
  mvi m, 1
  ret
  ; --- fillRect -----------------------------------------------------------------
fillRect:
  sta fillRect_4
  ; 97 asm {
    push b
    lda radio86rkVideoBpl
    mov c, a
    mvi b, 0
    lhld fillRect_1
    lda fillRect_3
    mov d, a
    lda fillRect_4
    mov e, a
fillRect_l1:  
    lda fillRect_2
    push h
fillRect_l0:
    mov m, e
    inx h
    dcr a
    jnz fillRect_l0
    pop h
    dad b    
    dcr d
    jnz fillRect_l1
    pop b
  
  ret
  ; --- drawFilesCountInt -----------------------------------------------------------------
drawFilesCountInt:
  shld drawFilesCountInt_2
  ; 128 a = charAddr(2+activePanel, 4+ROWS_CNT);
  lda activePanel
  adi 2
  sta charAddr_1
  mvi a, 26
  call charAddr
  shld drawFilesCountInt_a
  ; 129 i2s32((char*)a, total, 10, ' ');
  shld i2s32_1
  lhld drawFilesCountInt_1
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
  ; 130 print2(a+11, "bajt w    ");Сложение
  lhld drawFilesCountInt_a
  lxi d, 11
  dad d
  shld print2_1
  lxi h, string42
  call print2
  ; 131 if(filesCnt < 1000) i2s((char*)a+18, filesCnt, 3, ' ');Сложение
  lhld drawFilesCountInt_2
  lxi d, 64535
  dad d
  jc l319
  ; 131 i2s((char*)a+18, filesCnt, 3, ' ');Сложение
  lhld drawFilesCountInt_a
  lxi d, 18
  dad d
  shld i2s_1
  lhld drawFilesCountInt_2
  shld i2s_2
  lxi h, 3
  shld i2s_3
  mvi a, 32
  call i2s
l319:
  ; 132 v = filesCnt % 100;
  lxi d, 100
  lhld drawFilesCountInt_2
  call op_mod16
  mov a, l
  sta drawFilesCountInt_v
  ; 133 print2(a+22, (!(v >= 10 && v < 20) && v % 10 == 1) ? "fajle " : "fajlah ");Сложение
  lhld drawFilesCountInt_a
  lxi d, 22
  dad d
  shld print2_1
  cpi 10
  jc l320
  cpi 20
  jnc l320
  mvi a, 1
  jmp l321
l320:
  xra a
l321:
  ; convertToConfition
  ora a
  jnz l322
  mvi d, 10
  lda drawFilesCountInt_v
  call op_mod
  cpi 1
  jnz l322
  mvi a, 1
  jmp l323
l322:
  xra a
l323:
  ora a
  jz l324
  lxi h, string43
  jmp l325
l324:
  lxi h, string44
l325:
  jmp print2
drawPanel:
  shld drawPanel_1
  ; 139 drawRect(a, 30, ROWS_CNT + 4);
  shld drawRect_1
  mvi a, 30
  sta drawRect_2
  mvi a, 26
  call drawRect
  ; 140 memset(a + (VIDEO_BPL * (2 + ROWS_CNT) + 1), 0x1C, 29); // hLineСложение
  lhld drawPanel_1
  lxi d, 1801
  dad d
  shld memset_1
  mvi a, 28
  sta memset_2
  lxi h, 29
  call memset
  ; 141 vLine(a + (VIDEO_BPL + 15), ROWS_CNT+1, 0x1B);Сложение
  lhld drawPanel_1
  lxi d, 90
  dad d
  shld vLine_1
  mvi a, 23
  sta vLine_2
  mvi a, 27
  call vLine
  ; 142 print2(a + (VIDEO_BPL + 6 ), "imq");Сложение
  lhld drawPanel_1
  lxi d, 81
  dad d
  shld print2_1
  lxi h, string45
  call print2
  ; 143 print2(a + (VIDEO_BPL + 21), "imq");  Сложение
  lhld drawPanel_1
  lxi d, 96
  dad d
  shld print2_1
  lxi h, string45
  jmp print2
drawScreenInt:
  lhld radio86rkVideoMem
  shld fillRect_1
  mvi a, 64
  sta fillRect_2
  mvi a, 30
  sta fillRect_3
  mvi a, 32
  call fillRect
  ; 154 print(1, ROWS_CNT+7, "F1 FREE F2 NEW  F3 VIEW  F4 EDIT F5 COPY F6 REN  F7 DIR  F8 DEL"); 
  mvi a, 1
  sta print_1
  mvi a, 29
  sta print_2
  lxi h, string46
  call print
  ; 157 drawPanel(radio86rkVideoMem + 1);Сложение с константой 1
  lhld radio86rkVideoMem
  inx h
  call drawPanel
  ; 158 drawPanel(radio86rkVideoMem + 33);Сложение
  lhld radio86rkVideoMem
  lxi d, 33
  dad d
  call drawPanel
  ; 161 drawPanelTitle(1);
  mvi a, 1
  call drawPanelTitle
  ; 162 swapPanels();
  call swapPanels
  ; 163 drawPanelTitle(0);
  xra a
  call drawPanelTitle
  ; 164 swapPanels();
  call swapPanels
  ; 167 fileCursorAddr = 0;
  lxi h, 0
  shld fileCursorAddr
  ret
  ; --- drawPanelTitle -----------------------------------------------------------------
drawPanelTitle:
  sta drawPanelTitle_1
  ; 179 memset((char*)charAddr(activePanel + 2, 0), 0x1C, 29);
  lda activePanel
  adi 2
  sta charAddr_1
  xra a
  call charAddr
  shld memset_1
  mvi a, 28
  sta memset_2
  lxi h, 29
  call memset
  ; 182 p = panelA.path1;
  lxi h, (panelA)+(2)
  shld drawPanelTitle_p
  ; 183 if(p[0]==0) p = "/";Сложение с константой 0
  mov a, m
  ora a
  jnz l326
  ; 183 p = "/";
  lxi h, string21
  shld drawPanelTitle_p
l326:
  ; 184 l = strlen(p);
  call strlen
  shld drawPanelTitle_l
  ; 185 if(l>=27) p=p+(l-27), l=27;Сложение
  lxi d, 65509
  dad d
  jnc l327
  ; 185 p=p+(l-27), l=27;Сложение
  lhld drawPanelTitle_l
  lxi d, 65509
  dad d
  ; Сложение
  xchg
  lhld drawPanelTitle_p
  dad d
  shld drawPanelTitle_p
  lxi h, 27
  shld drawPanelTitle_l
l327:
  ; 186 x = 2 + (30 - l) / 2 + activePanel;16 битная арифметическая операция с константой
  lhld drawPanelTitle_l
  mvi a, 30
  sub l
  mov l, a
  mvi a, 0
  sbb h
  mov h, a
  lxi d, 2
  call op_div16
  ; Сложение с константой 2
  inx h
  inx h
  ; Сложение
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta drawPanelTitle_x
  ; 187 printn(x, 0, l, p);
  sta printn_1
  xra a
  sta printn_2
  lda drawPanelTitle_l
  sta printn_3
  lhld drawPanelTitle_p
  call printn
  ; 188 if(!active) return;convertToConfition
  lda drawPanelTitle_1
  ora a
  jnz l328
  ; 188 return;
  ret
l328:
  ; 189 print(x-1, 0, "[");
  lda drawPanelTitle_x
  dcr a
  sta print_1
  xra a
  sta print_2
  lxi h, string47
  call print
  ; 190 print(x+l, 0, "]");Сложение
  lhld drawPanelTitle_x
  mvi h, 0
  xchg
  lhld drawPanelTitle_l
  dad d
  mov a, l
  sta print_1
  xra a
  sta print_2
  lxi h, string48
  jmp print
drawFile2:
  shld drawFile2_2
  ; 196 print2n(a, 8, f->fname); 
  lhld drawFile2_1
  shld print2n_1
  mvi a, 8
  sta print2n_2
  lhld drawFile2_2
  call print2n
  ; 197 a[8] = (f->fattrib&0x80) ? '*' : ((f->fattrib & 0x06) ? 0x7F : ' ');Сложение
  lhld drawFile2_1
  lxi d, 8
  dad d
  ; Сложение
  push h
  lhld drawFile2_2
  lxi d, 11
  dad d
  mov a, m
  ani 128
  jz l329
  mvi a, 42
  jmp l330
l329:
  ; Сложение
  lhld drawFile2_2
  lxi d, 11
  dad d
  mov a, m
  ani 6
  jz l331
  mvi a, 127
  jmp l332
l331:
  mvi a, 32
l332:
l330:
  pop h
  mov m, a
  ; 198 print2n(a + 9, 3, f->fname + 8); Сложение
  lhld drawFile2_1
  lxi d, 9
  dad d
  shld print2n_1
  mvi a, 3
  sta print2n_2
  ; Сложение
  lhld drawFile2_2
  lxi d, 8
  dad d
  jmp print2n
drawColumn:
  push b
  sta drawColumn_1
  ; 206 panelA.offset+i*ROWS_CNT;<n>
  mvi d, 22
  call op_mul
  ; Сложение
  xchg
  lhld (panelA)+(260)
  dad d
  mov b, h
  mov c, l
  ; 207 panelA.files1 + n;  <f>
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
  shld drawColumn_f
  ; 209 a = charAddr(i*15+3+activePanel,2);
  mvi d, 15
  lda drawColumn_1
  call op_mul
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  ; Сложение
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta charAddr_1
  mvi a, 2
  call charAddr
  shld drawColumn_a
  ; 210 for(y=ROWS_CNT; y; --y, a+=VIDEO_BPL) {
  mvi a, 22
  sta drawColumn_y
l333:
  ; convertToConfition
  lda drawColumn_y
  ora a
  jz l334
  ; 211 if(n>=panelA.cnt) {
  lhld (panelA)+(262)
  mov d, b
  mov e, c
  call op_cmp16
  jz l337
  jnc l336
l337:
  ; 212 print2cn(a, 12, ' ');
  lhld drawColumn_a
  shld print2cn_1
  mvi a, 12
  sta print2cn_2
  mvi a, 32
  call print2cn
  ; 213 continue;
  jmp l335
l336:
  ; 215 drawFile2(a, f);
  lhld drawColumn_a
  shld drawFile2_1
  lhld drawColumn_f
  call drawFile2
  ; 216 ++f; ++n; 
  lhld drawColumn_f
  lxi d, 20
  dad d
  shld drawColumn_f
  ; 216 ++n; 
  inx b
l335:
  lxi h, drawColumn_y
  dcr m
  ; Сложение
  lxi d, 75
  lhld drawColumn_a
  dad d
  shld drawColumn_a
  jmp l333
l334:
  pop b
  ret
  ; --- drawFile -----------------------------------------------------------------
drawFile:
  shld drawFile_3
  ; 223 drawFile2(charAddr(x*15+3+activePanel, 2+y), f);
  mvi d, 15
  lda drawFile_1
  call op_mul
  ; Сложение с константой 3
  inx h
  inx h
  inx h
  ; Сложение
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta charAddr_1
  lda drawFile_2
  adi 2
  call charAddr
  shld drawFile2_1
  lhld drawFile_3
  jmp drawFile2
drawFileInfo1:
  shld drawFileInfo1_1
  ; 230 printm(3+activePanel, ROWS_CNT+3, 10, buf);
  lda activePanel
  adi 3
  sta printm_1
  mvi a, 25
  sta printm_2
  mvi a, 10
  sta printm_3
  jmp printm
drawFileInfoDir:
  lxi h, string49
  jmp drawFileInfo1
drawFileInfo2:
  shld drawFileInfo2_1
  ; 243 printm(14+activePanel, ROWS_CNT+3, 16, buf);
  lda activePanel
  adi 14
  sta printm_1
  mvi a, 25
  sta printm_2
  mvi a, 16
  sta printm_3
  jmp printm
drawCmdLineWithPath:
  push b
  ; 253 print(1, ROWS_CNT+6, "/");
  mvi a, 1
  sta print_1
  mvi a, 28
  sta print_2
  lxi h, string21
  call print
  ; 254 l = strlen(panelA.path1);
  lxi h, (panelA)+(2)
  call strlen
  shld drawCmdLineWithPath_l
  ; 255 if(l>=30) o=l-30, l=30; else o=0;Сложение
  lxi d, 65506
  dad d
  jnc l338
  ; 255 o=l-30, l=30; else o=0;Сложение
  lhld drawCmdLineWithPath_l
  lxi d, 65506
  dad d
  mov b, h
  mov c, l
  lxi h, 30
  shld drawCmdLineWithPath_l
  jmp l339
l338:
  ; 255 o=0;
  lxi b, 0
l339:
  ; 256 printn(2, ROWS_CNT+6, l, panelA.path1+o);
  mvi a, 2
  sta printn_1
  mvi a, 28
  sta printn_2
  lda drawCmdLineWithPath_l
  sta printn_3
  ; Сложение с BC
  lxi h, (panelA)+(2)
  dad b
  call printn
  ; 257 print(l+2, ROWS_CNT+6, ">");Сложение с константой 2
  lhld drawCmdLineWithPath_l
  inx h
  inx h
  mov a, l
  sta print_1
  mvi a, 28
  sta print_2
  lxi h, string50
  call print
  ; 260 panelA.cmdLineOff = l+3;Сложение с константой 3
  lhld drawCmdLineWithPath_l
  inx h
  inx h
  inx h
  shld (panelA)+(264)
  ; 263 drawCmdLine();
  call drawCmdLine
  pop b
  ret
  ; --- drawWindow -----------------------------------------------------------------
drawWindow:
  push b
  shld drawWindow_1
  ; 272 hideTextCursor();
  call hideTextCursor
  ; 274 fillRect(charAddr(WINDOW_X-5,WINDOW_Y-3), 49, 11, ' ');
  mvi a, 8
  sta charAddr_1
  call charAddr
  shld fillRect_1
  mvi a, 49
  sta fillRect_2
  mvi a, 11
  sta fillRect_3
  mvi a, 32
  call fillRect
  ; 275 drawRect(charAddr(WINDOW_X-4,WINDOW_Y-2), 46, 7);
  mvi a, 9
  sta charAddr_1
  call charAddr
  shld drawRect_1
  mvi a, 46
  sta drawRect_2
  mvi a, 7
  call drawRect
  ; 277 print((64-strlen(title)) >> 1, WINDOW_Y-2, title);
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
  mvi a, 9
  sta print_2
  lhld drawWindow_1
  call print
  pop b
  ret
  ; --- drawAnyKeyButton -----------------------------------------------------------------
drawAnyKeyButton:
  mvi a, 27
  sta print_1
  mvi a, 15
  sta print_2
  lxi h, string51
  jmp print
drawEscButton:
  mvi a, 25
  sta print_1
  mvi a, 15
  sta print_2
  lxi h, string52
  jmp print
drawWindowText:
  shld drawWindowText_3
  ; 297 printn(WINDOW_X+ox, WINDOW_Y+oy, 40-ox, text);
  lda drawWindowText_1
  adi 13
  sta printn_1
  lda drawWindowText_2
  adi 11
  sta printn_2
  ; Арифметика 3/4
  lxi h, drawWindowText_1
  mvi a, 40
  sub m
  sta printn_3
  lhld drawWindowText_3
  jmp printn
drawWindowProgress:
  sta drawWindowProgress_4
  ; 304 if(n==0) return;
  lda drawWindowProgress_3
  ora a
  jnz l340
  ; 304 return;
  ret
l340:
  ; 305 printcn(WINDOW_X+ox, WINDOW_Y+oy, n, chr);
  lda drawWindowProgress_1
  adi 13
  sta printcn_1
  lda drawWindowProgress_2
  adi 11
  sta printcn_2
  lda drawWindowProgress_3
  sta printcn_3
  lda drawWindowProgress_4
  jmp printcn
drawCmdLine:
  lda (panelA)+(264)
  sta drawInput_1
  mvi a, 28
  sta drawInput_2
  ; 16 битная арифметическая операция с константой
  lhld (panelA)+(264)
  mvi a, 62
  sub l
  mov l, a
  mvi a, 0
  sbb h
  mov h, a
  mov a, l
  jmp drawInput
drawInput:
  push b
  sta drawInput_3
  ; 322 cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  call strlen
  shld drawInput_cmdline_pos
  ; 323 --max;
  lxi h, drawInput_3
  dcr m
  ; 324 if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  lhld drawInput_cmdline_pos
  xchg
  lhld drawInput_3
  mvi h, 0
  call op_cmp16
  jc l341
  jz l341
  ; 324 cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  lxi h, 0
  shld drawInput_cmdline_offset
  jmp l342
l341:
  ; 324 cmdline_offset = cmdline_pos-max;16 битная арифметическая операция с константой
  lhld drawInput_3
  mvi h, 0
  xchg
  lhld drawInput_cmdline_pos
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld drawInput_cmdline_offset
l342:
  ; 325 c1 = cmdline_pos - cmdline_offset;16 битная арифметическая операция с константой
  lhld drawInput_cmdline_offset
  xchg
  lhld drawInput_cmdline_pos
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  shld drawInput_c1
  ; 326 cmdline[cmdline_pos] = 0;Сложение
  lhld drawInput_cmdline_pos
  lxi d, cmdline
  dad d
  mvi m, 0
  ; 327 ++c1;
  lhld drawInput_c1
  inx h
  shld drawInput_c1
  ; 328 if(c1 > max) c1 = max;
  xchg
  lhld drawInput_3
  mvi h, 0
  call op_cmp16
  jnc l343
  ; 328 c1 = max;
  lhld drawInput_3
  mvi h, 0
  shld drawInput_c1
l343:
  ; 329 ++c1;
  lhld drawInput_c1
  inx h
  shld drawInput_c1
  ; 330 ++max;
  lxi h, drawInput_3
  inr m
  ; 331 printm(x, y, max, cmdline + cmdline_offset);
  lda drawInput_1
  sta printm_1
  lda drawInput_2
  sta printm_2
  lda drawInput_3
  sta printm_3
  ; Сложение
  lhld drawInput_cmdline_offset
  lxi d, cmdline
  dad d
  call printm
  ; 334 showTextCursor(x+cmdline_pos-cmdline_offset, y);Сложение
  lhld drawInput_1
  mvi h, 0
  xchg
  lhld drawInput_cmdline_pos
  dad d
  ; 16 битная арифметическая операция с константой
  xchg
  lhld drawInput_cmdline_offset
  xchg
  mov a, l
  sub e
  mov l, a
  mov a, h
  sbb d
  mov h, a
  mov a, l
  sta showTextCursor_1
  lda drawInput_2
  call showTextCursor
  pop b
  ret
  ; --- drawWindowInput -----------------------------------------------------------------
drawWindowInput:
  sta drawWindowInput_3
  ; 340 drawInput(WINDOW_X+x, WINDOW_Y+y, max);
  lda drawWindowInput_1
  adi 13
  sta drawInput_1
  lda drawWindowInput_2
  adi 11
  sta drawInput_2
  lda drawWindowInput_3
  jmp drawInput
getch1:
  jmp 63491
  ret
  ; --- bioskey1 -----------------------------------------------------------------
bioskey1:
  jmp 63515
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
  ; --- op_cmp16 -----------------------------------------------------------------
op_cmp16:
    mov a, h
    cmp d
    rnz
    mov a, l
    cmp e
  
  ret
  ; --- i2s32 -----------------------------------------------------------------
i2s32:
  sta i2s32_4
  ; 7 set32(&v, src);
  lxi h, i2s32_v
  shld set32_1
  lhld i2s32_2
  call set32
  ; 9 buf += n;  Сложение
  lhld i2s32_3
  xchg
  lhld i2s32_1
  dad d
  shld i2s32_1
  ; 10 *buf = 0;
  mvi m, 0
  ; 12 while(1) {
l344:
  ; 13 div32_16(&v, 10);
  lxi h, i2s32_v
  shld div32_16_1
  lxi h, 10
  call div32_16
  ; 14 --buf;
  lhld i2s32_1
  dcx h
  shld i2s32_1
  ; 15 *buf = "0123456789ABCDEF"[op_div16_mod];Сложение
  lhld op_div16_mod
  lxi d, string53
  dad d
  mov a, m
  lhld i2s32_1
  mov m, a
  ; 16 if(--n == 0) return;
  lhld i2s32_3
  dcx h
  shld i2s32_3
  ; Сложение с константой 0
  mov a, l
  ora h
  jnz l346
  ; 16 return;
  ret
l346:
  ; 17 if(((ushort*)&v)[0] == 0 && ((ushort*)&v)[1] == 0) break;Сложение с константой 0
  lhld (i2s32_v)+(0)
  mov a, l
  ora h
  jnz l347
  ; Сложение с константой 0
  lhld (i2s32_v)+(2)
  mov a, l
  ora h
  jz l345
l347:
  jmp l344
l345:
  ; 20 while(1) {
l348:
  ; 21 --buf;
  lhld i2s32_1
  dcx h
  shld i2s32_1
  ; 22 *buf = spc;
  lda i2s32_4
  mov m, a
  ; 23 if(--n == 0) break;
  lhld i2s32_3
  dcx h
  shld i2s32_3
  ; Сложение с константой 0
  mov a, l
  ora h
  jz l349
  jmp l348
l349:
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
l351:
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
  lxi d, string53
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
  jnz l353
  ; 11 return;
  ret
l353:
  ; 12 if(v == 0) break;Сложение с константой 0
  lhld i2s_2
  mov a, l
  ora h
  jz l352
  jmp l351
l352:
  ; 14 while(1) {
l355:
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
  jz l356
  jmp l355
l356:
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
  ; --- add32_32 -----------------------------------------------------------------
add32_32:
  shld add32_32_2
  ; 4 asm {   
   
    ; hl = add32_32_2   
    xchg
    lhld add32_32_1
    xchg

    ldax d
    add  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
  
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
  ; --- fs_findfirst -----------------------------------------------------------------
fs_findfirst:
  shld fs_findfirst_3
  ; 4 if(path[0] == '/') path++;Сложение с константой 0
  lhld fs_findfirst_1
  mov a, m
  cpi 47
  jnz l358
  ; 4 path++;
  mov d, h
  mov e, l
  inx h
  shld fs_findfirst_1
  xchg
l358:
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
  ; --- strcmp -----------------------------------------------------------------
strcmp:
  shld strcmp_2
  ; 3 while(1) {
l359:
  ; 4 a=*d, b=*s;
  lhld strcmp_1
  mov a, m
  sta strcmp_a
  lhld strcmp_2
  mov a, m
  sta strcmp_b
  ; 5 if(a < b) return 255;
  lxi h, strcmp_b
  lda strcmp_a
  cmp m
  jnc l361
  ; 5 return 255;
  mvi a, 255
  ret
l361:
  ; 6 if(b < a) return 1;
  lxi h, strcmp_a
  lda strcmp_b
  cmp m
  jnc l362
  ; 6 return 1;
  mvi a, 1
  ret
l362:
  ; 7 if(*d==0) return 0;
  lhld strcmp_1
  mov a, m
  ora a
  jnz l363
  ; 7 return 0;
  xra a
  ret
l363:
  ; 8 ++d, ++s;
  inx h
  shld strcmp_1
  lhld strcmp_2
  inx h
  shld strcmp_2
  jmp l359
l360:
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
  ; --- fs_open -----------------------------------------------------------------
fs_open:
  shld fs_open_1
  ; 5 return fs_open0(name, O_OPEN);
  shld fs_open0_1
  xra a
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
  ; --- fs_create -----------------------------------------------------------------
fs_create:
  shld fs_create_1
  ; 5 return fs_open0(name, O_CREATE);
  shld fs_open0_1
  mvi a, 1
  jmp fs_open0
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
  ; --- fs_getsize -----------------------------------------------------------------
fs_getsize:
  lxi h, 0
  shld fs_seek_1
  shld fs_seek_2
  mvi a, 100
  jmp fs_seek
  ret
  ; --- set32 -----------------------------------------------------------------
set32:
  shld set32_2
  ; 4 asm {
    xchg ; de = set32_2
    lhld set32_1
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
  
  ret
  ; --- div32_16 -----------------------------------------------------------------
div32_16:
  shld div32_16_2
  ; 9 ((ushort*)a)[1] = ((ushort*)a)[1] / b;Сложение с константой 2
  lhld div32_16_1
  inx h
  inx h
  ; Сложение с константой 2
  push h
  lhld div32_16_1
  inx h
  inx h
  xchg
  lhld div32_16_2
  xchg
  mov a, m
  inx h
  mov h, m
  mov l, a
  call op_div16
  pop d
  xchg
  mov m, e
  inx h
  mov m, d
  dcx h
  ; 11 ((uchar*)&tmp)[1] = op_div16_mod;
  lda op_div16_mod
  sta (div32_16_tmp)+(1)
  ; 12 ((uchar*)&tmp)[0] = ((uchar*)a)[1];Сложение с константой 1
  lhld div32_16_1
  inx h
  mov a, m
  sta (div32_16_tmp)+(0)
  ; 13 ((uchar*)a)[1] = tmp / b;Сложение с константой 1
  lhld div32_16_1
  inx h
  xchg
  lhld div32_16_2
  xchg
  push h
  lhld div32_16_tmp
  call op_div16
  mov a, l
  pop h
  mov m, a
  ; 15 ((uchar*)&tmp)[1] = op_div16_mod;
  lda op_div16_mod
  sta (div32_16_tmp)+(1)
  ; 16 ((uchar*)&tmp)[0] = ((uchar*)a)[0];Сложение с константой 0
  lhld div32_16_1
  mov a, m
  sta (div32_16_tmp)+(0)
  ; 17 ((uchar*)a)[0] = tmp / b;Сложение с константой 0
  xchg
  lhld div32_16_2
  xchg
  push h
  lhld div32_16_tmp
  call op_div16
  mov a, l
  pop h
  mov m, a
  ret
  ; --- fs_swap -----------------------------------------------------------------
fs_swap:
  lxi h, string13
  shld fs_open0_1
  mvi a, 101
  jmp fs_open0
  ret
  ; --- add32_16 -----------------------------------------------------------------
add32_16:
  shld add32_16_2
  ; 4 asm {
    ; de = *to
    lhld add32_16_1
    mov e, m
    inx h
    mov d, m

    ; hl = de + from
    lhld add32_16_2
    dad d

    ; *hl = de
    xchg
    lhld add32_16_1
    mov m, e
    inx h
    mov m, d     

    ; …б«Ё ЇҐаҐЇ®«­Ґ­ЁҐ, в® гўҐ«ЁзЁў Ґ¬ ўҐае­Ё© а §ап¤
    rnc
    inx h
    inr m    

    ; …б«Ё ЇҐаҐЇ®«­Ґ­ЁҐ, в® гўҐ«ЁзЁў Ґ¬ ўҐае­Ё© а §ап¤
    rnz
    inx h
    inr m
  
  ret
  ; --- cmp32_32 -----------------------------------------------------------------
cmp32_32:
  shld cmp32_32_2
  ; 4 asm {
    lhld cmp32_32_1
    inx h
    inx h
    inx h
    xchg

    lhld cmp32_32_2
    inx h
    inx h
    inx h
  
    ldax d
    cmp m
    jnz cmp32_32_l0
   
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0
    
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0

    dcx h
    dcx d
    ldax d
    cmp m
    rz

cmp32_32_l0:   
    cmc
    sbb a
    ori 1
    ret
  
  ret
  ; --- sub32_32 -----------------------------------------------------------------
sub32_32:
  shld sub32_32_2
  ; 4 asm {
    lhld sub32_32_1
    xchg
    lhld sub32_32_2
  
    ldax d
    sub m
    stax d
   
    inx h
    inx d
    ldax d
    sbb m
    stax d
    
    inx h
    inx d
    ldax d
    sbb m
    stax d

    inx h
    inx d
    ldax d
    sbb m
    stax d
  
  ret
  ; --- fs_delete -----------------------------------------------------------------
fs_delete:
  shld fs_delete_1
  ; 5 return fs_open0(name, O_DELETE);
  shld fs_open0_1
  mvi a, 100
  jmp fs_open0
  ret
  ; --- fs_mkdir -----------------------------------------------------------------
fs_mkdir:
  shld fs_mkdir_1
  ; 5 return fs_open0(name, O_MKDIR);
  shld fs_open0_1
  mvi a, 2
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
  ; --- radio86rkScreen2a -----------------------------------------------------------------
radio86rkScreen2a:
  push b
  ; 3 memset((uchar*)MEM_ADDR, 0, (HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+2); 
  lxi h, 30416
  shld memset_1
  xra a
  sta memset_2
  lxi h, 2333
  call memset
  ; 4 for(v=(uchar*)(MEM_ADDR)-1, i=TOP_INVISIBLE; i; --i) 
  lxi b, 30415
  mvi a, 3
  sta radio86rkScreen2a_i
l364:
  ; convertToConfition
  lda radio86rkScreen2a_i
  ora a
  jz l365
  ; 5 v+=2, *v = 0xF1; Сложение BC с константой 2
  inx b
  inx b
  mvi a, 241
  stax b
l366:
  lxi h, radio86rkScreen2a_i
  dcr m
  jmp l364
l365:
  ; 6 if(FILL_EOL) 7 for(i = HEIGHT; i; --i) 
  mvi a, 31
  sta radio86rkScreen2a_i
l368:
  ; convertToConfition
  lda radio86rkScreen2a_i
  ora a
  jz l369
  ; 8 v += (BPL), *v = 0xF1; Сложение с BC
  lxi h, 75
  dad b
  mov b, h
  mov c, l
  mvi a, 241
  stax b
l370:
  lxi h, radio86rkScreen2a_i
  dcr m
  jmp l368
l369:
  ; 9 ((uchar*)MEM_ADDR)[(HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+1] = 0xFF; 
  lxi h, 32748
  mvi m, 255
  ; 10 radio86rkVideoMem = (uchar*)(MEM_ADDR) + (TOP_INVISIBLE)*2 + 9; 
  lxi h, 30431
  shld radio86rkVideoMem
  ; 11 radio86rkVideoBpl = (BPL); 
  mvi a, 75
  sta radio86rkVideoBpl
  ; 1 ((uchar*)0xC000)
  lxi h, 49153
  mvi m, 0
  ; 1 ((uchar*)0xC000)
  dcr l
  mvi m, 77
  ; 1 ((uchar*)0xC000)
  mvi m, 100
  ; 1 ((uchar*)0xC000)
  mvi m, 119
  ; 1 ((uchar*)0xC000)
  mvi m, 83
  ; 1 ((uchar*)0xC000)
  inr l
  mvi m, 35
  ; 7 while((VG75[1] & 0x20) == 0); 
l377:
  lda 49153
  ani 32
  jnz l378
  jmp l377
l378:
  ; 8 while((VG75[1] & 0x20) == 0); 
l379:
  lda 49153
  ani 32
  jnz l380
  jmp l379
l380:
  ; 1 ((uchar*)0xE000)
  lxi h, 57352
  mvi m, 128
  ; 1 ((uchar*)0xE000)
  mvi l, 4
  mvi m, 208
  ; 1 ((uchar*)0xE000)
  mvi m, 118
  ; 1 ((uchar*)0xE000)
  inr l
  mvi m, 28
  ; 1 ((uchar*)0xE000)
  mvi m, 73
  ; 1 ((uchar*)0xE000)
  mvi l, 8
  mvi m, 164
  ; 15 if(CHAR_GEN) asm { ei } else asm { di } 15 asm { ei } else asm { di } 15 asm { di } 
 di 
  pop b
  ret
  ; --- directCursor -----------------------------------------------------------------
directCursor:
  sta directCursor_2
  ; 1 ((uchar*)0xC000)
  lxi h, 49153
  mvi m, 128
  ; 1 ((uchar*)0xC000)
  lda directCursor_1
  sta 49152
  ; 1 ((uchar*)0xC000)
  lda directCursor_2
  sta 49152
  ret
  ; --- charAddr -----------------------------------------------------------------
charAddr:
  sta charAddr_2
  ; 4 return radio86rkVideoMem + y * radio86rkVideoBpl + x;
  lxi h, radio86rkVideoBpl
  mov d, m
  call op_mul
  ; Сложение
  xchg
  lhld radio86rkVideoMem
  dad d
  ; Сложение
  xchg
  lhld charAddr_1
  mvi h, 0
  dad d
  ret
  ; --- print2 -----------------------------------------------------------------
print2:
  shld print2_2
  ; 4 asm {
    xchg
    lhld print2_1
print2_loop:
    ldax d
    ora  a
    rz
    ani  07Fh
    mov  m, a
    inx  h
    inx  d
    jmp  print2_loop
  
  ret
  ; --- op_mod -----------------------------------------------------------------
op_mod:
    PUSH B
    MOV E, A
    LXI H, 8
    MVI C, 0
op_mod_1:
    MOV A,E
    RAL
    MOV E,A
    MOV A,C
    RAL
    SUB D
    JNC op_mod_2
    ADD D
op_mod_2:
    MOV C,A ; Остаток в С
    CMC
    MOV A,H
    RAL
    MOV H,A ; Частное в Н
    DCR L
    JNZ op_mod_1
    MOV A, C
    POP B
  
  ret
  ; --- print -----------------------------------------------------------------
print:
  shld print_3
  ; 4 print2(charAddr(x, y), text);
  lda print_1
  sta charAddr_1
  lda print_2
  call charAddr
  shld print2_1
  lhld print_3
  jmp print2
printn:
  shld printn_4
  ; 4 print2n(charAddr(x, y), len, text);
  lda printn_1
  sta charAddr_1
  lda printn_2
  call charAddr
  shld print2n_1
  lda printn_3
  sta print2n_2
  lhld printn_4
  jmp print2n
print2n:
  shld print2n_3
  ; 4 asm {
    push b
    xchg
    lhld print2n_1
    lda print2n_2
    mov b, a
print2n_loop:
    ldax d
    ora  a
    jz   print2n_ret
    ani  07Fh
    mov  m, a
    inx  h
    inx  d
    dcr b
    jnz  print2n_loop 
print2n_ret:
    pop b
  
  ret
  ; --- print2cn -----------------------------------------------------------------
print2cn:
  sta print2cn_3
  ; 4 asm {
    ani  07Fh
    mov  d, a
    lda  print2cn_2    
    lhld print2cn_1
print2cn_loop:
    mov  m, d
    inx  h
    dcr  a
    jnz  print2cn_loop
  
  ret
  ; --- printm -----------------------------------------------------------------
printm:
  shld printm_4
  ; 4 print2m(charAddr(x, y), len, text);
  lda printm_1
  sta charAddr_1
  lda printm_2
  call charAddr
  shld print2m_1
  lda printm_3
  sta print2m_2
  lhld printm_4
  jmp print2m
printcn:
  sta printcn_4
  ; 4 print2cn(charAddr(x, y),len, c);
  lda printcn_1
  sta charAddr_1
  lda printcn_2
  call charAddr
  shld print2cn_1
  lda printcn_3
  sta print2cn_2
  lda printcn_4
  jmp print2cn
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
  ; --- print2m -----------------------------------------------------------------
print2m:
  shld print2m_3
  ; 4 asm {
    push b
    xchg
    lhld print2m_1
    lda print2m_2
    mov b, a
print2m_loop:
    ldax d
    ora  a
    jz   print2m_ret
    inx  d
print2m_ret:
    ani  07Fh
    mov  m, a
    inx  h
    dcr b
    jnz  print2m_loop 
    pop b
  
  ret
editorApp:
  .db 66,79,79,84,47,69,68,73,84,46,82,75
  .db 0

viewerApp:
  .db 66,79,79,84,47,86,73,69,87,46,82,75
  .db 0

panelA:
 .ds 266
panelB:
 .ds 266
cmdline:
 .ds 256
maxFiles:
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

getSel_n:
 .ds 2
getSelNoBack_f:
 .ds 2
drawFileInfo_f:
 .ds 2
drawFileInfo_buf:
 .ds 18
drawFilesCount_total:
 .ds 4
drawFilesCount_i:
 .ds 2
drawFilesCount_filesCnt:
 .ds 2
drawFilesCount_p:
 .ds 2
processInput_1:
 .ds 1
drawError_1:
 .ds 2
drawError_2:
 .ds 1
drawError_buf:
 .ds 4
inputBox_1:
 .ds 2
confirm_1:
 .ds 2
confirm_2:
 .ds 2
unpackName_1:
 .ds 2
unpackName_2:
 .ds 2
catPathAndUnpack_1:
 .ds 2
catPathAndUnpack_2:
 .ds 2
catPathAndUnpack_len:
 .ds 2
nextSelectedCnt:
 .ds 2
nextSelectedFile:
 .dw $+2
 .ds 20
getFirstSelected_1:
 .ds 2
getFirstSelected_type:
 .ds 1
getNextSelected_1:
 .ds 2
cmpFileInfo_1:
 .ds 2
cmpFileInfo_2:
 .ds 2
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
packName_1:
 .ds 2
packName_2:
 .ds 2
packName_i:
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
selectFile_1:
 .ds 2
selectFile_f:
 .ds 2
reloadFiles_1:
 .ds 2
absolutePath_1:
 .ds 2
absolutePath_l:
 .ds 2
getName_1:
 .ds 2
getName_p:
 .ds 2
dropPathInt_1:
 .ds 2
dropPathInt_2:
 .ds 2
dropPathInt_p:
 .ds 2
dropPath_buf:
 .ds 11
cursor_right_w:
 .ds 2
dupFiles_1:
 .ds 1
loadState_i:
 .ds 2
run_1:
 .ds 2
run_2:
 .ds 2
cmd_editview_1:
 .ds 2
cmd_editview_f:
 .ds 2
cmd_enter_d:
 .ds 2
cmd_enter_i:
 .ds 1
cmd_enter_f:
 .ds 2
cmd_enter_l:
 .ds 2
cmd_enter_o:
 .ds 2
cmd_inverseOne_f:
 .ds 2
cmd_inverseAll_f:
 .ds 2
cmd_inverseAll_i:
 .ds 2
cmd_copyFile_1:
 .ds 2
cmd_copyFile_2:
 .ds 2
cmd_copyFile_buf:
 .ds 16
cmd_copyFile_e:
 .ds 1
cmd_copyFile_progress_i:
 .ds 1
cmd_copyFile_progress:
 .ds 4
cmd_copyFile_progress_x:
 .ds 4
cmd_copyFile_progress_step:
 .ds 4
applyMask1_1:
 .ds 2
applyMask1_2:
 .ds 2
applyMask1_3:
 .ds 1
cmd_copyFolder_1:
 .ds 2
cmd_copyFolder_2:
 .ds 2
cmd_copyFolder_e:
 .ds 1
cmd_copyFolder_i:
 .ds 2
cmd_copyFolder_level:
 .ds 1
cmd_copyFolder_stack:
 .ds 16
cmd_copyFolder_f:
 .ds 2
applyMask_1:
 .ds 2
applyMask_2:
 .ds 2
cmd_copymove1_1:
 .ds 1
cmd_copymove1_2:
 .ds 1
cmd_copymove1_name:
 .ds 2
cmd_copymove1_e:
 .ds 1
cmd_copymove1_f:
 .ds 2
cmd_copymove1_sourceFile:
 .ds 256
cmd_copymove1_mask:
 .ds 11
cmd_copymove1_forMask:
 .ds 11
cmd_copymove1_type:
 .ds 1
cmd_copymove1_i:
 .ds 2
cmd_copymove_1:
 .ds 1
cmd_copymove_2:
 .ds 1
cmd_new1_1:
 .ds 1
cmd_new_1:
 .ds 1
cmd_freespace_1_1:
 .ds 1
cmd_freespace_1_2:
 .ds 2
cmd_freespace_1_buf:
 .ds 17
cmd_freespace_e:
 .ds 1
cmd_deleteFolder_level:
 .ds 1
cmd_deleteFolder_e:
 .ds 1
cmd_deleteFolder_p:
 .ds 2
cmd_deleteFolder_i:
 .ds 2
cmd_delete_e:
 .ds 1
cmd_delete_needRefresh2:
 .ds 1
compareMask1_1:
 .ds 2
compareMask1_2:
 .ds 2
compareMask1_3:
 .ds 1
compareMask_1:
 .ds 2
compareMask_2:
 .ds 2
cmd_sel_1:
 .ds 1
cmd_sel_f:
 .ds 2
cmd_sel_i:
 .ds 2
cmd_sel_buf:
 .ds 11
activePanel:
 .ds 1
fileCursorAddr:
 .dw $+2
 .ds 1
showTextCursor_1:
 .ds 1
showTextCursor_2:
 .ds 1
vLine_1:
 .ds 2
vLine_2:
 .ds 1
vLine_3:
 .ds 1
drawRect_1:
 .ds 2
drawRect_2:
 .ds 1
drawRect_3:
 .ds 1
drawRect_i:
 .ds 1
fillRect_1:
 .ds 2
fillRect_2:
 .ds 1
fillRect_3:
 .ds 1
fillRect_4:
 .ds 1
drawFilesCountInt_1:
 .ds 2
drawFilesCountInt_2:
 .ds 2
drawFilesCountInt_v:
 .ds 1
drawFilesCountInt_a:
 .ds 2
drawPanel_1:
 .ds 2
drawPanelTitle_1:
 .ds 1
drawPanelTitle_p:
 .ds 2
drawPanelTitle_l:
 .ds 2
drawPanelTitle_x:
 .ds 1
drawFile2_1:
 .ds 2
drawFile2_2:
 .ds 2
drawColumn_1:
 .ds 1
drawColumn_a:
 .ds 2
drawColumn_y:
 .ds 1
drawColumn_f:
 .ds 2
drawFile_1:
 .ds 1
drawFile_2:
 .ds 1
drawFile_3:
 .ds 2
drawFileInfo1_1:
 .ds 2
drawFileInfo2_1:
 .ds 2
drawCmdLineWithPath_l:
 .ds 2
drawCmdLineWithPath_old:
 .ds 2
drawWindow_1:
 .ds 2
drawWindowText_1:
 .ds 1
drawWindowText_2:
 .ds 1
drawWindowText_3:
 .ds 2
drawWindowProgress_1:
 .ds 1
drawWindowProgress_2:
 .ds 1
drawWindowProgress_3:
 .ds 1
drawWindowProgress_4:
 .ds 1
drawInput_1:
 .ds 1
drawInput_2:
 .ds 1
drawInput_3:
 .ds 1
drawInput_c1:
 .ds 2
drawInput_old:
 .ds 2
drawInput_cmdline_offset:
 .ds 2
drawInput_cmdline_pos:
 .ds 2
drawWindowInput_1:
 .ds 1
drawWindowInput_2:
 .ds 1
drawWindowInput_3:
 .ds 1
memswap_1:
 .ds 2
memswap_2:
 .ds 2
memswap_3:
 .ds 2
i2s32_1:
 .ds 2
i2s32_2:
 .ds 2
i2s32_3:
 .ds 2
i2s32_4:
 .ds 1
i2s32_v:
 .ds 4
i2s_1:
 .ds 2
i2s_2:
 .ds 2
i2s_3:
 .ds 2
i2s_4:
 .ds 1
add32_32_1:
 .ds 2
add32_32_2:
 .ds 2
strlen_1:
 .ds 2
memcmp_1:
 .ds 2
memcmp_2:
 .ds 2
memcmp_3:
 .ds 2
op_div16_mod:
 .ds 2
memset_1:
 .ds 2
memset_2:
 .ds 1
memset_3:
 .ds 2
memcpy_1:
 .ds 2
memcpy_2:
 .ds 2
memcpy_3:
 .ds 2
fs_findfirst_1:
 .ds 2
fs_findfirst_2:
 .ds 2
fs_findfirst_3:
 .ds 2
strcpy_1:
 .ds 2
strcpy_2:
 .ds 2
memcpy_back_1:
 .ds 2
memcpy_back_2:
 .ds 2
memcpy_back_3:
 .ds 2
strchr_1:
 .ds 2
strchr_2:
 .ds 1
strcmp_1:
 .ds 2
strcmp_2:
 .ds 2
strcmp_a:
 .ds 1
strcmp_b:
 .ds 1
fs_open_1:
 .ds 2
fs_read_1:
 .ds 2
fs_read_2:
 .ds 2
fs_create_1:
 .ds 2
fs_write_1:
 .ds 2
fs_write_2:
 .ds 2
fs_exec_1:
 .ds 2
fs_exec_2:
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
set32_1:
 .ds 2
set32_2:
 .ds 2
div32_16_1:
 .ds 2
div32_16_2:
 .ds 2
div32_16_tmp:
 .ds 2
add32_16_1:
 .ds 2
add32_16_2:
 .ds 2
cmp32_32_1:
 .ds 2
cmp32_32_2:
 .ds 2
sub32_32_1:
 .ds 2
sub32_32_2:
 .ds 2
fs_delete_1:
 .ds 2
fs_mkdir_1:
 .ds 2
fs_move_1:
 .ds 2
fs_move_2:
 .ds 2
radio86rkScreen2a_i:
 .ds 1
directCursor_1:
 .ds 1
directCursor_2:
 .ds 1
charAddr_1:
 .ds 1
charAddr_2:
 .ds 1
print2_1:
 .ds 2
print2_2:
 .ds 2
radio86rkVideoMem:
 .dw 14018

radio86rkVideoBpl:
 .db 78

print_1:
 .ds 1
print_2:
 .ds 1
print_3:
 .ds 2
printn_1:
 .ds 1
printn_2:
 .ds 1
printn_3:
 .ds 1
printn_4:
 .ds 2
print2n_1:
 .ds 2
print2n_2:
 .ds 1
print2n_3:
 .ds 2
print2cn_1:
 .ds 2
print2cn_2:
 .ds 1
print2cn_3:
 .ds 1
printm_1:
 .ds 1
printm_2:
 .ds 1
printm_3:
 .ds 1
printm_4:
 .ds 2
printcn_1:
 .ds 1
printcn_2:
 .ds 1
printcn_3:
 .ds 1
printcn_4:
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
print2m_1:
 .ds 2
print2m_2:
 .ds 1
print2m_3:
 .ds 2
string13:
 .db 0
string20:
 .db 23,0
string49:
 .db 32,32,32,32,32,60,68,73,82,62,0
string16:
 .db 32,107,111,112,105,114,111,119,97,110,105,101,32,0
string22:
 .db 32,107,111,112,105,114,111,119,97,116,120,32,0
string30:
 .db 32,109,98,0
string31:
 .db 32,110,97,107,111,112,105,116,101,108,120,32,0
string0:
 .db 32,111,123,105,98,107,97,32,0
string24:
 .db 32,112,101,114,101,105,109,101,110,111,119,97,110,105,101,47,112,101,114,101,109,101,125,101,110,105,101,32,0
string23:
 .db 32,112,101,114,101,105,109,101,110,111,119,97,116,120,47,112,101,114,101,109,101,115,116,105,116,120,32,0
string41:
 .db 32,112,111,109,101,116,105,116,120,32,102,97,106,108,121,32,0
string28:
 .db 32,115,111,122,100,97,116,120,32,102,97,106,108,32,0
string27:
 .db 32,115,111,122,100,97,116,120,32,112,97,112,107,117,32,0
string36:
 .db 32,117,100,97,108,101,110,105,101,32,0
string37:
 .db 32,117,100,97,108,105,116,120,32,0
string40:
 .db 42,46,42,0
string15:
 .db 46,73,78,0
string14:
 .db 46,82,75,0
string21:
 .db 47,0
string53:
 .db 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,0
string50:
 .db 62,0
string46:
 .db 70,49,32,70,82,69,69,32,70,50,32,78,69,87,32,32,70,51,32,86,73,69,87,32,32,70,52,32,69,68,73,84,32,70,53,32,67,79,80,89,32,70,54,32,82,69,78,32,32,70,55,32,68,73,82,32,32,70,56,32,68,69,76,0
string47:
 .db 91,0
string51:
 .db 91,32,65,78,89,32,75,69,89,32,93,0
string52:
 .db 91,32,97,114,50,32,45,32,115,116,111,112,32,93,0
string12:
 .db 91,32,119,107,32,45,32,111,107,32,93,32,32,91,32,97,114,50,32,45,32,111,116,109,101,110,97,32,93,0
string48:
 .db 93,0
string42:
 .db 98,97,106,116,32,119,32,32,32,32,0
string7:
 .db 100,105,115,107,32,122,97,112,111,108,110,101,110,0
string8:
 .db 102,97,105,108,32,115,117,125,101,115,116,119,117,101,116,0
string4:
 .db 102,97,106,108,32,110,101,32,111,116,107,114,121,116,0
string44:
 .db 102,97,106,108,97,104,32,0
string43:
 .db 102,97,106,108,101,32,0
string45:
 .db 105,109,113,0
string11:
 .db 105,109,113,58,0
string17:
 .db 105,122,58,0
string6:
 .db 109,97,107,115,105,109,117,109,32,102,97,106,108,111,119,32,119,32,112,97,112,107,101,0
string1:
 .db 110,101,116,32,102,97,106,108,111,119,111,106,32,115,105,115,116,101,109,121,0
string25:
 .db 111,123,105,98,107,97,32,107,111,112,105,114,111,119,97,110,105,113,0
string2:
 .db 111,123,105,98,107,97,32,110,97,107,111,112,105,116,101,108,113,0
string26:
 .db 111,123,105,98,107,97,32,112,101,114,101,109,101,125,101,110,105,113,0
string29:
 .db 111,123,105,98,107,97,32,115,111,122,100,97,110,105,113,32,112,97,112,107,105,0
string39:
 .db 111,123,105,98,107,97,32,117,100,97,108,101,110,105,113,0
string33:
 .db 111,123,105,98,107,97,32,126,116,101,110,105,113,0
string3:
 .db 112,97,112,107,97,32,110,101,32,112,117,115,116,97,0
string9:
 .db 112,114,101,114,119,97,110,111,32,112,111,108,120,122,111,119,97,116,101,108,101,109,0
string32:
 .db 112,114,111,119,101,114,107,97,46,46,46,0
string10:
 .db 112,117,116,120,32,98,111,108,120,123,101,32,50,53,53,32,115,105,109,119,111,108,111,119,0
string5:
 .db 112,117,116,120,32,110,101,32,110,97,106,100,101,110,0
string19:
 .db 115,107,111,112,105,114,111,119,97,110,111,32,32,32,32,32,32,32,32,32,32,32,47,32,32,32,32,32,32,32,32,32,32,32,98,97,106,116,0
string34:
 .db 115,119,111,98,111,100,110,111,58,32,0
string18:
 .db 119,58,0
string35:
 .db 119,115,101,103,111,58,0
string38:
 .db 119,121,32,104,111,116,105,116,101,32,117,100,97,108,105,116,120,32,102,97,105,108,40,121,41,63,0
  .end
