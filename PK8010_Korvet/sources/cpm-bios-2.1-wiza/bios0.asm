        org     0da00h
bdosadr equ     0cc06h
ccpstart        equ     0c400h
cmdreg  equ     0fb18h
datreg  equ     0fb1bh
drvreg  equ     0fb39h
l3a7f   equ     3a7fh
l3b18   equ     3b18h
l3b1b   equ     3b1bh
lf840   equ     0f840h
lf87f   equ     0f87fh
lf880   equ     0f880h
lf920   equ     0f920h
lf93f   equ     0f93fh
lfabf   equ     0fabfh
lfafb   equ     0fafbh
lfb00   equ     0fb00h
lfb03   equ     0fb03h
lfb10   equ     0fb10h
lfb11   equ     0fb11h
lfb28   equ     0fb28h
lfb29   equ     0fb29h
lfb30   equ     0fb30h
lfb32   equ     0fb32h
lfb33   equ     0fb33h
lfb38   equ     0fb38h
lfb3a   equ     0fb3ah
secreg  equ     0fb1ah
sysreg1c        equ     0fa7fh
trkreg  equ     0fb19h

        jmp     boot    ;0db42h
        jmp     wboot   ;0db5eh
        jmp     const   ;0e181h
        jmp     conin   ;0e18eh
        jmp     conout  ;0e07dh
        jmp     list    ;0e2edh
        jmp     auxout  ;0e398h
        jmp     auxin   ;0e3b2h
        jmp     home    ;0dc86h
        jmp     seldsk  ;0dc8dh
        jmp     settrk  ;0dc88h
        jmp     setsec  ;0dcdch
        jmp     setdma  ;0dce5h
        jmp     read    ;0dcebh
        jmp     write   ;0deafh
        jmp     listst  ;0e30fh
        jmp     sectran ;0dce1h

dpha:           ;da33
        dw      0
        db      0,0,0,0,0,0
        dw      dirbuf  ;0eba6h
        dw      dpba    ;0da8bh
        dw      csva    ;0ed00h
        dw      alwa    ;0ec26h

dphb:           ;da43
        dw      0
        db      0,0,0,0,0,0
        dw      dirbuf  ;0eba6h
        dw      dpbb    ;0daa2h
        dw      csvb    ;0ed20h
        dw      alwb    ;0ec58h

dbpc:           ;da53
        dw      0
        db      0,0,0,0,0,0
        dw      dirbuf  ;0eba6h
        dw      dpbc    ;0dab9h
        dw      csvc    ;0ed40h
        dw      alwc    ;0ec8ah

dphd:           ;da63
        dw      0
        db      0,0,0,0,0,0
        dw      dirbuf  ;0eba6h
        dw      dpbd    ;0dad0h
        dw      csvd    ;0ed60h
        dw      alwd    ;0ecbch

dphe:           ;da73
        dw      0
        db      3,0,0,0,0,0
        dw      dirbuf  ;0eba6h
        dw      dpbe    ;0dadfh
        dw      0
        dw      alwe    ;0eceeh

hpba:
        db      80      ;Track on dsk           0
        db      080h    ;Head & Speed           1
        db      5       ;Sector Per Track       2
        db      1       ;InSec? (double side)   3
        db      3       ;Sec Size               4
        db      0       ;Track (current)        5
        db      01h     ;Drive as 2^n           6
        db      0       ;Info                   7
dpba:
        dw      40      ;spt
        db      4       ;bsh
        db      0fh     ;blm
        db      0       ;exm
        dw      394     ;dsm
        dw      127     ;drm
        db      0c0h    ;al0
        db      0       ;al1
        dw      32      ;cks
        dw      2       ;off

hpbb:   db      50h,80h,5,1,2,0,2,0
dpbb:   db      14h,0,4,0fh,1,0c3h,0,7fh,0
        db      0c0h,0,' ',0,2,0

hpbc:   db      50h,80h,5,1,2,0,4,0
dpbc:   db      '(',0,4,0fh,1,0c3h,0,7fh,0
        db      0c0h,0,' ',0,0,0

hpbc:   db      50h,80h,5,1,2,0,8,0
dpbd:   db      14h,0,4,0fh,1,0c3h,0,7fh,0
        db      0c0h,0,' ',0,2,0

dpbe:           ;dadf
        dw      128     ;spt
        db      3       ;bsh
        db      07h     ;blm
        db      0       ;exm
        dw      143     ;dsm
        dw      31      ;drm
        db      080h    ;al0
        db      0       ;al1
        dw      0       ;cks
        dw      0       ;off

mhello:         ;daee
        db      1fh,0dh,0ah
        db      'CP/M-80  VERS. 2.2 ',0dh,0ah
        db      'Bios  Vers.2.1 (c) ',0dh,0ah
        db      'íçõ Î/Ð ëÏÏÐ."÷éúá"',0dh,0ah
        db      '   íÏÓË×Á 1989 '
        db      0dh,0ah,0

boot:           ;db42
        di
        lxi     sp,80h
        mvi     a,1ch
        sta     sysreg1c        ;0fa7fh
        sta     syscopy         ;0f703h
        call    harwinit        ;0e40ah

        call    keyinit         ;0e4cdh

        xra     a
        sta     4
        lxi     h,mhello        ;0daeeh
        call    putstrr ;0e02dh
wboot:          ;db5e
        di
        lxi     sp,80h
        call    harwinit        ;0e40ah
        mvi     c,0
        call    seldsk  ;0dc8dh
        call    home    ;0dc86h
        mvi     b,','   ;2ch
        mvi     c,0
        mvi     d,2
        lxi     h,ccpstart      ;0c400h
ldb76:          ;db76
        push    b
        push    d
        push    h
        mov     c,d
        mvi     b,0
        call    setsec  ;0dcdch
        pop     b
        push    b
        call    setdma  ;0dce5h
        call    read    ;0dcebh
        ora     a
        jnz     wboot   ;0db5eh
        pop     h
        lxi     d,80h
        dad     d
        pop     d
        pop     b
        dcr     b
        jz      ldbaf   ;0dbafh
        inr     d
        lda     dpba    ;0da8bh
        cmp     d
        jnc     ldb76   ;0db76h
        mvi     d,1
        inr     c
        push    b
        push    d
        push    h
        mvi     b,0
        call    settrk  ;0dc88h
        pop     h
        pop     d
        pop     b
        jmp     ldb76   ;0db76h
ldbaf:          ;dbaf
        mvi     a,0c3h
        sta     0
        lxi     h,wboot0        ;0da03h
        shld    1
        sta     5
        lxi     h,bdosadr       ;0cc06h
        shld    6
        lxi     b,80h
        call    setdma  ;0dce5h
        lda     4
        mov     c,a
        jmp     ccpstart        ;0c400h
int0:           ;dbd0
        push    h
        lhld    vi0     ;0f7c8h
        jmp     intx    ;0dc05h
int1:           ;dbd7
        push    h
        lhld    vi1     ;0f7cah
        jmp     intx    ;0dc05h
int2:           ;dbde
        push    h
        lhld    vi2     ;0f7cch
        jmp     intx    ;0dc05h
int3:           ;dbe5
        push    h
        lhld    vi3     ;0f7ceh
        jmp     intx    ;0dc05h
int4:           ;dbec
        push    h
        lhld    vi4     ;0f7d0h
        jmp     intx    ;0dc05h
int5:           ;dbf3
        push    h
        lhld    vi5     ;0f7d2h
        jmp     intx    ;0dc05h
int6:           ;dbfa
        push    h
        lhld    vi6     ;0f7d4h
        jmp     intx    ;0dc05h
int7:           ;dc01
        push    h
        lhld    vi7     ;0f7d6h
intx:           ;dc05
        push    psw
        mvi     a,1ch
        sta     sysreg1c        ;0fa7fh
        pchl
vintnop:                ;dc0c
        lda     syscopy ;0f703h
        sta     sysreg1c        ;0fa7fh
        di
        mvi     a,' '   ;20h
        sta     lfb28   ;0fb28h
        pop     psw
        pop     h
        ei
        ret

vint4:          ;dc1c
        lxi     h,0
        dad     sp
        lxi     sp,home ;0dc86h
        push    h
        push    d
        push    b
        lda     lutfl   ;0f76eh
        ora     a
        jz      nolut   ;0dc34h
        call    lutprg  ;0e4a5h
        xra     a
        sta     lutfl   ;0f76eh
nolut:          ;dc34
        lda     scancode        ;0e2ebh
        ora     a
        jnz     v4nokey ;0dc61h
        call    inkey   ;0e0d6h
        ora     a
        jz      v4nokey ;0dc61h
        lhld    vi8     ;0f7d8h
        pchl
vint8:          ;dc46
        mov     a,c
        ora     a
        jz      v4nokey ;0dc61h
        sta     scancode        ;0e2ebh
        mov     a,b
        sta     keymodif        ;0e2ech
        lda     sndflg  ;0f731h
        ora     a
        jz      v4nokey ;0dc61h
        call    keyclick        ;0e0cbh
        mvi     a,1
        sta     lfb00   ;0fb00h
v4nokey:                ;dc61
        pop     b
        pop     d
        pop     h
        sphl
        jmp     vintnop ;0dc0ch
        ds      001eh
home:           ;dc86
        mvi     c,0
settrk:         ;dc88
        mov     a,c
        sta     trk     ;0e068h
        ret
seldsk:         ;dc8d
        mov     a,c
        cpi     0ffh
        lxi     h,vi0   ;0f7c8h
        rz
        cpi     8
        jnc     badseldsk       ;0dcc4h
        lxi     h,dphbuf        ;0dccch
        sta     dsk     ;0e064h
        mvi     b,0
        dad     b
        dad     b
        mov     a,m
        inx     h
        mov     h,m
        mov     l,a
        ora     h
        jz      badseldsk       ;0dcc4h
        mov     a,c
        cpi     4
        rnc
        push    h
        lxi     b,0ah
        dad     b
        mov     a,m
        inx     h
        mov     h,m
        mov     l,a
        dcx     h
        mov     a,m
        dcx     h
        shld    dskinfo ;0e06eh
        inr     a
        cnz     initdsk ;0e648h
        pop     h
        rz
badseldsk:              ;dcc4
        lxi     h,0
        xra     a
        sta     4
        ret
dphbuf:         ;dccc
        dw      dpha    ;0da33h
        dw      dphb    ;0da43h
        dw      dbpc    ;0da53h
        dw      dphd    ;0da63h
        dw      dphe    ;0da73h
        dw      0
        dw      0
        dw      0

setsec:         ;dcdc
        mov     a,c
        sta     secnum  ;0e069h
        ret
sectran:                ;dce1
        mov     h,b
        mov     l,c
        inx     h
        ret
setdma:         ;dce5
        mov     l,c
        mov     h,b
        shld    dmaptr  ;0e06ah
        ret
read:           ;dceb
        mvi     a,4
        sta     iooper  ;0e066h
        lda     dsk     ;0e064h
        cpi     4
        jz      edskio  ;0ddc4h
        cc      motoron ;0e829h
        lda     ioresult        ;0dfd2h
        ora     a
        jnz     ldd0b   ;0dd0bh
ldd02:          ;dd02
        lxi     h,guddrvreg     ;0e079h
        call    lde81   ;0de81h
        jz      ldd1c   ;0dd1ch
ldd0b:          ;dd0b
        lhld    dskinfo ;0e06eh
        push    h
        call    ldf4e   ;0df4eh
        pop     h
        shld    dskinfo ;0e06eh
        call    ldd35   ;0dd35h
        jmp     ldd02   ;0dd02h
ldd1c:          ;dd1c
        lxi     h,rdbuff        ;0ee00h
        rar
        mov     b,a
        mvi     a,0
        rar
        mov     c,a
        dad     b
        xchg
        lhld    dmaptr  ;0e06ah
        mvi     a,'@'   ;40h
        call    fastcpy2        ;0e045h
        ei
        lda     ioresult        ;0dfd2h
        ora     a
        ret
ldd35:          ;dd35
        lda     trk     ;0e068h
        sta     le07a   ;0e07ah
        sta     le075   ;0e075h
        lda     secnum  ;0e069h
        sta     le076   ;0e076h
        lda     dsk     ;0e064h
        sta     guddrvreg       ;0e079h
        call    le73e   ;0e73eh
        lda     le073   ;0e073h
        sta     le07b   ;0e07bh
        lxi     h,ldd7d ;0dd7dh
        mvi     m,10h
        mvi     a,0
        sta     sidevvvvv       ;0e07ch
        lxi     h,rdbuff        ;0ee00h
        shld    lddc2   ;0ddc2h
ldd63:          ;dd63
        lxi     h,dskinfo       ;0e06eh
        call    seekfd  ;0dfd3h
ldd69:          ;dd69
        lhld    lddc2   ;0ddc2h
        call    rdsec   ;0e79ah
        rnz
        xchg
        shld    lddc2   ;0ddc2h
        lxi     h,sidevvvvv     ;0e07ch
        lda     le074   ;0e074h
        add     m
        mov     m,a
        cpi     10h
        rp
        lda     lddc3   ;0ddc3h
        cpi     0f6h
        jc      ldd8d   ;0dd8dh
        mvi     a,0ffh
        sta     ioresult        ;0dfd2h
        ret
ldd8d:          ;dd8d
        lxi     h,isector       ;0e072h
        mov     a,m
        inr     m
        lhld    dskinfo ;0e06eh
        lxi     d,0fffch
        dad     d
        cmp     m
        jp      ldda4   ;0dda4h
        inr     a
        sta     secreg  ;0fb1ah
        jmp     ldd69   ;0dd69h
ldda4:          ;dda4
        lda     le075   ;0e075h
        inr     a
        sta     le075   ;0e075h
        mvi     a,1
        sta     le076   ;0e076h
        call    le73e   ;0e73eh
        lhld    dskinfo ;0e06eh
        lxi     d,0fffah
        dad     d
        lda     itrack  ;0e071h
        cmp     m
        rp
        jmp     ldd63   ;0dd63h
lddc2:          ;ddc2
        dw      key0    ;0f600h
edskio:         ;ddc4
        lda     trk     ;0e068h
        add     a
        cpi     11h
        mov     e,a
        mvi     a,1
        rnc
        di
        mvi     d,0
        lxi     h,etrktbl       ;0de6fh
        dad     d
        lda     lfb3a   ;0fb3ah
        sta     oldfb3a ;0de6dh
        ani     '?'     ;3fh
        ora     m
        sta     lfb3a   ;0fb3ah
        inx     h
        mov     a,m
        sta     eslojmask       ;0de6eh
        lda     secnum  ;0e069h
        rrc
        mov     e,a
        ani     '?'     ;3fh
        ori     '@'     ;40h
        mov     d,a
        mvi     a,80h
        ana     e
        mov     e,a
        mvi     b,80h
        lxi     h,ebuf  ;0ed80h
        lda     iooper  ;0e066h
        cpi     6
        cz      ewriteprep      ;0de3fh
        lda     eslojmask       ;0de6eh
        inr     a
        sta     lfabf   ;0fabfh
        mvi     a,'<'   ;3ch
        sta     sysreg1c        ;0fa7fh
lde0d:          ;de0d
        ldax    d
        mov     m,a
        inx     d
        inx     h
        dcr     b
        jnz     lde0d   ;0de0dh
        mvi     a,1ch
        sta     0ff7fh
        lda     oldfb3a ;0de6dh
        sta     lfb3a   ;0fb3ah
        lda     iooper  ;0e066h
        cpi     4
        jz      lde31   ;0de31h
eioext:         ;de28
        lda     colcopy ;0f704h
        sta     lfabf   ;0fabfh
        ei
        xra     a
        ret
lde31:          ;de31
        lhld    dmaptr  ;0e06ah
        lxi     d,ebuf  ;0ed80h
        mvi     a,'@'   ;40h
        call    fastcpy2        ;0e045h
        jmp     eioext  ;0de28h
ewriteprep:             ;de3f
        push    d
        xchg
        lhld    dmaptr  ;0e06ah
        xchg
        mvi     a,'@'   ;40h
        call    fastcpy2        ;0e045h
        pop     h
        push    h
        lda     eslojmask       ;0de6eh
        sta     lfabf   ;0fabfh
        mvi     a,'<'   ;3ch
        sta     sysreg1c        ;0fa7fh
        mvi     a,0ffh
        mvi     b,80h
lde5b:          ;de5b
        mov     m,a
        inx     h
        dcr     b
        jnz     lde5b   ;0de5bh
        mvi     a,1ch
        sta     0ff7fh
        pop     h
        lxi     d,ebuf  ;0ed80h
        mvi     b,80h
        ret

oldfb3a:db      0
eslojmask:db    0
etrktbl:
        db      40h,01ch
        db      40h,02ah
        db      40h,046h
        db      80h,01ch
        db      80h,02ah
        db      80h,046h
        db      c0h,01ch
        db      c0h,02ah
        db      c0h,046h

lde81:          ;de81
        lda     dsk     ;0e064h
        cmp     m
        rnz
        inx     h
        lda     trk     ;0e068h
        sub     m
        rc
        inx     h
        mov     e,m
        inx     h
        mov     d,m
        lhld    dskinfo ;0e06eh
        inx     h
        inx     h
        jz      ldea7   ;0dea7h
        dcr     a
        rnz
        lda     secnum  ;0e069h
        add     m
lde9e:          ;de9e
        sub     e
        mov     e,a
        mov     a,d
        dcr     a
        cmp     e
        rc
        xra     a
        mov     a,e
        ret
ldea7:          ;dea7
        lda     secnum  ;0e069h
        cmp     e
        rc
        jmp     lde9e   ;0de9eh
write:          ;deaf
        mvi     a,6
        sta     iooper  ;0e066h
        lda     dsk     ;0e064h
        cpi     4
        jz      edskio  ;0ddc4h
        mov     a,c
        sta     wroper  ;0dfd0h
        cc      motoron ;0e829h
ldec3:          ;dec3
        lxi     h,guddrvreg     ;0e079h
        call    lde81   ;0de81h
        jz      ldf05   ;0df05h
        lhld    dskinfo ;0e06eh
        push    h
        call    ldf4e   ;0df4eh
        pop     h
        shld    le077   ;0e077h
        shld    dskinfo ;0e06eh
        lda     wroper  ;0dfd0h
        cpi     2
        jz      ldee8   ;0dee8h
        call    ldd35   ;0dd35h
        jmp     ldec3   ;0dec3h
ldee8:          ;dee8
        lda     dsk     ;0e064h
        sta     guddrvreg       ;0e079h
        lhld    trk     ;0e068h
        shld    le07a   ;0e07ah
        lhld    dskinfo ;0e06eh
        lxi     d,5
        dad     d
        mov     a,m
        inr     a
        sta     sidevvvvv       ;0e07ch
        xra     a
        sta     ioresult        ;0dfd2h
        mov     e,a
ldf05:          ;df05
        call    ldf14   ;0df14h
        lda     wroper  ;0dfd0h
        dcr     a
        cz      ldf4e   ;0df4eh
        lda     ioresult        ;0dfd2h
        ora     a
        ret
ldf14:          ;df14
        rar
        mov     b,a
        mvi     a,0
        rar
        mov     c,a
        lxi     h,rdbuff        ;0ee00h
        dad     b
        xchg
        mov     a,d
        cpi     0f6h
        jc      ldf2b   ;0df2bh
        mvi     a,0ffh
        sta     ioresult        ;0dfd2h
        ret
ldf2b:          ;df2b
        lda     sidevvvvv       ;0e07ch
        dcr     a
        cmp     l
        jnz     ldf38   ;0df38h
        mvi     a,1
        sta     wroper  ;0dfd0h
ldf38:          ;df38
        mvi     a,0ffh
        sta     ldfd1   ;0dfd1h
        lhld    dskinfo ;0e06eh
        shld    le077   ;0e077h
        lhld    dmaptr  ;0e06ah
        xchg
        mvi     a,'@'   ;40h
        call    fastcpy2        ;0e045h
        ei
        ret
ldf4e:          ;df4e
        lda     ldfd1   ;0dfd1h
        ora     a
        rz
        xra     a
        sta     ldfd1   ;0dfd1h
        lhld    le077   ;0e077h
        shld    dskinfo ;0e06eh
        lhld    le07a   ;0e07ah
        shld    le075   ;0e075h
        call    le73e   ;0e73eh
        mvi     a,0
        sta     le067   ;0e067h
        lxi     h,rdbuff        ;0ee00h
        shld    lddc2   ;0ddc2h
        mvi     a,0a4h
        sta     le7ea   ;0e7eah
ldf76:          ;df76
        lxi     h,dskinfo       ;0e06eh
        call    seekfd  ;0dfd3h
ldf7c:          ;df7c
        lhld    lddc2   ;0ddc2h
        call    phiswr  ;0e7e4h
        xchg
        shld    lddc2   ;0ddc2h
        mvi     a,0a0h
        sta     le7ea   ;0e7eah
        lxi     h,le067 ;0e067h
        lda     le074   ;0e074h
        add     m
        mov     m,a
        lda     sidevvvvv       ;0e07ch
        cmp     m
        rz
        rm
        lda     lddc3   ;0ddc3h
        cpi     0f6h
        jc      ldfa7   ;0dfa7h
        mvi     a,0ffh
        sta     ioresult        ;0dfd2h
        ret
ldfa7:          ;dfa7
        lxi     h,isector       ;0e072h
        mov     a,m
        inr     m
        lhld    dskinfo ;0e06eh
        lxi     d,0fffch
        dad     d
        cmp     m
        jp      ldfbe   ;0dfbeh
        inr     a
        sta     secreg  ;0fb1ah
        jmp     ldf7c   ;0df7ch
ldfbe:          ;dfbe
        lda     le075   ;0e075h
        inr     a
        sta     le075   ;0e075h
        mvi     a,1
        sta     le076   ;0e076h
        call    le73e   ;0e73eh
        jmp     ldf76   ;0df76h
wroper:         ;dfd0
        db      1
ldfd1:          ;dfd1
        db      0
ioresult:               ;dfd2
        db      0
seekfd:         ;dfd3
        mov     e,m
        inx     h
        mov     d,m
;de = * dpb - 2
        inx     h
        call    breakvg ;0e879h
        mov     a,m
        sta     drvreg  ;0fb39h
        push    d
        call    motoron ;0e829h
        pop     d
        dcx     d
        inx     h
        mov     a,m
        ora     a
        mov     c,a
        inx     h
        mov     a,m
        sta     secreg  ;0fb1ah
        jz      ldfff   ;0dfffh
        ldax    d
        sta     trkreg  ;0fb19h
        cmp     c
        rz
        mov     a,c
        sta     datreg  ;0fb1bh
        mvi     c,18h
        jnz     le002   ;0e002h
ldfff:          ;dfff
        mov     a,c
        mvi     c,8
le002:          ;e002
        stax    d
        dcx     d
        dcx     d
        dcx     d
        dcx     d
        ldax    d
;density & ds/dd
        ani     0c0h
        mov     b,a
        lda     drvreg  ;0fb39h
        push    psw
        ora     b
        sta     drvreg  ;0fb39h
        ldax    d
;steprate
        ani     3
        ora     c
        call    writevgcmd      ;0e87bh
le01a:          ;e01a
        lda     cmdreg  ;0fb18h
        rrc
        jc      le01a   ;0e01ah
        pop     psw
        sta     drvreg  ;0fb39h
        mvi     b,0fh
        call    waite   ;0e871h
        jmp     breakvg ;0e879h
putstrr:                ;e02d
        mov     a,m
        ora     a
        rz
        push    h
        mov     c,a
        call    conout  ;0e07dh
        pop     h
        inx     h
        jmp     putstrr ;0e02dh
ldrdehl:                ;e03a
        mov     a,b
        ora     c
        rz
        ldax    d
        mov     m,a
        inx     h
        inx     d
        dcx     b
        jmp     ldrdehl ;0e03ah
fastcpy2:               ;e045
        ora     a
        rz
        push    h
        lxi     h,2
        dad     sp
        shld    savesp  ;0e062h
        xchg
        pop     d
        di
        sphl
        xchg
le054:          ;e054
        pop     d
        mov     m,e
        inx     h
        mov     m,d
        inx     h
        dcr     a
        jnz     le054   ;0e054h
        lhld    savesp  ;0e062h
        sphl
        ret
savesp:         ;e062
        ds      0001h
        db      0cfh
dsk:            ;e064
        db      4,80h
iooper:         ;e066
        db      6
le067:          ;e067
        db      10h
trk:            ;e068
        db      0
secnum:         ;e069
        db      'l'
dmaptr:         ;e06a
        dw      80h
        dw      0
dskinfo:                ;e06e
        dw      HPBA+6       ;0da89h
drivereg:               ;e070
        db      1
itrack:         ;e071
        db      '/'
isector:                ;e072
        db      4
le073:          ;e073
        db      11h
le074:          ;e074
        db      8
le075:          ;e075
        dw      115eh
le077:          ;e077
        dw      HPBA+6       ;0da89h
guddrvreg:              ;e079
        db      0
le07a:          ;e07a
        dw      115eh
sidevvvvv:              ;e07c
        db      10h
conout:         ;e07d
        mov     a,c
        cpi     7
        jz      beep    ;0e0a5h
        lxi     h,0
        dad     sp
        lxi     sp,stack0       ;0edfeh
        push    h
        mvi     a,14h
        di
        sta     syscopy ;0f703h
        sta     sysreg1c        ;0fa7fh
        ei
        call    4ch
        mvi     a,1ch
        di
        sta     sysreg1c        ;0fa7fh
        sta     syscopy ;0f703h
        ei
        pop     h
        sphl
        ret
beep:           ;e0a5
        mvi     a,'6'   ;36h
        sta     lfb03   ;0fb03h
        lhld    belldiv ;0f715h
        lxi     d,lfb00 ;0fb00h
        xchg
        mov     m,l
        mov     m,d
        mvi     l,'2'   ;32h
        mov     b,m
        mvi     a,8
        ora     b
        mov     m,a
        xchg
        lhld    belldel ;0f717h
le0be:          ;e0be
        dcx     h
        mov     a,l
        ora     h
        jnz     le0be   ;0e0beh
        xchg
        mov     m,b
        lda     sndflg  ;0f731h
        ora     a
        rz
keyclick:               ;e0cb
        mvi     a,' '   ;20h
        sta     lfb03   ;0fb03h
        mvi     a,7
        sta     lfb33   ;0fb33h
        ret
inkey:          ;e0d6
        lda     lf87f   ;0f87fh
        ora     a
        jnz     le139   ;0e139h
        lda     lf93f   ;0f93fh
        ora     a
        jnz     le12b   ;0e12bh
        lda     lf880   ;0f880h
        ora     a
        jnz     le0f0   ;0e0f0h
le0eb:          ;e0eb
        xra     a
        sta     le2e7   ;0e2e7h
        ret
le0f0:          ;e0f0
        mov     b,a
        ani     'h'     ;48h
        jz      le0eb   ;0e0ebh
        mvi     c,0
        call    le17b   ;0e17bh
        mvi     a,'8'   ;38h
        add     c
        mov     c,a
        cpi     ';'     ;3bh
        jz      le140   ;0e140h
        lxi     h,le2e7 ;0e2e7h
        sub     m
        rz
        mov     m,c
        lxi     h,fshift        ;0f72dh
        mvi     a,81h
        ana     b
        jz      le117   ;0e117h
        mvi     a,0ffh
        xra     m
        mov     m,a
le117:          ;e117
        inx     h
        mvi     a,2
        ana     b
        xra     m
        mov     m,a
        mvi     a,4
        inx     h
        ana     b
        xra     m
        mov     m,a
        inx     h
        mvi     a,10h
        ana     b
        xra     m
        mov     m,a
        xra     a
        ret
le12b:          ;e12b
        lxi     h,lf920 ;0f920h
        call    le168   ;0e168h
        rz
        mvi     a,'@'   ;40h
        add     c
        mov     c,a
        jmp     le140   ;0e140h
le139:          ;e139
        lxi     h,lf840 ;0f840h
        call    le168   ;0e168h
        rz
le140:          ;e140
        lxi     d,le2e7 ;0e2e7h
        lxi     h,lf71f ;0f71fh
        ldax    d
        sub     c
        jz      le15a   ;0e15ah
        lda     longval ;0f720h
le14e:          ;e14e
        mov     m,a
        lda     lf880   ;0f880h
        sta     keymodif        ;0e2ech
        mov     b,a
        mov     a,c
        stax    d
        ora     a
        ret
le15a:          ;e15a
        lda     autoval ;0f721h
        dcr     m
        jz      le14e   ;0e14eh
        xra     a
        ret
le163:          ;e163
        mov     a,l
        rar
        mov     l,a
        ora     a
        rz
le168:          ;e168
        mov     a,m
        ora     a
        jz      le163   ;0e163h
        mvi     c,0
        push    psw
        mov     a,l
        call    le17b   ;0e17bh
        mov     a,c
        add     a
        add     a
        add     a
        inr     a
        mov     c,a
        pop     psw
le17b:          ;e17b
        rrc
        rc
        inr     c
        jmp     le17b   ;0e17bh
const:          ;e181
        lda     seqflag ;0e2e8h
        ora     a
        rnz
        lda     scancode        ;0e2ebh
        ora     a
        rz
        mvi     a,0ffh
        ret
conin:          ;e18e
        lda     seqflag ;0e2e8h
        ora     a
        lhld    seqptr  ;0e2e9h
        jnz     le2be   ;0e2beh
le198:          ;e198
        ei
        lda     scancode        ;0e2ebh
        ora     a
        jz      le198   ;0e198h
        mov     c,a
        xra     a
        sta     scancode        ;0e2ebh
        dcr     c
        mvi     b,0
        lda     keymodif        ;0e2ech
        mov     e,a
        mov     a,c
        cpi     ' '     ;20h
        jc      le1d7   ;0e1d7h
        cpi     ','     ;2ch
        jc      le26d   ;0e26dh
        cpi     '0'     ;30h
        jc      le275   ;0e275h
        cpi     '8'     ;38h
        jc      le27d   ;0e27dh
        cpi     '@'     ;40h
        jc      le289   ;0e289h
        cpi     'p'     ;50h
        jc      le28c   ;0e28ch
        cpi     60h
        jc      le2ce   ;0e2ceh
        cpi     70h
        jc      le29e   ;0e29eh
        xra     a
        ret
le1d7:          ;e1d7
        lxi     h,scanalpha     ;0e225h
        dad     b
        mov     l,m
        mov     a,e
        ani     ' '     ;20h
        jnz     le1ef   ;0e1efh
        lda     fgraph  ;0f72fh
        xra     e
        ani     4
        jz      le1f3   ;0e1f3h
        mov     a,l
        xri     0c0h
        ret
le1ef:          ;e1ef
        mov     a,l
        ani     1fh
        ret
le1f3:          ;e1f3
        lda     falf    ;0f72eh
        xra     e
        ani     2
        jnz     le208   ;0e208h
        lda     setflag ;0f71ah
        ora     a
        jz      le21e   ;0e21eh
        lxi     h,scan2 ;0e245h
        dad     b
        mov     l,m
le208:          ;e208
        call    le20d   ;0e20dh
        add     l
        ret
le20d:          ;e20d
        mvi     a,81h
        ana     e
        jz      le215   ;0e215h
        mvi     a,0ffh
le215:          ;e215
        mov     e,a
        lda     fshift  ;0f72dh
        xra     e
        rz
        mvi     a,' '   ;20h
        ret
le21e:          ;e21e
        call    le20d   ;0e20dh
        xri     0a0h
        add     l
        ret
scanalpha:              ;e225
        db      '@abcdefghijklmnopqrstuvwxyz[\]^_'
scan2:          ;e245
        db      0ceh,0b0h,0b1h,0c6h,0b4h,0b5h,0c4h
        db      0b3h,0c5h,0b8h,0b9h,0bah,0bbh,0bch
        db      0bdh,0beh,0bfh,0cfh,0c0h,0c1h,0c2h
        db      0c3h,0b6h,0b2h,0cch,0cbh,0b7h,0c8h
        db      0cdh,0c9h,0c7h,0cah,0dh,8dh,3
        db      8bh,8ch,8,9,' '
le26d:          ;e26d
        db      '{',0e6h,81h,'y',0c0h,0c6h,10h
        db      0c9h
le275:          ;e275
        db      '{',0e6h,81h,'y',0c8h,0c6h,10h
        db      0c9h
le27d:          ;e27d
        db      '!5',0e2h,9,'~',0feh,80h,0d8h
        db      'o',0c3h,0aah,0e2h
le289:          ;e289
        db      '>',1bh,0c9h
le28c:          ;e28c
        db      ':0',0f7h,0abh,0e6h,10h,0cah
        db      9eh,0e2h
le295:          ;e295
        db      '>`',0a9h
le298:          ;e298
        cpi     '*'     ;2ah
        rnc
        adi     10h
        ret
le29e:          ;e29e
        mvi     a,81h
        ana     e
        jz      le2aa   ;0e2aah
        call    le295   ;0e295h
        adi     60h
        ret
le2aa:          ;e2aa
        mvi     a,0fh
        ana     c
        mov     c,a
        lhld    contab  ;0f729h
        cpi     0eh
        jc      le2b8   ;0e2b8h
        mvi     c,0ah
le2b8:          ;e2b8
        dad     b
        dad     b
        mov     a,m
        inx     h
        mov     h,m
        mov     l,a
le2be:          ;e2be
        mov     a,m
        inx     h
        shld    seqptr  ;0e2e9h
        mov     d,a
        ora     a
        jz      le2c9   ;0e2c9h
        mov     a,m
le2c9:          ;e2c9
        sta     seqflag ;0e2e8h
        mov     a,d
        ret
le2ce:          ;e2ce
        lhld    funtab  ;0f72bh
        mvi     a,0fh
        ana     c
        mov     c,a
        cpi     5
        jnc     le2b8   ;0e2b8h
        mvi     a,81h
        ana     e
        jz      le2b8   ;0e2b8h
        mov     a,c
        adi     5
        mov     c,a
        jmp     le2b8   ;0e2b8h
le2e7:          ;e2e7
        nop
seqflag:                ;e2e8
        db      0
seqptr:         ;e2e9
        dw      lf6b9   ;0f6b9h
scancode:               ;e2eb
        db      0
keymodif:               ;e2ec
        db      0
list:           ;e2ed
        call    listst  ;0e30fh
        jz      list    ;0e2edh
        mov     a,c
        cpi     80h
        jc      le300   ;0e300h
        lxi     h,PRNENCTAB-080h
        mvi     b,0
        dad     b
        mov     a,m
le300:          ;e300
        xri     0ffh
        sta     lfb30   ;0fb30h
        lxi     h,lfb33 ;0fb33h
        mvi     m,0bh
        xthl
        xthl
        mvi     m,0ah
        ret
listst:         ;e30f
        lda     lfb38   ;0fb38h
        ani     4
        rz
        mvi     a,0ffh
        ret
PRNENCTAB:      ;e318
        db      80h,81h,82h,83h,84h,85h,86h
        db      87h,88h,89h,8ah,8bh,8ch,8dh
        db      8eh,8fh,90h,91h,92h,93h,94h
        db      95h,96h,97h,98h,99h,9ah,9bh
        db      9ch,9dh,9eh,9fh,0a0h,0a1h,0a2h
        db      0a3h,0a4h,0a5h,0a6h,0a7h,0a8h,0a9h
        db      0aah,0abh,0ach,0adh,0aeh,0afh,0b0h
        db      0b1h,0b2h,0b3h,0b4h,0b5h,0b6h,0b7h
        db      0b8h,0b9h,0bah,0bbh,0bch,0bdh,0beh
        db      0bfh,0c0h,0c1h,0c2h,0c3h,0c4h,0c5h
        db      0c6h,0c7h,0c8h,0c9h,0cah,0cbh,0cch
        db      0cdh,0ceh,0cfh,0d0h,0d1h,0d2h,0d3h
        db      0d4h,0d5h,0d6h,0d7h,0d8h,0d9h,0dah
        db      0dbh,0dch,0ddh,0deh,0dfh,0e0h,0e1h
        db      0e2h,0e3h,0e4h,0e5h,0e6h,0e7h,0e8h
        db      0e9h,0eah,0ebh,0ech,0edh,0eeh,0efh
        db      0f0h,0f1h,0f2h,0f3h,0f4h,0f5h,0f6h
        db      0f7h,0f8h,0f9h,0fah,0fbh,0fch,0fdh
        db      0feh,0ffh
auxout:         ;e398
        call    auxtst  ;0e3a3h
        jz      auxout  ;0e398h
        mov     a,c
        sta     lfb10   ;0fb10h
        ret
auxtst:         ;e3a3
        lda     lfb11   ;0fb11h
        ani     81h
        xri     81h
        jnz     le3b0   ;0e3b0h
        xri     0ffh
        ret
le3b0:          ;e3b0
        xra     a
        ret
auxin:          ;e3b2
        call    le3c7   ;0e3c7h
        jnz     le3c3   ;0e3c3h
        di
        mvi     m,''''  ;27h
le3bb:          ;e3bb
        call    le3ca   ;0e3cah
        jz      le3bb   ;0e3bbh
        mvi     m,'%'   ;25h
le3c3:          ;e3c3
        dcx     h
        mov     a,m
        ei
        ret
le3c7:          ;e3c7
        lxi     h,lfb11 ;0fb11h
le3ca:          ;e3ca
        mov     a,m
        ani     2
        rz
        mvi     a,0ffh
        ret

InstINTTAB:          ;e3d1
        dw      le3d3

le3d3:  dw      vintnop ;0dc0ch
        dw      vintnop ;0dc0ch
        dw      vintnop ;0dc0ch
        dw      vintnop ;0dc0ch
        dw      vint4   ;0dc1ch
        dw      vintnop ;0dc0ch
        dw      vintnop ;0dc0ch
        dw      vintnop ;0dc0ch
        dw      vint8   ;0dc46h
        dw      0
        dw      0
        dw      0

        jmp     int0    ;0dbd0h
        nop
        jmp     int1    ;0dbd7h
        nop
        jmp     int2    ;0dbdeh
        nop
        jmp     int3    ;0dbe5h
        nop
        jmp     int4    ;0dbech
        nop
        jmp     int5    ;0dbf3h
        nop
        jmp     int6    ;0dbfah
        nop
        jmp     int7    ;0dc01h

harwinit:               ;e40a
        di
        lxi     d,InstINTTAB            ;0e3d1h
        lxi     h,MemINTTAB             ;0f7c6h
        lxi     b,harwinit-InstINTTAB+1 ;3ah
        call    ldrdehl ;0e03ah

;PIC
; step 4 byte
; base 0f7e0
; enable only int4

        mvi     a,0f6h
        sta     0fb28h   ;0fb28h
        mvi     a,0f7h
        sta     0fb29h   ;0fb29h
        mvi     a,0efh
        sta     0fb29h   ;0fb29h
;
        lxi     h,lfb11 ;0fb11h
        xra     a
        mov     m,a
        mov     m,a
        mov     m,a
        mvi     m,'@'   ;40h
        mvi     m,0ceh
        mvi     m,'5'   ;35h
;timer
        lxi     h,lfb03 ;0fb03h
        mvi     m,7eh
        mvi     m,14h
        mvi     m,90h

        dcx     h
        dcx     h
        mvi     m,0dh   ;9600 bod
        mvi     m,0
;CRT
;store font
;reset inverse
        lda     lfb3a   ;0fb3ah
        ani     4
        ori     ' '     ;20h
        sta     lfb3a   ;0fb3ah

;clear gzu

        lxi     h,0
        dad     sp
        xchg
        mvi     a,'<'   ;3ch
        sta     sysreg1c        ;0fa7fh
        lxi     sp,8000h
        lxi     h,0ffffh
        lxi     b,0800h
        mvi     a,0
        sta     0ffbfh
le464:          ;e464
        push    h
        push    h
        push    h
        push    h
        dcr     c
        jnz     le464   ;0e464h
        dcr     b
        jnz     le464   ;0e464h
        xchg
        sphl

        mvi     a,1ch
        sta     0ff7fh

        xra     a
;unselect all drive

        sta     HPBA+7  ;0da8ah
        sta     HPBB+7  ;0daa1h
        sta     HPBC+7  ;0dab8h
        sta     HPBD+7  ;0dacfh

        sta     3
        sta     scancode        ;0e2ebh

        mvi     a,0ffh
        sta     lutfl   ;0f76eh

        lxi     h,mcurs ;0e4c8h
        call    putstrr ;0e02dh

        mvi     a,0ffh
        sta     sndflg  ;0f731h

        mvi     a,2
        sta     falf    ;0f72eh

        mvi     a,'i'   ;49h
        sta     lfb32   ;0fb32h
        ret
lutprg:         ;e4a5
        call    waitretrace     ;0e4b7h
        lhld    adrlut  ;0f76fh
        mvi     b,10h
le4ad:          ;e4ad
        mov     a,m
        sta     lfafb   ;0fafbh
        inx     h
        dcr     b
        jnz     le4ad   ;0e4adh
        ret
waitretrace:            ;e4b7
        lda     lfb38   ;0fb38h
        ani     2
        jnz     waitretrace     ;0e4b7h
        mvi     a,'2'   ;32h
le4c1:          ;e4c1
        xthl
        xthl
        dcr     a
        jnz     le4c1   ;0e4c1h
        ret
mcurs:          ;e4c8
        db      1bh
        db      ';',1bh,':',0

keyinit:                ;e4cd
        lxi     d,mkeytab       ;0e4e5h
        lxi     h,key0  ;0f600h
        lxi     b,mkeytab1-mkeytab
        call    ldrdehl ;0e03ah

        lxi     d,mkeyval       ;0e5d9h
        lxi     h,belldiv       ;0f715h
        lxi     b,mkeyval1-mkeyval;6fh
        jmp     ldrdehl ;0e03ah

mkeytab:                ;e4e5
        db      'dir ',0,0,0,0,0,0,0,0,0,0,0,0
        db      'type ',0,0,0,0,0,0,0,0,0,0,0
        db      'era ',0,0,0,0,0,0,0,0,0,0,0,0
        db      'ren ',0,0,0,0,0,0,0,0,0,0,0,0
        db      'mim ',0,0,0,0,0,0,0,0,0,0,0,0
        db      'basic ',0,0,0,0,0,0,0,0,0,0
        db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        db      'm80 =l',0dh,'link l',0dh,0,0
        db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        db      80h,0,0,0,0,0
        db      81h,0,0,0,0,0
        db      82h,0,0,0,0,0
        db      83h,0,0,0,0,0
        db      84h,0,0,0,0,0
        db      85h,0,0,0,0,0
        db      86h,0,0,0,0,0
        db      87h,0,0,0,0,0
        db      88h,0,0,0,0,0
        db      89h,0,0,0,0,0
        db      8ah,0,0,0,0,0
        db      'del',0,0,0
        db      'ins',0,0,0
        db      'cls',0,0,0
mkeytab1:

mkeyval:
        db      0,0bh
        db      0,10h,0ffh
        db      0,'/',0cdh,'64'
        db      '*'
        db      1eh
        dw      2
        dw      scancode
        dw      scancode
        dw      0
        dw      0f736h
        db      'r',0f7h
        db      0
        db      2
        db      0
        db      0
        db      0ffh,0,0,0,0
        dw      lf6a0   ;0f6a0h
        dw      lf6a6   ;0f6a6h
        dw      lf6ac   ;0f6ach
        dw      lf6b2   ;0f6b2h
        dw      lf6b8   ;0f6b8h
        dw      lf6be   ;0f6beh
        dw      lf6c4   ;0f6c4h
        dw      lf6ca   ;0f6cah
        dw      lf6d0   ;0f6d0h
        dw      lf6d6   ;0f6d6h
        dw      lf6dc   ;0f6dch
        dw      lf6e2   ;0f6e2h
        dw      lf6e8   ;0f6e8h
        dw      lf6ee   ;0f6eeh
        dw      F1      ;0f600h
        dw      F2      ;0f610h
        dw      F3      ;0f620h
        dw      F4      ;0f630h
        dw      F5      ;0f640h
        dw      F6      ;0f650h
        dw      F7      ;0f660h
        dw      F8      ;0f670h
        dw      F9      ;0f680h
        dw      F10     ;0f690h
        db      '=d'
        db      1bh,'!'
        db      0,0,0,0
        db      0
        dw      tablut
        db      000h,091h,0a2h,0b3h,0c4h,0d5h,0e6h,0f7h
        db      0f8h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh
        db      0
        dw      PRNENCTAB
mkeyval1:

initdsk:                ;e648
        push    h
        call    ldf4e   ;0df4eh
        pop     h
        shld    dskinfo ;0e06eh
        push    h
        mov     a,m
        ani     0fh
        sta     drivereg        ;0e070h
        xra     a
        sta     itrack  ;0e071h
        inr     a
        sta     isector ;0e072h
        lxi     h,dskinfo       ;0e06eh
        call    seekfd  ;0dfd3h
        lxi     h,rdbuff        ;0ee00h
        call    rdsec   ;0e79ah
        jz      le685   ;0e685h
        lda     drvreg  ;0fb39h
        adi     '@'     ;40h
        sta     drvreg  ;0fb39h
        call    breakvg ;0e879h
        lxi     h,rdbuff        ;0ee00h
        call    rdsec   ;0e79ah
        lxi     h,mdisknoread   ;0e6afh
        jnz     dskerrext       ;0e6a7h
le685:          ;e685
        lda     drivereg        ;0e070h
        sta     guddrvreg       ;0e079h
        xra     a
        sta     le07a   ;0e07ah
        inr     a
        sta     le07b   ;0e07bh
        lxi     h,rdbuff        ;0ee00h
        mvi     a,66h
        mvi     b,1fh
le69a:          ;e69a
        add     m
        inx     h
        dcr     b
        jnz     le69a   ;0e69ah
        cmp     m
        jz      okinfsec        ;0e703h
        lxi     h,mnosysinfo    ;0e6d4h
dskerrext:              ;e6a7
        pop     d
        call    putstrr ;0e02dh
        mvi     a,1
        ora     a
        ret

mdisknoread:
        db      1bh,'c',0dh,0ah
        db      '***** disk ne citaetsa',9,'*****',0dh,0ah,1bh,'c',0
mnosysinfo:
        db      1bh,'c',0dh,0ah
        db      '****** net sistemnoj informacii ******',0dh,0ah,1bh,'c',0

okinfsec:               ;e703
        pop     h
        push    h
        lda     drvreg  ;0fb39h
        ani     0cfh
        mov     m,a
        inx     h
        mvi     m,0ffh
        inx     h
        lxi     d,lee10 ;0ee10h
        lxi     b,0fh
;copy dpb
        call    ldrdehl ;0e03ah
        pop     d
        xra     a
        dcx     d
        stax    d
        dcx     d
        lxi     h,lee0a ;0ee0ah
        mov     a,m
;secsize
        stax    d
        dcx     d
        inx     h
        mov     a,m
;insec
        stax    d
        mov     c,a
        inr     c
        mvi     a,80h
le72a:          ;e72a
        rlc
        dcr     c
        jnz     le72a   ;0e72ah
        sta     sidevvvvv       ;0e07ch
        dcx     d
        inx     h
        mov     a,m
;;secpertrk
        stax    d
        dcx     d
        dcx     d
        inx     h
        inx     h
        mov     a,m
;trkperdisk
        stax    d
        xra     a
        ret
le73e:          ;e73e
        lhld    dskinfo ;0e06eh
        mov     a,m
        sta     drivereg        ;0e070h
        dcx     h
        dcx     h
;sector size
        mov     b,m
        mvi     c,0ffh
        lda     le076   ;0e076h
        dcr     a
        inr     b
        mov     d,a
        mov     e,a
le751:          ;e751
        dcr     b
        jz      le75f   ;0e75fh
        ora     a
        mov     a,e
        rar
        mov     e,a
        mov     a,c
        add     a
        mov     c,a
        jmp     le751   ;0e751h
le75f:          ;e75f
        mov     a,c
        ana     d
        inr     a
        sta     le073   ;0e073h
        mov     a,c
        cma
        inr     a
        sta     le074   ;0e074h
        dcx     h
        mov     d,m
        ora     a
        dcr     d
        lda     le075   ;0e075h
        jnz     le776   ;0e776h
        rar
le776:          ;e776
        sta     itrack  ;0e071h
        cc      selectside1     ;0e790h
        dcr     d
        jnz     le78a   ;0e78ah
        dcx     h
        mov     a,e
        sub     m
        jc      le78a   ;0e78ah
        mov     e,a
        call    selectside1     ;0e790h
le78a:          ;e78a
        mov     a,e
        inr     a
        sta     isector ;0e072h
        ret
selectside1:            ;e790
        lda     drivereg        ;0e070h
        ori     10h
        sta     drivereg        ;0e070h
        ret
trycount:               ;e799
        db      3
rdsec:          ;e79a
        mvi     a,3
le79c:          ;e79c
        sta     trycount        ;0e799h
        call    phisrdsec       ;0e7ach
        rz
        lda     trycount        ;0e799h
        dcr     a
        jnz     le79c   ;0e79ch
        dcr     a
        ret
phisrdsec:              ;e7ac
        call    motoron ;0e829h
        rnz
        push    h
        di
        mvi     a,80h
        call    writevgcmd      ;0e87bh
        xra     a
        sta     sysreg1c        ;0fa7fh
        lxi     b,0301h
        lxi     d,l3b18 ;3b18h
rdsecloop:              ;e7c1
        ldax    d
        ana     b
        xra     c
        jz      rdsecloop       ;0e7c1h
        ana     c
        lda     l3b1b   ;3b1bh
        jnz     le7d3   ;0e7d3h
        mov     m,a
        inx     h
        jmp     rdsecloop       ;0e7c1h
le7d3:          ;e7d3
        xchg
le7d4:          ;e7d4
        mvi     a,1ch
        sta     l3a7f   ;3a7fh
        pop     h
        lda     cmdreg  ;0fb18h
        ani     0ddh
        ei
        sta     ioresult        ;0dfd2h
        ret
phiswr:         ;e7e4
        call    motoron ;0e829h
        rnz
        di
        mvi     a,0a0h
        call    writevgcmd      ;0e87bh
        push    h
        xchg
        lxi     h,0
        dad     sp
        shld    savesp  ;0e062h
        xchg
        sphl
        xra     a
        sta     sysreg1c        ;0fa7fh
        lxi     h,l3b1b ;3b1bh
        lxi     d,l3b18 ;3b18h
le803:          ;e803
        pop     b
le804:          ;e804
        ldax    d
        xri     1
        jz      le804   ;0e804h
        mov     m,c
        rar
        jc      le81d   ;0e81dh
        rar
        jnc     le804   ;0e804h
le813:          ;e813
        ldax    d
        xri     1
        jz      le813   ;0e813h
        mov     m,b
        jmp     le803   ;0e803h
le81d:          ;e81d
        lxi     h,0fffeh
        dad     sp
        xchg
        lhld    savesp  ;0e062h
        sphl
        jmp     le7d4   ;0e7d4h
motoron:                ;e829
        lxi     d,drvreg        ;0fb39h
        mvi     a,0ah
        sta     lfb28   ;0fb28h
        lda     lfb28   ;0fb28h
        ani     80h
        push    psw
        ldax    d
        ani     0dfh
        stax    d
        ori     ' '     ;20h
        stax    d
        ani     0dfh
        stax    d
        pop     psw
        cnz     wait1   ;0e86fh
        mvi     c,0ah
waitmotor:              ;e847
        ldax    d
        ani     0dfh
        stax    d
        ori     ' '     ;20h
        stax    d
        ani     0dfh
        stax    d
        lda     cmdreg  ;0fb18h
        rlc
        jnc     okmotor ;0e862h
        dcr     c
        jz      errmtroff       ;0e868h
        call    wait1   ;0e86fh
        jmp     waitmotor       ;0e847h
okmotor:                ;e862
        lxi     d,cmdreg        ;0fb18h
        jmp     breakvg ;0e879h
errmtroff:              ;e868
        mvi     a,80h
        sta     ioresult        ;0dfd2h
        ora     a
        ret
wait1:          ;e86f
        mvi     b,0
waite:          ;e871
        call    wait0   ;0e880h
        dcr     b
        jnz     waite   ;0e871h
        ret
breakvg:                ;e879
        mvi     a,0d0h
writevgcmd:             ;e87b
        sta     cmdreg  ;0fb18h
        mvi     a,0fh
wait0:          ;e880
        dcr     a
        jnz     wait0   ;0e880h
        ret

        ds      03a1h

alwa:   ds      0032h
alwb:   ds      0032h
alwc:   ds      0032h
alwd:   ds      0032h
alwe:   ds      0012h

csva:   ds      0020h
csvb:   ds      0020h
csvc:   ds      0020h
csvd:   ds      0020h

ebuf:   ds      0080h

rdbuff: ds      0400h
        ds      0400h

F1:     db      'dir ',0,0,0,0,0,0,0,0,0,0,0,0
F2:     db      'type ',0,0,0,0,0,0,0,0,0,0,0
F3:     db      'era ',0,0,0,0,0,0,0,0,0,0,0,0
F4:     db      'ren ',0,0,0,0,0,0,0,0,0,0,0,0
F5:     db      'mim ',0,0,0,0,0,0,0,0,0,0,0,0
F6:     db      'basic ',0,0,0,0,0,0,0,0,0,0
F7:     db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
F8:     db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
F9:     db      'm80 =l',0dh,'link l',0dh,0,0
F10:    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

lf6a0:  db      80h,0,0,0,0,0
lf6a6:  db      81h,0,0,0,0,0
lf6ac:  db      82h,0,0,0,0,0
lf6b2:  db      83h,0,0,0,0,0
lf6b8:  db      84h
lf6b9:  db      0,0,0,0,0
lf6be:  db      85h,0,0,0,0,0
lf6c4:  db      86h,0,0,0,0,0
lf6ca:  db      87h,0,0,0,0,0
lf6d0:  db      88h,0,0,0,0,0
lf6d6:  db      89h,0,0,0,0,0
lf6dc:  db      8ah,0,0,0,0,0
lf6e2:  db      'del',0,0,0
lf6e8:  db      'ins',0,0,0
lf6ee:  db      'cls',0,0,0

        db      0bbh,0fbh,0fbh,0bBH
        db      0,0,0,0,' ',0,0,0

        db      0,0,0
syscopy:db      1ch
colcopy:dw      0c000h
        dw      0ffffh
cursor: db      0
csrattr:db      10h
bufchar:db      0
bufattr:db      ' '
autoflag:db      0ffh
escflag:db      0
fnum:   db      0
adrtab: db      '(',6
esctab: db      'h',6
minesc: db      '0'
limesc: db      'y'

belldiv:db      0,0bh
belldel:db      0,10h,0ffh
setflag:db      0,'/',0cdh,'64'
lf71f:  db      14h
longval:db      17h
autoval:db      1,0
getpnt: db      0ebh,0e2h
putpnt: db      0ebh,0e2h,0,0
contab: db      '6',0f7h
funtab: db      'r',0f7h
fshift: db      0
falf:   db      2
fgraph: db      0
fsel:   db      0
sndflg: db      0ffh,0,0,0,0
cont:   dw      lf6a0   ;0f6a0h
        dw      lf6a6   ;0f6a6h
        dw      lf6ac   ;0f6ach
        dw      lf6b2   ;0f6b2h
        dw      lf6b8   ;0f6b8h
        dw      lf6be   ;0f6beh
        dw      lf6c4   ;0f6c4h
        dw      lf6ca   ;0f6cah
        dw      lf6d0   ;0f6d0h
        dw      lf6d6   ;0f6d6h
        dw      lf6dc   ;0f6dch
        dw      lf6e2   ;0f6e2h
        dw      lf6e8   ;0f6e8h
        dw      lf6ee   ;0f6eeh

funt:   dw      F1      ;0f600h
        dw      F2      ;0f610h
        dw      F3      ;0f620h
        dw      F4      ;0f630h
        dw      F5      ;0f640h
        dw      F6      ;0f650h
        dw      F7      ;0f660h
        dw      F8      ;0f670h
        dw      F9      ;0f680h
        dw      F10     ;0f690h

wave1f: db      '=d'
wave2f: db      1bh,'!'
stmes:  db      0,0,0,0
lutfl:  db      0
adrlut: dw      tablut
tablut: db      000h,091h,0a2h,0b3h,0c4h,0d5h,0e6h,0f7h
        db      0f8h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh
flgint: db      0
prntab: dw      PRNENCTAB

        db      0,0,0,0,0ffh,0fbh,0ffh
        db      0ffh,0ffh,0fbh,0ffh,0efh,0,0,0
        db      0,0,0,0,10h,0dfh,0ffh,0ffh,0ffh
        db      0ffh,0ffh,0ffh,0fbh,0,0,0,0,0
        db      0,0,0,0ffh,0ffh,0ffh,0ffh,0ffh
        db      0ffh,0ffh,0fbh,0,0,0,'@@',0
        db      0,'@',0bfh,0ffh,0bfh,0fbh,0ffh
        db      0ffh,0ffh,0ffh,0efh,0ffh,0ffh,0ffh
        db      0ffh,0ffh

MemINTTAB:
        dw      le3d3
vi0:    dw      vintnop ;0dc0ch
vi1:    dw      vintnop ;0dc0ch
vi2:    dw      vintnop ;0dc0ch
vi3:    dw      vintnop ;0dc0ch
vi4:    dw      vint4   ;0dc1ch
vi5:    dw      vintnop ;0dc0ch
vi6:    dw      vintnop ;0dc0ch
vi7:    dw      vintnop ;0dc0ch
vi8:    dw      vint8   ;0dc46h
        dw      0
        dw      0
        dw      0

intbase:                ;f7e0
        jmp     int0    ;0dbd0h
        nop
        jmp     int1    ;0dbd7h
        nop
        jmp     int2    ;0dbdeh
        nop
        jmp     int3    ;0dbe5h
        nop
        jmp     int4    ;0dbech
        nop
        jmp     int5    ;0dbf3h
        nop
        jmp     int6    ;0dbfah
        nop
        jmp     int7    ;0dc01h
        end
     int5    ;0dbf3h
    