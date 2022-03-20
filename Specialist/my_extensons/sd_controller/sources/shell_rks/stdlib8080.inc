  .org 04000h
end: 
  .db 0FFh, 0FFh

entry:
  .org 0
  .dw $+4
  .dw end
start:
  jmp main

chargen:
  .include "fon_spets.inc"



