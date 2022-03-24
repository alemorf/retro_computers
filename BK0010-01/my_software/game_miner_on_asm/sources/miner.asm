; Miner for BK0010 / САПЕР ДЛЯ БК0010
; (c) 5-03-2012 VINXRU (aleksey.f.morozov@gmail.com)

	        ORG 01000

;----------------------------------------------------------------------------        
; МЕНЮ        

EntryPoint:     ; Игра очень прожорлива до стека
		MOV #16384, SP

		; Включение режима 256x256
		MOV #0233, R0
		EMT 016

		; Отключение курсора
		MOV #0232, R0
		EMT 016

		; Запуск таймера
		MOV #731, @#0177706
		MOV #0160, @#0177712

		; Выключаем прерывание клавиатуры
		MOV #64, @#0177660

		; Очистка экрана
Menu:		JSR PC, @#clearScreen

		; Вывод лого		
		MOV #bmpLogo, R0
		MOV #045020, R1
		MOV #37, R3
drawLogo0:	MOV #16, R2
drawLogo1:	MOV (R0)+,(R1)+
		SOB R2, drawLogo1
		ADD #32, R1
		SOB R3, drawLogo0

		; Вывод меню
		MOV #txtMenu, R0
		JSR PC, @#Print

MenuLoop:	; Инициализируем генератор случайных чисел.
                JSR PC, @#rand

		; Обрабатываем клавиши
		MOV @#0177662, R0

		; Анализ клавиши
		MOV #menuItems, R5
Menu2:		MOV (R5)+, R1
		BEQ MenuLoop
		CMPB R0, R1
		BEQ StartGame
		ADD #8, R5
		BR Menu2

;----------------------------------------------------------------------------
; ДАННЫЕ МЕНЮ

txtMenu:	DB 10,12,0222,"0. Лошара",0
		DB 10,13,0222,"1. Новичок",0
		DB 10,14,     "2. Любитель",0
		DB 10,15,     "3. Профессионал",0
		DB  9,22,0221,"(c) 2012 VINXRU",0
		DB  3,23,0223,"aleksey.f.morozov@gmail.com",0,255

menuItems:	DW '0', 9, 9, 3, 21006	; клавиша, ширина, высота, кол-во бомб, положение на экране
		DW '1', 9, 9, 10, 21006
	 	DW '2', 13, 10, 20, 20486
		DW '3', 16, 14, 43, 18432
		DW 0

;----------------------------------------------------------------------------
; ИГРА

StartGame:      ; Параметры игрового поля
		MOV (R5)+, gameWidth
		MOV (R5)+, gameHeight
		MOV (R5)+, bombsCnt
		MOV (R5)+, playfieldVA

		; Очистка экрана
		JSR PC, @#clearScreen
		JSR PC, @#fillBlocks

		; Устанавливаем курсор в центр поля
		MOV gameWidth, R0
		ASR R0
		MOV R0, cursorX
		MOV gameHeight, R0
		ASR R0
		MOV R0, cursorY

		; Очистка основных переменных
		CLR bombsPutted
		CLR gameOverFlag
		CLR time

		; Очистка игрового поля
		CLR R0
		MOV #254, R1
StartGame1:	MOVB R1, playfield(R0)
		CLRB userMarks(R0)
		INCB R0
		BNE StartGame1

		; Вывод смайлика
		MOV #bmpGood, R0
		JSR PC, @#drawSmile

		; Рисование игрового поля
		JSR PC, @#drawPlayField
	
		; Вывод чисел
		JSR PC, @#leftNumber
		JSR PC, @#rightNumber
		
		; Время
mainLoop:       CMP gameOverFlag, #1
		BEQ mainLoop1
		CMP time, #999
		BEQ mainLoop1

		; Прошла секунда?
		CLR R0
		CMP @#0177710, #365
		ADC R0
		CMP lastTimer, R0
		BEQ mainLoop1
		MOV R0, lastTimer

		; Да прошла. Увеличиваем переменную и перерисовываем экран
		INC time
		JSR PC, @#rightNumber

mainLoop1:      ; Нажата ли клавиша
		BIT #128, @#0177660
		BEQ mainLoop

		; Анализируем клавиатуру
		MOV @#0177662, R0
		CMP R0, #8
		BEQ cursorLeft
		CMP R0, #0x19
		BEQ cursorRight
		CMP R0, #0x1A
		BEQ cursorUp
		CMP R0, #0x1B
		BEQ cursorDown	
		CMP R0, #' '
		BEQ leftClick

		BR rightClick

;----------------------------------------------------------------------------
; ЛЕВАЯ КНОПКА МЫШИ

leftClick:	; Если бомбы не установлены, установить бомбы
		MOV bombsPutted, R0
		BEQ putBombs

		; Если игра завершена, то выйти в меню
putBombsRet:	CMP gameOverFlag, #1
		BEQ MenuFar

		; Запустить функцию Open
		MOV cursorX, R0
		MOV cursorY, R1
		JSR PC, @#open

		; Возможно курсор стерт
		JSR PC, @#drawCursor

		; Проверить, выиграли ли мы
		JSR PC, @#checkWin
	
		; Основной цикл игры	
		BR mainLoop

;----------------------------------------------------------------------------

MenuFar:	JMP @#Menu

;----------------------------------------------------------------------------

cursorLeft:     CMP cursorX, #0
		BEQ mainLoop
		JSR PC, @#hideCursor
		DEC cursorX
		JSR PC, @#drawCursor
		BR mainLoop

;----------------------------------------------------------------------------

cursorRight:    MOV cursorX, R0
		INC R0
		CMP R0, gameWidth
		BEQ mainLoop
		JSR PC, @#hideCursor
		INC cursorX
		JSR PC, @#drawCursor
		BR mainLoop

;----------------------------------------------------------------------------

cursorUp:    	CMP cursorY, #0
		BEQ mainLoop
		JSR PC, @#hideCursor
		DEC cursorY
		JSR PC, @#drawCursor
		BR mainLoop

;----------------------------------------------------------------------------

cursorDown:	MOV cursorY, R0
		INC R0
		CMP R0, gameHeight
		BEQ mainLoop
		JSR PC, @#hideCursor
		INC cursorY
		JSR PC, @#drawCursor
		BR mainLoop

;----------------------------------------------------------------------------
; ЛЮБАЯ КНОПКА КЛАВИАТУРЫ - УСТАНОВКА ФЛАГА

rightClick:	; if(gameOver) return;
		CMP gameOverFlag, #1
		BEQ mainLoop
		; a=x+y*miner_w
		MOV cursorX, R0
		MOV cursorY, R1
		JSR PC, @#mul01
		; userMarks[a] = (userMarks[a]+1)%3;
		MOVB userMarks(R2), R3
		INC R3
		CMP R3, #4
		BNE rightClick1
		  CLR R3 
rightClick1:	MOVB R3, userMarks(R2)
		; redraw();
		JSR PC, @#hideCursor
		JSR PC, @#drawCursor
rightClickRet:	JSR PC, @#leftNumber
	 	JMP @#mainLoop

;----------------------------------------------------------------------------
; ПОМЕСТИТЬ БОМБЫ НА ПОЛЕ

putBombs:	INC bombsPutted

                ; Цикл
		MOV bombsCnt, R5
putBombs1:      MOV R5, -(SP)
	
                ; Координата X
putBombs2:	JSR PC, @#rand
		MOV gameHeight, R1
		JSR PC, @#div
		MOV R0, R5

                ; Координата Y
		JSR PC, @#rand
		MOV gameWidth, R1
		JSR PC, @#div

		; Бомба не должна быть под крсором
		CMP cursorY, R5
		BNE putBombs3
		CMP cursorX, R0
		BEQ putBombs2

		; Расчет адреса в массиве
putBombs3:	MOV R5, R1
		JSR PC, @#mul01

		; Бомба в этой клетке уже есть
		CMPB #255, playfield(R2)
		BEQ putBombs2

		; Ставим бомбу
		MOVB #255, playfield(R2)

		MOV (SP)+, R5
		SOB R5, putBombs1

		JMP @#putBombsRet

;----------------------------------------------------------------------------
; ПЕРЕРИСОВАТЬ КЛЕТКУ (СТЕРЕТЬ КУРСОР)

hideCursor:	MOV cursorX, R0
		MOV cursorY, R1
		JSR PC, @#mul01		; R0+R1*16 -> R2
		JSR PC, @#calcCell2	; R0,R1 -> R1. Портит R3
		MOVB userMarks(R2), R5
		MOVB playfield(R2), R2
		JSR PC, @#getBitmap
		CMP R0, #bmpUn
		BEQ drawCursor4
drawCursor5:	JSR PC, @#drawImage ; Используется R0,R1. Портит R2.
                RTS PC

;................................

drawCursor4:	CMP R5, #1
		BEQ drawCursorF
		CMP R5, #2
		BNE drawCursor5
		mov #bmpQ, R0
		BR drawCursor5

;................................
	
drawCursorF:	mov #bmpF, R0
		BR drawCursor5

;----------------------------------------------------------------------------
; НАРИСОВАТЬ КУРСОР ПОВЕРХ КЛЕТКИ

drawCursor:	MOV cursorX, R0
		MOV cursorY, R1
		JSR PC, @#calcCell2
		MOV #bmpCursor, R0
		JSR PC, @#drawTransImage
		RTS PC      

;----------------------------------------------------------------------------
; РАСЧЕТ АДРЕСА В ВИДЕОПАМЯТИ ЯЧЕЙКИ ИГРОВОГО ПОЛЯ 
; R0,R1 - Координаты => R1 - адрес, Портит R3

calcCell2:	MOV R1, R3
		SWAB R3
		ROL R3
		ROL R3
		ADD R0, R3
		ADD R0, R3
		ADD R0, R3
		ADD R0, R3
		ADD playfieldVA, R3		
		MOV R3, R1		
		RTS PC

;----------------------------------------------------------------------------
; ЛОГИКА ИГРЫ
; R0,R1 - координаты. R3 - счетчик => R2 - портит

check:		; if(x>=8 || y>=8) return;
		CMP R0, gameWidth
		BCC checkRet
                CMP R1, gameHeight
		BCC checkRet
		; a = x+y*miner_w
		JSR PC, @#Mul01
		; if(playfield[a]==-1) R3++;
		CMPB playfield(R2), #255 
		BNE openRet
		INC R3
checkRet:	RTS PC

;----------------------------------------------------------------------------
; ЛОГИКА ИГРЫ

call8:		DEC R1
		JSR PC, @#call81
		DEC R0
		INC R1
		JSR PC, (R5)
		INC R0
		INC R0
		JSR PC, (R5)
		DEC R0
		INC R1
		JSR PC, @#call81
		DEC R1
		RTS PC

;----------------------------------------------------------------------------
; ЛОГИКА ИГРЫ

call81:         DEC R0
		JSR PC, (R5)
		INC R0
		JSR PC, (R5)
		INC R0
		JSR PC, (R5)
		DEC R0
		RTS PC

;----------------------------------------------------------------------------
; R0+R1*16 => R2

mul01:		MOV R1, R2
		ASL R2
		ASL R2
		ASL R2
		ASL R2
		ADD R0, R2
		RTS PC

;----------------------------------------------------------------------------
; ЛОГИКА ИГРЫ

open:		CMP R0, gameWidth
		BCC openRet
                CMP R1, gameHeight
		BCC openRet
		; a=x+y*miner_w 
		JSR PC, @#Mul01
	        ; if(playfield[a]==-1) miner_gameOver=true;
	        CMPB playfield(R2), #255
	        BEQ die
	        ; if(playfield[a]!=-2) return;
		CMPB playfield(R2), #254
		BNE openRet
		; push
		MOV R5, -(SP)
                MOV R0, -(SP)
                MOV R1, -(SP)             
		; playfield[a]=call8(check,x,y);
		MOV #check, R5
		CLR R3
		JSR PC, @#call8
		JSR PC, @#mul01
		MOVB R3, playfield(R2)
		; redraw
		MOV R3, R4
		JSR PC, @#redrawCell012
		; if(playfield[a]!=0) return;
		MOV R4, R4
		BNE openRets
		; call8(open,x,y);
                MOV (SP)+, R1
                MOV (SP)+, R0
		MOV #open, R5
		JSR PC, @#call8
                MOV (SP)+, R5
		RTS PC

openRets:       MOV (SP)+, R1
                MOV (SP)+, R0
		MOV (SP)+, R5
openRet:        RTS PC

;----------------------------------------------------------------------------
; ИГРОК УМЕР

die:		; Вывод смайлика
		MOV #bmpBad, R0
		JSR PC, @#drawSmile
		JMP @#gameOver

;----------------------------------------------------------------------------
; ПЕРЕРИСОВАТь ЯЧЕЙКУ НА ЭКРАНЕ
; R0,R1 - координаты. R2 - число. => портит все регистры

redrawCell012:   MOV R3, R2
		 JSR PC, @#calcCell2 ; R0,R1 -> R1. Портит R3
		 JSR PC, @#getBitmap ; R2 -> R0		
		 JSR PC, @#drawImage ; Используется R0,R1. Портит R2.
		 RTS PC

;----------------------------------------------------------------------------
; ПОЛУЧИТЬ УКАЗАТЕЛЬ НА ИЗОБРАЖЕНИЕ ПО НОМЕРУ ИЗОБРАЖЕНИЯ
; R0 => R0

getBitmap:      MOV R2, R0
		INC R0
		INC R0
		CMP gameOverFlag, #1
		BNE getBitmap3		
getBitmap2:	SWAB R0
		ASR R0
		ASR R0
		ADD #bmpUn, R0
                RTS PC

getBitmap3:     CMPB R0, #1
		BNE getBitmap2
		DEC R0
		BR getBitmap2

;----------------------------------------------------------------------------
; ГЕНЕРАТОР СЛУЧАЙНЫХ ЧИСЕЛ
; нет => R0 - случайное число. R1 - портит.

rand_state:	dw 0x1245
		
rand:           MOV rand_state, R0
		MOV R0, R1
		ASL R0
		ASL R0
		ASR R1                    
		ASR R1                    
		ASR R1                    
		ASR R1
		ASR R1
		XOR R1, R0
		MOV R0, rand_state

		MOV R0, R1
		SWAB R0
		XOR R1, R0
		MOV @#0177710, R1
		XOR R1, R0
		BIC #0xFF00, R0

		RTS PC

;----------------------------------------------------------------------------
; ДЕЛЕНИЕ
; R0/R1 => R2, остаток в R0

div:		CLR R2
div1:		SUB R1, R0
		BCS div2
		INC R2
		BR div1
div2:		ADD R1, R0
		RTS PC

;----------------------------------------------------------------------------
; ПРОВЕРКА, ВЫИГРАЛ ЛИ ИГРОК
; => Портит все регистры

checkWin:	; Подсчет не открытых клеток без бомб.
		MOV #254, R3
		CLR R1
checkWin2:	 CLR R0
checkWin1:	  JSR PC, @#mul01
		  CMPB playfield(R2), R3
		  BEQ checkWin3
	  	 INC R0
  	  	 CMP gameWidth, R0
	  	 BNE checkWin1
		INC R1
		CMP gameHeight, R1
		BNE checkWin2
		
		; Пользователь выиграл

		; Рисуем смайлик
		MOV #bmpWin, R0
		JSR PC, @#drawSmile

gameOver:	; Конец игры
		MOV #1, R0
		MOV R0, gameOverFlag

		; Показать все бомбы
		JSR PC, @#drawPlayField

checkWin3:	RTS PC
                               
;----------------------------------------------------------------------------
; РАСЧЕТ И ВЫВОД НА ЭКРАН ЛЕВОГО ЧИСЛА
; => Портит все регистры

leftNumber:	; Подсчет кол-ва флагов
		CLR R0
		MOV bombsCnt, R1
leftNumber1:	 CMPB userMarks(R0), #1
		 BNE leftNumber3
		  DEC R1
		  BEQ leftNumber4
leftNumber3:	INCB R0
		BNE leftNumber1

		; Вывод числа на экран
leftNumber4:	MOV R1, R0
	        MOV #040510, R3		; Адрес в видеопамяти
		JSR PC, @#drawNumber

		RTS PC

;----------------------------------------------------------------------------
; ВЫВОД НА ЭКРАН ПРАВОГО ЧИСЛА
; => Портит все регистры
		          
rightNumber:	MOV time, R0		; Исходное число
	        MOV #040573, R3		; Адрес в видеопамяти
		JSR PC, @#drawNumber
		RTS PC

;----------------------------------------------------------------------------
; ВЫВОД ТРЕХЗНАЧНОГО ЧИСЛА НА ЭКРАН
; R0 - число, R3 - адрес в видеопамяти. => Портит все регистры.

drawNumber:	MOV #3, R5		; Кол-во чисел

drawNumber0:	; Получаем первую цифру
		MOV #10, R1		
		JSR PC, @#div

		; Расчет положения битмепа
		SWAB R0
		ASR R0
		ASR R0
		ADD #bmpN0, R0

		; Вывод изобрежния
		MOV #21, R4
drawNumber1:    MOVB (R0)+, (R3)+
		MOVB (R0)+, (R3)+
		MOVB (R0)+, (R3)+
		ADD #61, R3           
		SOB R4, drawNumber1

		; Положение следующего симовола
		SUB #1347, R3

		; Цикл
		MOV R2, R0
		SOB R5, drawNumber0
		
		RTS PC

;-----------------------------------------------
; Вывод смайлика
; => R0 - изображение. Портит R1,R2

drawSmile:	MOV #040435, R1
		MOV #24, R2
drawGood:	MOV (R0)+, (R1)+
		MOV (R0)+, (R1)+
		MOV (R0)+, (R1)+
		ADD #58, R1
		SOB R2, drawGood
		RTS PC

;----------------------------------------------------------------------------
; Рисование игрового поля и курсора
; => Портит все регистры

drawPlayField:	CLR R1
LOOP2:    	 CLR R0
LOOP1:	    	  MOV R0, -(SP)
	    	  MOV R1, -(SP)
  	     	   JSR PC, @#mul01
		   MOVB playfield(R2), R3
  	     	   JSR PC, @#redrawCell012
	    	  MOV (SP)+, R1
	    	  MOV (SP)+, R0
	  	 INC R0
  	  	 CMP gameWidth, R0
	  	 BNE LOOP1
		INC R1
		CMP gameHeight, R1
		BNE LOOP2
		
		JMP @#drawCursor

;----------------------------------------------------------------------------
; ОЧИСТИТЬ ЭКРАН
; => Портит R0, R2

clearScreen:	MOV #040000, R0
		MOV #2048, R2
clearScreen1:	CLR (R0)+
		CLR (R0)+
		CLR (R0)+
		CLR (R0)+
		SOB R2, clearScreen1
		RTS PC

;----------------------------------------------------------------------------
; ЗАМОСТИТЬ ЭКРАН

fillBlocks:	MOV #044000, R0
		MOV #14, R4
fillBlocks3:	MOV #bmpBlock, R1
		MOV #16, R3
fillBlocks2:	MOV #16, R2
fillBlocks1:	MOV (R1)+, (R0)+
		MOV (R1)+, (R0)+
		SUB #4, R1
		SOB R2, fillBlocks1
		ADD #4, R1
		SOB R3, fillBlocks2
		SOB R4, fillBlocks3
		RTS PC

;----------------------------------------------------------------------------
; НАРИСОВАТЬ ИЗОБРАЖЕНИЕ 16x16 С ПРОЗРАЧНОСТЬЮ
; R0 - Изображение, R1 - Куда => Портит R1, R2

drawTransImage: MOV     #16, R2
drawTransImag1:	BIC     (R0)+, (R1)
		BIS     (R0)+, (R1)+
		BIC     (R0)+, (R1)
		BIS     (R0)+, (R1)+
        	ADD     #60, R1                        
		SOB	R2, drawTransImag1
		RTS	PC

;----------------------------------------------------------------------------
; НАРИСОВАТЬ ИЗОБРАЖЕНИЕ 16x16
; R0 - Изображение, R1 - Куда => Портит R1, R2

drawImage:      MOV     #16, R2
drawImage1:	MOV     (R0)+, (R1)+
		MOV     (R0)+, (R1)+
        	ADD     #60, R1
		SOB	R2, drawImage1
		RTS	PC

;----------------------------------------------------------------------------
; ВЫВОД ТЕКСТА

Print:		; Установка координат
		CLR R1
		MOVB (R0)+, R1
		CLR R2
		MOVB (R0)+, R2
		EMT 024		                       

		; Вывод текста
		MOV R0, R1
		MOV #0x00FF, R2
		EMT 020

		; Поиск след строки
Print1:		MOVB (R0)+, R1
		BNE Print1
		CMPB (R0), #255
		BNE Print

		RTS PC

;----------------------------------------------------------------------------
; Изображения

bmpLogo:   	insert_bitmap2 "resources/logo.bmp",  128, 37

bmpCursor:  	insert_bitmap2t "resources/cursor.bmp",  16, 16

bmpF:    	insert_bitmap2 "resources/f.bmp", 16, 16
bmpQ:    	insert_bitmap2 "resources/q.bmp", 16, 16

bmpUn:   	insert_bitmap2 "resources/un.bmp", 16, 16
bmpB:    	insert_bitmap2 "resources/b.bmp",  16, 16
bmp0:    	insert_bitmap2 "resources/0.bmp",  16, 16
bmp1:    	insert_bitmap2 "resources/1.bmp",  16, 16
bmp2:    	insert_bitmap2 "resources/2.bmp",  16, 16
bmp3:    	insert_bitmap2 "resources/3.bmp",  16, 16
bmp4:    	insert_bitmap2 "resources/4.bmp",  16, 16
bmp5:    	insert_bitmap2 "resources/5.bmp",  16, 16
bmp6:    	insert_bitmap2 "resources/6.bmp",  16, 16
bmp7:    	insert_bitmap2 "resources/7.bmp",  16, 16
bmp8:    	insert_bitmap2 "resources/8.bmp",  16, 16

bmpGood: 	insert_bitmap2 "resources/good.bmp", 24, 24
bmpBad:  	insert_bitmap2 "resources/bad.bmp", 24, 24
bmpWin:  	insert_bitmap2 "resources/win.bmp", 24, 24

bmpN0:   	insert_bitmap2 "resources/n0.bmp", 12, 21
bmpN1:   	insert_bitmap2 "resources/n1.bmp", 12, 21
bmpN2:   	insert_bitmap2 "resources/n2.bmp", 12, 21
bmpN3:   	insert_bitmap2 "resources/n3.bmp", 12, 21
bmpN4:   	insert_bitmap2 "resources/n4.bmp", 12, 21
bmpN5:   	insert_bitmap2 "resources/n5.bmp", 12, 21
bmpN6:   	insert_bitmap2 "resources/n6.bmp", 12, 21
bmpN7:   	insert_bitmap2 "resources/n7.bmp", 12, 21
bmpN8:   	insert_bitmap2 "resources/n8.bmp", 12, 21
bmpN9:   	insert_bitmap2 "resources/n9.bmp", 12, 21                          

bmpBlock:   	insert_bitmap2 "resources/block.bmp", 16, 16                       

endOfROM:              

;-----------------------------------------------

pfSize = 256 ; Удобное число для буфера, хотя максимальный размер поля 16x14

gameWidth:	dw 0
gameHeight:	dw 0
gameOverFlag:  	dw 0
cursorX:    	dw 0
cursorY:    	dw 0
playfieldVA:	dw 0
bombsCnt:   	dw 0
bombsPutted:	dw 0
time:	    	dw 0
lastTimer:      dw 0
playfield:    	db pfSize dup(0)
userMarks:    	db pfSize dup(0)

;-----------------------------------------------

make_bk0010_rom "bk0010_miner.bin", EntryPoint, endOfROM
