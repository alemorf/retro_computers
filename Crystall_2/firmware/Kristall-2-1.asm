		device zxspectrum48

VIDEO_MEM = 0E800h
STACK_TOP = 0F7C0h

;----------------------------------------------------------------------------

		org 0F7C0h

defCursorAddr:	ds 2	; Адрес курсора по умолчанию
loadErrorPtr:	ds 2	; Указатель на loadError. Запускается в случае ошибки загрузки программы с магнитофона.
  		ds 2	; НЕ ИСПОЛЬЗУЕТСЯ
tapeFormat:	ds 1	; Формат записи на магнитофон: 0-собственный, FF-РК86 (Изменяется директивой УС+S)
unknown_3:	ds 1	; Инициализируется значением 3 и не используется
forCmdO:	ds 1	; Длина имени введенная в директиве O (используется только директивой O)
charAtCursor:	ds 1	; Символ находящийся под курсором
cursorAddr:	ds 2	; Адрес курсора в видеопамяти
outputTapeDely:	ds 1	; Скорость записи на магнитофон
inputTapeDelay:	ds 1	; Скорость загрузки с магнитофона
forInputTape:	ds 1	; Используется только функцией загрузки с магнитофона. Содержит 0 или FF
cmdLineLastChr:	ds 2	; Функция inputString заносит сюда адрес последнего символа в строке
lastJmp:	ds 2	; Используется только директивой J. Она заносит сюда первый аргумент, если агрумент не указан, то использует это значение.
		ds 4    ; НЕ ИСПОЛЬЗУЕТСЯ
forDirL:	ds 2	; Используется только директивой L. Она заносит сюда первый аргумент, если агрумент не указан, то использует это значение.
cmd_param3:	ds 2	; 1 параметр (Заполняется фунукуией parseParams и директивой I)
cmd_param2:	ds 2	; 2 параметр
cmd_param1:	ds 2	; 3 параметр
cmdLine:	ds 32	; Командная строка 32 байта.


;----------------------------------------------------------------------------

		org 0F800h

rom:		jp	reboot
		jp	getChar
		jp	inputTape
		jp	putCharC
		jp	outputTape
		jp	putCharA
		jp	checkKeyPressed
		jp	printHex2
		jp	printString
		nop
		nop
		nop
		jp	initKeyb

;----------------------------------------------------------------------------

reboot:		ld	sp, STACK_TOP
		ld	hl, 1F15h
		ld	(outputTapeDely), hl
		ld	hl, loadError
		ld	(loadErrorPtr), hl
		ld	hl, VIDEO_MEM + 31*64
		ld	(defCursorAddr), hl
		ld	hl, 300h
		ld	(tapeFormat), hl

;----------------------------------------------------------------------------

cmd_empty:	ld	hl, a_hello
		call	printString

;----------------------------------------------------------------------------

monitor:	ld	sp, STACK_TOP
		call	initKeyb
		ld	hl, a_prompt
		call	printString
		ld	hl, monitor
		push	hl
		call	inputString
		call	printCrLf
		ld	a, (cmdLine)
		cp	48h ; 'H'
		jp	z, cmd_h
		call	parseParams
		ld	hl, (cmd_param3)
		ld	c, l
		ld	b, h
		ld	hl, (cmd_param2)
		ex	de, hl
		ld	hl, (cmd_param1)
		ld	a, (cmdLine)
		cp	0Dh
		jp	z, cmd_empty
		cp	4Dh ; 'M'
		jp	z, cmd_m
		cp	44h ; 'D'
		jp	z, cmd_l
		cp	4Ch ; 'L'
		jp	z, cmd_l
		cp	4Ah ; 'J'
		jp	z, cmd_j
		cp	43h ; 'C'
		jp	z, cmd_c
		cp	46h ; 'F'
		jp	z, cmd_f
		cp	53h ; 'S'
		jp	z, cmd_s
		cp	50h ; 'P'
		jp	z, cmd_p
		cp	4Bh ; 'K'
		jp	z, cmd_k
		cp	45h ; 'E'
		jp	z, 0
		cp	48h ; 'H'
		jp	z, cmd_h
		cp	4Fh ; 'O'
		jp	z, cmd_o
		cp	49h ; 'I'
		jp	z, cmd_i
		cp	52h ; 'R'
		jp	z, cmd_r
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		cp	13h
		jp	z, cmd_ctrl_s
		cp	14h
		jp	z, cmd_ctrl_t
error:		ld	a, 3Fh ; '?'
		call	putCharA
		jp	monitor

;----------------------------------------------------------------------------

cmd_ctrl_t:	ld	hl, VIDEO_MEM
		ld	(defCursorAddr), hl
		ret

;----------------------------------------------------------------------------

a_hello:	db 1Fh,'kristall-s',13,10
		db '*SVP-1987*'
a_crlf:		db 13,10,0
a_prompt:	db 13,10,10,'M*',0

;----------------------------------------------------------------------------

inputString:	push	hl
		ld	hl, cmdLine
		ld	b, 0
inputString_1:  call	getChar
		cp	'.'
		jp	z, error
		cp	8
		jp	nz, inputString_2
		ld	a, cmdLine&0xFF
		cp	l
		jp	z, inputString_1
		ld	a, 3
		call	putCharA
		dec	hl
		dec	b
		jp	inputString_1

;----------------------------------------------------------------------------

inputString_2:	call	putCharA
		ld	(hl), a
		ld	(cmdLineLastChr), hl
		cp	0Dh
		jp	z, inputString_3
		inc	b
		inc	hl
		ld	a, l
		cp	0FFh
		jp	nz, inputString_1
		jp	error

;----------------------------------------------------------------------------

inputString_3:  pop	hl
		ret

;============================================================================

parseParams:	ld	hl, cmd_param3
		ld	b, 6
parseParams_1:	ld	(hl), 0
		inc	hl
		dec	b
		jp	nz, parseParams_1
		inc	hl
		ex	de, hl
		call	parseHex2	; Вход:	de - строка, выход: hl-число, cf-найдена запятая
		ld	(cmd_param1), hl
		ret	c
		call	parseHex2
		ld	(cmd_param2), hl
		ret	c
		call	parseHex2
		ld	(cmd_param3), hl
		ret	c
		jp	error

;============================================================================
; Вход:	de - строка, выход: hl-число, cf-найдена запятая

parseHex2:	ld	hl, 0
		push	bc
		ld	b, l
		ld	c, l
parseHex2_loop:	ld	a, (de)
		inc	de
		cp	0Dh
		jp	z, parseHex2_ret1
		cp	20h ; ' '
		jp	z, parseHex2_loop
		cp	2Ch ; ','
		jp	z, parseHex2_ret
		sub	30h ; '0'
		jp	m, error
		cp	0Ah
		jp	m, parseHex2_1
		cp	11h
		jp	m, error
		cp	17h
		jp	p, error
		sub	7
parseHex2_1:	ld	c, a
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		jp	c, error
		add	hl, bc
		jp	parseHex2_loop

;---------------------------------------------------------------------------

parseHex2_ret1:	scf
parseHex2_ret:	pop	bc
		ret

;============================================================================

printHex2_hl:	ld	a, (hl)
printHex2:	push	af
		rrca
		rrca
		rrca
		rrca
		call	printHex1
		pop	af
printHex1:	and	0Fh
		cp	0Ah
		jp	m, printHex1_1
		add	a, 7
printHex1_1:	add	a, 30h ; '0'
		jp	putCharA


;============================================================================

printCrLfHex4:	call	printCrLf
printHex4:	ld	a, h
		call	printHex2
		ld	a, l
		call	printHex2
printSpace:	ld	a, 20h ; ' '
		jp	putCharA


;============================================================================

printCrLf:	push	hl
		ld	hl, a_crlf
		call	printString
		pop	hl
		ret

;============================================================================

printString:	ld	a, (hl)
		and	a
		ret	z
		call	putCharA
		inc	hl
		jp	printString

;============================================================================

inc_hl_cmp_hl_de_ret:
		call	cmp_hl_de
		jp	z, inc_hl_cmp_hl_de_ret_1
		inc	hl
		ret

;---------------------------------------------------------------------------

inc_hl_cmp_hl_de_ret_1:
		inc	sp
		inc	sp
		ret

;============================================================================

cmp_hl_de:	ld	a, h
		cp	d
		ret	nz
		ld	a, l
		cp	e
		ret

;============================================================================

inputTape:	push	bc
		push	de
		push	hl
		ld	c, 0
		ld	d, a
		in	a, (2)
		and	1
		ld	e, a
inputTape_1:	ld	a, c
		and	7Fh
		rlca
		ld	c, a
		ld	a, (inputTapeDelay)
		add	a, a
		add	a, a
		ld	b, a
inputTape_2:	dec	b
		jp	nz, inputTape_3
		ld	hl, (loadErrorPtr)
		jp	(hl)

;----------------------------------------------------------------------------

inputTape_3:	in	a, (2)
		and	1
		cp	e
		jp	z, inputTape_2
		and	1
		or	c
		ld	c, a
		call	inputTapeDel
		in	a, (2)
		and	1
		ld	e, a
		ld	a, d
		or	a
		jp	p, inputTape_6
		ld	a, c
		cp	0E6h ; 'ц'
		jp	nz, inputTape_4
		xor	a
		ld	(forInputTape), a
		ld	a, 2Ah ; '*'
		jp	inputTape_5

;-----------------------------------------------------------------------------

inputTape_4:	cp	19h
		jp	nz,inputTape_1
		ld	a, 0FFh
		ld	(forInputTape), a
		ld	a, 2Dh ; '-'
inputTape_5:	ld	hl, (cursorAddr)
		ld	(hl), a
		ld	d, 9
inputTape_6:	dec	d
		jp	nz, inputTape_1
		ld	a, (forInputTape)
		xor	c
		pop	hl
		pop	de
		pop	bc
		ret

;============================================================================

outputTape:	push	bc
		push	de
		push	af
		ld	d, 8
outputTape_1:	ld	a, c
		ld	a, 80h
		xor	c
		out	(2), a
		call	outputTapeDel
		ld	a, 0
		push	de
		pop	de
		push	de
		pop	de
		xor	c
		out	(2), a
		call	outputTapeDel
		ld	a, c
		rlca
		ld	c, a
		dec	d
		jp	nz, outputTape_1
		pop	af
		pop	de
		pop	bc
		ret

;============================================================================

outputTapeDel:	ld	a, (outputTapeDely)
		jp	inputTapeDel_1

;============================================================================

inputTapeDel:	ld	a, (inputTapeDelay)
inputTapeDel_1:	dec	a
		jp	nz, inputTapeDel_1
		ret

;============================================================================

checkKeyPressed:
		xor	a
		out	(0), a
		in	a, (1)
		and	7Fh
		cp	7Fh
		ld	a, 0
		ret	z
		cpl
		ret

;============================================================================

cmd_m:		call	printCrLfHex4
		call	printHex2_hl
		call	printSpace
		call	inputString
		ld	a, b
		and	a
		jp	z, cmd_m_1
		push	hl
		ld	de, cmdLine
		call	parseHex2	; Вход:	de - строка, выход: hl-число, cf-найдена запятая
		ld	a, l
		pop	hl
		ld	(hl), a
cmd_m_1:	inc	hl
		jp	cmd_m

;============================================================================

cmd_j:		ld	a, (cmdLine+1)
		cp	0Dh
		jp	z, cmd_j_empty
		ld	(lastJmp), hl
		jp	(hl)
cmd_j_empty:	ld	hl, (lastJmp)
		call	printHex4
		call	getChar
		cp	0Dh
		ret	nz
		jp	(hl)

;============================================================================

cmd_l:		ld	a, d
		or	e
		jp	nz, cmd_l_1
		ld	de, 0FFFFh
cmd_l_1:	ld	a, (cmdLine+1)
		cp	2Ch ; ','
		jp	nz, cmd_l_2
		ld	hl, (forDirL)
		jp	cmd_l_3
;----------------------------------------------------------------------------
cmd_l_2:	ld	(forDirL), hl
cmd_l_3:	ld	b, 0FFh
		call	printCrLf
		call	sub_l
cmd_l_4:	call	printCrLfHex4
		push	hl
		ld	b, 2
cmd_l_5:	call	printHex2_hl
		inc	hl
		dec	b
		jp	nz, cmd_l_6
		call	printSpace
		ld	b, 2
cmd_l_6:	ld	a, l
		and	0Fh
		jp	nz, cmd_l_5
		pop	hl
cmd_l_7:	ld	a, (hl)
		or	a
		jp	m, cmd_l_8
		cp	20h
		jp	nc, cmd_l_9
cmd_l_8:	ld	a, 2Eh
cmd_l_9:	call	putCharA
		call	inc_hl_cmp_hl_de_ret
		ld	a, l
		and	0Fh
		jp	nz, cmd_l_7
		ld	a, l
		and	a
		jp	nz, cmd_l_4
		call	printCrLf
		call	getChar
		cp	2Eh
		ret	z
		jp	cmd_l_3

;============================================================================

sub_l:		ld	c, 5
sub_l_1:	call	printSpace
		dec	c
		jp	nz, sub_l_1
sub_l_2:	ld	b, 2
sub_l_3:	ld	a, c
		call	printHex1
		call	printSpace
		inc	c
		dec	b
		jp	nz, sub_l_3
		call	printSpace
		ld	a, c
		cp	10h
		jp	nz, sub_l_2
sub_l_4:	ld	a, c
		cp	20h
		jp	z, printCrLf
		call	printHex1
		inc	c
		jp	sub_l_4

;============================================================================

cmd_c:		ld	a, (bc)
		cp	(hl)
		jp	z, sub_c_1
		call	printCrLfHex4
		call	printHex2_hl
		call	printSpace
		ld	a, (bc)
		call	printHex2
		call	checkKeyPressed
		and	a
		jp	z, sub_c_1
		call	inputTapeDel
		call	getChar
		cp	0Dh
		ret	z
sub_c_1:	inc	bc
		call	inc_hl_cmp_hl_de_ret
		jp	cmd_c

;============================================================================

cmd_f:		ld	(hl), c
		call	inc_hl_cmp_hl_de_ret
		jp	cmd_f

;============================================================================

cmd_s:		push	hl
		ld	hl, (cmdLineLastChr)
		dec	hl
		dec	hl
		dec	hl
		ld	a, (hl)
		cp	2Ch ; ','
		pop	hl
		jp	z, cmd_s_1
		ld	a, b
		cp	(hl)
		jp	nz, cmd_s_2
		call	inc_hl_cmp_hl_de_ret
cmd_s_1:	ld	a, c
		cp	(hl)
		call	z, cmd_s_3
cmd_s_2:	call	inc_hl_cmp_hl_de_ret
		jp	cmd_s

;----------------------------------------------------------------------------

cmd_s_3:	call	printCrLfHex4
cmd_s_4:	call	checkKeyPressed
		and	a
		jp	nz, cmd_s_4
		ret

;============================================================================

cmd_p:		ld	a, (hl)
		ld	(bc), a
		inc	bc
		call	inc_hl_cmp_hl_de_ret
		jp	cmd_p

;============================================================================

cmd_k:		call	getChar
		cp	0
		ret	z
		call	putCharA
		cp	0Dh
		ld	a, 0Ah
		call	z, putCharA
		jp	cmd_k

;============================================================================

cmd_h:		ld	a, (cmdLine+1)
		jp	printHex2

;============================================================================

cmd_o:		ld	a, c
		or	a
		jp	z, cmd_o_1
		ld	(outputTapeDely), a
		ld	c, a
		rrca
		and	7Fh
		add	a, c
		ld	(inputTapeDelay), a
cmd_o_1:	push	hl
		push	de
		ld	hl, a_name
		call	printString
		call	inputString
		ld	a, b
		ld	(forCmdO), a
		call	printCrLf
		pop	de
		pop	hl
		push	hl
		call	calcCrc
		pop	hl
		push	bc
		ld	bc, 0
cmd_o_2:	call	outputTape
		dec	b
		jp	nz, cmd_o_2
		ld	c, 0E6h
		call	outputTape
		call	outputTape2
		ex	de, hl
		call	outputTape2
		ex	de, hl
		push	hl
		ld	a, (tapeFormat)
		and	a
		jp	nz, cmd_o_4
		ld	hl, cmdLine
		ld	a, (forCmdO)
cmd_o_3:	ld	c, (hl)
		call	outputTape
		inc	hl
		dec	a
		jp	nz, cmd_o_3
		ld	c, 0
		call	outputTape
cmd_o_4:	pop	hl
		call	outputTapeBlock
		pop	hl
		call	outputTape2
		ld	c, 0
		call	outputTape
		jp	printHex4

;============================================================================

outputTapeBlock:ld	c, (hl)
		call	outputTape
		call	inc_hl_cmp_hl_de_ret
		jp	outputTapeBlock

;============================================================================

outputTape2:	ld	c, h
		call	outputTape
		ld	c, l
		jp	outputTape

;============================================================================

calcCrc:	ld	bc, 0
		xor	a
calcCrc_1:	ld	a, (hl)
		add	a, c
		ld	c, a
		push	af
		call	cmp_hl_de
		jp	z, calcCrc_2
		pop	af
		inc	hl
		ld	a, b
		adc	a, (hl)
		ld	b, a
		push	af
		call	cmp_hl_de
		jp	z, calcCrc_2
		pop	af
		inc	hl
		jp	calcCrc_1
;----------------------------------------------------------------------------
calcCrc_2:	pop	af
		ret

;============================================================================

a_name:		db 0E9h, 0EDh, 0F1h, 3Ah, 0	; Имя: 

;============================================================================

cmd_i:		ld	a, (cmdLine+1)
		cp	0Dh
		jp	z, cmd_i_empty
		push	hl
		ld	a, 0FFh
		call	getTape2	; Результат в BC
		ld	a, c
		cpl
		add	a, 1
		ld	l, a
		ld	a, b
		cpl
		adc	a, 0
		ld	h, a
		call	getTape2WoSync
		add	hl, bc
		ex	de, hl
		pop	hl
		push	hl
		add	hl, de
		ex	de, hl
		pop	hl
		jp	cmd_i_2
; ---------------------------------------------------------------------------
cmd_i_empty:				; CODE XREF: ROM:FC80|j
		push	hl
		ld	a, 0FFh
		call	getTape2	; Результат в BC
		add	hl, bc
		ex	de, hl
		pop	hl
		call	getTape2WoSync
		add	hl, bc
		ex	de, hl
cmd_i_2:	push	hl
		ld	(cmd_param2), hl
		ex	de, hl
		ld	(cmd_param3), hl
		ex	de, hl
		ld	a, (tapeFormat)
		and	a
		jp	nz, cmd_i_5
		ld	hl, (cursorAddr)
cmd_i_3:	call	getTapeWoSync
		cp	0
		jp	z, cmd_i_4
		ld	(hl), a
		inc	hl
		jp	cmd_i_3
; ---------------------------------------------------------------------------
cmd_i_4:	ld	(cursorAddr), hl
cmd_i_5:	pop	hl
		push	hl
		call	inputTapeBlock
		call	getTape2WoSync
		call	printCrLf
		pop	hl
		call	printHex4
		push	bc
		call	calcCrc
		pop	hl
		ex	de, hl
		call	printHex4
		ld	a, (inputTapeDelay)
		call	printHex2
		call	printSpace
		ld	hl, a_l		; "╙╜"
		call	printString
		ld	l, c
		ld	h, b
		call	cmp_hl_de
		jp	nz, cmd_i_6
		ld	a, (cmdLine+1)
		cp	2Ch ; ','
		jp	nz, printHex4
		ld	hl, (cmd_param2)
		jp	(hl)
cmd_i_6:	ld	a, 23h ; '#'
		call	putCharA
		jp	printHex4

;============================================================================

cmd_ctrl_s:	ld	a, 0FFh
		ld	(tapeFormat), a
		ret

;============================================================================

loadError:	ld	hl, (cmd_param2)
		call	printCrLfHex4
		ld	hl, (cmd_param3)
		call	printHex4
		ld	a, (inputTapeDelay)
		call	printHex2
		jp	error

;============================================================================

a_l:            db 0D3h, 0BDh, 0	; L:

;============================================================================

getTape2WoSync:	ld	a, 8
getTape2:	call	inputTape
		ld	b, a
getTapeWoSync:	ld	a, 8
		call	inputTape
		ld	c, a
		ret

;============================================================================

inputTapeBlock:	ld	a, 8
		call	inputTape
		ld	(hl), a
		call	inc_hl_cmp_hl_de_ret
		jp	inputTapeBlock

;============================================================================

cmd_r:		ld	b, 2
cmd_r_1:	ld	c, 0
cmd_r_2:	in	a, (2)
		and	1
		jp	nz, cmd_r_2
cmd_r_3:	in	a, (2)
		and	1
		jp	z, cmd_r_3
cmd_r_4:	inc	c
		in	a, (2)
		and	1
		push	af
		pop	af
		nop
		jp	nz, cmd_r_4
		dec	b
		jp	z, cmd_r_5
		ld	d, a
		jp	cmd_r_1

;----------------------------------------------------------------------------

cmd_r_5:	cp	d
		jp	nz, cmd_r
		xor	a
		ld	a, c
		add	a, a
		add	a, 5
		ld	c, a
		rra
		and	7Fh
		add	a, c
		ld	(inputTapeDelay), a
		jp	cmd_i

;============================================================================

cmd_z:		ld	hl, 0F000h
		ld	a, (hl)
		cp	0FFh
		jp	z, error
		jp	(hl)

;============================================================================

initKeyb:	ld	a, 8Bh
		out	(3), a
		out	(20h), a
		nop
		nop
		ret

;============================================================================

putCharC:	ld	a, c
putCharA:	push	hl
		push	de
		push	bc
		push	af
		and	7Fh
		ld	c, a
		ld	hl, (cursorAddr)
		ld	a, (charAtCursor)
		ld	(hl), a
		ld	a, c
		cp	1Fh
		jp	z, clearScreen
putChar_er:	cp	8
		jp	z, backSpace
		cp	0Ah
		jp	z, putCr
		cp	0Dh
		jp	z, putLf
		cp	1Ah
		jp	z, cursorDown
		cp	0Ch
		jp	z, setDefCursorAddr
		cp	18h
		jp	z, cursorRight
		cp	19h
		jp	z, cursorUp
		ld	a, h
		cp	(VIDEO_MEM>>8)+8
		call	z, scrollUp
		ld	(hl), c
incAndSaveCursorAddr:
		inc	hl
saveCursorAddr:	ld	(cursorAddr), hl
		ld	a, (hl)
		ld	(charAtCursor),	a
		ld	(hl), 1Eh
		ld	a, c
popa_ret:	pop	af
		pop	bc
		pop	de
		pop	hl
		ret

;============================================================================

clearScreen:	ld	hl, VIDEO_MEM
clearScreen_1:	ld	(hl), 20h
		inc	hl
		ld	a, h
		cp	(VIDEO_MEM>>8)+8
		jp	nz, clearScreen_1

setDefCursorAddr:
		ld	hl, (defCursorAddr)
		jp	saveCursorAddr

;============================================================================

		jp	popa_ret

;============================================================================

backSpace:	dec	hl
		ld	a, h
		cp	(VIDEO_MEM>>8)-1
		jp	nz, saveCursorAddr
		jp	incAndSaveCursorAddr

;============================================================================

incLineCheckEnd:
		ld	de, 40h	; '@'
		add	hl, de
		ld	a, h
		cp	(VIDEO_MEM>>8)+8
		ret

;============================================================================

putCr:		call	incLineCheckEnd
		jp	nz, saveCursorAddr
		call	scrollUp
		ld	d, 0
		ld	a, (cursorAddr)
		sub	0C0h
		ld	e, a
		add	hl, de
		jp	saveCursorAddr

;============================================================================

cursorDown:	call	incLineCheckEnd
		jp	nz, saveCursorAddr

truncCursorAddr:
		ld	h, VIDEO_MEM>>8
		jp	saveCursorAddr

;============================================================================

putLf:		ld	a, l
		and	3Fh ; '?'
		jp	z, saveCursorAddr
		dec	hl
		jp	putLf

;============================================================================

cursorRight:	inc	hl
		ld	a, h
		cp	(VIDEO_MEM>>8)+8
		jp	nz, saveCursorAddr
		jp	truncCursorAddr

;============================================================================

cursorUp:	ld	de, -40h
		add	hl, de
		ld	a, h
		cp	(VIDEO_MEM>>8)-1
		jp	nz, saveCursorAddr
		ld	h, (VIDEO_MEM>>8)+7
		jp	saveCursorAddr

;============================================================================
; Прокручивает экран вверх не одну строку

scrollUp:	ld	hl, VIDEO_MEM
		ld	de,  VIDEO_MEM+40h
scrollUp_1:	ld	a, (de)
		ld	(hl), a
		inc	hl
		inc	de
		ld	a, d
		cp	(VIDEO_MEM>>8)+8
		jp	nz, scrollUp_1
		push	hl
scrollUp_2:	ld	(hl), 20h ; ' '
		inc	hl
		ld	a, h
		cp	(VIDEO_MEM>>8)+8
		jp	nz, scrollUp_2
		pop	hl
		ret

;============================================================================

getChar:	push	bc
		push	de
		push	hl
getChar_1:	ld	b, 0
		ld	c, 0FEh
		ld	d, 8
getChar_2:	ld	a, c
		out	(0), a
		rlca
		ld	c, a
		in	a, (1)
		ld	e, a
		call	delay255
		in	a, (1)
		cp	e
		jp	nz, getChar_3
		and	7Fh
		cp	7Fh
		jp	nz, getChar_4
getChar_3:	ld	a, b
		add	a, 7
		ld	b, a
		dec	d
		jp	nz, getChar_2
		jp	getChar_1
;----------------------------------------------------------------------------
getChar_4:	ld	e, a
getChar_5:	rra
		jp	nc, getChar_6
		inc	b
		jp	getChar_5
;----------------------------------------------------------------------------
getChar_6:	ld	a, b
		cp	30h
		jp	nc, getChar_10
		add	a, 30h
		cp	3Ch
		jp	c, getChar_7
		cp	40h
		jp	nc, getChar_7
		and	2Fh
getChar_7:	ld	c, a
		in	a, (2)
		ld	b, a
		and	4
		jp	z, getChar_11
		ld	a, b
		and	2
		jp	nz, getChar_9
		ld	a, c
		and	1Fh
getChar_8:	ld	c, a
getChar_9:	in	a, (1)
		ld	d, a
		call	delay255
		in	a, (1)
		cp	d
		jp	nz, getChar_9
		and	7Fh
		cp	e
		jp	z, getChar_9
		ld	a, c
		pop	hl
		pop	de
		pop	bc
		ret
; ---------------------------------------------------------------------------
getChar_10:	ld	hl, decodeKeybTbl
		sub	30h ; '0'
		ld	c, a
		ld	b, 0
		add	hl, bc
		ld	a, (hl)
		jp	getChar_8
; ---------------------------------------------------------------------------
getChar_11:	ld	a, c
		cp	40h
		jp	nc, getChar_12
		cp	30h
		jp	nc, getChar_13
		or	30h
		jp	getChar_8
; ---------------------------------------------------------------------------
getChar_12:	or	20h
		jp	getChar_8
; ---------------------------------------------------------------------------
getChar_13:	and	2Fh
		jp	getChar_8

;============================================================================

delay255:	push	af
		xor	a
delay255_1:	dec	a
		jp	nz, delay255_1
		pop	af
		ret

;============================================================================

decodeKeybTbl:	db 20h,	18h, 1Ah, 8, 19h, 0Dh, 1Fh, 0Ch

;============================================================================

		DUP 10000h-$
		db 0FFh
		EDUP

		savebin "Kristall-2.dat",rom,10000h-rom