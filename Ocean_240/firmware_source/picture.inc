; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод и сохранение изображений

Picture:
        lhld   v_arg_3
        mov    a, m
        cpi    ':'
        rnz
        inx    h

        mov    e, m
        inx    h
        mov    d, m
        inx    h

        mov    a, m
        sta    v_a
        inx    h

        mov    a, m
        sta    byte_BFF6
        inx    h
        push   h
        mov    c, m
        inx    h
        mov    b, m
        inx    h
        inx    h
        xchg
        push   d

        mvi    a, 1
        out    PORT_MAPPER

        call   SomeImageFunction

        mvi    a, 0
        out    PORT_MAPPER

        pop    d
        pop    h

        mov    m, c
        inx    h
        mov    m, b

        call   sub_F3CA
        ret

;----------------------------------------------------------------------------

SomeImageFunction:
        lda    v_arg_0
        cpi    19h
        jz     loc_F368
        cpi    18h
        jz     loc_F266
        cpi    1Ah
        jz     loc_F319
        cpi    8
        jz     loc_F2BD
        cpi    1Fh
        jz     loc_F0F3
        ret

;----------------------------------------------------------------------------

loc_F0F3:                ; CODE XREF: SomeImageFunction+19j
        mov    l, c
        mov    h, b
        lda    v_a
        mov    c, a
        lda    byte_BFF6
        mov    b, a
        call   PutImage    ; de - \AE\E2\AA㤠, hl - \AA㤠, bc - ࠧ\AC\A5\E0
        pop    h
        pop    h
        pop    h
        ret

; ---------------------------------------------------------------------------

loc_F104:                ; CODE XREF: SomeImageFunction+E4j
        cpi    2
        jz     GetImageWithHeader
        cpi    3
        jz     loc_F10F
        ret

; ---------------------------------------------------------------------------

loc_F10F:
        lhld   v_arg_2
        inr    l
        mov    c, l
        mov    b, h
        mov    e, l
        call   MulEH        ; E *= H, H = E, D = 0
        dad    h
        xchg
        lhld   v_arg_0
        push   b
        push   d
        lxi    b, 10
        mov    e, l
        mov    d, h
        dad    b
        xchg
        mov    m, e
        inx    h
        mov    m, d
        inx    h
        pop    b
        mvi    a, 4

loc_F12E:                ; CODE XREF: SomeImageFunction+62j
        push    psw
        xchg
        dad    b
        xchg
        mov    m, e
        inx    h
        mov    m, d
        inx    h
        pop    psw
        dcr    a
        jnz    loc_F12E
        xchg
        lxi    h, 0
        dad    b
        dad    b
        dad    h
        dad    b
        dad    h
        xchg
        mvi    a, 0
        mov    b, a
loc_F148:   mov    m, b
            inx    h
            dcx    d
            cmp    e
          jnz    loc_F148
          cmp    d
        jnz    loc_F148

        xra    a
        sta    v_a

        pop    b

        lhld   v_arg_0
        lxi    d, 10
        dad    d

loc_F15F: xchg
          lhld    v_arg_4
          xchg

          push   b
          call   sub_F223
          pop    b

          lda    v_a
          adi    2
          sta    v_a

          cpi    10
          rz
        jmp    loc_F15F

;----------------------------------------------------------------------------

GetImageWithHeader:
        lhld   v_arg_4
        mvi    m, ':'
        inx    h
        push   h
        lhld   v_arg_2    ; 23 - \90\A0\A7\AC\A5\E0
        inr    l
        mov    c, l
        mov    a, h
        adi    4
        mov    b, a
        mov    h, b
        mov    e, c
        call   MulEH        ; E *= H, H = E, D = 0
        dad    h
        xchg
        pop    h
        mov    m, e
        inx    h
        mov    m, d
        inx    h
        mov    m, c        ; \90\A0\A7\AC\A5\E0
        inx    h
        mov    m, b
        inx    h
        xchg
        lhld   v_arg_0    ; 01 - \AA\AE\AEन\AD\A0\E2\EB
        dad    h
        xchg
        push   b
        push   h
        call   CalcPixelAddress ; de -    \AA\AE\AEन\AD\A0\E2\EB / hl    - \A0\A4\E0\A5\E1, b - \AD\AE\AC\A5\E0 \A1\A8\E2\A0
        pop    d
        mov    a, l        ; \87\A0\AF\A8\E1\A0\E2\EC \A2 \AF\A0\AC\EF\E2\EC \A0\A4\E0\A5\E1 \A8 \AD\AE\AC\A5\E0 \A1\A8\E2\A0
        stax   d
        inx    d
        mov    a, h
        stax   d
        inx    d
        mov    a, b
        stax   d
        inx    d
        pop    b

        mvi    a, 1
        out    PORT_MAPPER

        call   GetImage    ; de - \AE\E2\AA㤠, hl - \AA㤠, bc - ࠧ\AC\A5\E0
        ret
; ---------------------------------------------------------------------------

GetPutImage:
        lda    v_arg_6
        cpi    2
        jnc    loc_F104

        lxi    h, v_arg_0    ; de = 01
        mov    e, m
        inx    h
        mov    d, m
        inx    h
        mov    c, m        ; bc = 23
        inx    h
        mov    b, m
        call   CalcPixelAddress ; de -    \AA\AE\AEन\AD\A0\E2\EB / hl    - \A0\A4\E0\A5\E1, b - \AD\AE\AC\A5\E0 \A1\A8\E2\A0
        xchg
        lhld   v_arg_4    ; hl = 45 - \A0\A4\A5\E0\E1 \AE\E2 8000h \A4\AE B800h
        mov    a, h
        cpi    80h ; '\80'
        rc
        cpi    0B8h ; '\B8'
        rnc
        xchg

        mvi    a, 1
        out    PORT_MAPPER

        lda    v_arg_6    ; 6 - \A4\A5\A9\E1⢨\A5 (0 = GetImage, 1    = PutImage)
        ora    a
        jnz    PutImage    ; de - \AE\E2\AA㤠, hl - \AA㤠, bc - ࠧ\AC\A5\E0

; =============== S U B    R O U T    I N E =======================================

; Сохранить изображение с экрана
; Вход: bc - размер, hl - адрес в видеопамяти, de - буфер в памяти

GetImage:
          push    h
          push    b
loc_F1E3:   mov    a, m
            stax   d
            inr    h
            inx    d

            mov    a, m
            stax   d
            inr    h

            mov    a, h
            cpi    80h
            jnz    loc_F1F2
              mvi    h, 40h
loc_F1F2:
            inx    d

            dcr    c
          jnz    loc_F1E3

          pop    b
          pop    h
          inr    l
          dcr    b
        jnz    GetImage

        jmp    SetMemoryMap0

; =============== S U B    R O U T    I N E =======================================

; Вывести изображение на экран
; Вход: bc - размер, hl - адрес в видеопамяти, de - буфер в памяти

PutImage:
          push    h
          push    b
loc_F203:   ldax   d
            mov    m, a
            inr    h
            inx    d

            ldax   d
            mov    m, a
            inx    d
            inr    h

            mov    a, h
            cpi    80h
            jnz    loc_F213
              mvi    h, 40h
loc_F213:   dcr    c
          jnz    loc_F203
          pop    b
          pop    h
          inr    l
          dcr    b
        jnz    PutImage

; =============== S U B    R O U T    I N E =======================================


SetMemoryMap0:                ; CODE XREF: GetImage+1Dj
        mvi    a, 0
        out    PORT_MAPPER
        ret
; End of function SetMemoryMap0


; =============== S U B    R O U T    I N E =======================================


sub_F223:                ; CODE XREF: SomeImageFunction+8Fp
        dcr    c

loc_F224:                ; CODE XREF: sub_F223+3Fj
        push    b

loc_F225:                ; CODE XREF: sub_F223+38j
        xchg
        push   b
        push   h
        mov    l, m
        mvi    h, 0

        ; hl <<= v_a
        lda    v_a
        mov    b, a
        ora    a
        jz     loc_F238
loc_F233: dad    h
          dcr    a
        jnz    loc_F233
loc_F238:

        ;
        mov    a, b
        mov    c, l
        mov    b, h
        pop    h
        inx    h
        push   h

        mov    l, m
        mvi    h, 0

        ; hl <<= a
        ora    a
        jz     loc_F24A
loc_F245: dad    h
          dcr    a
        jnz    loc_F245

loc_F24A:
        xchg
        mov    a, m
        ora    c
        mov    m, a
        inx    h

        mov    a, m
        ora    e
        mov    m, a
        inx    h

        mov    m, b
        inx    h
        mov    m, d
        dcx    h

        pop    d
        inx    d
        pop    b
        dcr    c
        jnz    loc_F225
        pop    b
        inx    h
        inx    h
        dcr    b
        jnz    loc_F224
        ret

;----------------------------------------------------------------------------

loc_F266:
        dcx    d
        ldax   d
        adi    2
        stax   d
        cpi    9
        rc

        mvi    a, 2
        stax   d
        inx    d
        push   b
        mov    h, d
        mov    l, e
        inx    h
        inx    h

        lda    v_a
        push   psw

        dcr    a
        sta    v_a

        inr    a
        add    a
        add    b
        cpi    80h ; '\80'
        jc     loc_F289
        sui    40h ; '@'

loc_F289:                ; CODE XREF: SomeImageFunction+1AEj
        mov    b, a
        lda    byte_BFF6

loc_F28D:                ; CODE XREF: SomeImageFunction+1D6j
        push    psw

        ; Копирование столбца
        lda    v_a
loc_F291: push   psw
            mov    a, m
            stax   d
            inx    h
            inx    d

            mov    a, m
            stax   d
            inx    h
            inx    d
          pop    psw
          dcr    a
        jnz    loc_F291

        ldax   b
        stax   d
        inx    d
        inx    h
        inr    b

        ldax   b
        stax   d
        inx    h
        inx    d
        dcr    b

        inr    c
        pop    psw
        dcr    a
        jnz    loc_F28D
        pop    psw
        sta    v_a
        pop    b
        inr    b
        inr    b
        mov    a, b
        cpi    80h ; '\80'
        rnz
        mvi    b, 40h ; '@'
        ret
; ---------------------------------------------------------------------------

loc_F2BD:
        dcx    d
        ldax   d
        sui    2
        stax   d
        rnc
        mvi    a, 6
        stax   d
        inx    d
        push   b
        dad    d
        dcx    h
        mov    d, h
        mov    e, l
        dcx    h
        dcx    h
        lda    byte_BFF6
        add    c
        dcr    a
        mov    c, a
        mov    a, b
        dcr    a
        cpi    3Fh ; '?'
        jnz    loc_F2DD
        mvi    a, 7Fh ; ''

loc_F2DD:                ; CODE XREF: SomeImageFunction+202j
        mov    b, a
        lda    v_a
        push    psw
        dcr    a
        sta    v_a
        lda    byte_BFF6

loc_F2E9:                ; CODE XREF: SomeImageFunction+232j
        push   psw

        lda    v_a
loc_F2ED: push   psw

          mov    a, m
          stax   d
          dcx    h
          dcx    d

          mov    a, m
          stax   d
          dcx    h
          dcx    d

          pop    psw
          dcr    a
        jnz    loc_F2ED

        ldax    b
        stax    d
        dcx    h
        dcx    d
        dcr    b

        ldax    b
        stax    d
        dcx    h
        dcx    d
        inr    b
        dcr    c

        pop    psw
        dcr    a
        jnz    loc_F2E9

        pop    psw
        sta    v_a
        pop    b
        dcr    b
        dcr    b
        mov    a, b
        cpi    3Eh ; '>'
        rnz
        mvi    b, 7Eh ; '~'
        ret

;----------------------------------------------------------------------------

loc_F319:                ; CODE XREF: SomeImageFunction+Fj
        push    b
        lda    v_a
        add    a
        add    a
        add    e
        mov    l, a
        mov    h, d
        lda    byte_BFF6
        add    c
        mov    c, a
        push    b
        lda    byte_BFF6
        dcr    a
        dcr    a
        mov    c, a

loc_F32E:                ; CODE XREF: SomeImageFunction+269j
        lda    v_a
        mov    b, a

loc_F332:                ; CODE XREF: SomeImageFunction+265j
        mov    a, m
        stax    d
        inx    h
        inx    d
        mov    a, m
        stax    d
        inx    h
        inx    d
        dcr    b
        jnz    loc_F332
        dcr    c
        jnz    loc_F32E
        pop    b
        mvi    l, 2

loc_F345:                ; CODE XREF: SomeImageFunction+28Bj
        lda    v_a
        mov    h, a
        push    b

loc_F34A:                ; CODE XREF: SomeImageFunction+285j
        ldax    b
        stax    d
        inx    d
        inr    b
        ldax    b
        stax    d
        inx    d
        inr    b
        mov    a, b
        cpi    80h ; '\80'
        jnz    loc_F35A
        mvi    b, 40h ; '@'

loc_F35A:                ; CODE XREF: SomeImageFunction+27Fj
        dcr    h
        jnz    loc_F34A
        pop    b
        inr    c
        dcr    l
        jnz    loc_F345
        pop    b
        inr    c
        inr    c
        ret
; ---------------------------------------------------------------------------

loc_F368:
        push   b
        lda    v_a
        add    a
        add    b
        cpi    80h
        jz     loc_F378
        jc     loc_F378
          sui    40h
loc_F378:
        dcr    a
        mov    b, a
        dcr    c
        push   b
        dad    d
        lda    v_a
        add    a
        add    a
        mov    e, a
        mov    a, l
        sub    e
        mov    e, a
        mov    d, h
        dcx    d
        dcx    h
        xchg

        lda    byte_BFF6
        dcr    a
        dcr    a

        ; Копирование
        mov    c, a
loc_F390: lda    v_a
          mov    b, a
loc_F394:   mov    a, m
            stax   d
            dcx    h
            dcx    d

            mov    a, m
            stax   d
            dcx    h
            dcx    d

            dcr    b
          jnz    loc_F394
          dcr    c
        jnz    loc_F390
        pop    b

        mvi    l, 2
loc_F3A7: lda    v_a
          mov    h, a
          push   b
loc_F3AC:     ldax   b
              stax   d
              dcx    d
              dcr    b

              ldax   b
              stax   d
              dcx    d
              dcr    b

              mov    a, b
              cpi    3Fh
            jnz    loc_F3BC

            mvi    b, 7Fh
loc_F3BC:
            dcr    h
          jnz    loc_F3AC
          pop    b
          dcr    c
          dcr    l
        jnz    loc_F3A7
        pop    b
        dcr    c
        dcr    c
        ret

; =============== S U B    R O U T    I N E =======================================


sub_F3CA:                ; CODE XREF: RAM:F0D2p
        push   d
        dcx    d
        ldax   d
        mov    e, a
        mvi    d, 0
        lhld   v_arg_1
        dad    d
        mov    e, m
        inx    h
        mov    d, m
        pop    h
        push   b
        push   h
        push   h
        lhld   v_arg_3
        inx    h
        mov    c, m
        inx    h
        mov    b, m
        pop    h
        dad    b
        mov    c, l
        mov    b, h
        pop    h
        call   sub_F43B

        lda    v_arg_5
        ora    a
        jz     loc_F3F2
          xchg
loc_F3F2:

        lda    byte_BFF6
        sui    4

loc_F3F7:                ; CODE XREF: sub_F3CA+51j
        push   psw
        lda    v_a
loc_F3FB: push   psw
          ldax   d
          inx    d
          push   d
          push   psw
          ldax   d
          mov    e, a
          pop    psw
          mov    d, a
          ora    e
          cma
          push   psw
          ana    m
          ora    d
          stax   b
          inx    b
          inx    h
          pop    psw
          ana    m
          ora    e
          stax   b
          inx    b
          inx    h
          pop    d
          inx    d
          pop    psw
          dcr    a
        jnz    loc_F3FB

        pop    psw
        dcr    a
        jnz    loc_F3F7
        lda    v_arg_5
        ora    a
        jz     loc_F426
          xchg
loc_F426:
        call   sub_F43B
        pop    d
        xchg

        lda    v_a
        mov    c, a

        lda    byte_BFF6
        mov    b, a

        mvi    a, 1
        out    PORT_MAPPER

        call   PutImage
        ret

;----------------------------------------------------------------------------
; Копирование памяти из HL в BC длинной 4 * v_a

sub_F43B:
        push   d

        lda    v_a
        add    a
        add    a
        mov    e, a

loc_F442: mov    a, m
          stax   b
          inx    h
          inx    b
          dcr    e
        jnz    loc_F442

        pop    d
        ret
