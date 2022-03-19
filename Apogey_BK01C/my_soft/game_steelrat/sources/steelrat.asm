// Game "Steelrat" for 8 bit computer "Apogey BK01C"
// 1985 English text (c) Harry Harrison
// 2014-07-25  Build on Windows & tasm version, Alemorf, aleksey.f.morozov@gmail.com
// 2021-01-05  Build on Linux & sjasm version,  Alemorf, aleksey.f.morozov@gmail.com

        device zxspectrum48
        org 0

;----------------------------------------------------------------------------

keyCodeClearScreen = 1Fh
biosPrintChar      = 0F809h
screenAddr         = 0E2C1h
screenBpl          = 78
codeNextChapter    = 0xFE
codeGameOver       = 0xFD
codeEndPage        = 0xFF

;----------------------------------------------------------------------------

begin:
        ; Clear screen
        ld   c, keyCodeClearScreen
        call biosPrintChar

        ; Reset variables
        xor  a
        ld   (curChapter), a

        ; Hide hadrware cursor
        call hideHardwareCursor

        ; Draw border, top line
        ld   bc, screenF
        ld   hl, screenAddr
        call drawText

        ; Draw border, middle lines
        call clearCenter

        ; Draw border, bottom line
        ld   bc, screenE
        call drawText

        ; Unpack chapter
loadChapter:
        ld   hl, (curChapter)
        ld   h, 0
        add  hl, hl
        ld   de, chaptersList
        add  hl, de
        ld   e, (hl)
        inc  hl
        ld   d, (hl)
        ld   bc, buffer
        call unmlz

        ; Select first page in chapter
        xor  a

loadPage:
        ld   (curPage), a
        ld   hl, buffer
        ; Next chapter
        cp   codeNextChapter
        jp   z, nextChapter
        ; Game over
        cp   codeGameOver
        jp   z, begin
        ; Search page
        ld   c, a
        inc  c
loadPage_1:
        dec  c
        jp   z, drawPage
loadPage_2:
        ld   a, (hl)
        inc  hl
        or   a
        jp   nz, loadPage_2
        ld   a, (hl)
        inc  hl
        cp   codeEndPage
        jp   nz, loadPage_2
        ld   a, (hl)
        cp   codeEndPage
        jp   nz, loadPage_1
nextChapter:
        ld   a, (curChapter)
        inc  a
        cp   chapterCount
        jp   c, nextChapter_1
        xor  a
nextChapter_1:
        ld   (curChapter), a
        jp   loadChapter

;----------------------------------------------------------------------------

beep:	; Би-би
        ld   c, 7
        call 0F809h

hideHardwareCursor:
        ; Скрываем курсор
        push hl
        ld   hl, 0EF01h
        ld   (hl), 80h
        dec  hl
        ld   (hl), 0FFh
        ld   (hl), 0FFh
        pop  hl
        ret

;----------------------------------------------------------------------------

clearCenter:
        ld   hl, screenAddr + screenBpl
        ld   d, 23
clearCenter_1:
        push de
        ld   bc, screenL
        call drawText
        pop  de
        dec  d
        jp   nz, clearCenter_1
        ret

;----------------------------------------------------------------------------
		
drawPage:
        push hl
        call clearCenter
        pop  bc

        ; Draw text
        ld   hl, screenAddr + 3 + screenBpl * 2
        call drawText

        ; Save pointer
        ld   de, ptrs
drawPage_1:
        ld   a, (bc)
        inc  bc

        ; End of page
        cp   0FFh
        jp   z, drawPage_2

        ; Save pointer
        ld   (de), a
        inc  de

        ; Draw answer
        push de
        push bc
        ld   bc, mark
        call drawText
        pop  bc
        call drawText_1
        pop  de

        jp   drawPage_1

;----------------------------------------------------------------------------

drawPage_2:
        ld  a, -1
        ld  (cursorN), a
        ld  hl, 0E2C0h
        ld  bc, 1
        jp  move_1

;----------------------------------------------------------------------------

loop:  	ld   hl, (cursorPos)
        ld   a, 9
        cp   (hl)
        jp   nz, loop_5
        xor  a
loop_5:	ld   (hl), a

        ld   hl, 3000h
wait_2:	dec  l
        jp   nz, wait_2
        dec  h
        jp   nz, wait_2

        call 0F81Bh
        cp   0FFh
        jp   z, loop
        call beep

        ld   hl, 5000h
wait_0:
        dec  l
        jp   nz, wait_0
        dec  h
        jp   nz, wait_0

        cp   19h
        jp   z, left
        cp   1Ah
        jp   z, right
        cp   'Q'
        jp   z, nextChapter
        cp   'W'
        jp   z, nextPage
        cp   1Bh
        jp   z, begin
        cp   0Dh
        jp   z, enter
        cp   ' '
        jp   z, enter
        jp   loop

;----------------------------------------------------------------------------

enter:	ld   hl, (cursorN)
        ld   h, 0
        ld   de, ptrs
        add  hl, de
        ld   a, (hl)
        jp   loadPage

nextPage:
        ld   a, (curPage)
        inc  a
        jp   loadPage

;----------------------------------------------------------------------------

left:	ld   bc, -1
        jp   move

;----------------------------------------------------------------------------

right:	ld  bc, 1

move:	ld   hl, (cursorPos)
        ld   (hl), '*'
move_1: add  hl, bc
        ld   a, h
        cp   0E1h
        jp   z, move_2
        cp   0EBh
        jp   z, move_2
        ld   a, (hl)
        cp   '*'
        jp   nz,move_1
        ld   a, (cursorN)
        add  c
        ld   (cursorN), a
move_3: ld   (hl), 9
        ld   (cursorPos), hl
        jp   loop

;----------------------------------------------------------------------------

move_2:	ld   hl, (cursorPos)
        jp   move_3

;----------------------------------------------------------------------------
; Print text
;     hl - destination address in video memory
;     de - source address of text

drawText_nextLine:
        ld   de, screenBpl
        add  hl, de
drawText:
        ld   de, hl
drawText_1:
        ld   a, (bc)
        inc  bc
        or   a
        ret  z
        cp   10
        jp   z, drawText_nextLine
        ld   (de), a
        inc  de
        jp   drawText_1

;----------------------------------------------------------------------------

        include "unmlz.inc"

;----------------------------------------------------------------------------

screenF:    db 094h," \\/\\/\\/\\/\\/\\/\\/\\/\\/\\/ stanx stalxnoj krysoj \\/\\/\\/\\/\\/\\/\\/\\/\\/\\ ",80h,10,0 ;0
screenL:    db 094h,' ',80h,"                                                            ",94h,' ',80h,10,0 ;1
screenE:    db 094h," "," ESC - sna~ala \\/\\/\\/\\/\\/\\ 2014-2021 garri garrison & ALEMORF  ",80h,0,0 ; 24
mark:	    db 10, 10, "* ",0
curPage:    db 0
curChapter: db 0
cursorPos:  dw 0E2C0h
cursorN:    db 0
ptrs:       db 0,0,0,0

chaptersList:
        dw chapter00
        dw chapter01
        dw chapter02
        dw chapter03
        dw chapter04
        dw chapter05
        dw chapter06
        dw chapter07
        dw chapter08
        dw chapter09
        dw chapter10
        dw chapter11
        dw chapter12
        dw chapter13
        dw chapter14

chapterCount = 15

;----------------------------------------------------------------------------

chapter00: .incbin "build/00.bin"
chapter01: .incbin "build/01.bin"
chapter02: .incbin "build/02.bin"
chapter03: .incbin "build/03.bin"
chapter04: .incbin "build/04.bin"
chapter05: .incbin "build/05.bin"
chapter06: .incbin "build/06.bin"
chapter07: .incbin "build/07.bin"
chapter08: .incbin "build/08.bin"
chapter09: .incbin "build/09.bin"
chapter10: .incbin "build/10.bin"
chapter11: .incbin "build/11.bin"
chapter12: .incbin "build/12.bin"
chapter13: .incbin "build/13.bin"
chapter14: .incbin "build/14.bin"

buffer: db 0


