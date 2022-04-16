; Генератор псевдослучайных чисел

rand:
rand_seed = $+1
    mvi  a, 13
    mov  e, a
    add  a
    add  a
    add  e
    inr  a
    sta  rand_seed
    ret

