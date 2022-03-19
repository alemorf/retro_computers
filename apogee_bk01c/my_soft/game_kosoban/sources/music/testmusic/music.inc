; (c) 2012 vinxru

SPD = 5

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
		lxi h, channelInfo+4
		call processChannel
                mvi e, 2
		lxi h, channelInfo+8
		jmp processChannel		

doMusicDelay:	call doMusic
                mvi a, SPD
x:              push psw
;		call waitHorzSync

		; плюмканье
plumkA:
		; Сдвиг
		lda plumk
		inr a
		ani 3
		sta plumk

		lxi h, channelInfo+1
		lxi d, 0EC00h
		call plumk_to

;		lxi h, channelInfo+4+1
;		lxi d, 0EC01h
;		call plumk_to

;		lxi h, channelInfo+8+1
;		lxi d, 0EC02h
;		call plumk_to

		lxi h, 400h
plumk_d:	dcx h
		mov a, h
		ora l
		jnz plumk_d
		
		lda 0EF01h
		ani 20h
		jz plumkA

                pop psw
                dcr a
                jnz x
		call doMute	

		ret

;------------------------------------------------------------------

		; Канал играет?
plumk_to:       xra a
		ora m
		rz

		; Частота
		inx h
		mov c, m
		inx h
		mov b, m

		; Сдвиг
		lda plumk
		cpi 2
		jc plumk_r
		mvi a, 1
plumk_r:
                inr a
plumk0:		dcr a
		jz plumk1
		push psw
		sub a
		mov a, b		
		rar
		mov b, a
		mov a, c
		rar
		mov c, a
		pop psw
		jmp plumk0
plumk1:
		; Загружаем в таймер
		xchg
		mov m, c
		mov m, b
		ret
;------------------------------------------------------------------

plumk: .db 0

;------------------------------------------------------------------

musicptr:	.dw music
channelInfo:	.db 0,0,0,0
		.db 0,0,0,0
		.db 0,0,0,0

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
		;cpi 0FFh
		;jz restartMelody

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
		cpi 1
		jz noise

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
		
		; Задержа
		mvi a, 8

		jmp writeFq

;------------------------------------------------------------------

noise:		; Задержа
		mvi a, 2

		; Частота
                lxi b, 160

writeFq:	; Задержа
      		inx h
		mov m, a

		; Сдвиг
;		push h
;		mvi h, 0
;		mov l, e
;		dad h
;		dad h
;		dad b
;		mov b, h
;		mov c, l
;		pop h

		; Запись частоты
      		inx h
		mov m, c
      		inx h
		mov m, b

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
		inx d
		inx d
		ret
