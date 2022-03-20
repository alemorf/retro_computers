;+---------------------------------------------------------------------------
; MXOS
; Обновление драйвера по адресу 0FFC0h и запуск NC.COM
;
; А так же однократный запуск AUTOEX.BAT, если не нажата клавиша.
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

reboot3:	; Инициализация стека
		lxi	sp, STACK_ADDR

		; Копируем драйвер в отведенное для него место
		lxi	h, driverStart
		lxi	d, driverEnd
		lxi	b, 0FFC0h
		call	memmove_bc_hl

		; Обновляем переменные
		lxi	h, j_reboot3
		shld	v_tapeError

		; Код ниже будет выполнен лишь один раз после холодной перезагрузки.
		; То есть при теплой перезагрузке он не вызывается.
reboot3_0:	jmp	reboot3_1
reboot3_1:	lxi	h, reboot3_2
		shld	reboot3_0+1

		; Если нажата клавиша, пропустить запуск B:AUTOEX.BAT
		lda	IO_KEYB_B	
		ani	2
		jz	reboot3_2

		; Запуск файла B:AUTOEX.BAT
		lxi	h, aBAutoex_bat
		call	fileExec

reboot3_2:	; Запуск файла NC.COM
		lxi	h, aANc_com
		call	fileExec

		; Теплая перезагрузка
		jmp	j_reboot3