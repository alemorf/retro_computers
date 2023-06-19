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
0000 C3 7A 20  jp main
sector_count:
0003 7A 00     dw (file_end+127)/128
CpmInterrupt:
0005 C3 E9 1F  jp InterruptHandler
EntryCpmWBoot:
0008 C3 C0 20  jp CpmWBoot
EntryCpmConst:
000B C3 43 03  jp CpmConst
EntryCpmConin:
000E C3 4B 03  jp CpmConin
EntryCpmConout:
0011 C3 BE 02  jp CpmConout
EntryCpmList:
0014 C3 FB 3B  jp CpmList
EntryCpmPunch:
0017 C3 BC 3C  jp CpmPunch
EntryCpmReader:
001A C3 BD 3C  jp CpmReader
EntryCpmSelDsk:
001D C3 0D 3C  jp CpmSelDsk
EntryCpmSetTrk:
0020 C3 4D 3C  jp CpmSetTrk
EntryCpmSetSec:
0023 C3 53 3C  jp CpmSetSec
EntryCpmRead:
0026 C3 8B 3C  jp CpmRead
EntryCpmWrite:
0029 C3 A7 3C  jp CpmWrite
EntryCpmPrSta:
002C C3 FC 3B  jp CpmPrSta
002F 00 00 00  org 56
EntryInterrupt:
0038 F5        push af
0039 C5        push bc
003A D5        push de
003B E5        push hl
003C CD E9 1F  call InterruptHandler
003F E1        pop hl
0040 D1        pop de
0041 C1        pop bc
0042 F1        pop af
0043 FB        ei
0044 C9        ret
key_buffer:
0045 00 00 00  ds 64
0085 00 00 00  org 256
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
esc_param:
0105 00        ds 1
esc_param_2:
0106 00        ds 1
esc_param_ptr:
0107 00 00     ds 2
BeginConsoleChange:
0109 3E 01     ld a, 1
010B D3 02     out (2), a
010D D3 03     out (3), a
010F 21 01 01  ld hl, cursor_visible
0112 F3        di
0113 7E        ld a, (hl)
0114 36 00     ld (hl), 0
0116 FB        ei
0117 FE 03     cp 3
0119 C2 24 01  jp nz, _l30
011C 2A 03 01  ld hl, (cursor_y)
011F CD 85 03  call DrawCursor
0122 3E 01     ld a, 1
_l30:
0124 32 02 01  ld (cursor_visible_1), a
0127 C9        ret
EndConsoleChange:
0128 3E 02     ld a, 2
012A 32 00 01  ld (cursor_blink_counter), a
012D 3A 02 01  ld a, (cursor_visible_1)
0130 32 01 01  ld (cursor_visible), a
0133 3E 0C     ld a, 6*2
0135 D3 02     out (2), a
0137 3E 0E     ld a, 7*2
0139 D3 03     out (3), a
013B C9        ret
ConClear:
ConReset:
013C AF        xor a
013D 32 01 01  ld (cursor_visible), a
0140 32 04 01  ld (cursor_x), a
0143 32 03 01  ld (cursor_y), a
0146 CD 88 03  call ClearScreen
0149 C9        ret
ConNextLine:
014A AF        xor a
014B 32 04 01  ld (cursor_x), a
014E 3A 03 01  ld a, (cursor_y)
0151 3C        inc a
0152 FE 19     cp TEXT_SCREEN_HEIGHT
0154 D2 5B 01  jp nc, _l35
0157 32 03 01  ld (cursor_y), a
015A C9        ret
_l35:
015B CD 2E 04  call ScrollUp
015E C9        ret
ConPrintChar:
015F 2A 03 01  ld hl, (cursor_y)
0162 CD 7F 03  call DrawChar
0165 2A 7E 03  ld hl, (text_screen_width)
0168 3A 04 01  ld a, (cursor_x)
016B 3C        inc a
016C BD        cp l
016D D2 74 01  jp nc, _l37
0170 32 04 01  ld (cursor_x), a
0173 C9        ret
_l37:
0174 C3 4A 01  jp ConNextLine
ConEraseInLine:
0177 C9        ret
0178 2A 03 01  ld hl, (cursor_y)
_l40:
017B E5        push hl
017C 7C        ld a, h
017D E6 03     and 3
017F 4F        ld c, a
0180 7C        ld a, h
0181 0F 0F     rrca
 rrca
0183 E6 3F     and 63
0185 2F        cpl
0186 67        ld h, a
0187 EB        ex hl, de
0188 AF        xor a
0189 CD 7F 03  call DrawChar
018C E1        pop hl
018D 7C        ld a, h
018E C6 03     add FONT_WIDTH
0190 67        ld h, a
0191 C3 7B 01  jp _l40
_l39:
CpmConoutCsi2:
0194 79        ld a, c
0195 FE 30     cp 48
0197 DA AE 01  jp c, _l42
019A FE 3A     cp 57+1
019C D2 AE 01  jp nc, _l43
019F D6 30     sub 48
01A1 4F        ld c, a
01A2 2A 07 01  ld hl, (esc_param_ptr)
01A5 7E        ld a, (hl)
01A6 87        add a
01A7 47        ld b, a
01A8 87        add a
01A9 87        add a
01AA 80        add b
01AB 81        add c
01AC 77        ld (hl), a
01AD C9        ret
_l42:
_l43:
01AE FE 3B     cp 59
01B0 C2 BA 01  jp nz, _l44
01B3 21 06 01  ld hl, esc_param_2
01B6 22 07 01  ld (esc_param_ptr), hl
01B9 C9        ret
_l44:
01BA 21 BE 02  ld hl, CpmConout
01BD 22 12 00  ld (entry_cpm_conout_address), hl
01C0 FE 48     cp 72
01C2 C2 E0 01  jp nz, _l45
01C5 3A 05 01  ld a, (esc_param)
01C8 FE 19     cp TEXT_SCREEN_HEIGHT
01CA DA CE 01  jp c, _l46
01CD AF        xor a
_l46:
01CE 32 03 01  ld (cursor_y), a
01D1 2A 7E 03  ld hl, (text_screen_width)
01D4 3A 06 01  ld a, (esc_param_2)
01D7 BD        cp l
01D8 DA DC 01  jp c, _l47
01DB AF        xor a
_l47:
01DC 32 04 01  ld (cursor_x), a
01DF C9        ret
_l45:
01E0 FE 4A     cp 74
01E2 C2 F1 01  jp nz, _l48
01E5 3A 05 01  ld a, (esc_param)
01E8 FE 02     cp 2
01EA C2 F0 01  jp nz, _l49
01ED CD 88 03  call ClearScreen
_l49:
01F0 C9        ret
_l48:
01F1 FE 4B     cp 75
01F3 C2 02 02  jp nz, _l50
01F6 3A 05 01  ld a, (esc_param)
01F9 B7        or a
01FA C2 01 02  jp nz, _l51
01FD CD 77 01  call ConEraseInLine
0200 C9        ret
_l51:
0201 C9        ret
_l50:
0202 FE 6D     cp 109
0204 C2 20 02  jp nz, _l52
0207 3A 05 01  ld a, (esc_param)
020A FE 00     cp 0
020C 3E 01     ld a, 1
020E CA 82 03  jp z, SetColor
0211 3A 05 01  ld a, (esc_param)
0214 FE 07     cp 7
0216 3E 04     ld a, 4
0218 CA 82 03  jp z, SetColor
021B 3E 03     ld a, 3
021D C3 82 03  jp SetColor
_l52:
0220 C9        ret
CpmConoutCsi:
0221 C5        push bc
0222 CD 09 01  call BeginConsoleChange
0225 C1        pop bc
0226 CD 94 01  call CpmConoutCsi2
0229 CD 28 01  call EndConsoleChange
022C C9        ret
CpmConoutEscY1:
022D 79        ld a, c
022E D6 20     sub 32
0230 2A 7E 03  ld hl, (text_screen_width)
0233 BD        cp l
0234 DA 38 02  jp c, _l55
0237 AF        xor a
_l55:
0238 F5        push af
0239 CD 09 01  call BeginConsoleChange
023C F1        pop af
023D 32 04 01  ld (cursor_x), a
0240 3A 05 01  ld a, (esc_param)
0243 32 03 01  ld (cursor_y), a
0246 CD 28 01  call EndConsoleChange
0249 21 BE 02  ld hl, CpmConout
024C 22 12 00  ld (entry_cpm_conout_address), hl
024F C9        ret
CpmConoutEscY:
0250 79        ld a, c
0251 D6 20     sub 32
0253 FE 19     cp TEXT_SCREEN_HEIGHT
0255 DA 59 02  jp c, _l57
0258 AF        xor a
_l57:
0259 32 05 01  ld (esc_param), a
025C 21 2D 02  ld hl, CpmConoutEscY1
025F 22 12 00  ld (entry_cpm_conout_address), hl
0262 C9        ret
CpmConoutEsc:
0263 21 BE 02  ld hl, CpmConout
0266 79        ld a, c
0267 FE 5B     cp 91
0269 C2 7F 02  jp nz, _l59
026C AF        xor a
026D 32 05 01  ld (esc_param), a
0270 32 06 01  ld (esc_param_2), a
0273 21 05 01  ld hl, esc_param
0276 22 07 01  ld (esc_param_ptr), hl
0279 21 21 02  ld hl, CpmConoutCsi
027C C3 BA 02  jp _l60
_l59:
027F FE 4B     cp 75
0281 C2 8D 02  jp nz, _l61
0284 CD 77 01  call ConEraseInLine
0287 21 BE 02  ld hl, CpmConout
028A C3 BA 02  jp _l62
_l61:
028D FE 59     cp 89
028F C2 98 02  jp nz, _l63
0292 21 50 02  ld hl, CpmConoutEscY
0295 C3 BA 02  jp _l64
_l63:
0298 FE 3D     cp 61
029A C2 A3 02  jp nz, _l65
029D 21 50 02  ld hl, CpmConoutEscY
02A0 C3 BA 02  jp _l66
_l65:
02A3 FE 3B     cp 59
02A5 C2 BA 02  jp nz, _l67
02A8 CD 09 01  call BeginConsoleChange
02AB CD 88 03  call ClearScreen
02AE 21 00 00  ld hl, 0
02B1 22 03 01  ld (cursor_y), hl
02B4 CD 28 01  call EndConsoleChange
02B7 21 BE 02  ld hl, CpmConout
_l60:
_l66:
_l62:
_l67:
_l64:
02BA 22 12 00  ld (entry_cpm_conout_address), hl
02BD C9        ret
CpmConout:
02BE 79        ld a, c
02BF FE 1B     cp 27
02C1 C2 CB 02  jp nz, _l69
02C4 21 63 02  ld hl, CpmConoutEsc
02C7 22 12 00  ld (entry_cpm_conout_address), hl
02CA C9        ret
_l69:
02CB F5        push af
02CC CD 09 01  call BeginConsoleChange
02CF F1        pop af
02D0 FE 1C     cp 28
02D2 DA DB 02  jp c, _l70
02D5 CD 5F 01  call ConPrintChar
02D8 C3 40 03  jp _l71
_l70:
02DB FE 07     cp 7
02DD C2 E3 02  jp nz, _l72
02E0 C3 40 03  jp _l73
_l72:
02E3 FE 08     cp 8
02E5 C2 08 03  jp nz, _l74
02E8 3A 04 01  ld a, (cursor_x)
02EB 3D        dec a
02EC FA F5 02  jp m, _l75
02EF 32 04 01  ld (cursor_x), a
02F2 C3 05 03  jp _l76
_l75:
02F5 3A 03 01  ld a, (cursor_y)
02F8 3D        dec a
02F9 FA 05 03  jp m, _l77
02FC 32 03 01  ld (cursor_y), a
02FF 3A 7E 03  ld a, (text_screen_width)
0302 32 04 01  ld (cursor_x), a
_l77:
_l76:
0305 C3 40 03  jp _l78
_l74:
0308 FE 0A     cp 10
030A C2 10 03  jp nz, _l79
030D C3 40 03  jp _l80
_l79:
0310 FE 0C     cp 12
0312 C2 21 03  jp nz, _l81
0315 CD 88 03  call ClearScreen
0318 21 00 00  ld hl, 0
031B 22 03 01  ld (cursor_y), hl
031E C3 40 03  jp _l82
_l81:
0321 FE 1A     cp 26
0323 C2 32 03  jp nz, _l83
0326 CD 88 03  call ClearScreen
0329 21 00 00  ld hl, 0
032C 22 03 01  ld (cursor_y), hl
032F C3 40 03  jp _l84
_l83:
0332 FE 0D     cp 13
0334 C2 3D 03  jp nz, _l85
0337 CD 4A 01  call ConNextLine
033A C3 40 03  jp _l86
_l85:
033D CD 5F 01  call ConPrintChar
_l78:
_l71:
_l80:
_l82:
_l84:
_l73:
_l86:
0340 C3 28 01  jp EndConsoleChange
CpmConst:
0343 CD A0 1E  call CheckKeyboard
0346 16 00     ld d, 0
0348 C8        ret z
0349 15        dec d
034A C9        ret
_l89:
CpmConin:
034B CD A6 1E  call ReadKeyboard
_l91:
034E CA 4B 03  jp z, _l89
_l90:
0351 FE F2     cp KEY_F1
0353 C2 65 03  jp nz, _l92
0356 CD 09 01  call BeginConsoleChange
0359 CD C8 06  call SetScreenBw
035C CD 3C 01  call ConClear
035F CD 28 01  call EndConsoleChange
0362 C3 4B 03  jp CpmConin
_l92:
0365 FE F3     cp KEY_F2
0367 C2 7C 03  jp nz, _l93
036A CD 09 01  call BeginConsoleChange
036D CD 3C 01  call ConClear
0370 CD 0D 07  call SetScreenColor
0373 CD 3C 01  call ConClear
0376 CD 28 01  call EndConsoleChange
0379 C3 4B 03  jp CpmConin
_l93:
037C 57        ld d, a
037D C9        ret
037E          PALETTE_WHITE equ 0
037E          PALETTE_CYAN equ 1
037E          PALETTE_MAGENTA equ 2
037E          PALETTE_BLUE equ 3
037E          PALETTE_YELLOW equ 4
037E          PALETTE_GREEN equ 5
037E          PALETTE_RED equ 6
037E          PALETTE_XXX equ 7
037E          PALETTE_GRAY equ 8
037E          PALETTE_DARK_CYAN equ 9
037E          PALETTE_DARK_MAGENTA equ 10
037E          PALETTE_DARK_BLUE equ 11
037E          PALETTE_DARK_YELLOW equ 12
037E          PALETTE_DARK_GREEN equ 13
037E          PALETTE_DARK_RED equ 14
037E          PALETTE_BLACK equ 15
037E          KEY_BACKSPACE equ 8
037E          KEY_TAB equ 9
037E          KEY_ENTER equ 13
037E          KEY_ESC equ 27
037E          KEY_ALT equ 1
037E          KEY_F1 equ 242
037E          KEY_F2 equ 243
037E          KEY_F3 equ 244
037E          KEY_UP equ 245
037E          KEY_DOWN equ 246
037E          KEY_RIGHT equ 247
037E          KEY_LEFT equ 248
037E          KEY_EXT_5 equ 249
037E          KEY_END equ 250
037E          KEY_HOME equ 251
037E          KEY_INSERT equ 252
037E          KEY_DEL equ 253
037E          KEY_PG_UP equ 254
037E          KEY_PG_DN equ 255
037E          PORT_FRAME_IRQ_RESET equ 4
037E          PORT_SD_SIZE equ 9
037E          PORT_SD_RESULT equ 9
037E          PORT_SD_DATA equ 8
037E          PORT_UART_DATA equ 128
037E          PORT_UART_CONFIG equ 129
037E          PORT_UART_STATE equ 129
037E          PORT_EXT_DATA_OUT equ 136
037E          PORT_PALETTE_3 equ 144
037E          PORT_PALETTE_2 equ 145
037E          PORT_PALETTE_1 equ 146
037E          PORT_PALETTE_0 equ 147
037E          PORT_EXT_IN_DATA equ 137
037E          PORT_A0 equ 160
037E          PORT_ROM_0000 equ 168
037E          PORT_ROM_0000__ROM equ 0
037E          PORT_ROM_0000__RAM equ 128
037E          PORT_VIDEO_MODE_1_LOW equ 185
037E          PORT_VIDEO_MODE_1_HIGH equ 249
037E          PORT_VIDEO_MODE_0_LOW equ 184
037E          PORT_VIDEO_MODE_0_HIGH equ 248
037E          PORT_UART_SPEED_0 equ 187
037E          PORT_KEYBOARD equ 192
037E          PORT_UART_SPEED_1 equ 251
037E          PORT_CODE_ROM equ 186
037E          PORT_CHARGEN_ROM equ 250
037E          PORT_TAPE_AND_IDX2 equ 153
037E          PORT_TAPE_AND_IDX2_ID1_2 equ 2
037E          PORT_TAPE_AND_IDX2_ID2_2 equ 4
037E          PORT_TAPE_AND_IDX2_ID3_2 equ 8
037E          PORT_TAPE_AND_IDX2_ID6_2 equ 64
037E          PORT_TAPE_AND_IDX2_ID7_2 equ 128
037E          PORT_RESET_CU1 equ 188
037E          PORT_RESET_CU2 equ 189
037E          PORT_RESET_CU3 equ 190
037E          PORT_RESET_CU4 equ 191
037E          PORT_SET_CU1 equ 252
037E          PORT_SET_CU2 equ 253
037E          PORT_SET_CU3 equ 254
037E          PORT_SET_CU4 equ 255
037E          PORT_TAPE_OUT equ 176
037E          SD_COMMAND_READ equ 1
037E          SD_COMMAND_READ_SIZE equ 5
037E          SD_COMMAND_WRITE equ 2
037E          SD_COMMAND_WRITE_SIZE equ 5+128
037E          SD_RESULT_BUSY equ 255
037E          SD_RESULT_OK equ 0
037E          TEXT_SCREEN_HEIGHT equ 25
037E          FONT_HEIGHT equ 10
037E          FONT_WIDTH equ 3
037E          DrawCharAddress equ DrawChar+1
037E          SetColorAddress equ SetColor+1
037E          DrawCursorAddress equ DrawCursor+1
037E          OPCODE_NOP equ 0
037E          OPCODE_LD_DE_CONST equ 17
037E          OPCODE_LD_A_CONST equ 62
037E          OPCODE_LD_H_A equ 103
037E          OPCODE_LD_A_D equ 122
037E          OPCODE_LD_A_H equ 124
037E          OPCODE_XOR_B equ 168
037E          OPCODE_JP equ 195
037E          OPCODE_RET equ 201
037E          OPCODE_SUB_CONST equ 214
037E          OPCODE_AND_CONST equ 230
037E          OPCODE_OR_CONST equ 246
text_screen_width:
037E 60        db 96
037F          ClearScreen_2 equ ClearScreen_1+1
037F          ClearScreen_3 equ ClearScreen_1+2
037F          ClearScreen_4 equ ClearScreenPoly3+1
037F          ClearScreenSp equ ClearScreenSetSp+1
037F          ScrollUpAddr equ ScrollUp+1
037F          ScrollUpSp equ ScrollUpSpInstr+1
037F          ScrollUpSp2 equ ScrollUpSpInstr2+1
037F          ScrollUpBwSp equ ScrollUpBwSpInstr+1
037F          ScrollUp_1 equ ScrollUpSub+1
037F          ScrollUp_2 equ ScrollUp_2
037F          ScrollUp_3 equ ScrollUp_2+1
037F          ScrollUpSpInstr2 equ ScrollUpSpInstr2
DrawChar:
037F C3 95 04  jp DrawChar6
SetColor:
0382 C3 91 05  jp SetColor6
DrawCursor:
0385 C3 66 06  jp DrawCursor6
ClearScreen:
0388 21 00 00  ld hl, 0
038B 39        add hl, sp
038C 22 BB 03  ld (ClearScreenSp), hl
038F 11 00 00  ld de, 0
0392 0E 30     ld c, 48
0394 21 00 00  ld hl, 0
_l105:
0397 06 10     ld b, 16
0399 F3        di
039A F9        ld sp, hl
_l108:
039B D5        push de
039C D5        push de
039D D5        push de
039E D5        push de
039F D5        push de
03A0 D5        push de
03A1 D5        push de
03A2 D5        push de
_l110:
03A3 05        dec b
03A4 C2 9B 03  jp nz, _l108
_l109:
03A7 7C        ld a, h
ClearScreen_1:
03A8 D6 40     sub 64
03AA 67        ld h, a
03AB 06 10     ld b, 16
03AD F9        ld sp, hl
_l111:
03AE D5        push de
03AF D5        push de
03B0 D5        push de
03B1 D5        push de
03B2 D5        push de
03B3 D5        push de
03B4 D5        push de
03B5 D5        push de
_l113:
03B6 05        dec b
03B7 C2 AE 03  jp nz, _l111
ClearScreenSetSp:
_l112:
03BA 31 00 00  ld sp, 0
03BD FB        ei
ClearScreenPoly3:
03BE C6 3F     add 63
03C0 67        ld h, a
_l107:
03C1 0D        dec c
03C2 C2 97 03  jp nz, _l105
_l106:
03C5 C9        ret
03C6          SCROLL_COLUMN_UP equ 256
03C6          BITPLANE_OFFSET equ 16384
03C6          SCREEN_SIZE equ 12288
03C6          SCREEN_0_ADDRESS equ 53248
03C6          SCREEN_1_ADDRESS equ 36864
ScrollUpSubBw:
_l115:
03C6 F9        ld sp, hl
03C7 19        add hl, de
03C8 46        ld b, (hl)
03C9 2D        dec l
03CA 4E        ld c, (hl)
03CB 2D        dec l
03CC C5        push bc
03CD 46        ld b, (hl)
03CE 2D        dec l
03CF 4E        ld c, (hl)
03D0 2D        dec l
03D1 C5        push bc
03D2 46        ld b, (hl)
03D3 2D        dec l
03D4 4E        ld c, (hl)
03D5 2D        dec l
03D6 C5        push bc
03D7 46        ld b, (hl)
03D8 2D        dec l
03D9 4E        ld c, (hl)
03DA 2D        dec l
03DB C5        push bc
03DC 46        ld b, (hl)
03DD 2D        dec l
03DE 4E        ld c, (hl)
03DF C5        push bc
03E0 21 0A 01  ld hl, FONT_HEIGHT+256
03E3 39        add hl, sp
_l117:
03E4 3D        dec a
03E5 C2 C6 03  jp nz, _l115
_l116:
03E8 C3 44 04  jp ScrollUpSpInstr
ScrollUpSubColor:
_l119:
03EB F9        ld sp, hl
03EC 19        add hl, de
03ED 46        ld b, (hl)
03EE 2D        dec l
03EF 4E        ld c, (hl)
03F0 2D        dec l
03F1 C5        push bc
03F2 46        ld b, (hl)
03F3 2D        dec l
03F4 4E        ld c, (hl)
03F5 2D        dec l
03F6 C5        push bc
03F7 46        ld b, (hl)
03F8 2D        dec l
03F9 4E        ld c, (hl)
03FA 2D        dec l
03FB C5        push bc
03FC 46        ld b, (hl)
03FD 2D        dec l
03FE 4E        ld c, (hl)
03FF 2D        dec l
0400 C5        push bc
0401 46        ld b, (hl)
0402 2D        dec l
0403 4E        ld c, (hl)
0404 C5        push bc
0405 21 0A C0  ld hl, FONT_HEIGHT-BITPLANE_OFFSET
0408 39        add hl, sp
0409 F9        ld sp, hl
040A 19        add hl, de
040B 46        ld b, (hl)
040C 2D        dec l
040D 4E        ld c, (hl)
040E 2D        dec l
040F C5        push bc
0410 46        ld b, (hl)
0411 2D        dec l
0412 4E        ld c, (hl)
0413 2D        dec l
0414 C5        push bc
0415 46        ld b, (hl)
0416 2D        dec l
0417 4E        ld c, (hl)
0418 2D        dec l
0419 C5        push bc
041A 46        ld b, (hl)
041B 2D        dec l
041C 4E        ld c, (hl)
041D 2D        dec l
041E C5        push bc
041F 46        ld b, (hl)
0420 2D        dec l
0421 4E        ld c, (hl)
0422 C5        push bc
0423 21 0A 41  ld hl, (FONT_HEIGHT+BITPLANE_OFFSET)+256
0426 39        add hl, sp
_l121:
0427 3D        dec a
0428 C2 EB 03  jp nz, _l119
_l120:
042B C3 44 04  jp ScrollUpSpInstr
ScrollUp:
042E 21 00 00  ld hl, 0
0431 39        add hl, sp
0432 22 45 04  ld (ScrollUpSp), hl
0435 22 81 04  ld (ScrollUpSp2), hl
0438 11 F5 FF  ld de, -FONT_HEIGHT-1
043B 21 00 D1  ld hl, 53504
_l122:
043E F3        di
043F 3E 30     ld a, 48
ScrollUpSub:
0441 C3 C6 03  jp ScrollUpSubBw
ScrollUpSpInstr:
0444 31 00 00  ld sp, 0
0447 FB        ei
0448 7D        ld a, l
0449 D6 0A     sub FONT_HEIGHT
044B 6F        ld l, a
044C 26 D0     ld h, 208
_l124:
044E FE 11     cp FONT_HEIGHT+7
0450 D2 3E 04  jp nc, _l122
_l123:
0453 3E 30     ld a, 48
0455 11 00 00  ld de, 0
0458 F3        di
0459 31 10 FF  ld sp, (SCREEN_0_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l125:
045C D5        push de
045D D5        push de
045E D5        push de
045F D5        push de
0460 D5        push de
0461 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
0464 39        add hl, sp
0465 F9        ld sp, hl
_l127:
0466 3D        dec a
0467 C2 5C 04  jp nz, _l125
ScrollUp_2:
_l126:
046A 3E 30     ld a, 48
046C 11 00 00  ld de, 0
046F 31 10 BF  ld sp, (SCREEN_1_ADDRESS+SCREEN_SIZE)-(TEXT_SCREEN_HEIGHT-1)*FONT_HEIGHT
_l128:
0472 D5        push de
0473 D5        push de
0474 D5        push de
0475 D5        push de
0476 D5        push de
0477 21 0A FF  ld hl, -SCROLL_COLUMN_UP+FONT_HEIGHT
047A 39        add hl, sp
047B F9        ld sp, hl
_l130:
047C 3D        dec a
047D C2 72 04  jp nz, _l128
ScrollUpSpInstr2:
_l129:
0480 31 00 00  ld sp, 0
0483 FB        ei
0484 C9        ret
DrawText:
_l133:
0485 7E        ld a, (hl)
0486 23        inc hl
0487 B7        or a
0488 C8        ret z
0489 E5        push hl
048A D5        push de
048B EB        ex hl, de
048C CD 7F 03  call DrawChar
048F D1        pop de
0490 E1        pop hl
0491 14        inc d
0492 C3 85 04  jp _l133
_l132:
DrawChar6:
0495 47        ld b, a
0496 7D        ld a, l
0497 87        add a
0498 87        add a
0499 85        add l
049A 87        add a
049B 2F        cpl
049C 5F        ld e, a
049D 7C        ld a, h
049E 87        add a
049F 84        add h
04A0 4F        ld c, a
04A1 1F        rra
04A2 1F        rra
04A3 E6 3F     and 63
04A5 2F        cpl
04A6 57        ld d, a
04A7 78        ld a, b
04A8 C6 33     add font
04AA 6F        ld l, a
04AB CE 07     adc font>>8
04AD 95        sub l
04AE 67        ld h, a
04AF 79        ld a, c
04B0 E6 03     and 3
04B2 CA 04 05  jp z, DrawChar60
04B5 3D        dec a
04B6 CA 2B 05  jp z, DrawChar62
04B9 3D        dec a
04BA CA 4C 05  jp z, DrawChar64
DrawChar66:
04BD 0E 0A     ld c, FONT_HEIGHT
_l136:
04BF 7E        ld a, (hl)
04C0 0F 0F 0F  rrca
 rrca
 rrca
 rrca
04C4 F5        push af
04C5 E6 03     and 3
04C7 47        ld b, a
04C8 1A        ld a, (de)
DrawChar_And3:
04C9 E6 FC     and 252
DrawChar_Xor3:
04CB A8        xor b
04CC 12        ld (de), a
04CD F1        pop af
04CE 15        dec d
04CF E6 F0     and 240
04D1 47        ld b, a
04D2 1A        ld a, (de)
DrawChar_And5:
04D3 E6 0F     and 15
DrawChar_Xor4:
04D5 A8        xor b
04D6 12        ld (de), a
04D7 14        inc d
04D8 24        inc h
04D9 1D        dec e
_l138:
04DA 0D        dec c
04DB C2 BF 04  jp nz, _l136
_l137:
DrawChar_2:
04DE 7A        ld a, d
04DF D6 40     sub 64
04E1 57        ld d, a
04E2 0E 0A     ld c, FONT_HEIGHT
_l144:
04E4 1C        inc e
04E5 25        dec h
04E6 7E        ld a, (hl)
04E7 0F 0F 0F  rrca
 rrca
 rrca
 rrca
04EB F5        push af
04EC E6 03     and 3
04EE 47        ld b, a
04EF 1A        ld a, (de)
DrawChar_And4:
04F0 E6 FC     and 252
DrawChar_Xor5:
04F2 A8        xor b
04F3 12        ld (de), a
04F4 F1        pop af
04F5 15        dec d
04F6 E6 F0     and 240
04F8 47        ld b, a
04F9 1A        ld a, (de)
DrawChar_And6:
04FA E6 0F     and 15
DrawChar_Xor6:
04FC A8        xor b
04FD 12        ld (de), a
04FE 14        inc d
_l146:
04FF 0D        dec c
0500 C2 E4 04  jp nz, _l144
_l145:
0503 C9        ret
DrawChar60:
0504 0E 0A     ld c, FONT_HEIGHT
_l152:
0506 7E        ld a, (hl)
0507 87        add a
0508 87        add a
0509 47        ld b, a
050A 1A        ld a, (de)
DrawChar_And1:
050B E6 03     and 3
DrawChar_Xor1:
050D A8        xor b
050E 12        ld (de), a
050F 1D        dec e
0510 24        inc h
_l154:
0511 0D        dec c
0512 C2 06 05  jp nz, _l152
_l153:
DrawChar_1:
0515 7A        ld a, d
0516 D6 40     sub 64
0518 57        ld d, a
0519 0E 0A     ld c, FONT_HEIGHT
_l158:
051B 25        dec h
051C 1C        inc e
051D 7E        ld a, (hl)
051E 87        add a
051F 87        add a
0520 47        ld b, a
0521 1A        ld a, (de)
DrawChar_And2:
0522 E6 03     and 3
DrawChar_Xor2:
0524 A8        xor b
0525 12        ld (de), a
_l160:
0526 0D        dec c
0527 C2 1B 05  jp nz, _l158
_l159:
052A C9        ret
DrawChar62:
052B 0E 0A     ld c, FONT_HEIGHT
_l164:
052D 46        ld b, (hl)
052E 1A        ld a, (de)
DrawChar_And11:
052F E6 C0     and 192
DrawChar_Xor11:
0531 A8        xor b
0532 12        ld (de), a
0533 1D        dec e
0534 24        inc h
_l166:
0535 0D        dec c
0536 C2 2D 05  jp nz, _l164
_l165:
DrawChar_3:
0539 7A        ld a, d
053A D6 40     sub 64
053C 57        ld d, a
053D 0E 0A     ld c, FONT_HEIGHT
_l170:
053F 25        dec h
0540 1C        inc e
0541 46        ld b, (hl)
0542 1A        ld a, (de)
DrawChar_And12:
0543 E6 C0     and 192
DrawChar_Xor12:
0545 A8        xor b
0546 12        ld (de), a
_l172:
0547 0D        dec c
0548 C2 3F 05  jp nz, _l170
_l171:
054B C9        ret
DrawChar64:
054C 0E 0A     ld c, FONT_HEIGHT
_l176:
054E 7E        ld a, (hl)
054F 0F 0F     rrca
 rrca
0551 E6 0F     and 15
0553 47        ld b, a
0554 1A        ld a, (de)
DrawChar_And7:
0555 E6 F0     and 240
DrawChar_Xor7:
0557 A8        xor b
0558 12        ld (de), a
0559 15        dec d
055A 7E        ld a, (hl)
055B 0F 0F     rrca
 rrca
055D E6 C0     and 192
055F 47        ld b, a
0560 1A        ld a, (de)
DrawChar_And9:
0561 E6 3F     and 63
DrawChar_Xor8:
0563 A8        xor b
0564 12        ld (de), a
0565 14        inc d
0566 1D        dec e
0567 24        inc h
_l178:
0568 0D        dec c
0569 C2 4E 05  jp nz, _l176
_l177:
DrawChar_4:
056C 7A        ld a, d
056D D6 40     sub 64
056F 57        ld d, a
0570 0E 0A     ld c, FONT_HEIGHT
_l184:
0572 25        dec h
0573 1C        inc e
0574 7E        ld a, (hl)
0575 0F 0F     rrca
 rrca
0577 E6 0F     and 15
0579 47        ld b, a
057A 1A        ld a, (de)
DrawChar_And8:
057B E6 F0     and 240
DrawChar_Xor9:
057D A8        xor b
057E 12        ld (de), a
057F 15        dec d
0580 7E        ld a, (hl)
0581 0F 0F     rrca
 rrca
0583 E6 C0     and 192
0585 47        ld b, a
0586 1A        ld a, (de)
DrawChar_And10:
0587 E6 3F     and 63
DrawChar_Xor10:
0589 A8        xor b
058A 12        ld (de), a
058B 14        inc d
_l186:
058C 0D        dec c
058D C2 72 05  jp nz, _l184
_l185:
0590 C9        ret
SetColor6:
0591 4F        ld c, a
0592 E6 04     and 4
0594 C2 BC 05  jp nz, _l192
0597 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
059A 22 0B 05  ld (DrawChar_And1), hl
059D 22 22 05  ld (DrawChar_And2), hl
05A0 26 FC     ld h, 252
05A2 22 C9 04  ld (DrawChar_And3), hl
05A5 26 0F     ld h, 15
05A7 22 D3 04  ld (DrawChar_And5), hl
05AA 26 F0     ld h, 240
05AC 22 55 05  ld (DrawChar_And7), hl
05AF 26 3F     ld h, 63
05B1 22 61 05  ld (DrawChar_And9), hl
05B4 26 C0     ld h, 192
05B6 22 2F 05  ld (DrawChar_And11), hl
05B9 C3 DE 05  jp _l193
_l192:
05BC 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
05BF 22 0B 05  ld (DrawChar_And1), hl
05C2 22 22 05  ld (DrawChar_And2), hl
05C5 26 03     ld h, 255^252
05C7 22 C9 04  ld (DrawChar_And3), hl
05CA 26 F0     ld h, 255^15
05CC 22 D3 04  ld (DrawChar_And5), hl
05CF 26 0F     ld h, 255^240
05D1 22 55 05  ld (DrawChar_And7), hl
05D4 26 C0     ld h, 255^63
05D6 22 61 05  ld (DrawChar_And9), hl
05D9 26 3F     ld h, 255^192
05DB 22 2F 05  ld (DrawChar_And11), hl
_l193:
05DE 47        ld b, a
05DF 79        ld a, c
05E0 87        add a
05E1 87        add a
05E2 E6 04     and 4
05E4 A8        xor b
05E5 3E A8     ld a, OPCODE_XOR_B
05E7 C2 EC 05  jp nz, _l194
05EA 3E 00     ld a, OPCODE_NOP
_l194:
05EC 32 0D 05  ld (DrawChar_Xor1), a
05EF 32 CB 04  ld (DrawChar_Xor3), a
05F2 32 D5 04  ld (DrawChar_Xor4), a
05F5 32 57 05  ld (DrawChar_Xor7), a
05F8 32 63 05  ld (DrawChar_Xor8), a
05FB 32 31 05  ld (DrawChar_Xor11), a
05FE 79        ld a, c
05FF E6 08     and 8
0601 C2 26 06  jp nz, _l195
0604 21 E6 03  ld hl, OPCODE_AND_CONST|3<<8
0607 22 22 05  ld (DrawChar_And2), hl
060A 26 FC     ld h, 252
060C 22 F0 04  ld (DrawChar_And4), hl
060F 26 0F     ld h, 15
0611 22 FA 04  ld (DrawChar_And6), hl
0614 26 F0     ld h, 240
0616 22 7B 05  ld (DrawChar_And8), hl
0619 26 3F     ld h, 63
061B 22 87 05  ld (DrawChar_And10), hl
061E 26 C0     ld h, 192
0620 22 43 05  ld (DrawChar_And12), hl
0623 C3 45 06  jp _l196
_l195:
0626 21 F6 FC  ld hl, OPCODE_OR_CONST|(255^3)<<8
0629 22 22 05  ld (DrawChar_And2), hl
062C 26 03     ld h, 255^252
062E 22 F0 04  ld (DrawChar_And4), hl
0631 26 F0     ld h, 255^15
0633 22 FA 04  ld (DrawChar_And6), hl
0636 26 0F     ld h, 255^240
0638 22 7B 05  ld (DrawChar_And8), hl
063B 26 C0     ld h, 255^63
063D 22 87 05  ld (DrawChar_And10), hl
0640 26 3F     ld h, 255^192
0642 22 43 05  ld (DrawChar_And12), hl
_l196:
0645 47        ld b, a
0646 79        ld a, c
0647 87        add a
0648 87        add a
0649 E6 08     and 8
064B A8        xor b
064C 3E A8     ld a, OPCODE_XOR_B
064E C2 53 06  jp nz, _l197
0651 3E 00     ld a, OPCODE_NOP
_l197:
0653 32 24 05  ld (DrawChar_Xor2), a
0656 32 F2 04  ld (DrawChar_Xor5), a
0659 32 FC 04  ld (DrawChar_Xor6), a
065C 32 7D 05  ld (DrawChar_Xor9), a
065F 32 89 05  ld (DrawChar_Xor10), a
0662 32 45 05  ld (DrawChar_Xor12), a
0665 C9        ret
DrawCursor6:
0666 7C        ld a, h
0667 E6 03     and 3
0669 C2 72 06  jp nz, _l199
066C 11 FC 00  ld de, 63<<2
066F C3 89 06  jp _l200
_l199:
0672 3D        dec a
0673 C2 7C 06  jp nz, _l201
0676 11 03 F0  ld de, 61443
0679 C3 89 06  jp _l202
_l201:
067C 3D        dec a
067D C2 86 06  jp nz, _l203
0680 11 03 F0  ld de, 61443
0683 C3 89 06  jp _l204
_l203:
0686 11 3F 00  ld de, 63
_l204:
_l202:
_l200:
0689 7D        ld a, l
068A 87        add a
068B 87        add a
068C 85        add l
068D 87        add a
068E 2F        cpl
068F 6F        ld l, a
0690 7C        ld a, h
0691 87        add a
0692 84        add h
0693 0F 0F     rrca
 rrca
0695 E6 3F     and 63
0697 2F        cpl
0698 67        ld h, a
0699 0E 0A     ld c, FONT_HEIGHT
_l205:
069B 7E        ld a, (hl)
069C AB        xor e
069D 77        ld (hl), a
069E 25        dec h
069F 7E        ld a, (hl)
06A0 AA        xor d
06A1 77        ld (hl), a
06A2 24        inc h
06A3 2D        dec l
_l207:
06A4 0D        dec c
06A5 C2 9B 06  jp nz, _l205
_l206:
06A8 C9        ret
SetScreenBw6:
06A9 3E 40     ld a, 64
06AB 32 7E 03  ld (text_screen_width), a
06AE 21 95 04  ld hl, DrawChar6
06B1 22 80 03  ld (DrawCharAddress), hl
06B4 21 91 05  ld hl, SetColor6
06B7 22 83 03  ld (SetColorAddress), hl
06BA 3E C9     ld a, OPCODE_RET
06BC 32 15 05  ld (DrawChar_1), a
06BF 32 DE 04  ld (DrawChar_2), a
06C2 32 39 05  ld (DrawChar_3), a
06C5 32 6C 05  ld (DrawChar_4), a
SetScreenBw:
06C8 D3 B8     out (PORT_VIDEO_MODE_0_LOW), a
06CA D3 F9     out (PORT_VIDEO_MODE_1_HIGH), a
06CC 3E C3     ld a, OPCODE_JP
06CE 32 A8 03  ld (ClearScreen_1), a
06D1 21 BA 03  ld hl, ClearScreenSetSp
06D4 22 A9 03  ld (ClearScreen_2), hl
06D7 3E FF     ld a, 255
06D9 32 BF 03  ld (ClearScreen_4), a
06DC 21 C6 03  ld hl, ScrollUpSubBw
06DF 22 42 04  ld (ScrollUp_1), hl
06E2 3E C3     ld a, OPCODE_JP
06E4 32 6A 04  ld (ScrollUp_2), a
06E7 21 80 04  ld hl, ScrollUpSpInstr2
06EA 22 6B 04  ld (ScrollUp_3), hl
06ED C9        ret
SetScreenColor6:
06EE 3E 40     ld a, 64
06F0 32 7E 03  ld (text_screen_width), a
06F3 21 95 04  ld hl, DrawChar6
06F6 22 80 03  ld (DrawCharAddress), hl
06F9 21 91 05  ld hl, SetColor6
06FC 22 83 03  ld (SetColorAddress), hl
06FF 3E 7A     ld a, OPCODE_LD_A_D
0701 32 15 05  ld (DrawChar_1), a
0704 32 DE 04  ld (DrawChar_2), a
0707 32 39 05  ld (DrawChar_3), a
070A 32 6C 05  ld (DrawChar_4), a
SetScreenColor:
070D D3 F8     out (PORT_VIDEO_MODE_0_HIGH), a
070F D3 B9     out (PORT_VIDEO_MODE_1_LOW), a
0711 21 D6 40  ld hl, OPCODE_SUB_CONST|64<<8
0714 22 A8 03  ld (ClearScreen_1), hl
0717 3E 67     ld a, OPCODE_LD_H_A
0719 32 AA 03  ld (ClearScreen_3), a
071C 3E 3F     ld a, 63
071E 32 BF 03  ld (ClearScreen_4), a
0721 21 EB 03  ld hl, ScrollUpSubColor
0724 22 42 04  ld (ScrollUp_1), hl
0727 3E 3E     ld a, OPCODE_LD_A_CONST
0729 32 6A 04  ld (ScrollUp_2), a
072C 21 30 11  ld hl, 48|OPCODE_LD_DE_CONST<<8
072F 22 6B 04  ld (ScrollUp_3), hl
0732 C9        ret
font:
0733 00 00 00  db 0
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
1133          PALETTE_WHITE equ 0
1133          PALETTE_CYAN equ 1
1133          PALETTE_MAGENTA equ 2
1133          PALETTE_BLUE equ 3
1133          PALETTE_YELLOW equ 4
1133          PALETTE_GREEN equ 5
1133          PALETTE_RED equ 6
1133          PALETTE_XXX equ 7
1133          PALETTE_GRAY equ 8
1133          PALETTE_DARK_CYAN equ 9
1133          PALETTE_DARK_MAGENTA equ 10
1133          PALETTE_DARK_BLUE equ 11
1133          PALETTE_DARK_YELLOW equ 12
1133          PALETTE_DARK_GREEN equ 13
1133          PALETTE_DARK_RED equ 14
1133          PALETTE_BLACK equ 15
1133          KEY_BACKSPACE equ 8
1133          KEY_TAB equ 9
1133          KEY_ENTER equ 13
1133          KEY_ESC equ 27
1133          KEY_ALT equ 1
1133          KEY_F1 equ 242
1133          KEY_F2 equ 243
1133          KEY_F3 equ 244
1133          KEY_UP equ 245
1133          KEY_DOWN equ 246
1133          KEY_RIGHT equ 247
1133          KEY_LEFT equ 248
1133          KEY_EXT_5 equ 249
1133          KEY_END equ 250
1133          KEY_HOME equ 251
1133          KEY_INSERT equ 252
1133          KEY_DEL equ 253
1133          KEY_PG_UP equ 254
1133          KEY_PG_DN equ 255
1133          PORT_FRAME_IRQ_RESET equ 4
1133          PORT_SD_SIZE equ 9
1133          PORT_SD_RESULT equ 9
1133          PORT_SD_DATA equ 8
1133          PORT_UART_DATA equ 128
1133          PORT_UART_CONFIG equ 129
1133          PORT_UART_STATE equ 129
1133          PORT_EXT_DATA_OUT equ 136
1133          PORT_PALETTE_3 equ 144
1133          PORT_PALETTE_2 equ 145
1133          PORT_PALETTE_1 equ 146
1133          PORT_PALETTE_0 equ 147
1133          PORT_EXT_IN_DATA equ 137
1133          PORT_A0 equ 160
1133          PORT_ROM_0000 equ 168
1133          PORT_ROM_0000__ROM equ 0
1133          PORT_ROM_0000__RAM equ 128
1133          PORT_VIDEO_MODE_1_LOW equ 185
1133          PORT_VIDEO_MODE_1_HIGH equ 249
1133          PORT_VIDEO_MODE_0_LOW equ 184
1133          PORT_VIDEO_MODE_0_HIGH equ 248
1133          PORT_UART_SPEED_0 equ 187
1133          PORT_KEYBOARD equ 192
1133          PORT_UART_SPEED_1 equ 251
1133          PORT_CODE_ROM equ 186
1133          PORT_CHARGEN_ROM equ 250
1133          PORT_TAPE_AND_IDX2 equ 153
1133          PORT_TAPE_AND_IDX2_ID1_2 equ 2
1133          PORT_TAPE_AND_IDX2_ID2_2 equ 4
1133          PORT_TAPE_AND_IDX2_ID3_2 equ 8
1133          PORT_TAPE_AND_IDX2_ID6_2 equ 64
1133          PORT_TAPE_AND_IDX2_ID7_2 equ 128
1133          PORT_RESET_CU1 equ 188
1133          PORT_RESET_CU2 equ 189
1133          PORT_RESET_CU3 equ 190
1133          PORT_RESET_CU4 equ 191
1133          PORT_SET_CU1 equ 252
1133          PORT_SET_CU2 equ 253
1133          PORT_SET_CU3 equ 254
1133          PORT_SET_CU4 equ 255
1133          PORT_TAPE_OUT equ 176
1133          SD_COMMAND_READ equ 1
1133          SD_COMMAND_READ_SIZE equ 5
1133          SD_COMMAND_WRITE equ 2
1133          SD_COMMAND_WRITE_SIZE equ 5+128
1133          SD_RESULT_BUSY equ 255
1133          SD_RESULT_OK equ 0
1133          TEXT_SCREEN_HEIGHT equ 25
1133          FONT_HEIGHT equ 10
1133          FONT_WIDTH equ 3
1133          DrawCharAddress equ DrawChar+1
1133          SetColorAddress equ SetColor+1
1133          DrawCursorAddress equ DrawCursor+1
1133          OPCODE_NOP equ 0
1133          OPCODE_LD_DE_CONST equ 17
1133          OPCODE_LD_A_CONST equ 62
1133          OPCODE_LD_H_A equ 103
1133          OPCODE_LD_A_D equ 122
1133          OPCODE_LD_A_H equ 124
1133          OPCODE_XOR_B equ 168
1133          OPCODE_JP equ 195
1133          OPCODE_RET equ 201
1133          OPCODE_SUB_CONST equ 214
1133          OPCODE_AND_CONST equ 230
1133          OPCODE_OR_CONST equ 246
font4:
1133 00 00 00  db 0
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
1B33 47        ld b, a
1B34 7D        ld a, l
1B35 87        add a
1B36 87        add a
1B37 85        add l
1B38 87        add a
1B39 2F        cpl
1B3A 5F        ld e, a
1B3B 7C        ld a, h
1B3C 4F        ld c, a
1B3D B7        or a
1B3E 1F        rra
1B3F 2F        cpl
1B40 57        ld d, a
1B41 78        ld a, b
1B42 C6 33     add font4
1B44 6F        ld l, a
1B45 CE 11     adc font4>>8
1B47 95        sub l
1B48 67        ld h, a
1B49 79        ld a, c
1B4A E6 01     and 1
1B4C C2 76 1B  jp nz, DrawChar40
DrawChar44:
1B4F 0E 0A     ld c, FONT_HEIGHT
_l216:
1B51 7E        ld a, (hl)
1B52 E6 F0     and 240
1B54 47        ld b, a
1B55 1A        ld a, (de)
DrawChar4a_And1:
1B56 E6 0F     and 15
DrawChar4a_Xor1:
1B58 A8        xor b
1B59 12        ld (de), a
1B5A 1D        dec e
1B5B 24        inc h
_l218:
1B5C 0D        dec c
1B5D C2 51 1B  jp nz, _l216
_l217:
DrawChar4a:
1B60 7A        ld a, d
1B61 D6 40     sub 64
1B63 57        ld d, a
1B64 0E 0A     ld c, FONT_HEIGHT
_l222:
1B66 25        dec h
1B67 1C        inc e
1B68 7E        ld a, (hl)
1B69 E6 F0     and 240
1B6B 47        ld b, a
1B6C 1A        ld a, (de)
DrawChar4a_And2:
1B6D E6 0F     and 15
DrawChar4a_Xor2:
1B6F A8        xor b
1B70 12        ld (de), a
_l224:
1B71 0D        dec c
1B72 C2 66 1B  jp nz, _l222
_l223:
1B75 C9        ret
DrawChar40:
1B76 0E 0A     ld c, FONT_HEIGHT
_l228:
1B78 7E        ld a, (hl)
1B79 E6 0F     and 15
1B7B 47        ld b, a
1B7C 1A        ld a, (de)
DrawChar4b_And1:
1B7D E6 F0     and 240
DrawChar4b_Xor1:
1B7F A8        xor b
1B80 12        ld (de), a
1B81 1D        dec e
1B82 24        inc h
_l230:
1B83 0D        dec c
1B84 C2 78 1B  jp nz, _l228
_l229:
DrawChar4b:
1B87 7A        ld a, d
1B88 D6 40     sub 64
1B8A 57        ld d, a
1B8B 0E 0A     ld c, FONT_HEIGHT
_l234:
1B8D 25        dec h
1B8E 1C        inc e
1B8F 7E        ld a, (hl)
1B90 E6 0F     and 15
1B92 47        ld b, a
1B93 1A        ld a, (de)
DrawChar4b_And2:
1B94 E6 F0     and 240
DrawChar4b_Xor2:
1B96 A8        xor b
1B97 12        ld (de), a
_l236:
1B98 0D        dec c
1B99 C2 8D 1B  jp nz, _l234
_l235:
1B9C C9        ret
SetColor4:
1B9D 4F        ld c, a
1B9E E6 04     and 4
1BA0 C2 B1 1B  jp nz, _l240
1BA3 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
1BA6 22 56 1B  ld (DrawChar4a_And1), hl
1BA9 26 F0     ld h, 240
1BAB 22 7D 1B  ld (DrawChar4b_And1), hl
1BAE C3 BC 1B  jp _l241
_l240:
1BB1 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
1BB4 22 56 1B  ld (DrawChar4a_And1), hl
1BB7 26 0F     ld h, 15
1BB9 22 7D 1B  ld (DrawChar4b_And1), hl
_l241:
1BBC 47        ld b, a
1BBD 79        ld a, c
1BBE 87        add a
1BBF 87        add a
1BC0 E6 04     and 4
1BC2 A8        xor b
1BC3 3E A8     ld a, OPCODE_XOR_B
1BC5 C2 CA 1B  jp nz, _l242
1BC8 3E 00     ld a, OPCODE_NOP
_l242:
1BCA 32 58 1B  ld (DrawChar4a_Xor1), a
1BCD 32 7F 1B  ld (DrawChar4b_Xor1), a
1BD0 79        ld a, c
1BD1 E6 08     and 8
1BD3 C2 E4 1B  jp nz, _l243
1BD6 21 E6 0F  ld hl, OPCODE_AND_CONST|15<<8
1BD9 22 6D 1B  ld (DrawChar4a_And2), hl
1BDC 26 F0     ld h, 240
1BDE 22 94 1B  ld (DrawChar4b_And2), hl
1BE1 C3 EF 1B  jp _l244
_l243:
1BE4 21 F6 F0  ld hl, OPCODE_OR_CONST|240<<8
1BE7 22 6D 1B  ld (DrawChar4a_And2), hl
1BEA 26 0F     ld h, 15
1BEC 22 94 1B  ld (DrawChar4b_And2), hl
_l244:
1BEF 47        ld b, a
1BF0 79        ld a, c
1BF1 87        add a
1BF2 87        add a
1BF3 E6 08     and 8
1BF5 A8        xor b
1BF6 3E A8     ld a, OPCODE_XOR_B
1BF8 C2 FD 1B  jp nz, _l245
1BFB 3E 00     ld a, OPCODE_NOP
_l245:
1BFD 32 6F 1B  ld (DrawChar4a_Xor2), a
1C00 32 96 1B  ld (DrawChar4b_Xor2), a
1C03 C9        ret
DrawCursor4:
1C04 7C        ld a, h
1C05 B7        or a
1C06 1F        rra
1C07 2F        cpl
1C08 57        ld d, a
1C09 7D        ld a, l
1C0A 87        add a
1C0B 87        add a
1C0C 85        add l
1C0D 87        add a
1C0E 2F        cpl
1C0F 5F        ld e, a
1C10 7C        ld a, h
1C11 E6 01     and 1
1C13 06 0F     ld b, 15
1C15 C2 1A 1C  jp nz, _l247
1C18 06 F0     ld b, 240
_l247:
1C1A 0E 0A     ld c, FONT_HEIGHT
_l248:
1C1C 1A        ld a, (de)
1C1D A8        xor b
1C1E 12        ld (de), a
1C1F 1D        dec e
_l250:
1C20 0D        dec c
1C21 C2 1C 1C  jp nz, _l248
_l249:
1C24 C9        ret
SetScreenBw4:
1C25 3E 60     ld a, 96
1C27 32 7E 03  ld (text_screen_width), a
1C2A 21 9D 1B  ld hl, SetColor4
1C2D 22 83 03  ld (SetColorAddress), hl
1C30 21 33 1B  ld hl, DrawChar4
1C33 22 80 03  ld (DrawCharAddress), hl
1C36 21 04 1C  ld hl, DrawCursor4
1C39 22 86 03  ld (DrawCursorAddress), hl
1C3C 3E C9     ld a, OPCODE_RET
1C3E 32 60 1B  ld (DrawChar4a), a
1C41 32 87 1B  ld (DrawChar4b), a
1C44 C3 C8 06  jp SetScreenBw
SetScreenColor4:
1C47 3E 60     ld a, 96
1C49 32 7E 03  ld (text_screen_width), a
1C4C 21 9D 1B  ld hl, SetColor4
1C4F 22 83 03  ld (SetColorAddress), hl
1C52 21 33 1B  ld hl, DrawChar4
1C55 22 80 03  ld (DrawCharAddress), hl
1C58 21 04 1C  ld hl, DrawCursor4
1C5B 22 86 03  ld (DrawCursorAddress), hl
1C5E 3E 7A     ld a, OPCODE_LD_A_D
1C60 32 60 1B  ld (DrawChar4a), a
1C63 32 87 1B  ld (DrawChar4b), a
1C66 C3 0D 07  jp SetScreenColor
1C69          PALETTE_WHITE equ 0
1C69          PALETTE_CYAN equ 1
1C69          PALETTE_MAGENTA equ 2
1C69          PALETTE_BLUE equ 3
1C69          PALETTE_YELLOW equ 4
1C69          PALETTE_GREEN equ 5
1C69          PALETTE_RED equ 6
1C69          PALETTE_XXX equ 7
1C69          PALETTE_GRAY equ 8
1C69          PALETTE_DARK_CYAN equ 9
1C69          PALETTE_DARK_MAGENTA equ 10
1C69          PALETTE_DARK_BLUE equ 11
1C69          PALETTE_DARK_YELLOW equ 12
1C69          PALETTE_DARK_GREEN equ 13
1C69          PALETTE_DARK_RED equ 14
1C69          PALETTE_BLACK equ 15
1C69          KEY_BACKSPACE equ 8
1C69          KEY_TAB equ 9
1C69          KEY_ENTER equ 13
1C69          KEY_ESC equ 27
1C69          KEY_ALT equ 1
1C69          KEY_F1 equ 242
1C69          KEY_F2 equ 243
1C69          KEY_F3 equ 244
1C69          KEY_UP equ 245
1C69          KEY_DOWN equ 246
1C69          KEY_RIGHT equ 247
1C69          KEY_LEFT equ 248
1C69          KEY_EXT_5 equ 249
1C69          KEY_END equ 250
1C69          KEY_HOME equ 251
1C69          KEY_INSERT equ 252
1C69          KEY_DEL equ 253
1C69          KEY_PG_UP equ 254
1C69          KEY_PG_DN equ 255
1C69          PORT_FRAME_IRQ_RESET equ 4
1C69          PORT_SD_SIZE equ 9
1C69          PORT_SD_RESULT equ 9
1C69          PORT_SD_DATA equ 8
1C69          PORT_UART_DATA equ 128
1C69          PORT_UART_CONFIG equ 129
1C69          PORT_UART_STATE equ 129
1C69          PORT_EXT_DATA_OUT equ 136
1C69          PORT_PALETTE_3 equ 144
1C69          PORT_PALETTE_2 equ 145
1C69          PORT_PALETTE_1 equ 146
1C69          PORT_PALETTE_0 equ 147
1C69          PORT_EXT_IN_DATA equ 137
1C69          PORT_A0 equ 160
1C69          PORT_ROM_0000 equ 168
1C69          PORT_ROM_0000__ROM equ 0
1C69          PORT_ROM_0000__RAM equ 128
1C69          PORT_VIDEO_MODE_1_LOW equ 185
1C69          PORT_VIDEO_MODE_1_HIGH equ 249
1C69          PORT_VIDEO_MODE_0_LOW equ 184
1C69          PORT_VIDEO_MODE_0_HIGH equ 248
1C69          PORT_UART_SPEED_0 equ 187
1C69          PORT_KEYBOARD equ 192
1C69          PORT_UART_SPEED_1 equ 251
1C69          PORT_CODE_ROM equ 186
1C69          PORT_CHARGEN_ROM equ 250
1C69          PORT_TAPE_AND_IDX2 equ 153
1C69          PORT_TAPE_AND_IDX2_ID1_2 equ 2
1C69          PORT_TAPE_AND_IDX2_ID2_2 equ 4
1C69          PORT_TAPE_AND_IDX2_ID3_2 equ 8
1C69          PORT_TAPE_AND_IDX2_ID6_2 equ 64
1C69          PORT_TAPE_AND_IDX2_ID7_2 equ 128
1C69          PORT_RESET_CU1 equ 188
1C69          PORT_RESET_CU2 equ 189
1C69          PORT_RESET_CU3 equ 190
1C69          PORT_RESET_CU4 equ 191
1C69          PORT_SET_CU1 equ 252
1C69          PORT_SET_CU2 equ 253
1C69          PORT_SET_CU3 equ 254
1C69          PORT_SET_CU4 equ 255
1C69          PORT_TAPE_OUT equ 176
1C69          SD_COMMAND_READ equ 1
1C69          SD_COMMAND_READ_SIZE equ 5
1C69          SD_COMMAND_WRITE equ 2
1C69          SD_COMMAND_WRITE_SIZE equ 5+128
1C69          SD_RESULT_BUSY equ 255
1C69          SD_RESULT_OK equ 0
1C69          stack equ 256
1C69          entry_cpm_conout_address equ EntryCpmConout+1
1C69          cpm_dph_a equ 65376
1C69          cpm_dph_b equ 65392
1C69          cpm_dma_buffer equ 65408
1C69          MOD_CTR equ 1
1C69          MOD_SHIFT equ 2
1C69          MOD_CAPS equ 16
1C69          MOD_NUM equ 32
1C69          TEXT_SCREEN_HEIGHT equ 25
1C69          FONT_HEIGHT equ 10
1C69          FONT_WIDTH equ 3
1C69          DrawCharAddress equ DrawChar+1
1C69          SetColorAddress equ SetColor+1
1C69          DrawCursorAddress equ DrawCursor+1
1C69          NEXT_REPLAY_DELAY equ 3
1C69          FIRST_REPLAY_DELAY equ 30
1C69          SCAN_LAT equ 25
1C69          SCAN_RUS equ 24
1C69          SCAN_CAP equ 30
1C69          SCAN_NUM equ 28
1C69          LAYOUT_SIZE equ 80
1C69          CURSOR_BLINK_PERIOD equ 35
frame_counter:
1C69 00        db 0
key_leds:
1C6A 20        db MOD_NUM
key_pressed:
1C6B 00        db 0
key_delay:
1C6C 00        db 0
key_rus:
1C6D 00        db 0
key_read:
1C6E 45        db key_buffer
key_write:
1C6F 45        db key_buffer
1C70          SHI equ 64
1C70          CAP equ 128
1C70          NUM equ 32
shiftLayout:
1C70 40        db SHI
1C71 80        db CAP
1C72 80        db CAP
1C73 80        db CAP
1C74 40        db SHI
1C75 80        db CAP
1C76 80        db CAP
1C77 40        db SHI
1C78 40        db SHI
1C79 80        db CAP
1C7A 80        db CAP
1C7B 80        db CAP
1C7C 40        db SHI
1C7D 80        db CAP
1C7E 80        db CAP
1C7F 40        db SHI
1C80 40        db SHI
1C81 80        db CAP
1C82 80        db CAP
1C83 80        db CAP
1C84 40        db SHI
1C85 80        db CAP
1C86 40        db SHI
1C87 40        db SHI
1C88 00        db 0
1C89 00        db 0
1C8A 00        db 0
1C8B 00        db 0
1C8C 00        db 0
1C8D 00        db 0
1C8E 00        db 0
1C8F 00        db 0
1C90 40        db SHI
1C91 80        db CAP
1C92 80        db CAP
1C93 80        db CAP
1C94 40        db SHI
1C95 40        db SHI
1C96 40        db SHI
1C97 40        db SHI
1C98 40        db SHI
1C99 80        db CAP
1C9A 80        db CAP
1C9B 80        db CAP
1C9C 40        db SHI
1C9D 40        db SHI
1C9E 40        db SHI
1C9F 40        db SHI
1CA0 40        db SHI
1CA1 20        db NUM
1CA2 80        db CAP
1CA3 80        db CAP
1CA4 40        db SHI
1CA5 40        db SHI
1CA6 40        db SHI
1CA7 20        db NUM
1CA8 00        db 0
1CA9 80        db CAP
1CAA 80        db CAP
1CAB 80        db CAP
1CAC 00        db 0
1CAD 20        db NUM
1CAE 20        db NUM
1CAF 20        db NUM
1CB0 00        db 0
1CB1 80        db CAP
1CB2 00        db 0
1CB3 00        db 0
1CB4 40        db SHI
1CB5 20        db NUM
1CB6 20        db NUM
1CB7 20        db NUM
1CB8 00        db 0
1CB9 00        db 0
1CBA 00        db 0
1CBB 00        db 0
1CBC 00        db 0
1CBD 20        db NUM
1CBE 20        db NUM
1CBF 20        db NUM
1CC0 40        db SHI
1CC1 80        db CAP
1CC2 80        db CAP
1CC3 80        db CAP
1CC4 40        db SHI
1CC5 80        db CAP
1CC6 80        db CAP
1CC7 80        db CAP
1CC8 40        db SHI
1CC9 80        db CAP
1CCA 80        db CAP
1CCB 80        db CAP
1CCC 40        db SHI
1CCD 80        db CAP
1CCE 80        db CAP
1CCF 80        db CAP
1CD0 40        db SHI
1CD1 80        db CAP
1CD2 80        db CAP
1CD3 80        db CAP
1CD4 40        db SHI
1CD5 80        db CAP
1CD6 80        db CAP
1CD7 80        db CAP
1CD8 00        db 0
1CD9 00        db 0
1CDA 00        db 0
1CDB 00        db 0
1CDC 00        db 0
1CDD 00        db 0
1CDE 00        db 0
1CDF 00        db 0
1CE0 40        db SHI
1CE1 80        db CAP
1CE2 80        db CAP
1CE3 80        db CAP
1CE4 40        db SHI
1CE5 80        db CAP
1CE6 80        db CAP
1CE7 40        db SHI
1CE8 40        db SHI
1CE9 80        db CAP
1CEA 80        db CAP
1CEB 80        db CAP
1CEC 40        db SHI
1CED 80        db CAP
1CEE 40        db SHI
1CEF 40        db SHI
1CF0 40        db SHI
1CF1 20        db NUM
1CF2 80        db CAP
1CF3 80        db CAP
1CF4 40        db SHI
1CF5 40        db SHI
1CF6 40        db SHI
1CF7 20        db NUM
1CF8 00        db 0
1CF9 80        db CAP
1CFA 80        db CAP
1CFB 80        db CAP
1CFC 00        db 0
1CFD 20        db NUM
1CFE 20        db NUM
1CFF 20        db NUM
1D00 00        db 0
1D01 80        db CAP
1D02 00        db 0
1D03 00        db 0
1D04 40        db SHI
1D05 20        db NUM
1D06 20        db NUM
1D07 20        db NUM
1D08 00        db 0
1D09 00        db 0
1D0A 00        db 0
1D0B 00        db 0
1D0C 00        db 0
1D0D 20        db NUM
1D0E 20        db NUM
1D0F 20        db NUM
ctrLayout:
1D10 1E        db 30
1D11 15        db 117&31
1D12 0A        db 106&31
1D13 0D        db 109&31
1D14 1F        db 31
1D15 09        db 105&31
1D16 0B        db 107&31
1D17 00        db 96&31
1D18 1D        db 29
1D19 19        db 121&31
1D1A 08        db 104&31
1D1B 0E        db 110&31
1D1C 08        db 8
1D1D 0F        db 111&31
1D1E 0C        db 108&31
1D1F 00        db 64&31
1D20 1C        db 28
1D21 14        db 116&31
1D22 07        db 103&31
1D23 02        db 98&31
1D24 39        db 57
1D25 10        db 112&31
1D26 1B        db 91&31
1D27 3F        db 63
1D28 3F        db 63
1D29 3F        db 63
1D2A 01        db KEY_ALT
1D2B 3F        db 63
1D2C 3F        db 63
1D2D 08        db KEY_BACKSPACE
1D2E 3F        db 63
1D2F 00        db 32&31
1D30 1B        db 27
1D31 12        db 114&31
1D32 06        db 102&31
1D33 16        db 118&31
1D34 00        db 0
1D35 1B        db 123&31
1D36 1D        db 93&31
1D37 2C        db 44
1D38 00        db 0
1D39 05        db 101&31
1D3A 04        db 100&31
1D3B 03        db 99&31
1D3C 1F        db 95&31
1D3D 1D        db 125&31
1D3E 3A        db 58
1D3F 2E        db 46
1D40 31        db 49
1D41 2E        db 46
1D42 01        db 97&31
1D43 1A        db 122&31
1D44 1E        db 94&31
1D45 0F        db 47&31
1D46 3B        db 59
1D47 30        db 48
1D48 3F        db 63
1D49 17        db 119&31
1D4A 13        db 115&31
1D4B 18        db 120&31
1D4C 3F        db 63
1D4D 37        db 55
1D4E 34        db 52
1D4F 31        db 49
1D50 0A        db 10
1D51 11        db 113&31
1D52 09        db KEY_TAB
1D53 3F        db 63
1D54 1C        db 92&31
1D55 38        db 56
1D56 35        db 53
1D57 32        db 50
1D58 F4        db KEY_F3
1D59 3F        db 63
1D5A F2        db KEY_F1
1D5B F3        db KEY_F2
1D5C 1B        db KEY_ESC
1D5D 39        db 57
1D5E 36        db 54
1D5F 33        db 51
key_layout_table:
1D60 36        db 54
1D61 75        db 117
1D62 6A        db 106
1D63 6D        db 109
1D64 37        db 55
1D65 69        db 105
1D66 6B        db 107
1D67 60        db 96
1D68 35        db 53
1D69 79        db 121
1D6A 68        db 104
1D6B 6E        db 110
1D6C 38        db 56
1D6D 6F        db 111
1D6E 6C        db 108
1D6F 40        db 64
1D70 34        db 52
1D71 74        db 116
1D72 67        db 103
1D73 62        db 98
1D74 39        db 57
1D75 70        db 112
1D76 5B        db 91
1D77 00        db 0
1D78 00        db 0
1D79 00        db 0
1D7A 01        db KEY_ALT
1D7B 00        db 0
1D7C 00        db 0
1D7D 08        db KEY_BACKSPACE
1D7E 00        db 0
1D7F 20        db 32
1D80 33        db 51
1D81 72        db 114
1D82 66        db 102
1D83 76        db 118
1D84 30        db 48
1D85 7B        db 123
1D86 5D        db 93
1D87 2C        db 44
1D88 32        db 50
1D89 65        db 101
1D8A 64        db 100
1D8B 63        db 99
1D8C 2D        db 45
1D8D 7D        db 125
1D8E 3A        db 58
1D8F 2E        db 46
1D90 31        db 49
1D91 FD        db KEY_DEL
1D92 61        db 97
1D93 7A        db 122
1D94 5E        db 94
1D95 2F        db 47
1D96 3B        db 59
1D97 FC        db KEY_INSERT
1D98 00        db 0
1D99 77        db 119
1D9A 73        db 115
1D9B 78        db 120
1D9C FD        db KEY_DEL
1D9D FB        db KEY_HOME
1D9E F8        db KEY_LEFT
1D9F FA        db KEY_END
1DA0 0D        db KEY_ENTER
1DA1 71        db 113
1DA2 09        db KEY_TAB
1DA3 00        db 0
1DA4 5C        db 92
1DA5 F5        db KEY_UP
1DA6 F9        db KEY_EXT_5
1DA7 F6        db KEY_DOWN
1DA8 F4        db KEY_F3
1DA9 00        db 0
1DAA F2        db KEY_F1
1DAB F3        db KEY_F2
1DAC 1B        db KEY_ESC
1DAD FE        db KEY_PG_UP
1DAE F7        db KEY_RIGHT
1DAF FF        db KEY_PG_DN
1DB0 26        db 38
1DB1 55        db 85
1DB2 4A        db 74
1DB3 4D        db 77
1DB4 27        db 39
1DB5 49        db 73
1DB6 4B        db 75
1DB7 60        db 96
1DB8 25        db 37
1DB9 59        db 89
1DBA 48        db 72
1DBB 4E        db 78
1DBC 28        db 40
1DBD 4F        db 79
1DBE 4C        db 76
1DBF 40        db 64
1DC0 24        db 36
1DC1 54        db 84
1DC2 47        db 71
1DC3 42        db 66
1DC4 29        db 41
1DC5 50        db 80
1DC6 5B        db 91
1DC7 00        db 0
1DC8 00        db 0
1DC9 00        db 0
1DCA 01        db KEY_ALT
1DCB 00        db 0
1DCC 00        db 0
1DCD 08        db KEY_BACKSPACE
1DCE 00        db 0
1DCF 20        db 32
1DD0 23        db 35
1DD1 52        db 82
1DD2 46        db 70
1DD3 56        db 86
1DD4 5F        db 95
1DD5 7B        db 123
1DD6 5D        db 93
1DD7 3C        db 60
1DD8 22        db 34
1DD9 45        db 69
1DDA 44        db 68
1DDB 43        db 67
1DDC 3D        db 61
1DDD 7D        db 125
1DDE 2A        db 42
1DDF 3E        db 62
1DE0 21        db 33
1DE1 2E        db 46
1DE2 41        db 65
1DE3 5A        db 90
1DE4 7E        db 126
1DE5 3F        db 63
1DE6 2B        db 43
1DE7 30        db 48
1DE8 00        db 0
1DE9 57        db 87
1DEA 53        db 83
1DEB 58        db 88
1DEC FD        db KEY_DEL
1DED 37        db 55
1DEE 34        db 52
1DEF 31        db 49
1DF0 0D        db KEY_ENTER
1DF1 51        db 81
1DF2 09        db KEY_TAB
1DF3 00        db 0
1DF4 7C        db 124
1DF5 38        db 56
1DF6 35        db 53
1DF7 32        db 50
1DF8 F4        db KEY_F3
1DF9 00        db 0
1DFA F2        db KEY_F1
1DFB F3        db KEY_F2
1DFC 1B        db KEY_ESC
1DFD 39        db 57
1DFE 36        db 54
1DFF 33        db 51
1E00 36        db 54
1E01 A3        db 163
1E02 AE        db 174
1E03 EC        db 236
1E04 37        db 55
1E05 E8        db 232
1E06 AB        db 171
1E07 A1        db 161
1E08 35        db 53
1E09 AD        db 173
1E0A E0        db 224
1E0B E2        db 226
1E0C 38        db 56
1E0D E9        db 233
1E0E A4        db 164
1E0F EE        db 238
1E10 34        db 52
1E11 A5        db 165
1E12 AF        db 175
1E13 A8        db 168
1E14 39        db 57
1E15 A7        db 167
1E16 A6        db 166
1E17 F1        db 241
1E18 00        db 0
1E19 00        db 0
1E1A 01        db KEY_ALT
1E1B 00        db 0
1E1C 00        db 0
1E1D 08        db KEY_BACKSPACE
1E1E 00        db 0
1E1F 20        db 32
1E20 33        db 51
1E21 AA        db 170
1E22 A0        db 160
1E23 AC        db 172
1E24 30        db 48
1E25 E5        db 229
1E26 ED        db 237
1E27 2C        db 44
1E28 32        db 50
1E29 E3        db 227
1E2A A2        db 162
1E2B E1        db 225
1E2C 2D        db 45
1E2D EA        db 234
1E2E 3A        db 58
1E2F 2E        db 46
1E30 31        db 49
1E31 FD        db KEY_DEL
1E32 E4        db 228
1E33 EF        db 239
1E34 5E        db 94
1E35 2F        db 47
1E36 3B        db 59
1E37 FC        db KEY_INSERT
1E38 00        db 0
1E39 E6        db 230
1E3A EB        db 235
1E3B E7        db 231
1E3C FD        db KEY_DEL
1E3D FB        db KEY_HOME
1E3E F8        db KEY_LEFT
1E3F FA        db KEY_END
1E40 0D        db KEY_ENTER
1E41 A9        db 169
1E42 09        db KEY_TAB
1E43 00        db 0
1E44 5C        db 92
1E45 F5        db KEY_UP
1E46 F9        db KEY_EXT_5
1E47 F6        db KEY_DOWN
1E48 F4        db KEY_F3
1E49 00        db 0
1E4A F2        db KEY_F1
1E4B F3        db KEY_F2
1E4C 1B        db KEY_ESC
1E4D FE        db KEY_PG_UP
1E4E F7        db KEY_RIGHT
1E4F FF        db KEY_PG_DN
1E50 26        db 38
1E51 83        db 131
1E52 8E        db 142
1E53 9C        db 156
1E54 27        db 39
1E55 98        db 152
1E56 8B        db 139
1E57 81        db 129
1E58 25        db 37
1E59 8D        db 141
1E5A 90        db 144
1E5B 92        db 146
1E5C 28        db 40
1E5D 99        db 153
1E5E 84        db 132
1E5F 9E        db 158
1E60 24        db 36
1E61 85        db 133
1E62 8F        db 143
1E63 88        db 136
1E64 29        db 41
1E65 58        db 88
1E66 86        db 134
1E67 F0        db 240
1E68 00        db 0
1E69 00        db 0
1E6A 01        db KEY_ALT
1E6B 00        db 0
1E6C 00        db 0
1E6D 08        db KEY_BACKSPACE
1E6E 00        db 0
1E6F 20        db 32
1E70 23        db 35
1E71 8A        db 138
1E72 80        db 128
1E73 8C        db 140
1E74 5F        db 95
1E75 58        db 88
1E76 9D        db 157
1E77 3C        db 60
1E78 22        db 34
1E79 93        db 147
1E7A 82        db 130
1E7B 91        db 145
1E7C 3D        db 61
1E7D 9A        db 154
1E7E 2A        db 42
1E7F 3E        db 62
1E80 21        db 33
1E81 2E        db 46
1E82 94        db 148
1E83 9F        db 159
1E84 7E        db 126
1E85 3F        db 63
1E86 2B        db 43
1E87 30        db 48
1E88 00        db 0
1E89 96        db 150
1E8A 9B        db 155
1E8B 97        db 151
1E8C FD        db KEY_DEL
1E8D 37        db 55
1E8E 34        db 52
1E8F 31        db 49
1E90 0D        db KEY_ENTER
1E91 89        db 137
1E92 09        db KEY_TAB
1E93 00        db 0
1E94 7C        db 124
1E95 38        db 56
1E96 35        db 53
1E97 32        db 50
1E98 F4        db KEY_F3
1E99 00        db 0
1E9A F2        db KEY_F1
1E9B F3        db KEY_F2
1E9C 1B        db KEY_ESC
1E9D 39        db 57
1E9E 36        db 54
1E9F 33        db 51
CheckKeyboard:
1EA0 2A 6E 1C  ld hl, (key_read)
1EA3 7C        ld a, h
1EA4 BD        cp l
1EA5 C9        ret
ReadKeyboard:
1EA6 2A 6E 1C  ld hl, (key_read)
1EA9 7C        ld a, h
1EAA BD        cp l
1EAB C8        ret z
1EAC 26 00     ld h, key_buffer>>8
1EAE 56        ld d, (hl)
1EAF 2C        inc l
1EB0 7D        ld a, l
1EB1 FE 85     cp key_buffer+64
1EB3 C2 B8 1E  jp nz, _l265
1EB6 3E 45     ld a, key_buffer
_l265:
1EB8 32 6E 1C  ld (key_read), a
1EBB AF        xor a
1EBC 3C        inc a
1EBD 7A        ld a, d
1EBE C9        ret
KeyPush:
1EBF E5        push hl
1EC0 2A 6F 1C  ld hl, (key_write)
1EC3 26 00     ld h, key_buffer>>8
1EC5 77        ld (hl), a
1EC6 2C        inc l
1EC7 7D        ld a, l
1EC8 FE 85     cp key_buffer+64&255
1ECA C2 CF 1E  jp nz, _l267
1ECD 3E 45     ld a, key_buffer
_l267:
1ECF 32 6F 1C  ld (key_write), a
1ED2 E1        pop hl
1ED3 C9        ret
special_keys:
1ED4 4F        db 79
1ED5 50        db 80
1ED6 00        db 0
1ED7 4F        db 79
1ED8 51        db 81
1ED9 00        db 0
1EDA 4F        db 79
1EDB 52        db 82
1EDC 00        db 0
1EDD 5B        db 91
1EDE 41        db 65
1EDF 00        db 0
1EE0 5B        db 91
1EE1 42        db 66
1EE2 00        db 0
1EE3 5B        db 91
1EE4 43        db 67
1EE5 00        db 0
1EE6 5B        db 91
1EE7 44        db 68
1EE8 00        db 0
1EE9 5B        db 91
1EEA 45        db 69
1EEB 00        db 0
1EEC 5B        db 91
1EED 46        db 70
1EEE 00        db 0
1EEF 5B        db 91
1EF0 48        db 72
1EF1 00        db 0
1EF2 5B        db 91
1EF3 32        db 50
1EF4 7E        db 126
1EF5 5B        db 91
1EF6 33        db 51
1EF7 7E        db 126
1EF8 5B        db 91
1EF9 35        db 53
1EFA 7E        db 126
1EFB 5B        db 91
1EFC 36        db 54
1EFD 7E        db 126
KeyPressed:
1EFE 57        ld d, a
1EFF 2A 6B 1C  ld hl, (key_pressed)
1F02 BD        cp l
1F03 C2 10 1F  jp nz, _l270
1F06 21 6C 1C  ld hl, key_delay
1F09 35        dec (hl)
1F0A C0        ret nz
1F0B 36 03     ld (hl), NEXT_REPLAY_DELAY
1F0D C3 18 1F  jp _l271
_l270:
1F10 32 6B 1C  ld (key_pressed), a
1F13 21 6C 1C  ld hl, key_delay
1F16 36 1E     ld (hl), FIRST_REPLAY_DELAY
_l271:
1F18 FE 19     cp SCAN_LAT
1F1A C2 22 1F  jp nz, _l272
1F1D AF        xor a
1F1E 32 6D 1C  ld (key_rus), a
1F21 C9        ret
_l272:
1F22 FE 18     cp SCAN_RUS
1F24 C2 2D 1F  jp nz, _l273
1F27 3E 50     ld a, LAYOUT_SIZE
1F29 32 6D 1C  ld (key_rus), a
1F2C C9        ret
_l273:
1F2D FE 1E     cp SCAN_CAP
1F2F C2 3B 1F  jp nz, _l274
1F32 3A 6A 1C  ld a, (key_leds)
1F35 EE 10     xor MOD_CAPS
1F37 32 6A 1C  ld (key_leds), a
1F3A C9        ret
_l274:
1F3B FE 1C     cp SCAN_NUM
1F3D C2 49 1F  jp nz, _l275
1F40 3A 6A 1C  ld a, (key_leds)
1F43 EE 20     xor MOD_NUM
1F45 32 6A 1C  ld (key_leds), a
1F48 C9        ret
_l275:
1F49 7B        ld a, e
1F4A E6 01     and MOD_CTR
1F4C CA 5C 1F  jp z, _l276
1F4F 7A        ld a, d
1F50 C6 10     add ctrLayout
1F52 6F        ld l, a
1F53 CE 1D     adc ctrLayout>>8
1F55 95        sub l
1F56 67        ld h, a
1F57 7E        ld a, (hl)
1F58 CD BF 1E  call KeyPush
1F5B C9        ret
_l276:
1F5C 7A        ld a, d
1F5D C6 70     add shiftLayout
1F5F 6F        ld l, a
1F60 CE 1C     adc shiftLayout>>8
1F62 95        sub l
1F63 67        ld h, a
1F64 3A 6D 1C  ld a, (key_rus)
1F67 B7        or a
1F68 CA 72 1F  jp z, _l277
1F6B 3E 50     ld a, LAYOUT_SIZE
1F6D 85        add l
1F6E 6F        ld l, a
1F6F 8C        adc h
1F70 95        sub l
1F71 67        ld h, a
_l277:
1F72 7E        ld a, (hl)
1F73 26 00     ld h, 0
1F75 87        add a
1F76 D2 8E 1F  jp nc, _l278
1F79 7B        ld a, e
1F7A E6 02     and MOD_SHIFT
1F7C CA 81 1F  jp z, _l279
1F7F 26 50     ld h, LAYOUT_SIZE
_l279:
1F81 7B        ld a, e
1F82 E6 10     and MOD_CAPS
1F84 C2 8B 1F  jp nz, _l280
1F87 3E 50     ld a, LAYOUT_SIZE
1F89 94        sub h
1F8A 67        ld h, a
_l280:
1F8B C3 A9 1F  jp _l281
_l278:
1F8E 87        add a
1F8F D2 9D 1F  jp nc, _l282
1F92 7B        ld a, e
1F93 E6 02     and MOD_SHIFT
1F95 CA 9A 1F  jp z, _l283
1F98 26 50     ld h, LAYOUT_SIZE
_l283:
1F9A C3 A9 1F  jp _l284
_l282:
1F9D 87        add a
1F9E D2 A9 1F  jp nc, _l285
1FA1 7B        ld a, e
1FA2 E6 20     and MOD_NUM
1FA4 C2 A9 1F  jp nz, _l286
1FA7 26 50     ld h, LAYOUT_SIZE
_l281:
_l284:
_l285:
_l286:
1FA9 7A        ld a, d
1FAA 84        add h
1FAB C6 60     add key_layout_table
1FAD 6F        ld l, a
1FAE CE 1D     adc key_layout_table>>8
1FB0 95        sub l
1FB1 67        ld h, a
1FB2 3A 6D 1C  ld a, (key_rus)
1FB5 B7        or a
1FB6 CA C0 1F  jp z, _l287
1FB9 3E A0     ld a, LAYOUT_SIZE*2
1FBB 85        add l
1FBC 6F        ld l, a
1FBD 8C        adc h
1FBE 95        sub l
1FBF 67        ld h, a
_l287:
1FC0 7E        ld a, (hl)
1FC1 FE F4     cp 244
1FC3 DA BF 1E  jp c, KeyPush
1FC6 D6 F2     sub 242
1FC8 47        ld b, a
1FC9 87        add a
1FCA 80        add b
1FCB C6 D4     add special_keys
1FCD 6F        ld l, a
1FCE CE 1E     adc special_keys>>8
1FD0 95        sub l
1FD1 67        ld h, a
1FD2 3E 1B     ld a, 27
1FD4 CD BF 1E  call KeyPush
1FD7 7E        ld a, (hl)
1FD8 CD BF 1E  call KeyPush
1FDB 23        inc hl
1FDC 7E        ld a, (hl)
1FDD CD BF 1E  call KeyPush
1FE0 23        inc hl
1FE1 7E        ld a, (hl)
1FE2 B7        or a
1FE3 C8        ret z
1FE4 7E        ld a, (hl)
1FE5 CD BF 1E  call KeyPush
1FE8 C9        ret
InterruptHandler:
1FE9 DB 04     in a, (PORT_FRAME_IRQ_RESET)
1FEB 0F        rrca
1FEC D8        ret c
1FED D3 04     out (PORT_FRAME_IRQ_RESET), a
1FEF 21 69 1C  ld hl, frame_counter
1FF2 34        inc (hl)
1FF3 3A 01 01  ld a, (cursor_visible)
1FF6 B7        or a
1FF7 CA 21 20  jp z, _l289
1FFA 3A 00 01  ld a, (cursor_blink_counter)
1FFD 3D        dec a
1FFE C2 1E 20  jp nz, _l290
2001 3A 01 01  ld a, (cursor_visible)
2004 EE 02     xor 2
2006 32 01 01  ld (cursor_visible), a
2009 DB 03     in a, (3)
200B F5        push af
200C 3E 01     ld a, 1
200E D3 03     out (3), a
2010 2A 03 01  ld hl, (cursor_y)
2013 CD 85 03  call DrawCursor
2016 F1        pop af
2017 D3 03     out (3), a
2019 3E 23     ld a, CURSOR_BLINK_PERIOD
201B 32 00 01  ld (cursor_blink_counter), a
_l290:
201E 32 00 01  ld (cursor_blink_counter), a
_l289:
2021 3A 6A 1C  ld a, (key_leds)
2024 F6 08     or 8
2026 D3 C0     out (PORT_KEYBOARD), a
2028 DB C0     in a, (PORT_KEYBOARD)
202A E6 08     and 8
202C 3A 6A 1C  ld a, (key_leds)
202F CA 34 20  jp z, _l291
2032 F6 01     or MOD_CTR
_l291:
2034 5F        ld e, a
2035 3A 6A 1C  ld a, (key_leds)
2038 F6 03     or 3
203A D3 C0     out (PORT_KEYBOARD), a
203C DB C0     in a, (PORT_KEYBOARD)
203E E6 08     and 8
2040 CA 47 20  jp z, _l292
2043 3E 02     ld a, MOD_SHIFT
2045 B3        or e
2046 5F        ld e, a
_l292:
2047 06 09     ld b, 9
_l293:
2049 3A 6A 1C  ld a, (key_leds)
204C B0        or b
204D D3 C0     out (PORT_KEYBOARD), a
204F DB C0     in a, (PORT_KEYBOARD)
2051 B7        or a
2052 CA 70 20  jp z, _l296
2055 0E 07     ld c, 7
_l297:
2057 87        add a
2058 D2 6C 20  jp nc, _l300
205B 57        ld d, a
205C 78        ld a, b
205D 87        add a
205E 87        add a
205F 87        add a
2060 81        add c
2061 FE 1B     cp 27
2063 CA 6B 20  jp z, _l301
2066 FE 43     cp 67
2068 C2 FE 1E  jp nz, KeyPressed
_l301:
206B 7A        ld a, d
_l299:
_l300:
206C 0D        dec c
206D F2 57 20  jp p, _l297
_l295:
_l296:
_l298:
2070 05        dec b
2071 F2 49 20  jp p, _l293
_l294:
2074 3E FF     ld a, 255
2076 32 6B 1C  ld (key_pressed), a
2079 C9        ret
207A          PALETTE_WHITE equ 0
207A          PALETTE_CYAN equ 1
207A          PALETTE_MAGENTA equ 2
207A          PALETTE_BLUE equ 3
207A          PALETTE_YELLOW equ 4
207A          PALETTE_GREEN equ 5
207A          PALETTE_RED equ 6
207A          PALETTE_XXX equ 7
207A          PALETTE_GRAY equ 8
207A          PALETTE_DARK_CYAN equ 9
207A          PALETTE_DARK_MAGENTA equ 10
207A          PALETTE_DARK_BLUE equ 11
207A          PALETTE_DARK_YELLOW equ 12
207A          PALETTE_DARK_GREEN equ 13
207A          PALETTE_DARK_RED equ 14
207A          PALETTE_BLACK equ 15
207A          KEY_BACKSPACE equ 8
207A          KEY_TAB equ 9
207A          KEY_ENTER equ 13
207A          KEY_ESC equ 27
207A          KEY_ALT equ 1
207A          KEY_F1 equ 242
207A          KEY_F2 equ 243
207A          KEY_F3 equ 244
207A          KEY_UP equ 245
207A          KEY_DOWN equ 246
207A          KEY_RIGHT equ 247
207A          KEY_LEFT equ 248
207A          KEY_EXT_5 equ 249
207A          KEY_END equ 250
207A          KEY_HOME equ 251
207A          KEY_INSERT equ 252
207A          KEY_DEL equ 253
207A          KEY_PG_UP equ 254
207A          KEY_PG_DN equ 255
207A          PORT_FRAME_IRQ_RESET equ 4
207A          PORT_SD_SIZE equ 9
207A          PORT_SD_RESULT equ 9
207A          PORT_SD_DATA equ 8
207A          PORT_UART_DATA equ 128
207A          PORT_UART_CONFIG equ 129
207A          PORT_UART_STATE equ 129
207A          PORT_EXT_DATA_OUT equ 136
207A          PORT_PALETTE_3 equ 144
207A          PORT_PALETTE_2 equ 145
207A          PORT_PALETTE_1 equ 146
207A          PORT_PALETTE_0 equ 147
207A          PORT_EXT_IN_DATA equ 137
207A          PORT_A0 equ 160
207A          PORT_ROM_0000 equ 168
207A          PORT_ROM_0000__ROM equ 0
207A          PORT_ROM_0000__RAM equ 128
207A          PORT_VIDEO_MODE_1_LOW equ 185
207A          PORT_VIDEO_MODE_1_HIGH equ 249
207A          PORT_VIDEO_MODE_0_LOW equ 184
207A          PORT_VIDEO_MODE_0_HIGH equ 248
207A          PORT_UART_SPEED_0 equ 187
207A          PORT_KEYBOARD equ 192
207A          PORT_UART_SPEED_1 equ 251
207A          PORT_CODE_ROM equ 186
207A          PORT_CHARGEN_ROM equ 250
207A          PORT_TAPE_AND_IDX2 equ 153
207A          PORT_TAPE_AND_IDX2_ID1_2 equ 2
207A          PORT_TAPE_AND_IDX2_ID2_2 equ 4
207A          PORT_TAPE_AND_IDX2_ID3_2 equ 8
207A          PORT_TAPE_AND_IDX2_ID6_2 equ 64
207A          PORT_TAPE_AND_IDX2_ID7_2 equ 128
207A          PORT_RESET_CU1 equ 188
207A          PORT_RESET_CU2 equ 189
207A          PORT_RESET_CU3 equ 190
207A          PORT_RESET_CU4 equ 191
207A          PORT_SET_CU1 equ 252
207A          PORT_SET_CU2 equ 253
207A          PORT_SET_CU3 equ 254
207A          PORT_SET_CU4 equ 255
207A          PORT_TAPE_OUT equ 176
207A          SD_COMMAND_READ equ 1
207A          SD_COMMAND_READ_SIZE equ 5
207A          SD_COMMAND_WRITE equ 2
207A          SD_COMMAND_WRITE_SIZE equ 5+128
207A          SD_RESULT_BUSY equ 255
207A          SD_RESULT_OK equ 0
207A          stack equ 256
207A          entry_cpm_conout_address equ EntryCpmConout+1
207A          cpm_dph_a equ 65376
207A          cpm_dph_b equ 65392
207A          cpm_dma_buffer equ 65408
207A          TEXT_SCREEN_HEIGHT equ 25
207A          FONT_HEIGHT equ 10
207A          FONT_WIDTH equ 3
207A          DrawCharAddress equ DrawChar+1
207A          SetColorAddress equ SetColor+1
207A          DrawCursorAddress equ DrawCursor+1
207A          cpm_load_address equ 58624
207A          CpmEntryPoint equ 64307
main:
207A 3E 00     ld a, 0*2
207C D3 00     out (0), a
207E 3E 02     ld a, 1*2
2080 D3 01     out (1), a
2082 3E 01     ld a, 1
2084 D3 02     out (2), a
2086 3E 01     ld a, 1
2088 D3 03     out (3), a
208A 31 00 01  ld sp, stack
208D CD 3C 01  call ConReset
2090 3E 0B     ld a, PALETTE_DARK_BLUE
2092 D3 90     out (144+(0&3)), a
2094 3E 04     ld a, PALETTE_YELLOW
2096 D3 91     out (144+(1&3)), a
2098 3E 00     ld a, PALETTE_WHITE
209A D3 92     out (144+(2&3)), a
209C 3E 01     ld a, PALETTE_CYAN
209E D3 93     out (144+(3&3)), a
20A0 3E 03     ld a, 3
20A2 CD 82 03  call SetColor
20A5 CD 0D 07  call SetScreenColor
20A8 CD 88 03  call ClearScreen
20AB 0E 00     ld c, 0
20AD 11 00 00  ld de, 0
20B0 21 C0 3C  ld hl, _l303
20B3 CD 85 04  call DrawText
20B6 3E 01     ld a, 1
20B8 CD 82 03  call SetColor
20BB 3E 01     ld a, 1
20BD 32 01 01  ld (cursor_visible), a
CpmWBoot:
20C0 3E 0E     ld a, 7*2
20C2 D3 03     out (3), a
20C4 11 00 E5  ld de, cpm_load_address
20C7 21 DA 20  ld hl, cpm_start
_l305:
20CA 7E        ld a, (hl)
20CB 12        ld (de), a
20CC 23        inc hl
20CD 13        inc de
_l307:
20CE 7A        ld a, d
20CF B7        or a
20D0 C2 CA 20  jp nz, _l305
_l306:
20D3 3A FF 3B  ld a, (drive_number)
20D6 4F        ld c, a
20D7 C3 33 FB  jp CpmEntryPoint
cpm_start:
20DA C3 5C E8  db 195
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
 db 150
 db 251
 db 195
 db 158
 db 251
 db 195
 db 164
 db 251
 db 195
 db 171
 db 251
 db 195
 db 178
 db 251
 db 195
 db 185
 db 251
 db 195
 db 192
 db 251
 db 195
 db 199
 db 251
 db 195
 db 245
 db 251
 db 195
 db 213
 db 251
 db 195
 db 238
 db 251
 db 195
 db 254
 db 251
 db 195
 db 12
 db 252
 db 195
 db 23
 db 252
 db 195
 db 47
 db 252
 db 195
 db 69
 db 252
 db 195
 db 20
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
 db 144
 db 251
 db 49
 db 0
 db 1
 db 175
 db 211
 db 0
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
 db 73
 db 252
 db 213
 db 17
 db 11
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 14
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 17
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 20
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 23
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 26
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 29
 db 0
 db 195
 db 73
 db 252
 db 121
 db 254
 db 2
 db 33
 db 0
 db 0
 db 208
 db 205
 db 206
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
 db 73
 db 252
 db 197
 db 1
 db 0
 db 0
 db 205
 db 238
 db 251
 db 193
 db 201
 db 213
 db 17
 db 35
 db 0
 db 195
 db 73
 db 252
 db 213
 db 17
 db 38
 db 0
 db 195
 db 73
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
 db 5
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
 db 36
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
 db 55
 db 252
 db 225
 db 17
 db 41
 db 0
 db 195
 db 73
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
 db 101
 db 252
 db 175
 db 243
 db 49
 db 0
 db 1
 db 211
 db 0
 db 251
 db 235
 db 197
 db 205
 db 108
 db 252
 db 193
 db 62
 db 8
 db 243
 db 211
 db 0
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
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 139
 db 252
 db 109
 db 252
 db 11
 db 253
 db 75
 db 253
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 0
 db 139
 db 252
 db 124
 db 252
 db 43
 db 253
 db 75
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
3BDA 00        db 0
MulU16:
3BDB 44        ld b, h
3BDC 4D        ld c, l
3BDD 21 00 00  ld hl, 0
3BE0 3E 11     ld a, 17
_l312:
3BE2 3D        dec a
3BE3 C8        ret z
3BE4 29        add hl, hl
3BE5 EB        ex hl, de
3BE6 D2 EE 3B  jp nc, _l313
3BE9 29        add hl, hl
3BEA 23        inc hl
3BEB C3 EF 3B  jp _l314
_l313:
3BEE 29        add hl, hl
_l314:
3BEF EB        ex hl, de
3BF0 D2 E2 3B  jp nc, _l312
3BF3 09        add hl, bc
3BF4 D2 E2 3B  jp nc, _l312
3BF7 13        inc de
3BF8 C3 E2 3B  jp _l312
_l311:
3BFB          PALETTE_WHITE equ 0
3BFB          PALETTE_CYAN equ 1
3BFB          PALETTE_MAGENTA equ 2
3BFB          PALETTE_BLUE equ 3
3BFB          PALETTE_YELLOW equ 4
3BFB          PALETTE_GREEN equ 5
3BFB          PALETTE_RED equ 6
3BFB          PALETTE_XXX equ 7
3BFB          PALETTE_GRAY equ 8
3BFB          PALETTE_DARK_CYAN equ 9
3BFB          PALETTE_DARK_MAGENTA equ 10
3BFB          PALETTE_DARK_BLUE equ 11
3BFB          PALETTE_DARK_YELLOW equ 12
3BFB          PALETTE_DARK_GREEN equ 13
3BFB          PALETTE_DARK_RED equ 14
3BFB          PALETTE_BLACK equ 15
3BFB          KEY_BACKSPACE equ 8
3BFB          KEY_TAB equ 9
3BFB          KEY_ENTER equ 13
3BFB          KEY_ESC equ 27
3BFB          KEY_ALT equ 1
3BFB          KEY_F1 equ 242
3BFB          KEY_F2 equ 243
3BFB          KEY_F3 equ 244
3BFB          KEY_UP equ 245
3BFB          KEY_DOWN equ 246
3BFB          KEY_RIGHT equ 247
3BFB          KEY_LEFT equ 248
3BFB          KEY_EXT_5 equ 249
3BFB          KEY_END equ 250
3BFB          KEY_HOME equ 251
3BFB          KEY_INSERT equ 252
3BFB          KEY_DEL equ 253
3BFB          KEY_PG_UP equ 254
3BFB          KEY_PG_DN equ 255
3BFB          PORT_FRAME_IRQ_RESET equ 4
3BFB          PORT_SD_SIZE equ 9
3BFB          PORT_SD_RESULT equ 9
3BFB          PORT_SD_DATA equ 8
3BFB          PORT_UART_DATA equ 128
3BFB          PORT_UART_CONFIG equ 129
3BFB          PORT_UART_STATE equ 129
3BFB          PORT_EXT_DATA_OUT equ 136
3BFB          PORT_PALETTE_3 equ 144
3BFB          PORT_PALETTE_2 equ 145
3BFB          PORT_PALETTE_1 equ 146
3BFB          PORT_PALETTE_0 equ 147
3BFB          PORT_EXT_IN_DATA equ 137
3BFB          PORT_A0 equ 160
3BFB          PORT_ROM_0000 equ 168
3BFB          PORT_ROM_0000__ROM equ 0
3BFB          PORT_ROM_0000__RAM equ 128
3BFB          PORT_VIDEO_MODE_1_LOW equ 185
3BFB          PORT_VIDEO_MODE_1_HIGH equ 249
3BFB          PORT_VIDEO_MODE_0_LOW equ 184
3BFB          PORT_VIDEO_MODE_0_HIGH equ 248
3BFB          PORT_UART_SPEED_0 equ 187
3BFB          PORT_KEYBOARD equ 192
3BFB          PORT_UART_SPEED_1 equ 251
3BFB          PORT_CODE_ROM equ 186
3BFB          PORT_CHARGEN_ROM equ 250
3BFB          PORT_TAPE_AND_IDX2 equ 153
3BFB          PORT_TAPE_AND_IDX2_ID1_2 equ 2
3BFB          PORT_TAPE_AND_IDX2_ID2_2 equ 4
3BFB          PORT_TAPE_AND_IDX2_ID3_2 equ 8
3BFB          PORT_TAPE_AND_IDX2_ID6_2 equ 64
3BFB          PORT_TAPE_AND_IDX2_ID7_2 equ 128
3BFB          PORT_RESET_CU1 equ 188
3BFB          PORT_RESET_CU2 equ 189
3BFB          PORT_RESET_CU3 equ 190
3BFB          PORT_RESET_CU4 equ 191
3BFB          PORT_SET_CU1 equ 252
3BFB          PORT_SET_CU2 equ 253
3BFB          PORT_SET_CU3 equ 254
3BFB          PORT_SET_CU4 equ 255
3BFB          PORT_TAPE_OUT equ 176
3BFB          SD_COMMAND_READ equ 1
3BFB          SD_COMMAND_READ_SIZE equ 5
3BFB          SD_COMMAND_WRITE equ 2
3BFB          SD_COMMAND_WRITE_SIZE equ 5+128
3BFB          SD_RESULT_BUSY equ 255
3BFB          SD_RESULT_OK equ 0
3BFB          stack equ 256
3BFB          entry_cpm_conout_address equ EntryCpmConout+1
3BFB          cpm_dph_a equ 65376
3BFB          cpm_dph_b equ 65392
3BFB          cpm_dma_buffer equ 65408
CpmList:
3BFB C9        ret
CpmPrSta:
3BFC 16 00     ld d, 0
3BFE C9        ret
3BFF          PALETTE_WHITE equ 0
3BFF          PALETTE_CYAN equ 1
3BFF          PALETTE_MAGENTA equ 2
3BFF          PALETTE_BLUE equ 3
3BFF          PALETTE_YELLOW equ 4
3BFF          PALETTE_GREEN equ 5
3BFF          PALETTE_RED equ 6
3BFF          PALETTE_XXX equ 7
3BFF          PALETTE_GRAY equ 8
3BFF          PALETTE_DARK_CYAN equ 9
3BFF          PALETTE_DARK_MAGENTA equ 10
3BFF          PALETTE_DARK_BLUE equ 11
3BFF          PALETTE_DARK_YELLOW equ 12
3BFF          PALETTE_DARK_GREEN equ 13
3BFF          PALETTE_DARK_RED equ 14
3BFF          PALETTE_BLACK equ 15
3BFF          KEY_BACKSPACE equ 8
3BFF          KEY_TAB equ 9
3BFF          KEY_ENTER equ 13
3BFF          KEY_ESC equ 27
3BFF          KEY_ALT equ 1
3BFF          KEY_F1 equ 242
3BFF          KEY_F2 equ 243
3BFF          KEY_F3 equ 244
3BFF          KEY_UP equ 245
3BFF          KEY_DOWN equ 246
3BFF          KEY_RIGHT equ 247
3BFF          KEY_LEFT equ 248
3BFF          KEY_EXT_5 equ 249
3BFF          KEY_END equ 250
3BFF          KEY_HOME equ 251
3BFF          KEY_INSERT equ 252
3BFF          KEY_DEL equ 253
3BFF          KEY_PG_UP equ 254
3BFF          KEY_PG_DN equ 255
3BFF          PORT_FRAME_IRQ_RESET equ 4
3BFF          PORT_SD_SIZE equ 9
3BFF          PORT_SD_RESULT equ 9
3BFF          PORT_SD_DATA equ 8
3BFF          PORT_UART_DATA equ 128
3BFF          PORT_UART_CONFIG equ 129
3BFF          PORT_UART_STATE equ 129
3BFF          PORT_EXT_DATA_OUT equ 136
3BFF          PORT_PALETTE_3 equ 144
3BFF          PORT_PALETTE_2 equ 145
3BFF          PORT_PALETTE_1 equ 146
3BFF          PORT_PALETTE_0 equ 147
3BFF          PORT_EXT_IN_DATA equ 137
3BFF          PORT_A0 equ 160
3BFF          PORT_ROM_0000 equ 168
3BFF          PORT_ROM_0000__ROM equ 0
3BFF          PORT_ROM_0000__RAM equ 128
3BFF          PORT_VIDEO_MODE_1_LOW equ 185
3BFF          PORT_VIDEO_MODE_1_HIGH equ 249
3BFF          PORT_VIDEO_MODE_0_LOW equ 184
3BFF          PORT_VIDEO_MODE_0_HIGH equ 248
3BFF          PORT_UART_SPEED_0 equ 187
3BFF          PORT_KEYBOARD equ 192
3BFF          PORT_UART_SPEED_1 equ 251
3BFF          PORT_CODE_ROM equ 186
3BFF          PORT_CHARGEN_ROM equ 250
3BFF          PORT_TAPE_AND_IDX2 equ 153
3BFF          PORT_TAPE_AND_IDX2_ID1_2 equ 2
3BFF          PORT_TAPE_AND_IDX2_ID2_2 equ 4
3BFF          PORT_TAPE_AND_IDX2_ID3_2 equ 8
3BFF          PORT_TAPE_AND_IDX2_ID6_2 equ 64
3BFF          PORT_TAPE_AND_IDX2_ID7_2 equ 128
3BFF          PORT_RESET_CU1 equ 188
3BFF          PORT_RESET_CU2 equ 189
3BFF          PORT_RESET_CU3 equ 190
3BFF          PORT_RESET_CU4 equ 191
3BFF          PORT_SET_CU1 equ 252
3BFF          PORT_SET_CU2 equ 253
3BFF          PORT_SET_CU3 equ 254
3BFF          PORT_SET_CU4 equ 255
3BFF          PORT_TAPE_OUT equ 176
3BFF          SD_COMMAND_READ equ 1
3BFF          SD_COMMAND_READ_SIZE equ 5
3BFF          SD_COMMAND_WRITE equ 2
3BFF          SD_COMMAND_WRITE_SIZE equ 5+128
3BFF          SD_RESULT_BUSY equ 255
3BFF          SD_RESULT_OK equ 0
3BFF          stack equ 256
3BFF          entry_cpm_conout_address equ EntryCpmConout+1
3BFF          cpm_dph_a equ 65376
3BFF          cpm_dph_b equ 65392
3BFF          cpm_dma_buffer equ 65408
drive_number:
3BFF 00        db 0
drive_track:
3C00 00 00     dw 0
drive_sector:
3C02 00        db 0
drive_dpb:
3C03 60 FF     dw cpm_dph_a
WaitSd:
_l322:
3C05 DB 09     in a, (PORT_SD_RESULT)
_l324:
3C07 FE FF     cp SD_RESULT_BUSY
3C09 CA 05 3C  jp z, _l322
_l323:
3C0C C9        ret
CpmSelDsk:
3C0D CD 05 3C  call WaitSd
3C10 3E 05     ld a, SD_COMMAND_READ_SIZE
3C12 D3 09     out (PORT_SD_SIZE), a
3C14 3E 01     ld a, SD_COMMAND_READ
3C16 D3 08     out (PORT_SD_DATA), a
3C18 79        ld a, c
3C19 3C        inc a
3C1A D3 08     out (PORT_SD_DATA), a
3C1C AF        xor a
3C1D D3 08     out (PORT_SD_DATA), a
3C1F D3 08     out (PORT_SD_DATA), a
3C21 D3 08     out (PORT_SD_DATA), a
3C23 D3 08     out (PORT_SD_DATA), a
3C25 CD 05 3C  call WaitSd
3C28 B7        or a
3C29 CA 2E 3C  jp z, _l326
3C2C 57        ld d, a
3C2D C9        ret
_l326:
3C2E 79        ld a, c
3C2F 2A 6A FF  ld hl, (cpm_dph_a+10)
3C32 FE 01     cp 1
3C34 C2 3A 3C  jp nz, _l327
3C37 2A 7A FF  ld hl, (cpm_dph_b+10)
_l327:
3C3A 32 FF 3B  ld (drive_number), a
3C3D 22 03 3C  ld (drive_dpb), hl
3C40 06 0F     ld b, 15
_l328:
3C42 DB 08     in a, (PORT_SD_DATA)
3C44 77        ld (hl), a
3C45 23        inc hl
_l330:
3C46 05        dec b
3C47 C2 42 3C  jp nz, _l328
_l329:
3C4A 16 00     ld d, 0
3C4C C9        ret
CpmSetTrk:
3C4D 60        ld h, b
3C4E 69        ld l, c
3C4F 22 00 3C  ld (drive_track), hl
3C52 C9        ret
CpmSetSec:
3C53 79        ld a, c
3C54 32 02 3C  ld (drive_sector), a
3C57 C9        ret
ReadWriteSd:
3C58 CD 05 3C  call WaitSd
3C5B 78        ld a, b
3C5C D3 09     out (PORT_SD_SIZE), a
3C5E 79        ld a, c
3C5F D3 08     out (PORT_SD_DATA), a
3C61 3A FF 3B  ld a, (drive_number)
3C64 3C        inc a
3C65 D3 08     out (PORT_SD_DATA), a
3C67 2A 03 3C  ld hl, (drive_dpb)
3C6A 5E        ld e, (hl)
3C6B 23        inc hl
3C6C 56        ld d, (hl)
3C6D 2A 00 3C  ld hl, (drive_track)
3C70 CD DB 3B  call MulU16
3C73 06 00     ld b, 0
3C75 3A 02 3C  ld a, (drive_sector)
3C78 4F        ld c, a
3C79 09        add hl, bc
3C7A D2 7E 3C  jp nc, _l334
3C7D 13        inc de
_l334:
3C7E 7D        ld a, l
3C7F D3 08     out (PORT_SD_DATA), a
3C81 7C        ld a, h
3C82 D3 08     out (PORT_SD_DATA), a
3C84 7B        ld a, e
3C85 D3 08     out (PORT_SD_DATA), a
3C87 7A        ld a, d
3C88 D3 08     out (PORT_SD_DATA), a
3C8A C9        ret
CpmRead:
3C8B 01 01 05  ld bc, SD_COMMAND_READ_SIZE<<8|SD_COMMAND_READ
3C8E CD 58 3C  call ReadWriteSd
3C91 CD 05 3C  call WaitSd
3C94 B7        or a
3C95 CA 9A 3C  jp z, _l336
3C98 57        ld d, a
3C99 C9        ret
_l336:
3C9A 21 80 FF  ld hl, cpm_dma_buffer
_l337:
3C9D DB 08     in a, (PORT_SD_DATA)
3C9F 77        ld (hl), a
3CA0 2C        inc l
_l339:
3CA1 C2 9D 3C  jp nz, _l337
_l338:
3CA4 16 00     ld d, 0
3CA6 C9        ret
CpmWrite:
3CA7 01 02 85  ld bc, SD_COMMAND_WRITE_SIZE<<8|SD_COMMAND_WRITE
3CAA CD 58 3C  call ReadWriteSd
3CAD 21 80 FF  ld hl, cpm_dma_buffer
_l341:
3CB0 7E        ld a, (hl)
3CB1 D3 08     out (PORT_SD_DATA), a
3CB3 2C        inc l
_l343:
3CB4 C2 B0 3C  jp nz, _l341
_l342:
3CB7 CD 05 3C  call WaitSd
3CBA 57        ld d, a
3CBB C9        ret
3CBC          PALETTE_WHITE equ 0
3CBC          PALETTE_CYAN equ 1
3CBC          PALETTE_MAGENTA equ 2
3CBC          PALETTE_BLUE equ 3
3CBC          PALETTE_YELLOW equ 4
3CBC          PALETTE_GREEN equ 5
3CBC          PALETTE_RED equ 6
3CBC          PALETTE_XXX equ 7
3CBC          PALETTE_GRAY equ 8
3CBC          PALETTE_DARK_CYAN equ 9
3CBC          PALETTE_DARK_MAGENTA equ 10
3CBC          PALETTE_DARK_BLUE equ 11
3CBC          PALETTE_DARK_YELLOW equ 12
3CBC          PALETTE_DARK_GREEN equ 13
3CBC          PALETTE_DARK_RED equ 14
3CBC          PALETTE_BLACK equ 15
3CBC          KEY_BACKSPACE equ 8
3CBC          KEY_TAB equ 9
3CBC          KEY_ENTER equ 13
3CBC          KEY_ESC equ 27
3CBC          KEY_ALT equ 1
3CBC          KEY_F1 equ 242
3CBC          KEY_F2 equ 243
3CBC          KEY_F3 equ 244
3CBC          KEY_UP equ 245
3CBC          KEY_DOWN equ 246
3CBC          KEY_RIGHT equ 247
3CBC          KEY_LEFT equ 248
3CBC          KEY_EXT_5 equ 249
3CBC          KEY_END equ 250
3CBC          KEY_HOME equ 251
3CBC          KEY_INSERT equ 252
3CBC          KEY_DEL equ 253
3CBC          KEY_PG_UP equ 254
3CBC          KEY_PG_DN equ 255
3CBC          PORT_FRAME_IRQ_RESET equ 4
3CBC          PORT_SD_SIZE equ 9
3CBC          PORT_SD_RESULT equ 9
3CBC          PORT_SD_DATA equ 8
3CBC          PORT_UART_DATA equ 128
3CBC          PORT_UART_CONFIG equ 129
3CBC          PORT_UART_STATE equ 129
3CBC          PORT_EXT_DATA_OUT equ 136
3CBC          PORT_PALETTE_3 equ 144
3CBC          PORT_PALETTE_2 equ 145
3CBC          PORT_PALETTE_1 equ 146
3CBC          PORT_PALETTE_0 equ 147
3CBC          PORT_EXT_IN_DATA equ 137
3CBC          PORT_A0 equ 160
3CBC          PORT_ROM_0000 equ 168
3CBC          PORT_ROM_0000__ROM equ 0
3CBC          PORT_ROM_0000__RAM equ 128
3CBC          PORT_VIDEO_MODE_1_LOW equ 185
3CBC          PORT_VIDEO_MODE_1_HIGH equ 249
3CBC          PORT_VIDEO_MODE_0_LOW equ 184
3CBC          PORT_VIDEO_MODE_0_HIGH equ 248
3CBC          PORT_UART_SPEED_0 equ 187
3CBC          PORT_KEYBOARD equ 192
3CBC          PORT_UART_SPEED_1 equ 251
3CBC          PORT_CODE_ROM equ 186
3CBC          PORT_CHARGEN_ROM equ 250
3CBC          PORT_TAPE_AND_IDX2 equ 153
3CBC          PORT_TAPE_AND_IDX2_ID1_2 equ 2
3CBC          PORT_TAPE_AND_IDX2_ID2_2 equ 4
3CBC          PORT_TAPE_AND_IDX2_ID3_2 equ 8
3CBC          PORT_TAPE_AND_IDX2_ID6_2 equ 64
3CBC          PORT_TAPE_AND_IDX2_ID7_2 equ 128
3CBC          PORT_RESET_CU1 equ 188
3CBC          PORT_RESET_CU2 equ 189
3CBC          PORT_RESET_CU3 equ 190
3CBC          PORT_RESET_CU4 equ 191
3CBC          PORT_SET_CU1 equ 252
3CBC          PORT_SET_CU2 equ 253
3CBC          PORT_SET_CU3 equ 254
3CBC          PORT_SET_CU4 equ 255
3CBC          PORT_TAPE_OUT equ 176
3CBC          SD_COMMAND_READ equ 1
3CBC          SD_COMMAND_READ_SIZE equ 5
3CBC          SD_COMMAND_WRITE equ 2
3CBC          SD_COMMAND_WRITE_SIZE equ 5+128
3CBC          SD_RESULT_BUSY equ 255
3CBC          SD_RESULT_OK equ 0
3CBC          stack equ 256
3CBC          entry_cpm_conout_address equ EntryCpmConout+1
3CBC          cpm_dph_a equ 65376
3CBC          cpm_dph_b equ 65392
3CBC          cpm_dma_buffer equ 65408
CpmPunch:
3CBC C9        ret
CpmReader:
3CBD 16 00     ld d, 0
3CBF C9        ret
3CC0          ; Const strings
_l303:
3CC0 88 E1 AA  db 136
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
3CCE 00 00 00  align 128
file_end:
3D00 00 00 00  savebin "boot.cpm", 0, $
