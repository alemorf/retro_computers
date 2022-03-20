#include <graph.h>

uint graphOffset;

void graphXor() {
  asm {
    lxi h, 0FEh ; CPI
    mvi a, 0AAh
    jmp graph1_l1
  }
}

void graph0() {
  asm {
    lxi h, 0E6h ; ANI
    mvi a, 0A2h
    sta fillRect1_int_cmd
    mvi a, 02Fh
    jmp graph1_l2
  }
}

void graph1() {
  asm {
    lxi h, 02FE6h ; ORI !
    mvi a, 0B2h
graph1_l1:
    sta fillRect1_int_cmd
    xra a
graph1_l2:
    sta fillRect1_int_cmd2
    mov a, l
    sta print_mode1
    sta print_mode2
    sta print_mode3
    sta print_mode4
    sta print_mode5
    sta print_mode6
    mov a, h
    sta print_mode1A
    sta print_mode2A
    sta print_mode3A
    sta print_mode4A
    sta print_mode5A
  }
}

void clrscr10(void* t, uchar w, uchar h) {
  asm {
    push b
    lxi  h, 0
    dad  sp     
    shld clrscr10_saveHl+1
    lda  clrscr10_2
    mov  c, a
    lda  clrscr10_3
    lhld clrscr10_1        
    dcx  h
    lxi  d, 0
clrscr10_l2:
    sphl
    mov  b, a
clrscr10_l1:
    push d         ; 10
    push d         ; 10
    push d         ; 10
    push d         ; 10
    push d         ; 10
    dcr b
    jnz clrscr10_l1 ; 10 = 15   
    inr h
    dcr c
    jnz clrscr10_l2
clrscr10_saveHl:
    lxi h, 0
    sphl
    pop b
  }
}

void fillRect1_int(uchar len, uchar x, uchar* a) {
asm {
    lda fillRect1_int_2
fillRect1_int_cmd2:
    nop          ; CMA = 2F NOP = 00
    mov d, a
    lda fillRect1_int_1
    mov e, a
fillRect1_int_l0:
    mov a, m
fillRect1_int_cmd:
    ora d        ; XRA D = AA, ANA D = A2, ORA D = B2
    mov m, a
    inx h
    dcr e
    jnz fillRect1_int_l0
  }
}

void fillRect1(uchar* a, ushort c, uchar l, uchar r, uchar h) {
  a += graphOffset;
  if(c==0) {
    fillRect1_int(h, l & r, a);
    return;
  }
  --c;  
  fillRect1_int(h, l, a);
  a += 0x100;
  for(; c; --c) {  
    fillRect1_int(h, 0xFF, a);
    a += 0x100;
  }  
  fillRect1_int(h, r, a);
}

void fillRect(ushort x0, uchar y0, ushort x1, uchar y1) {
  fillRect1(HORZALINEARGS(x0, y0, x1), y1-y0+1);
}

extern uchar chargen[2048];

void print_p1(uchar*,uchar*) {
  asm {
    XCHG
    LHLD print_p1_1
    PUSH B
    MVI C, 8
print1_l:
    LDAX D
print_mode1A:
    NOP
    ADD A
    ADD A
    MOV B, A
    MOV A, M
print_mode1:
    ANI 3
    XRA B
    MOV M, A

    INX D
    INX H
    DCR C
    JNZ print1_l
    POP B
  }
}

void print_p2(uchar*,uchar*) {
  asm {
    XCHG
    LHLD print_p2_1
    PUSH B
    MVI C, 8
print2_l:
    LDAX D    
print_mode2A:
    NOP
    ADD A
    ADC A
    ADC A
    ADC A
    PUSH PSW
    ADC A
    ANI 00000011b
    MOV B, A
    MOV A, M
print_mode2:
    ANI 0FCh
    XRA B
    MOV M, A

    INR H

    POP PSW
    ANI 011110000b
    MOV B, A
    MOV A, M
print_mode3:
    ANI 00Fh
    XRA B
    MOV M, A

    DCR H

    INX D
    INX H
    DCR C
    JNZ print2_l

    POP B
  }
}

void print_p3(uchar*,uchar*) {
  asm {
    XCHG
    LHLD print_p3_1
    PUSH B
    MVI C, 8
print3_l:
    LDAX D    
print_mode3A:
    NOP
    RAR
    RAR
    ANI 00001111b
    MOV B, A
    MOV A, M
print_mode4:
    ANI 0F0h
    XRA B
    MOV M, A

    INR H

    LDAX D    
print_mode4A:
    NOP
    RAR
    RAR
    RAR
    ANI 11000000b
    MOV B, A
    MOV A, M
print_mode5:
    ANI 03Fh
    XRA B
    MOV M, A

    DCR H

    INX D
    INX H
    DCR C
    JNZ print3_l

    POP B
  }
}

void print_p4(uchar*,uchar*) {
  asm {
    XCHG
    LHLD print_p4_1
    PUSH B
    MVI C, 8
print4_l:
    LDAX D    
print_mode5A:
    NOP
    ANI 03Fh
    MOV B, A
    MOV A, M
print_mode6:
    ANI 0C0h
    XRA B
    MOV M, A
    INX D
    INX H
    DCR C
    JNZ print4_l
    POP B
  }
}

void print1(uchar* d, uchar st, uchar n, char* text) {
  uchar* s;
  uchar c, e;
  d += graphOffset;
  e = n&0x80; n&=0x7F;
  while(1) { 
    if(n == 0) return;     
    c = *text;
    if(c) ++text; else if(!e) return;
    s = chargen + c*8;
    switch(st) {
      case 0: print_p1(d, s); ++st; break;
      case 1: print_p2(d, s); ++st; d += 0x100; break;
      case 2: print_p3(d, s); ++st; d += 0x100; break;
      case 3: print_p4(d, s); st=0; d += 0x100; break;
    }  
    --n;
  }
}

void rect1(uchar* a, ushort c, uchar ll, uchar rr, uchar l, uchar r, uchar h) {
  fillRect1(a, c, l, r, 1);
  fillRect1(a, 0, ll, ll, h);
  fillRect1(a+c*256, 0, rr, rr, h);
  fillRect1(a+h-1, c, l, r, 1);
}

void rect(ushort x, uchar y, ushort x1, uchar y1) {
  rect1(RECTARGS(x, y, x1, y1));
}

void print(uchar x, uchar y, uchar n, char* text) {
  print1(PRINTARGS(x, y), n, text);
}

void scroll(char* d, char* s, uchar w, uchar h) {          
  d += graphOffset;
  s += graphOffset;
  if(d>s) {
//    d += h; s += h;
    for(; w; --w, d+=0x100, s+=0x100)
      memcpy_back(d, s, h);
  }
  for(; w; --w, d+=0x100, s+=0x100)
    memcpy(d, s, h);
}
