  .org 09000h
  .include "lvov_drawsprite.asm";
end: 
  .db "#"
  .org 100h-16-6
entry:
  .db "LVOV/2.0/"
  .db 0D0h
  .db "LINES"
  .org 100h-6
  .dw start
  .dw end
  .dw main
start: