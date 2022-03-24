// САПЕР ДЛЯ БК0010
// (c) 5-03-2012 VINXRU (aleksey.f.morozov@gmail.com)
// 10-03-2012 Игра переписана на язык С>>


	        ORG 01000;

EntryPoint:     // Инициализируем стек
		SP = #16384;

		// Включаем режим экрана 256x256
		R0 = #0233;
		EMT 016;

		// Отключение курсора
		R0 = #0232;
		EMT 016;

		// Запуск таймера
		@#0177706 = #731;
		@#0177712 = #0160;

		// Выключаем прерывание клавиатуры
		@#0177660 = #64;

		// Очистка экрана
Menu:		clearScreen();

		// Вывод лого		
		R0 = #bmpLogo;
		R1 = #045020;
		R3 = #37;
		do {
		  R2 = #16;
		  do {
		    (R1)+ = (R0)+;
		  } while(R2--);
		  R1 += #32;
		} while(R3--);

		// Вывод меню
		R0 = #txtMenu;
		print();

		do {
		  // Инициализируем генератор случайных чисел.
		  R1 = #256;
                  rand();

		  // Обрабатываем клавиши
		  R0 = @#0177662;

		  // Анализ клавиши
		  R5 = #menuItems;
		  do {
		    R1 = (R5)+;
		    if(R1 == #0) break;
		    if(R1 == R0) goto startGame;
		    R5 += #8;
		  };
		};

//----------------------------------------------------------------------------
// ДАННЫЕ МЕНЮ

txtMenu:	DB 10,12,0222,"0. Лошара",0;
		DB 10,13,     "1. Новичок",0;
		DB 10,14,     "2. Любитель",0;
		DB 10,15,     "3. Профессионал",0;
		DB  9,22,0221,"(c) 2012 VINXRU",0;
		DB  3,23,0223,"aleksey.f.morozov@gmail.com",0,255;

		ALIGN 2;

menuItems:	DW '0', 9, 9, 3, 21006; // клавиша, ширина, высота, кол-во бомб, положение на экране
		DW '1', 9, 9, 10, 21006;
	 	DW '2', 13, 10, 20, 20486;
		DW '3', 16, 14, 43, 18432;
		DW 0;

//----------------------------------------------------------------------------
// ИГРА

startGame:      // Параметры игрового поля
		gameWidth   = (R5)+;
		gameHeight  = (R5)+;
		bombsCnt    = (R5)+;
		playfieldVA = (R5)+;

		// Очистка экрана
		clearScreen();
		fillBlocks();

		// Устанавливаем курсор в центр поля
		cursorX = gameWidth >> #1;
		cursorY = gameHeight >> #1;

		// Очистка основных переменных
		bombsPutted = #0;
		gameOverFlag = #0;
		time = #0;

		// Очистка игрового поля
		R0 = #0;
		R1 = #254;
		do {
		  playfield(R0b) = R1b;
		  userMarks(R0b) = #0;
		} while(R0b++);

		// Вывод смайлика
		R0 = #bmpGood;
		drawSmile();

		// Рисование игрового поля
		drawPlayField();
	
		// Вывод чисел
		leftNumber();
		rightNumber();
		
		
mainLoop:       do {
                  do {
		    // Время
		    if(gameOverFlag!=#1) {
		      if(time!=#999) {
		        // Прошла секунда?
		        R0 = #0;
		        if(@#0177710 > #365) R0++;
		        if(lastTimer != R0) {
		          lastTimer = R0;

		          // Да прошла. Увеличиваем переменную и перерисовываем экран
		          time++;
		          rightNumber();
		        };
		      };
		    };

		    // Ждем, пока не нажмут клавишу
		  } while(#128 & @#0177660 == #0);

		  // Стираем курсора
		  hideCursor();

		  // Код нажатой клавиши
		  R0 = @#0177662;

		  if(R0==#8  ) { 
		    if(cursorX != #0) cursorX--; 
		  } else
		  if(R0==#1Ah) {
		    if(cursorY != #0) cursorY--; } else
		  if(R0==#19h) {
		    cursorX++; if(cursorX == gameWidth) cursorX--; 
		  } else
		  if(R0==#1Bh) {
		    cursorY++; if(cursorY == gameHeight) cursorY--; 
		  } else
		  if(R0==#' ') { 
		    leftClick();
                  } else {
		    rightClick();
  		    hideCursor();
		  };

		  // Рисуем курсор
		  showCursor();
		};

//----------------------------------------------------------------------------

MenuFar:	goto Menu;

//----------------------------------------------------------------------------
// ЛЕВАЯ КНОПКА МЫШИ

leftClick:	// Если бомбы не установлены, установить бомбы
		if(bombsPutted == #0) goto putBombs;

		// Если игра завершена, то выйти в меню
putBombsRet:	if(gameOverFlag != #0) goto MenuFar;

		// Попали в бомбу?
		R0 = cursorX;
		R1 = cursorY;
		mul01();
	        if(playfield(R2b) == #255) goto die;

		// Открыть клетку и все клетки вокруг
		open();

		// Проверить, выиграли ли мы
		checkWin();
	
		// Основной цикл игры	
		return;

//----------------------------------------------------------------------------
// ИГРОК УМЕР

die:		// Вывод смайлика
		R0 = #bmpBad;
		drawSmile();
		goto gameOver;

//----------------------------------------------------------------------------
// ЛЮБАЯ КНОПКА КЛАВИАТУРЫ - УСТАНОВКА ФЛАГА

rightClick:	// Если игра завершена, то ничего не делать
		if(gameOverFlag != #0) goto rightClickRet;

		// Меняем флажки
		R0 = cursorX;
		R1 = cursorY;
		mul01();
		userMarks(R2b)++;
		if(userMarks(R2b) == #3) userMarks(R2b) = #0;

		// Пересчитать левое число
		leftNumber();

rightClickRet:	return;

//----------------------------------------------------------------------------
// ПОМЕСТИТЬ БОМБЫ НА ПОЛЕ

putBombs:	bombsPutted++;

                // Цикл
		R4 = bombsCnt;
		do {
putBombs2:	  // Координата Y
		  R1 = gameHeight;
		  rand();		// R1->R0, R1=R2=? 
		  R3 = R0;

                  // Координата X
		  R1 = gameWidth;
		  rand();		// R1->R0, R1=R2=?
		  R1 = R3;

		  // Бомба не должна быть под крсором
		  if(cursorX==R0) if(cursorY==R1) goto putBombs2;

		  // Расчет адреса в массиве
		  mul01();		// R0,R1->R2

		  // Бомба в этой клетке уже есть
		  if(playfield(R2b) == #255) goto putBombs2;

		  // Ставим бомбу
		  playfield(R2b) = #255;
		} while(R4--);

		goto putBombsRet;

//----------------------------------------------------------------------------
// ПЕРЕРИСОВАТЬ КЛЕТКУ (СТЕРЕТЬ КУРСОР)

hideCursor:	R0 = cursorX;
		R1 = cursorY;
		mul01();		// R0+R1*16 -> R2
		calcCell2();		// R0,R1 -> R1
		R0b = playfield(R2b);   
		getBitmap();		// R0 -> R0
		if(R0b==#bmpUn) {
		  R5b = userMarks(R2b);
		  if(R5 == #1) R0 = #bmpF;
		  if(R5 == #2) R0 = #bmpQ;
		};
drawCursor5:	drawImage();		// R0=R1=R2=?
		return; 

//----------------------------------------------------------------------------
// НАРИСОВАТЬ КУРСОР ПОВЕРХ КЛЕТКИ

showCursor:	R0 = cursorX;
		R1 = cursorY;
		calcCell2();		// R0,R1 -> R1
		R0 = #bmpCursor;
		goto drawTransImage;

//----------------------------------------------------------------------------
// РАСЧЕТ АДРЕСА В ВИДЕОПАМЯТИ ЯЧЕЙКИ ИГРОВОГО ПОЛЯ 
// R0,R1 - Координаты => R1 - адрес

calcCell2:	ASM SWAB R1;
		R1 = R1 << #2 + R0 + R0 + R0 + R0 + playfieldVA;
		return;

//----------------------------------------------------------------------------
// ЛОГИКА ИГРЫ
// R0,R1 - координаты. R3 - счетчик => R2 - портит

check:		if(unsigned R0 >= gameWidth ) goto checkRet;
		if(unsigned R1 >= gameHeight) goto checkRet;
		mul01();
		if(playfield(R2b) == #255) R3++;
checkRet:	return;

//----------------------------------------------------------------------------
// ЛОГИКА ИГРЫ

call8:		R1--;       call81(); 
		R0--; R1++; (R5)();
		R0++; R0++; (R5)();
		R0--; R1++; call81();
		R1--;
		return;

//----------------------------------------------------------------------------
// ЛОГИКА ИГРЫ

call81:         R0--; (R5)();
		R0++; (R5)();
		R0++; (R5)();
		R0--;
		return;

//----------------------------------------------------------------------------
// R0+R1*16 => R2

mul01:		R2 = R1 << #4 + R0;
		return;

//----------------------------------------------------------------------------
// ЛОГИКА ИГРЫ

// Да, я вижу что тут все можно оптимизировать :)

open:		if(unsigned R0 >= gameWidth ) goto openRet;
                if(unsigned R1 >= gameHeight) goto openRet;
		mul01();
		if(userMarks(R2b) != #0) goto openRet;
		if(playfield(R2b) != #254) goto openRet;
		// Посчитать колво бомб вокруг. Результат в R3
		R5 = #check;
		R3 = #0;
		call8();
		R5 = #open;

		// Записываем результат
		mul01();
		playfield(R2b) = R3b;

		// Перерисовываем ячейку
  		push R0, R1 {
		  calcCell2();		// R0,R1 -> R1
		  R0 = R3;
		  getBitmap();		// R0 -> R0
		  drawImage();		// R0=R1=R2=?
		};

		// Если в ячейке 0, то открываем соседние ячейки
		if(R3 == #0) call8();
		
openRet:        return;

//----------------------------------------------------------------------------
// ПОЛУЧИТЬ УКАЗАТЕЛЬ НА ИЗОБРАЖЕНИЕ ПО НОМЕРУ ИЗОБРАЖЕНИЯ
// R0 => R0

getBitmap:      R0 += #2;
		R0 !&= 0FF000h;
		if(gameOverFlag==#0) if(R0==#1) R0=#0;
getBitmap2:	ASM SWAB R0;
		R0 = R0 >> #2 + #bmpUn;
                return; 

//----------------------------------------------------------------------------
// ГЕНЕРАТОР СЛУЧАЙНЫХ ЧИСЕЛ
// R1 - максимум => R0 - случайное число. R1,R2 - портит.

rand_state:	dw 1245h;
		
rand:           R0 = rand_state;
		R2 = R0 << #2;
		R0 = R0 >> #5 ^ R2;
		rand_state = R0;
		R0 = R2;
		ASM SWAB R0;
		R0 ^= R2;
		R2 = @#0177710;
		R0 ^= R2;
		R0 !&= #0FF00h;

		goto div;

//----------------------------------------------------------------------------
// ДЕЛЕНИЕ
// R0/R1 => R2, остаток в R0

div:		R2 = #0;
		do {
		  R0 -= R1;
		  ASM BCS div2;
		  R2++;
		};
div2:		R0 += R1;
		return;

//----------------------------------------------------------------------------
// ПРОВЕРКА, ВЫИГРАЛ ЛИ ИГРОК
// => Портит все регистры

checkWin:	// Подсчет не открытых клеток без бомб.
		R3 = #254;
		R1 = #0;
checkWin2:	do {
		  R0 = #0;
		  do {
checkWin1:	    mul01();
		    if(playfield(R2b) == R3b) goto checkWin3;
		    R0++;
		  } while(R0 != gameWidth);
		  R1++;
		} while(R1 != gameHeight);
		
		// Пользователь выиграл

		// Рисуем смайлик
		R0 = #bmpWin;
		drawSmile();

gameOver:	// Конец игры
		gameOverFlag = #1;

		// Показать все бомбы
		drawPlayField();

checkWin3:	return;
                               
//----------------------------------------------------------------------------
// РАСЧЕТ И ВЫВОД НА ЭКРАН ЛЕВОГО ЧИСЛА
// => Портит все регистры

leftNumber:	// Подсчет кол-ва флагов
		R0 = #0;
		R1 = bombsCnt;
		do {
		  if(unsigned playfield(R0b) >= #254) {
  		    if(usermarks(R0b) == #1) {
		      R1--;
		      ASM BEQ leftNumber4;
		    };
 		  };
		} while(R0b++);

		// Вывод числа на экран
leftNumber4:	R0 = R1;
	        R3 = #040510;
		goto drawNumber;

//----------------------------------------------------------------------------
// ВЫВОД НА ЭКРАН ПРАВОГО ЧИСЛА
// => Портит все регистры
		          
rightNumber:	R0 = time;		// Исходное число
	        R3 = #040573;		// Адрес в видеопамяти

//----------------------------------------------------------------------------
// ВЫВОД ТРЕХЗНАЧНОГО ЧИСЛА НА ЭКРАН
// R0 - число, R3 - адрес в видеопамяти. => Портит все регистры.

drawNumber:	R5 = #3;		// Кол-во чисел
                do {
		  // Получаем первую цифру
		  R1 = #10;
		  div();		// R0/R1 -> частное=, остаток=R0

		  // Расчет положения битмепа
		  ASM SWAB R0;
		  R0 = R0 >> #2 + #bmpN0;

		  // Вывод изобрежния
		  R4 = #21;
		  do {
		    (R3b)+ = (R0b)+;
		    (R3b)+ = (R0b)+;
		    (R3b)+ = (R0b)+;
		    R3 += #61;
		  } while(R4--);

		  // Положение следующего символа
		  R3 -= #1347;

		  // Цикл
		  R0 = R2;
		} while(R5--);		
		return;

//-----------------------------------------------
// Вывод смайлика
// => R0 - изображение. Портит R1,R2

drawSmile:	R1 = #040435;
		R2 = #24;
		do {
		  (R1)+ = (R0)+;
		  (R1)+ = (R0)+;
		  (R1)+ = (R0)+;
		  R1 += #58;
		} while(R2--);
		return;

//----------------------------------------------------------------------------
// Рисование игрового поля и курсора
// => Портит все регистры

drawPlayField:	R4 = #0;
		do {
		  R3 = #0;
		  do {
		    R0=R3;
		    R1=R4;
  	     	    mul01();			// R0,R1 -> R2
		    calcCell2();		// R0,R1 -> R1
		    R0b = playfield(R2b);	// R2 -> R0	
		    getBitmap();		// R0 -> R0
		    drawImage();		// R0=R1=R2=?
		    R3++;
		  } while(R3 < gameWidth);
		  R4++;
		} while(R4 < gameHeight);		
		goto showCursor;

//----------------------------------------------------------------------------
// ОЧИСТИТЬ ЭКРАН
// => Портит R0, R2

clearScreen:	R0 = #040000;
		R2 = #2048;
		do {
		  (R0)+ = #0;
		  (R0)+ = #0;
		  (R0)+ = #0;
		  (R0)+ = #0;
		} while(R2--);
		return;

//----------------------------------------------------------------------------
// ЗАМОСТИТЬ ЭКРАН

fillBlocks:	R0 = #044000;
		R4 = #14;
fillBlocks3:	do {
		  R1 = #bmpBlock;
		  R3 = #16;
fillBlocks2:	  do {
	  	    R2 = #16;
fillBlocks1:	    do {
		      (R0)+ = (R1)+;
		      (R0)+ = (R1)+;
		      R1 -= #4;
		    } while(R2--);
		    R1 += #4;
	  	  } while(R3--);
		} while(R4--);
		return;

//----------------------------------------------------------------------------
// НАРИСОВАТЬ ИЗОБРАЖЕНИЕ 16x16 С ПРОЗРАЧНОСТЬЮ
// R0 - Изображение, R1 - Куда => Портит R1, R2

drawTransImage: R2 = #16;
		do {
		  (R1)  !&= (R0)+;
		  (R1)+ |=  (R0)+;
		  (R1)  !&= (R0)+;
		  (R1)+ |=  (R0)+;
		  R1 += #60;
		} while(R2--); 
		return;

//----------------------------------------------------------------------------
// НАРИСОВАТЬ ИЗОБРАЖЕНИЕ 16x16
// R0 - Изображение, R1 - Куда => Портит R1, R2

drawImage:      R2 = #16;
		do {
		  (R1)+ = (R0)+;
		  (R1)+ = (R0)+;
		  R1 += #60;
		} while(R2--); 
		return;

//----------------------------------------------------------------------------
// ВЫВОД ТЕКСТА

Print:		do {
		  // Установка координат
		  R1 = #0;
     		  R1b = (R0b)+;
		  R2 = #0;
		  R2b = (R0b)+;
		  EMT 024;		                       

		  // Вывод текста
		  R1 = R0;
		  R2 = #0FFh;
		  EMT 020;

		  // Поиск след строки
Print1:		  do { } while((R0b)+ != #0);
		} while((R0b) != #255);
		return;

//----------------------------------------------------------------------------
// Изображения

bmpLogo:   	insert_bitmap2 "resources/logo.bmp",  128, 37;

bmpCursor:  	insert_bitmap2t "resources/cursor.bmp",  16, 16;

bmpF:    	insert_bitmap2 "resources/f.bmp", 16, 16;
bmpQ:    	insert_bitmap2 "resources/q.bmp", 16, 16;

bmpUn:   	insert_bitmap2 "resources/un.bmp", 16, 16;
bmpB:    	insert_bitmap2 "resources/b.bmp",  16, 16;
bmp0:    	insert_bitmap2 "resources/0.bmp",  16, 16;
bmp1:    	insert_bitmap2 "resources/1.bmp",  16, 16;
bmp2:    	insert_bitmap2 "resources/2.bmp",  16, 16;
bmp3:    	insert_bitmap2 "resources/3.bmp",  16, 16;
bmp4:    	insert_bitmap2 "resources/4.bmp",  16, 16;
bmp5:    	insert_bitmap2 "resources/5.bmp",  16, 16;
bmp6:    	insert_bitmap2 "resources/6.bmp",  16, 16;
bmp7:    	insert_bitmap2 "resources/7.bmp",  16, 16;
bmp8:    	insert_bitmap2 "resources/8.bmp",  16, 16;

bmpGood: 	insert_bitmap2 "resources/good.bmp", 24, 24;
bmpBad:  	insert_bitmap2 "resources/bad.bmp", 24, 24;
bmpWin:  	insert_bitmap2 "resources/win.bmp", 24, 24;

bmpN0:   	insert_bitmap2 "resources/n0.bmp", 12, 21;
bmpN1:   	insert_bitmap2 "resources/n1.bmp", 12, 21;
bmpN2:   	insert_bitmap2 "resources/n2.bmp", 12, 21;
bmpN3:   	insert_bitmap2 "resources/n3.bmp", 12, 21;
bmpN4:   	insert_bitmap2 "resources/n4.bmp", 12, 21;
bmpN5:   	insert_bitmap2 "resources/n5.bmp", 12, 21;
bmpN6:   	insert_bitmap2 "resources/n6.bmp", 12, 21;
bmpN7:   	insert_bitmap2 "resources/n7.bmp", 12, 21;
bmpN8:   	insert_bitmap2 "resources/n8.bmp", 12, 21;
bmpN9:   	insert_bitmap2 "resources/n9.bmp", 12, 21;                          

bmpBlock:   	insert_bitmap2 "resources/block.bmp", 16, 16;                       

endOfROM:              

//-----------------------------------------------

pfSize equ 256; // Удобное число для буфера, хотя максимальный размер поля 16x14

gameWidth:	dw 0;
gameHeight:	dw 0;
gameOverFlag:  	dw 0;
cursorX:    	dw 0;
cursorY:    	dw 0;
playfieldVA:	dw 0;
bombsCnt:   	dw 0;
bombsPutted:	dw 0;
time:	    	dw 0;
lastTimer:      dw 0;
playfield:    	db pfSize dup(0);
userMarks:    	db pfSize dup(0);

//-----------------------------------------------

make_bk0010_rom "bk0010_miner.bin", EntryPoint, endOfROM;
