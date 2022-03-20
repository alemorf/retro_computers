;+---------------------------------------------------------------------------
; RAMFOS
; Инициализация BIOS
; Вызывается только функцией init
;
; 2013-11-01 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

biosInit:	; Очистка переменных начиная с v_dblClear
		lxi	h, v_dblClear
		mvi	b, 47
		xra	a
		sta	v_inverse
loc_C8EA:	 mov	m, a
		 inx	h
		 dcr	b
		jnz	loc_C8EA

		; Инициализация	контроллера цвета черным цветом для очистки экрана
#if INIT_SCREEN_COLOR==100h
		lda	v_selColor
#else
		mvi	a, INIT_SCREEN_COLOR
#endif
		call	setColor

		; Инициализация	клавиатуры
		call	keyMode82	

		; Скрываем нижнюю строку
		call	bottomLineHide

		; Очищаем экран
		call	clearScreen
		
		; Настройка таймера
		lxi	h, IO_TIMER+3
		mvi	m, 36h
		mvi	m, 76h
		mvi	m, 90h
		dcx	h
		mvi	m, 10h
		dcx	h
		mvi	m, 20h
		mvi	m, 4Eh
		dcx	h
		mvi	m, 10h
		mvi	m, 15h
		
		; *** Определение размера ДОЗУ ***

#if WORK_WITHOUT_ARAM
		; Надо вернуть доступ к ДОЗУ, иначе проверка не работает
		mvi	a, 0FDh		; Порт выбора ДОЗУ		
		sta	disableARAM1+1
		sta	disableARAM2+1
#endif

#if TRUE_CHECK_ARAM
		lxi	h, ARAM_PAGE_END
#else
		lhld	v_aramPageEnd	; Это не совсем правильно, так как при программном сбросе проверка будет работать не так, как при аппаратном
#endif
		lda	v_aramMaxPageI
		call	checkARAM
		
#if WORK_WITHOUT_ARAM
		lxi	d, 0		; Начало ДОЗУ
#endif
		; Если ДОЗУ найдено
#if TRUE_CHECK_ARAM
		jnz	aramFounded	; Так короче код испрваленной функции
#else
		jz	aramFounded		
#endif

		; ДОЗУ не найдено
#if WORK_WITHOUT_ARAM
		 ; Настраиваем небольшой диск в основном ОЗУ
		 lxi	d, miniPage
		 lxi	h, miniPageEnd
		 mvi	a, 0FCh		; Порт выбора ОЗУ
		 sta	disableARAM1+1
		 sta	disableARAM2+1
#else
		 ; Пытаемся работать с 48 Кб ДОЗУ
		 lxi	h, 0BFFBh
#endif
aramFounded:	
		shld	v_aramPageEnd
		shld	v_aramPageEnd2
#if WORK_WITHOUT_ARAM
		xchg
		shld	v_aramPageStart
#endif
		; *** Инициализация экрана ***
		lxi	h, a_initScreen
		; Далее printString


		; Этот текст будет встроен в конец кода
#if NICE
#define A_INITSCREEN a_initScreen: .db C_INVERSE, C_TOPLINE, ' ', 0F3h, 0D0h, 0C5h, 0C3h, 0C9h, 0C1h, 0CCh, 0C9h, 0D3h, 0D4h, ' ','M','X','2',' ','R','A','M','F','O','S',C_NORMAL,0
#else                                                                                                                                                                  
#define A_INITSCREEN a_initScreen: .db C_INVERSE, C_TOPLINE, ' ', 0F3h, 0D0h, 0C5h, 0C3h, 0C9h, 0C1h, 0CCh, 0C9h, 0D3h, 0D4h, '_','M','X',92,'R','A','M','F','O','S',92,C_NORMAL,0
#endif
