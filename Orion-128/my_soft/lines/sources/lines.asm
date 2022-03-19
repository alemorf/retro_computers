  .include "stdlib8080.inc"
i2s:
  shld i2s_2
  ; 37 *buf = ' '; ++buf;
  lhld i2s_1
  mvi m, 32
  ; 37 ++buf;
  inx h
  shld i2s_1
  ; 38 *buf = ' '; ++buf;
  mvi m, 32
  ; 38 ++buf;
  inx h
  shld i2s_1
  ; 39 *buf = ' '; ++buf;
  mvi m, 32
  ; 39 ++buf;
  inx h
  shld i2s_1
  ; 40 *buf = ' '; ++buf;
  mvi m, 32
  ; 40 ++buf;
  inx h
  shld i2s_1
  ; 41 for(i=0; i<5; i++) {
  xra a
  sta i2s_i
l0:
  lda i2s_i
  cpi 5
  jnc l1
  ; 42 x/=10, *buf = (uchar)op_div16_mod + '0', --buf; 
  lxi d, 10
  lhld i2s_2
  call op_div16
  shld i2s_2
  lda op_div16_mod
  adi 48
  lhld i2s_1
  mov m, a
  lhld i2s_1
  dcx h
  shld i2s_1
  ; 43 if(x==0) break;Сложение с константой 0
  lhld i2s_2
  mov a, l
  ora h
  jz l1
l2:
  lxi h, i2s_i
  mov a, m
  inr m
  jmp l0
l1:
  ret
  ; --- drawScore1 -----------------------------------------------------------------
drawScore1:
  xra a
  sta (drawScore1_buf)+(5)
  ; 50 i2s(buf, score);
  lxi h, drawScore1_buf
  shld i2s_1
  lhld score
  call i2s
  ; 51 drawScore(score, buf);
  lhld score
  shld drawScore_1
  lxi h, drawScore1_buf
  jmp drawScore
drawCell:
  sta drawCell_2
  ; 55 drawSprite(x, y, game[x][y]);
  lda drawCell_1
  sta drawSprite_1
  lda drawCell_2
  sta drawSprite_2
  lhld drawCell_1
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld drawCell_2
  mvi h, 0
  dad d
  mov a, m
  jmp drawSprite
drawCells:
  xra a
  sta drawCells_y
l4:
  lda drawCells_y
  cpi 9
  jnc l5
  ; 61 for(x=0; x<9; x++)
  xra a
  sta drawCells_x
l7:
  lda drawCells_x
  cpi 9
  jnc l8
  ; 62 drawCell(x,y);
  sta drawCell_1
  lda drawCells_y
  call drawCell
l9:
  lxi h, drawCells_x
  mov a, m
  inr m
  jmp l7
l8:
l6:
  lxi h, drawCells_y
  mov a, m
  inr m
  jmp l4
l5:
  ; 63 drawCursor();
  jmp drawCursor
clearCursor:
  lda cursorX
  sta drawCell_1
  lda cursorY
  jmp drawCell
clearLine:
  push b
  sta clearLine_5
  ; 76 c =  game[x0][y0];
  lhld clearLine_1
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld clearLine_2
  mvi h, 0
  dad d
  mov b, m
  ; 78 for(o=0; o<4; o++) {
  xra a
  sta clearLine_o
l10:
  lda clearLine_o
  cpi 4
  jnc l11
  ; 79 for(x=x0, y=y0, i=n; i; --i, x=x+dx, y=y+dy)
  lda clearLine_1
  mov c, a
  lda clearLine_2
  sta clearLine_y
  lda clearLine_5
  sta clearLine_i
l13:
  ; convertToConfition
  lda clearLine_i
  ora a
  jz l14
  ; 80 drawSpriteRemove(x, y, c, o);
  mov a, c
  sta drawSpriteRemove_1
  lda clearLine_y
  sta drawSpriteRemove_2
  mov a, b
  sta drawSpriteRemove_3
  lda clearLine_o
  call drawSpriteRemove
l15:
  lxi h, clearLine_i
  dcr m
  lda clearLine_3
  add c
  mov c, a
  lxi h, clearLine_4
  lda clearLine_y
  add m
  sta clearLine_y
  jmp l13
l14:
  ; 81 delay(ANIMATION_SPEED);
  mvi a, 64
  call delay
l12:
  lxi h, clearLine_o
  mov a, m
  inr m
  jmp l10
l11:
  ; 85 for(x=x0, y=y0, i=n; i; --i, x=x+dx, y=y+dy) {
  lda clearLine_1
  mov c, a
  lda clearLine_2
  sta clearLine_y
  lda clearLine_5
  sta clearLine_i
l16:
  ; convertToConfition
  lda clearLine_i
  ora a
  jz l17
  ; 86 game[x][y] = 0;
  mvi h, 0
  mov l, c
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld clearLine_y
  mvi h, 0
  dad d
  mvi m, 0
  ; 87 drawSprite(x, y, 0);
  mov a, c
  sta drawSprite_1
  lda clearLine_y
  sta drawSprite_2
  xra a
  call drawSprite
l18:
  lxi h, clearLine_i
  dcr m
  lda clearLine_3
  add c
  mov c, a
  lxi h, clearLine_4
  lda clearLine_y
  add m
  sta clearLine_y
  jmp l16
l17:
  pop b
  ret
  ; --- check -----------------------------------------------------------------
check:
  push b
  ; 97 0;<total>
  xra a
  sta check_total
  ; 100 for(y=0; y!=GAME_HEIGHT; ++y) {
  mov c, a
l19:
  mvi a, 9
  cmp c
  jz l20
  ; 101 for(p=&game[0][y], x=0; x<GAME_WIDTH;) {Сложение
  lhld (game)+(0)
  mov e, c
  mvi d, 0
  dad d
  shld check_p
  mov b, d
l22:
  mvi a, 9
  cmp b
  jc l23
  jz l23
  ; 102 prevx = x;
  mov a, b
  sta check_prevx
  ; 103 c = *p;
  lhld check_p
  mov a, m
  sta check_c
  ; 104 ++x;
  inr b
  ; 105 p += GAME_WIDTH;Сложение
  lxi d, 9
  dad d
  shld check_p
  ; 106 if(c==0) continue;
  ora a
  jz l24
l26:
  mov a, e
  cmp b
  jz l27
  mov a, m
  lxi h, check_c
  cmp m
  jnz l27
  ; 107 p+=GAME_WIDTH, ++x;Сложение
  lxi d, 9
  lhld check_p
  dad d
  shld check_p
  inr b
  jmp l26
l27:
  ; 108 n = x - prevx;Арифметика 1/4
  mov a, b
  lxi h, check_prevx
  sub m
  sta check_n
  ; 109 if(n<5) continue;
  cpi 5
  jc l24
  mov a, m
  sta clearLine_1
  mov a, c
  sta clearLine_2
  mvi a, 1
  sta clearLine_3
  xra a
  sta clearLine_4
  lda check_n
  call clearLine
  ; 111 total += n;
  lxi h, check_n
  lda check_total
  add m
  sta check_total
  ; 112 break;
  jmp l23
l24:
  jmp l22
l23:
l21:
  inr c
  jmp l19
l20:
  ; 115 for(x=0; x!=9; ++x) {
  mvi b, 0
l29:
  mvi a, 9
  cmp b
  jz l30
  ; 116 for(p=&game[x][0], y=0; y<5;) {
  mvi h, 0
  mov l, b
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение с константой 0
  mov e, m
  inx h
  mov d, m
  xchg
  shld check_p
  mvi c, 0
l32:
  mvi a, 5
  cmp c
  jc l33
  jz l33
  ; 117 c = *p;  
  lhld check_p
  mov a, m
  sta check_c
  ; 118 prevy = y;
  mov a, c
  sta check_prevy
  ; 119 ++y;
  inr c
  ; 120 ++p;
  inx h
  shld check_p
  ; 121 if(c==0) continue;
  lda check_c
  ora a
  jz l34
l36:
  mvi a, 9
  cmp c
  jz l37
  mov a, m
  lxi h, check_c
  cmp m
  jnz l37
  ; 122 ++p, ++y;
  lhld check_p
  inx h
  shld check_p
  inr c
  jmp l36
l37:
  ; 123 n = y - prevy;Арифметика 2/4
  mov a, c
  lxi h, check_prevy
  sub m
  sta check_n
  ; 124 if(n<5) continue;      
  cpi 5
  jc l34
  mov a, b
  sta clearLine_1
  mov a, m
  sta clearLine_2
  xra a
  sta clearLine_3
  inr a
  sta clearLine_4
  lda check_n
  call clearLine
  ; 126 total += n;
  lxi h, check_n
  lda check_total
  add m
  sta check_total
  ; 127 break;
  jmp l33
l34:
  jmp l32
l33:
l31:
  inr b
  jmp l29
l30:
  ; 130 for(y=0; y!=6; ++y) {
  mvi c, 0
l39:
  mvi a, 6
  cmp c
  jz l40
  ; 131 for(x=0; x!=6; ++x) {
  mvi b, 0
l42:
  mvi a, 6
  cmp b
  jz l43
  ; 132 p = &game[x][y];
  mvi h, 0
  mov l, b
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  xchg
  mov e, c
  mvi d, 0
  dad d
  shld check_p
  ; 133 c = *p;  
  mov a, m
  sta check_c
  ; 134 if(c==0) continue;
  ora a
  jz l44
  mov a, b
  sta check_prevx
  ; 136 prevy = y;
  mov a, c
  sta check_prevy
  ; 137 while(1) {
l46:
  ; 138 ++prevy;
  lxi h, check_prevy
  inr m
  ; 139 ++prevx;
  lxi h, check_prevx
  inr m
  ; 140 p += GAME_WIDTH+1;Сложение
  lxi d, 10
  lhld check_p
  dad d
  shld check_p
  ; 141 if(prevx==9) break;
  lda check_prevx
  cpi 9
  jz l47
  lda check_prevy
  cpi 9
  jz l47
  mov a, m
  lxi h, check_c
  cmp m
  jnz l47
  jmp l46
l47:
  ; 145 n = prevy-y;Арифметика 4/2
  lda check_prevy
  sub c
  sta check_n
  ; 146 if(n<5) continue;
  cpi 5
  jc l44
  mov a, b
  sta clearLine_1
  mov a, c
  sta clearLine_2
  mvi a, 1
  sta clearLine_3
  sta clearLine_4
  lda check_n
  call clearLine
  ; 148 total += n;
  lxi h, check_n
  lda check_total
  add m
  sta check_total
l44:
  inr b
  jmp l42
l43:
l41:
  inr c
  jmp l39
l40:
  ; 151 for(y=0; y!=6; ++y) {
  mvi c, 0
l52:
  mvi a, 6
  cmp c
  jz l53
  ; 152 for(x=4; x!=9; ++x) {
  mvi b, 4
l55:
  mvi a, 9
  cmp b
  jz l56
  ; 153 p = &game[x][y];
  mvi h, 0
  mov l, b
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  xchg
  mov e, c
  mvi d, 0
  dad d
  shld check_p
  ; 154 c = *p;  
  mov a, m
  sta check_c
  ; 155 if(c==0) continue;
  ora a
  jz l57
  mov a, b
  sta check_prevx
  ; 157 prevy = y;
  mov a, c
  sta check_prevy
  ; 158 while(1) {
l59:
  ; 159 ++prevy;
  lxi h, check_prevy
  inr m
  ; 160 --prevx;
  lxi h, check_prevx
  dcr m
  ; 161 p += 1-GAME_WIDTH;Сложение
  lxi d, 65528
  lhld check_p
  dad d
  shld check_p
  ; 162 if(prevx==-1) break;
  lda check_prevx
  cpi -1
  jz l60
  lda check_prevy
  cpi 9
  jz l60
  mov a, m
  lxi h, check_c
  cmp m
  jnz l60
  jmp l59
l60:
  ; 166 n = prevy-y;Арифметика 4/2
  lda check_prevy
  sub c
  sta check_n
  ; 167 if(n<5) continue;
  cpi 5
  jc l57
  mov a, b
  sta clearLine_1
  mov a, c
  sta clearLine_2
  mvi a, 255
  sta clearLine_3
  mvi a, 1
  sta clearLine_4
  lda check_n
  call clearLine
  ; 169 total += n;
  lxi h, check_n
  lda check_total
  add m
  sta check_total
l57:
  inr b
  jmp l55
l56:
l54:
  inr c
  jmp l52
l53:
  ; 172 if(total==0) return 0;
  lda check_total
  ora a
  jnz l65
  ; 172 return 0;
  xra a
  pop b
  ret
l65:
  ; 175 score += total*2;
  lhld check_total
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  xchg
  lhld score
  dad d
  shld score
  ; 176 drawScore1();
  call drawScore1
  ; 177 return 1;
  mvi a, 1
  pop b
  ret
  ; --- calcFreeCell -----------------------------------------------------------------
calcFreeCell:
  push b
  ; 186 for(c=0, p=&game[0][0], i=81; i; --i, ++p)
  xra a
  sta calcFreeCell_c
  ; Сложение с константой 0
  lhld (game)+(0)
  mov b, h
  mov c, l
  mvi a, 81
  sta calcFreeCell_i
l66:
  ; convertToConfition
  lda calcFreeCell_i
  ora a
  jz l67
  ; 187 if(*p==0)
  ldax b
  ora a
  jnz l69
  ; 188 c++;
  lxi h, calcFreeCell_c
  inr m
l69:
l68:
  lxi h, calcFreeCell_i
  dcr m
  inx b
  jmp l66
l67:
  ; 189 return c;
  lda calcFreeCell_c
  pop b
  ret
  ; --- newBall -----------------------------------------------------------------
newBall:
  push b
  sta newBall_1
  ; 202 c = calcFreeCell();
  call calcFreeCell
  sta newBall_c
  ; 203 if(c==0) { nx=-1; gameover=1; return; }
  ora a
  jnz l70
  ; 203 nx=-1; gameover=1; return; }
  mvi a, 255
  sta nx
  ; 203 gameover=1; return; }
  mvi a, 1
  sta gameOver
  ; 203 return; }
  pop b
  ret
l70:
  ; 206 c = rand()%c;
  call rand
  lxi h, newBall_c
  mov d, m
  call op_mod
  sta newBall_c
  ; 209 for(p=&game[0][0], i=81; i; --i, ++p)Сложение с константой 0
  lhld (game)+(0)
  mov b, h
  mov c, l
  mvi a, 81
  sta newBall_i
l71:
  ; convertToConfition
  lda newBall_i
  ora a
  jz l72
  ; 210 if(*p==0) {
  ldax b
  ora a
  jnz l74
  ; 211 if(c==0) break;
  lda newBall_c
  ora a
  jz l72
  lxi h, newBall_c
  dcr m
l74:
l73:
  lxi h, newBall_i
  dcr m
  inx b
  jmp l71
l72:
  ; 216 nx = (81-i)/9, ny = op_div_mod;Арифметика 3/4
  lxi h, newBall_i
  mvi a, 81
  sub m
  mvi d, 9
  call op_div
  sta nx
  lda op_div_mod
  sta ny
  ; 219 game[nx][ny] = color;
  lhld nx
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  mov l, a
  mvi h, 0
  dad d
  lda newBall_1
  mov m, a
  pop b
  ret
  ; --- randNewBall -----------------------------------------------------------------
randNewBall:
  call rand
  mvi d, 7
  call op_mod
  inr a
  sta newBall1
  ; 227 newBall2 = rand()%7+1;
  call rand
  mvi d, 7
  call op_mod
  inr a
  sta newBall2
  ; 228 newBall3 = rand()%7+1;
  call rand
  mvi d, 7
  call op_mod
  inr a
  sta newBall3
  ret
  ; --- redrawNewBalls1 -----------------------------------------------------------------
redrawNewBalls1:
  lda showHelp
  ora a
  jz l76
  ; 234 redrawNewBalls(newBall1, newBall2, newBall3);
  lda newBall1
  sta redrawNewBalls_1
  lda newBall2
  sta redrawNewBalls_2
  lda newBall3
  call redrawNewBalls
l76:
  ret
  ; --- redrawNewBalls2 -----------------------------------------------------------------
redrawNewBalls2:
  lda showHelp
  ora a
  jz l77
  ; 238 redrawNewBalls1(); else redrawNewBallsOff();
  call redrawNewBalls1
  jmp l78
l77:
  ; 238 redrawNewBallsOff();
  call redrawNewBallsOff
l78:
  ret
  ; --- gameStep -----------------------------------------------------------------
gameStep:
  call check
  ; convertToConfition
  ora a
  jnz l79
  ; 251 newBall(newBall1); nx1=nx; ny1=ny;
  lda newBall1
  call newBall
  ; 251 nx1=nx; ny1=ny;
  lda nx
  sta gameStep_nx1
  ; 251 ny1=ny;
  lda ny
  sta gameStep_ny1
  ; 252 newBall(newBall2); nx2=nx; ny2=ny;
  lda newBall2
  call newBall
  ; 252 nx2=nx; ny2=ny;
  lda nx
  sta gameStep_nx2
  ; 252 ny2=ny;
  lda ny
  sta gameStep_ny2
  ; 253 newBall(newBall3);
  lda newBall3
  call newBall
  ; 256 for(o=0; o<5; o++) {
  xra a
  sta gameStep_o
l80:
  lda gameStep_o
  cpi 5
  jnc l81
  ; 257 if(nx1!=-1) drawSpriteNew(nx1, ny1, newBall1, o);
  lda gameStep_nx1
  cpi -1
  jz l83
  ; 257 drawSpriteNew(nx1, ny1, newBall1, o);
  sta drawSpriteNew_1
  lda gameStep_ny1
  sta drawSpriteNew_2
  lda newBall1
  sta drawSpriteNew_3
  lda gameStep_o
  call drawSpriteNew
l83:
  ; 258 if(nx2!=-1) drawSpriteNew(nx2, ny2, newBall2, o);
  lda gameStep_nx2
  cpi -1
  jz l84
  ; 258 drawSpriteNew(nx2, ny2, newBall2, o);
  sta drawSpriteNew_1
  lda gameStep_ny2
  sta drawSpriteNew_2
  lda newBall2
  sta drawSpriteNew_3
  lda gameStep_o
  call drawSpriteNew
l84:
  ; 259 if(nx !=-1) drawSpriteNew(nx,  ny,  newBall3, o);
  lda nx
  cpi -1
  jz l85
  ; 259 drawSpriteNew(nx,  ny,  newBall3, o);
  sta drawSpriteNew_1
  lda ny
  sta drawSpriteNew_2
  lda newBall3
  sta drawSpriteNew_3
  lda gameStep_o
  call drawSpriteNew
l85:
  ; 260 delay(ANIMATION_SPEED);
  mvi a, 64
  call delay
l82:
  lxi h, gameStep_o
  mov a, m
  inr m
  jmp l80
l81:
  ; 264 randNewBall();
  call randNewBall
  ; 265 redrawNewBalls1();
  call redrawNewBalls1
  ; 267 if(!gameOver) {    convertToConfition
  lda gameOver
  ora a
  jnz l86
  ; 269 check();
  call check
  ; 272 if(calcFreeCell()==0) gameOver=1;
  call calcFreeCell
  ora a
  jnz l87
  ; 272 gameOver=1;
  mvi a, 1
  sta gameOver
l87:
l86:
l79:
  ; 276 drawCursor(); 
  jmp drawCursor
path_find:
  push b
  ; 294 path_c = game[selX][selY];  
  lhld selX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld selY
  mvi h, 0
  dad d
  mov a, m
  sta path_c
  ; 295 game[selX][selY] = 255;
  lhld selX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld selY
  mvi h, 0
  dad d
  mvi m, 255
  ; 296 game[cursorX][cursorY] = PATH_START_VAL;
  lhld cursorX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld cursorY
  mvi h, 0
  dad d
  mvi a, 10
  mov m, a
  ; 299 for(path_n = PATH_START_VAL; path_n != PATH_START_VAL+GAME_WIDTH*GAME_HEIGHT; ++path_n)
  sta path_n
l88:
  lda path_n
  cpi 91
  jz l89
  ; 300 for(p = &game[0][0], path_x=0; path_x != GAME_WIDTH; ++path_x)Сложение с константой 0
  lhld (game)+(0)
  mov b, h
  mov c, l
  xra a
  sta path_x
l91:
  lda path_x
  cpi 9
  jz l92
  ; 301 for(path_y=0; path_y != GAME_HEIGHT; ++path_y, ++p)
  xra a
  sta path_y
l94:
  lda path_y
  cpi 9
  jz l95
  ; 302 if(*p == path_n) {
  lxi h, path_n
  ldax b
  cmp m
  jnz l97
  ; 303 if(path_y != 0            ) { p-=1;           if(*p==255) { --path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
  lda path_y
  ora a
  jz l98
  ; 303 p-=1;           if(*p==255) { --path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }Сложение BC с константой -1
  dcx b
  ; 303 if(*p==255) { --path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
  ldax b
  cpi 255
  jnz l99
  ; 303 --path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
  lxi h, path_y
  dcr m
  ; 303 path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
  mov h, b
  mov l, c
  shld path_p
  ; 303 return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
  mvi a, 1
  pop b
  ret
  jmp l100
l99:
  ; 303 if(*p==0) *p=path_n+1; p+=1;           }
  ldax b
  ora a
  jnz l101
  ; 303 *p=path_n+1; p+=1;           }
  lda path_n
  inr a
  stax b
l101:
l100:
  ; 303 p+=1;           }Сложение BC с константой 1
  inx b
l98:
  ; 304 if(path_y != GAME_HEIGHT-1) { p+=1;           if(*p==255) { ++path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
  lda path_y
  cpi 8
  jz l102
  ; 304 p+=1;           if(*p==255) { ++path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }Сложение BC с константой 1
  inx b
  ; 304 if(*p==255) { ++path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
  ldax b
  cpi 255
  jnz l103
  ; 304 ++path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
  lxi h, path_y
  inr m
  ; 304 path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
  mov h, b
  mov l, c
  shld path_p
  ; 304 return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
  mvi a, 1
  pop b
  ret
  jmp l104
l103:
  ; 304 if(*p==0) *p=path_n+1; p-=1;           }
  ldax b
  ora a
  jnz l105
  ; 304 *p=path_n+1; p-=1;           }
  lda path_n
  inr a
  stax b
l105:
l104:
  ; 304 p-=1;           }Сложение BC с константой -1
  dcx b
l102:
  ; 305 if(path_x != 0            ) { p-=GAME_HEIGHT; if(*p==255) { --path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  lda path_x
  ora a
  jz l106
  ; 305 p-=GAME_HEIGHT; if(*p==255) { --path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }Сложение с BC
  lxi h, 65527
  dad b
  mov b, h
  mov c, l
  ; 305 if(*p==255) { --path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  ldax b
  cpi 255
  jnz l107
  ; 305 --path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  lxi h, path_x
  dcr m
  ; 305 path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  mov h, b
  mov l, c
  shld path_p
  ; 305 return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  mvi a, 1
  pop b
  ret
  jmp l108
l107:
  ; 305 if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
  ldax b
  ora a
  jnz l109
  ; 305 *p=path_n+1; p+=GAME_HEIGHT; }
  lda path_n
  inr a
  stax b
l109:
l108:
  ; 305 p+=GAME_HEIGHT; }Сложение с BC
  lxi h, 9
  dad b
  mov b, h
  mov c, l
l106:
  ; 306 if(path_x != GAME_WIDTH -1) { p+=GAME_HEIGHT; if(*p==255) { ++path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  lda path_x
  cpi 8
  jz l110
  ; 306 p+=GAME_HEIGHT; if(*p==255) { ++path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }Сложение с BC
  lxi h, 9
  dad b
  mov b, h
  mov c, l
  ; 306 if(*p==255) { ++path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  ldax b
  cpi 255
  jnz l111
  ; 306 ++path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  lxi h, path_x
  inr m
  ; 306 path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  mov h, b
  mov l, c
  shld path_p
  ; 306 return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  mvi a, 1
  pop b
  ret
  jmp l112
l111:
  ; 306 if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
  ldax b
  ora a
  jnz l113
  ; 306 *p=path_n+1; p-=GAME_HEIGHT; }
  lda path_n
  inr a
  stax b
l113:
l112:
  ; 306 p-=GAME_HEIGHT; }Сложение с BC
  lxi h, 65527
  dad b
  mov b, h
  mov c, l
l110:
l97:
l96:
  lxi h, path_y
  inr m
  inx b
  jmp l94
l95:
l93:
  lxi h, path_x
  inr m
  jmp l91
l92:
l90:
  lxi h, path_n
  inr m
  jmp l88
l89:
  ; 310 path_end();
  call path_end
  ; 311 game[selX][selY] = path_c;
  lhld selX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld selY
  mvi h, 0
  dad d
  lda path_c
  mov m, a
  ; 312 return 0;
  xra a
  pop b
  ret
  ; --- path_nextStep -----------------------------------------------------------------
path_nextStep:
  push b
  ; 319 path_p;<p>
  lhld path_p
  mov b, h
  mov c, l
  ; 320 if(path_y != 0            ) { p -= 1;           if(*p == path_n) { --path_y; --path_n; path_p=p; return 1; } p+=1;           }
  lda path_y
  ora a
  jz l114
  ; 320 p -= 1;           if(*p == path_n) { --path_y; --path_n; path_p=p; return 1; } p+=1;           }Сложение BC с константой -1
  dcx b
  ; 320 if(*p == path_n) { --path_y; --path_n; path_p=p; return 1; } p+=1;           }
  lxi h, path_n
  ldax b
  cmp m
  jnz l115
  ; 320 --path_y; --path_n; path_p=p; return 1; } p+=1;           }
  lxi h, path_y
  dcr m
  ; 320 --path_n; path_p=p; return 1; } p+=1;           }
  lxi h, path_n
  dcr m
  ; 320 path_p=p; return 1; } p+=1;           }
  mov h, b
  mov l, c
  shld path_p
  ; 320 return 1; } p+=1;           }
  mvi a, 1
  pop b
  ret
l115:
  ; 320 p+=1;           }Сложение BC с константой 1
  inx b
l114:
  ; 321 if(path_y != GAME_HEIGHT-1) { p += 1;           if(*p == path_n) { ++path_y; --path_n; path_p=p; return 2; } p-=1;           }
  lda path_y
  cpi 8
  jz l116
  ; 321 p += 1;           if(*p == path_n) { ++path_y; --path_n; path_p=p; return 2; } p-=1;           }Сложение BC с константой 1
  inx b
  ; 321 if(*p == path_n) { ++path_y; --path_n; path_p=p; return 2; } p-=1;           }
  lxi h, path_n
  ldax b
  cmp m
  jnz l117
  ; 321 ++path_y; --path_n; path_p=p; return 2; } p-=1;           }
  lxi h, path_y
  inr m
  ; 321 --path_n; path_p=p; return 2; } p-=1;           }
  lxi h, path_n
  dcr m
  ; 321 path_p=p; return 2; } p-=1;           }
  mov h, b
  mov l, c
  shld path_p
  ; 321 return 2; } p-=1;           }
  mvi a, 2
  pop b
  ret
l117:
  ; 321 p-=1;           }Сложение BC с константой -1
  dcx b
l116:
  ; 322 if(path_x != 0            ) { p -= GAME_HEIGHT; if(*p == path_n) { --path_x; --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }
  lda path_x
  ora a
  jz l118
  ; 322 p -= GAME_HEIGHT; if(*p == path_n) { --path_x; --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }Сложение с BC
  lxi h, 65527
  dad b
  mov b, h
  mov c, l
  ; 322 if(*p == path_n) { --path_x; --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }
  lxi h, path_n
  ldax b
  cmp m
  jnz l119
  ; 322 --path_x; --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }
  lxi h, path_x
  dcr m
  ; 322 --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }
  lxi h, path_n
  dcr m
  ; 322 path_p=p; return 3; } p+=GAME_HEIGHT; }
  mov h, b
  mov l, c
  shld path_p
  ; 322 return 3; } p+=GAME_HEIGHT; }
  mvi a, 3
  pop b
  ret
l119:
  ; 322 p+=GAME_HEIGHT; }Сложение с BC
  lxi h, 9
  dad b
  mov b, h
  mov c, l
l118:
  ; 323 if(path_x != GAME_WIDTH -1) { p += GAME_HEIGHT; if(*p == path_n) { ++path_x; --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }
  lda path_x
  cpi 8
  jz l120
  ; 323 p += GAME_HEIGHT; if(*p == path_n) { ++path_x; --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }Сложение с BC
  lxi h, 9
  dad b
  mov b, h
  mov c, l
  ; 323 if(*p == path_n) { ++path_x; --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }
  lxi h, path_n
  ldax b
  cmp m
  jnz l121
  ; 323 ++path_x; --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }
  lxi h, path_x
  inr m
  ; 323 --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }
  lxi h, path_n
  dcr m
  ; 323 path_p=p; return 4; } p-=GAME_HEIGHT; }
  mov h, b
  mov l, c
  shld path_p
  ; 323 return 4; } p-=GAME_HEIGHT; }
  mvi a, 4
  pop b
  ret
l121:
  ; 323 p-=GAME_HEIGHT; }Сложение с BC
  lxi h, 65527
  dad b
  mov b, h
  mov c, l
l120:
  ; 324 while(1);
l122:
  jmp l122
l123:
  pop b
  ret
  ; --- path_save -----------------------------------------------------------------
path_save:
  lhld path_p
  shld path_p1
  ; 331 path_x1 = path_x; 
  lda path_x
  sta path_x1
  ; 332 path_y1 = path_y;
  lda path_y
  sta path_y1
  ; 333 path_n1 = path_n;
  lda path_n
  sta path_n1
  ret
  ; --- path_load -----------------------------------------------------------------
path_load:
  lhld path_p1
  shld path_p
  ; 340 path_x = path_x1;
  lda path_x1
  sta path_x
  ; 341 path_y = path_y1;
  lda path_y1
  sta path_y
  ; 342 path_n = path_n1;
  lda path_n1
  sta path_n
  ret
  ; --- path_end -----------------------------------------------------------------
path_end:
  push b
  ; 350 for(p=&game[0][0]; p != &game[8][8]+1; ++p)Сложение с константой 0
  lhld (game)+(0)
  mov b, h
  mov c, l
l124:
  ; Сложение
  lhld (game)+(16)
  lxi d, 8
  dad d
  ; Сложение с константой 1
  inx h
  mov d, b
  mov e, c
  call op_cmp16
  jz l125
  ; 351 if(*p >= PATH_START_VAL)
  ldax b
  cpi 10
  jc l127
  ; 352 *p=0;
  xra a
  stax b
l127:
l126:
  inx b
  jmp l124
l125:
  pop b
  ret
  ; --- move -----------------------------------------------------------------
move:
  call path_find
  ; convertToConfition
  ora a
  jnz l128
  ; 361 if(playSound) soundBadMove();convertToConfition
  lda playSound
  ora a
  cnz soundBadMove
  ret
l128:
  ; 365 if(showPath) {convertToConfition
  lda showPath
  ora a
  jz l130
  ; 367 path_save();
  call path_save
  ; 368 while(1) {
l131:
  ; 369 switch(path_nextStep()) {
  call path_nextStep
  cpi 1
  jz l134
  cpi 2
  jz l135
  cpi 3
  jz l136
  cpi 4
  jz l137
  jmp l133
l134:
  ; 370 drawSpriteStep(path_x, path_y+1, 0); break;
  lda path_x
  sta drawSpriteStep_1
  lda path_y
  inr a
  sta drawSpriteStep_2
  xra a
  call drawSpriteStep
  ; 370 break;
  jmp l133
l135:
  ; 371 drawSpriteStep(path_x, path_y-1, 1); break;
  lda path_x
  sta drawSpriteStep_1
  lda path_y
  dcr a
  sta drawSpriteStep_2
  mvi a, 1
  call drawSpriteStep
  ; 371 break;
  jmp l133
l136:
  ; 372 drawSpriteStep(path_x+1, path_y, 2); break;
  lda path_x
  inr a
  sta drawSpriteStep_1
  lda path_y
  sta drawSpriteStep_2
  mvi a, 2
  call drawSpriteStep
  ; 372 break;
  jmp l133
l137:
  ; 373 drawSpriteStep(path_x-1, path_y, 3); break;
  lda path_x
  dcr a
  sta drawSpriteStep_1
  lda path_y
  sta drawSpriteStep_2
  mvi a, 3
  call drawSpriteStep
  ; 373 break;
l133:
  ; 375 drawSprite(path_x, path_y, path_c);
  lda path_x
  sta drawSprite_1
  lda path_y
  sta drawSprite_2
  lda path_c
  call drawSprite
  ; 376 if(path_n==LAST_STEP) break;
  lda path_n
  cpi 9
  jz l132
  lda playSound
  ora a
  cnz soundJumpSel
  mvi a, 64
  call delay
  jmp l131
l132:
  ; 382 path_load();
  call path_load
  ; 383 while(1) {
l140:
  ; 384 drawSprite(path_x, path_y, 0);
  lda path_x
  sta drawSprite_1
  lda path_y
  sta drawSprite_2
  xra a
  call drawSprite
  ; 385 path_nextStep();
  call path_nextStep
  ; 386 if(path_n==LAST_STEP) break;
  lda path_n
  cpi 9
  jz l141
  jmp l140
l141:
  jmp l143
l130:
  ; 389 drawSprite(selX, selY, 0);
  lda selX
  sta drawSprite_1
  lda selY
  sta drawSprite_2
  xra a
  call drawSprite
  ; 390 drawSprite(cursorX, cursorY, path_c);
  lda cursorX
  sta drawSprite_1
  lda cursorY
  sta drawSprite_2
  lda path_c
  call drawSprite
l143:
  ; 394 game[cursorX][cursorY] = path_c;
  lhld cursorX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld cursorY
  mvi h, 0
  dad d
  lda path_c
  mov m, a
  ; 397 selX = -1;
  mvi a, 255
  sta selX
  ; 400 path_end();
  call path_end
  ; 403 gameStep();
  jmp gameStep
startGame:
  push b
  ; 412 selX = -1;
  mvi a, 255
  sta selX
  ; 413 score = 0;
  lxi h, 0
  shld score
  ; 414 gameOver = 0;
  xra a
  sta gameOver
  ; 417 initGameScreen();
  call initGameScreen
  ; 420 for(y=0; y!=GAME_HEIGHT; ++y)
  mvi c, 0
l144:
  mvi a, 9
  cmp c
  jz l145
  ; 421 for(x=0; x!=GAME_WIDTH; ++x)
  mvi b, 0
l147:
  mvi a, 9
  cmp b
  jz l148
  ; 422 game[x][y] = 0;
  mvi h, 0
  mov l, b
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  xchg
  mov e, c
  mvi d, 0
  dad d
  mvi m, 0
l149:
  inr b
  jmp l147
l148:
l146:
  inr c
  jmp l144
l145:
  ; 424 randNewBall();
  call randNewBall
  ; 425 gameStep();
  call gameStep
  pop b
  ret
  ; --- recordAnimation -----------------------------------------------------------------
recordAnimation:
  call prepareRecordScreen
  ; 442 if(score < hiScores[8].score) {
  lhld score
  xchg
  lhld ((hiScores)+(128))+(14)
  call op_cmp16
  jc l150
  jz l150
  ; 443 return; 
  ret
l150:
  ; 446 hiScores[8].score = score;
  lhld score
  shld ((hiScores)+(128))+(14)
  ; 448 memset(hiScores[8].name, 0, 6);
  lxi h, (hiScores)+(128)
  shld memset_1
  xra a
  sta memset_2
  lxi h, 6
  call memset
  ; 449 i = 0;
  xra a
  sta recordAnimation_i
  ; 451 drawRecordScreen(8);
  mvi a, 8
  call drawRecordScreen
  ; 453 while(1) {
l151:
  ; 454 c = getch_();
  call getch_
  sta recordAnimation_c
  ; 455 if(c==13) break;  
  cpi 13
  jz l152
  cpi 8
  jnz l154
  ; 457 if(i==0) continue;
  lda recordAnimation_i
  ora a
  jz l151
  lxi h, recordAnimation_i
  dcr m
  ; 459 hiScores[8].name[i] = 0;Сложение
  lhld recordAnimation_i
  mvi h, 0
  lxi d, (hiScores)+(128)
  dad d
  mvi m, 0
  ; 460 drawRecordLastLine();
  call drawRecordLastLine
  ; 461 continue;
  jmp l151
l154:
  ; 463 if(c>=32) {
  lda recordAnimation_c
  cpi 32
  jc l156
  ; 464 if(i==6) continue;
  lda recordAnimation_i
  cpi 6
  jz l151
  mov l, a
  mvi h, 0
  lxi d, (hiScores)+(128)
  dad d
  lda recordAnimation_c
  mov m, a
  ; 466 hiScores[8].name[i+1] = 0;
  lda recordAnimation_i
  inr a
  ; Сложение
  mvi h, 0
  mov l, a
  lxi d, (hiScores)+(128)
  dad d
  mvi m, 0
  ; 467 ++i;   
  lxi h, recordAnimation_i
  inr m
  ; 468 drawRecordLastLine();
  call drawRecordLastLine
l156:
  jmp l151
l152:
  ; 471 c = 8;
  mvi a, 8
  sta recordAnimation_c
  ; 472 p = hiScores+8;
  lxi h, (hiScores)+(128)
  shld recordAnimation_p
  ; 473 while(1) {
l158:
  ; 474 if(p->score < p[-1].score) break;    Сложение
  lhld recordAnimation_p
  lxi d, 14
  dad d
  ; Сложение
  push h
  lhld recordAnimation_p
  lxi d, 65520
  dad d
  ; Сложение
  lxi d, 14
  dad d
  mov e, m
  inx h
  mov d, m
  pop h
  mov a, m
  inx h
  mov h, m
  mov l, a
  call op_cmp16
  jc l159
  lhld recordAnimation_p
  push h
  lxi d, 65520
  dad d
  shld recordAnimation_p
  pop h
  ; 476 memcpy(&tmp, p+1, sizeof(tmp));
  lxi h, recordAnimation_tmp
  shld memcpy_1
  ; Сложение
  lhld recordAnimation_p
  lxi d, 16
  dad d
  shld memcpy_2
  lxi h, 16
  call memcpy
  ; 477 memcpy(p+1, p, sizeof(tmp));Сложение
  lhld recordAnimation_p
  lxi d, 16
  dad d
  shld memcpy_1
  lhld recordAnimation_p
  shld memcpy_2
  lxi h, 16
  call memcpy
  ; 478 memcpy(p, &tmp, sizeof(tmp));
  lhld recordAnimation_p
  shld memcpy_1
  lxi h, recordAnimation_tmp
  shld memcpy_2
  lxi h, 16
  call memcpy
  ; 479 c--;    
  lxi h, recordAnimation_c
  dcr m
  ; 480 drawRecordScreen(c);
  lda recordAnimation_c
  call drawRecordScreen
  ; 481 delay(RECORD_SPEED);
  mvi a, 64
  call delay
  ; 482 if(c==0) {
  lda recordAnimation_c
  ora a
  jnz l161
  ; 483 updateTopScore();      
  call updateTopScore
  ; 484 break;
  jmp l159
l161:
  jmp l158
l159:
  ; 488 getch_();
  jmp getch_
main:
  xra a
  sta main_selAnimationT
  ; 494 0, keybTimeout=0; <selAnimationTT>
  lxi h, 0
  shld main_selAnimationTT
  ; 494 0; <keybTimeout>
  shld main_keybTimeout
  ; 496 intro();
  call intro
  ; 499 startGame();
  call startGame
  ; 505 while(1) {
l162:
  ; 506 rand();
  call rand
  ; 508 if(selX!=-1) {
  lda selX
  cpi -1
  jz l164
  ; 509 selAnimationTT++;
  lhld main_selAnimationTT
  mov d, h
  mov e, l
  inx h
  shld main_selAnimationTT
  xchg
  ; 510 if(selAnimationTT==150) {Сложение
  lhld main_selAnimationTT
  lxi d, 65386
  dad d
  mov a, l
  ora h
  jnz l165
  ; 511 selAnimationTT=0;
  lxi h, 0
  shld main_selAnimationTT
  ; 512 drawSpriteSel(selX, selY, game[selX][selY], selX==cursorX && selY==cursorY, selAnimationT);
  lda selX
  sta drawSpriteSel_1
  lda selY
  sta drawSpriteSel_2
  lhld selX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld selY
  mvi h, 0
  dad d
  mov a, m
  sta drawSpriteSel_3
  lxi h, cursorX
  lda selX
  cmp m
  jnz l166
  lxi h, cursorY
  lda selY
  cmp m
  jnz l166
  mvi a, 1
  jmp l167
l166:
  xra a
l167:
  sta drawSpriteSel_4
  lda main_selAnimationT
  call drawSpriteSel
  ; 513 selAnimationT++;
  lxi h, main_selAnimationT
  inr m
  ; 514 if(selAnimationT>=6) selAnimationT=0; else
  lda main_selAnimationT
  cpi 6
  jc l168
  ; 514 selAnimationT=0; else
  xra a
  sta main_selAnimationT
  jmp l169
l168:
  ; 515 if(playSound && selAnimationT==2) soundJumpSel();convertToConfition
  lda playSound
  ora a
  jz l170
  lda main_selAnimationT
  cpi 2
  cz soundJumpSel
l170:
l169:
l165:
l164:
  ; 519 c1 = bioskey_();
  call bioskey_
  sta main_c1
  ; 521 if(keybTimeout) {convertToConfition
  lhld main_keybTimeout
  mov a, l
  ora h
  jz l171
  ; 522 keybTimeout--;
  mov d, h
  mov e, l
  dcx h
  shld main_keybTimeout
  xchg
  ; 523 continue;
  jmp l162
l171:
  ; 526 if(c == c1) continue;
  lxi h, main_c1
  lda main_c
  cmp m
  jz l162
  mov a, m
  sta main_c
  ; 529 switch(c) {
  cpi 1
  jz l174
  cpi 2
  jz l175
  cpi 3
  jz l176
  cpi 4
  jz l177
  cpi 5
  jz l179
  cpi 25
  jz l180
  cpi 26
  jz l183
  cpi 8
  jz l186
  cpi 24
  jz l189
  cpi 32
  jz l192
  jmp l197
l174:
  ; 530 showPath  = !showPath;  drawOnOff(0, showPath);  break;convertToConfition
  lda showPath
  ora a
  sui 1
  sbb a
  sta showPath
  ; 530 drawOnOff(0, showPath);  break;
  xra a
  sta drawOnOff_1
  lda showPath
  call drawOnOff
  ; 530 break;
  jmp l173
l175:
  ; 531 playSound = !playSound; drawOnOff(1, playSound); break;convertToConfition
  lda playSound
  ora a
  sui 1
  sbb a
  sta playSound
  ; 531 drawOnOff(1, playSound); break;
  mvi a, 1
  sta drawOnOff_1
  lda playSound
  call drawOnOff
  ; 531 break;
  jmp l173
l176:
  ; 532 showHelp  = !showHelp;  drawOnOff(2, showHelp);  redrawNewBalls2(); break;convertToConfition
  lda showHelp
  ora a
  sui 1
  sbb a
  sta showHelp
  ; 532 drawOnOff(2, showHelp);  redrawNewBalls2(); break;
  mvi a, 2
  sta drawOnOff_1
  lda showHelp
  call drawOnOff
  ; 532 redrawNewBalls2(); break;
  call redrawNewBalls2
  ; 532 break;
  jmp l173
l177:
  ; 534 prepareRecordScreen();
  call prepareRecordScreen
  ; 535 drawRecordScreen(-1);
  mvi a, 255
  call drawRecordScreen
  ; 536 getch_();
  call getch_
  ; 537 initGameScreen();
  call initGameScreen
  ; 538 if(showHelp) redrawNewBalls1();convertToConfition
  lda showHelp
  ora a
  cnz redrawNewBalls1
  call drawCells
  ; 540 break;
  jmp l173
l179:
  ; 541 startGame(); break;
  call startGame
  ; 541 break;
  jmp l173
l180:
  ; 551 clearCursor(); if(cursorY==0) cursorY=8; else cursorY--; drawCursor(); break;
  call clearCursor
  ; 551 if(cursorY==0) cursorY=8; else cursorY--; drawCursor(); break;
  lda cursorY
  ora a
  jnz l181
  ; 551 cursorY=8; else cursorY--; drawCursor(); break;
  mvi a, 8
  sta cursorY
  jmp l182
l181:
  ; 551 cursorY--; drawCursor(); break;
  lxi h, cursorY
  dcr m
l182:
  ; 551 drawCursor(); break;
  call drawCursor
  ; 551 break;
  jmp l173
l183:
  ; 552 clearCursor(); if(cursorY==8) cursorY=0; else cursorY++; drawCursor(); break;
  call clearCursor
  ; 552 if(cursorY==8) cursorY=0; else cursorY++; drawCursor(); break;
  lda cursorY
  cpi 8
  jnz l184
  ; 552 cursorY=0; else cursorY++; drawCursor(); break;
  xra a
  sta cursorY
  jmp l185
l184:
  ; 552 cursorY++; drawCursor(); break;
  lxi h, cursorY
  inr m
l185:
  ; 552 drawCursor(); break;
  call drawCursor
  ; 552 break;
  jmp l173
l186:
  ; 553 clearCursor(); if(cursorX==0) cursorX=8; else cursorX--; drawCursor(); break;
  call clearCursor
  ; 553 if(cursorX==0) cursorX=8; else cursorX--; drawCursor(); break;
  lda cursorX
  ora a
  jnz l187
  ; 553 cursorX=8; else cursorX--; drawCursor(); break;
  mvi a, 8
  sta cursorX
  jmp l188
l187:
  ; 553 cursorX--; drawCursor(); break;
  lxi h, cursorX
  dcr m
l188:
  ; 553 drawCursor(); break;
  call drawCursor
  ; 553 break;
  jmp l173
l189:
  ; 554 clearCursor(); if(cursorX==8) cursorX=0; else cursorX++; drawCursor(); break;
  call clearCursor
  ; 554 if(cursorX==8) cursorX=0; else cursorX++; drawCursor(); break;
  lda cursorX
  cpi 8
  jnz l190
  ; 554 cursorX=0; else cursorX++; drawCursor(); break;
  xra a
  sta cursorX
  jmp l191
l190:
  ; 554 cursorX++; drawCursor(); break;
  lxi h, cursorX
  inr m
l191:
  ; 554 drawCursor(); break;
  call drawCursor
  ; 554 break;
  jmp l173
l192:
  ; 556 if(game[cursorX][cursorY]) { if(selX!=-1) drawCell(selX, selY); selX=cursorX, selY=cursorY; break; }
  lhld cursorX
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, game
  dad d
  ; Сложение
  mov e, m
  inx h
  mov d, m
  lhld cursorY
  mvi h, 0
  dad d
  ; convertToConfition
  xra a
  ora m
  jz l193
  ; 556 if(selX!=-1) drawCell(selX, selY); selX=cursorX, selY=cursorY; break; }
  lda selX
  cpi -1
  jz l194
  ; 556 drawCell(selX, selY); selX=cursorX, selY=cursorY; break; }
  sta drawCell_1
  lda selY
  call drawCell
l194:
  ; 556 selX=cursorX, selY=cursorY; break; }
  lda cursorX
  sta selX
  lda cursorY
  sta selY
  ; 556 break; }
  jmp l173
l193:
  ; 557 if(selX==-1) break;
  lda selX
  cpi -1
  jz l173
  call move
  ; 559 if(gameOver) {convertToConfition
  lda gameOver
  ora a
  jz l196
  ; 560 recordAnimation();
  call recordAnimation
  ; 561 startGame();
  call startGame
l196:
  ; 563 break;        
  jmp l173
l197:
  ; 565 continue;
  jmp l162
l173:
  ; 568 keybTimeout=50;
  lxi h, 50
  shld main_keybTimeout
  jmp l162
l163:
  ret
  ; --- sound -----------------------------------------------------------------
sound:
  shld sound_2
  ; 13 asm {
    xchg
sound_l3:
    di
    lda sound_1
sound_l0:
    dcr a 
    jnz sound_l0
    ei
    lda sound_1
sound_l1:
    dcr a 
    jnz sound_l1
    dcx d
    mov a, d
    ora e
    jnz sound_l3
  
  ret
  ; --- cellAddr -----------------------------------------------------------------
cellAddr:
  sta cellAddr_2
  ; 53 return PIXELCOORDS(PLAYFIELD_X+x*3, PLAYFIELD_Y+y*20);
  mvi d, 20
  call op_mul
  ; Сложение
  lxi d, 29
  dad d
  ; Сложение
  lxi d, 49153
  dad d
  push h
  mvi d, 3
  lda cellAddr_1
  call op_mul
  ; Сложение
  lxi d, 11
  dad d
  lxi d, 256
  call op_mul16
  ; Сложение
  pop d
  dad d
  ret
  ; --- drawBall1 -----------------------------------------------------------------
drawBall1:
  sta drawBall1_4
  ; 61 color = colors[c-1] | bg;
  lda drawBall1_3
  dcr a
  ; Сложение
  mvi h, 0
  mov l, a
  lxi d, colors
  dad d
  lda drawBall1_4
  ora m
  sta color
  ; 62 bitblt_bw(d, o, 0x20E);
  lhld drawBall1_1
  shld bitBlt_bw_1
  lhld drawBall1_2
  shld bitBlt_bw_2
  lxi h, 526
  jmp bitBlt_bw
drawBall:
  push b
  sta drawBall_4
  ; 66 cellAddr(x, y);<d>
  lda drawBall_1
  sta cellAddr_1
  lda drawBall_2
  call cellAddr
  mov b, h
  mov c, l
  ; 67 color = 0x70;
  mvi a, 112
  sta color
  ; 68 bitblt_bw(d-1, imgBalls+16*28+1, 0x20E);Сложение с константой -1
  dcx h
  shld bitBlt_bw_1
  lxi h, ((imgBalls)+(448))+(1)
  shld bitBlt_bw_2
  lxi h, 526
  call bitBlt_bw
  ; 69 drawBall1(d, o, c, 0x70);
  mov h, b
  mov l, c
  shld drawBall1_1
  lhld drawBall_3
  shld drawBall1_2
  lda drawBall_4
  sta drawBall1_3
  mvi a, 112
  call drawBall1
  pop b
  ret
  ; --- drawCursor -----------------------------------------------------------------
drawCursor:
  push b
  ; 76 cellAddr(cursorX, cursorY);<d>
  lda cursorX
  sta cellAddr_1
  lda cursorY
  call cellAddr
  mov b, h
  mov c, l
  ; 77 bitblt(d, imgCursor, 0x202);
  shld bitBlt_1
  lxi h, imgCursor
  shld bitBlt_2
  lxi h, 514
  call bitBlt
  ; 78 bitblt(d+12, imgCursor+8, 0x202);Сложение с BC
  lxi h, 12
  dad b
  shld bitBlt_1
  lxi h, (imgCursor)+(8)
  shld bitBlt_2
  lxi h, 514
  call bitBlt
  pop b
  ret
  ; --- drawSprite -----------------------------------------------------------------
drawSprite:
  sta drawSprite_3
  ; 85 if(c==0) drawBall(x, y, imgBalls+28*16, 8);
  ora a
  jnz l198
  ; 85 drawBall(x, y, imgBalls+28*16, 8);
  lda drawSprite_1
  sta drawBall_1
  lda drawSprite_2
  sta drawBall_2
  lxi h, (imgBalls)+(448)
  shld drawBall_3
  mvi a, 8
  call drawBall
  jmp l199
l198:
  ; 86 drawBall(x, y, imgBalls, c);
  lda drawSprite_1
  sta drawBall_1
  lda drawSprite_2
  sta drawBall_2
  lxi h, imgBalls
  shld drawBall_3
  lda drawSprite_3
  call drawBall
l199:
  ret
  ; --- drawSpriteRemove -----------------------------------------------------------------
drawSpriteRemove:
  sta drawSpriteRemove_4
  ; 95 drawBall(x, y, removeAnimation[n], s);
  lda drawSpriteRemove_1
  sta drawBall_1
  lda drawSpriteRemove_2
  sta drawBall_2
  lhld drawSpriteRemove_4
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, removeAnimation
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  shld drawBall_3
  lda drawSpriteRemove_3
  jmp drawBall
drawSpriteNew:
  sta drawSpriteNew_4
  ; 102 drawBall(x, y, imgBalls+(4-n)*28, s);
  lda drawSpriteNew_1
  sta drawBall_1
  lda drawSpriteNew_2
  sta drawBall_2
  ; Арифметика 3/4
  lxi h, drawSpriteNew_4
  mvi a, 4
  sub m
  mvi d, 28
  call op_mul
  ; Сложение
  lxi d, imgBalls
  dad d
  shld drawBall_3
  lda drawSpriteNew_3
  jmp drawBall
drawSpriteStep:
  sta drawSpriteStep_3
  ; 109 drawBall(x, y, imgBalls+(12+n)*28, 8);
  lda drawSpriteStep_1
  sta drawBall_1
  lda drawSpriteStep_2
  sta drawBall_2
  lda drawSpriteStep_3
  adi 12
  mvi d, 28
  call op_mul
  ; Сложение
  lxi d, imgBalls
  dad d
  shld drawBall_3
  mvi a, 8
  call drawBall
  ; 110 sound(1, 10);
  mvi a, 1
  sta sound_1
  lxi h, 10
  jmp sound
drawSpriteSel:
  sta drawSpriteSel_5
  ; 120 if(t==1) {
  cpi 1
  jnz l200
  ; 121 d = cellAddr(x, y)-1;
  lda drawSpriteSel_1
  sta cellAddr_1
  lda drawSpriteSel_2
  call cellAddr
  ; Сложение с константой -1
  dcx h
  shld drawSpriteSel_d
  ; 122 d[14] = 0;Сложение
  lxi d, 14
  dad d
  mvi m, 0
  ; 123 d[0x100+14] = 0;  Сложение
  lhld drawSpriteSel_d
  lxi d, 270
  dad d
  mvi m, 0
  ; 124 drawBall1(d, selAnimation[t], s, 0x70);  
  lhld drawSpriteSel_d
  shld drawBall1_1
  lhld drawSpriteSel_5
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, selAnimation
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  shld drawBall1_2
  lda drawSpriteSel_3
  sta drawBall1_3
  mvi a, 112
  call drawBall1
  jmp l201
l200:
  ; 126 drawBall(x, y, selAnimation[t], s);  
  lda drawSpriteSel_1
  sta drawBall_1
  lda drawSpriteSel_2
  sta drawBall_2
  lhld drawSpriteSel_5
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, selAnimation
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  shld drawBall_3
  lda drawSpriteSel_3
  call drawBall
l201:
  ; 129 if(c) drawCursor();convertToConfition
  lda drawSpriteSel_4
  ora a
  cnz drawCursor
  lda drawSpriteSel_5
  cpi 3
  jnz l203
  ; 131 sound(1, 10);
  mvi a, 1
  sta sound_1
  lxi h, 10
  call sound
l203:
  ret
  ; --- drawScore -----------------------------------------------------------------
drawScore:
  push b
  shld drawScore_2
  ; 143 print1(PIXELCOORDS(40,7),2,5,scoreText);
  lxi h, 59400
  shld print1_1
  mvi a, 2
  sta print1_2
  mvi a, 5
  sta print1_3
  lhld drawScore_2
  call print1
  ; 145 if(score < hiScores[0].score) {
  lhld drawScore_1
  xchg
  lhld ((hiScores)+(0))+(14)
  call op_cmp16
  jc l204
  jz l204
  ; 146 n = (score / (hiScores[0].score / 13));
  lxi d, 13
  lhld ((hiScores)+(0))+(14)
  call op_div16
  xchg
  lhld drawScore_1
  call op_div16
  mov a, l
  sta drawScore_n
  ; 147 if(n>13) n=13;
  cpi 13
  jc l205
  jz l205
  ; 147 n=13;
  mvi a, 13
  sta drawScore_n
l205:
  jmp l206
l204:
  ; 149 n = 14;
  mvi a, 14
  sta drawScore_n
l206:
  ; 152 if(playerSpriteTop != n) {
  lxi h, drawScore_n
  lda playerSpriteTop
  cmp m
  jz l207
  ; 153 playerSpriteTop = n;
  mov a, m
  sta playerSpriteTop
  ; 154 for(s=PIXELCOORDS(40, 167); n; --n, s-=4)
  lxi b, 59560
l208:
  ; convertToConfition
  lda drawScore_n
  ora a
  jz l209
  ; 155 bitBlt(s, imgPlayerD, 5*256+4);  
  mov h, b
  mov l, c
  shld bitBlt_1
  lxi h, imgPlayerD
  shld bitBlt_2
  lxi h, 1284
  call bitBlt
l210:
  lxi h, drawScore_n
  dcr m
  ; Сложение BC с константой -4
  dcx b
  dcx b
  dcx b
  dcx b
  jmp l208
l209:
  ; 156 bitBlt(s-46, imgPlayer, 5*256+50);                                         Сложение с BC
  lxi h, 65490
  dad b
  shld bitBlt_1
  lxi h, imgPlayer
  shld bitBlt_2
  lxi h, 1330
  call bitBlt
  ; 157 if(playerSpriteTop == 14) {
  lda playerSpriteTop
  cpi 14
  jnz l211
  ; 158 bitBlt(s-50+0x200, imgPlayerWin, 3*256+16);Сложение с BC
  lxi h, 65486
  dad b
  ; Сложение
  lxi d, 512
  dad d
  shld bitBlt_1
  lxi h, imgPlayerWin
  shld bitBlt_2
  lxi h, 784
  call bitBlt
  ; 159 bitBlt(PIXELCOORDS(3, 53), imgKingLose, 6*256+62);                                         
  lxi h, 49974
  shld bitBlt_1
  lxi h, imgKingLose
  shld bitBlt_2
  lxi h, 1598
  call bitBlt
l211:
l207:
  pop b
  ret
  ; --- redrawNewBalls -----------------------------------------------------------------
redrawNewBalls:
  sta redrawNewBalls_3
  ; 168 if(a==8) {
  lda redrawNewBalls_1
  cpi 8
  jnz l212
  ; 169 color = 0;
  xra a
  sta color
  ; 170 colorRect(PIXELCOORDS(19, 3), 0x20E);
  lxi h, 54020
  shld colorRect_1
  lxi h, 526
  call colorRect
  ; 171 colorRect(PIXELCOORDS(23, 3), 0x20E);
  lxi h, 55044
  shld colorRect_1
  lxi h, 526
  call colorRect
  ; 172 colorRect(PIXELCOORDS(27, 3), 0x20E);
  lxi h, 56068
  shld colorRect_1
  lxi h, 526
  jmp colorRect
  ; 173 return;
l212:
  ; 175 drawBall1(PIXELCOORDS(19, 3), imgBalls, a, 0x70);
  lxi h, 54020
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_1
  sta drawBall1_3
  mvi a, 112
  call drawBall1
  ; 176 drawBall1(PIXELCOORDS(23, 3), imgBalls, b, 0x70);
  lxi h, 55044
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_2
  sta drawBall1_3
  mvi a, 112
  call drawBall1
  ; 177 drawBall1(PIXELCOORDS(27, 3), imgBalls, c, 0x70);
  lxi h, 56068
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_3
  sta drawBall1_3
  mvi a, 112
  jmp drawBall1
redrawNewBallsOff:
  mvi a, 8
  sta redrawNewBalls_1
  sta redrawNewBalls_2
  jmp redrawNewBalls
drawOnOff:
  sta drawOnOff_2
  ; 194 onOff[n];<d>
  lhld drawOnOff_1
  mvi h, 0
  ; Умножение HL на 2
  dad h
  ; Сложение
  lxi d, onOff
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  shld drawOnOff_d
  ; 195 if(state) color = 10; else color = 7;convertToConfition
  ora a
  jz l213
  ; 195 color = 10; else color = 7;
  mvi a, 10
  sta color
  jmp l214
l213:
  ; 195 color = 7;
  mvi a, 7
  sta color
l214:
  ; 196 colorRect(d, 0x408);
  lhld drawOnOff_d
  shld colorRect_1
  lxi h, 1032
  jmp colorRect
soundJumpSel:
  ret
  ; --- delay -----------------------------------------------------------------
delay:
  sta delay_1
  ; 210 while(--a) {
l215:
  lxi h, delay_1
  dcr m
  ; convertToConfition
  jz l216
  ; 211 i = 64;
  mvi a, 64
  sta delay_i
  ; 212 while(--i);
l217:
  lxi h, delay_i
  dcr m
  ; convertToConfition
  jz l218
  jmp l217
l218:
  jmp l215
l216:
  ret
  ; --- soundBadMove -----------------------------------------------------------------
soundBadMove:
  mvi a, 255
  sta sound_1
  lxi h, 10
  call sound
  ; 221 delay(128);
  mvi a, 128
  call delay
  ; 222 sound(255, 10);
  mvi a, 255
  sta sound_1
  lxi h, 10
  call sound
  ; 223 delay(128);
  mvi a, 128
  jmp delay
intro:
  lxi h, 63488
  mvi m, 6
  ; 239 himem();  
  call himem
  ; 240 color = 0;
  xra a
  sta color
  ; 241 colorRect(PIXELCOORDS(0,0), 0x3000);
  lxi h, 49153
  shld colorRect_1
  lxi h, 12288
  call colorRect
  ; 244 unmlz((uchar*)0xC000, imgTitle);
  lxi h, 49152
  shld unmlz_1
  lxi h, imgTitle
  call unmlz
  ; 247 unmlz((uchar*)COLOR_BUFFER, imgTitle_colors);
  lxi h, 32768
  shld unmlz_1
  lxi h, imgTitle_colors
  call unmlz
  ; 250 himem();  
  call himem
  ; 251 colorizer_rand();    
  call colorizer_rand
  ; 254 p = music;
  lxi h, music
  shld intro_p
  ; 255 while(1) {
l219:
  ; 256 s = *p; ++p;
  lhld intro_p
  mov a, m
  sta intro_s
  ; 256 ++p;
  inx h
  inx h
  shld intro_p
  ; 257 if(s==0) { while(bioskey()==0xFF); break; }
  ora a
  jnz l221
  ; 257 while(bioskey()==0xFF); break; }
l222:
  call 63515
  cpi 255
  jnz l223
  jmp l222
l223:
  ; 257 break; }
  jmp l220
l221:
  ; 258 if(bioskey()!=0xFF) break;
  call 63515
  cpi 255
  jnz l220
  lda intro_s
  sta sound_1
  lhld intro_p
  mov e, m
  inx h
  mov d, m
  xchg
  call sound
  ; 259 ++p;
  lhld intro_p
  inx h
  inx h
  shld intro_p
  ; 260 rand();
  call rand
  jmp l219
l220:
  ret
  ; --- prepareRecordScreen -----------------------------------------------------------------
prepareRecordScreen:
  lxi h, 32768
  shld memset_1
  xra a
  sta memset_2
  lxi h, 2641
  call memset
  ; 269 color = 0x0E;
  mvi a, 14
  sta color
  ; 270 bitblt_bw(PIXELCOORDS(112/8, PLAYFIELD_Y+17), (uchar*)COLOR_BUFFER, 0x138B);
  lxi h, 52783
  shld bitBlt_bw_1
  lxi h, 32768
  shld bitBlt_bw_2
  lxi h, 5003
  jmp bitBlt_bw
drawRecordScreen1:
  sta drawRecordScreen1_2
  ; 281 for(h=hiScores+i; i<9; ++i, ++h) {
  lhld drawRecordScreen1_1
  mvi h, 0
  ; Умножение HL на 16
  dad h
  dad h
  dad h
  dad h
  ; Сложение
  lxi d, hiScores
  dad d
  shld drawRecordScreen1_h
l225:
  lda drawRecordScreen1_1
  cpi 9
  jnc l226
  ; 284 memcpy(buf, "             ", 14);
  lxi h, drawRecordScreen1_buf
  shld memcpy_1
  lxi h, string9
  shld memcpy_2
  lxi h, 14
  call memcpy
  ; 285 memcpy(buf, h->name, strlen(h->name));
  lxi h, drawRecordScreen1_buf
  shld memcpy_1
  lhld drawRecordScreen1_h
  shld memcpy_2
  lhld drawRecordScreen1_h
  call strlen
  call memcpy
  ; 286 i2s(buf+8, h->score);
  lxi h, (drawRecordScreen1_buf)+(8)
  shld i2s_1
  ; Сложение
  lhld drawRecordScreen1_h
  lxi d, 14
  dad d
  mov e, m
  inx h
  mov d, m
  xchg
  call i2s
  ; 288 print(25, 7+i, 14, buf);
  mvi a, 25
  sta print_1
  lda drawRecordScreen1_1
  adi 7
  sta print_2
  mvi a, 14
  sta print_3
  lxi h, drawRecordScreen1_buf
  call print
l227:
  lxi h, drawRecordScreen1_1
  inr m
  lhld drawRecordScreen1_h
  lxi d, 16
  dad d
  shld drawRecordScreen1_h
  jmp l225
l226:
  ret
  ; --- drawRecordScreen -----------------------------------------------------------------
drawRecordScreen:
  sta drawRecordScreen_1
  ; 294 drawRecordScreen1(0, pos);
  xra a
  sta drawRecordScreen1_1
  lda drawRecordScreen_1
  jmp drawRecordScreen1
drawRecordLastLine:
  mvi a, 8
  sta drawRecordScreen1_1
  jmp drawRecordScreen1
updateTopScore:
  lxi h, updateTopScore_buf
  shld i2s_1
  lhld ((hiScores)+(0))+(14)
  call i2s
  ; 312 color = 12;
  mvi a, 12
  sta color
  ; 313 print1(PIXELCOORDS(3,7),1,5,buf);
  lxi h, 49928
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 5
  sta print1_3
  lxi h, updateTopScore_buf
  call print1
  ; 316 print1(PRINTARGS(5,19),7|0x80,hiScores[0].name);
  lxi h, 50111
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 135
  sta print1_3
  lxi h, (hiScores)+(0)
  jmp print1
initGameScreen:
  lxi h, 32768
  shld memset_1
  xra a
  sta memset_2
  mvi h, 48
  call memset
  ; 327 colorizer_rand();    
  call colorizer_rand
  ; 330 unmlz((uchar*)0xC000, imgScreen);
  lxi h, 49152
  shld unmlz_1
  lxi h, imgScreen
  call unmlz
  ; 333 unmlz((uchar*)COLOR_BUFFER, imgScreen_colors);  
  lxi h, 32768
  shld unmlz_1
  lxi h, imgScreen_colors
  call unmlz
  ; 336 himem();
  call himem
  ; 337 colorizer_rand();
  call colorizer_rand
  ; 340 print(56,19,8,"‚›");  
  mvi a, 56
  sta print_1
  mvi a, 19
  sta print_2
  mvi a, 8
  sta print_3
  lxi h, string10
  call print
  ; 341 updateTopScore();
  call updateTopScore
  ; 342 playerSpriteTop = -1;
  mvi a, 255
  sta playerSpriteTop
  ; 343 drawScore1();
  call drawScore1
  ; 344 if(!showPath ) drawOnOff(0, 0);convertToConfition
  lda showPath
  ora a
  jnz l228
  ; 344 drawOnOff(0, 0);
  xra a
  sta drawOnOff_1
  call drawOnOff
l228:
  ; 345 if(!playSound) drawOnOff(1, 0);convertToConfition
  lda playSound
  ora a
  jnz l229
  ; 345 drawOnOff(1, 0);
  mvi a, 1
  sta drawOnOff_1
  xra a
  call drawOnOff
l229:
  ; 346 if(!showHelp ) drawOnOff(2, 0);convertToConfition
  lda showHelp
  ora a
  jnz l230
  ; 346 drawOnOff(2, 0);
  mvi a, 2
  sta drawOnOff_1
  xra a
  call drawOnOff
l230:
  ret
  ; --- translate -----------------------------------------------------------------
translate:
  sta translate_1
  ; 350 switch(k) {
  ora a
  jz l232
  cpi 1
  jz l233
  cpi 2
  jz l234
  cpi 3
  jz l235
  cpi 4
  jz l236
  cpi 25
  jz l237
  cpi 26
  jz l238
  cpi 8
  jz l239
  cpi 24
  jz l240
  cpi 13
  jz l241
  cpi 127
  jz l242
  cpi 255
  jz l243
  jmp l244
l232:
  ; 351 return K_PATH;
  mvi a, 1
  ret
l233:
  ; 352 return K_SOUND;
  mvi a, 2
  ret
l234:
  ; 353 return K_HELP;
  mvi a, 3
  ret
l235:
  ; 354 return K_RECORD;
  mvi a, 4
  ret
l236:
  ; 355 return K_NEW;
  mvi a, 5
  ret
l237:
  ; 356 return K_UP;
  mvi a, 25
  ret
l238:
  ; 357 return K_DOWN;
  mvi a, 26
  ret
l239:
  ; 358 return K_LEFT;
  mvi a, 8
  ret
l240:
  ; 359 return K_RIGHT;
  mvi a, 24
  ret
l241:
  ; 360 return K_ENTER;
  mvi a, 13
  ret
l242:
  ; 361 return K_LEFT;
  mvi a, 8
  ret
l243:
  ; 362 return 255;
  mvi a, 255
  ret
l244:
  ; 364 if(k >= ' ') return k;
  lda translate_1
  cpi 32
  jc l245
  ; 364 return k;
  ret
l245:
  ; 365 return 0;
  xra a
  ret
l231:
  ret
  ; --- getch_ -----------------------------------------------------------------
getch_:
  call 63491
  jmp translate
  ret
  ; --- bioskey_ -----------------------------------------------------------------
bioskey_:
  call 63515
  jmp translate
  ret
  ; --- print_p1 -----------------------------------------------------------------
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
  ; 285 e = n&0x80; n&=0x7F;
  lda print1_3
  ani 128
  sta print1_e
  ; 285 n&=0x7F;
  lda print1_3
  ani 127
  sta print1_3
  ; 286 while(1) { 
l246:
  ; 287 if(n == 0) return;     
  lda print1_3
  ora a
  jnz l248
  ; 287 return;     
  ret
l248:
  ; 288 c = *text;
  lhld print1_4
  mov a, m
  sta print1_c
  ; 289 if(c) ++text; else if(!e) return;convertToConfition
  ora a
  jz l249
  ; 289 ++text; else if(!e) return;
  inx h
  shld print1_4
  jmp l250
l249:
  ; 289 if(!e) return;convertToConfition
  lda print1_e
  ora a
  jnz l251
  ; 289 return;
  ret
l251:
l250:
  ; 290 s = chargen + c*8;
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
  ; 291 switch(st) {
  lda print1_2
  ora a
  jz l253
  cpi 1
  jz l254
  cpi 2
  jz l255
  cpi 3
  jz l256
  jmp l252
l253:
  ; 292 print_p1(d, s); ++st; break;
  lhld print1_1
  shld print_p1_1
  lhld print1_s
  call print_p1
  ; 292 ++st; break;
  lxi h, print1_2
  inr m
  ; 292 break;
  jmp l252
l254:
  ; 293 print_p2(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p2_1
  lhld print1_s
  call print_p2
  ; 293 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 293 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 293 break;
  jmp l252
l255:
  ; 294 print_p3(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p3_1
  lhld print1_s
  call print_p3
  ; 294 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 294 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 294 break;
  jmp l252
l256:
  ; 295 print_p4(d, s); st=0; d += 0x100; break;
  lhld print1_1
  shld print_p4_1
  lhld print1_s
  call print_p4
  ; 295 st=0; d += 0x100; break;
  xra a
  sta print1_2
  ; 295 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 295 break;
l252:
  ; 297 --n;
  lxi h, print1_3
  dcr m
  jmp l246
l247:
  ret
  ; --- print -----------------------------------------------------------------
print:
  shld print_4
  ; 302 print1(PRINTARGS(x, y), n, text);
  mvi d, 10
  lda print_2
  call op_mul
  ; Сложение
  lxi d, 49153
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
himem:
    lxi h, bitBlt
    lxi d, 0F000h
initSpec:
    mov a, m
    inx h
    stax d
    inr e
    jnz initSpec
  
  ret
  ; --- bitBlt -----------------------------------------------------------------
bitBlt:
  shld bitBlt_3
  ; 322 asm {
    jmp bitBlt_himem - bitBlt + 0F000h
bitBlt_himem:
    push b
    ; lhld bitBlt_3
    mov b, h
    mov c, l
    lhld bitBlt_1
    xchg    
    lhld bitBlt_2
bitBlt_l1:
    push d
    push b                        
bitBlt_l2:
    mov b, m
    inx h
    mvi a, 1
    sta 0F900H
    mov a, b
    stax d
    xra a
    sta 0F900H
    mov a, m
    inx h
    stax d
    inx d    
    dcr c
    jnz bitBlt_l2 - bitBlt + 0F000h
    pop b
    pop d    
    inr d
    dcr b
    jnz bitBlt_l1 - bitBlt + 0F000h    
    pop b
    ret
  
  ret
  ; --- colorizer_rand -----------------------------------------------------------------
colorizer_rand:
    jmp colorizer_himem - bitBlt + 0F000h
colorizer_himem:
    push b
    mvi  b, 0
    mvi  c, 48 
colorizerr_1:
    call rand
    
    mvi  d, 80h
    mov  e, a
    mvi  h, 0C0h
    mov  l, a
         
    push b 
colorizerr_2:
    ldax d
    inr  d
    mov  b, a

    mvi a, 1
    sta 0F900H
    mov  m, b
    inr  h    
    xra a
    sta 0F900H

    dcr  c
    jnz  colorizerr_2 - bitBlt + 0F000h
    pop  b

    dcr  b
    jnz  colorizerr_1 - bitBlt + 0F000h
    pop  b
    ret
  
  ret
  ; --- bitBlt_bw -----------------------------------------------------------------
bitBlt_bw:
  shld bitBlt_bw_3
  ; 400 asm {
    jmp bitBlt_bw_himem - bitBlt + 0F000h
bitBlt_bw_himem:
    ;lhld bitBlt_bw_3
    push b
    mov b, h
    mov c, l
    lhld bitBlt_bw_2
    xchg    
    lhld bitBlt_bw_1
bitBlt_bw_l1:
    push h
    push b
    lda  color
    mov  b, a
bitBlt_bw_l2:
    ldax d
    mov m, a

    mvi a, 1
    sta 0F900H
    mov m, b
    xra a
    sta 0F900H

    inx h
    inx d
    dcr c
    jnz bitBlt_bw_l2 - bitBlt + 0F000h

    pop b
    pop h
    inr h
    dcr b
    jnz bitBlt_bw_l1 - bitBlt + 0F000h
    pop b
  
  ret
  ; --- colorRect -----------------------------------------------------------------
colorRect:
  shld colorRect_2
  ; 440 asm {
    jmp colorRect_himem - bitBlt + 0F000h
colorRect_himem:
    ; hl = colorRect_2
    xchg
    lhld colorRect_1
    lda  color
    push psw
    mvi  a, 1
    sta  0F900H
    pop  psw
colorRect_l1:
    push h
    push d
colorRect_l2:
    mov  m, a
    inx  h
    dcr  e
    jnz  colorRect_l2 - bitBlt + 0F000h    
    pop  d
    pop  h
    inr  h
    dcr  d
    jnz  colorRect_l1 - bitBlt + 0F000h
    xra  a
    sta  0F900H
  
  ret
  ; --- unmlz -----------------------------------------------------------------
unmlz:
  shld unmlz_2
  ; 4 asm {
		push	b
		xchg
		lhld	unmlz_1
		mov	b, h
		mov	c, l

		mvi	a, 80h
UNLD:
		sta	unmlz_1
		ldax	d
		inx	d
		jmp	UNSTA

; ---------------------------------------------------------------------------

UNST3:		mov	a, m
		inx	h
		stax	b
		inx	b
		
UNST2:		mov	a, m
		inx	h
		stax	b
		inx	b

UNST1:		mov	a, m

UNSTA:		stax	b
		inx	b

ULOOP:		lda	unmlz_1
		add	a
		jnz	L1
		ldax	d
		inx	d
		ral

L1:		jc	UNLD
		add	a
		jnz	L3
		ldax	d
		inx	d
		ral

L3:		jc	UN2
		add	a
		jnz	L2
		ldax	d
		inx	d
		ral

L2:		jc	UN1
		lxi	h, 3FFFh
		call	GETBITS
		sta	unmlz_1
		dad	b
		jmp	UNST1

; ---------------------------------------------------------------------------

UN1:		sta	unmlz_1
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		dad	b
		jmp	UNST2

; ---------------------------------------------------------------------------

UN2:		add	a
		jnz	L4
		ldax	d
		inx	d
		ral

L4:		jc	UN3
		call	GETBIGD
		dad	b
		jmp	UNST3

; ---------------------------------------------------------------------------

UN3:		mvi	h, 0

UN3A:		inr	h
		add	a
		jnz	L5
		ldax	d
		inx	d
		ral

L5:		jnc	UN3A
		push	psw
		mov	a, h
		cpi	8
		jnc	UNEXIT
		mvi	a, 0

L5B:		rar
		dcr	h
		jnz	L5B
		mov	h, a
		mvi	l, 1
		pop	psw
		call	GETBITS
		inx	h
		inx	h
		push	h
		call	GETBIGD
		xchg
		xthl
		xchg
		dad	b

LDIR:		mov	a, m
		inx	h
		stax	b
		inx	b
		dcr	e
		jnz	LDIR
		pop	d
		jmp	ULOOP

; ---------------------------------------------------------------------------

UNEXIT:		pop	psw
		pop	b
		ret

; ---------------------------------------------------------------------------

GETBITS:	add	a
		jnz	L7
		ldax	d
		inx	d
		ral		
L7:		jc	GETB1
		dad	h
		rc
		jmp	GETBITS

; ---------------------------------------------------------------------------

GETB1:		dad	h
		inr	l
		rc
		jmp	GETBITS

; ---------------------------------------------------------------------------

GETBIGD:	add	a
		jnz	L8
		ldax	d
		inx	d
		ral

L8:		jc	GETBD1
		sta	unmlz_1
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		ret

; ---------------------------------------------------------------------------

GETBD1:		lxi	h, 1FFFh
		call	GETBITS
		sta	unmlz_1
		mov	h, l
		dcr	h
		ldax	d
		inx	d
		mov	l, a
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
  ; --- rand -----------------------------------------------------------------
rand:
    LDA rand_seed
    mov e,a
    add a
    add a
    add e
    inr a
    sta rand_seed
  
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
  ; --- op_div -----------------------------------------------------------------
op_div:
    push b
    mov e, a
    LXI H,0008h
    MVI C,00
op_div_1:
    MOV A,E
    RAL
    MOV E,A
    MOV A,C
    RAL
    SUB D
    JNC op_div_2
    ADD D
op_div_2:
    MOV C,A ; Остаток в С
    CMC
    MOV A,H
    RAL
    MOV H,A ; Частное в Н
    DCR L
    JNZ op_div_1
    MOV A, C
    STA op_div_mod
    MOV A, H
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
game:
 .dw $+18
 .dw $+25
 .dw $+32
 .dw $+39
 .dw $+46
 .dw $+53
 .dw $+60
 .dw $+67
 .dw $+74
 .ds 81
gameOver:
 .db 0

cursorX:
 .db 4

cursorY:
 .db 4

selX:
 .db 255

selY:
 .ds 1
score:
 .dw 0

newBall1:
 .ds 1
newBall2:
 .ds 1
newBall3:
 .ds 1
showPath:
 .db 1

playSound:
 .db 1

showHelp:
 .db 1

nx:
 .ds 1
ny:
 .ds 1
hiScores:
 .db "VINXRU",0,0,0,0,0,0,0,0
 .dw 40
 .db "ELTARO",0,0,0,0,0,0,0,0
 .dw 18
 .db "ERR404",0,0,0,0,0,0,0,0
 .dw 16
 .db "SYSCAT",0,0,0,0,0,0,0,0
 .dw 14
 .db "MICK",0,0,0,0,0,0,0,0,0,0
 .dw 12
 .db "SCL MC",0,0,0,0,0,0,0,0
 .dw 10
 .db "SVOFSK",0,0,0,0,0,0,0,0
 .dw 8
 .db "TITUS",0,0,0,0,0,0,0,0,0
 .dw 6
 .db "B2M",0,0,0,0,0,0,0,0,0,0,0
 .dw 4

 .ds 117
i2s_1:
 .ds 2
i2s_2:
 .ds 2
i2s_i:
 .ds 1
drawScore1_buf:
 .ds 6
drawCell_1:
 .ds 1
drawCell_2:
 .ds 1
drawCells_x:
 .ds 1
drawCells_y:
 .ds 1
clearLine_1:
 .ds 1
clearLine_2:
 .ds 1
clearLine_3:
 .ds 1
clearLine_4:
 .ds 1
clearLine_5:
 .ds 1
clearLine_y:
 .ds 1
clearLine_o:
 .ds 1
clearLine_i:
 .ds 1
check_prevx:
 .ds 1
check_prevy:
 .ds 1
check_c:
 .ds 1
check_n:
 .ds 1
check_total:
 .ds 1
check_p:
 .ds 2
calcFreeCell_c:
 .ds 1
calcFreeCell_i:
 .ds 1
newBall_1:
 .ds 1
newBall_i:
 .ds 1
newBall_c:
 .ds 1
gameStep_nx1:
 .ds 1
gameStep_ny1:
 .ds 1
gameStep_nx2:
 .ds 1
gameStep_ny2:
 .ds 1
gameStep_o:
 .ds 1
path_c:
 .ds 1
path_p:
 .dw $+2
 .ds 1
path_n:
 .ds 1
path_x:
 .ds 1
path_y:
 .ds 1
path_p1:
 .dw $+2
 .ds 1
path_n1:
 .ds 1
path_x1:
 .ds 1
path_y1:
 .ds 1
recordAnimation_c:
 .ds 1
recordAnimation_i:
 .ds 1
recordAnimation_p:
 .ds 2
recordAnimation_tmp:
 .ds 16
main_c:
 .ds 1
main_c1:
 .ds 1
main_selAnimationT:
 .ds 1
main_selAnimationTT:
 .ds 2
main_keybTimeout:
 .ds 2
sound_1:
 .ds 1
sound_2:
 .ds 2
cellAddr_1:
 .ds 1
cellAddr_2:
 .ds 1
colors:
 .db 9
 .db 10
 .db 11
 .db 12
 .db 13
 .db 14
 .db 15
 .db 0

drawBall1_1:
 .ds 2
drawBall1_2:
 .ds 2
drawBall1_3:
 .ds 1
drawBall1_4:
 .ds 1
drawBall_1:
 .ds 1
drawBall_2:
 .ds 1
drawBall_3:
 .ds 2
drawBall_4:
 .ds 1
drawSprite_1:
 .ds 1
drawSprite_2:
 .ds 1
drawSprite_3:
 .ds 1
removeAnimation:
 .dw ((imgBalls)+(140)) & 65535
 .dw ((imgBalls)+(168)) & 65535
 .dw ((imgBalls)+(196)) & 65535
 .dw ((imgBalls)+(224)) & 65535

 .ds 4
drawSpriteRemove_1:
 .ds 1
drawSpriteRemove_2:
 .ds 1
drawSpriteRemove_3:
 .ds 1
drawSpriteRemove_4:
 .ds 1
drawSpriteNew_1:
 .ds 1
drawSpriteNew_2:
 .ds 1
drawSpriteNew_3:
 .ds 1
drawSpriteNew_4:
 .ds 1
drawSpriteStep_1:
 .ds 1
drawSpriteStep_2:
 .ds 1
drawSpriteStep_3:
 .ds 1
selAnimation:
 .dw (imgBalls) & 65535
 .dw (imgBalls) & 65535
 .dw (imgBalls) & 65535
 .dw ((imgBalls)+(280)) & 65535
 .dw ((imgBalls)+(308)) & 65535
 .dw ((imgBalls)+(280)) & 65535

 .ds 6
drawSpriteSel_1:
 .ds 1
drawSpriteSel_2:
 .ds 1
drawSpriteSel_3:
 .ds 1
drawSpriteSel_4:
 .ds 1
drawSpriteSel_5:
 .ds 1
drawSpriteSel_d:
 .ds 2
playerSpriteTop:
 .ds 1
drawScore_1:
 .ds 2
drawScore_2:
 .ds 2
drawScore_n:
 .ds 1
redrawNewBalls_1:
 .ds 1
redrawNewBalls_2:
 .ds 1
redrawNewBalls_3:
 .ds 1
onOff:
 .dw 50417
 .dw 52721
 .dw 55025

drawOnOff_1:
 .ds 1
drawOnOff_2:
 .ds 1
drawOnOff_i:
 .ds 1
drawOnOff_d:
 .ds 2
delay_1:
 .ds 1
delay_i:
 .ds 1
intro_p:
 .ds 2
intro_s:
 .ds 1
drawRecordScreen1_1:
 .ds 1
drawRecordScreen1_2:
 .ds 1
drawRecordScreen1_h:
 .ds 2
drawRecordScreen1_l:
 .ds 1
drawRecordScreen1_buf:
 .ds 14
drawRecordScreen_1:
 .ds 1
updateTopScore_buf:
 .ds 7
initGameScreen_s:
 .ds 2
initGameScreen_i:
 .ds 1
initGameScreen_x:
 .ds 1
initGameScreen_y:
 .ds 1
translate_1:
 .ds 1
color:
 .db 15

chargen:
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 30
 .db 33
 .db 51
 .db 33
 .db 45
 .db 33
 .db 30
 .db 0
 .db 30
 .db 63
 .db 45
 .db 63
 .db 51
 .db 63
 .db 30
 .db 0
 .db 0
 .db 0
 .db 10
 .db 31
 .db 31
 .db 14
 .db 4
 .db 0
 .db 0
 .db 0
 .db 4
 .db 14
 .db 31
 .db 14
 .db 4
 .db 0
 .db 0
 .db 0
 .db 4
 .db 14
 .db 31
 .db 4
 .db 14
 .db 0
 .db 0
 .db 0
 .db 4
 .db 14
 .db 31
 .db 14
 .db 31
 .db 0
 .db 0
 .db 12
 .db 30
 .db 30
 .db 12
 .db 0
 .db 0
 .db 63
 .db 63
 .db 51
 .db 33
 .db 33
 .db 51
 .db 63
 .db 63
 .db 0
 .db 0
 .db 12
 .db 18
 .db 18
 .db 12
 .db 0
 .db 0
 .db 63
 .db 63
 .db 51
 .db 45
 .db 45
 .db 51
 .db 63
 .db 63
 .db 0
 .db 0
 .db 7
 .db 3
 .db 29
 .db 36
 .db 36
 .db 24
 .db 0
 .db 14
 .db 17
 .db 17
 .db 14
 .db 4
 .db 31
 .db 4
 .db 0
 .db 30
 .db 18
 .db 30
 .db 16
 .db 16
 .db 48
 .db 48
 .db 0
 .db 31
 .db 17
 .db 31
 .db 17
 .db 17
 .db 51
 .db 51
 .db 12
 .db 45
 .db 12
 .db 51
 .db 51
 .db 12
 .db 45
 .db 12
 .db 0
 .db 48
 .db 60
 .db 63
 .db 63
 .db 60
 .db 48
 .db 0
 .db 0
 .db 3
 .db 15
 .db 63
 .db 63
 .db 15
 .db 3
 .db 0
 .db 4
 .db 14
 .db 31
 .db 4
 .db 31
 .db 14
 .db 4
 .db 0
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 0
 .db 10
 .db 0
 .db 0
 .db 31
 .db 41
 .db 25
 .db 9
 .db 9
 .db 9
 .db 0
 .db 14
 .db 16
 .db 12
 .db 18
 .db 18
 .db 12
 .db 2
 .db 28
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 31
 .db 31
 .db 0
 .db 4
 .db 14
 .db 31
 .db 4
 .db 31
 .db 14
 .db 4
 .db 31
 .db 4
 .db 14
 .db 31
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 4
 .db 4
 .db 4
 .db 4
 .db 31
 .db 14
 .db 4
 .db 0
 .db 0
 .db 4
 .db 2
 .db 31
 .db 2
 .db 4
 .db 0
 .db 0
 .db 0
 .db 4
 .db 8
 .db 31
 .db 8
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 16
 .db 16
 .db 31
 .db 0
 .db 0
 .db 18
 .db 51
 .db 63
 .db 63
 .db 51
 .db 18
 .db 0
 .db 0
 .db 12
 .db 30
 .db 63
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 63
 .db 63
 .db 30
 .db 12
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 4
 .db 0
 .db 10
 .db 10
 .db 10
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 10
 .db 10
 .db 31
 .db 10
 .db 31
 .db 10
 .db 10
 .db 0
 .db 4
 .db 15
 .db 20
 .db 14
 .db 5
 .db 30
 .db 4
 .db 0
 .db 24
 .db 25
 .db 2
 .db 4
 .db 8
 .db 19
 .db 3
 .db 0
 .db 4
 .db 10
 .db 10
 .db 12
 .db 21
 .db 18
 .db 13
 .db 0
 .db 6
 .db 6
 .db 2
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 2
 .db 4
 .db 8
 .db 8
 .db 8
 .db 4
 .db 2
 .db 0
 .db 8
 .db 4
 .db 2
 .db 2
 .db 2
 .db 4
 .db 8
 .db 0
 .db 0
 .db 4
 .db 21
 .db 14
 .db 21
 .db 4
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 31
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 12
 .db 12
 .db 4
 .db 8
 .db 0
 .db 0
 .db 0
 .db 0
 .db 31
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 12
 .db 12
 .db 0
 .db 0
 .db 1
 .db 2
 .db 4
 .db 8
 .db 16
 .db 0
 .db 0
 .db 14
 .db 17
 .db 19
 .db 21
 .db 25
 .db 17
 .db 14
 .db 0
 .db 4
 .db 12
 .db 4
 .db 4
 .db 4
 .db 4
 .db 14
 .db 0
 .db 14
 .db 17
 .db 1
 .db 6
 .db 8
 .db 16
 .db 31
 .db 0
 .db 31
 .db 1
 .db 2
 .db 6
 .db 1
 .db 17
 .db 14
 .db 0
 .db 2
 .db 6
 .db 10
 .db 18
 .db 31
 .db 2
 .db 2
 .db 0
 .db 31
 .db 16
 .db 30
 .db 1
 .db 1
 .db 17
 .db 14
 .db 0
 .db 7
 .db 8
 .db 16
 .db 30
 .db 17
 .db 17
 .db 14
 .db 0
 .db 31
 .db 1
 .db 2
 .db 4
 .db 8
 .db 8
 .db 8
 .db 0
 .db 14
 .db 17
 .db 17
 .db 14
 .db 17
 .db 17
 .db 14
 .db 0
 .db 14
 .db 17
 .db 17
 .db 15
 .db 1
 .db 2
 .db 28
 .db 0
 .db 0
 .db 12
 .db 12
 .db 0
 .db 0
 .db 12
 .db 12
 .db 0
 .db 12
 .db 12
 .db 0
 .db 12
 .db 12
 .db 4
 .db 8
 .db 0
 .db 2
 .db 4
 .db 8
 .db 16
 .db 8
 .db 4
 .db 2
 .db 0
 .db 0
 .db 0
 .db 31
 .db 0
 .db 31
 .db 0
 .db 0
 .db 0
 .db 8
 .db 4
 .db 2
 .db 1
 .db 2
 .db 4
 .db 8
 .db 0
 .db 14
 .db 17
 .db 1
 .db 2
 .db 4
 .db 0
 .db 4
 .db 0
 .db 14
 .db 17
 .db 19
 .db 21
 .db 23
 .db 16
 .db 14
 .db 0
 .db 4
 .db 10
 .db 17
 .db 17
 .db 31
 .db 17
 .db 17
 .db 0
 .db 30
 .db 17
 .db 17
 .db 30
 .db 17
 .db 17
 .db 30
 .db 0
 .db 14
 .db 17
 .db 16
 .db 16
 .db 16
 .db 17
 .db 14
 .db 0
 .db 30
 .db 9
 .db 9
 .db 9
 .db 9
 .db 9
 .db 30
 .db 0
 .db 31
 .db 16
 .db 16
 .db 30
 .db 16
 .db 16
 .db 31
 .db 0
 .db 31
 .db 16
 .db 16
 .db 30
 .db 16
 .db 16
 .db 16
 .db 0
 .db 14
 .db 17
 .db 16
 .db 16
 .db 19
 .db 17
 .db 15
 .db 0
 .db 17
 .db 17
 .db 17
 .db 31
 .db 17
 .db 17
 .db 17
 .db 0
 .db 14
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 14
 .db 0
 .db 1
 .db 1
 .db 1
 .db 1
 .db 17
 .db 17
 .db 14
 .db 0
 .db 17
 .db 18
 .db 20
 .db 24
 .db 20
 .db 18
 .db 17
 .db 0
 .db 16
 .db 16
 .db 16
 .db 16
 .db 16
 .db 17
 .db 31
 .db 0
 .db 17
 .db 27
 .db 21
 .db 21
 .db 17
 .db 17
 .db 17
 .db 0
 .db 17
 .db 17
 .db 25
 .db 21
 .db 19
 .db 17
 .db 17
 .db 0
 .db 14
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 14
 .db 0
 .db 30
 .db 17
 .db 17
 .db 30
 .db 16
 .db 16
 .db 16
 .db 0
 .db 14
 .db 17
 .db 17
 .db 17
 .db 21
 .db 18
 .db 13
 .db 0
 .db 30
 .db 17
 .db 17
 .db 30
 .db 20
 .db 18
 .db 17
 .db 0
 .db 14
 .db 17
 .db 16
 .db 14
 .db 1
 .db 17
 .db 14
 .db 0
 .db 31
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 14
 .db 0
 .db 17
 .db 17
 .db 17
 .db 10
 .db 10
 .db 4
 .db 4
 .db 0
 .db 17
 .db 17
 .db 17
 .db 21
 .db 21
 .db 21
 .db 10
 .db 0
 .db 17
 .db 17
 .db 10
 .db 4
 .db 10
 .db 17
 .db 17
 .db 0
 .db 17
 .db 17
 .db 10
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 31
 .db 1
 .db 2
 .db 14
 .db 8
 .db 16
 .db 31
 .db 0
 .db 14
 .db 8
 .db 8
 .db 8
 .db 8
 .db 8
 .db 14
 .db 0
 .db 0
 .db 16
 .db 8
 .db 4
 .db 2
 .db 1
 .db 0
 .db 0
 .db 14
 .db 2
 .db 2
 .db 2
 .db 2
 .db 2
 .db 14
 .db 0
 .db 14
 .db 17
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 31
 .db 24
 .db 24
 .db 16
 .db 8
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 14
 .db 18
 .db 18
 .db 18
 .db 13
 .db 0
 .db 0
 .db 24
 .db 8
 .db 14
 .db 9
 .db 9
 .db 22
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 16
 .db 17
 .db 14
 .db 0
 .db 0
 .db 6
 .db 2
 .db 14
 .db 18
 .db 18
 .db 13
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 31
 .db 16
 .db 15
 .db 0
 .db 0
 .db 3
 .db 4
 .db 14
 .db 4
 .db 4
 .db 14
 .db 0
 .db 0
 .db 0
 .db 13
 .db 18
 .db 18
 .db 14
 .db 2
 .db 28
 .db 0
 .db 24
 .db 8
 .db 14
 .db 9
 .db 9
 .db 25
 .db 0
 .db 0
 .db 8
 .db 0
 .db 8
 .db 8
 .db 8
 .db 6
 .db 0
 .db 0
 .db 2
 .db 0
 .db 2
 .db 2
 .db 18
 .db 12
 .db 0
 .db 0
 .db 24
 .db 8
 .db 11
 .db 12
 .db 10
 .db 25
 .db 0
 .db 0
 .db 12
 .db 4
 .db 4
 .db 4
 .db 4
 .db 14
 .db 0
 .db 0
 .db 0
 .db 26
 .db 21
 .db 21
 .db 21
 .db 21
 .db 0
 .db 0
 .db 0
 .db 28
 .db 18
 .db 18
 .db 18
 .db 18
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 17
 .db 17
 .db 14
 .db 0
 .db 0
 .db 0
 .db 22
 .db 9
 .db 9
 .db 14
 .db 8
 .db 24
 .db 0
 .db 0
 .db 13
 .db 18
 .db 18
 .db 14
 .db 2
 .db 3
 .db 0
 .db 0
 .db 22
 .db 9
 .db 8
 .db 8
 .db 28
 .db 0
 .db 0
 .db 0
 .db 14
 .db 16
 .db 14
 .db 1
 .db 30
 .db 0
 .db 0
 .db 8
 .db 28
 .db 8
 .db 8
 .db 8
 .db 6
 .db 0
 .db 0
 .db 0
 .db 18
 .db 18
 .db 18
 .db 18
 .db 13
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 17
 .db 10
 .db 4
 .db 0
 .db 0
 .db 0
 .db 17
 .db 21
 .db 21
 .db 21
 .db 10
 .db 0
 .db 0
 .db 0
 .db 17
 .db 10
 .db 4
 .db 10
 .db 17
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 15
 .db 1
 .db 30
 .db 0
 .db 0
 .db 0
 .db 31
 .db 18
 .db 4
 .db 9
 .db 31
 .db 0
 .db 3
 .db 4
 .db 4
 .db 8
 .db 4
 .db 4
 .db 3
 .db 0
 .db 0
 .db 4
 .db 4
 .db 0
 .db 0
 .db 4
 .db 4
 .db 0
 .db 24
 .db 4
 .db 4
 .db 2
 .db 4
 .db 4
 .db 24
 .db 0
 .db 10
 .db 20
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 10
 .db 17
 .db 17
 .db 31
 .db 0
 .db 4
 .db 10
 .db 17
 .db 17
 .db 31
 .db 17
 .db 17
 .db 0
 .db 31
 .db 16
 .db 16
 .db 30
 .db 17
 .db 17
 .db 30
 .db 0
 .db 30
 .db 17
 .db 17
 .db 30
 .db 17
 .db 17
 .db 30
 .db 0
 .db 31
 .db 17
 .db 16
 .db 16
 .db 16
 .db 16
 .db 16
 .db 0
 .db 6
 .db 10
 .db 10
 .db 10
 .db 10
 .db 31
 .db 17
 .db 0
 .db 31
 .db 16
 .db 16
 .db 30
 .db 16
 .db 16
 .db 31
 .db 0
 .db 17
 .db 21
 .db 21
 .db 14
 .db 21
 .db 21
 .db 17
 .db 0
 .db 14
 .db 17
 .db 1
 .db 6
 .db 1
 .db 17
 .db 14
 .db 0
 .db 17
 .db 17
 .db 19
 .db 21
 .db 25
 .db 17
 .db 17
 .db 0
 .db 21
 .db 17
 .db 19
 .db 21
 .db 25
 .db 17
 .db 17
 .db 0
 .db 17
 .db 18
 .db 20
 .db 24
 .db 20
 .db 18
 .db 17
 .db 0
 .db 7
 .db 9
 .db 9
 .db 9
 .db 9
 .db 9
 .db 25
 .db 0
 .db 17
 .db 27
 .db 21
 .db 21
 .db 17
 .db 17
 .db 17
 .db 0
 .db 17
 .db 17
 .db 17
 .db 31
 .db 17
 .db 17
 .db 17
 .db 0
 .db 14
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 14
 .db 0
 .db 31
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 17
 .db 0
 .db 30
 .db 17
 .db 17
 .db 30
 .db 16
 .db 16
 .db 16
 .db 0
 .db 14
 .db 17
 .db 16
 .db 16
 .db 16
 .db 17
 .db 14
 .db 0
 .db 31
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 17
 .db 17
 .db 17
 .db 10
 .db 4
 .db 8
 .db 16
 .db 0
 .db 4
 .db 31
 .db 21
 .db 21
 .db 31
 .db 4
 .db 4
 .db 0
 .db 17
 .db 17
 .db 10
 .db 4
 .db 10
 .db 17
 .db 17
 .db 0
 .db 18
 .db 18
 .db 18
 .db 18
 .db 18
 .db 31
 .db 1
 .db 0
 .db 17
 .db 17
 .db 17
 .db 31
 .db 1
 .db 1
 .db 1
 .db 0
 .db 17
 .db 21
 .db 21
 .db 21
 .db 21
 .db 21
 .db 31
 .db 0
 .db 21
 .db 21
 .db 21
 .db 21
 .db 21
 .db 31
 .db 1
 .db 0
 .db 24
 .db 8
 .db 8
 .db 14
 .db 9
 .db 9
 .db 14
 .db 0
 .db 17
 .db 17
 .db 17
 .db 25
 .db 21
 .db 21
 .db 25
 .db 0
 .db 16
 .db 16
 .db 16
 .db 30
 .db 17
 .db 17
 .db 30
 .db 0
 .db 14
 .db 17
 .db 1
 .db 7
 .db 1
 .db 17
 .db 14
 .db 0
 .db 18
 .db 21
 .db 21
 .db 29
 .db 21
 .db 21
 .db 18
 .db 0
 .db 15
 .db 17
 .db 17
 .db 15
 .db 5
 .db 9
 .db 17
 .db 0
 .db 0
 .db 0
 .db 12
 .db 2
 .db 14
 .db 18
 .db 13
 .db 0
 .db 1
 .db 14
 .db 24
 .db 30
 .db 17
 .db 17
 .db 14
 .db 0
 .db 0
 .db 0
 .db 28
 .db 18
 .db 30
 .db 17
 .db 30
 .db 0
 .db 0
 .db 0
 .db 31
 .db 16
 .db 16
 .db 16
 .db 16
 .db 0
 .db 0
 .db 0
 .db 6
 .db 10
 .db 10
 .db 31
 .db 17
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 31
 .db 16
 .db 15
 .db 0
 .db 0
 .db 0
 .db 21
 .db 21
 .db 14
 .db 21
 .db 21
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 6
 .db 17
 .db 14
 .db 0
 .db 0
 .db 0
 .db 17
 .db 19
 .db 21
 .db 25
 .db 17
 .db 0
 .db 0
 .db 4
 .db 17
 .db 19
 .db 21
 .db 25
 .db 17
 .db 0
 .db 0
 .db 0
 .db 17
 .db 18
 .db 28
 .db 18
 .db 17
 .db 0
 .db 0
 .db 0
 .db 7
 .db 9
 .db 9
 .db 9
 .db 25
 .db 0
 .db 0
 .db 0
 .db 17
 .db 27
 .db 21
 .db 17
 .db 17
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 31
 .db 17
 .db 17
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 17
 .db 17
 .db 14
 .db 0
 .db 0
 .db 0
 .db 31
 .db 17
 .db 17
 .db 17
 .db 17
 .db 0
 .db 17
 .db 4
 .db 17
 .db 4
 .db 17
 .db 4
 .db 17
 .db 4
 .db 21
 .db 42
 .db 21
 .db 42
 .db 21
 .db 42
 .db 21
 .db 42
 .db 46
 .db 59
 .db 46
 .db 59
 .db 46
 .db 59
 .db 46
 .db 59
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 60
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 60
 .db 4
 .db 60
 .db 4
 .db 4
 .db 4
 .db 10
 .db 10
 .db 10
 .db 58
 .db 10
 .db 10
 .db 10
 .db 10
 .db 0
 .db 0
 .db 0
 .db 63
 .db 10
 .db 10
 .db 10
 .db 10
 .db 0
 .db 0
 .db 60
 .db 4
 .db 60
 .db 4
 .db 4
 .db 4
 .db 10
 .db 10
 .db 58
 .db 2
 .db 58
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 0
 .db 0
 .db 62
 .db 2
 .db 58
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 58
 .db 2
 .db 62
 .db 0
 .db 0
 .db 0
 .db 10
 .db 10
 .db 10
 .db 62
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 60
 .db 4
 .db 60
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 60
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 7
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 4
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 63
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 7
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 4
 .db 63
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 0
 .db 7
 .db 4
 .db 7
 .db 4
 .db 4
 .db 4
 .db 10
 .db 10
 .db 10
 .db 11
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 11
 .db 8
 .db 15
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 15
 .db 8
 .db 11
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 59
 .db 0
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 63
 .db 0
 .db 59
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 11
 .db 8
 .db 11
 .db 10
 .db 10
 .db 10
 .db 0
 .db 0
 .db 63
 .db 0
 .db 63
 .db 0
 .db 0
 .db 0
 .db 10
 .db 10
 .db 59
 .db 0
 .db 59
 .db 10
 .db 10
 .db 10
 .db 4
 .db 4
 .db 63
 .db 0
 .db 63
 .db 0
 .db 0
 .db 0
 .db 10
 .db 10
 .db 10
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 63
 .db 0
 .db 63
 .db 4
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 63
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 15
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 4
 .db 7
 .db 4
 .db 7
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 7
 .db 4
 .db 7
 .db 4
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 15
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 10
 .db 63
 .db 10
 .db 10
 .db 10
 .db 10
 .db 4
 .db 4
 .db 63
 .db 4
 .db 63
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 4
 .db 60
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 7
 .db 4
 .db 4
 .db 4
 .db 4
 .db 63
 .db 63
 .db 63
 .db 63
 .db 63
 .db 63
 .db 63
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 63
 .db 63
 .db 63
 .db 63
 .db 56
 .db 56
 .db 56
 .db 56
 .db 56
 .db 56
 .db 56
 .db 56
 .db 7
 .db 7
 .db 7
 .db 7
 .db 7
 .db 7
 .db 7
 .db 7
 .db 63
 .db 63
 .db 63
 .db 63
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 30
 .db 17
 .db 30
 .db 16
 .db 16
 .db 0
 .db 0
 .db 0
 .db 14
 .db 17
 .db 16
 .db 17
 .db 14
 .db 0
 .db 0
 .db 0
 .db 31
 .db 4
 .db 4
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 15
 .db 1
 .db 30
 .db 0
 .db 0
 .db 4
 .db 14
 .db 21
 .db 14
 .db 4
 .db 4
 .db 0
 .db 0
 .db 0
 .db 17
 .db 10
 .db 4
 .db 10
 .db 17
 .db 0
 .db 0
 .db 0
 .db 18
 .db 18
 .db 18
 .db 31
 .db 1
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 15
 .db 1
 .db 1
 .db 0
 .db 0
 .db 0
 .db 21
 .db 21
 .db 21
 .db 21
 .db 31
 .db 0
 .db 0
 .db 0
 .db 21
 .db 21
 .db 21
 .db 31
 .db 1
 .db 0
 .db 0
 .db 0
 .db 24
 .db 8
 .db 14
 .db 9
 .db 14
 .db 0
 .db 0
 .db 0
 .db 17
 .db 17
 .db 29
 .db 21
 .db 29
 .db 0
 .db 0
 .db 0
 .db 16
 .db 16
 .db 30
 .db 17
 .db 30
 .db 0
 .db 0
 .db 0
 .db 30
 .db 1
 .db 15
 .db 1
 .db 30
 .db 0
 .db 0
 .db 0
 .db 18
 .db 21
 .db 29
 .db 21
 .db 18
 .db 0
 .db 0
 .db 0
 .db 15
 .db 17
 .db 15
 .db 9
 .db 17
 .db 0
 .db 10
 .db 0
 .db 31
 .db 16
 .db 30
 .db 16
 .db 31
 .db 0
 .db 10
 .db 0
 .db 14
 .db 17
 .db 31
 .db 16
 .db 15
 .db 0
 .db 12
 .db 18
 .db 4
 .db 8
 .db 30
 .db 0
 .db 0
 .db 0
 .db 12
 .db 18
 .db 4
 .db 18
 .db 12
 .db 0
 .db 0
 .db 0
 .db 4
 .db 12
 .db 20
 .db 30
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 12
 .db 12
 .db 0
 .db 63
 .db 0
 .db 12
 .db 12
 .db 0
 .db 0
 .db 10
 .db 20
 .db 0
 .db 10
 .db 20
 .db 0
 .db 0
 .db 0
 .db 8
 .db 20
 .db 8
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 12
 .db 0
 .db 0
 .db 0
 .db 28
 .db 28
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 1
 .db 1
 .db 2
 .db 2
 .db 36
 .db 20
 .db 8
 .db 0
 .db 3
 .db 3
 .db 36
 .db 52
 .db 44
 .db 36
 .db 36
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 30
 .db 30
 .db 30
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0

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
print_1:
 .ds 1
print_2:
 .ds 1
print_3:
 .ds 1
print_4:
 .ds 2
bitBlt_1:
 .ds 2
bitBlt_2:
 .ds 2
bitBlt_3:
 .ds 2
bitBlt_bw_1:
 .ds 2
bitBlt_bw_2:
 .ds 2
bitBlt_bw_3:
 .ds 2
colorRect_1:
 .ds 2
colorRect_2:
 .ds 2
unmlz_1:
 .ds 2
unmlz_2:
 .ds 2
music:
 .dw 75
 .dw 853
 .dw 59
 .dw 542
 .dw 50
 .dw 640
 .dw 59
 .dw 542
 .dw 75
 .dw 853
 .dw 100
 .dw 320
 .dw 89
 .dw 359
 .dw 79
 .dw 405
 .dw 75
 .dw 853
 .dw 59
 .dw 542
 .dw 50
 .dw 640
 .dw 59
 .dw 542
 .dw 67
 .dw 955
 .dw 100
 .dw 320
 .dw 89
 .dw 359
 .dw 79
 .dw 405
 .dw 79
 .dw 810
 .dw 100
 .dw 320
 .dw 89
 .dw 359
 .dw 79
 .dw 405
 .dw 75
 .dw 1706
 .dw 75
 .dw 853
 .dw 59
 .dw 542
 .dw 50
 .dw 640
 .dw 59
 .dw 542
 .dw 67
 .dw 955
 .dw 100
 .dw 320
 .dw 89
 .dw 359
 .dw 79
 .dw 405
 .dw 79
 .dw 810
 .dw 100
 .dw 320
 .dw 89
 .dw 359
 .dw 79
 .dw 405
 .dw 75
 .dw 1706
 .dw 0

imgTitle:
 .db 0
 .db 96
 .db 84
 .db 163
 .db 255
 .db 1
 .db 199
 .db 3
 .db 135
 .db 2
 .db 7
 .db 142
 .db 15
 .db 40
 .db 112
 .db 6
 .db 129
 .db 37
 .db 244
 .db 239
 .db 148
 .db 227
 .db 161
 .db 3
 .db 255
 .db 239
 .db 96
 .db 102
 .db 63
 .db 255
 .db 48
 .db 120
 .db 200
 .db 192
 .db 224
 .db 121
 .db 198
 .db 31
 .db 15
 .db 143
 .db 63
 .db 127
 .db 156
 .db 255
 .db 255
 .db 239
 .db 223
 .db 15
 .db 253
 .db 241
 .db 225
 .db 135
 .db 63
 .db 242
 .db 159
 .db 231
 .db 59
 .db 221
 .db 238
 .db 255
 .db 14
 .db 161
 .db 253
 .db 243
 .db 111
 .db 31
 .db 62
 .db 25
 .db 95
 .db 245
 .db 77
 .db 213
 .db 248
 .db 189
 .db 192
 .db 222
 .db 24
 .db 26
 .db 15
 .db 255
 .db 126
 .db 240
 .db 238
 .db 233
 .db 248
 .db 232
 .db 236
 .db 244
 .db 249
 .db 253
 .db 251
 .db 254
 .db 255
 .db 37
 .db 255
 .db 254
 .db 206
 .db 225
 .db 159
 .db 15
 .db 248
 .db 231
 .db 120
 .db 251
 .db 245
 .db 170
 .db 85
 .db 194
 .db 99
 .db 63
 .db 121
 .db 210
 .db 249
 .db 255
 .db 112
 .db 192
 .db 209
 .db 124
 .db 0
 .db 224
 .db 144
 .db 152
 .db 70
 .db 31
 .db 252
 .db 21
 .db 252
 .db 226
 .db 222
 .db 16
 .db 239
 .db 142
 .db 18
 .db 209
 .db 2
 .db 0
 .db 3
 .db 65
 .db 93
 .db 140
 .db 81
 .db 32
 .db 64
 .db 83
 .db 255
 .db 2
 .db 84
 .db 168
 .db 199
 .db 80
 .db 224
 .db 221
 .db 227
 .db 247
 .db 230
 .db 223
 .db 6
 .db 139
 .db 0
 .db 4
 .db 14
 .db 31
 .db 62
 .db 48
 .db 255
 .db 12
 .db 121
 .db 243
 .db 254
 .db 220
 .db 0
 .db 32
 .db 240
 .db 63
 .db 29
 .db 223
 .db 172
 .db 216
 .db 168
 .db 88
 .db 241
 .db 232
 .db 120
 .db 112
 .db 0
 .db 144
 .db 255
 .db 62
 .db 96
 .db 192
 .db 128
 .db 219
 .db 252
 .db 217
 .db 176
 .db 208
 .db 240
 .db 112
 .db 216
 .db 24
 .db 45
 .db 16
 .db 3
 .db 7
 .db 197
 .db 255
 .db 196
 .db 51
 .db 247
 .db 93
 .db 7
 .db 199
 .db 126
 .db 248
 .db 243
 .db 220
 .db 156
 .db 56
 .db 112
 .db 24
 .db 120
 .db 252
 .db 252
 .db 62
 .db 30
 .db 255
 .db 254
 .db 240
 .db 6
 .db 11
 .db 91
 .db 160
 .db 34
 .db 137
 .db 48
 .db 172
 .db 255
 .db 193
 .db 75
 .db 124
 .db 143
 .db 224
 .db 240
 .db 252
 .db 127
 .db 158
 .db 15
 .db 7
 .db 131
 .db 31
 .db 193
 .db 225
 .db 199
 .db 243
 .db 255
 .db 236
 .db 31
 .db 15
 .db 3
 .db 24
 .db 127
 .db 140
 .db 64
 .db 147
 .db 96
 .db 138
 .db 255
 .db 248
 .db 160
 .db 252
 .db 255
 .db 108
 .db 38
 .db 23
 .db 255
 .db 213
 .db 115
 .db 112
 .db 127
 .db 63
 .db 38
 .db 94
 .db 83
 .db 2
 .db 72
 .db 255
 .db 187
 .db 76
 .db 41
 .db 51
 .db 255
 .db 155
 .db 127
 .db 5
 .db 6
 .db 83
 .db 254
 .db 116
 .db 18
 .db 128
 .db 120
 .db 192
 .db 244
 .db 224
 .db 255
 .db 8
 .db 6
 .db 12
 .db 47
 .db 0
 .db 16
 .db 24
 .db 56
 .db 60
 .db 31
 .db 62
 .db 127
 .db 91
 .db 170
 .db 176
 .db 126
 .db 152
 .db 255
 .db 90
 .db 211
 .db 181
 .db 255
 .db 207
 .db 7
 .db 145
 .db 136
 .db 251
 .db 0
 .db 112
 .db 255
 .db 11
 .db 5
 .db 255
 .db 38
 .db 148
 .db 127
 .db 254
 .db 119
 .db 153
 .db 102
 .db 185
 .db 86
 .db 235
 .db 85
 .db 185
 .db 51
 .db 213
 .db 246
 .db 106
 .db 21
 .db 14
 .db 3
 .db 13
 .db 152
 .db 215
 .db 46
 .db 209
 .db 34
 .db 236
 .db 209
 .db 251
 .db 52
 .db 9
 .db 139
 .db 255
 .db 185
 .db 102
 .db 191
 .db 143
 .db 160
 .db 113
 .db 181
 .db 43
 .db 180
 .db 15
 .db 44
 .db 96
 .db 43
 .db 71
 .db 2
 .db 252
 .db 150
 .db 124
 .db 255
 .db 73
 .db 125
 .db 123
 .db 183
 .db 159
 .db 99
 .db 250
 .db 156
 .db 109
 .db 179
 .db 92
 .db 175
 .db 252
 .db 252
 .db 234
 .db 242
 .db 252
 .db 117
 .db 30
 .db 13
 .db 63
 .db 193
 .db 167
 .db 11
 .db 215
 .db 203
 .db 146
 .db 110
 .db 164
 .db 71
 .db 198
 .db 199
 .db 179
 .db 195
 .db 20
 .db 255
 .db 199
 .db 234
 .db 103
 .db 47
 .db 235
 .db 199
 .db 87
 .db 212
 .db 248
 .db 168
 .db 99
 .db 7
 .db 142
 .db 140
 .db 141
 .db 46
 .db 55
 .db 255
 .db 251
 .db 185
 .db 85
 .db 128
 .db 248
 .db 239
 .db 234
 .db 63
 .db 143
 .db 243
 .db 60
 .db 252
 .db 207
 .db 179
 .db 92
 .db 239
 .db 85
 .db 171
 .db 106
 .db 238
 .db 247
 .db 246
 .db 110
 .db 53
 .db 11
 .db 216
 .db 7
 .db 1
 .db 51
 .db 97
 .db 215
 .db 122
 .db 232
 .db 193
 .db 107
 .db 255
 .db 192
 .db 130
 .db 248
 .db 178
 .db 203
 .db 255
 .db 163
 .db 128
 .db 22
 .db 234
 .db 96
 .db 235
 .db 199
 .db 242
 .db 225
 .db 159
 .db 192
 .db 255
 .db 0
 .db 30
 .db 63
 .db 255
 .db 97
 .db 185
 .db 255
 .db 175
 .db 27
 .db 186
 .db 127
 .db 0
 .db 31
 .db 227
 .db 180
 .db 252
 .db 239
 .db 233
 .db 31
 .db 231
 .db 241
 .db 243
 .db 62
 .db 205
 .db 179
 .db 93
 .db 0
 .db 187
 .db 24
 .db 71
 .db 255
 .db 248
 .db 59
 .db 13
 .db 216
 .db 6
 .db 1
 .db 46
 .db 99
 .db 215
 .db 8
 .db 28
 .db 223
 .db 30
 .db 31
 .db 248
 .db 60
 .db 254
 .db 246
 .db 252
 .db 104
 .db 255
 .db 177
 .db 238
 .db 35
 .db 235
 .db 158
 .db 167
 .db 127
 .db 126
 .db 60
 .db 24
 .db 123
 .db 255
 .db 8
 .db 129
 .db 195
 .db 13
 .db 81
 .db 0
 .db 31
 .db 221
 .db 214
 .db 197
 .db 202
 .db 38
 .db 254
 .db 102
 .db 175
 .db 143
 .db 241
 .db 250
 .db 192
 .db 190
 .db 174
 .db 187
 .db 245
 .db 227
 .db 251
 .db 220
 .db 111
 .db 157
 .db 231
 .db 89
 .db 254
 .db 252
 .db 247
 .db 252
 .db 251
 .db 53
 .db 30
 .db 94
 .db 246
 .db 96
 .db 181
 .db 141
 .db 215
 .db 128
 .db 248
 .db 110
 .db 6
 .db 120
 .db 148
 .db 255
 .db 56
 .db 255
 .db 123
 .db 249
 .db 16
 .db 1
 .db 92
 .db 237
 .db 118
 .db 215
 .db 84
 .db 39
 .db 186
 .db 16
 .db 22
 .db 60
 .db 126
 .db 142
 .db 124
 .db 212
 .db 227
 .db 237
 .db 235
 .db 4
 .db 128
 .db 1
 .db 236
 .db 206
 .db 62
 .db 47
 .db 255
 .db 53
 .db 143
 .db 111
 .db 129
 .db 15
 .db 240
 .db 246
 .db 0
 .db 199
 .db 0
 .db 217
 .db 229
 .db 63
 .db 218
 .db 207
 .db 179
 .db 254
 .db 252
 .db 191
 .db 224
 .db 0
 .db 73
 .db 248
 .db 213
 .db 215
 .db 46
 .db 29
 .db 88
 .db 63
 .db 43
 .db 227
 .db 215
 .db 1
 .db 7
 .db 50
 .db 46
 .db 126
 .db 27
 .db 129
 .db 255
 .db 66
 .db 254
 .db 248
 .db 56
 .db 24
 .db 16
 .db 2
 .db 198
 .db 44
 .db 162
 .db 255
 .db 219
 .db 13
 .db 99
 .db 245
 .db 252
 .db 253
 .db 193
 .db 0
 .db 255
 .db 86
 .db 186
 .db 91
 .db 140
 .db 241
 .db 0
 .db 255
 .db 254
 .db 246
 .db 128
 .db 127
 .db 31
 .db 225
 .db 207
 .db 165
 .db 240
 .db 15
 .db 159
 .db 103
 .db 255
 .db 249
 .db 86
 .db 239
 .db 53
 .db 207
 .db 115
 .db 236
 .db 87
 .db 161
 .db 255
 .db 0
 .db 252
 .db 132
 .db 239
 .db 158
 .db 248
 .db 117
 .db 31
 .db 13
 .db 3
 .db 193
 .db 59
 .db 24
 .db 215
 .db 12
 .db 30
 .db 237
 .db 62
 .db 51
 .db 19
 .db 8
 .db 198
 .db 255
 .db 217
 .db 62
 .db 120
 .db 207
 .db 28
 .db 24
 .db 8
 .db 236
 .db 56
 .db 243
 .db 2
 .db 254
 .db 29
 .db 208
 .db 255
 .db 235
 .db 148
 .db 184
 .db 52
 .db 132
 .db 195
 .db 135
 .db 248
 .db 1
 .db 254
 .db 251
 .db 1
 .db 167
 .db 30
 .db 247
 .db 111
 .db 229
 .db 143
 .db 115
 .db 252
 .db 2
 .db 125
 .db 252
 .db 45
 .db 250
 .db 85
 .db 220
 .db 254
 .db 213
 .db 127
 .db 21
 .db 216
 .db 18
 .db 1
 .db 38
 .db 96
 .db 215
 .db 220
 .db 186
 .db 248
 .db 109
 .db 148
 .db 31
 .db 255
 .db 251
 .db 118
 .db 48
 .db 46
 .db 32
 .db 48
 .db 24
 .db 154
 .db 255
 .db 31
 .db 227
 .db 221
 .db 190
 .db 250
 .db 193
 .db 12
 .db 255
 .db 211
 .db 151
 .db 174
 .db 0
 .db 139
 .db 6
 .db 251
 .db 77
 .db 187
 .db 252
 .db 123
 .db 243
 .db 195
 .db 63
 .db 35
 .db 239
 .db 216
 .db 87
 .db 2
 .db 119
 .db 168
 .db 242
 .db 118
 .db 4
 .db 190
 .db 248
 .db 90
 .db 244
 .db 37
 .db 248
 .db 63
 .db 89
 .db 130
 .db 29
 .db 149
 .db 128
 .db 221
 .db 66
 .db 151
 .db 2
 .db 156
 .db 7
 .db 255
 .db 177
 .db 143
 .db 204
 .db 181
 .db 8
 .db 191
 .db 14
 .db 130
 .db 224
 .db 240
 .db 97
 .db 114
 .db 19
 .db 254
 .db 182
 .db 176
 .db 47
 .db 248
 .db 216
 .db 220
 .db 215
 .db 140
 .db 136
 .db 217
 .db 76
 .db 99
 .db 125
 .db 228
 .db 1
 .db 91
 .db 150
 .db 19
 .db 63
 .db 193
 .db 107
 .db 234
 .db 2
 .db 112
 .db 219
 .db 243
 .db 37
 .db 199
 .db 124
 .db 251
 .db 131
 .db 231
 .db 121
 .db 254
 .db 93
 .db 95
 .db 128
 .db 252
 .db 240
 .db 0
 .db 142
 .db 47
 .db 248
 .db 88
 .db 246
 .db 55
 .db 34
 .db 252
 .db 251
 .db 15
 .db 129
 .db 195
 .db 231
 .db 199
 .db 44
 .db 255
 .db 252
 .db 217
 .db 25
 .db 239
 .db 217
 .db 5
 .db 129
 .db 239
 .db 131
 .db 245
 .db 3
 .db 17
 .db 48
 .db 56
 .db 198
 .db 216
 .db 21
 .db 115
 .db 251
 .db 247
 .db 227
 .db 38
 .db 254
 .db 255
 .db 119
 .db 126
 .db 253
 .db 99
 .db 34
 .db 0
 .db 65
 .db 64
 .db 185
 .db 68
 .db 11
 .db 27
 .db 15
 .db 23
 .db 194
 .db 13
 .db 22
 .db 152
 .db 5
 .db 254
 .db 2
 .db 134
 .db 131
 .db 252
 .db 67
 .db 3
 .db 159
 .db 250
 .db 254
 .db 245
 .db 234
 .db 5
 .db 232
 .db 33
 .db 252
 .db 1
 .db 128
 .db 191
 .db 126
 .db 173
 .db 248
 .db 243
 .db 62
 .db 31
 .db 127
 .db 112
 .db 245
 .db 243
 .db 124
 .db 103
 .db 253
 .db 183
 .db 63
 .db 207
 .db 120
 .db 248
 .db 209
 .db 4
 .db 223
 .db 252
 .db 228
 .db 248
 .db 236
 .db 91
 .db 230
 .db 97
 .db 213
 .db 86
 .db 1
 .db 86
 .db 51
 .db 98
 .db 7
 .db 252
 .db 176
 .db 133
 .db 255
 .db 248
 .db 73
 .db 218
 .db 224
 .db 209
 .db 155
 .db 128
 .db 255
 .db 15
 .db 11
 .db 243
 .db 2
 .db 191
 .db 140
 .db 31
 .db 127
 .db 253
 .db 15
 .db 0
 .db 20
 .db 190
 .db 233
 .db 254
 .db 65
 .db 70
 .db 161
 .db 251
 .db 7
 .db 219
 .db 227
 .db 117
 .db 170
 .db 84
 .db 102
 .db 20
 .db 169
 .db 125
 .db 65
 .db 6
 .db 85
 .db 2
 .db 85
 .db 246
 .db 248
 .db 3
 .db 42
 .db 5
 .db 168
 .db 23
 .db 0
 .db 213
 .db 247
 .db 253
 .db 248
 .db 126
 .db 217
 .db 247
 .db 61
 .db 245
 .db 175
 .db 241
 .db 181
 .db 230
 .db 248
 .db 252
 .db 8
 .db 4
 .db 190
 .db 233
 .db 221
 .db 248
 .db 63
 .db 177
 .db 31
 .db 239
 .db 228
 .db 251
 .db 25
 .db 4
 .db 254
 .db 141
 .db 129
 .db 1
 .db 217
 .db 6
 .db 2
 .db 181
 .db 2
 .db 85
 .db 1
 .db 190
 .db 62
 .db 161
 .db 3
 .db 51
 .db 75
 .db 255
 .db 172
 .db 16
 .db 194
 .db 239
 .db 233
 .db 8
 .db 237
 .db 92
 .db 3
 .db 29
 .db 114
 .db 3
 .db 227
 .db 195
 .db 110
 .db 120
 .db 7
 .db 15
 .db 3
 .db 160
 .db 96
 .db 211
 .db 80
 .db 254
 .db 132
 .db 48
 .db 252
 .db 72
 .db 32
 .db 0
 .db 83
 .db 1
 .db 73
 .db 127
 .db 191
 .db 245
 .db 95
 .db 168
 .db 7
 .db 160
 .db 131
 .db 15
 .db 254
 .db 40
 .db 253
 .db 5
 .db 168
 .db 87
 .db 175
 .db 95
 .db 191
 .db 166
 .db 241
 .db 111
 .db 142
 .db 241
 .db 153
 .db 156
 .db 150
 .db 246
 .db 127
 .db 156
 .db 227
 .db 249
 .db 152
 .db 127
 .db 218
 .db 159
 .db 231
 .db 25
 .db 247
 .db 134
 .db 225
 .db 53
 .db 172
 .db 248
 .db 153
 .db 68
 .db 108
 .db 132
 .db 25
 .db 101
 .db 251
 .db 250
 .db 12
 .db 19
 .db 216
 .db 254
 .db 5
 .db 34
 .db 146
 .db 255
 .db 172
 .db 62
 .db 113
 .db 175
 .db 31
 .db 255
 .db 159
 .db 89
 .db 138
 .db 255
 .db 127
 .db 209
 .db 0
 .db 213
 .db 96
 .db 137
 .db 199
 .db 3
 .db 158
 .db 153
 .db 246
 .db 119
 .db 48
 .db 0
 .db 252
 .db 3
 .db 6
 .db 16
 .db 7
 .db 4
 .db 161
 .db 232
 .db 126
 .db 130
 .db 252
 .db 248
 .db 211
 .db 46
 .db 251
 .db 235
 .db 248
 .db 39
 .db 154
 .db 190
 .db 241
 .db 143
 .db 47
 .db 206
 .db 150
 .db 1
 .db 214
 .db 47
 .db 247
 .db 252
 .db 253
 .db 251
 .db 137
 .db 199
 .db 102
 .db 140
 .db 66
 .db 248
 .db 204
 .db 34
 .db 236
 .db 2
 .db 188
 .db 91
 .db 156
 .db 206
 .db 17
 .db 157
 .db 206
 .db 7
 .db 248
 .db 18
 .db 5
 .db 152
 .db 255
 .db 182
 .db 131
 .db 53
 .db 255
 .db 87
 .db 243
 .db 135
 .db 21
 .db 5
 .db 234
 .db 73
 .db 240
 .db 204
 .db 70
 .db 52
 .db 197
 .db 253
 .db 251
 .db 35
 .db 255
 .db 241
 .db 179
 .db 245
 .db 82
 .db 254
 .db 43
 .db 173
 .db 31
 .db 60
 .db 55
 .db 95
 .db 63
 .db 127
 .db 191
 .db 159
 .db 111
 .db 254
 .db 183
 .db 93
 .db 46
 .db 85
 .db 198
 .db 42
 .db 23
 .db 235
 .db 21
 .db 10
 .db 1
 .db 39
 .db 28
 .db 12
 .db 253
 .db 26
 .db 243
 .db 193
 .db 234
 .db 213
 .db 170
 .db 254
 .db 212
 .db 232
 .db 160
 .db 197
 .db 42
 .db 248
 .db 184
 .db 224
 .db 170
 .db 30
 .db 186
 .db 245
 .db 243
 .db 126
 .db 127
 .db 179
 .db 242
 .db 254
 .db 251
 .db 196
 .db 53
 .db 225
 .db 204
 .db 249
 .db 2
 .db 120
 .db 4
 .db 48
 .db 8
 .db 252
 .db 2
 .db 102
 .db 196
 .db 41
 .db 1
 .db 224
 .db 149
 .db 225
 .db 45
 .db 208
 .db 33
 .db 88
 .db 224
 .db 255
 .db 198
 .db 7
 .db 253
 .db 127
 .db 74
 .db 2
 .db 65
 .db 235
 .db 106
 .db 14
 .db 106
 .db 2
 .db 205
 .db 183
 .db 69
 .db 42
 .db 125
 .db 214
 .db 92
 .db 239
 .db 25
 .db 106
 .db 252
 .db 247
 .db 15
 .db 221
 .db 239
 .db 250
 .db 169
 .db 181
 .db 38
 .db 253
 .db 254
 .db 138
 .db 84
 .db 227
 .db 227
 .db 249
 .db 234
 .db 69
 .db 242
 .db 168
 .db 84
 .db 162
 .db 21
 .db 248
 .db 220
 .db 254
 .db 190
 .db 250
 .db 255
 .db 178
 .db 2
 .db 190
 .db 252
 .db 199
 .db 255
 .db 251
 .db 248
 .db 228
 .db 52
 .db 204
 .db 34
 .db 254
 .db 179
 .db 250
 .db 93
 .db 0
 .db 4
 .db 6
 .db 15
 .db 245
 .db 0
 .db 20
 .db 70
 .db 116
 .db 89
 .db 28
 .db 226
 .db 238
 .db 237
 .db 232
 .db 15
 .db 14
 .db 14
 .db 236
 .db 4
 .db 0
 .db 1
 .db 58
 .db 89
 .db 1
 .db 240
 .db 253
 .db 132
 .db 198
 .db 80
 .db 168
 .db 62
 .db 30
 .db 184
 .db 212
 .db 170
 .db 208
 .db 183
 .db 240
 .db 80
 .db 8
 .db 12
 .db 169
 .db 68
 .db 196
 .db 240
 .db 32
 .db 91
 .db 102
 .db 244
 .db 1
 .db 7
 .db 31
 .db 171
 .db 16
 .db 62
 .db 236
 .db 130
 .db 5
 .db 160
 .db 84
 .db 201
 .db 1
 .db 0
 .db 171
 .db 172
 .db 95
 .db 110
 .db 195
 .db 243
 .db 207
 .db 195
 .db 118
 .db 157
 .db 89
 .db 121
 .db 103
 .db 31
 .db 137
 .db 223
 .db 84
 .db 126
 .db 120
 .db 219
 .db 112
 .db 64
 .db 145
 .db 154
 .db 2
 .db 237
 .db 254
 .db 120
 .db 60
 .db 156
 .db 128
 .db 213
 .db 192
 .db 248
 .db 166
 .db 42
 .db 60
 .db 255
 .db 28
 .db 66
 .db 255
 .db 122
 .db 249
 .db 8
 .db 208
 .db 105
 .db 249
 .db 245
 .db 225
 .db 12
 .db 28
 .db 62
 .db 183
 .db 250
 .db 171
 .db 228
 .db 124
 .db 26
 .db 83
 .db 192
 .db 1
 .db 251
 .db 210
 .db 10
 .db 114
 .db 11
 .db 200
 .db 157
 .db 191
 .db 248
 .db 177
 .db 255
 .db 159
 .db 213
 .db 102
 .db 65
 .db 7
 .db 162
 .db 127
 .db 137
 .db 28
 .db 199
 .db 3
 .db 31
 .db 187
 .db 128
 .db 27
 .db 154
 .db 14
 .db 1
 .db 175
 .db 154
 .db 7
 .db 180
 .db 120
 .db 255
 .db 59
 .db 188
 .db 67
 .db 63
 .db 227
 .db 95
 .db 175
 .db 87
 .db 122
 .db 23
 .db 143
 .db 81
 .db 174
 .db 218
 .db 230
 .db 221
 .db 228
 .db 127
 .db 54
 .db 169
 .db 249
 .db 199
 .db 186
 .db 128
 .db 42
 .db 246
 .db 76
 .db 35
 .db 73
 .db 135
 .db 248
 .db 217
 .db 240
 .db 192
 .db 136
 .db 154
 .db 15
 .db 16
 .db 25
 .db 32
 .db 3
 .db 73
 .db 6
 .db 164
 .db 247
 .db 98
 .db 102
 .db 255
 .db 47
 .db 199
 .db 90
 .db 69
 .db 28
 .db 133
 .db 43
 .db 13
 .db 207
 .db 68
 .db 255
 .db 135
 .db 219
 .db 255
 .db 3
 .db 77
 .db 27
 .db 137
 .db 70
 .db 144
 .db 5
 .db 177
 .db 250
 .db 6
 .db 118
 .db 70
 .db 0
 .db 198
 .db 1
 .db 240
 .db 198
 .db 248
 .db 4
 .db 137
 .db 255
 .db 7
 .db 117
 .db 255
 .db 3
 .db 224
 .db 253
 .db 250
 .db 252
 .db 0
 .db 245
 .db 17
 .db 205
 .db 254
 .db 125
 .db 128
 .db 119
 .db 22
 .db 240
 .db 143
 .db 108
 .db 133
 .db 126
 .db 25
 .db 235
 .db 101
 .db 14
 .db 235
 .db 254
 .db 191
 .db 17
 .db 87
 .db 103
 .db 252
 .db 88
 .db 91
 .db 139
 .db 141
 .db 15
 .db 128
 .db 226
 .db 153
 .db 64
 .db 25
 .db 12
 .db 6
 .db 143
 .db 199
 .db 196
 .db 150
 .db 111
 .db 3
 .db 111
 .db 45
 .db 3
 .db 7
 .db 140
 .db 255
 .db 187
 .db 190
 .db 1
 .db 241
 .db 2
 .db 6
 .db 246
 .db 128
 .db 224
 .db 27
 .db 108
 .db 15
 .db 250
 .db 255
 .db 0
 .db 2
 .db 23
 .db 61
 .db 53
 .db 75
 .db 165
 .db 141
 .db 219
 .db 66
 .db 21
 .db 117
 .db 48
 .db 154
 .db 168
 .db 21
 .db 117
 .db 125
 .db 245
 .db 234
 .db 213
 .db 208
 .db 20
 .db 45
 .db 160
 .db 251
 .db 22
 .db 42
 .db 226
 .db 4
 .db 160
 .db 5
 .db 118
 .db 213
 .db 234
 .db 253
 .db 75
 .db 187
 .db 28
 .db 227
 .db 219
 .db 207
 .db 63
 .db 44
 .db 4
 .db 63
 .db 76
 .db 5
 .db 197
 .db 233
 .db 247
 .db 24
 .db 241
 .db 132
 .db 153
 .db 68
 .db 152
 .db 136
 .db 252
 .db 22
 .db 140
 .db 90
 .db 233
 .db 8
 .db 239
 .db 52
 .db 30
 .db 90
 .db 114
 .db 247
 .db 169
 .db 255
 .db 243
 .db 255
 .db 227
 .db 122
 .db 255
 .db 195
 .db 206
 .db 107
 .db 255
 .db 207
 .db 131
 .db 239
 .db 45
 .db 213
 .db 253
 .db 252
 .db 134
 .db 157
 .db 4
 .db 28
 .db 227
 .db 32
 .db 212
 .db 42
 .db 28
 .db 22
 .db 238
 .db 181
 .db 76
 .db 180
 .db 106
 .db 36
 .db 4
 .db 137
 .db 81
 .db 84
 .db 136
 .db 136
 .db 99
 .db 75
 .db 16
 .db 110
 .db 1
 .db 87
 .db 233
 .db 20
 .db 14
 .db 182
 .db 128
 .db 234
 .db 26
 .db 226
 .db 12
 .db 186
 .db 240
 .db 235
 .db 20
 .db 205
 .db 198
 .db 253
 .db 11
 .db 247
 .db 107
 .db 224
 .db 255
 .db 27
 .db 89
 .db 163
 .db 173
 .db 104
 .db 162
 .db 240
 .db 5
 .db 198
 .db 157
 .db 255
 .db 240
 .db 8
 .db 152
 .db 108
 .db 0
 .db 129
 .db 252
 .db 120
 .db 98
 .db 62
 .db 113
 .db 227
 .db 129
 .db 227
 .db 225
 .db 216
 .db 193
 .db 138
 .db 255
 .db 225
 .db 204
 .db 96
 .db 255
 .db 227
 .db 243
 .db 59
 .db 76
 .db 255
 .db 51
 .db 186
 .db 0
 .db 51
 .db 255
 .db 112
 .db 142
 .db 52
 .db 32
 .db 187
 .db 252
 .db 139
 .db 96
 .db 209
 .db 156
 .db 16
 .db 109
 .db 64
 .db 39
 .db 8
 .db 191
 .db 235
 .db 95
 .db 47
 .db 0
 .db 163
 .db 18
 .db 119
 .db 168
 .db 83
 .db 143
 .db 245
 .db 20
 .db 69
 .db 229
 .db 166
 .db 145
 .db 204
 .db 12
 .db 89
 .db 12
 .db 30
 .db 4
 .db 248
 .db 101
 .db 87
 .db 252
 .db 254
 .db 220
 .db 236
 .db 240
 .db 96
 .db 128
 .db 56
 .db 176
 .db 1
 .db 247
 .db 96
 .db 105
 .db 38
 .db 113
 .db 97
 .db 149
 .db 107
 .db 23
 .db 241
 .db 85
 .db 255
 .db 243
 .db 231
 .db 255
 .db 121
 .db 235
 .db 187
 .db 59
 .db 126
 .db 60
 .db 171
 .db 24
 .db 88
 .db 255
 .db 0
 .db 228
 .db 152
 .db 3
 .db 87
 .db 234
 .db 101
 .db 255
 .db 216
 .db 255
 .db 131
 .db 9
 .db 254
 .db 187
 .db 193
 .db 239
 .db 172
 .db 141
 .db 244
 .db 199
 .db 191
 .db 223
 .db 162
 .db 197
 .db 236
 .db 233
 .db 20
 .db 221
 .db 24
 .db 94
 .db 13
 .db 192
 .db 183
 .db 127
 .db 117
 .db 17
 .db 8
 .db 252
 .db 162
 .db 248
 .db 118
 .db 88
 .db 75
 .db 123
 .db 39
 .db 6
 .db 244
 .db 5
 .db 123
 .db 31
 .db 39
 .db 81
 .db 192
 .db 125
 .db 237
 .db 249
 .db 79
 .db 255
 .db 250
 .db 254
 .db 251
 .db 10
 .db 95
 .db 83
 .db 229
 .db 129
 .db 255
 .db 195
 .db 199
 .db 9
 .db 252
 .db 46
 .db 186
 .db 48
 .db 236
 .db 92
 .db 39
 .db 40
 .db 4
 .db 88
 .db 96
 .db 127
 .db 204
 .db 212
 .db 86
 .db 29
 .db 6
 .db 235
 .db 227
 .db 31
 .db 95
 .db 247
 .db 215
 .db 227
 .db 31
 .db 225
 .db 27
 .db 165
 .db 239
 .db 32
 .db 31
 .db 245
 .db 78
 .db 4
 .db 115
 .db 207
 .db 55
 .db 167
 .db 8
 .db 117
 .db 124
 .db 222
 .db 4
 .db 248
 .db 203
 .db 254
 .db 120
 .db 5
 .db 14
 .db 12
 .db 12
 .db 251
 .db 227
 .db 255
 .db 240
 .db 249
 .db 48
 .db 142
 .db 99
 .db 255
 .db 213
 .db 249
 .db 244
 .db 218
 .db 96
 .db 64
 .db 255
 .db 216
 .db 6
 .db 31
 .db 241
 .db 10
 .db 191
 .db 54
 .db 175
 .db 227
 .db 193
 .db 55
 .db 250
 .db 91
 .db 131
 .db 45
 .db 1
 .db 219
 .db 24
 .db 128
 .db 217
 .db 29
 .db 85
 .db 244
 .db 183
 .db 143
 .db 11
 .db 22
 .db 86
 .db 249
 .db 103
 .db 9
 .db 25
 .db 16
 .db 47
 .db 254
 .db 84
 .db 248
 .db 96
 .db 192
 .db 111
 .db 102
 .db 69
 .db 155
 .db 85
 .db 9
 .db 135
 .db 49
 .db 249
 .db 245
 .db 16
 .db 48
 .db 56
 .db 120
 .db 33
 .db 48
 .db 236
 .db 126
 .db 252
 .db 49
 .db 17
 .db 27
 .db 153
 .db 253
 .db 217
 .db 127
 .db 212
 .db 199
 .db 60
 .db 56
 .db 143
 .db 16
 .db 0
 .db 176
 .db 129
 .db 187
 .db 125
 .db 2
 .db 124
 .db 120
 .db 112
 .db 138
 .db 249
 .db 0
 .db 250
 .db 4
 .db 44
 .db 248
 .db 136
 .db 107
 .db 7
 .db 7
 .db 248
 .db 218
 .db 18
 .db 53
 .db 251
 .db 82
 .db 4
 .db 155
 .db 4
 .db 187
 .db 144
 .db 10
 .db 251
 .db 147
 .db 248
 .db 87
 .db 252
 .db 187
 .db 88
 .db 175
 .db 186
 .db 228
 .db 204
 .db 63
 .db 127
 .db 121
 .db 240
 .db 224
 .db 193
 .db 31
 .db 131
 .db 135
 .db 163
 .db 207
 .db 192
 .db 14
 .db 253
 .db 244
 .db 6
 .db 124
 .db 25
 .db 0
 .db 231
 .db 255
 .db 225
 .db 24
 .db 136
 .db 157
 .db 233
 .db 152
 .db 251
 .db 14
 .db 241
 .db 4
 .db 216
 .db 95
 .db 150
 .db 251
 .db 44
 .db 128
 .db 239
 .db 248
 .db 135
 .db 127
 .db 252
 .db 5
 .db 0
 .db 22
 .db 254
 .db 11
 .db 252
 .db 230
 .db 29
 .db 251
 .db 92
 .db 243
 .db 77
 .db 210
 .db 8
 .db 254
 .db 4
 .db 239
 .db 19
 .db 155
 .db 248
 .db 186
 .db 92
 .db 47
 .db 151
 .db 26
 .db 192
 .db 212
 .db 110
 .db 36
 .db 255
 .db 127
 .db 49
 .db 66
 .db 126
 .db 31
 .db 255
 .db 59
 .db 57
 .db 28
 .db 14
 .db 3
 .db 12
 .db 254
 .db 30
 .db 63
 .db 124
 .db 120
 .db 255
 .db 127
 .db 15
 .db 194
 .db 223
 .db 47
 .db 241
 .db 84
 .db 186
 .db 135
 .db 24
 .db 38
 .db 68
 .db 255
 .db 199
 .db 131
 .db 199
 .db 21
 .db 235
 .db 162
 .db 60
 .db 11
 .db 166
 .db 252
 .db 197
 .db 254
 .db 93
 .db 239
 .db 187
 .db 11
 .db 155
 .db 13
 .db 1
 .db 254
 .db 78
 .db 255
 .db 0
 .db 157
 .db 123
 .db 220
 .db 243
 .db 205
 .db 59
 .db 213
 .db 160
 .db 238
 .db 8
 .db 142
 .db 118
 .db 0
 .db 86
 .db 188
 .db 112
 .db 63
 .db 207
 .db 26
 .db 96
 .db 112
 .db 128
 .db 224
 .db 255
 .db 240
 .db 56
 .db 158
 .db 207
 .db 127
 .db 59
 .db 0
 .db 4
 .db 84
 .db 99
 .db 80
 .db 240
 .db 78
 .db 255
 .db 30
 .db 14
 .db 0
 .db 50
 .db 7
 .db 255
 .db 6
 .db 111
 .db 215
 .db 225
 .db 224
 .db 49
 .db 54
 .db 89
 .db 198
 .db 183
 .db 217
 .db 188
 .db 84
 .db 1
 .db 107
 .db 167
 .db 18
 .db 175
 .db 255
 .db 231
 .db 92
 .db 255
 .db 239
 .db 255
 .db 100
 .db 57
 .db 52
 .db 124
 .db 56
 .db 48
 .db 255
 .db 236
 .db 16
 .db 1
 .db 135
 .db 41
 .db 88
 .db 1
 .db 224
 .db 185
 .db 68
 .db 26
 .db 13
 .db 114
 .db 180
 .db 3
 .db 189
 .db 11
 .db 62
 .db 237
 .db 217
 .db 230
 .db 221
 .db 23
 .db 4
 .db 234
 .db 59
 .db 0
 .db 88
 .db 176
 .db 64
 .db 8
 .db 247
 .db 31
 .db 7
 .db 245
 .db 9
 .db 25
 .db 98
 .db 248
 .db 47
 .db 231
 .db 71
 .db 123
 .db 8
 .db 247
 .db 182
 .db 249
 .db 220
 .db 101
 .db 0
 .db 14
 .db 130
 .db 186
 .db 138
 .db 48
 .db 129
 .db 31
 .db 158
 .db 171
 .db 213
 .db 106
 .db 53
 .db 169
 .db 26
 .db 92
 .db 29
 .db 199
 .db 60
 .db 179
 .db 247
 .db 124
 .db 1
 .db 61
 .db 14
 .db 211
 .db 253
 .db 102
 .db 201
 .db 87
 .db 166
 .db 153
 .db 6
 .db 55
 .db 250
 .db 100
 .db 199
 .db 245
 .db 143
 .db 7
 .db 117
 .db 171
 .db 38
 .db 96
 .db 204
 .db 136
 .db 41
 .db 187
 .db 250
 .db 186
 .db 201
 .db 197
 .db 11
 .db 68
 .db 141
 .db 13
 .db 55
 .db 22
 .db 158
 .db 251
 .db 121
 .db 230
 .db 157
 .db 123
 .db 213
 .db 147
 .db 8
 .db 170
 .db 252
 .db 86
 .db 216
 .db 232
 .db 112
 .db 83
 .db 223
 .db 43
 .db 126
 .db 15
 .db 119
 .db 151
 .db 251
 .db 23
 .db 55
 .db 47
 .db 159
 .db 191
 .db 34
 .db 170
 .db 238
 .db 35
 .db 196
 .db 106
 .db 125
 .db 135
 .db 88
 .db 219
 .db 31
 .db 231
 .db 122
 .db 238
 .db 87
 .db 184
 .db 175
 .db 152
 .db 252
 .db 158
 .db 244
 .db 159
 .db 255
 .db 177
 .db 14
 .db 2
 .db 193
 .db 210
 .db 254
 .db 208
 .db 22
 .db 140
 .db 35
 .db 47
 .db 255
 .db 110
 .db 230
 .db 241
 .db 249
 .db 139
 .db 59
 .db 163
 .db 247
 .db 3
 .db 97
 .db 196
 .db 155
 .db 7
 .db 159
 .db 255
 .db 236
 .db 11
 .db 156
 .db 123
 .db 234
 .db 4
 .db 122
 .db 213
 .db 105
 .db 37
 .db 88
 .db 188
 .db 216
 .db 88
 .db 160
 .db 85
 .db 207
 .db 48
 .db 12
 .db 30
 .db 19
 .db 3
 .db 238
 .db 7
 .db 158
 .db 248
 .db 253
 .db 113
 .db 254
 .db 223
 .db 33
 .db 129
 .db 251
 .db 191
 .db 255
 .db 143
 .db 135
 .db 225
 .db 248
 .db 92
 .db 185
 .db 103
 .db 220
 .db 255
 .db 187
 .db 119
 .db 112
 .db 123
 .db 191
 .db 207
 .db 246
 .db 248
 .db 239
 .db 124
 .db 152
 .db 224
 .db 214
 .db 204
 .db 31
 .db 191
 .db 207
 .db 228
 .db 119
 .db 32
 .db 124
 .db 96
 .db 112
 .db 120
 .db 120
 .db 228
 .db 197
 .db 107
 .db 248
 .db 19
 .db 91
 .db 255
 .db 249
 .db 29
 .db 255
 .db 6
 .db 66
 .db 86
 .db 241
 .db 47
 .db 63
 .db 30
 .db 253
 .db 12
 .db 4
 .db 192
 .db 240
 .db 135
 .db 224
 .db 1
 .db 63
 .db 247
 .db 204
 .db 51
 .db 206
 .db 53
 .db 235
 .db 105
 .db 45
 .db 39
 .db 84
 .db 184
 .db 113
 .db 26
 .db 135
 .db 217
 .db 50
 .db 30
 .db 64
 .db 184
 .db 243
 .db 171
 .db 240
 .db 96
 .db 118
 .db 203
 .db 222
 .db 239
 .db 47
 .db 232
 .db 24
 .db 255
 .db 204
 .db 42
 .db 159
 .db 187
 .db 49
 .db 47
 .db 189
 .db 208
 .db 255
 .db 97
 .db 56
 .db 249
 .db 215
 .db 82
 .db 11
 .db 124
 .db 255
 .db 200
 .db 253
 .db 250
 .db 240
 .db 147
 .db 199
 .db 225
 .db 23
 .db 188
 .db 181
 .db 251
 .db 129
 .db 1
 .db 242
 .db 195
 .db 157
 .db 194
 .db 131
 .db 255
 .db 23
 .db 229
 .db 68
 .db 160
 .db 168
 .db 254
 .db 176
 .db 78
 .db 207
 .db 44
 .db 41
 .db 63
 .db 192
 .db 1
 .db 207
 .db 218
 .db 255
 .db 243
 .db 255
 .db 10
 .db 216
 .db 255
 .db 252
 .db 254
 .db 30
 .db 120
 .db 112
 .db 48
 .db 16
 .db 88
 .db 255
 .db 34
 .db 24
 .db 121
 .db 174
 .db 88
 .db 41
 .db 29
 .db 102
 .db 255
 .db 63
 .db 150
 .db 41
 .db 6
 .db 209
 .db 4
 .db 135
 .db 249
 .db 41
 .db 96
 .db 94
 .db 152
 .db 20
 .db 127
 .db 150
 .db 41
 .db 5
 .db 233
 .db 20
 .db 135
 .db 249
 .db 41
 .db 96
 .db 94
 .db 152
 .db 20
 .db 127
 .db 150
 .db 41
 .db 5
 .db 233
 .db 16
 .db 135
 .db 249
 .db 41
 .db 97
 .db 121
 .db 172
 .db 128
 .db 64

imgTitle_colors:
 .db 10
 .db 96
 .db 84
 .db 172
 .db 255
 .db 13
 .db 209
 .db 255
 .db 239
 .db 100
 .db 173
 .db 227
 .db 7
 .db 12
 .db 237
 .db 12
 .db 197
 .db 255
 .db 13
 .db 141
 .db 173
 .db 255
 .db 112
 .db 206
 .db 246
 .db 55
 .db 213
 .db 48
 .db 0
 .db 58
 .db 254
 .db 252
 .db 220
 .db 255
 .db 192
 .db 236
 .db 109
 .db 0
 .db 10
 .db 14
 .db 0
 .db 255
 .db 48
 .db 57
 .db 76
 .db 0
 .db 64
 .db 19
 .db 240
 .db 243
 .db 108
 .db 131
 .db 13
 .db 3
 .db 29
 .db 0
 .db 14
 .db 98
 .db 166
 .db 255
 .db 12
 .db 255
 .db 29
 .db 183
 .db 12
 .db 60
 .db 252
 .db 253
 .db 202
 .db 53
 .db 254
 .db 55
 .db 253
 .db 22
 .db 252
 .db 255
 .db 12
 .db 38
 .db 0
 .db 12
 .db 223
 .db 135
 .db 176
 .db 12
 .db 200
 .db 0
 .db 220
 .db 248
 .db 108
 .db 214
 .db 11
 .db 181
 .db 255
 .db 14
 .db 177
 .db 248
 .db 185
 .db 252
 .db 230
 .db 253
 .db 166
 .db 254
 .db 121
 .db 11
 .db 158
 .db 18
 .db 96
 .db 86
 .db 145
 .db 0
 .db 2
 .db 133
 .db 38
 .db 0
 .db 127
 .db 216
 .db 252
 .db 38
 .db 126
 .db 13
 .db 15
 .db 205
 .db 22
 .db 255
 .db 239
 .db 86
 .db 30
 .db 215
 .db 237
 .db 96
 .db 148
 .db 0
 .db 127
 .db 216
 .db 5
 .db 96
 .db 0
 .db 1
 .db 152
 .db 78
 .db 176
 .db 14
 .db 235
 .db 214
 .db 7
 .db 15
 .db 54
 .db 255
 .db 183
 .db 112
 .db 56
 .db 246
 .db 213
 .db 193
 .db 44
 .db 0
 .db 208
 .db 27
 .db 195
 .db 67
 .db 0
 .db 140
 .db 253
 .db 197
 .db 64
 .db 14
 .db 135
 .db 95
 .db 251
 .db 176
 .db 15
 .db 144
 .db 255
 .db 194
 .db 240
 .db 0
 .db 44
 .db 84
 .db 0
 .db 255
 .db 48
 .db 12
 .db 73
 .db 49
 .db 0
 .db 143
 .db 128
 .db 252
 .db 195
 .db 131
 .db 0
 .db 124
 .db 55
 .db 215
 .db 48
 .db 238
 .db 37
 .db 190
 .db 0
 .db 199
 .db 126
 .db 253
 .db 88
 .db 255
 .db 70
 .db 0
 .db 98
 .db 7
 .db 19
 .db 131
 .db 243
 .db 100
 .db 24
 .db 13
 .db 78
 .db 0
 .db 100
 .db 153
 .db 51
 .db 230
 .db 0
 .db 230
 .db 7
 .db 9
 .db 171
 .db 0
 .db 10
 .db 29
 .db 248
 .db 252
 .db 12
 .db 33
 .db 195
 .db 215
 .db 99
 .db 190
 .db 15
 .db 118
 .db 0
 .db 199
 .db 76
 .db 32
 .db 21
 .db 12
 .db 0
 .db 127
 .db 207
 .db 249
 .db 49
 .db 255
 .db 83
 .db 0
 .db 7
 .db 13
 .db 48
 .db 0
 .db 252
 .db 0
 .db 142
 .db 253
 .db 54
 .db 252
 .db 0
 .db 0
 .db 194
 .db 143
 .db 150
 .db 252
 .db 255
 .db 61
 .db 134
 .db 215
 .db 5
 .db 23
 .db 219
 .db 0
 .db 134
 .db 0
 .db 100
 .db 24
 .db 1
 .db 85
 .db 240
 .db 252
 .db 24
 .db 60
 .db 225
 .db 0
 .db 135
 .db 166
 .db 0
 .db 21
 .db 234
 .db 68
 .db 14
 .db 198
 .db 204
 .db 255
 .db 28
 .db 12
 .db 0
 .db 58
 .db 249
 .db 0
 .db 195
 .db 8
 .db 178
 .db 188
 .db 200
 .db 255
 .db 0
 .db 251
 .db 176
 .db 91
 .db 235
 .db 224
 .db 252
 .db 48
 .db 41
 .db 254
 .db 0
 .db 243
 .db 3
 .db 59
 .db 236
 .db 255
 .db 204
 .db 176
 .db 99
 .db 219
 .db 224
 .db 252
 .db 49
 .db 220
 .db 209
 .db 222
 .db 9
 .db 254
 .db 230
 .db 250
 .db 15
 .db 222
 .db 0
 .db 101
 .db 0
 .db 4
 .db 44
 .db 240
 .db 42
 .db 189
 .db 67
 .db 14
 .db 143
 .db 152
 .db 255
 .db 224
 .db 0
 .db 70
 .db 44
 .db 0
 .db 103
 .db 44
 .db 46
 .db 10
 .db 88
 .db 0
 .db 88
 .db 235
 .db 42
 .db 241
 .db 0
 .db 191
 .db 216
 .db 2
 .db 127
 .db 244
 .db 252
 .db 255
 .db 99
 .db 38
 .db 0
 .db 31
 .db 253
 .db 0
 .db 230
 .db 38
 .db 9
 .db 124
 .db 0
 .db 150
 .db 13
 .db 254
 .db 36
 .db 255
 .db 97
 .db 239
 .db 192
 .db 252
 .db 96
 .db 168
 .db 0
 .db 121
 .db 249
 .db 135
 .db 102
 .db 0
 .db 106
 .db 103
 .db 13
 .db 197
 .db 142
 .db 255
 .db 48
 .db 227
 .db 247
 .db 229
 .db 253
 .db 255
 .db 130
 .db 137
 .db 0
 .db 137
 .db 24
 .db 1
 .db 117
 .db 6
 .db 0
 .db 44
 .db 2
 .db 1
 .db 142
 .db 117
 .db 248
 .db 130
 .db 209
 .db 0
 .db 185
 .db 237
 .db 158
 .db 0
 .db 96
 .db 129
 .db 134
 .db 0
 .db 53
 .db 54
 .db 68
 .db 89
 .db 13
 .db 130
 .db 103
 .db 173
 .db 0
 .db 14
 .db 16
 .db 254
 .db 9
 .db 24
 .db 153
 .db 0
 .db 134
 .db 247
 .db 13
 .db 99
 .db 230
 .db 0
 .db 16
 .db 200
 .db 68
 .db 6
 .db 108
 .db 152
 .db 97
 .db 41
 .db 240
 .db 0
 .db 188
 .db 8
 .db 254
 .db 140
 .db 248
 .db 63
 .db 243
 .db 0
 .db 14
 .db 190
 .db 0
 .db 199
 .db 162
 .db 61
 .db 3
 .db 5
 .db 76
 .db 183
 .db 255
 .db 4
 .db 0
 .db 193
 .db 4
 .db 0
 .db 3
 .db 5
 .db 19
 .db 0
 .db 15
 .db 180
 .db 7
 .db 220
 .db 5
 .db 199
 .db 204
 .db 0
 .db 30
 .db 48
 .db 0
 .db 194
 .db 69
 .db 6
 .db 10
 .db 134
 .db 70
 .db 3
 .db 13
 .db 214
 .db 0
 .db 13
 .db 130
 .db 169
 .db 0
 .db 134
 .db 38
 .db 4
 .db 13
 .db 244
 .db 0
 .db 44
 .db 255
 .db 52
 .db 203
 .db 0
 .db 24
 .db 243
 .db 6
 .db 2
 .db 194
 .db 69
 .db 0
 .db 253
 .db 133
 .db 132
 .db 0
 .db 173
 .db 97
 .db 143
 .db 88
 .db 6
 .db 83
 .db 6
 .db 0
 .db 13
 .db 224
 .db 0
 .db 88
 .db 101
 .db 198
 .db 0
 .db 52
 .db 0
 .db 1
 .db 132
 .db 166
 .db 4
 .db 81
 .db 7
 .db 131
 .db 200
 .db 0
 .db 6
 .db 9
 .db 30
 .db 0
 .db 103
 .db 253
 .db 255
 .db 132
 .db 30
 .db 15
 .db 98
 .db 166
 .db 223
 .db 12
 .db 135
 .db 0
 .db 152
 .db 211
 .db 39
 .db 117
 .db 0
 .db 185
 .db 255
 .db 134
 .db 166
 .db 38
 .db 198
 .db 215
 .db 12
 .db 255
 .db 0
 .db 44
 .db 255
 .db 44
 .db 48
 .db 0
 .db 139
 .db 172
 .db 0
 .db 19
 .db 120
 .db 25
 .db 212
 .db 191
 .db 192
 .db 131
 .db 245
 .db 0
 .db 7
 .db 24
 .db 250
 .db 217
 .db 0
 .db 130
 .db 41
 .db 6
 .db 131
 .db 79
 .db 209
 .db 0
 .db 248
 .db 133
 .db 63
 .db 0
 .db 99
 .db 102
 .db 0
 .db 40
 .db 5
 .db 96
 .db 102
 .db 24
 .db 0
 .db 177
 .db 44
 .db 137
 .db 152
 .db 5
 .db 20
 .db 66
 .db 0
 .db 223
 .db 193
 .db 15
 .db 140
 .db 0
 .db 107
 .db 44
 .db 41
 .db 9
 .db 163
 .db 0
 .db 99
 .db 248
 .db 4
 .db 67
 .db 126
 .db 21
 .db 203
 .db 41
 .db 3
 .db 136
 .db 255
 .db 199
 .db 243
 .db 41
 .db 12
 .db 108
 .db 255
 .db 96
 .db 118
 .db 253
 .db 241
 .db 121
 .db 161
 .db 191
 .db 158
 .db 247
 .db 0
 .db 101
 .db 249
 .db 137
 .db 145
 .db 246
 .db 240
 .db 6
 .db 191
 .db 219
 .db 227
 .db 153
 .db 14
 .db 102
 .db 2
 .db 127
 .db 216
 .db 237
 .db 28
 .db 102
 .db 0
 .db 62
 .db 255
 .db 96
 .db 122
 .db 145
 .db 4
 .db 213
 .db 129
 .db 195
 .db 198
 .db 227
 .db 121
 .db 10
 .db 185
 .db 17
 .db 135
 .db 6
 .db 0
 .db 1

imgScreen:
 .db 255
 .db 98
 .db 171
 .db 255
 .db 254
 .db 2
 .db 217
 .db 255
 .db 255
 .db 96
 .db 132
 .db 255
 .db 226
 .db 128
 .db 63
 .db 64
 .db 176
 .db 45
 .db 80
 .db 255
 .db 127
 .db 24
 .db 96
 .db 18
 .db 217
 .db 127
 .db 64
 .db 7
 .db 255
 .db 165
 .db 192
 .db 0
 .db 254
 .db 129
 .db 108
 .db 255
 .db 99
 .db 102
 .db 22
 .db 41
 .db 226
 .db 214
 .db 204
 .db 203
 .db 48
 .db 192
 .db 71
 .db 77
 .db 0
 .db 1
 .db 255
 .db 3
 .db 162
 .db 255
 .db 7
 .db 61
 .db 6
 .db 205
 .db 255
 .db 4
 .db 1
 .db 135
 .db 100
 .db 176
 .db 185
 .db 24
 .db 75
 .db 1
 .db 14
 .db 69
 .db 0
 .db 227
 .db 147
 .db 235
 .db 215
 .db 255
 .db 5
 .db 52
 .db 0
 .db 1
 .db 227
 .db 91
 .db 15
 .db 31
 .db 199
 .db 63
 .db 251
 .db 95
 .db 79
 .db 227
 .db 249
 .db 252
 .db 64
 .db 161
 .db 63
 .db 243
 .db 225
 .db 132
 .db 42
 .db 85
 .db 255
 .db 170
 .db 65
 .db 156
 .db 38
 .db 175
 .db 63
 .db 127
 .db 159
 .db 241
 .db 224
 .db 252
 .db 223
 .db 173
 .db 175
 .db 171
 .db 4
 .db 252
 .db 227
 .db 248
 .db 10
 .db 70
 .db 252
 .db 195
 .db 227
 .db 155
 .db 173
 .db 63
 .db 7
 .db 8
 .db 91
 .db 0
 .db 254
 .db 252
 .db 57
 .db 255
 .db 254
 .db 106
 .db 41
 .db 222
 .db 15
 .db 8
 .db 255
 .db 44
 .db 247
 .db 16
 .db 152
 .db 0
 .db 2
 .db 7
 .db 194
 .db 227
 .db 117
 .db 250
 .db 227
 .db 218
 .db 170
 .db 139
 .db 122
 .db 231
 .db 58
 .db 0
 .db 63
 .db 7
 .db 98
 .db 221
 .db 143
 .db 210
 .db 226
 .db 231
 .db 247
 .db 239
 .db 223
 .db 255
 .db 224
 .db 191
 .db 242
 .db 192
 .db 127
 .db 3
 .db 248
 .db 181
 .db 44
 .db 135
 .db 20
 .db 175
 .db 241
 .db 31
 .db 80
 .db 148
 .db 82
 .db 160
 .db 48
 .db 71
 .db 249
 .db 155
 .db 240
 .db 203
 .db 224
 .db 14
 .db 121
 .db 103
 .db 31
 .db 113
 .db 195
 .db 132
 .db 127
 .db 0
 .db 119
 .db 241
 .db 32
 .db 224
 .db 239
 .db 226
 .db 225
 .db 151
 .db 255
 .db 11
 .db 242
 .db 231
 .db 84
 .db 41
 .db 161
 .db 227
 .db 255
 .db 159
 .db 129
 .db 216
 .db 190
 .db 126
 .db 0
 .db 110
 .db 255
 .db 199
 .db 112
 .db 248
 .db 199
 .db 216
 .db 168
 .db 23
 .db 240
 .db 224
 .db 49
 .db 39
 .db 192
 .db 255
 .db 48
 .db 220
 .db 94
 .db 95
 .db 63
 .db 127
 .db 160
 .db 191
 .db 0
 .db 95
 .db 235
 .db 16
 .db 228
 .db 206
 .db 31
 .db 0
 .db 88
 .db 14
 .db 95
 .db 240
 .db 248
 .db 249
 .db 242
 .db 197
 .db 240
 .db 202
 .db 213
 .db 200
 .db 225
 .db 159
 .db 254
 .db 124
 .db 1
 .db 63
 .db 253
 .db 9
 .db 247
 .db 71
 .db 252
 .db 128
 .db 254
 .db 97
 .db 73
 .db 252
 .db 127
 .db 41
 .db 193
 .db 63
 .db 97
 .db 41
 .db 0
 .db 238
 .db 255
 .db 239
 .db 207
 .db 175
 .db 151
 .db 1
 .db 131
 .db 27
 .db 245
 .db 183
 .db 0
 .db 125
 .db 17
 .db 152
 .db 255
 .db 32
 .db 177
 .db 0
 .db 6
 .db 15
 .db 154
 .db 121
 .db 14
 .db 155
 .db 216
 .db 108
 .db 128
 .db 241
 .db 192
 .db 255
 .db 225
 .db 211
 .db 152
 .db 61
 .db 125
 .db 253
 .db 31
 .db 108
 .db 79
 .db 241
 .db 198
 .db 128
 .db 0
 .db 64
 .db 94
 .db 254
 .db 3
 .db 192
 .db 96
 .db 143
 .db 224
 .db 240
 .db 215
 .db 200
 .db 56
 .db 216
 .db 210
 .db 106
 .db 254
 .db 235
 .db 246
 .db 207
 .db 63
 .db 214
 .db 39
 .db 224
 .db 17
 .db 116
 .db 0
 .db 236
 .db 125
 .db 31
 .db 159
 .db 162
 .db 255
 .db 235
 .db 109
 .db 33
 .db 41
 .db 224
 .db 142
 .db 16
 .db 43
 .db 49
 .db 0
 .db 1
 .db 100
 .db 24
 .db 255
 .db 70
 .db 0
 .db 214
 .db 64
 .db 224
 .db 177
 .db 214
 .db 76
 .db 254
 .db 144
 .db 250
 .db 199
 .db 45
 .db 248
 .db 20
 .db 54
 .db 115
 .db 255
 .db 128
 .db 176
 .db 208
 .db 16
 .db 240
 .db 255
 .db 179
 .db 149
 .db 204
 .db 255
 .db 30
 .db 182
 .db 0
 .db 88
 .db 227
 .db 161
 .db 215
 .db 151
 .db 155
 .db 191
 .db 255
 .db 3
 .db 99
 .db 91
 .db 0
 .db 127
 .db 191
 .db 41
 .db 255
 .db 128
 .db 99
 .db 191
 .db 215
 .db 177
 .db 15
 .db 3
 .db 255
 .db 2
 .db 124
 .db 236
 .db 140
 .db 0
 .db 16
 .db 133
 .db 255
 .db 186
 .db 138
 .db 24
 .db 182
 .db 19
 .db 198
 .db 236
 .db 25
 .db 225
 .db 0
 .db 233
 .db 255
 .db 231
 .db 255
 .db 163
 .db 224
 .db 252
 .db 3
 .db 68
 .db 0
 .db 199
 .db 240
 .db 0
 .db 246
 .db 255
 .db 152
 .db 147
 .db 60
 .db 236
 .db 132
 .db 253
 .db 202
 .db 88
 .db 0
 .db 239
 .db 129
 .db 255
 .db 129
 .db 60
 .db 236
 .db 97
 .db 14
 .db 48
 .db 0
 .db 7
 .db 8
 .db 160
 .db 1
 .db 8
 .db 19
 .db 59
 .db 243
 .db 215
 .db 207
 .db 3
 .db 144
 .db 33
 .db 253
 .db 48
 .db 47
 .db 254
 .db 0
 .db 199
 .db 241
 .db 0
 .db 62
 .db 142
 .db 161
 .db 227
 .db 253
 .db 57
 .db 33
 .db 230
 .db 143
 .db 201
 .db 231
 .db 44
 .db 253
 .db 12
 .db 223
 .db 113
 .db 0
 .db 199
 .db 187
 .db 251
 .db 196
 .db 179
 .db 191
 .db 49
 .db 0
 .db 69
 .db 56
 .db 255
 .db 61
 .db 5
 .db 246
 .db 121
 .db 114
 .db 33
 .db 249
 .db 87
 .db 255
 .db 197
 .db 253
 .db 96
 .db 95
 .db 249
 .db 0
 .db 143
 .db 226
 .db 0
 .db 16
 .db 62
 .db 32
 .db 192
 .db 49
 .db 251
 .db 103
 .db 49
 .db 0
 .db 254
 .db 192
 .db 228
 .db 252
 .db 253
 .db 38
 .db 6
 .db 135
 .db 24
 .db 0
 .db 254
 .db 54
 .db 0
 .db 254
 .db 253
 .db 106
 .db 255
 .db 254
 .db 192
 .db 214
 .db 51
 .db 0
 .db 240
 .db 0
 .db 196
 .db 236
 .db 20
 .db 192
 .db 190
 .db 243
 .db 0
 .db 11
 .db 76
 .db 255
 .db 243
 .db 0
 .db 3
 .db 183
 .db 15
 .db 0
 .db 243
 .db 235
 .db 51
 .db 204
 .db 232
 .db 14
 .db 76
 .db 49
 .db 0
 .db 142
 .db 176
 .db 0
 .db 54
 .db 241
 .db 0
 .db 62
 .db 188
 .db 34
 .db 255
 .db 88
 .db 247
 .db 183
 .db 152
 .db 0
 .db 27
 .db 184
 .db 0
 .db 220
 .db 113
 .db 138
 .db 255
 .db 176
 .db 119
 .db 55
 .db 77
 .db 0
 .db 241
 .db 0
 .db 231
 .db 24
 .db 64
 .db 153
 .db 120
 .db 0
 .db 220
 .db 199
 .db 40
 .db 255
 .db 163
 .db 247
 .db 240
 .db 23
 .db 235
 .db 0
 .db 3
 .db 111
 .db 30
 .db 0
 .db 34
 .db 162
 .db 36
 .db 56
 .db 48
 .db 129
 .db 48
 .db 59
 .db 242
 .db 0
 .db 207
 .db 243
 .db 21
 .db 3
 .db 191
 .db 76
 .db 0
 .db 15
 .db 220
 .db 51
 .db 0
 .db 204
 .db 255
 .db 14
 .db 220
 .db 179
 .db 0
 .db 240
 .db 0
 .db 203
 .db 94
 .db 230
 .db 156
 .db 255
 .db 188
 .db 128
 .db 235
 .db 192
 .db 233
 .db 195
 .db 0
 .db 118
 .db 255
 .db 192
 .db 206
 .db 58
 .db 52
 .db 253
 .db 235
 .db 236
 .db 3
 .db 111
 .db 24
 .db 0
 .db 243
 .db 138
 .db 254
 .db 139
 .db 242
 .db 130
 .db 131
 .db 89
 .db 247
 .db 168
 .db 0
 .db 176
 .db 238
 .db 35
 .db 253
 .db 246
 .db 3
 .db 119
 .db 30
 .db 0
 .db 232
 .db 8
 .db 9
 .db 206
 .db 48
 .db 129
 .db 51
 .db 155
 .db 33
 .db 128
 .db 243
 .db 204
 .db 255
 .db 12
 .db 200
 .db 206
 .db 0
 .db 187
 .db 255
 .db 131
 .db 251
 .db 89
 .db 255
 .db 120
 .db 0
 .db 213
 .db 156
 .db 162
 .db 132
 .db 2
 .db 9
 .db 156
 .db 33
 .db 191
 .db 159
 .db 193
 .db 0
 .db 188
 .db 244
 .db 192
 .db 219
 .db 197
 .db 0
 .db 241
 .db 91
 .db 2
 .db 242
 .db 130
 .db 179
 .db 135
 .db 254
 .db 33
 .db 201
 .db 227
 .db 235
 .db 3
 .db 111
 .db 27
 .db 0
 .db 192
 .db 32
 .db 150
 .db 255
 .db 240
 .db 48
 .db 215
 .db 96
 .db 116
 .db 97
 .db 0
 .db 142
 .db 172
 .db 0
 .db 224
 .db 64
 .db 255
 .db 192
 .db 158
 .db 48
 .db 236
 .db 179
 .db 12
 .db 0
 .db 108
 .db 0
 .db 192
 .db 179
 .db 48
 .db 255
 .db 211
 .db 29
 .db 0
 .db 128
 .db 127
 .db 64
 .db 144
 .db 255
 .db 216
 .db 127
 .db 128
 .db 25
 .db 102
 .db 0
 .db 63
 .db 134
 .db 0
 .db 113
 .db 18
 .db 129
 .db 51
 .db 252
 .db 0
 .db 3
 .db 7
 .db 137
 .db 255
 .db 1
 .db 99
 .db 134
 .db 220
 .db 63
 .db 140
 .db 0
 .db 137
 .db 138
 .db 122
 .db 251
 .db 209
 .db 253
 .db 247
 .db 96
 .db 88
 .db 60
 .db 0
 .db 127
 .db 159
 .db 227
 .db 252
 .db 236
 .db 100
 .db 63
 .db 7
 .db 104
 .db 220
 .db 199
 .db 241
 .db 0
 .db 200
 .db 143
 .db 40
 .db 239
 .db 90
 .db 255
 .db 96
 .db 89
 .db 19
 .db 0
 .db 103
 .db 31
 .db 224
 .db 70
 .db 251
 .db 19
 .db 251
 .db 0
 .db 131
 .db 191
 .db 172
 .db 135
 .db 8
 .db 1
 .db 205
 .db 192
 .db 0
 .db 241
 .db 190
 .db 75
 .db 255
 .db 2
 .db 209
 .db 0
 .db 254
 .db 216
 .db 193
 .db 63
 .db 233
 .db 0
 .db 143
 .db 227
 .db 0
 .db 113
 .db 138
 .db 114
 .db 255
 .db 137
 .db 192
 .db 178
 .db 117
 .db 0
 .db 246
 .db 207
 .db 63
 .db 219
 .db 39
 .db 224
 .db 25
 .db 48
 .db 222
 .db 159
 .db 1
 .db 0
 .db 51
 .db 22
 .db 0
 .db 1
 .db 65
 .db 255
 .db 129
 .db 163
 .db 166
 .db 0
 .db 63
 .db 136
 .db 0
 .db 128
 .db 236
 .db 221
 .db 99
 .db 232
 .db 1
 .db 254
 .db 48
 .db 45
 .db 150
 .db 255
 .db 255
 .db 8
 .db 141
 .db 255
 .db 127
 .db 128
 .db 129
 .db 108
 .db 255
 .db 97
 .db 97
 .db 24
 .db 128
 .db 64

imgScreen_colors:
 .db 7
 .db 96
 .db 104
 .db 24
 .db 255
 .db 31
 .db 171
 .db 255
 .db 247
 .db 4
 .db 20
 .db 192
 .db 10
 .db 176
 .db 254
 .db 45
 .db 155
 .db 255
 .db 7
 .db 15
 .db 11
 .db 197
 .db 14
 .db 204
 .db 150
 .db 192
 .db 96
 .db 142
 .db 0
 .db 177
 .db 12
 .db 3
 .db 255
 .db 14
 .db 215
 .db 176
 .db 15
 .db 152
 .db 255
 .db 114
 .db 0
 .db 178
 .db 10
 .db 214
 .db 242
 .db 15
 .db 10
 .db 75
 .db 0
 .db 12
 .db 30
 .db 88
 .db 255
 .db 15
 .db 32
 .db 24
 .db 255
 .db 66
 .db 0
 .db 179
 .db 247
 .db 204
 .db 255
 .db 243
 .db 23
 .db 15
 .db 77
 .db 0
 .db 214
 .db 18
 .db 14
 .db 201
 .db 255
 .db 10
 .db 253
 .db 99
 .db 199
 .db 3
 .db 249
 .db 254
 .db 131
 .db 16
 .db 0
 .db 217
 .db 219
 .db 127
 .db 127
 .db 20
 .db 150
 .db 127
 .db 231
 .db 10
 .db 39
 .db 0
 .db 152
 .db 255
 .db 92
 .db 0
 .db 176
 .db 15
 .db 99
 .db 51
 .db 0
 .db 186
 .db 250
 .db 193
 .db 68
 .db 0
 .db 141
 .db 13
 .db 140
 .db 0
 .db 107
 .db 182
 .db 253
 .db 10
 .db 97
 .db 248
 .db 130
 .db 217
 .db 1
 .db 186
 .db 41
 .db 127
 .db 59
 .db 8
 .db 120
 .db 23
 .db 197
 .db 248
 .db 233
 .db 199
 .db 214
 .db 0
 .db 14
 .db 62
 .db 255
 .db 104
 .db 19
 .db 98
 .db 38
 .db 215
 .db 14
 .db 27
 .db 0
 .db 99
 .db 224
 .db 0
 .db 44
 .db 127
 .db 165
 .db 255
 .db 7
 .db 129
 .db 171
 .db 166
 .db 0
 .db 126
 .db 236
 .db 233
 .db 127
 .db 119
 .db 236
 .db 215
 .db 68
 .db 232
 .db 192
 .db 158
 .db 48
 .db 236
 .db 191
 .db 44
 .db 0
 .db 15
 .db 211
 .db 0
 .db 63
 .db 204
 .db 230
 .db 13
 .db 163
 .db 0
 .db 63
 .db 140
 .db 23
 .db 213
 .db 0
 .db 127
 .db 129
 .db 128
 .db 0
 .db 97
 .db 166
 .db 31
 .db 0
 .db 182
 .db 253
 .db 156
 .db 237
 .db 96
 .db 94
 .db 152
 .db 0
 .db 101
 .db 134
 .db 0
 .db 225
 .db 0
 .db 88
 .db 24
 .db 6
 .db 0
 .db 26
 .db 97
 .db 0
 .db 254
 .db 207
 .db 96
 .db 97
 .db 152
 .db 0
 .db 95
 .db 134
 .db 0
 .db 118
 .db 24
 .db 253
 .db 27
 .db 220
 .db 0
 .db 97
 .db 22
 .db 44
 .db 215
 .db 247
 .db 12
 .db 179
 .db 0
 .db 31
 .db 193
 .db 0
 .db 206
 .db 103
 .db 93
 .db 191
 .db 129
 .db 213
 .db 150
 .db 0
 .db 7
 .db 233
 .db 0
 .db 137
 .db 102
 .db 212
 .db 127
 .db 192
 .db 237
 .db 195
 .db 0
 .db 63
 .db 236
 .db 240
 .db 14
 .db 108
 .db 49
 .db 0
 .db 111
 .db 48
 .db 0
 .db 55
 .db 112
 .db 0
 .db 199
 .db 204
 .db 0
 .db 14
 .db 220
 .db 51
 .db 0
 .db 250
 .db 0
 .db 192
 .db 212
 .db 195
 .db 0
 .db 3
 .db 247
 .db 44
 .db 0
 .db 14
 .db 190
 .db 176
 .db 0
 .db 63
 .db 112
 .db 0
 .db 192
 .db 253
 .db 203
 .db 0
 .db 12
 .db 140
 .db 255
 .db 172
 .db 176
 .db 217
 .db 59
 .db 240
 .db 0
 .db 220
 .db 0
 .db 211
 .db 108
 .db 201
 .db 14
 .db 172
 .db 55
 .db 0
 .db 23
 .db 0
 .db 5
 .db 30
 .db 253
 .db 244
 .db 96
 .db 116
 .db 97
 .db 0
 .db 159
 .db 231
 .db 0
 .db 152
 .db 244
 .db 29
 .db 88
 .db 0
 .db 111
 .db 246
 .db 223
 .db 73
 .db 0
 .db 129
 .db 231
 .db 138
 .db 0
 .db 127
 .db 53
 .db 255
 .db 48
 .db 202
 .db 56
 .db 112
 .db 0
 .db 198
 .db 204
 .db 215
 .db 14
 .db 108
 .db 48
 .db 0
 .db 53
 .db 204
 .db 0
 .db 63
 .db 35
 .db 255
 .db 0
 .db 2
 .db 216
 .db 255
 .db 195
 .db 245
 .db 0
 .db 247
 .db 129
 .db 172
 .db 0
 .db 103
 .db 225
 .db 0
 .db 138
 .db 241
 .db 233
 .db 129
 .db 46
 .db 0
 .db 188
 .db 15
 .db 255
 .db 198
 .db 140
 .db 222
 .db 42
 .db 195
 .db 0
 .db 2
 .db 200
 .db 0
 .db 199
 .db 190
 .db 254
 .db 198
 .db 176
 .db 0
 .db 192
 .db 235
 .db 51
 .db 0
 .db 240
 .db 0
 .db 192
 .db 228
 .db 49
 .db 0
 .db 172
 .db 48
 .db 0
 .db 49
 .db 204
 .db 0
 .db 54
 .db 227
 .db 0
 .db 60
 .db 23
 .db 197
 .db 118
 .db 233
 .db 192
 .db 207
 .db 219
 .db 0
 .db 31
 .db 197
 .db 0
 .db 127
 .db 148
 .db 255
 .db 176
 .db 7
 .db 47
 .db 86
 .db 255
 .db 15
 .db 8
 .db 139
 .db 185
 .db 127
 .db 2
 .db 216
 .db 255
 .db 194
 .db 195
 .db 25
 .db 0
 .db 128

imgBalls:
 .db 7
 .db 31
 .db 63
 .db 127
 .db 127
 .db 255
 .db 255
 .db 255
 .db 255
 .db 127
 .db 74
 .db 32
 .db 24
 .db 7
 .db 224
 .db 248
 .db 252
 .db 250
 .db 254
 .db 249
 .db 237
 .db 241
 .db 193
 .db 162
 .db 2
 .db 4
 .db 24
 .db 224
 .db 0
 .db 3
 .db 15
 .db 31
 .db 63
 .db 63
 .db 127
 .db 127
 .db 63
 .db 37
 .db 16
 .db 12
 .db 3
 .db 0
 .db 0
 .db 192
 .db 240
 .db 248
 .db 244
 .db 252
 .db 242
 .db 130
 .db 68
 .db 4
 .db 8
 .db 48
 .db 192
 .db 0
 .db 0
 .db 0
 .db 1
 .db 7
 .db 15
 .db 31
 .db 63
 .db 63
 .db 19
 .db 8
 .db 6
 .db 1
 .db 0
 .db 0
 .db 0
 .db 0
 .db 128
 .db 224
 .db 240
 .db 248
 .db 228
 .db 132
 .db 8
 .db 16
 .db 96
 .db 128
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 3
 .db 7
 .db 7
 .db 7
 .db 3
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 192
 .db 224
 .db 160
 .db 32
 .db 192
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 1
 .db 1
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 128
 .db 128
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 7
 .db 31
 .db 63
 .db 127
 .db 127
 .db 255
 .db 255
 .db 255
 .db 255
 .db 127
 .db 74
 .db 32
 .db 24
 .db 7
 .db 224
 .db 248
 .db 252
 .db 250
 .db 254
 .db 249
 .db 237
 .db 241
 .db 193
 .db 162
 .db 2
 .db 4
 .db 24
 .db 224
 .db 4
 .db 30
 .db 62
 .db 122
 .db 114
 .db 188
 .db 128
 .db 128
 .db 188
 .db 126
 .db 74
 .db 34
 .db 26
 .db 4
 .db 32
 .db 120
 .db 124
 .db 122
 .db 98
 .db 60
 .db 0
 .db 0
 .db 60
 .db 114
 .db 114
 .db 68
 .db 88
 .db 32
 .db 0
 .db 24
 .db 60
 .db 116
 .db 56
 .db 0
 .db 0
 .db 0
 .db 0
 .db 56
 .db 108
 .db 36
 .db 24
 .db 0
 .db 0
 .db 24
 .db 60
 .db 58
 .db 28
 .db 0
 .db 0
 .db 0
 .db 0
 .db 28
 .db 50
 .db 36
 .db 24
 .db 0
 .db 0
 .db 32
 .db 112
 .db 32
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 32
 .db 112
 .db 32
 .db 0
 .db 0
 .db 4
 .db 14
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 4
 .db 14
 .db 4
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 1
 .db 3
 .db 7
 .db 7
 .db 2
 .db 1
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 128
 .db 192
 .db 160
 .db 160
 .db 64
 .db 128
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 7
 .db 31
 .db 63
 .db 127
 .db 255
 .db 255
 .db 255
 .db 255
 .db 127
 .db 32
 .db 24
 .db 7
 .db 0
 .db 0
 .db 224
 .db 248
 .db 252
 .db 254
 .db 249
 .db 237
 .db 241
 .db 193
 .db 162
 .db 4
 .db 24
 .db 224
 .db 0
 .db 0
 .db 0
 .db 0
 .db 7
 .db 63
 .db 127
 .db 127
 .db 255
 .db 255
 .db 127
 .db 74
 .db 56
 .db 7
 .db 0
 .db 0
 .db 0
 .db 0
 .db 224
 .db 252
 .db 250
 .db 254
 .db 237
 .db 241
 .db 162
 .db 2
 .db 28
 .db 224
 .db 0
 .db 0
 .db 0
 .db 0
 .db 10
 .db 32
 .db 14
 .db 30
 .db 14
 .db 6
 .db 6
 .db 0
 .db 6
 .db 0
 .db 0
 .db 0
 .db 80
 .db 4
 .db 112
 .db 120
 .db 112
 .db 96
 .db 96
 .db 0
 .db 96
 .db 0
 .db 0
 .db 0
 .db 0
 .db 6
 .db 0
 .db 6
 .db 6
 .db 14
 .db 30
 .db 14
 .db 32
 .db 10
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 96
 .db 0
 .db 96
 .db 96
 .db 112
 .db 120
 .db 112
 .db 4
 .db 80
 .db 0
 .db 0
 .db 0
 .db 8
 .db 2
 .db 23
 .db 7
 .db 23
 .db 0
 .db 0
 .db 5
 .db 1
 .db 5
 .db 0
 .db 2
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 208
 .db 208
 .db 0
 .db 0
 .db 244
 .db 244
 .db 192
 .db 128
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 11
 .db 11
 .db 0
 .db 0
 .db 47
 .db 47
 .db 3
 .db 1
 .db 0
 .db 0
 .db 0
 .db 16
 .db 64
 .db 232
 .db 224
 .db 232
 .db 0
 .db 0
 .db 160
 .db 128
 .db 160
 .db 0
 .db 64
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0

imgPlayerD:
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 15
 .db 173
 .db 15
 .db 223
 .db 15
 .db 171
 .db 15
 .db 223
 .db 15
 .db 255
 .db 15
 .db 255
 .db 15
 .db 255
 .db 15
 .db 255
 .db 15
 .db 253
 .db 15
 .db 255
 .db 15
 .db 254
 .db 15
 .db 255
 .db 15
 .db 168
 .db 15
 .db 216
 .db 15
 .db 168
 .db 15
 .db 216

imgPlayer:
 .db 14
 .db 16
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 56
 .db 14
 .db 130
 .db 14
 .db 254
 .db 14
 .db 218
 .db 14
 .db 138
 .db 13
 .db 96
 .db 13
 .db 96
 .db 13
 .db 64
 .db 13
 .db 124
 .db 13
 .db 125
 .db 13
 .db 125
 .db 13
 .db 125
 .db 13
 .db 1
 .db 14
 .db 56
 .db 14
 .db 124
 .db 14
 .db 56
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 13
 .db 1
 .db 13
 .db 3
 .db 13
 .db 7
 .db 13
 .db 15
 .db 13
 .db 15
 .db 13
 .db 31
 .db 13
 .db 31
 .db 13
 .db 63
 .db 13
 .db 95
 .db 13
 .db 79
 .db 13
 .db 230
 .db 13
 .db 240
 .db 13
 .db 249
 .db 13
 .db 251
 .db 13
 .db 183
 .db 13
 .db 23
 .db 13
 .db 27
 .db 13
 .db 11
 .db 13
 .db 1
 .db 13
 .db 16
 .db 13
 .db 8
 .db 13
 .db 20
 .db 13
 .db 10
 .db 13
 .db 21
 .db 13
 .db 10
 .db 13
 .db 21
 .db 10
 .db 0
 .db 13
 .db 28
 .db 13
 .db 50
 .db 13
 .db 59
 .db 13
 .db 63
 .db 13
 .db 63
 .db 13
 .db 31
 .db 15
 .db 224
 .db 15
 .db 252
 .db 15
 .db 223
 .db 10
 .db 0
 .db 13
 .db 1
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 13
 .db 3
 .db 13
 .db 4
 .db 13
 .db 7
 .db 13
 .db 9
 .db 13
 .db 8
 .db 13
 .db 7
 .db 13
 .db 31
 .db 13
 .db 98
 .db 13
 .db 221
 .db 13
 .db 210
 .db 13
 .db 210
 .db 13
 .db 226
 .db 13
 .db 247
 .db 13
 .db 239
 .db 13
 .db 223
 .db 13
 .db 223
 .db 13
 .db 223
 .db 13
 .db 224
 .db 13
 .db 191
 .db 13
 .db 64
 .db 13
 .db 63
 .db 13
 .db 158
 .db 13
 .db 192
 .db 13
 .db 223
 .db 13
 .db 159
 .db 13
 .db 128
 .db 13
 .db 63
 .db 13
 .db 127
 .db 13
 .db 255
 .db 13
 .db 255
 .db 13
 .db 127
 .db 13
 .db 31
 .db 13
 .db 152
 .db 13
 .db 89
 .db 13
 .db 154
 .db 13
 .db 57
 .db 13
 .db 120
 .db 13
 .db 251
 .db 13
 .db 252
 .db 13
 .db 252
 .db 13
 .db 248
 .db 10
 .db 0
 .db 10
 .db 0
 .db 15
 .db 224
 .db 13
 .db 128
 .db 13
 .db 192
 .db 13
 .db 128
 .db 13
 .db 192
 .db 13
 .db 64
 .db 13
 .db 192
 .db 13
 .db 128
 .db 10
 .db 0
 .db 13
 .db 128
 .db 13
 .db 128
 .db 10
 .db 0
 .db 10
 .db 0
 .db 13
 .db 192
 .db 13
 .db 48
 .db 13
 .db 220
 .db 13
 .db 94
 .db 13
 .db 95
 .db 13
 .db 63
 .db 13
 .db 127
 .db 13
 .db 191
 .db 13
 .db 223
 .db 13
 .db 223
 .db 13
 .db 223
 .db 13
 .db 63
 .db 13
 .db 238
 .db 13
 .db 28
 .db 13
 .db 241
 .db 13
 .db 7
 .db 13
 .db 255
 .db 13
 .db 255
 .db 13
 .db 255
 .db 13
 .db 255
 .db 13
 .db 15
 .db 13
 .db 241
 .db 13
 .db 254
 .db 13
 .db 252
 .db 13
 .db 249
 .db 13
 .db 194
 .db 13
 .db 85
 .db 13
 .db 74
 .db 13
 .db 84
 .db 13
 .db 73
 .db 13
 .db 99
 .db 13
 .db 127
 .db 13
 .db 255
 .db 13
 .db 255
 .db 13
 .db 127
 .db 10
 .db 0
 .db 15
 .db 1
 .db 15
 .db 63
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 13
 .db 128
 .db 13
 .db 192
 .db 13
 .db 224
 .db 13
 .db 224
 .db 13
 .db 224
 .db 13
 .db 208
 .db 13
 .db 144
 .db 13
 .db 56
 .db 13
 .db 248
 .db 13
 .db 252
 .db 13
 .db 252
 .db 13
 .db 252
 .db 13
 .db 254
 .db 13
 .db 254
 .db 13
 .db 254
 .db 13
 .db 254
 .db 13
 .db 254
 .db 13
 .db 126
 .db 13
 .db 62
 .db 13
 .db 15
 .db 13
 .db 167
 .db 13
 .db 83
 .db 13
 .db 171
 .db 13
 .db 19
 .db 13
 .db 203
 .db 13
 .db 35
 .db 13
 .db 169
 .db 13
 .db 228
 .db 13
 .db 224
 .db 13
 .db 192
 .db 15
 .db 56
 .db 15
 .db 248
 .db 15
 .db 216

imgPlayerWin:
 .db 12
 .db 2
 .db 12
 .db 7
 .db 12
 .db 2
 .db 12
 .db 2
 .db 14
 .db 117
 .db 14
 .db 250
 .db 14
 .db 250
 .db 14
 .db 218
 .db 14
 .db 170
 .db 14
 .db 170
 .db 14
 .db 218
 .db 14
 .db 122
 .db 14
 .db 58
 .db 10
 .db 0
 .db 14
 .db 63
 .db 14
 .db 31
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 14
 .db 112
 .db 14
 .db 248
 .db 14
 .db 248
 .db 14
 .db 216
 .db 14
 .db 168
 .db 14
 .db 168
 .db 14
 .db 216
 .db 14
 .db 240
 .db 14
 .db 224
 .db 10
 .db 0
 .db 14
 .db 224
 .db 14
 .db 192

imgKingLose:
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 1
 .db 12
 .db 1
 .db 12
 .db 1
 .db 12
 .db 1
 .db 12
 .db 3
 .db 12
 .db 3
 .db 12
 .db 3
 .db 12
 .db 3
 .db 12
 .db 3
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 7
 .db 12
 .db 6
 .db 12
 .db 6
 .db 12
 .db 4
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 1
 .db 12
 .db 7
 .db 12
 .db 15
 .db 12
 .db 31
 .db 12
 .db 63
 .db 12
 .db 63
 .db 12
 .db 127
 .db 12
 .db 127
 .db 12
 .db 127
 .db 12
 .db 191
 .db 12
 .db 207
 .db 12
 .db 243
 .db 12
 .db 253
 .db 12
 .db 254
 .db 12
 .db 255
 .db 12
 .db 195
 .db 12
 .db 189
 .db 12
 .db 189
 .db 12
 .db 190
 .db 12
 .db 190
 .db 12
 .db 191
 .db 12
 .db 223
 .db 12
 .db 239
 .db 12
 .db 240
 .db 12
 .db 227
 .db 12
 .db 195
 .db 12
 .db 129
 .db 10
 .db 0
 .db 15
 .db 96
 .db 15
 .db 252
 .db 15
 .db 223
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 1
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 3
 .db 12
 .db 4
 .db 12
 .db 7
 .db 12
 .db 9
 .db 12
 .db 8
 .db 12
 .db 7
 .db 12
 .db 31
 .db 12
 .db 98
 .db 12
 .db 221
 .db 12
 .db 210
 .db 12
 .db 210
 .db 12
 .db 226
 .db 12
 .db 247
 .db 12
 .db 239
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 224
 .db 12
 .db 255
 .db 12
 .db 240
 .db 12
 .db 239
 .db 12
 .db 127
 .db 12
 .db 128
 .db 12
 .db 255
 .db 12
 .db 255
 .db 12
 .db 255
 .db 12
 .db 252
 .db 12
 .db 131
 .db 12
 .db 127
 .db 12
 .db 127
 .db 12
 .db 191
 .db 12
 .db 63
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 15
 .db 10
 .db 0
 .db 10
 .db 0
 .db 15
 .db 224
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 128
 .db 12
 .db 192
 .db 12
 .db 128
 .db 12
 .db 128
 .db 12
 .db 192
 .db 12
 .db 64
 .db 12
 .db 192
 .db 12
 .db 128
 .db 10
 .db 0
 .db 12
 .db 128
 .db 12
 .db 128
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 224
 .db 12
 .db 56
 .db 12
 .db 222
 .db 12
 .db 95
 .db 12
 .db 95
 .db 12
 .db 63
 .db 12
 .db 127
 .db 12
 .db 191
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 223
 .db 12
 .db 63
 .db 12
 .db 255
 .db 12
 .db 127
 .db 12
 .db 190
 .db 12
 .db 253
 .db 12
 .db 3
 .db 12
 .db 250
 .db 12
 .db 249
 .db 12
 .db 225
 .db 12
 .db 25
 .db 12
 .db 251
 .db 12
 .db 251
 .db 12
 .db 251
 .db 12
 .db 247
 .db 12
 .db 224
 .db 12
 .db 238
 .db 12
 .db 223
 .db 12
 .db 222
 .db 12
 .db 128
 .db 10
 .db 0
 .db 15
 .db 1
 .db 15
 .db 63
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 128
 .db 12
 .db 192
 .db 12
 .db 224
 .db 12
 .db 240
 .db 12
 .db 248
 .db 12
 .db 254
 .db 12
 .db 255
 .db 12
 .db 255
 .db 12
 .db 255
 .db 12
 .db 252
 .db 12
 .db 251
 .db 12
 .db 119
 .db 12
 .db 175
 .db 12
 .db 15
 .db 12
 .db 236
 .db 12
 .db 224
 .db 12
 .db 232
 .db 12
 .db 224
 .db 12
 .db 200
 .db 12
 .db 208
 .db 12
 .db 168
 .db 12
 .db 16
 .db 12
 .db 8
 .db 15
 .db 192
 .db 15
 .db 48
 .db 15
 .db 8
 .db 15
 .db 56
 .db 15
 .db 248
 .db 15
 .db 216
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 12
 .db 192
 .db 12
 .db 240
 .db 12
 .db 248
 .db 12
 .db 248
 .db 12
 .db 224
 .db 12
 .db 128
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0
 .db 10
 .db 0

imgCursor:
 .db 14
 .db 255
 .db 126
 .db 192
 .db 14
 .db 255
 .db 231
 .db 252
 .db 126
 .db 192
 .db 14
 .db 255
 .db 231
 .db 252
 .db 14
 .db 255

op_div16_mod:
 .ds 2
rand_seed:
 .db 250

op_div_mod:
 .ds 1
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
strlen_1:
 .ds 2
string9:
 .db 32,32,32,32,32,32,32,32,32,32,32,32,32,0
string8:
 .db 66,50,77,0
string1:
 .db 69,76,84,65,82,79,0
string2:
 .db 69,82,82,52,48,52,0
string4:
 .db 77,73,67,75,0
string5:
 .db 83,67,76,32,77,67,0
string6:
 .db 83,86,79,70,83,75,0
string3:
 .db 83,89,83,67,65,84,0
string7:
 .db 84,73,84,85,83,0
string0:
 .db 86,73,78,88,82,85,0
string10:
 .db 130,155,0
  .end
