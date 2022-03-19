.org 0h
start: call initMusic
l:     
       call doMusicDelay
       jmp l

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
	
;----------------------------------------------------------------------------

.include "music.inc"

.end