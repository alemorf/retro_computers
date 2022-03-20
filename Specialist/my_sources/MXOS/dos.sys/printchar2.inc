;+---------------------------------------------------------------------------
; MXOS
; Вывод символа на экран (или принтер)
;
; На входе
;  с - символ
;
; На выходе
;  регистры не сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printChar2:	; Помещаем в HL координаты курсора
		lhld	v_cursorY

		; Продолжаем, если не включен режим обработки ESC последовательности (v_escMode==0FFh)
		lda	v_escMode
		inr	a
		jnz	printChar_esc

		; Тут v_escMode==0FFh

		; Если это печатные символы (>=20h), переходим к печати
		mov	a, c
		cpi	' '
		jnc	printChar_real

		; Это табуляция
		cpi	9
		jz	printChar_c9	; там v_cursorX+=24 и ret

		; Любой символ кроме ESC
		cpi	1Bh
		jnz	printChar3

		; Далее ESC. Включаем режим обработки ESC последовательности (v_escMode=0)
		xra	a
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------
; Преобразование символа из KOI-7 в KOI-8 и вывод на экран (служебные коды 
; так же будут выводится)

printChar_real:	; Символ для печати
		mov	c, a

		; Продолжаем, если включен режим KOI-7 
		lda	v_koi8
		inr	a
		jnz	printChar_real2

		; Если символ больше или равен 0C0h просто выходим
		mov	a, c
		cpi	0C0h
		rnc

		; Если символ находится в пределах 60h ... 7Fh, увеличиваем его код на 80h
		cpi	60h
		jc	printChar_real2
		cpi	80h
		jnc	printChar_real2
		adi	80h
		mov	c, a

; ---------------------------------------------------------------------------
; Вывод символа на экран в KOI-8 (служебные коды так же будут выводится)

printChar_real2:	
		; Тут полиморфизм
		lda	v_inverse
		ana	a
printChar_poly:	cz	normalVideo

		; Если v_charGen не равен 0FFFFh, то используется знакогнератор по адресу v_charGen*8
		lhld	v_charGen
		mov	a, h
		inr	a
		jnz	printChar_alt
		mov	a, l
		inr	a
		jnz	printChar_alt

		; Иначе используем символы из ПЗУ. 
		; Адрес символа в ПЗУ (de = 0x800 + c*8)
		lxi	h, 100h		
		mvi	b, 0
		dad	b
		dad	h
		dad	h
		dad	h
		xchg

		; Промежуточное место для символа
		lxi	h, v_char
		push	h

		; Копируем 8 байт из ПЗУ
		sta	IO_ROM
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		inx	h
		inx	d
		ldax	d
		mov	m, a
		sta	IO_RAM

		; Вывод символа
		pop	d
		jmp	printChar_de

; ---------------------------------------------------------------------------
; Обработка режима ESC+F

printChar_esc80:; Если символ с кодом 0, выключаем режим обработки ESC
		mov	a, c
		ora	a
		jz	printChar_esc80_exit

		; Обработка кодов <20h
		cpi	20h
		jc	printChar3

		; Если код >= 80h, выйти
		cpi	80h
		rnc

		; Если c >= 40h, вывести на экран c+40h
		cpi	40h
		jnc	printChar_esc80_2

		; Иначе вывести c - 20h
		sui	20h ; ' '
		mov	c, a
		jmp	printChar_real2

; ---------------------------------------------------------------------------

printChar_esc80_2:
		; Если c >= 40h, вывести на экран c+40h
		adi	40h
		mov	c, a
		jmp	printChar_real2

; ---------------------------------------------------------------------------

printChar_esc80_exit:
		dcr	a
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------
; Печать символа в ESC-режиме

printChar_esc:	; Перейти если v_escMode=80h
		lda	v_escMode
		cpi	80h
		jz	printChar_esc80

		; Выключить режим обработки ESC последовательности
		push	psw
		mvi	a, 0FFh
		sta	v_escMode
		pop	psw

		; Перейти если v_escMode==0
		ora	a
		jz	printChar_esc0

		; Перейти если обработка ESC+Y (v_escMode==1)
		dcr	a
		jz	printChar_esc1

		; Перейти если v_escMode==2
		dcr	a
		jz	printChar_esc2

		; Перейти если v_escMode==3
		dcr	a
		jz	printChar_esc3

		; Выйти
		ret

; ---------------------------------------------------------------------------
; Обработка ESC+Y

printChar_esc1:	; Если код меньше 20h или больше 20h + 24, то пропускаем установку Y
		mov	a, c
		cpi	20h + 25
		jnc	loc_C693
		sui	20h
		jc	loc_C693

		; cursorY = 8 + a*10
		add	a
		mov	c, a
		add	c
		add	c
		add	c
		add	c
		adi	8
		sta	v_cursorY

loc_C693:	; Следующий символ будет обработан в printChar_esc2
		mvi	a, 2
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------
; Обработка ESC+Y

printChar_esc2:	; Если код меньше 20h или больше 20h + 63, то пропускаем установку X
		mov	a, c
		cpi	60h
		rnc
		sui	20h
		rc

		; cursorX = c*3;
		mov	c, a
		add	a
		add	c
		sta	v_cursorX
		ret

; ---------------------------------------------------------------------------
; Обработка первого символа ESC последовательности

printChar_esc0:	; Если код больше 20h
		mov	a, c
		cpi	'(' ; 28h
		jz	printChar_e28
		cpi	')' ; 29h
		jz	printChar_e29
		cpi	'P' ; 50h
		jz	printChar_eP
		sui	'A' ; 41h
		jz	printChar19
		dcr	a ; 'B' 42h
		jz	printChar1A
		dcr	a ; 'C' 43h
		jz	printChar18
		dcr	a ; 'D' 44h
		jz	printChar08
		dcr	a ; 'E' 45h
		jz	printChar1F
		dcr	a ; 'F' 46h
		jz	printChar_eF
		dcr	a
		dcr	a ; 'H' 48h
		jz	printChar0C
		dcr	a ; 'I' 49h
		jz	printChar_eI
		dcr	a
		dcr	a
		sui	14 ; 'Y' 59h
		jz	setEscMode_eY

		; Вывод символа
		jmp	printChar2

; ---------------------------------------------------------------------------
; Обработка ESC+Y.

setEscMode_eY:	; Следующий символ будет обработан в printChar_esc1 
		mvi	a, 1
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------

printChar18:	mvi	c, 18h
		jmp	printChar2

; ---------------------------------------------------------------------------

printChar08:	mvi	c, 8
		jmp	printChar2

; ---------------------------------------------------------------------------

printChar1F:	mvi	c, 1Fh
		jmp	printChar2

; ---------------------------------------------------------------------------

printChar0C:	mvi	c, 0Ch
		jmp	printChar2

; ---------------------------------------------------------------------------
; Обработка ESP+P. Вклчюение режима эхопечати на принтере

printChar_eP:	mvi	a, 3
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------

printChar19:	mvi	c, 19h
		jmp	printChar2

; ---------------------------------------------------------------------------

printChar1A:	mvi	c, 1Ah
		jmp	printChar2

; ---------------------------------------------------------------------------
; Режим эхопечати на принтере. Включается ESC+P

printChar_esc3:	; Выходим, из режима, если код нулевой
		mov	a, c
		ora	a
		rz

		; Печать на принтере
		call	printer

		; Печать на экране
		call	printChar2

		; Находимся в этом режиме до кода 0 или ESC
		mvi	a, 3
		sta	v_escMode
		ret

; ---------------------------------------------------------------------------
; Продолжение обработки ESC+I. Перемещение курсора вверх с прокруткой экрана

printChar_eI_2:	; Если cursorY > 18, перемещаем курсор вверх и выходим
		cpi	19
		jnc	printChar2

		; Устанаваливаем v_cursorY=8
		mvi	a, 8
		sta	v_cursorY
		ret

; ---------------------------------------------------------------------------
; Обработка ESC+I. Перемещение курсора вверх с прокруткой экрана

printChar_eI:	; Используется дальше функцией printChar2
		mvi	c, 19h

		; Прокручиваем экран вних, только если v_cursorY == 8.
		; иначе переходим на printChar_eI_2
		lda	v_cursorY
		cpi	8
		jnz	printChar_eI_2