; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; CCP вызывает эту функцию для выполнения новых команд

CcpCommands:
        ; Предотвращаем переполнение стека
        lxi    h, 0
        dad    sp
        shld   v_saved_stack
        lxi    sp, v_safe_stack

        ; Поиск в введенной пользователем командной строке новой команды
        call   GetCcpCommandIndex

        ; Получаем адрес функции новой команды или функции возврата в CCP
        lxi    h, ccp_commands
        mov    e, a
        mvi    d, 0
        dad    d
        dad    d
        mov    a, m
        inx    h
        mov    h, m
        mov    l, a

        ; Запускаем коменду
        pchl

;----------------------------------------------------------------------------

CCP_COMMANDS_COUNT = 3
CCP_COMMAND_SIZE = 5

a_ccp_commands_names:
        .text "SDIR "
        .text "READ "
        .text "WRITE"

;----------------------------------------------------------------------------
; Поиск в введенной пользователем командной строке новой кманды

GetCcpCommandIndex:
        lxi    h, a_ccp_commands_names
        mvi    c, 0
loc_DB2E: ; Если команда не найдена, то выход с A = CCP_COMMANDS_COUNT
          mov    a, c
          cpi    CCP_COMMANDS_COUNT
          rnc

          ; Сравнение командной строки с очередной строкой
          lxi    d, v_ccp_command_line_buffer
          mvi    b, CCP_COMMAND_SIZE
loc_DB37:   ldax   d
            cmp    m
            jnz    loc_DB4A
            inx    d
            inx    h
            dcr    b
          jnz    loc_DB37

          ; После команды обязателено должен идти пробел
          ldax   d
          cpi    ' '
          jnz    loc_DB4F

          ; Команда найдена. Выход с номером команды в A.
          mov    a, c
          ret

loc_DB4A:   inx  h
            dcr  b
          jnz    loc_DB4A
loc_DB4F:
          inr    c
        jmp      loc_DB2E

;----------------------------------------------------------------------------

ccp_commands:
        .dw CcpSdir
        .dw CcpRead
        .dw CcpWrite
        .dw CcpReturn

;----------------------------------------------------------------------------
; Функция возврата в CCP, когда новая команда в не обнаружена

CcpReturn:
        lhld   v_saved_stack
        sphl
        jmp    ccp_ram_B200 + 6A5h
