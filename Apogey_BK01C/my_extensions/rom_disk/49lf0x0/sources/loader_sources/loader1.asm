; ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
; Начальный загрузчик
; (с) 22-11-2011 vinxru
; Используется компилятор sjasm

		device zxspectrum48
		org 0h

;----------------------------------------------------------------------------


entryPoint:     ; Адрес ОЗУ (Программа начинается со 100h, а в первом байте указано кол-во страниц для загрузки)
		ld bc, 0FFh

		; Инициализация порта
		ld hl, 0EE03h		
		ld (hl), 90h 

		; R/C=1
		dec hl
		dec hl
		ld (hl), 1

		; Младшие биты и (R/C=0)
loop1:		ld de, 0F000h

loop:		; Пропуск адресов: bank=0, de=0; bank=2; de=2; bank=4; de=4;
bank2:		ld a, 0 ; Тут находится текущий банк *2
		cp e
		jp z, ignorebyte2			
noignorebyte:
		; Спад
		inc hl
		ld (hl), d  ; hl=0EE02h
		dec hl
		ld (hl), e  ; hl=0EE01h (R/C=0)
		
		; Подъем
		inc hl
		ld (hl), 0 ; hl=0EE02h
		dec hl
bank:		ld (hl), 1 ; hl=0EE01h ; Тут находится текущий банк *2+1 (R/C=1)

		; Копирование данных
		ld a, (0EE00h)
		ld (bc), a
		inc bc	
ignorebyte:     ; Цикл
		inc de
		inc de
		ld a, d
		or e
		jp nz, loop

		; В самом первом загруженном байте указано, сколько надо загружать страниц
		push bc
		ld a, (0FFh)
		ld b, a
		ld a, (bank+1)
		cp b
		jp z, 100h
		pop bc

		; Следующий банк
		ld a, (bank+1)
		inc a
		ld (bank2+1), a
		inc a
		ld (bank+1), a
		jp loop1

ignorebyte2:    ld a, 0F0h
		cp d
		jp z, ignorebyte
		jp noignorebyte

;----------------------------------------------------------------------------

		; Размер файла 87 байт. А так же это контроль максимального размера кода.
end1		DUP 87-(end1-entryPoint)
		db 0
		EDUP
end:                
		savebin "loader1.bin",entryPoint,end-entryPoint
