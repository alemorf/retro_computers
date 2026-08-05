; ASSIST6.COM - Assistent 128 60hz tweak
; Alemorf 2.08.2026
; --wbcbz7 15.o7.2o17

; sets 60hz refresh for modes 0-7

; USE AT OWN RISK - UTILIZES NON-STANDARD CRTC PARAMETERS!!1!

; use FASM to compile
; sudo apt install fasm

format binary
resident_start  equ     0x40                   ; resident start offset

;-----------------------------------------------------------------------------

                org     0x100
start:          jmp     init
                
;-----------------------------------------------------------------------------
                
realint10:
                org     resident_start
int10:
newint10id      dw      "hz"                  ; our signature
newint10:       cmp     ax, 0x0008
                jnc     prevint10
                cmp     al, 4
                jc      set_0_1_2_3_7
                cmp     al, 7
                je      set_0_1_2_3_7
                
set_4_5_6:      pushf
                push    cs
                call    prevint10
                push    ax
                mov     ax, 0505h  ; Vertical Total Adjust Register
                call    crtc
                mov     ax, 7007h  ; Vertical Sync Position
                call    crtc
                pop     ax
                iret

;-----------------------------------------------------------------------------

set_0_1_2_3_7:  pushf
                push    cs
                call    prevint10
                push    ax
                call    upd_0_1_2_3_7
                pop     ax
                iret

;-----------------------------------------------------------------------------

upd_0_1_2_3_7:  mov     ax, 1F04h  ; Vertical Total Register
                call    crtc
                mov     ax, 0505h  ; Vertical Total Adjust Register
                call    crtc
                mov     ax, 1C07h  ; Vertical Sync Position
                jmp     crtc

;-----------------------------------------------------------------------------

crtc:           push    dx                
                mov     dx, 3D4h
                out     dx, al
                inc     dl
                mov     al, ah
                out     dx, al
                pop     dx
                retn

;-----------------------------------------------------------------------------
    
prevint10:      db      0xEA ; jmp dword ?:?
int10ofs        dw      0
int10seg        dw      0

newint10end:

;-----------------------------------------------------------------------------

                org     realint10 + (newint10end - int10)

init:           ; init ds, cld
                push    cs
                pop     ds
                cld

                ; print text
                mov     ah, 9
                mov     dx, info_str
                int     21h
                
                ; get int10h vector in es:bx
                mov     ax, 3510h
                int     21h
                
                ; check installed
                xor     bp, bp
                mov     ax, [es:bx-2]
                cmp     ax, "hz"  ; check for signature
                jnz     init1
                inc     bp
init1:
                ; parse command line
                mov     si, 80h
                lodsb
                mov     cl, al
parse_loop:     dec     cl                    ; empty commandline
                js      install
                lodsb
                cmp     al, 'a'               ; lowercase
                jl      skip_upcase
                sub     al, 'a' - 'A'
skip_upcase:    or      al, al                
                cmp     al, ' '               ; skip spaces
                je      parse_loop
                cmp     al, 'U'               ; uninstall
                je      uninstall

                ; print text
                mov     ah, 9
                mov     dx, help_str
                int     21h
                
                ; exit to dos
                int     20h 

;-----------------------------------------------------------------------------

install:        ; exit if installed
                or      bp, bp
                jnz     installed
                
                ; move TSR in PSP area
                push    es
                push    cs
                pop     es
                mov     si, realint10
                mov     di, int10
                mov     cx, (newint10end - int10)
                rep     movsb                
                pop     es

                ; save original int10h    
                mov     [int10seg], es
                mov     [int10ofs], bx
                mov     ax, 2510h
                mov     dx, newint10
                int     21h

                ; free environment
                mov     bx, [cs:2Ch]
                mov     es, bx
                mov     ah, 49h
                int     21h
                
                ; update screen now
                ; TODO: Check current video mode
                call upd_0_1_2_3_7	
    
                ; TSR
                mov     dx, newint10end
                int     27h

;-----------------------------------------------------------------------------
                
installed:      ; print text
                mov     ah, 9
                mov     dx, already_str
                int     21h
                
                ; exit to dos
                int     20h

;-----------------------------------------------------------------------------

uninstall:      ; exit if not installed
                or      bp, bp
                jz      cant_uninstall

                ; print text
                mov     ah, 9
                mov     dx, uninstalld_str
                int     21h 
                
                ; set old int10h
                mov     ax, [es:int10seg]
                mov     ds, ax
                mov     dx, [es:int10ofs]
                mov     ax, 2510h
                int     21h                   
                
                ; free memory
                mov     bx, [es:int10seg]
                mov     ah, 49h
                int     21h
                
                ; exit to dos
                int     20h

;-----------------------------------------------------------------------------

cant_uninstall: ; print text
                mov     ah, 9
                mov     dx, relfail_str
                int     21h
                
                ; exit to dos
                int     20h

;-----------------------------------------------------------------------------

info_str        db      "Assistent 128 60 Hz tweak - by Alemorf 2.08.2026 - by wbc\\bz7 16.o5.2o16",13,10,"$"
help_str        db      "Help",10,13
                db      "u - uninstall",13,10,"$"
uninstalld_str  db      "Uninstalled",13,10,"$"                
relfail_str     db      "Unable to uninstall",13,10,"$"
already_str     db      "Already installed",13,10,"$"


