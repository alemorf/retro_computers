/*
It is an open source software to implement SD routines to
small embedded systems. This is a free software and is opened for education,
research and commercial developments under license policy of following trems.

(C) 2013 vinxru (aleksey.f.morozov@gmail.com)

It is a free software and there is NO WARRANTY.
No restriction on use. You can use, modify and redistribute it for
personal, non-profit or commercial use UNDER YOUR RESPONSIBILITY.
Redistributions of source code must retain the above copyright notice.

Version 0.99 5-05-2013
*/

#ifndef _SD_H_
#define _SD_H_

BYTE sd_init(); /* Инициализация карты */
BYTE sd_check(); /* Проверка наличия карты */
BYTE sd_read(BYTE* buffer, DWORD sector, WORD offsetInSector, WORD length); /* Чтение части сектора */
BYTE sd_write512(BYTE* buffer, DWORD sector); /* Запись сектора */

#endif
