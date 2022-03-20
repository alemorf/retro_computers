;----------------------------------------------------------------------------
; RAMFOS
; Файловая панель
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if ALL_CHARS
#define BORDER_BL  27,12
#define BORDER_BL1 12
#define BORDER_B   27,13
#define BORDER_B1  13
#define BORDER_BR  27,24
#define BORDER_BR1 24
#define BORDER_L   27, 8
#define BORDER_L1  8
#define BORDER_R   27, 10
#define BORDER_R1  10
#define BORDER_H   27, 25
#define BORDER_H1  25
#else
BORDER_BL  = 15h
BORDER_BL1 = 15h
BORDER_B   = 14h
BORDER_B1  = 14h
BORDER_BR  = 16h
BORDER_BR1 = 16h
BORDER_L   = 11h
BORDER_L1  = 11h
BORDER_R   = 6
BORDER_R1  = 6
BORDER_H   = 6
BORDER_H1  = 6
#endif

dlg_loadFile:	; Активная страница
		lda	v_page
		ani	0Fh
		; Режим выбора файла (6 ой бит)
		ori	40h
		mov	b, a
		jmp	dlg_main

; ---------------------------------------------------------------------------

.include "fileSetAddr.inc"
.include "fileSave.inc"	; Продолжение
.include "fileChanged.inc"
.include "fileFindFree.inc"

; ---------------------------------------------------------------------------
; УДАЛЕНИЕ ДАТЫ

dlg_f2_alt:	; Если режим выбора файла, то выходим
		mov	a, b
		ral
		ral
		rc

		; Вывод сообщения "дату удалить"
		lxi	d, a_deleteDate
		call	dlg_msgYesNo

.include "deleteDate.inc"

		; Далее init

; ---------------------------------------------------------------------------

.include "init.inc"	; Продолжение в dlg_main

; ---------------------------------------------------------------------------

dlg_main:	
		; Очищаем экран, перерисовываем заголовок и нижнюю строку
		call	dlg_pageChanged
	
dlg_main_0:
		; Сохраняем текущий файл и положение курсора
#if DLG_CURSOR_AT_TOP
		xchg
		lhld	v_curFile
		push	h
		lhld	v_cursorPos
		push	h
		xchg
#endif	
		; Выводим все файлы на экран
dlg_main_1:	 call	fileLoadHeader
		 push	psw
		  call	dlg_printFile
		 pop	psw
		 lhld	f_nextFile
		jz	dlg_main_1

#if NICE
dlg_z1:
		call	getCursorPos
		mov	a, h
		sui	16h
		jnc	dlg_z0
		; 46 пробелов
		lxi	b, (46 << 8) + ' '
		call	printChars	
		; Правая граница
		call	dlg_rightEdge
		jmp	dlg_z1
dlg_z0:		
#endif		

		; Рисуем нижнюю границу
		call	dlg_bottomEdge
		; Восстанавливаем положение курсора
#if DLG_CURSOR_AT_TOP
		pop	h
		shld	v_cursorPos
		pop	h
		shld	v_curFile
#else
		lhld    v_printedFile
#endif	
		call    dlg_reloadItem

		call    printStringEx
#if NICE==0
		.db C_BEEP
#endif
		.db C_POPCURSORL, C_PUSHCURSORS, C_NORMAL, 0

		lhld	v_curFile
		jmp	dlg_main_0

; ---------------------------------------------------------------------------

dlg_msgYesNo:	; Вывод сообщения
		call	dlg_msg

dlg_yesNo:	; Ввод строки из 4-х сиволов
		lxi	h, buffer
		lxi	d, 4FFh
		call	j_input
		mov	m, a

		; Если нажат ENTER, печатаем символ 0E и выходим
		mvi	a, 0Eh
		jc	j_printCharA	; Выход

		; Если нажат не ESC, повторяем
		jnz	dlg_yesNo

		; Выкидываем адрес возрата
		pop	h
		
loc_F9D0:	; Стираем то, что нарисовали
		call	dlg_bottomEdge

		; Перезагрузить и перерисовать выбранный файл
		lhld    v_curFile
		jmp     dlg_reloadItem

; ---------------------------------------------------------------------------
; Рисование нижней границы

dlg_bottomEdge:
		; Темный фон, восстановление курсора экрана, удаление, какой то символ
		call	printStringEx
		.db 8Ch, 94h, 8, BORDER_BL, 0
	
		; 46 символов 0x14
		lxi	b, 2E00h | BORDER_B1

		call	printChars

		; Символ 16, восстановление курсора строки
		call	printStringEx
		.db BORDER_BR, 8Eh, 0

		ret

; ---------------------------------------------------------------------------
; Клавиша вниз.

dlg_down:	; Если это последний файл, переходим на следующую страницу
		call	dlg_isLastLine
		jnc	dlg_nextPage

		; Если это последняя строка на экране, перерисовываем экран
		; так что наша строка оказывается сверху.
		lda	v_dlgOffset+1
		dcr	a
		cmp	c
		jz	dlg_drawItems

		; Помещаем в стек адрес следующего файла
		lhld	f_nextFile
		push	h

		; Стираем курсор
		call	printFileHeaderDark
		
		jmp	dlg_upDownInt
		
; ---------------------------------------------------------------------------

dlg_nextPage:	; Следующая страница (в регистре b)
		call	pageNext

		; Это была последняя страница
		rc

		; Страница была изменена
		jmp	dlg_pageChanged

; ---------------------------------------------------------------------------

dlg_prevPage:	; Если это нулевая страница, выходим
		mov	a, b
#if ARAM_MAX_PAGE <= 7
		ani	7
#else
		ani	0Fh	; Старшие биты выполняют спец функции
#endif
		jz	dlg_drawItem

		; Уменьшаем страницу
		dcr	b
		jmp	dlg_pageChanged

; ---------------------------------------------------------------------------

dlg_up:		; Если это первая строка, то перейти на предыдущую страницу
		lhld	v_curFile
		call	j_cmp_hl_de
		jz	dlg_prevPage

		; Непонятно что в с
		mov	a, c
		cpi	3
		jz	dlg_pageChanged

.include	"filePrev.inc"

		; Сохраняем адрес файла
		push	b

dlg_upDownInt:	; Стираем курсор
		call	printFileHeaderDark

dlg_upDownInt2:
		; Перемещаем курсор вверх или вниз
		lda	v_lastKey
		call	j_printCharA

		; Восстаналваем HL
		pop	h

dlg_reloadItem:	; Загрузить заголовок файла
		call	fileLoadHeader

dlg_drawItem:	; Вывести название файла
		call	printFileHeaderLight
		mov	c, d

		; Ждем символ с кодом <0x20
dlg_0:		call	keyWaitNoCursor
		cpi	20h
		jnc	dlg_0

		sta	v_lastKey

		; de - начало диска
		lhld	v_pageStart
		xchg

		cpi	19h
		jz	dlg_up
		cpi	1Ah
		jz	dlg_down
		cpi	0Dh
		jz	dlg_enter
		cpi	1Bh
		jz	dlg_esc		; ESC
		ora	a
		jz	dlg_f1		; F1
		dcr	a
		jz	dlg_f2		; F2
		dcr	a
		jz	dlg_f3		; F3
		dcr	a
		jz	dlg_f4		; F4
		dcr	a
		jz	dlg_f5		; F5
		dcr	a
		jz	dlg_f6		; F6
		dcr	a
		jnz	dlg_drawItem
		; Продолжение в startDebuger

; ---------------------------------------------------------------------------

.include "startEditorDebuger.inc"
.include "keyWaitNoCursor.inc"
.include "memcmp_hl_de_c.inc"

; ---------------------------------------------------------------------------

dlg_enter:	call	dlg_isLastLine
		jz	dlg_drawItem

#if OPEN_ANY_FILE==0
		; Сравнить расширение выбранного файла с установленным расширением
		lxi	h, v_header2_ext
		call	memcmp_ext
#endif
		; Если это режим выбора файла
		mov	a, b
		ral
		ral
#if OPEN_ANY_FILE
		jc	dlg_enter_1
#else
		jc	dlg_enter_0
#endif	

.include "rks.inc"

		; Допускаются только расширения EXE и COM
		lxi	h, a_exe		; "EXE"
		call	memcmp_ext
		lxi	h, a_com		; "COM"
		cnz	memcmp_ext

		; Недопустимое расширение, переходим в основной цикл
dlg_enter_0:	jnz	dlg_drawItem

dlg_enter_1:	lhld	v_header_start
		xchg

		; Режим выбора
		jc	dlg_select

		call	fileLoadComEx
		jnz	dlg_error

		;
		xthl
		jmp	loc_FB05

; ---------------------------------------------------------------------------

dlg_f1:		; Выводим сообщение
		lxi	d, a_copy
		call	dlg_checkMsg
		rz

		; Ввод числа в v_header_start
		call	dlg_yesNo
		lhld	v_header_start	; Зачем?
		cm	j_strToHex	; Преобразовать строку DE в число HL
		jz	dlg_error

fileLoadSetAddr:; Установить новый адрес загрузки
		; de = v_header_start = hl; 
		; hl = v_header_stop  = f_fileBodySize + hl;
		call	fileChangeAddr

		; Если режим выбора файла, то сохраняем заголовок файла.
		; В заголовке мы только что изменили адрес загрузки
		mov	a, b
		ral
		ral
		jnc	fileSaveHeader
		
dlg_select:	; Загрузить файл в память
		call	fileLoadComEx
		jnz	dlg_error
		pop	h

loc_FB05:	push	b
		 ; Вывести имя файла
		 call	printFileHeaderName
		 ; Сохранить информацию о загруженном файле
		 call	memcpy_fd_fd2
		pop	b

loadDStartDStop:; de=v_header_stop, hl=v_header_start
		lhld	v_header_stop
		xchg
		lhld	v_header_start
		ret

; ---------------------------------------------------------------------------

; de = v_header_start = hl; v_header_stop = f_fileBodySize+hl;

fileChangeAddr: shld	v_header_start
		xchg
		lhld	f_fileBodySize
		dad	d
		shld	v_header_stop
		ret

; ---------------------------------------------------------------------------

.include "fileLoad.inc"

; ---------------------------------------------------------------------------

dlg_esc:	; Если это не режим выбора файла, ничего не делаем
		mov	a, b
		ral
		ral
		rnc

		; Возвращаемся в программу		
		pop	h
		cmc
		ret

; ---------------------------------------------------------------------------

.include "fileLoadHeader.inc"

; ---------------------------------------------------------------------------
; Скопировать имя выбранного файла с v_header2_name

memcpy_fd_fd2:	lxi	h, v_header
		lxi	d, v_header2
memcpy_de_hl_15:mvi	c, 14

.include "memcpy_de_hl_c.inc"
.include "fileLoadHeader2.inc"

; ---------------------------------------------------------------------------

printFileHeaderLight:
		; Если сделать курсор цветным, то цвет будет задевать рамку. 

		; Инверсия
		mvi	a, C_INVERSE
		call	j_printCharA

printFileHeaderDark:
		; Функция сохранит положение курсора строки, но не восстановит его
		; Выведет на экран имя файла
		; После вывода имени функция установит темный фон
		call	printFileHeaderName2

popCursorLine2:	; Восстановить курсор строки
		mvi	a, C_POPCURSORL
		jmp	j_printCharA

; ---------------------------------------------------------------------------
; Функция сохранит положение курсора строки, но не восстановит его
; Выведет на экран имя файла
; После вывода имени функция установит темный фон

printFileHeaderName2:
		call	pushCursorLine2
		call	j_getCursorPos
		xchg

printFileHeaderName:
		mvi	c, 12
		lxi	h, v_header_name
printFileHeaderName_0:
		 mov	a, m
		 inx	h
		 call	j_printCharA
		 dcr	c
		jnz	printFileHeaderName_0

		; Установка темного фона
		mvi	a, C_NORMAL
		jmp	j_printCharA

; ---------------------------------------------------------------------------

dlg_printFile:	push	psw
		 call	j_getCursorPos
		 mov	a, h
v_dlgOffset:	 sui	16h
		pop	h

		; if(a >= 0x16)	return;
		rnc			
		
		; D272 = v_curFile
		push	h
#if DLG_CURSOR_AT_TOP==0
		 lhld	v_curFile
		 shld	v_printedFile
#endif		
		pop	psw

		; Если на входе в функцию был NZ
		jnz	loc_FC7A

		; Вывести имя файла
		call	printFileHeaderName2

		; Разделитель
		call	dlg_printSep

		; Если файл изменен
		mov	a, m
		call	j_printCharA
		inx	h

		; Дата
		mvi	c, 3
loc_FC1E:        mov	a, m
		 inx	h
		 call	j_printHex
		 dcr	c
#if NICE
		 jz	loc_FC1E_
		 mvi	a, '-'
		 call	j_printCharA
		jmp	loc_FC1E
loc_FC1E_:
#else
		jnz	loc_FC1E
#endif
		
		; Разделитель
		call	dlg_printSep

		; Информация о файле
		call	dlg_printFileInfo

		; Выводим длину
		lhld	f_fileBodySize
		inx	h

printNumber:			
		; Разделитель
		call	dlg_printSep

		; Вывод	HL на экран в 10чном виде
		lxi	d, 10000	
		call	divAndPrint
		lxi	d, 1000
		call	divAndPrint
		lxi	d, 100
		call	divAndPrint
		lxi	d, 10
		call	divAndPrint
		mov	a, l
		adi	'0'
		call	j_printCharA
		
		; Правая граница
dlg_rightEdge:
#if ALL_CHARS
		mvi	c, BORDER_R1
		call	printCharAll
#else
		mvi	a, BORDER_R1
		call	j_printCharA
#endif	
		; Правый край
		lxi	h, a_rightEdge
		jmp	j_printString

; ---------------------------------------------------------------------------

dlg_printFileInfo:		
		call	loadDStartDStop	; de=v_header_stop, hl=v_header_start
#if NICE
		mvi	c, '-'
#else
		mvi	c, ','
#endif
		call	printHexWord	; printHexWord(v_header_start)
		xchg
#if NICE
		mvi	c, ' '
#else
		inr	c		; c = '-'
#endif
		call	printHexWord	; printHexWord(v_header_stop)
#if NICE
		mvi	c, BORDER_H1
		call	printCharAll
#endif
		lhld	v_header_crc	; c = ?
		mvi	c, C_NORMAL
		; Продолжение на printHexWord

; ---------------------------------------------------------------------------

.include "printHexWord.inc"

; ---------------------------------------------------------------------------

loc_FC7A:	; Функция сохранит положение курсора строки, но не восстановит его
		; Выведет на экран имя файла
		; После вывода имени функция установит темный фон
		call	printFileHeaderName2

#if NICE
		; 27 пробелов
		lxi	b, 1B20h	; b-колво, с-символ
#else
		; 26 пробелов
		lxi	b, 1A20h	; b-колво, с-символ
#endif
		call	printChars	
		
		; Свободное место
		lhld	v_pageFreeTotal
		jmp	printNumber

; ---------------------------------------------------------------------------

.include "printChars.inc"

; ---------------------------------------------------------------------------

divAndPrint:	mvi	c, '0'-1
loc_FC93:	 inr	c
		 call	sub_hl_de
		jnc	loc_FC93
		dad	d
		jmp	j_printChar
		
; ---------------------------------------------------------------------------

.include "filesetpage.inc"

; ---------------------------------------------------------------------------

dlg_f6:		
#if NO_MXDOS==0
		; Если в номере диска 7, 6 биты не установлены, запускаем MXDOS
		mov	a, b
		ani	0C0h
		cz	loadMxDos
#endif
		; Запустить не удалось, меняем на противоположный 7 бит
		mov	a, b
#if NO_ROM_SWITCH_BUG
		ani	0F0h
#endif
		xri	80h
		mov	b, a

dlg_pageChanged:; Устаналиваем активную страницу
		call	fileSetPage

dlg_drawItems:				; CODE XREF: dlg_down+Bj
		push	h
		 ; Копируем в заголовок установленный фильтр
		 lxi	h, v_header2_ext
		 lxi	d, a_panelFilter
		 mvi	c, 2
		 call	memcpy_de_hl_c	; memcpy(de, hl, c+1)

		 ; Копируем туда же активную страницу
		 mov	a, b
#if ARAM_MAX_PAGE <= 7
		 ani	7
#else
		 ani	0Fh	; Старшие биты выполняют спец функции
		 cpi	9
		 jc	correct
		  adi	'A'-9-'1'
correct:
#endif
		 adi	'1'
#if NICE
		 sta	p_pageNum
#else
		 inx	d
		 stax	d
#endif
		pop	h

dlg_redraw:
	        ; Выводим панель
		call	printStringEx

		.db C_INVERSE, C_BOTTOMLINE
		.text " F1-COPY F2-DELETE F3-MLOAD F4-MSAVE F5-EDIT F6-DOS F7-DEBUG"
		.db C_NORMAL
#if NICE
		.db 0B0h				; Контрастно
#else
		.db C_CLEARSCREEN			; очистка экрана
#endif
#if NICE
		.db 1Bh, 'Y', 20h+2, 20h+8		; положение панели
#else
		.db 1Bh, 'Y', 20h+2, 20h+7		; положение панели
#endif
		.db 17h, 93h, 8Bh
		.db 'R'
a_panelOA:	.db "AM"
#if NICE
		.db '\'
p_pageNum	.text "0 "
a_panelFilter:	.text "          "
#else
		.text "_V6.0"
		.db 92
a_panelFilter:	.db 92,92,92
		.db '\'
p_pageNum	.db "0  "
#endif
		.db 0C4h, 0C1h,	0D4h, 0C1h ; дата
		.db  ' ', ' ', ' ', ' '
		.db 0C1h, 0C4h, 0CEh ; "адн"
		.db ' '
#if NICE
		.db ' '
		.db 0C1h, 0C4h, 0CBh ; "адк"
		.db ' ', ' ', ' '
		.db 0D3h, 0D5h, 0CDh, 0CDh, 0C1h ; "сумма"
		.db ' '
#else
		.db 2Ch
		.db 0C1h, 0C4h, 0CBh ; "адк"
		.db ' '
		.db 2Dh
		.db 0D3h, 0D5h, 0CDh, 0CDh, 0C1h ; "сумма"
		.db ' '
		.db ' '
#endif
		.db 0C4h, 0CCh, 0C9h, 0CEh, 0C1h ; "длина"
		.db ' '
		.db 8Ch ; темный фон
#if NICE
		.db 0B8h				; Серый фон
#endif
a_rightEdge:	.db 94h, 1Ah, 8, BORDER_L, 93h, 0 ; восстановление курсора экрана, вниз, влево, |, запоминание курсора экрана
#if NO_MXDOS==0
		sta	IO_FLOPPY_HEAD
#endif	
pushCursorLine2:; Сохранить курсор строки
		mvi	a, 8Dh
		jmp	j_printCharA

; ---------------------------------------------------------------------------

dlg_printSep:	call	printStringEx
		.db C_NORMAL, ' ', BORDER_H, 
#if NICE==0
		.db ' '
#endif
		.db 0
		ret

; ---------------------------------------------------------------------------

.include "pageReadBlock.inc"

; ---------------------------------------------------------------------------

dlg_checkMsg:	; Выйти с флагом Z, если выбрана последняя строка
		push	d                
		call	dlg_isLastLine
		pop	d
		rz

dlg_msg:	; Вывод сообщения
		push	psw
		 call	printStringEx
		 .db C_POPCURSORS, C_LEFT, C_INVERSE, ' ', ' ', ' ', 0C6h, 0C1h, 0CAh, 0CCh ; файл тип
		 .db ' ', ' ', 2Eh, 0D4h, 0C9h, 0D0h, ' ', 0Eh, ' ', 0
		 
		 xchg
		 call	j_printString

		 call	printStringEx
aa:		 .text ":?"
		 .db C_LEFT, 0
		pop	psw
		ret

; ---------------------------------------------------------------------------

dlg_isLastLine:	lhld	v_pageFreePtr
		xchg
		lhld	v_curFile
		jmp	j_cmp_hl_de

; ---------------------------------------------------------------------------

.include "fileGetStartAndSize2.inc"	; fileGetStartAndSize2 продолжается на sub_hl_de
.include "sub_hl_de.inc"

; ---------------------------------------------------------------------------

dlg_f2:		; Вывод текста "удалить"
		lxi	d, a_delete
		call	dlg_checkMsg
		jz	dlg_f2_alt

		; Пользователь должен нажать Enter
		call	dlg_yesNo

		; Удалить файл
		call	fileDelete

		; Сдвинуть экран вверх
#if NICE==0
		call	printStringEx
		.db C_NORMAL, C_POPCURSORL, 19h, C_SCROLLUPEX, 0
#endif
		; Перерисовать экран
		ret

; ---------------------------------------------------------------------------

.include "compareFileName.inc"
.include "fileDelete.inc"
.include "fileFromTapeCom.inc"

; ---------------------------------------------------------------------------

dlg_f3:		; Выводим "сравнить"
		lxi	d, a_verify
		call	dlg_checkMsg

		; Если файл не выбран
		jz	dlg_f3_alt

		; ?
		call	dlg_yesNo

		; Продолжение в fileVerify

; ---------------------------------------------------------------------------

.include "fileVerify.inc"

; ---------------------------------------------------------------------------

dlg_f3_alt:	; Вывод на экран строки "Чтение"
		lxi	d, a_load
		call	dlg_msgYesNo

.include "fileFromTape.inc"	; fileFromTape продолжается

dlg_error:	; Выводим сообщение "ОШИБКА" + звуковой сигнал
		call	printStringEx
		.db 0CFh, 0DBh,	0C9h, 0C2h, 0CBh, 0C1h,	C_BEEP, 0 ; ошибка

waitEsc:	; Ждем, пока пользователь не нажмет ESC
		 call	keyWaitNoCursor
#if NICE
		 cpi	' '
#else
		 cpi	1Fh
#endif
		jnz	waitEsc
		; Выходим с установленным флагом C
		stc
		ret

; ---------------------------------------------------------------------------
; Вывод сообщения МАЛ ДИСК

outOfSpace:	call	printStringEx
		.db 0CDh, 0C1h,	0CCh, 20h, 0C4h, 0C9h, 0D3h, 0CBh, 0 ; мал диск
		jmp	waitEsc

; ---------------------------------------------------------------------------

.include "printStringEx.inc"

; ---------------------------------------------------------------------------
; Соханить файл на магнитофон

dlg_f4:		; Если файл не выбран, выходим
		lhld	f_nextFile
		call	j_cmp_hl_de
		rz

		; Вывод "запись"
		lxi	d, a_save
		call	dlg_msgYesNo

		call	dlg_isLastLine
		lhld	v_pageStart
		jz	fileToTape

		mvi	c, C_NORMAL

		lhld	v_curFile
		lxi	d, 0Fh
		dad	d
		call	pageWrite
		
		lhld	f_fileSize
		xchg
		lhld	v_curFile

.include "fileToTape.inc"

; ---------------------------------------------------------------------------
; Переименовать файл

dlg_f5:		; Вывести "имя:"
		lxi	d, a_name
		call	dlg_checkMsg

		; Если файл не выбран
		jz	startEditor

dlg_f5_retry:	; Устанавливаем курсор на имя файла
		call	popCursorLine2

		; Редактирование имени файла
		lxi	h, v_header_name
		lxi	d, 0CFFh
		call	j_input
	
		; Был нажат ESC	
		jz	loc_F9D0

		; Была нажата служебная клавиша
		jnc	dlg_f5_retry

		; Имя не введено, перерисовать
		rp

		; Продолжение в fileSaveHeader

; ---------------------------------------------------------------------------