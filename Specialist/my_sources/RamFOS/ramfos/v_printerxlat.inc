;+---------------------------------------------------------------------------
; RAMFOS
; Таблица преобразования кодировки символов для принтера
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_PRINTER==0

v_printerXlat:	.db 0EEh, 0D0h, 0D1h, 0E6h, 0D4h, 0D5h, 0E4h, 0D3h 
		.db 0E5h, 0D8h, 0D9h, 0DAh, 0DBh, 0DCh, 0DDh, 0DEh
		.db 0DFh, 0EFh, 0E0h, 0E1h, 0E2h, 0E3h, 0D6h, 0D2h
		.db 0ECh, 0EBh, 0D7h, 0E8h, 0EDh, 0E9h, 0E7h, 0EAh
		.db 0CEh, 0B0h, 0B1h, 0C6h, 0B4h, 0B5h, 0C4h, 0B3h 
		.db 0C5h, 0B8h, 0B9h, 0BAh, 0BBh, 0BCh, 0BDh, 0BEh
		.db 0BFh, 0CFh, 0C0h, 0C1h, 0C2h, 0C3h, 0B6h, 0B2h
		.db 0CCh, 0CBh, 0B7h, 0C8h, 0CDh, 0C9h, 0C7h, 0CAh

#endif