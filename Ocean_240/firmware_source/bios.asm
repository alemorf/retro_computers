; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL

.include "config.inc"

; Размеры виртуального диска

#define RAM_DISK_SIZE_KB ((CONFIG_RAM_SIZE_KB) - 64)
#ifdef CONFIG_ROM_DISK
#define ROM_DISK_SIZE_KB 48
#else
#define ROM_DISK_SIZE_KB 0
#endif

; Константы

CMP_CCP = 0B200h
v_ccp_command_line_buffer = CMP_CCP + 07CEh
CPM_SECTOR_BUFFER_SIZE = 80h
CPM_CCP = 0B200h
CPM_CCP_SIZE = 2057
DPH_SIZE = 16
DPB_SIZE = 15
DISK_COUNT = 3
MAX_FILES_COUNT = 128
RAM_FILES_COUNT = 32
REAL_SECTOR_PER_TRACK = 9
RAM_DISK_BLOCK_SIZE = 1024
TEXT_LINE_HEIGHT = 10
TEXT_LINES = 25
SCREEN_MODE_CURSOR_MASK = 4

; Порты ввода-вывода

PORT_VG93_COMMAND    = 20h
PORT_VG93_TRACK      = 21h
PORT_VG93_SECTOR     = 22h
PORT_VG93_DATA       = 23h
PORT_FLOPPY_WAIT     = 24h
PORT_FLOPPY          = 25h
PORT_KEY_IN          = 40h
PORT_TAPE_IN         = 41h
PORT_KEY_OUT         = 42h
PORT_KEY_CONFIG      = 43h
PORT_TIMER_0         = 60h
PORT_TIMER_1         = 61h
PORT_TIMER_2         = 62h
PORT_TIMER_CONTROL   = 63h
PORT_INT             = 80h
PORT_INT_1           = 81h
PORT_UART_DATA       = 0A0h
PORT_UART_CONTROL    = 0A1h
PORT_SCROLL_Y        = 0C0h
PORT_MAPPER          = 0C1h
PORT_SCROLL_X        = 0C2h
PORT_C3_V55_CONTROL  = 0C3h
PORT_PRINTER_DATA    = 0E0h
PORT_COLOR           = 0E1h
PORT_PRINTER_CONTROL = 0E2h
PORT_E3_V55_CONFIG   = 0E3h

; Биты конфигурации КР580ВВ55А

VV55_CONFIG = 1 << 7
VV55_A_IN   = 1 << 4
VV55_A_OUT  = 0
VV55_B_IN   = 1 << 1
VV55_B_OUT  = 0
VV55_CL_IN  = 1 << 0
VV55_CL_OUT = 0
VV55_CH_IN  = 1 << 3
VV55_CH_OUT = 0

; Биты PORT_FLOPPY на запись

PFE_MOTOR_0      = 1 << 0
PFE_MOTOR_1      = 1 << 1
PFE_DRIVE_SELECT = 1 << 2
PFE_NEG_INIT     = 1 << 3
PFE_NEG_DDEN     = 1 << 4
PFE_SIDE_SELECT  = 1 << 5
PFE_READ_MASK    = PFE_SIDE_SELECT | PFE_MOTOR_0 | PFE_MOTOR_1

; Биты контроллера прерываний

KEY_INT_MASK      = 1 << 1
PRINTER_INT_MASK  = 1 << 3
TIMER_INT_MASK    = 1 << 4

; Переменные

v_current_disk            = 4   ; байт
v_disk_1_tracks           = 42h ; байт, кол-во дорожек на одной стороне диска C:
v_c_360_720               = 43h ; Замена диска С: 360 кБ <-> 720 кБ
v_sector_128_interleave_c = 44h
v_cpm_sector_buffer       = 80h


v_dup_printer                = 0BA0Ch
v_cpm_disk                   = 0BA41h
v_saved_stack                = 0BA9Ch
v_safe_stack                 = 0BAB4h
v_dph                        = 0BADEh
v_sector_128_interleave_b    = 0BB0Eh
v_dpb_a                      = 0BB17h
v_dpb_b                      = 0BB26h
v_dpb_c                      = 0BB35h
v_disk                       = 0BB44h
v_dma                        = 0BB45h ; word
v_track                      = 0BB47h
v_sector_128                 = 0BB48h
v_slicer_disk                = 0BB49h
v_slicer_track               = 0BB4Ah
v_slicer_real_sector         = 0BB4Bh
v_tmp_slicer_real_sector     = 0BB4Ch
v_slicer_has_data            = 0BB4Dh
v_slicer_need_save           = 0BB4Eh
v_slicer_uninited_count      = 0BB4Fh
v_slicer_uninited_disk       = 0BB50h
v_slicer_uninited_track      = 0BB51h
v_slicer_uninited_sector_128 = 0BB52h
v_tmp_slicer_result          = 0BB53h
v_tmp_slicer_can_read        = 0BB54h
v_tmp_slicer_operation       = 0BB55h
v_tmp_slicer_flush           = 0BB56h
v_dir_buf                    = 0BB57h
v_alv_a                      = 0BBD7h ; 31 байт или 248 блоков
v_csv_a                      = 0BBF6h ; 16
v_alv_b                      = 0BC06h ; 45
v_csv_b                      = 0BC33h ; 32
v_alv_c                      = 0BC53h ; 45
v_csv_c                      = 0BC80h ; 32
v_slicer_buffer              = 0BD00h ; - 0BEFFh
v_buffer_128                 = 0BF00h ; - 0BF7Fh
v_safe_stack_2               = 0BFA4h
v_tmp_right_mask             = 0BFCFh

v_esc_mode             = 0BFD3h
v_esc_command          = 0BFD4h
v_esc_count            = 0BFD5h
v_arg_0                = 0BFD6h
v_arg_1                = 0BFD7h
v_arg_2                = 0BFD8h
v_arg_3                = 0BFD9h
v_arg_4                = 0BFDAh
v_arg_5                = 0BFDBh
v_arg_6                = 0BFDCh
v_tmp_neg_left_mask    = 0BFDDh
v_tmp_neg_right_mask   = 0BFDEh
v_tmp_left_mask        = 0BFDFh
v_screen_mode          = 0BFE0h
v_cursor_position      = 0BFE1h
v_color                = 0BFE3h
v_scroll_y             = 0BFE5h
v_codepage             = 0BFE6h
v_palette              = 0BFE7h
v_beep_period          = 0BFE8h
v_beep_duration        = 0BFEAh
v_scroll_x             = 0BFECh
v_printer_control      = 0BFEDh
v_tmp_printer_x        = 0BFEEh
v_floppy_0_inited      = 0BFEFh
v_floppy_1_inited      = 0BFF0h
v_floppy_current       = 0BFF1h
v_floppy_0_track       = 0BFF2h
v_floppy_1_track       = 0BFF3h
v_floppy_direction     = 0BFF4h
v_game_sprites         = 0BFF7h
v_get_color            = 0BFF8h

; Неопределенные переменные

byte_3 = 3
byte_5 = 5
ccp_ram_BA09 = 0BA09h
ccp_ram_B200 = 0B200h
word_BA42 = 0BA42h
word_BA44 = 0BA44h
byte_BA70 = 0BA70h
word_BA0E = 0BA0Eh
v_a = 0BFF5h
byte_BFF6 = 0BFF6h
byte_BA78 = 0BA78h
byte_BA0D = 0BA0Dh
byte_BA7A = 0BA7Ah
byte_BA0A = 0BA0Ah
byte_BA0B = 0BA0Bh
word_BA81 = 0BA81h
byte_BA5E = 0BA5Eh
byte_BA7D = 0BA7Dh
word_BA7F = 0BA7Fh
v_tmp_x1 = 0BFC5h
v_tmp_mode = 0BFC6h
v_tmp_x = 0BFC7h
v_tmp_y = 0BFC8h
byte_BFC9 = 0BFC9h
word_BA4D = 0BA4Dh
word_BA4F = 0BA4Fh
word_BA51 = 0BA51h
word_BA55 = 0BA55h
word_BA60 = 0BA60h
word_BA6A = 0BA6Ah
v_tmp_saved_color = 0BFD0h
v_tmp_paint_y = 0BFCAh
byte_BFCB = 0BFCBh
v_tmp_saved_sp = 0BFCDh
word_BA84 = 0BA84h
word_BA86 = 0BA86h
word_BA5B = 0BA5Bh
word_BA68 = 0BA68h
byte_BA5D = 0BA5Dh
byte_BA7C = 0BA7Ch
byte_BA77 = 0BA77h
byte_BA7B = 0BA7Bh
byte_BA5F = 0BA5Fh
byte_BA6F = 0BA6Fh
word_BA53 = 0BA53h
word_BA47 = 0BA47h
word_BA62 = 0BA62h
byte_BA83 = 0BA83h
word_BA66 = 0BA66h
word_BA57 = 0BA57h
word_BA4B = 0BA4Bh
word_BA59 = 0BA59h
word_BA64 = 0BA64h
byte_BA40 = 0BA40h
byte_BA6E = 0BA6Eh
byte_BA72 = 0BA72h
word_BA73 = 0BA73h
byte_BA6C = 0BA6Ch
byte_BA46 = 0BA46h
byte_BA6D = 0BA6Dh
byte_BA71 = 0BA71h
word_BA49 = 0BA49h
byte_BA79 = 0BA79h
v_tmp_sdir_total = 0BA9Ah
byte_BAB6 = 0BAB6h
v_tmp_compare_color = 0BFCCh
byte_BAD6 = 0BAD6h
v_tmp_file_name = 0BAB7h
v_stack = 0BFC4h
byte_BA41 = 0BA41h

    .org 0C000h

    .include "cpm.inc"

;----------------------------------------------------------------------------
; Точки входа CP/M BIOS

    .org 0D600h

BiosBoot:       jmp BiosBoot2
BiosWBoot:      jmp BiosWBoot2
BiosConst:      jmp BiosConst2
BiosConin:      jmp BiosConin2
BiosConout:     jmp BiosConout2
BiosList:       jmp BiosList2
BiosPunch:      jmp BiosPunch2
BiosReader:     jmp BiosReader2
BiosHome:       jmp BiosHome2
BiosSelDsk:     jmp BiosSelDsk2
BiosSetTrk:     jmp BiosSetTrk2
BiosSetSec:     jmp BiosSetSec2
BiosSetDma:     jmp BiosSetDma2
BiosRead:       jmp BiosRead2
BiosWrite:      jmp BiosWrite2
BiosPrStat:     jmp BiosPrStat2
BiosSecTrn:     jmp BiosSecTrn2
                jmp 0
                jmp 0
TapeReadBlock:  jmp TapeReadBlock2
TapeWriteBlock: jmp TapeWriteBlock2
WaitTapePause:  jmp WaitTapePause2
                jmp 0

; Конфигурация
cfg_disk_a_size:   .dw RAM_DISK_SIZE_KB + ROM_DISK_SIZE_KB
cfg_disk_b_size:   .dw 720
cfg_disk_c_size:   .dw 720
cfg_disk_0_tracks: .db 80
cfg_disk_c_tracks: .db 80

.include "biosboot.inc"
.include "bioswboot.inc"
.include "memcpyhldec.inc"
.include "biosprstat2.inc"
.include "biosseldsk2.inc"
.include "bioshome2settrk2.inc"
.include "biossetsec2.inc"
.include "biossetdma2.inc"
.include "biossettrn2.inc"
.include "biosread2write2.inc"
.include "slicer.inc"
.include "printstring2.inc"
.include "init3.inc"

; Таблицы паметров дисков (DPB)

dpb_192: .dw 16                  ; Sector per track
         .db 3                   ; Block shift: 3 -> 1k
         .db 7                   ; Block mask, 7 -> 1k
         .db 0                   ; Extent mask
         .dw RAM_DISK_SIZE_KB + ROM_DISK_SIZE_KB - 1 ; Blocks count - 1
         .dw RAM_FILES_COUNT - 1 ; Dir size - 1
         .dw 80h                 ; Dir bitmap  TODO: Вычисляется из dir size и block size
         .dw RAM_FILES_COUNT / 4 ; Checksum vector size
         .dw 0                   ; Reserved tracks

dpb_ff:  .dw -1                  ; Sector per track
         .db -1                  ; Block shift: 3 -> 1k
         .db -1                  ; Block mask, 7 -> 1k
         .db -1                  ; Extent mask
         .dw -1                  ; Blocks count - 1
         .dw -1                  ; Dir size - 1
         .dw -1                  ; Dir bitmap
         .dw -1                  ; Checksum vector size
         .dw -1                  ; Reserved tracks

dpb_720: .dw 36                  ; Sector per track
         .db 4                   ; Block shift, 4 -> 2k
         .db 0Fh                 ; Block mask, 0Fh -> 2k
         .db 0                   ; Extent mask
         .dw 360 - 1             ; Block count - 1
         .dw MAX_FILES_COUNT - 1 ; Dir size
         .dw 0C0h                ; Dir bitmap  TODO: Вычисляется из dir size и block size
         .dw MAX_FILES_COUNT / 4 ; Checksum vector size
         .dw 0                   ; Reserved tracks

dpb_360: .dw 36                  ; Sector per track
         .db 4                   ; Block shift, 4 => 2k
         .db 0Fh                 ; Block mask, 0Fh -> 2k
         .db 1                   ; Extent mask
         .dw 180 - 1             ; Block count - 1
         .dw MAX_FILES_COUNT - 1 ; Dir size
         .dw 0C0h                ; Dir bitmap  TODO: Вычисляется из dir size и block size
         .dw MAX_FILES_COUNT / 4 ; Checksum vector size
         .dw 0                   ; Reserved tracks

MAGIC_40 = 0AAAAh

rom_40:  .dw MAGIC_40
         .db 0, 0FFh

sector_interleave_c:
         .db 1, 8, 6, 4, 2, 9, 7, 5, 3

dph:    .dw 0, 0, 0, 0, v_dir_buf, v_dpb_a, v_csv_a, v_alv_a ; Диск A:
        .dw 0, 0, 0, 0, v_dir_buf, v_dpb_b, v_csv_b, v_alv_b ; Диск B:
        .dw 0, 0, 0, 0, v_dir_buf, v_dpb_c, v_csv_c, v_alv_c ; Диск C:

sector_interleave_b:
        .db 1, 8, 6, 4, 2, 9, 7, 5, 3

#ifndef CONFIG_NO_DEAD_CODE
        .db 00Eh, 3
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh
#endif

.org 0DB00h

.include "ccpcommands.inc"
.include "ccpsdir.inc"
.include "ccpread.inc"
.include "printstring3.inc"
.include "ccpread2.inc"
.include "ccpwrite.inc"

#ifndef CONFIG_NO_DEAD_CODE
        .db 04Ch
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh
        .db 0AAh
#endif

.org 0E000h

                 jmp Init
                 jmp PrintHexByte
BiosConst2:      jmp KeyCheck
BiosConin2:      jmp KeyRead
BiosConout2:     jmp PrintChar
BiosReader2:     jmp UartRead
BiosPunch2:      jmp UartWrite
BiosList2:       jmp PrinterWrite
TapeReadBlock2:  jmp TapeReadBlock3
TapeWriteBlock2: jmp TapeWriteBlock3
RamDiskRead:     jmp RamDiskRead2
RamDiskWrite:    jmp RamDiskWrite2
#ifndef CONFIG_NO_READ_TAPE_ALL
                 jmp TapeReadAllRamDisk
#else
                 jmp 0
#endif
#ifndef CONFIG_NO_WRITE_TAPE_ALL
                 jmp TapeWriteAllRamDisk
#else
                 jmp 0
#endif
WaitTapePause2:  jmp TapeWaitPause
                 jmp TapeCheckPause
ReadFloppy:      jmp FloppyRead
WriteFloppy:     jmp FloppyWrite
                 jmp PrintString4
                 jmp loc_F10F
                 jmp GetImageWithHeader
                 jmp Picture
#ifndef CONFIG_NO_GAME
                 jmp Game
#else
                 jmp 0
#endif
                 jmp DrawFillRect
                 jmp Paint
                 jmp DrawLine
                 jmp DrawCircle

.include "init.inc"
.include "printstring4.inc"
.include "init2.inc"
#ifdef KEY_DRIVER_MATRIX
.include "keymatrix.inc"
#endif
#ifdef KEY_DRIVER_TERMINAL
.include "keycheck.inc"
#endif
.include "uartread.inc"
#ifdef KEY_DRIVER_TERMINAL
.include "keyread.inc"
#endif
.include "uartwrite.inc"
.include "printerwrite.inc"
.include "printchar.inc"
.include "beepset.inc"
.include "cursorpositionset2.inc"
.include "printerscreen.inc"
.include "paletteset.inc"
.include "codepageset.inc"
.include "fontget.inc"
.include "print40.inc"
.include "calctextaddress40.inc"
.include "printdown2.inc"
.include "scrollup2.inc"
.include "print2left.inc"
.include "print64.inc"
.include "scrollup.inc"
.include "print64leftup.inc"
.include "print64tab.inc"
.include "print80.inc"
.include "calctextaddress80.inc"
.include "clearscreenhome.inc"
.include "clearscreen2.inc"
.include "drawcursor.inc"
.include "printcontrolchar.inc"
.include "beep.inc"
.include "cursorpositionset.inc"
.include "screenmodeset.inc"
.include "colorset.inc"
#ifndef CONFIG_NO_GAME
.include "game.inc"
#endif
.include "calcpixeladdress.inc"
.include "drawfillrect.inc"
.include "paint.inc"
.include "getpointcolor.inc"
.include "paint2.inc"
.include "drawhorzline.inc"
.include "drawline.inc"
.include "drawpixel.inc"
.include "picture.inc"
#ifndef CONFIG_NO_DEAD_CODE
.include "drawcircle.inc"
#else
.include "drawcircle_v2.inc"
#endif
.include "font.inc"
.include "printhexbyte.inc"
#ifndef CONFIG_NO_WRITE_TAPE_ALL
.include "tapewriteallramdisk.inc"
#endif
#ifndef CONFIG_NO_READ_TAPE_ALL
.include "tapereadallramdisk.inc"
#endif
.include "printstring.inc"
.include "ramdiskread2.inc"
.include "ramdiskwrite2.inc"
.include "tapewriteblock.inc"
.include "tapewritebyte.inc"
.include "tapereadblock.inc"
.include "tapereadbyte.inc"
.include "tapewaitchange.inc"
.include "tapewaitchangebreakable.inc"
.include "tapewaitpause.inc"
.include "tapecheckpause.inc"
.include "floppyhome.inc"
.include "floppysetdrivehead.inc"
.include "floppyread.inc"
.include "floppywrite.inc"
.include "floppystartmotorsettracksector.inc"
.include "floppystartmotor.inc"
.include "floppysettracksector.inc"
.include "floppywriteinternal.inc"
.include "floppyreadinternal.inc"
.include "floppycheckerror.inc"

#ifndef CONFIG_NO_DEAD_CODE
        .db 20h
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh, 0FFh, 0FFh, 0FFh,  0FFh, 0FFh, 0FFh, 0FFh
        .db 0FFh
#endif

.end
