;----------------------------------------------------------------------------
; MXOS NC.COM
;
; 2013-12-18 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

.org 0D000h

ENABLE_COLOR		= 1	; Включить цвет
BIG_MEM			= 1	; Запуск на компьюетре, где ДОЗУ больше, чем 64 Кб
DISABLE_FREE_SPACE_BUG	= 1	; Исправить ошибку определения свободного объема

; Цвета
COLOR_CMDLINE		= 070h	; Цвет ком строки
COLOR_BORDER		= 0F1h	; Цвет рамки
COLOR_PANELNAME		= 0A1h	; Цвет заголовка панели (NAME)
COLOR_FILE		= 0B1h	; Цвет файлов
COLOR_INFOLINE		= 0B1h	; Цвет строки информации о текущем файле
COLOR_CURSOR            = 0B0h  ; Цвет курсора (инверсный)
COLOR_DIALOG		= 007h	; Цвет диалогов F1-F9
COLOR_INFOHEADER	= 0A1h	; Заголовок информационной панели
COLOR_INFONUMBER	= 0E1h	; Цифры на информационной панели
COLOR_INFOTEXT		= 0F1h	; Текст на информационной панели
COLOR_HELP_F		= 040h  ; Цвет функциональных клавиш в строке подсказки
COLOR_HELP_TEXT		= 071h	; Цвет текста в строке подсказки

; Если цвет включен, то вставляем код MVI A, # / STA IO_COLOR
#if ENABLE_COLOR
#define COLOR(C) .db 3Eh, C, 32h, IO_COLOR&0FFh, IO_COLOR>>8
#else
#define COLOR(C)
#endif

.include "mxos.inc"
.include "start.inc"	; продолжение в main
.include "main.inc"
.include "selFileToCmdLine.inc"
.include "f4.inc"
.include "enter.inc"
.include "saveState.inc"
.include "enter2.inc"
.include "main2.inc"
.include "drawWindow.inc"
.include "printStringInv.inc"
.include "inputForCopyMove.inc"
.include "printSelDrive.inc"
.include "f7.inc"
.include "tapeErrorHandler.inc"
.include "f9.inc"
.include "tapeWrite.inc"
.include "F6.inc"
.include "F5.inc"
.include "loadSelFileAt0.inc"
.include "copyFileInt.inc"
.include "printInvSelFile.inc"
.include "f8.inc"
.include "f2.inc"
.include "tab.inc"
.include "f3.inc"
.include "upDownLeftRight.inc"
.include "clearCmdLine.inc"	; Продолжение на printSpaces
.include "printSpaces.inc"
.include "drawCursor.inc"
.include "printInfoLine.inc"
.include "inverseRect.inc"
.include "getSelectedFile.inc"
.include "loadAndPrint.inc"
.include "loadFiles.inc"
.include "printInfoPanel.inc"
.include "printFilePanel.inc"
.include "printCurDrive.inc"
.include "rwBytePanel.inc"
.include "printFileName.inc"
.include "printString2.inc"
.include "setCursorPosPanel.inc"
.include "draw.inc"
.include "memset_hl_a_c.inc"
.include "memcpy_hl_de_3.inc"
.include "compactName.inc"
.include "input.inc"
.include "printDec.inc"
.include "driver.inc"

; ---------------------------------------------------------------------------

aNameName:	.db "NAME",18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,"NAME",0
aF1LeftF2RighF3:.db "F1 LEFT F2 RIGH F3 INFO F4 EDIT F5 COPY F6 RMOV F7 LOAD F8 DEL",0
aCommanderVersi:.db "COMMANDER VERSION 1.4",0
aCOmsk1992:	.db "(C) OMSK 1992",0
aFileIsProtecti:.db "FILE IS PROTECTION",0
aABCD:		.db "A   B   C   D",0
aEFGH:		.db "E   F   G   H",0
aChooseDrive:	.db "CHOOSE DRIVE:",0
aDeleteFromDisk:.db "DELETE FROM DISK  ",0
asc_DC17:	.db 8,' ',8,0
aCopyFromDiskTo:.db "COPY FROM DISK     TO",8,8,8,8,8,0
aCanTCreatyFile:.db "CAN",39,"T CREATY FILE",0 
aRemoveFromDisk:.db "REMOVE FROM DISK     TO",8,8,8,8,8,0
aBytesFreeOnDri:.db " BYTES FREE ON DRIVE ",0
aFilesUse:	.db " FILES USE ",0
aBytesIn:	.db "BYTES IN ",0
aTotalBytes:	.db " TOTAL BYTES",0
aOnDrive:	.db "ON DRIVE ",0
		.db "    0",0	; Не используется
aSaveFromToTape:.db "SAVE FROM     TO TAPE",8,8,8,8,8,8,8,8,8,8,0
aSavingTape:	.db "     SAVING TAPE     ",0
aLoadingTapeTo:	.db "LOADING TAPE TO  ",0
aErrorLoadingTa:.db "ERROR LOADING TAPE",0

; Испольузется функцией draw_window

v_window:	.db 01111111b		; Верхний левый угол
		.db 01000000b
		.db 01011111b
		.db 01010000b		; Левый край
		.db 01011111b		; Нижний левый угол
		.db 01000000b
		.db 01111111b

		.db 11111111b		; Верх окна
		.db 00000000b
		.db 11111111b

		.db 00000000b		; Содержимое окна

		.db 11111111b		; Низ окна
		.db 00000000b
		.db 11111111b

		.db 11111110b		; Правый верхний угол
		.db 00000010b
		.db 11111010b
		.db 00001010b		; Правая граница
		.db 11111010b		; Правый нижний угол
		.db 00000010b
		.db 11111110b

#define G_WINDOW(A,X,Y,W,H) .db A|2, Y, 90h+(X>>3), H-6, (W>>3)-2
#define G_LINE(A,X,Y,W) .db A|1, Y, 90h+(X>>3), (((X&7)+W+7)>>3)-2, 0FFh>>(X&7), (0FF00h>>((W+X)&7)) & 0FFh
#define G_VLINE(A,X,Y,H) .db A|3, Y, 90h+(X>>3), H, 80h>>(X&7)

g_filePanel:	G_WINDOW(0, 0, 0, 192, 230)		; 2, 0, 90h, 0E0h, 16h
		G_LINE(0, 4, 208, 184)			; 1, 0D0h, 90h, 16h, 0Fh, 0F0h
		G_VLINE(0, 96, 3, 205)			; 3, ?, 9Ch, 0CDh, 80h
		.db 0

g_infoPanel:	G_WINDOW(0, 0, 0, 192, 230)		; 2, 0, 90h, 0E0h, 16h
		G_LINE(0, 4, 31, 184)			; 1, 1Fh, 90h, 16h, 0Fh, 0F0h
		G_LINE(0, 4, 112, 184)			; 1, 70h, 90h, 16h, 0Fh, 0F0h
		.db 0

g_chooseDrive:	G_WINDOW(0, 40, 85, 112, 50)		; 2, 55h, 95h, 02Ch, 0Ch
		G_LINE(0, 44, 103, 104)			; 1, 67h, 95h, 0Ch, 0Fh, 0F0h
		.db 0

g_window1:	G_WINDOW(80h, 112, 80, 160, 37)		; 82h, 50h, 9Eh, 1Fh, 12h
		G_LINE(80h, 116, 98, 152)		; 81h, 62h, 9Eh, 12h, 0Fh, 0F0h
		.db 0

g_window2:	G_WINDOW(80h, 104, 114, 176, 37)	; 82h, 72h, 9Dh, 1Fh, 14h
		G_LINE(80h, 108, 132, 168)		; 81h, 84h, 9Dh, 14h, 0Fh, 0F0h 
		.db 0

initState:	.db 5Ah
activePanel:	.db 0
panelA_info:	.db 0
panelB_info:	.db 1
panelA_drive:	.db 0
panelB_drive:	.db 0
panelA_filesCnt:.db 0
panelB_filesCnt:.db 0
panelA_curFile:	.db 0
panelB_curFile:	.db 0
aNcExt:		.db "NC    EXT",0,0,0,0,0,0,0
aEditor:	.db "A:E.COM",0Dh
aFormatB:	.db "A:FORMAT.COM B:"
		.db 0Dh
v_cmdLinePos:	.dw 0
v_cmdLineEnd:	.dw 0
v_chooseDrive:	.db 0
v_tapeSaveCRC:	.dw 0
v_savedSP:	.dw 0
word_DDA0:	.dw 0

v_cmdLine:	.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh

v_input:	.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		.db 0FFh

		.block 11
files2:		.block 10
v_file_addr:	.block 2
v_file_length:	.block 2
		.block 2
files:		.block 301h

.end