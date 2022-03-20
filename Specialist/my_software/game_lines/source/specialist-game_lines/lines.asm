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
  cpi 244
  jz l174
  cpi 245
  jz l175
  cpi 246
  jz l176
  cpi 247
  jz l177
  cpi 248
  jz l179
  cpi 23
  jz l180
  cpi 26
  jz l183
  cpi 25
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
  ; 14 asm {
    xchg
    lxi h, 0F802h
sound_l3:
    mvi m, 0
    lda sound_1
sound_l0:
    dcr a 
    jnz sound_l0
    mvi m, 20h
    lda sound_1
sound_l1:
    dcr a 
    jnz sound_l1
    dcx d
    mov a, d
    ora e
    jnz sound_l3
  
  ret
  ; --- bitBlt -----------------------------------------------------------------
bitBlt:
  shld bitBlt_3
  ; 36 asm {
    ; lhld bitBlt_3
    push b
    mov b, h
    mov c, l
    lhld bitBlt_1
    xchg    
    lhld bitBlt_2
bitBlt_l1:
    push d
    push b                    
bitBlt_l2:
    mov a, m
    inx h
    sta 0F802h
    mov a, m
    inx h
    stax d
    inx d
    dcr c
    jnz bitBlt_l2
    pop b
    pop d
    inr d
    dcr b
    jnz bitBlt_l1
    pop b
  
  ret
  ; --- bitBlt_bw -----------------------------------------------------------------
bitBlt_bw:
  shld bitBlt_bw_3
  ; 67 asm {
    ; lhld bitBlt_bw_3
    push b
    mov b, h
    mov c, l
    lhld bitBlt_bw_1
    xchg    
    lhld bitBlt_bw_2
bitBlt_bw_l1:
    push d
    push b                    
bitBlt_bw_l2:
    mov a, m
    inx h
    stax d
    inx d
    dcr c
    jnz bitBlt_bw_l2
    pop b
    pop d
    inr d
    dcr b
    jnz bitBlt_bw_l1
    pop b
  
  ret
  ; --- colorizer_rand -----------------------------------------------------------------
colorizer_rand:
    push b
    mvi  b, 0
colorizerr_1:
    call rand
    
    mvi  d, 48h
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
  
  ret
  ; --- cellAddr -----------------------------------------------------------------
cellAddr:
  sta cellAddr_2
  ; 145 return PIXELCOORDS(PLAYFIELD_X+x*3, PLAYFIELD_Y+y*20);
  mvi d, 20
  call op_mul
  ; Сложение
  lxi d, 28
  dad d
  ; Сложение
  lxi d, 36865
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
  sta drawBall1_3
  ; 1 *(uchar*)(0xF802)=(C); }
  dcr a
  ; Сложение
  mvi h, 0
  mov l, a
  lxi d, colors
  dad d
  mov a, m
  sta 63490
  ; 154 bitblt_bw(d, o, 0x20E);
  lhld drawBall1_1
  shld bitBlt_bw_1
  lhld drawBall1_2
  shld bitBlt_bw_2
  lxi h, 526
  jmp bitBlt_bw
drawBall:
  push b
  sta drawBall_4
  ; 158 cellAddr(x, y);<d>
  lda drawBall_1
  sta cellAddr_1
  lda drawBall_2
  call cellAddr
  mov b, h
  mov c, l
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 192
  ; 160 d[-1] = 0x55;Сложение с константой -1
  mov h, b
  mov l, c
  dcx h
  mvi m, 85
  ; 161 d[0x100-1] = 0x55;  Сложение с BC
  lxi h, 255
  dad b
  mvi m, 85
  ; 162 drawBall1(d, o, c);
  mov h, b
  mov l, c
  shld drawBall1_1
  lhld drawBall_3
  shld drawBall1_2
  lda drawBall_4
  call drawBall1
  pop b
  ret
  ; --- drawCursor -----------------------------------------------------------------
drawCursor:
  lxi h, 63490
  mvi m, 16
  ; 171 memset(cellAddr(cursorX, cursorY), 255, 2);
  lda cursorX
  sta cellAddr_1
  lda cursorY
  call cellAddr
  shld memset_1
  mvi a, 255
  sta memset_2
  lxi h, 2
  call memset
  ; 172 memset(cellAddr(cursorX, cursorY)+0x100, 255, 2);
  lda cursorX
  sta cellAddr_1
  lda cursorY
  call cellAddr
  ; Сложение
  lxi d, 256
  dad d
  shld memset_1
  mvi a, 255
  sta memset_2
  lxi h, 2
  call memset
  ; 173 memset(cellAddr(cursorX, cursorY)+12, 255, 2);
  lda cursorX
  sta cellAddr_1
  lda cursorY
  call cellAddr
  ; Сложение
  lxi d, 12
  dad d
  shld memset_1
  mvi a, 255
  sta memset_2
  lxi h, 2
  call memset
  ; 174 memset(cellAddr(cursorX, cursorY)+0x100+12, 255, 2);
  lda cursorX
  sta cellAddr_1
  lda cursorY
  call cellAddr
  ; Сложение
  lxi d, 256
  dad d
  ; Сложение
  lxi d, 12
  dad d
  shld memset_1
  mvi a, 255
  sta memset_2
  lxi h, 2
  jmp memset
drawSprite:
  sta drawSprite_3
  ; 181 if(c==0) drawBall(x, y, imgBalls+28*16, 1);
  ora a
  jnz l198
  ; 181 drawBall(x, y, imgBalls+28*16, 1);
  lda drawSprite_1
  sta drawBall_1
  lda drawSprite_2
  sta drawBall_2
  lxi h, (imgBalls)+(448)
  shld drawBall_3
  mvi a, 1
  call drawBall
  jmp l199
l198:
  ; 182 drawBall(x, y, imgBalls, c);
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
  ; 191 drawBall(x, y, removeAnimation[n], s);
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
  ; 198 drawBall(x, y, imgBalls+(4-n)*28, s);
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
  ; 205 drawBall(x, y, imgBalls+(12+n)*28, 1);
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
  mvi a, 1
  call drawBall
  ; 206 sound(1, 10);
  mvi a, 1
  sta sound_1
  lxi h, 10
  jmp sound
drawSpriteSel:
  sta drawSpriteSel_5
  ; 216 if(t==1) {
  cpi 1
  jnz l200
  ; 217 d = cellAddr(x, y)-1;
  lda drawSpriteSel_1
  sta cellAddr_1
  lda drawSpriteSel_2
  call cellAddr
  ; Сложение с константой -1
  dcx h
  shld drawSpriteSel_d
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 192
  ; 219 d[14] = 0x55;Сложение
  lhld drawSpriteSel_d
  lxi d, 14
  dad d
  mvi m, 85
  ; 220 d[0x100+14] = 0x55;  Сложение
  lhld drawSpriteSel_d
  lxi d, 270
  dad d
  mvi m, 85
  ; 221 drawBall1(d, selAnimation[t], s);  
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
  call drawBall1
  jmp l201
l200:
  ; 223 drawBall(x, y, selAnimation[t], s);  
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
  ; 226 if(c) drawCursor();convertToConfition
  lda drawSpriteSel_4
  ora a
  cnz drawCursor
  lda drawSpriteSel_5
  cpi 3
  jnz l203
  ; 228 sound(1, 10);
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
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 144
  ; 240 print1(PIXELCOORDS(40,7),2,5,scoreText);
  lxi h, 47112
  shld print1_1
  mvi a, 2
  sta print1_2
  mvi a, 5
  sta print1_3
  lhld drawScore_2
  call print1
  ; 242 if(score < hiScores[0].score) {
  lhld drawScore_1
  xchg
  lhld ((hiScores)+(0))+(14)
  call op_cmp16
  jc l204
  jz l204
  ; 243 n = (score / (hiScores[0].score / 13));
  lxi d, 13
  lhld ((hiScores)+(0))+(14)
  call op_div16
  xchg
  lhld drawScore_1
  call op_div16
  mov a, l
  sta drawScore_n
  ; 244 if(n>13) n=13;
  cpi 13
  jc l205
  jz l205
  ; 244 n=13;
  mvi a, 13
  sta drawScore_n
l205:
  jmp l206
l204:
  ; 246 n = 14;
  mvi a, 14
  sta drawScore_n
l206:
  ; 249 if(playerSpriteTop != n) {
  lxi h, drawScore_n
  lda playerSpriteTop
  cmp m
  jz l207
  ; 250 playerSpriteTop = n;
  mov a, m
  sta playerSpriteTop
  ; 251 for(s=PIXELCOORDS(40, 167); n; --n, s-=4)
  lxi b, 47272
l208:
  ; convertToConfition
  lda drawScore_n
  ora a
  jz l209
  ; 252 bitBlt(s, imgPlayerD, 5*256+4);  
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
  ; 253 bitBlt(s-46, imgPlayer, 5*256+50);                                         Сложение с BC
  lxi h, 65490
  dad b
  shld bitBlt_1
  lxi h, imgPlayer
  shld bitBlt_2
  lxi h, 1330
  call bitBlt
  ; 254 if(playerSpriteTop == 14) {
  lda playerSpriteTop
  cpi 14
  jnz l211
  ; 255 bitBlt(s-50+0x200, imgPlayerWin, 3*256+16);Сложение с BC
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
  ; 256 bitBlt(PIXELCOORDS(3, 53), imgKingLose, 6*256+62);                                         
  lxi h, 37686
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
  ; 265 drawBall1(PIXELCOORDS(20, 3), imgBalls, a);
  lxi h, 41988
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_1
  call drawBall1
  ; 266 drawBall1(PIXELCOORDS(23, 3), imgBalls, b);
  lxi h, 42756
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_2
  call drawBall1
  ; 267 drawBall1(PIXELCOORDS(26, 3), imgBalls, c);
  lxi h, 43524
  shld drawBall1_1
  lxi h, imgBalls
  shld drawBall1_2
  lda redrawNewBalls_3
  jmp drawBall1
redrawNewBallsOff:
  mvi a, 8
  sta redrawNewBalls_1
  sta redrawNewBalls_2
  jmp redrawNewBalls
drawOnOff:
  sta drawOnOff_2
  ; 284 onOff[n];<d>
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
  ; 285 if(state) SET_COLOR(COLOR_GREEN) else SET_COLOR(COLOR_BLUE);convertToConfition
  ora a
  jz l212
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 144
  jmp l213
l212:
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 192
l213:
  ; 286 for(i=4; i; --i, d+=0x100)
  mvi a, 4
  sta drawOnOff_i
l214:
  ; convertToConfition
  lda drawOnOff_i
  ora a
  jz l215
  ; 287 memcpy(d, d, 8);
  lhld drawOnOff_d
  shld memcpy_1
  lhld drawOnOff_d
  shld memcpy_2
  lxi h, 8
  call memcpy
l216:
  lxi h, drawOnOff_i
  dcr m
  ; Сложение
  lxi d, 256
  lhld drawOnOff_d
  dad d
  shld drawOnOff_d
  jmp l214
l215:
  ret
  ; --- soundJumpSel -----------------------------------------------------------------
soundJumpSel:
  ret
  ; --- delay -----------------------------------------------------------------
delay:
  sta delay_1
  ; 301 while(--a) {
l217:
  lxi h, delay_1
  dcr m
  ; convertToConfition
  jz l218
  ; 302 i = 64;
  mvi a, 64
  sta delay_i
  ; 303 while(--i);
l219:
  lxi h, delay_i
  dcr m
  ; convertToConfition
  jz l220
  jmp l219
l220:
  jmp l217
l218:
  ret
  ; --- soundBadMove -----------------------------------------------------------------
soundBadMove:
  mvi a, 255
  sta sound_1
  lxi h, 10
  call sound
  ; 312 delay(128);
  mvi a, 128
  call delay
  ; 313 sound(255, 10);
  mvi a, 255
  sta sound_1
  lxi h, 10
  call sound
  ; 314 delay(128);
  mvi a, 128
  jmp delay
intro:
  lxi h, 63490
  mvi m, 208
  ; 326 unmlz((uchar*)0x9000, imgTitle);
  lxi h, 36864
  shld unmlz_1
  lxi h, imgTitle
  call unmlz
  ; 327 unmlz((uchar*)0x4800, imgTitle_colors);
  lxi h, 18432
  shld unmlz_1
  lxi h, imgTitle_colors
  call unmlz
  ; 328 colorizer_rand();    
  call colorizer_rand
  ; 331 p = music;
  lxi h, music
  shld intro_p
  ; 332 while(1) {
l221:
  ; 333 s = *p; ++p;
  lhld intro_p
  mov a, m
  sta intro_s
  ; 333 ++p;
  inx h
  inx h
  shld intro_p
  ; 334 if(s==0) { while(!getch1(1)); break; }
  ora a
  jnz l223
  ; 334 while(!getch1(1)); break; }
l224:
  mvi a, 1
  call getch1
  ; convertToConfition
  ora a
  jnz l225
  jmp l224
l225:
  ; 334 break; }
  jmp l222
l223:
  ; 335 if(getch1(1)) break;
  mvi a, 1
  call getch1
  ; convertToConfition
  ora a
  jnz l222
  lda intro_s
  sta sound_1
  lhld intro_p
  mov e, m
  inx h
  mov d, m
  xchg
  call sound
  ; 336 ++p;
  lhld intro_p
  inx h
  inx h
  shld intro_p
  ; 337 rand();
  call rand
  jmp l221
l222:
  ret
  ; --- prepareRecordScreen -----------------------------------------------------------------
prepareRecordScreen:
  lxi h, 63490
  mvi m, 192
  ; 346 graph0();
  call graph0
  ; 347 fillRect1(FILLRECTARGS(108, PLAYFIELD_Y+18, 274, PLAYFIELD_Y+156)); 
  lxi h, 40238
  shld fillRect1_1
  lxi h, 21
  shld fillRect1_2
  mvi a, 15
  sta fillRect1_3
  mvi a, 224
  sta fillRect1_4
  mvi a, 139
  jmp fillRect1
drawRecordScreen1:
  sta drawRecordScreen1_2
  ; 358 for(h=hiScores+i; i<9; ++i, ++h) {
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
l227:
  lda drawRecordScreen1_1
  cpi 9
  jnc l228
  ; 359 if(pos==i) { SET_COLOR(COLOR_YELLOW); } else SET_COLOR(COLOR_WHITE);
  lxi h, drawRecordScreen1_1
  lda drawRecordScreen1_2
  cmp m
  jnz l230
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 16
  jmp l231
l230:
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 0
l231:
  ; 361 memcpy(buf, "             ", 14);
  lxi h, drawRecordScreen1_buf
  shld memcpy_1
  lxi h, string9
  shld memcpy_2
  lxi h, 14
  call memcpy
  ; 362 memcpy(buf, h->name, strlen(h->name));
  lxi h, drawRecordScreen1_buf
  shld memcpy_1
  lhld drawRecordScreen1_h
  shld memcpy_2
  lhld drawRecordScreen1_h
  call strlen
  call memcpy
  ; 363 i2s(buf+8, h->score);
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
  ; 365 print(25, 7+i, 14, buf);
  mvi a, 25
  sta print_1
  lda drawRecordScreen1_1
  adi 7
  sta print_2
  mvi a, 14
  sta print_3
  lxi h, drawRecordScreen1_buf
  call print
l229:
  lxi h, drawRecordScreen1_1
  inr m
  lhld drawRecordScreen1_h
  lxi d, 16
  dad d
  shld drawRecordScreen1_h
  jmp l227
l228:
  ret
  ; --- drawRecordScreen -----------------------------------------------------------------
drawRecordScreen:
  sta drawRecordScreen_1
  ; 370 drawRecordScreen1(0, pos);
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
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 144
  ; 389 print1(PIXELCOORDS(3,7),1,5,buf);
  lxi h, 37640
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 5
  sta print1_3
  lxi h, updateTopScore_buf
  call print1
  ; 392 print1(PRINTARGS(5,19),7|0x80,hiScores[0].name);
  lxi h, 37823
  shld print1_1
  mvi a, 1
  sta print1_2
  mvi a, 135
  sta print1_3
  lxi h, (hiScores)+(0)
  jmp print1
initGameScreen2:
  lxi h, 63490
  mvi m, 208
  ; 407 unmlz((uchar*)0x9000, imgScreen);
  lxi h, 36864
  shld unmlz_1
  lxi h, imgScreen
  call unmlz
  ; 408 unmlz((uchar*)0x4800, imgScreen_colors);
  lxi h, 18432
  shld unmlz_1
  lxi h, imgScreen_colors
  call unmlz
  ; 409 colorizer_rand();
  call colorizer_rand
  ; 1 *(uchar*)(0xF802)=(C); }
  lxi h, 63490
  mvi m, 144
  ; 412 print(56,19,8,"‚›");
  mvi a, 56
  sta print_1
  mvi a, 19
  sta print_2
  mvi a, 8
  sta print_3
  lxi h, string10
  call print
  ; 414 updateTopScore();
  call updateTopScore
  ; 415 playerSpriteTop = -1;
  mvi a, 255
  sta playerSpriteTop
  ; 416 drawScore1();
  call drawScore1
  ; 418 if(!showPath ) drawOnOff(0, 0);convertToConfition
  lda showPath
  ora a
  jnz l232
  ; 418 drawOnOff(0, 0);
  xra a
  sta drawOnOff_1
  call drawOnOff
l232:
  ; 419 if(!playSound) drawOnOff(1, 0);convertToConfition
  lda playSound
  ora a
  jnz l233
  ; 419 drawOnOff(1, 0);
  mvi a, 1
  sta drawOnOff_1
  xra a
  call drawOnOff
l233:
  ; 420 if(!showHelp ) drawOnOff(2, 0);convertToConfition
  lda showHelp
  ora a
  jnz l234
  ; 420 drawOnOff(2, 0);
  mvi a, 2
  sta drawOnOff_1
  xra a
  call drawOnOff
l234:
  ret
  ; --- changeColor -----------------------------------------------------------------
changeColor:
  lxi h, spriteMode
  mvi a, 1
  sub m
  sta spriteMode
  ; 433 initGameScreen2();
  jmp initGameScreen2
initGameScreen:
  lxi h, 18432
  shld memset_1
  mvi a, 240
  sta memset_2
  mvi h, 48
  call memset
  ; 440 colorizer_rand();    
  call colorizer_rand
  ; 441 initGameScreen2();
  jmp initGameScreen2
getch_:
  xra a
  jmp getch1
  ret
  ; --- bioskey_ -----------------------------------------------------------------
bioskey_:
  mvi a, 1
  jmp getch1
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
  ; 50 asm {
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
  ; 83 asm {
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
  ; 102 a += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld fillRect1_1
  dad d
  shld fillRect1_1
  ; 103 if(c==0) {Сложение с константой 0
  lhld fillRect1_2
  mov a, l
  ora h
  jnz l235
  ; 104 fillRect1_int(h, l & r, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lxi h, fillRect1_4
  lda fillRect1_3
  ana m
  sta fillRect1_int_2
  lhld fillRect1_1
  jmp fillRect1_int
  ; 105 return;
l235:
  ; 107 --c;  
  lhld fillRect1_2
  dcx h
  shld fillRect1_2
  ; 108 fillRect1_int(h, l, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lda fillRect1_3
  sta fillRect1_int_2
  lhld fillRect1_1
  call fillRect1_int
  ; 109 a += 0x100;Сложение
  lxi d, 256
  lhld fillRect1_1
  dad d
  shld fillRect1_1
  ; 110 for(; c; --c) {  
l236:
  ; convertToConfition
  lhld fillRect1_2
  mov a, l
  ora h
  jz l237
  ; 111 fillRect1_int(h, 0xFF, a);
  lda fillRect1_5
  sta fillRect1_int_1
  mvi a, 255
  sta fillRect1_int_2
  lhld fillRect1_1
  call fillRect1_int
  ; 112 a += 0x100;Сложение
  lxi d, 256
  lhld fillRect1_1
  dad d
  shld fillRect1_1
l238:
  lhld fillRect1_2
  dcx h
  shld fillRect1_2
  jmp l236
l237:
  ; 114 fillRect1_int(h, r, a);
  lda fillRect1_5
  sta fillRect1_int_1
  lda fillRect1_4
  sta fillRect1_int_2
  lhld fillRect1_1
  jmp fillRect1_int
fillRect:
  sta fillRect_4
  ; 118 fillRect1(HORZALINEARGS(x0, y0, x1), y1-y0+1);
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
  ; 271 d += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld print1_1
  dad d
  shld print1_1
  ; 272 e = n&0x80; n&=0x7F;
  lda print1_3
  ani 128
  sta print1_e
  ; 272 n&=0x7F;
  lda print1_3
  ani 127
  sta print1_3
  ; 273 while(1) { 
l239:
  ; 274 if(n == 0) return;     
  lda print1_3
  ora a
  jnz l241
  ; 274 return;     
  ret
l241:
  ; 275 c = *text;
  lhld print1_4
  mov a, m
  sta print1_c
  ; 276 if(c) ++text; else if(!e) return;convertToConfition
  ora a
  jz l242
  ; 276 ++text; else if(!e) return;
  inx h
  shld print1_4
  jmp l243
l242:
  ; 276 if(!e) return;convertToConfition
  lda print1_e
  ora a
  jnz l244
  ; 276 return;
  ret
l244:
l243:
  ; 277 s = chargen + c*8;
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
  ; 278 switch(st) {
  lda print1_2
  ora a
  jz l246
  cpi 1
  jz l247
  cpi 2
  jz l248
  cpi 3
  jz l249
  jmp l245
l246:
  ; 279 print_p1(d, s); ++st; break;
  lhld print1_1
  shld print_p1_1
  lhld print1_s
  call print_p1
  ; 279 ++st; break;
  lxi h, print1_2
  inr m
  ; 279 break;
  jmp l245
l247:
  ; 280 print_p2(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p2_1
  lhld print1_s
  call print_p2
  ; 280 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 280 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 280 break;
  jmp l245
l248:
  ; 281 print_p3(d, s); ++st; d += 0x100; break;
  lhld print1_1
  shld print_p3_1
  lhld print1_s
  call print_p3
  ; 281 ++st; d += 0x100; break;
  lxi h, print1_2
  inr m
  ; 281 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 281 break;
  jmp l245
l249:
  ; 282 print_p4(d, s); st=0; d += 0x100; break;
  lhld print1_1
  shld print_p4_1
  lhld print1_s
  call print_p4
  ; 282 st=0; d += 0x100; break;
  xra a
  sta print1_2
  ; 282 d += 0x100; break;Сложение
  lxi d, 256
  lhld print1_1
  dad d
  shld print1_1
  ; 282 break;
l245:
  ; 284 --n;
  lxi h, print1_3
  dcr m
  jmp l239
l240:
  ret
  ; --- rect1 -----------------------------------------------------------------
rect1:
  sta rect1_7
  ; 289 fillRect1(a, c, l, r, 1);
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
  ; 290 fillRect1(a, 0, ll, ll, h);
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
  ; 291 fillRect1(a+c*256, 0, rr, rr, h);
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
  ; 292 fillRect1(a+h-1, c, l, r, 1);Сложение
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
  ; 296 rect1(RECTARGS(x, y, x1, y1));
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
  ; 300 print1(PRINTARGS(x, y), n, text);
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
  ; 304 d += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld scroll_1
  dad d
  shld scroll_1
  ; 305 s += graphOffset;Сложение
  lhld graphOffset
  xchg
  lhld scroll_2
  dad d
  shld scroll_2
  ; 306 if(d>s) {
  lhld scroll_1
  xchg
  lhld scroll_2
  call op_cmp16
  jnc l250
  ; 308 for(; w; --w, d+=0x100, s+=0x100)
l251:
  ; convertToConfition
  lda scroll_3
  ora a
  jz l252
  ; 309 memcpy_back(d, s, h);
  lhld scroll_1
  shld memcpy_back_1
  lhld scroll_2
  shld memcpy_back_2
  lhld scroll_4
  mvi h, 0
  call memcpy_back
l253:
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
  jmp l251
l252:
l250:
  ; 311 for(; w; --w, d+=0x100, s+=0x100)
l254:
  ; convertToConfition
  lda scroll_3
  ora a
  jz l255
  ; 312 memcpy(d, s, h);
  lhld scroll_1
  shld memcpy_1
  lhld scroll_2
  shld memcpy_2
  lhld scroll_4
  mvi h, 0
  call memcpy
l256:
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
  jmp l254
l255:
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
  sta getch1_1
  ; 1 (*(uchar*)0xF803)
  lxi h, 63491
  mvi m, 145
l257:
  ; 65 while(1) {
l258:
  ; 66 i = 6;
  mvi b, 6
  ; 67 while(1) {
l260:
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
  jz l262
  ; 71 u = 4; break; }
  mvi c, 4
  ; 71 break; }
  jmp l261
l262:
  ; 72 b = KEYB2 | 0xF0;
  lda 63490
  ori 240
  sta getch1_b
  ; 73 if(b != 0xFF) { u = -4; break; }
  cpi 255
  jz l263
  ; 73 u = -4; break; }
  mvi c, 252
  ; 73 break; }
  jmp l261
l263:
  ; 74 if(i) continue;convertToConfition
  mov a, b
  ora a
  jnz l260
  mvi b, 6
  ; 76 prevCh = -1;
  mvi a, 255
  sta prevCh
  ; 77 if(noWait) return 0;convertToConfition
  lda getch1_1
  ora a
  jz l265
  ; 77 return 0;
  xra a
  pop b
  ret
l265:
  jmp l260
l261:
  ; 79 b = numberOfBit(b) + u + i $ 12;
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
  ; 80 if(noWait) break;convertToConfition
  lda getch1_1
  ora a
  jnz l259
  lxi h, getch1_b
  lda prevCh
  cmp m
  jnz l259
  jmp l258
l259:
  ; 84 prevCh = b;
  lda getch1_b
  sta prevCh
  ; 86 if(b==12) {
  lda getch1_b
  cpi 12
  jnz l268
  ; 87 rus = !rus;convertToConfition
  lda rus
  ora a
  sui 1
  sbb a
  sta rus
  jmp l257
l268:
  ; 91 if(b>=24) {
  lda getch1_b
  cpi 24
  jc l269
  ; 92 if(shiftPressed()) b += 12*4;
  call shiftPressed
  ; convertToConfition
  ora a
  jz l270
  ; 92 b += 12*4;
  lda getch1_b
  adi 48
  sta getch1_b
l270:
  ; 93 if(rus) b += 12*8;convertToConfition
  lda rus
  ora a
  jz l271
  ; 93 b += 12*8;
  lda getch1_b
  adi 96
  sta getch1_b
l271:
l269:
  ; 96 return scanCodes[b];Сложение
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
  ; 101 return ~KEYB1 & 2;
  lda 63489
  cma
  ani 2
  ret
  ; --- unmlz -----------------------------------------------------------------
unmlz:
  shld unmlz_2
  ; 2 asm {
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

; ===========================================================================

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

; ===========================================================================

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

; ---------------------------------------------------------------------------
  
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
  ; --- op_shr -----------------------------------------------------------------
op_shr:
  inr d
op_shr_2:
  dcr d
  rz
  cmp a
  rar
  jmp op_shr_2

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
spriteMode:
 .db 1

cellAddr_1:
 .ds 1
cellAddr_2:
 .ds 1
colors:
 .db 192
 .db 0
 .db 16
 .db 64
 .db 80
 .db 128
 .db 144
 .db 208

drawBall1_1:
 .ds 2
drawBall1_2:
 .ds 2
drawBall1_3:
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
 .dw 39665
 .dw 41713
 .dw 43761

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
initGameScreen2_s:
 .ds 2
initGameScreen2_i:
 .ds 1
initGameScreen2_x:
 .ds 1
initGameScreen2_y:
 .ds 1
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

getch1_1:
 .ds 1
getch1_b:
 .ds 1
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
 .db 226
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
 .db 158
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
 .db 94
 .db 55
 .db 68
 .db 237
 .db 209
 .db 95
 .db 52
 .db 97
 .db 49
 .db 255
 .db 119
 .db 102
 .db 191
 .db 143
 .db 46
 .db 160
 .db 37
 .db 181
 .db 180
 .db 15
 .db 101
 .db 96
 .db 133
 .db 104
 .db 2
 .db 252
 .db 242
 .db 124
 .db 255
 .db 201
 .db 47
 .db 125
 .db 127
 .db 183
 .db 159
 .db 99
 .db 156
 .db 109
 .db 179
 .db 92
 .db 175
 .db 95
 .db 252
 .db 158
 .db 234
 .db 252
 .db 117
 .db 30
 .db 13
 .db 88
 .db 63
 .db 52
 .db 225
 .db 215
 .db 121
 .db 146
 .db 109
 .db 164
 .db 200
 .db 198
 .db 199
 .db 246
 .db 195
 .db 98
 .db 255
 .db 199
 .db 140
 .db 234
 .db 229
 .db 235
 .db 199
 .db 234
 .db 212
 .db 248
 .db 245
 .db 99
 .db 7
 .db 17
 .db 142
 .db 141
 .db 133
 .db 198
 .db 255
 .db 255
 .db 185
 .db 106
 .db 128
 .db 189
 .db 248
 .db 234
 .db 63
 .db 255
 .db 143
 .db 243
 .db 60
 .db 207
 .db 179
 .db 92
 .db 239
 .db 85
 .db 141
 .db 171
 .db 238
 .db 94
 .db 246
 .db 251
 .db 110
 .db 53
 .db 11
 .db 7
 .db 1
 .db 6
 .db 124
 .db 115
 .db 215
 .db 1
 .db 3
 .db 193
 .db 255
 .db 192
 .db 92
 .db 248
 .db 21
 .db 150
 .db 255
 .db 93
 .db 128
 .db 24
 .db 179
 .db 234
 .db 6
 .db 235
 .db 242
 .db 225
 .db 60
 .db 192
 .db 251
 .db 255
 .db 0
 .db 30
 .db 63
 .db 255
 .db 13
 .db 205
 .db 255
 .db 120
 .db 186
 .db 219
 .db 253
 .db 0
 .db 31
 .db 227
 .db 252
 .db 167
 .db 127
 .db 233
 .db 31
 .db 231
 .db 241
 .db 62
 .db 205
 .db 179
 .db 152
 .db 93
 .db 0
 .db 187
 .db 194
 .db 63
 .db 254
 .db 248
 .db 59
 .db 13
 .db 6
 .db 1
 .db 193
 .db 115
 .db 30
 .db 215
 .db 8
 .db 28
 .db 30
 .db 31
 .db 255
 .db 199
 .db 60
 .db 254
 .db 179
 .db 252
 .db 69
 .db 255
 .db 238
 .db 137
 .db 28
 .db 235
 .db 167
 .db 243
 .db 127
 .db 126
 .db 60
 .db 24
 .db 255
 .db 8
 .db 216
 .db 129
 .db 195
 .db 106
 .db 0
 .db 142
 .db 31
 .db 238
 .db 182
 .db 197
 .db 83
 .db 38
 .db 254
 .db 175
 .db 143
 .db 241
 .db 53
 .db 250
 .db 192
 .db 245
 .db 174
 .db 223
 .db 245
 .db 227
 .db 220
 .db 111
 .db 157
 .db 223
 .db 231
 .db 89
 .db 247
 .db 252
 .db 186
 .db 252
 .db 251
 .db 53
 .db 30
 .db 243
 .db 246
 .db 5
 .db 172
 .db 107
 .db 215
 .db 128
 .db 248
 .db 116
 .db 6
 .db 120
 .db 255
 .db 163
 .db 56
 .db 255
 .db 218
 .db 249
 .db 16
 .db 1
 .db 227
 .db 237
 .db 182
 .db 84
 .db 185
 .db 186
 .db 16
 .db 60
 .db 22
 .db 60
 .db 126
 .db 124
 .db 118
 .db 167
 .db 227
 .db 111
 .db 4
 .db 128
 .db 1
 .db 95
 .db 206
 .db 97
 .db 241
 .db 255
 .db 121
 .db 143
 .db 171
 .db 129
 .db 15
 .db 240
 .db 127
 .db 182
 .db 0
 .db 199
 .db 0
 .db 206
 .db 229
 .db 63
 .db 207
 .db 179
 .db 215
 .db 247
 .db 252
 .db 191
 .db 2
 .db 0
 .db 78
 .db 248
 .db 213
 .db 46
 .db 29
 .db 186
 .db 63
 .db 193
 .db 95
 .db 25
 .db 215
 .db 1
 .db 7
 .db 46
 .db 148
 .db 126
 .db 27
 .db 255
 .db 10
 .db 254
 .db 23
 .db 56
 .db 24
 .db 16
 .db 193
 .db 2
 .db 198
 .db 101
 .db 22
 .db 255
 .db 219
 .db 13
 .db 31
 .db 245
 .db 230
 .db 253
 .db 8
 .db 2
 .db 255
 .db 186
 .db 178
 .db 140
 .db 223
 .db 143
 .db 0
 .db 255
 .db 254
 .db 128
 .db 127
 .db 31
 .db 182
 .db 225
 .db 127
 .db 165
 .db 240
 .db 15
 .db 159
 .db 103
 .db 249
 .db 86
 .db 239
 .db 253
 .db 53
 .db 207
 .db 115
 .db 236
 .db 87
 .db 255
 .db 12
 .db 0
 .db 252
 .db 239
 .db 36
 .db 248
 .db 246
 .db 117
 .db 31
 .db 13
 .db 3
 .db 9
 .db 216
 .db 215
 .db 199
 .db 12
 .db 30
 .db 105
 .db 240
 .db 51
 .db 152
 .db 70
 .db 255
 .db 51
 .db 217
 .db 62
 .db 207
 .db 28
 .db 199
 .db 24
 .db 8
 .db 97
 .db 199
 .db 159
 .db 2
 .db 246
 .db 29
 .db 135
 .db 255
 .db 92
 .db 184
 .db 166
 .db 52
 .db 132
 .db 135
 .db 248
 .db 24
 .db 15
 .db 240
 .db 251
 .db 13
 .db 56
 .db 247
 .db 247
 .db 111
 .db 143
 .db 115
 .db 252
 .db 43
 .db 2
 .db 233
 .db 252
 .db 250
 .db 85
 .db 110
 .db 254
 .db 230
 .db 213
 .db 127
 .db 21
 .db 18
 .db 1
 .db 193
 .db 51
 .db 6
 .db 215
 .db 186
 .db 248
 .db 228
 .db 109
 .db 31
 .db 163
 .db 255
 .db 251
 .db 177
 .db 46
 .db 32
 .db 128
 .db 48
 .db 196
 .db 215
 .db 255
 .db 31
 .db 29
 .db 221
 .db 246
 .db 250
 .db 8
 .db 102
 .db 255
 .db 156
 .db 174
 .db 188
 .db 0
 .db 6
 .db 90
 .db 251
 .db 109
 .db 252
 .db 219
 .db 243
 .db 217
 .db 195
 .db 63
 .db 31
 .db 216
 .db 122
 .db 2
 .db 119
 .db 189
 .db 242
 .db 118
 .db 69
 .db 4
 .db 242
 .db 248
 .db 244
 .db 209
 .db 248
 .db 63
 .db 44
 .db 89
 .db 16
 .db 236
 .db 128
 .db 174
 .db 66
 .db 236
 .db 188
 .db 2
 .db 7
 .db 229
 .db 255
 .db 143
 .db 142
 .db 101
 .db 8
 .db 173
 .db 251
 .db 14
 .db 130
 .db 224
 .db 240
 .db 11
 .db 149
 .db 19
 .db 254
 .db 177
 .db 176
 .db 126
 .db 248
 .db 216
 .db 220
 .db 140
 .db 136
 .db 190
 .db 76
 .db 203
 .db 26
 .db 125
 .db 228
 .db 1
 .db 216
 .db 150
 .db 155
 .db 63
 .db 193
 .db 95
 .db 86
 .db 2
 .db 112
 .db 217
 .db 243
 .db 47
 .db 199
 .db 124
 .db 131
 .db 231
 .db 121
 .db 218
 .db 254
 .db 93
 .db 252
 .db 252
 .db 7
 .db 132
 .db 0
 .db 113
 .db 248
 .db 122
 .db 246
 .db 55
 .db 193
 .db 23
 .db 224
 .db 251
 .db 121
 .db 129
 .db 195
 .db 231
 .db 199
 .db 255
 .db 103
 .db 230
 .db 25
 .db 239
 .db 206
 .db 204
 .db 5
 .db 239
 .db 15
 .db 131
 .db 3
 .db 17
 .db 48
 .db 174
 .db 56
 .db 48
 .db 216
 .db 171
 .db 153
 .db 251
 .db 247
 .db 227
 .db 254
 .db 51
 .db 255
 .db 119
 .db 253
 .db 99
 .db 245
 .db 34
 .db 0
 .db 65
 .db 64
 .db 200
 .db 68
 .db 11
 .db 222
 .db 15
 .db 23
 .db 13
 .db 22
 .db 20
 .db 5
 .db 196
 .db 254
 .db 2
 .db 50
 .db 131
 .db 252
 .db 3
 .db 28
 .db 250
 .db 249
 .db 254
 .db 245
 .db 234
 .db 5
 .db 232
 .db 252
 .db 8
 .db 13
 .db 128
 .db 126
 .db 253
 .db 248
 .db 111
 .db 155
 .db 62
 .db 31
 .db 251
 .db 245
 .db 243
 .db 131
 .db 124
 .db 253
 .db 59
 .db 183
 .db 63
 .db 207
 .db 198
 .db 248
 .db 4
 .db 223
 .db 143
 .db 252
 .db 34
 .db 248
 .db 236
 .db 219
 .db 230
 .db 14
 .db 170
 .db 1
 .db 178
 .db 51
 .db 179
 .db 7
 .db 252
 .db 21
 .db 132
 .db 42
 .db 255
 .db 248
 .db 76
 .db 218
 .db 224
 .db 209
 .db 128
 .db 216
 .db 255
 .db 15
 .db 95
 .db 156
 .db 2
 .db 191
 .db 31
 .db 99
 .db 253
 .db 15
 .db 250
 .db 0
 .db 20
 .db 190
 .db 233
 .db 254
 .db 13
 .db 70
 .db 251
 .db 8
 .db 63
 .db 219
 .db 117
 .db 170
 .db 84
 .db 27
 .db 20
 .db 169
 .db 48
 .db 125
 .db 65
 .db 50
 .db 85
 .db 2
 .db 246
 .db 175
 .db 3
 .db 42
 .db 192
 .db 5
 .db 168
 .db 190
 .db 0
 .db 175
 .db 247
 .db 235
 .db 248
 .db 246
 .db 247
 .db 201
 .db 237
 .db 245
 .db 241
 .db 125
 .db 230
 .db 175
 .db 192
 .db 252
 .db 69
 .db 4
 .db 246
 .db 233
 .db 237
 .db 248
 .db 63
 .db 31
 .db 143
 .db 127
 .db 251
 .db 25
 .db 4
 .db 36
 .db 254
 .db 129
 .db 110
 .db 1
 .db 6
 .db 2
 .db 205
 .db 170
 .db 2
 .db 173
 .db 1
 .db 62
 .db 245
 .db 3
 .db 9
 .db 154
 .db 255
 .db 93
 .db 16
 .db 102
 .db 23
 .db 239
 .db 74
 .db 8
 .db 237
 .db 224
 .db 3
 .db 235
 .db 150
 .db 3
 .db 227
 .db 27
 .db 115
 .db 7
 .db 15
 .db 3
 .db 198
 .db 160
 .db 96
 .db 153
 .db 80
 .db 254
 .db 132
 .db 252
 .db 129
 .db 72
 .db 0
 .db 2
 .db 1
 .db 159
 .db 73
 .db 127
 .db 191
 .db 95
 .db 168
 .db 7
 .db 172
 .db 160
 .db 31
 .db 15
 .db 254
 .db 40
 .db 5
 .db 168
 .db 87
 .db 237
 .db 175
 .db 95
 .db 191
 .db 55
 .db 111
 .db 142
 .db 140
 .db 241
 .db 204
 .db 231
 .db 150
 .db 127
 .db 156
 .db 227
 .db 180
 .db 249
 .db 198
 .db 127
 .db 159
 .db 231
 .db 208
 .db 247
 .db 204
 .db 49
 .db 225
 .db 173
 .db 99
 .db 248
 .db 153
 .db 68
 .db 99
 .db 132
 .db 25
 .db 47
 .db 216
 .db 250
 .db 12
 .db 158
 .db 192
 .db 254
 .db 44
 .db 34
 .db 149
 .db 255
 .db 62
 .db 99
 .db 175
 .db 31
 .db 255
 .db 138
 .db 159
 .db 204
 .db 86
 .db 255
 .db 127
 .db 139
 .db 0
 .db 213
 .db 4
 .db 78
 .db 60
 .db 3
 .db 153
 .db 243
 .db 246
 .db 185
 .db 0
 .db 252
 .db 128
 .db 3
 .db 48
 .db 128
 .db 56
 .db 161
 .db 39
 .db 126
 .db 130
 .db 252
 .db 70
 .db 248
 .db 153
 .db 251
 .db 119
 .db 89
 .db 248
 .db 60
 .db 190
 .db 209
 .db 241
 .db 143
 .db 206
 .db 124
 .db 1
 .db 177
 .db 214
 .db 127
 .db 191
 .db 252
 .db 236
 .db 251
 .db 78
 .db 63
 .db 102
 .db 140
 .db 66
 .db 204
 .db 34
 .db 236
 .db 194
 .db 2
 .db 188
 .db 216
 .db 156
 .db 206
 .db 140
 .db 239
 .db 206
 .db 7
 .db 192
 .db 18
 .db 44
 .db 197
 .db 255
 .db 131
 .db 177
 .db 255
 .db 170
 .db 243
 .db 135
 .db 184
 .db 5
 .db 175
 .db 73
 .db 240
 .db 86
 .db 70
 .db 97
 .db 166
 .db 41
 .db 253
 .db 251
 .db 255
 .db 241
 .db 29
 .db 159
 .db 169
 .db 82
 .db 254
 .db 173
 .db 88
 .db 60
 .db 252
 .db 55
 .db 95
 .db 63
 .db 127
 .db 191
 .db 111
 .db 254
 .db 254
 .db 183
 .db 93
 .db 46
 .db 85
 .db 42
 .db 23
 .db 55
 .db 21
 .db 10
 .db 1
 .db 89
 .db 28
 .db 63
 .db 12
 .db 253
 .db 26
 .db 193
 .db 234
 .db 213
 .db 159
 .db 170
 .db 254
 .db 212
 .db 160
 .db 197
 .db 42
 .db 69
 .db 248
 .db 197
 .db 224
 .db 85
 .db 30
 .db 215
 .db 245
 .db 155
 .db 126
 .db 253
 .db 242
 .db 159
 .db 246
 .db 251
 .db 33
 .db 175
 .db 225
 .db 204
 .db 2
 .db 120
 .db 4
 .db 200
 .db 48
 .db 8
 .db 252
 .db 22
 .db 102
 .db 33
 .db 76
 .db 1
 .db 224
 .db 225
 .db 174
 .db 45
 .db 130
 .db 33
 .db 199
 .db 6
 .db 255
 .db 7
 .db 253
 .db 51
 .db 250
 .db 2
 .db 87
 .db 65
 .db 88
 .db 106
 .db 115
 .db 86
 .db 2
 .db 109
 .db 186
 .db 69
 .db 42
 .db 125
 .db 214
 .db 224
 .db 239
 .db 203
 .db 80
 .db 252
 .db 247
 .db 125
 .db 221
 .db 239
 .db 250
 .db 181
 .db 73
 .db 253
 .db 55
 .db 254
 .db 138
 .db 84
 .db 31
 .db 227
 .db 207
 .db 234
 .db 69
 .db 168
 .db 84
 .db 162
 .db 150
 .db 21
 .db 248
 .db 229
 .db 254
 .db 247
 .db 250
 .db 253
 .db 2
 .db 149
 .db 246
 .db 252
 .db 63
 .db 255
 .db 251
 .db 248
 .db 52
 .db 204
 .db 34
 .db 37
 .db 254
 .db 250
 .db 154
 .db 0
 .db 239
 .db 4
 .db 6
 .db 15
 .db 168
 .db 0
 .db 162
 .db 51
 .db 162
 .db 28
 .db 207
 .db 23
 .db 238
 .db 237
 .db 64
 .db 14
 .db 127
 .db 14
 .db 4
 .db 0
 .db 1
 .db 97
 .db 210
 .db 1
 .db 240
 .db 207
 .db 238
 .db 132
 .db 80
 .db 168
 .db 49
 .db 30
 .db 245
 .db 184
 .db 212
 .db 170
 .db 208
 .db 184
 .db 240
 .db 80
 .db 64
 .db 102
 .db 169
 .db 68
 .db 240
 .db 32
 .db 34
 .db 223
 .db 102
 .db 1
 .db 7
 .db 31
 .db 161
 .db 171
 .db 16
 .db 236
 .db 246
 .db 130
 .db 5
 .db 160
 .db 84
 .db 72
 .db 0
 .db 13
 .db 171
 .db 95
 .db 99
 .db 195
 .db 243
 .db 207
 .db 118
 .db 28
 .db 118
 .db 89
 .db 236
 .db 121
 .db 103
 .db 31
 .db 78
 .db 254
 .db 84
 .db 126
 .db 120
 .db 112
 .db 64
 .db 220
 .db 154
 .db 143
 .db 2
 .db 108
 .db 254
 .db 120
 .db 60
 .db 230
 .db 128
 .db 192
 .db 248
 .db 173
 .db 42
 .db 60
 .db 50
 .db 255
 .db 28
 .db 255
 .db 19
 .db 214
 .db 249
 .db 8
 .db 135
 .db 105
 .db 207
 .db 225
 .db 12
 .db 28
 .db 173
 .db 62
 .db 189
 .db 250
 .db 228
 .db 124
 .db 88
 .db 83
 .db 215
 .db 192
 .db 1
 .db 216
 .db 210
 .db 83
 .db 150
 .db 11
 .db 68
 .db 237
 .db 191
 .db 248
 .db 140
 .db 255
 .db 254
 .db 170
 .db 102
 .db 13
 .db 7
 .db 127
 .db 20
 .db 78
 .db 28
 .db 3
 .db 31
 .db 61
 .db 128
 .db 216
 .db 154
 .db 221
 .db 14
 .db 1
 .db 125
 .db 154
 .db 7
 .db 120
 .db 167
 .db 255
 .db 59
 .db 188
 .db 67
 .db 63
 .db 95
 .db 175
 .db 87
 .db 27
 .db 23
 .db 143
 .db 214
 .db 81
 .db 174
 .db 214
 .db 230
 .db 233
 .db 228
 .db 127
 .db 169
 .db 249
 .db 181
 .db 199
 .db 209
 .db 128
 .db 246
 .db 82
 .db 35
 .db 98
 .db 78
 .db 135
 .db 248
 .db 240
 .db 192
 .db 204
 .db 64
 .db 154
 .db 15
 .db 129
 .db 25
 .db 3
 .db 2
 .db 6
 .db 75
 .db 164
 .db 247
 .db 19
 .db 49
 .db 255
 .db 126
 .db 58
 .db 90
 .db 44
 .db 28
 .db 41
 .db 90
 .db 13
 .db 207
 .db 38
 .db 255
 .db 135
 .db 255
 .db 3
 .db 218
 .db 108
 .db 27
 .db 74
 .db 53
 .db 144
 .db 5
 .db 139
 .db 250
 .db 6
 .db 178
 .db 0
 .db 54
 .db 1
 .db 240
 .db 54
 .db 248
 .db 4
 .db 52
 .db 255
 .db 75
 .db 7
 .db 175
 .db 3
 .db 224
 .db 248
 .db 253
 .db 250
 .db 252
 .db 0
 .db 245
 .db 142
 .db 107
 .db 254
 .db 125
 .db 128
 .db 187
 .db 22
 .db 240
 .db 143
 .db 99
 .db 133
 .db 240
 .db 235
 .db 203
 .db 47
 .db 14
 .db 88
 .db 254
 .db 191
 .db 138
 .db 103
 .db 252
 .db 186
 .db 91
 .db 196
 .db 95
 .db 141
 .db 15
 .db 128
 .db 153
 .db 64
 .db 25
 .db 16
 .db 96
 .db 54
 .db 143
 .db 199
 .db 36
 .db 111
 .db 179
 .db 3
 .db 121
 .db 3
 .db 7
 .db 108
 .db 255
 .db 101
 .db 221
 .db 1
 .db 247
 .db 2
 .db 143
 .db 6
 .db 128
 .db 176
 .db 224
 .db 219
 .db 103
 .db 15
 .db 255
 .db 0
 .db 2
 .db 209
 .db 23
 .db 61
 .db 75
 .db 173
 .db 42
 .db 141
 .db 219
 .db 17
 .db 21
 .db 117
 .db 132
 .db 211
 .db 168
 .db 21
 .db 125
 .db 245
 .db 234
 .db 174
 .db 213
 .db 129
 .db 20
 .db 160
 .db 111
 .db 223
 .db 22
 .db 42
 .db 4
 .db 160
 .db 5
 .db 19
 .db 213
 .db 234
 .db 178
 .db 253
 .db 94
 .db 187
 .db 28
 .db 227
 .db 207
 .db 63
 .db 217
 .db 4
 .db 63
 .db 98
 .db 102
 .db 5
 .db 47
 .db 79
 .db 247
 .db 24
 .db 132
 .db 153
 .db 68
 .db 140
 .db 152
 .db 64
 .db 252
 .db 178
 .db 140
 .db 215
 .db 233
 .db 8
 .db 121
 .db 30
 .db 162
 .db 114
 .db 247
 .db 213
 .db 255
 .db 243
 .db 75
 .db 255
 .db 227
 .db 214
 .db 255
 .db 195
 .db 115
 .db 255
 .db 207
 .db 131
 .db 95
 .db 45
 .db 126
 .db 172
 .db 253
 .db 252
 .db 52
 .db 232
 .db 4
 .db 231
 .db 32
 .db 212
 .db 42
 .db 24
 .db 226
 .db 22
 .db 238
 .db 181
 .db 97
 .db 180
 .db 106
 .db 36
 .db 4
 .db 81
 .db 76
 .db 84
 .db 136
 .db 67
 .db 75
 .db 16
 .db 27
 .db 1
 .db 87
 .db 119
 .db 77
 .db 20
 .db 14
 .db 128
 .db 183
 .db 87
 .db 26
 .db 21
 .db 12
 .db 215
 .db 240
 .db 94
 .db 20
 .db 198
 .db 111
 .db 235
 .db 11
 .db 247
 .db 95
 .db 0
 .db 255
 .db 218
 .db 205
 .db 163
 .db 107
 .db 162
 .db 240
 .db 70
 .db 5
 .db 52
 .db 255
 .db 235
 .db 240
 .db 8
 .db 152
 .db 100
 .db 0
 .db 252
 .db 11
 .db 120
 .db 17
 .db 247
 .db 113
 .db 129
 .db 227
 .db 225
 .db 30
 .db 193
 .db 196
 .db 86
 .db 255
 .db 225
 .db 99
 .db 255
 .db 227
 .db 243
 .db 1
 .db 218
 .db 255
 .db 97
 .db 157
 .db 209
 .db 0
 .db 255
 .db 155
 .db 129
 .db 142
 .db 165
 .db 32
 .db 252
 .db 220
 .db 96
 .db 94
 .db 156
 .db 139
 .db 16
 .db 64
 .db 105
 .db 63
 .db 8
 .db 191
 .db 95
 .db 47
 .db 0
 .db 93
 .db 18
 .db 27
 .db 168
 .db 83
 .db 191
 .db 143
 .db 170
 .db 20
 .db 45
 .db 229
 .db 52
 .db 204
 .db 138
 .db 12
 .db 200
 .db 12
 .db 4
 .db 243
 .db 248
 .db 42
 .db 191
 .db 252
 .db 254
 .db 220
 .db 240
 .db 96
 .db 128
 .db 97
 .db 197
 .db 135
 .db 1
 .db 187
 .db 96
 .db 75
 .db 38
 .db 140
 .db 97
 .db 171
 .db 90
 .db 23
 .db 241
 .db 175
 .db 255
 .db 243
 .db 59
 .db 255
 .db 205
 .db 235
 .db 221
 .db 59
 .db 126
 .db 60
 .db 24
 .db 90
 .db 255
 .db 0
 .db 199
 .db 36
 .db 3
 .db 194
 .db 191
 .db 86
 .db 101
 .db 255
 .db 196
 .db 255
 .db 24
 .db 77
 .db 254
 .db 193
 .db 223
 .db 172
 .db 124
 .db 109
 .db 244
 .db 199
 .db 254
 .db 162
 .db 254
 .db 47
 .db 236
 .db 74
 .db 20
 .db 221
 .db 24
 .db 246
 .db 13
 .db 183
 .db 127
 .db 3
 .db 168
 .db 8
 .db 141
 .db 252
 .db 18
 .db 248
 .db 118
 .db 75
 .db 195
 .db 217
 .db 63
 .db 6
 .db 163
 .db 5
 .db 217
 .db 31
 .db 58
 .db 192
 .db 143
 .db 125
 .db 249
 .db 106
 .db 255
 .db 127
 .db 215
 .db 254
 .db 218
 .db 10
 .db 250
 .db 229
 .db 129
 .db 152
 .db 255
 .db 195
 .db 199
 .db 79
 .db 229
 .db 46
 .db 48
 .db 215
 .db 92
 .db 97
 .db 57
 .db 4
 .db 66
 .db 96
 .db 127
 .db 198
 .db 102
 .db 86
 .db 160
 .db 6
 .db 239
 .db 90
 .db 227
 .db 31
 .db 255
 .db 215
 .db 227
 .db 31
 .db 184
 .db 225
 .db 165
 .db 223
 .db 122
 .db 32
 .db 31
 .db 245
 .db 117
 .db 4
 .db 115
 .db 207
 .db 55
 .db 59
 .db 8
 .db 117
 .db 230
 .db 4
 .db 246
 .db 248
 .db 254
 .db 120
 .db 88
 .db 5
 .db 112
 .db 12
 .db 103
 .db 223
 .db 255
 .db 240
 .db 249
 .db 25
 .db 132
 .db 115
 .db 255
 .db 30
 .db 249
 .db 175
 .db 218
 .db 96
 .db 166
 .db 64
 .db 255
 .db 6
 .db 31
 .db 199
 .db 141
 .db 10
 .db 249
 .db 175
 .db 227
 .db 177
 .db 193
 .db 191
 .db 209
 .db 91
 .db 131
 .db 1
 .db 110
 .db 24
 .db 128
 .db 222
 .db 202
 .db 29
 .db 173
 .db 244
 .db 188
 .db 11
 .db 120
 .db 22
 .db 86
 .db 249
 .db 103
 .db 72
 .db 16
 .db 201
 .db 123
 .db 254
 .db 84
 .db 248
 .db 96
 .db 192
 .db 123
 .db 52
 .db 69
 .db 216
 .db 85
 .db 76
 .db 57
 .db 143
 .db 249
 .db 16
 .db 48
 .db 56
 .db 169
 .db 120
 .db 15
 .db 48
 .db 126
 .db 103
 .db 225
 .db 17
 .db 136
 .db 220
 .db 253
 .db 206
 .db 217
 .db 127
 .db 212
 .db 60
 .db 56
 .db 60
 .db 16
 .db 125
 .db 0
 .db 129
 .db 133
 .db 219
 .db 2
 .db 236
 .db 124
 .db 120
 .db 112
 .db 87
 .db 207
 .db 0
 .db 209
 .db 4
 .db 248
 .db 100
 .db 67
 .db 7
 .db 7
 .db 248
 .db 94
 .db 18
 .db 210
 .db 53
 .db 251
 .db 4
 .db 155
 .db 148
 .db 4
 .db 187
 .db 10
 .db 132
 .db 251
 .db 157
 .db 248
 .db 87
 .db 252
 .db 88
 .db 221
 .db 186
 .db 127
 .db 35
 .db 204
 .db 63
 .db 248
 .db 121
 .db 240
 .db 224
 .db 193
 .db 253
 .db 131
 .db 135
 .db 207
 .db 24
 .db 192
 .db 119
 .db 235
 .db 244
 .db 6
 .db 224
 .db 0
 .db 207
 .db 63
 .db 255
 .db 12
 .db 24
 .db 68
 .db 233
 .db 236
 .db 199
 .db 251
 .db 14
 .db 142
 .db 4
 .db 194
 .db 252
 .db 177
 .db 251
 .db 103
 .db 128
 .db 248
 .db 135
 .db 127
 .db 127
 .db 224
 .db 5
 .db 0
 .db 183
 .db 247
 .db 11
 .db 230
 .db 29
 .db 251
 .db 230
 .db 92
 .db 243
 .db 77
 .db 8
 .db 254
 .db 144
 .db 4
 .db 239
 .db 156
 .db 248
 .db 217
 .db 186
 .db 92
 .db 124
 .db 26
 .db 190
 .db 192
 .db 161
 .db 110
 .db 35
 .db 255
 .db 249
 .db 66
 .db 126
 .db 143
 .db 31
 .db 59
 .db 255
 .db 57
 .db 28
 .db 14
 .db 3
 .db 12
 .db 30
 .db 63
 .db 124
 .db 246
 .db 120
 .db 255
 .db 127
 .db 15
 .db 22
 .db 249
 .db 241
 .db 122
 .db 186
 .db 135
 .db 160
 .db 38
 .db 194
 .db 38
 .db 255
 .db 131
 .db 199
 .db 56
 .db 175
 .db 88
 .db 162
 .db 60
 .db 93
 .db 54
 .db 252
 .db 47
 .db 247
 .db 93
 .db 125
 .db 11
 .db 220
 .db 13
 .db 218
 .db 1
 .db 254
 .db 119
 .db 0
 .db 157
 .db 123
 .db 253
 .db 220
 .db 243
 .db 205
 .db 59
 .db 213
 .db 238
 .db 4
 .db 8
 .db 115
 .db 0
 .db 86
 .db 188
 .db 177
 .db 112
 .db 254
 .db 127
 .db 26
 .db 96
 .db 112
 .db 128
 .db 224
 .db 240
 .db 56
 .db 158
 .db 250
 .db 207
 .db 127
 .db 59
 .db 0
 .db 4
 .db 162
 .db 99
 .db 130
 .db 240
 .db 113
 .db 255
 .db 30
 .db 14
 .db 0
 .db 144
 .db 255
 .db 59
 .db 6
 .db 126
 .db 191
 .db 225
 .db 1
 .db 49
 .db 178
 .db 205
 .db 198
 .db 190
 .db 188
 .db 202
 .db 163
 .db 1
 .db 93
 .db 61
 .db 18
 .db 255
 .db 231
 .db 122
 .db 255
 .db 239
 .db 227
 .db 255
 .db 33
 .db 52
 .db 124
 .db 207
 .db 56
 .db 48
 .db 255
 .db 16
 .db 1
 .db 135
 .db 97
 .db 74
 .db 1
 .db 224
 .db 197
 .db 200
 .db 68
 .db 13
 .db 211
 .db 149
 .db 180
 .db 3
 .db 239
 .db 11
 .db 62
 .db 217
 .db 230
 .db 221
 .db 104
 .db 4
 .db 185
 .db 234
 .db 0
 .db 88
 .db 216
 .db 176
 .db 64
 .db 71
 .db 191
 .db 31
 .db 7
 .db 9
 .db 25
 .db 98
 .db 169
 .db 248
 .db 125
 .db 231
 .db 71
 .db 123
 .db 8
 .db 247
 .db 249
 .db 182
 .db 224
 .db 101
 .db 0
 .db 113
 .db 130
 .db 186
 .db 138
 .db 132
 .db 8
 .db 253
 .db 158
 .db 171
 .db 213
 .db 106
 .db 53
 .db 26
 .db 74
 .db 29
 .db 199
 .db 229
 .db 60
 .db 247
 .db 155
 .db 225
 .db 1
 .db 238
 .db 14
 .db 155
 .db 253
 .db 54
 .db 77
 .db 87
 .db 52
 .db 6
 .db 201
 .db 187
 .db 250
 .db 38
 .db 59
 .db 245
 .db 143
 .db 7
 .db 173
 .db 38
 .db 96
 .db 94
 .db 136
 .db 29
 .db 133
 .db 58
 .db 252
 .db 93
 .db 201
 .db 98
 .db 133
 .db 68
 .db 198
 .db 13
 .db 155
 .db 22
 .db 253
 .db 158
 .db 121
 .db 230
 .db 157
 .db 123
 .db 213
 .db 201
 .db 8
 .db 170
 .db 252
 .db 236
 .db 86
 .db 232
 .db 112
 .db 41
 .db 239
 .db 43
 .db 126
 .db 15
 .db 119
 .db 253
 .db 151
 .db 23
 .db 55
 .db 47
 .db 159
 .db 191
 .db 145
 .db 85
 .db 238
 .db 17
 .db 196
 .db 181
 .db 125
 .db 135
 .db 44
 .db 219
 .db 31
 .db 231
 .db 61
 .db 238
 .db 87
 .db 92
 .db 175
 .db 76
 .db 252
 .db 158
 .db 122
 .db 159
 .db 88
 .db 255
 .db 14
 .db 129
 .db 193
 .db 105
 .db 254
 .db 104
 .db 22
 .db 70
 .db 17
 .db 151
 .db 255
 .db 183
 .db 230
 .db 241
 .db 249
 .db 69
 .db 59
 .db 209
 .db 247
 .db 176
 .db 3
 .db 226
 .db 77
 .db 7
 .db 207
 .db 255
 .db 246
 .db 11
 .db 156
 .db 123
 .db 117
 .db 4
 .db 122
 .db 213
 .db 52
 .db 37
 .db 88
 .db 236
 .db 188
 .db 88
 .db 160
 .db 42
 .db 231
 .db 48
 .db 12
 .db 30
 .db 19
 .db 247
 .db 3
 .db 7
 .db 158
 .db 248
 .db 126
 .db 113
 .db 254
 .db 239
 .db 192
 .db 33
 .db 251
 .db 255
 .db 191
 .db 143
 .db 135
 .db 225
 .db 248
 .db 92
 .db 185
 .db 103
 .db 255
 .db 220
 .db 187
 .db 119
 .db 112
 .db 123
 .db 191
 .db 207
 .db 246
 .db 247
 .db 248
 .db 124
 .db 152
 .db 224
 .db 235
 .db 204
 .db 31
 .db 191
 .db 103
 .db 242
 .db 119
 .db 32
 .db 62
 .db 96
 .db 112
 .db 60
 .db 120
 .db 114
 .db 197
 .db 53
 .db 248
 .db 137
 .db 173
 .db 255
 .db 249
 .db 142
 .db 255
 .db 131
 .db 66
 .db 43
 .db 120
 .db 47
 .db 63
 .db 30
 .db 254
 .db 12
 .db 4
 .db 192
 .db 240
 .db 195
 .db 240
 .db 1
 .db 31
 .db 247
 .db 204
 .db 51
 .db 206
 .db 53
 .db 180
 .db 235
 .db 150
 .db 39
 .db 84
 .db 184
 .db 184
 .db 26
 .db 195
 .db 236
 .db 143
 .db 50
 .db 64
 .db 92
 .db 243
 .db 85
 .db 240
 .db 187
 .db 96
 .db 101
 .db 222
 .db 239
 .db 151
 .db 244
 .db 24
 .db 255
 .db 102
 .db 21
 .db 159
 .db 93
 .db 49
 .db 151
 .db 189
 .db 232
 .db 255
 .db 48
 .db 156
 .db 249
 .db 107
 .db 169
 .db 11
 .db 124
 .db 255
 .db 100
 .db 126
 .db 250
 .db 240
 .db 201
 .db 227
 .db 225
 .db 139
 .db 188
 .db 218
 .db 251
 .db 129
 .db 1
 .db 249
 .db 195
 .db 157
 .db 97
 .db 65
 .db 255
 .db 139
 .db 242
 .db 68
 .db 160
 .db 212
 .db 254
 .db 88
 .db 78
 .db 103
 .db 150
 .db 41
 .db 31
 .db 224
 .db 1
 .db 103
 .db 237
 .db 255
 .db 121
 .db 255
 .db 133
 .db 108
 .db 255
 .db 252
 .db 254
 .db 15
 .db 120
 .db 112
 .db 48
 .db 16
 .db 44
 .db 255
 .db 17
 .db 12
 .db 121
 .db 87
 .db 44
 .db 41
 .db 14
 .db 179
 .db 255
 .db 31
 .db 203
 .db 41
 .db 3
 .db 104
 .db 4
 .db 195
 .db 252
 .db 176
 .db 41
 .db 47
 .db 76
 .db 20
 .db 63
 .db 203
 .db 41
 .db 2
 .db 244
 .db 20
 .db 195
 .db 252
 .db 176
 .db 41
 .db 47
 .db 76
 .db 20
 .db 63
 .db 203
 .db 41
 .db 2
 .db 244
 .db 16
 .db 195
 .db 252
 .db 176
 .db 41
 .db 192
 .db 171
 .db 192
 .db 253
 .db 48
 .db 255
 .db 8

imgTitle_colors:
 .db 0
 .db 96
 .db 84
 .db 172
 .db 255
 .db 64
 .db 195
 .db 255
 .db 3
 .db 244
 .db 255
 .db 192
 .db 253
 .db 48
 .db 255
 .db 63
 .db 86
 .db 255
 .db 16
 .db 166
 .db 255
 .db 7
 .db 89
 .db 17
 .db 129
 .db 200
 .db 21
 .db 103
 .db 152
 .db 255
 .db 51
 .db 45
 .db 3
 .db 144
 .db 22
 .db 255
 .db 80
 .db 231
 .db 252
 .db 153
 .db 253
 .db 70
 .db 254
 .db 134
 .db 253
 .db 198
 .db 252
 .db 10
 .db 139
 .db 255
 .db 16
 .db 7
 .db 19
 .db 255
 .db 67
 .db 8
 .db 13
 .db 13
 .db 0
 .db 255
 .db 248
 .db 128
 .db 101
 .db 173
 .db 255
 .db 16
 .db 141
 .db 248
 .db 207
 .db 252
 .db 53
 .db 253
 .db 51
 .db 254
 .db 140
 .db 255
 .db 147
 .db 116
 .db 2
 .db 212
 .db 0
 .db 88
 .db 60
 .db 84
 .db 0
 .db 70
 .db 254
 .db 11
 .db 38
 .db 0
 .db 22
 .db 224
 .db 168
 .db 176
 .db 27
 .db 248
 .db 0
 .db 140
 .db 62
 .db 48
 .db 51
 .db 0
 .db 76
 .db 78
 .db 26
 .db 140
 .db 14
 .db 243
 .db 255
 .db 13
 .db 13
 .db 0
 .db 204
 .db 6
 .db 53
 .db 2
 .db 0
 .db 203
 .db 48
 .db 64
 .db 125
 .db 251
 .db 252
 .db 23
 .db 2
 .db 0
 .db 197
 .db 200
 .db 0
 .db 41
 .db 193
 .db 44
 .db 0
 .db 243
 .db 255
 .db 4
 .db 195
 .db 0
 .db 115
 .db 177
 .db 5
 .db 95
 .db 48
 .db 0
 .db 80
 .db 35
 .db 0
 .db 255
 .db 14
 .db 76
 .db 0
 .db 54
 .db 243
 .db 245
 .db 17
 .db 50
 .db 0
 .db 76
 .db 51
 .db 243
 .db 0
 .db 115
 .db 7
 .db 5
 .db 3
 .db 0
 .db 15
 .db 250
 .db 245
 .db 193
 .db 23
 .db 204
 .db 0
 .db 116
 .db 32
 .db 193
 .db 120
 .db 0
 .db 140
 .db 255
 .db 25
 .db 244
 .db 1
 .db 195
 .db 127
 .db 48
 .db 0
 .db 252
 .db 0
 .db 136
 .db 253
 .db 252
 .db 208
 .db 0
 .db 193
 .db 247
 .db 236
 .db 252
 .db 27
 .db 190
 .db 0
 .db 207
 .db 48
 .db 0
 .db 119
 .db 251
 .db 252
 .db 13
 .db 56
 .db 0
 .db 195
 .db 211
 .db 0
 .db 19
 .db 235
 .db 76
 .db 7
 .db 175
 .db 48
 .db 249
 .db 168
 .db 0
 .db 195
 .db 175
 .db 190
 .db 0
 .db 236
 .db 18
 .db 234
 .db 176
 .db 11
 .db 139
 .db 140
 .db 95
 .db 8
 .db 238
 .db 176
 .db 0
 .db 220
 .db 0
 .db 196
 .db 168
 .db 10
 .db 140
 .db 32
 .db 24
 .db 63
 .db 252
 .db 0
 .db 160
 .db 192
 .db 254
 .db 110
 .db 50
 .db 250
 .db 214
 .db 255
 .db 144
 .db 13
 .db 103
 .db 0
 .db 153
 .db 254
 .db 107
 .db 4
 .db 128
 .db 10
 .db 244
 .db 75
 .db 195
 .db 227
 .db 0
 .db 204
 .db 254
 .db 72
 .db 255
 .db 207
 .db 243
 .db 41
 .db 24
 .db 48
 .db 0
 .db 93
 .db 227
 .db 0
 .db 31
 .db 48
 .db 255
 .db 79
 .db 49
 .db 0
 .db 63
 .db 176
 .db 0
 .db 91
 .db 51
 .db 0
 .db 81
 .db 102
 .db 64
 .db 152
 .db 156
 .db 24
 .db 109
 .db 207
 .db 216
 .db 252
 .db 37
 .db 24
 .db 0
 .db 55
 .db 237
 .db 0
 .db 154
 .db 103
 .db 108
 .db 17
 .db 97
 .db 111
 .db 216
 .db 252
 .db 106
 .db 0
 .db 97
 .db 255
 .db 88
 .db 0
 .db 127
 .db 102
 .db 0
 .db 121
 .db 210
 .db 134
 .db 7
 .db 3
 .db 152
 .db 255
 .db 45
 .db 121
 .db 0
 .db 231
 .db 245
 .db 25
 .db 255
 .db 230
 .db 0
 .db 31
 .db 225
 .db 0
 .db 141
 .db 214
 .db 76
 .db 64
 .db 193
 .db 127
 .db 114
 .db 248
 .db 192
 .db 254
 .db 197
 .db 12
 .db 255
 .db 179
 .db 63
 .db 4
 .db 107
 .db 177
 .db 0
 .db 101
 .db 223
 .db 144
 .db 148
 .db 255
 .db 128
 .db 0
 .db 193
 .db 139
 .db 133
 .db 0
 .db 8
 .db 224
 .db 254
 .db 24
 .db 161
 .db 0
 .db 133
 .db 126
 .db 0
 .db 97
 .db 215
 .db 192
 .db 0
 .db 177
 .db 144
 .db 99
 .db 255
 .db 5
 .db 179
 .db 3
 .db 113
 .db 0
 .db 254
 .db 96
 .db 233
 .db 214
 .db 0
 .db 62
 .db 0
 .db 97
 .db 161
 .db 4
 .db 135
 .db 231
 .db 0
 .db 152
 .db 255
 .db 50
 .db 97
 .db 0
 .db 152
 .db 113
 .db 97
 .db 215
 .db 216
 .db 7
 .db 63
 .db 208
 .db 0
 .db 176
 .db 229
 .db 228
 .db 0
 .db 207
 .db 227
 .db 0
 .db 7
 .db 201
 .db 176
 .db 255
 .db 188
 .db 0
 .db 140
 .db 255
 .db 49
 .db 243
 .db 0
 .db 24
 .db 48
 .db 210
 .db 126
 .db 155
 .db 3
 .db 13
 .db 32
 .db 0
 .db 194
 .db 208
 .db 0
 .db 12
 .db 50
 .db 48
 .db 0
 .db 100
 .db 131
 .db 3
 .db 13
 .db 0
 .db 0
 .db 48
 .db 199
 .db 140
 .db 0
 .db 80
 .db 127
 .db 198
 .db 204
 .db 4
 .db 9
 .db 127
 .db 128
 .db 0
 .db 193
 .db 103
 .db 204
 .db 0
 .db 56
 .db 48
 .db 53
 .db 200
 .db 255
 .db 195
 .db 19
 .db 0
 .db 140
 .db 1
 .db 21
 .db 140
 .db 0
 .db 53
 .db 55
 .db 7
 .db 48
 .db 245
 .db 95
 .db 55
 .db 0
 .db 251
 .db 252
 .db 4
 .db 83
 .db 0
 .db 5
 .db 143
 .db 176
 .db 7
 .db 143
 .db 236
 .db 237
 .db 26
 .db 58
 .db 0
 .db 198
 .db 207
 .db 0
 .db 48
 .db 4
 .db 105
 .db 243
 .db 7
 .db 15
 .db 207
 .db 0
 .db 48
 .db 255
 .db 70
 .db 48
 .db 0
 .db 248
 .db 4
 .db 193
 .db 212
 .db 0
 .db 3
 .db 10
 .db 204
 .db 0
 .db 24
 .db 204
 .db 255
 .db 26
 .db 204
 .db 0
 .db 16
 .db 251
 .db 0
 .db 16
 .db 96
 .db 248
 .db 255
 .db 97
 .db 223
 .db 192
 .db 0
 .db 96
 .db 152
 .db 255
 .db 98
 .db 198
 .db 92
 .db 7
 .db 234
 .db 255
 .db 80
 .db 192
 .db 248
 .db 49
 .db 255
 .db 63
 .db 176
 .db 252
 .db 63
 .db 76
 .db 255
 .db 18
 .db 190
 .db 237
 .db 192
 .db 253
 .db 48
 .db 255
 .db 63
 .db 76
 .db 255
 .db 15
 .db 211
 .db 255
 .db 3
 .db 244
 .db 255
 .db 192
 .db 32

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
 .db 99
 .db 70
 .db 255
 .db 19
 .db 54
 .db 214
 .db 128
 .db 0
 .db 5
 .db 194
 .db 255
 .db 128
 .db 198
 .db 18
 .db 41
 .db 0
 .db 39
 .db 200
 .db 22
 .db 255
 .db 242
 .db 255
 .db 234
 .db 178
 .db 253
 .db 151
 .db 255
 .db 254
 .db 24
 .db 215
 .db 23
 .db 39
 .db 255
 .db 189
 .db 41
 .db 248
 .db 247
 .db 246
 .db 245
 .db 148
 .db 255
 .db 239
 .db 244
 .db 240
 .db 248
 .db 27
 .db 0
 .db 226
 .db 8
 .db 210
 .db 255
 .db 15
 .db 247
 .db 220
 .db 0
 .db 140
 .db 247
 .db 160
 .db 194
 .db 12
 .db 17
 .db 211
 .db 0
 .db 1
 .db 255
 .db 3
 .db 104
 .db 255
 .db 143
 .db 7
 .db 6
 .db 115
 .db 255
 .db 4
 .db 1
 .db 97
 .db 217
 .db 176
 .db 6
 .db 185
 .db 18
 .db 1
 .db 194
 .db 51
 .db 0
 .db 71
 .db 57
 .db 131
 .db 191
 .db 190
 .db 138
 .db 135
 .db 90
 .db 252
 .db 26
 .db 47
 .db 177
 .db 23
 .db 188
 .db 162
 .db 220
 .db 253
 .db 176
 .db 128
 .db 85
 .db 78
 .db 0
 .db 1
 .db 91
 .db 15
 .db 31
 .db 60
 .db 63
 .db 127
 .db 95
 .db 79
 .db 227
 .db 249
 .db 180
 .db 252
 .db 3
 .db 161
 .db 243
 .db 255
 .db 225
 .db 132
 .db 42
 .db 85
 .db 170
 .db 65
 .db 156
 .db 38
 .db 255
 .db 175
 .db 63
 .db 127
 .db 159
 .db 224
 .db 252
 .db 223
 .db 173
 .db 26
 .db 171
 .db 240
 .db 252
 .db 78
 .db 48
 .db 248
 .db 164
 .db 252
 .db 105
 .db 195
 .db 227
 .db 173
 .db 63
 .db 176
 .db 7
 .db 133
 .db 0
 .db 1
 .db 129
 .db 252
 .db 248
 .db 56
 .db 255
 .db 184
 .db 56
 .db 201
 .db 255
 .db 8
 .db 68
 .db 246
 .db 103
 .db 106
 .db 23
 .db 199
 .db 251
 .db 128
 .db 146
 .db 224
 .db 253
 .db 239
 .db 193
 .db 13
 .db 0
 .db 2
 .db 140
 .db 7
 .db 46
 .db 117
 .db 250
 .db 62
 .db 218
 .db 170
 .db 56
 .db 190
 .db 122
 .db 58
 .db 0
 .db 63
 .db 120
 .db 7
 .db 98
 .db 221
 .db 210
 .db 254
 .db 226
 .db 247
 .db 239
 .db 223
 .db 126
 .db 255
 .db 224
 .db 191
 .db 192
 .db 127
 .db 3
 .db 188
 .db 139
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
 .db 152
 .db 240
 .db 203
 .db 224
 .db 44
 .db 56
 .db 108
 .db 255
 .db 31
 .db 224
 .db 32
 .db 49
 .db 98
 .db 174
 .db 163
 .db 0
 .db 130
 .db 78
 .db 176
 .db 2
 .db 72
 .db 246
 .db 0
 .db 112
 .db 248
 .db 62
 .db 216
 .db 168
 .db 56
 .db 185
 .db 240
 .db 224
 .db 165
 .db 143
 .db 192
 .db 48
 .db 253
 .db 220
 .db 94
 .db 95
 .db 63
 .db 127
 .db 191
 .db 2
 .db 0
 .db 248
 .db 235
 .db 16
 .db 228
 .db 206
 .db 31
 .db 2
 .db 194
 .db 14
 .db 255
 .db 240
 .db 248
 .db 249
 .db 242
 .db 197
 .db 202
 .db 213
 .db 200
 .db 132
 .db 225
 .db 254
 .db 112
 .db 165
 .db 1
 .db 63
 .db 253
 .db 74
 .db 247
 .db 60
 .db 252
 .db 254
 .db 3
 .db 10
 .db 75
 .db 252
 .db 155
 .db 86
 .db 193
 .db 63
 .db 14
 .db 157
 .db 0
 .db 3
 .db 253
 .db 5
 .db 144
 .db 255
 .db 216
 .db 253
 .db 3
 .db 122
 .db 0
 .db 198
 .db 6
 .db 15
 .db 105
 .db 230
 .db 14
 .db 111
 .db 99
 .db 108
 .db 128
 .db 199
 .db 192
 .db 252
 .db 225
 .db 211
 .db 152
 .db 61
 .db 125
 .db 253
 .db 127
 .db 108
 .db 79
 .db 198
 .db 128
 .db 197
 .db 0
 .db 64
 .db 120
 .db 254
 .db 14
 .db 192
 .db 96
 .db 224
 .db 63
 .db 240
 .db 200
 .db 56
 .db 95
 .db 210
 .db 97
 .db 171
 .db 254
 .db 246
 .db 207
 .db 61
 .db 2
 .db 254
 .db 252
 .db 224
 .db 143
 .db 24
 .db 104
 .db 95
 .db 238
 .db 171
 .db 7
 .db 251
 .db 11
 .db 200
 .db 108
 .db 255
 .db 251
 .db 7
 .db 33
 .db 99
 .db 0
 .db 64
 .db 224
 .db 28
 .db 255
 .db 76
 .db 254
 .db 100
 .db 250
 .db 49
 .db 45
 .db 248
 .db 197
 .db 13
 .db 156
 .db 255
 .db 244
 .db 128
 .db 176
 .db 16
 .db 240
 .db 255
 .db 179
 .db 0
 .db 192
 .db 231
 .db 48
 .db 96
 .db 219
 .db 0
 .db 15
 .db 178
 .db 0
 .db 192
 .db 190
 .db 211
 .db 0
 .db 9
 .db 242
 .db 0
 .db 198
 .db 159
 .db 0
 .db 63
 .db 32
 .db 47
 .db 42
 .db 45
 .db 103
 .db 24
 .db 254
 .db 19
 .db 235
 .db 236
 .db 63
 .db 8
 .db 51
 .db 0
 .db 15
 .db 105
 .db 130
 .db 255
 .db 247
 .db 199
 .db 9
 .db 0
 .db 226
 .db 170
 .db 179
 .db 85
 .db 140
 .db 254
 .db 10
 .db 3
 .db 236
 .db 55
 .db 60
 .db 0
 .db 190
 .db 191
 .db 135
 .db 81
 .db 25
 .db 153
 .db 0
 .db 156
 .db 161
 .db 255
 .db 159
 .db 129
 .db 123
 .db 190
 .db 3
 .db 121
 .db 0
 .db 254
 .db 2
 .db 252
 .db 113
 .db 255
 .db 28
 .db 236
 .db 197
 .db 52
 .db 250
 .db 12
 .db 246
 .db 100
 .db 55
 .db 0
 .db 125
 .db 17
 .db 153
 .db 255
 .db 201
 .db 0
 .db 249
 .db 255
 .db 163
 .db 248
 .db 252
 .db 37
 .db 0
 .db 239
 .db 217
 .db 170
 .db 77
 .db 198
 .db 254
 .db 4
 .db 249
 .db 236
 .db 184
 .db 0
 .db 75
 .db 127
 .db 56
 .db 255
 .db 201
 .db 214
 .db 23
 .db 224
 .db 16
 .db 56
 .db 172
 .db 230
 .db 0
 .db 230
 .db 228
 .db 60
 .db 4
 .db 132
 .db 253
 .db 192
 .db 195
 .db 251
 .db 0
 .db 23
 .db 118
 .db 255
 .db 1
 .db 254
 .db 2
 .db 67
 .db 255
 .db 254
 .db 1
 .db 101
 .db 55
 .db 229
 .db 12
 .db 228
 .db 2
 .db 255
 .db 96
 .db 107
 .db 24
 .db 0
 .db 251
 .db 255
 .db 6
 .db 242
 .db 29
 .db 198
 .db 253
 .db 5
 .db 231
 .db 152
 .db 0
 .db 114
 .db 0
 .db 156
 .db 126
 .db 255
 .db 6
 .db 114
 .db 113
 .db 88
 .db 27
 .db 159
 .db 0
 .db 236
 .db 128
 .db 127
 .db 64
 .db 133
 .db 255
 .db 127
 .db 151
 .db 12
 .db 215
 .db 64
 .db 79
 .db 119
 .db 24
 .db 253
 .db 24
 .db 204
 .db 0
 .db 252
 .db 251
 .db 123
 .db 250
 .db 45
 .db 255
 .db 248
 .db 181
 .db 252
 .db 230
 .db 0
 .db 3
 .db 4
 .db 130
 .db 221
 .db 4
 .db 200
 .db 229
 .db 0
 .db 248
 .db 235
 .db 255
 .db 120
 .db 36
 .db 250
 .db 192
 .db 193
 .db 243
 .db 0
 .db 70
 .db 34
 .db 193
 .db 223
 .db 61
 .db 195
 .db 77
 .db 117
 .db 151
 .db 156
 .db 0
 .db 159
 .db 80
 .db 119
 .db 28
 .db 253
 .db 30
 .db 98
 .db 214
 .db 20
 .db 96
 .db 98
 .db 97
 .db 0
 .db 87
 .db 30
 .db 142
 .db 118
 .db 198
 .db 246
 .db 238
 .db 16
 .db 36
 .db 246
 .db 100
 .db 49
 .db 0
 .db 34
 .db 162
 .db 241
 .db 30
 .db 130
 .db 236
 .db 60
 .db 13
 .db 214
 .db 0
 .db 127
 .db 63
 .db 206
 .db 90
 .db 255
 .db 127
 .db 163
 .db 0
 .db 136
 .db 227
 .db 144
 .db 224
 .db 22
 .db 251
 .db 66
 .db 0
 .db 24
 .db 207
 .db 48
 .db 255
 .db 53
 .db 246
 .db 0
 .db 108
 .db 229
 .db 1
 .db 131
 .db 255
 .db 3
 .db 99
 .db 236
 .db 0
 .db 96
 .db 255
 .db 204
 .db 179
 .db 238
 .db 3
 .db 180
 .db 0
 .db 207
 .db 48
 .db 255
 .db 59
 .db 253
 .db 0
 .db 192
 .db 217
 .db 191
 .db 160
 .db 13
 .db 255
 .db 191
 .db 192
 .db 129
 .db 179
 .db 253
 .db 0
 .db 254
 .db 253
 .db 154
 .db 255
 .db 218
 .db 252
 .db 254
 .db 242
 .db 0
 .db 31
 .db 210
 .db 108
 .db 0
 .db 13
 .db 253
 .db 87
 .db 0
 .db 128
 .db 113
 .db 30
 .db 96
 .db 111
 .db 226
 .db 97
 .db 148
 .db 255
 .db 246
 .db 100
 .db 107
 .db 0
 .db 56
 .db 69
 .db 114
 .db 255
 .db 59
 .db 200
 .db 94
 .db 0
 .db 31
 .db 255
 .db 180
 .db 28
 .db 60
 .db 255
 .db 244
 .db 192
 .db 199
 .db 196
 .db 0
 .db 187
 .db 229
 .db 255
 .db 131
 .db 251
 .db 255
 .db 151
 .db 141
 .db 0
 .db 227
 .db 20
 .db 203
 .db 255
 .db 251
 .db 62
 .db 79
 .db 0
 .db 108
 .db 255
 .db 2
 .db 243
 .db 12
 .db 91
 .db 118
 .db 0
 .db 63
 .db 159
 .db 31
 .db 106
 .db 255
 .db 63
 .db 213
 .db 0
 .db 145
 .db 227
 .db 81
 .db 18
 .db 28
 .db 8
 .db 19
 .db 56
 .db 0
 .db 168
 .db 3
 .db 192
 .db 224
 .db 162
 .db 0
 .db 54
 .db 224
 .db 51
 .db 255
 .db 152
 .db 0
 .db 4
 .db 127
 .db 244
 .db 7
 .db 253
 .db 96
 .db 110
 .db 75
 .db 0
 .db 127
 .db 191
 .db 101
 .db 44
 .db 255
 .db 127
 .db 166
 .db 229
 .db 3
 .db 158
 .db 243
 .db 255
 .db 3
 .db 222
 .db 24
 .db 0
 .db 7
 .db 115
 .db 241
 .db 3
 .db 75
 .db 255
 .db 3
 .db 113
 .db 0
 .db 224
 .db 217
 .db 223
 .db 208
 .db 13
 .db 255
 .db 223
 .db 224
 .db 136
 .db 152
 .db 222
 .db 24
 .db 254
 .db 0
 .db 179
 .db 254
 .db 141
 .db 255
 .db 187
 .db 0
 .db 243
 .db 143
 .db 138
 .db 139
 .db 238
 .db 242
 .db 130
 .db 131
 .db 49
 .db 30
 .db 99
 .db 2
 .db 3
 .db 15
 .db 53
 .db 0
 .db 192
 .db 220
 .db 30
 .db 176
 .db 183
 .db 116
 .db 253
 .db 13
 .db 45
 .db 246
 .db 128
 .db 245
 .db 0
 .db 232
 .db 227
 .db 8
 .db 9
 .db 206
 .db 8
 .db 19
 .db 3
 .db 120
 .db 0
 .db 245
 .db 34
 .db 65
 .db 66
 .db 0
 .db 253
 .db 56
 .db 172
 .db 188
 .db 242
 .db 0
 .db 158
 .db 161
 .db 33
 .db 255
 .db 32
 .db 76
 .db 121
 .db 0
 .db 248
 .db 246
 .db 8
 .db 232
 .db 168
 .db 72
 .db 113
 .db 254
 .db 129
 .db 62
 .db 236
 .db 182
 .db 248
 .db 123
 .db 0
 .db 31
 .db 207
 .db 15
 .db 143
 .db 41
 .db 255
 .db 15
 .db 30
 .db 31
 .db 213
 .db 0
 .db 120
 .db 87
 .db 2
 .db 236
 .db 121
 .db 65
 .db 67
 .db 116
 .db 0
 .db 192
 .db 183
 .db 49
 .db 255
 .db 252
 .db 238
 .db 0
 .db 224
 .db 16
 .db 89
 .db 255
 .db 248
 .db 78
 .db 0
 .db 248
 .db 247
 .db 244
 .db 200
 .db 108
 .db 255
 .db 247
 .db 248
 .db 13
 .db 135
 .db 0
 .db 63
 .db 223
 .db 95
 .db 100
 .db 54
 .db 255
 .db 223
 .db 63
 .db 43
 .db 118
 .db 233
 .db 4
 .db 187
 .db 0
 .db 3
 .db 7
 .db 34
 .db 255
 .db 88
 .db 1
 .db 110
 .db 0
 .db 103
 .db 152
 .db 255
 .db 21
 .db 207
 .db 0
 .db 127
 .db 159
 .db 227
 .db 252
 .db 95
 .db 59
 .db 176
 .db 7
 .db 221
 .db 0
 .db 240
 .db 217
 .db 239
 .db 232
 .db 13
 .db 255
 .db 239
 .db 240
 .db 129
 .db 92
 .db 0
 .db 119
 .db 29
 .db 40
 .db 134
 .db 75
 .db 29
 .db 247
 .db 0
 .db 68
 .db 69
 .db 30
 .db 125
 .db 182
 .db 253
 .db 227
 .db 23
 .db 2
 .db 193
 .db 0
 .db 254
 .db 216
 .db 193
 .db 63
 .db 70
 .db 0
 .db 81
 .db 2
 .db 174
 .db 96
 .db 227
 .db 29
 .db 88
 .db 91
 .db 160
 .db 253
 .db 105
 .db 246
 .db 64
 .db 218
 .db 0
 .db 128
 .db 177
 .db 23
 .db 228
 .db 20
 .db 235
 .db 247
 .db 108
 .db 255
 .db 11
 .db 38
 .db 0
 .db 246
 .db 207
 .db 123
 .db 2
 .db 254
 .db 252
 .db 224
 .db 26
 .db 51
 .db 221
 .db 51
 .db 0
 .db 49
 .db 143
 .db 239
 .db 97
 .db 143
 .db 238
 .db 241
 .db 101
 .db 231
 .db 0
 .db 78
 .db 81
 .db 30
 .db 223
 .db 41
 .db 255
 .db 101
 .db 59
 .db 0
 .db 31
 .db 239
 .db 47
 .db 33
 .db 255
 .db 239
 .db 176
 .db 31
 .db 48
 .db 183
 .db 0
 .db 15
 .db 236
 .db 231
 .db 7
 .db 199
 .db 164
 .db 255
 .db 7
 .db 123
 .db 15
 .db 86
 .db 0
 .db 56
 .db 69
 .db 229
 .db 255
 .db 68
 .db 129
 .db 251
 .db 144
 .db 0
 .db 152
 .db 227
 .db 0
 .db 127
 .db 63
 .db 176
 .db 31
 .db 45
 .db 155
 .db 255
 .db 63
 .db 127
 .db 10
 .db 243
 .db 0
 .db 192
 .db 96
 .db 126
 .db 152
 .db 255
 .db 4

imgScreen_colors:
 .db 0
 .db 96
 .db 120
 .db 24
 .db 255
 .db 31
 .db 166
 .db 255
 .db 7
 .db 234
 .db 255
 .db 144
 .db 216
 .db 255
 .db 193
 .db 129
 .db 149
 .db 80
 .db 96
 .db 154
 .db 255
 .db 96
 .db 81
 .db 24
 .db 0
 .db 249
 .db 59
 .db 129
 .db 149
 .db 247
 .db 0
 .db 172
 .db 18
 .db 16
 .db 147
 .db 255
 .db 8
 .db 254
 .db 57
 .db 192
 .db 205
 .db 243
 .db 0
 .db 11
 .db 140
 .db 0
 .db 12
 .db 46
 .db 51
 .db 187
 .db 204
 .db 7
 .db 40
 .db 251
 .db 251
 .db 3
 .db 108
 .db 5
 .db 207
 .db 248
 .db 250
 .db 12
 .db 28
 .db 76
 .db 255
 .db 17
 .db 12
 .db 29
 .db 15
 .db 213
 .db 255
 .db 192
 .db 129
 .db 112
 .db 255
 .db 97
 .db 47
 .db 24
 .db 0
 .db 30
 .db 230
 .db 0
 .db 7
 .db 233
 .db 0
 .db 129
 .db 250
 .db 0
 .db 70
 .db 255
 .db 7
 .db 217
 .db 0
 .db 143
 .db 152
 .db 255
 .db 31
 .db 166
 .db 0
 .db 7
 .db 233
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 237
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 152
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 239
 .db 24
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 233
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 241
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 152
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 239
 .db 24
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 233
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 241
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 152
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 97
 .db 255
 .db 143
 .db 152
 .db 0
 .db 31
 .db 166
 .db 255
 .db 7
 .db 233
 .db 255
 .db 129
 .db 250
 .db 255
 .db 96
 .db 126
 .db 245
 .db 0
 .db 129
 .db 250
 .db 0
 .db 96
 .db 126
 .db 152
 .db 0
 .db 31
 .db 166
 .db 0
 .db 7
 .db 233
 .db 0
 .db 129
 .db 250
 .db 255
 .db 96
 .db 126
 .db 152
 .db 255
 .db 4

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
 .db 170
 .db 85
 .db 170
 .db 64
 .db 138
 .db 32
 .db 142
 .db 94
 .db 142
 .db 70
 .db 166
 .db 80
 .db 166
 .db 80
 .db 170
 .db 5
 .db 80
 .db 5
 .db 112
 .db 121
 .db 114
 .db 101
 .db 106
 .db 5
 .db 106
 .db 5
 .db 170
 .db 85
 .db 160
 .db 86
 .db 160
 .db 86
 .db 166
 .db 78
 .db 158
 .db 14
 .db 160
 .db 10
 .db 160
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 10
 .db 101
 .db 10
 .db 101
 .db 98
 .db 113
 .db 122
 .db 113
 .db 4
 .db 81
 .db 2
 .db 85
 .db 162
 .db 72
 .db 130
 .db 87
 .db 135
 .db 87
 .db 128
 .db 80
 .db 165
 .db 81
 .db 165
 .db 80
 .db 170
 .db 80
 .db 170
 .db 85
 .db 42
 .db 5
 .db 210
 .db 213
 .db 2
 .db 1
 .db 244
 .db 245
 .db 192
 .db 149
 .db 42
 .db 85
 .db 170
 .db 85
 .db 170
 .db 64
 .db 171
 .db 75
 .db 160
 .db 0
 .db 175
 .db 47
 .db 131
 .db 81
 .db 168
 .db 85
 .db 130
 .db 21
 .db 66
 .db 233
 .db 226
 .db 233
 .db 2
 .db 5
 .db 170
 .db 133
 .db 170
 .db 5
 .db 74
 .db 21
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85
 .db 170
 .db 85

imgPlayerD:
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 173
 .db 0
 .db 223
 .db 0
 .db 171
 .db 0
 .db 223
 .db 0
 .db 255
 .db 0
 .db 255
 .db 0
 .db 255
 .db 0
 .db 255
 .db 0
 .db 253
 .db 0
 .db 255
 .db 0
 .db 254
 .db 0
 .db 255
 .db 0
 .db 168
 .db 0
 .db 216
 .db 0
 .db 168
 .db 0
 .db 216

imgPlayer:
 .db 16
 .db 16
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 56
 .db 16
 .db 130
 .db 16
 .db 254
 .db 16
 .db 218
 .db 16
 .db 138
 .db 64
 .db 96
 .db 64
 .db 96
 .db 64
 .db 64
 .db 64
 .db 124
 .db 64
 .db 125
 .db 64
 .db 125
 .db 64
 .db 125
 .db 64
 .db 1
 .db 16
 .db 56
 .db 16
 .db 124
 .db 16
 .db 56
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 64
 .db 1
 .db 64
 .db 3
 .db 64
 .db 7
 .db 64
 .db 15
 .db 64
 .db 15
 .db 64
 .db 31
 .db 64
 .db 31
 .db 64
 .db 63
 .db 64
 .db 95
 .db 64
 .db 79
 .db 64
 .db 230
 .db 64
 .db 240
 .db 64
 .db 249
 .db 64
 .db 251
 .db 64
 .db 183
 .db 64
 .db 23
 .db 64
 .db 27
 .db 64
 .db 11
 .db 64
 .db 1
 .db 64
 .db 16
 .db 64
 .db 8
 .db 64
 .db 20
 .db 64
 .db 10
 .db 64
 .db 21
 .db 64
 .db 10
 .db 64
 .db 21
 .db 64
 .db 0
 .db 64
 .db 28
 .db 64
 .db 50
 .db 64
 .db 59
 .db 64
 .db 63
 .db 64
 .db 63
 .db 64
 .db 31
 .db 0
 .db 224
 .db 0
 .db 252
 .db 0
 .db 223
 .db 0
 .db 0
 .db 64
 .db 1
 .db 64
 .db 0
 .db 64
 .db 0
 .db 64
 .db 0
 .db 64
 .db 0
 .db 64
 .db 3
 .db 64
 .db 4
 .db 64
 .db 7
 .db 64
 .db 9
 .db 64
 .db 8
 .db 64
 .db 7
 .db 64
 .db 31
 .db 64
 .db 98
 .db 64
 .db 221
 .db 64
 .db 210
 .db 64
 .db 210
 .db 64
 .db 226
 .db 64
 .db 247
 .db 64
 .db 239
 .db 64
 .db 223
 .db 64
 .db 223
 .db 64
 .db 223
 .db 64
 .db 224
 .db 64
 .db 191
 .db 64
 .db 64
 .db 64
 .db 63
 .db 64
 .db 158
 .db 64
 .db 192
 .db 64
 .db 223
 .db 64
 .db 159
 .db 64
 .db 128
 .db 64
 .db 63
 .db 64
 .db 127
 .db 64
 .db 255
 .db 64
 .db 255
 .db 64
 .db 127
 .db 64
 .db 31
 .db 64
 .db 152
 .db 64
 .db 89
 .db 64
 .db 154
 .db 64
 .db 57
 .db 64
 .db 120
 .db 64
 .db 251
 .db 64
 .db 252
 .db 64
 .db 252
 .db 64
 .db 248
 .db 64
 .db 0
 .db 64
 .db 0
 .db 0
 .db 224
 .db 64
 .db 128
 .db 64
 .db 192
 .db 64
 .db 128
 .db 64
 .db 192
 .db 64
 .db 64
 .db 64
 .db 192
 .db 64
 .db 128
 .db 64
 .db 0
 .db 64
 .db 128
 .db 64
 .db 128
 .db 64
 .db 0
 .db 64
 .db 0
 .db 64
 .db 192
 .db 64
 .db 48
 .db 64
 .db 220
 .db 64
 .db 94
 .db 64
 .db 95
 .db 64
 .db 63
 .db 64
 .db 127
 .db 64
 .db 191
 .db 64
 .db 223
 .db 64
 .db 223
 .db 64
 .db 223
 .db 64
 .db 63
 .db 64
 .db 238
 .db 64
 .db 28
 .db 64
 .db 241
 .db 64
 .db 7
 .db 64
 .db 255
 .db 64
 .db 255
 .db 64
 .db 255
 .db 64
 .db 255
 .db 64
 .db 15
 .db 64
 .db 241
 .db 64
 .db 254
 .db 64
 .db 252
 .db 64
 .db 249
 .db 64
 .db 194
 .db 64
 .db 85
 .db 64
 .db 74
 .db 64
 .db 84
 .db 64
 .db 73
 .db 64
 .db 99
 .db 64
 .db 127
 .db 64
 .db 255
 .db 64
 .db 255
 .db 64
 .db 127
 .db 64
 .db 0
 .db 0
 .db 1
 .db 0
 .db 63
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
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 64
 .db 128
 .db 64
 .db 192
 .db 64
 .db 224
 .db 64
 .db 224
 .db 64
 .db 224
 .db 64
 .db 208
 .db 64
 .db 144
 .db 64
 .db 56
 .db 64
 .db 248
 .db 64
 .db 252
 .db 64
 .db 252
 .db 64
 .db 252
 .db 64
 .db 254
 .db 64
 .db 254
 .db 64
 .db 254
 .db 64
 .db 254
 .db 64
 .db 254
 .db 64
 .db 126
 .db 64
 .db 62
 .db 64
 .db 15
 .db 64
 .db 167
 .db 64
 .db 83
 .db 64
 .db 171
 .db 64
 .db 19
 .db 64
 .db 203
 .db 64
 .db 35
 .db 64
 .db 169
 .db 64
 .db 228
 .db 64
 .db 224
 .db 64
 .db 192
 .db 0
 .db 56
 .db 0
 .db 248
 .db 0
 .db 216

imgPlayerWin:
 .db 80
 .db 2
 .db 80
 .db 7
 .db 80
 .db 2
 .db 80
 .db 2
 .db 16
 .db 117
 .db 16
 .db 250
 .db 16
 .db 250
 .db 16
 .db 218
 .db 16
 .db 170
 .db 16
 .db 170
 .db 16
 .db 218
 .db 16
 .db 122
 .db 16
 .db 58
 .db 16
 .db 0
 .db 16
 .db 63
 .db 16
 .db 31
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 0
 .db 16
 .db 112
 .db 16
 .db 248
 .db 16
 .db 248
 .db 16
 .db 216
 .db 16
 .db 168
 .db 16
 .db 168
 .db 16
 .db 216
 .db 16
 .db 240
 .db 16
 .db 224
 .db 16
 .db 0
 .db 16
 .db 224
 .db 16
 .db 192

imgKingLose:
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
 .db 80
 .db 1
 .db 80
 .db 1
 .db 80
 .db 1
 .db 80
 .db 1
 .db 80
 .db 3
 .db 80
 .db 3
 .db 80
 .db 3
 .db 80
 .db 3
 .db 80
 .db 3
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 7
 .db 80
 .db 6
 .db 80
 .db 6
 .db 80
 .db 4
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 1
 .db 80
 .db 7
 .db 80
 .db 15
 .db 80
 .db 31
 .db 80
 .db 63
 .db 80
 .db 63
 .db 80
 .db 127
 .db 80
 .db 127
 .db 80
 .db 127
 .db 80
 .db 191
 .db 80
 .db 207
 .db 80
 .db 243
 .db 80
 .db 253
 .db 80
 .db 254
 .db 80
 .db 255
 .db 80
 .db 195
 .db 80
 .db 189
 .db 80
 .db 189
 .db 80
 .db 190
 .db 80
 .db 190
 .db 80
 .db 191
 .db 80
 .db 223
 .db 80
 .db 239
 .db 80
 .db 240
 .db 80
 .db 227
 .db 80
 .db 195
 .db 80
 .db 129
 .db 80
 .db 0
 .db 0
 .db 96
 .db 0
 .db 252
 .db 0
 .db 223
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
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 80
 .db 1
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 3
 .db 80
 .db 4
 .db 80
 .db 7
 .db 80
 .db 9
 .db 80
 .db 8
 .db 80
 .db 7
 .db 80
 .db 31
 .db 80
 .db 98
 .db 80
 .db 221
 .db 80
 .db 210
 .db 80
 .db 210
 .db 80
 .db 226
 .db 80
 .db 247
 .db 80
 .db 239
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 224
 .db 80
 .db 255
 .db 80
 .db 240
 .db 80
 .db 239
 .db 80
 .db 127
 .db 80
 .db 128
 .db 80
 .db 255
 .db 80
 .db 255
 .db 80
 .db 255
 .db 80
 .db 252
 .db 80
 .db 131
 .db 80
 .db 127
 .db 80
 .db 127
 .db 80
 .db 191
 .db 80
 .db 63
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 15
 .db 80
 .db 0
 .db 80
 .db 0
 .db 0
 .db 224
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
 .db 0
 .db 0
 .db 0
 .db 80
 .db 128
 .db 80
 .db 192
 .db 80
 .db 128
 .db 80
 .db 128
 .db 80
 .db 192
 .db 80
 .db 64
 .db 80
 .db 192
 .db 80
 .db 128
 .db 80
 .db 0
 .db 80
 .db 128
 .db 80
 .db 128
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 224
 .db 80
 .db 56
 .db 80
 .db 222
 .db 80
 .db 95
 .db 80
 .db 95
 .db 80
 .db 63
 .db 80
 .db 127
 .db 80
 .db 191
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 223
 .db 80
 .db 63
 .db 80
 .db 255
 .db 80
 .db 127
 .db 80
 .db 190
 .db 80
 .db 253
 .db 80
 .db 3
 .db 80
 .db 250
 .db 80
 .db 249
 .db 80
 .db 225
 .db 80
 .db 25
 .db 80
 .db 251
 .db 80
 .db 251
 .db 80
 .db 251
 .db 80
 .db 247
 .db 80
 .db 224
 .db 80
 .db 238
 .db 80
 .db 223
 .db 80
 .db 222
 .db 80
 .db 128
 .db 80
 .db 0
 .db 0
 .db 1
 .db 0
 .db 63
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
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 0
 .db 80
 .db 128
 .db 80
 .db 192
 .db 80
 .db 224
 .db 80
 .db 240
 .db 80
 .db 248
 .db 80
 .db 254
 .db 80
 .db 255
 .db 80
 .db 255
 .db 80
 .db 255
 .db 80
 .db 252
 .db 80
 .db 251
 .db 80
 .db 119
 .db 80
 .db 175
 .db 80
 .db 15
 .db 80
 .db 236
 .db 80
 .db 224
 .db 80
 .db 232
 .db 80
 .db 224
 .db 80
 .db 200
 .db 80
 .db 208
 .db 80
 .db 168
 .db 80
 .db 16
 .db 80
 .db 8
 .db 0
 .db 192
 .db 0
 .db 48
 .db 0
 .db 8
 .db 0
 .db 56
 .db 0
 .db 248
 .db 0
 .db 216
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
 .db 80
 .db 192
 .db 80
 .db 240
 .db 80
 .db 248
 .db 80
 .db 248
 .db 80
 .db 224
 .db 80
 .db 128
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0
 .db 80
 .db 0

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
memcpy_back_1:
 .ds 2
memcpy_back_2:
 .ds 2
memcpy_back_3:
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
