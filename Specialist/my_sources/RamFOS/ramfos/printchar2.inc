;+---------------------------------------------------------------------------
; RAMFOS
; Обработка специальных кодов символов
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printChar2:	sui	21h
		jnc	setColorChar
		adi	19h
		jz	popColor	; 87h Восстановние кода цвета из стека
		dcr	a
		jz	pushColor	; 88h Запоминание кода цвета по принципу стека (глубина 2 цвета)
		dcr	a
		jz	inverseColor	; 89h Инверсия кода цвета
		dcr	a
		jz	changeInverse	; 8Ah Инверсия фона чернобелого экрана (инверсия инверсии)
		dcr	a
		jz	setInverseNeg	; 8Bh Установка светлого фона черно-белого экрана (потому что A=0 будет инвертировано)
		dcr	a
		jz	setInverse	; 8Сh Установка темного фона черно-белого экрана (потому что A=0)
		dcr	a
		jz	pushCursorLine	; 8Dh Запоминание курсора строки
		dcr	a
		jz	popCursorLine	; 8Eh Восстановление курсора строки
		dcr	a
		jz	clearTopLine	; 8Fh Очистка верхней служебной строки
		dcr	a
		jz	clearBottomLine	; 90h Очистка нижней служебной строки
		dcr	a
		jz	scrollDown	; 91h Сдвииг экрана вних от курсора
		dcr	a
		jz	scrollUp	; 92h Сдвин экрана вверх от курсора
		dcr	a
		jz	pushCursor	; 93h Запоминание курсора экрана
		dcr	a
		jz	popCursor	; 94h Восстановление курсора экрана
		dcr	a
		jz	printFileName	; 95h Вывод имени файла загруженного с диска
		dcr	a
		xchg
		lhld	v_koi8
		dcr	a
		jz	c_koi7		; 97h Включение режиме KOI-7
		dcr	a
		jz	c_koi8		; 98h Включение режиме KOI-8
		dcr	a
		dcr	a
		rnz			; Выход, а дальше 9Ah Сдвиг экрана вверх от нижней служеюной строки до текущей строки курсора
		xchg
		push	h
		inr	l
		inr	l
		mov	a, l
		adi	10
		mov	e, a
		lda	v_screenHeight
		jmp	c_scrolUpEx