;+---------------------------------------------------------------------------
; MXOS
; Перезагрузка (продолжение)
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

reboot1:	; Для выключения звука
		mvi	a, 36h

		; Включаем ОЗУ
		sta	IO_RAM

		; Выключаем звук		
		sta	IO_TIMER+3

		; Инициализация переменных
		lxi	h, initVars	; Откуда
		lxi	d, initVarsEnd	; Конец
		lxi	b, vars		; Куда
		call	memcpy_bc_hl

		; Установка цвета
#if DISABLE_COLOR_BUG
		mvi	a, INIT_COLOR
		sta	IO_COLOR
#else
		mvi	a, 0Fh  
		sta	IO_KEYB_MODE 
#endif

#if LOAD_FONT
onceInitFont:
		jmp	initFont
#else
		jmp	reboot2
#endif