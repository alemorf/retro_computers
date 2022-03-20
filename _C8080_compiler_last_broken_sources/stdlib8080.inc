; Заголовок для RKA файла

  .org 0h

entry:
  .db 0, 4, 0, 0
  jmp main

;----------------------------------------------------------------------------
; Умножение A на D, результат в HL. BC портить нельзя

op_mul:
  push b
  lxi h, 0
  mov e, d  ; de=d
  mov d, l  
  mvi c, 8
op_mul1:
  dad h
  add a
  jnc op_mul2
    dad d
op_mul2:
  dcr c
  jnz op_mul1
pop_bc_ret:
  pop b
  ret

;----------------------------------------------------------------------------
; Умножение HL на DE, результат в HL. BC портить нельзя

op_mul16:
  push b
  mov b, h
  mov c, l
  lxi h, 0
  mvi a, 17
op_mul16_1:
  dcr a
  jz pop_bc_ret
  dad h
  xchg
  jnc op_mul16_2
  dad h
  inx h
  jmp op_mul16_3
op_mul16_2:
  dad h
op_mul16_3:
  xchg
  jnc op_mul16_1
  dad b
  jnc op_mul16_1
  inx d
  jmp op_mul16_1

;----------------------------------------------------------------------------
; Сдвиг HL на DE, результат в HL. BC портить нельзя

op_shr16:
  inr e
x:dcr e
  rz
  sub a
  ora h 
  rar
  mov h, a
  mov a, l
  rar
  mov l, a
  jp x

;----------------------------------------------------------------------------
; Сдвиг A на D, результат в A. BC портить нельзя

op_shl:
  inr d
op_shl_2:
  dcr d
  rz
  add a
  jmp op_shl_2

;----------------------------------------------------------------------------
; Сдвиг A на D, результат в A. HL, BC портить нельзя

op_shr:
  inr d
op_shr_2:
  dcr d
  rz
  cmp a
  rar
  jmp op_shr_2
