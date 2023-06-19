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
0000          KEY_UP equ 242
0000          KEY_DOWN equ 243
0000          KEY_RIGHT equ 244
0000          KEY_LEFT equ 245
0000          KEY_EXT_5 equ 246
0000          KEY_END equ 247
0000          KEY_HOME equ 248
0000          KEY_INSERT equ 249
0000          KEY_DEL equ 250
0000          KEY_PG_UP equ 251
0000          KEY_PG_DN equ 252
0000          KEY_F1 equ 253
0000          KEY_F2 equ 254
0000          KEY_F3 equ 255
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
0000          SD_COMMAND_WRITE equ 2
0000          SD_RESULT_BUSY equ 255
0000          SD_RESULT_OK equ 0
0000          Start equ 0
0000          info_size_l equ 3
0000          info_size_h equ 4
0000           org 0
0000 00 00 00  org 49152
Entry:
C000 F3        di
C001 3E 0F     ld a, 3+3*4
C003 D3 00     out (0), a
C005 D3 03     out (3), a
C007 C3 0A C0  jp Entry2
Entry2:
C00A D3 B8     out (PORT_VIDEO_MODE_0_LOW), a
C00C D3 B9     out (PORT_VIDEO_MODE_1_LOW), a
C00E 3E 0B     ld a, PALETTE_DARK_BLUE
C010 D3 90     out (144+(0&3)), a
C012 D3 91     out (144+(1&3)), a
C014 D3 92     out (144+(2&3)), a
C016 D3 93     out (144+(3&3)), a
C018 3E 00     ld a, 0*2
C01A D3 00     out (0), a
C01C 3E 02     ld a, 1*2
C01E D3 01     out (1), a
C020 3E 04     ld a, 2*2
C022 D3 02     out (2), a
_l2:
C024 DB 09     in a, (PORT_SD_RESULT)
_l4:
C026 FE FF     cp SD_RESULT_BUSY
C028 CA 24 C0  jp z, _l2
_l3:
C02B 11 00 00  ld de, Start
C02E 21 00 00  ld hl, 0
_l8:
_l5:
C031 3E 05     ld a, 5
C033 D3 09     out (PORT_SD_SIZE), a
C035 3E 01     ld a, SD_COMMAND_READ
C037 D3 08     out (PORT_SD_DATA), a
C039 AF        xor a
C03A D3 08     out (PORT_SD_DATA), a
C03C 7D        ld a, l
C03D D3 08     out (PORT_SD_DATA), a
C03F 7C        ld a, h
C040 D3 08     out (PORT_SD_DATA), a
C042 AF        xor a
C043 D3 08     out (PORT_SD_DATA), a
C045 D3 08     out (PORT_SD_DATA), a
_l11:
C047 DB 09     in a, (PORT_SD_RESULT)
_l13:
C049 FE FF     cp SD_RESULT_BUSY
C04B CA 47 C0  jp z, _l11
_l12:
C04E FE 00     cp SD_RESULT_OK
C050 C2 0A C0  jp nz, Entry2
C053 0E 80     ld c, 128
_l14:
C055 DB 08     in a, (PORT_SD_DATA)
C057 12        ld (de), a
C058 13        inc de
_l16:
C059 0D        dec c
C05A C2 55 C0  jp nz, _l14
_l15:
C05D 23        inc hl
_l10:
C05E 3A 03 00  ld a, (info_size_l)
C061 BD        cp l
C062 C2 31 C0  jp nz, _l8
_l7:
_l9:
C065 3A 04 00  ld a, (info_size_h)
C068 BC        cp h
C069 C2 31 C0  jp nz, _l5
_l6:
C06C C3 00 00  jp Start
C06F 00 00 00  savebin "loader.bin", 0, 65536
