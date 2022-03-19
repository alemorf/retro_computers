; (c) 2012 vinxru

SPD = 7

initMusic:	lxi h, music
		shld musicptr
		lxi h, channelInfo
		xra a
		mov m, a
		inx h
		mov m, a
		inx h
		mov m, a
		inx h
		mov m, a
		inx h
		mov m, a
		inx h
		mov m, a
		ret

doMusic:	mvi e, 0
		lxi h, channelInfo
		call processChannel
                mvi e, 1
		lxi h, channelInfo+2
		call processChannel
                mvi e, 2
		lxi h, channelInfo+4
		jmp processChannel		

;------------------------------------------------------------------

musicptr:	.dw music
channelInfo:	.db 0,0,0,0,0,0

;------------------------------------------------------------------


restartMelody:  push h
		call initMusic
		pop h

processChannel:	; hl - указатель на channelInfo
		; e - канал

		mov a, m
		ora a
		jnz channelWait

                ; a = *musicptr++
		push h
		lhld musicptr
		mov a, m
		pop h
		cpi 0FFh
		rz
		push h
		lhld musicptr
		inx h
		shld musicptr
		pop h

		; end of melody
;		cpi 0FFh
;		jz restartMelody

		; delay
		mov d, a		
		rlc
		rlc
		rlc
		ani 7
		mov m, a		

		; note
		mov a, d
		ani 01Fh

		; none
		rz

		; noise
		;cpi 1
		;jz noise

		; bc = word_notes[a]
		push h
		mov l, a
		mvi h, 0
		dad h
		lxi b, notes
		dad b
		mov c, m
		inx h
		mov b, m
		pop h
		
		; Длительность звучания
		mvi a, 12

;		jmp writeFq

;------------------------------------------------------------------

;noise:		; Задержа
;		mvi a, 2
;
;		; Частота
;                lxi b, 160

writeFq:	; Задержа
      		inx h
		mov m, a

		; Сдвиг
		mvi h, 0
		mov l, e
		dad h
		dad h
		dad b
		mov b, h
		mov c, l

		; Запись частоты
;		mov l, e
;		mvi h, 0ECh
;		mvi m, 1
;		mvi m, 1

		; Запись частоты
		mov l, e
		mvi h, 0ECh
		mov m, c
		mov m, b

		ret
		
;------------------------------------------------------------------

channelWait:	dcr m
		ret

;------------------------------------------------------------------

doMute:		lxi h, 0EC03h
		lxi d, channelInfo+1
		mvi b, 3Eh
		call mutex
		mvi b, 40h|3Eh
		call mutex
		mvi b, 80h|3Eh
mutex:		ldax d
		ora a
		jz l21
		dcr a
		jnz l11
		mov m, b
l11:		stax d
l21:		inx d
		inx d
		ret

;------------------------------------------------------------------

notes:		
.include "music_notes.inc";
music:
.include "music_data.inc"
