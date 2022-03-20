;+---------------------------------------------------------------------------
; RAMFOS
; Запуск RKS файла
;
; 2013-11-01 Разработано vinxru
;----------------------------------------------------------------------------

#if RKS_LOADER
		; Это RKS файл
		lxi	h, a_rks
		call	memcmp_ext
		jnz	defExec2
		
		; Загрузить его в память
		call	fileLoad2
		jnz	dlg_error

		; Адрес запуска
		push	h
#if RKS_SHIFT_LOADER
		; Если нажат HP
		lda	IO_KEYB_B		
		ani	2
		rz
#endif
		; Найти файл Monitor2.sys
		lxi	h, a_monitor2_sys
		call	exec1

		; Адрес запуска
		pop	h

		jnz	dlg_error
		
		; При загрузке монитора стандартный стек будет уничтожен
		lxi	sp, 8FFFh

		; Адрес программы
		push	h
		jmp	exec2

a_rks:		.db "RKS"
a_monitor2_sys:	.db "Monitor2 SYS"

defExec2:
#endif