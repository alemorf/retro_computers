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
0000 C3 22 28  jp main
sector_count:
0003 93 00     dw (file_end+127)/128
CpmInterrupt:
0005 C3 EB 23  jp InterruptHandler
EntryCpmWBoot:
0008 C3 09 29  jp CpmWBoot
EntryCpmConst:
000B C3 84 07  jp CpmConst
EntryCpmConin:
000E C3 90 07  jp CpmConin
EntryCpmConout:
0011 C3 CE 06  jp CpmConout
EntryCpmList:
0014 C3 44 44  jp CpmList
EntryCpmPunch:
0017 C3 69 45  jp CpmPunch
EntryCpmReader:
001A C3 6A 45  jp CpmReader
EntryCpmSelDsk:
001D C3 56 44  jp CpmSelDsk
EntryCpmSetTrk:
0020 C3 97 44  jp CpmSetTrk
EntryCpmSetSec:
0023 C3 9D 44  jp CpmSetSec
EntryCpmRead:
0026 C3 D6 44  jp CpmRead
EntryCpmWrite:
0029 C3 F2 44  jp CpmWrite
EntryCpmPrSta:
002C C3 45 44  jp CpmPrSta
002F 00 00 00  org 56
EntryInterrupt:
0038 F5        push af
0039 C5        push bc
003A D5        push de
003B E5        push hl
003C CD EB 23  call InterruptHandler
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
Beep:
030B F3        di
030C 0E 00     ld c, 0
_l33:
030E D3 B0     out (PORT_TAPE_OUT), a
0310 3E 30     ld a, 48
_l36:
_l38:
0312 3D        dec a
0313 C2 12 03  jp nz, _l36
_l37:
0316 0D        dec c
_l35:
0317 0D        dec c
0318 C2 0E 03  jp nz, _l33
_l34:
031B FB        ei
031C C9        ret
BeginConsoleChange:
031D 3E 01     ld a, 1
031F D3 02     out (2), a
0321 D3 03     out (3), a
0323 21 01 01  ld hl, cursor_visible
0326 F3        di
0327 7E        ld a, (hl)
0328 36 00     ld (hl), 0
032A FB        ei
032B FE 03     cp 3
032D C2 38 03  jp nz, _l40
0330 2A 03 01  ld hl, (cursor_y_l_x_h)
0333 CD D6 07  call DrawCursor
0336 3E 01     ld a, 1
_l40:
0338 32 02 01  ld (cursor_visible_1), a
033B C9        ret
EndConsoleChange:
033C 3E 02     ld a, 2
033E 32 00 01  ld (cursor_blink_counter), a
0341 3A 02 01  ld a, (cursor_visible_1)
0344 32 01 01  ld (cursor_visible), a
0347 3E 0C     ld a, 6*2
0349 D3 02     out (2), a
034B 3E 0E     ld a, 7*2
034D D3 03     out (3), a
034F C9        ret
ConClear:
ConReset:
0350 AF        xor a
0351 32 01 01  ld (cursor_visible), a
0354 32 04 01  ld (cursor_x), a
0357 32 03 01  ld (cursor_y), a
035A C3 D9 07  jp ClearScreen
ConNextLine:
035D AF        xor a
035E 32 04 01  ld (cursor_x), a
0361 3A 03 01  ld a, (cursor_y)
0364 3C        inc a
0365 FE 19     cp TEXT_SCREEN_HEIGHT
0367 D2 7F 08  jp nc, ScrollUp
036A 32 03 01  ld (cursor_y), a
036D C9        ret
ConPrintChar:
036E C6 0B     add console_xlat
0370 6F        ld l, a
0371 CE 01     adc console_xlat>>8
0373 95        sub l
0374 67        ld h, a
0375 7E        ld a, (hl)
0376 2A 03 01  ld hl, (cursor_y_l_x_h)
0379 CD D0 07  call DrawChar
037C 2A CF 07  ld hl, (text_screen_width)
037F 3A 04 01  ld a, (cursor_x)
0382 3C        inc a
0383 BD        cp l
0384 D2 5D 03  jp nc, ConNextLine
0387 32 04 01  ld (cursor_x), a
038A C9        ret
ConEraseInLine:
038B C9        ret
038C 2A 03 01  ld hl, (cursor_y_l_x_h)
_l48:
038F E5        push hl
0390 7C        ld a, h
0391 E6 03     and 3
0393 4F        ld c, a
0394 7C        ld a, h
0395 0F 0F     rrca
 rrca
0397 E6 3F     and 63
0399 2F        cpl
039A 67        ld h, a
039B EB        ex hl, de
039C AF        xor a
039D CD D0 07  call DrawChar
03A0 E1        pop hl
03A1 7C        ld a, h
03A2 C6 03     add FONT_WIDTH
03A4 67        ld h, a
03A5 C3 8F 03  jp _l48
_l47:
CpmConoutCsi2:
03A8 79        ld a, c
03A9 FE 30     cp 48
03AB DA C2 03  jp c, _l50
03AE FE 3A     cp 57+1
03B0 D2 C2 03  jp nc, _l51
03B3 D6 30     sub 48
03B5 4F        ld c, a
03B6 2A 07 01  ld hl, (esc_param_ptr)
03B9 7E        ld a, (hl)
03BA 87        add a
03BB 47        ld b, a
03BC 87        add a
03BD 87        add a
03BE 80        add b
03BF 81        add c
03C0 77        ld (hl), a
03C1 C9        ret
_l50:
_l51:
03C2 FE 3B     cp 59
03C4 C2 CE 03  jp nz, _l52
03C7 21 06 01  ld hl, esc_param_2
03CA 22 07 01  ld (esc_param_ptr), hl
03CD C9        ret
_l52:
03CE 21 CE 06  ld hl, CpmConout
03D1 22 12 00  ld (entry_cpm_conout_address), hl
03D4 FE 48     cp 72
03D6 C2 F4 03  jp nz, _l53
03D9 3A 05 01  ld a, (esc_param)
03DC FE 19     cp TEXT_SCREEN_HEIGHT
03DE DA E2 03  jp c, _l54
03E1 AF        xor a
_l54:
03E2 32 03 01  ld (cursor_y), a
03E5 2A CF 07  ld hl, (text_screen_width)
03E8 3A 06 01  ld a, (esc_param_2)
03EB BD        cp l
03EC DA F0 03  jp c, _l55
03EF AF        xor a
_l55:
03F0 32 04 01  ld (cursor_x), a
03F3 C9        ret
_l53:
03F4 FE 4A     cp 74
03F6 C2 05 04  jp nz, _l56
03F9 3A 05 01  ld a, (esc_param)
03FC FE 02     cp 2
03FE C2 04 04  jp nz, _l57
0401 CD D9 07  call ClearScreen
_l57:
0404 C9        ret
_l56:
0405 FE 4B     cp 75
0407 C2 16 04  jp nz, _l58
040A 3A 05 01  ld a, (esc_param)
040D B7        or a
040E C2 15 04  jp nz, _l59
0411 CD 8B 03  call ConEraseInLine
0414 C9        ret
_l59:
0415 C9        ret
_l58:
0416 FE 6D     cp 109
0418 C2 34 04  jp nz, _l60
041B 3A 05 01  ld a, (esc_param)
041E FE 00     cp 0
0420 3E 01     ld a, 1
0422 CA D3 07  jp z, SetColor
0425 3A 05 01  ld a, (esc_param)
0428 FE 07     cp 7
042A 3E 04     ld a, 4
042C CA D3 07  jp z, SetColor
042F 3E 03     ld a, 3
0431 C3 D3 07  jp SetColor
_l60:
0434 C9        ret
CpmConoutCsi:
0435 C5        push bc
0436 CD 1D 03  call BeginConsoleChange
0439 C1        pop bc
043A CD A8 03  call CpmConoutCsi2
043D CD 3C 03  call EndConsoleChange
0440 C9        ret
CpmConoutEscY1:
0441 79        ld a, c
0442 D6 20     sub 32
0444 2A CF 07  ld hl, (text_screen_width)
0447 BD        cp l
0448 DA 4C 04  jp c, _l63
044B AF        xor a
_l63:
044C F5        push af
044D CD 1D 03  call BeginConsoleChange
0450 F1        pop af
0451 32 04 01  ld (cursor_x), a
0454 3A 05 01  ld a, (esc_param)
0457 32 03 01  ld (cursor_y), a
045A CD 3C 03  call EndConsoleChange
045D 21 CE 06  ld hl, CpmConout
0460 22 12 00  ld (entry_cpm_conout_address), hl
0463 C9        ret
CpmConoutEscY:
0464 79        ld a, c
0465 D6 20     sub 32
0467 FE 19     cp TEXT_SCREEN_HEIGHT
0469 DA 6D 04  jp c, _l65
046C AF        xor a
_l65:
046D 32 05 01  ld (esc_param), a
0470 21 41 04  ld hl, CpmConoutEscY1
0473 22 12 00  ld (entry_cpm_conout_address), hl
0476 C9        ret
CpmConoutEsc:
0477 21 CE 06  ld hl, CpmConout
047A 79        ld a, c
047B FE 5B     cp 91
047D C2 93 04  jp nz, _l67
0480 AF        xor a
0481 32 05 01  ld (esc_param), a
0484 32 06 01  ld (esc_param_2), a
0487 21 05 01  ld hl, esc_param
048A 22 07 01  ld (esc_param_ptr), hl
048D 21 35 04  ld hl, CpmConoutCsi
0490 C3 CE 04  jp _l68
_l67:
0493 FE 4B     cp 75
0495 C2 A1 04  jp nz, _l69
0498 CD 8B 03  call ConEraseInLine
049B 21 CE 06  ld hl, CpmConout
049E C3 CE 04  jp _l70
_l69:
04A1 FE 59     cp 89
04A3 C2 AC 04  jp nz, _l71
04A6 21 64 04  ld hl, CpmConoutEscY
04A9 C3 CE 04  jp _l72
_l71:
04AC FE 3D     cp 61
04AE C2 B7 04  jp nz, _l73
04B1 21 64 04  ld hl, CpmConoutEscY
04B4 C3 CE 04  jp _l74
_l73:
04B7 FE 3B     cp 59
04B9 C2 CE 04  jp nz, _l75
04BC CD 1D 03  call BeginConsoleChange
04BF CD D9 07  call ClearScreen
04C2 21 00 00  ld hl, 0
04C5 22 03 01  ld (cursor_y_l_x_h), hl
04C8 CD 3C 03  call EndConsoleChange
04CB 21 CE 06  ld hl, CpmConout
_l75:
_l74:
_l72:
_l70:
_l68:
04CE 22 12 00  ld (entry_cpm_conout_address), hl
04D1 C9        ret
console_xlat_koi7:
04D2 60        db 96
04D3 9E        db 158
04D4 80        db 128
04D5 81        db 129
04D6 96        db 150
04D7 84        db 132
04D8 85        db 133
04D9 94        db 148
04DA 83        db 131
04DB 95        db 149
04DC 88        db 136
04DD 89        db 137
04DE 8A        db 138
04DF 8B        db 139
04E0 8C        db 140
04E1 8D        db 141
04E2 8E        db 142
04E3 8F        db 143
04E4 9F        db 159
04E5 90        db 144
04E6 91        db 145
04E7 92        db 146
04E8 93        db 147
04E9 86        db 134
04EA 82        db 130
04EB 9C        db 156
04EC 9B        db 155
04ED 87        db 135
04EE 98        db 152
04EF 9D        db 157
04F0 99        db 153
04F1 97        db 151
04F2 7F        db 127
04F3 00        db 0
04F4 01        db 1
04F5 02        db 2
04F6 03        db 3
04F7 04        db 4
04F8 05        db 5
04F9 06        db 6
04FA 07        db 7
04FB 08        db 8
04FC 09        db 9
04FD 0A        db 10
04FE 0B        db 11
04FF 0C        db 12
0500 0D        db 13
0501 0E        db 14
0502 0F        db 15
0503 10        db 16
0504 11        db 17
0505 12        db 18
0506 13        db 19
0507 14        db 20
0508 15        db 21
0509 16        db 22
050A 17        db 23
050B 18        db 24
050C 19        db 25
050D 1A        db 26
050E 1B        db 27
050F 1C        db 28
0510 1D        db 29
0511 1E        db 30
0512 1F        db 31
0513 20        db 32
0514 21        db 33
0515 22        db 34
0516 23        db 35
0517 FD        db 253
0518 25        db 37
0519 26        db 38
051A 27        db 39
051B 28        db 40
051C 29        db 41
051D 2A        db 42
051E 2B        db 43
051F 2C        db 44
0520 2D        db 45
0521 2E        db 46
0522 2F        db 47
0523 30        db 48
0524 31        db 49
0525 32        db 50
0526 33        db 51
0527 34        db 52
0528 35        db 53
0529 36        db 54
052A 37        db 55
052B 38        db 56
052C 39        db 57
052D 3A        db 58
052E 3B        db 59
052F 3C        db 60
0530 3D        db 61
0531 3E        db 62
0532 3F        db 63
0533 40        db 64
0534 41        db 65
0535 42        db 66
0536 43        db 67
0537 44        db 68
0538 45        db 69
0539 46        db 70
053A 47        db 71
053B 48        db 72
053C 49        db 73
053D 4A        db 74
053E 4B        db 75
053F 4C        db 76
0540 4D        db 77
0541 4E        db 78
0542 4F        db 79
0543 50        db 80
0544 51        db 81
0545 52        db 82
0546 53        db 83
0547 54        db 84
0548 55        db 85
0549 56        db 86
054A 57        db 87
054B 58        db 88
054C 59        db 89
054D 5A        db 90
054E 5B        db 91
054F 5C        db 92
0550 5D        db 93
0551 5E        db 94
0552 5F        db 95
0553 9E        db 158
0554 80        db 128
0555 81        db 129
0556 96        db 150
0557 84        db 132
0558 85        db 133
0559 94        db 148
055A 83        db 131
055B 95        db 149
055C 88        db 136
055D 89        db 137
055E 8A        db 138
055F 8B        db 139
0560 8C        db 140
0561 8D        db 141
0562 8E        db 142
0563 8F        db 143
0564 9F        db 159
0565 90        db 144
0566 91        db 145
0567 92        db 146
0568 93        db 147
0569 86        db 134
056A 82        db 130
056B 9C        db 156
056C 9B        db 155
056D 87        db 135
056E 98        db 152
056F 9D        db 157
0570 99        db 153
0571 97        db 151
0572 7F        db 127
console_xlat_koi8:
0573 80        db 128
0574 C4        db 196
0575 B3        db 179
0576 DA        db 218
0577 BF        db 191
0578 C0        db 192
0579 D9        db 217
057A C3        db 195
057B B4        db 180
057C C2        db 194
057D C1        db 193
057E C5        db 197
057F DF        db 223
0580 DC        db 220
0581 DB        db 219
0582 DD        db 221
0583 DE        db 222
0584 B0        db 176
0585 B1        db 177
0586 B2        db 178
0587 F4        db 244
0588 FE        db 254
0589 F9        db 249
058A FB        db 251
058B F7        db 247
058C F3        db 243
058D F2        db 242
058E FF        db 255
058F F5        db 245
0590 F8        db 248
0591 FD        db 253
0592 FA        db 250
0593 F6        db 246
0594 CD        db 205
0595 BA        db 186
0596 D5        db 213
0597 F1        db 241
0598 D6        db 214
0599 C9        db 201
059A B8        db 184
059B B7        db 183
059C BB        db 187
059D D4        db 212
059E D3        db 211
059F C8        db 200
05A0 BE        db 190
05A1 BD        db 189
05A2 BC        db 188
05A3 C6        db 198
05A4 C7        db 199
05A5 CC        db 204
05A6 B5        db 181
05A7 F0        db 240
05A8 B6        db 182
05A9 B9        db 185
05AA D1        db 209
05AB D2        db 210
05AC CB        db 203
05AD CF        db 207
05AE D0        db 208
05AF CA        db 202
05B0 D8        db 216
05B1 D7        db 215
05B2 CE        db 206
05B3 FC        db 252
05B4 EE        db 238
05B5 A0        db 160
05B6 A1        db 161
05B7 E6        db 230
05B8 A4        db 164
05B9 A5        db 165
05BA E4        db 228
05BB A3        db 163
05BC E5        db 229
05BD A8        db 168
05BE A9        db 169
05BF AA        db 170
05C0 AB        db 171
05C1 AC        db 172
05C2 AD        db 173
05C3 AE        db 174
05C4 AF        db 175
05C5 EF        db 239
05C6 E0        db 224
05C7 E1        db 225
05C8 E2        db 226
05C9 E3        db 227
05CA A6        db 166
05CB A2        db 162
05CC EC        db 236
05CD EB        db 235
05CE A7        db 167
05CF E8        db 232
05D0 ED        db 237
05D1 E9        db 233
05D2 E7        db 231
05D3 EA        db 234
05D4 9E        db 158
05D5 80        db 128
05D6 81        db 129
05D7 96        db 150
05D8 84        db 132
05D9 85        db 133
05DA 94        db 148
05DB 83        db 131
05DC 95        db 149
05DD 88        db 136
05DE 89        db 137
05DF 8A        db 138
05E0 8B        db 139
05E1 8C        db 140
05E2 8D        db 141
05E3 8E        db 142
05E4 8F        db 143
05E5 9F        db 159
05E6 90        db 144
05E7 91        db 145
05E8 92        db 146
05E9 93        db 147
05EA 86        db 134
05EB 82        db 130
05EC 9C        db 156
05ED 9B        db 155
05EE 87        db 135
05EF 98        db 152
05F0 9D        db 157
05F1 99        db 153
05F2 97        db 151
05F3 9A        db 154
console_xlat_1251:
05F4 80        db 128
05F5 B0        db 176
05F6 B1        db 177
05F7 B2        db 178
05F8 B3        db 179
05F9 B4        db 180
05FA B5        db 181
05FB B6        db 182
05FC B7        db 183
05FD B8        db 184
05FE B9        db 185
05FF BA        db 186
0600 BB        db 187
0601 BC        db 188
0602 BD        db 189
0603 BE        db 190
0604 BF        db 191
0605 C0        db 192
0606 C1        db 193
0607 C2        db 194
0608 C3        db 195
0609 C4        db 196
060A C5        db 197
060B C6        db 198
060C C7        db 199
060D C8        db 200
060E C9        db 201
060F CA        db 202
0610 CB        db 203
0611 CC        db 204
0612 CD        db 205
0613 CE        db 206
0614 CF        db 207
0615 D0        db 208
0616 D1        db 209
0617 D2        db 210
0618 D3        db 211
0619 D4        db 212
061A D5        db 213
061B D6        db 214
061C D7        db 215
061D D8        db 216
061E D9        db 217
061F DA        db 218
0620 DB        db 219
0621 DC        db 220
0622 DD        db 221
0623 DE        db 222
0624 DF        db 223
0625 F0        db 240
0626 F1        db 241
0627 F2        db 242
0628 F3        db 243
0629 F4        db 244
062A F5        db 245
062B F6        db 246
062C F7        db 247
062D F8        db 248
062E F9        db 249
062F FA        db 250
0630 FB        db 251
0631 FC        db 252
0632 FD        db 253
0633 FE        db 254
0634 FF        db 255
0635 80        db 128
0636 81        db 129
0637 82        db 130
0638 83        db 131
0639 84        db 132
063A 85        db 133
063B 86        db 134
063C 87        db 135
063D 88        db 136
063E 89        db 137
063F 8A        db 138
0640 8B        db 139
0641 8C        db 140
0642 8D        db 141
0643 8E        db 142
0644 8F        db 143
0645 90        db 144
0646 91        db 145
0647 92        db 146
0648 93        db 147
0649 94        db 148
064A 95        db 149
064B 96        db 150
064C 97        db 151
064D 98        db 152
064E 99        db 153
064F 9A        db 154
0650 9B        db 155
0651 9C        db 156
0652 9D        db 157
0653 9E        db 158
0654 9F        db 159
0655 A0        db 160
0656 A1        db 161
0657 A2        db 162
0658 A3        db 163
0659 A4        db 164
065A A5        db 165
065B A6        db 166
065C A7        db 167
065D A8        db 168
065E A9        db 169
065F AA        db 170
0660 AB        db 171
0661 AC        db 172
0662 AD        db 173
0663 AE        db 174
0664 AF        db 175
0665 E0        db 224
0666 E1        db 225
0667 E2        db 226
0668 E3        db 227
0669 E4        db 228
066A E5        db 229
066B E6        db 230
066C E7        db 231
066D E8        db 232
066E E9        db 233
066F EA        db 234
0670 EB        db 235
0671 EC        db 236
0672 ED        db 237
0673 EE        db 238
0674 EF        db 239
codepages:
0675 D2 04     dw console_xlat_koi7
0677 73 05     dw console_xlat_koi8
0679 F4 05     dw console_xlat_1251
ConSetXlat:
067B F5        push af
067C 11 0B 01  ld de, console_xlat
067F 21 0B 02  ld hl, console_xlat_back
0682 AF        xor a
0683 06 3F     ld b, 63
_l81:
0685 70        ld (hl), b
0686 12        ld (de), a
0687 23        inc hl
0688 13        inc de
_l83:
0689 3C        inc a
068A C2 85 06  jp nz, _l81
_l82:
068D F1        pop af
068E B7        or a
068F CA BA 06  jp z, _l84
0692 3D        dec a
0693 C2 9C 06  jp nz, _l85
0696 11 F4 05  ld de, console_xlat_1251
0699 C3 A9 06  jp _l86
_l85:
069C 3D        dec a
069D C2 A6 06  jp nz, _l87
06A0 11 D2 04  ld de, console_xlat_koi7
06A3 C3 A9 06  jp _l88
_l87:
06A6 11 73 05  ld de, console_xlat_koi8
_l88:
_l86:
06A9 1A        ld a, (de)
06AA 4F        ld c, a
06AB C6 0B     add console_xlat
06AD 6F        ld l, a
06AE CE 01     adc console_xlat>>8
06B0 95        sub l
06B1 67        ld h, a
_l89:
06B2 13        inc de
06B3 1A        ld a, (de)
06B4 77        ld (hl), a
06B5 23        inc hl
_l91:
06B6 0C        inc c
06B7 C2 B2 06  jp nz, _l89
_l84:
_l90:
06BA 11 0A 02  ld de, console_xlat+255
06BD 0E FF     ld c, 255
_l92:
06BF 1A        ld a, (de)
06C0 C6 0B     add console_xlat_back
06C2 6F        ld l, a
06C3 CE 02     adc console_xlat_back>>8
06C5 95        sub l
06C6 67        ld h, a
06C7 71        ld (hl), c
06C8 1B        dec de
_l94:
06C9 0D        dec c
06CA C2 BF 06  jp nz, _l92
_l93:
06CD C9        ret
CpmConout:
06CE 79        ld a, c
06CF FE 1B     cp KEY_ESC
06D1 C2 DB 06  jp nz, _l96
06D4 21 77 04  ld hl, CpmConoutEsc
06D7 22 12 00  ld (entry_cpm_conout_address), hl
06DA C9        ret
_l96:
06DB FE 07     cp 7
06DD CA 0B 03  jp z, Beep
06E0 FE 0A     cp 10
06E2 C8        ret z
06E3 F5        push af
06E4 CD 1D 03  call BeginConsoleChange
06E7 F1        pop af
06E8 FE 1C     cp 28
06EA DA F3 06  jp c, _l97
06ED CD 6E 03  call ConPrintChar
06F0 C3 3C 03  jp EndConsoleChange
_l97:
06F3 FE 08     cp 8
06F5 C2 19 07  jp nz, _l98
06F8 3A 04 01  ld a, (cursor_x)
06FB 3D        dec a
06FC FA 05 07  jp m, _l99
06FF 32 04 01  ld (cursor_x), a
0702 C3 3C 03  jp EndConsoleChange
_l99:
0705 3A 03 01  ld a, (cursor_y)
0708 3D        dec a
0709 FA 3C 03  jp m, EndConsoleChange
070C 32 03 01  ld (cursor_y), a
070F 3A CF 07  ld a, (text_screen_width)
0712 3D        dec a
0713 32 04 01  ld (cursor_x), a
0716 C3 3C 03  jp EndConsoleChange
_l98:
0719 FE 0C     cp 12
071B C2 2A 07  jp nz, _l100
071E CD D9 07  call ClearScreen
0721 21 00 00  ld hl, 0
0724 22 03 01  ld (cursor_y_l_x_h), hl
0727 C3 3C 03  jp EndConsoleChange
_l100:
072A FE 1A     cp 26
072C C2 3B 07  jp nz, _l101
072F CD D9 07  call ClearScreen
0732 21 00 00  ld hl, 0
0735 22 03 01  ld (cursor_y_l_x_h), hl
0738 C3 3C 03  jp EndConsoleChange
_l101:
073B FE 0D     cp 13
073D C2 46 07  jp nz, _l102
0740 CD 5D 03  call ConNextLine
0743 C3 3C 03  jp EndConsoleChange
_l102:
0746 CD 6E 03  call ConPrintChar
0749 C3 3C 03  jp EndConsoleChange
con_special_keys:
074C 5B        db 91
074D 4F        db 79
074E 50        db 80
074F 00        db 0
0750 5B        db 91
0751 4F        db 79
0752 51        db 81
0753 00        db 0
0754 5B        db 91
0755 4F        db 79
0756 52        db 82
0757 00        db 0
0758 5B        db 91
0759 41        db 65
075A 00        db 0
075B 00        db 0
075C 5B        db 91
075D 42        db 66
075E 00        db 0
075F 00        db 0
0760 5B        db 91
0761 43        db 67
0762 00        db 0
0763 00        db 0
0764 5B        db 91
0765 44        db 68
0766 00        db 0
0767 00        db 0
0768 5B        db 91
0769 45        db 69
076A 00        db 0
076B 00        db 0
076C 5B        db 91
076D 46        db 70
076E 00        db 0
076F 00        db 0
0770 5B        db 91
0771 48        db 72
0772 00        db 0
0773 00        db 0
0774 5B        db 91
0775 32        db 50
0776 7E        db 126
0777 00        db 0
0778 5B        db 91
0779 33        db 51
077A 7E        db 126
077B 00        db 0
077C 5B        db 91
077D 35        db 53
077E 7E        db 126
077F 00        db 0
0780 5B        db 91
0781 36        db 54
0782 7E        db 126
0783 00        db 0
CpmConst:
0784 3A 0A 01  ld a, (long_code_high)
0787 B7        or a
0788 CC F1 22  call z, CheckKeyboard
078B 16 00     ld d, 0
078D C8        ret z
078E 15        dec d
078F C9        ret
CpmConin:
0790 3A 0A 01  ld a, (long_code_high)
0793 B7        or a
0794 CA AB 07  jp z, _l106
0797 2A 09 01  ld hl, (long_code)
079A 56        ld d, (hl)
079B 23        inc hl
079C 7E        ld a, (hl)
079D B7        or a
079E C2 A4 07  jp nz, _l107
07A1 21 00 00  ld hl, 0
_l107:
07A4 22 09 01  ld (long_code), hl
07A7 7A        ld a, d
07A8 C3 C6 07  jp _l108
_l106:
_l109:
07AB CD F7 22  call ReadKeyboard
_l111:
07AE CA AB 07  jp z, _l109
_l110:
07B1 FE F2     cp KEY_F1
07B3 DA C6 07  jp c, _l112
07B6 D6 F2     sub KEY_F1
07B8 87        add a
07B9 87        add a
07BA C6 4C     add con_special_keys
07BC 6F        ld l, a
07BD CE 07     adc con_special_keys>>8
07BF 95        sub l
07C0 67        ld h, a
07C1 22 09 01  ld (long_code), hl
07C4 3E 1B     ld a, KEY_ESC
_l112:
_l108:
07C6 C6 0B     add console_xlat_back
07C8 6F        ld l, a
07C9 CE 02     adc console_xlat_back>>8
07CB 95        sub l
07CC 67        ld h, a
07CD 56        ld d, (hl)
07CE C9        ret
07CF          SCREEN_0_ADDRESS equ 53248
07CF          SCREEN_1_ADDRESS equ 36864
07CF          PALETTE_WHITE equ 0
07CF          PALETTE_CYAN equ 1
07CF          PALETTE_MAGENTA equ 2
07CF          PALETTE_BLUE equ 3
07CF          PALETTE_YELLOW equ 4
07CF          PALETTE_GREEN equ 5
07CF          PALETTE_RED equ 6
07CF          PALETTE_XXX equ 7
07CF          PALETTE_GRAY equ 8
07CF          PALETTE_DARK_CYAN equ 9
07CF          PALETTE_DARK_MAGENTA equ 10
07CF          PALETTE_DARK_BLUE equ 11
07CF          PALETTE_DARK_YELLOW equ 12
07CF          PALETTE_DARK_GREEN equ 13
07CF          PALETTE_DARK_RED equ 14
07CF          PALETTE_BLACK equ 15
07CF          KEY_BACKSPACE equ 8
07CF          KEY_TAB equ 9
07CF          KEY_ENTER equ 13
07CF          KEY_ESC equ 27
07CF          KEY_ALT equ 1
07CF          KEY_F1 equ 242
07CF          KEY_F2 equ 243
07CF          KEY_F3 equ 244
07CF          KEY_UP equ 245
07CF          KEY_DOWN equ 246
07CF          KEY_RIGHT equ 247
07CF          KEY_LEFT equ 248
07CF          KEY_EXT_5 equ 249
07CF          KEY_END equ 250
07CF          KEY_HOME equ 251
07CF          KEY_INSERT equ 252
07CF          KEY_DEL equ 253
07CF          KEY_PG_UP equ 254
07CF          KEY_PG_DN equ 255
07CF          PORT_FRAME_IRQ_RESET equ 4
07CF          PORT_SD_SIZE equ 9
07CF          PORT_SD_RESULT equ 9
07CF          PORT_SD_DATA equ 8
07CF          PORT_UART_DATA equ 128
07CF          PORT_UART_CONFIG equ 129
07CF          PORT_UART_STATE equ 129
07CF          PORT_EXT_DATA_OUT equ 136
07CF          PORT_PALETTE_3 equ 144
07CF          PORT_PALETTE_2 equ 145
07CF          PORT_PALETTE_1 equ 146
07CF          PORT_PALETTE_0 equ 147
07CF          PORT_EXT_IN_DATA equ 137
07CF          PORT_A0 equ 160
07CF          PORT_ROM_0000 equ 168
07CF          PORT_ROM_0000__ROM equ 0
07CF          PORT_ROM_0000__RAM equ 128
07CF          PORT_VIDEO_MODE_1_LOW equ 185
07CF          PORT_VIDEO_MODE_1_HIGH equ 249
07CF          PORT_VIDEO_MODE_0_LOW equ 184
07CF          PORT_VIDEO_MODE_0_HIGH equ 248
07CF          PORT_UART_SPEED_0 equ 187
07CF          PORT_KEYBOARD equ 192
07CF          PORT_UART_SPEED_1 equ 251
07CF          PORT_CODE_ROM equ 186
07CF          PORT_CHARGEN_ROM equ 250
07CF          PORT_TAPE_AND_IDX2 equ 153
07CF          PORT_TAPE_AND_IDX2_ID1_2 equ 2
07CF          PORT_TAPE_AND_IDX2_ID2_2 equ 4
07CF          PORT_TAPE_AND_IDX2_ID3_2 equ 8
07CF          PORT_TAPE_AND_IDX2_ID6_2 equ 64
07CF          PORT_TAPE_AND_IDX2_ID7_2 equ 128
07CF          PORT_RESET_CU1 equ 188
07CF          PORT_RESET_CU2 equ 189
07CF          PORT_RESET_CU3 equ 190
07CF          PORT_RESET_CU4 equ 191
07CF          PORT_SET_CU1 equ 252
07CF          PORT_SET_CU2 equ 253
07CF          PORT_SET_CU3 equ 254
07CF          PORT_SET_CU4 equ 255
07CF          PORT_TAPE_OUT equ 176
07CF          SD_COMMAND_READ equ 1
07CF          SD_COMMAND_READ_SIZE equ 5
07CF          SD_COMMAND_WRITE equ 2
07CF          SD_COMMAND_WRITE_SIZE equ 5+128
07CF          SD_RESULT_BUSY equ 255
07CF          SD_RESULT_OK equ 0
07CF          TEXT_SCREEN_HEIGHT equ 25
07CF          FONT_HEIGHT equ 10
07CF          FONT_WIDTH equ 3
07CF          DrawCharAddress equ DrawChar+1
07CF          SetColorAddress equ SetColor+1
07CF          DrawCursorAddress equ DrawCursor+1
07CF          OPCODE_NOP equ 0
07CF          OPCODE_LD_DE_CONST equ 17
07CF          OPCODE_LD_A_CONST equ 62
07CF          OPCODE_LD_H_A equ 103
07CF          OPCODE_LD_A_D equ 122
07CF          OPCODE_LD_A_H equ 124
07CF          OPCODE_XOR_A equ 175
07CF          OPCODE_XOR_B equ 168
07CF          OPCODE_JP equ 195
07CF          OPCODE_RET equ 201
07CF          OPCODE_SUB_CONST equ 214
07CF          OPCODE_AND_CONST equ 230
07CF          OPCODE_OR_CONST equ 246
07CF          OPCODE_OUT equ 211
07CF          OPCODE_JMP equ 195
text_screen_width:
07CF 60        db 96
07D0          ClearScreen_2 equ ClearScreen_1+1
07D0          ClearScreen_3 equ ClearScreen_1+2
07D0          ClearScreen_4 equ ClearScreenPoly3+1
07D0          ClearScreenSp equ ClearScreenSetSp+1
07D0          ScrollUpAddr equ ScrollUp+1
07D0          ScrollUpSp equ ScrollUpSpInstr+1
07D0          ScrollUpSp2 equ ScrollUpSpInstr2+1
07D0          ScrollUpBwSp equ ScrollUpBwSpInstr+1
07D0          ScrollUp_1 equ ScrollUpSub+1
07D0          ScrollUp_2 equ ScrollUp_2
07D0          ScrollUp_3 equ ScrollUp_2+1
07D0          ScrollUpSpInstr2 equ ScrollUpSpInstr2
DrawChar:
07D0 C3 E6 08  jp DrawChar6
SetColor:
07D3 C3 E2 09  jp SetColor6
DrawCursor:
07D6 C3 B7 0A  jp DrawCursor6
ClearScreen:
07D9 21 00 00  ld hl, 0
07DC 39        add hl, sp
07DD 22 0C 08  ld (ClearScreenSp), hl
07E0 11 00 00  ld de, 0
07E3 0E 30     ld c, 48
07E5 21 00 00  ld hl, 0
_l124:
07E8 06 10     ld b, 16
07EA F3        di
07EB F9        ld sp, hl
_l127:
07EC D5        push de
07ED D5        push de
07EE D5        push de
07EF D5        push de
07F0 D5        push de
07F1 D5        push de
07F2 D5        push de
07F3 D5        push de
_l129:
07F4 05        dec b
07F5 C2 EC 07  jp nz, _l127
_l128:
07F8 7C        ld a, h
ClearScreen_1:
07F9 D6 40     sub 64
07FB 67        ld h, a
07FC 06 10     ld b, 16
07FE F9        ld sp, hl
_l130:
07FF D5        push de
0800 D5        push de
0801 D5        push de
0802 D5        push de
0803 D5        push de
0804 D5        push de
0805 D5        push de
0806 D5        push de
_l132:
0807 05        dec b
0808 C2 FF 07  jp nz, _l130
ClearScreenSetSp:
_l131:
080B 31 00 00  ld sp, 0
080E FB        ei
ClearScreenPoly3:
080F C6 3F     add 63
0811 67        ld h, a
_l126:
0812 0D        dec c
0813 C2 E8 07  jp nz, _l124
_l125:
0816 C9        ret
0817          SCROLL_COLUMN_UP equ 256
0817          BITPLANE_OFFSET equ 16384
0817          SCREEN_SIZE equ 12288
_l134:
ScrollUpSubBw:
0817 F9        ld sp, hl
0818 19        add hl, de
0819 46        ld b, (hl)
081A 2D        dec l
081B 4E        ld c, (hl)
081C 2D        dec l
081D C5        push bc
081E 46        ld b, (hl)
081F 2D        dec l
0820 4E        ld c, (hl)
0821 2D        dec l
0822 C5        push bc
0823 46        ld b, (hl)
0824 2D        dec l
0825 4E        ld c, (hl)
0826 2D        dec l
0827 C5        push bc
0828 46        ld b, (hl)
0829 2D        dec l
082A 4E        ld c, (hl)
082B 2D        dec l
082C C5        push bc
082D 46        ld b, (hl)
082E 2D        dec l
082F 4E        ld c, (hl)
0830 C5        push bc
0831 21 0A 01  ld hl, FONT_HEIGHT+256
0834 39        add hl, sp
_l136:
0835 3D        dec a
0836 C2 17 08  jp nz, _l134
_l135:
0839 C3 95 08  jp ScrollUpSpInstr
_l138:
ScrollUpSubColor:
083C F9        ld sp, hl
083D 19        add hl, de
083E 46        ld b, (hl)
083F 2D        dec l
0840 4E        ld c, (hl)
0841 2D        dec l
0842 C5        push bc
0843 46        ld b, (hl)
0844 2D        dec l
0845 4E        ld c, (hl)
0846 2D        dec l
0847 C5        push bc
0848 46        ld b, (hl)
0849 2D        dec l
084A 4E        ld c, (hl)
084B 2D        dec l
084C C5        push bc
084D 46        ld b, (hl)
084E 2D        dec l
084F 4E        ld c, (hl)
0850 2D        dec l
0851 C5        push bc
0852 46        ld b, (hl)
0853 2D        dec l
0854 4E        ld c, (hl)
0855 C5        push bc
0856 21 0A C0  ld hl, FONT_HEIGHT-BITPLANE_OFFSET
0859 39        add hl, sp
085A F9        ld sp, hl
085B 19        add hl, de
085C 46        ld b, (hl)
085D 2D        dec l
085E 4E        ld c, (hl)
085F 2D        dec l
0860 C5        push bc
0861 46        ld b, (hl)
0862 2D        dec l
0863 4E        ld c, (hl)
0864 2D        dec l
0865 C5        push bc
0866 46        ld b, (hl)
0867 2D        dec l
0868 4E        ld c, (hl)
0869 2D        dec l
086A C5        push bc
086B 46        ld b, (hl)
086C 2D        dec l
086D 4E        ld c, (hl)
086E 2D        dec l
086F C5        push bc
0870 46        ld b, (hl)
0871 2D        dec l
0872 4E        ld c, (hl)
0873 C5        push bc
0874 21 0A 41  ld hl, (FONT_HEIGHT+BITPLANE_OFFSET)+256
0877 39        add hl, sp
_l140:
0878 3D        dec a
0879 C2 3C 08  jp nz, _l138
_l139:
087C C3 95 08  jp ScrollUpSpInstr
ScrollUp:
087F 21 00 00  ld hl, 0
0882 39        add hl, sp
0883 22 96 08  ld (ScrollUpSp), hl
0886 22 D2 08  ld (ScrollUpSp2), hl
0889 11 F5 FF  ld de, -FONT_HEIGHT-1
088C 21 00 D1  ld hl, 53504
_l141:
088F F3        di
0890 3E 30     ld a, 48
ScrollUpSub:
0892 C3 17 08  jp ScrollUpSubBw
ScrollUpSpInstr:
0895 31 00 00  ld sp, 0
0898 FB        ei
0899 7D        ld a, l
089A D6 0A     sub FONT_HEIGHT
089C 6F        ld l, a
089D 26 D0     ld h, 208
_l143:
089F FE 11     cp FONT_HEIGHT+7
08A1 D2 8F 08  jp nc, _l141
_l142:
08A4 3E 30     ld a, 48
08A6 11 00 00  ld de, 0
08A9 F3        di
08AA 31 10 FF  ld sp, (SCREEN_0_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l144:
08AD D5        push de
08AE D5        push de
08AF D5        push de
08B0 D5        push de
08B1 D5        push de
08B2 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
08B5 39        add hl, sp
08B6 F9        ld sp, hl
_l146:
08B7 3D        dec a
08B8 C2 AD 08  jp nz, _l144
ScrollUp_2:
_l145:
08BB 3E 30     ld a, 48
08BD 11 00 00  ld de, 0
08C0 31 10 BF  ld sp, (SCREEN_1_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l147:
08C3 D5        push de
08C4 D5        push de
08C5 D5        push de
08C6 D5        push de
08C7 D5        push de
08C8 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
08CB 39        add hl, sp
08CC F9        ld sp, hl
_l149:
08CD 3D        dec a
08CE C2 C3 08  jp nz, _l147
ScrollUpSpInstr2:
_l148:
08D1 31 00 00  ld sp, 0
08D4 FB        ei
08D5 C9        ret
DrawText:
_l152:
08D6 7E        ld a, (hl)
08D7 23        inc hl
08D8 B7        or a
08D9 C8        ret z
08DA E5        push hl
08DB D5        push de
08DC EB        ex hl, de
08DD CD D0 07  call DrawChar
08E0 D1        pop de
08E1 E1        pop hl
08E2 14        inc d
08E3 C3 D6 08  jp _l152
_l151:
DrawChar6:
08E6 47        ld b, a
08E7 7D        ld a, l
08E8 87        add a
08E9 87        add a
08EA 85        add l
08EB 87        add a
08EC 2F        cpl
08ED 5F        ld e, a
08EE 7C        ld a, h
08EF 87        add a
08F0 84        add h
08F1 4F        ld c, a
08F2 1F        rra
08F3 1F        rra
08F4 E6 3F     and 63
08F6 2F        cpl
08F7 57        ld d, a
08F8 78        ld a, b
08F9 C6 84     add font
08FB 6F        ld l, a
08FC CE 0B     adc font>>8
08FE 95        sub l
08FF 67        ld h, a
0900 79        ld a, c
0901 E6 03     and 3
0903 CA 55 09  jp z, DrawChar60
0906 3D        dec a
0907 CA 7C 09  jp z, DrawChar62
090A 3D        dec a
090B CA 9D 09  jp z, DrawChar64
DrawChar66:
090E 0E 0A     ld c, FONT_HEIGHT
_l155:
0910 7E        ld a, (hl)
0911 0F 0F 0F  rrca
 rrca
 rrca
 rrca
0915 F5        push af
0916 E6 03     and 3
0918 47        ld b, a
0919 1A        ld a, (de)
DrawChar_And3:
091A E6 FC     and 252
DrawChar_Xor3:
091C A8        xor b
091D 12        ld (de), a
091E F1        pop af
091F 15        dec d
0920 E6 F0     and 240
0922 47        ld b, a
0923 1A        ld a, (de)
DrawChar_And5:
0924 E6 0F     and 15
DrawChar_Xor4:
0926 A8        xor b
0927 12        ld (de), a
0928 14        inc d
0929 24        inc h
092A 1D        dec e
_l157:
092B 0D        dec c
092C C2 10 09  jp nz, _l155
DrawChar_2:
_l156:
092F 7A        ld a, d
0930 D6 40     sub 64
0932 57        ld d, a
0933 0E 0A     ld c, FONT_HEIGHT
_l163:
0935 1C        inc e
0936 25        dec h
0937 7E        ld a, (hl)
0938 0F 0F 0F  rrca
 rrca
 rrca
 rrca
093C F5        push af
093D E6 03     and 3
093F 47        ld b, a
0940 1A        ld a, (de)
DrawChar_And4:
0941 E6 FC     and 252
DrawChar_Xor5:
0943 A8        xor b
0944 12        ld (de), a
0945 F1        pop af
0946 15        dec d
0947 E6 F0     and 240
0949 47        ld b, a
094A 1A        ld a, (de)
DrawChar_And6:
094B E6 0F     and 15
DrawChar_Xor6:
094D A8        xor b
094E 12        ld (de), a
094F 14        inc d
_l165:
0950 0D        dec c
0951 C2 35 09  jp nz, _l163
_l164:
0954 C9        ret
DrawChar60:
0955 0E 0A     ld c, FONT_HEIGHT
_l171:
0957 7E        ld a, (hl)
0958 87        add a
0959 87        add a
095A 47        ld b, a
095B 1A        ld a, (de)
DrawChar_And1:
095C E6 03     and 3
DrawChar_Xor1:
095E A8        xor b
095F 12        ld (de), a
0960 1D        dec e
0961 24        inc h
_l173:
0962 0D        dec c
0963 C2 57 09  jp nz, _l171
DrawChar_1:
_l172:
0966 7A        ld a, d
0967 D6 40     sub 64
0969 57        ld d, a
096A 0E 0A     ld c, FONT_HEIGHT
_l177:
096C 25        dec h
096D 1C        inc e
096E 7E        ld a, (hl)
096F 87        add a
0970 87        add a
0971 47        ld b, a
0972 1A        ld a, (de)
DrawChar_And2:
0973 E6 03     and 3
DrawChar_Xor2:
0975 A8        xor b
0976 12        ld (de), a
_l179:
0977 0D        dec c
0978 C2 6C 09  jp nz, _l177
_l178:
097B C9        ret
DrawChar62:
097C 0E 0A     ld c, FONT_HEIGHT
_l183:
097E 46        ld b, (hl)
097F 1A        ld a, (de)
DrawChar_And11:
0980 E6 C0     and 192
DrawChar_Xor11:
0982 A8        xor b
0983 12        ld (de), a
0984 1D        dec e
0985 24        inc h
_l185:
0986 0D        dec c
0987 C2 7E 09  jp nz, _l183
_l184:
DrawChar_3:
098A 7A        ld a, d
098B D6 40     sub 64
098D 57        ld d, a
098E 0E 0A     ld c, FONT_HEIGHT
_l189:
0990 25        dec h
0991 1C        inc e
0992 46        ld b, (hl)
0993 1A        ld a, (de)
DrawChar_And12:
0994 E6 C0     and 192
DrawChar_Xor12:
0996 A8        xor b
0997 12        ld (de), a
_l191:
0998 0D        dec c
0999 C2 90 09  jp nz, _l189
_l190:
099C C9        ret
DrawChar64:
099D 0E 0A     ld c, FONT_HEIGHT
_l195:
099F 7E        ld a, (hl)
09A0 0F 0F     rrca
 rrca
09A2 E6 0F     and 15
09A4 47        ld b, a
09A5 1A        ld a, (de)
DrawChar_And7:
09A6 E6 F0     and 240
DrawChar_Xor7:
09A8 A8        xor b
09A9 12        ld (de), a
09AA 15        dec d
09AB 7E        ld a, (hl)
09AC 0F 0F     rrca
 rrca
09AE E6 C0     and 192
09B0 47        ld b, a
09B1 1A        ld a, (de)
DrawChar_And9:
09B2 E6 3F     and 63
DrawChar_Xor8:
09B4 A8        xor b
09B5 12        ld (de), a
09B6 14        inc d
09B7 1D        dec e
09B8 24        inc h
_l197:
09B9 0D        dec c
09BA C2 9F 09  jp nz, _l195
_l196:
DrawChar_4:
09BD 7A        ld a, d
09BE D6 40     sub 64
09C0 57        ld d, a
09C1 0E 0A     ld c, FONT_HEIGHT
_l203:
09C3 25        dec h
09C4 1C        inc e
09C5 7E        ld a, (hl)
09C6 0F 0F     rrca
 rrca
09C8 E6 0F     and 15
09CA 47        ld b, a
09CB 1A        ld a, (de)
DrawChar_And8:
09CC E6 F0     and 240
DrawChar_Xor9:
09CE A8        xor b
09CF 12        ld (de), a
09D0 15        dec d
09D1 7E        ld a, (hl)
09D2 0F 0F     rrca
 rrca
09D4 E6 C0     and 192
09D6 47        ld b, a
09D7 1A        ld a, (de)
DrawChar_And10:
09D8 E6 3F     and 63
DrawChar_Xor10:
09DA A8        xor b
09DB 12        ld (de), a
09DC 14        inc d
_l205:
09DD 0D        dec c
09DE C2 C3 09  jp nz, _l203
_l204:
09E1 C9        ret
SetColor6:
09E2 4F        ld c, a
09E3 E6 04     and 4
09E5 C2 0D 0A  jp nz, _l211
09E8 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
09EB 22 5C 09  ld (DrawChar_And1), hl
09EE 22 73 09  ld (DrawChar_And2), hl
09F1 26 FC     ld h, 252
09F3 22 1A 09  ld (DrawChar_And3), hl
09F6 26 0F     ld h, 15
09F8 22 24 09  ld (DrawChar_And5), hl
09FB 26 F0     ld h, 240
09FD 22 A6 09  ld (DrawChar_And7), hl
0A00 26 3F     ld h, 63
0A02 22 B2 09  ld (DrawChar_And9), hl
0A05 26 C0     ld h, 192
0A07 22 80 09  ld (DrawChar_And11), hl
0A0A C3 2F 0A  jp _l212
_l211:
0A0D 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
0A10 22 5C 09  ld (DrawChar_And1), hl
0A13 22 73 09  ld (DrawChar_And2), hl
0A16 26 03     ld h, 255^252
0A18 22 1A 09  ld (DrawChar_And3), hl
0A1B 26 F0     ld h, 255^15
0A1D 22 24 09  ld (DrawChar_And5), hl
0A20 26 0F     ld h, 255^240
0A22 22 A6 09  ld (DrawChar_And7), hl
0A25 26 C0     ld h, 255^63
0A27 22 B2 09  ld (DrawChar_And9), hl
0A2A 26 3F     ld h, 255^192
0A2C 22 80 09  ld (DrawChar_And11), hl
_l212:
0A2F 47        ld b, a
0A30 79        ld a, c
0A31 87        add a
0A32 87        add a
0A33 E6 04     and 4
0A35 A8        xor b
0A36 3E A8     ld a, OPCODE_XOR_B
0A38 C2 3D 0A  jp nz, _l213
0A3B 3E 00     ld a, OPCODE_NOP
_l213:
0A3D 32 5E 09  ld (DrawChar_Xor1), a
0A40 32 1C 09  ld (DrawChar_Xor3), a
0A43 32 26 09  ld (DrawChar_Xor4), a
0A46 32 A8 09  ld (DrawChar_Xor7), a
0A49 32 B4 09  ld (DrawChar_Xor8), a
0A4C 32 82 09  ld (DrawChar_Xor11), a
0A4F 79        ld a, c
0A50 E6 08     and 8
0A52 C2 77 0A  jp nz, _l214
0A55 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
0A58 22 73 09  ld (DrawChar_And2), hl
0A5B 26 FC     ld h, 252
0A5D 22 41 09  ld (DrawChar_And4), hl
0A60 26 0F     ld h, 15
0A62 22 4B 09  ld (DrawChar_And6), hl
0A65 26 F0     ld h, 240
0A67 22 CC 09  ld (DrawChar_And8), hl
0A6A 26 3F     ld h, 63
0A6C 22 D8 09  ld (DrawChar_And10), hl
0A6F 26 C0     ld h, 192
0A71 22 94 09  ld (DrawChar_And12), hl
0A74 C3 96 0A  jp _l215
_l214:
0A77 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
0A7A 22 73 09  ld (DrawChar_And2), hl
0A7D 26 03     ld h, 255^252
0A7F 22 41 09  ld (DrawChar_And4), hl
0A82 26 F0     ld h, 255^15
0A84 22 4B 09  ld (DrawChar_And6), hl
0A87 26 0F     ld h, 255^240
0A89 22 CC 09  ld (DrawChar_And8), hl
0A8C 26 C0     ld h, 255^63
0A8E 22 D8 09  ld (DrawChar_And10), hl
0A91 26 3F     ld h, 255^192
0A93 22 94 09  ld (DrawChar_And12), hl
_l215:
0A96 47        ld b, a
0A97 79        ld a, c
0A98 87        add a
0A99 87        add a
0A9A E6 08     and 8
0A9C A8        xor b
0A9D 3E A8     ld a, OPCODE_XOR_B
0A9F C2 A4 0A  jp nz, _l216
0AA2 3E 00     ld a, OPCODE_NOP
_l216:
0AA4 32 75 09  ld (DrawChar_Xor2), a
0AA7 32 43 09  ld (DrawChar_Xor5), a
0AAA 32 4D 09  ld (DrawChar_Xor6), a
0AAD 32 CE 09  ld (DrawChar_Xor9), a
0AB0 32 DA 09  ld (DrawChar_Xor10), a
0AB3 32 96 09  ld (DrawChar_Xor12), a
0AB6 C9        ret
DrawCursor6:
0AB7 7C        ld a, h
0AB8 E6 03     and 3
0ABA C2 C3 0A  jp nz, _l218
0ABD 11 FC 00  ld de, 252
0AC0 C3 DA 0A  jp _l219
_l218:
0AC3 3D        dec a
0AC4 C2 CD 0A  jp nz, _l220
0AC7 11 03 F0  ld de, 61443
0ACA C3 DA 0A  jp _l221
_l220:
0ACD 3D        dec a
0ACE C2 D7 0A  jp nz, _l222
0AD1 11 0F C0  ld de, 49167
0AD4 C3 DA 0A  jp _l223
_l222:
0AD7 11 3F 00  ld de, 63
_l219:
_l221:
_l223:
0ADA 7D        ld a, l
0ADB 87        add a
0ADC 87        add a
0ADD 85        add l
0ADE 87        add a
0ADF 2F        cpl
0AE0 6F        ld l, a
0AE1 7C        ld a, h
0AE2 87        add a
0AE3 84        add h
0AE4 0F 0F     rrca
 rrca
0AE6 E6 3F     and 63
0AE8 2F        cpl
0AE9 67        ld h, a
0AEA 0E 0A     ld c, FONT_HEIGHT
_l224:
0AEC 7E        ld a, (hl)
0AED AB        xor e
0AEE 77        ld (hl), a
0AEF 25        dec h
0AF0 7E        ld a, (hl)
0AF1 AA        xor d
0AF2 77        ld (hl), a
0AF3 24        inc h
0AF4 2D        dec l
_l226:
0AF5 0D        dec c
0AF6 C2 EC 0A  jp nz, _l224
_l225:
0AF9 C9        ret
SetScreenBw6:
0AFA 3E 40     ld a, 64
0AFC 32 CF 07  ld (text_screen_width), a
0AFF 21 E6 08  ld hl, DrawChar6
0B02 22 D1 07  ld (DrawCharAddress), hl
0B05 21 E2 09  ld hl, SetColor6
0B08 22 D4 07  ld (SetColorAddress), hl
0B0B 3E C9     ld a, OPCODE_RET
0B0D 32 66 09  ld (DrawChar_1), a
0B10 32 2F 09  ld (DrawChar_2), a
0B13 32 8A 09  ld (DrawChar_3), a
0B16 32 BD 09  ld (DrawChar_4), a
SetScreenBw:
0B19 D3 B8     out (PORT_VIDEO_MODE_0_LOW), a
0B1B D3 F9     out (PORT_VIDEO_MODE_1_HIGH), a
0B1D 3E C3     ld a, OPCODE_JP
0B1F 32 F9 07  ld (ClearScreen_1), a
0B22 21 0B 08  ld hl, ClearScreenSetSp
0B25 22 FA 07  ld (ClearScreen_2), hl
0B28 3E FF     ld a, 255
0B2A 32 10 08  ld (ClearScreen_4), a
0B2D 21 17 08  ld hl, ScrollUpSubBw
0B30 22 93 08  ld (ScrollUp_1), hl
0B33 3E C3     ld a, OPCODE_JP
0B35 32 BB 08  ld (ScrollUp_2), a
0B38 21 D1 08  ld hl, ScrollUpSpInstr2
0B3B 22 BC 08  ld (ScrollUp_3), hl
0B3E C9        ret
SetScreenColor6:
0B3F 3E 40     ld a, 64
0B41 32 CF 07  ld (text_screen_width), a
0B44 21 E6 08  ld hl, DrawChar6
0B47 22 D1 07  ld (DrawCharAddress), hl
0B4A 21 E2 09  ld hl, SetColor6
0B4D 22 D4 07  ld (SetColorAddress), hl
0B50 3E 7A     ld a, OPCODE_LD_A_D
0B52 32 66 09  ld (DrawChar_1), a
0B55 32 2F 09  ld (DrawChar_2), a
0B58 32 8A 09  ld (DrawChar_3), a
0B5B 32 BD 09  ld (DrawChar_4), a
SetScreenColor:
0B5E D3 F8     out (PORT_VIDEO_MODE_0_HIGH), a
0B60 D3 B9     out (PORT_VIDEO_MODE_1_LOW), a
0B62 21 D6 40  ld hl, OPCODE_SUB_CONST|64<<8
0B65 22 F9 07  ld (ClearScreen_1), hl
0B68 3E 67     ld a, OPCODE_LD_H_A
0B6A 32 FB 07  ld (ClearScreen_3), a
0B6D 3E 3F     ld a, 63
0B6F 32 10 08  ld (ClearScreen_4), a
0B72 21 3C 08  ld hl, ScrollUpSubColor
0B75 22 93 08  ld (ScrollUp_1), hl
0B78 3E 3E     ld a, OPCODE_LD_A_CONST
0B7A 32 BB 08  ld (ScrollUp_2), a
0B7D 21 30 11  ld hl, 48|OPCODE_LD_DE_CONST<<8
0B80 22 BC 08  ld (ScrollUp_3), hl
0B83 C9        ret
font:
0B84 00 00 00  db 0
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
1584          SCREEN_0_ADDRESS equ 53248
1584          SCREEN_1_ADDRESS equ 36864
1584          PALETTE_WHITE equ 0
1584          PALETTE_CYAN equ 1
1584          PALETTE_MAGENTA equ 2
1584          PALETTE_BLUE equ 3
1584          PALETTE_YELLOW equ 4
1584          PALETTE_GREEN equ 5
1584          PALETTE_RED equ 6
1584          PALETTE_XXX equ 7
1584          PALETTE_GRAY equ 8
1584          PALETTE_DARK_CYAN equ 9
1584          PALETTE_DARK_MAGENTA equ 10
1584          PALETTE_DARK_BLUE equ 11
1584          PALETTE_DARK_YELLOW equ 12
1584          PALETTE_DARK_GREEN equ 13
1584          PALETTE_DARK_RED equ 14
1584          PALETTE_BLACK equ 15
1584          KEY_BACKSPACE equ 8
1584          KEY_TAB equ 9
1584          KEY_ENTER equ 13
1584          KEY_ESC equ 27
1584          KEY_ALT equ 1
1584          KEY_F1 equ 242
1584          KEY_F2 equ 243
1584          KEY_F3 equ 244
1584          KEY_UP equ 245
1584          KEY_DOWN equ 246
1584          KEY_RIGHT equ 247
1584          KEY_LEFT equ 248
1584          KEY_EXT_5 equ 249
1584          KEY_END equ 250
1584          KEY_HOME equ 251
1584          KEY_INSERT equ 252
1584          KEY_DEL equ 253
1584          KEY_PG_UP equ 254
1584          KEY_PG_DN equ 255
1584          PORT_FRAME_IRQ_RESET equ 4
1584          PORT_SD_SIZE equ 9
1584          PORT_SD_RESULT equ 9
1584          PORT_SD_DATA equ 8
1584          PORT_UART_DATA equ 128
1584          PORT_UART_CONFIG equ 129
1584          PORT_UART_STATE equ 129
1584          PORT_EXT_DATA_OUT equ 136
1584          PORT_PALETTE_3 equ 144
1584          PORT_PALETTE_2 equ 145
1584          PORT_PALETTE_1 equ 146
1584          PORT_PALETTE_0 equ 147
1584          PORT_EXT_IN_DATA equ 137
1584          PORT_A0 equ 160
1584          PORT_ROM_0000 equ 168
1584          PORT_ROM_0000__ROM equ 0
1584          PORT_ROM_0000__RAM equ 128
1584          PORT_VIDEO_MODE_1_LOW equ 185
1584          PORT_VIDEO_MODE_1_HIGH equ 249
1584          PORT_VIDEO_MODE_0_LOW equ 184
1584          PORT_VIDEO_MODE_0_HIGH equ 248
1584          PORT_UART_SPEED_0 equ 187
1584          PORT_KEYBOARD equ 192
1584          PORT_UART_SPEED_1 equ 251
1584          PORT_CODE_ROM equ 186
1584          PORT_CHARGEN_ROM equ 250
1584          PORT_TAPE_AND_IDX2 equ 153
1584          PORT_TAPE_AND_IDX2_ID1_2 equ 2
1584          PORT_TAPE_AND_IDX2_ID2_2 equ 4
1584          PORT_TAPE_AND_IDX2_ID3_2 equ 8
1584          PORT_TAPE_AND_IDX2_ID6_2 equ 64
1584          PORT_TAPE_AND_IDX2_ID7_2 equ 128
1584          PORT_RESET_CU1 equ 188
1584          PORT_RESET_CU2 equ 189
1584          PORT_RESET_CU3 equ 190
1584          PORT_RESET_CU4 equ 191
1584          PORT_SET_CU1 equ 252
1584          PORT_SET_CU2 equ 253
1584          PORT_SET_CU3 equ 254
1584          PORT_SET_CU4 equ 255
1584          PORT_TAPE_OUT equ 176
1584          SD_COMMAND_READ equ 1
1584          SD_COMMAND_READ_SIZE equ 5
1584          SD_COMMAND_WRITE equ 2
1584          SD_COMMAND_WRITE_SIZE equ 5+128
1584          SD_RESULT_BUSY equ 255
1584          SD_RESULT_OK equ 0
1584          TEXT_SCREEN_HEIGHT equ 25
1584          FONT_HEIGHT equ 10
1584          FONT_WIDTH equ 3
1584          DrawCharAddress equ DrawChar+1
1584          SetColorAddress equ SetColor+1
1584          DrawCursorAddress equ DrawCursor+1
1584          OPCODE_NOP equ 0
1584          OPCODE_LD_DE_CONST equ 17
1584          OPCODE_LD_A_CONST equ 62
1584          OPCODE_LD_H_A equ 103
1584          OPCODE_LD_A_D equ 122
1584          OPCODE_LD_A_H equ 124
1584          OPCODE_XOR_A equ 175
1584          OPCODE_XOR_B equ 168
1584          OPCODE_JP equ 195
1584          OPCODE_RET equ 201
1584          OPCODE_SUB_CONST equ 214
1584          OPCODE_AND_CONST equ 230
1584          OPCODE_OR_CONST equ 246
1584          OPCODE_OUT equ 211
1584          OPCODE_JMP equ 195
font4:
1584 00 00 00  db 0
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
1F84 47        ld b, a
1F85 7D        ld a, l
1F86 87        add a
1F87 87        add a
1F88 85        add l
1F89 87        add a
1F8A 2F        cpl
1F8B 5F        ld e, a
1F8C 7C        ld a, h
1F8D 4F        ld c, a
1F8E B7        or a
1F8F 1F        rra
1F90 2F        cpl
1F91 57        ld d, a
1F92 78        ld a, b
1F93 C6 84     add font4
1F95 6F        ld l, a
1F96 CE 15     adc font4>>8
1F98 95        sub l
1F99 67        ld h, a
1F9A 79        ld a, c
1F9B E6 01     and 1
1F9D C2 C7 1F  jp nz, DrawChar40
DrawChar44:
1FA0 0E 0A     ld c, FONT_HEIGHT
_l235:
1FA2 7E        ld a, (hl)
1FA3 E6 F0     and 240
1FA5 47        ld b, a
1FA6 1A        ld a, (de)
DrawChar4a_And1:
1FA7 E6 0F     and 15
DrawChar4a_Xor1:
1FA9 A8        xor b
1FAA 12        ld (de), a
1FAB 1D        dec e
1FAC 24        inc h
_l237:
1FAD 0D        dec c
1FAE C2 A2 1F  jp nz, _l235
_l236:
DrawChar4a:
1FB1 7A        ld a, d
1FB2 D6 40     sub 64
1FB4 57        ld d, a
1FB5 0E 0A     ld c, FONT_HEIGHT
_l241:
1FB7 25        dec h
1FB8 1C        inc e
1FB9 7E        ld a, (hl)
1FBA E6 F0     and 240
1FBC 47        ld b, a
1FBD 1A        ld a, (de)
DrawChar4a_And2:
1FBE E6 0F     and 15
DrawChar4a_Xor2:
1FC0 A8        xor b
1FC1 12        ld (de), a
_l243:
1FC2 0D        dec c
1FC3 C2 B7 1F  jp nz, _l241
_l242:
1FC6 C9        ret
DrawChar40:
1FC7 0E 0A     ld c, FONT_HEIGHT
_l247:
1FC9 7E        ld a, (hl)
1FCA E6 0F     and 15
1FCC 47        ld b, a
1FCD 1A        ld a, (de)
DrawChar4b_And1:
1FCE E6 F0     and 240
DrawChar4b_Xor1:
1FD0 A8        xor b
1FD1 12        ld (de), a
1FD2 1D        dec e
1FD3 24        inc h
_l249:
1FD4 0D        dec c
1FD5 C2 C9 1F  jp nz, _l247
_l248:
DrawChar4b:
1FD8 7A        ld a, d
1FD9 D6 40     sub 64
1FDB 57        ld d, a
1FDC 0E 0A     ld c, FONT_HEIGHT
_l253:
1FDE 25        dec h
1FDF 1C        inc e
1FE0 7E        ld a, (hl)
1FE1 E6 0F     and 15
1FE3 47        ld b, a
1FE4 1A        ld a, (de)
DrawChar4b_And2:
1FE5 E6 F0     and 240
DrawChar4b_Xor2:
1FE7 A8        xor b
1FE8 12        ld (de), a
_l255:
1FE9 0D        dec c
1FEA C2 DE 1F  jp nz, _l253
_l254:
1FED C9        ret
SetColor4:
1FEE 4F        ld c, a
1FEF E6 04     and 4
1FF1 C2 02 20  jp nz, _l259
1FF4 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
1FF7 22 A7 1F  ld (DrawChar4a_And1), hl
1FFA 26 F0     ld h, 240
1FFC 22 CE 1F  ld (DrawChar4b_And1), hl
1FFF C3 0D 20  jp _l260
_l259:
2002 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
2005 22 A7 1F  ld (DrawChar4a_And1), hl
2008 26 0F     ld h, 15
200A 22 CE 1F  ld (DrawChar4b_And1), hl
_l260:
200D 47        ld b, a
200E 79        ld a, c
200F 87        add a
2010 87        add a
2011 E6 04     and 4
2013 A8        xor b
2014 3E A8     ld a, OPCODE_XOR_B
2016 C2 1B 20  jp nz, _l261
2019 3E 00     ld a, OPCODE_NOP
_l261:
201B 32 A9 1F  ld (DrawChar4a_Xor1), a
201E 32 D0 1F  ld (DrawChar4b_Xor1), a
2021 79        ld a, c
2022 E6 08     and 8
2024 C2 35 20  jp nz, _l262
2027 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
202A 22 BE 1F  ld (DrawChar4a_And2), hl
202D 26 F0     ld h, 240
202F 22 E5 1F  ld (DrawChar4b_And2), hl
2032 C3 40 20  jp _l263
_l262:
2035 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
2038 22 BE 1F  ld (DrawChar4a_And2), hl
203B 26 0F     ld h, 15
203D 22 E5 1F  ld (DrawChar4b_And2), hl
_l263:
2040 47        ld b, a
2041 79        ld a, c
2042 87        add a
2043 87        add a
2044 E6 08     and 8
2046 A8        xor b
2047 3E A8     ld a, OPCODE_XOR_B
2049 C2 4E 20  jp nz, _l264
204C 3E 00     ld a, OPCODE_NOP
_l264:
204E 32 C0 1F  ld (DrawChar4a_Xor2), a
2051 32 E7 1F  ld (DrawChar4b_Xor2), a
2054 C9        ret
DrawCursor4:
2055 7C        ld a, h
2056 B7        or a
2057 1F        rra
2058 2F        cpl
2059 57        ld d, a
205A 7D        ld a, l
205B 87        add a
205C 87        add a
205D 85        add l
205E 87        add a
205F 2F        cpl
2060 5F        ld e, a
2061 7C        ld a, h
2062 E6 01     and 1
2064 06 0F     ld b, 15
2066 C2 6B 20  jp nz, _l266
2069 06 F0     ld b, 240
_l266:
206B 0E 0A     ld c, FONT_HEIGHT
_l267:
206D 1A        ld a, (de)
206E A8        xor b
206F 12        ld (de), a
2070 1D        dec e
_l269:
2071 0D        dec c
2072 C2 6D 20  jp nz, _l267
_l268:
2075 C9        ret
SetScreenBw4:
2076 3E 60     ld a, 96
2078 32 CF 07  ld (text_screen_width), a
207B 21 EE 1F  ld hl, SetColor4
207E 22 D4 07  ld (SetColorAddress), hl
2081 21 84 1F  ld hl, DrawChar4
2084 22 D1 07  ld (DrawCharAddress), hl
2087 21 55 20  ld hl, DrawCursor4
208A 22 D7 07  ld (DrawCursorAddress), hl
208D 3E C9     ld a, OPCODE_RET
208F 32 B1 1F  ld (DrawChar4a), a
2092 32 D8 1F  ld (DrawChar4b), a
2095 C3 19 0B  jp SetScreenBw
SetScreenColor4:
2098 3E 60     ld a, 96
209A 32 CF 07  ld (text_screen_width), a
209D 21 EE 1F  ld hl, SetColor4
20A0 22 D4 07  ld (SetColorAddress), hl
20A3 21 84 1F  ld hl, DrawChar4
20A6 22 D1 07  ld (DrawCharAddress), hl
20A9 21 55 20  ld hl, DrawCursor4
20AC 22 D7 07  ld (DrawCursorAddress), hl
20AF 3E 7A     ld a, OPCODE_LD_A_D
20B1 32 B1 1F  ld (DrawChar4a), a
20B4 32 D8 1F  ld (DrawChar4b), a
20B7 C3 5E 0B  jp SetScreenColor
20BA          MOD_CTR equ 1
20BA          MOD_SHIFT equ 2
20BA          MOD_CAPS equ 16
20BA          MOD_NUM equ 32
20BA          SCREEN_0_ADDRESS equ 53248
20BA          SCREEN_1_ADDRESS equ 36864
20BA          PALETTE_WHITE equ 0
20BA          PALETTE_CYAN equ 1
20BA          PALETTE_MAGENTA equ 2
20BA          PALETTE_BLUE equ 3
20BA          PALETTE_YELLOW equ 4
20BA          PALETTE_GREEN equ 5
20BA          PALETTE_RED equ 6
20BA          PALETTE_XXX equ 7
20BA          PALETTE_GRAY equ 8
20BA          PALETTE_DARK_CYAN equ 9
20BA          PALETTE_DARK_MAGENTA equ 10
20BA          PALETTE_DARK_BLUE equ 11
20BA          PALETTE_DARK_YELLOW equ 12
20BA          PALETTE_DARK_GREEN equ 13
20BA          PALETTE_DARK_RED equ 14
20BA          PALETTE_BLACK equ 15
20BA          KEY_BACKSPACE equ 8
20BA          KEY_TAB equ 9
20BA          KEY_ENTER equ 13
20BA          KEY_ESC equ 27
20BA          KEY_ALT equ 1
20BA          KEY_F1 equ 242
20BA          KEY_F2 equ 243
20BA          KEY_F3 equ 244
20BA          KEY_UP equ 245
20BA          KEY_DOWN equ 246
20BA          KEY_RIGHT equ 247
20BA          KEY_LEFT equ 248
20BA          KEY_EXT_5 equ 249
20BA          KEY_END equ 250
20BA          KEY_HOME equ 251
20BA          KEY_INSERT equ 252
20BA          KEY_DEL equ 253
20BA          KEY_PG_UP equ 254
20BA          KEY_PG_DN equ 255
20BA          PORT_FRAME_IRQ_RESET equ 4
20BA          PORT_SD_SIZE equ 9
20BA          PORT_SD_RESULT equ 9
20BA          PORT_SD_DATA equ 8
20BA          PORT_UART_DATA equ 128
20BA          PORT_UART_CONFIG equ 129
20BA          PORT_UART_STATE equ 129
20BA          PORT_EXT_DATA_OUT equ 136
20BA          PORT_PALETTE_3 equ 144
20BA          PORT_PALETTE_2 equ 145
20BA          PORT_PALETTE_1 equ 146
20BA          PORT_PALETTE_0 equ 147
20BA          PORT_EXT_IN_DATA equ 137
20BA          PORT_A0 equ 160
20BA          PORT_ROM_0000 equ 168
20BA          PORT_ROM_0000__ROM equ 0
20BA          PORT_ROM_0000__RAM equ 128
20BA          PORT_VIDEO_MODE_1_LOW equ 185
20BA          PORT_VIDEO_MODE_1_HIGH equ 249
20BA          PORT_VIDEO_MODE_0_LOW equ 184
20BA          PORT_VIDEO_MODE_0_HIGH equ 248
20BA          PORT_UART_SPEED_0 equ 187
20BA          PORT_KEYBOARD equ 192
20BA          PORT_UART_SPEED_1 equ 251
20BA          PORT_CODE_ROM equ 186
20BA          PORT_CHARGEN_ROM equ 250
20BA          PORT_TAPE_AND_IDX2 equ 153
20BA          PORT_TAPE_AND_IDX2_ID1_2 equ 2
20BA          PORT_TAPE_AND_IDX2_ID2_2 equ 4
20BA          PORT_TAPE_AND_IDX2_ID3_2 equ 8
20BA          PORT_TAPE_AND_IDX2_ID6_2 equ 64
20BA          PORT_TAPE_AND_IDX2_ID7_2 equ 128
20BA          PORT_RESET_CU1 equ 188
20BA          PORT_RESET_CU2 equ 189
20BA          PORT_RESET_CU3 equ 190
20BA          PORT_RESET_CU4 equ 191
20BA          PORT_SET_CU1 equ 252
20BA          PORT_SET_CU2 equ 253
20BA          PORT_SET_CU3 equ 254
20BA          PORT_SET_CU4 equ 255
20BA          PORT_TAPE_OUT equ 176
20BA          SD_COMMAND_READ equ 1
20BA          SD_COMMAND_READ_SIZE equ 5
20BA          SD_COMMAND_WRITE equ 2
20BA          SD_COMMAND_WRITE_SIZE equ 5+128
20BA          SD_RESULT_BUSY equ 255
20BA          SD_RESULT_OK equ 0
20BA          stack equ 256
20BA          entry_cpm_conout_address equ EntryCpmConout+1
20BA          cpm_dph_a equ 65376
20BA          cpm_dph_b equ 65392
20BA          cpm_dma_buffer equ 65408
20BA          TEXT_SCREEN_HEIGHT equ 25
20BA          FONT_HEIGHT equ 10
20BA          FONT_WIDTH equ 3
20BA          DrawCharAddress equ DrawChar+1
20BA          SetColorAddress equ SetColor+1
20BA          DrawCursorAddress equ DrawCursor+1
20BA          NEXT_REPLAY_DELAY equ 3
20BA          FIRST_REPLAY_DELAY equ 30
20BA          SCAN_LAT equ 25
20BA          SCAN_RUS equ 24
20BA          SCAN_CAP equ 30
20BA          SCAN_NUM equ 28
20BA          LAYOUT_SIZE equ 80
20BA          CURSOR_BLINK_PERIOD equ 35
frame_counter:
20BA 00        db 0
key_leds:
20BB 20        db MOD_NUM
key_pressed:
20BC 00        db 0
key_delay:
20BD 00        db 0
key_rus:
20BE 00        db 0
key_read:
20BF 45        db key_buffer
key_write:
20C0 45        db key_buffer
20C1          key_read_l_write_h equ key_read
20C1          SHI equ 64
20C1          CAP equ 128
20C1          NUM equ 32
shiftLayout:
20C1 40        db SHI
20C2 80        db CAP
20C3 80        db CAP
20C4 80        db CAP
20C5 40        db SHI
20C6 80        db CAP
20C7 80        db CAP
20C8 40        db SHI
20C9 40        db SHI
20CA 80        db CAP
20CB 80        db CAP
20CC 80        db CAP
20CD 40        db SHI
20CE 80        db CAP
20CF 80        db CAP
20D0 40        db SHI
20D1 40        db SHI
20D2 80        db CAP
20D3 80        db CAP
20D4 80        db CAP
20D5 40        db SHI
20D6 80        db CAP
20D7 40        db SHI
20D8 40        db SHI
20D9 00        db 0
20DA 00        db 0
20DB 00        db 0
20DC 00        db 0
20DD 00        db 0
20DE 00        db 0
20DF 00        db 0
20E0 00        db 0
20E1 40        db SHI
20E2 80        db CAP
20E3 80        db CAP
20E4 80        db CAP
20E5 40        db SHI
20E6 40        db SHI
20E7 40        db SHI
20E8 40        db SHI
20E9 40        db SHI
20EA 80        db CAP
20EB 80        db CAP
20EC 80        db CAP
20ED 40        db SHI
20EE 40        db SHI
20EF 40        db SHI
20F0 40        db SHI
20F1 40        db SHI
20F2 20        db NUM
20F3 80        db CAP
20F4 80        db CAP
20F5 40        db SHI
20F6 40        db SHI
20F7 40        db SHI
20F8 20        db NUM
20F9 00        db 0
20FA 80        db CAP
20FB 80        db CAP
20FC 80        db CAP
20FD 00        db 0
20FE 20        db NUM
20FF 20        db NUM
2100 20        db NUM
2101 00        db 0
2102 80        db CAP
2103 00        db 0
2104 00        db 0
2105 40        db SHI
2106 20        db NUM
2107 20        db NUM
2108 20        db NUM
2109 00        db 0
210A 00        db 0
210B 00        db 0
210C 00        db 0
210D 00        db 0
210E 20        db NUM
210F 20        db NUM
2110 20        db NUM
2111 40        db SHI
2112 80        db CAP
2113 80        db CAP
2114 80        db CAP
2115 40        db SHI
2116 80        db CAP
2117 80        db CAP
2118 80        db CAP
2119 40        db SHI
211A 80        db CAP
211B 80        db CAP
211C 80        db CAP
211D 40        db SHI
211E 80        db CAP
211F 80        db CAP
2120 80        db CAP
2121 40        db SHI
2122 80        db CAP
2123 80        db CAP
2124 80        db CAP
2125 40        db SHI
2126 80        db CAP
2127 80        db CAP
2128 80        db CAP
2129 00        db 0
212A 00        db 0
212B 00        db 0
212C 00        db 0
212D 00        db 0
212E 00        db 0
212F 00        db 0
2130 00        db 0
2131 40        db SHI
2132 80        db CAP
2133 80        db CAP
2134 80        db CAP
2135 40        db SHI
2136 80        db CAP
2137 80        db CAP
2138 40        db SHI
2139 40        db SHI
213A 80        db CAP
213B 80        db CAP
213C 80        db CAP
213D 40        db SHI
213E 80        db CAP
213F 40        db SHI
2140 40        db SHI
2141 40        db SHI
2142 20        db NUM
2143 80        db CAP
2144 80        db CAP
2145 40        db SHI
2146 40        db SHI
2147 40        db SHI
2148 20        db NUM
2149 00        db 0
214A 80        db CAP
214B 80        db CAP
214C 80        db CAP
214D 00        db 0
214E 20        db NUM
214F 20        db NUM
2150 20        db NUM
2151 00        db 0
2152 80        db CAP
2153 00        db 0
2154 00        db 0
2155 40        db SHI
2156 20        db NUM
2157 20        db NUM
2158 20        db NUM
2159 00        db 0
215A 00        db 0
215B 00        db 0
215C 00        db 0
215D 00        db 0
215E 20        db NUM
215F 20        db NUM
2160 20        db NUM
ctrLayout:
2161 1E        db 30
2162 15        db 117&31
2163 0A        db 106&31
2164 0D        db 109&31
2165 1F        db 31
2166 09        db 105&31
2167 0B        db 107&31
2168 00        db 96&31
2169 1D        db 29
216A 19        db 121&31
216B 08        db 104&31
216C 0E        db 110&31
216D 08        db 8
216E 0F        db 111&31
216F 0C        db 108&31
2170 00        db 64&31
2171 1C        db 28
2172 14        db 116&31
2173 07        db 103&31
2174 02        db 98&31
2175 39        db 57
2176 10        db 112&31
2177 1B        db 91&31
2178 3F        db 63
2179 3F        db 63
217A 3F        db 63
217B 01        db KEY_ALT
217C 3F        db 63
217D 3F        db 63
217E 08        db KEY_BACKSPACE
217F 3F        db 63
2180 00        db 32&31
2181 1B        db 27
2182 12        db 114&31
2183 06        db 102&31
2184 16        db 118&31
2185 00        db 0
2186 1B        db 123&31
2187 1D        db 93&31
2188 2C        db 44
2189 00        db 0
218A 05        db 101&31
218B 04        db 100&31
218C 03        db 99&31
218D 1F        db 95&31
218E 1D        db 125&31
218F 3A        db 58
2190 2E        db 46
2191 31        db 49
2192 2E        db 46
2193 01        db 97&31
2194 1A        db 122&31
2195 1E        db 94&31
2196 0F        db 47&31
2197 3B        db 59
2198 30        db 48
2199 3F        db 63
219A 17        db 119&31
219B 13        db 115&31
219C 18        db 120&31
219D 3F        db 63
219E 37        db 55
219F 34        db 52
21A0 31        db 49
21A1 0A        db 10
21A2 11        db 113&31
21A3 09        db KEY_TAB
21A4 3F        db 63
21A5 1C        db 92&31
21A6 38        db 56
21A7 35        db 53
21A8 32        db 50
21A9 F4        db KEY_F3
21AA 3F        db 63
21AB F2        db KEY_F1
21AC F3        db KEY_F2
21AD 1B        db KEY_ESC
21AE 39        db 57
21AF 36        db 54
21B0 33        db 51
key_layout_table:
21B1 36        db 54
21B2 75        db 117
21B3 6A        db 106
21B4 6D        db 109
21B5 37        db 55
21B6 69        db 105
21B7 6B        db 107
21B8 60        db 96
21B9 35        db 53
21BA 79        db 121
21BB 68        db 104
21BC 6E        db 110
21BD 38        db 56
21BE 6F        db 111
21BF 6C        db 108
21C0 40        db 64
21C1 34        db 52
21C2 74        db 116
21C3 67        db 103
21C4 62        db 98
21C5 39        db 57
21C6 70        db 112
21C7 5B        db 91
21C8 00        db 0
21C9 00        db 0
21CA 00        db 0
21CB 01        db KEY_ALT
21CC 00        db 0
21CD 00        db 0
21CE 08        db KEY_BACKSPACE
21CF 00        db 0
21D0 20        db 32
21D1 33        db 51
21D2 72        db 114
21D3 66        db 102
21D4 76        db 118
21D5 30        db 48
21D6 7B        db 123
21D7 5D        db 93
21D8 2C        db 44
21D9 32        db 50
21DA 65        db 101
21DB 64        db 100
21DC 63        db 99
21DD 2D        db 45
21DE 7D        db 125
21DF 3A        db 58
21E0 2E        db 46
21E1 31        db 49
21E2 FD        db KEY_DEL
21E3 61        db 97
21E4 7A        db 122
21E5 5E        db 94
21E6 2F        db 47
21E7 3B        db 59
21E8 FC        db KEY_INSERT
21E9 00        db 0
21EA 77        db 119
21EB 73        db 115
21EC 78        db 120
21ED FD        db KEY_DEL
21EE FB        db KEY_HOME
21EF F8        db KEY_LEFT
21F0 FA        db KEY_END
21F1 0D        db KEY_ENTER
21F2 71        db 113
21F3 09        db KEY_TAB
21F4 00        db 0
21F5 5C        db 92
21F6 F5        db KEY_UP
21F7 F9        db KEY_EXT_5
21F8 F6        db KEY_DOWN
21F9 F4        db KEY_F3
21FA 00        db 0
21FB F2        db KEY_F1
21FC F3        db KEY_F2
21FD 1B        db KEY_ESC
21FE FE        db KEY_PG_UP
21FF F7        db KEY_RIGHT
2200 FF        db KEY_PG_DN
2201 26        db 38
2202 55        db 85
2203 4A        db 74
2204 4D        db 77
2205 27        db 39
2206 49        db 73
2207 4B        db 75
2208 60        db 96
2209 25        db 37
220A 59        db 89
220B 48        db 72
220C 4E        db 78
220D 28        db 40
220E 4F        db 79
220F 4C        db 76
2210 40        db 64
2211 24        db 36
2212 54        db 84
2213 47        db 71
2214 42        db 66
2215 29        db 41
2216 50        db 80
2217 5B        db 91
2218 00        db 0
2219 00        db 0
221A 00        db 0
221B 01        db KEY_ALT
221C 00        db 0
221D 00        db 0
221E 08        db KEY_BACKSPACE
221F 00        db 0
2220 20        db 32
2221 23        db 35
2222 52        db 82
2223 46        db 70
2224 56        db 86
2225 5F        db 95
2226 7B        db 123
2227 5D        db 93
2228 3C        db 60
2229 22        db 34
222A 45        db 69
222B 44        db 68
222C 43        db 67
222D 3D        db 61
222E 7D        db 125
222F 2A        db 42
2230 3E        db 62
2231 21        db 33
2232 2E        db 46
2233 41        db 65
2234 5A        db 90
2235 7E        db 126
2236 3F        db 63
2237 2B        db 43
2238 30        db 48
2239 00        db 0
223A 57        db 87
223B 53        db 83
223C 58        db 88
223D FD        db KEY_DEL
223E 37        db 55
223F 34        db 52
2240 31        db 49
2241 0D        db KEY_ENTER
2242 51        db 81
2243 09        db KEY_TAB
2244 00        db 0
2245 7C        db 124
2246 38        db 56
2247 35        db 53
2248 32        db 50
2249 F4        db KEY_F3
224A 00        db 0
224B F2        db KEY_F1
224C F3        db KEY_F2
224D 1B        db KEY_ESC
224E 39        db 57
224F 36        db 54
2250 33        db 51
2251 36        db 54
2252 A3        db 163
2253 AE        db 174
2254 EC        db 236
2255 37        db 55
2256 E8        db 232
2257 AB        db 171
2258 A1        db 161
2259 35        db 53
225A AD        db 173
225B E0        db 224
225C E2        db 226
225D 38        db 56
225E E9        db 233
225F A4        db 164
2260 EE        db 238
2261 34        db 52
2262 A5        db 165
2263 AF        db 175
2264 A8        db 168
2265 39        db 57
2266 A7        db 167
2267 A6        db 166
2268 F1        db 241
2269 00        db 0
226A 00        db 0
226B 01        db KEY_ALT
226C 00        db 0
226D 00        db 0
226E 08        db KEY_BACKSPACE
226F 00        db 0
2270 20        db 32
2271 33        db 51
2272 AA        db 170
2273 A0        db 160
2274 AC        db 172
2275 30        db 48
2276 E5        db 229
2277 ED        db 237
2278 2C        db 44
2279 32        db 50
227A E3        db 227
227B A2        db 162
227C E1        db 225
227D 2D        db 45
227E EA        db 234
227F 3A        db 58
2280 2E        db 46
2281 31        db 49
2282 FD        db KEY_DEL
2283 E4        db 228
2284 EF        db 239
2285 5E        db 94
2286 2F        db 47
2287 3B        db 59
2288 FC        db KEY_INSERT
2289 00        db 0
228A E6        db 230
228B EB        db 235
228C E7        db 231
228D FD        db KEY_DEL
228E FB        db KEY_HOME
228F F8        db KEY_LEFT
2290 FA        db KEY_END
2291 0D        db KEY_ENTER
2292 A9        db 169
2293 09        db KEY_TAB
2294 00        db 0
2295 5C        db 92
2296 F5        db KEY_UP
2297 F9        db KEY_EXT_5
2298 F6        db KEY_DOWN
2299 F4        db KEY_F3
229A 00        db 0
229B F2        db KEY_F1
229C F3        db KEY_F2
229D 1B        db KEY_ESC
229E FE        db KEY_PG_UP
229F F7        db KEY_RIGHT
22A0 FF        db KEY_PG_DN
22A1 26        db 38
22A2 83        db 131
22A3 8E        db 142
22A4 9C        db 156
22A5 27        db 39
22A6 98        db 152
22A7 8B        db 139
22A8 81        db 129
22A9 25        db 37
22AA 8D        db 141
22AB 90        db 144
22AC 92        db 146
22AD 28        db 40
22AE 99        db 153
22AF 84        db 132
22B0 9E        db 158
22B1 24        db 36
22B2 85        db 133
22B3 8F        db 143
22B4 88        db 136
22B5 29        db 41
22B6 58        db 88
22B7 86        db 134
22B8 F0        db 240
22B9 00        db 0
22BA 00        db 0
22BB 01        db KEY_ALT
22BC 00        db 0
22BD 00        db 0
22BE 08        db KEY_BACKSPACE
22BF 00        db 0
22C0 20        db 32
22C1 23        db 35
22C2 8A        db 138
22C3 80        db 128
22C4 8C        db 140
22C5 5F        db 95
22C6 58        db 88
22C7 9D        db 157
22C8 3C        db 60
22C9 22        db 34
22CA 93        db 147
22CB 82        db 130
22CC 91        db 145
22CD 3D        db 61
22CE 9A        db 154
22CF 2A        db 42
22D0 3E        db 62
22D1 21        db 33
22D2 2E        db 46
22D3 94        db 148
22D4 9F        db 159
22D5 7E        db 126
22D6 3F        db 63
22D7 2B        db 43
22D8 30        db 48
22D9 00        db 0
22DA 96        db 150
22DB 9B        db 155
22DC 97        db 151
22DD FD        db KEY_DEL
22DE 37        db 55
22DF 34        db 52
22E0 31        db 49
22E1 0D        db KEY_ENTER
22E2 89        db 137
22E3 09        db KEY_TAB
22E4 00        db 0
22E5 7C        db 124
22E6 38        db 56
22E7 35        db 53
22E8 32        db 50
22E9 F4        db KEY_F3
22EA 00        db 0
22EB F2        db KEY_F1
22EC F3        db KEY_F2
22ED 1B        db KEY_ESC
22EE 39        db 57
22EF 36        db 54
22F0 33        db 51
CheckKeyboard:
22F1 2A BF 20  ld hl, (key_read_l_write_h)
22F4 7C        ld a, h
22F5 BD        cp l
22F6 C9        ret
ReadKeyboard:
22F7 2A BF 20  ld hl, (key_read_l_write_h)
22FA 7C        ld a, h
22FB BD        cp l
22FC C8        ret z
22FD 26 00     ld h, key_buffer>>8
22FF 56        ld d, (hl)
2300 2C        inc l
2301 7D        ld a, l
2302 FE 55     cp key_buffer+16
2304 C2 09 23  jp nz, _l284
2307 3E 45     ld a, key_buffer
_l284:
2309 32 BF 20  ld (key_read), a
230C AF        xor a
230D 3C        inc a
230E 7A        ld a, d
230F C9        ret
KeyPush:
2310 E5        push hl
2311 2A BF 20  ld hl, (key_read_l_write_h)
2314 26 00     ld h, key_buffer>>8
2316 77        ld (hl), a
2317 2C        inc l
2318 7D        ld a, l
2319 FE 55     cp key_buffer+16&255
231B C2 20 23  jp nz, _l286
231E 3E 45     ld a, key_buffer
_l286:
2320 32 C0 20  ld (key_write), a
2323 E1        pop hl
2324 C9        ret
KeyPressed:
2325 57        ld d, a
2326 2A BC 20  ld hl, (key_pressed)
2329 BD        cp l
232A C2 37 23  jp nz, _l288
232D 21 BD 20  ld hl, key_delay
2330 35        dec (hl)
2331 C0        ret nz
2332 36 03     ld (hl), NEXT_REPLAY_DELAY
2334 C3 3F 23  jp _l289
_l288:
2337 32 BC 20  ld (key_pressed), a
233A 21 BD 20  ld hl, key_delay
233D 36 1E     ld (hl), FIRST_REPLAY_DELAY
_l289:
233F FE 19     cp SCAN_LAT
2341 C2 49 23  jp nz, _l290
2344 AF        xor a
2345 32 BE 20  ld (key_rus), a
2348 C9        ret
_l290:
2349 FE 18     cp SCAN_RUS
234B C2 54 23  jp nz, _l291
234E 3E 50     ld a, LAYOUT_SIZE
2350 32 BE 20  ld (key_rus), a
2353 C9        ret
_l291:
2354 FE 1E     cp SCAN_CAP
2356 C2 62 23  jp nz, _l292
2359 3A BB 20  ld a, (key_leds)
235C EE 10     xor MOD_CAPS
235E 32 BB 20  ld (key_leds), a
2361 C9        ret
_l292:
2362 FE 1C     cp SCAN_NUM
2364 C2 70 23  jp nz, _l293
2367 3A BB 20  ld a, (key_leds)
236A EE 20     xor MOD_NUM
236C 32 BB 20  ld (key_leds), a
236F C9        ret
_l293:
2370 7B        ld a, e
2371 E6 01     and MOD_CTR
2373 CA 83 23  jp z, _l294
2376 7A        ld a, d
2377 C6 61     add ctrLayout
2379 6F        ld l, a
237A CE 21     adc ctrLayout>>8
237C 95        sub l
237D 67        ld h, a
237E 7E        ld a, (hl)
237F CD 10 23  call KeyPush
2382 C9        ret
_l294:
2383 7A        ld a, d
2384 C6 C1     add shiftLayout
2386 6F        ld l, a
2387 CE 20     adc shiftLayout>>8
2389 95        sub l
238A 67        ld h, a
238B 3A BE 20  ld a, (key_rus)
238E B7        or a
238F CA 99 23  jp z, _l295
2392 3E 50     ld a, LAYOUT_SIZE
2394 85        add l
2395 6F        ld l, a
2396 8C        adc h
2397 95        sub l
2398 67        ld h, a
_l295:
2399 7E        ld a, (hl)
239A 26 00     ld h, 0
239C 87        add a
239D D2 B5 23  jp nc, _l296
23A0 7B        ld a, e
23A1 E6 02     and MOD_SHIFT
23A3 CA A8 23  jp z, _l297
23A6 26 50     ld h, LAYOUT_SIZE
_l297:
23A8 7B        ld a, e
23A9 E6 10     and MOD_CAPS
23AB C2 B2 23  jp nz, _l298
23AE 3E 50     ld a, LAYOUT_SIZE
23B0 94        sub h
23B1 67        ld h, a
_l298:
23B2 C3 D0 23  jp _l299
_l296:
23B5 87        add a
23B6 D2 C4 23  jp nc, _l300
23B9 7B        ld a, e
23BA E6 02     and MOD_SHIFT
23BC CA C1 23  jp z, _l301
23BF 26 50     ld h, LAYOUT_SIZE
_l301:
23C1 C3 D0 23  jp _l302
_l300:
23C4 87        add a
23C5 D2 D0 23  jp nc, _l303
23C8 7B        ld a, e
23C9 E6 20     and MOD_NUM
23CB C2 D0 23  jp nz, _l304
23CE 26 50     ld h, LAYOUT_SIZE
_l299:
_l302:
_l303:
_l304:
23D0 7A        ld a, d
23D1 84        add h
23D2 C6 B1     add key_layout_table
23D4 6F        ld l, a
23D5 CE 21     adc key_layout_table>>8
23D7 95        sub l
23D8 67        ld h, a
23D9 3A BE 20  ld a, (key_rus)
23DC B7        or a
23DD CA E7 23  jp z, _l305
23E0 3E A0     ld a, LAYOUT_SIZE*2
23E2 85        add l
23E3 6F        ld l, a
23E4 8C        adc h
23E5 95        sub l
23E6 67        ld h, a
_l305:
23E7 7E        ld a, (hl)
23E8 C3 10 23  jp KeyPush
InterruptHandler:
23EB DB 04     in a, (PORT_FRAME_IRQ_RESET)
23ED 0F        rrca
23EE D8        ret c
23EF D3 04     out (PORT_FRAME_IRQ_RESET), a
23F1 21 BA 20  ld hl, frame_counter
23F4 34        inc (hl)
23F5 3A 01 01  ld a, (cursor_visible)
23F8 B7        or a
23F9 CA 23 24  jp z, _l307
23FC 3A 00 01  ld a, (cursor_blink_counter)
23FF 3D        dec a
2400 C2 20 24  jp nz, _l308
2403 3A 01 01  ld a, (cursor_visible)
2406 EE 02     xor 2
2408 32 01 01  ld (cursor_visible), a
240B DB 03     in a, (3)
240D F5        push af
240E 3E 01     ld a, 1
2410 D3 03     out (3), a
2412 2A 03 01  ld hl, (cursor_y)
2415 CD D6 07  call DrawCursor
2418 F1        pop af
2419 D3 03     out (3), a
241B 3E 23     ld a, CURSOR_BLINK_PERIOD
241D 32 00 01  ld (cursor_blink_counter), a
_l308:
2420 32 00 01  ld (cursor_blink_counter), a
_l307:
2423 3A BB 20  ld a, (key_leds)
2426 F6 08     or 8
2428 D3 C0     out (PORT_KEYBOARD), a
242A DB C0     in a, (PORT_KEYBOARD)
242C E6 08     and 8
242E 3A BB 20  ld a, (key_leds)
2431 CA 36 24  jp z, _l309
2434 F6 01     or MOD_CTR
_l309:
2436 5F        ld e, a
2437 3A BB 20  ld a, (key_leds)
243A F6 03     or 3
243C D3 C0     out (PORT_KEYBOARD), a
243E DB C0     in a, (PORT_KEYBOARD)
2440 E6 08     and 8
2442 CA 49 24  jp z, _l310
2445 3E 02     ld a, MOD_SHIFT
2447 B3        or e
2448 5F        ld e, a
_l310:
2449 06 09     ld b, 9
_l311:
244B 3A BB 20  ld a, (key_leds)
244E B0        or b
244F D3 C0     out (PORT_KEYBOARD), a
2451 DB C0     in a, (PORT_KEYBOARD)
2453 B7        or a
2454 CA 72 24  jp z, _l314
2457 0E 07     ld c, 7
_l315:
2459 87        add a
245A D2 6E 24  jp nc, _l318
245D 57        ld d, a
245E 78        ld a, b
245F 87        add a
2460 87        add a
2461 87        add a
2462 81        add c
2463 FE 1B     cp 27
2465 CA 6D 24  jp z, _l319
2468 FE 43     cp 67
246A C2 25 23  jp nz, KeyPressed
_l319:
246D 7A        ld a, d
_l317:
_l318:
246E 0D        dec c
246F F2 59 24  jp p, _l315
_l313:
_l314:
_l316:
2472 05        dec b
2473 F2 4B 24  jp p, _l311
_l312:
2476 3E FF     ld a, 255
2478 32 BC 20  ld (key_pressed), a
247B C9        ret
247C          SCREEN_0_ADDRESS equ 53248
247C          SCREEN_1_ADDRESS equ 36864
247C          PALETTE_WHITE equ 0
247C          PALETTE_CYAN equ 1
247C          PALETTE_MAGENTA equ 2
247C          PALETTE_BLUE equ 3
247C          PALETTE_YELLOW equ 4
247C          PALETTE_GREEN equ 5
247C          PALETTE_RED equ 6
247C          PALETTE_XXX equ 7
247C          PALETTE_GRAY equ 8
247C          PALETTE_DARK_CYAN equ 9
247C          PALETTE_DARK_MAGENTA equ 10
247C          PALETTE_DARK_BLUE equ 11
247C          PALETTE_DARK_YELLOW equ 12
247C          PALETTE_DARK_GREEN equ 13
247C          PALETTE_DARK_RED equ 14
247C          PALETTE_BLACK equ 15
247C          KEY_BACKSPACE equ 8
247C          KEY_TAB equ 9
247C          KEY_ENTER equ 13
247C          KEY_ESC equ 27
247C          KEY_ALT equ 1
247C          KEY_F1 equ 242
247C          KEY_F2 equ 243
247C          KEY_F3 equ 244
247C          KEY_UP equ 245
247C          KEY_DOWN equ 246
247C          KEY_RIGHT equ 247
247C          KEY_LEFT equ 248
247C          KEY_EXT_5 equ 249
247C          KEY_END equ 250
247C          KEY_HOME equ 251
247C          KEY_INSERT equ 252
247C          KEY_DEL equ 253
247C          KEY_PG_UP equ 254
247C          KEY_PG_DN equ 255
247C          PORT_FRAME_IRQ_RESET equ 4
247C          PORT_SD_SIZE equ 9
247C          PORT_SD_RESULT equ 9
247C          PORT_SD_DATA equ 8
247C          PORT_UART_DATA equ 128
247C          PORT_UART_CONFIG equ 129
247C          PORT_UART_STATE equ 129
247C          PORT_EXT_DATA_OUT equ 136
247C          PORT_PALETTE_3 equ 144
247C          PORT_PALETTE_2 equ 145
247C          PORT_PALETTE_1 equ 146
247C          PORT_PALETTE_0 equ 147
247C          PORT_EXT_IN_DATA equ 137
247C          PORT_A0 equ 160
247C          PORT_ROM_0000 equ 168
247C          PORT_ROM_0000__ROM equ 0
247C          PORT_ROM_0000__RAM equ 128
247C          PORT_VIDEO_MODE_1_LOW equ 185
247C          PORT_VIDEO_MODE_1_HIGH equ 249
247C          PORT_VIDEO_MODE_0_LOW equ 184
247C          PORT_VIDEO_MODE_0_HIGH equ 248
247C          PORT_UART_SPEED_0 equ 187
247C          PORT_KEYBOARD equ 192
247C          PORT_UART_SPEED_1 equ 251
247C          PORT_CODE_ROM equ 186
247C          PORT_CHARGEN_ROM equ 250
247C          PORT_TAPE_AND_IDX2 equ 153
247C          PORT_TAPE_AND_IDX2_ID1_2 equ 2
247C          PORT_TAPE_AND_IDX2_ID2_2 equ 4
247C          PORT_TAPE_AND_IDX2_ID3_2 equ 8
247C          PORT_TAPE_AND_IDX2_ID6_2 equ 64
247C          PORT_TAPE_AND_IDX2_ID7_2 equ 128
247C          PORT_RESET_CU1 equ 188
247C          PORT_RESET_CU2 equ 189
247C          PORT_RESET_CU3 equ 190
247C          PORT_RESET_CU4 equ 191
247C          PORT_SET_CU1 equ 252
247C          PORT_SET_CU2 equ 253
247C          PORT_SET_CU3 equ 254
247C          PORT_SET_CU4 equ 255
247C          PORT_TAPE_OUT equ 176
247C          SD_COMMAND_READ equ 1
247C          SD_COMMAND_READ_SIZE equ 5
247C          SD_COMMAND_WRITE equ 2
247C          SD_COMMAND_WRITE_SIZE equ 5+128
247C          SD_RESULT_BUSY equ 255
247C          SD_RESULT_OK equ 0
247C          stack equ 256
247C          entry_cpm_conout_address equ EntryCpmConout+1
247C          cpm_dph_a equ 65376
247C          cpm_dph_b equ 65392
247C          cpm_dma_buffer equ 65408
247C          TEXT_SCREEN_HEIGHT equ 25
247C          FONT_HEIGHT equ 10
247C          FONT_WIDTH equ 3
247C          DrawCharAddress equ DrawChar+1
247C          SetColorAddress equ SetColor+1
247C          DrawCursorAddress equ DrawCursor+1
247C          MOD_CTR equ 1
247C          MOD_SHIFT equ 2
247C          MOD_CAPS equ 16
247C          MOD_NUM equ 32
247C          OPCODE_NOP equ 0
247C          OPCODE_LD_DE_CONST equ 17
247C          OPCODE_LD_A_CONST equ 62
247C          OPCODE_LD_H_A equ 103
247C          OPCODE_LD_A_D equ 122
247C          OPCODE_LD_A_H equ 124
247C          OPCODE_XOR_A equ 175
247C          OPCODE_XOR_B equ 168
247C          OPCODE_JP equ 195
247C          OPCODE_RET equ 201
247C          OPCODE_SUB_CONST equ 214
247C          OPCODE_AND_CONST equ 230
247C          OPCODE_OR_CONST equ 246
247C          OPCODE_OUT equ 211
247C          OPCODE_JMP equ 195
247C          MIT_SUBMENU equ 1
247C          MIT_JUMP equ 2
247C          cpm_load_address equ 58624
247C          CpmEntryPoint equ 64307
config_begin:
247C           ds 0
screen_mode:
247C 00        ds 1
color_0:
247D 0B        db PALETTE_DARK_BLUE
color_1:
247E 01        db PALETTE_CYAN
color_2:
247F 00        db PALETTE_WHITE
color_3:
2480 04        db PALETTE_YELLOW
drive_0:
2481 00        db 0
drive_1:
2482 01        db 1
codepage:
2483 00        db 0
uart_baud_rate:
2484 03        db 3
uart_data_bits:
2485 03        db 3
uart_parity:
2486 00        db 0
uart_stop_bits:
2487 00        db 0
uart_flow:
2488 00        db 0
config_check_sum:
2489 00        db 0
248A          MENU_FIRST_ITEM_Y equ 3
248A          MENU_VALUES_X equ 20
menu_item_address:
248A 7B        ld a, e
248B 87        add a
248C 87        add a
248D 87        add a
248E C6 02     add 2
2490 85        add l
2491 6F        ld l, a
2492 8C        adc h
2493 95        sub l
2494 67        ld h, a
2495 C9        ret
menu_item_is_empty:
2496 E5        push hl
2497 C5        push bc
2498 CD 8A 24  call menu_item_address
249B 7E        ld a, (hl)
249C 23        inc hl
249D 66        ld h, (hl)
249E 6F        ld l, a
249F 7E        ld a, (hl)
24A0 B7        or a
24A1 C1        pop bc
24A2 E1        pop hl
24A3 C9        ret
SetColorEx:
24A4 C5        push bc
24A5 D5        push de
24A6 E5        push hl
24A7 CD D3 07  call SetColor
24AA E1        pop hl
24AB D1        pop de
24AC C1        pop bc
24AD C9        ret
Menu:
24AE D5        push de
24AF E5        push hl
24B0 3E 02     ld a, 2
24B2 CD D3 07  call SetColor
24B5 CD D9 07  call ClearScreen
24B8 E1        pop hl
24B9 E5        push hl
24BA 5E        ld e, (hl)
24BB 23        inc hl
24BC 56        ld d, (hl)
24BD 23        inc hl
24BE E5        push hl
24BF EB        ex hl, de
24C0 0E 00     ld c, 0
24C2 11 01 03  ld de, 769
24C5 CD D6 08  call DrawText
24C8 3E 01     ld a, 1
24CA CD D3 07  call SetColor
24CD E1        pop hl
24CE 06 00     ld b, 0
24D0 E5        push hl
_l340:
24D1 5E        ld e, (hl)
24D2 23        inc hl
24D3 56        ld d, (hl)
24D4 23        inc hl
24D5 7B        ld a, e
24D6 B7        or a
24D7 CA 41 25  jp z, _l339
24DA D5        push de
24DB E5        push hl
24DC C5        push bc
24DD EB        ex hl, de
24DE 16 03     ld d, 3
24E0 58        ld e, b
24E1 1C        inc e
24E2 1C        inc e
24E3 1C        inc e
24E4 3E 01     ld a, 1
24E6 CD A4 24  call SetColorEx
24E9 0E 00     ld c, 0
24EB CD D6 08  call DrawText
24EE C1        pop bc
24EF E1        pop hl
24F0 23        inc hl
24F1 23        inc hl
24F2 23        inc hl
24F3 23        inc hl
24F4 E5        push hl
24F5 C5        push bc
24F6 58        ld e, b
24F7 4E        ld c, (hl)
24F8 23        inc hl
24F9 46        ld b, (hl)
24FA 78        ld a, b
24FB B1        or c
24FC CA 38 25  jp z, _l341
24FF 0A        ld a, (bc)
2500 47        ld b, a
2501 2B        dec hl
2502 2B        dec hl
2503 4E        ld c, (hl)
2504 2B        dec hl
2505 6E        ld l, (hl)
2506 61        ld h, c
2507 23        inc hl
2508 23        inc hl
_l343:
2509 7E        ld a, (hl)
250A 23        inc hl
250B B6        or (hl)
250C 23        inc hl
250D CA 38 25  jp z, _l342
2510 23        inc hl
2511 23        inc hl
2512 78        ld a, b
2513 BE        cp (hl)
2514 C2 31 25  jp nz, _l344
2517 2B        dec hl
2518 2B        dec hl
2519 2B        dec hl
251A 2B        dec hl
251B 4E        ld c, (hl)
251C 23        inc hl
251D 66        ld h, (hl)
251E 69        ld l, c
251F 3E 03     ld a, 3
2521 CD A4 24  call SetColorEx
2524 16 14     ld d, MENU_VALUES_X
2526 1C        inc e
2527 1C        inc e
2528 1C        inc e
2529 0E 00     ld c, 0
252B CD D6 08  call DrawText
252E C3 38 25  jp _l342
_l344:
2531 23        inc hl
2532 23        inc hl
2533 23        inc hl
2534 23        inc hl
2535 C3 09 25  jp _l343
_l341:
_l342:
2538 C1        pop bc
2539 E1        pop hl
253A 23        inc hl
253B 23        inc hl
253C D1        pop de
253D 04        inc b
253E C3 D1 24  jp _l340
_l339:
2541 E1        pop hl
2542 E1        pop hl
2543 D1        pop de
2544 3E 02     ld a, 2
2546 CD A4 24  call SetColorEx
2549 05        dec b
_l346:
254A D5        push de
254B C5        push bc
254C E5        push hl
254D 1C        inc e
254E 1C        inc e
254F 1C        inc e
2550 0E 00     ld c, 0
2552 16 01     ld d, 1
2554 21 70 45  ld hl, _l347
2557 CD D6 08  call DrawText
255A E1        pop hl
255B C1        pop bc
255C D1        pop de
255D 53        ld d, e
_l348:
255E D5        push de
255F C5        push bc
2560 E5        push hl
2561 CD F7 22  call ReadKeyboard
2564 E1        pop hl
2565 C1        pop bc
2566 D1        pop de
_l350:
2567 CA 5E 25  jp z, _l348
_l349:
256A FE 0D     cp KEY_ENTER
256C C2 B1 25  jp nz, _l351
256F E5        push hl
2570 CD 8A 24  call menu_item_address
2573 23        inc hl
2574 23        inc hl
2575 7E        ld a, (hl)
2576 B7        or a
2577 C2 84 25  jp nz, _l352
257A 23        inc hl
257B 23        inc hl
257C 5E        ld e, (hl)
257D 23        inc hl
257E 56        ld d, (hl)
257F E1        pop hl
2580 C9        ret
2581 C3 AD 25  jp _l353
_l352:
2584 3D        dec a
2585 C2 A1 25  jp nz, _l354
2588 23        inc hl
2589 23        inc hl
258A 56        ld d, (hl)
258B 23        inc hl
258C E5        push hl
258D 66        ld h, (hl)
258E 6A        ld l, d
258F D5        push de
2590 1E 00     ld e, 0
2592 CD AE 24  call Menu
2595 7B        ld a, e
2596 D1        pop de
2597 E1        pop hl
2598 23        inc hl
2599 56        ld d, (hl)
259A 23        inc hl
259B 66        ld h, (hl)
259C 6A        ld l, d
259D 77        ld (hl), a
259E C3 AD 25  jp _l355
_l354:
25A1 3D        dec a
25A2 C2 AD 25  jp nz, _l356
25A5 23        inc hl
25A6 23        inc hl
25A7 56        ld d, (hl)
25A8 23        inc hl
25A9 66        ld h, (hl)
25AA 6A        ld l, d
25AB D1        pop de
25AC E9        jp hl
_l353:
_l355:
_l356:
25AD E1        pop hl
25AE C3 AE 24  jp Menu
_l351:
25B1 FE F5     cp KEY_UP
25B3 C2 C9 25  jp nz, _l357
_l359:
25B6 7B        ld a, e
25B7 FE 00     cp 0
25B9 CA C6 25  jp z, _l358
25BC 1D        dec e
25BD CD 96 24  call menu_item_is_empty
25C0 C2 C6 25  jp nz, _l358
25C3 C3 B6 25  jp _l359
_l358:
25C6 C3 DD 25  jp _l360
_l357:
25C9 FE F6     cp KEY_DOWN
25CB C2 4A 25  jp nz, _l346
_l362:
25CE 7B        ld a, e
25CF B8        cp b
25D0 CA DD 25  jp z, _l361
25D3 1C        inc e
25D4 CD 96 24  call menu_item_is_empty
25D7 C2 DD 25  jp nz, _l361
25DA C3 CE 25  jp _l362
_l361:
_l360:
25DD D5        push de
25DE C5        push bc
25DF E5        push hl
25E0 5A        ld e, d
25E1 1C        inc e
25E2 1C        inc e
25E3 1C        inc e
25E4 0E 00     ld c, 0
25E6 16 01     ld d, 1
25E8 21 74 45  ld hl, _l363
25EB CD D6 08  call DrawText
25EE E1        pop hl
25EF C1        pop bc
25F0 D1        pop de
25F1 C3 4A 25  jp _l346
SaveConfig:
_l345:
25F4 21 7C 24  ld hl, config_begin
25F7 0E 0D     ld c, config_check_sum-config_begin
25F9 3E AA     ld a, 170
_l365:
25FB AE        xor (hl)
25FC 23        inc hl
_l367:
25FD 0D        dec c
25FE C2 FB 25  jp nz, _l365
_l366:
2601 77        ld (hl), a
2602 21 7C 24  ld hl, config_begin
2605 0E 0E     ld c, (config_check_sum-config_begin)+1
2607 C3 47 45  jp WriteConfig
menu_screen:
260A 3E 47     dw _l369
260C B6 45     dw _l370
260E 00 00     dw 0
2610 00 00     dw 0
2612 00 00     dw 0
2614 C6 45     dw _l371
2616 00 00     dw 0
2618 01 00     dw 1
261A 00 00     dw 0
261C EF 45     dw _l372
261E 00 00     dw 0
2620 02 00     dw 2
2622 00 00     dw 0
2624 FF 45     dw _l373
2626 00 00     dw 0
2628 03 00     dw 3
262A 00 00     dw 0
262C 00 00     dw 0
menu_drive:
262E 8C 46     dw _l375
2630 23 48     dw _l376
2632 00 00     dw 0
2634 00 00     dw 0
2636 00 00     dw 0
2638 30 48     dw _l377
263A 00 00     dw 0
263C 01 00     dw 1
263E 00 00     dw 0
2640 6C 46     dw _l378
2642 00 00     dw 0
2644 02 00     dw 2
2646 00 00     dw 0
2648 00 00     dw 0
menu_code_page:
264A A0 46     dw _l380
264C DE 45     dw _l381
264E 00 00     dw 0
2650 00 00     dw 0
2652 00 00     dw 0
2654 8D 45     dw _l382
2656 00 00     dw 0
2658 01 00     dw 1
265A 00 00     dw 0
265C EB 47     dw _l383
265E 00 00     dw 0
2660 02 00     dw 2
2662 00 00     dw 0
2664 F3 47     dw _l384
2666 00 00     dw 0
2668 03 00     dw 3
266A 00 00     dw 0
266C 00 00     dw 0
menu_uart_baud_rate:
266E 56 47     dw _l386
2670 82 45     dw _l387
2672 00 00     dw 0
2674 00 00     dw 0
2676 00 00     dw 0
2678 98 45     dw _l388
267A 00 00     dw 0
267C 01 00     dw 1
267E 00 00     dw 0
2680 A3 45     dw _l389
2682 00 00     dw 0
2684 02 00     dw 2
2686 00 00     dw 0
2688 E4 45     dw _l390
268A 00 00     dw 0
268C 03 00     dw 3
268E 00 00     dw 0
2690 00 00     dw 0
menu_uart_data_bits:
2692 B5 46     dw _l392
2694 AE 45     dw _l393
2696 00 00     dw 0
2698 00 00     dw 0
269A 00 00     dw 0
269C B2 45     dw _l394
269E 00 00     dw 0
26A0 01 00     dw 1
26A2 00 00     dw 0
26A4 D6 45     dw _l395
26A6 00 00     dw 0
26A8 02 00     dw 2
26AA 00 00     dw 0
26AC DA 45     dw _l396
26AE 00 00     dw 0
26B0 03 00     dw 3
26B2 00 00     dw 0
26B4 00 00     dw 0
menu_uart_stop_bits:
26B6 D7 46     dw _l398
26B8 78 45     dw _l399
26BA 00 00     dw 0
26BC 00 00     dw 0
26BE 00 00     dw 0
26C0 7C 45     dw _l400
26C2 00 00     dw 0
26C4 01 00     dw 1
26C6 00 00     dw 0
26C8 94 45     dw _l401
26CA 00 00     dw 0
26CC 02 00     dw 2
26CE 00 00     dw 0
26D0 00 00     dw 0
menu_uart_parity:
26D2 1C 47     dw _l403
26D4 1D 48     dw _l404
26D6 00 00     dw 0
26D8 00 00     dw 0
26DA 00 00     dw 0
26DC FD 48     dw _l405
26DE 00 00     dw 0
26E0 01 00     dw 1
26E2 00 00     dw 0
26E4 11 48     dw _l406
26E6 00 00     dw 0
26E8 02 00     dw 2
26EA 00 00     dw 0
26EC 00 00     dw 0
menu_uart_flow:
26EE FB 46     dw _l408
26F0 1D 48     dw _l404
26F2 00 00     dw 0
26F4 00 00     dw 0
26F6 00 00     dw 0
26F8 0F 46     dw _l409
26FA 00 00     dw 0
26FC 01 00     dw 1
26FE 00 00     dw 0
2700 00 00     dw 0
menu_color:
2702 6F 47     dw _l411
2704 F4 48     dw _l412
2706 00 00     dw 0
2708 0F 00     dw PALETTE_BLACK
270A 00 00     dw 0
270C 92 48     dw _l413
270E 00 00     dw 0
2710 0E 00     dw PALETTE_DARK_RED
2712 00 00     dw 0
2714 82 48     dw _l414
2716 00 00     dw 0
2718 0D 00     dw PALETTE_DARK_GREEN
271A 00 00     dw 0
271C 73 48     dw _l415
271E 00 00     dw 0
2720 0C 00     dw PALETTE_DARK_YELLOW
2722 00 00     dw 0
2724 A2 48     dw _l416
2726 00 00     dw 0
2728 0B 00     dw PALETTE_DARK_BLUE
272A 00 00     dw 0
272C B0 48     dw _l417
272E 00 00     dw 0
2730 0A 00     dw PALETTE_DARK_MAGENTA
2732 00 00     dw 0
2734 63 48     dw _l418
2736 00 00     dw 0
2738 09 00     dw PALETTE_DARK_CYAN
273A 00 00     dw 0
273C 3D 48     dw _l419
273E 00 00     dw 0
2740 08 00     dw PALETTE_GRAY
2742 00 00     dw 0
2744 07 48     dw _l420
2746 00 00     dw 0
2748 06 00     dw PALETTE_RED
274A 00 00     dw 0
274C C5 47     dw _l421
274E 00 00     dw 0
2750 05 00     dw PALETTE_GREEN
2752 00 00     dw 0
2754 9D 47     dw _l422
2756 00 00     dw 0
2758 04 00     dw PALETTE_YELLOW
275A 00 00     dw 0
275C 45 48     dw _l423
275E 00 00     dw 0
2760 03 00     dw PALETTE_BLUE
2762 00 00     dw 0
2764 C3 48     dw _l424
2766 00 00     dw 0
2768 02 00     dw PALETTE_MAGENTA
276A 00 00     dw 0
276C 7F 47     dw _l425
276E 00 00     dw 0
2770 01 00     dw PALETTE_CYAN
2772 00 00     dw 0
2774 84 46     dw _l426
2776 00 00     dw 0
2778 00 00     dw PALETTE_WHITE
277A 00 00     dw 0
277C 00 00     dw 0
menu_root:
277E DD 47     dw _l428
2780 A6 47     dw _l429
2782 02 00     dw MIT_JUMP
2784 AE 28     dw StartCpm
2786 00 00     dw 0
2788 B4 47     dw _l430
278A 02 00     dw MIT_JUMP
278C 91 28     dw StartBasic
278E 00 00     dw 0
2790 6D 45     dw _l431
2792 00 00     dw 0
2794 00 00     dw 0
2796 00 00     dw 0
2798 FB 47     dw _l432
279A 01 00     dw MIT_SUBMENU
279C 4A 26     dw menu_code_page
279E 83 24     dw codepage
27A0 06 49     dw _l433
27A2 01 00     dw MIT_SUBMENU
27A4 0A 26     dw menu_screen
27A6 7C 24     dw screen_mode
27A8 D0 48     dw _l434
27AA 01 00     dw MIT_SUBMENU
27AC 02 27     dw menu_color
27AE 7D 24     dw color_0
27B0 D9 48     dw _l435
27B2 01 00     dw MIT_SUBMENU
27B4 02 27     dw menu_color
27B6 7E 24     dw color_1
27B8 E2 48     dw _l436
27BA 01 00     dw MIT_SUBMENU
27BC 02 27     dw menu_color
27BE 7F 24     dw color_2
27C0 EB 48     dw _l437
27C2 01 00     dw MIT_SUBMENU
27C4 02 27     dw menu_color
27C6 80 24     dw color_3
27C8 6D 45     dw _l431
27CA 00 00     dw 0
27CC 00 00     dw 0
27CE 00 00     dw 0
27D0 3B 46     dw _l438
27D2 01 00     dw MIT_SUBMENU
27D4 6E 26     dw menu_uart_baud_rate
27D6 84 24     dw uart_baud_rate
27D8 19 46     dw _l439
27DA 01 00     dw MIT_SUBMENU
27DC 92 26     dw menu_uart_data_bits
27DE 85 24     dw uart_data_bits
27E0 5C 46     dw _l440
27E2 01 00     dw MIT_SUBMENU
27E4 D2 26     dw menu_uart_parity
27E6 86 24     dw uart_parity
27E8 4B 46     dw _l441
27EA 01 00     dw MIT_SUBMENU
27EC B6 26     dw menu_uart_stop_bits
27EE 87 24     dw uart_stop_bits
27F0 2B 46     dw _l442
27F2 01 00     dw MIT_SUBMENU
27F4 EE 26     dw menu_uart_flow
27F6 88 24     dw uart_flow
27F8 6D 45     dw _l431
27FA 00 00     dw 0
27FC 00 00     dw 0
27FE 00 00     dw 0
2800 89 47     dw _l443
2802 01 00     dw MIT_SUBMENU
2804 2E 26     dw menu_drive
2806 81 24     dw drive_0
2808 93 47     dw _l444
280A 01 00     dw MIT_SUBMENU
280C 2E 26     dw menu_drive
280E 82 24     dw drive_1
2810 6D 45     dw _l431
2812 00 00     dw 0
2814 00 00     dw 0
2816 00 00     dw 0
2818 4D 48     dw _l445
281A 02 00     dw MIT_JUMP
281C F4 25     dw SaveConfig
281E 00 00     dw 0
2820 00 00     dw 0
main:
2822 31 00 01  ld sp, stack
2825 3E 00     ld a, 0*2
2827 D3 00     out (0), a
2829 3E 02     ld a, 1*2
282B D3 01     out (1), a
282D 3E 01     ld a, 1
282F D3 02     out (2), a
2831 3E 01     ld a, 1
2833 D3 03     out (3), a
2835 21 00 D0  ld hl, SCREEN_0_ADDRESS
2838 0E 0E     ld c, (config_check_sum-config_begin)+1
283A CD 1E 45  call ReadConfig
283D C2 61 28  jp nz, _l447
2840 21 00 D0  ld hl, SCREEN_0_ADDRESS
2843 0E 0E     ld c, (config_check_sum-config_begin)+1
2845 3E AA     ld a, 170
_l448:
2847 AE        xor (hl)
2848 23        inc hl
_l450:
2849 0D        dec c
284A C2 47 28  jp nz, _l448
_l449:
284D B7        or a
284E C2 61 28  jp nz, _l451
2851 21 7C 24  ld hl, config_begin
2854 11 00 D0  ld de, SCREEN_0_ADDRESS
2857 0E 0D     ld c, config_check_sum-config_begin
_l452:
2859 1A        ld a, (de)
285A 77        ld (hl), a
285B 23        inc hl
285C 13        inc de
_l454:
285D 0D        dec c
285E C2 59 28  jp nz, _l452
_l447:
_l453:
_l451:
2861 CD 3F 0B  call SetScreenColor6
2864 3E 03     ld a, 3
2866 CD D3 07  call SetColor
2869 CD 50 03  call ConReset
286C 3E 0B     ld a, PALETTE_DARK_BLUE
286E D3 90     out (144+(0&3)), a
2870 3E 04     ld a, PALETTE_YELLOW
2872 D3 91     out (144+(1&3)), a
2874 3E 00     ld a, PALETTE_WHITE
2876 D3 92     out (144+(2&3)), a
2878 3E 01     ld a, PALETTE_CYAN
287A D3 93     out (144+(3&3)), a
_l456:
287C 1E 00     ld e, 0
287E 21 7E 27  ld hl, menu_root
2881 CD AE 24  call Menu
2884 C3 7C 28  jp _l456
StartBasic4000:
_l455:
2887 3E 01     ld a, 1
2889 D3 00     out (0), a
288B AF        xor a
288C D3 A8     out (PORT_ROM_0000), a
288E C3 00 00  jp 0
StartBasic:
2891 F3        di
2892 3E 01     ld a, 1
2894 D3 01     out (1), a
2896 D3 02     out (2), a
2898 D3 03     out (3), a
289A 21 00 40  ld hl, 16384
289D 11 87 28  ld de, StartBasic4000
28A0 0E 0A     ld c, StartBasic-StartBasic4000
_l459:
28A2 1A        ld a, (de)
28A3 77        ld (hl), a
28A4 23        inc hl
28A5 13        inc de
_l461:
28A6 0D        dec c
28A7 C2 A2 28  jp nz, _l459
_l460:
28AA CD 00 40  call 16384
28AD C9        ret
StartCpm:
28AE 3A 83 24  ld a, (codepage)
28B1 CD 7B 06  call ConSetXlat
28B4 3A 7C 24  ld a, (screen_mode)
28B7 B7        or a
28B8 C2 C1 28  jp nz, _l463
28BB CD FA 0A  call SetScreenBw6
28BE C3 D8 28  jp _l464
_l463:
28C1 3D        dec a
28C2 C2 CB 28  jp nz, _l465
28C5 CD 3F 0B  call SetScreenColor6
28C8 C3 D8 28  jp _l466
_l465:
28CB 3D        dec a
28CC C2 D5 28  jp nz, _l467
28CF CD 76 20  call SetScreenBw4
28D2 C3 D8 28  jp _l468
_l467:
28D5 CD 98 20  call SetScreenColor4
_l466:
_l464:
_l468:
28D8 3E 03     ld a, 3
28DA CD D3 07  call SetColor
28DD CD D9 07  call ClearScreen
28E0 3A 7D 24  ld a, (color_0)
28E3 D3 90     out (144+(0&3)), a
28E5 3A 7E 24  ld a, (color_1)
28E8 D3 91     out (144+(1&3)), a
28EA 3A 7F 24  ld a, (color_2)
28ED D3 92     out (144+(2&3)), a
28EF 3A 80 24  ld a, (color_3)
28F2 D3 93     out (144+(3&3)), a
28F4 0E 00     ld c, 0
28F6 11 00 00  ld de, 0
28F9 21 CF 47  ld hl, _l469
28FC CD D6 08  call DrawText
28FF 3E 01     ld a, 1
2901 CD D3 07  call SetColor
2904 3E 01     ld a, 1
2906 32 01 01  ld (cursor_visible), a
CpmWBoot:
2909 3E 0E     ld a, 7*2
290B D3 03     out (3), a
290D 11 00 E5  ld de, cpm_load_address
2910 21 23 29  ld hl, cpm_start
_l471:
2913 7E        ld a, (hl)
2914 12        ld (de), a
2915 23        inc hl
2916 13        inc de
_l473:
2917 7A        ld a, d
2918 B7        or a
2919 C2 13 29  jp nz, _l471
_l472:
291C 3A 48 44  ld a, (drive_number)
291F 4F        ld c, a
2920 C3 33 FB  jp CpmEntryPoint
cpm_start:
2923 C3 5C E8  db 195
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
4423 00        db 0
MulU16:
4424 44        ld b, h
4425 4D        ld c, l
4426 21 00 00  ld hl, 0
4429 3E 11     ld a, 17
_l478:
442B 3D        dec a
442C C8        ret z
442D 29        add hl, hl
442E EB        ex hl, de
442F D2 37 44  jp nc, _l479
4432 29        add hl, hl
4433 23        inc hl
4434 C3 38 44  jp _l480
_l479:
4437 29        add hl, hl
_l480:
4438 EB        ex hl, de
4439 D2 2B 44  jp nc, _l478
443C 09        add hl, bc
443D D2 2B 44  jp nc, _l478
4440 13        inc de
4441 C3 2B 44  jp _l478
_l477:
4444          SCREEN_0_ADDRESS equ 53248
4444          SCREEN_1_ADDRESS equ 36864
4444          PALETTE_WHITE equ 0
4444          PALETTE_CYAN equ 1
4444          PALETTE_MAGENTA equ 2
4444          PALETTE_BLUE equ 3
4444          PALETTE_YELLOW equ 4
4444          PALETTE_GREEN equ 5
4444          PALETTE_RED equ 6
4444          PALETTE_XXX equ 7
4444          PALETTE_GRAY equ 8
4444          PALETTE_DARK_CYAN equ 9
4444          PALETTE_DARK_MAGENTA equ 10
4444          PALETTE_DARK_BLUE equ 11
4444          PALETTE_DARK_YELLOW equ 12
4444          PALETTE_DARK_GREEN equ 13
4444          PALETTE_DARK_RED equ 14
4444          PALETTE_BLACK equ 15
4444          KEY_BACKSPACE equ 8
4444          KEY_TAB equ 9
4444          KEY_ENTER equ 13
4444          KEY_ESC equ 27
4444          KEY_ALT equ 1
4444          KEY_F1 equ 242
4444          KEY_F2 equ 243
4444          KEY_F3 equ 244
4444          KEY_UP equ 245
4444          KEY_DOWN equ 246
4444          KEY_RIGHT equ 247
4444          KEY_LEFT equ 248
4444          KEY_EXT_5 equ 249
4444          KEY_END equ 250
4444          KEY_HOME equ 251
4444          KEY_INSERT equ 252
4444          KEY_DEL equ 253
4444          KEY_PG_UP equ 254
4444          KEY_PG_DN equ 255
4444          PORT_FRAME_IRQ_RESET equ 4
4444          PORT_SD_SIZE equ 9
4444          PORT_SD_RESULT equ 9
4444          PORT_SD_DATA equ 8
4444          PORT_UART_DATA equ 128
4444          PORT_UART_CONFIG equ 129
4444          PORT_UART_STATE equ 129
4444          PORT_EXT_DATA_OUT equ 136
4444          PORT_PALETTE_3 equ 144
4444          PORT_PALETTE_2 equ 145
4444          PORT_PALETTE_1 equ 146
4444          PORT_PALETTE_0 equ 147
4444          PORT_EXT_IN_DATA equ 137
4444          PORT_A0 equ 160
4444          PORT_ROM_0000 equ 168
4444          PORT_ROM_0000__ROM equ 0
4444          PORT_ROM_0000__RAM equ 128
4444          PORT_VIDEO_MODE_1_LOW equ 185
4444          PORT_VIDEO_MODE_1_HIGH equ 249
4444          PORT_VIDEO_MODE_0_LOW equ 184
4444          PORT_VIDEO_MODE_0_HIGH equ 248
4444          PORT_UART_SPEED_0 equ 187
4444          PORT_KEYBOARD equ 192
4444          PORT_UART_SPEED_1 equ 251
4444          PORT_CODE_ROM equ 186
4444          PORT_CHARGEN_ROM equ 250
4444          PORT_TAPE_AND_IDX2 equ 153
4444          PORT_TAPE_AND_IDX2_ID1_2 equ 2
4444          PORT_TAPE_AND_IDX2_ID2_2 equ 4
4444          PORT_TAPE_AND_IDX2_ID3_2 equ 8
4444          PORT_TAPE_AND_IDX2_ID6_2 equ 64
4444          PORT_TAPE_AND_IDX2_ID7_2 equ 128
4444          PORT_RESET_CU1 equ 188
4444          PORT_RESET_CU2 equ 189
4444          PORT_RESET_CU3 equ 190
4444          PORT_RESET_CU4 equ 191
4444          PORT_SET_CU1 equ 252
4444          PORT_SET_CU2 equ 253
4444          PORT_SET_CU3 equ 254
4444          PORT_SET_CU4 equ 255
4444          PORT_TAPE_OUT equ 176
4444          SD_COMMAND_READ equ 1
4444          SD_COMMAND_READ_SIZE equ 5
4444          SD_COMMAND_WRITE equ 2
4444          SD_COMMAND_WRITE_SIZE equ 5+128
4444          SD_RESULT_BUSY equ 255
4444          SD_RESULT_OK equ 0
4444          stack equ 256
4444          entry_cpm_conout_address equ EntryCpmConout+1
4444          cpm_dph_a equ 65376
4444          cpm_dph_b equ 65392
4444          cpm_dma_buffer equ 65408
CpmList:
4444 C9        ret
CpmPrSta:
4445 16 00     ld d, 0
4447 C9        ret
4448          SCREEN_0_ADDRESS equ 53248
4448          SCREEN_1_ADDRESS equ 36864
4448          PALETTE_WHITE equ 0
4448          PALETTE_CYAN equ 1
4448          PALETTE_MAGENTA equ 2
4448          PALETTE_BLUE equ 3
4448          PALETTE_YELLOW equ 4
4448          PALETTE_GREEN equ 5
4448          PALETTE_RED equ 6
4448          PALETTE_XXX equ 7
4448          PALETTE_GRAY equ 8
4448          PALETTE_DARK_CYAN equ 9
4448          PALETTE_DARK_MAGENTA equ 10
4448          PALETTE_DARK_BLUE equ 11
4448          PALETTE_DARK_YELLOW equ 12
4448          PALETTE_DARK_GREEN equ 13
4448          PALETTE_DARK_RED equ 14
4448          PALETTE_BLACK equ 15
4448          KEY_BACKSPACE equ 8
4448          KEY_TAB equ 9
4448          KEY_ENTER equ 13
4448          KEY_ESC equ 27
4448          KEY_ALT equ 1
4448          KEY_F1 equ 242
4448          KEY_F2 equ 243
4448          KEY_F3 equ 244
4448          KEY_UP equ 245
4448          KEY_DOWN equ 246
4448          KEY_RIGHT equ 247
4448          KEY_LEFT equ 248
4448          KEY_EXT_5 equ 249
4448          KEY_END equ 250
4448          KEY_HOME equ 251
4448          KEY_INSERT equ 252
4448          KEY_DEL equ 253
4448          KEY_PG_UP equ 254
4448          KEY_PG_DN equ 255
4448          PORT_FRAME_IRQ_RESET equ 4
4448          PORT_SD_SIZE equ 9
4448          PORT_SD_RESULT equ 9
4448          PORT_SD_DATA equ 8
4448          PORT_UART_DATA equ 128
4448          PORT_UART_CONFIG equ 129
4448          PORT_UART_STATE equ 129
4448          PORT_EXT_DATA_OUT equ 136
4448          PORT_PALETTE_3 equ 144
4448          PORT_PALETTE_2 equ 145
4448          PORT_PALETTE_1 equ 146
4448          PORT_PALETTE_0 equ 147
4448          PORT_EXT_IN_DATA equ 137
4448          PORT_A0 equ 160
4448          PORT_ROM_0000 equ 168
4448          PORT_ROM_0000__ROM equ 0
4448          PORT_ROM_0000__RAM equ 128
4448          PORT_VIDEO_MODE_1_LOW equ 185
4448          PORT_VIDEO_MODE_1_HIGH equ 249
4448          PORT_VIDEO_MODE_0_LOW equ 184
4448          PORT_VIDEO_MODE_0_HIGH equ 248
4448          PORT_UART_SPEED_0 equ 187
4448          PORT_KEYBOARD equ 192
4448          PORT_UART_SPEED_1 equ 251
4448          PORT_CODE_ROM equ 186
4448          PORT_CHARGEN_ROM equ 250
4448          PORT_TAPE_AND_IDX2 equ 153
4448          PORT_TAPE_AND_IDX2_ID1_2 equ 2
4448          PORT_TAPE_AND_IDX2_ID2_2 equ 4
4448          PORT_TAPE_AND_IDX2_ID3_2 equ 8
4448          PORT_TAPE_AND_IDX2_ID6_2 equ 64
4448          PORT_TAPE_AND_IDX2_ID7_2 equ 128
4448          PORT_RESET_CU1 equ 188
4448          PORT_RESET_CU2 equ 189
4448          PORT_RESET_CU3 equ 190
4448          PORT_RESET_CU4 equ 191
4448          PORT_SET_CU1 equ 252
4448          PORT_SET_CU2 equ 253
4448          PORT_SET_CU3 equ 254
4448          PORT_SET_CU4 equ 255
4448          PORT_TAPE_OUT equ 176
4448          SD_COMMAND_READ equ 1
4448          SD_COMMAND_READ_SIZE equ 5
4448          SD_COMMAND_WRITE equ 2
4448          SD_COMMAND_WRITE_SIZE equ 5+128
4448          SD_RESULT_BUSY equ 255
4448          SD_RESULT_OK equ 0
4448          stack equ 256
4448          entry_cpm_conout_address equ EntryCpmConout+1
4448          cpm_dph_a equ 65376
4448          cpm_dph_b equ 65392
4448          cpm_dma_buffer equ 65408
drive_number:
4448 00        db 0
drive_track:
4449 00 00     dw 0
drive_sector:
444B 00        db 0
drive_dpb:
444C 60 FF     dw cpm_dph_a
WaitSd:
_l488:
444E DB 09     in a, (PORT_SD_RESULT)
_l490:
4450 FE FF     cp SD_RESULT_BUSY
4452 CA 4E 44  jp z, _l488
_l489:
4455 C9        ret
CpmSelDsk:
4456 CD 4E 44  call WaitSd
4459 3E 05     ld a, SD_COMMAND_READ_SIZE
445B D3 09     out (PORT_SD_SIZE), a
445D 3E 01     ld a, SD_COMMAND_READ
445F D3 08     out (PORT_SD_DATA), a
4461 79        ld a, c
4462 3C        inc a
4463 3C        inc a
4464 D3 08     out (PORT_SD_DATA), a
4466 AF        xor a
4467 D3 08     out (PORT_SD_DATA), a
4469 D3 08     out (PORT_SD_DATA), a
446B D3 08     out (PORT_SD_DATA), a
446D D3 08     out (PORT_SD_DATA), a
446F CD 4E 44  call WaitSd
4472 B7        or a
4473 CA 78 44  jp z, _l492
4476 57        ld d, a
4477 C9        ret
_l492:
4478 79        ld a, c
4479 2A 6A FF  ld hl, (cpm_dph_a+10)
447C FE 01     cp 1
447E C2 84 44  jp nz, _l493
4481 2A 7A FF  ld hl, (cpm_dph_b+10)
_l493:
4484 32 48 44  ld (drive_number), a
4487 22 4C 44  ld (drive_dpb), hl
448A 06 0F     ld b, 15
_l494:
448C DB 08     in a, (PORT_SD_DATA)
448E 77        ld (hl), a
448F 23        inc hl
_l496:
4490 05        dec b
4491 C2 8C 44  jp nz, _l494
_l495:
4494 16 00     ld d, 0
4496 C9        ret
CpmSetTrk:
4497 60        ld h, b
4498 69        ld l, c
4499 22 49 44  ld (drive_track), hl
449C C9        ret
CpmSetSec:
449D 79        ld a, c
449E 32 4B 44  ld (drive_sector), a
44A1 C9        ret
ReadWriteSd:
44A2 CD 4E 44  call WaitSd
44A5 78        ld a, b
44A6 D3 09     out (PORT_SD_SIZE), a
44A8 79        ld a, c
44A9 D3 08     out (PORT_SD_DATA), a
44AB 3A 48 44  ld a, (drive_number)
44AE 3C        inc a
44AF 3C        inc a
44B0 D3 08     out (PORT_SD_DATA), a
44B2 2A 4C 44  ld hl, (drive_dpb)
44B5 5E        ld e, (hl)
44B6 23        inc hl
44B7 56        ld d, (hl)
44B8 2A 49 44  ld hl, (drive_track)
44BB CD 24 44  call MulU16
44BE 06 00     ld b, 0
44C0 3A 4B 44  ld a, (drive_sector)
44C3 4F        ld c, a
44C4 09        add hl, bc
44C5 D2 C9 44  jp nc, _l500
44C8 13        inc de
_l500:
44C9 7D        ld a, l
44CA D3 08     out (PORT_SD_DATA), a
44CC 7C        ld a, h
44CD D3 08     out (PORT_SD_DATA), a
44CF 7B        ld a, e
44D0 D3 08     out (PORT_SD_DATA), a
44D2 7A        ld a, d
44D3 D3 08     out (PORT_SD_DATA), a
44D5 C9        ret
CpmRead:
44D6 01 01 05  ld bc, SD_COMMAND_READ_SIZE<<8|SD_COMMAND_READ
44D9 CD A2 44  call ReadWriteSd
44DC CD 4E 44  call WaitSd
44DF B7        or a
44E0 CA E5 44  jp z, _l502
44E3 57        ld d, a
44E4 C9        ret
_l502:
44E5 21 80 FF  ld hl, cpm_dma_buffer
_l503:
44E8 DB 08     in a, (PORT_SD_DATA)
44EA 77        ld (hl), a
44EB 2C        inc l
_l505:
44EC C2 E8 44  jp nz, _l503
_l504:
44EF 16 00     ld d, 0
44F1 C9        ret
CpmWrite:
44F2 01 02 85  ld bc, SD_COMMAND_WRITE_SIZE<<8|SD_COMMAND_WRITE
44F5 CD A2 44  call ReadWriteSd
44F8 21 80 FF  ld hl, cpm_dma_buffer
_l507:
44FB 7E        ld a, (hl)
44FC D3 08     out (PORT_SD_DATA), a
44FE 2C        inc l
_l509:
44FF C2 FB 44  jp nz, _l507
_l508:
4502 CD 4E 44  call WaitSd
4505 57        ld d, a
4506 C9        ret
ReadWriteConfig:
4507 CD 4E 44  call WaitSd
450A 78        ld a, b
450B D3 09     out (PORT_SD_SIZE), a
450D 79        ld a, c
450E D3 08     out (PORT_SD_DATA), a
4510 3E 01     ld a, 1
4512 D3 08     out (PORT_SD_DATA), a
4514 AF        xor a
4515 D3 08     out (PORT_SD_DATA), a
4517 D3 08     out (PORT_SD_DATA), a
4519 D3 08     out (PORT_SD_DATA), a
451B D3 08     out (PORT_SD_DATA), a
451D C9        ret
ReadConfig:
451E 3E 80     ld a, 128
4520 91        sub c
4521 47        ld b, a
4522 D2 28 45  jp nc, _l512
4525 3E 01     ld a, 1
4527 C9        ret
_l512:
4528 E5        push hl
4529 C5        push bc
452A 01 01 05  ld bc, SD_COMMAND_READ_SIZE<<8|SD_COMMAND_READ
452D CD 07 45  call ReadWriteConfig
4530 CD 4E 44  call WaitSd
4533 C1        pop bc
4534 E1        pop hl
4535 B7        or a
4536 C0        ret nz
_l513:
4537 DB 08     in a, (PORT_SD_DATA)
4539 77        ld (hl), a
453A 23        inc hl
_l515:
453B 0D        dec c
453C C2 37 45  jp nz, _l513
_l516:
_l514:
453F DB 08     in a, (PORT_SD_DATA)
_l518:
4541 05        dec b
4542 C2 3F 45  jp nz, _l516
_l517:
4545 AF        xor a
4546 C9        ret
WriteConfig:
4547 3E 80     ld a, 128
4549 91        sub c
454A 47        ld b, a
454B E5        push hl
454C C5        push bc
454D 01 02 85  ld bc, SD_COMMAND_WRITE_SIZE<<8|SD_COMMAND_WRITE
4550 CD 07 45  call ReadWriteConfig
4553 C1        pop bc
4554 E1        pop hl
_l520:
4555 7E        ld a, (hl)
4556 D3 08     out (PORT_SD_DATA), a
4558 23        inc hl
_l522:
4559 0D        dec c
455A C2 55 45  jp nz, _l520
_l521:
455D AF        xor a
_l523:
455E D3 08     out (PORT_SD_DATA), a
_l525:
4560 05        dec b
4561 C2 5E 45  jp nz, _l523
_l524:
4564 CD 4E 44  call WaitSd
4567 B7        or a
4568 C9        ret
4569          SCREEN_0_ADDRESS equ 53248
4569          SCREEN_1_ADDRESS equ 36864
4569          PALETTE_WHITE equ 0
4569          PALETTE_CYAN equ 1
4569          PALETTE_MAGENTA equ 2
4569          PALETTE_BLUE equ 3
4569          PALETTE_YELLOW equ 4
4569          PALETTE_GREEN equ 5
4569          PALETTE_RED equ 6
4569          PALETTE_XXX equ 7
4569          PALETTE_GRAY equ 8
4569          PALETTE_DARK_CYAN equ 9
4569          PALETTE_DARK_MAGENTA equ 10
4569          PALETTE_DARK_BLUE equ 11
4569          PALETTE_DARK_YELLOW equ 12
4569          PALETTE_DARK_GREEN equ 13
4569          PALETTE_DARK_RED equ 14
4569          PALETTE_BLACK equ 15
4569          KEY_BACKSPACE equ 8
4569          KEY_TAB equ 9
4569          KEY_ENTER equ 13
4569          KEY_ESC equ 27
4569          KEY_ALT equ 1
4569          KEY_F1 equ 242
4569          KEY_F2 equ 243
4569          KEY_F3 equ 244
4569          KEY_UP equ 245
4569          KEY_DOWN equ 246
4569          KEY_RIGHT equ 247
4569          KEY_LEFT equ 248
4569          KEY_EXT_5 equ 249
4569          KEY_END equ 250
4569          KEY_HOME equ 251
4569          KEY_INSERT equ 252
4569          KEY_DEL equ 253
4569          KEY_PG_UP equ 254
4569          KEY_PG_DN equ 255
4569          PORT_FRAME_IRQ_RESET equ 4
4569          PORT_SD_SIZE equ 9
4569          PORT_SD_RESULT equ 9
4569          PORT_SD_DATA equ 8
4569          PORT_UART_DATA equ 128
4569          PORT_UART_CONFIG equ 129
4569          PORT_UART_STATE equ 129
4569          PORT_EXT_DATA_OUT equ 136
4569          PORT_PALETTE_3 equ 144
4569          PORT_PALETTE_2 equ 145
4569          PORT_PALETTE_1 equ 146
4569          PORT_PALETTE_0 equ 147
4569          PORT_EXT_IN_DATA equ 137
4569          PORT_A0 equ 160
4569          PORT_ROM_0000 equ 168
4569          PORT_ROM_0000__ROM equ 0
4569          PORT_ROM_0000__RAM equ 128
4569          PORT_VIDEO_MODE_1_LOW equ 185
4569          PORT_VIDEO_MODE_1_HIGH equ 249
4569          PORT_VIDEO_MODE_0_LOW equ 184
4569          PORT_VIDEO_MODE_0_HIGH equ 248
4569          PORT_UART_SPEED_0 equ 187
4569          PORT_KEYBOARD equ 192
4569          PORT_UART_SPEED_1 equ 251
4569          PORT_CODE_ROM equ 186
4569          PORT_CHARGEN_ROM equ 250
4569          PORT_TAPE_AND_IDX2 equ 153
4569          PORT_TAPE_AND_IDX2_ID1_2 equ 2
4569          PORT_TAPE_AND_IDX2_ID2_2 equ 4
4569          PORT_TAPE_AND_IDX2_ID3_2 equ 8
4569          PORT_TAPE_AND_IDX2_ID6_2 equ 64
4569          PORT_TAPE_AND_IDX2_ID7_2 equ 128
4569          PORT_RESET_CU1 equ 188
4569          PORT_RESET_CU2 equ 189
4569          PORT_RESET_CU3 equ 190
4569          PORT_RESET_CU4 equ 191
4569          PORT_SET_CU1 equ 252
4569          PORT_SET_CU2 equ 253
4569          PORT_SET_CU3 equ 254
4569          PORT_SET_CU4 equ 255
4569          PORT_TAPE_OUT equ 176
4569          SD_COMMAND_READ equ 1
4569          SD_COMMAND_READ_SIZE equ 5
4569          SD_COMMAND_WRITE equ 2
4569          SD_COMMAND_WRITE_SIZE equ 5+128
4569          SD_RESULT_BUSY equ 255
4569          SD_RESULT_OK equ 0
4569          stack equ 256
4569          entry_cpm_conout_address equ EntryCpmConout+1
4569          cpm_dph_a equ 65376
4569          cpm_dph_b equ 65392
4569          cpm_dma_buffer equ 65408
CpmPunch:
4569 C9        ret
CpmReader:
456A 16 00     ld d, 0
456C C9        ret
456D          ; Const strings
_l431:
456D 00 2C 00  db 0
 db 44
 db 0
_l347:
4570 10 00 29  db 16
 db 0
 db 41
 db 0
_l363:
4574 20 00 29  db 32
 db 0
 db 41
 db 0
_l399:
4578 31 00 2C  db 49
 db 0
 db 44
 db 0
_l400:
457C 31 2E 35  db 49
 db 46
 db 53
 db 0
 db 44
 db 0
_l387:
4582 31 32 30  db 49
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
_l382:
458D 31 32 35  db 49
 db 50
 db 53
 db 49
 db 0
 db 44
 db 0
_l401:
4594 32 00 2C  db 50
 db 0
 db 44
 db 0
_l388:
4598 32 34 30  db 50
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
_l389:
45A3 34 38 30  db 52
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
_l393:
45AE 35 00 2C  db 53
 db 0
 db 44
 db 0
_l394:
45B2 36 00 2C  db 54
 db 0
 db 44
 db 0
_l370:
45B6 36 34 78  db 54
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
_l371:
45C6 36 34 78  db 54
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
_l395:
45D6 37 00 2C  db 55
 db 0
 db 44
 db 0
_l396:
45DA 38 00 2C  db 56
 db 0
 db 44
 db 0
_l381:
45DE 38 36 36  db 56
 db 54
 db 54
 db 0
 db 44
 db 0
_l390:
45E4 39 36 30  db 57
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
_l372:
45EF 39 36 78  db 57
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
_l373:
45FF 39 36 78  db 57
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
_l409:
460F 43 54 53  db 67
 db 84
 db 83
 db 47
 db 82
 db 84
 db 83
 db 0
 db 44
 db 0
_l439:
4619 55 41 52  db 85
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
_l442:
462B 55 41 52  db 85
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
_l438:
463B 55 41 52  db 85
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
_l441:
464B 55 41 52  db 85
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
_l440:
465C 55 41 52  db 85
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
_l378:
466C 55 53 42  db 85
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
_l426:
4684 81 A5 AB  db 129
 db 165
 db 171
 db 235
 db 169
 db 0
 db 44
 db 0
_l375:
468C 82 EB A1  db 130
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
_l380:
46A0 82 EB A1  db 130
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
_l392:
46B5 82 EB A1  db 130
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
_l398:
46D7 82 EB A1  db 130
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
_l408:
46FB 82 EB A1  db 130
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
_l403:
471C 82 EB A1  db 130
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
_l369:
473E 82 EB A1  db 130
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
_l386:
4756 82 EB A1  db 130
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
_l411:
476F 82 EB A1  db 130
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
_l425:
477F 83 AE AB  db 131
 db 174
 db 171
 db 227
 db 161
 db 174
 db 169
 db 0
 db 44
 db 0
_l443:
4789 84 A8 E1  db 132
 db 168
 db 225
 db 170
 db 32
 db 65
 db 58
 db 0
 db 44
 db 0
_l444:
4793 84 A8 E1  db 132
 db 168
 db 225
 db 170
 db 32
 db 66
 db 58
 db 0
 db 44
 db 0
_l422:
479D 86 F1 AB  db 134
 db 241
 db 171
 db 226
 db 235
 db 169
 db 0
 db 44
 db 0
_l429:
47A6 87 A0 AF  db 135
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
_l430:
47B4 87 A0 AF  db 135
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
_l421:
47C5 87 A5 AB  db 135
 db 165
 db 171
 db 165
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l469:
47CF 88 E1 AA  db 136
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
_l428:
47DD 88 E1 AA  db 136
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
_l383:
47EB 8A 8E 88  db 138
 db 142
 db 136
 db 45
 db 55
 db 0
 db 44
 db 0
_l384:
47F3 8A 8E 88  db 138
 db 142
 db 136
 db 45
 db 56
 db 0
 db 44
 db 0
_l432:
47FB 8A AE A4  db 138
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
_l420:
4807 8A E0 A0  db 138
 db 224
 db 160
 db 225
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l406:
4811 8D A5 20  db 141
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
_l404:
481D 8D A5 E2  db 141
 db 165
 db 226
 db 0
 db 44
 db 0
_l376:
4823 90 A5 A0  db 144
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
_l377:
4830 90 A5 A0  db 144
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
_l419:
483D 91 A5 E0  db 145
 db 165
 db 224
 db 235
 db 169
 db 0
 db 44
 db 0
_l423:
4845 91 A8 AD  db 145
 db 168
 db 173
 db 168
 db 169
 db 0
 db 44
 db 0
_l445:
484D 91 AE E5  db 145
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
_l418:
4863 92 A5 AC  db 146
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
_l415:
4873 92 F1 AC  db 146
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
_l414:
4882 92 F1 AC  db 146
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
_l413:
4892 92 F1 AC  db 146
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
_l416:
48A2 92 F1 AC  db 146
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
_l417:
48B0 92 F1 AC  db 146
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
_l424:
48C3 94 A8 AE  db 148
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
_l434:
48D0 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 48
 db 0
 db 44
 db 0
_l435:
48D9 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 49
 db 0
 db 44
 db 0
_l436:
48E2 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 50
 db 0
 db 44
 db 0
_l437:
48EB 96 A2 A5  db 150
 db 162
 db 165
 db 226
 db 32
 db 51
 db 0
 db 44
 db 0
_l412:
48F4 97 F1 E0  db 151
 db 241
 db 224
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l405:
48FD 97 F1 E2  db 151
 db 241
 db 226
 db 173
 db 235
 db 169
 db 0
 db 44
 db 0
_l433:
4906 9D AA E0  db 157
 db 170
 db 224
 db 160
 db 173
 db 0
 db 44
 db 0
490E 00 00 00  align 128
file_end:
4980 00 00 00  savebin "boot.cpm", 0, $
