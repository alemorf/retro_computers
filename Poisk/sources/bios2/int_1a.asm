;----- INT 1A --------------------------------------------------------------
; TIME_OF_DAY
;	’ ……‚€… ‡‚‹…’ “‘’€€‚‹‚€’/—’€’ CMOC —€‘›
; € ‚•„…
;   (AH) = 0 —’…… ’…“™…ƒ ‡€—… CMOS —€‘‚
;     ‚‡‚€’ CX = ‘’€‰ €‰’ ‘—…’—€
;	      DX = ‹€„‰ €‰’
;	      AL = 0 …‘‹ … ‹ 24 —€‘‚ ‘‹… ‘‹…„…ƒ —’…
;	      <> 0 …‘‹ ‘‹…„“™‰ „…
;   (AH) = 1 “‘’€‚€ ‡€—… CMOS —€‘‚
;	      CX = ‘’€‰ €‰’ ‘—…’—€
;	      DX = ‹€„‰ €‰’ ‘—…’—€
; ‡€…—€…: ‘—…’ „…’ ‘ ‘‘’ 1193180/65536 €‡ ‚ ‘…“„“
;	(‹ ‹ 18.2 €‡€ ‚ ‘…“„“ - ‘’ …€’› EQU)
;   (AH) = 2 —’…… ’…“™…ƒ ‚……
;     ‚‡‚€’ CH = —€‘› ‚ BCD „…
;	      CL = “’› ‚ BCD „…
;	      DH = ‘…“„› ‚ BCD „…
;   (AH) = 3 “‘’€‚€ ’…“™…ƒ ‚……
;	      CH = —€‘› ‚ BCD „…
;	      CL = “’› ‚ BCD „…
;	      DH = ‘…“„› ‚ BCD „…
;	      DL = 1 …‘‹ …‚€ ‹‚€ „, €—… 0
;   (AH) = 4 —’…… „€’› ‡ —€‘‚ CMOS
;     ‚‡‚€’ CH = ‘’‹…’… ‚ BCD (19 ‹ 20)
;	      CL = ƒ„ ‚ BCD
;	      DH = …‘– ‚ BCD
;	      DL = „… ‚ BCD
;   (AH) = 5 “‘’€‚€ „€’› ‚ —€‘€• CMOS
;	      CH = ‘’‹…’… ‚ BCD (19 OR 20)
;	      CL = ƒ„ ‚ BCD
;	      DH = …‘– ‚ BCD
;	      DL = „… ‚ BCD
;   (AH) = 6 “‘’€‚€ ‘ƒ€‹€
;	     ‘ƒ€‹ †…’ ›’ “‘’€‚‹…  ‚…… „ 23:59:59
;	     „€ ”“– ‘ƒ€‹€ †…’ ›’ €’‚€ ‚ ‹… ‚…
;	      CH = —€‘› ‚ BCD
;	      CL = “’› ‚ BCD
;	      DH = ‘…“„› ‚ BCD
;   (AH) = 7 ‘‘ ‘ƒ€‹€
; ‡€…—€…: „‹ AH = 2, 4, 6 - ”‹€ƒ CY “‘’€‚‹… …‘‹ —€‘› … €’€’
;	„‹ AH = 6 - ”‹€ƒ CY “‘’€‚‹… …‘‹ ‘ƒ€‹ “†… ‚‹—…
; ‡€…—€…: „‹ ”“– “‘’€‚ ‘ƒ€‹€ (AH = 6) ‹‡‚€’…‹
; „‹†… €‚‹ “‘’€‚’ €„…‘ …›‚€ INT 4AH ‚ ’€‹–… ‚…’‚
;---------------------------------------------------------------------------

	assume	cs:code,ds:data
TIME_2:
TIME_OF_DAY_1	PROC	FAR
  STI				;€‡……… …›‚€‰
  push	ds
  CALL	 DDS			;SET DATA SEGMENT
  OR	 AH,AH			;AH = 0
  JZ	 T2			;READ_TIME
  DEC	 AH			;AH = 1
  JZ	 T3			;SET_TIME
  CMP	 AH,07			;‚…€ € €‚‹‘’
  JGE	 T1			;‚‡‚€’ …‘‹ …’
  JMP    short RTC_0            ;‚…€ „“ƒ• …†‚
T1:
  STI				;€‡……… …›‚€‰
  POP	 DS			;‚‘’€€‚‹‚€… ‘…ƒ…’
  IRET
T1_A:
  STC				;“‘’€‚€ ™ ‚‡‚€’€
  POP	 DS
  RET	 2
T2:				;READ_TIME
  CLI				;€ —’…… ‡€…’ …›‚€‰
  MOV	 AL,TIMER_OFL
  MOV	 TIMER_OFL,0		;‚‡’ ‡€—……  “‘’€‚’ ”‹€ƒ
  MOV	 CX,TIMER_HIGH
  MOV	 DX,TIMER_LOW
  JMP	 T1			;TOD_RETURN
T3:				;SET_TIME
  CLI				;€ —’…… ‡€…’ …›‚€‰
  MOV	 TIMER_LOW,DX
  MOV	 TIMER_HIGH,CX		;“‘’€‚€ ‚……
  MOV	 TIMER_OFL,00		;‘‘ ”‹€ƒ€
  JMP	 T1			;TOD_RETURN
RTC_0:
  DEC	 AH			;AH = 2
  JZ	 RTC_2			;—’…… CMOS ‚……
  DEC	 AH			;AH = 3
  JZ	 RTC_3			;“‘’€‚€ CMOS ‚……
  JMP	 RTC_1			;‚…€ ‘’€‚•‘ ”“–‰
RTC_GET_TIME	PROC	NEAR
RTC_2:
  CALL	 UPD_IN_PR		;‚…€ „‹ ‡……‰ ‚ –…‘‘…
  JNC	 RTC_2A 		;„€‹… …‘‹ OK
  JMP	 T1_A			;‚‡‚€’ …‘‹ €
RTC_2A:
  CLI				;‡€…’ …›‚€‰
  MOV	 DL,-2
  CALL	 PORT_INC_2		;“‘’€‚’ €„…‘ ‘…“„
  IN	 AL,CMOS_PORT+1
  MOV	 DH,AL			;‡€’
  CALL	 PORT_INC_2		;“‘’€‚’ €„…‘ “’
  IN	 AL,CMOS_PORT+1
  MOV	 CL,AL			;‡€’
  CALL	 PORT_INC_2		;“‘’€‚’ €„…‘ —€‘‚
  IN	 AL,CMOS_PORT+1
  MOV	 CH,AL			;‡€’
  MOV	 DL,00			;“‘’€‚’ DL ‚ 0
  JMP	 T1			;‚‡‚€’
RTC_GET_TIME	ENDP
;	ORG 0E506H
RTC_SET_TIME	PROC	NEAR
RTC_3:
  CALL	 UPD_IN_PR		;‚…€ „‹ ‡……‰ ‚ –…‘‘…
  JNC	 RTC_3A 		;„‹†’ …‘‹ —€‘› €’€’
  CALL	 INITIALIZE_STATUS
RTC_3A:
  CLI				;€ “‘’€‚€ ‡€…’ …›‚€‰
  PUSH	 DX			;‡€’
  MOV	 DL,-2			;…‚›‰ €„…‘
  CALL	 PORT_INC_2		;‡…’ €„…‘
  MOV	 AL,DH			;‚‡’ ’ ‚…… - ‘…“„›
  OUT	 CMOS_PORT+1,AL 	;‡€‘€’ ’
  CALL	 PORT_INC_2		;‡…’ €„…‘
  MOV	 AL,CL			;‚‡’ ’ ‚…… - “’›
  OUT	 CMOS_PORT+1,AL 	;‡€‘€’ ’
  CALL	 PORT_INC_2		;‡…’ €„…‘
  MOV	 AL,CH			;‚‡’ ’ ‚…… - —€‘›
  OUT	 CMOS_PORT+1,AL 	;‡€‘€’ ’
  MOV	 DL,0AH
  CALL	 PORT_INC
  POP	 DX			;‚‘’€‚’
  IN	 AL,CMOS_PORT+1 	;‚‡’ ’…“™…… ‡€—……
  AND	 AL,23H 		;€‘€ „‹ €‚‹‰ ‡– ’€
  OR	 AL,DL			;‚‡’ DST ’
  OR	 AL,02			;‚‹—’ 24-—€‘‚‰ …†
  PUSH	 AX
  MOV	 DL,0AH
  CALL	 PORT_INC
  POP	 AX
  OUT	 CMOS_PORT+1,AL
  JMP	 T1			;‚›‹…
RTC_SET_TIME	ENDP
   
RTC_GET_DATE	PROC	NEAR
RTC_4:
  CALL	 UPD_IN_PR
  JNC	 RTC_4A 		;‚‡‚€’ …‘‹ €
  JMP	 T1_A
RTC_4A:
  CLI				;€ “‘’€‚€ ‡€…’ …›‚€‰
  MOV	 DL,06
  CALL	 PORT_INC		;“€‡€’…‹ € „…
  IN	 AL,CMOS_PORT+1
  MOV	 CH,AL			;‡€’
  CALL	 PORT_INC		;“€‡€’…‹ € …‘–
  IN	 AL,CMOS_PORT+1
  MOV	 DH,AL			;‡€’
  CALL	 PORT_INC		;“€‡€’…‹ € ƒ„
  IN	 AL,CMOS_PORT+1
  MOV	 CL,AL			;‡€’
  MOV	 DL,31H 		;“€‡€’…‹ € €‰’ ‚…€
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;‚‡’ ‡€—……
  MOV	 DL,CH			;GET DAY BACK
  MOV	 CH,AL
  JMP	 T1			;”
RTC_GET_DATE	ENDP
RTC_1:
  DEC	 AH			;AH = 4
  JZ	 RTC_4			;—’€’ „€’“ ‡ CMOS
  DEC	 AH			;AH = 5
  JZ	 RTC_5			;“‘’€‚’ „€’“ ‚ CMOS
  DEC	 AH			;AH = 6
  JZ	 RTC_6			;“‘’€‚’ ‘ƒ€‹ ‚ CMOS
  JMP    RTC_7                  ;‘‘ ‘ƒ€‹€ CMOS
SOOB_1	DB	'All right reserved',0
        ORG  0E506H

RTC_SET_DATE	PROC	NEAR
RTC_5:
  CALL	 UPD_IN_PR		;‚…€ „‹ ‡……‰ ‚ –…‘‘…
  JNC	 RTC_5A 		;„€‹… …‘‹ —€‘› ‡……›
  CALL	 INITIALIZE_STATUS
RTC_5A:
  CLI				;€ “‘’€‚€ ‡€…’ …›‚€‰
  PUSH	 CX			;‡€’
  MOV	 CH,DL			;‡€’ „… …‘–€
  MOV	 DL,5			;€„…‘ …ƒ‘’€ „ …„…‹
  CALL	 PORT_INC
  MOV	 AL,00H
  OUT	 CMOS_PORT+1,AL 	;“‹’ €‰’ '„… …„…‹'
  CALL	 PORT_INC		;€„…‘ …ƒ‘’€ „ …‘–€
  MOV	 AL,CH			;‚‡’ €‰’ '„… …‘–€'
  OUT	 CMOS_PORT+1,AL 	;‡€’
  CALL	 PORT_INC		;€„…‘ …ƒ‘’€ …‘–€
  MOV	 AL,DH			;‚‡’ €‰’ '…‘–'
  OUT	 CMOS_PORT+1,AL 	;‡€’
  CALL	 PORT_INC		;€„…‘ …ƒ‘’€ ƒ„€
  MOV	 AL,CL			;‚‡’ €‰’ 'ƒ„'
  OUT	 CMOS_PORT+1,AL 	;‡€’
  MOV	 DL,0AH
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;‚‡’ ’…“™“ “‘’€‚“
  AND	 AL,07FH		;—‘’’ 'SET BIT'
  OUT	 CMOS_PORT+1,AL 	; €—€’ ‡€‘ —€‘‚
  POP	 CX			;‚‡‚€’’ €’
  MOV	 DL,31H 		;“‹€‡€’…‹ € ‡€‘€“ ‹€‘’
  CALL	 PORT_INC
  MOV	 AL,CH			;‚‡’ €‰’ ‚…€
  OUT	 CMOS_PORT+1,AL 	;‡€’
  JMP	 T1			;‚‡‚€’
RTC_SET_DATE  ENDP

RTC_SET_ALARM  PROC  NEAR
;	org	0e506h
RTC_6:
  MOV	 DL,0AH 		;‚…€ € “‘’€‚‹…›‰ ‘ƒ€‹
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;‚‡’ ’…“™“ “‘’€‚“ ‘ƒ€‹€
  TEST	 AL,20H
  JZ	 RTC_6A 		;‘ƒ€‹ … “‘’€‚‹… - ‚›‹……
  XOR	 AX,AX			;
  JMP	 T1_A			;‚‡‚€’ …‘‹ €
RTC_6A:
  CALL	 UPD_IN_PR		;‚…€ „‹ ‡……‰ ‚ –…‘‘…
  JNC	 RTC_6B
  CALL	 INITIALIZE_STATUS
RTC_6B:
  CLI				;€ “‘’€‚€ ‡€…’ …›‚€‰
  MOV	 DL,-1
  CALL	 PORT_INC_2
  MOV	 AL,DH			;‚‡’ €‰’ ‘…“„
  OUT	 CMOS_PORT+1,AL 	;‡€ƒ“‡’ €‰’ ‘ƒ€‹€ - ‘…“„›
  CALL	 PORT_INC_2
  MOV	 AL,CL			;‚‡’ €€…’› “’
  OUT	 CMOS_PORT+1,AL 	;‡€ƒ“‡’ €‰’ ‘ƒ€‹€ - “’›
  CALL	 PORT_INC_2
  MOV	 AL,CH			;‚‡’ €€…’› —€‘‚
  OUT	 CMOS_PORT+1,AL 	;‡€ƒ“‡’ €‰’ ‘ƒ€‹€ - —€‘›
  IN	 AL,0A1H		;ƒ€€’‚€… €‡……… …›‚€…
  AND	 AL,0FEH
  OUT	 0A1H,AL
  MOV	 DL,0AH
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;‚‡’ ’…“™…… ‡€—……
  AND	 AL,07FH		;ƒ€€’‚€€ “‘’€‚€ ’€
  OR	 AL,20H 		;‚‹—’ ‚‡†‘’ ‘ƒ€‹€
  PUSH	 AX
  MOV	 DL,0AH
  CALL	 PORT_INC
  POP	 AX
  OUT	 CMOS_PORT+1,AL 	;‘ƒ€‹ ‚‡†…
  JMP	 T1
RTC_SET_ALARM  ENDP

RTC_RESET_ALARM  PROC  NEAR
RTC_7:
  CLI				;‹‚€ …›‚€‰ € “‘’€‚€
  MOV	 DL,0AH
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;‚‡’ €‰’ ‘’€’“‘€
  AND	 AL,57H 		;‚›‹—’ ‚‡†‘’ ‘ƒ€‹€
  PUSH	 AX			;‡€’
  MOV	 DL,0AH
  CALL	 PORT_INC
  POP	 AX
  OUT	 CMOS_PORT+1,AL 	;‚‘’€‚’
  JMP	 T1
RTC_RESET_ALARM  ENDP

RTC_TIMEBIOS_SUBR  PROC  NEAR
PORT_INC:
  INC	 DL			;“‚…‹—’ €„…‘
  MOV	 AL,DL
  OUT	 CMOS_PORT,AL
  RET
PORT_INC_2:
  ADD	 DL,2			;“‚…‹—’ €„…‘
  MOV	 AL,DL
  OUT	 CMOS_PORT,AL
  RET
INITIALIZE_STATUS  PROC NEAR
  PUSH	 DX			;‡€’
  MOV	 DL,09H
  CALL	 PORT_INC
  MOV	 AL,26H
  OUT	 CMOS_PORT+1,AL 	;–€‹‡‚€’ …ƒ‘’  'A'
  CALL	 PORT_INC
  MOV	 AL,82H 		;“‘’€‚’ ’ 'SET BIT' „‹
				;–€‹‡€– —€‘‚  24 —€‘‚ƒ …†€
  OUT	 CMOS_PORT+1,AL 	;–€‹‡‚€’ …ƒ‘’ 'B'
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;—’…… …ƒ‘’€ 'C' „‹ –€‹‡€–
  CALL	 PORT_INC
  IN	 AL,CMOS_PORT+1 	;—’…… …ƒ‘’€ 'D' „‹ –€‹‡€–
  POP	 DX			;‚‘’€‚’
  RET
INITIALIZE_STATUS  ENDP

UPD_IN_PR:
  PUSH	 CX
  MOV	 CX,600 		;“‘’€‚’ ‘—…’— –‹‚
UPDATE:
  MOV	 AL,0AH 		;€„…‘ …ƒ‘’€ 'A'
  OUT	 CMOS_PORT,AL
  JMP	 SHORT $+2		;I/O ‚……€ ‡€„…†€
  IN	 AL,CMOS_PORT+1 	;—’…… ‚ …ƒ‘’ 'A'
  TEST	 AL,80H 		;…‘‹ 8XH-->UIP ’ ‚‹—…
				;(…‹‡ —’€’ ‚…)
  JZ	 UPD_IN_PREND
  LOOP	 UPDATE
  XOR	 AX,AX
  STC				;“‘’€‚€ CARRY „‹ 
UPD_IN_PREND:
  POP	 CX
  RET
RTC_TIMEBIOS_SUBR  ENDP
TIME_OF_DAY_1  ENDP


otsl_1  proc near
;®βα«¥¦¨Ά ­¨¥ ―¥ΰ¥―®«­¥­¨ο
	MOV	BX,160*2+19*2
	MOV	CX,3630H
	MOV	DX,3539H
	CALL	OTSL
	MOV	BX,160*2+16*2
	CALL	OTSL
	MOV	BX,160*4+19*2
	CALL	OTSL
	MOV	BX,160*4+16*2
	CALL	OTSL
	MOV	BX,160*2+13*2
	MOV	CX,3234H
	MOV	DX,3233H
	CALL	OTSL
	MOV	BX,160*4+13*2
	CALL	OTSL
	MOV	CX,3332H
	MOV	DX,3331H
	MOV	BX,160*3+13*2
	CALL	OTSL
	MOV	CX,3133H
	MOV	DX,3132H
	MOV	BX,160*3+16*2
	CALL	OTSL
	MOV	CX,3035H
	MOV	DX,3034H
	MOV	BX,160*6+13*2
	CALL	OTSL
	MOV	BX,160*7+13*2
	CALL	OTSL
;hard
	MOV	CX,3136H
	MOV	DX,3135H
	MOV	BX,160*8+13*2
OT_1:	CALL	OTSL
;adapter
	MOV	CX,3034H
	MOV	DX,3033H
	MOV	BX,160*9+13*2
	CALL	OTSL
	ret
otsl_1	endp	
;®βα«¥¦¨Ά ­¨¥
;BX- ¤ΰ¥α,CX-¬ ªα¨¬ «μ­®¥ §­ η¥­¨¥ DX=CX-1, AX-¬¨­¨¬ «μ­®¥ §­ η¥­¨¥
OTSL	PROC  NEAR
	MOV	AL,byte ptr ES:[BX+2]
	MOV	AH,byte ptr ES:[BX]
	CMP	AX,CX
	jb	rt_1
	MOV	byte ptr ES:[BX],30H
	MOV	byte ptr ES:[BX+2],30H
RT_1:   CMP	AX,3939H
	jb	rt_2
	MOV	byte ptr ES:[BX],DH
	MOV	byte ptr ES:[BX+2],DL
RT_2:   RET
OTSL	ENDP

CMOS_MEM PROC NEAR
	call	dds
        MOV     BX,MEMORY_SIZE
	MOV	AL,16H
	OUT 	CMOS_PORT,AL
	IN	AL,CMOS_PORT+1
	MOV	AH,AL
	MOV	AL,15H
	OUT 	CMOS_PORT,AL
	IN	AL,CMOS_PORT+1
	CMP	AX,BX
	JA	WEL_1
	XCHG	AX,BX
;γαβ ­®Άª  ΰ §¬¥ΰ  ― ¬οβ¨ ¨§ CMOS
	CALL	CMOS_DIAG1
	TEST	AL,0DH
	JNZ	WEL_1
	MOV     MEMORY_SIZE,BX    	;SAVE MEMORY SIZE
WEL_1:  RET
CMOS_MEM ENDP

H_ARD	DB	'Hard',0
A_DAP	DB	'Adapter',0
ROM_S	DB	'System M',0
EMS_S	DB	'EMS size',0

SOOB_2	DB	'SET_UP POISK 1991',0

DISK_0	DB	'None ',0
DISK_2  DB	'360K ',0
DISK_3  DB	'1.2M ',0
DISK_5  DB	'1.44M',0
DISK_4  DB	'720K ',0
ADAPT1	DB	'Ega,Vga   ',0
ADAPT2	DB	'Cga 40-clm',0
ADAPT3	DB	'Cga 80-clm',0
ADAPT4	DB	'Monochrome',0
