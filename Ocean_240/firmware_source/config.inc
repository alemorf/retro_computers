; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; НЕ ЗАКОНЧЕНО !!!!

; Объем ОЗУ
#define CONFIG_RAM_SIZE_KB 256
;#define CONFIG_RAM_SIZE_KB 128

; Установлено 64 кБ ПЗУ. 48 кБ ПЗУ содержат файлы.
;#define CONFIG_ROM_DISK

; Драйвер клавиатуры
#define KEY_DRIVER_TERMINAL
;#define KEY_DRIVER_MATRIX

; Удаление мертвого кода
;#define CONFIG_NO_DEAD_CODE

; Удаление функции сохранения рам-диска на ленту. Верисия 1. ПЗУ содержит две версии функций.
;#define CONFIG_NO_READ_TAPE_ALL

; Удалении загрузки рам-диска с ленты. Верисия 1. ПЗУ содержит две версии функций.
;#define CONFIG_NO_READ_TAPE_ALL

; Сообщение выводимое при запуске компьютера. 28 символов
;                            "1234567890123456789012345678"
;#define CONFIG_HELLO_MESSAGE "OKEAH-240 CP/M (V2.2) REL.8B"

; Поддержка VT52
;#define CONFIG_VT52

; Выключить режим игровой графики
;#define CONFIG_NO_GAME

; Исправлены ошибки
;#define CONFIG_FIX_RAMDISK_RETURN_VALUE
;#define CONFIG_RAMDISK_SIZE_OPTIMIZATION
;#define CONFIG_RAMDISK_FIX_512K
;#define CONFIG_OPTIMIZE_SLICER_CALL
;#define CONFIG_OPTIMIZE_RAMDISK
;#define CONFIG_FLOPPY_SIZE_OPTIMIZATION
;#define CONFIG_FIX_SCROL_UP_GLITCH
