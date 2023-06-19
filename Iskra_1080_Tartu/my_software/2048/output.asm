    device zxspectrum48
   org 100h
begin:
entry:
main:
; 322  main(int argc, char *argv[]) {
	; Stack correction reset
	ld (main_2_a), hl

		ld sp, 9000h
		ld hl, 0
		push hl
	
; 323 	asm {
; 324 		ld sp, 9000h
; 325 		ld hl, 0
; 326 		push hl
; 327 	}
; 328 	char c;
; 329 	bool success;
; 330 
; 331     // TODO: if (argc == 2 && strcmp(argv[1],"test")==0) {
; 332     // TODO: 	return test();
; 333     // TODO: }
; 334 
; 335 	initBoard();
	call initBoard
l_0:
; 336 	while (true) {
; 337 		c=getchar();
	call getchar
	ld a, l
	ld (main_s + 0), a
; 338 		if (c == 27) {
	cp 27
	jp nz, l_2
; 339     		c = getchar();
	call getchar
	ld a, l
	ld (main_s + 0), a
; 340     		if (c == '[') {
	cp 91
	jp nz, l_4
; 341         		c = getchar();
	call getchar
	ld a, l
	ld (main_s + 0), a
; 342 		        switch(c) {
	sub 65
	jp z, l_10
	dec a
	jp z, l_9
	dec a
	jp z, l_7
	dec a
	jp z, l_8
	jp l_0
l_10:
; 343 			        case 'A':
; 344 			            c = 'W';
	ld a, 87
	ld (main_s + 0), a
	jp l_6
l_9:
; 345 			            break;
; 346 			        case 'B':
; 347 			            c = 'S';
	ld a, 83
	ld (main_s + 0), a
	jp l_6
l_8:
; 348 			            break;
; 349 			        case 'D':
; 350 			            c = 'A';
	ld a, 65
	ld (main_s + 0), a
	jp l_6
l_7:
; 351 			            break;
; 352 			        case 'C':
; 353 			            c = 'D';
	ld a, 68
	ld (main_s + 0), a
	jp l_6
l_6:
l_4:
l_2:
; 354 			            break;
; 355 			        default:
; 356 			            continue;
; 357 		        }
; 358     		}
; 359         }		
; 360 		switch(c) {
	sub 65
	jp z, l_19
	sub 3
	jp z, l_17
	sub 15
	jp z, l_13
	sub 4
	jp z, l_15
	sub 10
	jp z, l_20
	sub 3
	jp z, l_18
	sub 15
	jp z, l_14
	sub 4
	jp z, l_16
	jp l_21
l_20:
l_19:
; 361 			case 'a':
; 362 			case 'A':
; 363 				success = moveLeft();  break;
	call moveLeft
	ld (main_s + 1), a
	jp l_12
l_18:
l_17:
; 364 			case 'd':
; 365 			case 'D':
; 366 				success = moveRight(); break;
	call moveRight
	ld (main_s + 1), a
	jp l_12
l_16:
l_15:
; 367 			case 'w':
; 368 			case 'W':
; 369 				success = moveUp();    break;
	call moveUp
	ld (main_s + 1), a
	jp l_12
l_14:
l_13:
; 370 			case 's':
; 371 			case 'S':
; 372 				success = moveDown();  break;
	call moveDown
	ld (main_s + 1), a
	jp l_12
l_21:
; 373 			default: success = false;
; 24 ;
	xor a
	ld (main_s + 1), a
l_12:
; 375 ) {
	or a
	jp z, l_22
; 376 			drawBoard();
	call drawBoard
; 377 			sleep(2);
	ld hl, 2
	call sleep
; 378 			addRandom();
	call addRandom
; 379 			drawBoard();
	call drawBoard
; 380 			if (gameEnded()) {
	call gameEnded
	or a
	jp z, l_24
; 381 				printf("            GAME OVER          \n");
	ld hl, s_18
	push hl
	call printf
	pop bc
	jp l_1
l_24:
l_22:
; 382 				break;
; 383 			}
; 384 		}
; 385 		if (c=='q' || c=='Q') {
	ld a, (main_s + 0)
	cp 113
	jp z, l_28
	cp 81
	jp nz, l_26
l_28:
; 386 			printf("            QUIT? (y/n)         \n");
	ld hl, s_19
	push hl
	call printf
	pop bc
; 387 			c=getchar();
	call getchar
	ld a, l
	ld (main_s + 0), a
; 388 			if (c=='y' || c=='Y') {
	cp 121
	jp z, l_1
	cp 89
	jp z, l_1
; 389 				break;
; 390 			}
; 391 			prepareScreen();
	call prepareScreen
l_26:
; 392 		}
; 393 		if (c=='r' || c=='R') {
	ld a, (main_s + 0)
	cp 114
	jp z, l_34
	cp 82
	jp nz, l_0
l_34:
; 394 			printf("          RESTART? (y/n)       \n");
	ld hl, s_20
	push hl
	call printf
	pop bc
; 395 			c=getchar();
	call getchar
	ld a, l
	ld (main_s + 0), a
; 396 			if (c=='y' || c=='Y') {
	cp 121
	jp z, l_37
	cp 89
	jp nz, l_35
l_37:
; 397 				initBoard();
	call initBoard
l_35:
; 398 			}
; 399 			prepareScreen();
	call prepareScreen
	jp l_0
l_1:
; 400 		}
; 401 	}
; 402 
; 403 	printf(ESC_CLEAR_SCREEN);
	ld hl, s_7
	push hl
	call printf
	pop bc
	ld hl, 0
	ret
initBoard:
; 246  initBoard() {
	; Stack correction reset
; 247 	uint8_t x,y;
; 248 	for (x=0;x<SIZE;x++) {
	xor a
	ld (initBoard_s + 0), a
l_38:
	ld a, (initBoard_s + 0)
	cp 4
	jp nc, l_40
; 249 		for (y=0;y<SIZE;y++) {
	xor a
	ld (initBoard_s + 1), a
l_41:
	ld a, (initBoard_s + 1)
	cp 4
	jp nc, l_43
; 250 			board[x][y]=0;
	ld hl, (initBoard_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (initBoard_s + 1)
	ld h, 0
	add hl, de
	ld (hl), 0
l_42:
	ld a, (initBoard_s + 1)
	inc a
	ld (initBoard_s + 1), a
	jp l_41
l_43:
l_39:
	ld a, (initBoard_s + 0)
	inc a
	ld (initBoard_s + 0), a
	jp l_38
l_40:
; 251 		}
; 252 	}
; 253     addRandom();
	call addRandom
; 254     addRandom();
	call addRandom
; 255     prepareScreen();
	call prepareScreen
; 256     score = 0;
	ld de, 0
	ld hl, 0
	ld (score), hl
	ex hl, de
	ld ((score) + 2), hl
; 257     drawBoard();
	jp drawBoard
getchar:
; 40  __fastcall getchar() {
	; Stack correction reset
; 41     return cpmBiosConIn();
	call cpmBiosConIn
	ld l, a
	ld h, 0
	ret
moveLeft:
; 150  moveLeft() {
	; Stack correction reset
; 151 	bool success;
; 152 	rotateBoard();
	call rotateBoard
; 153 	success = moveUp();
	call moveUp
	ld (moveLeft_s + 0), a
; 154 	rotateBoard();
	call rotateBoard
; 155 	rotateBoard();
	call rotateBoard
; 156 	rotateBoard();
	call rotateBoard
; 157 	return success;
	ld a, (moveLeft_s + 0)
	ret
moveRight:
; 170  moveRight() {
	; Stack correction reset
; 171 	bool success;
; 172 	rotateBoard();
	call rotateBoard
; 173 	rotateBoard();
	call rotateBoard
; 174 	rotateBoard();
	call rotateBoard
; 175 	success = moveUp();
	call moveUp
	ld (moveRight_s + 0), a
; 176 	rotateBoard();
	call rotateBoard
; 177 	return success;
	ld a, (moveRight_s + 0)
	ret
moveUp:
; 141  moveUp() {
	; Stack correction reset
; 142 	bool success = false;
; 24 ;
	xor a
	ld (moveUp_s + 0), a
; 144 =0;x<SIZE;x++) {
	ld (moveUp_s + 1), a
l_44:
	ld a, (moveUp_s + 1)
	cp 4
	jp nc, l_46
; 145 		success |= slideArray(board[x]);
	ld hl, (moveUp_s + 1)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	call slideArray
	ld hl, moveUp_s + 0
	or (hl)
	ld (moveUp_s + 0), a
l_45:
	ld a, (moveUp_s + 1)
	inc a
	ld (moveUp_s + 1), a
	jp l_44
l_46:
; 146 	}
; 147 	return success;
	ld a, (moveUp_s + 0)
	ret
moveDown:
; 160  moveDown() {
	; Stack correction reset
; 161 	bool success;
; 162 	rotateBoard();
	call rotateBoard
; 163 	rotateBoard();
	call rotateBoard
; 164 	success = moveUp();
	call moveUp
	ld (moveDown_s + 0), a
; 165 	rotateBoard();
	call rotateBoard
; 166 	rotateBoard();
	call rotateBoard
; 167 	return success;
	ld a, (moveDown_s + 0)
	ret
drawBoard:
; 31  drawBoard() {
	; Stack correction reset
; 32 	uint8_t x,y;
; 33 	uint8_t t;
; 34     printf(ESC_HOME_CURSOR);
	ld hl, s_0
	push hl
	call printf
	pop bc
; 36 "2048.c %23d pts",score);
	ld hl, (((score) + 2))
	ex hl, de
	ld hl, (score)
	push de
	push hl
	ld hl, s_1
	push hl
	call printf
	pop bc
	pop bc
	pop bc
; 37     for (y=0;y<SIZE;y++) {
	xor a
	ld (drawBoard_s + 1), a
l_47:
	ld a, (drawBoard_s + 1)
	cp 4
	jp nc, l_49
; 38         printf("\n\n\n\n");
	ld hl, s_2
	push hl
	call printf
	pop bc
; 39         for (x=0;x<SIZE;x++) {
	xor a
	ld (drawBoard_s + 0), a
l_50:
	ld a, (drawBoard_s + 0)
	cp 4
	jp nc, l_52
; 40             if (board[x][y]!=0) {
	ld hl, (drawBoard_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (drawBoard_s + 1)
	ld h, 0
	add hl, de
	ld a, (hl)
	or a
	jp z, l_53
; 41                 char s[8];
; 42                 snprintf(s,8,"%u",1<<board[x][y]);
	ld hl, (drawBoard_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (drawBoard_s + 1)
	ld h, 0
	add hl, de
	ld l, (hl)
	ld h, 0
	ld de, 1
	ex hl, de
	call __o_shl_16
	push hl
	ld hl, s_3
	push hl
	ld hl, 8
	push hl
	ld hl, drawBoard_s + 3
	push hl
	call snprintf
	ld hl, 8
	add hl, sp
	ld sp, hl
; 43                 t = 7-strlen(s);
	ld hl, drawBoard_s + 3
	call strlen
	ld a, l
	ld d, a
	ld a, 7
	sub d
	ld (drawBoard_s + 2), a
; 44                 printf("|%*s%s%*s",t-t/2,"",s,t/2,"");
	ld hl, s_5
	push hl
	ld hl, (drawBoard_s + 2)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	push hl
	ld hl, drawBoard_s + 3
	push hl
	ld hl, s_5
	push hl
	ld hl, (drawBoard_s + 2)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	ex hl, de
	ld hl, (drawBoard_s + 2)
	ld h, 0
	call __o_sub_16
	push hl
	ld hl, s_4
	push hl
	call printf
	ld hl, 12
	add hl, sp
	ld sp, hl
	jp l_54
l_53:
; 45             } else {
; 46                 printf("|       ");
	ld hl, s_6
	push hl
	call printf
	pop bc
l_54:
l_51:
	ld a, (drawBoard_s + 0)
	inc a
	ld (drawBoard_s + 0), a
	jp l_50
l_52:
l_48:
	ld a, (drawBoard_s + 1)
	inc a
	ld (drawBoard_s + 1), a
	jp l_47
l_49:
; 47             }
; 48         }
; 49     }
; 50     printf("\n\n\n\n");
	ld hl, s_2
	push hl
	call printf
	pop bc
	ret
sleep:
; 25  sleep(unsigned seconds) {
	; Stack correction reset
	ld (sleep_1_a), hl
l_55:
; 26     while (seconds != 0) {
	ld hl, (sleep_1_a)
	ld a, h
	or l
	jp z, l_56
; 27         seconds--;
	dec hl
	ld (sleep_1_a), hl
; 28         Delay(C8080_SECOND_DELAY);
	ld hl, 5000
	call Delay
	jp l_55
l_56:
; 30 ;
	ld hl, 0
	ret
addRandom:
; 216  addRandom() {
	; Stack correction reset
; 217 	static bool initialized = false;
; 218 	uint8_t x,y;
; 219 	uint8_t r,len=0;
	xor a
	ld (addRandom_s + 3), a
; 220 	uint8_t n,list[SIZE*SIZE][2];
; 221 
; 222 	if (!initialized) {
	ld a, (initialized)
	or a
	jp nz, l_57
; 223 		//srand(time(NULL));
; 224 		initialized = true;
; 25 ;
	ld a, 1
	ld (initialized), a
l_57:
; 227 =0;x<SIZE;x++) {
	xor a
	ld (addRandom_s + 0), a
l_59:
	ld a, (addRandom_s + 0)
	cp 4
	jp nc, l_61
; 228 		for (y=0;y<SIZE;y++) {
	xor a
	ld (addRandom_s + 1), a
l_62:
	ld a, (addRandom_s + 1)
	cp 4
	jp nc, l_64
; 229 			if (board[x][y]==0) {
	ld hl, (addRandom_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (addRandom_s + 1)
	ld h, 0
	add hl, de
	ld a, (hl)
	or a
	jp nz, l_65
; 230 				list[len][0]=x;
	ld a, (addRandom_s + 0)
	ld hl, (addRandom_s + 3)
	ld h, 0
	add hl, hl
	ld de, addRandom_s + 5
	add hl, de
	ld (hl), a
; 231 				list[len][1]=y;
	ld a, (addRandom_s + 1)
	ld hl, (addRandom_s + 3)
	ld h, 0
	add hl, hl
	add hl, de
	inc hl
	ld (hl), a
; 232 				len++;
	ld a, (addRandom_s + 3)
	inc a
	ld (addRandom_s + 3), a
l_65:
l_63:
	ld a, (addRandom_s + 1)
	inc a
	ld (addRandom_s + 1), a
	jp l_62
l_64:
l_60:
	ld a, (addRandom_s + 0)
	inc a
	ld (addRandom_s + 0), a
	jp l_59
l_61:
; 233 			}
; 234 		}
; 235 	}
; 236 
; 237 	if (len>0) {
	ld a, (addRandom_s + 3)
	or a
	ret z
; 238 		r = rand()%len;
	call rand
	ld l, a
	ld h, 0
	ex hl, de
	ld hl, (addRandom_s + 3)
	ld h, 0
	ex hl, de
	call __o_mod_u16
	ld a, l
	ld (addRandom_s + 2), a
; 239 		x = list[r][0];
	ld hl, (addRandom_s + 2)
	ld h, 0
	add hl, hl
	ld de, addRandom_s + 5
	add hl, de
	ld a, (hl)
	ld (addRandom_s + 0), a
; 240 		y = list[r][1];
	ld hl, (addRandom_s + 2)
	ld h, 0
	add hl, hl
	add hl, de
	inc hl
	ld a, (hl)
	ld (addRandom_s + 1), a
; 241 		n = (rand()%10)/9+1;
	call rand
	ld l, a
	ld h, 0
	ld de, 10
	call __o_mod_u16
	ld de, 9
	call __o_div_u16
	ld a, l
	inc a
	ld (addRandom_s + 4), a
; 242 		board[x][y]=n;
	ld hl, (addRandom_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (addRandom_s + 1)
	ld h, 0
	add hl, de
	ld (hl), a
	ret
gameEnded:
; 204  gameEnded() {
	; Stack correction reset
; 205 	bool ended = true;
; 25 ;
	ld a, 1
	ld (gameEnded_s + 0), a
; 206 )>0) return false;
	call countEmpty
	or a
	jp z, l_69
; 24 ;
	xor a
	ret
l_69:
; 207 )) return false;
	call findPairDown
	or a
	jp z, l_71
; 24 ;
	xor a
	ret
l_71:
; 208 );
	call rotateBoard
; 209 	if (findPairDown()) ended = false;
	call findPairDown
	or a
	jp z, l_73
; 24 ;
	xor a
	ld (gameEnded_s + 0), a
l_73:
; 210 );
	call rotateBoard
; 211 	rotateBoard();
	call rotateBoard
; 212 	rotateBoard();
	call rotateBoard
; 213 	return ended;
	ld a, (gameEnded_s + 0)
	ret
printf:
; 26  __stdcall printf(const char* format, ...) {
	push bc
	; Stack correction reset
; 1 /c8080/include/c8080/c8080.h
	ld hl, 6
	add hl, sp
	ex hl, de
	ld hl, 0
	add hl, sp
	ld (hl), e
	inc hl
	ld (hl), d
; 29  = printfOutConsole;
	ld hl, printfOutConsole
	ld (printfOut), hl
; 30     printfInternal(format, va);
	ld hl, 4
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (printfInternal_1_a), hl
	ld hl, 0
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	call printfInternal
; 31     va_end(va);
; 32     return printfOutTotal;
	ld hl, (printfOutTotal)
	pop bc
	ret
prepareScreen:
; 53  prepareScreen() {
	; Stack correction reset
; 54     uint8_t x,y,i;
; 55     printf(ESC_CLEAR_SCREEN);
	ld hl, s_7
	push hl
	call printf
	pop bc
; 57 "2048.c %17d pts\n\n",score);
	ld hl, (((score) + 2))
	ex hl, de
	ld hl, (score)
	push de
	push hl
	ld hl, s_8
	push hl
	call printf
	pop bc
	pop bc
	pop bc
; 58     for (x=0;x<SIZE;x++)
	xor a
	ld (prepareScreen_s + 0), a
l_76:
	ld a, (prepareScreen_s + 0)
	cp 4
	jp nc, l_78
; 59         printf("+-------");
	ld hl, s_9
	push hl
	call printf
	pop bc
l_77:
	ld a, (prepareScreen_s + 0)
	inc a
	ld (prepareScreen_s + 0), a
	jp l_76
l_78:
; 60     printf("+\n");
	ld hl, s_10
	push hl
	call printf
	pop bc
; 61     for (y=0;y<SIZE;y++) {
	xor a
	ld (prepareScreen_s + 1), a
l_79:
	ld a, (prepareScreen_s + 1)
	cp 4
	jp nc, l_81
; 62         for (i=0;i<3;i++) {
	xor a
	ld (prepareScreen_s + 2), a
l_82:
	ld a, (prepareScreen_s + 2)
	cp 3
	jp nc, l_84
; 63             for (x=0;x<SIZE;x++)
	xor a
	ld (prepareScreen_s + 0), a
l_85:
	ld a, (prepareScreen_s + 0)
	cp 4
	jp nc, l_87
; 64                 printf("|       ");
	ld hl, s_6
	push hl
	call printf
	pop bc
l_86:
	ld a, (prepareScreen_s + 0)
	inc a
	ld (prepareScreen_s + 0), a
	jp l_85
l_87:
; 65             printf("|\n");
	ld hl, s_11
	push hl
	call printf
	pop bc
l_83:
	ld a, (prepareScreen_s + 2)
	inc a
	ld (prepareScreen_s + 2), a
	jp l_82
l_84:
; 66         }
; 67         for (x=0;x<SIZE;x++)
	xor a
	ld (prepareScreen_s + 0), a
l_88:
	ld a, (prepareScreen_s + 0)
	cp 4
	jp nc, l_90
; 68             printf("+-------");
	ld hl, s_9
	push hl
	call printf
	pop bc
l_89:
	ld a, (prepareScreen_s + 0)
	inc a
	ld (prepareScreen_s + 0), a
	jp l_88
l_90:
; 69         printf("+\n");
	ld hl, s_10
	push hl
	call printf
	pop bc
l_80:
	ld a, (prepareScreen_s + 1)
	inc a
	ld (prepareScreen_s + 1), a
	jp l_79
l_81:
; 70     }
; 71     printf("\n          w,a,s,d or r,q       \n");
	ld hl, s_12
	push hl
	call printf
	pop bc
; 72     drawBoard();
	jp drawBoard
cpmBiosConIn:
; 32  uint8_t __fastcall cpmBiosConIn() {
	; Stack correction reset

        ld hl, (1)
        ld l, 09h
        jp hl
    
	ret
rotateBoard:
; 127  rotateBoard() {
	; Stack correction reset
; 128 	uint8_t i,j,n=SIZE;
	ld a, 4
	ld (rotateBoard_s + 2), a
; 130 =0; i<n/2; i++) {
	xor a
	ld (rotateBoard_s + 0), a
l_91:
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	ex hl, de
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	call __o_sub_16
	ret nc
; 131 		for (j=i; j<n-i-1; j++) {
	ld a, (rotateBoard_s + 0)
	ld (rotateBoard_s + 1), a
l_94:
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	ex hl, de
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	call __o_sub_16
	jp nc, l_96
; 132 			tmp = board[i][j];
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	add hl, de
	ld a, (hl)
	ld (rotateBoard_s + 3), a
; 133 			board[i][j] = board[j][n-i-1];
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	push hl
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	pop de
	add hl, de
	ld a, (hl)
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	add hl, de
	ld (hl), a
; 134 			board[j][n-i-1] = board[n-i-1][n-j-1];
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	push hl
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	pop de
	add hl, de
	push hl
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	push hl
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	pop de
	add hl, de
	ld a, (hl)
	pop hl
	ld (hl), a
; 135 			board[n-i-1][n-j-1] = board[n-j-1][i];
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	push hl
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	pop de
	add hl, de
	push hl
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	add hl, de
	ld a, (hl)
	pop hl
	ld (hl), a
; 136 			board[n-j-1][i] = tmp;
	ld hl, (rotateBoard_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (rotateBoard_s + 2)
	ld h, 0
	call __o_sub_16
	dec hl
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (rotateBoard_s + 0)
	ld h, 0
	add hl, de
	ld a, (rotateBoard_s + 3)
	ld (hl), a
l_95:
	ld a, (rotateBoard_s + 1)
	inc a
	ld (rotateBoard_s + 1), a
	jp l_94
l_96:
l_92:
	ld a, (rotateBoard_s + 0)
	inc a
	ld (rotateBoard_s + 0), a
	jp l_91
slideArray:
; 99  slideArray(uint8_t array[SIZE]) {
	; Stack correction reset
	ld (slideArray_1_a), hl
; 100 	bool success = false;
; 24 ;
	xor a
	ld (slideArray_s + 0), a
; 101  x,t,stop=0;
	ld (slideArray_s + 3), a
; 102 
; 103 	for (x=0;x<SIZE;x++) {
	ld (slideArray_s + 1), a
l_97:
	ld a, (slideArray_s + 1)
	cp 4
	jp nc, l_99
; 104 		if (array[x]!=0) {
	ld hl, (slideArray_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld a, (hl)
	or a
	jp z, l_100
; 105 			t = findTarget(array,x,stop);
	ld hl, (slideArray_1_a)
	ld (findTarget_1_a), hl
	ld a, (slideArray_s + 1)
	ld (findTarget_2_a), a
	ld a, (slideArray_s + 3)
	call findTarget
	ld (slideArray_s + 2), a
; 106 			// if target is not original position, then move or merge
; 107 			if (t!=x) {
	ld a, (slideArray_s + 1)
	ld hl, slideArray_s + 2
	cp (hl)
	jp z, l_102
; 108 				// if target is zero, this is a move
; 109 				if (array[t]==0) {
	ld hl, (slideArray_s + 2)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld a, (hl)
	or a
	jp nz, l_104
; 110 					array[t]=array[x];
	ld hl, (slideArray_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld a, (hl)
	ld hl, (slideArray_s + 2)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld (hl), a
	jp l_105
l_104:
; 111 				} else if (array[t]==array[x]) {
	ld hl, (slideArray_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld a, (hl)
	ld hl, (slideArray_s + 2)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	cp (hl)
	jp nz, l_106
; 112 					// merge (increase power of two)
; 113 					array[t]++;
	ld hl, (slideArray_s + 2)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld a, (hl)
	inc a
	ld (hl), a
; 114 					// increase score
; 115 					score+=(uint32_t)1<<array[t];
	ld hl, (((score) + 2))
	ex hl, de
	ld hl, (score)
	push de
	push hl
	ld de, 0
	ld hl, 1
	push de
	push hl
	ld hl, (slideArray_s + 2)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld l, (hl)
	ld de, 0
	ld h, d
	call __o_shl_32
	; Stack correction -4
	call __o_add_32
	; Stack correction -4
	ld (score), hl
	ex hl, de
	ld ((score) + 2), hl
; 116 					// set stop to avoid double merge
; 117 					stop = t+1;
	ld a, (slideArray_s + 2)
	inc a
	ld (slideArray_s + 3), a
l_106:
l_105:
; 118 				}
; 119 				array[x]=0;
	ld hl, (slideArray_s + 1)
	ld h, 0
	ex hl, de
	ld hl, (slideArray_1_a)
	add hl, de
	ld (hl), 0
; 120 				success = true;
; 25 ;
	ld a, 1
	ld (slideArray_s + 0), a
l_102:
l_100:
l_98:
; 103 ) {
	ld a, (slideArray_s + 1)
	inc a
	ld (slideArray_s + 1), a
	jp l_97
l_99:
; 104 		if (array[x]!=0) {
; 105 			t = findTarget(array,x,stop);
; 106 			// if target is not original position, then move or merge
; 107 			if (t!=x) {
; 108 				// if target is zero, this is a move
; 109 				if (array[t]==0) {
; 110 					array[t]=array[x];
; 111 				} else if (array[t]==array[x]) {
; 112 					// merge (increase power of two)
; 113 					array[t]++;
; 114 					// increase score
; 115 					score+=(uint32_t)1<<array[t];
; 116 					// set stop to avoid double merge
; 117 					stop = t+1;
; 118 				}
; 119 				array[x]=0;
; 120 				success = true;
; 121 			}
; 122 		}
; 123 	}
; 124 	return success;
	ld a, (slideArray_s + 0)
	ret
snprintf:
; 38  __stdcall snprintf(char* buffer, size_t buffer_size, const char* format, ...) {
	push bc
	; Stack correction reset
; 1 /c8080/include/putchar.c
	ld hl, 10
	add hl, sp
	ex hl, de
	ld hl, 0
	add hl, sp
	ld (hl), e
	inc hl
	ld (hl), d
; 41 buffer, buffer_size, format, va);
	ld hl, 4
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (snprintfInternal_1_a), hl
	ld hl, 6
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (snprintfInternal_2_a), hl
	ld hl, 8
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (snprintfInternal_3_a), hl
	ld hl, 0
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	call snprintfInternal
; 42     va_end(va);
; 43     return printfOutTotal;
	ld hl, (printfOutTotal)
	pop bc
	ret
strlen:
; 20  __fastcall strlen(const char string[]) {
	; Stack correction reset
	ld (strlen_1_a), hl
; 21     (void)string;

        ld de, -1
        xor a
strlen_1:
        cp (hl)
        inc de
        inc hl
        jp nz, strlen_1
        ex hl, de
    
	ret
Delay:
; 22  Delay(uint16_t n) {
	; Stack correction reset
	ld (Delay_1_a), hl
l_109:
; 23     while (--n != 0) {
	ld hl, (Delay_1_a)
	dec hl
	ld (Delay_1_a), hl
	ld a, h
	or l
	jp nz, l_109
	ret
rand:
; 20  __fastcall rand() {
	; Stack correction reset

rand_seed:
        ld a, 0FAh
        ld b, a
        add a, a
        add a, a
        add a, b
        inc a
        ld (rand_seed + 1), a
    
	ret
countEmpty:
; 191  countEmpty() {
	; Stack correction reset
; 192 	uint8_t x,y;
; 193 	uint8_t count=0;
	xor a
	ld (countEmpty_s + 2), a
; 194 	for (x=0;x<SIZE;x++) {
	ld (countEmpty_s + 0), a
l_111:
	ld a, (countEmpty_s + 0)
	cp 4
	jp nc, l_113
; 195 		for (y=0;y<SIZE;y++) {
	xor a
	ld (countEmpty_s + 1), a
l_114:
	ld a, (countEmpty_s + 1)
	cp 4
	jp nc, l_116
; 196 			if (board[x][y]==0) {
	ld hl, (countEmpty_s + 0)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (countEmpty_s + 1)
	ld h, 0
	add hl, de
	ld a, (hl)
	or a
	jp nz, l_117
; 197 				count++;
	ld a, (countEmpty_s + 2)
	inc a
	ld (countEmpty_s + 2), a
l_117:
l_115:
	ld a, (countEmpty_s + 1)
	inc a
	ld (countEmpty_s + 1), a
	jp l_114
l_116:
l_112:
	ld a, (countEmpty_s + 0)
	inc a
	ld (countEmpty_s + 0), a
	jp l_111
l_113:
; 198 			}
; 199 		}
; 200 	}
; 201 	return count;
	ld a, (countEmpty_s + 2)
	ret
findPairDown:
; 180  findPairDown() {
	; Stack correction reset
; 181 	bool success = false;
; 24 ;
	xor a
	ld (findPairDown_s + 0), a
; 183 =0;x<SIZE;x++) {
	ld (findPairDown_s + 1), a
l_119:
	ld a, (findPairDown_s + 1)
	cp 4
	jp nc, l_121
; 184 		for (y=0;y<SIZE-1;y++) {
	xor a
	ld (findPairDown_s + 2), a
l_122:
	ld a, (findPairDown_s + 2)
	cp 3
	jp nc, l_124
; 185 			if (board[x][y]==board[x][y+1]) return true;
	ld hl, (findPairDown_s + 1)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (findPairDown_s + 2)
	ld h, 0
	inc hl
	add hl, de
	ld a, (hl)
	ld hl, (findPairDown_s + 1)
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, board
	add hl, de
	ex hl, de
	ld hl, (findPairDown_s + 2)
	ld h, 0
	add hl, de
	cp (hl)
	jp nz, l_125
; 25 ;
	ld a, 1
	ret
l_125:
l_123:
; 184 ) {
	ld a, (findPairDown_s + 2)
	inc a
	ld (findPairDown_s + 2), a
	jp l_122
l_124:
l_120:
	ld a, (findPairDown_s + 1)
	inc a
	ld (findPairDown_s + 1), a
	jp l_119
l_121:
; 185 			if (board[x][y]==board[x][y+1]) return true;
; 186 		}
; 187 	}
; 188 	return success;
	ld a, (findPairDown_s + 0)
	ret
printfOutConsole:
; 21  __stdcall printfOutConsole(int c) { // TODO: static
	; Stack correction reset
; 22     printfOutTotal++;
	ld hl, (printfOutTotal)
	inc hl
	ld (printfOutTotal), hl
; 23     return putchar(c);
	ld hl, 2
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	jp putchar
printfInternal:
; 46  printfInternal(const char* format, va_list va) {
	; Stack correction reset
	ld (printfInternal_2_a), hl
; 47     printfOutTotal = 0;
	ld hl, 0
	ld (printfOutTotal), hl
l_127:
; 48     char buf[UINT16_TO_STRING_SIZE];
; 49     for (;;) {
; 50         uint8_t c = *format;
	ld hl, (printfInternal_1_a)
	ld a, (hl)
	ld (printfInternal_s + 6), a
; 51         switch (c) {
	or a
	ret z
	sub 37
	jp z, l_131
	jp l_133
l_131:
; 52             case 0:
; 53                 return;
; 54             case '%':
; 55                 unsigned width = 0;
	ld hl, 0
	ld (printfInternal_s + 7), hl
; 56                 format++;
	ld hl, (printfInternal_1_a)
	inc hl
	ld (printfInternal_1_a), hl
; 57                 c = *format;
	ld a, (hl)
	ld (printfInternal_s + 6), a
; 58                 if (c == '*') {
	cp 42
	jp nz, l_134
; 59                     width = va_arg(va, unsigned);
	ld hl, (printfInternal_2_a)
	inc hl
	inc hl
	ld (printfInternal_2_a), hl
	dec hl
	dec hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (printfInternal_s + 7), hl
; 60 ;
	ld hl, (printfInternal_1_a)
	inc hl
	ld (printfInternal_1_a), hl
; 61                     c = *format;
	ld a, (hl)
	ld (printfInternal_s + 6), a
	jp l_135
l_134:
l_136:
; 62                 } else {
; 63                     while (c >= '0' && c <= '9') {
	ld a, (printfInternal_s + 6)
	cp 48
	jp c, l_137
	ld a, 57
	ld hl, printfInternal_s + 6
	cp (hl)
	jp c, l_137
; 64                         width = width * 10 + (c - '0');
	ld hl, (printfInternal_s + 6)
	ld h, 0
	ld de, 65488
	add hl, de
	push hl
	ld hl, (printfInternal_s + 7)
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	pop de
	add hl, de
	ld (printfInternal_s + 7), hl
; 65                         format++;
	ld hl, (printfInternal_1_a)
	inc hl
	ld (printfInternal_1_a), hl
; 66                         c = *format;
	ld a, (hl)
	ld (printfInternal_s + 6), a
	jp l_136
l_137:
l_135:
; 67                     }
; 68                 }
; 69                 switch (c) {
	ld a, (printfInternal_s + 6)
	or a
	ret z
	sub 100
	jp z, l_141
	sub 5
	jp z, l_140
	sub 10
	jp z, l_139
	sub 2
	jp z, l_142
	jp l_130
l_142:
l_141:
l_140:
; 70                     case 0:
; 71                         return;
; 72                     case 'u':
; 73                     case 'd':
; 74                     case 'i': {
; 75                         unsigned i = va_arg(va, unsigned);
	ld hl, (printfInternal_2_a)
	inc hl
	inc hl
	ld (printfInternal_2_a), hl
	dec hl
	dec hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	ld (printfInternal_s + 9), hl
; 76  != 'u' && (int16_t)i < 0) {
	ld a, (printfInternal_s + 6)
	cp 117
	jp z, l_144
	ld de, 0
	call __o_sub_16
	jp p, l_144
; 77                             printfOut('-');
	ld hl, 45
	push hl
	ld hl, (printfOut)
	call __o_call_hl
	pop bc
; 78                             i = 0 - i;
	ld hl, (printfInternal_s + 9)
	ld de, 0
	ex hl, de
	call __o_sub_16
	ld (printfInternal_s + 9), hl
l_144:
; 79                         }
; 80                         char* text = Uint16ToString(buf, (uint16_t)i);
	ld hl, printfInternal_s + 0
	ld (Uint16ToString_1_a), hl
	ld hl, (printfInternal_s + 9)
	call Uint16ToString
	ld (printfInternal_s + 11), hl
; 81                         printSpaces(width, &buf[UINT16_TO_STRING_SIZE] - text);
	ld hl, (printfInternal_s + 7)
	ld (printSpaces_1_a), hl
	ld hl, (printfInternal_s + 11)
	ld de, (printfInternal_s + 0) + (6)
	ex hl, de
	call __o_sub_16
	call printSpaces
; 82                         printfText(text);
	ld hl, (printfInternal_s + 11)
	call printfText
	jp l_130
l_139:
; 83                         break;
; 84                     }
; 85                     case 's': {
; 86                         uint16_t prevTotal = printfOutTotal;
	ld hl, (printfOutTotal)
	ld (printfInternal_s + 9), hl
; 87                         printfText(va_arg(va, char*));
	ld hl, (printfInternal_2_a)
	inc hl
	inc hl
	ld (printfInternal_2_a), hl
	dec hl
	dec hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex hl, de
	call printfText
; 88 width, printfOutTotal - prevTotal);
	ld hl, (printfInternal_s + 7)
	ld (printSpaces_1_a), hl
	ld hl, (printfInternal_s + 9)
	ex hl, de
	ld hl, (printfOutTotal)
	call __o_sub_16
	call printSpaces
	jp l_130
l_133:
; 89                         break;
; 90                     }
; 91                 }
; 92                 break;
; 93             default:
; 94                 printfOut(c);
	ld hl, (printfInternal_s + 6)
	ld h, 0
	push hl
	ld hl, (printfOut)
	call __o_call_hl
	pop bc
l_130:
; 95         }
; 96         format++;
	ld hl, (printfInternal_1_a)
	inc hl
	ld (printfInternal_1_a), hl
l_128:
	jp l_127
l_129:
	ret
findTarget:
; 75  findTarget(uint8_t array[SIZE],uint8_t x,uint8_t stop) {
	; Stack correction reset
	ld (findTarget_3_a), a
; 76 	uint8_t t;
; 77 	// if the position is already on the first, don't evaluate
; 78 	if (x==0) {
	ld a, (findTarget_2_a)
	or a
	jp nz, l_146
; 79 		return x;
	ret
l_146:
; 80 	}
; 81 	for(t=x-1;;t--) {
	dec a
	ld (findTarget_s + 0), a
l_148:
; 82 		if (array[t]!=0) {
	ld hl, (findTarget_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (findTarget_1_a)
	add hl, de
	ld a, (hl)
	or a
	jp z, l_151
; 83 			if (array[t]!=array[x]) {
	ld hl, (findTarget_2_a)
	ld h, 0
	ex hl, de
	ld hl, (findTarget_1_a)
	add hl, de
	ld a, (hl)
	ld hl, (findTarget_s + 0)
	ld h, 0
	ex hl, de
	ld hl, (findTarget_1_a)
	add hl, de
	cp (hl)
	jp z, l_153
; 84 				// merge is not possible, take next position
; 85 				return t+1;
	ld a, (findTarget_s + 0)
	inc a
	ret
l_153:
; 86 			}
; 87 			return t;
	ld a, (findTarget_s + 0)
	ret
l_151:
; 88 		} else {
; 89 			// we should not slide further, return this one
; 90 			if (t==stop) {
	ld a, (findTarget_3_a)
	ld hl, findTarget_s + 0
	cp (hl)
	jp nz, l_155
; 91 				return t;
	ld a, (findTarget_s + 0)
	ret
l_155:
l_149:
	ld a, (findTarget_s + 0)
	dec a
	ld (findTarget_s + 0), a
	jp l_148
l_150:
; 92 			}
; 93 		}
; 94 	}
; 95 	// we did not find a
; 96 	return x;
	ld a, (findTarget_2_a)
	ret
snprintfInternal:
; 29  void snprintfInternal(char* buffer, size_t buffer_size, const char* format, va_list va) {
	; Stack correction reset
	ld (snprintfInternal_4_a), hl
; 30     printfOut = printfOutString;
	ld hl, printfOutString
	ld (printfOut), hl
; 31     if (buffer_size > 0) buffer_size--;
	ld hl, (snprintfInternal_2_a)
	ld a, h
	or l
	jp z, l_157
	dec hl
	ld (snprintfInternal_2_a), hl
l_157:
; 32     printfOutPointer = buffer;
	ld hl, (snprintfInternal_1_a)
	ld (printfOutPointer), hl
; 33     printfOutEnd = buffer + buffer_size;
	ld hl, (snprintfInternal_2_a)
	ex hl, de
	ld hl, (snprintfInternal_1_a)
	add hl, de
	ld (printfOutEnd), hl
; 34     printfInternal(format, va);
	ld hl, (snprintfInternal_3_a)
	ld (printfInternal_1_a), hl
	ld hl, (snprintfInternal_4_a)
	call printfInternal
; 35     *printfOutPointer = 0;
	ld hl, (printfOutPointer)
	ld (hl), 0
	ret
putchar:
; 45  __fastcall putchar(int c) {
	; Stack correction reset
	ld (putchar_1_a), hl
; 46     if (c == 0x0A) cpmBiosConOut(0x0D);
	ld de, 10
	call __o_cmp_16
	jp nz, l_159
	ld a, 13
	call cpmBiosConOut
l_159:
; 47     cpmBiosConOut(c);
	ld a, (putchar_1_a)
	call cpmBiosConOut
; 48     return 0;
	ld hl, 0
	ret
Uint16ToString:
; 21 * Uint16ToString(char* outputBuffer, uint16_t value) {
	; Stack correction reset
	ld (Uint16ToString_2_a), hl
; 22     outputBuffer += UINT16_TO_STRING_SIZE - 1;
	ld hl, (Uint16ToString_1_a)
	ld de, 5
	add hl, de
	ld (Uint16ToString_1_a), hl
; 23     *outputBuffer = 0;
	ld (hl), 0
l_161:
; 24     do {
; 25         value /= 10;
	ld hl, (Uint16ToString_2_a)
	ld de, 10
	call __o_div_u16
	ld (Uint16ToString_2_a), hl
; 26         --outputBuffer;
	ld hl, (Uint16ToString_1_a)
	dec hl
	ld (Uint16ToString_1_a), hl
; 27         *outputBuffer = (uint8_t)__div_16_mod + '0';
	ld a, (__div_16_mod)
	add 48
	ld (hl), a
l_162:
; 28     } while (value != 0);
	ld hl, (Uint16ToString_2_a)
	ld a, h
	or l
	jp nz, l_161
l_163:
; 29     return outputBuffer;
	ld hl, (Uint16ToString_1_a)
	ret
printSpaces:
; 37  void printSpaces(unsigned need, unsigned ready) {
	; Stack correction reset
	ld (printSpaces_2_a), hl
; 38     if (ready >= need) return;
	ld hl, (printSpaces_1_a)
	ex hl, de
	ld hl, (printSpaces_2_a)
	call __o_sub_16
	ret nc
; 39     need -= ready;
	ld hl, (printSpaces_2_a)
	ex hl, de
	ld hl, (printSpaces_1_a)
	call __o_sub_16
	ld (printSpaces_1_a), hl
l_166:
; 40     do {
; 41         printfOut(' ');
	ld hl, 32
	push hl
	ld hl, (printfOut)
	call __o_call_hl
	pop bc
; 42         need--;
	ld hl, (printSpaces_1_a)
	dec hl
	ld (printSpaces_1_a), hl
l_167:
; 43     } while(need != 0);
	ld hl, (printSpaces_1_a)
	ld a, h
	or l
	jp nz, l_166
l_168:
	ret
printfText:
; 28  printfText(const char *text) {
	; Stack correction reset
	ld (printfText_1_a), hl
l_169:
; 29     for (;;) {
; 30         uint8_t c = *text;
	ld hl, (printfText_1_a)
	ld a, (hl)
	ld (printfText_s + 0), a
; 31         if (c == 0) break;
	or a
	ret z
; 32         printfOut(c);
	ld hl, (printfText_s + 0)
	ld h, 0
	push hl
	ld hl, (printfOut)
	call __o_call_hl
	pop bc
; 33         text++;
	ld hl, (printfText_1_a)
	inc hl
	ld (printfText_1_a), hl
l_170:
	jp l_169
printfOutString:
; 21  __stdcall printfOutString(int c) { // TODO: static
	; Stack correction reset
; 22     printfOutTotal++;
	ld hl, (printfOutTotal)
	inc hl
	ld (printfOutTotal), hl
; 23     if (printfOutPointer != printfOutEnd) {
	ld hl, (printfOutEnd)
	ex hl, de
	ld hl, (printfOutPointer)
	call __o_cmp_16
	ret z
; 24         *printfOutPointer = c;
	ld hl, 2
	add hl, sp
	ld a, (hl)
	ld hl, (printfOutPointer)
	ld (hl), a
; 25         printfOutPointer++;
	inc hl
	ld (printfOutPointer), hl
	ret
cpmBiosConOut:
; 36  void __fastcall cpmBiosConOut(uint8_t c) {
	; Stack correction reset
	ld (cpmBiosConOut_1_a), a

        ld c, a
        ld hl, (1)
        ld l, 0Ch
        jp hl
    
	ret
score:
	dd 0
board:
	ds 16
initialized:
	db 0
printfOut:
	ds 2
printfOutPointer:
	ds 2
printfOutEnd:
	ds 2
printfOutTotal:
	ds 2
strlen_1_a:
	ds 2
findTarget_1_a:
	ds 2
findTarget_2_a:
	ds 1
findTarget_3_a:
	ds 1
slideArray_1_a:
	ds 2
main_1_a:
	ds 2
main_2_a:
	ds 2
sleep_1_a:
	ds 2
putchar_1_a:
	ds 2
printfInternal_1_a:
	ds 2
printfInternal_2_a:
	ds 2
snprintfInternal_1_a:
	ds 2
snprintfInternal_2_a:
	ds 2
snprintfInternal_3_a:
	ds 2
snprintfInternal_4_a:
	ds 2
cpmBiosConOut_1_a:
	ds 1
Delay_1_a:
	ds 2
printfText_1_a:
	ds 2
printSpaces_1_a:
	ds 2
printSpaces_2_a:
	ds 2
Uint16ToString_1_a:
	ds 2
Uint16ToString_2_a:
	ds 2
main_s:
	ds 2
initBoard_s:
	ds 2
moveLeft_s:
	ds 1
moveRight_s:
	ds 1
moveUp_s:
	ds 2
moveDown_s:
	ds 1
drawBoard_s:
	ds 11
addRandom_s:
	ds 37
gameEnded_s:
	ds 1
prepareScreen_s:
	ds 3
rotateBoard_s:
	ds 4
slideArray_s:
	ds 4
countEmpty_s:
	ds 3
findPairDown_s:
	ds 3
printfInternal_s:
	ds 13
findTarget_s:
	ds 1
printfText_s:
	ds 1
__o_sub_16:
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ret
__o_cmp_16:
    ld a, h
    cp d
    ret nz
    ld a, l
    cp e
    ret
__o_div_u16:
    push bc
    ex hl, de
    call __o_div_u16__l0
    ex hl, de
    ld (__div_16_mod), hl
    ex hl, de
    pop bc
    ret

__o_div_u16__l0:
__o_div_u16__l:
    ld a, h
    or l
    ret z
    ld bc, 0
    push bc
__o_div_u16__l1:
    ld a, e
    sub l
    ld a, d
    sbc h
    jp c, __o_div_u16__l2
    push hl
    add hl, hl
    jp nc, __o_div_u16__l1
__o_div_u16__l2:
    ld hl, 0
__o_div_u16__l3:
    pop bc
    ld a, b
    or c
    ret z
    add hl, hl
    push de
    ld a, e
    sub c
    ld e, a
    ld a, d
    sbc b
    ld d, a
    jp c, __o_div_u16__l4
    inc hl
    pop bc
    jp __o_div_u16__l3
__o_div_u16__l4:
    pop de
    jp __o_div_u16__l3
__o_mod_u16:
    push bc
    ex hl, de
    call __o_div_u16__l0
    ex hl, de
    pop bc
    ret
__o_shl_16:
    inc e
__o_shl_16__l1:
    dec e
    ret z
    add hl, hl
    jp __o_shl_16__l1
__o_shr_u16:
    inc e
__o_shr_u16__l1:
    dec e
    ret z
    ld a, h
    or a  ; cf = 0
    rra
    ld h, a
    ld a, l
    rra
    ld l, a
    jp __o_shr_u16__l1
; Input: de:hl - value 1, stack - 32 bit value 2
; Output: de:hl - result

__o_add_32:
    ld bc, hl ; bc = v1l
    pop hl ; hl = ret, stack = v2l
    ex (sp), hl ; hl = v2l, stack = ret
    ld a, c
    add l
    ld c, a
    ld a, b
    adc h
    ld b, a ; bc - result
    pop hl ; hl = ret, stack = v2h
    ex (sp), hl ; hl = v2h, stack = ret
    ld a, e
    adc l
    ld e, a
    ld a, d
    adc h
    ld d, a ; de - result
    ld hl, bc
    ret
__o_call_hl:
    jp hl
; Input: de:hl - value 1, stack - 32 bit value 2
; Output: de:hl - result

__o_shl_32:
    ld bc, hl ; bc = v1l
    pop hl ; hl = ret, stack = v2l
    ex (sp), hl ; hl = v2l, stack = ret
    ld a, l
    and 31
    jp z, __o_shl_32_ret
__o_shl_32_1:
    ex hl, de ; de <<= 1
    add hl, hl
    ex hl, de
    ld hl, bc ; bc <<= 1
    add hl, hl
    ld bc, hl
    jp nz, __o_shl_32_2 ; if (flag_c) de++;
    inc de
__o_shl_32_2:
    dec a
    jp nz, __o_shl_32_1
__o_shl_32_ret:
    pop hl ; hl = ret, stack = v2ha
    ex (sp), hl ; hl = v2h, stack = ret
    ld hl, bc
    jp hl
__div_16_mod:
	ds 2
s_5: db 0
s_2: db 10, 10, 10, 10, 0
s_12: db 10, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 119, 44, 97, 44, 115, 44, 100, 32, 111, 114, 32, 114, 44, 113, 32, 32, 32, 32, 32, 32, 32, 10, 0
s_0: db 27, 91, 72, 0
s_7: db 27, 91, 72, 27, 91, 50, 74, 0
s_18: db 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 71, 65, 77, 69, 32, 79, 86, 69, 82, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 10, 0
s_19: db 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 81, 85, 73, 84, 63, 32, 40, 121, 47, 110, 41, 32, 32, 32, 32, 32, 32, 32, 32, 32, 10, 0
s_20: db 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 82, 69, 83, 84, 65, 82, 84, 63, 32, 40, 121, 47, 110, 41, 32, 32, 32, 32, 32, 32, 32, 10, 0
s_3: db 37, 117, 0
s_10: db 43, 10, 0
s_9: db 43, 45, 45, 45, 45, 45, 45, 45, 0
s_8: db 50, 48, 52, 56, 46, 99, 32, 37, 49, 55, 100, 32, 112, 116, 115, 10, 10, 0
s_1: db 50, 48, 52, 56, 46, 99, 32, 37, 50, 51, 100, 32, 112, 116, 115, 0
s_11: db 124, 10, 0
s_6: db 124, 32, 32, 32, 32, 32, 32, 32, 0
s_4: db 124, 37, 42, 115, 37, 115, 37, 42, 115, 0
end:
    savebin 'output.com', begin, end - begin
