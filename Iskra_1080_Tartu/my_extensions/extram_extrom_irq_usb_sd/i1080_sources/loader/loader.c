#include "../i1080.h"

void Start() __address(0);

extern uint8_t info_size_l __address(3);
extern uint8_t info_size_h __address(4);

void Entry2();

asm("org 0");

asm("org 0C000h");

/* Эти функции скомпилированы для работы из 3 окна, но после перезагрузки эти функции
 * подключены к нулевому окну и процессор выполняет программу с нулевого адреса.
 * Первым делом настроим маппер и перейдем в третье окно. 
 */

void Entry() {
    /* Выключение прерываний */
    DisableInterrupts();
    /* Включение маппера. Первым делом настраиваем окно из которого выполняется код. */
    out(PORT_WINDOW(0), a = PAGE_ROM(3));
    /* Подключение ПЗУ в 3 окно */
    out(PORT_WINDOW(3), a);
    return Entry2();
    return Entry2();
}

void Entry2() {
    /* Выключение видео */
    out(PORT_VIDEO_MODE_0_LOW, a);
    out(PORT_VIDEO_MODE_1_LOW, a);
    
    /* Настройка палитры */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a);
    out(PORT_PALETTE(2), a);
    out(PORT_PALETTE(3), a);
        
    /* Включение ОЗУ */
    out(PORT_WINDOW(0), a = PAGE_RAM(0));
    out(PORT_WINDOW(1), a = PAGE_RAM(1));
    out(PORT_WINDOW(2), a = PAGE_RAM(2));

    /* Ожидание готовности контроллера */
    do {
        a = in(PORT_SD_RESULT);
    } while(a == SD_RESULT_BUSY);
    
    /* Загрузка */
    de = &Start; /* Адрес загрузки */
    hl = 0; /* Номер сектора */
    do {
        do {
            /* Отправка команды */
            out(PORT_SD_SIZE, a = 5);  /* Длина команды */
            out(PORT_SD_DATA, a = SD_COMMAND_READ); /* Код команды */
            out(PORT_SD_DATA, a ^= a); /* Устройство */
            out(PORT_SD_DATA, a = l);  /* Смещение */
            out(PORT_SD_DATA, a = h);  /* Смещение */
            out(PORT_SD_DATA, a ^= a); /* Смещение */
            out(PORT_SD_DATA, a);      /* Смещение */

            /* Ожидание выполнения команды */
            do {
                a = in(PORT_SD_RESULT);
            } while(a == SD_RESULT_BUSY);

            /* Делаем еще попытку, если команда закончилась ошибкой */
            if (a != SD_RESULT_OK)
                return Entry2();

            /* Получаем данные */
            c = 128;
            do {
                *de = a = in(PORT_SD_DATA);
                de++;
            } while(flag_nz(c--));

            /* Следующий сектор */
            hl++;
        } while ((a = info_size_l) != l);
    } while ((a = info_size_h) != h);

    /* Запуск программы */
    return Start();
}

asm("savebin \"loader.bin\", 0, 10000h");
