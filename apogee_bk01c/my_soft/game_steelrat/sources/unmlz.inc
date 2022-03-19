// UNMLZ
// (c) b2m, lvd, mayhem...

unmlz:
    LD A,80h
UNLD:	LD (BITS), A
    LD   A, (DE)
    INC  DE
    JP UNSTA

UNST3:	LD A,(HL)
    INC HL
    LD (BC), A
    INC BC
UNST2:  LD A,(HL)
    INC HL
    LD (BC), A
    INC BC
UNST1:	LD A,(HL)
UNSTA:	LD (BC), A
    INC BC
ULOOP:	LD A, (BITS)
    ADD A
    JP NZ,  L1
    LD   A, (DE)
    INC  DE
    RLA
L1:	JP C,  UNLD
    ADD A
    JP NZ,  L3
    LD   A, (DE)
    INC  DE
    RLA ; RAL
L3:	JP C,  UN2
    ADD A
    JP NZ,  L2
    LD   A, (DE)
    INC  DE
    RLA
L2:	JP C,  UN1
    LD HL,3FFFh
    CALL GETBITS
    LD (BITS), A
    ADD HL, BC
    JP UNST1
UN1:    LD (BITS), A
    LD   A, (DE)
    INC  DE
    LD L,A
    LD H,0FFh
    ADD HL, BC
    JP UNST2
UN2:	ADD A
    JP NZ,  L4
    LD   A, (DE)
    INC  DE
    RLA
L4:	JP C,  UN3
    CALL GETBIGD
    ADD HL, BC
    JP UNST3
UN3:	LD H,0
UN3A:	INC H
    ADD A
    JP NZ,  L5
    LD   A, (DE)
    INC  DE
    RLA
L5:	JP NC,  UN3A
    PUSH AF
    LD A,H
    CP 8
    JP NC,  UNEXIT
    LD A,0
    RRA
    DEC H
    JP NZ,  $-2
    LD H,A
    LD L,1
    POP AF
    CALL GETBITS
    INC HL
    INC HL
    PUSH HL
    CALL GETBIGD
    EX DE, HL ; XCHG
    EX (SP), HL ; XTHL
    EX DE, HL ; XCHG
    ADD HL, BC
LDIR:	LD A, (HL)
    INC HL
    LD (BC), A
    INC BC
    DEC E
    JP NZ,  LDIR
    POP DE
    JP ULOOP
UNEXIT:	POP AF
    RET

GETBITS:ADD A
    JP NZ,  L7
    LD   A, (DE)
    INC  DE
    RLA ; RAL
L7:	JP C,  GETB1
    ADD HL, HL
    RET C
    JP GETBITS
GETB1:	ADD HL, HL
    INC L
    RET C
    JP GETBITS

GETBIGD:ADD A
    JP NZ,  L8
    LD   A, (DE)
    INC  DE
    RLA
L8:	JP C,  GETBD1
    LD (BITS), A
    LD   A, (DE)
    INC  DE
    LD L,A
    LD H,0FFh
    RET

GETBD1:	LD HL,1FFFh
    CALL GETBITS
    LD (BITS), A
    LD H,L
    DEC H
    LD  A, (DE)
    INC DE
    LD L,A
    RET

BITS DB 80h
