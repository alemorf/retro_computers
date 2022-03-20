    ; /media/alemorf/alefpash/work/z/cmm/_test.c:2 
    ; _test.h:2 
    ; _test.h:3 void test()
test:
    ; _test.h:4 {
    ; _test.h:5 hl = de;
    ld   h, d
    ld   l, e
    ; _test.h:6 }
    ret
    ; _test.h:7 
    ; _test.h:8 void test2()
test2:
    ; _test.h:9 {
    ; _test.h:10 b = 1;
    ld   b, 1
    ; _test.h:11 }
    ret
    ; _test.h:12 
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:3 uint8_t test[] = {
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:4 @"Привет",
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:5 1,
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:6 @"Земля"
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:7 };
test:
    db 207
    db 240
    db 232
    db 226
    db 229
    db 242
    db 1
    db 199
    db 229
    db 236
    db 235
    db 255
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:8 
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:9 void getNpcSprite(hl)
getNpcSprite:
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:10 {    
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:11 }
    ret
    ; /media/alemorf/alefpash/work/z/cmm/_test.c:12 
