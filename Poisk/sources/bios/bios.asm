;ver 26.02.90 
;****** ОТКРЫТА ПАМЯТЬ (96К) ****** 
 
INCLUDE EQU.ASM       ;Константы и переменные 
INCLUDE TEST.ASM      ;Начальный тест и инициализация 
INCLUDE MONN.ASM      ;Монитор 
INCLUDE ALTTAB.ASM    ; Таблица альтернативных кодов 128 - 256 
INCLUDE INT19.ASM     ;INT19 - загрузка системы 
INCLUDE INT10_B2.ASM    ;Write_TTY и световое перо 
INCLUDE TBL_KBDP.ASM 
INCLUDE INT16N.ASM 
INCLUDE TBL_INT9.ASM 
INCLUDE INT9.ASM 
INCLUDE INT_TIME.ASM 
INCLUDE INT13.ASM 
INCLUDE SCANINT2.ASM 
INCLUDE NMISER.ASM 
INCLUDE INT15_B.ASM 
INCLUDE RWCAS.ASM     ;INT15 - РАБОТА С ФАЙЛАМИ 
INCLUDE STP2.ASM 
INCLUDE INT10_A.ASM 
INCLUDE INT10_BN.ASM 
INCLUDE INT10_C.ASM   ;INT10 - часть 3 
INCLUDE INT12.ASM 
INCLUDE INT11.ASM 
INCLUDE INT15_A.ASM 
INCLUDE CRT_GEN.ASM 
INCLUDE INT1A.ASM 
INCLUDE VEK.ASM 
INCLUDE INT15_NP.ASM 
INCLUDE STP1.ASM      ;П/П звукового сигнала и печати сообщений 
INCLUDE RESTART.ASM 
end