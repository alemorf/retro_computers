.org 0h

BUF = 0BA00h

go:     lxi h, title
        call 0F818h
	
        lxi h, 0EF01h
        mvi m, 080h
        dcr l
        mvi m, 0FFh
        mvi m, 0FFh

        mvi a, 10
        lxi d, text
go0:	push psw
        lxi b, BUF
        call unmlz
        push d
        call show 
        pop d
        pop psw
        dcr a 
        jnz go0

mme:
        call doMute
        jmp mme

show:   lxi h, BUF
frame:
        lxi d, 0E496h
	lxi b, 64*256+13
loop:
        mov a, m
        inx h
        cpi 127
        rz
        cpi 32
        jc repe
        cpi 'a'
        jnc spaces
l1:     cpi 128
        jnc old
        sta lastChar
l2:     stax d
        inx d
        call eol
        jmp loop

old:    sui 126
old_l:  push psw
        ldax d
        inx d
        call eol
        pop psw
        dcr a
        jnz old_l
        jmp loop

repe:
repea:  push psw
        lda lastChar
        stax d
        inx d
        call eol
        pop psw
        dcr a
        jnz repea
        jmp loop

spaces: cpi 'z'+1
        jnc l1
        sui 'a'  
        push psw
        mvi a, ' '
        sta lastChar
        pop  psw
        jmp repea        
        
eol:    dcr b
        rnz
        mvi b, 64
        
        push h
        xchg
        lxi d, 14
        dad d
        xchg
        pop h

        dcr c
        rnz
        mvi c, 13

        mov a, m
        inx h 
        
        push b
        push d
        push h        
frameDivider:
	mvi c, 6 ; frameDivider
y:	mvi b, SPD
x:	push b
	call waitHorzSync
	pop b
	dcr b
	jnz x

        push b
	call doMusic
	call doMute	
        pop b
	
	dcr c
	jnz y

        pop h
        pop d
        pop b

        call 0F81Bh
        cpi '1'
        jc if0
        cpi '9'+1
        jnc if0
        sui '1'-1
        sta frameDivider+1
if0:
	
        lxi d, 0E496h
	lxi b, 64*256+13
        ret
    
lastChar: .db 0
musicDiver: .db 0

;----------------------------------------------------------------------------

waitHorzSync:
	lxi h, 0EF01h
	mvi m, 027h
	mov a, m
waitHorzSync_1:
	mov a, m
	ani 20h
	jz waitHorzSync_1
	ret
	
title: .db 01Fh,"klawi{i 1-9 izmenenie skorosti",0

.include "music.inc"
.include "unmlz.inc"

text:
.end