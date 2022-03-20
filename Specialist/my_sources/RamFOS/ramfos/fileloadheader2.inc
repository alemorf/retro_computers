;+---------------------------------------------------------------------------
; RAMFOS
; Расчитать доп переменные загруженного заголовка файла
;
; На входе
;   v_curFile      - Адрес текущего файла в ДОЗУ
;   f_header       - Заголовок файла
;
; На выходе
;   f_fileBodySize - Длина файла без заголовка - 1
;   f_fileSize     - Длина файла с заголовком
;   f_nextFile     - Адрес следующего файла в ДОЗУ
;
;   Если не включено в ДОЗУ по адресу v_curFile + f_fileSize 
;   записывается v_curFile
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileLoadHeader2:; Длина файла без заголовка
		; f_fileBodySize = v_header_stop - v_header_start
		call	loadDStartDStop	
		xchg
		call	sub_hl_de
		shld	f_fileBodySize

		; Длина файла с заголовом
		; f_fileSize = f_fileBodySize+1
		lxi	d, FILE_HEADER_SIZE+1
		dad	d
		shld	f_fileSize

		; Конец файла
		; de = v_curFile + f_fileSize
		xchg
		lhld	v_curFile
		xchg
		dad	d

		; Обновляем в ДОЗУ указатель на наш файл, который находится
		; перед следующим файлом.
		mov	c, e
		call	pageWrite
		inx	h
		mov	c, d
		call	pageWrite
		inx	h

		; Адрес следующего файла
		; f_nextFile =  v_curFile + f_fileSize + 2
		shld	f_nextFile

		; Возвращаем ноль и Z
		xra	a
		ret