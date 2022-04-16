; Просто функции

;-------------------------------------------------------------------------------

memcpy8back:
    ldax d
    mov m, a
    dcx d
    dcx h
    dcx b
    mov a, c
    ora b
    jnz memcpy8back
    ret

;-------------------------------------------------------------------------------

memcpy8:
    mov  a, m
    stax d
    inx  d
    inx  h
    dcr  c
    jnz  memcpy8
    ret

;-------------------------------------------------------------------------------

memset8:
    mov  m, a
    inx  h
    dcr  c
    jnz  memset8
    ret

;-------------------------------------------------------------------------------

delay8000:
    lxi  d, 08000h
delay:
    dcx  d
    mov  a, d
    ora  e
    jnz  delay
    ret

;-------------------------------------------------------------------------------
; 16 битное деление

div16:
    MOV  A,H
    ORA  L
    RZ
    LXI  B,0000
    PUSH B
div16_1:
    MOV  A,E
    SUB  L
    MOV  A,D
    SBB  H
    JC   div16_2
    PUSH H
    DAD  H
    JNC  div16_1
div16_2:
    LXI  H,0000
div16_3:
    POP  B
    MOV  A, B
    ORA  C
    RZ
    DAD  H
    PUSH D
    MOV  A, E
    SUB  C
    MOV  E, A
    MOV  A, D
    SBB  B
    MOV  D, A
    JC   div16_4
    INX  H
    POP  B
    JMP  div16_3
div16_4:
    POP  D
    JMP  div16_3

