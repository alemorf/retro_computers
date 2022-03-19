; Загрузчик для банков отличных от нулевого
; (с) 17-11-2011 vinxru
; Используется компилятор sjasm

		device zxspectrum48
		org 0h

;----------------------------------------------------------------------------

entryPoint:     ld d, 1 ; Дозагрузка программы
		ld h, 0 ; Старт ПЗУ = 0
		ld l, h
		ld e, h
		ld b, h
		ld c, h
		call 0FA68h ; Функция загрузки из ПЗУ

		; Выбор нулевого банка ПЗУ
		ld hl, 0EE01h 
		xor a
		ld (hl), a
		inc hl ; hl = 0EE02h 
		ld (hl), a
		ld (hl), 80h
		ld (hl), a

		ld h, a ; Старт ПЗУ = 0
		ld l, a
		ld b, a
		ld c, a
		push bc
		jp 0FA68h ; Функция загрузки из ПЗУ

end:
		savebin "loader0.bin",entryPoint,end
