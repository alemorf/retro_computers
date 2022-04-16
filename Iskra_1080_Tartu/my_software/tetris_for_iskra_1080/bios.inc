; Искра 1080 Тарту

; Все цвета
PALETTE_WHITE        = 0
PALETTE_CYAN         = 1
PALETTE_MAGENTA      = 2
PALETTE_BLUE         = 3
PALETTE_YELLOW       = 4
PALETTE_GREEN        = 5
PALETTE_RED          = 6
PALETTE_XXX          = 7
PALETTE_DARK_GRAY    = 8
PALETTE_DARK_CYAN    = 9
PALETTE_DARK_MAGENTA = 10
PALETTE_DARK_BLUE    = 11
PALETTE_DARK_YELLOW  = 12
PALETTE_DARK_GREEN   = 13
PALETTE_DARK_RED     = 14
PALETTE_BLACK        = 15

; Порты палитры
IO_PALETTE_0         = 90h
IO_PALETTE_1         = 91h
IO_PALETTE_2         = 92h
IO_PALETTE_3         = 93h

; Параметры видеопамяти
VIDEO_PAGE_0         = 0D000h
VIDEO_PAGE_1         = 09000h
VIDEO_WIDTH          = 384
VIDEO_HEIGHT         = 256

; Точки входа в BIOS
;setCursorY_F7DC      = 0F7DCh
;setCursorX_F7BE      = 0F7BEh
;printString_F137     = 0F137h
;waitKey_FDAC         = 0FDACh
;drawChar1_F7FB       = 0F7FBh
;drawChar2_F8B0       = 0F8B0h
;clearScreen1_F9A0    = 0F9A0h
inkey_FC12           = 0FC12h
;negativeText_F798    = 0F798h
;normalText_F793      = 0F793h
;videoMode_C802       = 0C802h
