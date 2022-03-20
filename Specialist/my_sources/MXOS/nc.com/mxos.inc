;----------------------------------------------------------------------------
; MXOS NC.COM
; Функции MXOS
;
; 2013-12-18 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

; Переменные ОС

v_cursorCfg	= 8FE9h
v_inverse	= 8FFAh
v_tapeError	= 8FE1h
v_cursorY	= 8FFCh
v_cursorX	= 8FFDh

; Оборудование

IO_KEYB_A	= 0FFE0h
IO_KEYB_B	= 0FFE1h
IO_KEYB_C	= 0FFE2h
IO_KEYB_MODE	= 0FFE3h
IO_EXT_A	= 0FFE4h
IO_EXT_B	= 0FFE5h
IO_EXT_C	= 0FFE6h
IO_EXT_MODE	= 0FFE7h
IO_COLOR	= 0FFF8h
IO_PAGE_RAM	= 0FFFCh
IO_PAGE_ARAM	= 0FFFDh
IO_PAGE_ROM	= 0FFFEh
IO_PAGE_STR	= 0FFFFh

; Функции ОС

getch		= 0C803h
tapeRead	= 0C806h
printChar	= 0C809h
tapeWrite	= 0C80Ch
printHexByte	= 0C815h
printString	= 0C818h
keyScan		= 0C81Bh
calcCS		= 0C82Ah
fileList	= 0C83Fh
fileCreate	= 0C845h
diskDriver	= 0C863h
fileGetSetDrive	= 0C842h
fileDelete	= 0C84Bh
fileRename	= 0C84Eh
fileGetSetAddr	= 0C854h
fileGetSetAttr	= 0C857h
fileNamePrepare	= 0C85Ah
fileExec	= 0C85Dh
fileLoad2	= 0C866h
