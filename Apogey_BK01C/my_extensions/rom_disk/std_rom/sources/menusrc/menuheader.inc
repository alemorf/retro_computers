		org 0h
begin:
		ld d, (end+255)/256 ; Дозагрузка программы
		ld h, 0 ; Старт ПЗУ = 0
		ld l, h
		ld e, h
		ld b, h
		ld c, h
		call 0FA68h ; Функция загрузки из ПЗУ
