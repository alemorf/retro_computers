; Вся логика игры Тетрис

map  db 232 dup(0)

// const
WIDTH     = 10
HEIGHT    = 20
BPL       = WIDTH+1
START     = 1
MAP_SIZE  = (START + (BPL * (HEIGHT + 1)))

;----------------------------------------------------------------------------------------------------------------------

speeds         db 200/2,110/2,60/2,40/2,30/2,15/2 ; Скорости для каждого уровня
timer          db 0
lastPressedKey db 0
figureA        db 0
figureO        db 0 ;  O+С должны быть подряд
figureC        db 0
nextO          db 0 ;  O+С должны быть подряд
nextC          db 0
score          dw 0
bestScore      dw 0
level          db 0
gameOverFlag   db 0

;-------------------------------------------------------------------------------
; Перерисовать весь экран

redrawAll:
    call drawBackgrond
    call invalidatePlayfield
    call redrawNewFigure
    call redrawMap
    call redrawScore
    call paletteShow
    ret

;-------------------------------------------------------------------------------

checkFigure:
    ; return map[a];
    mov a, m
    ora a
    ret

;-------------------------------------------------------------------------------

; map[a] = figureC;
; return false;

drawFigure:
    lda  figureC
    mov  m, a
    xra  a ; return z
    ret

;-------------------------------------------------------------------------------

clearFigure:
    mvi m, 0
    xra a ; return z
    ret

;-------------------------------------------------------------------------------

; return fn(x, y, figureA + START + x + y * BPL);

; a & 3, (a >> 2) & 3
; a = y
; d = x

decodeFigure2:
    mov  l, a
    ani  3
    mov  d, a ; d - это X
    mov  a, l
    rrc
    rrc
    ani  3
    mov  e, a ; e - это Y
    add  a ; *2
    add  a ; *4
    add  e ; *5
    add  a ; *10
    add  e ; *11
    add  d
    mov  b, a
    lda  figureA
    add  b
    mvi  h, 0
    mov  l, a
    lxi  b, map + START
    dad  b

    ; call
decodeFigure3 = $+1
    jmp 0

;-------------------------------------------------------------------------------
; return decodeFigure2(fn, a) || decodeFigure2(a >> 4);

decodeFigure1:
    mov  l, a
    push h
    call decodeFigure2
    pop  h
    rnz
    mov  a, l
    rrc
    rrc
    rrc
    rrc
    jmp  decodeFigure2

;-------------------------------------------------------------------------------
; return true;

figures:
    db 81,132,16,101,81,132,16,101,64,149,84,33,64,149,84,33,81,217,84,118
    db 81,217,84,118,16,84,16,84,16,84,16,84,65,101,64,88,16,82,81,73,64
    db 152,16,66,16,149,84,38,81,137,64,101,16,132,16,98

decodeFigure:
    lda  figureO

decodeFigureEx:
    shld decodeFigure3

    ; if(decodeFigure1(fn, figures[figureO + 0])) return true;
    mov  l, a
    mvi  h, 0
    lxi  d, figures
    dad  d
    mov  a, m
    push h
    call decodeFigure1
    pop  h
    rnz

    ; return decodeFigure1(fn, figures[figureO + 1]);
    inx  h
    mov  a, m
    jmp  decodeFigure1

;-------------------------------------------------------------------------------

gen:
    ;nextO = Math.floor(Math.random() * 7) * 2 * 4;
    call rand
gen_2:
    sbi  7
    jnc  gen_2
    adi  7
    ; * 2 * 4
    add  a
    add  a
    add  a
    sta  nextO

    ;nextC = Math.floor(Math.random() * (colors.length - 1)) + 1;
    call rand
gen_3:
    sbi  3
    jnc  gen_3
    adi  3
    inr  a
    sta  nextC
    ret

;-------------------------------------------------------------------------------

newFigureEx:
    ; figureO = nextO;
    lhld nextO
    shld figureO

    ; figureA = START + ((WIDTH - 1) >> 1);
    mvi  a, 4
    sta  figureA

    ; if(decodeFigure(checkFigure)) gameOverFlag = 1;
    lxi  h, checkFigure
    call decodeFigure
    jz   newFigure_1
    mvi  a, 1
    sta  gameOverFlag
newFigure_1:

    ; decodeFigure(drawFigure);
    lxi  h, drawFigure
    call decodeFigure

    ; gen();
    jmp gen

;-------------------------------------------------------------------------------

newFigure:
    call newFigureEx

    ; redrawNewFigure();
    call redrawNewFigure

    ; redrawMap();
    jmp  redrawMap

;-------------------------------------------------------------------------------

move:
    ; decodeFigure(clearFigure);
    push b
    lxi  h, clearFigure
    call decodeFigure
    pop  b

    ; figureA += d;
    lda figureA
    push psw
    add c
    sta figureA

    ; var o1 = figureO;
    lda  figureO
    push psw

    ; if(r) figureO = ((figureO + 2) & 6) + (figureO & ~6);
    dcr b
    jnz move_1

    mov b, a
    inr a
    inr a
    ani 6
    mov c, a
    mov a, b
    ani 0F9h
    add c
    sta figureO

move_1:

    ; if(!decodeFigure(checkFigure)) {
    lxi  h, checkFigure
    call decodeFigure
    jz   move_2

    ; figureA -= d;
    ; figureO = o1;
    pop psw
    sta figureO
    pop psw
    sta figureA

    ; decodeFigure(drawFigure);
    lxi  h, drawFigure
    call decodeFigure

    ; return false;
    xra a
    ret

move_2:
    ; free tmp
    pop psw
    pop psw

    ; decodeFigure(drawFigure);
    lxi  h, drawFigure
    call decodeFigure

    ; redrawMap();
    call redrawMap

    ; return true;
    xra a
    inr a
    ret

;-------------------------------------------------------------------------------

; hl - address

deleteLine:
    mvi  a, 7
deleteLine_1:
    push psw
    push h
    mvi  c, WIDTH
    out  0B0h
    call memset8
    call redrawMap
    pop  h
    pop  psw
    dcr  a
    jnz  deleteLine_1


    ; a--;
    dcx  h

    ; prepare
    mov  d, h
    mov  e, l
    lxi  b, BPL
    dad  b

    ; for(;a != 0; a--) {
deleteLine_1:
    ldax d
    dcx  d
    mov  m, a
    dcx  h

    ; if(a==0) break;
    mov  a, e
    sui  map
    mov  a, d
    sbi  (map/256)
    jnc  deleteLine_1

    ;clearLine(START);
    lxi  h, map + START
    xra  a
    mvi  c, WIDTH
    call memset8

    ; redrawMap();

    jmp  redrawMap

;-------------------------------------------------------------------------------
; hl - address

clearLine:
    ; for(var x=0; x<WIDTH; x++, a++)
    ;   map[a] = 0;
    ; return a;

    mvi  b, WIDTH
clearLine_1:
    mvi  m, 0
    inx  h
    dcr  b
    jnz  clearLine_1
    ret

;-------------------------------------------------------------------------------

newGame:
    call gen
    xra  a
    sta  level
    sta  score + 0
    sta  score + 1
    sta  gameOverFlag

    ; for(a = 1, y = HEIGHT; y != 0; y--)
    ;    a = clearLine(a) + 1;

    lxi  h, map
    mvi  c, HEIGHT
newGame_1:
    mvi  m, 1
    inx  h
    call clearLine
    dcr  c
    jnz  newGame_1
    mvi  c, BPL + 1
newGame_1a:
    mvi  m, 1
    inx  h
    dcr  c
    jnz  newGame_1a


    call  newFigureEx

    call  redrawAll

    ret

;-------------------------------------------------------------------------------

checkLine:
    ; for(var x = WIDTH; x != 0; x--, a++)
    ;     if(map[a] == 0)
    ;         return false;
    mvi  c, WIDTH
checkLine_1:
    mov  a, m
    ora  a
    rz
    inx  h
    dcr  c
    jnz  checkLine_1

    ; return true;
    xra a
    inr a
    ret

;-------------------------------------------------------------------------------

;setLevel:
    ; level = l;
;    sta level;

    ; initTimer();;
    ; call initTimer
;
    ; redrawAll();
;    jmp redrawAll

;-------------------------------------------------------------------------------

checkLines:
    mvi  a, 0C9h
    sta  checkLines_3
    ; var f = false;
    ; var a = START + BPL * (HEIGHT - 1);
    lxi h, map + START + (BPL * (HEIGHT - 1))
checkLines_1:
    ; for(;a != START;)
    ; {
    ;     if(checkLine(a)) {
    push h
    call checkLine
    pop  h
    jz checkLines_2
    ;         deleteLine(a);
    push h
    call deleteLine
    ;         score++;
    lhld score
    inx  h
    shld score
    ; if(bestScore < score) bestScore = score
    xchg
    lhld bestScore
    mov  a, l
    sub  e
    mov  a, h
    sbc  d
    jnc checkLines_4
    xchg
    shld bestScore
checkLines_4:
    ; f = true;
    xra  a
    sta  checkLines_3
    pop  h
    ;         continue;
    jmp checkLines_1
checkLines_2:
    ;     }
    ;     a -= BPL;
    lxi d, 65536-BPL
    dad d
    ; cond
    mov a, l
    sui (map + START + 1)
    mov a, h
    sbi (map + START + 1) / 256
    jnc checkLines_1
    ; if(f) {
checkLines_3:
    ret
    ;     redrawScore();
    call redrawScore
    ; hl = score/30;
    lhld score
    xchg
    lxi  h, 30
    call div16
    mov  a, l
setLevel1:
    ; if(a <= level) return;
    lhld level
    cmp  l
    rz
    rc
    ; if(a >= LEVELS_COUNT) return
    cpi  LEVELS_COUNT
    rnc
    sta  level
    jmp  redrawAll

;-------------------------------------------------------------------------------

nextLevel:
    lda  level
    inr  a
    call setLevel1
    jmp  gameLoop

;-------------------------------------------------------------------------------

tick:
    ; if(move(BPL, 0)) return true;
    lxi  b, BPL
    call move

    rnz

    ; checkLines();
    call checkLines

    ; newFigure();
    call newFigure

    ; return false;
    ret


down:
    ; while(move(BPL, 0));
    lxi  b, BPL
    call move

    jnz  down

    ; checkLines();
    call checkLines

    ; newFigure();
    call newFigure

    ; initTimer();
    ;!!!!!!!!!!!!!!!!!!!!!!
    jmp gameLoop

;----------------------------------------------------------------------------------------------------------------------

tetris:
    call newGame

gameLoop:
    lda  gameOverFlag
    ora  a
    rnz

    lda  timer
    dcr  a
    jnz  gameLoop_2

    call tick

    lhld level ; 0..5
    mvi  h, 0
    lxi  d, speeds
    dad  d
    mov  a, m

gameLoop_2:
    sta  timer ; by level

    ; Привязываем генератор случайных чисел к нажатиях клавиш пользователем.
    call rand

    ; Получить код нажатой клавиши
    call inkey_FC12

    ; Если таймер установлен
    lhld lastPressedKey
    cmp  l
    jnz  gameLoop_1a
    mvi  a, 0FFh
    jmp  gameLoop_2a
gameLoop_1a:
    sta  lastPressedKey
gameLoop_2a:

gameLoop_185:
    ; Клавиша "Вверх"
    cpi  136
    jnz  gameLoop_16
    lxi  b, 100h
    call move
    jmp  gameLoop
gameLoop_16:
    cpi  '1'
    jz   nextLevel

    ; Клавиша "Вниз"
    cpi  130
    jz   down

    ; Клавиша "Влево"
    cpi  132
    jnz  gameLoop_18
    lxi  b, 0FFh
    call move
gameLoop_18:
    ; Клавиша "Вправо"
    cpi  134
    jnz  gameLoop_19
    lxi  b, 01h
    call move
    jmp  gameLoop
gameLoop_19:
    lxi  b, 0
    call move
    jmp  gameLoop
