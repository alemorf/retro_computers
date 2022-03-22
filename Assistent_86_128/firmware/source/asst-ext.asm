; +-------------------------------------------------------------------------+
; |   ASSISTENT EXTERNAL LOGO PROCEDURE          						    |
; +-------------------------------------------------------------------------+
F490:0000  E9 36 07            JMPN  0739

; LOGO DATA ...

F490:0739  8C C8               MOV   AX, CS
F490:073B  8E C0               MOV   ES, AX
F490:073D  8E D8               MOV   DS, AX
F490:073F  B4 00               MOV   AH, 00
F490:0741  B0 04               MOV   AL, 04
F490:0743  CD 10               INT   10
F490:0745  B4 0B               MOV   AH, 0B
F490:0747  BB 01 00            MOV   BX, 0001
F490:074A  CD 10               INT   10
F490:074C  B4 0B               MOV   AH, 0B
F490:074E  BB 00 01            MOV   BX, 0100
F490:0751  CD 10               INT   10
F490:0753  BB A0 2F            MOV   BX, 2FA0
F490:0756  53                  PUSH  BX
F490:0757  BB A0 0F            MOV   BX, 0FA0
F490:075A  53                  PUSH  BX
F490:075B  E9 84 00            JMPN  07E2
F490:075E  E9 13 01            JMPN  0874
F490:0761  E9 40 01            JMPN  08A4
F490:0764  B5 2A               MOV   CH, 2A
F490:0766  5E                  POP   SI
F490:0767  8B DE               MOV   BX, SI
F490:0769  E8 64 01            CALL  08D0
F490:076C  5E                  POP   SI
F490:076D  56                  PUSH  SI
F490:076E  53                  PUSH  BX
F490:076F  E8 5E 01            CALL  08D0
F490:0772  E8 9D 00            CALL  0812
F490:0775  E8 F2 00            CALL  086A
F490:0778  FE CD               DEC   CH
F490:077A  80 FD 00            CMP   CH, 00
F490:077D  75 E7               JNZ   0766
F490:077F  B8 EE EE            MOV   AX, EEEE
F490:0782  E8 E8 00            CALL  086D
F490:0785  B3 02               MOV   BL, 02
F490:0787  BA 43 00            MOV   DX, 0043
F490:078A  B0 B6               MOV   AL, B6
F490:078C  EE                  OUT   DX, AL
F490:078D  BA 42 00            MOV   DX, 0042
F490:0790  B8 33 05            MOV   AX, 0533
F490:0793  EE                  OUT   DX, AL
F490:0794  8A C4               MOV   AL, AH
F490:0796  EE                  OUT   DX, AL
F490:0797  BA 61 00            MOV   DX, 0061
F490:079A  EC                  IN    AL, DX
F490:079B  8A E0               MOV   AH, AL
F490:079D  0C 03               OR    AL, 03
F490:079F  EE                  OUT   DX, AL
F490:07A0  2B C9               SUB   CX, CX
F490:07A2  E2 FE               LOOP  07A2
F490:07A4  FE CB               DEC   BL
F490:07A6  75 FA               JNZ   07A2
F490:07A8  8A C4               MOV   AL, AH
F490:07AA  EE                  OUT   DX, AL
F490:07AB  B8 EE EE            MOV   AX, EEEE
F490:07AE  E8 BC 00            CALL  086D
F490:07B1  5F                  POP   DI
F490:07B2  5E                  POP   SI
F490:07B3  56                  PUSH  SI
F490:07B4  57                  PUSH  DI
F490:07B5  B1 50               MOV   CL, 50
F490:07B7  B0 00               MOV   AL, 00
F490:07B9  26 88 05            MOV   BYTE [ES:DI], AL
F490:07BC  26 88 04            MOV   BYTE [ES:SI], AL
F490:07BF  46                  INC   SI
F490:07C0  47                  INC   DI
F490:07C1  FE C9               DEC   CL
F490:07C3  80 F9 00            CMP   CL, 00
F490:07C6  75 EF               JNZ   07B7
F490:07C8  81 FF F0 0F         CMP   DI, 0FF0
F490:07CC  74 0B               JZ    07D9
F490:07CE  E8 6D 00            CALL  083E
F490:07D1  B8 55 0A            MOV   AX, 0A55
F490:07D4  E8 96 00            CALL  086D
F490:07D7  EB D8               JMPS  07B1
F490:07D9  B4 00               MOV   AH, 00
F490:07DB  B0 01               MOV   AL, 01
F490:07DD  CD 10               INT   10
F490:07DF  58                  POP   AX
F490:07E0  58                  POP   AX
F490:07E1  CB                  RETF
F490:07E2  BF 03 00            MOV   DI, 0003
F490:07E5  B9 08 00            MOV   CX, 0008
F490:07E8  5E                  POP   SI
F490:07E9  56                  PUSH  SI
F490:07EA  B8 00 B8            MOV   AX, B800
F490:07ED  8E C0               MOV   ES, AX
F490:07EF  E8 0C 01            CALL  08FE
F490:07F2  E8 4B 01            CALL  0940
F490:07F5  E8 27 01            CALL  091F
F490:07F8  47                  INC   DI
F490:07F9  5B                  POP   BX
F490:07FA  5E                  POP   SI
F490:07FB  56                  PUSH  SI
F490:07FC  53                  PUSH  BX
F490:07FD  E8 FE 00            CALL  0u8FE
F490:0800  E8 3D 01            CALL  0940
F490:0803  E8 19 01            CALL  091F
F490:0806  47                  INC   DI
F490:0807  E8 08 00            CALL  0812
F490:080A  E8 5D 00            CALL  086A
F490:080D  E1 D9               LOOPZ 07E8
F490:080F  E9 4C FF            JMPN  075E
F490:0812  5B                  POP   BX
F490:0813  5E                  POP   SI
F490:0814  81 FE 00 20         CMP   SI, 2000
F490:0818  73 0A               JNC   0824
F490:081A  81 C6 00 20         ADD   SI, 2000
F490:081E  83 EE 50            SUB   SI, +50
F490:0821  EB 05               JMPS  0828
F490:0823  90                  NOP
F490:0824  81 EE 00 20         SUB   SI, 2000
F490:0828  58                  POP   AX
F490:0829  3D 00 20            CMP   AX, 2000
F490:082C  73 06               JNC   0834
F490:082E  05 00 20            ADD   AX, 2000
F490:0831  EB 07               JMPS  083A
F490:0833  90                  NOP
F490:0834  2D 00 20            SUB   AX, 2000
F490:0837  05 50 00            ADD   AX, 0050
F490:083A  50                  PUSH  AX
F490:083B  56                  PUSH  SI
F490:083C  53                  PUSH  BX
F490:083D  C3                  RETN
F490:083E  5E                  POP   SI
F490:083F  5B                  POP   BX
F490:0840  81 FB 00 20         CMP   BX, 2000
F490:0844  73 07               JNC   084D
F490:0846  81 C3 00 20         ADD   BX, 2000
F490:084A  EB 08               JMPS  0854
F490:084C  90                  NOP
F490:084D  81 EB 00 20         SUB   BX, 2000
F490:0851  83 C3 50            ADD   BX, +50
F490:0854  58                  POP   AX
F490:0855  3D 00 20            CMP   AX, 2000
F490:0858  73 09               JNC   0863
F490:085A  05 00 20            ADD   AX, 2000
F490:085D  2D 50 00            SUB   AX, 0050
F490:0860  EB 04               JMPS  0866
F490:0862  90                  NOP
F490:0863  2D 00 20            SUB   AX, 2000
F490:0866  50                  PUSH  AX
F490:0867  53                  PUSH  BX
F490:0868  56                  PUSH  SI
F490:0869  C3                  RETN
F490:086A  B8 B3 15            MOV   AX, 15B3
F490:086D  48                  DEC   AX
F490:086E  3D 00 00            CMP   AX, 0000
F490:0871  75 FA               JNZ   086D
F490:0873  C3                  RETN
F490:0874  B6 0C               MOV   DH, 0C
F490:0876  BF 73 03            MOV   DI, 0373
F490:0879  BD 7F 03            MOV   BP, 037F
F490:087C  5E                  POP   SI
F490:087D  8B DE               MOV   BX, SI
F490:087F  E8 CC 00            CALL  094E
F490:0882  83 C7 0C            ADD   DI, +0C
F490:0885  83 C5 0C            ADD   BP, +0C
F490:0888  5E                  POP   SI
F490:0889  56                  PUSH  SI
F490:088A  53                  PUSH  BX
F490:088B  E8 C0 00            CALL  094E
F490:088E  83 C7 0C            ADD   DI, +0C
F490:0891  83 C5 0C            ADD   BP, +0C
F490:0894  E8 7B FF            CALL  0812
F490:0897  E8 D0 FF            CALL  086A
F490:089A  FE CE               DEC   DH
F490:089C  80 FE 00            CMP   DH, 00
F490:089F  75 DB               JNZ   087C
F490:08A1  E9 BD FE            JMPN  0761
F490:08A4  B6 12               MOV   DH, 12
F490:08A6  BF 9B 05            MOV   DI, 059B
F490:08A9  BD A7 05            MOV   BP, 05A7
F490:08AC  5E                  POP   SI
F490:08AD  8B DE               MOV   BX, SI
F490:08AF  E8 9C 00            CALL  094E
F490:08B2  5E                  POP   SI
F490:08B3  56                  PUSH  SI
F490:08B4  53                  PUSH  BX
F490:08B5  E8 18 00            CALL  08D0
F490:08B8  83 C7 0C            ADD   DI, +0C
F490:08BB  83 C5 0C            ADD   BP, +0C
F490:08BE  E8 51 FF            CALL  0812
F490:08C1  E8 A6 FF            CALL  086A
F490:08C4  FE CE               DEC   DH
F490:08C6  80 FE 00            CMP   DH, 00
F490:08C9  75 03               JNZ   08CE
F490:08CB  E9 96 FE            JMPN  0764
F490:08CE  EB DC               JMPS  08AC
F490:08D0  B1 05               MOV   CL, 05
F490:08D2  B0 00               MOV   AL, 00
F490:08D4  26 88 04            MOV   BYTE [ES:SI], AL
F490:08D7  46                  INC   SI
F490:08D8  FE C9               DEC   CL
F490:08DA  80 F9 00            CMP   CL, 00
F490:08DD  75 F3               JNZ   08D2
F490:08DF  B1 46               MOV   CL, 46
F490:08E1  B0 AA               MOV   AL, AA
F490:08E3  26 88 04            MOV   BYTE [ES:SI], AL
F490:08E6  46                  INC   SI
F490:08E7  FE C9               DEC   CL
F490:08E9  80 F9 00            CMP   CL, 00
F490:08EC  75 F3               JNZ   08E1
F490:08EE  B1 05               MOV   CL, 05
F490:08F0  B0 00               MOV   AL, 00
F490:08F2  26 88 04            MOV   BYTE [ES:SI], AL
F490:08F5  46                  INC   SI
F490:08F6  FE C9               DEC   CL
F490:08F8  80 F9 00            CMP   CL, 00
F490:08FB  75 F3               JNZ   08F0
F490:08FD  C3                  RETN
F490:08FE  51                  PUSH  CX
F490:08FF  B9 05 00            MOV   CX, 0005
F490:0902  B0 00               MOV   AL, 00
F490:0904  26 88 04            MOV   BYTE [ES:SI], AL
F490:0907  46                  INC   SI
F490:0908  49                  DEC   CX
F490:0909  83 F9 00            CMP   CX, +00
F490:090C  75 F6               JNZ   0904
F490:090E  B9 07 00            MOV   CX, 0007
F490:0911  B0 AA               MOV   AL, AA
F490:0913  26 88 04            MOV   BYTE [ES:SI], AL
F490:0916  46                  INC   SI
F490:0917  49                  DEC   CX
F490:0918  83 F9 00            CMP   CX, +00
F490:091B  75 F6               JNZ   0913
F490:091D  59                  POP   CX
F490:091E  C3                  RETN
F490:091F  51                  PUSH  CX
F490:0920  B9 09 00            MOV   CX, 0009
F490:0923  B0 AA               MOV   AL, AA
F490:0925  26 88 04            MOV   BYTE [ES:SI], AL
F490:0928  46                  INC   SI
F490:0929  49                  DEC   CX
F490:092A  83 F9 00            CMP   CX, +00
F490:092D  75 F6               JNZ   0925
F490:092F  B9 05 00            MOV   CX, 0005
F490:0932  B0 00               MOV   AL, 00
F490:0934  26 88 04            MOV   BYTE [ES:SI], AL
F490:0937  46                  INC   SI
F490:0938  49                  DEC   CX
F490:0939  83 F9 00            CMP   CX, +00
F490:093C  75 F6               JNZ   0934
F490:093E  59                  POP   CX
F490:093F  C3                  RETN
F490:0940  8A 05               MOV   AL, BYTE [DI]
F490:0942  3C 24               CMP   AL, 24
F490:0944  74 07               JZ    094D
F490:0946  26 88 04            MOV   BYTE [ES:SI], AL
F490:0949  46                  INC   SI
F490:094A  47                  INC   DI
F490:094B  EB F3               JMPS  0940
F490:094D  C3                  RETN
F490:094E  3E 8A 4E 00         MOV   CL, BYTE [DS:BP+00]
F490:0952  8A 05               MOV   AL, BYTE [DI]
F490:0954  3C 24               CMP   AL, 24
F490:0956  74 11               JZ    0969
F490:0958  26 88 04            MOV   BYTE [ES:SI], AL
F490:095B  46                  INC   SI
F490:095C  FE C9               DEC   CL
F490:095E  80 F9 00            CMP   CL, 00
F490:0961  74 02               JZ    0965
F490:0963  EB ED               JMPS  0952
F490:0965  45                  INC   BP
F490:0966  47                  INC   DI
F490:0967  EB E5               JMPS  094E
F490:0969  C3                  RETN


; +-------------------------------------------------------------------------+
; |   ASSISTENT EXTERNAL FLOPPY-SEEK PROCEDURES 						    |
; +-------------------------------------------------------------------------+
; EE83 = NEC_OUTPUT
; EEE6 = CHK_STAT_2
; EEAF = GET_PARM

F000:5300  B0 01               MOV   AL, 01
F000:5302  51                  PUSH  CX
F000:5303  8A CA               MOV   CL, DL
F000:5305  D2 C0               ROL   AL, CL
F000:5307  59                  POP   CX
F000:5308  84 06 3E 00         TEST  BYTE [003E], AL
F000:530C  75 13               JNZ   5321
F000:530E  08 06 3E 00         OR    BYTE [003E], AL
F000:5312  B4 07               MOV   AH, 07
F000:5314  E8 6C 9B            CALL  EE83		;  NEC_OUTPUT
F000:5317  8A E2               MOV   AH, DL
F000:5319  E8 67 9B            CALL  EE83		;  NEC_OUTPUT
F000:531C  E8 C7 9B            CALL  EEE6		;  CHK_STAT_2
F000:531F  72 33               JC    5354
F000:5321  B4 0F               MOV   AH, 0F
F000:5323  E8 5D 9B            CALL  EE83
-u
F000:5326  8A E2               MOV   AH, DL
F000:5328  E8 58 9B            CALL  EE83
F000:532B  8A E5               MOV   AH, CH
F000:532D  F6 06 11 00 20      TEST  BYTE [0011], 20
F000:5332  75 02               JNZ   5336
F000:5334  D0 E4               SHL   AH, 1
F000:5336  E8 4A 9B            CALL  EE83
F000:5339  E8 AA 9B            CALL  EEE6
F000:533C  9C                  PUSHF
F000:533D  BB 12 00            MOV   BX, 0012
F000:5340  E8 6C 9B            CALL  EEAF		; GET_PARM
F000:5343  51                  PUSH  CX
F000:5344  B9 26 02            MOV   CX, 0226
F000:5347  0A E4               OR    AH, AH
F000:5349  74 06               JZ    5351
F000:534B  E2 FE               LOOP  534B
-u
F000:534D  FE CC               DEC   AH
F000:534F  EB F3               JMPS  5344
F000:5351  59                  POP   CX
F000:5352  9D                  POPF
F000:5353  C3                  RETN
F000:5354  B4 07               MOV   AH, 07
F000:5356  E8 2A 9B            CALL  EE83
F000:5359  8A E2               MOV   AH, DL
F000:535B  E8 25 9B            CALL  EE83
F000:535E  E8 85 9B            CALL  EEE6
F000:5361  72 F0               JC    5353
F000:5363  EB BC               JMPS  5321

