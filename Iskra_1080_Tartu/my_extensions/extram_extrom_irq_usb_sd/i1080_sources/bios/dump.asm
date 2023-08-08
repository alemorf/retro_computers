0000          SCREEN_0_ADDRESS equ 53248
0000          SCREEN_1_ADDRESS equ 36864
0000          PALETTE_WHITE equ 0
0000          PALETTE_CYAN equ 1
0000          PALETTE_MAGENTA equ 2
0000          PALETTE_BLUE equ 3
0000          PALETTE_YELLOW equ 4
0000          PALETTE_GREEN equ 5
0000          PALETTE_RED equ 6
0000          PALETTE_XXX equ 7
0000          PALETTE_GRAY equ 8
0000          PALETTE_DARK_CYAN equ 9
0000          PALETTE_DARK_MAGENTA equ 10
0000          PALETTE_DARK_BLUE equ 11
0000          PALETTE_DARK_YELLOW equ 12
0000          PALETTE_DARK_GREEN equ 13
0000          PALETTE_DARK_RED equ 14
0000          PALETTE_BLACK equ 15
0000          KEY_BACKSPACE equ 8
0000          KEY_TAB equ 9
0000          KEY_ENTER equ 13
0000          KEY_ESC equ 27
0000          KEY_ALT equ 1
0000          KEY_F1 equ 242
0000          KEY_F2 equ 243
0000          KEY_F3 equ 244
0000          KEY_UP equ 245
0000          KEY_DOWN equ 246
0000          KEY_RIGHT equ 247
0000          KEY_LEFT equ 248
0000          KEY_EXT_5 equ 249
0000          KEY_END equ 250
0000          KEY_HOME equ 251
0000          KEY_INSERT equ 252
0000          KEY_DEL equ 253
0000          KEY_PG_UP equ 254
0000          KEY_PG_DN equ 255
0000          PORT_FRAME_IRQ_RESET equ 4
0000          PORT_SD_SIZE equ 9
0000          PORT_SD_RESULT equ 9
0000          PORT_SD_DATA equ 8
0000          PORT_UART_DATA equ 128
0000          PORT_UART_CONFIG equ 129
0000          PORT_UART_STATE equ 129
0000          PORT_EXT_DATA_OUT equ 136
0000          PORT_PALETTE_3 equ 144
0000          PORT_PALETTE_2 equ 145
0000          PORT_PALETTE_1 equ 146
0000          PORT_PALETTE_0 equ 147
0000          PORT_EXT_IN_DATA equ 137
0000          PORT_A0 equ 160
0000          PORT_ROM_0000 equ 168
0000          PORT_ROM_0000__ROM equ 0
0000          PORT_ROM_0000__RAM equ 128
0000          PORT_VIDEO_MODE_1_LOW equ 185
0000          PORT_VIDEO_MODE_1_HIGH equ 249
0000          PORT_VIDEO_MODE_0_LOW equ 184
0000          PORT_VIDEO_MODE_0_HIGH equ 248
0000          PORT_UART_SPEED_0 equ 187
0000          PORT_KEYBOARD equ 192
0000          PORT_UART_SPEED_1 equ 251
0000          PORT_CODE_ROM equ 186
0000          PORT_CHARGEN_ROM equ 250
0000          PORT_TAPE_AND_IDX2 equ 153
0000          PORT_TAPE_AND_IDX2_ID1_2 equ 2
0000          PORT_TAPE_AND_IDX2_ID2_2 equ 4
0000          PORT_TAPE_AND_IDX2_ID3_2 equ 8
0000          PORT_TAPE_AND_IDX2_ID6_2 equ 64
0000          PORT_TAPE_AND_IDX2_ID7_2 equ 128
0000          PORT_RESET_CU1 equ 188
0000          PORT_RESET_CU2 equ 189
0000          PORT_RESET_CU3 equ 190
0000          PORT_RESET_CU4 equ 191
0000          PORT_SET_CU1 equ 252
0000          PORT_SET_CU2 equ 253
0000          PORT_SET_CU3 equ 254
0000          PORT_SET_CU4 equ 255
0000          PORT_TAPE_OUT equ 176
0000          SD_COMMAND_READ equ 1
0000          SD_COMMAND_READ_SIZE equ 5
0000          SD_COMMAND_WRITE equ 2
0000          SD_COMMAND_WRITE_SIZE equ 5+128
0000          SD_RESULT_BUSY equ 255
0000          SD_RESULT_OK equ 0
0000          stack equ 256
0000          entry_cpm_conout_address equ EntryCpmConout+1
0000          cpm_dph_a equ 65376
0000          cpm_dph_b equ 65392
0000          cpm_dma_buffer equ 65408
0000          MOD_CTR equ 1
0000          MOD_SHIFT equ 2
0000          MOD_CAPS equ 16
0000          MOD_NUM equ 32
0000           org 0
Reboot:
0000 C3 8F 27  jp main
sector_count:
0003 95 00     dw (file_end+127)/128
CpmInterrupt:
0005 C3 C2 24  jp InterruptHandler
EntryCpmWBoot:
0008 C3 90 28  jp CpmWBoot
EntryCpmConst:
000B C3 51 08  jp CpmConst
EntryCpmConin:
000E C3 5D 08  jp CpmConin
EntryCpmConout:
0011 C3 9B 07  jp CpmConout
EntryCpmList:
0014 C3 CB 43  jp CpmList
EntryCpmPunch:
0017 C3 F0 44  jp CpmPunch
EntryCpmReader:
001A C3 F1 44  jp CpmReader
EntryCpmSelDsk:
001D C3 DD 43  jp CpmSelDsk
EntryCpmSetTrk:
0020 C3 1E 44  jp CpmSetTrk
EntryCpmSetSec:
0023 C3 24 44  jp CpmSetSec
EntryCpmRead:
0026 C3 5D 44  jp CpmRead
EntryCpmWrite:
0029 C3 79 44  jp CpmWrite
EntryCpmPrSta:
002C C3 CC 43  jp CpmPrSta
002F 00 00 00  org 56
EntryInterrupt:
0038 F5        push af
0039 C5        push bc
003A D5        push de
003B E5        push hl
003C CD C2 24  call InterruptHandler
003F E1        pop hl
0040 D1        pop de
0041 C1        pop bc
0042 F1        pop af
0043 FB        ei
0044 C9        ret
key_buffer:
0045 00 00 00  ds 16
0055 00 00 00  org 256
0100          SCREEN_0_ADDRESS equ 53248
0100          SCREEN_1_ADDRESS equ 36864
0100          PALETTE_WHITE equ 0
0100          PALETTE_CYAN equ 1
0100          PALETTE_MAGENTA equ 2
0100          PALETTE_BLUE equ 3
0100          PALETTE_YELLOW equ 4
0100          PALETTE_GREEN equ 5
0100          PALETTE_RED equ 6
0100          PALETTE_XXX equ 7
0100          PALETTE_GRAY equ 8
0100          PALETTE_DARK_CYAN equ 9
0100          PALETTE_DARK_MAGENTA equ 10
0100          PALETTE_DARK_BLUE equ 11
0100          PALETTE_DARK_YELLOW equ 12
0100          PALETTE_DARK_GREEN equ 13
0100          PALETTE_DARK_RED equ 14
0100          PALETTE_BLACK equ 15
0100          KEY_BACKSPACE equ 8
0100          KEY_TAB equ 9
0100          KEY_ENTER equ 13
0100          KEY_ESC equ 27
0100          KEY_ALT equ 1
0100          KEY_F1 equ 242
0100          KEY_F2 equ 243
0100          KEY_F3 equ 244
0100          KEY_UP equ 245
0100          KEY_DOWN equ 246
0100          KEY_RIGHT equ 247
0100          KEY_LEFT equ 248
0100          KEY_EXT_5 equ 249
0100          KEY_END equ 250
0100          KEY_HOME equ 251
0100          KEY_INSERT equ 252
0100          KEY_DEL equ 253
0100          KEY_PG_UP equ 254
0100          KEY_PG_DN equ 255
0100          PORT_FRAME_IRQ_RESET equ 4
0100          PORT_SD_SIZE equ 9
0100          PORT_SD_RESULT equ 9
0100          PORT_SD_DATA equ 8
0100          PORT_UART_DATA equ 128
0100          PORT_UART_CONFIG equ 129
0100          PORT_UART_STATE equ 129
0100          PORT_EXT_DATA_OUT equ 136
0100          PORT_PALETTE_3 equ 144
0100          PORT_PALETTE_2 equ 145
0100          PORT_PALETTE_1 equ 146
0100          PORT_PALETTE_0 equ 147
0100          PORT_EXT_IN_DATA equ 137
0100          PORT_A0 equ 160
0100          PORT_ROM_0000 equ 168
0100          PORT_ROM_0000__ROM equ 0
0100          PORT_ROM_0000__RAM equ 128
0100          PORT_VIDEO_MODE_1_LOW equ 185
0100          PORT_VIDEO_MODE_1_HIGH equ 249
0100          PORT_VIDEO_MODE_0_LOW equ 184
0100          PORT_VIDEO_MODE_0_HIGH equ 248
0100          PORT_UART_SPEED_0 equ 187
0100          PORT_KEYBOARD equ 192
0100          PORT_UART_SPEED_1 equ 251
0100          PORT_CODE_ROM equ 186
0100          PORT_CHARGEN_ROM equ 250
0100          PORT_TAPE_AND_IDX2 equ 153
0100          PORT_TAPE_AND_IDX2_ID1_2 equ 2
0100          PORT_TAPE_AND_IDX2_ID2_2 equ 4
0100          PORT_TAPE_AND_IDX2_ID3_2 equ 8
0100          PORT_TAPE_AND_IDX2_ID6_2 equ 64
0100          PORT_TAPE_AND_IDX2_ID7_2 equ 128
0100          PORT_RESET_CU1 equ 188
0100          PORT_RESET_CU2 equ 189
0100          PORT_RESET_CU3 equ 190
0100          PORT_RESET_CU4 equ 191
0100          PORT_SET_CU1 equ 252
0100          PORT_SET_CU2 equ 253
0100          PORT_SET_CU3 equ 254
0100          PORT_SET_CU4 equ 255
0100          PORT_TAPE_OUT equ 176
0100          SD_COMMAND_READ equ 1
0100          SD_COMMAND_READ_SIZE equ 5
0100          SD_COMMAND_WRITE equ 2
0100          SD_COMMAND_WRITE_SIZE equ 5+128
0100          SD_RESULT_BUSY equ 255
0100          SD_RESULT_OK equ 0
0100          stack equ 256
0100          entry_cpm_conout_address equ EntryCpmConout+1
0100          cpm_dph_a equ 65376
0100          cpm_dph_b equ 65392
0100          cpm_dma_buffer equ 65408
0100          TEXT_SCREEN_HEIGHT equ 25
0100          FONT_HEIGHT equ 10
0100          FONT_WIDTH equ 3
0100          DrawCharAddress equ DrawChar+1
0100          SetColorAddress equ SetColor+1
0100          DrawCursorAddress equ DrawCursor+1
0100          MOD_CTR equ 1
0100          MOD_SHIFT equ 2
0100          MOD_CAPS equ 16
0100          MOD_NUM equ 32
cursor_blink_counter:
0100 01        db 1
cursor_visible:
0101 00        db 0
cursor_visible_1:
0102 00        db 0
cursor_y:
0103 00        db 0
cursor_x:
0104 00        db 0
0105          cursor_y_l_x_h equ cursor_y
esc_param:
0105 00        ds 1
esc_param_2:
0106 00        ds 1
esc_param_ptr:
0107 00 00     ds 2
long_code:
0109 00 00     ds 2
010B          long_code_high equ long_code+1
console_xlat:
010B 00 00 00  ds 256
console_xlat_back:
020B 00 00 00  ds 256
con_attrib:
030B 00        db 0
con_foreground:
030C 00        db 0
con_background:
030D 00        db 0
con_color_0:
030E 00        ds 1
con_color_1:
030F 00        ds 1
con_color_2:
0310 00        ds 1
con_color_3:
0311 00        ds 1
Beep:
0312 F3        di
0313 0E 00     ld c, 0
_l40:
0315 D3 B0     out (PORT_TAPE_OUT), a
0317 3E 30     ld a, 48
_l43:
_l45:
0319 3D        dec a
031A C2 19 03  jp nz, _l43
_l44:
031D 0D        dec c
_l42:
031E 0D        dec c
031F C2 15 03  jp nz, _l40
_l41:
0322 FB        ei
0323 C9        ret
BeginConsoleChange:
0324 3E 01     ld a, 1
0326 D3 02     out (2), a
0328 D3 03     out (3), a
032A 21 01 01  ld hl, cursor_visible
032D F3        di
032E 7E        ld a, (hl)
032F 36 00     ld (hl), 0
0331 FB        ei
0332 FE 03     cp 3
0334 C2 3F 03  jp nz, _l47
0337 2A 03 01  ld hl, (cursor_y_l_x_h)
033A CD A3 08  call DrawCursor
033D 3E 01     ld a, 1
_l47:
033F 32 02 01  ld (cursor_visible_1), a
0342 C9        ret
EndConsoleChange:
0343 3E 02     ld a, 2
0345 32 00 01  ld (cursor_blink_counter), a
0348 3A 02 01  ld a, (cursor_visible_1)
034B 32 01 01  ld (cursor_visible), a
034E 3E 0C     ld a, 6*2
0350 D3 02     out (2), a
0352 3E 0E     ld a, 7*2
0354 D3 03     out (3), a
0356 C9        ret
ConReset:
0357 AF        xor a
0358 32 0B 03  ld (con_attrib), a
035B 3E 09     ld a, 9
035D 32 0C 03  ld (con_foreground), a
0360 32 0D 03  ld (con_background), a
0363 CD D1 03  call ConUpdateColor
ConClear:
0366 AF        xor a
0367 32 01 01  ld (cursor_visible), a
036A 32 04 01  ld (cursor_x), a
036D 32 03 01  ld (cursor_y), a
0370 C3 B0 08  jp ClearScreen
ConNextLine:
0373 AF        xor a
0374 32 04 01  ld (cursor_x), a
0377 3A 03 01  ld a, (cursor_y)
037A 3C        inc a
037B FE 19     cp TEXT_SCREEN_HEIGHT
037D D2 56 09  jp nc, ScrollUp
0380 32 03 01  ld (cursor_y), a
0383 C9        ret
ConPrintChar:
0384 C6 0B     add console_xlat
0386 6F        ld l, a
0387 CE 01     adc console_xlat>>8
0389 95        sub l
038A 67        ld h, a
038B 7E        ld a, (hl)
038C 2A 03 01  ld hl, (cursor_y_l_x_h)
038F CD 9D 08  call DrawChar
0392 2A 9C 08  ld hl, (text_screen_width)
0395 3A 04 01  ld a, (cursor_x)
0398 3C        inc a
0399 BD        cp l
039A D2 73 03  jp nc, ConNextLine
039D 32 04 01  ld (cursor_x), a
03A0 C9        ret
ConEraseInLine:
03A1 C9        ret
03A2 2A 03 01  ld hl, (cursor_y_l_x_h)
_l55:
03A5 E5        push hl
03A6 7C        ld a, h
03A7 E6 03     and 3
03A9 4F        ld c, a
03AA 7C        ld a, h
03AB 0F 0F     rrca
 rrca
03AD E6 3F     and 63
03AF 2F        cpl
03B0 67        ld h, a
03B1 EB        ex hl, de
03B2 AF        xor a
03B3 CD 9D 08  call DrawChar
03B6 E1        pop hl
03B7 7C        ld a, h
03B8 C6 03     add FONT_WIDTH
03BA 67        ld h, a
03BB C3 A5 03  jp _l55
_l54:
ConFindColor:
03BE 2A 0E 03  ld hl, (con_color_0)
03C1 06 00     ld b, 0
03C3 BD        cp l
03C4 C8        ret z
03C5 04        inc b
03C6 BC        cp h
03C7 C8        ret z
03C8 2A 10 03  ld hl, (con_color_2)
03CB 04        inc b
03CC BD        cp l
03CD C8        ret z
03CE 04        inc b
03CF BC        cp h
03D0 C9        ret
ConUpdateColor:
03D1 3A 0D 03  ld a, (con_background)
03D4 5F        ld e, a
03D5 FE 09     cp 9
03D7 C2 DF 03  jp nz, _l58
03DA 0E 00     ld c, 0
03DC C3 E8 03  jp _l59
_l58:
03DF CD BE 03  call ConFindColor
03E2 48        ld c, b
03E3 CA E8 03  jp z, _l60
03E6 0E 00     ld c, 0
_l59:
_l60:
03E8 3A 0C 03  ld a, (con_foreground)
03EB FE 09     cp 9
03ED C2 0A 04  jp nz, _l61
03F0 16 0A     ld d, 10
03F2 06 01     ld b, 1
03F4 3A 0B 03  ld a, (con_attrib)
03F7 0F        rrca
03F8 D2 00 04  jp nc, _l62
03FB 06 02     ld b, 2
03FD C3 07 04  jp _l63
_l62:
0400 E6 1F     and 31
0402 CA 07 04  jp z, _l64
0405 06 03     ld b, 3
_l63:
_l64:
0407 C3 1B 04  jp _l65
_l61:
040A 57        ld d, a
040B BB        cp e
040C C2 13 04  jp nz, _l66
040F 41        ld b, c
0410 C3 1B 04  jp _l67
_l66:
0413 CD BE 03  call ConFindColor
0416 CA 1B 04  jp z, _l68
0419 06 01     ld b, 1
_l67:
_l68:
_l65:
041B 78        ld a, b
041C B9        cp c
041D C2 2A 04  jp nz, _l69
0420 7A        ld a, d
0421 BB        cp e
0422 CA 2A 04  jp z, _l70
0425 78        ld a, b
0426 3C        inc a
0427 E6 03     and 3
0429 47        ld b, a
_l70:
_l69:
042A 3A 0B 03  ld a, (con_attrib)
042D 87        add a
042E D2 35 04  jp nc, _l71
0431 41        ld b, c
0432 C3 3C 04  jp _l72
_l71:
0435 87        add a
0436 D2 3C 04  jp nc, _l73
0439 79        ld a, c
043A 48        ld c, b
043B 47        ld b, a
_l72:
_l73:
043C 79        ld a, c
043D 87        add a
043E 87        add a
043F B0        or b
0440 C3 A0 08  jp SetColor
CpmConoutCsi2:
0443 79        ld a, c
0444 FE 30     cp 48
0446 DA 5D 04  jp c, _l75
0449 FE 3A     cp 57+1
044B D2 5D 04  jp nc, _l76
044E D6 30     sub 48
0450 4F        ld c, a
0451 2A 07 01  ld hl, (esc_param_ptr)
0454 7E        ld a, (hl)
0455 87        add a
0456 47        ld b, a
0457 87        add a
0458 87        add a
0459 80        add b
045A 81        add c
045B 77        ld (hl), a
045C C9        ret
_l75:
_l76:
045D FE 3B     cp 59
045F C2 69 04  jp nz, _l77
0462 21 06 01  ld hl, esc_param_2
0465 22 07 01  ld (esc_param_ptr), hl
0468 C9        ret
_l77:
0469 21 9B 07  ld hl, CpmConout
046C 22 12 00  ld (entry_cpm_conout_address), hl
046F FE 48     cp 72
0471 C2 8F 04  jp nz, _l78
0474 3A 05 01  ld a, (esc_param)
0477 FE 19     cp TEXT_SCREEN_HEIGHT
0479 DA 7D 04  jp c, _l79
047C AF        xor a
_l79:
047D 32 03 01  ld (cursor_y), a
0480 2A 9C 08  ld hl, (text_screen_width)
0483 3A 06 01  ld a, (esc_param_2)
0486 BD        cp l
0487 DA 8B 04  jp c, _l80
048A AF        xor a
_l80:
048B 32 04 01  ld (cursor_x), a
048E C9        ret
_l78:
048F FE 4A     cp 74
0491 C2 A0 04  jp nz, _l81
0494 3A 05 01  ld a, (esc_param)
0497 FE 02     cp 2
0499 C2 9F 04  jp nz, _l82
049C CD B0 08  call ClearScreen
_l82:
049F C9        ret
_l81:
04A0 FE 4B     cp 75
04A2 C2 B1 04  jp nz, _l83
04A5 3A 05 01  ld a, (esc_param)
04A8 B7        or a
04A9 C2 B0 04  jp nz, _l84
04AC CD A1 03  call ConEraseInLine
04AF C9        ret
_l84:
04B0 C9        ret
_l83:
04B1 FE 6D     cp 109
04B3 C2 01 05  jp nz, _l85
04B6 3A 05 01  ld a, (esc_param)
04B9 B7        or a
04BA C2 CB 04  jp nz, _l86
04BD 32 0B 03  ld (con_attrib), a
04C0 3E 09     ld a, 9
04C2 32 0C 03  ld (con_foreground), a
04C5 32 0D 03  ld (con_background), a
04C8 C3 D1 03  jp ConUpdateColor
_l86:
04CB FE 09     cp 9
04CD D2 E0 04  jp nc, _l87
04D0 47        ld b, a
04D1 3E 80     ld a, 128
_l88:
04D3 07        rlca
_l90:
04D4 05        dec b
04D5 C2 D3 04  jp nz, _l88
_l89:
04D8 21 0B 03  ld hl, con_attrib
04DB B6        or (hl)
04DC 77        ld (hl), a
04DD C3 D1 03  jp ConUpdateColor
_l87:
04E0 FE 26     cp 38
04E2 D2 F0 04  jp nc, _l91
04E5 FE 1E     cp 30
04E7 D8        ret c
04E8 D6 1E     sub 30
04EA 32 0C 03  ld (con_foreground), a
04ED C3 D1 03  jp ConUpdateColor
_l91:
04F0 FE 31     cp 49
04F2 D2 00 05  jp nc, _l92
04F5 FE 28     cp 40
04F7 D8        ret c
04F8 D6 28     sub 40
04FA 32 0D 03  ld (con_background), a
04FD C3 D1 03  jp ConUpdateColor
_l92:
0500 C9        ret
_l85:
0501 C9        ret
CpmConoutCsi:
0502 C5        push bc
0503 CD 24 03  call BeginConsoleChange
0506 C1        pop bc
0507 CD 43 04  call CpmConoutCsi2
050A CD 43 03  call EndConsoleChange
050D C9        ret
CpmConoutEscY1:
050E 79        ld a, c
050F D6 20     sub 32
0511 2A 9C 08  ld hl, (text_screen_width)
0514 BD        cp l
0515 DA 19 05  jp c, _l95
0518 AF        xor a
_l95:
0519 F5        push af
051A CD 24 03  call BeginConsoleChange
051D F1        pop af
051E 32 04 01  ld (cursor_x), a
0521 3A 05 01  ld a, (esc_param)
0524 32 03 01  ld (cursor_y), a
0527 CD 43 03  call EndConsoleChange
052A 21 9B 07  ld hl, CpmConout
052D 22 12 00  ld (entry_cpm_conout_address), hl
0530 C9        ret
CpmConoutEscY:
0531 79        ld a, c
0532 D6 20     sub 32
0534 FE 19     cp TEXT_SCREEN_HEIGHT
0536 DA 3A 05  jp c, _l97
0539 AF        xor a
_l97:
053A 32 05 01  ld (esc_param), a
053D 21 0E 05  ld hl, CpmConoutEscY1
0540 22 12 00  ld (entry_cpm_conout_address), hl
0543 C9        ret
CpmConoutEsc:
0544 21 9B 07  ld hl, CpmConout
0547 79        ld a, c
0548 FE 5B     cp 91
054A C2 60 05  jp nz, _l99
054D AF        xor a
054E 32 05 01  ld (esc_param), a
0551 32 06 01  ld (esc_param_2), a
0554 21 05 01  ld hl, esc_param
0557 22 07 01  ld (esc_param_ptr), hl
055A 21 02 05  ld hl, CpmConoutCsi
055D C3 9B 05  jp _l100
_l99:
0560 FE 4B     cp 75
0562 C2 6E 05  jp nz, _l101
0565 CD A1 03  call ConEraseInLine
0568 21 9B 07  ld hl, CpmConout
056B C3 9B 05  jp _l102
_l101:
056E FE 59     cp 89
0570 C2 79 05  jp nz, _l103
0573 21 31 05  ld hl, CpmConoutEscY
0576 C3 9B 05  jp _l104
_l103:
0579 FE 3D     cp 61
057B C2 84 05  jp nz, _l105
057E 21 31 05  ld hl, CpmConoutEscY
0581 C3 9B 05  jp _l106
_l105:
0584 FE 3B     cp 59
0586 C2 9B 05  jp nz, _l107
0589 CD 24 03  call BeginConsoleChange
058C CD B0 08  call ClearScreen
058F 21 00 00  ld hl, 0
0592 22 03 01  ld (cursor_y_l_x_h), hl
0595 CD 43 03  call EndConsoleChange
0598 21 9B 07  ld hl, CpmConout
_l104:
_l106:
_l107:
_l102:
_l100:
059B 22 12 00  ld (entry_cpm_conout_address), hl
059E C9        ret
console_xlat_koi7:
059F 60        db 96
05A0 9E        db 158
05A1 80        db 128
05A2 81        db 129
05A3 96        db 150
05A4 84        db 132
05A5 85        db 133
05A6 94        db 148
05A7 83        db 131
05A8 95        db 149
05A9 88        db 136
05AA 89        db 137
05AB 8A        db 138
05AC 8B        db 139
05AD 8C        db 140
05AE 8D        db 141
05AF 8E        db 142
05B0 8F        db 143
05B1 9F        db 159
05B2 90        db 144
05B3 91        db 145
05B4 92        db 146
05B5 93        db 147
05B6 86        db 134
05B7 82        db 130
05B8 9C        db 156
05B9 9B        db 155
05BA 87        db 135
05BB 98        db 152
05BC 9D        db 157
05BD 99        db 153
05BE 97        db 151
05BF 7F        db 127
05C0 00        db 0
05C1 01        db 1
05C2 02        db 2
05C3 03        db 3
05C4 04        db 4
05C5 05        db 5
05C6 06        db 6
05C7 07        db 7
05C8 08        db 8
05C9 09        db 9
05CA 0A        db 10
05CB 0B        db 11
05CC 0C        db 12
05CD 0D        db 13
05CE 0E        db 14
05CF 0F        db 15
05D0 10        db 16
05D1 11        db 17
05D2 12        db 18
05D3 13        db 19
05D4 14        db 20
05D5 15        db 21
05D6 16        db 22
05D7 17        db 23
05D8 18        db 24
05D9 19        db 25
05DA 1A        db 26
05DB 1B        db 27
05DC 1C        db 28
05DD 1D        db 29
05DE 1E        db 30
05DF 1F        db 31
05E0 20        db 32
05E1 21        db 33
05E2 22        db 34
05E3 23        db 35
05E4 FD        db 253
05E5 25        db 37
05E6 26        db 38
05E7 27        db 39
05E8 28        db 40
05E9 29        db 41
05EA 2A        db 42
05EB 2B        db 43
05EC 2C        db 44
05ED 2D        db 45
05EE 2E        db 46
05EF 2F        db 47
05F0 30        db 48
05F1 31        db 49
05F2 32        db 50
05F3 33        db 51
05F4 34        db 52
05F5 35        db 53
05F6 36        db 54
05F7 37        db 55
05F8 38        db 56
05F9 39        db 57
05FA 3A        db 58
05FB 3B        db 59
05FC 3C        db 60
05FD 3D        db 61
05FE 3E        db 62
05FF 3F        db 63
0600 40        db 64
0601 41        db 65
0602 42        db 66
0603 43        db 67
0604 44        db 68
0605 45        db 69
0606 46        db 70
0607 47        db 71
0608 48        db 72
0609 49        db 73
060A 4A        db 74
060B 4B        db 75
060C 4C        db 76
060D 4D        db 77
060E 4E        db 78
060F 4F        db 79
0610 50        db 80
0611 51        db 81
0612 52        db 82
0613 53        db 83
0614 54        db 84
0615 55        db 85
0616 56        db 86
0617 57        db 87
0618 58        db 88
0619 59        db 89
061A 5A        db 90
061B 5B        db 91
061C 5C        db 92
061D 5D        db 93
061E 5E        db 94
061F 5F        db 95
0620 9E        db 158
0621 80        db 128
0622 81        db 129
0623 96        db 150
0624 84        db 132
0625 85        db 133
0626 94        db 148
0627 83        db 131
0628 95        db 149
0629 88        db 136
062A 89        db 137
062B 8A        db 138
062C 8B        db 139
062D 8C        db 140
062E 8D        db 141
062F 8E        db 142
0630 8F        db 143
0631 9F        db 159
0632 90        db 144
0633 91        db 145
0634 92        db 146
0635 93        db 147
0636 86        db 134
0637 82        db 130
0638 9C        db 156
0639 9B        db 155
063A 87        db 135
063B 98        db 152
063C 9D        db 157
063D 99        db 153
063E 97        db 151
063F 7F        db 127
console_xlat_koi8:
0640 80        db 128
0641 C4        db 196
0642 B3        db 179
0643 DA        db 218
0644 BF        db 191
0645 C0        db 192
0646 D9        db 217
0647 C3        db 195
0648 B4        db 180
0649 C2        db 194
064A C1        db 193
064B C5        db 197
064C DF        db 223
064D DC        db 220
064E DB        db 219
064F DD        db 221
0650 DE        db 222
0651 B0        db 176
0652 B1        db 177
0653 B2        db 178
0654 F4        db 244
0655 FE        db 254
0656 F9        db 249
0657 FB        db 251
0658 F7        db 247
0659 F3        db 243
065A F2        db 242
065B FF        db 255
065C F5        db 245
065D F8        db 248
065E FD        db 253
065F FA        db 250
0660 F6        db 246
0661 CD        db 205
0662 BA        db 186
0663 D5        db 213
0664 F1        db 241
0665 D6        db 214
0666 C9        db 201
0667 B8        db 184
0668 B7        db 183
0669 BB        db 187
066A D4        db 212
066B D3        db 211
066C C8        db 200
066D BE        db 190
066E BD        db 189
066F BC        db 188
0670 C6        db 198
0671 C7        db 199
0672 CC        db 204
0673 B5        db 181
0674 F0        db 240
0675 B6        db 182
0676 B9        db 185
0677 D1        db 209
0678 D2        db 210
0679 CB        db 203
067A CF        db 207
067B D0        db 208
067C CA        db 202
067D D8        db 216
067E D7        db 215
067F CE        db 206
0680 FC        db 252
0681 EE        db 238
0682 A0        db 160
0683 A1        db 161
0684 E6        db 230
0685 A4        db 164
0686 A5        db 165
0687 E4        db 228
0688 A3        db 163
0689 E5        db 229
068A A8        db 168
068B A9        db 169
068C AA        db 170
068D AB        db 171
068E AC        db 172
068F AD        db 173
0690 AE        db 174
0691 AF        db 175
0692 EF        db 239
0693 E0        db 224
0694 E1        db 225
0695 E2        db 226
0696 E3        db 227
0697 A6        db 166
0698 A2        db 162
0699 EC        db 236
069A EB        db 235
069B A7        db 167
069C E8        db 232
069D ED        db 237
069E E9        db 233
069F E7        db 231
06A0 EA        db 234
06A1 9E        db 158
06A2 80        db 128
06A3 81        db 129
06A4 96        db 150
06A5 84        db 132
06A6 85        db 133
06A7 94        db 148
06A8 83        db 131
06A9 95        db 149
06AA 88        db 136
06AB 89        db 137
06AC 8A        db 138
06AD 8B        db 139
06AE 8C        db 140
06AF 8D        db 141
06B0 8E        db 142
06B1 8F        db 143
06B2 9F        db 159
06B3 90        db 144
06B4 91        db 145
06B5 92        db 146
06B6 93        db 147
06B7 86        db 134
06B8 82        db 130
06B9 9C        db 156
06BA 9B        db 155
06BB 87        db 135
06BC 98        db 152
06BD 9D        db 157
06BE 99        db 153
06BF 97        db 151
06C0 9A        db 154
console_xlat_1251:
06C1 80        db 128
06C2 B0        db 176
06C3 B1        db 177
06C4 B2        db 178
06C5 B3        db 179
06C6 B4        db 180
06C7 B5        db 181
06C8 B6        db 182
06C9 B7        db 183
06CA B8        db 184
06CB B9        db 185
06CC BA        db 186
06CD BB        db 187
06CE BC        db 188
06CF BD        db 189
06D0 BE        db 190
06D1 BF        db 191
06D2 C0        db 192
06D3 C1        db 193
06D4 C2        db 194
06D5 C3        db 195
06D6 C4        db 196
06D7 C5        db 197
06D8 C6        db 198
06D9 C7        db 199
06DA C8        db 200
06DB C9        db 201
06DC CA        db 202
06DD CB        db 203
06DE CC        db 204
06DF CD        db 205
06E0 CE        db 206
06E1 CF        db 207
06E2 D0        db 208
06E3 D1        db 209
06E4 D2        db 210
06E5 D3        db 211
06E6 D4        db 212
06E7 D5        db 213
06E8 D6        db 214
06E9 D7        db 215
06EA D8        db 216
06EB D9        db 217
06EC DA        db 218
06ED DB        db 219
06EE DC        db 220
06EF DD        db 221
06F0 DE        db 222
06F1 DF        db 223
06F2 F0        db 240
06F3 F1        db 241
06F4 F2        db 242
06F5 F3        db 243
06F6 F4        db 244
06F7 F5        db 245
06F8 F6        db 246
06F9 F7        db 247
06FA F8        db 248
06FB F9        db 249
06FC FA        db 250
06FD FB        db 251
06FE FC        db 252
06FF FD        db 253
0700 FE        db 254
0701 FF        db 255
0702 80        db 128
0703 81        db 129
0704 82        db 130
0705 83        db 131
0706 84        db 132
0707 85        db 133
0708 86        db 134
0709 87        db 135
070A 88        db 136
070B 89        db 137
070C 8A        db 138
070D 8B        db 139
070E 8C        db 140
070F 8D        db 141
0710 8E        db 142
0711 8F        db 143
0712 90        db 144
0713 91        db 145
0714 92        db 146
0715 93        db 147
0716 94        db 148
0717 95        db 149
0718 96        db 150
0719 97        db 151
071A 98        db 152
071B 99        db 153
071C 9A        db 154
071D 9B        db 155
071E 9C        db 156
071F 9D        db 157
0720 9E        db 158
0721 9F        db 159
0722 A0        db 160
0723 A1        db 161
0724 A2        db 162
0725 A3        db 163
0726 A4        db 164
0727 A5        db 165
0728 A6        db 166
0729 A7        db 167
072A A8        db 168
072B A9        db 169
072C AA        db 170
072D AB        db 171
072E AC        db 172
072F AD        db 173
0730 AE        db 174
0731 AF        db 175
0732 E0        db 224
0733 E1        db 225
0734 E2        db 226
0735 E3        db 227
0736 E4        db 228
0737 E5        db 229
0738 E6        db 230
0739 E7        db 231
073A E8        db 232
073B E9        db 233
073C EA        db 234
073D EB        db 235
073E EC        db 236
073F ED        db 237
0740 EE        db 238
0741 EF        db 239
codepages:
0742 9F 05     dw console_xlat_koi7
0744 40 06     dw console_xlat_koi8
0746 C1 06     dw console_xlat_1251
ConSetXlat:
0748 F5        push af
0749 11 0B 01  ld de, console_xlat
074C 21 0B 02  ld hl, console_xlat_back
074F AF        xor a
0750 06 3F     ld b, 63
_l113:
0752 70        ld (hl), b
0753 12        ld (de), a
0754 23        inc hl
0755 13        inc de
_l115:
0756 3C        inc a
0757 C2 52 07  jp nz, _l113
_l114:
075A F1        pop af
075B B7        or a
075C CA 87 07  jp z, _l116
075F 3D        dec a
0760 C2 69 07  jp nz, _l117
0763 11 C1 06  ld de, console_xlat_1251
0766 C3 76 07  jp _l118
_l117:
0769 3D        dec a
076A C2 73 07  jp nz, _l119
076D 11 9F 05  ld de, console_xlat_koi7
0770 C3 76 07  jp _l120
_l119:
0773 11 40 06  ld de, console_xlat_koi8
_l120:
_l118:
0776 1A        ld a, (de)
0777 4F        ld c, a
0778 C6 0B     add console_xlat
077A 6F        ld l, a
077B CE 01     adc console_xlat>>8
077D 95        sub l
077E 67        ld h, a
_l121:
077F 13        inc de
0780 1A        ld a, (de)
0781 77        ld (hl), a
0782 23        inc hl
_l123:
0783 0C        inc c
0784 C2 7F 07  jp nz, _l121
_l116:
_l122:
0787 11 0A 02  ld de, console_xlat+255
078A 0E FF     ld c, 255
_l124:
078C 1A        ld a, (de)
078D C6 0B     add console_xlat_back
078F 6F        ld l, a
0790 CE 02     adc console_xlat_back>>8
0792 95        sub l
0793 67        ld h, a
0794 71        ld (hl), c
0795 1B        dec de
_l126:
0796 0D        dec c
0797 C2 8C 07  jp nz, _l124
_l125:
079A C9        ret
CpmConout:
079B 79        ld a, c
079C FE 1B     cp KEY_ESC
079E C2 A8 07  jp nz, _l128
07A1 21 44 05  ld hl, CpmConoutEsc
07A4 22 12 00  ld (entry_cpm_conout_address), hl
07A7 C9        ret
_l128:
07A8 FE 07     cp 7
07AA CA 12 03  jp z, Beep
07AD FE 0A     cp 10
07AF C8        ret z
07B0 F5        push af
07B1 CD 24 03  call BeginConsoleChange
07B4 F1        pop af
07B5 FE 1C     cp 28
07B7 DA C0 07  jp c, _l129
07BA CD 84 03  call ConPrintChar
07BD C3 43 03  jp EndConsoleChange
_l129:
07C0 FE 08     cp 8
07C2 C2 E6 07  jp nz, _l130
07C5 3A 04 01  ld a, (cursor_x)
07C8 3D        dec a
07C9 FA D2 07  jp m, _l131
07CC 32 04 01  ld (cursor_x), a
07CF C3 43 03  jp EndConsoleChange
_l131:
07D2 3A 03 01  ld a, (cursor_y)
07D5 3D        dec a
07D6 FA 43 03  jp m, EndConsoleChange
07D9 32 03 01  ld (cursor_y), a
07DC 3A 9C 08  ld a, (text_screen_width)
07DF 3D        dec a
07E0 32 04 01  ld (cursor_x), a
07E3 C3 43 03  jp EndConsoleChange
_l130:
07E6 FE 0C     cp 12
07E8 C2 F7 07  jp nz, _l132
07EB CD B0 08  call ClearScreen
07EE 21 00 00  ld hl, 0
07F1 22 03 01  ld (cursor_y_l_x_h), hl
07F4 C3 43 03  jp EndConsoleChange
_l132:
07F7 FE 1A     cp 26
07F9 C2 08 08  jp nz, _l133
07FC CD B0 08  call ClearScreen
07FF 21 00 00  ld hl, 0
0802 22 03 01  ld (cursor_y_l_x_h), hl
0805 C3 43 03  jp EndConsoleChange
_l133:
0808 FE 0D     cp 13
080A C2 13 08  jp nz, _l134
080D CD 73 03  call ConNextLine
0810 C3 43 03  jp EndConsoleChange
_l134:
0813 CD 84 03  call ConPrintChar
0816 C3 43 03  jp EndConsoleChange
con_special_keys:
0819 5B        db 91
081A 4F        db 79
081B 50        db 80
081C 00        db 0
081D 5B        db 91
081E 4F        db 79
081F 51        db 81
0820 00        db 0
0821 5B        db 91
0822 4F        db 79
0823 52        db 82
0824 00        db 0
0825 5B        db 91
0826 41        db 65
0827 00        db 0
0828 00        db 0
0829 5B        db 91
082A 42        db 66
082B 00        db 0
082C 00        db 0
082D 5B        db 91
082E 43        db 67
082F 00        db 0
0830 00        db 0
0831 5B        db 91
0832 44        db 68
0833 00        db 0
0834 00        db 0
0835 5B        db 91
0836 45        db 69
0837 00        db 0
0838 00        db 0
0839 5B        db 91
083A 46        db 70
083B 00        db 0
083C 00        db 0
083D 5B        db 91
083E 48        db 72
083F 00        db 0
0840 00        db 0
0841 5B        db 91
0842 32        db 50
0843 7E        db 126
0844 00        db 0
0845 5B        db 91
0846 33        db 51
0847 7E        db 126
0848 00        db 0
0849 5B        db 91
084A 35        db 53
084B 7E        db 126
084C 00        db 0
084D 5B        db 91
084E 36        db 54
084F 7E        db 126
0850 00        db 0
CpmConst:
0851 3A 0A 01  ld a, (long_code_high)
0854 B7        or a
0855 CC C8 23  call z, CheckKeyboard
0858 16 00     ld d, 0
085A C8        ret z
085B 15        dec d
085C C9        ret
CpmConin:
085D 3A 0A 01  ld a, (long_code_high)
0860 B7        or a
0861 CA 78 08  jp z, _l138
0864 2A 09 01  ld hl, (long_code)
0867 56        ld d, (hl)
0868 23        inc hl
0869 7E        ld a, (hl)
086A B7        or a
086B C2 71 08  jp nz, _l139
086E 21 00 00  ld hl, 0
_l139:
0871 22 09 01  ld (long_code), hl
0874 7A        ld a, d
0875 C3 93 08  jp _l140
_l138:
_l141:
0878 CD CE 23  call ReadKeyboard
_l143:
087B CA 78 08  jp z, _l141
_l142:
087E FE F2     cp KEY_F1
0880 DA 93 08  jp c, _l144
0883 D6 F2     sub KEY_F1
0885 87        add a
0886 87        add a
0887 C6 19     add con_special_keys
0889 6F        ld l, a
088A CE 08     adc con_special_keys>>8
088C 95        sub l
088D 67        ld h, a
088E 22 09 01  ld (long_code), hl
0891 3E 1B     ld a, KEY_ESC
_l140:
_l144:
0893 C6 0B     add console_xlat_back
0895 6F        ld l, a
0896 CE 02     adc console_xlat_back>>8
0898 95        sub l
0899 67        ld h, a
089A 56        ld d, (hl)
089B C9        ret
089C          SCREEN_0_ADDRESS equ 53248
089C          SCREEN_1_ADDRESS equ 36864
089C          PALETTE_WHITE equ 0
089C          PALETTE_CYAN equ 1
089C          PALETTE_MAGENTA equ 2
089C          PALETTE_BLUE equ 3
089C          PALETTE_YELLOW equ 4
089C          PALETTE_GREEN equ 5
089C          PALETTE_RED equ 6
089C          PALETTE_XXX equ 7
089C          PALETTE_GRAY equ 8
089C          PALETTE_DARK_CYAN equ 9
089C          PALETTE_DARK_MAGENTA equ 10
089C          PALETTE_DARK_BLUE equ 11
089C          PALETTE_DARK_YELLOW equ 12
089C          PALETTE_DARK_GREEN equ 13
089C          PALETTE_DARK_RED equ 14
089C          PALETTE_BLACK equ 15
089C          KEY_BACKSPACE equ 8
089C          KEY_TAB equ 9
089C          KEY_ENTER equ 13
089C          KEY_ESC equ 27
089C          KEY_ALT equ 1
089C          KEY_F1 equ 242
089C          KEY_F2 equ 243
089C          KEY_F3 equ 244
089C          KEY_UP equ 245
089C          KEY_DOWN equ 246
089C          KEY_RIGHT equ 247
089C          KEY_LEFT equ 248
089C          KEY_EXT_5 equ 249
089C          KEY_END equ 250
089C          KEY_HOME equ 251
089C          KEY_INSERT equ 252
089C          KEY_DEL equ 253
089C          KEY_PG_UP equ 254
089C          KEY_PG_DN equ 255
089C          PORT_FRAME_IRQ_RESET equ 4
089C          PORT_SD_SIZE equ 9
089C          PORT_SD_RESULT equ 9
089C          PORT_SD_DATA equ 8
089C          PORT_UART_DATA equ 128
089C          PORT_UART_CONFIG equ 129
089C          PORT_UART_STATE equ 129
089C          PORT_EXT_DATA_OUT equ 136
089C          PORT_PALETTE_3 equ 144
089C          PORT_PALETTE_2 equ 145
089C          PORT_PALETTE_1 equ 146
089C          PORT_PALETTE_0 equ 147
089C          PORT_EXT_IN_DATA equ 137
089C          PORT_A0 equ 160
089C          PORT_ROM_0000 equ 168
089C          PORT_ROM_0000__ROM equ 0
089C          PORT_ROM_0000__RAM equ 128
089C          PORT_VIDEO_MODE_1_LOW equ 185
089C          PORT_VIDEO_MODE_1_HIGH equ 249
089C          PORT_VIDEO_MODE_0_LOW equ 184
089C          PORT_VIDEO_MODE_0_HIGH equ 248
089C          PORT_UART_SPEED_0 equ 187
089C          PORT_KEYBOARD equ 192
089C          PORT_UART_SPEED_1 equ 251
089C          PORT_CODE_ROM equ 186
089C          PORT_CHARGEN_ROM equ 250
089C          PORT_TAPE_AND_IDX2 equ 153
089C          PORT_TAPE_AND_IDX2_ID1_2 equ 2
089C          PORT_TAPE_AND_IDX2_ID2_2 equ 4
089C          PORT_TAPE_AND_IDX2_ID3_2 equ 8
089C          PORT_TAPE_AND_IDX2_ID6_2 equ 64
089C          PORT_TAPE_AND_IDX2_ID7_2 equ 128
089C          PORT_RESET_CU1 equ 188
089C          PORT_RESET_CU2 equ 189
089C          PORT_RESET_CU3 equ 190
089C          PORT_RESET_CU4 equ 191
089C          PORT_SET_CU1 equ 252
089C          PORT_SET_CU2 equ 253
089C          PORT_SET_CU3 equ 254
089C          PORT_SET_CU4 equ 255
089C          PORT_TAPE_OUT equ 176
089C          SD_COMMAND_READ equ 1
089C          SD_COMMAND_READ_SIZE equ 5
089C          SD_COMMAND_WRITE equ 2
089C          SD_COMMAND_WRITE_SIZE equ 5+128
089C          SD_RESULT_BUSY equ 255
089C          SD_RESULT_OK equ 0
089C          TEXT_SCREEN_HEIGHT equ 25
089C          FONT_HEIGHT equ 10
089C          FONT_WIDTH equ 3
089C          DrawCharAddress equ DrawChar+1
089C          SetColorAddress equ SetColor+1
089C          DrawCursorAddress equ DrawCursor+1
089C          OPCODE_NOP equ 0
089C          OPCODE_LD_DE_CONST equ 17
089C          OPCODE_LD_A_CONST equ 62
089C          OPCODE_LD_H_A equ 103
089C          OPCODE_LD_A_D equ 122
089C          OPCODE_LD_A_H equ 124
089C          OPCODE_XOR_A equ 175
089C          OPCODE_XOR_B equ 168
089C          OPCODE_JP equ 195
089C          OPCODE_RET equ 201
089C          OPCODE_SUB_CONST equ 214
089C          OPCODE_AND_CONST equ 230
089C          OPCODE_OR_CONST equ 246
089C          OPCODE_OUT equ 211
089C          OPCODE_JMP equ 195
text_screen_width:
089C 60        db 96
089D          ClearScreen_2 equ ClearScreen_1+1
089D          ClearScreen_3 equ ClearScreen_1+2
089D          ClearScreen_4 equ ClearScreenPoly3+1
089D          ClearScreenSp equ ClearScreenSetSp+1
089D          ScrollUpAddr equ ScrollUp+1
089D          ScrollUpSp equ ScrollUpSpInstr+1
089D          ScrollUpSp2 equ ScrollUpSpInstr2+1
089D          ScrollUpBwSp equ ScrollUpBwSpInstr+1
089D          ScrollUp_1 equ ScrollUpSub+1
089D          ScrollUp_2 equ ScrollUp_2
089D          ScrollUp_3 equ ScrollUp_2+1
089D          ScrollUpSpInstr2 equ ScrollUpSpInstr2
DrawChar:
089D C3 BD 09  jp DrawChar6
SetColor:
08A0 C3 B9 0A  jp SetColor6
DrawCursor:
08A3 C3 8E 0B  jp DrawCursor6
SetColorSave:
08A6 C5        push bc
08A7 D5        push de
08A8 E5        push hl
08A9 CD A0 08  call SetColor
08AC E1        pop hl
08AD D1        pop de
08AE C1        pop bc
08AF C9        ret
ClearScreen:
08B0 21 00 00  ld hl, 0
08B3 39        add hl, sp
08B4 22 E3 08  ld (ClearScreenSp), hl
08B7 11 00 00  ld de, 0
08BA 0E 30     ld c, 48
08BC 21 00 00  ld hl, 0
_l157:
08BF 06 10     ld b, 16
08C1 F3        di
08C2 F9        ld sp, hl
_l160:
08C3 D5        push de
08C4 D5        push de
08C5 D5        push de
08C6 D5        push de
08C7 D5        push de
08C8 D5        push de
08C9 D5        push de
08CA D5        push de
_l162:
08CB 05        dec b
08CC C2 C3 08  jp nz, _l160
_l161:
08CF 7C        ld a, h
ClearScreen_1:
08D0 D6 40     sub 64
08D2 67        ld h, a
08D3 06 10     ld b, 16
08D5 F9        ld sp, hl
_l163:
08D6 D5        push de
08D7 D5        push de
08D8 D5        push de
08D9 D5        push de
08DA D5        push de
08DB D5        push de
08DC D5        push de
08DD D5        push de
_l165:
08DE 05        dec b
08DF C2 D6 08  jp nz, _l163
_l164:
ClearScreenSetSp:
08E2 31 00 00  ld sp, 0
08E5 FB        ei
ClearScreenPoly3:
08E6 C6 3F     add 63
08E8 67        ld h, a
_l159:
08E9 0D        dec c
08EA C2 BF 08  jp nz, _l157
_l158:
08ED C9        ret
08EE          SCROLL_COLUMN_UP equ 256
08EE          BITPLANE_OFFSET equ 16384
08EE          SCREEN_SIZE equ 12288
_l167:
ScrollUpSubBw:
08EE F9        ld sp, hl
08EF 19        add hl, de
08F0 46        ld b, (hl)
08F1 2D        dec l
08F2 4E        ld c, (hl)
08F3 2D        dec l
08F4 C5        push bc
08F5 46        ld b, (hl)
08F6 2D        dec l
08F7 4E        ld c, (hl)
08F8 2D        dec l
08F9 C5        push bc
08FA 46        ld b, (hl)
08FB 2D        dec l
08FC 4E        ld c, (hl)
08FD 2D        dec l
08FE C5        push bc
08FF 46        ld b, (hl)
0900 2D        dec l
0901 4E        ld c, (hl)
0902 2D        dec l
0903 C5        push bc
0904 46        ld b, (hl)
0905 2D        dec l
0906 4E        ld c, (hl)
0907 C5        push bc
0908 21 0A 01  ld hl, FONT_HEIGHT+256
090B 39        add hl, sp
_l169:
090C 3D        dec a
090D C2 EE 08  jp nz, _l167
_l168:
0910 C3 6C 09  jp ScrollUpSpInstr
ScrollUpSubColor:
_l171:
0913 F9        ld sp, hl
0914 19        add hl, de
0915 46        ld b, (hl)
0916 2D        dec l
0917 4E        ld c, (hl)
0918 2D        dec l
0919 C5        push bc
091A 46        ld b, (hl)
091B 2D        dec l
091C 4E        ld c, (hl)
091D 2D        dec l
091E C5        push bc
091F 46        ld b, (hl)
0920 2D        dec l
0921 4E        ld c, (hl)
0922 2D        dec l
0923 C5        push bc
0924 46        ld b, (hl)
0925 2D        dec l
0926 4E        ld c, (hl)
0927 2D        dec l
0928 C5        push bc
0929 46        ld b, (hl)
092A 2D        dec l
092B 4E        ld c, (hl)
092C C5        push bc
092D 21 0A C0  ld hl, FONT_HEIGHT-BITPLANE_OFFSET
0930 39        add hl, sp
0931 F9        ld sp, hl
0932 19        add hl, de
0933 46        ld b, (hl)
0934 2D        dec l
0935 4E        ld c, (hl)
0936 2D        dec l
0937 C5        push bc
0938 46        ld b, (hl)
0939 2D        dec l
093A 4E        ld c, (hl)
093B 2D        dec l
093C C5        push bc
093D 46        ld b, (hl)
093E 2D        dec l
093F 4E        ld c, (hl)
0940 2D        dec l
0941 C5        push bc
0942 46        ld b, (hl)
0943 2D        dec l
0944 4E        ld c, (hl)
0945 2D        dec l
0946 C5        push bc
0947 46        ld b, (hl)
0948 2D        dec l
0949 4E        ld c, (hl)
094A C5        push bc
094B 21 0A 41  ld hl, (FONT_HEIGHT+BITPLANE_OFFSET)+256
094E 39        add hl, sp
_l173:
094F 3D        dec a
0950 C2 13 09  jp nz, _l171
_l172:
0953 C3 6C 09  jp ScrollUpSpInstr
ScrollUp:
0956 21 00 00  ld hl, 0
0959 39        add hl, sp
095A 22 6D 09  ld (ScrollUpSp), hl
095D 22 A9 09  ld (ScrollUpSp2), hl
0960 11 F5 FF  ld de, -FONT_HEIGHT-1
0963 21 00 D1  ld hl, 53504
_l174:
0966 F3        di
0967 3E 30     ld a, 48
ScrollUpSub:
0969 C3 EE 08  jp ScrollUpSubBw
ScrollUpSpInstr:
096C 31 00 00  ld sp, 0
096F FB        ei
0970 7D        ld a, l
0971 D6 0A     sub FONT_HEIGHT
0973 6F        ld l, a
0974 26 D0     ld h, 208
_l176:
0976 FE 11     cp FONT_HEIGHT+7
0978 D2 66 09  jp nc, _l174
_l175:
097B 3E 30     ld a, 48
097D 11 00 00  ld de, 0
0980 F3        di
0981 31 10 FF  ld sp, (SCREEN_0_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l177:
0984 D5        push de
0985 D5        push de
0986 D5        push de
0987 D5        push de
0988 D5        push de
0989 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
098C 39        add hl, sp
098D F9        ld sp, hl
_l179:
098E 3D        dec a
098F C2 84 09  jp nz, _l177
_l178:
ScrollUp_2:
0992 3E 30     ld a, 48
0994 11 00 00  ld de, 0
0997 31 10 BF  ld sp, (SCREEN_1_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l180:
099A D5        push de
099B D5        push de
099C D5        push de
099D D5        push de
099E D5        push de
099F 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
09A2 39        add hl, sp
09A3 F9        ld sp, hl
_l182:
09A4 3D        dec a
09A5 C2 9A 09  jp nz, _l180
ScrollUpSpInstr2:
_l181:
09A8 31 00 00  ld sp, 0
09AB FB        ei
09AC C9        ret
DrawText:
_l185:
09AD 7E        ld a, (hl)
09AE 23        inc hl
09AF B7        or a
09B0 C8        ret z
09B1 E5        push hl
09B2 D5        push de
09B3 EB        ex hl, de
09B4 CD 9D 08  call DrawChar
09B7 D1        pop de
09B8 E1        pop hl
09B9 14        inc d
09BA C3 AD 09  jp _l185
_l184:
DrawChar6:
09BD 47        ld b, a
09BE 7D        ld a, l
09BF 87        add a
09C0 87        add a
09C1 85        add l
09C2 87        add a
09C3 2F        cpl
09C4 5F        ld e, a
09C5 7C        ld a, h
09C6 87        add a
09C7 84        add h
09C8 4F        ld c, a
09C9 1F        rra
09CA 1F        rra
09CB E6 3F     and 63
09CD 2F        cpl
09CE 57        ld d, a
09CF 78        ld a, b
09D0 C6 5B     add font
09D2 6F        ld l, a
09D3 CE 0C     adc font>>8
09D5 95        sub l
09D6 67        ld h, a
09D7 79        ld a, c
09D8 E6 03     and 3
09DA CA 2C 0A  jp z, DrawChar60
09DD 3D        dec a
09DE CA 53 0A  jp z, DrawChar62
09E1 3D        dec a
09E2 CA 74 0A  jp z, DrawChar64
DrawChar66:
09E5 0E 0A     ld c, FONT_HEIGHT
_l188:
09E7 7E        ld a, (hl)
09E8 0F 0F 0F  rrca
 rrca
 rrca
 rrca
09EC F5        push af
09ED E6 03     and 3
09EF 47        ld b, a
09F0 1A        ld a, (de)
DrawChar_And3:
09F1 E6 FC     and 252
DrawChar_Xor3:
09F3 A8        xor b
09F4 12        ld (de), a
09F5 F1        pop af
09F6 15        dec d
09F7 E6 F0     and 240
09F9 47        ld b, a
09FA 1A        ld a, (de)
DrawChar_And5:
09FB E6 0F     and 15
DrawChar_Xor4:
09FD A8        xor b
09FE 12        ld (de), a
09FF 14        inc d
0A00 24        inc h
0A01 1D        dec e
_l190:
0A02 0D        dec c
0A03 C2 E7 09  jp nz, _l188
_l189:
DrawChar_2:
0A06 7A        ld a, d
0A07 D6 40     sub 64
0A09 57        ld d, a
0A0A 0E 0A     ld c, FONT_HEIGHT
_l196:
0A0C 1C        inc e
0A0D 25        dec h
0A0E 7E        ld a, (hl)
0A0F 0F 0F 0F  rrca
 rrca
 rrca
 rrca
0A13 F5        push af
0A14 E6 03     and 3
0A16 47        ld b, a
0A17 1A        ld a, (de)
DrawChar_And4:
0A18 E6 FC     and 252
DrawChar_Xor5:
0A1A A8        xor b
0A1B 12        ld (de), a
0A1C F1        pop af
0A1D 15        dec d
0A1E E6 F0     and 240
0A20 47        ld b, a
0A21 1A        ld a, (de)
DrawChar_And6:
0A22 E6 0F     and 15
DrawChar_Xor6:
0A24 A8        xor b
0A25 12        ld (de), a
0A26 14        inc d
_l198:
0A27 0D        dec c
0A28 C2 0C 0A  jp nz, _l196
_l197:
0A2B C9        ret
DrawChar60:
0A2C 0E 0A     ld c, FONT_HEIGHT
_l204:
0A2E 7E        ld a, (hl)
0A2F 87        add a
0A30 87        add a
0A31 47        ld b, a
0A32 1A        ld a, (de)
DrawChar_And1:
0A33 E6 03     and 3
DrawChar_Xor1:
0A35 A8        xor b
0A36 12        ld (de), a
0A37 1D        dec e
0A38 24        inc h
_l206:
0A39 0D        dec c
0A3A C2 2E 0A  jp nz, _l204
_l205:
DrawChar_1:
0A3D 7A        ld a, d
0A3E D6 40     sub 64
0A40 57        ld d, a
0A41 0E 0A     ld c, FONT_HEIGHT
_l210:
0A43 25        dec h
0A44 1C        inc e
0A45 7E        ld a, (hl)
0A46 87        add a
0A47 87        add a
0A48 47        ld b, a
0A49 1A        ld a, (de)
DrawChar_And2:
0A4A E6 03     and 3
DrawChar_Xor2:
0A4C A8        xor b
0A4D 12        ld (de), a
_l212:
0A4E 0D        dec c
0A4F C2 43 0A  jp nz, _l210
_l211:
0A52 C9        ret
DrawChar62:
0A53 0E 0A     ld c, FONT_HEIGHT
_l216:
0A55 46        ld b, (hl)
0A56 1A        ld a, (de)
DrawChar_And11:
0A57 E6 C0     and 192
DrawChar_Xor11:
0A59 A8        xor b
0A5A 12        ld (de), a
0A5B 1D        dec e
0A5C 24        inc h
_l218:
0A5D 0D        dec c
0A5E C2 55 0A  jp nz, _l216
_l217:
DrawChar_3:
0A61 7A        ld a, d
0A62 D6 40     sub 64
0A64 57        ld d, a
0A65 0E 0A     ld c, FONT_HEIGHT
_l222:
0A67 25        dec h
0A68 1C        inc e
0A69 46        ld b, (hl)
0A6A 1A        ld a, (de)
DrawChar_And12:
0A6B E6 C0     and 192
DrawChar_Xor12:
0A6D A8        xor b
0A6E 12        ld (de), a
_l224:
0A6F 0D        dec c
0A70 C2 67 0A  jp nz, _l222
_l223:
0A73 C9        ret
DrawChar64:
0A74 0E 0A     ld c, FONT_HEIGHT
_l228:
0A76 7E        ld a, (hl)
0A77 0F 0F     rrca
 rrca
0A79 E6 0F     and 15
0A7B 47        ld b, a
0A7C 1A        ld a, (de)
DrawChar_And7:
0A7D E6 F0     and 240
DrawChar_Xor7:
0A7F A8        xor b
0A80 12        ld (de), a
0A81 15        dec d
0A82 7E        ld a, (hl)
0A83 0F 0F     rrca
 rrca
0A85 E6 C0     and 192
0A87 47        ld b, a
0A88 1A        ld a, (de)
DrawChar_And9:
0A89 E6 3F     and 63
DrawChar_Xor8:
0A8B A8        xor b
0A8C 12        ld (de), a
0A8D 14        inc d
0A8E 1D        dec e
0A8F 24        inc h
_l230:
0A90 0D        dec c
0A91 C2 76 0A  jp nz, _l228
_l229:
DrawChar_4:
0A94 7A        ld a, d
0A95 D6 40     sub 64
0A97 57        ld d, a
0A98 0E 0A     ld c, FONT_HEIGHT
_l236:
0A9A 25        dec h
0A9B 1C        inc e
0A9C 7E        ld a, (hl)
0A9D 0F 0F     rrca
 rrca
0A9F E6 0F     and 15
0AA1 47        ld b, a
0AA2 1A        ld a, (de)
DrawChar_And8:
0AA3 E6 F0     and 240
DrawChar_Xor9:
0AA5 A8        xor b
0AA6 12        ld (de), a
0AA7 15        dec d
0AA8 7E        ld a, (hl)
0AA9 0F 0F     rrca
 rrca
0AAB E6 C0     and 192
0AAD 47        ld b, a
0AAE 1A        ld a, (de)
DrawChar_And10:
0AAF E6 3F     and 63
DrawChar_Xor10:
0AB1 A8        xor b
0AB2 12        ld (de), a
0AB3 14        inc d
_l238:
0AB4 0D        dec c
0AB5 C2 9A 0A  jp nz, _l236
_l237:
0AB8 C9        ret
SetColor6:
0AB9 4F        ld c, a
0ABA E6 08     and 8
0ABC C2 E4 0A  jp nz, _l244
0ABF 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
0AC2 22 33 0A  ld (DrawChar_And1), hl
0AC5 22 4A 0A  ld (DrawChar_And2), hl
0AC8 26 FC     ld h, 252
0ACA 22 F1 09  ld (DrawChar_And3), hl
0ACD 26 0F     ld h, 15
0ACF 22 FB 09  ld (DrawChar_And5), hl
0AD2 26 F0     ld h, 240
0AD4 22 7D 0A  ld (DrawChar_And7), hl
0AD7 26 3F     ld h, 63
0AD9 22 89 0A  ld (DrawChar_And9), hl
0ADC 26 C0     ld h, 192
0ADE 22 57 0A  ld (DrawChar_And11), hl
0AE1 C3 06 0B  jp _l245
_l244:
0AE4 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
0AE7 22 33 0A  ld (DrawChar_And1), hl
0AEA 22 4A 0A  ld (DrawChar_And2), hl
0AED 26 03     ld h, 255^252
0AEF 22 F1 09  ld (DrawChar_And3), hl
0AF2 26 F0     ld h, 255^15
0AF4 22 FB 09  ld (DrawChar_And5), hl
0AF7 26 0F     ld h, 255^240
0AF9 22 7D 0A  ld (DrawChar_And7), hl
0AFC 26 C0     ld h, 255^63
0AFE 22 89 0A  ld (DrawChar_And9), hl
0B01 26 3F     ld h, 255^192
0B03 22 57 0A  ld (DrawChar_And11), hl
_l245:
0B06 47        ld b, a
0B07 79        ld a, c
0B08 87        add a
0B09 87        add a
0B0A E6 08     and 8
0B0C A8        xor b
0B0D 3E A8     ld a, OPCODE_XOR_B
0B0F C2 14 0B  jp nz, _l246
0B12 3E 00     ld a, OPCODE_NOP
_l246:
0B14 32 35 0A  ld (DrawChar_Xor1), a
0B17 32 F3 09  ld (DrawChar_Xor3), a
0B1A 32 FD 09  ld (DrawChar_Xor4), a
0B1D 32 7F 0A  ld (DrawChar_Xor7), a
0B20 32 8B 0A  ld (DrawChar_Xor8), a
0B23 32 59 0A  ld (DrawChar_Xor11), a
0B26 79        ld a, c
0B27 E6 04     and 4
0B29 C2 4E 0B  jp nz, _l247
0B2C 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
0B2F 22 4A 0A  ld (DrawChar_And2), hl
0B32 26 FC     ld h, 252
0B34 22 18 0A  ld (DrawChar_And4), hl
0B37 26 0F     ld h, 15
0B39 22 22 0A  ld (DrawChar_And6), hl
0B3C 26 F0     ld h, 240
0B3E 22 A3 0A  ld (DrawChar_And8), hl
0B41 26 3F     ld h, 63
0B43 22 AF 0A  ld (DrawChar_And10), hl
0B46 26 C0     ld h, 192
0B48 22 6B 0A  ld (DrawChar_And12), hl
0B4B C3 6D 0B  jp _l248
_l247:
0B4E 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
0B51 22 4A 0A  ld (DrawChar_And2), hl
0B54 26 03     ld h, 255^252
0B56 22 18 0A  ld (DrawChar_And4), hl
0B59 26 F0     ld h, 255^15
0B5B 22 22 0A  ld (DrawChar_And6), hl
0B5E 26 0F     ld h, 255^240
0B60 22 A3 0A  ld (DrawChar_And8), hl
0B63 26 C0     ld h, 255^63
0B65 22 AF 0A  ld (DrawChar_And10), hl
0B68 26 3F     ld h, 255^192
0B6A 22 6B 0A  ld (DrawChar_And12), hl
_l248:
0B6D 47        ld b, a
0B6E 79        ld a, c
0B6F 87        add a
0B70 87        add a
0B71 E6 04     and 4
0B73 A8        xor b
0B74 3E A8     ld a, OPCODE_XOR_B
0B76 C2 7B 0B  jp nz, _l249
0B79 3E 00     ld a, OPCODE_NOP
_l249:
0B7B 32 4C 0A  ld (DrawChar_Xor2), a
0B7E 32 1A 0A  ld (DrawChar_Xor5), a
0B81 32 24 0A  ld (DrawChar_Xor6), a
0B84 32 A5 0A  ld (DrawChar_Xor9), a
0B87 32 B1 0A  ld (DrawChar_Xor10), a
0B8A 32 6D 0A  ld (DrawChar_Xor12), a
0B8D C9        ret
DrawCursor6:
0B8E 7C        ld a, h
0B8F E6 03     and 3
0B91 C2 9A 0B  jp nz, _l251
0B94 11 FC 00  ld de, 252
0B97 C3 B1 0B  jp _l252
_l251:
0B9A 3D        dec a
0B9B C2 A4 0B  jp nz, _l253
0B9E 11 03 F0  ld de, 61443
0BA1 C3 B1 0B  jp _l254
_l253:
0BA4 3D        dec a
0BA5 C2 AE 0B  jp nz, _l255
0BA8 11 0F C0  ld de, 49167
0BAB C3 B1 0B  jp _l256
_l255:
0BAE 11 3F 00  ld de, 63
_l252:
_l254:
_l256:
0BB1 7D        ld a, l
0BB2 87        add a
0BB3 87        add a
0BB4 85        add l
0BB5 87        add a
0BB6 2F        cpl
0BB7 6F        ld l, a
0BB8 7C        ld a, h
0BB9 87        add a
0BBA 84        add h
0BBB 0F 0F     rrca
 rrca
0BBD E6 3F     and 63
0BBF 2F        cpl
0BC0 67        ld h, a
0BC1 0E 0A     ld c, FONT_HEIGHT
_l257:
0BC3 7E        ld a, (hl)
0BC4 AB        xor e
0BC5 77        ld (hl), a
0BC6 25        dec h
0BC7 7E        ld a, (hl)
0BC8 AA        xor d
0BC9 77        ld (hl), a
0BCA 24        inc h
0BCB 2D        dec l
_l259:
0BCC 0D        dec c
0BCD C2 C3 0B  jp nz, _l257
_l258:
0BD0 C9        ret
SetScreenBw6:
0BD1 3E 40     ld a, 64
0BD3 32 9C 08  ld (text_screen_width), a
0BD6 21 BD 09  ld hl, DrawChar6
0BD9 22 9E 08  ld (DrawCharAddress), hl
0BDC 21 B9 0A  ld hl, SetColor6
0BDF 22 A1 08  ld (SetColorAddress), hl
0BE2 3E C9     ld a, OPCODE_RET
0BE4 32 3D 0A  ld (DrawChar_1), a
0BE7 32 06 0A  ld (DrawChar_2), a
0BEA 32 61 0A  ld (DrawChar_3), a
0BED 32 94 0A  ld (DrawChar_4), a
SetScreenBw:
0BF0 D3 B8     out (PORT_VIDEO_MODE_0_LOW), a
0BF2 D3 F9     out (PORT_VIDEO_MODE_1_HIGH), a
0BF4 3E C3     ld a, OPCODE_JP
0BF6 32 D0 08  ld (ClearScreen_1), a
0BF9 21 E2 08  ld hl, ClearScreenSetSp
0BFC 22 D1 08  ld (ClearScreen_2), hl
0BFF 3E FF     ld a, 255
0C01 32 E7 08  ld (ClearScreen_4), a
0C04 21 EE 08  ld hl, ScrollUpSubBw
0C07 22 6A 09  ld (ScrollUp_1), hl
0C0A 3E C3     ld a, OPCODE_JP
0C0C 32 92 09  ld (ScrollUp_2), a
0C0F 21 A8 09  ld hl, ScrollUpSpInstr2
0C12 22 93 09  ld (ScrollUp_3), hl
0C15 C9        ret
SetScreenColor6:
0C16 3E 40     ld a, 64
0C18 32 9C 08  ld (text_screen_width), a
0C1B 21 BD 09  ld hl, DrawChar6
0C1E 22 9E 08  ld (DrawCharAddress), hl
0C21 21 B9 0A  ld hl, SetColor6
0C24 22 A1 08  ld (SetColorAddress), hl
0C27 3E 7A     ld a, OPCODE_LD_A_D
0C29 32 3D 0A  ld (DrawChar_1), a
0C2C 32 06 0A  ld (DrawChar_2), a
0C2F 32 61 0A  ld (DrawChar_3), a
0C32 32 94 0A  ld (DrawChar_4), a
SetScreenColor:
0C35 D3 F8     out (PORT_VIDEO_MODE_0_HIGH), a
0C37 D3 B9     out (PORT_VIDEO_MODE_1_LOW), a
0C39 21 D6 40  ld hl, OPCODE_SUB_CONST|64<<8
0C3C 22 D0 08  ld (ClearScreen_1), hl
0C3F 3E 67     ld a, OPCODE_LD_H_A
0C41 32 D2 08  ld (ClearScreen_3), a
0C44 3E 3F     ld a, 63
0C46 32 E7 08  ld (ClearScreen_4), a
0C49 21 13 09  ld hl, ScrollUpSubColor
0C4C 22 6A 09  ld (ScrollUp_1), hl
0C4F 3E 3E     ld a, OPCODE_LD_A_CONST
0C51 32 92 09  ld (ScrollUp_2), a
0C54 21 30 11  ld hl, 48|OPCODE_LD_DE_CONST<<8
0C57 22 93 09  ld (ScrollUp_3), hl
0C5A C9        ret
font:
0C5B 00 00 00  db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 63
 db 0
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 42
 db 59
 db 4
 db 4
 db 4
 db 10
 db 0
 db 0
 db 10
 db 10
 db 0
 db 10
 db 10
 db 4
 db 0
 db 4
 db 4
 db 0
 db 4
 db 0
 db 4
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 10
 db 0
 db 10
 db 4
 db 10
 db 0
 db 0
 db 10
 db 4
 db 0
 db 0
 db 10
 db 4
 db 4
 db 0
 db 63
 db 0
 db 56
 db 7
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 10
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 30
 db 30
 db 0
 db 0
 db 4
 db 4
 db 0
 db 63
 db 0
 db 63
 db 0
 db 14
 db 15
 db 15
 db 4
 db 16
 db 2
 db 4
 db 10
 db 15
 db 14
 db 0
 db 4
 db 4
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 10
 db 10
 db 17
 db 25
 db 4
 db 4
 db 2
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 14
 db 4
 db 14
 db 31
 db 2
 db 31
 db 6
 db 31
 db 14
 db 14
 db 0
 db 0
 db 2
 db 0
 db 8
 db 14
 db 14
 db 4
 db 30
 db 14
 db 30
 db 31
 db 31
 db 14
 db 17
 db 14
 db 1
 db 17
 db 16
 db 17
 db 17
 db 14
 db 30
 db 14
 db 30
 db 14
 db 31
 db 17
 db 17
 db 17
 db 17
 db 17
 db 31
 db 14
 db 0
 db 14
 db 4
 db 0
 db 16
 db 0
 db 16
 db 0
 db 1
 db 0
 db 6
 db 0
 db 16
 db 4
 db 1
 db 16
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 3
 db 4
 db 24
 db 0
 db 0
 db 7
 db 31
 db 30
 db 31
 db 6
 db 31
 db 21
 db 14
 db 17
 db 21
 db 17
 db 7
 db 17
 db 17
 db 14
 db 31
 db 30
 db 14
 db 31
 db 17
 db 14
 db 17
 db 18
 db 17
 db 17
 db 21
 db 24
 db 17
 db 16
 db 14
 db 18
 db 15
 db 0
 db 14
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 21
 db 46
 db 4
 db 4
 db 4
 db 10
 db 0
 db 0
 db 10
 db 10
 db 0
 db 10
 db 10
 db 4
 db 0
 db 4
 db 4
 db 0
 db 4
 db 0
 db 4
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 10
 db 0
 db 10
 db 4
 db 10
 db 0
 db 0
 db 10
 db 4
 db 0
 db 0
 db 10
 db 4
 db 4
 db 0
 db 63
 db 0
 db 56
 db 7
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 31
 db 10
 db 8
 db 2
 db 2
 db 4
 db 12
 db 0
 db 12
 db 0
 db 0
 db 1
 db 24
 db 24
 db 0
 db 0
 db 0
 db 33
 db 63
 db 10
 db 4
 db 14
 db 14
 db 0
 db 63
 db 0
 db 63
 db 7
 db 17
 db 9
 db 9
 db 21
 db 24
 db 6
 db 14
 db 10
 db 21
 db 16
 db 0
 db 14
 db 14
 db 4
 db 4
 db 4
 db 0
 db 0
 db 4
 db 0
 db 0
 db 4
 db 10
 db 10
 db 14
 db 26
 db 10
 db 4
 db 4
 db 4
 db 4
 db 4
 db 0
 db 0
 db 0
 db 1
 db 17
 db 12
 db 17
 db 1
 db 6
 db 16
 db 8
 db 1
 db 17
 db 17
 db 12
 db 12
 db 4
 db 0
 db 4
 db 17
 db 17
 db 10
 db 17
 db 17
 db 17
 db 16
 db 16
 db 17
 db 17
 db 4
 db 1
 db 17
 db 16
 db 27
 db 17
 db 17
 db 17
 db 17
 db 17
 db 17
 db 4
 db 17
 db 17
 db 17
 db 17
 db 17
 db 1
 db 8
 db 16
 db 2
 db 10
 db 0
 db 8
 db 0
 db 16
 db 0
 db 1
 db 0
 db 9
 db 0
 db 16
 db 0
 db 0
 db 16
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 4
 db 4
 db 0
 db 0
 db 9
 db 16
 db 17
 db 16
 db 10
 db 16
 db 21
 db 17
 db 17
 db 17
 db 17
 db 9
 db 27
 db 17
 db 17
 db 17
 db 17
 db 17
 db 4
 db 17
 db 21
 db 17
 db 18
 db 17
 db 21
 db 21
 db 8
 db 17
 db 16
 db 17
 db 21
 db 17
 db 0
 db 16
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 42
 db 59
 db 4
 db 4
 db 4
 db 10
 db 0
 db 0
 db 10
 db 10
 db 0
 db 10
 db 10
 db 4
 db 0
 db 4
 db 4
 db 0
 db 4
 db 0
 db 4
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 10
 db 0
 db 10
 db 4
 db 10
 db 0
 db 0
 db 10
 db 4
 db 0
 db 0
 db 10
 db 4
 db 4
 db 0
 db 63
 db 0
 db 56
 db 7
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 16
 db 0
 db 4
 db 4
 db 5
 db 4
 db 12
 db 13
 db 18
 db 0
 db 0
 db 1
 db 20
 db 4
 db 0
 db 0
 db 0
 db 51
 db 45
 db 31
 db 14
 db 4
 db 31
 db 12
 db 51
 db 12
 db 51
 db 3
 db 17
 db 15
 db 15
 db 14
 db 28
 db 14
 db 31
 db 10
 db 21
 db 12
 db 0
 db 31
 db 31
 db 4
 db 6
 db 12
 db 0
 db 18
 db 14
 db 0
 db 0
 db 4
 db 10
 db 31
 db 17
 db 2
 db 10
 db 8
 db 8
 db 2
 db 21
 db 4
 db 0
 db 0
 db 0
 db 2
 db 19
 db 4
 db 1
 db 2
 db 10
 db 30
 db 16
 db 2
 db 17
 db 17
 db 12
 db 12
 db 8
 db 31
 db 2
 db 1
 db 19
 db 17
 db 17
 db 16
 db 17
 db 16
 db 16
 db 16
 db 17
 db 4
 db 1
 db 18
 db 16
 db 21
 db 25
 db 17
 db 17
 db 17
 db 17
 db 16
 db 4
 db 17
 db 17
 db 17
 db 10
 db 17
 db 2
 db 8
 db 8
 db 2
 db 17
 db 0
 db 4
 db 14
 db 30
 db 15
 db 15
 db 14
 db 8
 db 15
 db 30
 db 12
 db 1
 db 17
 db 4
 db 26
 db 30
 db 14
 db 30
 db 15
 db 22
 db 15
 db 30
 db 17
 db 17
 db 17
 db 17
 db 17
 db 31
 db 4
 db 4
 db 4
 db 0
 db 4
 db 9
 db 16
 db 17
 db 16
 db 10
 db 16
 db 21
 db 1
 db 19
 db 19
 db 18
 db 9
 db 21
 db 17
 db 17
 db 17
 db 17
 db 16
 db 4
 db 17
 db 21
 db 10
 db 18
 db 17
 db 21
 db 21
 db 8
 db 17
 db 16
 db 1
 db 21
 db 17
 db 14
 db 30
 db 30
 db 31
 db 6
 db 14
 db 21
 db 14
 db 17
 db 17
 db 17
 db 7
 db 17
 db 17
 db 14
 db 31
 db 17
 db 21
 db 46
 db 4
 db 4
 db 60
 db 10
 db 0
 db 60
 db 58
 db 10
 db 62
 db 58
 db 10
 db 60
 db 0
 db 4
 db 4
 db 0
 db 4
 db 0
 db 4
 db 7
 db 10
 db 11
 db 15
 db 59
 db 63
 db 11
 db 63
 db 59
 db 63
 db 10
 db 63
 db 0
 db 10
 db 7
 db 7
 db 0
 db 10
 db 63
 db 4
 db 0
 db 63
 db 0
 db 56
 db 7
 db 63
 db 30
 db 15
 db 31
 db 17
 db 14
 db 17
 db 18
 db 17
 db 21
 db 21
 db 24
 db 17
 db 16
 db 14
 db 18
 db 15
 db 16
 db 14
 db 2
 db 8
 db 4
 db 4
 db 0
 db 22
 db 18
 db 0
 db 0
 db 2
 db 20
 db 8
 db 30
 db 0
 db 0
 db 33
 db 63
 db 31
 db 31
 db 31
 db 31
 db 30
 db 33
 db 18
 db 45
 db 13
 db 14
 db 8
 db 9
 db 17
 db 30
 db 30
 db 4
 db 10
 db 13
 db 18
 db 0
 db 4
 db 4
 db 4
 db 31
 db 31
 db 0
 db 51
 db 31
 db 31
 db 0
 db 4
 db 0
 db 10
 db 17
 db 4
 db 12
 db 0
 db 8
 db 2
 db 14
 db 31
 db 0
 db 31
 db 0
 db 4
 db 21
 db 4
 db 6
 db 6
 db 18
 db 1
 db 30
 db 4
 db 14
 db 15
 db 0
 db 0
 db 16
 db 0
 db 1
 db 2
 db 21
 db 17
 db 30
 db 16
 db 17
 db 30
 db 30
 db 16
 db 31
 db 4
 db 1
 db 28
 db 16
 db 21
 db 21
 db 17
 db 17
 db 17
 db 17
 db 14
 db 4
 db 17
 db 10
 db 21
 db 4
 db 10
 db 4
 db 8
 db 4
 db 2
 db 0
 db 0
 db 0
 db 1
 db 17
 db 16
 db 17
 db 17
 db 28
 db 17
 db 17
 db 4
 db 1
 db 18
 db 4
 db 21
 db 17
 db 17
 db 17
 db 17
 db 25
 db 16
 db 8
 db 17
 db 17
 db 21
 db 10
 db 17
 db 2
 db 24
 db 0
 db 3
 db 13
 db 10
 db 17
 db 30
 db 30
 db 16
 db 10
 db 30
 db 14
 db 6
 db 21
 db 21
 db 28
 db 9
 db 21
 db 31
 db 17
 db 17
 db 17
 db 16
 db 4
 db 15
 db 21
 db 4
 db 18
 db 15
 db 21
 db 21
 db 14
 db 25
 db 30
 db 7
 db 29
 db 17
 db 1
 db 17
 db 17
 db 16
 db 10
 db 17
 db 21
 db 17
 db 19
 db 19
 db 18
 db 9
 db 27
 db 17
 db 17
 db 17
 db 4
 db 42
 db 59
 db 4
 db 60
 db 4
 db 58
 db 63
 db 4
 db 2
 db 10
 db 2
 db 2
 db 62
 db 4
 db 60
 db 7
 db 63
 db 63
 db 7
 db 63
 db 63
 db 4
 db 11
 db 8
 db 8
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 63
 db 0
 db 63
 db 15
 db 4
 db 4
 db 15
 db 63
 db 4
 db 60
 db 7
 db 63
 db 0
 db 56
 db 7
 db 63
 db 17
 db 16
 db 4
 db 17
 db 21
 db 10
 db 18
 db 17
 db 21
 db 21
 db 8
 db 17
 db 16
 db 17
 db 21
 db 17
 db 30
 db 17
 db 4
 db 4
 db 4
 db 4
 db 30
 db 0
 db 12
 db 12
 db 4
 db 2
 db 20
 db 28
 db 30
 db 0
 db 0
 db 45
 db 51
 db 31
 db 31
 db 27
 db 31
 db 30
 db 33
 db 18
 db 45
 db 18
 db 4
 db 8
 db 9
 db 14
 db 28
 db 14
 db 31
 db 10
 db 5
 db 18
 db 0
 db 31
 db 4
 db 31
 db 6
 db 12
 db 16
 db 63
 db 31
 db 31
 db 0
 db 4
 db 0
 db 31
 db 17
 db 8
 db 21
 db 0
 db 8
 db 2
 db 21
 db 4
 db 0
 db 0
 db 0
 db 8
 db 25
 db 4
 db 8
 db 1
 db 31
 db 1
 db 17
 db 8
 db 17
 db 1
 db 0
 db 0
 db 8
 db 31
 db 2
 db 4
 db 23
 db 31
 db 17
 db 16
 db 17
 db 16
 db 16
 db 19
 db 17
 db 4
 db 17
 db 18
 db 16
 db 17
 db 19
 db 17
 db 30
 db 21
 db 30
 db 1
 db 4
 db 17
 db 10
 db 21
 db 10
 db 4
 db 8
 db 8
 db 2
 db 2
 db 0
 db 0
 db 0
 db 15
 db 17
 db 16
 db 17
 db 31
 db 8
 db 17
 db 17
 db 4
 db 1
 db 28
 db 4
 db 21
 db 17
 db 17
 db 17
 db 17
 db 16
 db 14
 db 8
 db 17
 db 10
 db 21
 db 4
 db 17
 db 4
 db 4
 db 4
 db 4
 db 22
 db 17
 db 31
 db 17
 db 17
 db 16
 db 10
 db 16
 db 21
 db 1
 db 25
 db 25
 db 18
 db 9
 db 17
 db 17
 db 17
 db 17
 db 30
 db 16
 db 4
 db 1
 db 14
 db 10
 db 18
 db 1
 db 21
 db 21
 db 9
 db 21
 db 17
 db 1
 db 21
 db 15
 db 15
 db 17
 db 30
 db 16
 db 10
 db 31
 db 14
 db 6
 db 21
 db 21
 db 28
 db 9
 db 21
 db 31
 db 17
 db 17
 db 17
 db 21
 db 46
 db 4
 db 4
 db 60
 db 10
 db 10
 db 60
 db 58
 db 10
 db 58
 db 62
 db 0
 db 60
 db 4
 db 0
 db 0
 db 4
 db 4
 db 0
 db 4
 db 7
 db 10
 db 15
 db 11
 db 63
 db 59
 db 11
 db 63
 db 59
 db 63
 db 0
 db 63
 db 10
 db 0
 db 7
 db 7
 db 10
 db 10
 db 63
 db 0
 db 4
 db 63
 db 63
 db 56
 db 7
 db 0
 db 17
 db 16
 db 4
 db 17
 db 21
 db 4
 db 18
 db 15
 db 21
 db 21
 db 14
 db 29
 db 30
 db 7
 db 29
 db 15
 db 16
 db 31
 db 8
 db 2
 db 4
 db 4
 db 0
 db 13
 db 0
 db 12
 db 0
 db 36
 db 0
 db 0
 db 30
 db 0
 db 0
 db 33
 db 63
 db 14
 db 14
 db 4
 db 4
 db 12
 db 51
 db 12
 db 51
 db 18
 db 14
 db 24
 db 27
 db 21
 db 24
 db 6
 db 14
 db 0
 db 5
 db 12
 db 30
 db 14
 db 4
 db 14
 db 4
 db 4
 db 16
 db 51
 db 0
 db 14
 db 0
 db 0
 db 0
 db 10
 db 14
 db 11
 db 18
 db 0
 db 4
 db 4
 db 4
 db 4
 db 12
 db 0
 db 12
 db 16
 db 17
 db 4
 db 16
 db 17
 db 2
 db 17
 db 17
 db 8
 db 17
 db 2
 db 12
 db 12
 db 4
 db 0
 db 4
 db 0
 db 16
 db 17
 db 17
 db 17
 db 17
 db 16
 db 16
 db 17
 db 17
 db 4
 db 17
 db 17
 db 16
 db 17
 db 17
 db 17
 db 16
 db 18
 db 18
 db 17
 db 4
 db 17
 db 4
 db 21
 db 17
 db 4
 db 16
 db 8
 db 1
 db 2
 db 0
 db 0
 db 0
 db 17
 db 17
 db 16
 db 17
 db 16
 db 8
 db 17
 db 17
 db 4
 db 17
 db 18
 db 4
 db 21
 db 17
 db 17
 db 17
 db 17
 db 16
 db 1
 db 9
 db 17
 db 10
 db 21
 db 10
 db 17
 db 8
 db 4
 db 4
 db 4
 db 0
 db 17
 db 17
 db 17
 db 17
 db 16
 db 10
 db 16
 db 21
 db 17
 db 17
 db 17
 db 17
 db 9
 db 17
 db 17
 db 17
 db 17
 db 16
 db 17
 db 4
 db 17
 db 4
 db 17
 db 18
 db 1
 db 21
 db 21
 db 9
 db 21
 db 17
 db 17
 db 21
 db 9
 db 17
 db 17
 db 17
 db 16
 db 10
 db 16
 db 21
 db 17
 db 25
 db 25
 db 18
 db 9
 db 17
 db 17
 db 17
 db 17
 db 4
 db 42
 db 59
 db 4
 db 4
 db 4
 db 10
 db 10
 db 4
 db 10
 db 10
 db 10
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 4
 db 4
 db 0
 db 4
 db 4
 db 10
 db 0
 db 10
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 0
 db 4
 db 10
 db 0
 db 0
 db 4
 db 10
 db 10
 db 4
 db 0
 db 4
 db 63
 db 63
 db 56
 db 7
 db 0
 db 17
 db 16
 db 4
 db 17
 db 21
 db 10
 db 18
 db 1
 db 21
 db 21
 db 9
 db 21
 db 17
 db 17
 db 21
 db 9
 db 16
 db 16
 db 0
 db 0
 db 4
 db 20
 db 12
 db 22
 db 0
 db 0
 db 0
 db 20
 db 0
 db 0
 db 30
 db 0
 db 0
 db 30
 db 30
 db 4
 db 4
 db 14
 db 14
 db 0
 db 63
 db 0
 db 63
 db 12
 db 4
 db 24
 db 27
 db 4
 db 16
 db 2
 db 4
 db 10
 db 5
 db 2
 db 30
 db 4
 db 4
 db 4
 db 0
 db 0
 db 31
 db 18
 db 0
 db 4
 db 0
 db 4
 db 0
 db 10
 db 17
 db 19
 db 13
 db 0
 db 2
 db 8
 db 0
 db 0
 db 12
 db 0
 db 12
 db 0
 db 14
 db 14
 db 31
 db 14
 db 2
 db 14
 db 14
 db 8
 db 14
 db 12
 db 12
 db 12
 db 2
 db 0
 db 8
 db 4
 db 14
 db 17
 db 30
 db 14
 db 30
 db 31
 db 16
 db 15
 db 17
 db 14
 db 14
 db 17
 db 31
 db 17
 db 17
 db 14
 db 16
 db 13
 db 17
 db 14
 db 4
 db 14
 db 4
 db 10
 db 17
 db 4
 db 31
 db 14
 db 0
 db 14
 db 0
 db 0
 db 0
 db 15
 db 30
 db 15
 db 15
 db 15
 db 8
 db 15
 db 17
 db 14
 db 17
 db 17
 db 2
 db 21
 db 17
 db 14
 db 30
 db 15
 db 16
 db 30
 db 6
 db 15
 db 4
 db 10
 db 17
 db 15
 db 31
 db 3
 db 4
 db 24
 db 0
 db 31
 db 17
 db 30
 db 30
 db 16
 db 31
 db 31
 db 21
 db 14
 db 17
 db 17
 db 17
 db 17
 db 17
 db 17
 db 14
 db 17
 db 16
 db 14
 db 4
 db 14
 db 4
 db 17
 db 31
 db 1
 db 31
 db 31
 db 14
 db 25
 db 30
 db 14
 db 18
 db 17
 db 15
 db 14
 db 30
 db 16
 db 31
 db 14
 db 21
 db 14
 db 17
 db 17
 db 17
 db 25
 db 17
 db 17
 db 14
 db 17
 db 17
 db 21
 db 46
 db 4
 db 4
 db 4
 db 10
 db 10
 db 4
 db 10
 db 10
 db 10
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 4
 db 4
 db 0
 db 4
 db 4
 db 10
 db 0
 db 10
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 0
 db 4
 db 10
 db 0
 db 0
 db 4
 db 10
 db 10
 db 4
 db 0
 db 4
 db 63
 db 63
 db 56
 db 7
 db 0
 db 30
 db 15
 db 4
 db 15
 db 14
 db 17
 db 31
 db 1
 db 31
 db 31
 db 14
 db 29
 db 30
 db 14
 db 18
 db 17
 db 31
 db 14
 db 31
 db 31
 db 4
 db 8
 db 12
 db 0
 db 0
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 63
 db 0
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 28
 db 0
 db 31
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 31
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 1
 db 0
 db 0
 db 14
 db 0
 db 0
 db 0
 db 0
 db 0
 db 16
 db 1
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 1
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 1
 db 0
 db 0
 db 1
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 42
 db 59
 db 4
 db 4
 db 4
 db 10
 db 10
 db 4
 db 10
 db 10
 db 10
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 4
 db 4
 db 0
 db 4
 db 4
 db 10
 db 0
 db 10
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 0
 db 4
 db 10
 db 0
 db 0
 db 4
 db 10
 db 10
 db 4
 db 0
 db 4
 db 63
 db 63
 db 56
 db 7
 db 0
 db 16
 db 0
 db 0
 db 1
 db 4
 db 0
 db 1
 db 0
 db 0
 db 1
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 63
 db 0
 db 63
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 8
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 14
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 16
 db 1
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 14
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 21
 db 46
 db 4
 db 4
 db 4
 db 10
 db 10
 db 4
 db 10
 db 10
 db 10
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 4
 db 4
 db 0
 db 4
 db 4
 db 10
 db 0
 db 10
 db 0
 db 10
 db 10
 db 0
 db 10
 db 0
 db 0
 db 4
 db 10
 db 0
 db 0
 db 4
 db 10
 db 10
 db 4
 db 0
 db 4
 db 63
 db 63
 db 56
 db 7
 db 0
 db 16
 db 0
 db 0
 db 14
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 4
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
165B          SCREEN_0_ADDRESS equ 53248
165B          SCREEN_1_ADDRESS equ 36864
165B          PALETTE_WHITE equ 0
165B          PALETTE_CYAN equ 1
165B          PALETTE_MAGENTA equ 2
165B          PALETTE_BLUE equ 3
165B          PALETTE_YELLOW equ 4
165B          PALETTE_GREEN equ 5
165B          PALETTE_RED equ 6
165B          PALETTE_XXX equ 7
165B          PALETTE_GRAY equ 8
165B          PALETTE_DARK_CYAN equ 9
165B          PALETTE_DARK_MAGENTA equ 10
165B          PALETTE_DARK_BLUE equ 11
165B          PALETTE_DARK_YELLOW equ 12
165B          PALETTE_DARK_GREEN equ 13
165B          PALETTE_DARK_RED equ 14
165B          PALETTE_BLACK equ 15
165B          KEY_BACKSPACE equ 8
165B          KEY_TAB equ 9
165B          KEY_ENTER equ 13
165B          KEY_ESC equ 27
165B          KEY_ALT equ 1
165B          KEY_F1 equ 242
165B          KEY_F2 equ 243
165B          KEY_F3 equ 244
165B          KEY_UP equ 245
165B          KEY_DOWN equ 246
165B          KEY_RIGHT equ 247
165B          KEY_LEFT equ 248
165B          KEY_EXT_5 equ 249
165B          KEY_END equ 250
165B          KEY_HOME equ 251
165B          KEY_INSERT equ 252
165B          KEY_DEL equ 253
165B          KEY_PG_UP equ 254
165B          KEY_PG_DN equ 255
165B          PORT_FRAME_IRQ_RESET equ 4
165B          PORT_SD_SIZE equ 9
165B          PORT_SD_RESULT equ 9
165B          PORT_SD_DATA equ 8
165B          PORT_UART_DATA equ 128
165B          PORT_UART_CONFIG equ 129
165B          PORT_UART_STATE equ 129
165B          PORT_EXT_DATA_OUT equ 136
165B          PORT_PALETTE_3 equ 144
165B          PORT_PALETTE_2 equ 145
165B          PORT_PALETTE_1 equ 146
165B          PORT_PALETTE_0 equ 147
165B          PORT_EXT_IN_DATA equ 137
165B          PORT_A0 equ 160
165B          PORT_ROM_0000 equ 168
165B          PORT_ROM_0000__ROM equ 0
165B          PORT_ROM_0000__RAM equ 128
165B          PORT_VIDEO_MODE_1_LOW equ 185
165B          PORT_VIDEO_MODE_1_HIGH equ 249
165B          PORT_VIDEO_MODE_0_LOW equ 184
165B          PORT_VIDEO_MODE_0_HIGH equ 248
165B          PORT_UART_SPEED_0 equ 187
165B          PORT_KEYBOARD equ 192
165B          PORT_UART_SPEED_1 equ 251
165B          PORT_CODE_ROM equ 186
165B          PORT_CHARGEN_ROM equ 250
165B          PORT_TAPE_AND_IDX2 equ 153
165B          PORT_TAPE_AND_IDX2_ID1_2 equ 2
165B          PORT_TAPE_AND_IDX2_ID2_2 equ 4
165B          PORT_TAPE_AND_IDX2_ID3_2 equ 8
165B          PORT_TAPE_AND_IDX2_ID6_2 equ 64
165B          PORT_TAPE_AND_IDX2_ID7_2 equ 128
165B          PORT_RESET_CU1 equ 188
165B          PORT_RESET_CU2 equ 189
165B          PORT_RESET_CU3 equ 190
165B          PORT_RESET_CU4 equ 191
165B          PORT_SET_CU1 equ 252
165B          PORT_SET_CU2 equ 253
165B          PORT_SET_CU3 equ 254
165B          PORT_SET_CU4 equ 255
165B          PORT_TAPE_OUT equ 176
165B          SD_COMMAND_READ equ 1
165B          SD_COMMAND_READ_SIZE equ 5
165B          SD_COMMAND_WRITE equ 2
165B          SD_COMMAND_WRITE_SIZE equ 5+128
165B          SD_RESULT_BUSY equ 255
165B          SD_RESULT_OK equ 0
165B          TEXT_SCREEN_HEIGHT equ 25
165B          FONT_HEIGHT equ 10
165B          FONT_WIDTH equ 3
165B          DrawCharAddress equ DrawChar+1
165B          SetColorAddress equ SetColor+1
165B          DrawCursorAddress equ DrawCursor+1
165B          OPCODE_NOP equ 0
165B          OPCODE_LD_DE_CONST equ 17
165B          OPCODE_LD_A_CONST equ 62
165B          OPCODE_LD_H_A equ 103
165B          OPCODE_LD_A_D equ 122
165B          OPCODE_LD_A_H equ 124
165B          OPCODE_XOR_A equ 175
165B          OPCODE_XOR_B equ 168
165B          OPCODE_JP equ 195
165B          OPCODE_RET equ 201
165B          OPCODE_SUB_CONST equ 214
165B          OPCODE_AND_CONST equ 230
165B          OPCODE_OR_CONST equ 246
165B          OPCODE_OUT equ 211
165B          OPCODE_JMP equ 195
font4:
165B 00 00 00  db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 255
 db 0
 db 255
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 170
 db 187
 db 34
 db 34
 db 34
 db 85
 db 0
 db 0
 db 85
 db 85
 db 0
 db 85
 db 85
 db 34
 db 0
 db 34
 db 34
 db 0
 db 34
 db 0
 db 34
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 85
 db 0
 db 85
 db 34
 db 85
 db 0
 db 0
 db 85
 db 34
 db 0
 db 0
 db 85
 db 34
 db 34
 db 0
 db 255
 db 0
 db 204
 db 51
 db 255
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 85
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 119
 db 119
 db 0
 db 0
 db 34
 db 34
 db 0
 db 255
 db 0
 db 255
 db 0
 db 0
 db 51
 db 51
 db 34
 db 0
 db 0
 db 34
 db 85
 db 51
 db 51
 db 0
 db 34
 db 34
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 85
 db 85
 db 85
 db 85
 db 34
 db 17
 db 17
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 34
 db 34
 db 34
 db 34
 db 17
 db 119
 db 34
 db 119
 db 34
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 34
 db 34
 db 102
 db 34
 db 102
 db 119
 db 119
 db 34
 db 85
 db 119
 db 17
 db 85
 db 68
 db 85
 db 85
 db 34
 db 102
 db 34
 db 102
 db 51
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 119
 db 51
 db 68
 db 51
 db 34
 db 0
 db 68
 db 0
 db 68
 db 0
 db 17
 db 0
 db 34
 db 0
 db 68
 db 34
 db 17
 db 68
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 34
 db 68
 db 0
 db 0
 db 51
 db 119
 db 102
 db 119
 db 51
 db 119
 db 119
 db 34
 db 85
 db 0
 db 85
 db 51
 db 85
 db 85
 db 34
 db 119
 db 102
 db 34
 db 119
 db 85
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 102
 db 85
 db 68
 db 102
 db 119
 db 51
 db 0
 db 51
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 85
 db 238
 db 34
 db 34
 db 34
 db 85
 db 0
 db 0
 db 85
 db 85
 db 0
 db 85
 db 85
 db 34
 db 0
 db 34
 db 34
 db 0
 db 34
 db 0
 db 34
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 85
 db 0
 db 85
 db 34
 db 85
 db 0
 db 0
 db 85
 db 34
 db 0
 db 0
 db 85
 db 34
 db 34
 db 0
 db 255
 db 0
 db 204
 db 51
 db 255
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 119
 db 85
 db 68
 db 17
 db 17
 db 34
 db 34
 db 0
 db 34
 db 0
 db 0
 db 17
 db 102
 db 102
 db 0
 db 0
 db 0
 db 85
 db 119
 db 85
 db 34
 db 119
 db 34
 db 0
 db 255
 db 0
 db 255
 db 51
 db 34
 db 34
 db 34
 db 119
 db 68
 db 17
 db 119
 db 85
 db 85
 db 68
 db 0
 db 119
 db 119
 db 34
 db 68
 db 34
 db 0
 db 0
 db 34
 db 0
 db 0
 db 68
 db 85
 db 85
 db 34
 db 17
 db 102
 db 17
 db 34
 db 17
 db 85
 db 34
 db 0
 db 0
 db 0
 db 17
 db 85
 db 102
 db 85
 db 85
 db 51
 db 68
 db 85
 db 17
 db 85
 db 85
 db 34
 db 34
 db 17
 db 0
 db 68
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 68
 db 68
 db 85
 db 85
 db 34
 db 17
 db 85
 db 68
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 68
 db 34
 db 85
 db 85
 db 85
 db 85
 db 85
 db 17
 db 34
 db 68
 db 17
 db 85
 db 0
 db 34
 db 0
 db 68
 db 0
 db 17
 db 0
 db 85
 db 0
 db 68
 db 0
 db 0
 db 68
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 34
 db 34
 db 0
 db 34
 db 85
 db 68
 db 85
 db 68
 db 85
 db 68
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 34
 db 85
 db 119
 db 85
 db 85
 db 85
 db 119
 db 119
 db 34
 db 85
 db 68
 db 17
 db 119
 db 85
 db 0
 db 68
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 170
 db 187
 db 34
 db 34
 db 34
 db 85
 db 0
 db 0
 db 85
 db 85
 db 0
 db 85
 db 85
 db 34
 db 0
 db 34
 db 34
 db 0
 db 34
 db 0
 db 34
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 85
 db 0
 db 85
 db 34
 db 85
 db 0
 db 0
 db 85
 db 34
 db 0
 db 0
 db 85
 db 34
 db 34
 db 0
 db 255
 db 0
 db 204
 db 51
 db 255
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 0
 db 34
 db 34
 db 34
 db 34
 db 34
 db 51
 db 85
 db 0
 db 0
 db 17
 db 85
 db 17
 db 0
 db 0
 db 0
 db 85
 db 119
 db 119
 db 34
 db 34
 db 119
 db 34
 db 153
 db 34
 db 153
 db 17
 db 85
 db 34
 db 51
 db 34
 db 102
 db 51
 db 34
 db 85
 db 85
 db 34
 db 0
 db 34
 db 34
 db 34
 db 102
 db 102
 db 0
 db 0
 db 119
 db 0
 db 0
 db 68
 db 85
 db 119
 db 85
 db 34
 db 119
 db 34
 db 34
 db 17
 db 34
 db 34
 db 0
 db 0
 db 0
 db 34
 db 85
 db 34
 db 17
 db 17
 db 51
 db 102
 db 68
 db 17
 db 85
 db 85
 db 34
 db 34
 db 34
 db 119
 db 34
 db 17
 db 119
 db 85
 db 85
 db 68
 db 85
 db 68
 db 68
 db 68
 db 85
 db 34
 db 17
 db 85
 db 68
 db 119
 db 119
 db 85
 db 85
 db 85
 db 85
 db 68
 db 34
 db 85
 db 85
 db 119
 db 85
 db 85
 db 34
 db 34
 db 34
 db 17
 db 0
 db 0
 db 17
 db 34
 db 102
 db 51
 db 51
 db 34
 db 68
 db 51
 db 102
 db 102
 db 17
 db 85
 db 34
 db 102
 db 102
 db 34
 db 102
 db 51
 db 102
 db 51
 db 102
 db 85
 db 85
 db 85
 db 85
 db 85
 db 119
 db 34
 db 34
 db 34
 db 0
 db 34
 db 85
 db 102
 db 85
 db 68
 db 85
 db 68
 db 119
 db 17
 db 119
 db 85
 db 85
 db 85
 db 119
 db 85
 db 85
 db 85
 db 85
 db 68
 db 34
 db 85
 db 119
 db 85
 db 85
 db 85
 db 119
 db 119
 db 34
 db 85
 db 68
 db 17
 db 119
 db 85
 db 34
 db 102
 db 102
 db 119
 db 51
 db 34
 db 119
 db 102
 db 85
 db 85
 db 85
 db 51
 db 85
 db 85
 db 34
 db 119
 db 17
 db 85
 db 238
 db 34
 db 34
 db 238
 db 85
 db 0
 db 238
 db 221
 db 85
 db 255
 db 221
 db 85
 db 238
 db 0
 db 34
 db 34
 db 0
 db 34
 db 0
 db 34
 db 51
 db 85
 db 85
 db 119
 db 221
 db 255
 db 85
 db 255
 db 221
 db 255
 db 85
 db 255
 db 0
 db 85
 db 51
 db 51
 db 0
 db 85
 db 255
 db 34
 db 0
 db 255
 db 0
 db 204
 db 51
 db 255
 db 102
 db 51
 db 119
 db 85
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 102
 db 85
 db 68
 db 102
 db 119
 db 51
 db 68
 db 34
 db 17
 db 68
 db 34
 db 34
 db 0
 db 102
 db 85
 db 0
 db 0
 db 17
 db 85
 db 34
 db 102
 db 0
 db 0
 db 85
 db 119
 db 119
 db 119
 db 119
 db 119
 db 119
 db 153
 db 85
 db 221
 db 51
 db 85
 db 34
 db 34
 db 119
 db 119
 db 119
 db 34
 db 85
 db 51
 db 85
 db 0
 db 34
 db 34
 db 34
 db 255
 db 255
 db 0
 db 85
 db 119
 db 119
 db 0
 db 68
 db 0
 db 85
 db 85
 db 34
 db 34
 db 0
 db 34
 db 17
 db 119
 db 119
 db 0
 db 119
 db 0
 db 34
 db 85
 db 34
 db 34
 db 34
 db 85
 db 85
 db 102
 db 17
 db 34
 db 51
 db 0
 db 0
 db 68
 db 0
 db 17
 db 34
 db 119
 db 85
 db 102
 db 68
 db 85
 db 102
 db 102
 db 68
 db 119
 db 34
 db 17
 db 102
 db 68
 db 85
 db 119
 db 85
 db 85
 db 85
 db 85
 db 34
 db 34
 db 85
 db 85
 db 119
 db 34
 db 34
 db 34
 db 34
 db 34
 db 17
 db 0
 db 0
 db 0
 db 17
 db 85
 db 68
 db 85
 db 85
 db 102
 db 85
 db 85
 db 34
 db 17
 db 85
 db 34
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 68
 db 68
 db 85
 db 85
 db 119
 db 85
 db 85
 db 17
 db 68
 db 0
 db 17
 db 51
 db 85
 db 85
 db 85
 db 102
 db 68
 db 85
 db 102
 db 34
 db 34
 db 119
 db 119
 db 102
 db 85
 db 85
 db 119
 db 85
 db 85
 db 85
 db 68
 db 34
 db 51
 db 119
 db 34
 db 85
 db 51
 db 119
 db 119
 db 51
 db 119
 db 102
 db 119
 db 119
 db 85
 db 17
 db 85
 db 85
 db 68
 db 85
 db 85
 db 119
 db 17
 db 119
 db 119
 db 85
 db 85
 db 119
 db 85
 db 85
 db 85
 db 68
 db 170
 db 187
 db 34
 db 238
 db 34
 db 221
 db 255
 db 34
 db 17
 db 85
 db 17
 db 17
 db 255
 db 34
 db 238
 db 51
 db 255
 db 255
 db 51
 db 255
 db 255
 db 34
 db 85
 db 68
 db 68
 db 0
 db 0
 db 68
 db 0
 db 0
 db 0
 db 255
 db 0
 db 255
 db 119
 db 34
 db 34
 db 119
 db 255
 db 34
 db 238
 db 51
 db 255
 db 0
 db 204
 db 51
 db 255
 db 85
 db 68
 db 34
 db 85
 db 119
 db 85
 db 85
 db 85
 db 119
 db 119
 db 34
 db 85
 db 68
 db 17
 db 119
 db 85
 db 102
 db 85
 db 34
 db 34
 db 34
 db 34
 db 119
 db 0
 db 34
 db 102
 db 34
 db 34
 db 85
 db 119
 db 102
 db 0
 db 0
 db 85
 db 119
 db 119
 db 119
 db 119
 db 119
 db 119
 db 153
 db 85
 db 221
 db 85
 db 34
 db 34
 db 34
 db 34
 db 102
 db 51
 db 34
 db 85
 db 51
 db 85
 db 0
 db 34
 db 34
 db 34
 db 102
 db 102
 db 68
 db 119
 db 119
 db 119
 db 0
 db 68
 db 0
 db 119
 db 85
 db 34
 db 85
 db 0
 db 34
 db 17
 db 34
 db 34
 db 0
 db 0
 db 0
 db 34
 db 85
 db 34
 db 34
 db 17
 db 119
 db 17
 db 85
 db 34
 db 85
 db 17
 db 0
 db 0
 db 34
 db 119
 db 34
 db 34
 db 119
 db 119
 db 85
 db 68
 db 85
 db 68
 db 68
 db 85
 db 85
 db 34
 db 85
 db 85
 db 68
 db 85
 db 119
 db 85
 db 102
 db 119
 db 102
 db 17
 db 34
 db 85
 db 85
 db 119
 db 85
 db 34
 db 34
 db 34
 db 34
 db 17
 db 0
 db 0
 db 0
 db 51
 db 85
 db 68
 db 85
 db 119
 db 68
 db 85
 db 85
 db 34
 db 17
 db 102
 db 34
 db 119
 db 85
 db 85
 db 85
 db 85
 db 68
 db 34
 db 68
 db 85
 db 85
 db 119
 db 34
 db 85
 db 34
 db 34
 db 34
 db 34
 db 102
 db 85
 db 119
 db 85
 db 85
 db 68
 db 85
 db 68
 db 119
 db 17
 db 119
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 102
 db 68
 db 34
 db 17
 db 119
 db 85
 db 85
 db 17
 db 119
 db 119
 db 51
 db 119
 db 85
 db 17
 db 119
 db 51
 db 51
 db 85
 db 102
 db 68
 db 85
 db 119
 db 34
 db 34
 db 119
 db 119
 db 102
 db 85
 db 119
 db 119
 db 85
 db 85
 db 17
 db 85
 db 238
 db 34
 db 34
 db 238
 db 85
 db 85
 db 238
 db 221
 db 85
 db 221
 db 255
 db 0
 db 238
 db 34
 db 0
 db 0
 db 34
 db 34
 db 0
 db 34
 db 51
 db 85
 db 119
 db 85
 db 255
 db 221
 db 85
 db 255
 db 221
 db 255
 db 0
 db 255
 db 85
 db 0
 db 51
 db 51
 db 85
 db 85
 db 255
 db 0
 db 34
 db 255
 db 255
 db 204
 db 51
 db 0
 db 85
 db 68
 db 34
 db 85
 db 119
 db 34
 db 85
 db 51
 db 119
 db 119
 db 51
 db 119
 db 102
 db 119
 db 119
 db 51
 db 68
 db 119
 db 68
 db 17
 db 34
 db 34
 db 0
 db 51
 db 0
 db 102
 db 0
 db 34
 db 0
 db 0
 db 102
 db 0
 db 0
 db 85
 db 119
 db 34
 db 34
 db 34
 db 34
 db 34
 db 153
 db 34
 db 153
 db 85
 db 119
 db 102
 db 102
 db 119
 db 68
 db 17
 db 119
 db 0
 db 51
 db 34
 db 119
 db 119
 db 34
 db 119
 db 68
 db 34
 db 68
 db 85
 db 0
 db 119
 db 0
 db 0
 db 0
 db 85
 db 34
 db 68
 db 85
 db 0
 db 34
 db 17
 db 85
 db 34
 db 34
 db 0
 db 34
 db 68
 db 85
 db 34
 db 68
 db 85
 db 17
 db 85
 db 85
 db 34
 db 85
 db 85
 db 34
 db 34
 db 17
 db 0
 db 68
 db 0
 db 68
 db 85
 db 85
 db 85
 db 85
 db 68
 db 68
 db 85
 db 85
 db 34
 db 85
 db 85
 db 68
 db 85
 db 85
 db 85
 db 68
 db 119
 db 85
 db 17
 db 34
 db 85
 db 34
 db 119
 db 85
 db 34
 db 68
 db 34
 db 17
 db 17
 db 0
 db 0
 db 0
 db 85
 db 85
 db 68
 db 85
 db 68
 db 68
 db 85
 db 85
 db 34
 db 85
 db 85
 db 34
 db 119
 db 85
 db 85
 db 85
 db 85
 db 68
 db 17
 db 85
 db 85
 db 85
 db 119
 db 85
 db 85
 db 68
 db 34
 db 34
 db 34
 db 0
 db 85
 db 85
 db 85
 db 85
 db 68
 db 85
 db 68
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 68
 db 85
 db 34
 db 85
 db 34
 db 85
 db 85
 db 17
 db 119
 db 119
 db 51
 db 119
 db 85
 db 17
 db 119
 db 85
 db 85
 db 85
 db 85
 db 68
 db 85
 db 68
 db 119
 db 17
 db 119
 db 119
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 68
 db 170
 db 187
 db 34
 db 34
 db 34
 db 85
 db 85
 db 34
 db 85
 db 85
 db 85
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 34
 db 34
 db 0
 db 34
 db 34
 db 85
 db 0
 db 85
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 0
 db 34
 db 85
 db 0
 db 0
 db 34
 db 85
 db 85
 db 34
 db 0
 db 34
 db 255
 db 255
 db 204
 db 51
 db 0
 db 85
 db 68
 db 34
 db 85
 db 119
 db 85
 db 85
 db 17
 db 119
 db 119
 db 51
 db 119
 db 85
 db 17
 db 119
 db 85
 db 68
 db 68
 db 0
 db 0
 db 34
 db 34
 db 34
 db 102
 db 0
 db 0
 db 0
 db 102
 db 0
 db 0
 db 102
 db 0
 db 0
 db 119
 db 119
 db 34
 db 34
 db 119
 db 119
 db 0
 db 255
 db 0
 db 255
 db 34
 db 34
 db 102
 db 102
 db 34
 db 0
 db 0
 db 34
 db 85
 db 51
 db 17
 db 119
 db 34
 db 34
 db 34
 db 0
 db 0
 db 119
 db 0
 db 0
 db 34
 db 0
 db 68
 db 0
 db 85
 db 85
 db 85
 db 51
 db 0
 db 17
 db 34
 db 0
 db 0
 db 34
 db 0
 db 34
 db 68
 db 34
 db 119
 db 119
 db 34
 db 17
 db 34
 db 34
 db 34
 db 34
 db 34
 db 34
 db 34
 db 0
 db 0
 db 0
 db 34
 db 51
 db 85
 db 102
 db 34
 db 102
 db 119
 db 68
 db 51
 db 85
 db 119
 db 34
 db 85
 db 119
 db 85
 db 85
 db 34
 db 68
 db 51
 db 85
 db 102
 db 34
 db 34
 db 34
 db 34
 db 85
 db 34
 db 119
 db 51
 db 17
 db 51
 db 0
 db 0
 db 0
 db 51
 db 102
 db 51
 db 51
 db 51
 db 68
 db 51
 db 85
 db 119
 db 85
 db 85
 db 17
 db 119
 db 85
 db 34
 db 102
 db 51
 db 68
 db 102
 db 34
 db 51
 db 34
 db 34
 db 85
 db 51
 db 119
 db 17
 db 34
 db 68
 db 0
 db 119
 db 85
 db 102
 db 102
 db 68
 db 255
 db 119
 db 119
 db 34
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 34
 db 85
 db 68
 db 34
 db 34
 db 34
 db 34
 db 85
 db 119
 db 17
 db 119
 db 119
 db 51
 db 119
 db 102
 db 102
 db 119
 db 85
 db 51
 db 34
 db 102
 db 68
 db 255
 db 51
 db 119
 db 102
 db 85
 db 85
 db 85
 db 85
 db 85
 db 85
 db 34
 db 85
 db 17
 db 85
 db 238
 db 34
 db 34
 db 34
 db 85
 db 85
 db 34
 db 85
 db 85
 db 85
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 34
 db 34
 db 0
 db 34
 db 34
 db 85
 db 0
 db 85
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 0
 db 34
 db 85
 db 0
 db 0
 db 34
 db 85
 db 85
 db 34
 db 0
 db 34
 db 255
 db 255
 db 204
 db 51
 db 0
 db 102
 db 51
 db 34
 db 51
 db 119
 db 85
 db 119
 db 17
 db 119
 db 119
 db 51
 db 119
 db 102
 db 102
 db 119
 db 85
 db 119
 db 51
 db 119
 db 119
 db 34
 db 68
 db 34
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 255
 db 0
 db 255
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 102
 db 0
 db 119
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 119
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 153
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 17
 db 0
 db 0
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 153
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 170
 db 187
 db 34
 db 34
 db 34
 db 85
 db 85
 db 34
 db 85
 db 85
 db 85
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 34
 db 34
 db 0
 db 34
 db 34
 db 85
 db 0
 db 85
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 0
 db 34
 db 85
 db 0
 db 0
 db 34
 db 85
 db 85
 db 34
 db 0
 db 34
 db 255
 db 255
 db 204
 db 51
 db 0
 db 68
 db 0
 db 0
 db 17
 db 34
 db 0
 db 17
 db 0
 db 0
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 255
 db 0
 db 255
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 102
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 68
 db 17
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 102
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 85
 db 238
 db 34
 db 34
 db 34
 db 85
 db 85
 db 34
 db 85
 db 85
 db 85
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 34
 db 34
 db 0
 db 34
 db 34
 db 85
 db 0
 db 85
 db 0
 db 85
 db 85
 db 0
 db 85
 db 0
 db 0
 db 34
 db 85
 db 0
 db 0
 db 34
 db 85
 db 85
 db 34
 db 0
 db 34
 db 255
 db 255
 db 204
 db 51
 db 0
 db 68
 db 0
 db 0
 db 102
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 34
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
DrawChar4:
205B 47        ld b, a
205C 7D        ld a, l
205D 87        add a
205E 87        add a
205F 85        add l
2060 87        add a
2061 2F        cpl
2062 5F        ld e, a
2063 7C        ld a, h
2064 4F        ld c, a
2065 B7        or a
2066 1F        rra
2067 2F        cpl
2068 57        ld d, a
2069 78        ld a, b
206A C6 5B     add font4
206C 6F        ld l, a
206D CE 16     adc font4>>8
206F 95        sub l
2070 67        ld h, a
2071 79        ld a, c
2072 E6 01     and 1
2074 C2 9E 20  jp nz, DrawChar40
DrawChar44:
2077 0E 0A     ld c, FONT_HEIGHT
_l268:
2079 7E        ld a, (hl)
207A E6 F0     and 240
207C 47        ld b, a
207D 1A        ld a, (de)
DrawChar4a_And1:
207E E6 0F     and 15
DrawChar4a_Xor1:
2080 A8        xor b
2081 12        ld (de), a
2082 1D        dec e
2083 24        inc h
_l270:
2084 0D        dec c
2085 C2 79 20  jp nz, _l268
_l269:
DrawChar4a:
2088 7A        ld a, d
2089 D6 40     sub 64
208B 57        ld d, a
208C 0E 0A     ld c, FONT_HEIGHT
_l274:
208E 25        dec h
208F 1C        inc e
2090 7E        ld a, (hl)
2091 E6 F0     and 240
2093 47        ld b, a
2094 1A        ld a, (de)
DrawChar4a_And2:
2095 E6 0F     and 15
DrawChar4a_Xor2:
2097 A8        xor b
2098 12        ld (de), a
_l276:
2099 0D        dec c
209A C2 8E 20  jp nz, _l274
_l275:
209D C9        ret
DrawChar40:
209E 0E 0A     ld c, FONT_HEIGHT
_l280:
20A0 7E        ld a, (hl)
20A1 E6 0F     and 15
20A3 47        ld b, a
20A4 1A        ld a, (de)
DrawChar4b_And1:
20A5 E6 F0     and 240
DrawChar4b_Xor1:
20A7 A8        xor b
20A8 12        ld (de), a
20A9 1D        dec e
20AA 24        inc h
_l282:
20AB 0D        dec c
20AC C2 A0 20  jp nz, _l280
_l281:
DrawChar4b:
20AF 7A        ld a, d
20B0 D6 40     sub 64
20B2 57        ld d, a
20B3 0E 0A     ld c, FONT_HEIGHT
_l286:
20B5 25        dec h
20B6 1C        inc e
20B7 7E        ld a, (hl)
20B8 E6 0F     and 15
20BA 47        ld b, a
20BB 1A        ld a, (de)
DrawChar4b_And2:
20BC E6 F0     and 240
DrawChar4b_Xor2:
20BE A8        xor b
20BF 12        ld (de), a
_l288:
20C0 0D        dec c
20C1 C2 B5 20  jp nz, _l286
_l287:
20C4 C9        ret
SetColor4:
20C5 4F        ld c, a
20C6 E6 04     and 4
20C8 C2 D9 20  jp nz, _l292
20CB 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
20CE 22 7E 20  ld (DrawChar4a_And1), hl
20D1 26 F0     ld h, 240
20D3 22 A5 20  ld (DrawChar4b_And1), hl
20D6 C3 E4 20  jp _l293
_l292:
20D9 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
20DC 22 7E 20  ld (DrawChar4a_And1), hl
20DF 26 0F     ld h, 15
20E1 22 A5 20  ld (DrawChar4b_And1), hl
_l293:
20E4 47        ld b, a
20E5 79        ld a, c
20E6 87        add a
20E7 87        add a
20E8 E6 04     and 4
20EA A8        xor b
20EB 3E A8     ld a, OPCODE_XOR_B
20ED C2 F2 20  jp nz, _l294
20F0 3E 00     ld a, OPCODE_NOP
_l294:
20F2 32 80 20  ld (DrawChar4a_Xor1), a
20F5 32 A7 20  ld (DrawChar4b_Xor1), a
20F8 79        ld a, c
20F9 E6 08     and 8
20FB C2 0C 21  jp nz, _l295
20FE 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
2101 22 95 20  ld (DrawChar4a_And2), hl
2104 26 F0     ld h, 240
2106 22 BC 20  ld (DrawChar4b_And2), hl
2109 C3 17 21  jp _l296
_l295:
210C 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
210F 22 95 20  ld (DrawChar4a_And2), hl
2112 26 0F     ld h, 15
2114 22 BC 20  ld (DrawChar4b_And2), hl
_l296:
2117 47        ld b, a
2118 79        ld a, c
2119 87        add a
211A 87        add a
211B E6 08     and 8
211D A8        xor b
211E 3E A8     ld a, OPCODE_XOR_B
2120 C2 25 21  jp nz, _l297
2123 3E 00     ld a, OPCODE_NOP
_l297:
2125 32 97 20  ld (DrawChar4a_Xor2), a
2128 32 BE 20  ld (DrawChar4b_Xor2), a
212B C9        ret
DrawCursor4:
212C 7C        ld a, h
212D B7        or a
212E 1F        rra
212F 2F        cpl
2130 57        ld d, a
2131 7D        ld a, l
2132 87        add a
2133 87        add a
2134 85        add l
2135 87        add a
2136 2F        cpl
2137 5F        ld e, a
2138 7C        ld a, h
2139 E6 01     and 1
213B 06 0F     ld b, 15
213D C2 42 21  jp nz, _l299
2140 06 F0     ld b, 240
_l299:
2142 0E 0A     ld c, FONT_HEIGHT
_l300:
2144 1A        ld a, (de)
2145 A8        xor b
2146 12        ld (de), a
2147 1D        dec e
_l302:
2148 0D        dec c
2149 C2 44 21  jp nz, _l300
_l301:
214C C9        ret
SetScreenBw4:
214D 3E 60     ld a, 96
214F 32 9C 08  ld (text_screen_width), a
2152 21 C5 20  ld hl, SetColor4
2155 22 A1 08  ld (SetColorAddress), hl
2158 21 5B 20  ld hl, DrawChar4
215B 22 9E 08  ld (DrawCharAddress), hl
215E 21 2C 21  ld hl, DrawCursor4
2161 22 A4 08  ld (DrawCursorAddress), hl
2164 3E C9     ld a, OPCODE_RET
2166 32 88 20  ld (DrawChar4a), a
2169 32 AF 20  ld (DrawChar4b), a
216C C3 F0 0B  jp SetScreenBw
SetScreenColor4:
216F 3E 60     ld a, 96
2171 32 9C 08  ld (text_screen_width), a
2174 21 C5 20  ld hl, SetColor4
2177 22 A1 08  ld (SetColorAddress), hl
217A 21 5B 20  ld hl, DrawChar4
217D 22 9E 08  ld (DrawCharAddress), hl
2180 21 2C 21  ld hl, DrawCursor4
2183 22 A4 08  ld (DrawCursorAddress), hl
2186 3E 7A     ld a, OPCODE_LD_A_D
2188 32 88 20  ld (DrawChar4a), a
218B 32 AF 20  ld (DrawChar4b), a
218E C3 35 0C  jp SetScreenColor
2191          MOD_CTR equ 1
2191          MOD_SHIFT equ 2
2191          MOD_CAPS equ 16
2191          MOD_NUM equ 32
2191          SCREEN_0_ADDRESS equ 53248
2191          SCREEN_1_ADDRESS equ 36864
2191          PALETTE_WHITE equ 0
2191          PALETTE_CYAN equ 1
2191          PALETTE_MAGENTA equ 2
2191          PALETTE_BLUE equ 3
2191          PALETTE_YELLOW equ 4
2191          PALETTE_GREEN equ 5
2191          PALETTE_RED equ 6
2191          PALETTE_XXX equ 7
2191          PALETTE_GRAY equ 8
2191          PALETTE_DARK_CYAN equ 9
2191          PALETTE_DARK_MAGENTA equ 10
2191          PALETTE_DARK_BLUE equ 11
2191          PALETTE_DARK_YELLOW equ 12
2191          PALETTE_DARK_GREEN equ 13
2191          PALETTE_DARK_RED equ 14
2191          PALETTE_BLACK equ 15
2191          KEY_BACKSPACE equ 8
2191          KEY_TAB equ 9
2191          KEY_ENTER equ 13
2191          KEY_ESC equ 27
2191          KEY_ALT equ 1
2191          KEY_F1 equ 242
2191          KEY_F2 equ 243
2191          KEY_F3 equ 244
2191          KEY_UP equ 245
2191          KEY_DOWN equ 246
2191          KEY_RIGHT equ 247
2191          KEY_LEFT equ 248
2191          KEY_EXT_5 equ 249
2191          KEY_END equ 250
2191          KEY_HOME equ 251
2191          KEY_INSERT equ 252
2191          KEY_DEL equ 253
2191          KEY_PG_UP equ 254
2191          KEY_PG_DN equ 255
2191          PORT_FRAME_IRQ_RESET equ 4
2191          PORT_SD_SIZE equ 9
2191          PORT_SD_RESULT equ 9
2191          PORT_SD_DATA equ 8
2191          PORT_UART_DATA equ 128
2191          PORT_UART_CONFIG equ 129
2191          PORT_UART_STATE equ 129
2191          PORT_EXT_DATA_OUT equ 136
2191          PORT_PALETTE_3 equ 144
2191          PORT_PALETTE_2 equ 145
2191          PORT_PALETTE_1 equ 146
2191          PORT_PALETTE_0 equ 147
2191          PORT_EXT_IN_DATA equ 137
2191          PORT_A0 equ 160
2191          PORT_ROM_0000 equ 168
2191          PORT_ROM_0000__ROM equ 0
2191          PORT_ROM_0000__RAM equ 128
2191          PORT_VIDEO_MODE_1_LOW equ 185
2191          PORT_VIDEO_MODE_1_HIGH equ 249
2191          PORT_VIDEO_MODE_0_LOW equ 184
2191          PORT_VIDEO_MODE_0_HIGH equ 248
2191          PORT_UART_SPEED_0 equ 187
2191          PORT_KEYBOARD equ 192
2191          PORT_UART_SPEED_1 equ 251
2191          PORT_CODE_ROM equ 186
2191          PORT_CHARGEN_ROM equ 250
2191          PORT_TAPE_AND_IDX2 equ 153
2191          PORT_TAPE_AND_IDX2_ID1_2 equ 2
2191          PORT_TAPE_AND_IDX2_ID2_2 equ 4
2191          PORT_TAPE_AND_IDX2_ID3_2 equ 8
2191          PORT_TAPE_AND_IDX2_ID6_2 equ 64
2191          PORT_TAPE_AND_IDX2_ID7_2 equ 128
2191          PORT_RESET_CU1 equ 188
2191          PORT_RESET_CU2 equ 189
2191          PORT_RESET_CU3 equ 190
2191          PORT_RESET_CU4 equ 191
2191          PORT_SET_CU1 equ 252
2191          PORT_SET_CU2 equ 253
2191          PORT_SET_CU3 equ 254
2191          PORT_SET_CU4 equ 255
2191          PORT_TAPE_OUT equ 176
2191          SD_COMMAND_READ equ 1
2191          SD_COMMAND_READ_SIZE equ 5
2191          SD_COMMAND_WRITE equ 2
2191          SD_COMMAND_WRITE_SIZE equ 5+128
2191          SD_RESULT_BUSY equ 255
2191          SD_RESULT_OK equ 0
2191          stack equ 256
2191          entry_cpm_conout_address equ EntryCpmConout+1
2191          cpm_dph_a equ 65376
2191          cpm_dph_b equ 65392
2191          cpm_dma_buffer equ 65408
2191          TEXT_SCREEN_HEIGHT equ 25
2191          FONT_HEIGHT equ 10
2191          FONT_WIDTH equ 3
2191          DrawCharAddress equ DrawChar+1
2191          SetColorAddress equ SetColor+1
2191          DrawCursorAddress equ DrawCursor+1
2191          NEXT_REPLAY_DELAY equ 3
2191          FIRST_REPLAY_DELAY equ 30
2191          SCAN_LAT equ 25
2191          SCAN_RUS equ 24
2191          SCAN_CAP equ 30
2191          SCAN_NUM equ 28
2191          LAYOUT_SIZE equ 80
2191          CURSOR_BLINK_PERIOD equ 35
frame_counter:
2191 00        db 0
key_leds:
2192 20        db MOD_NUM
key_pressed:
2193 00        db 0
key_delay:
2194 00        db 0
key_rus:
2195 00        db 0
key_read:
2196 45        db key_buffer
key_write:
2197 45        db key_buffer
2198          key_read_l_write_h equ key_read
2198          SHI equ 64
2198          CAP equ 128
2198          NUM equ 32
shiftLayout:
2198 40        db SHI
2199 80        db CAP
219A 80        db CAP
219B 80        db CAP
219C 40        db SHI
219D 80        db CAP
219E 80        db CAP
219F 40        db SHI
21A0 40        db SHI
21A1 80        db CAP
21A2 80        db CAP
21A3 80        db CAP
21A4 40        db SHI
21A5 80        db CAP
21A6 80        db CAP
21A7 40        db SHI
21A8 40        db SHI
21A9 80        db CAP
21AA 80        db CAP
21AB 80        db CAP
21AC 40        db SHI
21AD 80        db CAP
21AE 40        db SHI
21AF 40        db SHI
21B0 00        db 0
21B1 00        db 0
21B2 00        db 0
21B3 00        db 0
21B4 00        db 0
21B5 00        db 0
21B6 00        db 0
21B7 00        db 0
21B8 40        db SHI
21B9 80        db CAP
21BA 80        db CAP
21BB 80        db CAP
21BC 40        db SHI
21BD 40        db SHI
21BE 40        db SHI
21BF 40        db SHI
21C0 40        db SHI
21C1 80        db CAP
21C2 80        db CAP
21C3 80        db CAP
21C4 40        db SHI
21C5 40        db SHI
21C6 40        db SHI
21C7 40        db SHI
21C8 40        db SHI
21C9 20        db NUM
21CA 80        db CAP
21CB 80        db CAP
21CC 40        db SHI
21CD 40        db SHI
21CE 40        db SHI
21CF 20        db NUM
21D0 00        db 0
21D1 80        db CAP
21D2 80        db CAP
21D3 80        db CAP
21D4 00        db 0
21D5 20        db NUM
21D6 20        db NUM
21D7 20        db NUM
21D8 00        db 0
21D9 80        db CAP
21DA 00        db 0
21DB 00        db 0
21DC 40        db SHI
21DD 20        db NUM
21DE 20        db NUM
21DF 20        db NUM
21E0 00        db 0
21E1 00        db 0
21E2 00        db 0
21E3 00        db 0
21E4 00        db 0
21E5 20        db NUM
21E6 20        db NUM
21E7 20        db NUM
21E8 40        db SHI
21E9 80        db CAP
21EA 80        db CAP
21EB 80        db CAP
21EC 40        db SHI
21ED 80        db CAP
21EE 80        db CAP
21EF 80        db CAP
21F0 40        db SHI
21F1 80        db CAP
21F2 80        db CAP
21F3 80        db CAP
21F4 40        db SHI
21F5 80        db CAP
21F6 80        db CAP
21F7 80        db CAP
21F8 40        db SHI
21F9 80        db CAP
21FA 80        db CAP
21FB 80        db CAP
21FC 40        db SHI
21FD 80        db CAP
21FE 80        db CAP
21FF 80        db CAP
2200 00        db 0
2201 00        db 0
2202 00        db 0
2203 00        db 0
2204 00        db 0
2205 00        db 0
2206 00        db 0
2207 00        db 0
2208 40        db SHI
2209 80        db CAP
220A 80        db CAP
220B 80        db CAP
220C 40        db SHI
220D 80        db CAP
220E 80        db CAP
220F 40        db SHI
2210 40        db SHI
2211 80        db CAP
2212 80        db CAP
2213 80        db CAP
2214 40        db SHI
2215 80        db CAP
2216 40        db SHI
2217 40        db SHI
2218 40        db SHI
2219 20        db NUM
221A 80        db CAP
221B 80        db CAP
221C 40        db SHI
221D 40        db SHI
221E 40        db SHI
221F 20        db NUM
2220 00        db 0
2221 80        db CAP
2222 80        db CAP
2223 80        db CAP
2224 00        db 0
2225 20        db NUM
2226 20        db NUM
2227 20        db NUM
2228 00        db 0
2229 80        db CAP
222A 00        db 0
222B 00        db 0
222C 40        db SHI
222D 20        db NUM
222E 20        db NUM
222F 20        db NUM
2230 00        db 0
2231 00        db 0
2232 00        db 0
2233 00        db 0
2234 00        db 0
2235 20        db NUM
2236 20        db NUM
2237 20        db NUM
ctrLayout:
2238 1E        db 30
2239 15        db 117&31
223A 0A        db 106&31
223B 0D        db 109&31
223C 1F        db 31
223D 09        db 105&31
223E 0B        db 107&31
223F 00        db 96&31
2240 1D        db 29
2241 19        db 121&31
2242 08        db 104&31
2243 0E        db 110&31
2244 08        db 8
2245 0F        db 111&31
2246 0C        db 108&31
2247 00        db 64&31
2248 1C        db 28
2249 14        db 116&31
224A 07        db 103&31
224B 02        db 98&31
224C 39        db 57
224D 10        db 112&31
224E 1B        db 91&31
224F 3F        db 63
2250 3F        db 63
2251 3F        db 63
2252 01        db KEY_ALT
2253 3F        db 63
2254 3F        db 63
2255 08        db KEY_BACKSPACE
2256 3F        db 63
2257 00        db 32&31
2258 1B        db 27
2259 12        db 114&31
225A 06        db 102&31
225B 16        db 118&31
225C 00        db 0
225D 1B        db 123&31
225E 1D        db 93&31
225F 2C        db 44
2260 00        db 0
2261 05        db 101&31
2262 04        db 100&31
2263 03        db 99&31
2264 1F        db 95&31
2265 1D        db 125&31
2266 3A        db 58
2267 2E        db 46
2268 31        db 49
2269 2E        db 46
226A 01        db 97&31
226B 1A        db 122&31
226C 1E        db 94&31
226D 0F        db 47&31
226E 3B        db 59
226F 30        db 48
2270 3F        db 63
2271 17        db 119&31
2272 13        db 115&31
2273 18        db 120&31
2274 3F        db 63
2275 37        db 55
2276 34        db 52
2277 31        db 49
2278 0A        db 10
2279 11        db 113&31
227A 09        db KEY_TAB
227B 3F        db 63
227C 1C        db 92&31
227D 38        db 56
227E 35        db 53
227F 32        db 50
2280 F4        db KEY_F3
2281 3F        db 63
2282 F2        db KEY_F1
2283 F3        db KEY_F2
2284 1B        db KEY_ESC
2285 39        db 57
2286 36        db 54
2287 33        db 51
key_layout_table:
2288 36        db 54
2289 75        db 117
228A 6A        db 106
228B 6D        db 109
228C 37        db 55
228D 69        db 105
228E 6B        db 107
228F 60        db 96
2290 35        db 53
2291 79        db 121
2292 68        db 104
2293 6E        db 110
2294 38        db 56
2295 6F        db 111
2296 6C        db 108
2297 40        db 64
2298 34        db 52
2299 74        db 116
229A 67        db 103
229B 62        db 98
229C 39        db 57
229D 70        db 112
229E 5B        db 91
229F 00        db 0
22A0 00        db 0
22A1 00        db 0
22A2 01        db KEY_ALT
22A3 00        db 0
22A4 00        db 0
22A5 08        db KEY_BACKSPACE
22A6 00        db 0
22A7 20        db 32
22A8 33        db 51
22A9 72        db 114
22AA 66        db 102
22AB 76        db 118
22AC 30        db 48
22AD 7B        db 123
22AE 5D        db 93
22AF 2C        db 44
22B0 32        db 50
22B1 65        db 101
22B2 64        db 100
22B3 63        db 99
22B4 2D        db 45
22B5 7D        db 125
22B6 3A        db 58
22B7 2E        db 46
22B8 31        db 49
22B9 FD        db KEY_DEL
22BA 61        db 97
22BB 7A        db 122
22BC 5E        db 94
22BD 2F        db 47
22BE 3B        db 59
22BF FC        db KEY_INSERT
22C0 00        db 0
22C1 77        db 119
22C2 73        db 115
22C3 78        db 120
22C4 FD        db KEY_DEL
22C5 FB        db KEY_HOME
22C6 F8        db KEY_LEFT
22C7 FA        db KEY_END
22C8 0D        db KEY_ENTER
22C9 71        db 113
22CA 09        db KEY_TAB
22CB 00        db 0
22CC 5C        db 92
22CD F5        db KEY_UP
22CE F9        db KEY_EXT_5
22CF F6        db KEY_DOWN
22D0 F4        db KEY_F3
22D1 00        db 0
22D2 F2        db KEY_F1
22D3 F3        db KEY_F2
22D4 1B        db KEY_ESC
22D5 FE        db KEY_PG_UP
22D6 F7        db KEY_RIGHT
22D7 FF        db KEY_PG_DN
22D8 26        db 38
22D9 55        db 85
22DA 4A        db 74
22DB 4D        db 77
22DC 27        db 39
22DD 49        db 73
22DE 4B        db 75
22DF 60        db 96
22E0 25        db 37
22E1 59        db 89
22E2 48        db 72
22E3 4E        db 78
22E4 28        db 40
22E5 4F        db 79
22E6 4C        db 76
22E7 40        db 64
22E8 24        db 36
22E9 54        db 84
22EA 47        db 71
22EB 42        db 66
22EC 29        db 41
22ED 50        db 80
22EE 5B        db 91
22EF 00        db 0
22F0 00        db 0
22F1 00        db 0
22F2 01        db KEY_ALT
22F3 00        db 0
22F4 00        db 0
22F5 08        db KEY_BACKSPACE
22F6 00        db 0
22F7 20        db 32
22F8 23        db 35
22F9 52        db 82
22FA 46        db 70
22FB 56        db 86
22FC 5F        db 95
22FD 7B        db 123
22FE 5D        db 93
22FF 3C        db 60
2300 22        db 34
2301 45        db 69
2302 44        db 68
2303 43        db 67
2304 3D        db 61
2305 7D        db 125
2306 2A        db 42
2307 3E        db 62
2308 21        db 33
2309 2E        db 46
230A 41        db 65
230B 5A        db 90
230C 7E        db 126
230D 3F        db 63
230E 2B        db 43
230F 30        db 48
2310 00        db 0
2311 57        db 87
2312 53        db 83
2313 58        db 88
2314 FD        db KEY_DEL
2315 37        db 55
2316 34        db 52
2317 31        db 49
2318 0D        db KEY_ENTER
2319 51        db 81
231A 09        db KEY_TAB
231B 00        db 0
231C 7C        db 124
231D 38        db 56
231E 35        db 53
231F 32        db 50
2320 F4        db KEY_F3
2321 00        db 0
2322 F2        db KEY_F1
2323 F3        db KEY_F2
2324 1B        db KEY_ESC
2325 39        db 57
2326 36        db 54
2327 33        db 51
2328 36        db 54
2329 A3        db 163
232A AE        db 174
232B EC        db 236
232C 37        db 55
232D E8        db 232
232E AB        db 171
232F A1        db 161
2330 35        db 53
2331 AD        db 173
2332 E0        db 224
2333 E2        db 226
2334 38        db 56
2335 E9        db 233
2336 A4        db 164
2337 EE        db 238
2338 34        db 52
2339 A5        db 165
233A AF        db 175
233B A8        db 168
233C 39        db 57
233D A7        db 167
233E A6        db 166
233F F1        db 241
2340 00        db 0
2341 00        db 0
2342 01        db KEY_ALT
2343 00        db 0
2344 00        db 0
2345 08        db KEY_BACKSPACE
2346 00        db 0
2347 20        db 32
2348 33        db 51
2349 AA        db 170
234A A0        db 160
234B AC        db 172
234C 30        db 48
234D E5        db 229
234E ED        db 237
234F 2C        db 44
2350 32        db 50
2351 E3        db 227
2352 A2        db 162
2353 E1        db 225
2354 2D        db 45
2355 EA        db 234
2356 3A        db 58
2357 2E        db 46
2358 31        db 49
2359 FD        db KEY_DEL
235A E4        db 228
235B EF        db 239
235C 5E        db 94
235D 2F        db 47
235E 3B        db 59
235F FC        db KEY_INSERT
2360 00        db 0
2361 E6        db 230
2362 EB        db 235
2363 E7        db 231
2364 FD        db KEY_DEL
2365 FB        db KEY_HOME
2366 F8        db KEY_LEFT
2367 FA        db KEY_END
2368 0D        db KEY_ENTER
2369 A9        db 169
236A 09        db KEY_TAB
236B 00        db 0
236C 5C        db 92
236D F5        db KEY_UP
236E F9        db KEY_EXT_5
236F F6        db KEY_DOWN
2370 F4        db KEY_F3
2371 00        db 0
2372 F2        db KEY_F1
2373 F3        db KEY_F2
2374 1B        db KEY_ESC
2375 FE        db KEY_PG_UP
2376 F7        db KEY_RIGHT
2377 FF        db KEY_PG_DN
2378 26        db 38
2379 83        db 131
237A 8E        db 142
237B 9C        db 156
237C 27        db 39
237D 98        db 152
237E 8B        db 139
237F 81        db 129
2380 25        db 37
2381 8D        db 141
2382 90        db 144
2383 92        db 146
2384 28        db 40
2385 99        db 153
2386 84        db 132
2387 9E        db 158
2388 24        db 36
2389 85        db 133
238A 8F        db 143
238B 88        db 136
238C 29        db 41
238D 58        db 88
238E 86        db 134
238F F0        db 240
2390 00        db 0
2391 00        db 0
2392 01        db KEY_ALT
2393 00        db 0
2394 00        db 0
2395 08        db KEY_BACKSPACE
2396 00        db 0
2397 20        db 32
2398 23        db 35
2399 8A        db 138
239A 80        db 128
239B 8C        db 140
239C 5F        db 95
239D 58        db 88
239E 9D        db 157
239F 3C        db 60
23A0 22        db 34
23A1 93        db 147
23A2 82        db 130
23A3 91        db 145
23A4 3D        db 61
23A5 9A        db 154
23A6 2A        db 42
23A7 3E        db 62
23A8 21        db 33
23A9 2E        db 46
23AA 94        db 148
23AB 9F        db 159
23AC 7E        db 126
23AD 3F        db 63
23AE 2B        db 43
23AF 30        db 48
23B0 00        db 0
23B1 96        db 150
23B2 9B        db 155
23B3 97        db 151
23B4 FD        db KEY_DEL
23B5 37        db 55
23B6 34        db 52
23B7 31        db 49
23B8 0D        db KEY_ENTER
23B9 89        db 137
23BA 09        db KEY_TAB
23BB 00        db 0
23BC 7C        db 124
23BD 38        db 56
23BE 35        db 53
23BF 32        db 50
23C0 F4        db KEY_F3
23C1 00        db 0
23C2 F2        db KEY_F1
23C3 F3        db KEY_F2
23C4 1B        db KEY_ESC
23C5 39        db 57
23C6 36        db 54
23C7 33        db 51
CheckKeyboard:
23C8 2A 96 21  ld hl, (key_read_l_write_h)
23CB 7C        ld a, h
23CC BD        cp l
23CD C9        ret
ReadKeyboard:
23CE 2A 96 21  ld hl, (key_read_l_write_h)
23D1 7C        ld a, h
23D2 BD        cp l
23D3 C8        ret z
23D4 26 00     ld h, key_buffer>>8
23D6 56        ld d, (hl)
23D7 2C        inc l
23D8 7D        ld a, l
23D9 FE 55     cp key_buffer+16
23DB C2 E0 23  jp nz, _l317
23DE 3E 45     ld a, key_buffer
_l317:
23E0 32 96 21  ld (key_read), a
23E3 AF        xor a
23E4 3C        inc a
23E5 7A        ld a, d
23E6 C9        ret
KeyPush:
23E7 E5        push hl
23E8 2A 96 21  ld hl, (key_read_l_write_h)
23EB 26 00     ld h, key_buffer>>8
23ED 77        ld (hl), a
23EE 2C        inc l
23EF 7D        ld a, l
23F0 FE 55     cp key_buffer+16&255
23F2 C2 F7 23  jp nz, _l319
23F5 3E 45     ld a, key_buffer
_l319:
23F7 32 97 21  ld (key_write), a
23FA E1        pop hl
23FB C9        ret
KeyPressed:
23FC 57        ld d, a
23FD 2A 93 21  ld hl, (key_pressed)
2400 BD        cp l
2401 C2 0E 24  jp nz, _l321
2404 21 94 21  ld hl, key_delay
2407 35        dec (hl)
2408 C0        ret nz
2409 36 03     ld (hl), NEXT_REPLAY_DELAY
240B C3 16 24  jp _l322
_l321:
240E 32 93 21  ld (key_pressed), a
2411 21 94 21  ld hl, key_delay
2414 36 1E     ld (hl), FIRST_REPLAY_DELAY
_l322:
2416 FE 19     cp SCAN_LAT
2418 C2 20 24  jp nz, _l323
241B AF        xor a
241C 32 95 21  ld (key_rus), a
241F C9        ret
_l323:
2420 FE 18     cp SCAN_RUS
2422 C2 2B 24  jp nz, _l324
2425 3E 50     ld a, LAYOUT_SIZE
2427 32 95 21  ld (key_rus), a
242A C9        ret
_l324:
242B FE 1E     cp SCAN_CAP
242D C2 39 24  jp nz, _l325
2430 3A 92 21  ld a, (key_leds)
2433 EE 10     xor MOD_CAPS
2435 32 92 21  ld (key_leds), a
2438 C9        ret
_l325:
2439 FE 1C     cp SCAN_NUM
243B C2 47 24  jp nz, _l326
243E 3A 92 21  ld a, (key_leds)
2441 EE 20     xor MOD_NUM
2443 32 92 21  ld (key_leds), a
2446 C9        ret
_l326:
2447 7B        ld a, e
2448 E6 01     and MOD_CTR
244A CA 5A 24  jp z, _l327
244D 7A        ld a, d
244E C6 38     add ctrLayout
2450 6F        ld l, a
2451 CE 22     adc ctrLayout>>8
2453 95        sub l
2454 67        ld h, a
2455 7E        ld a, (hl)
2456 CD E7 23  call KeyPush
2459 C9        ret
_l327:
245A 7A        ld a, d
245B C6 98     add shiftLayout
245D 6F        ld l, a
245E CE 21     adc shiftLayout>>8
2460 95        sub l
2461 67        ld h, a
2462 3A 95 21  ld a, (key_rus)
2465 B7        or a
2466 CA 70 24  jp z, _l328
2469 3E 50     ld a, LAYOUT_SIZE
246B 85        add l
246C 6F        ld l, a
246D 8C        adc h
246E 95        sub l
246F 67        ld h, a
_l328:
2470 7E        ld a, (hl)
2471 26 00     ld h, 0
2473 87        add a
2474 D2 8C 24  jp nc, _l329
2477 7B        ld a, e
2478 E6 02     and MOD_SHIFT
247A CA 7F 24  jp z, _l330
247D 26 50     ld h, LAYOUT_SIZE
_l330:
247F 7B        ld a, e
2480 E6 10     and MOD_CAPS
2482 C2 89 24  jp nz, _l331
2485 3E 50     ld a, LAYOUT_SIZE
2487 94        sub h
2488 67        ld h, a
_l331:
2489 C3 A7 24  jp _l332
_l329:
248C 87        add a
248D D2 9B 24  jp nc, _l333
2490 7B        ld a, e
2491 E6 02     and MOD_SHIFT
2493 CA 98 24  jp z, _l334
2496 26 50     ld h, LAYOUT_SIZE
_l334:
2498 C3 A7 24  jp _l335
_l333:
249B 87        add a
249C D2 A7 24  jp nc, _l336
249F 7B        ld a, e
24A0 E6 20     and MOD_NUM
24A2 C2 A7 24  jp nz, _l337
24A5 26 50     ld h, LAYOUT_SIZE
_l332:
_l335:
_l336:
_l337:
24A7 7A        ld a, d
24A8 84        add h
24A9 C6 88     add key_layout_table
24AB 6F        ld l, a
24AC CE 22     adc key_layout_table>>8
24AE 95        sub l
24AF 67        ld h, a
24B0 3A 95 21  ld a, (key_rus)
24B3 B7        or a
24B4 CA BE 24  jp z, _l338
24B7 3E A0     ld a, LAYOUT_SIZE*2
24B9 85        add l
24BA 6F        ld l, a
24BB 8C        adc h
24BC 95        sub l
24BD 67        ld h, a
_l338:
24BE 7E        ld a, (hl)
24BF C3 E7 23  jp KeyPush
InterruptHandler:
24C2 DB 04     in a, (PORT_FRAME_IRQ_RESET)
24C4 0F        rrca
24C5 D8        ret c
24C6 D3 04     out (PORT_FRAME_IRQ_RESET), a
24C8 21 91 21  ld hl, frame_counter
24CB 34        inc (hl)
24CC 3A 01 01  ld a, (cursor_visible)
24CF B7        or a
24D0 CA FA 24  jp z, _l340
24D3 3A 00 01  ld a, (cursor_blink_counter)
24D6 3D        dec a
24D7 C2 F7 24  jp nz, _l341
24DA 3A 01 01  ld a, (cursor_visible)
24DD EE 02     xor 2
24DF 32 01 01  ld (cursor_visible), a
24E2 DB 03     in a, (3)
24E4 F5        push af
24E5 3E 01     ld a, 1
24E7 D3 03     out (3), a
24E9 2A 03 01  ld hl, (cursor_y)
24EC CD A3 08  call DrawCursor
24EF F1        pop af
24F0 D3 03     out (3), a
24F2 3E 23     ld a, CURSOR_BLINK_PERIOD
24F4 32 00 01  ld (cursor_blink_counter), a
_l341:
24F7 32 00 01  ld (cursor_blink_counter), a
_l340:
24FA 3A 92 21  ld a, (key_leds)
24FD F6 08     or 8
24FF D3 C0     out (PORT_KEYBOARD), a
2501 DB C0     in a, (PORT_KEYBOARD)
2503 E6 08     and 8
2505 3A 92 21  ld a, (key_leds)
2508 CA 0D 25  jp z, _l342
250B F6 01     or MOD_CTR
_l342:
250D 5F        ld e, a
250E 3A 92 21  ld a, (key_leds)
2511 F6 03     or 3
2513 D3 C0     out (PORT_KEYBOARD), a
2515 DB C0     in a, (PORT_KEYBOARD)
2517 E6 08     and 8
2519 CA 20 25  jp z, _l343
251C 3E 02     ld a, MOD_SHIFT
251E B3        or e
251F 5F        ld e, a
_l343:
2520 06 09     ld b, 9
_l344:
2522 3A 92 21  ld a, (key_leds)
2525 B0        or b
2526 D3 C0     out (PORT_KEYBOARD), a
2528 DB C0     in a, (PORT_KEYBOARD)
252A B7        or a
252B CA 49 25  jp z, _l347
252E 0E 07     ld c, 7
_l348:
2530 87        add a
2531 D2 45 25  jp nc, _l351
2534 57        ld d, a
2535 78        ld a, b
2536 87        add a
2537 87        add a
2538 87        add a
2539 81        add c
253A FE 1B     cp 27
253C CA 44 25  jp z, _l352
253F FE 43     cp 67
2541 C2 FC 23  jp nz, KeyPressed
_l352:
2544 7A        ld a, d
_l350:
_l351:
2545 0D        dec c
2546 F2 30 25  jp p, _l348
_l346:
_l347:
_l349:
2549 05        dec b
254A F2 22 25  jp p, _l344
_l345:
254D 3E FF     ld a, 255
254F 32 93 21  ld (key_pressed), a
2552 C9        ret
2553          SCREEN_0_ADDRESS equ 53248
2553          SCREEN_1_ADDRESS equ 36864
2553          PALETTE_WHITE equ 0
2553          PALETTE_CYAN equ 1
2553          PALETTE_MAGENTA equ 2
2553          PALETTE_BLUE equ 3
2553          PALETTE_YELLOW equ 4
2553          PALETTE_GREEN equ 5
2553          PALETTE_RED equ 6
2553          PALETTE_XXX equ 7
2553          PALETTE_GRAY equ 8
2553          PALETTE_DARK_CYAN equ 9
2553          PALETTE_DARK_MAGENTA equ 10
2553          PALETTE_DARK_BLUE equ 11
2553          PALETTE_DARK_YELLOW equ 12
2553          PALETTE_DARK_GREEN equ 13
2553          PALETTE_DARK_RED equ 14
2553          PALETTE_BLACK equ 15
2553          KEY_BACKSPACE equ 8
2553          KEY_TAB equ 9
2553          KEY_ENTER equ 13
2553          KEY_ESC equ 27
2553          KEY_ALT equ 1
2553          KEY_F1 equ 242
2553          KEY_F2 equ 243
2553          KEY_F3 equ 244
2553          KEY_UP equ 245
2553          KEY_DOWN equ 246
2553          KEY_RIGHT equ 247
2553          KEY_LEFT equ 248
2553          KEY_EXT_5 equ 249
2553          KEY_END equ 250
2553          KEY_HOME equ 251
2553          KEY_INSERT equ 252
2553          KEY_DEL equ 253
2553          KEY_PG_UP equ 254
2553          KEY_PG_DN equ 255
2553          PORT_FRAME_IRQ_RESET equ 4
2553          PORT_SD_SIZE equ 9
2553          PORT_SD_RESULT equ 9
2553          PORT_SD_DATA equ 8
2553          PORT_UART_DATA equ 128
2553          PORT_UART_CONFIG equ 129
2553          PORT_UART_STATE equ 129
2553          PORT_EXT_DATA_OUT equ 136
2553          PORT_PALETTE_3 equ 144
2553          PORT_PALETTE_2 equ 145
2553          PORT_PALETTE_1 equ 146
2553          PORT_PALETTE_0 equ 147
2553          PORT_EXT_IN_DATA equ 137
2553          PORT_A0 equ 160
2553          PORT_ROM_0000 equ 168
2553          PORT_ROM_0000__ROM equ 0
2553          PORT_ROM_0000__RAM equ 128
2553          PORT_VIDEO_MODE_1_LOW equ 185
2553          PORT_VIDEO_MODE_1_HIGH equ 249
2553          PORT_VIDEO_MODE_0_LOW equ 184
2553          PORT_VIDEO_MODE_0_HIGH equ 248
2553          PORT_UART_SPEED_0 equ 187
2553          PORT_KEYBOARD equ 192
2553          PORT_UART_SPEED_1 equ 251
2553          PORT_CODE_ROM equ 186
2553          PORT_CHARGEN_ROM equ 250
2553          PORT_TAPE_AND_IDX2 equ 153
2553          PORT_TAPE_AND_IDX2_ID1_2 equ 2
2553          PORT_TAPE_AND_IDX2_ID2_2 equ 4
2553          PORT_TAPE_AND_IDX2_ID3_2 equ 8
2553          PORT_TAPE_AND_IDX2_ID6_2 equ 64
2553          PORT_TAPE_AND_IDX2_ID7_2 equ 128
2553          PORT_RESET_CU1 equ 188
2553          PORT_RESET_CU2 equ 189
2553          PORT_RESET_CU3 equ 190
2553          PORT_RESET_CU4 equ 191
2553          PORT_SET_CU1 equ 252
2553          PORT_SET_CU2 equ 253
2553          PORT_SET_CU3 equ 254
2553          PORT_SET_CU4 equ 255
2553          PORT_TAPE_OUT equ 176
2553          SD_COMMAND_READ equ 1
2553          SD_COMMAND_READ_SIZE equ 5
2553          SD_COMMAND_WRITE equ 2
2553          SD_COMMAND_WRITE_SIZE equ 5+128
2553          SD_RESULT_BUSY equ 255
2553          SD_RESULT_OK equ 0
2553          stack equ 256
2553          entry_cpm_conout_address equ EntryCpmConout+1
2553          cpm_dph_a equ 65376
2553          cpm_dph_b equ 65392
2553          cpm_dma_buffer equ 65408
2553          TEXT_SCREEN_HEIGHT equ 25
2553          FONT_HEIGHT equ 10
2553          FONT_WIDTH equ 3
2553          DrawCharAddress equ DrawChar+1
2553          SetColorAddress equ SetColor+1
2553          DrawCursorAddress equ DrawCursor+1
2553          MOD_CTR equ 1
2553          MOD_SHIFT equ 2
2553          MOD_CAPS equ 16
2553          MOD_NUM equ 32
2553          OPCODE_NOP equ 0
2553          OPCODE_LD_DE_CONST equ 17
2553          OPCODE_LD_A_CONST equ 62
2553          OPCODE_LD_H_A equ 103
2553          OPCODE_LD_A_D equ 122
2553          OPCODE_LD_A_H equ 124
2553          OPCODE_XOR_A equ 175
2553          OPCODE_XOR_B equ 168
2553          OPCODE_JP equ 195
2553          OPCODE_RET equ 201
2553          OPCODE_SUB_CONST equ 214
2553          OPCODE_AND_CONST equ 230
2553          OPCODE_OR_CONST equ 246
2553          OPCODE_OUT equ 211
2553          OPCODE_JMP equ 195
2553          MIT_RETURN equ 0
2553          MIT_SUBMENU equ 1
2553          MIT_JUMP equ 2
2553          cpm_load_address equ 58624
2553          CpmEntryPoint equ 64307
cfg_begin:
2553           ds 0
cfg_screen_mode:
2553 00        ds 1
cfg_color_0:
2554 0B        db PALETTE_DARK_BLUE
cfg_color_1:
2555 01        db PALETTE_CYAN
cfg_color_2:
2556 00        db PALETTE_WHITE
cfg_color_3:
2557 04        db PALETTE_YELLOW
cfg_drive_0:
2558 00        db 0
cfg_drive_1:
2559 01        db 1
cfg_codepage:
255A 00        db 0
cfg_uart_baud_rate:
255B 03        db 3
cfg_uart_data_bits:
255C 03        db 3
cfg_uart_parity:
255D 00        db 0
cfg_uart_stop:
255E 00        db 0
cfg_uart_flow:
255F 00        db 0
cfg_check_sum:
2560 00        db 0
SaveConfig:
2561 21 53 25  ld hl, cfg_begin
2564 0E 0D     ld c, cfg_check_sum-cfg_begin
2566 3E AA     ld a, 170
_l369:
2568 AE        xor (hl)
2569 23        inc hl
_l371:
256A 0D        dec c
256B C2 68 25  jp nz, _l369
_l370:
256E 77        ld (hl), a
256F 21 53 25  ld hl, cfg_begin
2572 0E 0E     ld c, (cfg_check_sum-cfg_begin)+1
2574 C3 CE 44  jp WriteConfig
menu_screen:
2577 6B 48     dw _l373
2579 E3 46     dw _l374
257B 00 00     dw 0
257D 00 00     dw 0
257F 00 00     dw 0
2581 F3 46     dw _l375
2583 00 00     dw 0
2585 01 00     dw 1
2587 00 00     dw 0
2589 1C 47     dw _l376
258B 00 00     dw 0
258D 02 00     dw 2
258F 00 00     dw 0
2591 2C 47     dw _l377
2593 00 00     dw 0
2595 03 00     dw 3
2597 00 00     dw 0
2599 00 00     dw 0
menu_drive:
259B B9 47     dw _l379
259D 50 49     dw _l380
259F 00 00     dw 0
25A1 00 00     dw 0
25A3 00 00     dw 0
25A5 5D 49     dw _l381
25A7 00 00     dw 0
25A9 01 00     dw 1
25AB 00 00     dw 0
25AD 99 47     dw _l382
25AF 00 00     dw 0
25B1 02 00     dw 2
25B3 00 00     dw 0
25B5 00 00     dw 0
menu_code_page:
25B7 CD 47     dw _l384
25B9 0B 47     dw _l385
25BB 00 00     dw 0
25BD 00 00     dw 0
25BF 00 00     dw 0
25C1 BA 46     dw _l386
25C3 00 00     dw 0
25C5 01 00     dw 1
25C7 00 00     dw 0
25C9 18 49     dw _l387
25CB 00 00     dw 0
25CD 02 00     dw 2
25CF 00 00     dw 0
25D1 20 49     dw _l388
25D3 00 00     dw 0
25D5 03 00     dw 3
25D7 00 00     dw 0
25D9 00 00     dw 0
menu_uart_baud_rate:
25DB 83 48     dw _l390
25DD AF 46     dw _l391
25DF 00 00     dw 0
25E1 00 00     dw 0
25E3 00 00     dw 0
25E5 C5 46     dw _l392
25E7 00 00     dw 0
25E9 01 00     dw 1
25EB 00 00     dw 0
25ED D0 46     dw _l393
25EF 00 00     dw 0
25F1 02 00     dw 2
25F3 00 00     dw 0
25F5 11 47     dw _l394
25F7 00 00     dw 0
25F9 03 00     dw 3
25FB 00 00     dw 0
25FD 00 00     dw 0
menu_uart_data_bits:
25FF E2 47     dw _l396
2601 DB 46     dw _l397
2603 00 00     dw 0
2605 00 00     dw 0
2607 00 00     dw 0
2609 DF 46     dw _l398
260B 00 00     dw 0
260D 01 00     dw 1
260F 00 00     dw 0
2611 03 47     dw _l399
2613 00 00     dw 0
2615 02 00     dw 2
2617 00 00     dw 0
2619 07 47     dw _l400
261B 00 00     dw 0
261D 03 00     dw 3
261F 00 00     dw 0
2621 00 00     dw 0
menu_uart_stop_bits:
2623 04 48     dw _l402
2625 A5 46     dw _l403
2627 00 00     dw 0
2629 00 00     dw 0
262B 00 00     dw 0
262D A9 46     dw _l404
262F 00 00     dw 0
2631 01 00     dw 1
2633 00 00     dw 0
2635 C1 46     dw _l405
2637 00 00     dw 0
2639 02 00     dw 2
263B 00 00     dw 0
263D 00 00     dw 0
menu_uart_parity:
263F 49 48     dw _l407
2641 4A 49     dw _l408
2643 00 00     dw 0
2645 00 00     dw 0
2647 00 00     dw 0
2649 2A 4A     dw _l409
264B 00 00     dw 0
264D 01 00     dw 1
264F 00 00     dw 0
2651 3E 49     dw _l410
2653 00 00     dw 0
2655 02 00     dw 2
2657 00 00     dw 0
2659 00 00     dw 0
menu_uart_flow:
265B 28 48     dw _l412
265D 4A 49     dw _l408
265F 00 00     dw 0
2661 00 00     dw 0
2663 00 00     dw 0
2665 3C 47     dw _l413
2667 00 00     dw 0
2669 01 00     dw 1
266B 00 00     dw 0
266D 00 00     dw 0
menu_color:
266F 9C 48     dw _l415
2671 21 4A     dw _l416
2673 00 00     dw 0
2675 0F 00     dw PALETTE_BLACK
2677 00 00     dw 0
2679 BF 49     dw _l417
267B 00 00     dw 0
267D 0E 00     dw PALETTE_DARK_RED
267F 00 00     dw 0
2681 AF 49     dw _l418
2683 00 00     dw 0
2685 0D 00     dw PALETTE_DARK_GREEN
2687 00 00     dw 0
2689 A0 49     dw _l419
268B 00 00     dw 0
268D 0C 00     dw PALETTE_DARK_YELLOW
268F 00 00     dw 0
2691 CF 49     dw _l420
2693 00 00     dw 0
2695 0B 00     dw PALETTE_DARK_BLUE
2697 00 00     dw 0
2699 DD 49     dw _l421
269B 00 00     dw 0
269D 0A 00     dw PALETTE_DARK_MAGENTA
269F 00 00     dw 0
26A1 90 49     dw _l422
26A3 00 00     dw 0
26A5 09 00     dw PALETTE_DARK_CYAN
26A7 00 00     dw 0
26A9 6A 49     dw _l423
26AB 00 00     dw 0
26AD 08 00     dw PALETTE_GRAY
26AF 00 00     dw 0
26B1 34 49     dw _l424
26B3 00 00     dw 0
26B5 06 00     dw PALETTE_RED
26B7 00 00     dw 0
26B9 F2 48     dw _l425
26BB 00 00     dw 0
26BD 05 00     dw PALETTE_GREEN
26BF 00 00     dw 0
26C1 CA 48     dw _l426
26C3 00 00     dw 0
26C5 04 00     dw PALETTE_YELLOW
26C7 00 00     dw 0
26C9 72 49     dw _l427
26CB 00 00     dw 0
26CD 03 00     dw PALETTE_BLUE
26CF 00 00     dw 0
26D1 F0 49     dw _l428
26D3 00 00     dw 0
26D5 02 00     dw PALETTE_MAGENTA
26D7 00 00     dw 0
26D9 AC 48     dw _l429
26DB 00 00     dw 0
26DD 01 00     dw PALETTE_CYAN
26DF 00 00     dw 0
26E1 B1 47     dw _l430
26E3 00 00     dw 0
26E5 00 00     dw PALETTE_WHITE
26E7 00 00     dw 0
26E9 00 00     dw 0
menu_root:
26EB 0A 49     dw _l432
26ED D3 48     dw _l433
26EF 02 00     dw MIT_JUMP
26F1 1B 28     dw StartCpm
26F3 00 00     dw 0
26F5 E1 48     dw _l434
26F7 02 00     dw MIT_JUMP
26F9 FE 27     dw StartBasic
26FB 00 00     dw 0
26FD 9A 46     dw _l435
26FF 00 00     dw 0
2701 00 00     dw 0
2703 00 00     dw 0
2705 28 49     dw _l436
2707 01 00     dw MIT_SUBMENU
2709 B7 25     dw menu_code_page
270B 5A 25     dw cfg_codepage
270D 33 4A     dw _l437
270F 01 00     dw MIT_SUBMENU
2711 77 25     dw menu_screen
2713 53 25     dw cfg_screen_mode
2715 FD 49     dw _l438
2717 01 00     dw MIT_SUBMENU
2719 6F 26     dw menu_color
271B 54 25     dw cfg_color_0
271D 06 4A     dw _l439
271F 01 00     dw MIT_SUBMENU
2721 6F 26     dw menu_color
2723 55 25     dw cfg_color_1
2725 0F 4A     dw _l440
2727 01 00     dw MIT_SUBMENU
2729 6F 26     dw menu_color
272B 56 25     dw cfg_color_2
272D 18 4A     dw _l441
272F 01 00     dw MIT_SUBMENU
2731 6F 26     dw menu_color
2733 57 25     dw cfg_color_3
2735 9A 46     dw _l435
2737 00 00     dw 0
2739 00 00     dw 0
273B 00 00     dw 0
273D 68 47     dw _l442
273F 01 00     dw MIT_SUBMENU
2741 DB 25     dw menu_uart_baud_rate
2743 5B 25     dw cfg_uart_baud_rate
2745 46 47     dw _l443
2747 01 00     dw MIT_SUBMENU
2749 FF 25     dw menu_uart_data_bits
274B 5C 25     dw cfg_uart_data_bits
274D 89 47     dw _l444
274F 01 00     dw MIT_SUBMENU
2751 3F 26     dw menu_uart_parity
2753 5D 25     dw cfg_uart_parity
2755 78 47     dw _l445
2757 01 00     dw MIT_SUBMENU
2759 23 26     dw menu_uart_stop_bits
275B 5E 25     dw cfg_uart_stop
275D 58 47     dw _l446
275F 01 00     dw MIT_SUBMENU
2761 5B 26     dw menu_uart_flow
2763 5F 25     dw cfg_uart_flow
2765 9A 46     dw _l435
2767 00 00     dw 0
2769 00 00     dw 0
276B 00 00     dw 0
276D B6 48     dw _l447
276F 01 00     dw MIT_SUBMENU
2771 9B 25     dw menu_drive
2773 58 25     dw cfg_drive_0
2775 C0 48     dw _l448
2777 01 00     dw MIT_SUBMENU
2779 9B 25     dw menu_drive
277B 59 25     dw cfg_drive_1
277D 9A 46     dw _l435
277F 00 00     dw 0
2781 00 00     dw 0
2783 00 00     dw 0
2785 7A 49     dw _l449
2787 02 00     dw MIT_JUMP
2789 61 25     dw SaveConfig
278B 00 00     dw 0
278D 00 00     dw 0
main:
278F 31 00 01  ld sp, stack
2792 3E 00     ld a, 0*2
2794 D3 00     out (0), a
2796 3E 02     ld a, 1*2
2798 D3 01     out (1), a
279A 3E 01     ld a, 1
279C D3 02     out (2), a
279E 3E 01     ld a, 1
27A0 D3 03     out (3), a
27A2 21 00 D0  ld hl, SCREEN_0_ADDRESS
27A5 0E 0E     ld c, (cfg_check_sum-cfg_begin)+1
27A7 CD A5 44  call ReadConfig
27AA C2 CE 27  jp nz, _l451
27AD 21 00 D0  ld hl, SCREEN_0_ADDRESS
27B0 0E 0E     ld c, (cfg_check_sum-cfg_begin)+1
27B2 3E AA     ld a, 170
_l452:
27B4 AE        xor (hl)
27B5 23        inc hl
_l454:
27B6 0D        dec c
27B7 C2 B4 27  jp nz, _l452
_l453:
27BA B7        or a
27BB C2 CE 27  jp nz, _l455
27BE 21 53 25  ld hl, cfg_begin
27C1 11 00 D0  ld de, SCREEN_0_ADDRESS
27C4 0E 0D     ld c, cfg_check_sum-cfg_begin
_l456:
27C6 1A        ld a, (de)
27C7 77        ld (hl), a
27C8 23        inc hl
27C9 13        inc de
_l458:
27CA 0D        dec c
27CB C2 C6 27  jp nz, _l456
_l451:
_l457:
_l455:
27CE CD 16 0C  call SetScreenColor6
27D1 3E 03     ld a, 3
27D3 CD A0 08  call SetColor
27D6 CD 57 03  call ConReset
27D9 3E 0B     ld a, PALETTE_DARK_BLUE
27DB D3 90     out (144+(0&3)), a
27DD 3E 00     ld a, PALETTE_WHITE
27DF D3 91     out (144+(1&3)), a
27E1 3E 04     ld a, PALETTE_YELLOW
27E3 D3 92     out (144+(2&3)), a
27E5 3E 01     ld a, PALETTE_CYAN
27E7 D3 93     out (144+(3&3)), a
_l460:
27E9 1E 00     ld e, 0
27EB 21 EB 26  ld hl, menu_root
27EE CD 42 45  call Menu
27F1 C3 E9 27  jp _l460
StartBasic4000:
_l459:
27F4 3E 01     ld a, 1
27F6 D3 00     out (0), a
27F8 AF        xor a
27F9 D3 A8     out (PORT_ROM_0000), a
27FB C3 00 00  jp 0
StartBasic:
27FE F3        di
27FF 3E 01     ld a, 1
2801 D3 01     out (1), a
2803 D3 02     out (2), a
2805 D3 03     out (3), a
2807 21 00 40  ld hl, 16384
280A 11 F4 27  ld de, StartBasic4000
280D 0E 0A     ld c, StartBasic-StartBasic4000
_l463:
280F 1A        ld a, (de)
2810 77        ld (hl), a
2811 23        inc hl
2812 13        inc de
_l465:
2813 0D        dec c
2814 C2 0F 28  jp nz, _l463
_l464:
2817 CD 00 40  call 16384
281A C9        ret
StartCpm:
281B 3A 5A 25  ld a, (cfg_codepage)
281E CD 48 07  call ConSetXlat
2821 3A 53 25  ld a, (cfg_screen_mode)
2824 B7        or a
2825 C2 2E 28  jp nz, _l467
2828 CD D1 0B  call SetScreenBw6
282B C3 45 28  jp _l468
_l467:
282E 3D        dec a
282F C2 38 28  jp nz, _l469
2832 CD 16 0C  call SetScreenColor6
2835 C3 45 28  jp _l470
_l469:
2838 3D        dec a
2839 C2 42 28  jp nz, _l471
283C CD 4D 21  call SetScreenBw4
283F C3 45 28  jp _l472
_l471:
2842 CD 6F 21  call SetScreenColor4
_l472:
_l468:
_l470:
2845 3E 03     ld a, 3
2847 CD A0 08  call SetColor
284A CD B0 08  call ClearScreen
284D 3A 54 25  ld a, (cfg_color_0)
2850 D3 90     out (144+(0&3)), a
2852 EE 07     xor 7
2854 E6 07     and 7
2856 32 0E 03  ld (con_color_0), a
2859 3A 55 25  ld a, (cfg_color_1)
285C D3 91     out (144+(1&3)), a
285E EE 07     xor 7
2860 E6 07     and 7
2862 32 0F 03  ld (con_color_1), a
2865 3A 56 25  ld a, (cfg_color_2)
2868 D3 92     out (144+(2&3)), a
286A EE 07     xor 7
286C E6 07     and 7
286E 32 10 03  ld (con_color_2), a
2871 3A 57 25  ld a, (cfg_color_3)
2874 D3 93     out (144+(3&3)), a
2876 EE 07     xor 7
2878 E6 07     and 7
287A 32 11 03  ld (con_color_3), a
287D 0E 00     ld c, 0
287F 11 00 00  ld de, 0
2882 21 FC 48  ld hl, _l473
2885 CD AD 09  call DrawText
2888 CD D1 03  call ConUpdateColor
288B 3E 01     ld a, 1
288D 32 01 01  ld (cursor_visible), a
CpmWBoot:
2890 3E 0E     ld a, 7*2
2892 D3 03     out (3), a
2894 11 00 E5  ld de, cpm_load_address
2897 21 AA 28  ld hl, cpm_start
_l475:
289A 7E        ld a, (hl)
289B 12        ld (de), a
289C 23        inc hl
289D 13        inc de
_l477:
289E 7A        ld a, d
289F B7        or a
28A0 C2 9A 28  jp nz, _l475
_l476:
28A3 3A CF 43  ld a, (drive_number)
28A6 4F        ld c, a
28A7 C3 33 FB  jp CpmEntryPoint
cpm_start:
28AA C3 5C E8  db 195
 db 92
 db 232
 db 195
 db 88
 db 232
 db 127
 db 0
 db 67
 db 111
 db 112
 db 121
 db 114
 db 105
 db 103
 db 104
 db 116
 db 32
 db 49
 db 57
 db 55
 db 57
 db 32
 db 40
 db 99
 db 41
 db 32
 db 98
 db 121
 db 32
 db 68
 db 105
 db 103
 db 105
 db 116
 db 97
 db 108
 db 32
 db 82
 db 101
 db 115
 db 101
 db 97
 db 114
 db 99
 db 104
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 8
 db 229
 db 0
 db 0
 db 95
 db 14
 db 2
 db 195
 db 5
 db 0
 db 197
 db 205
 db 140
 db 229
 db 193
 db 201
 db 62
 db 13
 db 205
 db 146
 db 229
 db 62
 db 10
 db 195
 db 146
 db 229
 db 62
 db 32
 db 195
 db 146
 db 229
 db 197
 db 205
 db 152
 db 229
 db 225
 db 126
 db 183
 db 200
 db 35
 db 229
 db 205
 db 140
 db 229
 db 225
 db 195
 db 172
 db 229
 db 14
 db 13
 db 195
 db 5
 db 0
 db 95
 db 14
 db 14
 db 195
 db 5
 db 0
 db 205
 db 5
 db 0
 db 50
 db 238
 db 236
 db 60
 db 201
 db 14
 db 15
 db 195
 db 195
 db 229
 db 175
 db 50
 db 237
 db 236
 db 17
 db 205
 db 236
 db 195
 db 203
 db 229
 db 14
 db 16
 db 195
 db 195
 db 229
 db 14
 db 17
 db 195
 db 195
 db 229
 db 14
 db 18
 db 195
 db 195
 db 229
 db 17
 db 205
 db 236
 db 195
 db 223
 db 229
 db 14
 db 19
 db 195
 db 5
 db 0
 db 205
 db 5
 db 0
 db 183
 db 201
 db 14
 db 20
 db 195
 db 244
 db 229
 db 17
 db 205
 db 236
 db 195
 db 249
 db 229
 db 14
 db 21
 db 195
 db 244
 db 229
 db 14
 db 22
 db 195
 db 195
 db 229
 db 14
 db 23
 db 195
 db 5
 db 0
 db 30
 db 255
 db 14
 db 32
 db 195
 db 5
 db 0
 db 205
 db 19
 db 230
 db 135
 db 135
 db 135
 db 135
 db 33
 db 239
 db 236
 db 182
 db 50
 db 4
 db 0
 db 201
 db 58
 db 239
 db 236
 db 50
 db 4
 db 0
 db 201
 db 254
 db 97
 db 216
 db 254
 db 123
 db 208
 db 230
 db 95
 db 201
 db 58
 db 171
 db 236
 db 183
 db 202
 db 150
 db 230
 db 58
 db 239
 db 236
 db 183
 db 62
 db 0
 db 196
 db 189
 db 229
 db 17
 db 172
 db 236
 db 205
 db 203
 db 229
 db 202
 db 150
 db 230
 db 58
 db 187
 db 236
 db 61
 db 50
 db 204
 db 236
 db 17
 db 172
 db 236
 db 205
 db 249
 db 229
 db 194
 db 150
 db 230
 db 17
 db 7
 db 229
 db 33
 db 128
 db 0
 db 6
 db 128
 db 205
 db 66
 db 233
 db 33
 db 186
 db 236
 db 54
 db 0
 db 35
 db 53
 db 17
 db 172
 db 236
 db 205
 db 218
 db 229
 db 202
 db 150
 db 230
 db 58
 db 239
 db 236
 db 183
 db 196
 db 189
 db 229
 db 33
 db 8
 db 229
 db 205
 db 172
 db 229
 db 205
 db 194
 db 230
 db 202
 db 167
 db 230
 db 205
 db 221
 db 230
 db 195
 db 130
 db 232
 db 205
 db 221
 db 230
 db 205
 db 26
 db 230
 db 14
 db 10
 db 17
 db 6
 db 229
 db 205
 db 5
 db 0
 db 205
 db 41
 db 230
 db 33
 db 7
 db 229
 db 70
 db 35
 db 120
 db 183
 db 202
 db 186
 db 230
 db 126
 db 205
 db 48
 db 230
 db 119
 db 5
 db 195
 db 171
 db 230
 db 119
 db 33
 db 8
 db 229
 db 34
 db 136
 db 229
 db 201
 db 14
 db 11
 db 205
 db 5
 db 0
 db 183
 db 200
 db 14
 db 1
 db 205
 db 5
 db 0
 db 183
 db 201
 db 14
 db 25
 db 195
 db 5
 db 0
 db 17
 db 128
 db 0
 db 14
 db 26
 db 195
 db 5
 db 0
 db 33
 db 171
 db 236
 db 126
 db 183
 db 200
 db 54
 db 0
 db 175
 db 205
 db 189
 db 229
 db 17
 db 172
 db 236
 db 205
 db 239
 db 229
 db 58
 db 239
 db 236
 db 195
 db 189
 db 229
 db 17
 db 40
 db 232
 db 33
 db 0
 db 237
 db 6
 db 6
 db 26
 db 190
 db 194
 db 207
 db 232
 db 19
 db 35
 db 5
 db 194
 db 253
 db 230
 db 201
 db 205
 db 152
 db 229
 db 42
 db 138
 db 229
 db 126
 db 254
 db 32
 db 202
 db 34
 db 231
 db 183
 db 202
 db 34
 db 231
 db 229
 db 205
 db 140
 db 229
 db 225
 db 35
 db 195
 db 15
 db 231
 db 62
 db 63
 db 205
 db 140
 db 229
 db 205
 db 152
 db 229
 db 205
 db 221
 db 230
 db 195
 db 130
 db 232
 db 26
 db 183
 db 200
 db 254
 db 32
 db 218
 db 9
 db 231
 db 200
 db 254
 db 61
 db 200
 db 254
 db 95
 db 200
 db 254
 db 46
 db 200
 db 254
 db 58
 db 200
 db 254
 db 59
 db 200
 db 254
 db 60
 db 200
 db 254
 db 62
 db 200
 db 201
 db 26
 db 183
 db 200
 db 254
 db 32
 db 192
 db 19
 db 195
 db 79
 db 231
 db 133
 db 111
 db 208
 db 36
 db 201
 db 62
 db 0
 db 33
 db 205
 db 236
 db 205
 db 89
 db 231
 db 229
 db 229
 db 175
 db 50
 db 240
 db 236
 db 42
 db 136
 db 229
 db 235
 db 205
 db 79
 db 231
 db 235
 db 34
 db 138
 db 229
 db 235
 db 225
 db 26
 db 183
 db 202
 db 137
 db 231
 db 222
 db 64
 db 71
 db 19
 db 26
 db 254
 db 58
 db 202
 db 144
 db 231
 db 27
 db 58
 db 239
 db 236
 db 119
 db 195
 db 150
 db 231
 db 120
 db 50
 db 240
 db 236
 db 112
 db 19
 db 6
 db 8
 db 205
 db 48
 db 231
 db 202
 db 185
 db 231
 db 35
 db 254
 db 42
 db 194
 db 169
 db 231
 db 54
 db 63
 db 195
 db 171
 db 231
 db 119
 db 19
 db 5
 db 194
 db 152
 db 231
 db 205
 db 48
 db 231
 db 202
 db 192
 db 231
 db 19
 db 195
 db 175
 db 231
 db 35
 db 54
 db 32
 db 5
 db 194
 db 185
 db 231
 db 6
 db 3
 db 254
 db 46
 db 194
 db 233
 db 231
 db 19
 db 205
 db 48
 db 231
 db 202
 db 233
 db 231
 db 35
 db 254
 db 42
 db 194
 db 217
 db 231
 db 54
 db 63
 db 195
 db 219
 db 231
 db 119
 db 19
 db 5
 db 194
 db 200
 db 231
 db 205
 db 48
 db 231
 db 202
 db 240
 db 231
 db 19
 db 195
 db 223
 db 231
 db 35
 db 54
 db 32
 db 5
 db 194
 db 233
 db 231
 db 6
 db 3
 db 35
 db 54
 db 0
 db 5
 db 194
 db 242
 db 231
 db 235
 db 34
 db 136
 db 229
 db 225
 db 1
 db 11
 db 0
 db 35
 db 126
 db 254
 db 63
 db 194
 db 9
 db 232
 db 4
 db 13
 db 194
 db 1
 db 232
 db 120
 db 183
 db 201
 db 68
 db 73
 db 82
 db 32
 db 69
 db 82
 db 65
 db 32
 db 84
 db 89
 db 80
 db 69
 db 83
 db 65
 db 86
 db 69
 db 82
 db 69
 db 78
 db 32
 db 85
 db 83
 db 69
 db 82
 db 0
 db 22
 db 0
 db 0
 db 0
 db 0
 db 33
 db 16
 db 232
 db 14
 db 0
 db 121
 db 254
 db 6
 db 208
 db 17
 db 206
 db 236
 db 6
 db 4
 db 26
 db 190
 db 194
 db 79
 db 232
 db 19
 db 35
 db 5
 db 194
 db 60
 db 232
 db 26
 db 254
 db 32
 db 194
 db 84
 db 232
 db 121
 db 201
 db 35
 db 5
 db 194
 db 79
 db 232
 db 12
 db 195
 db 51
 db 232
 db 175
 db 50
 db 7
 db 229
 db 49
 db 171
 db 236
 db 197
 db 121
 db 31
 db 31
 db 31
 db 31
 db 230
 db 15
 db 95
 db 205
 db 21
 db 230
 db 205
 db 184
 db 229
 db 50
 db 171
 db 236
 db 193
 db 121
 db 230
 db 15
 db 50
 db 239
 db 236
 db 205
 db 189
 db 229
 db 58
 db 7
 db 229
 db 183
 db 194
 db 152
 db 232
 db 49
 db 171
 db 236
 db 205
 db 152
 db 229
 db 205
 db 208
 db 230
 db 198
 db 65
 db 205
 db 140
 db 229
 db 62
 db 62
 db 205
 db 140
 db 229
 db 205
 db 57
 db 230
 db 17
 db 128
 db 0
 db 205
 db 216
 db 230
 db 205
 db 208
 db 230
 db 50
 db 239
 db 236
 db 205
 db 94
 db 231
 db 196
 db 9
 db 231
 db 58
 db 240
 db 236
 db 183
 db 194
 db 165
 db 235
 db 205
 db 46
 db 232
 db 33
 db 193
 db 232
 db 95
 db 22
 db 0
 db 25
 db 25
 db 126
 db 35
 db 102
 db 111
 db 233
 db 119
 db 233
 db 31
 db 234
 db 93
 db 234
 db 173
 db 234
 db 16
 db 235
 db 142
 db 235
 db 165
 db 235
 db 33
 db 243
 db 118
 db 34
 db 0
 db 229
 db 33
 db 0
 db 229
 db 233
 db 1
 db 223
 db 232
 db 195
 db 167
 db 229
 db 82
 db 101
 db 97
 db 100
 db 32
 db 101
 db 114
 db 114
 db 111
 db 114
 db 0
 db 1
 db 240
 db 232
 db 195
 db 167
 db 229
 db 78
 db 111
 db 32
 db 102
 db 105
 db 108
 db 101
 db 0
 db 205
 db 94
 db 231
 db 58
 db 240
 db 236
 db 183
 db 194
 db 9
 db 231
 db 33
 db 206
 db 236
 db 1
 db 11
 db 0
 db 126
 db 254
 db 32
 db 202
 db 51
 db 233
 db 35
 db 214
 db 48
 db 254
 db 10
 db 210
 db 9
 db 231
 db 87
 db 120
 db 230
 db 224
 db 194
 db 9
 db 231
 db 120
 db 7
 db 7
 db 7
 db 128
 db 218
 db 9
 db 231
 db 128
 db 218
 db 9
 db 231
 db 130
 db 218
 db 9
 db 231
 db 71
 db 13
 db 194
 db 8
 db 233
 db 201
 db 126
 db 254
 db 32
 db 194
 db 9
 db 231
 db 35
 db 13
 db 194
 db 51
 db 233
 db 120
 db 201
 db 6
 db 3
 db 126
 db 18
 db 35
 db 19
 db 5
 db 194
 db 66
 db 233
 db 201
 db 33
 db 128
 db 0
 db 129
 db 205
 db 89
 db 231
 db 126
 db 201
 db 175
 db 50
 db 205
 db 236
 db 58
 db 240
 db 236
 db 183
 db 200
 db 61
 db 33
 db 239
 db 236
 db 190
 db 200
 db 195
 db 189
 db 229
 db 58
 db 240
 db 236
 db 183
 db 200
 db 61
 db 33
 db 239
 db 236
 db 190
 db 200
 db 58
 db 239
 db 236
 db 195
 db 189
 db 229
 db 205
 db 94
 db 231
 db 205
 db 84
 db 233
 db 33
 db 206
 db 236
 db 126
 db 254
 db 32
 db 194
 db 143
 db 233
 db 6
 db 11
 db 54
 db 63
 db 35
 db 5
 db 194
 db 136
 db 233
 db 30
 db 0
 db 213
 db 205
 db 233
 db 229
 db 204
 db 234
 db 232
 db 202
 db 27
 db 234
 db 58
 db 238
 db 236
 db 15
 db 15
 db 15
 db 230
 db 96
 db 79
 db 62
 db 10
 db 205
 db 75
 db 233
 db 23
 db 218
 db 15
 db 234
 db 209
 db 123
 db 28
 db 213
 db 230
 db 3
 db 245
 db 194
 db 204
 db 233
 db 205
 db 152
 db 229
 db 197
 db 205
 db 208
 db 230
 db 193
 db 198
 db 65
 db 205
 db 146
 db 229
 db 62
 db 58
 db 205
 db 146
 db 229
 db 195
 db 212
 db 233
 db 205
 db 162
 db 229
 db 62
 db 58
 db 205
 db 146
 db 229
 db 205
 db 162
 db 229
 db 6
 db 1
 db 120
 db 205
 db 75
 db 233
 db 230
 db 127
 db 254
 db 32
 db 194
 db 249
 db 233
 db 241
 db 245
 db 254
 db 3
 db 194
 db 247
 db 233
 db 62
 db 9
 db 205
 db 75
 db 233
 db 230
 db 127
 db 254
 db 32
 db 202
 db 14
 db 234
 db 62
 db 32
 db 205
 db 146
 db 229
 db 4
 db 120
 db 254
 db 12
 db 210
 db 14
 db 234
 db 254
 db 9
 db 194
 db 217
 db 233
 db 205
 db 162
 db 229
 db 195
 db 217
 db 233
 db 241
 db 205
 db 194
 db 230
 db 194
 db 27
 db 234
 db 205
 db 228
 db 229
 db 195
 db 152
 db 233
 db 209
 db 195
 db 134
 db 236
 db 205
 db 94
 db 231
 db 254
 db 11
 db 194
 db 66
 db 234
 db 1
 db 82
 db 234
 db 205
 db 167
 db 229
 db 205
 db 57
 db 230
 db 33
 db 7
 db 229
 db 53
 db 194
 db 130
 db 232
 db 35
 db 126
 db 254
 db 89
 db 194
 db 130
 db 232
 db 35
 db 34
 db 136
 db 229
 db 205
 db 84
 db 233
 db 17
 db 205
 db 236
 db 205
 db 239
 db 229
 db 60
 db 204
 db 234
 db 232
 db 195
 db 134
 db 236
 db 65
 db 108
 db 108
 db 32
 db 40
 db 121
 db 47
 db 110
 db 41
 db 63
 db 0
 db 205
 db 94
 db 231
 db 194
 db 9
 db 231
 db 205
 db 84
 db 233
 db 205
 db 208
 db 229
 db 202
 db 167
 db 234
 db 205
 db 152
 db 229
 db 33
 db 241
 db 236
 db 54
 db 255
 db 33
 db 241
 db 236
 db 126
 db 254
 db 128
 db 218
 db 135
 db 234
 db 229
 db 205
 db 254
 db 229
 db 225
 db 194
 db 160
 db 234
 db 175
 db 119
 db 52
 db 33
 db 128
 db 0
 db 205
 db 89
 db 231
 db 126
 db 254
 db 26
 db 202
 db 134
 db 236
 db 205
 db 140
 db 229
 db 205
 db 194
 db 230
 db 194
 db 134
 db 236
 db 195
 db 116
 db 234
 db 61
 db 202
 db 134
 db 236
 db 205
 db 217
 db 232
 db 205
 db 102
 db 233
 db 195
 db 9
 db 231
 db 205
 db 248
 db 232
 db 245
 db 205
 db 94
 db 231
 db 194
 db 9
 db 231
 db 205
 db 84
 db 233
 db 17
 db 205
 db 236
 db 213
 db 205
 db 239
 db 229
 db 209
 db 205
 db 9
 db 230
 db 202
 db 251
 db 234
 db 175
 db 50
 db 237
 db 236
 db 241
 db 111
 db 38
 db 0
 db 41
 db 17
 db 0
 db 1
 db 124
 db 181
 db 202
 db 241
 db 234
 db 43
 db 229
 db 33
 db 128
 db 0
 db 25
 db 229
 db 205
 db 216
 db 230
 db 17
 db 205
 db 236
 db 205
 db 4
 db 230
 db 209
 db 225
 db 194
 db 251
 db 234
 db 195
 db 212
 db 234
 db 17
 db 205
 db 236
 db 205
 db 218
 db 229
 db 60
 db 194
 db 1
 db 235
 db 1
 db 7
 db 235
 db 205
 db 167
 db 229
 db 205
 db 213
 db 230
 db 195
 db 134
 db 236
 db 78
 db 111
 db 32
 db 115
 db 112
 db 97
 db 99
 db 101
 db 0
 db 205
 db 94
 db 231
 db 194
 db 9
 db 231
 db 58
 db 240
 db 236
 db 245
 db 205
 db 84
 db 233
 db 205
 db 233
 db 229
 db 194
 db 121
 db 235
 db 33
 db 205
 db 236
 db 17
 db 221
 db 236
 db 6
 db 16
 db 205
 db 66
 db 233
 db 42
 db 136
 db 229
 db 235
 db 205
 db 79
 db 231
 db 254
 db 61
 db 202
 db 63
 db 235
 db 254
 db 95
 db 194
 db 115
 db 235
 db 235
 db 35
 db 34
 db 136
 db 229
 db 205
 db 94
 db 231
 db 194
 db 115
 db 235
 db 241
 db 71
 db 33
 db 240
 db 236
 db 126
 db 183
 db 202
 db 89
 db 235
 db 184
 db 112
 db 194
 db 115
 db 235
 db 112
 db 175
 db 50
 db 205
 db 236
 db 205
 db 233
 db 229
 db 202
 db 109
 db 235
 db 17
 db 205
 db 236
 db 205
 db 14
 db 230
 db 195
 db 134
 db 236
 db 205
 db 234
 db 232
 db 195
 db 134
 db 236
 db 205
 db 102
 db 233
 db 195
 db 9
 db 231
 db 1
 db 130
 db 235
 db 205
 db 167
 db 229
 db 195
 db 134
 db 236
 db 70
 db 105
 db 108
 db 101
 db 32
 db 101
 db 120
 db 105
 db 115
 db 116
 db 115
 db 0
 db 205
 db 248
 db 232
 db 254
 db 16
 db 210
 db 9
 db 231
 db 95
 db 58
 db 206
 db 236
 db 254
 db 32
 db 202
 db 9
 db 231
 db 205
 db 21
 db 230
 db 195
 db 137
 db 236
 db 205
 db 245
 db 230
 db 58
 db 206
 db 236
 db 254
 db 32
 db 194
 db 196
 db 235
 db 58
 db 240
 db 236
 db 183
 db 202
 db 137
 db 236
 db 61
 db 50
 db 239
 db 236
 db 205
 db 41
 db 230
 db 205
 db 189
 db 229
 db 195
 db 137
 db 236
 db 17
 db 214
 db 236
 db 26
 db 254
 db 32
 db 194
 db 9
 db 231
 db 213
 db 205
 db 84
 db 233
 db 209
 db 33
 db 131
 db 236
 db 205
 db 64
 db 233
 db 205
 db 208
 db 229
 db 202
 db 107
 db 236
 db 33
 db 0
 db 1
 db 229
 db 235
 db 205
 db 216
 db 230
 db 17
 db 205
 db 236
 db 205
 db 249
 db 229
 db 194
 db 1
 db 236
 db 225
 db 17
 db 128
 db 0
 db 25
 db 17
 db 0
 db 229
 db 125
 db 147
 db 124
 db 154
 db 210
 db 113
 db 236
 db 195
 db 225
 db 235
 db 225
 db 61
 db 194
 db 113
 db 236
 db 205
 db 102
 db 233
 db 205
 db 94
 db 231
 db 33
 db 240
 db 236
 db 229
 db 126
 db 50
 db 205
 db 236
 db 62
 db 16
 db 205
 db 96
 db 231
 db 225
 db 126
 db 50
 db 221
 db 236
 db 175
 db 50
 db 237
 db 236
 db 17
 db 92
 db 0
 db 33
 db 205
 db 236
 db 6
 db 33
 db 205
 db 66
 db 233
 db 33
 db 8
 db 229
 db 126
 db 183
 db 202
 db 62
 db 236
 db 254
 db 32
 db 202
 db 62
 db 236
 db 35
 db 195
 db 48
 db 236
 db 6
 db 0
 db 17
 db 129
 db 0
 db 126
 db 18
 db 183
 db 202
 db 79
 db 236
 db 4
 db 35
 db 19
 db 195
 db 67
 db 236
 db 120
 db 50
 db 128
 db 0
 db 205
 db 152
 db 229
 db 205
 db 213
 db 230
 db 205
 db 26
 db 230
 db 205
 db 0
 db 1
 db 49
 db 171
 db 236
 db 205
 db 41
 db 230
 db 205
 db 189
 db 229
 db 195
 db 130
 db 232
 db 205
 db 102
 db 233
 db 195
 db 9
 db 231
 db 1
 db 122
 db 236
 db 205
 db 167
 db 229
 db 195
 db 134
 db 236
 db 66
 db 97
 db 100
 db 32
 db 108
 db 111
 db 97
 db 100
 db 0
 db 67
 db 79
 db 77
 db 205
 db 102
 db 233
 db 205
 db 94
 db 231
 db 58
 db 206
 db 236
 db 214
 db 32
 db 33
 db 240
 db 236
 db 182
 db 194
 db 9
 db 231
 db 195
 db 130
 db 232
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 36
 db 36
 db 36
 db 32
 db 32
 db 32
 db 32
 db 32
 db 83
 db 85
 db 66
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 0
 db 0
 db 0
 db 0
 db 0
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 32
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 22
 db 0
 db 0
 db 0
 db 0
 db 195
 db 17
 db 237
 db 153
 db 237
 db 165
 db 237
 db 171
 db 237
 db 177
 db 237
 db 235
 db 34
 db 67
 db 240
 db 235
 db 123
 db 50
 db 214
 db 250
 db 33
 db 0
 db 0
 db 34
 db 69
 db 240
 db 57
 db 34
 db 15
 db 240
 db 49
 db 65
 db 240
 db 175
 db 50
 db 224
 db 250
 db 50
 db 222
 db 250
 db 33
 db 116
 db 250
 db 229
 db 121
 db 254
 db 41
 db 208
 db 75
 db 33
 db 71
 db 237
 db 95
 db 22
 db 0
 db 25
 db 25
 db 94
 db 35
 db 86
 db 42
 db 67
 db 240
 db 235
 db 233
 db 3
 db 251
 db 200
 db 239
 db 144
 db 238
 db 206
 db 239
 db 18
 db 251
 db 15
 db 251
 db 212
 db 239
 db 237
 db 239
 db 243
 db 239
 db 248
 db 239
 db 225
 db 238
 db 254
 db 239
 db 126
 db 249
 db 131
 db 249
 db 69
 db 249
 db 156
 db 249
 db 165
 db 249
 db 171
 db 249
 db 200
 db 249
 db 215
 db 249
 db 224
 db 249
 db 230
 db 249
 db 236
 db 249
 db 245
 db 249
 db 254
 db 249
 db 4
 db 250
 db 10
 db 250
 db 17
 db 250
 db 44
 db 242
 db 23
 db 250
 db 29
 db 250
 db 38
 db 250
 db 45
 db 250
 db 65
 db 250
 db 71
 db 250
 db 77
 db 250
 db 14
 db 249
 db 83
 db 250
 db 4
 db 240
 db 4
 db 240
 db 155
 db 250
 db 33
 db 202
 db 237
 db 205
 db 229
 db 237
 db 254
 db 3
 db 202
 db 0
 db 0
 db 201
 db 33
 db 213
 db 237
 db 195
 db 180
 db 237
 db 33
 db 225
 db 237
 db 195
 db 180
 db 237
 db 33
 db 220
 db 237
 db 205
 db 229
 db 237
 db 195
 db 0
 db 0
 db 66
 db 100
 db 111
 db 115
 db 32
 db 69
 db 114
 db 114
 db 32
 db 79
 db 110
 db 32
 db 32
 db 58
 db 32
 db 36
 db 66
 db 97
 db 100
 db 32
 db 83
 db 101
 db 99
 db 116
 db 111
 db 114
 db 36
 db 83
 db 101
 db 108
 db 101
 db 99
 db 116
 db 36
 db 70
 db 105
 db 108
 db 101
 db 32
 db 82
 db 47
 db 79
 db 36
 db 229
 db 205
 db 201
 db 238
 db 58
 db 66
 db 240
 db 198
 db 65
 db 50
 db 198
 db 237
 db 1
 db 186
 db 237
 db 205
 db 211
 db 238
 db 193
 db 205
 db 211
 db 238
 db 33
 db 14
 db 240
 db 126
 db 54
 db 0
 db 183
 db 192
 db 195
 db 9
 db 251
 db 205
 db 251
 db 237
 db 205
 db 20
 db 238
 db 216
 db 245
 db 79
 db 205
 db 144
 db 238
 db 241
 db 201
 db 254
 db 13
 db 200
 db 254
 db 10
 db 200
 db 254
 db 9
 db 200
 db 254
 db 8
 db 200
 db 254
 db 32
 db 201
 db 58
 db 14
 db 240
 db 183
 db 194
 db 69
 db 238
 db 205
 db 6
 db 251
 db 230
 db 1
 db 200
 db 205
 db 9
 db 251
 db 254
 db 19
 db 194
 db 66
 db 238
 db 205
 db 9
 db 251
 db 254
 db 3
 db 202
 db 0
 db 0
 db 175
 db 201
 db 50
 db 14
 db 240
 db 62
 db 1
 db 201
 db 58
 db 10
 db 240
 db 183
 db 194
 db 98
 db 238
 db 197
 db 205
 db 35
 db 238
 db 193
 db 197
 db 205
 db 12
 db 251
 db 193
 db 197
 db 58
 db 13
 db 240
 db 183
 db 196
 db 15
 db 251
 db 193
 db 121
 db 33
 db 12
 db 240
 db 254
 db 127
 db 200
 db 52
 db 254
 db 32
 db 208
 db 53
 db 126
 db 183
 db 200
 db 121
 db 254
 db 8
 db 194
 db 121
 db 238
 db 53
 db 201
 db 254
 db 10
 db 192
 db 54
 db 0
 db 201
 db 121
 db 205
 db 20
 db 238
 db 210
 db 144
 db 238
 db 245
 db 14
 db 94
 db 205
 db 72
 db 238
 db 241
 db 246
 db 64
 db 79
 db 121
 db 254
 db 9
 db 194
 db 72
 db 238
 db 14
 db 32
 db 205
 db 72
 db 238
 db 58
 db 12
 db 240
 db 230
 db 7
 db 194
 db 150
 db 238
 db 201
 db 205
 db 172
 db 238
 db 14
 db 32
 db 205
 db 12
 db 251
 db 14
 db 8
 db 195
 db 12
 db 251
 db 14
 db 35
 db 205
 db 72
 db 238
 db 205
 db 201
 db 238
 db 58
 db 12
 db 240
 db 33
 db 11
 db 240
 db 190
 db 208
 db 14
 db 32
 db 205
 db 72
 db 238
 db 195
 db 185
 db 238
 db 14
 db 13
 db 205
 db 72
 db 238
 db 14
 db 10
 db 195
 db 72
 db 238
 db 10
 db 254
 db 36
 db 200
 db 3
 db 197
 db 79
 db 205
 db 144
 db 238
 db 193
 db 195
 db 211
 db 238
 db 58
 db 12
 db 240
 db 50
 db 11
 db 240
 db 42
 db 67
 db 240
 db 78
 db 35
 db 229
 db 6
 db 0
 db 197
 db 229
 db 205
 db 251
 db 237
 db 0
 db 0
 db 225
 db 193
 db 254
 db 13
 db 202
 db 193
 db 239
 db 254
 db 10
 db 202
 db 193
 db 239
 db 254
 db 8
 db 194
 db 22
 db 239
 db 120
 db 183
 db 202
 db 239
 db 238
 db 5
 db 58
 db 12
 db 240
 db 50
 db 10
 db 240
 db 195
 db 112
 db 239
 db 254
 db 127
 db 194
 db 38
 db 239
 db 120
 db 183
 db 202
 db 239
 db 238
 db 126
 db 5
 db 43
 db 195
 db 169
 db 239
 db 254
 db 5
 db 194
 db 55
 db 239
 db 197
 db 229
 db 205
 db 201
 db 238
 db 175
 db 50
 db 11
 db 240
 db 195
 db 241
 db 238
 db 254
 db 16
 db 194
 db 72
 db 239
 db 229
 db 33
 db 13
 db 240
 db 62
 db 1
 db 150
 db 119
 db 225
 db 195
 db 239
 db 238
 db 254
 db 24
 db 194
 db 95
 db 239
 db 225
 db 58
 db 11
 db 240
 db 33
 db 12
 db 240
 db 190
 db 210
 db 225
 db 238
 db 53
 db 205
 db 164
 db 238
 db 195
 db 78
 db 239
 db 254
 db 21
 db 194
 db 107
 db 239
 db 205
 db 177
 db 238
 db 225
 db 195
 db 225
 db 238
 db 254
 db 18
 db 194
 db 166
 db 239
 db 197
 db 205
 db 177
 db 238
 db 193
 db 225
 db 229
 db 197
 db 120
 db 183
 db 202
 db 138
 db 239
 db 35
 db 78
 db 5
 db 197
 db 229
 db 205
 db 127
 db 238
 db 225
 db 193
 db 195
 db 120
 db 239
 db 229
 db 58
 db 10
 db 240
 db 183
 db 202
 db 241
 db 238
 db 33
 db 12
 db 240
 db 150
 db 50
 db 10
 db 240
 db 205
 db 164
 db 238
 db 33
 db 10
 db 240
 db 53
 db 194
 db 153
 db 239
 db 195
 db 241
 db 238
 db 35
 db 119
 db 4
 db 197
 db 229
 db 79
 db 205
 db 127
 db 238
 db 225
 db 193
 db 126
 db 254
 db 3
 db 120
 db 194
 db 189
 db 239
 db 254
 db 1
 db 202
 db 0
 db 0
 db 185
 db 218
 db 239
 db 238
 db 225
 db 112
 db 14
 db 13
 db 195
 db 72
 db 238
 db 205
 db 6
 db 238
 db 195
 db 1
 db 240
 db 205
 db 21
 db 251
 db 195
 db 1
 db 240
 db 121
 db 60
 db 202
 db 224
 db 239
 db 60
 db 202
 db 6
 db 251
 db 195
 db 12
 db 251
 db 205
 db 6
 db 251
 db 183
 db 202
 db 145
 db 250
 db 205
 db 9
 db 251
 db 195
 db 1
 db 240
 db 58
 db 3
 db 0
 db 195
 db 1
 db 240
 db 33
 db 3
 db 0
 db 113
 db 201
 db 235
 db 77
 db 68
 db 195
 db 211
 db 238
 db 205
 db 35
 db 238
 db 50
 db 69
 db 240
 db 201
 db 62
 db 1
 db 195
 db 1
 db 240
 db 0
 db 2
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 33
 db 11
 db 237
 db 94
 db 35
 db 86
 db 235
 db 233
 db 12
 db 13
 db 200
 db 26
 db 119
 db 19
 db 35
 db 195
 db 80
 db 240
 db 58
 db 66
 db 240
 db 79
 db 205
 db 27
 db 251
 db 124
 db 181
 db 200
 db 94
 db 35
 db 86
 db 35
 db 34
 db 179
 db 250
 db 35
 db 35
 db 34
 db 181
 db 250
 db 35
 db 35
 db 34
 db 183
 db 250
 db 35
 db 35
 db 235
 db 34
 db 208
 db 250
 db 33
 db 185
 db 250
 db 14
 db 8
 db 205
 db 79
 db 240
 db 42
 db 187
 db 250
 db 235
 db 33
 db 193
 db 250
 db 14
 db 15
 db 205
 db 79
 db 240
 db 42
 db 198
 db 250
 db 124
 db 33
 db 221
 db 250
 db 54
 db 255
 db 183
 db 202
 db 157
 db 240
 db 54
 db 0
 db 62
 db 255
 db 183
 db 201
 db 205
 db 24
 db 251
 db 175
 db 42
 db 181
 db 250
 db 119
 db 35
 db 119
 db 42
 db 183
 db 250
 db 119
 db 35
 db 119
 db 201
 db 205
 db 39
 db 251
 db 195
 db 187
 db 240
 db 205
 db 42
 db 251
 db 183
 db 200
 db 33
 db 9
 db 237
 db 195
 db 74
 db 240
 db 42
 db 234
 db 250
 db 14
 db 2
 db 205
 db 234
 db 241
 db 34
 db 229
 db 250
 db 34
 db 236
 db 250
 db 33
 db 229
 db 250
 db 78
 db 35
 db 70
 db 42
 db 183
 db 250
 db 94
 db 35
 db 86
 db 42
 db 181
 db 250
 db 126
 db 35
 db 102
 db 111
 db 121
 db 147
 db 120
 db 154
 db 210
 db 250
 db 240
 db 229
 db 42
 db 193
 db 250
 db 123
 db 149
 db 95
 db 122
 db 156
 db 87
 db 225
 db 43
 db 195
 db 228
 db 240
 db 229
 db 42
 db 193
 db 250
 db 25
 db 218
 db 15
 db 241
 db 121
 db 149
 db 120
 db 156
 db 218
 db 15
 db 241
 db 235
 db 225
 db 35
 db 195
 db 250
 db 240
 db 225
 db 197
 db 213
 db 229
 db 235
 db 42
 db 206
 db 250
 db 25
 db 68
 db 77
 db 205
 db 30
 db 251
 db 209
 db 42
 db 181
 db 250
 db 115
 db 35
 db 114
 db 209
 db 42
 db 183
 db 250
 db 115
 db 35
 db 114
 db 193
 db 121
 db 147
 db 79
 db 120
 db 154
 db 71
 db 42
 db 208
 db 250
 db 235
 db 205
 db 48
 db 251
 db 77
 db 68
 db 195
 db 33
 db 251
 db 33
 db 195
 db 250
 db 78
 db 58
 db 227
 db 250
 db 183
 db 31
 db 13
 db 194
 db 69
 db 241
 db 71
 db 62
 db 8
 db 150
 db 79
 db 58
 db 226
 db 250
 db 13
 db 202
 db 92
 db 241
 db 183
 db 23
 db 195
 db 83
 db 241
 db 128
 db 201
 db 42
 db 67
 db 240
 db 17
 db 16
 db 0
 db 25
 db 9
 db 58
 db 221
 db 250
 db 183
 db 202
 db 113
 db 241
 db 110
 db 38
 db 0
 db 201
 db 9
 db 94
 db 35
 db 86
 db 235
 db 201
 db 205
 db 62
 db 241
 db 79
 db 6
 db 0
 db 205
 db 94
 db 241
 db 34
 db 229
 db 250
 db 201
 db 42
 db 229
 db 250
 db 125
 db 180
 db 201
 db 58
 db 195
 db 250
 db 42
 db 229
 db 250
 db 41
 db 61
 db 194
 db 144
 db 241
 db 34
 db 231
 db 250
 db 58
 db 196
 db 250
 db 79
 db 58
 db 227
 db 250
 db 161
 db 181
 db 111
 db 34
 db 229
 db 250
 db 201
 db 42
 db 67
 db 240
 db 17
 db 12
 db 0
 db 25
 db 201
 db 42
 db 67
 db 240
 db 17
 db 15
 db 0
 db 25
 db 235
 db 33
 db 17
 db 0
 db 25
 db 201
 db 205
 db 174
 db 241
 db 126
 db 50
 db 227
 db 250
 db 235
 db 126
 db 50
 db 225
 db 250
 db 205
 db 166
 db 241
 db 58
 db 197
 db 250
 db 166
 db 50
 db 226
 db 250
 db 201
 db 205
 db 174
 db 241
 db 58
 db 213
 db 250
 db 254
 db 2
 db 194
 db 222
 db 241
 db 175
 db 79
 db 58
 db 227
 db 250
 db 129
 db 119
 db 235
 db 58
 db 225
 db 250
 db 119
 db 201
 db 12
 db 13
 db 200
 db 124
 db 183
 db 31
 db 103
 db 125
 db 31
 db 111
 db 195
 db 235
 db 241
 db 14
 db 128
 db 42
 db 185
 db 250
 db 175
 db 134
 db 35
 db 13
 db 194
 db 253
 db 241
 db 201
 db 12
 db 13
 db 200
 db 41
 db 195
 db 5
 db 242
 db 197
 db 58
 db 66
 db 240
 db 79
 db 33
 db 1
 db 0
 db 205
 db 4
 db 242
 db 193
 db 121
 db 181
 db 111
 db 120
 db 180
 db 103
 db 201
 db 42
 db 173
 db 250
 db 58
 db 66
 db 240
 db 79
 db 205
 db 234
 db 241
 db 125
 db 230
 db 1
 db 201
 db 33
 db 173
 db 250
 db 78
 db 35
 db 70
 db 205
 db 11
 db 242
 db 34
 db 173
 db 250
 db 42
 db 200
 db 250
 db 35
 db 235
 db 42
 db 179
 db 250
 db 115
 db 35
 db 114
 db 201
 db 205
 db 94
 db 242
 db 17
 db 9
 db 0
 db 25
 db 126
 db 23
 db 208
 db 33
 db 15
 db 237
 db 195
 db 74
 db 240
 db 205
 db 30
 db 242
 db 200
 db 33
 db 13
 db 237
 db 195
 db 74
 db 240
 db 42
 db 185
 db 250
 db 58
 db 233
 db 250
 db 133
 db 111
 db 208
 db 36
 db 201
 db 42
 db 67
 db 240
 db 17
 db 14
 db 0
 db 25
 db 126
 db 201
 db 205
 db 105
 db 242
 db 54
 db 0
 db 201
 db 205
 db 105
 db 242
 db 246
 db 128
 db 119
 db 201
 db 42
 db 234
 db 250
 db 235
 db 42
 db 179
 db 250
 db 123
 db 150
 db 35
 db 122
 db 158
 db 201
 db 205
 db 127
 db 242
 db 216
 db 19
 db 114
 db 43
 db 115
 db 201
 db 123
 db 149
 db 111
 db 122
 db 156
 db 103
 db 201
 db 14
 db 255
 db 42
 db 236
 db 250
 db 235
 db 42
 db 204
 db 250
 db 205
 db 149
 db 242
 db 208
 db 197
 db 205
 db 247
 db 241
 db 42
 db 189
 db 250
 db 235
 db 42
 db 236
 db 250
 db 25
 db 193
 db 12
 db 202
 db 196
 db 242
 db 190
 db 200
 db 205
 db 127
 db 242
 db 208
 db 205
 db 44
 db 242
 db 201
 db 119
 db 201
 db 205
 db 156
 db 242
 db 205
 db 224
 db 242
 db 14
 db 1
 db 205
 db 184
 db 240
 db 195
 db 218
 db 242
 db 205
 db 224
 db 242
 db 205
 db 178
 db 240
 db 33
 db 177
 db 250
 db 195
 db 227
 db 242
 db 33
 db 185
 db 250
 db 78
 db 35
 db 70
 db 195
 db 36
 db 251
 db 42
 db 185
 db 250
 db 235
 db 42
 db 177
 db 250
 db 14
 db 128
 db 195
 db 79
 db 240
 db 33
 db 234
 db 250
 db 126
 db 35
 db 190
 db 192
 db 60
 db 201
 db 33
 db 255
 db 255
 db 34
 db 234
 db 250
 db 201
 db 42
 db 200
 db 250
 db 235
 db 42
 db 234
 db 250
 db 35
 db 34
 db 234
 db 250
 db 205
 db 149
 db 242
 db 210
 db 25
 db 243
 db 195
 db 254
 db 242
 db 58
 db 234
 db 250
 db 230
 db 3
 db 6
 db 5
 db 135
 db 5
 db 194
 db 32
 db 243
 db 50
 db 233
 db 250
 db 183
 db 192
 db 197
 db 205
 db 195
 db 240
 db 205
 db 212
 db 242
 db 193
 db 195
 db 158
 db 242
 db 121
 db 230
 db 7
 db 60
 db 95
 db 87
 db 121
 db 15
 db 15
 db 15
 db 230
 db 31
 db 79
 db 120
 db 135
 db 135
 db 135
 db 135
 db 135
 db 177
 db 79
 db 120
 db 15
 db 15
 db 15
 db 230
 db 31
 db 71
 db 42
 db 191
 db 250
 db 9
 db 126
 db 7
 db 29
 db 194
 db 86
 db 243
 db 201
 db 213
 db 205
 db 53
 db 243
 db 230
 db 254
 db 193
 db 177
 db 15
 db 21
 db 194
 db 100
 db 243
 db 119
 db 201
 db 205
 db 94
 db 242
 db 17
 db 16
 db 0
 db 25
 db 197
 db 14
 db 17
 db 209
 db 13
 db 200
 db 213
 db 58
 db 221
 db 250
 db 183
 db 202
 db 136
 db 243
 db 197
 db 229
 db 78
 db 6
 db 0
 db 195
 db 142
 db 243
 db 13
 db 197
 db 78
 db 35
 db 70
 db 229
 db 121
 db 176
 db 202
 db 157
 db 243
 db 42
 db 198
 db 250
 db 125
 db 145
 db 124
 db 152
 db 212
 db 92
 db 243
 db 225
 db 35
 db 193
 db 195
 db 117
 db 243
 db 42
 db 198
 db 250
 db 14
 db 3
 db 205
 db 234
 db 241
 db 35
 db 68
 db 77
 db 42
 db 191
 db 250
 db 54
 db 0
 db 35
 db 11
 db 120
 db 177
 db 194
 db 177
 db 243
 db 42
 db 202
 db 250
 db 235
 db 42
 db 191
 db 250
 db 115
 db 35
 db 114
 db 205
 db 161
 db 240
 db 42
 db 179
 db 250
 db 54
 db 3
 db 35
 db 54
 db 0
 db 205
 db 254
 db 242
 db 14
 db 255
 db 205
 db 5
 db 243
 db 205
 db 245
 db 242
 db 200
 db 205
 db 94
 db 242
 db 62
 db 229
 db 190
 db 202
 db 210
 db 243
 db 58
 db 65
 db 240
 db 190
 db 194
 db 246
 db 243
 db 35
 db 126
 db 214
 db 36
 db 194
 db 246
 db 243
 db 61
 db 50
 db 69
 db 240
 db 14
 db 1
 db 205
 db 107
 db 243
 db 205
 db 140
 db 242
 db 195
 db 210
 db 243
 db 58
 db 212
 db 250
 db 195
 db 1
 db 240
 db 197
 db 245
 db 58
 db 197
 db 250
 db 47
 db 71
 db 121
 db 160
 db 79
 db 241
 db 160
 db 145
 db 230
 db 31
 db 193
 db 201
 db 62
 db 255
 db 50
 db 212
 db 250
 db 33
 db 216
 db 250
 db 113
 db 42
 db 67
 db 240
 db 34
 db 217
 db 250
 db 205
 db 254
 db 242
 db 205
 db 161
 db 240
 db 14
 db 0
 db 205
 db 5
 db 243
 db 205
 db 245
 db 242
 db 202
 db 148
 db 244
 db 42
 db 217
 db 250
 db 235
 db 26
 db 254
 db 229
 db 202
 db 74
 db 244
 db 213
 db 205
 db 127
 db 242
 db 209
 db 210
 db 148
 db 244
 db 205
 db 94
 db 242
 db 58
 db 216
 db 250
 db 79
 db 6
 db 0
 db 121
 db 183
 db 202
 db 131
 db 244
 db 26
 db 254
 db 63
 db 202
 db 124
 db 244
 db 120
 db 254
 db 13
 db 202
 db 124
 db 244
 db 254
 db 12
 db 26
 db 202
 db 115
 db 244
 db 150
 db 230
 db 127
 db 194
 db 45
 db 244
 db 195
 db 124
 db 244
 db 197
 db 78
 db 205
 db 7
 db 244
 db 193
 db 194
 db 45
 db 244
 db 19
 db 35
 db 4
 db 13
 db 195
 db 83
 db 244
 db 58
 db 234
 db 250
 db 230
 db 3
 db 50
 db 69
 db 240
 db 33
 db 212
 db 250
 db 126
 db 23
 db 208
 db 175
 db 119
 db 201
 db 205
 db 254
 db 242
 db 62
 db 255
 db 195
 db 1
 db 240
 db 205
 db 84
 db 242
 db 14
 db 12
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 200
 db 205
 db 68
 db 242
 db 205
 db 94
 db 242
 db 54
 db 229
 db 14
 db 0
 db 205
 db 107
 db 243
 db 205
 db 198
 db 242
 db 205
 db 45
 db 244
 db 195
 db 164
 db 244
 db 80
 db 89
 db 121
 db 176
 db 202
 db 209
 db 244
 db 11
 db 213
 db 197
 db 205
 db 53
 db 243
 db 31
 db 210
 db 236
 db 244
 db 193
 db 209
 db 42
 db 198
 db 250
 db 123
 db 149
 db 122
 db 156
 db 210
 db 244
 db 244
 db 19
 db 197
 db 213
 db 66
 db 75
 db 205
 db 53
 db 243
 db 31
 db 210
 db 236
 db 244
 db 209
 db 193
 db 195
 db 192
 db 244
 db 23
 db 60
 db 205
 db 100
 db 243
 db 225
 db 209
 db 201
 db 121
 db 176
 db 194
 db 192
 db 244
 db 33
 db 0
 db 0
 db 201
 db 14
 db 0
 db 30
 db 32
 db 213
 db 6
 db 0
 db 42
 db 67
 db 240
 db 9
 db 235
 db 205
 db 94
 db 242
 db 193
 db 205
 db 79
 db 240
 db 205
 db 195
 db 240
 db 195
 db 198
 db 242
 db 205
 db 84
 db 242
 db 14
 db 12
 db 205
 db 24
 db 244
 db 42
 db 67
 db 240
 db 126
 db 17
 db 16
 db 0
 db 25
 db 119
 db 205
 db 245
 db 242
 db 200
 db 205
 db 68
 db 242
 db 14
 db 16
 db 30
 db 12
 db 205
 db 1
 db 245
 db 205
 db 45
 db 244
 db 195
 db 39
 db 245
 db 14
 db 12
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 200
 db 14
 db 0
 db 30
 db 12
 db 205
 db 1
 db 245
 db 205
 db 45
 db 244
 db 195
 db 64
 db 245
 db 14
 db 15
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 200
 db 205
 db 166
 db 241
 db 126
 db 245
 db 229
 db 205
 db 94
 db 242
 db 235
 db 42
 db 67
 db 240
 db 14
 db 32
 db 213
 db 205
 db 79
 db 240
 db 205
 db 120
 db 242
 db 209
 db 33
 db 12
 db 0
 db 25
 db 78
 db 33
 db 15
 db 0
 db 25
 db 70
 db 225
 db 241
 db 119
 db 121
 db 190
 db 120
 db 202
 db 139
 db 245
 db 62
 db 0
 db 218
 db 139
 db 245
 db 62
 db 128
 db 42
 db 67
 db 240
 db 17
 db 15
 db 0
 db 25
 db 119
 db 201
 db 126
 db 35
 db 182
 db 43
 db 192
 db 26
 db 119
 db 19
 db 35
 db 26
 db 119
 db 27
 db 43
 db 201
 db 175
 db 50
 db 69
 db 240
 db 50
 db 234
 db 250
 db 50
 db 235
 db 250
 db 205
 db 30
 db 242
 db 192
 db 205
 db 105
 db 242
 db 230
 db 128
 db 192
 db 14
 db 15
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 200
 db 1
 db 16
 db 0
 db 205
 db 94
 db 242
 db 9
 db 235
 db 42
 db 67
 db 240
 db 9
 db 14
 db 16
 db 58
 db 221
 db 250
 db 183
 db 202
 db 232
 db 245
 db 126
 db 183
 db 26
 db 194
 db 219
 db 245
 db 119
 db 183
 db 194
 db 225
 db 245
 db 126
 db 18
 db 190
 db 194
 db 31
 db 246
 db 195
 db 253
 db 245
 db 205
 db 148
 db 245
 db 235
 db 205
 db 148
 db 245
 db 235
 db 26
 db 190
 db 194
 db 31
 db 246
 db 19
 db 35
 db 26
 db 190
 db 194
 db 31
 db 246
 db 13
 db 19
 db 35
 db 13
 db 194
 db 205
 db 245
 db 1
 db 236
 db 255
 db 9
 db 235
 db 9
 db 26
 db 190
 db 218
 db 23
 db 246
 db 119
 db 1
 db 3
 db 0
 db 9
 db 235
 db 9
 db 126
 db 18
 db 62
 db 255
 db 50
 db 210
 db 250
 db 195
 db 16
 db 245
 db 33
 db 69
 db 240
 db 53
 db 201
 db 205
 db 84
 db 242
 db 42
 db 67
 db 240
 db 229
 db 33
 db 172
 db 250
 db 34
 db 67
 db 240
 db 14
 db 1
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 225
 db 34
 db 67
 db 240
 db 200
 db 235
 db 33
 db 15
 db 0
 db 25
 db 14
 db 17
 db 175
 db 119
 db 35
 db 13
 db 194
 db 70
 db 246
 db 33
 db 13
 db 0
 db 25
 db 119
 db 205
 db 140
 db 242
 db 205
 db 253
 db 244
 db 195
 db 120
 db 242
 db 175
 db 50
 db 210
 db 250
 db 205
 db 162
 db 245
 db 205
 db 245
 db 242
 db 200
 db 42
 db 67
 db 240
 db 1
 db 12
 db 0
 db 9
 db 126
 db 60
 db 230
 db 31
 db 119
 db 202
 db 131
 db 246
 db 71
 db 58
 db 197
 db 250
 db 160
 db 33
 db 210
 db 250
 db 166
 db 202
 db 142
 db 246
 db 195
 db 172
 db 246
 db 1
 db 2
 db 0
 db 9
 db 52
 db 126
 db 230
 db 15
 db 202
 db 182
 db 246
 db 14
 db 15
 db 205
 db 24
 db 244
 db 205
 db 245
 db 242
 db 194
 db 172
 db 246
 db 58
 db 211
 db 250
 db 60
 db 202
 db 182
 db 246
 db 205
 db 36
 db 246
 db 205
 db 245
 db 242
 db 202
 db 182
 db 246
 db 195
 db 175
 db 246
 db 205
 db 90
 db 245
 db 205
 db 187
 db 241
 db 175
 db 195
 db 1
 db 240
 db 205
 db 5
 db 240
 db 195
 db 120
 db 242
 db 62
 db 1
 db 50
 db 213
 db 250
 db 62
 db 255
 db 50
 db 211
 db 250
 db 205
 db 187
 db 241
 db 58
 db 227
 db 250
 db 33
 db 225
 db 250
 db 190
 db 218
 db 230
 db 246
 db 254
 db 128
 db 194
 db 251
 db 246
 db 205
 db 90
 db 246
 db 175
 db 50
 db 227
 db 250
 db 58
 db 69
 db 240
 db 183
 db 194
 db 251
 db 246
 db 205
 db 119
 db 241
 db 205
 db 132
 db 241
 db 202
 db 251
 db 246
 db 205
 db 138
 db 241
 db 205
 db 209
 db 240
 db 205
 db 178
 db 240
 db 195
 db 210
 db 241
 db 195
 db 5
 db 240
 db 62
 db 1
 db 50
 db 213
 db 250
 db 62
 db 0
 db 50
 db 211
 db 250
 db 205
 db 84
 db 242
 db 42
 db 67
 db 240
 db 205
 db 71
 db 242
 db 205
 db 187
 db 241
 db 58
 db 227
 db 250
 db 254
 db 128
 db 210
 db 5
 db 240
 db 205
 db 119
 db 241
 db 205
 db 132
 db 241
 db 14
 db 0
 db 194
 db 110
 db 247
 db 205
 db 62
 db 241
 db 50
 db 215
 db 250
 db 1
 db 0
 db 0
 db 183
 db 202
 db 59
 db 247
 db 79
 db 11
 db 205
 db 94
 db 241
 db 68
 db 77
 db 205
 db 190
 db 244
 db 125
 db 180
 db 194
 db 72
 db 247
 db 62
 db 2
 db 195
 db 1
 db 240
 db 34
 db 229
 db 250
 db 235
 db 42
 db 67
 db 240
 db 1
 db 16
 db 0
 db 9
 db 58
 db 221
 db 250
 db 183
 db 58
 db 215
 db 250
 db 202
 db 100
 db 247
 db 205
 db 100
 db 242
 db 115
 db 195
 db 108
 db 247
 db 79
 db 6
 db 0
 db 9
 db 9
 db 115
 db 35
 db 114
 db 14
 db 2
 db 58
 db 69
 db 240
 db 183
 db 192
 db 197
 db 205
 db 138
 db 241
 db 58
 db 213
 db 250
 db 61
 db 61
 db 194
 db 187
 db 247
 db 193
 db 197
 db 121
 db 61
 db 61
 db 194
 db 187
 db 247
 db 229
 db 42
 db 185
 db 250
 db 87
 db 119
 db 35
 db 20
 db 242
 db 140
 db 247
 db 205
 db 224
 db 242
 db 42
 db 231
 db 250
 db 14
 db 2
 db 34
 db 229
 db 250
 db 197
 db 205
 db 209
 db 240
 db 193
 db 205
 db 184
 db 240
 db 42
 db 229
 db 250
 db 14
 db 0
 db 58
 db 196
 db 250
 db 71
 db 165
 db 184
 db 35
 db 194
 db 154
 db 247
 db 225
 db 34
 db 229
 db 250
 db 205
 db 218
 db 242
 db 205
 db 209
 db 240
 db 193
 db 197
 db 205
 db 184
 db 240
 db 193
 db 58
 db 227
 db 250
 db 33
 db 225
 db 250
 db 190
 db 218
 db 210
 db 247
 db 119
 db 52
 db 14
 db 2
 db 0
 db 0
 db 33
 db 0
 db 0
 db 245
 db 205
 db 105
 db 242
 db 230
 db 127
 db 119
 db 241
 db 254
 db 127
 db 194
 db 0
 db 248
 db 58
 db 213
 db 250
 db 254
 db 1
 db 194
 db 0
 db 248
 db 205
 db 210
 db 241
 db 205
 db 90
 db 246
 db 33
 db 69
 db 240
 db 126
 db 183
 db 194
 db 254
 db 247
 db 61
 db 50
 db 227
 db 250
 db 54
 db 0
 db 195
 db 210
 db 241
 db 175
 db 50
 db 213
 db 250
 db 197
 db 42
 db 67
 db 240
 db 235
 db 33
 db 33
 db 0
 db 25
 db 126
 db 230
 db 127
 db 245
 db 126
 db 23
 db 35
 db 126
 db 23
 db 230
 db 31
 db 79
 db 126
 db 31
 db 31
 db 31
 db 31
 db 230
 db 15
 db 71
 db 241
 db 35
 db 110
 db 44
 db 45
 db 46
 db 6
 db 194
 db 139
 db 248
 db 33
 db 32
 db 0
 db 25
 db 119
 db 33
 db 12
 db 0
 db 25
 db 121
 db 150
 db 194
 db 71
 db 248
 db 33
 db 14
 db 0
 db 25
 db 120
 db 150
 db 230
 db 127
 db 202
 db 127
 db 248
 db 197
 db 213
 db 205
 db 162
 db 245
 db 209
 db 193
 db 46
 db 3
 db 58
 db 69
 db 240
 db 60
 db 202
 db 132
 db 248
 db 33
 db 12
 db 0
 db 25
 db 113
 db 33
 db 14
 db 0
 db 25
 db 112
 db 205
 db 81
 db 245
 db 58
 db 69
 db 240
 db 60
 db 194
 db 127
 db 248
 db 193
 db 197
 db 46
 db 4
 db 12
 db 202
 db 132
 db 248
 db 205
 db 36
 db 246
 db 46
 db 5
 db 58
 db 69
 db 240
 db 60
 db 202
 db 132
 db 248
 db 193
 db 175
 db 195
 db 1
 db 240
 db 229
 db 205
 db 105
 db 242
 db 54
 db 192
 db 225
 db 193
 db 125
 db 50
 db 69
 db 240
 db 195
 db 120
 db 242
 db 14
 db 255
 db 205
 db 3
 db 248
 db 204
 db 193
 db 246
 db 201
 db 14
 db 0
 db 205
 db 3
 db 248
 db 204
 db 3
 db 247
 db 201
 db 235
 db 25
 db 78
 db 6
 db 0
 db 33
 db 12
 db 0
 db 25
 db 126
 db 15
 db 230
 db 128
 db 129
 db 79
 db 62
 db 0
 db 136
 db 71
 db 126
 db 15
 db 230
 db 15
 db 128
 db 71
 db 33
 db 14
 db 0
 db 25
 db 126
 db 135
 db 135
 db 135
 db 135
 db 245
 db 128
 db 71
 db 245
 db 225
 db 125
 db 225
 db 181
 db 230
 db 1
 db 201
 db 14
 db 12
 db 205
 db 24
 db 244
 db 42
 db 67
 db 240
 db 17
 db 33
 db 0
 db 25
 db 229
 db 114
 db 35
 db 114
 db 35
 db 114
 db 205
 db 245
 db 242
 db 202
 db 12
 db 249
 db 205
 db 94
 db 242
 db 17
 db 15
 db 0
 db 205
 db 165
 db 248
 db 225
 db 229
 db 95
 db 121
 db 150
 db 35
 db 120
 db 158
 db 35
 db 123
 db 158
 db 218
 db 6
 db 249
 db 115
 db 43
 db 112
 db 43
 db 113
 db 205
 db 45
 db 244
 db 195
 db 228
 db 248
 db 225
 db 201
 db 42
 db 67
 db 240
 db 17
 db 32
 db 0
 db 205
 db 165
 db 248
 db 33
 db 33
 db 0
 db 25
 db 113
 db 35
 db 112
 db 35
 db 119
 db 201
 db 42
 db 175
 db 250
 db 58
 db 66
 db 240
 db 79
 db 205
 db 234
 db 241
 db 229
 db 235
 db 205
 db 89
 db 240
 db 225
 db 204
 db 71
 db 240
 db 125
 db 31
 db 216
 db 42
 db 175
 db 250
 db 77
 db 68
 db 205
 db 11
 db 242
 db 34
 db 175
 db 250
 db 195
 db 163
 db 243
 db 58
 db 214
 db 250
 db 33
 db 66
 db 240
 db 190
 db 200
 db 119
 db 195
 db 33
 db 249
 db 62
 db 255
 db 50
 db 222
 db 250
 db 42
 db 67
 db 240
 db 126
 db 230
 db 31
 db 61
 db 50
 db 214
 db 250
 db 254
 db 30
 db 210
 db 117
 db 249
 db 58
 db 66
 db 240
 db 50
 db 223
 db 250
 db 126
 db 50
 db 224
 db 250
 db 230
 db 224
 db 119
 db 205
 db 69
 db 249
 db 58
 db 65
 db 240
 db 42
 db 67
 db 240
 db 182
 db 119
 db 201
 db 62
 db 34
 db 195
 db 1
 db 240
 db 33
 db 0
 db 0
 db 34
 db 173
 db 250
 db 34
 db 175
 db 250
 db 175
 db 50
 db 66
 db 240
 db 33
 db 128
 db 0
 db 34
 db 177
 db 250
 db 205
 db 218
 db 242
 db 195
 db 33
 db 249
 db 205
 db 114
 db 242
 db 205
 db 81
 db 249
 db 195
 db 81
 db 245
 db 205
 db 81
 db 249
 db 195
 db 162
 db 245
 db 14
 db 0
 db 235
 db 126
 db 254
 db 63
 db 202
 db 194
 db 249
 db 205
 db 166
 db 241
 db 126
 db 254
 db 63
 db 196
 db 114
 db 242
 db 205
 db 81
 db 249
 db 14
 db 15
 db 205
 db 24
 db 244
 db 195
 db 233
 db 242
 db 42
 db 217
 db 250
 db 34
 db 67
 db 240
 db 205
 db 81
 db 249
 db 205
 db 45
 db 244
 db 195
 db 233
 db 242
 db 205
 db 81
 db 249
 db 205
 db 156
 db 244
 db 195
 db 1
 db 244
 db 205
 db 81
 db 249
 db 195
 db 188
 db 246
 db 205
 db 81
 db 249
 db 195
 db 254
 db 246
 db 205
 db 114
 db 242
 db 205
 db 81
 db 249
 db 195
 db 36
 db 246
 db 205
 db 81
 db 249
 db 205
 db 22
 db 245
 db 195
 db 1
 db 244
 db 42
 db 175
 db 250
 db 195
 db 41
 db 250
 db 58
 db 66
 db 240
 db 195
 db 1
 db 240
 db 235
 db 34
 db 177
 db 250
 db 195
 db 218
 db 242
 db 42
 db 191
 db 250
 db 195
 db 41
 db 250
 db 42
 db 173
 db 250
 db 195
 db 41
 db 250
 db 205
 db 81
 db 249
 db 205
 db 59
 db 245
 db 195
 db 1
 db 244
 db 42
 db 187
 db 250
 db 34
 db 69
 db 240
 db 201
 db 58
 db 214
 db 250
 db 254
 db 255
 db 194
 db 59
 db 250
 db 58
 db 65
 db 240
 db 195
 db 1
 db 240
 db 230
 db 31
 db 50
 db 65
 db 240
 db 201
 db 205
 db 81
 db 249
 db 195
 db 147
 db 248
 db 205
 db 81
 db 249
 db 195
 db 156
 db 248
 db 205
 db 81
 db 249
 db 195
 db 210
 db 248
 db 42
 db 67
 db 240
 db 125
 db 47
 db 95
 db 124
 db 47
 db 42
 db 175
 db 250
 db 164
 db 87
 db 125
 db 163
 db 95
 db 42
 db 173
 db 250
 db 235
 db 34
 db 175
 db 250
 db 125
 db 163
 db 111
 db 124
 db 162
 db 103
 db 34
 db 173
 db 250
 db 201
 db 58
 db 222
 db 250
 db 183
 db 202
 db 145
 db 250
 db 42
 db 67
 db 240
 db 54
 db 0
 db 58
 db 224
 db 250
 db 183
 db 202
 db 145
 db 250
 db 119
 db 58
 db 223
 db 250
 db 50
 db 214
 db 250
 db 205
 db 69
 db 249
 db 42
 db 15
 db 240
 db 249
 db 42
 db 69
 db 240
 db 125
 db 68
 db 201
 db 205
 db 81
 db 249
 db 62
 db 2
 db 50
 db 213
 db 250
 db 14
 db 0
 db 205
 db 7
 db 248
 db 204
 db 3
 db 247
 db 201
 db 229
 db 0
 db 0
 db 0
 db 0
 db 128
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 195
 db 158
 db 251
 db 195
 db 166
 db 251
 db 195
 db 172
 db 251
 db 195
 db 179
 db 251
 db 195
 db 186
 db 251
 db 195
 db 193
 db 251
 db 195
 db 200
 db 251
 db 195
 db 207
 db 251
 db 195
 db 253
 db 251
 db 195
 db 221
 db 251
 db 195
 db 246
 db 251
 db 195
 db 6
 db 252
 db 195
 db 20
 db 252
 db 195
 db 31
 db 252
 db 195
 db 55
 db 252
 db 195
 db 77
 db 252
 db 195
 db 28
 db 252
 db 243
 db 62
 db 8
 db 211
 db 0
 db 62
 db 10
 db 211
 db 1
 db 62
 db 12
 db 211
 db 2
 db 62
 db 195
 db 50
 db 56
 db 0
 db 33
 db 117
 db 251
 db 34
 db 57
 db 0
 db 49
 db 171
 db 236
 db 251
 db 50
 db 0
 db 0
 db 33
 db 3
 db 251
 db 34
 db 1
 db 0
 db 50
 db 5
 db 0
 db 33
 db 6
 db 237
 db 34
 db 6
 db 0
 db 121
 db 50
 db 4
 db 0
 db 33
 db 128
 db 0
 db 34
 db 115
 db 251
 db 62
 db 129
 db 50
 db 3
 db 0
 db 195
 db 0
 db 229
 db 0
 db 0
 db 245
 db 229
 db 33
 db 0
 db 0
 db 57
 db 34
 db 152
 db 251
 db 49
 db 0
 db 1
 db 175
 db 211
 db 0
 db 62
 db 2
 db 211
 db 1
 db 197
 db 213
 db 205
 db 5
 db 0
 db 209
 db 193
 db 62
 db 8
 db 211
 db 0
 db 62
 db 10
 db 211
 db 1
 db 49
 db 0
 db 0
 db 225
 db 241
 db 251
 db 201
 db 243
 db 62
 db 255
 db 211
 db 0
 db 195
 db 0
 db 0
 db 17
 db 8
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 11
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 14
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 17
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 20
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 23
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 26
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 29
 db 0
 db 195
 db 81
 db 252
 db 121
 db 254
 db 2
 db 33
 db 0
 db 0
 db 208
 db 205
 db 214
 db 251
 db 183
 db 192
 db 121
 db 50
 db 4
 db 0
 db 183
 db 33
 db 96
 db 255
 db 200
 db 33
 db 112
 db 255
 db 201
 db 213
 db 17
 db 32
 db 0
 db 195
 db 81
 db 252
 db 197
 db 1
 db 0
 db 0
 db 205
 db 246
 db 251
 db 193
 db 201
 db 213
 db 17
 db 35
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 38
 db 0
 db 195
 db 81
 db 252
 db 229
 db 96
 db 105
 db 34
 db 115
 db 251
 db 225
 db 201
 db 96
 db 105
 db 201
 db 205
 db 13
 db 252
 db 183
 db 192
 db 213
 db 229
 db 17
 db 128
 db 255
 db 42
 db 115
 db 251
 db 26
 db 119
 db 35
 db 28
 db 194
 db 44
 db 252
 db 225
 db 209
 db 175
 db 201
 db 213
 db 229
 db 17
 db 128
 db 255
 db 42
 db 115
 db 251
 db 126
 db 18
 db 35
 db 28
 db 194
 db 63
 db 252
 db 225
 db 17
 db 41
 db 0
 db 195
 db 81
 db 252
 db 213
 db 17
 db 44
 db 0
 db 229
 db 33
 db 0
 db 0
 db 57
 db 34
 db 117
 db 252
 db 175
 db 243
 db 49
 db 0
 db 1
 db 211
 db 0
 db 62
 db 2
 db 211
 db 1
 db 251
 db 235
 db 197
 db 205
 db 124
 db 252
 db 193
 db 62
 db 8
 db 243
 db 211
 db 0
 db 62
 db 10
 db 211
 db 1
 db 49
 db 0
 db 0
 db 251
 db 122
 db 225
 db 209
 db 201
 db 233
 db 40
 db 0
 db 4
 db 15
 db 0
 db 138
 db 1
 db 63
 db 0
 db 128
 db 0
 db 16
 db 0
 db 2
 db 0
 db 40
 db 0
 db 4
 db 15
 db 0
 db 138
 db 1
 db 63
 db 0
 db 128
 db 0
 db 16
 db 0
 db 2
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 155
 db 252
 db 125
 db 252
 db 27
 db 253
 db 91
 db 253
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 155
 db 252
 db 140
 db 252
 db 59
 db 253
 db 91
 db 254
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
cpm_stop:
43AA 00        db 0
MulU16:
43AB 44        ld b, h
43AC 4D        ld c, l
43AD 21 00 00  ld hl, 0
43B0 3E 11     ld a, 17
_l482:
43B2 3D        dec a
43B3 C8        ret z
43B4 29        add hl, hl
43B5 EB        ex hl, de
43B6 D2 BE 43  jp nc, _l483
43B9 29        add hl, hl
43BA 23        inc hl
43BB C3 BF 43  jp _l484
_l483:
43BE 29        add hl, hl
_l484:
43BF EB        ex hl, de
43C0 D2 B2 43  jp nc, _l482
43C3 09        add hl, bc
43C4 D2 B2 43  jp nc, _l482
43C7 13        inc de
43C8 C3 B2 43  jp _l482
_l481:
43CB          SCREEN_0_ADDRESS equ 53248
43CB          SCREEN_1_ADDRESS equ 36864
43CB          PALETTE_WHITE equ 0
43CB          PALETTE_CYAN equ 1
43CB          PALETTE_MAGENTA equ 2
43CB          PALETTE_BLUE equ 3
43CB          PALETTE_YELLOW equ 4
43CB          PALETTE_GREEN equ 5
43CB          PALETTE_RED equ 6
43CB          PALETTE_XXX equ 7
43CB          PALETTE_GRAY equ 8
43CB          PALETTE_DARK_CYAN equ 9
43CB          PALETTE_DARK_MAGENTA equ 10
43CB          PALETTE_DARK_BLUE equ 11
43CB          PALETTE_DARK_YELLOW equ 12
43CB          PALETTE_DARK_GREEN equ 13
43CB          PALETTE_DARK_RED equ 14
43CB          PALETTE_BLACK equ 15
43CB          KEY_BACKSPACE equ 8
43CB          KEY_TAB equ 9
43CB          KEY_ENTER equ 13
43CB          KEY_ESC equ 27
43CB          KEY_ALT equ 1
43CB          KEY_F1 equ 242
43CB          KEY_F2 equ 243
43CB          KEY_F3 equ 244
43CB          KEY_UP equ 245
43CB          KEY_DOWN equ 246
43CB          KEY_RIGHT equ 247
43CB          KEY_LEFT equ 248
43CB          KEY_EXT_5 equ 249
43CB          KEY_END equ 250
43CB          KEY_HOME equ 251
43CB          KEY_INSERT equ 252
43CB          KEY_DEL equ 253
43CB          KEY_PG_UP equ 254
43CB          KEY_PG_DN equ 255
43CB          PORT_FRAME_IRQ_RESET equ 4
43CB          PORT_SD_SIZE equ 9
43CB          PORT_SD_RESULT equ 9
43CB          PORT_SD_DATA equ 8
43CB          PORT_UART_DATA equ 128
43CB          PORT_UART_CONFIG equ 129
43CB          PORT_UART_STATE equ 129
43CB          PORT_EXT_DATA_OUT equ 136
43CB          PORT_PALETTE_3 equ 144
43CB          PORT_PALETTE_2 equ 145
43CB          PORT_PALETTE_1 equ 146
43CB          PORT_PALETTE_0 equ 147
43CB          PORT_EXT_IN_DATA equ 137
43CB          PORT_A0 equ 160
43CB          PORT_ROM_0000 equ 168
43CB          PORT_ROM_0000__ROM equ 0
43CB          PORT_ROM_0000__RAM equ 128
43CB          PORT_VIDEO_MODE_1_LOW equ 185
43CB          PORT_VIDEO_MODE_1_HIGH equ 249
43CB          PORT_VIDEO_MODE_0_LOW equ 184
43CB          PORT_VIDEO_MODE_0_HIGH equ 248
43CB          PORT_UART_SPEED_0 equ 187
43CB          PORT_KEYBOARD equ 192
43CB          PORT_UART_SPEED_1 equ 251
43CB          PORT_CODE_ROM equ 186
43CB          PORT_CHARGEN_ROM equ 250
43CB          PORT_TAPE_AND_IDX2 equ 153
43CB          PORT_TAPE_AND_IDX2_ID1_2 equ 2
43CB          PORT_TAPE_AND_IDX2_ID2_2 equ 4
43CB          PORT_TAPE_AND_IDX2_ID3_2 equ 8
43CB          PORT_TAPE_AND_IDX2_ID6_2 equ 64
43CB          PORT_TAPE_AND_IDX2_ID7_2 equ 128
43CB          PORT_RESET_CU1 equ 188
43CB          PORT_RESET_CU2 equ 189
43CB          PORT_RESET_CU3 equ 190
43CB          PORT_RESET_CU4 equ 191
43CB          PORT_SET_CU1 equ 252
43CB          PORT_SET_CU2 equ 253
43CB          PORT_SET_CU3 equ 254
43CB          PORT_SET_CU4 equ 255
43CB          PORT_TAPE_OUT equ 176
43CB          SD_COMMAND_READ equ 1
43CB          SD_COMMAND_READ_SIZE equ 5
43CB          SD_COMMAND_WRITE equ 2
43CB          SD_COMMAND_WRITE_SIZE equ 5+128
43CB          SD_RESULT_BUSY equ 255
43CB          SD_RESULT_OK equ 0
43CB          stack equ 256
43CB          entry_cpm_conout_address equ EntryCpmConout+1
43CB          cpm_dph_a equ 65376
43CB          cpm_dph_b equ 65392
43CB          cpm_dma_buffer equ 65408
CpmList:
43CB C9        ret
CpmPrSta:
43CC 16 00     ld d, 0
43CE C9        ret
43CF          SCREEN_0_ADDRESS equ 53248
43CF          SCREEN_1_ADDRESS equ 36864
43CF          PALETTE_WHITE equ 0
43CF          PALETTE_CYAN equ 1
43CF          PALETTE_MAGENTA equ 2
43CF          PALETTE_BLUE equ 3
43CF          PALETTE_YELLOW equ 4
43CF          PALETTE_GREEN equ 5
43CF          PALETTE_RED equ 6
43CF          PALETTE_XXX equ 7
43CF          PALETTE_GRAY equ 8
43CF          PALETTE_DARK_CYAN equ 9
43CF          PALETTE_DARK_MAGENTA equ 10
43CF          PALETTE_DARK_BLUE equ 11
43CF          PALETTE_DARK_YELLOW equ 12
43CF          PALETTE_DARK_GREEN equ 13
43CF          PALETTE_DARK_RED equ 14
43CF          PALETTE_BLACK equ 15
43CF          KEY_BACKSPACE equ 8
43CF          KEY_TAB equ 9
43CF          KEY_ENTER equ 13
43CF          KEY_ESC equ 27
43CF          KEY_ALT equ 1
43CF          KEY_F1 equ 242
43CF          KEY_F2 equ 243
43CF          KEY_F3 equ 244
43CF          KEY_UP equ 245
43CF          KEY_DOWN equ 246
43CF          KEY_RIGHT equ 247
43CF          KEY_LEFT equ 248
43CF          KEY_EXT_5 equ 249
43CF          KEY_END equ 250
43CF          KEY_HOME equ 251
43CF          KEY_INSERT equ 252
43CF          KEY_DEL equ 253
43CF          KEY_PG_UP equ 254
43CF          KEY_PG_DN equ 255
43CF          PORT_FRAME_IRQ_RESET equ 4
43CF          PORT_SD_SIZE equ 9
43CF          PORT_SD_RESULT equ 9
43CF          PORT_SD_DATA equ 8
43CF          PORT_UART_DATA equ 128
43CF          PORT_UART_CONFIG equ 129
43CF          PORT_UART_STATE equ 129
43CF          PORT_EXT_DATA_OUT equ 136
43CF          PORT_PALETTE_3 equ 144
43CF          PORT_PALETTE_2 equ 145
43CF          PORT_PALETTE_1 equ 146
43CF          PORT_PALETTE_0 equ 147
43CF          PORT_EXT_IN_DATA equ 137
43CF          PORT_A0 equ 160
43CF          PORT_ROM_0000 equ 168
43CF          PORT_ROM_0000__ROM equ 0
43CF          PORT_ROM_0000__RAM equ 128
43CF          PORT_VIDEO_MODE_1_LOW equ 185
43CF          PORT_VIDEO_MODE_1_HIGH equ 249
43CF          PORT_VIDEO_MODE_0_LOW equ 184
43CF          PORT_VIDEO_MODE_0_HIGH equ 248
43CF          PORT_UART_SPEED_0 equ 187
43CF          PORT_KEYBOARD equ 192
43CF          PORT_UART_SPEED_1 equ 251
43CF          PORT_CODE_ROM equ 186
43CF          PORT_CHARGEN_ROM equ 250
43CF          PORT_TAPE_AND_IDX2 equ 153
43CF          PORT_TAPE_AND_IDX2_ID1_2 equ 2
43CF          PORT_TAPE_AND_IDX2_ID2_2 equ 4
43CF          PORT_TAPE_AND_IDX2_ID3_2 equ 8
43CF          PORT_TAPE_AND_IDX2_ID6_2 equ 64
43CF          PORT_TAPE_AND_IDX2_ID7_2 equ 128
43CF          PORT_RESET_CU1 equ 188
43CF          PORT_RESET_CU2 equ 189
43CF          PORT_RESET_CU3 equ 190
43CF          PORT_RESET_CU4 equ 191
43CF          PORT_SET_CU1 equ 252
43CF          PORT_SET_CU2 equ 253
43CF          PORT_SET_CU3 equ 254
43CF          PORT_SET_CU4 equ 255
43CF          PORT_TAPE_OUT equ 176
43CF          SD_COMMAND_READ equ 1
43CF          SD_COMMAND_READ_SIZE equ 5
43CF          SD_COMMAND_WRITE equ 2
43CF          SD_COMMAND_WRITE_SIZE equ 5+128
43CF          SD_RESULT_BUSY equ 255
43CF          SD_RESULT_OK equ 0
43CF          stack equ 256
43CF          entry_cpm_conout_address equ EntryCpmConout+1
43CF          cpm_dph_a equ 65376
43CF          cpm_dph_b equ 65392
43CF          cpm_dma_buffer equ 65408
drive_number:
43CF 00        db 0
drive_track:
43D0 00 00     dw 0
drive_sector:
43D2 00        db 0
drive_dpb:
43D3 60 FF     dw cpm_dph_a
_l492:
WaitSd:
43D5 DB 09     in a, (PORT_SD_RESULT)
_l494:
43D7 FE FF     cp SD_RESULT_BUSY
43D9 CA D5 43  jp z, _l492
_l493:
43DC C9        ret
CpmSelDsk:
43DD CD D5 43  call WaitSd
43E0 3E 05     ld a, SD_COMMAND_READ_SIZE
43E2 D3 09     out (PORT_SD_SIZE), a
43E4 3E 01     ld a, SD_COMMAND_READ
43E6 D3 08     out (PORT_SD_DATA), a
43E8 79        ld a, c
43E9 3C        inc a
43EA 3C        inc a
43EB D3 08     out (PORT_SD_DATA), a
43ED AF        xor a
43EE D3 08     out (PORT_SD_DATA), a
43F0 D3 08     out (PORT_SD_DATA), a
43F2 D3 08     out (PORT_SD_DATA), a
43F4 D3 08     out (PORT_SD_DATA), a
43F6 CD D5 43  call WaitSd
43F9 B7        or a
43FA CA FF 43  jp z, _l496
43FD 57        ld d, a
43FE C9        ret
_l496:
43FF 79        ld a, c
4400 2A 6A FF  ld hl, (cpm_dph_a+10)
4403 FE 01     cp 1
4405 C2 0B 44  jp nz, _l497
4408 2A 7A FF  ld hl, (cpm_dph_b+10)
_l497:
440B 32 CF 43  ld (drive_number), a
440E 22 D3 43  ld (drive_dpb), hl
4411 06 0F     ld b, 15
_l498:
4413 DB 08     in a, (PORT_SD_DATA)
4415 77        ld (hl), a
4416 23        inc hl
_l500:
4417 05        dec b
4418 C2 13 44  jp nz, _l498
_l499:
441B 16 00     ld d, 0
441D C9        ret
CpmSetTrk:
441E 60        ld h, b
441F 69        ld l, c
4420 22 D0 43  ld (drive_track), hl
4423 C9        ret
CpmSetSec:
4424 79        ld a, c
4425 32 D2 43  ld (drive_sector), a
4428 C9        ret
ReadWriteSd:
4429 CD D5 43  call WaitSd
442C 78        ld a, b
442D D3 09     out (PORT_SD_SIZE), a
442F 79        ld a, c
4430 D3 08     out (PORT_SD_DATA), a
4432 3A CF 43  ld a, (drive_number)
4435 3C        inc a
4436 3C        inc a
4437 D3 08     out (PORT_SD_DATA), a
4439 2A D3 43  ld hl, (drive_dpb)
443C 5E        ld e, (hl)
443D 23        inc hl
443E 56        ld d, (hl)
443F 2A D0 43  ld hl, (drive_track)
4442 CD AB 43  call MulU16
4445 06 00     ld b, 0
4447 3A D2 43  ld a, (drive_sector)
444A 4F        ld c, a
444B 09        add hl, bc
444C D2 50 44  jp nc, _l504
444F 13        inc de
_l504:
4450 7D        ld a, l
4451 D3 08     out (PORT_SD_DATA), a
4453 7C        ld a, h
4454 D3 08     out (PORT_SD_DATA), a
4456 7B        ld a, e
4457 D3 08     out (PORT_SD_DATA), a
4459 7A        ld a, d
445A D3 08     out (PORT_SD_DATA), a
445C C9        ret
CpmRead:
445D 01 01 05  ld bc, SD_COMMAND_READ_SIZE<<8|SD_COMMAND_READ
4460 CD 29 44  call ReadWriteSd
4463 CD D5 43  call WaitSd
4466 B7        or a
4467 CA 6C 44  jp z, _l506
446A 57        ld d, a
446B C9        ret
_l506:
446C 21 80 FF  ld hl, cpm_dma_buffer
_l507:
446F DB 08     in a, (PORT_SD_DATA)
4471 77        ld (hl), a
4472 2C        inc l
_l509:
4473 C2 6F 44  jp nz, _l507
_l508:
4476 16 00     ld d, 0
4478 C9        ret
CpmWrite:
4479 01 02 85  ld bc, SD_COMMAND_WRITE_SIZE<<8|SD_COMMAND_WRITE
447C CD 29 44  call ReadWriteSd
447F 21 80 FF  ld hl, cpm_dma_buffer
_l511:
4482 7E        ld a, (hl)
4483 D3 08     out (PORT_SD_DATA), a
4485 2C        inc l
_l513:
4486 C2 82 44  jp nz, _l511
_l512:
4489 CD D5 43  call WaitSd
448C 57        ld d, a
448D C9        ret
ReadWriteConfig:
448E CD D5 43  call WaitSd
4491 78        ld a, b
4492 D3 09     out (PORT_SD_SIZE), a
4494 79        ld a, c
4495 D3 08     out (PORT_SD_DATA), a
4497 3E 01     ld a, 1
4499 D3 08     out (PORT_SD_DATA), a
449B AF        xor a
449C D3 08     out (PORT_SD_DATA), a
449E D3 08     out (PORT_SD_DATA), a
44A0 D3 08     out (PORT_SD_DATA), a
44A2 D3 08     out (PORT_SD_DATA), a
44A4 C9        ret
ReadConfig:
44A5 3E 80     ld a, 128
44A7 91        sub c
44A8 47        ld b, a
44A9 D2 AF 44  jp nc, _l516
44AC 3E 01     ld a, 1
44AE C9        ret
_l516:
44AF E5        push hl
44B0 C5        push bc
44B1 01 01 05  ld bc, SD_COMMAND_READ_SIZE<<8|SD_COMMAND_READ
44B4 CD 8E 44  call ReadWriteConfig
44B7 CD D5 43  call WaitSd
44BA C1        pop bc
44BB E1        pop hl
44BC B7        or a
44BD C0        ret nz
_l517:
44BE DB 08     in a, (PORT_SD_DATA)
44C0 77        ld (hl), a
44C1 23        inc hl
_l519:
44C2 0D        dec c
44C3 C2 BE 44  jp nz, _l517
_l518:
_l520:
44C6 DB 08     in a, (PORT_SD_DATA)
_l522:
44C8 05        dec b
44C9 C2 C6 44  jp nz, _l520
_l521:
44CC AF        xor a
44CD C9        ret
WriteConfig:
44CE 3E 80     ld a, 128
44D0 91        sub c
44D1 47        ld b, a
44D2 E5        push hl
44D3 C5        push bc
44D4 01 02 85  ld bc, SD_COMMAND_WRITE_SIZE<<8|SD_COMMAND_WRITE
44D7 CD 8E 44  call ReadWriteConfig
44DA C1        pop bc
44DB E1        pop hl
_l524:
44DC 7E        ld a, (hl)
44DD D3 08     out (PORT_SD_DATA), a
44DF 23        inc hl
_l526:
44E0 0D        dec c
44E1 C2 DC 44  jp nz, _l524
_l525:
44E4 AF        xor a
_l527:
44E5 D3 08     out (PORT_SD_DATA), a
_l529:
44E7 05        dec b
44E8 C2 E5 44  jp nz, _l527
_l528:
44EB CD D5 43  call WaitSd
44EE B7        or a
44EF C9        ret
44F0          SCREEN_0_ADDRESS equ 53248
44F0          SCREEN_1_ADDRESS equ 36864
44F0          PALETTE_WHITE equ 0
44F0          PALETTE_CYAN equ 1
44F0          PALETTE_MAGENTA equ 2
44F0          PALETTE_BLUE equ 3
44F0          PALETTE_YELLOW equ 4
44F0          PALETTE_GREEN equ 5
44F0          PALETTE_RED equ 6
44F0          PALETTE_XXX equ 7
44F0          PALETTE_GRAY equ 8
44F0          PALETTE_DARK_CYAN equ 9
44F0          PALETTE_DARK_MAGENTA equ 10
44F0          PALETTE_DARK_BLUE equ 11
44F0          PALETTE_DARK_YELLOW equ 12
44F0          PALETTE_DARK_GREEN equ 13
44F0          PALETTE_DARK_RED equ 14
44F0          PALETTE_BLACK equ 15
44F0          KEY_BACKSPACE equ 8
44F0          KEY_TAB equ 9
44F0          KEY_ENTER equ 13
44F0          KEY_ESC equ 27
44F0          KEY_ALT equ 1
44F0          KEY_F1 equ 242
44F0          KEY_F2 equ 243
44F0          KEY_F3 equ 244
44F0          KEY_UP equ 245
44F0          KEY_DOWN equ 246
44F0          KEY_RIGHT equ 247
44F0          KEY_LEFT equ 248
44F0          KEY_EXT_5 equ 249
44F0          KEY_END equ 250
44F0          KEY_HOME equ 251
44F0          KEY_INSERT equ 252
44F0          KEY_DEL equ 253
44F0          KEY_PG_UP equ 254
44F0          KEY_PG_DN equ 255
44F0          PORT_FRAME_IRQ_RESET equ 4
44F0          PORT_SD_SIZE equ 9
44F0          PORT_SD_RESULT equ 9
44F0          PORT_SD_DATA equ 8
44F0          PORT_UART_DATA equ 128
44F0          PORT_UART_CONFIG equ 129
44F0          PORT_UART_STATE equ 129
44F0          PORT_EXT_DATA_OUT equ 136
44F0          PORT_PALETTE_3 equ 144
44F0          PORT_PALETTE_2 equ 145
44F0          PORT_PALETTE_1 equ 146
44F0          PORT_PALETTE_0 equ 147
44F0          PORT_EXT_IN_DATA equ 137
44F0          PORT_A0 equ 160
44F0          PORT_ROM_0000 equ 168
44F0          PORT_ROM_0000__ROM equ 0
44F0          PORT_ROM_0000__RAM equ 128
44F0          PORT_VIDEO_MODE_1_LOW equ 185
44F0          PORT_VIDEO_MODE_1_HIGH equ 249
44F0          PORT_VIDEO_MODE_0_LOW equ 184
44F0          PORT_VIDEO_MODE_0_HIGH equ 248
44F0          PORT_UART_SPEED_0 equ 187
44F0          PORT_KEYBOARD equ 192
44F0          PORT_UART_SPEED_1 equ 251
44F0          PORT_CODE_ROM equ 186
44F0          PORT_CHARGEN_ROM equ 250
44F0          PORT_TAPE_AND_IDX2 equ 153
44F0          PORT_TAPE_AND_IDX2_ID1_2 equ 2
44F0          PORT_TAPE_AND_IDX2_ID2_2 equ 4
44F0          PORT_TAPE_AND_IDX2_ID3_2 equ 8
44F0          PORT_TAPE_AND_IDX2_ID6_2 equ 64
44F0          PORT_TAPE_AND_IDX2_ID7_2 equ 128
44F0          PORT_RESET_CU1 equ 188
44F0          PORT_RESET_CU2 equ 189
44F0          PORT_RESET_CU3 equ 190
44F0          PORT_RESET_CU4 equ 191
44F0          PORT_SET_CU1 equ 252
44F0          PORT_SET_CU2 equ 253
44F0          PORT_SET_CU3 equ 254
44F0          PORT_SET_CU4 equ 255
44F0          PORT_TAPE_OUT equ 176
44F0          SD_COMMAND_READ equ 1
44F0          SD_COMMAND_READ_SIZE equ 5
44F0          SD_COMMAND_WRITE equ 2
44F0          SD_COMMAND_WRITE_SIZE equ 5+128
44F0          SD_RESULT_BUSY equ 255
44F0          SD_RESULT_OK equ 0
44F0          stack equ 256
44F0          entry_cpm_conout_address equ EntryCpmConout+1
44F0          cpm_dph_a equ 65376
44F0          cpm_dph_b equ 65392
44F0          cpm_dma_buffer equ 65408
CpmPunch:
44F0 C9        ret
CpmReader:
44F1 16 00     ld d, 0
44F3 C9        ret
44F4          SCREEN_0_ADDRESS equ 53248
44F4          SCREEN_1_ADDRESS equ 36864
44F4          PALETTE_WHITE equ 0
44F4          PALETTE_CYAN equ 1
44F4          PALETTE_MAGENTA equ 2
44F4          PALETTE_BLUE equ 3
44F4          PALETTE_YELLOW equ 4
44F4          PALETTE_GREEN equ 5
44F4          PALETTE_RED equ 6
44F4          PALETTE_XXX equ 7
44F4          PALETTE_GRAY equ 8
44F4          PALETTE_DARK_CYAN equ 9
44F4          PALETTE_DARK_MAGENTA equ 10
44F4          PALETTE_DARK_BLUE equ 11
44F4          PALETTE_DARK_YELLOW equ 12
44F4          PALETTE_DARK_GREEN equ 13
44F4          PALETTE_DARK_RED equ 14
44F4          PALETTE_BLACK equ 15
44F4          KEY_BACKSPACE equ 8
44F4          KEY_TAB equ 9
44F4          KEY_ENTER equ 13
44F4          KEY_ESC equ 27
44F4          KEY_ALT equ 1
44F4          KEY_F1 equ 242
44F4          KEY_F2 equ 243
44F4          KEY_F3 equ 244
44F4          KEY_UP equ 245
44F4          KEY_DOWN equ 246
44F4          KEY_RIGHT equ 247
44F4          KEY_LEFT equ 248
44F4          KEY_EXT_5 equ 249
44F4          KEY_END equ 250
44F4          KEY_HOME equ 251
44F4          KEY_INSERT equ 252
44F4          KEY_DEL equ 253
44F4          KEY_PG_UP equ 254
44F4          KEY_PG_DN equ 255
44F4          PORT_FRAME_IRQ_RESET equ 4
44F4          PORT_SD_SIZE equ 9
44F4          PORT_SD_RESULT equ 9
44F4          PORT_SD_DATA equ 8
44F4          PORT_UART_DATA equ 128
44F4          PORT_UART_CONFIG equ 129
44F4          PORT_UART_STATE equ 129
44F4          PORT_EXT_DATA_OUT equ 136
44F4          PORT_PALETTE_3 equ 144
44F4          PORT_PALETTE_2 equ 145
44F4          PORT_PALETTE_1 equ 146
44F4          PORT_PALETTE_0 equ 147
44F4          PORT_EXT_IN_DATA equ 137
44F4          PORT_A0 equ 160
44F4          PORT_ROM_0000 equ 168
44F4          PORT_ROM_0000__ROM equ 0
44F4          PORT_ROM_0000__RAM equ 128
44F4          PORT_VIDEO_MODE_1_LOW equ 185
44F4          PORT_VIDEO_MODE_1_HIGH equ 249
44F4          PORT_VIDEO_MODE_0_LOW equ 184
44F4          PORT_VIDEO_MODE_0_HIGH equ 248
44F4          PORT_UART_SPEED_0 equ 187
44F4          PORT_KEYBOARD equ 192
44F4          PORT_UART_SPEED_1 equ 251
44F4          PORT_CODE_ROM equ 186
44F4          PORT_CHARGEN_ROM equ 250
44F4          PORT_TAPE_AND_IDX2 equ 153
44F4          PORT_TAPE_AND_IDX2_ID1_2 equ 2
44F4          PORT_TAPE_AND_IDX2_ID2_2 equ 4
44F4          PORT_TAPE_AND_IDX2_ID3_2 equ 8
44F4          PORT_TAPE_AND_IDX2_ID6_2 equ 64
44F4          PORT_TAPE_AND_IDX2_ID7_2 equ 128
44F4          PORT_RESET_CU1 equ 188
44F4          PORT_RESET_CU2 equ 189
44F4          PORT_RESET_CU3 equ 190
44F4          PORT_RESET_CU4 equ 191
44F4          PORT_SET_CU1 equ 252
44F4          PORT_SET_CU2 equ 253
44F4          PORT_SET_CU3 equ 254
44F4          PORT_SET_CU4 equ 255
44F4          PORT_TAPE_OUT equ 176
44F4          SD_COMMAND_READ equ 1
44F4          SD_COMMAND_READ_SIZE equ 5
44F4          SD_COMMAND_WRITE equ 2
44F4          SD_COMMAND_WRITE_SIZE equ 5+128
44F4          SD_RESULT_BUSY equ 255
44F4          SD_RESULT_OK equ 0
44F4          MIT_RETURN equ 0
44F4          MIT_SUBMENU equ 1
44F4          MIT_JUMP equ 2
44F4          TEXT_SCREEN_HEIGHT equ 25
44F4          FONT_HEIGHT equ 10
44F4          FONT_WIDTH equ 3
44F4          DrawCharAddress equ DrawChar+1
44F4          SetColorAddress equ SetColor+1
44F4          DrawCursorAddress equ DrawCursor+1
44F4          MOD_CTR equ 1
44F4          MOD_SHIFT equ 2
44F4          MOD_CAPS equ 16
44F4          MOD_NUM equ 32
44F4          MENU_FIRST_ITEM_Y equ 3
44F4          MENU_ITEMS_X equ 3
44F4          MENU_VALUES_X equ 20
44F4          MENU_COLOR_TITLE equ 2
44F4          MENU_COLOR_VALUE equ 3
44F4          MENU_COLOR_ITEM equ 1
44F4          MENU_COLOR_CURSOR equ 2
44F4          MENU_CURSOR_X equ 1
GetMenuItemAddress:
44F4 7B        ld a, e
44F5 87        add a
44F6 87        add a
44F7 87        add a
44F8 C6 02     add 2
44FA 85        add l
44FB 6F        ld l, a
44FC 8C        adc h
44FD 95        sub l
44FE 67        ld h, a
44FF C9        ret
MenuMoveCursor:
4500 E5        push hl
_l534:
4501 7B        ld a, e
4502 80        add b
4503 FE FF     cp 255
4505 CA 26 45  jp z, _l535
4508 87        add a
4509 87        add a
450A 87        add a
450B C6 02     add 2
450D 85        add l
450E 6F        ld l, a
450F 8C        adc h
4510 95        sub l
4511 67        ld h, a
4512 7E        ld a, (hl)
4513 23        inc hl
4514 66        ld h, (hl)
4515 6F        ld l, a
4516 7C        ld a, h
4517 B5        or l
4518 B7        or a
4519 C2 1E 45  jp nz, _l537
451C E1        pop hl
451D C9        ret
_l537:
451E 7B        ld a, e
451F 80        add b
4520 5F        ld e, a
_l536:
4521 7E        ld a, (hl)
4522 B7        or a
4523 CA 01 45  jp z, _l534
_l535:
4526 E1        pop hl
4527 C9        ret
MenuFindItem:
4528 1E 00     ld e, 0
452A 23        inc hl
452B 23        inc hl
_l540:
452C 7E        ld a, (hl)
452D 23        inc hl
452E B6        or (hl)
452F 23        inc hl
4530 C2 35 45  jp nz, _l541
4533 3C        inc a
4534 C9        ret
_l541:
4535 23        inc hl
4536 23        inc hl
4537 78        ld a, b
4538 BE        cp (hl)
4539 C8        ret z
453A 23        inc hl
453B 23        inc hl
453C 23        inc hl
453D 23        inc hl
453E 1C        inc e
453F C3 2C 45  jp _l540
_l539:
Menu:
4542 3E 0B     ld a, PALETTE_DARK_BLUE
4544 D3 90     out (144+(0&3)), a
4546 D3 91     out (144+(1&3)), a
4548 D3 92     out (144+(2&3)), a
454A D3 93     out (144+(3&3)), a
454C D3 B8     out (PORT_VIDEO_MODE_0_LOW), a
454E D3 F9     out (PORT_VIDEO_MODE_1_HIGH), a
4550 D5        push de
4551 E5        push hl
4552 3E 02     ld a, MENU_COLOR_TITLE
4554 CD A0 08  call SetColor
4557 CD B0 08  call ClearScreen
455A E1        pop hl
455B E5        push hl
455C 5E        ld e, (hl)
455D 23        inc hl
455E 56        ld d, (hl)
455F 23        inc hl
4560 E5        push hl
4561 EB        ex hl, de
4562 0E 00     ld c, 0
4564 11 01 03  ld de, 769
4567 CD AD 09  call DrawText
456A 3E 01     ld a, MENU_COLOR_ITEM
456C CD A0 08  call SetColor
456F E1        pop hl
4570 06 03     ld b, MENU_FIRST_ITEM_Y
_l544:
4572 5E        ld e, (hl)
4573 23        inc hl
4574 56        ld d, (hl)
4575 23        inc hl
4576 7A        ld a, d
4577 B7        or a
4578 CA DB 45  jp z, _l543
457B E5        push hl
457C C5        push bc
457D EB        ex hl, de
457E 16 03     ld d, MENU_ITEMS_X
4580 58        ld e, b
4581 0E 00     ld c, 0
4583 CD AD 09  call DrawText
4586 C1        pop bc
4587 E1        pop hl
4588 23        inc hl
4589 23        inc hl
458A 23        inc hl
458B 23        inc hl
458C E5        push hl
458D C5        push bc
458E 58        ld e, b
458F 4E        ld c, (hl)
4590 23        inc hl
4591 46        ld b, (hl)
4592 78        ld a, b
4593 B1        or c
4594 B7        or a
4595 CA D3 45  jp z, _l545
4598 0A        ld a, (bc)
4599 47        ld b, a
459A 2B        dec hl
459B 2B        dec hl
459C 4E        ld c, (hl)
459D 2B        dec hl
459E 6E        ld l, (hl)
459F 61        ld h, c
45A0 23        inc hl
45A1 23        inc hl
_l547:
45A2 7E        ld a, (hl)
45A3 23        inc hl
45A4 B6        or (hl)
45A5 23        inc hl
45A6 CA D3 45  jp z, _l546
45A9 23        inc hl
45AA 23        inc hl
45AB 78        ld a, b
45AC BE        cp (hl)
45AD C2 CC 45  jp nz, _l548
45B0 2B        dec hl
45B1 2B        dec hl
45B2 2B        dec hl
45B3 2B        dec hl
45B4 4E        ld c, (hl)
45B5 23        inc hl
45B6 66        ld h, (hl)
45B7 69        ld l, c
45B8 3E 03     ld a, MENU_COLOR_VALUE
45BA CD A6 08  call SetColorSave
45BD 16 14     ld d, MENU_VALUES_X
45BF 0E 00     ld c, 0
45C1 CD AD 09  call DrawText
45C4 3E 01     ld a, MENU_COLOR_ITEM
45C6 CD A6 08  call SetColorSave
45C9 C3 D3 45  jp _l546
_l548:
45CC 23        inc hl
45CD 23        inc hl
45CE 23        inc hl
45CF 23        inc hl
45D0 C3 A2 45  jp _l547
_l546:
_l545:
45D3 C1        pop bc
45D4 E1        pop hl
45D5 23        inc hl
45D6 23        inc hl
45D7 04        inc b
45D8 C3 72 45  jp _l544
_l543:
45DB E1        pop hl
45DC D1        pop de
45DD D3 F8     out (PORT_VIDEO_MODE_0_HIGH), a
45DF D3 B9     out (PORT_VIDEO_MODE_1_LOW), a
45E1 3E 0B     ld a, PALETTE_DARK_BLUE
45E3 D3 90     out (144+(0&3)), a
45E5 3E 00     ld a, PALETTE_WHITE
45E7 D3 91     out (144+(1&3)), a
45E9 3E 04     ld a, PALETTE_YELLOW
45EB D3 92     out (144+(2&3)), a
45ED 3E 01     ld a, PALETTE_CYAN
45EF D3 93     out (144+(3&3)), a
45F1 3E 02     ld a, MENU_COLOR_CURSOR
45F3 CD A6 08  call SetColorSave
45F6 05        dec b
45F7 53        ld d, e
_l550:
45F8 E5        push hl
45F9 7A        ld a, d
45FA BB        cp e
45FB CA 0E 46  jp z, _l551
45FE D5        push de
45FF 7A        ld a, d
4600 C6 03     add MENU_FIRST_ITEM_Y
4602 5F        ld e, a
4603 0E 00     ld c, 0
4605 16 01     ld d, MENU_CURSOR_X
4607 21 A1 46  ld hl, _l552
460A CD AD 09  call DrawText
460D D1        pop de
_l551:
460E D5        push de
460F 7B        ld a, e
4610 C6 03     add MENU_FIRST_ITEM_Y
4612 5F        ld e, a
4613 0E 00     ld c, 0
4615 16 01     ld d, MENU_CURSOR_X
4617 21 9D 46  ld hl, _l553
461A CD AD 09  call DrawText
461D D1        pop de
461E 53        ld d, e
461F E1        pop hl
_l556:
_l555:
4620 D5        push de
4621 E5        push hl
4622 CD CE 23  call ReadKeyboard
4625 E1        pop hl
4626 D1        pop de
_l558:
4627 CA 20 46  jp z, _l556
_l557:
462A FE 0D     cp KEY_ENTER
462C C2 7A 46  jp nz, _l559
462F E5        push hl
4630 CD F4 44  call GetMenuItemAddress
4633 23        inc hl
4634 23        inc hl
4635 7E        ld a, (hl)
4636 B7        or a
4637 C2 41 46  jp nz, _l560
463A 23        inc hl
463B 23        inc hl
463C 5E        ld e, (hl)
463D 23        inc hl
463E 56        ld d, (hl)
463F E1        pop hl
4640 C9        ret
_l560:
4641 FE 02     cp MIT_JUMP
4643 C2 4E 46  jp nz, _l561
4646 23        inc hl
4647 23        inc hl
4648 56        ld d, (hl)
4649 23        inc hl
464A 66        ld h, (hl)
464B 6A        ld l, d
464C D1        pop de
464D E9        jp hl
_l561:
464E FE 01     cp MIT_SUBMENU
4650 C2 76 46  jp nz, _l562
4653 D5        push de
4654 23        inc hl
4655 23        inc hl
4656 23        inc hl
4657 23        inc hl
4658 5E        ld e, (hl)
4659 23        inc hl
465A 56        ld d, (hl)
465B 2B        dec hl
465C D5        push de
465D 1A        ld a, (de)
465E 47        ld b, a
465F 2B        dec hl
4660 2B        dec hl
4661 56        ld d, (hl)
4662 23        inc hl
4663 66        ld h, (hl)
4664 6A        ld l, d
4665 E5        push hl
4666 CD 28 45  call MenuFindItem
4669 CA 6E 46  jp z, _l563
466C 1E 00     ld e, 0
_l563:
466E E1        pop hl
466F CD 42 45  call Menu
4672 7B        ld a, e
4673 D1        pop de
4674 12        ld (de), a
4675 D1        pop de
_l562:
4676 E1        pop hl
4677 C3 42 45  jp Menu
_l559:
467A FE F5     cp KEY_UP
467C C2 87 46  jp nz, _l564
467F 06 FF     ld b, -1
4681 CD 00 45  call MenuMoveCursor
4684 C3 97 46  jp _l554
_l564:
4687 FE F6     cp KEY_DOWN
4689 C2 94 46  jp nz, _l565
468C 06 01     ld b, 1
468E CD 00 45  call MenuMoveCursor
4691 C3 97 46  jp _l554
_l565:
4694 C3 20 46  jp _l555
_l554:
4697 C3 F8 45  jp _l550
_l549:
469A          ; Const strings
_l435:
469A 00 2C 00  db 0
 db 44
 db 0
_l553:
469D 10 00 29  db 16
 db 0
 db 41
 db 0
_l552:
46A1 20 00 29  db 32
 db 0
 db 41
 db 0
_l403:
46A5 31 00 2C  db 49
 db 0
 db 44
 db 0
_l404:
46A9 31 2E 35  db 49
 db 46
 db 53
 db 0
 db 44
 db 0
_l391:
46AF 31 32 30  db 49
 db 50
 db 48
 db 48
 db 32
 db 161
 db 174
 db 164
 db 0
 db 44
 db 0
_l386:
46BA 31 32 35  db 49
 db 50
 db 53
 db 49
 db 0
 db 44
 db 0
_l405:
46C1 32 00 2C  db 50
 db 0
 db 44
 db 0
_l392:
46C5 32 34 30  db 50
 db 52
 db 48
 db 48
 db 32
 db 161
 db 174
 db 164
 db 0
 db 44
 db 0
_l393:
46D0 34 38 30  db 52
 db 56
 db 48
 db 48
 db 32
 db 161
 db 174
 db 164
 db 0
 db 44
 db 0
_l397:
46DB 35 00 2C  db 53
 db 0
 db 44
 db 0
_l398:
46DF 36 00 2C  db 54
 db 0
 db 44
 db 0
_l374:
46E3 36 34 78  db 54
 db 52
 db 120
 db 50
 db 53
 db 32
 db 50
 db 32
 db 230
 db 162
 db 165
 db 226
 db 160
 db 0
 db 44
 db 0
_l375:
46F3 36 34 78  db 54
 db 52
 db 120
 db 50
 db 53
 db 32
 db 52
 db 32
 db 230
 db 162
 db 165
 db 226
 db 160
 db 0
 db 44
 db 0
_l399:
4703 37 00 2C  db 55
 db 0
 db 44
 db 0
_l400:
4707 38 00 2C  db 56
 db 0
 db 44
 db 0
_l385:
470B 38 36 36  db 56
 db 54
 db 54
 db 0
 db 44
 db 0
_l394:
4711 39 36 30  db 57
 db 54
 db 48
 db 48
 db 32
 db 161
 db 174
 db 164
 db 0
 db 44
 db 0
_l376:
471C 39 36 78  db 57
 db 54
 db 120
 db 50
 db 53
 db 32
 db 50
 db 32
 db 230
 db 162
 db 165
 db 226
 db 160
 db 0
 db 44
 db 0
_l377:
472C 39 36 78  db 57
 db 54
 db 120
 db 50
 db 53
 db 32
 db 52
 db 32
 db 230
 db 162
 db 165
 db 226
 db 160
 db 0
 db 44
 db 0
_l413:
473C 43 54 53  db 67
 db 84
 db 83
 db 47
 db 82
 db 84
 db 83
 db 0
 db 44
 db 0
_l443:
4746 55 41 52  db 85
 db 65
 db 82
 db 84
 db 32
 db 161
 db 168
 db 226
 db 32
 db 164
 db 160
 db 173
 db 173
 db 235
 db 229
 db 0
 db 44
 db 0
_l446:
4758 55 41 52  db 85
 db 65
 db 82
 db 84
 db 32
 db 170
 db 174
 db 173
 db 226
 db 224
 db 174
 db 171
 db 236
 db 0
 db 44
 db 0
_l442:
4768 55 41 52  db 85
 db 65
 db 82
 db 84
 db 32
 db 225
 db 170
 db 174
 db 224
 db 174
 db 225
 db 226
 db 236
 db 0
 db 44
 db 0
_l445:
4778 55 41 52  db 85
 db 65
 db 82
 db 84
 db 32
 db 225
 db 226
 db 174
 db 175
 db 32
 db 161
 db 168
 db 226
 db 235
 db 0
 db 44
 db 0
_l444:
4789 55 41 52  db 85
 db 65
 db 82
 db 84
 db 32
 db 231
 db 241
 db 226
 db 173
 db 174
 db 225
 db 226
 db 236
 db 0
 db 44
 db 0
_l382:
4799 55 53 42  db 85
 db 83
 db 66
 db 32
 db 228
 db 171
 db 165
 db 232
 db 170
 db 160
 db 32
 db 47
 db 32
 db 83
 db 68
 db 32
 db 170
 db 160
 db 224
 db 226
 db 160
 db 0
 db 44
 db 0
_l430:
47B1 81 A5 AB  db 129
 db 165
 db 171
 db 235
 db 169
 db 0
 db 44
 db 0
_l379:
47B9 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 164
 db 168
 db 225
 db 170
 db 174
 db 162
 db 174
 db 164
 db 0
 db 44
 db 0
_l384:
47CD 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 170
 db 174
 db 164
 db 168
 db 224
 db 174
 db 162
 db 170
 db 227
 db 0
 db 44
 db 0
_l396:
47E2 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 170
 db 174
 db 171
 db 45
 db 162
 db 174
 db 32
 db 161
 db 168
 db 226
 db 32
 db 164
 db 160
 db 173
 db 173
 db 235
 db 229
 db 32
 db 85
 db 65
 db 82
 db 84
 db 0
 db 44
 db 0
_l402:
4804 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 170
 db 174
 db 171
 db 45
 db 162
 db 174
 db 32
 db 225
 db 226
 db 174
 db 175
 db 174
 db 162
 db 235
 db 229
 db 32
 db 161
 db 168
 db 226
 db 32
 db 85
 db 65
 db 82
 db 84
 db 0
 db 44
 db 0
_l412:
4828 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 170
 db 174
 db 173
 db 226
 db 224
 db 174
 db 171
 db 236
 db 32
 db 175
 db 174
 db 226
 db 174
 db 170
 db 174
 db 172
 db 32
 db 85
 db 65
 db 82
 db 84
 db 0
 db 44
 db 0
_l407:
4849 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 170
 db 174
 db 173
 db 226
 db 224
 db 174
 db 171
 db 236
 db 32
 db 231
 db 241
 db 226
 db 173
 db 174
 db 225
 db 226
 db 168
 db 32
 db 85
 db 65
 db 82
 db 84
 db 0
 db 44
 db 0
_l373:
486B 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 224
 db 165
 db 166
 db 168
 db 172
 db 32
 db 237
 db 170
 db 224
 db 160
 db 173
 db 160
 db 0
 db 44
 db 0
_l390:
4883 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 225
 db 170
 db 174
 db 224
 db 174
 db 225
 db 226
 db 236
 db 32
 db 85
 db 65
 db 82
 db 84
 db 0
 db 44
 db 0
_l415:
489C 82 EB A1  db 130
 db 235
 db 161
 db 165
 db 224
 db 168
 db 226
 db 165
 db 32
 db 230
 db 162
 db 165
 db 226
 db 0
 db 44
 db 0
_l429:
48AC 83 AE AB  db 131
 db 174
 db 171
 db 227
 db 161
 db 174
 db 169
 db 0
 db 44
 db 0
_l447:
48B6 84 A8 E1  db 132
 db 168
 db 225
 db 170
 db 32
 db 65
 db 58
 db 0
 db 44
 db 0
_l448:
48C0 84 A8 E1  db 132
 db 168
 db 225
 db 170
 db 32
 db 66
 db 58
 db 0
 db 44
 db 0
_l426:
48CA 86 F1 AB  db 134
 db 241
 db 171
 db 226
 db 235
 db 169
 db 0
 db 44
 db 0
_l433:
48D3 87 A0 AF  db 135
 db 160
 db 175
 db 227
 db 225
 db 170
 db 32
 db 67
 db 80
 db 47
 db 77
 db 0
 db 44
 db 0
_l434:
48E1 87 A0 AF  db 135
 db 160
 db 175
 db 227
 db 225
 db 170
 db 32
 db 84
 db 45
 db 66
 db 65
 db 83
 db 73
 db 67
 db 0
 db 44
 db 0
_l425:
48F2 87 A5 AB  db 135
 db 165
 db 171
 db 165
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l473:
48FC 88 E1 AA  db 136
 db 225
 db 170
 db 224
 db 160
 db 32
 db 49
 db 48
 db 56
 db 48
 db 140
 db 0
 db 41
 db 0
_l432:
490A 88 E1 AA  db 136
 db 225
 db 170
 db 224
 db 160
 db 32
 db 49
 db 48
 db 56
 db 48
 db 140
 db 0
 db 44
 db 0
_l387:
4918 8A 8E 88  db 138
 db 142
 db 136
 db 45
 db 55
 db 0
 db 44
 db 0
_l388:
4920 8A 8E 88  db 138
 db 142
 db 136
 db 45
 db 56
 db 0
 db 44
 db 0
_l436:
4928 8A AE A4  db 138
 db 174
 db 164
 db 168
 db 224
 db 174
 db 162
 db 170
 db 160
 db 0
 db 44
 db 0
_l424:
4934 8A E0 A0  db 138
 db 224
 db 160
 db 225
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l410:
493E 8D A5 20  db 141
 db 165
 db 32
 db 231
 db 241
 db 226
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l408:
494A 8D A5 E2  db 141
 db 165
 db 226
 db 0
 db 44
 db 0
_l380:
4950 90 A5 A0  db 144
 db 165
 db 160
 db 171
 db 236
 db 173
 db 235
 db 169
 db 32
 db 65
 db 0
 db 44
 db 0
_l381:
495D 90 A5 A0  db 144
 db 165
 db 160
 db 171
 db 236
 db 173
 db 235
 db 169
 db 32
 db 66
 db 0
 db 44
 db 0
_l423:
496A 91 A5 E0  db 145
 db 165
 db 224
 db 235
 db 169
 db 0
 db 44
 db 0
_l427:
4972 91 A8 AD  db 145
 db 168
 db 173
 db 168
 db 169
 db 0
 db 44
 db 0
_l449:
497A 91 AE E5  db 145
 db 174
 db 229
 db 224
 db 160
 db 173
 db 168
 db 226
 db 236
 db 32
 db 173
 db 160
 db 225
 db 226
 db 224
 db 174
 db 169
 db 170
 db 168
 db 0
 db 44
 db 0
_l422:
4990 92 A5 AC  db 146
 db 165
 db 172
 db 173
 db 174
 db 45
 db 163
 db 174
 db 171
 db 227
 db 161
 db 174
 db 169
 db 0
 db 44
 db 0
_l419:
49A0 92 F1 AC  db 146
 db 241
 db 172
 db 173
 db 174
 db 45
 db 166
 db 241
 db 171
 db 226
 db 235
 db 169
 db 0
 db 44
 db 0
_l418:
49AF 92 F1 AC  db 146
 db 241
 db 172
 db 173
 db 174
 db 45
 db 167
 db 165
 db 171
 db 241
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l417:
49BF 92 F1 AC  db 146
 db 241
 db 172
 db 173
 db 174
 db 45
 db 170
 db 224
 db 160
 db 225
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l420:
49CF 92 F1 AC  db 146
 db 241
 db 172
 db 173
 db 174
 db 45
 db 225
 db 168
 db 173
 db 168
 db 169
 db 0
 db 44
 db 0
_l421:
49DD 92 F1 AC  db 146
 db 241
 db 172
 db 173
 db 174
 db 45
 db 228
 db 168
 db 174
 db 171
 db 165
 db 226
 db 174
 db 162
 db 235
 db 169
 db 0
 db 44
 db 0
_l428:
49F0 94 A8 AE  db 148
 db 168
 db 174
 db 171
 db 165
 db 226
 db 174
 db 162
 db 235
 db 169
 db 0
 db 44
 db 0
_l438:
49FD 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 48
 db 0
 db 44
 db 0
_l439:
4A06 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 49
 db 0
 db 44
 db 0
_l440:
4A0F 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 50
 db 0
 db 44
 db 0
_l441:
4A18 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 51
 db 0
 db 44
 db 0
_l416:
4A21 97 F1 E0  db 151
 db 241
 db 224
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l409:
4A2A 97 F1 E2  db 151
 db 241
 db 226
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l437:
4A33 9D AA E0  db 157
 db 170
 db 224
 db 160
 db 173
 db 0
 db 44
 db 0
4A3B 00 00 00  align 128
file_end:
4A80 00 00 00  savebin "boot.cpm", 0, $
