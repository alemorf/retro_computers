;----------------------------------------------------------------------------
; MXOS NC.COM
; Получить имя выбранного файла
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

getSelectedFile:push	d

		; Получить номер текущего файла
		lxi	h, panelA_curFile
		call	readBytePanel

		; Получить имя (адрес) текущего файла
		; files2 += 16*curFile[activePanel];
		lxi	h, files2	
		lxi	d, 16
loc_D80F:	 dad	d
		 dcr	a
		jp	loc_D80F

		pop	d
		ret