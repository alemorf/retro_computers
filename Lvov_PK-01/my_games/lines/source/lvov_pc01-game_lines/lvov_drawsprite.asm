drawSprite_12_16:
    ; В HL спрайт
    push b
    ; В DE адрес назначения
    .db 11h ; lxi d, 0000
drawSprite_12_16_1 .dw 0
    ; Высота изображения
    mvi b, 16
    ; Цикл строк
drawSprite_12_16_l0:
    push b
   
    ; Загружаем 12 пикселей 
    mov a, m
    inx h    
    mov b, m
    inx h    
    mov c, m
    
    ; Переключаем страницу памяти
    push psw
    mvi a, 00010b
    out 0C3h
    pop psw
    
    ; Сохраняем 12 пикселей
    xchg
    mov m, a
    inx h
    mov m, b
    inx h  
    mov m, c
    
    ; Переключаем страницу памяти
    mvi a, 00011b
    out 0C3h

    ; Следующая строка
    lxi b, 64-2
    dad b
    xchg
    lxi b, 21-2
    dad b

    ; Конец цикла
    pop b
    dcr b
    jnz drawSprite_12_16_l0
    pop b
    ret

;---

drawSpriteBallOr:
    push b
    xchg
    .db 21h ; lxi h
drawSpriteBallOr_1 .dw 0
    mvi b, 16
    xchg  
dsbo0:
    push b
   
    mov a, m
    sta dsbo1+1
    inx h    
    mov b, m
    inx h    
    mov c, m
    
    xchg
    

    mvi a, 0
    out 0C2h
    
    mov a, m
dsbo1:
    xri 0
    mov m, a
    inx h
    mov a, m
    xra b
    mov m, a
    inx h  
    mov a, m
    xra c
    mov m, a
    
    mvi a, 2
    out 0C2h

    ; ***

    lxi b, 64-2
    dad b
    xchg
    lxi b, 21-2
    dad b

    pop b
    dcr b
    jnz dsbo0
    pop b
    ret

;----------------------------------------------------------------------------

bitBlt:
    push b
    .db 21h ; lxi h
bitBlt_1: .dw 0
    .db 11h ; lxi d
bitBlt_2: .dw 0
    .db 0Eh ; mvi c,
bitBlt_3: .db 0
    mov b, a

    ; Расчет BPL
    mvi a, 64
    sub c
    sta BitBlt_bpl

BitBlt0:
    push b    
    ; Вывод строки
BitBlt3:
    ldax d
    mov b, a
    inx d
    xra a
    out 0C2h
    mov m, b
    inx h    
    mvi a, 2
    out 0C2h
    dcr c
    jnz BitBlt3

    ; BPL

    .db 01h ; LXI B,
BitBlt_bpl .dw 0 ; bpl
    dad b

    pop b
    dcr b
    jnz BitBlt0
    pop b
    ret
    