;+---------------------------------------------------------------------------
; RAMFOS
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if BIG_ROM != 1
		
#if $ > 0FFB6h
Ошибка_часть_F800_не_влезла
#endif
.org 0FFB6h

pageWriteROM:	sta	IO_PAGE_ROM
		jmp	pageWriteCom

pageReadROM:	sta	IO_PAGE_ROM
		jmp	pageReadCom

#endif

; ---------------------------------------------------------------------------

#if $ > 0FFC2h
Ошибка_часть_F800_не_влезла
#endif
.org 0FFC2h

pageRead:	lda	v_page

;----------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа F836
; Чтение байта из ДОЗУ
;
; На входе
;   a  - номер страницы
;   hl - адрес
;
; На выходе
;   с  - байт
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

pageReadAny:	ora	a
#if BIG_ROM
		jm	bigRom
#else
		jm	pageReadROM
#endif
disableARAM1:	sta	IO_PAGE_ARAM		
pageReadCom:	mov	c, m
		sta	IO_PAGE_RAM
		ret

; ---------------------------------------------------------------------------

pageWrite:	lda	v_page

;----------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа F839
; Запись байта в ДОЗУ
;
; На входе
;   a  - номер страницы
;   hl - адрес
;   c  - байт
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

pageWriteAny:	ora	a
#if BIG_ROM
		jm	pageWriteRet
#else
		jm	pageWriteROM
#endif
disableARAM2:	sta	IO_PAGE_ARAM
pageWriteCom:	mov	m, c
		sta	IO_PAGE_RAM
pageWriteRet:	ret