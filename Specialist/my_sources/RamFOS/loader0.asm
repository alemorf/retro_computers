;----------------------------------------------------------------------------
; RAMFOS + Специалист MX2
; Загрузчик
;
; 2013-11-01 Разработано vinxru
;----------------------------------------------------------------------------

.include "config.inc"

; Точка входа для запуска файла
RAMFOS_EXEC = 0F857h	

;----------------------------------------------------------------------------
; Стандартные точки входа

.org 0                      
		jmp	reboot
		jmp	debuger
		jmp	editor
		jmp	asm
		jmp	disasm

;----------------------------------------------------------------------------

disasm:		lxi	h, a_disasm
		jmp	RAMFOS_EXEC
a_disasm:	.db "DisAsm   EXE"

;----------------------------------------------------------------------------

asm:		lxi	h, a_asm
		jmp	RAMFOS_EXEC
a_asm:		.db "Asm      EXE"

;----------------------------------------------------------------------------

editor:		lxi	h, a_editor
		jmp	RAMFOS_EXEC
a_editor:	.db "Editor   EXE"

;----------------------------------------------------------------------------

debuger:	lxi	h, a_debuger
		jmp	RAMFOS_EXEC
a_debuger:	.db "Debuger  EXE"

;----------------------------------------------------------------------------

reboot:		; Стек
		lxi     sp, 08FFEh

		; Сжатый загрузчик
		lxi     h, loader1Offset
		push	h
		lxi     d, loader1
		mov	b, h
		mov	c, l

#if $ != unmlzOffset
Некорректный_unmlzOffset
#endif

.include "unmlz.inc"

loader1:
.include "loader1.inc"

.end