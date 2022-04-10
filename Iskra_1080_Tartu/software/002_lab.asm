; Исходный код игры Лабиринт для компьютера Искра 1080 Тарту
; Восстановлено 13-03-2018 Алексей Морозов

; Проверял компиляцию в tasm.exe
; TASM Assembler. Version 3.2 September, 2001.
; Copyright (C) 2001 Squak Valley Software

; Заголовок LVT файла. Это надо для загрузки в эмулятор b2m.

.org 234
.db 4ch, 56h, 4fh, 56h, 2fh, 32h, 2eh, 30h, 2fh, 0d0h, 6ch, 61h, 62h, 20h, 20h, 20h
.dw entry
.dw end-1
.dw entry

; Используемые точки входа в ПЗУ (BIOS)

setCursorY_F7DC   = 0F7DCh
setCursorX_F7BE   = 0F7BEh
printString_F137  = 0F137h
waitKey_FDAC      = 0FDACh
drawChar1_F7FB    = 0F7FBh
drawChar2_F8B0    = 0F8B0h
cursorUp_FA93     = 0FA93h
cursorDown_FA9A   = 0FA9Ah
cursorLeft_FAB3   = 0FAB3h
cursorRight_FACE  = 0FACEh
clearScreen1_F9A0 = 0F9A0h
drawText_F12F     = 0F12Fh
inkey_FC12        = 0FC12h
inkey_FB94        = 0FB94h

; Переменные BIOS

videoMode_C802    = 0C802h
fontType_C803     = 0C803h
cursorX_C807      = 0C807h
cursorY_C808      = 0C808h
cursorAddr_C80A   = 0C80Ah
font_C819         = 0C819h

entry:
        ; Это похоже на место для отладочной команды JMP
        nop
        nop
        nop
        
        ; Сброс    рекордов. Переменную bestScore сбрасывать не обязательно, 
        ; она будет перезаписана ниже.
        lxi  h, 0
        shld bestScore    
        shld bestScoreForLevel1
        shld bestScoreForLevel2
        shld bestScoreForLevel3
        
        ; Инициализация стека
        lxi  sp, 0C900h    
        
        ; Режим экрана 64 символа в ширину
        mvi  a, 40h
        sta  videoMode_C802
        
        ; Устанавливаем свой шрифт
        lxi  h, font
        shld font_C819
        
        ; Параметры шрифта        
        mvi  a, 10
        sta  fontType_C803
        
        ; Установка палитры для каждого из 4-х цветов.
        mvi  a, 1
        out  90h
        mvi  a, 5
        out  91h
        mvi  a, 3
        out  92h
        mvi  a, 6
        out  93h

        ; Вывод    стартового экрана и ожидание нажатия клавиши
restartGame:
        call clearScreen    
        mvi  c, 0
        lxi  h, aStartScreen
        call printString_F137
        call waitKey_FDAC
        
        ; Вывод надписи    "Степень трудности" и ожидание нажатия клавиш 1,2,3
        ; Выбранная сложность сохраняется в переменую level в виде числа 1,2 или 3
        call clearScreen1_F9A0

enterLevel:
        mvi  a, 15
        call setCursorY_F7DC
        mvi  a, 20
        call setCursorX_F7BE
        mvi  c, '$'
        lxi  h, aEnterLevel
        call printString_F137
        call waitKey_FDAC
        sui  '0'        
        sta  level
        cpi  1
        jc   enterLevel
        cpi  4
        jnc  enterLevel
        
        ; Установка курсора в 4:20. Не имеет смысла.
        mvi  a, 20
        call setCursorY_F7DC
        mvi  a, 4
        call setCursorX_F7BE
        
        ; Установка переменной lives в 4. Это кол-во жизней.
        mvi     a, 4
        sta   lives

        ; *** Рисование уровня ***
        
        ; Нарисовать 7 вертикальных тунелей
        call drawVertTunnets
                
        ; Нарисовать верхние и нижние тупики 7 вертикальных тунелей
        call drawVertEnd    
        
        ; Рисование 3x6 горизонтальных тоннелей
        mvi  a, 8
        call setCursorX_F7BE
        mvi  a, 5
        call setCursorY_F7DC
        call drawHorzTunnels    
        
        ; Крайний левый тонель, где игрок начинает игру.
        mvi  a, 0
        call setCursorX_F7BE
        mvi  a, 19
        call setCursorY_F7DC
        call drawHorzTunnel
        
        ; Крайний правый тонель, куда игрок должен придти
        mvi  a, 56
        call setCursorX_F7BE
        mvi  a, 19
        call setCursorY_F7DC
        call drawHorzTunnel        
        
        ; Рисование тупика этого тоннеля
        call cursorUp_FA93    
        lda  cursorX_C807
        adi  4
        call setCursorX_F7BE
        mvi  a, 93
        call drawChar2_F8B0
        
        ; Копирование одного битплана экрана в другой
        ; Заливка строки состояния цветом
        call clearStatLineAndCopyBitpl
        
        ; Звук?
        out   0F8h
        out   0B9h
        
        ; Рисование жизней
        mvi  a, 1
        call setCursorX_F7BE
        mvi  a, 12
        call setCursorY_F7DC
        mvi  c, 3
drawLives:
        push b
        call drawChars91DD
        pop  b
        dcr  c
        jnz  drawLives
            
        ; Сохраняем координаты последней нарисованной жизни
        call cursorUp_FA93
        call cursorUp_FA93
        lda  cursorX_C807
        sta  livesX
        lda  cursorY_C808
        sta  livesY
        
        ; Переместить игрока в начальную позицию
        call movePlayerToStart
        
        ; Координаты для рисования трупов
        mvi  a, 5
        sta  corpseX
        mvi  a, 17h
        sta  corpseY
        
        ; Установить начальные координаты всех врагов и нарисовать всех врагов
        call initEnemies
        
        ; Вывеcти надпись "Очки"
        mvi  a, 48
        call setCursorX_F7BE
        mvi  a, 22
        call setCursorY_F7DC
        mvi  c, 20h ; ' '
        lxi  h, aOxkk    ; Очки
        call drawText_F12F

        ; Обнулить переменную score (это очки)        
        lxi  h, 0
        shld  score
        
        ; Вывести очки на экран, т.е. 0
        call drawScore
        
        ; Вывети надпись "Рекорд"
        mvi  a, 48        
        call  setCursorX_F7BE
        mvi  a, 24
        call  setCursorY_F7DC
        mvi  c, ' '
        lxi  h, aPekopz    ; Рекорд
        call drawText_F12F
        
        ; Нарисовать полосу времени и сбросить заморозку врагов        
        call drawTimeLineAndInitFreeze 
        
        ; Нарисовать стенки в зависимости от уровня сложности
        ; и загрузить соответствующий уровню рекорд
        lda  level
        cpi  1
        jz   drawLevel1
        cpi  2
        jz   drawLevel2
        call drawLevel3
        lhld bestScoreForLevel3
        jmp  afterDrawLevel

;----------------------------------------------------------------------------
        
drawLevel1:
        ; Нарисовать стенку 1
        mvi  a, 14
        call setCursorY_F7DC
        mvi  a, 44
        call setCursorX_F7BE
        mvi  a, 93
        call drawChar2_F8B0
        
        ; Нарисовать стенку 2
        mvi  a, 9
        call setCursorY_F7DC
        mvi  a, 15
        call setCursorX_F7BE
        mvi  a, 93
        call drawChar2_F8B0
                
        lhld  bestScoreForLevel1

afterDrawLevel:
        call setAndDrawBestScore
        jmp  gameLoop
        
;----------------------------------------------------------------------------

drawLevel2:
        ; Нарисовать 4 стенки
        call drawLevel2a
        lhld bestScoreForLevel2
        jmp    afterDrawLevel
        
;----------------------------------------------------------------------------
; Игровой цикл

gameLoop:
        ; Разморозка врагов и уменьшение время
        call unfreezeEnemyAndTime

        ; Движение врага 1
        lda  enemy1Off
        ora  a
        jnz  gameLoop_1
        call enemy1Move
        call cmpLives0
        jz   gameOver
        jmp  gameLoop_2
gameLoop_1:
        ; Рисование замороженного врага 1
        lda  enemy1Y
        call setCursorY_F7DC
        lda  enemy1X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0
gameLoop_2:

        ; Движение врага 2 (да, я тоже не понял, почему автор не использовал циклы)
        lda  enemy2Off
        ora  a
        jnz  gameLoop_3
        call enemy2Move
        call cmpLives0
        jz  gameOver
        jmp gameLoop_4
gameLoop_3:
        ; Рисование замороженного врага 2
        lda  enemy2Y
        call setCursorY_F7DC
        lda  enemy2X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0

        ; Движение врага 3
gameLoop_4:
        lda  enemy3Off
        ora  a
        jnz  gameLoop_5
        call enemy3Move
        call cmpLives0
        jz   gameOver
        jmp  gameLoop_6
gameLoop_5:
        lda  enemy3Y
        call setCursorY_F7DC
        lda  enemy3X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0

        ; Движение врага 4
gameLoop_6:
        lda  enemy4Off
        ora  a
        jnz  gameLoop_7
        call enemy4Move
        call cmpLives0
        jz   gameOver
        jmp  gameLoop_8
gameLoop_7:
        lda  enemy4Y
        call setCursorY_F7DC
        lda  enemy4X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0

        ; Движение врага 5
gameLoop_8:
        lda enemy5Off
        ora    a
        jnz    gameLoop_9
        call enemy5Move
        call cmpLives0
        jz    gameOver
        jmp    gameLoop_10
gameLoop_9:
        lda enemy5Y
        call setCursorY_F7DC
        lda enemy5X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0

        ; Движение врага 6
gameLoop_10:
        lda enemy6Off
        ora    a
        jnz    gameLoop_11
        call enemy6Move
        call cmpLives0
        jz    gameOver
        jmp    gameLoop_12
gameLoop_11:
        lda enemy6Y
        call setCursorY_F7DC
        lda enemy6X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0

        ; Движение врага 7
gameLoop_12:
        lda enemy7Off
        ora    a
        jnz    gameLoop_13
        call enemy7Move
        call cmpLives0
        jz    gameOver
        jmp    gameLoop_14
gameLoop_13:
        lda enemy7Y
        call setCursorY_F7DC
        lda enemy7X
        call setCursorX_F7BE
        mvi  a, 81
        call drawChar1_F7FB
        mvi  a, 82
        call drawChar2_F8B0
gameLoop_14:

        ; Получить код нажатой клавиши
        call inkey_FC12
        
        ; Если ничего не нажато, то переходим к началу цикла
        cpi  0FFh
        jz   gameLoop
        
        ; Если нажата М, то перезапуск игры
        cpi  'M'        
        jz    restartGame
        
        ; Если нажат пробел, то пауза
        cpi  ' '
        cz   pause
        
        ; Если нажата точка и таймер заморозки не запущен, то заморозка врага
        cpi  '.'
        jnz  gameLoop_15
        lda  freezeTimer
        ora  a
        jnz  gameLoop_15
        call playerFreeze
gameLoop_15:

        ; Если нажата клавиша "Вверх"
        cpi    136
        jnz    gameLoop_16
        call playerTryUp
        jmp    gameLoop
gameLoop_16:

        ; Клавиша "Вниз" - вызов playerTryDown и переход на начало цикла
        cpi    130
        jnz    gameLoop_17
        call   playerTryDown
        jmp    gameLoop
gameLoop_17:

        ; Клавиша "Влево" - вызов playerTryLeft и переход на начало цикла
        cpi    132
        jnz    gameLoop_18
        call   playerTryLeft
        jmp    gameLoop
gameLoop_18:

        ; Если не нажата клавиша "Вправо", то переход на начало цикла
        cpi    134
        jnz    gameLoop
        
        ; Иначе вызов playerTryRight
        call playerTryRight
        
        ; Если игрок не требует инициализации, то переход на начало цикла
        lda  needInitPlayer
        ora  a
        jz   gameLoop
        
        ; Если игрок набрал меньше 39936 очков, то переход на initPlayer
        lhld  score
        mov   a, h
        cpi   156
        jc    initPlayer
        
        ; Вывод надписи *** Olete ammendanud selle raskusastme ***
        mvi  a, 0
        call setCursorY_F7DC
        mvi  a, 10
        call setCursorX_F7BE
        lxi  h, aWin
        mvi  c, '$'
        call printString_F137
        
        ; Звуковой эффект
        mvi  c, 5
winSound:
        lxi  h, 0
        call delay
        call playSound3
        dcr  c
        jnz  winSound
        
        ; Перезапуск игры
        jmp  restartGame
        
;----------------------------------------------------------------------------

initPlayer:
        ; Переместить игрока в начальную позицию
        call movePlayerToStart
        
        ; Стереть мешок
        mvi  a, 58        
        call setCursorX_F7BE
        mvi  a, 17
        call setCursorY_F7DC
        mvi  a, 32
        call drawChar2_F8B0
        
        ; Сбросить флаг "Игрок не инициализирован"
        xra  a
        sta  needInitPlayer
        
        ; Перерисовать строку времени и разморозить врагов
        call drawTimeLineAndInitFreeze
        
        ; Переход на начало цикла
        jmp  gameLoop

;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
; Сравнить кол-во жизней с нулем

cmpLives0:
        lda  lives
        ora  a
        ret

;----------------------------------------------------------------------------
; Звуковой эффект 4

playSound4:
        lxi  b, sound4
        call playSound
        ret

;----------------------------------------------------------------------------
; Конец игры

gameOver:
        ; Звуковой эффект 4
        call playSound4
        out  0F8h
        out  0B9h
        
        ; Ожидание нажачтия клавиши
        call waitKey_FDAC
        jmp  restartGame

;----------------------------------------------------------------------------
; Выход из игры. Эта функция нигде не используется.

exitGame:
        ; Установка стандартного шрифта
        lxi  h, 0C100h
        shld font_C819
        xra  a
        sta  fontType_C803
        
        ; Очистка экрана
        call clearScreen1_F9A0
        
        ; Возврат в ОС
        jmp  0
        
;----------------------------------------------------------------------------
; Вызывается при нажатии клавиши влево

playerTryLeft:
        ; Установить курсор на игрока
        call setCursorToPlayer 
        
        ; Если игрок в крайнем левом положении, то выходим
        lda playerX
        cpi 0
        rz
        
        ; Если в ячейке куда двигается игрок не пусто, то выходим
        lhld cursorAddr_C80A
        dcx  h
        mov  a, m
        cpi  32
        rnz
        
        ; Звуковой эффект
        out  0B0h
        
        ; Стереть и нарисовать игрока в другом месте
        call cursorLeft_FAB3    
        mvi  a, 91
        call drawChar1_F7FB
        mvi  a, 92
        call drawChar1_F7FB
        mvi  a, 32
        call drawChar2_F8B0
        call cursorLeft_FAB3
        call cursorLeft_FAB3
        
        ; Сохранить координату X игрока
        lda  cursorX_C807
        sta  playerX
        ret
        
;----------------------------------------------------------------------------
; Вызывается при нажатии клавиши вправо

playerTryRight:
        ; Сброс флага "Игрок не инициализирован"
        xra  a
        sta  needInitPlayer
        
        ; Установить курсор на игрока
        call setCursorToPlayer
        
        ; Если игрок в крайнем правом положении, то переходим
        ; на функцию обработки конца уровня
        lda  playerX        
        cpi  57
        jz   levelDone
        
        ; Если в ячейке куда двигается игрок не пусто, то выходим
        lhld cursorAddr_C80A
        inx  h
        inx  h
        mov  a, m
        cpi  32
        rnz
        
        ; Звуковой эффект
        out  0B0h
        
        ; Стереть и нарисовать игрока в другом месте
        call cursorRight_FACE
        call cursorRight_FACE
        mvi  a, 92
        call drawChar2_F8B0
        call cursorLeft_FAB3
        mvi  a, 91
        call drawChar2_F8B0
        call cursorLeft_FAB3
        mvi  a, 32
        call drawChar1_F7FB

        ; Сохранить координату X игрока
        lda  cursorX_C807
        sta  playerX
        ret

;----------------------------------------------------------------------------
; Вызывается, когда игрок прошел уровень до конца

levelDone:
        ; Стираем игрока с экрана
        mvi  a, 32
        call drawChar1_F7FB
        mvi  a, 32
        call drawChar2_F8B0
        
        ; Рисуем мешок
        mvi  a, 17
        call setCursorY_F7DC
        mvi  a, 92
        call drawChar2_F8B0
        
        ; Увеличиваем счет
        lhld score
        call addTimeToHl
        shld score
        
        ; Рисуем счет на экране
        call drawScore
        
        ; Если счет больше рекора, то обновляем рекорд
        lhld score
        xchg
        lhld bestScore
        call cmpHlDe
        jnc  levelDone_3
        lhld score
        shld bestScore
        lda  level
        cpi  1
        jz   levelDone_1
        cpi  2
        jz   levelDone_2
        shld bestScoreForLevel3
        jmp  levelDone_3
levelDone_1:
        shld bestScoreForLevel1
        jmp  levelDone_3
levelDone_2:
        shld bestScoreForLevel2
levelDone_3:
        call setAndDrawBestScore
        
        ; Установка флага "Игрок не инициализирован"
        mvi  a, 1
        sta  needInitPlayer
        
        ; Звуковой эффект        
        call playSound6
        ret
        
;----------------------------------------------------------------------------
; Вызывается при нажатии клавиши вниз

playerTryDown:
        ; Установить курсор на игрока
        call setCursorToPlayer
        
        ; Если игрок в крайнем нижнем положении, то выходим
        lda  playerY
        cpi  23
        rz
        
        ; Если в ячейке куда двигается игрок не пусто, то выходим
        lhld cursorAddr_C80A
        lxi  d, 64
        dad  d
        mov  a, m
        cpi  32        
        rnz
        inx  h
        mov  a, m
        cpi  32
        rnz
        
        ; Звуковой эффект
        out  0B0h
        
        ; Стереть и нарисовать игрока в другом месте
        mvi  a, 32
        call drawChar1_F7FB
        mvi  a, 32
        call drawChar2_F8B0
        call cursorDown_FA9A
        mvi  a, 5Ch
        call drawChar2_F8B0
        call cursorLeft_FAB3
        mvi  a, 5Bh
        call drawChar2_F8B0
        
        ; Сохранить координату Y игрока
        lda  cursorY_C808
        sta  playerY
        ret

;----------------------------------------------------------------------------
; Вызывается при нажатии клавиши вверх

playerTryUp:
        ; Установить курсор на игрока
        call setCursorToPlayer
        
        ; Если игрок в крайнем верхнем положении, то выходим
        lda  playerY
        cpi  0
        rz
        
        ; Если в ячейке куда двигается игрок не пусто, то выходим
        lhld cursorAddr_C80A
        lxi  d, -64
        dad  d
        mov  a, m
        cpi  32
        rnz
        inx  h
        mov  a, m
        cpi  32
        rnz
        
        ; Звуковой эффект
        out  0B0h
        
        ; Стереть и нарисовать игрока в другом месте
        mvi  a, 32
        call drawChar1_F7FB
        mvi  a, 32
        call drawChar2_F8B0
        call cursorUp_FA93
        mvi  a, 5Ch
        call drawChar2_F8B0
        call cursorLeft_FAB3
        mvi  a, 5Bh
        call drawChar2_F8B0
        
        ; Сохранить координату Y игрока
        lda  cursorY_C808
        sta  playerY
        ret

;----------------------------------------------------------------------------
; Вызывается при нажатии пробела

pause:
        ; Цикл длится, пока не нажата любая клавиша кроме пробела
        call inkey_FB94
        cpi  20h ; ' '
        jz   pause
        cpi  0FFh
        rnz
        jmp  pause

;----------------------------------------------------------------------------
; Движение врага вверх

enemyUp:
        ; Стираем врага
        call drawSpaces2
        
        ; Рисуем врага выше
        call cursorUp_FA93
        lda  cursorY_C808
        mov  c, a
        push b
        call drawChars83_84
        
        ; Проверяем пересечение с игроком
        call enemyPlayerIntersect
        pop  b
        mov  a, c
        ret

;----------------------------------------------------------------------------
; Движение врага вниз

enemyDown:
        ; Стираем врага
        call drawSpaces2
        
        ; Рисуем врага ниже
        call cursorDown_FA9A
        lda  cursorY_C808
        mov  c, a
        push b
        call drawEnemy
        
        ; Проверяем пересечение с игроком
        call enemyPlayerIntersect
        pop    b
        mov    a, c
        ret

;----------------------------------------------------------------------------
; Рисование очков на экране

drawScore:
        ; Курсор в координаты 22x56
        mvi  a, 56
        call setCursorX_F7BE
        mvi  a, 22
        call setCursorY_F7DC
        lhld score
        
        ; Вывод числа из HL на экран
        call drawNumber
        ret

;----------------------------------------------------------------------------
; Рисование рекорда на экране

setAndDrawBestScore:
        ; Курсор в координаты 25x56
        push h
        mvi  a, 56
        call setCursorX_F7BE
        mvi  a, 24
        call setCursorY_F7DC
        pop  h
        
        ; Сохранение HL в переменную bestScore
        shld bestScore
        
        ; Вывод числа из HL на экран
        call drawNumber
        ret

;----------------------------------------------------------------------------
; Проверяем пересечение врага с игроком

enemyPlayerIntersect:
        ; Выходим если playerY != cursorY
        lda  cursorY_C808
        mov  c, a
        lda  playerY
        cmp  c
        rnz
        
        ; Если playerX == cursorX то переходим на enemyPlayerIntersect_2
        lda  cursorX_C807
        mov  c, a
        lda  playerX
        cmp  c
        jz   enemyPlayerIntersect_2        
        
        ; Если playerX-1 == cursorX то переходим на enemyPlayerIntersect_1
        dcr  a
        cmp  c
        jz   enemyPlayerIntersect_1
        
        ; Выходим если playerX+1 != cursorX
        inr  a
        inr  a
        cmp  c
        rnz

        ; Звуковой эффект и стираем игрока с экрана
        dcr  a
        call setCursorX_F7BE
        call playSound5        
        mvi  a, 20h
        call drawChar2_F8B0

        ; Вызов movePlayerToStart и выход        
        jmp  enemyPlayerIntersect_4
        
enemyPlayerIntersect_1:
        ; Звуковой эффект и стираем игрока с экрана
        inr  a
        inr  a
        call setCursorX_F7BE
        call playSound1
        mvi  a, 20h
        call drawChar2_F8B0
        
        ; Переход на 629
        jmp  enemyPlayerIntersect_3

enemyPlayerIntersect_2:
        ; Звуковой эффект
        call playSound1

enemyPlayerIntersect_3:
        ; Рисуем труп
        call drawCorpse    ; Рисование трупа и проверка конца игры
        
        ; Выходим если счетчик жизней равен нулю
        lda  lives
        ora  a
        rz
        
        ; Перерисовать строку времени и разморозить врагов        
        call drawTimeLineAndInitFreeze
        
        ; Стираем жизнь с экрана
        lda livesX
        call setCursorX_F7BE
        lda livesY
        call setCursorY_F7DC
        mvi  a, 20h ; ' '
        call drawChar2_F8B0
        
        ; Запоминаем положение курсора
        call cursorUp_FA93
        call cursorUp_FA93
        lda cursorX_C807
        sta  livesX
        lda cursorY_C808
        sta  livesY

enemyPlayerIntersect_4:
        ; Переместить игрока в начальную позицию
        call movePlayerToStart
        ret

;----------------------------------------------------------------------------
; Движение врага 1

enemy1Move:
        ; Установить курсор на врага 1         
        call enemy1SetCursor
        
        ; Если enemy1Dir=0, то вызвать enemyTryDown, иначе вызвать enemyTryUp
        ; Если enemyTryUp вернула ZF, то установить enemy1Dir=1 и повторить сначала
        ; Если enemyTryDown вернула ZF, то установить enemy1Dir=0 и повторить сначала
        lda  enemy1Dir
        cpi  0
        lda  enemy1Y
        jz   enemy1Move_2
enemy1Move_1:
        call enemyTryUp
        jz   enemy1Move_3
        sta  enemy1Y
        ret
enemy1Move_2:
        call enemyTryDown
        jz   enemy1Move_4
        sta  enemy1Y
        ret
enemy1Move_3:
        mvi  a, 0
        sta  enemy1Dir
        lda  enemy1Y
        jmp  enemy1Move_2
enemy1Move_4:
        mvi  a, 1
        sta  enemy1Dir
        lda  enemy1Y
        jmp  enemy1Move_1

;----------------------------------------------------------------------------
; Установить курсор на врага 1         

enemy1SetCursor:
        lda  enemy1X
        call setCursorX_F7BE
        lda  enemy1Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 2 (да, я тоже не понял, почему автор не использовал циклы)

enemy2Move:
        call enemy2SetCursor
        lda  enemy2Dir
        cpi  0
        lda  enemy2Y
        jz   loc_6B8
loc_6AE:
        call enemyTryUp
        jz   loc_6C2
        sta  enemy2Y
        ret
loc_6B8:
        call enemyTryDown
        jz   loc_6CD
        sta  enemy2Y
        ret
loc_6C2:
        mvi  a, 0
        sta  enemy2Dir
        lda  enemy2Y
        jmp  loc_6B8
loc_6CD:
        mvi  a, 1
        sta  enemy2Dir
        lda  enemy2Y
        jmp  loc_6AE

;----------------------------------------------------------------------------
; Установить курсор на врага 2

enemy2SetCursor:
        lda  enemy2X
        call setCursorX_F7BE
        lda  enemy2Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 3

enemy3Move:
        call enemt3SetCursor
        lda  enemy3Dir
        cpi  0
        lda  enemy3Y
        jz   loc_6FD
loc_6F3:
        call enemyTryUp
        jz   loc_707
        sta  enemy3Y
        ret
loc_6FD:
        call enemyTryDown
        jz   loc_712
        sta  enemy3Y
        ret
loc_707:
        mvi  a, 0
        sta  enemy3Dir
        lda  enemy3Y
        jmp  loc_6FD
loc_712:
        mvi  a, 1
        sta  enemy3Dir
        lda  enemy3Y
        jmp  loc_6F3

;----------------------------------------------------------------------------
; Установить курсор на врага 3

enemt3SetCursor:
        lda  enemy3X
        call setCursorX_F7BE
        lda  enemy3Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 4

enemy4Move:
        call enemy4SetCursor
        lda  enemy4Dir
        cpi  0
        lda  enemy4Y
        jz   loc_742
loc_738:
        call enemyTryUp
        jz   loc_74C
        sta  enemy4Y
        ret
loc_742:
        call enemyTryDown
        jz   loc_757
        sta  enemy4Y
        ret
loc_74C:
        mvi  a, 0
        sta  enemy4Dir
        lda  enemy4Y
        jmp  loc_742
loc_757:
        mvi  a, 1
        sta  enemy4Dir
        lda  enemy4Y
        jmp  loc_738

;----------------------------------------------------------------------------
; Установить курсор на врага 4

enemy4SetCursor:
        lda  enemy4X
        call setCursorX_F7BE
        lda  enemy4Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 5

enemy5Move:
        call enemy5SetCursor
        lda  enemy5Dir
        cpi  0
        lda  enemy5Y
        jz   loc_787
loc_77D:
        call enemyTryUp
        jz   loc_791
        sta  enemy5Y
        ret
loc_787:
        call enemyTryDown
        jz   loc_79C
        sta  enemy5Y
        ret
loc_791:
        mvi  a, 0
        sta  enemy5Dir
        lda  enemy5Y
        jmp  loc_787
loc_79C:
        mvi  a, 1
        sta  enemy5Dir
        lda  enemy5Y
        jmp  loc_77D

;----------------------------------------------------------------------------
; Установить курсор на врага 5

enemy5SetCursor:
        lda  enemy5X
        call setCursorX_F7BE
        lda  enemy5Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 6

enemy6Move:
        call enemt6SetCursor
        lda  enemy6Dir
        cpi  0
        lda  enemy6Y
        jz   loc_7CC
loc_7C2:
        call enemyTryUp
        jz   loc_7D6
        sta  enemy6Y
        ret
loc_7CC:
        call enemyTryDown
        jz   loc_7E1
        sta  enemy6Y
        ret
loc_7D6:
        mvi  a, 0
        sta  enemy6Dir
        lda  enemy6Y
        jmp  loc_7CC
loc_7E1:
        mvi  a, 1
        sta  enemy6Dir
        lda  enemy6Y
        jmp  loc_7C2

;----------------------------------------------------------------------------
; Установить курсор на врага 6

enemt6SetCursor:
        lda  enemy6X
        call setCursorX_F7BE
        lda  enemy6Y
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Движение врага 7

enemy7Move:
        call enemy7SetCursor
        lda  enemy7Dir
        cpi  0
        lda  enemy7Y
        jz   loc_811
loc_807:
        call enemyTryUp
        jz    loc_81B
        sta  enemy7Y
        ret
loc_811:
        call enemyTryDown
        jz    loc_826
        sta  enemy7Y
        ret
loc_81B:
        mvi  a, 0
        sta  enemy7Dir
        lda enemy7Y
        jmp    loc_811
loc_826:
        mvi  a, 1
        sta  enemy7Dir
        lda enemy7Y
        jmp    loc_807

;----------------------------------------------------------------------------
; Установить курсор на врага 7

enemy7SetCursor:
        lda  enemy7X
        call setCursorX_F7BE
        lda  enemy7Y
        call setCursorY_F7DC
        ret
; End of function enemy7SetCursor


;----------------------------------------------------------------------------
; Попытка движения врага вверх

enemyTryUp:
        ; Враг в крайнем верхнем положении, выходим с флагом ZF
        cpi  2
        rz
        
        ; Вызов функции, где происходит движение врага вверх
        call enemyUp
        
        ; Выход со сброшенным флагом ZF, так как в A координата врага, которая больше 0
        ani  0FFh
        ret

;----------------------------------------------------------------------------
; Попытка движения врага вниз

enemyTryDown:
        ; Враг в крайнем нижнем положении, выходим с флагом ZF
        cpi  20
        rz
        
        ; Вызов функции, где происходит движение врага вниз
        call enemyDown
        
        ; Выход со сброшенным флагом ZF, так как в A координата врага, которая больше 0
        ani  0FFh
        ret

;----------------------------------------------------------------------------
; Звуковой эффект 5

playSound5:
        lxi  b, sound5
        mvi  a, 6
        jmp  playSoundB

;----------------------------------------------------------------------------
; Звуковой эффект 3

playSound3:
        lxi  b, sound3
        mvi  a, 1
        out  90h
        call playSound
        out  0F8h
        out  0B9h
        ret

;----------------------------------------------------------------------------
; Звуковой эффект 6

playSound6:
        lxi  d, 0C8h
        lxi  h, 7D00h
        mvi  a, 5
        out  90h
        call playSoundC
        ret

;----------------------------------------------------------------------------
; Звуковой эффект 1

playSound1:
        lxi  b, sound1
playSoundA:
        mvi  a, 7
playSoundB:
        out  90h
        call playSound
        ret

;----------------------------------------------------------------------------
; Звуковой эффект 2

playSound2:
        lxi  b, sound2
        jmp  playSoundA

;----------------------------------------------------------------------------
; Вспомогательная функция для звуковых эффектов

playSound:
        ldax b
        mov  e, a
        inx  b
        ldax b
        mov  d, a
        ora  e
        rz
        inx  b
        ldax b
        mov  l, a
        inx  b
        ldax b
        mov  h, a
        push b
        call playSoundC
        pop  b
        inx  b
        jmp  playSound

;----------------------------------------------------------------------------
; Рисование трупа и проверка конца игры

drawCorpse:
        ; Курсор на место рисования трупа
        lda  corpseY
        call setCursorY_F7DC
        lda  corpseX
        call setCursorX_F7BE
        
        ; Рисование трупа
        mvi  a, 56h
        call drawChar1_F7FB
        mvi  a, 57h
        call drawChar1_F7FB
        mvi  a, 58h
        call drawChar1_F7FB
        call cursorRight_FACE
        
        ; Запоминает положение курсора
        lda  cursorX_C807
        sta  corpseX
        
        ; Звуковой эффект
        call playSound2
        
        ; Уменьшаем кол-во жизней
        lda  lives
        dcr  a
        sta  lives
        ret

;----------------------------------------------------------------------------
; Сравнить HL и DE

cmpHlDe:
        mov  a, h
        sub  d
        rnz
        mov  a, l
        sub  e
        ret
        
;----------------------------------------------------------------------------
; Нарисовать 7 вертикальных тунелей

drawVertTunnets:
        ; Очистить экран
        call clearScreen
        
        ; Нарисовать 7 вертикальных тунелей
        mvi  c, 21
drawVertTunnets_1:
        push b
        mov  a, c
        call setCursorY_F7DC
        mvi  a, 4
        call setCursorX_F7BE
drawVertTunnets_2:
        mvi  a, 5Dh
        call drawChar1_F7FB
        call cursorRight_FACE
        call cursorRight_FACE
        mvi  a, 5Dh
        call drawChar1_F7FB
        call cursorRight_FACE
        call cursorRight_FACE
        call cursorRight_FACE
        call cursorRight_FACE
        lda  cursorX_C807
        cpi  60
        jc   drawVertTunnets_2
        pop  b
        dcr  c
        jnz  drawVertTunnets_1
        ret

;----------------------------------------------------------------------------
; Нарисовать верхние и нижние тупики 7 вертикальных тунелей

drawVertEnd:
        ; Нарисовать верхние тупики 7 вертикальных тунелей
        mvi  a, 1
        call setCursorY_F7DC
        mvi  a, 4
        call setCursorX_F7BE
        mvi  a, 96 ; Верхние углы стенок        
        call drawVerticalEnd1 
        
        ; Нарисовать нижние тупики 7 вертикальных тунелей
        mvi  a, 21
        call setCursorY_F7DC
        mvi  a, 4
        call setCursorX_F7BE
        mvi  a, 95 ; Нижние углы стенок
        call drawVerticalEnd1 
        ret

;----------------------------------------------------------------------------
; Нарисовать верхние или нижние тупики 7 вертикальных тунелей

drawVerticalEnd1:
        sta  drawVerticalEndTmp
drawVerticalEnd1_1:
        lda  drawVerticalEndTmp
        call drawChar1_F7FB
        mvi  a, 94
        call drawChar1_F7FB
        mvi  a, 94
        call drawChar1_F7FB
        lda  drawVerticalEndTmp
        call drawChar1_F7FB
        call cursorRight_FACE
        call cursorRight_FACE
        call cursorRight_FACE
        call cursorRight_FACE
        lda  cursorX_C807
        cpi  60
        jc   drawVerticalEnd1_1
        ret

;----------------------------------------------------------------------------
; Установить курсор на игрока


setCursorToPlayer:            
        lda playerX
        call setCursorX_F7BE
        lda playerY
        call setCursorY_F7DC
        ret

;----------------------------------------------------------------------------
; Переместить игрока в начальную позицию

movePlayerToStart:
        ; Установка playerX,playerX = 1,20 и рисование игрока
        mvi  a, 1
        call setCursorX_F7BE
        mvi  a, 20
        call setCursorY_F7DC        
        lda cursorX_C807
        sta  playerX
        lda cursorY_C808
        sta  playerY
        mvi  a, 91
        call drawChar1_F7FB
        mvi  a, 92
        call drawChar2_F8B0
        call cursorLeft_FAB3
        call playSound3
        ret

;----------------------------------------------------------------------------
; Вывод символа 91 и перемещение курсора на две строки вниз

drawChars91DD:
        mvi  a, 91
        call drawChar2_F8B0
        call cursorDown_FA9A
        call cursorDown_FA9A
        ret
;----------------------------------------------------------------------------
; Нарисовать врага

drawEnemy:
        mvi  a, 89
        call drawChar1_F7FB
        mvi  a, 90
        call drawChar2_F8B0
        call cursorLeft_FAB3
        ret

;----------------------------------------------------------------------------
; Вывод символов 83, 84 без изменения положения курсора

drawChars83_84:
        mvi  a, 83
        call drawChar1_F7FB
        mvi  a, 84
        call drawChar2_F8B0
        call cursorLeft_FAB3
        ret

;----------------------------------------------------------------------------
; Вывод двух пробелов без изменения положения курсора

drawSpaces2:
        mvi  a, 20h
        call drawChar1_F7FB
        mvi  a, 20h
        call drawChar2_F8B0
        call cursorLeft_FAB3
        ret

;----------------------------------------------------------------------------
; Рисование 3x6 горизонтальных тоннелей

drawHorzTunnels:
        mvi  a, 8
drawHorzTunnels_1:
        push psw
        call setCursorX_F7BE
        mvi  a, 3
        call setCursorY_F7DC
        call drawHorzTunnel3
        pop  psw
        adi  8
        cpi  52
        jc   drawHorzTunnels_1
        ret

;----------------------------------------------------------------------------
; Установить начальные координаты всех врагов и нарисовать всех врагов

initEnemies:
        ; Установить начальные координаты всех врагов
        mvi  a, 5
        sta  enemy1X
        call setCursorX_F7BE
        lda  enemy1X
        adi  8
        sta  enemy2X
        adi  8
        sta  enemy3X
        adi  8
        sta  enemy4X
        adi  8
        sta  enemy5X
        adi  8
        sta  enemy6X
        adi  8
        sta  enemy7X
        mvi  a, 2
        sta  enemy1Y
        call setCursorY_F7DC
        lda  enemy1Y
        adi  3
        sta  enemy2Y
        adi  3
        sta  enemy3Y
        adi  3
        sta  enemy4Y
        adi  3
        sta  enemy5Y
        adi  3
        sta  enemy6Y
        adi  3
        sta  enemy7Y
        mvi  a, 0
        sta  enemy1Dir
        sta  enemy3Dir
        sta  enemy5Dir
        sta  enemy7Dir
        mvi  a, 1
        sta  enemy2Dir
        sta  enemy4Dir
        sta  enemy6Dir
        
        ; Нарисовать всех врагов
        mvi  c, 7
initEnemies_1:
        push b
        call drawEnemy
        lda  cursorX_C807
        adi  8
        call setCursorX_F7BE
        lda  cursorY_C808
        adi  3
        call setCursorY_F7DC
        pop  b
        dcr  c
        jnz  initEnemies_1
        ret

;----------------------------------------------------------------------------
; Нарисовать стенки для уровня 3

drawLevel3:
        mvi  a, 4
        call drawLevel3a
        mvi  a, 9
        call drawLevel3a
        mvi  a, 14
        call setCursorY_F7DC
        mvi  a, 12
        call drawLevel3b
        mvi  a, 9
        call setCursorY_F7DC
        mvi  a, 23
        call setCursorX_F7BE
        mvi  a, 93
        call drawChar2_F8B0
        ret

drawLevel3a:
        call setCursorY_F7DC
        mvi  a, 15
        
drawLevel3b:
        push psw
        call setCursorX_F7BE
        mvi  a, 93
        call drawChar2_F8B0
        pop  psw
        adi  16
        cpi  56
        jc   drawLevel3b
        ret

;----------------------------------------------------------------------------
; Нарисовать 4 стенки

drawLevel2a:
        ; Нарисовать стенку
        mvi  a, 14        
        call setCursorY_F7DC
        mvi  a, 12
        call setCursorX_F7BE
        mvi  a, 85
        call drawChar2_F8B0
        
        ; Нарисовать стенку
        mvi  a, 9
        call setCursorY_F7DC
        mvi  a, 28
        call setCursorX_F7BE
        mvi  a, 85
        call drawChar2_F8B0
        
        ; Нарисовать стенку        
        mvi  a, 4
        call setCursorY_F7DC
        mvi  a, 85
        call drawChar2_F8B0
        
        ; Нарисовать стенку        
        mvi  a, 14
        call setCursorY_F7DC
        mvi  a, 44
        call setCursorX_F7BE
        mvi  a, 85
        call drawChar2_F8B0
        ret

;----------------------------------------------------------------------------
; Рисование горизонтального тоннеля

drawHorzTunnel:
        ; Рисование стенки горизонтальных ходов
        call drawHorz4
        
        ; Проделаем отверстие в стенке вертикального тоннеля
        call cursorDown_FA9A
        mvi  a, 20h ; ' '
        call drawChar2_F8B0
        call cursorLeft4
        call cursorLeft_FAB3
        mvi  a, 20h ; ' '
        call drawChar1_F7FB
        call cursorDown_FA9A
        
        ; Рисование стенки горизонтальных ходов
        call drawHorz4    
        
        ; Возвращаем крусор на место
        call cursorLeft4
        ret

;----------------------------------------------------------------------------
; Курсор на 4 символа вправо

cursorLeft4:
        call cursorLeft_FAB3
        call cursorLeft_FAB3
        call cursorLeft_FAB3
        call cursorLeft_FAB3
        ret

;----------------------------------------------------------------------------
; Курсор на 3 символа вниз

cursorDown3:
        call cursorDown_FA9A
        call cursorDown_FA9A
        call cursorDown_FA9A
        ret
        
;----------------------------------------------------------------------------
; Рисование 3-х по вертикальни горизонтальных тоннелей

drawHorzTunnel3:
        call drawHorzTunnel
        call cursorDown3
        call drawHorzTunnel
        call cursorDown3
        call drawHorzTunnel
        ret

;----------------------------------------------------------------------------
; Рисование стенки горизонтальных ходов

drawHorz4:
        mvi  a, 5Eh
        call drawChar1_F7FB
        mvi  a, 5Eh
        call drawChar1_F7FB
        mvi  a, 5Eh
        call drawChar1_F7FB
        mvi  a, 5Eh
        call drawChar1_F7FB
        ret

;----------------------------------------------------------------------------
; Копирование одного битплана экрана в другой
; Заливка строки состояния цветом

clearStatLineAndCopyBitpl:
        ; Копирование одного битплана экрана в другой
        push h
        push d
        lxi  h, 0D000h
        lxi  d, 9000h
clearStatLineAndCopyBitpl_1:
        mov  a, m
        stax d
        inx  d
        inx  h
        mov  a, h
        ora  l
        jnz  clearStatLineAndCopyBitpl_1
        
        ; Заливка строки состояния цветом
        call clearStatusLine
        
        pop  d
        pop  h
        ret

;----------------------------------------------------------------------------
; Очистка экрана

clearScreen:
        ; Звуковой эффект?
        out  0F9h ; Установка бита в регистра конфигурации
        out  0B8h ; Очистка бита регистра конфигурации

        ; Очистка первого битплана
        call clearScreen1_F9A0
        
        ; Очистка второго битплана
        call clearScreen2
        ret

;----------------------------------------------------------------------------
; Очистка второго битплана

clearScreen2:
        push h
        push d
        lxi  h, 9000h    ; Указатель на начало видеопамяти
        lxi  d, 3000h    ; Длина
clearScreen2_1:
        xra  a
        mov  m, a
        inx  h
        dcx  d
        mov  a, d
        ora  e
        jnz  clearScreen2_1
        pop  d
        pop  h
        ret

;----------------------------------------------------------------------------
; Заливка строки состояния цветом

clearStatusLine:
        mvi  h, 90h
clearStatusLine_1:
        mvi  l, 25h
        mvi  a, 0FFh
clearStatusLine_2:
        mov  m, a
        dcr  l
        jnz  clearStatusLine_2
        inr  h
        mov  a, h
        cpi  0C0h
        jnz  clearStatusLine_1
        ret

;----------------------------------------------------------------------------
; Шрифт

font:   .db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0
        .db    8,   8,   8,   8,   8,   0,   8,   0,   0,   0
        .db  14h, 14h, 14h,   0,   0,   0,   0,   0,   0,   0
        .db  14h, 14h, 3Eh, 14h, 3Eh, 14h, 14h,   0,   0,   0
        .db    8, 1Eh, 28h, 1Ch, 0Ah, 3Ch,   8,   0,   0,   0
        .db  30h, 32h,   4,   8, 10h, 26h,   6,   0,   0,   0
        .db  10h, 28h, 28h, 10h, 2Ah, 24h, 1Ah,   0,   0,   0
        .db    8,   8,   8,   0,   0,   0,   0,   0,   0,   0
        .db    8, 10h, 20h, 20h, 20h, 10h,   8,   0,   0,   0
        .db    8,   4,   2,   2,   2,   4,   8,   0,   0,   0
        .db    8, 2Ah, 1Ch,   8, 1Ch, 2Ah,   8,   0,   0,   0
        .db    0,   8,   8, 3Eh,   8,   8,   0,   0,   0,   0
        .db    0,   0,   0,   0, 18h,   8, 10h,   0,   0,   0
        .db    0,   0,   0, 3Eh,   0,   0,   0,   0,   0,   0
        .db    0,   0,   0,   0,   0, 18h, 18h,   0,   0,   0
        .db    0,   2,   4,   8, 10h, 20h,   0,   0,   0,   0
        .db  1Ch, 22h, 26h, 2Ah, 32h, 22h, 1Ch,   0,   0,   0
        .db    8, 18h, 28h,   8,   8,   8, 3Ch,   0,   0,   0
        .db  1Ch, 22h,   2, 0Ch, 10h, 20h, 3Eh,   0,   0,   0
        .db  3Eh,   2,   4, 0Ch,   2, 22h, 1Ch,   0,   0,   0
        .db    4, 0Ch, 14h, 24h, 3Eh,   4,   4,   0,   0,   0
        .db  3Eh, 20h, 3Ch,   2,   2, 22h, 1Ch,   0,   0,   0
        .db  0Ch, 10h, 20h, 3Ch, 22h, 22h, 1Ch,   0,   0,   0
        .db  3Eh,   2,   4,   8, 10h, 10h, 10h,   0,   0,   0
        .db  1Ch, 22h, 22h, 1Ch, 22h, 22h, 1Ch,   0,   0,   0
        .db  1Ch, 22h, 22h, 1Eh,   2,   4, 38h,   0,   0,   0
        .db    0, 18h, 18h,   0, 18h, 18h,   0,   0,   0,   0
        .db    0, 18h, 18h,   0, 18h,   8, 10h,   0,   0,   0
        .db    4,   8, 10h, 20h, 10h,   8,   4,   0,   0,   0
        .db    0,   0, 3Eh,   0, 3Eh,   0,   0,   0,   0,   0
        .db  10h,   8,   4,   2,   4,   8, 10h,   0,   0,   0
        .db  1Ch, 22h,   4,   8,   8,   0,   8,   0,   0,   0
        .db  1Ch, 22h, 2Ah, 2Eh, 2Ch, 20h, 1Eh,   0,   0,   0
        .db    8, 14h, 22h, 22h, 3Eh, 22h, 22h,   0,   0,   0
        .db  3Ch, 22h, 22h, 3Ch, 22h, 22h, 3Ch,   0,   0,   0
        .db  1Ch, 22h, 20h, 20h, 20h, 22h, 1Ch,   0,   0,   0
        .db  3Ch, 22h, 22h, 22h, 22h, 22h, 3Ch,   0,   0,   0
        .db  3Eh, 20h, 20h, 3Ch, 20h, 20h, 3Eh,   0,   0,   0
        .db  3Eh, 20h, 20h, 3Ch, 20h, 20h, 20h,   0,   0,   0
        .db  1Eh, 20h, 20h, 20h, 26h, 22h, 1Eh,   0,   0,   0
        .db  22h, 22h, 22h, 3Eh, 22h, 22h, 22h,   0,   0,   0
        .db    0, 3Fh, 20h, 2Ch, 20h, 24h, 23h, 2Fh, 29h, 38h
        .db    0, 3Fh,   1, 0Dh,   1,   9, 31h, 3Dh, 25h,   7
        .db  22h, 24h, 28h, 30h, 28h, 24h, 22h,   0,   0,   0
        .db  20h, 20h, 20h, 20h, 20h, 20h, 3Eh,   0,   0,   0
        .db  22h, 36h, 2Ah, 2Ah, 22h, 22h, 22h,   0,   0,   0
        .db  22h, 22h, 32h, 2Ah, 26h, 22h, 22h,   0,   0,   0
        .db  1Ch, 22h, 22h, 22h, 22h, 22h, 1Ch,   0,   0,   0
        .db  3Ch, 22h, 22h, 3Ch, 20h, 20h, 20h,   0,   0,   0
        .db    0, 3Fh, 20h, 2Ch, 20h, 24h, 23h, 2Fh, 29h, 38h
        .db    0, 3Fh,   1, 0Dh,   1,   9, 31h, 3Dh, 25h,   7
        .db  20h, 30h, 38h, 1Dh, 1Fh, 1Fh, 19h, 0Fh,   7,   4
        .db    1,   3,   7, 2Eh, 3Eh, 3Eh, 26h, 3Ch, 38h,   8
        .db  0Ch, 1Eh, 1Eh, 0Ch, 1Eh, 1Eh, 0Ch, 1Eh, 1Eh, 0Ch
        .db    0,   0,   0,   4, 1Ch, 22h, 2Ah, 21h, 21h, 1Fh
        .db    0,   0,   0,   1,   2,   4,   4,   5, 3Fh, 3Ch
        .db    0,   0,   0,   0, 28h, 34h, 24h, 12h, 1Ah,   3
        .db    4,   7, 0Fh, 19h, 1Fh, 1Fh, 1Dh, 38h, 30h, 20h
        .db    8, 38h, 3Ch, 26h, 3Eh, 3Eh, 2Eh,   7,   3,   1
        .db  1Ch, 2Ah, 1Ch,   9, 1Fh, 28h,   8, 14h, 22h, 22h
        .db    0, 36h, 28h, 2Eh, 12h, 21h, 21h, 3Eh,   0,   0
        .db  0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch
        .db    0,   0,   0,   0, 3Fh, 3Fh,   0,   0,   0,   0
        .db  0Ch, 0Ch, 0Ch, 0Ch, 0Ch,   0,   0,   0,   0,   0
        .db    0,   0,   0,   0,   0, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch
        .db    0,   0, 1Ch,   2, 1Eh, 22h, 1Eh,   0,   0,   0
        .db  20h, 20h, 3Ch, 22h, 22h, 22h, 3Ch,   0,   0,   0
        .db    0,   0, 1Eh, 20h, 20h, 20h, 1Eh,   0,   0,   0
        .db    2,   2, 1Eh, 22h, 22h, 22h, 1Eh,   0,   0,   0
        .db    0,   0, 1Ch, 22h, 3Eh, 20h, 1Eh,   0,   0,   0
        .db  0Ch, 12h, 10h, 3Ch, 10h, 10h, 10h,   0,   0,   0
        .db    0,   0, 1Ah, 26h, 22h, 1Eh,   2, 3Ch,   0,   0
        .db  20h, 20h, 3Ch, 22h, 22h, 22h, 22h,   0,   0,   0
        .db    8,   0, 18h,   8,   8,   8, 1Ch,   0,   0,   0
        .db    4,   0, 0Ch,   4,   4,   4, 24h, 18h,   0,   0
        .db  20h, 20h, 22h, 24h, 38h, 24h, 22h,   0,   0,   0
        .db  18h,   8,   8,   8,   8,   8, 1Ch,   0,   0,   0
        .db    0,   0, 36h, 2Ah, 2Ah, 2Ah, 2Ah,   0,   0,   0
        .db    0,   0, 2Ch, 32h, 22h, 22h, 22h,   0,   0,   0
        .db    0,   0, 1Ch, 22h, 22h, 22h, 1Ch,   0,   0,   0
        .db    0,   0, 3Ch, 22h, 22h, 3Ch, 20h, 20h,   0,   0
        .db    0,   0, 1Eh, 22h, 22h, 1Eh,   2,   2,   0,   0
        .db    0,   0, 2Eh, 30h, 20h, 20h, 20h,   0,   0,   0
        .db    0,   0, 1Eh, 20h, 1Ch,   2, 3Ch,   0,   0,   0
        .db  10h, 10h, 3Ch, 10h, 10h, 12h, 0Ch,   0,   0,   0
        .db    0,   0, 22h, 22h, 22h, 26h, 1Ah,   0,   0,   0
        .db    0,   0, 22h, 22h, 22h, 14h,   8,   0,   0,   0
        .db    0,   0, 22h, 22h, 2Ah, 2Ah, 36h,   0,   0,   0
        .db    0,   0, 22h, 14h,   8, 14h, 22h,   0,   0,   0
        .db    0,   0, 22h, 22h, 22h, 1Eh,   2, 1Ch,   0,   0
        .db    0,   0, 3Eh,   4,   8, 10h, 3Eh,   0,   0,   0
        .db  0Eh, 18h, 18h, 30h, 18h, 18h, 0Eh,   0,   0,   0
        .db    8,   8,   8,   8,   8,   8,   8,   8,   0,   0
        .db  38h, 0Ch, 0Ch,   6, 0Ch, 0Ch, 38h,   0,   0,   0
        .db  1Ah, 2Ch,   0,   0,   0,   0,   0,   0,   0,   0
        .db  36h, 36h, 36h,   0,   0, 22h, 1Ch,   0,   0,   0
        .db  1Ch,   0, 1Ch, 22h, 22h, 22h, 1Ch,   0,   0,   0
        .db  22h,   8, 14h, 22h, 3Eh, 22h, 22h,   0,   0,   0
        .db  22h,   0, 1Ch, 22h, 22h, 22h, 1Ch,   0,   0,   0
        .db  22h,   0, 22h, 22h, 22h, 22h, 1Ch,   0,   0,   0
        .db  3Eh, 20h, 20h, 3Ch, 22h, 22h, 3Ch,   0,   0,   0
        .db  3Ch, 22h, 22h, 3Ch, 22h, 22h, 3Ch,   0,   0,   0
        .db  3Eh, 22h, 20h, 20h, 20h, 20h, 20h,   0,   0,   0
        .db  0Ch, 14h, 14h, 14h, 14h, 3Eh, 22h,   0,   0,   0
        .db  2Ah, 2Ah, 2Ah, 1Ch, 2Ah, 2Ah, 2Ah,   0,   0,   0
        .db  1Ch, 22h,   2, 0Ch,   2, 22h, 1Ch,   0,   0,   0
        .db  22h, 22h, 26h, 2Ah, 32h, 22h, 22h,   0,   0,   0
        .db  14h,   8, 22h, 26h, 2Ah, 32h, 22h,   0,   0,   0
        .db  22h, 24h, 28h, 30h, 28h, 24h, 22h,   0,   0,   0
        .db    6, 0Ah, 12h, 12h, 12h, 12h, 22h,   0,   0,   0
        .db  22h, 36h, 2Ah, 22h, 22h, 22h, 22h,   0,   0,   0
        .db  22h, 22h, 22h, 3Eh, 22h, 22h, 22h,   0,   0,   0
        .db  3Eh, 22h, 22h, 22h, 22h, 22h, 22h,   0,   0,   0
        .db  3Eh,   8,   8,   8,   8,   8,   8,   0,   0,   0
        .db  22h, 22h, 22h, 1Eh,   2, 22h, 1Ch,   0,   0,   0
        .db    8, 1Ch, 2Ah, 2Ah, 2Ah, 1Ch,   8,   0,   0,   0
        .db  24h, 24h, 24h, 24h, 24h, 3Eh,   2,   0,   0,   0
        .db  22h, 22h, 22h, 1Eh,   2,   2,   2,   0,   0,   0
        .db  2Ah, 2Ah, 2Ah, 2Ah, 2Ah, 2Ah, 3Eh,   0,   0,   0
        .db  2Ah, 2Ah, 2Ah, 2Ah, 2Ah, 3Eh,   2,   0,   0,   0
        .db  22h, 22h, 32h, 2Ah, 2Ah, 2Ah, 32h,   0,   0,   0
        .db  20h, 20h, 38h, 24h, 22h, 24h, 38h,   0,   0,   0
        .db  1Ch, 22h,   2, 1Eh,   2, 22h, 1Ch,   0,   0,   0
        .db  2Eh, 2Ah, 2Ah, 3Ah, 2Ah, 2Ah, 2Eh,   0,   0,   0
        .db  1Eh, 22h, 22h, 1Eh, 0Ah, 12h, 22h,   0,   0,   0
        .db  30h, 10h, 10h, 1Ch, 12h, 12h, 1Ch,   0,   0,   0
        .db    8, 1Ch, 3Eh, 3Eh, 1Ch,   8,   0,   0,   0,   0
        .db    0, 36h, 3Eh, 3Eh, 1Ch,   8,   0,   0,   0,   0
        .db    0, 1Ch,   0, 1Ch, 22h, 22h, 1Ch,   0,   0,   0
        .db  14h,   0, 1Ch,   2, 1Eh, 22h, 1Eh,   0,   0,   0
        .db    0, 14h,   0, 1Ch, 22h, 22h, 1Ch,   0,   0,   0
        .db    0, 14h,   0, 22h, 22h, 26h, 1Ah,   0,   0,   0
        .db    0,   0, 3Eh, 20h, 3Ch, 22h, 3Ch,   0,   0,   0
        .db    0,   0, 3Ch, 22h, 3Ch, 22h, 3Ch,   0,   0,   0
        .db    0,   0, 3Eh, 22h, 20h, 20h, 20h,   0,   0,   0
        .db    0,   0, 0Ch, 14h, 14h, 14h, 3Eh, 22h,   0,   0
        .db    0,   0, 2Ah, 2Ah, 1Ch, 2Ah, 2Ah,   0,   0,   0
        .db    0,   0, 1Ch, 22h,   4,   2, 22h, 1Ch,   0,   0
        .db    0,   0, 22h, 26h, 2Ah, 32h, 22h,   0,   0,   0
        .db    0, 14h,   8, 22h, 26h, 2Ah, 32h,   0,   0,   0
        .db    0,   0, 22h, 24h, 38h, 24h, 22h,   0,   0,   0
        .db    0,   0, 0Eh, 0Ah, 0Ah, 12h, 22h,   0,   0,   0
        .db    0,   0, 22h, 36h, 2Ah, 22h, 22h,   0,   0,   0
        .db    0,   0, 22h, 22h, 3Eh, 22h, 22h,   0,   0,   0
        .db    0,   0, 3Eh, 22h, 22h, 22h, 22h,   0,   0,   0
        .db    0,   0, 3Eh,   8,   8,   8,   8,   0,   0,   0
        .db    0,   0, 22h, 22h, 1Eh,   2,   2, 1Ch,   0,   0
        .db    0,   0,   8, 3Eh, 2Ah, 3Eh,   8,   8,   0,   0
        .db    0,   0, 24h, 24h, 24h, 24h, 3Eh,   2,   0,   0
        .db    0,   0, 22h, 22h, 1Eh,   2,   2,   0,   0,   0
        .db    0,   0, 2Ah, 2Ah, 2Ah, 2Ah, 3Eh,   0,   0,   0
        .db    0,   0, 2Ah, 2Ah, 2Ah, 2Ah, 3Eh,   2,   0,   0
        .db    0,   0, 22h, 22h, 3Ah, 2Ah, 3Ah,   0,   0,   0
        .db    0,   0, 20h, 20h, 38h, 24h, 38h,   0,   0,   0
        .db    0,   0, 3Ch,   2, 1Eh,   2, 3Ch,   0,   0,   0
        .db    0,   0, 2Eh, 2Ah, 3Ah, 2Ah, 2Eh,   0,   0,   0
        .db    0,   0, 1Eh, 22h, 1Eh, 12h, 22h,   0,   0,   0
        .db    0,   0, 30h, 10h, 1Ch, 12h, 1Ch,   0,   0,   0
        .db    8, 1Ch,   8, 3Eh,   8,   8, 1Ch,   0,   0,   0
        .db    8, 1Ch, 3Eh, 3Eh,   8,   8, 36h,   0,   0,   0

;----------------------------------------------------------------------------
; Вспомогательная функция для звуковых эффектов

playSoundC:
        out  0F9h
        out  0B8h
        mov  b, d
        mov  c, e
playSoundC_1:
        mov  d, b
        mov  e, c
        out  0B0h
playSoundC_2:
        dcx  h
        mov  a, h
        ora  l
        rz
        dcx  d
        mov  a, d
        ora  e
        jnz  playSoundC_2
        jmp  playSoundC_1

;----------------------------------------------------------------------------
; Рисование числа из HL на экране

drawNumber:
        ; Преобразование числа из HL в строку, строка в numToStrBuf
        call numToStr
        ; Рисование строки numToStrBuf на экране
        call drawNumToStrBuf
        ret

;----------------------------------------------------------------------------
; Преобразование числа из HL в строку, строка в numToStrBuf

numToStr:
        push b
        push d
        push h
        shld word_1391
        lxi  d, numToStrBuf
        lxi  h, numToStrTbl
numToStr_1:
        push d
        mov  a, m
        inr  a
        jz   numToStr_3
        mov  e, m
        inx  h
        mov  d, m
        inx  h
        push h
        mvi  c, 0FFh
        lhld word_1391
numToStr_2:
        shld word_1391
        dad  d
        inr  c
        mov  a, h
        ora  a
        jp   numToStr_2
        pop  h
        pop  d
        mov  a, c
        adi  30h
        stax d
        inx  d
        jmp  numToStr_1
numToStr_3:
        pop  d
        lhld word_1391
        mov  a, l
        adi  30h ; '0'
        stax d
        lxi  h, numToStrBuf
        mvi  c, 4
numToStr_4:
        mov  a, m
        cpi  30h
        jnz  numToStr_5
        mvi  m, 20h
        inx  h
        dcr  c
        jnz  numToStr_4
numToStr_5:
        pop  h
        pop  d
        pop  b
        ret

numToStrTbl:    .db 0F0h,0D8h, 18h,0FCh, 9Ch,0FFh,0F6h,0FFh,0FFh ; DATA    XREF: numToStr+9o

;----------------------------------------------------------------------------
; Рисование строки numToStrBuf на экране

drawNumToStrBuf:
        push b
        push d
        push h
        mvi  c, 5
        lxi  h, numToStrBuf
drawNumber2_1:
        push b
        push h
        mov  a, m
        call drawChar1_F7FB
        pop  h
        pop  b
        inx  h
        dcr  c
        jnz  drawNumber2_1
        pop  h
        pop  d
        pop  b
        ret

;----------------------------------------------------------------------------
; Нарисовать полосу времени и сбросить заморозку врагов

drawTimeLineAndInitFreeze:
        ; Cбросить заморозку врагов
        call initFreeze        
        
        ; Сбросить переменную, которая испольуется как счетчик-делитель для
        ; замедления полоски времени. Смысла в этом особого нет.
        xra  a
        sta  timeDivider
        
        ; Нарисовать полосу времени        
        mvi  a, 15
        call setCursorX_F7BE
        xra  a
        sta  timeY
        call setCursorY_F7DC
        mvi  c, 1Eh
drawTimeLineAndInitFreeze_1:
        push b
        mvi  a, 94
        call drawChar1_F7FB
        pop  b
        dcr  c
        jnz  drawTimeLineAndInitFreeze_1
        lda  cursorX_C807
        
        ; Установить счетчик времени. Он будет уменьшаться во время игры
        ; и когда игрок дойдет до конца, остаток будет прибавлен к очкам
        dcr  a
        sta  time
        ret

;----------------------------------------------------------------------------
; Прибавить оставшееся время к HL

addTimeToHl:
        lda  time
        inr  a
        sui  0Fh
        adi  5
        mov  e, a
        mvi  d, 0
        dad  d
        ret
        
;----------------------------------------------------------------------------
; Разморозка врагов по таймеру и уменьшение полоски времени

unfreezeEnemyAndTime:
        ; Разморозка врагов по таймеру
        call unfreezeEnemy
        
        ; Счетчик делитель. Коэффициент делерния зависит от уровня.
        lda  level
        rlc
        mov  c, a
        rlc
        add  c
        adi  10
        mov  c, a
        lda  timeDivider
        inr  a
        sta  timeDivider
        cmp  c
        rnz
        xra  a
        sta  timeDivider    ; timeDivier = 0;
        
        ; Если время (переменная time) равно 14, то выходим
        lda  time
        cpi  14
        rz
        
        ; Перерисовать полосу времени
        push psw
        call setCursorX_F7BE
        lda  timeY
        call setCursorY_F7DC
        mvi  a, ' '
        call drawChar2_F8B0
        pop  psw
        
        ; Уменьшить time на единицу
        dcr  a
        sta  time
        ret

;----------------------------------------------------------------------------
; Разморозка врагов по таймеру

unfreezeEnemy:
        lda  freezeTimer
        ora  a
        rz
        inr  a
        sta  freezeTimer
        cpi  30
        rc
        xra  a
        call unfreezeEnemy2
        ret

;----------------------------------------------------------------------------
; Сбросить заморозку врагов

initFreeze:
        xra  a
        sta  freezeTimer
unfreezeEnemy2:
        sta  enemy1Off
        sta  enemy2Off
        sta  enemy3Off
        sta  enemy4Off
        sta  enemy5Off
        sta  enemy6Off
        sta  enemy7Off
        ret

;----------------------------------------------------------------------------
; Вызывается при нажатии клавиши [.]

playerFreeze:
        ; Определение, какого врага мы заморозили. Установка его флага
        ; enemy?Off=1 и таймера freezeTimer=1        
        lda  playerX
        mov  c, a
        lda  enemy1X
        cmp  c
        jnz  playerFreeze_1        
        mvi  a, 1
        sta  enemy1Off
        jmp  playerFreeze_8
playerFreeze_1:
        lda  playerX
        mov  c, a
        lda  enemy2X
        cmp  c
        jnz  playerFreeze_2
        mvi  a, 1
        sta  enemy2Off
        jmp  playerFreeze_8
playerFreeze_2:
        lda  playerX
        mov  c, a
        lda  enemy3X
        cmp  c
        jnz  playerFreeze_3
        mvi  a, 1
        sta  enemy3Off
        jmp  playerFreeze_8
playerFreeze_3:
        lda  playerX
        mov  c, a
        lda  enemy4X
        cmp  c
        jnz  playerFreeze_4
        mvi  a, 1
        sta  enemy4Off
        jmp  playerFreeze_8
playerFreeze_4:
        lda  playerX
        mov  c, a
        lda  enemy5X
        cmp  c
        jnz  playerFreeze_5
        mvi  a, 1
        sta  enemy5Off
        jmp  playerFreeze_8
playerFreeze_5:
        lda  playerX
        mov  c, a
        lda  enemy6X
        cmp  c
        jnz  playerFreeze_6
        mvi  a, 1
        sta  enemy6Off
        jmp  playerFreeze_8
playerFreeze_6:
        lda  playerX
        mov  c, a
        lda  enemy7X
        cmp  c
        jnz  playerFreeze_7
        mvi  a, 1
        sta  enemy7Off
        jmp  playerFreeze_8
playerFreeze_7:
        ret
playerFreeze_8:
        mvi  a, 1
        sta  freezeTimer
        ret

; ---------------------------------------------------------------------------
; Переменные

enemy1X:    .db 5
enemy1Y:    .db 5
enemy2X:    .db 0Dh
enemy2Y:    .db 9
enemy3X:    .db 15h
enemy3Y:    .db 4
enemy4X:    .db 1Dh
enemy4Y:    .db 0Fh
enemy5X:    .db 25h
enemy5Y:    .db 0Ah
enemy6X:    .db 2Dh
enemy6Y:    .db 13h
enemy7X:    .db 35h
enemy7Y:    .db 10h
enemy1Dir:  .db 1
enemy2Dir:  .db 1
enemy3Dir:  .db 0
enemy4Dir:  .db 1
enemy5Dir:  .db 0
enemy6Dir:  .db 0
enemy7Dir:  .db 0
playerX:    .db 1
playerY:    .db 14h
            .db 0F5h ; Это что?
            .db 02Ah ; Это что?
corpseX:    .db 9
corpseY:    .db 17h
livesX:     .db 1
livesY:     .db 0Eh
lives:      .db 3
drawVerticalEndTmp: .db 5Fh
level:      .db 1
score:      .dw 0
needInitPlayer: .db 0
bestScore:  .dw 0
bestScoreForLevel1: .dw 0
bestScoreForLevel2: .dw 0
bestScoreForLevel3: .dw 0
word_1391:  .dw 0
numToStrBuf:.text "    0"
timeDivider:.db 0Bh
time:       .db 2Bh
timeY:      .db 0
enemy1Off:  .db 0
enemy2Off:  .db 0
enemy3Off:  .db 0
enemy4Off:  .db 0
enemy5Off:  .db 0
enemy6Off:  .db 0
enemy7Off:  .db 0
freezeTimer:.db 0

aEnterLevel:.db 43h, 91h, 45h, 90h, 45h, 48h, 99h, 20h, 91h, 50h
            .db 92h, 87h, 48h, 4Fh, 43h, 91h, 8Ah, 20h, 28h, 31h
            .db 2Fh, 32h, 2Fh, 33h, 29h, 20h, 24h
aUnused:    .text "Alustamiseks A, raskusastme muutmiseks M, lahkumiseks L $"
aOxkk:      .db 4Fh, 95h, 4Bh, 8Ah, 3Ah, 20h
aPekopz:    .db 50h, 45h, 4Bh, 4Fh, 50h, 87h, 3Ah, 20h
aWin:       .text "*** Olete ammendanud selle raskusastme ***$"

sound1:     .dw 64h, 12Ch, 43h, 12Ch, 2Dh, 12Ch, 1Eh, 12Ch, 14h, 12Ch
            .dw 0Dh, 12Ch, 64h, 12Ch, 43h, 12Ch, 2Dh, 12Ch, 1Eh, 12Ch
            .dw 14h, 12Ch, 0Dh, 12Ch, 64h, 12Ch, 43h, 12Ch, 2Dh, 12Ch
            .dw 1Eh, 12Ch, 14h, 12Ch, 0Dh, 12Ch, 0FFFFh, 1194h, 2, 12Ch
            .dw 3, 12Ch, 5, 12Ch, 8, 12Ch, 0Ch, 12Ch, 12h, 12Ch
            .dw 1Bh, 12Ch, 29h, 12Ch, 3Eh, 12Ch, 0
sound3:     .dw 0FFFFh, 4E20h, 8, 0FA0h, 9, 0FA0h, 8, 0FA0h, 0
sound5:     .dw 64h, 32h, 0FFFFh, 1388h, 43h, 32h, 0FFFFh, 1388h, 2Dh, 32h
            .dw 0FFFFh, 1388h, 1Eh, 32h, 0FFFFh, 1388h, 14h, 32h, 0FFFFh, 1388h
            .dw 0Dh, 32h, 0FFFFh, 1388h, 9, 32h, 0FFFFh, 1388h, 6, 32h
            .dw 0FFFFh, 1388h, 4, 32h, 0FFFFh, 1388h, 3, 32h, 0FFFFh, 1388h
            .dw 2, 32h, 0FFFFh, 1388h, 1, 32h, 0FFFFh, 3A98h, 0
sound4:     .dw 5, 96h, 0FFFFh, 1388h, 8, 96h, 0FFFFh, 1388h, 0Dh, 96h
            .dw 0FFFFh, 1388h, 5, 96h, 0FFFFh, 1388h, 0
sound2:     .dw 2EEh, 1F40h, 0FFFFh, 7D0h, 2EEh, 3A98h, 0

aStartScreen:
        .db 20h, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah
        .db 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h
        .db 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h
        .db 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah
        .db 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h
        .db 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h, 5Ah, 20h, 59h
        .db 5Ah, 20h, 20h, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h
        .db 20h, 20h, 20h, 20h, 94h, 65h, 0ADh, 0B9h, 20h, 0AAh
        .db 0A6h, 70h, 0B8h, 3Ah, 20h, 0AFh, 61h, 0A7h, 6Fh, 20h
        .db 0B0h, 70h, 6Fh, 0A5h, 65h, 63h, 0B1h, 0AAh, 20h, 0B5h
        .db 65h, 0ADh, 6Fh, 0A5h, 65h, 0B5h, 0ACh, 61h, 20h, 28h
        .db 5Bh, 29h, 20h, 0B0h, 6Fh, 20h, 0ADh, 61h, 0A4h, 0AAh
        .db 70h, 0AAh, 0AFh, 0B1h, 0B2h, 20h, 20h, 20h, 20h, 20h
        .db 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h
        .db 20h, 20h, 0AAh, 0A9h, 20h, 20h, 0ADh, 65h, 0A5h, 6Fh
        .db 0A6h, 6Fh, 20h, 0AFh, 0AAh, 0A8h, 0AFh, 65h, 0A6h, 6Fh
        .db 20h, 0B2h, 0A6h, 0ADh, 61h, 20h, 0A5h, 20h, 20h, 0B0h
        .db 70h, 61h, 0A5h, 0B8h, 0ABh, 20h, 0AFh, 0AAh, 0A8h, 0AFh
        .db 0AAh, 0ABh, 2Eh, 20h, 20h, 9Ah, 0B1h, 6Fh, 20h, 0A7h
        .db 61h, 65h, 0B1h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh
        .db 5Ch, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h
        .db 0AAh, 0A6h, 70h, 61h, 0BBh, 0B7h, 65h, 0AEh, 0B2h, 20h
        .db 35h, 20h, 6Fh, 0B5h, 0ACh, 6Fh, 0A5h, 2Eh, 20h, 20h
        .db 92h, 0B5h, 0AAh, 0B1h, 0B8h, 0A5h, 61h, 65h, 0B1h, 63h
        .db 0BCh, 20h, 0B1h, 61h, 0ACh, 0A8h, 65h, 20h, 63h, 0ACh
        .db 6Fh, 70h, 6Fh, 63h, 0B1h, 0B9h, 20h, 0B0h, 70h, 6Fh
        .db 2Dh, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h, 78h, 6Fh
        .db 0A7h, 61h, 2Eh, 20h, 95h, 65h, 0ADh, 6Fh, 0A5h, 65h
        .db 0B5h, 65h, 0ACh, 20h, 0B2h, 0B0h, 70h, 61h, 0A5h, 0ADh
        .db 0BCh, 65h, 0B1h, 63h, 0BCh, 20h, 0ACh, 0ADh, 61h, 0A5h
        .db 0AAh, 0B6h, 61h, 0AEh, 0AAh, 20h, 63h, 6Fh, 20h, 63h
        .db 0B1h, 70h, 65h, 0ADh, 0ACh, 61h, 0AEh, 0AAh, 2Eh, 20h
        .db 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh
        .db 5Ch, 20h, 20h, 20h, 20h, 20h, 85h, 6Fh, 20h, 0A5h
        .db 70h, 65h, 0AEh, 0BCh, 20h, 0A7h, 0A5h, 0AAh, 0A8h, 65h
        .db 0AFh, 0AAh, 0BCh, 20h, 0AFh, 61h, 0A7h, 6Fh, 20h, 0AAh
        .db 0A9h, 0A4h, 65h, 0A6h, 61h, 0B1h, 0B9h, 20h, 0ADh, 0BBh
        .db 0A7h, 6Fh, 65h, 0A7h, 6Fh, 0A5h, 20h, 28h, 59h, 5Ah
        .db 29h, 2Eh, 20h, 20h, 4Fh, 0AFh, 0AAh, 20h, 20h, 20h
        .db 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h
        .db 20h, 20h, 20h, 20h, 0A7h, 0A5h, 0AAh, 0A8h, 0B2h, 0B1h
        .db 63h, 0BCh, 20h, 0B1h, 6Fh, 0ADh, 0B9h, 0ACh, 6Fh, 20h
        .db 0B0h, 6Fh, 20h, 0A5h, 65h, 70h, 0B1h, 0AAh, 0ACh, 61h
        .db 0ADh, 0AAh, 2Eh, 20h, 20h, 8Ch, 0ADh, 61h, 0A5h, 0AAh
        .db 0B6h, 65h, 0ABh, 20h, 20h, 22h, 2Eh, 22h, 20h, 20h
        .db 0AEh, 6Fh, 0A8h, 0AFh, 6Fh, 20h, 20h, 20h, 20h, 20h
        .db 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h
        .db 20h, 20h, 6Fh, 63h, 0B1h, 61h, 0AFh, 6Fh, 0A5h, 0AAh
        .db 0B1h, 0B9h, 20h, 0A7h, 0A5h, 0AAh, 0A8h, 65h, 0AFh, 0AAh
        .db 65h, 20h, 0ADh, 0BBh, 0A7h, 6Fh, 65h, 0A7h, 61h, 2Eh
        .db 20h, 9Ah, 0B1h, 6Fh, 20h, 0A7h, 6Fh, 0B0h, 0B2h, 63h
        .db 0ACh, 61h, 65h, 0B1h, 63h, 0BCh, 20h, 0B1h, 6Fh, 0ADh
        .db 0B9h, 0ACh, 6Fh, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh
        .db 5Ch, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h
        .db 6Fh, 0A7h, 0AAh, 0AFh, 20h, 70h, 61h, 0A9h, 20h, 0A9h
        .db 61h, 20h, 0A5h, 65h, 63h, 0B9h, 20h, 0B0h, 70h, 6Fh
        .db 78h, 6Fh, 0A7h, 20h, 0B5h, 65h, 0ADh, 6Fh, 0A5h, 65h
        .db 0B5h, 0ACh, 61h, 2Eh, 20h, 20h, 8Ch, 0ADh, 61h, 0A5h
        .db 0AAh, 0B6h, 61h, 20h, 0B0h, 70h, 6Fh, 0A4h, 65h, 0ADh
        .db 61h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 5Ch, 0Dh, 5Ch, 20h, 20h, 20h, 20h, 20h, 2Dh, 2Dh
        .db 20h, 0A5h, 70h, 65h, 0AEh, 65h, 0AFh, 0AFh, 61h, 0BCh
        .db 20h, 6Fh, 63h, 0B1h, 61h, 0AFh, 6Fh, 0A5h, 0ACh, 61h
        .db 20h, 0AAh, 0A6h, 70h, 0B8h, 2Eh, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 5Ch, 0Dh, 5Ch, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 5Ch, 0Dh
        .db 20h, 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h
        .db 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h, 20h
        .db 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h
        .db 54h, 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h
        .db 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h, 20h
        .db 53h, 54h, 20h, 53h, 54h, 20h, 53h, 54h, 20h, 53h
        .db 54h, 20h, 20h, 0Dh, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 0Dh, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 45h, 63h, 0ADh, 0AAh, 20h, 85h, 0B8h, 20h, 6Fh
        .db 0A9h, 0AFh, 61h, 0ACh, 6Fh, 0AEh, 0AAh, 0ADh, 0AAh, 63h
        .db 0B9h, 20h, 63h, 20h, 0B0h, 70h, 61h, 0A5h, 0AAh, 0ADh
        .db 61h, 0AEh, 0AAh, 20h, 0AAh, 0A6h, 70h, 0B8h, 20h, 2Dh
        .db 2Dh, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 0Dh, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h
        .db 20h, 20h, 20h, 0AFh, 61h, 0A8h, 0AEh, 0AAh, 0B1h, 65h
        .db 20h, 0ADh, 0BBh, 0A4h, 0B2h, 0BBh, 20h, 0ACh, 0ADh, 61h
        .db 0A5h, 0AAh, 0B6h, 0B2h, 2Eh, 20h, 20h, 0

        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .db 0, 0, 0, 0, 0, 0, 0, 0

;----------------------------------------------------------------------------
; Задержка

delay:
        push    b
delay_1:
        dcx    h
        mov    a, h
        ora    l
        nop
        jnz    delay_1
        pop    b
        ret

;----------------------------------------------------------------------------
; Мусор в конце файла

        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        .db 0, 0, 0, 0, 0, 0, 0, 0, 0, 92h
        .db 42h, 10h, 44h, 40h, 40h, 42h, 49h, 4, 88h, 92h
        .db 40h, 12h, 1, 0, 24h, 91h, 1, 10h, 0, 80h
        .db 9, 24h, 48h, 42h, 44h, 21h, 8, 84h, 80h, 42h
        .db 10h, 80h, 90h, 0, 1, 20h, 0, 4, 48h, 80h
        .db 92h, 49h, 24h, 90h, 24h, 0, 0, 0, 8, 92h
        .db 24h, 22h, 4, 89h, 24h, 10h, 91h, 1, 20h, 82h
        .db 44h, 91h, 0, 88h, 11h, 10h, 84h, 82h, 24h, 82h
        .db 8, 92h, 22h, 49h, 9, 20h, 88h, 24h, 84h, 49h
        .db 24h, 44h, 81h, 8, 24h, 8, 10h, 82h, 42h, 22h
        .db 20h, 40h, 8, 0, 40h, 40h, 44h, 10h, 10h, 90h
        .db 92h, 40h, 4, 1, 12h, 0, 10h, 22h, 10h, 21h
        .db 8, 2, 8, 42h, 2, 0, 22h, 11h, 8, 22h
        .db 10h, 44h, 84h, 22h, 10h, 84h, 0

end:

.end entry