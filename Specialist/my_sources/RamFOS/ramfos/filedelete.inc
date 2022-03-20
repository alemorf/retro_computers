;+---------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа F851
; Удаление файла найденного программой F84B
;
; Файл должен быть обязательно найден функцией fileFind (F84B), иначе
; будет повреждена структура файлов.
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileDelete:	; Расчет длины полезных данных после нашего файла, которые
		; надо сдвинуть.
		; de = v_pageFreePtr - f_nextFile - 1 
		lhld	f_nextFile
		xchg
		lhld	v_pageFreePtr
		dcx	h		
		call	sub_hl_de
		xchg

		; Помещаем в стек адрес следующего файла
		push	h

		; Помещаем в HL адрес нашего файла
		lhld	v_curFile

		; Адрес следующего файла изменится после сдвига,
		; а он используется в функции compareFileName
		shld	f_nextFile

		; Если наш файл был посленим, ничего не перемещаем
		jc	fileDelete_1

fileDelete_0:	 ; Чтение с диска
		 xthl
		 call	pageRead
		 inx	h
		 xthl
		 ; Запись на диск
		 call	pageWrite
		 inx	h
		 ; if(de==0) break;
		 mov	a, e
		 ora	d
		 ; de--
		 dcx	d
		jnz	fileDelete_0

fileDelete_1:	; Обновляем счетчик свободного места
		xthl
		pop	h
		jmp	fileChanged