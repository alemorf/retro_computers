; Заголовок для RKA файла

  device zxspectrum48
  org 0h

entry:
  db 0, 4, 0, 0
  jp main

;----------------------------------------------------------------------------
; Умножение A на D, результат в HL. BC портить нельзя

op_mul:
  push bc
  ld hl, 0
  ld e, d  ; de=d
  ld d, l  
  ld c, 8
op_mul1:
  add hl, hl
  add a
  jp nc, op_mul2
    add hl, de
op_mul2:
  dec c
  jp nz, op_mul1
pop_bc_ret:
  pop bc
  ret

;----------------------------------------------------------------------------
; Умножение HL на DE, результат в HL. BC портить нельзя

op_mul16:
  push bc
  ld bc, hl
  ld hl, 0
  ld a, 17
op_mul16_1:
  dec a
  jp z, pop_bc_ret
  add hl, hl
  ex hl, de 
  jp nc, op_mul16_2
  add hl, hl
  inc hl
  jp op_mul16_3
op_mul16_2:
  add hl, hl
op_mul16_3:
  ex de, hl
  jp nc, op_mul16_1
  add hl, bc
  jp nc, op_mul16_1
  inc de
  jp op_mul16_1

;----------------------------------------------------------------------------
; Сдвиг HL на DE, результат в HL. BC портить нельзя

op_shr16:
  inc e
x:dec e
  ret z
  sub a
  or h 
  rra
  ld h, a
  ld a, l
  rra
  ld l, a
  jp x

;----------------------------------------------------------------------------
; Сдвиг A на D, результат в A. BC портить нельзя

op_shl:
  inc d
op_shl_2:
  dec d
  ret z
  add a
  jp op_shl_2

;----------------------------------------------------------------------------
; Сдвиг A на D, результат в A. HL, BC портить нельзя

op_shr:
  inc d
op_shr_2:
  dec d
  ret z
  cp a
  rra
  jp op_shr_2
