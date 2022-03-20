;+---------------------------------------------------------------------------
; MXOS
; Драйвер внешнего ПЗУ
;
; Все регистры сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

LETTER = 'H'	; Буква для накопителя
ROM_SIZE = 0C0h	; Максимальный размер ПЗУ = 48 Кб

IO_KEYB_MODE	= 0FFE3h
IO_EXT_A	= 0FFE4h
IO_EXT_B	= 0FFE5h
IO_EXT_C	= 0FFE6h
IO_EXT_MODE	= 0FFE7h

sys_installDriver = 0C860h
sys_fileGetSetDrive = 0C842h

.org 0FA00h

start:		; Установить драйвер
		mvi     a, LETTER-'A'
                lxi     h, driver
                jmp     sys_installDriver

; ---------------------------------------------------------------------------

		; Сделать активным диск H (этот код не используется)
                mvi     e, 1
                mvi     a, 7
                jmp     sys_fileGetSetDrive

; ---------------------------------------------------------------------------

driver:		; Запись не поддерживается
                mov     a, e
                cpi     1
                rz

		; Сохраняем регистры
                push    h
                push    d
                push    b

		; Настройка портов
                mvi     a, 90h
                sta     IO_EXT_MODE

		; 6 вывод = 1
                mvi     a, 0Dh
                sta     IO_KEYB_MODE

		; Определение размера
                mov     a, e
                cpi     3
                jz      fn3

		; Неизвестная функция
                cpi     2
                jnz     exit

		; Читаем блок
                xra     a
                mov     e, a
readLoop:	call    read
                mov     m, a
                inx     h
                inr     e
                jz      exit
                jmp     readLoop

; ---------------------------------------------------------------------------
; Определение обьема ПЗУ

fn3:            ; Считаем блоки в FAT, чей номер не равен 0FFh
		xra     a
                mov     b, a
                mov     d, a
                mvi     e, 4
loc_FA3E:       call    read
                cpi     0FFh
                jnz     loc_FA47
                inr     b
loc_FA47:       inr     e
                mov     a, e
                cpi     ROM_SIZE
                jnz     loc_FA3E

		; И общий обьем ПЗУ получается ROM_SIZE-0FFh
                mvi     a, ROM_SIZE
                sub     b

exit:		push    psw

		; 6 вывод = 0
                mvi     a, 0Ch
                sta     IO_KEYB_MODE

                ; Восстановление режима портов
                mvi     a, 9Bh
                sta     IO_EXT_MODE

                pop     psw

		; Восстановление регистров
                pop     b
                pop     d
                pop     h
                ret

; ---------------------------------------------------------------------------

read:		xchg
                shld    IO_EXT_B
                lda     IO_EXT_A
                xchg
                ret

.end