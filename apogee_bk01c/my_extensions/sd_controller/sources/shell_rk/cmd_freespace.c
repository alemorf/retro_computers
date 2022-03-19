// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

void cmd_freespace_1(uchar y, const char* text) {
  char buf[17];

  // Преобразование числа в строку
  i2s32(buf, (ulong*)&fs_low, 10, ' ');

  // Формирваоние строки в формате XXX XXX XXX МБ
  memcpy_back(buf+10, buf+7, 3); buf[9]  = ' ';
  memcpy_back(buf+6,  buf+4, 3); buf[5]  = ' ';
  memcpy_back(buf+2,  buf+1, 3); buf[1]  = ' ';
  strcpy(buf+13, " mb");

  // Вывод на экран
  drawWindowText(6, y, text);
  drawWindowText(16, y, buf);
}

//---------------------------------------------------------------------------

void cmd_freespace() {
  uchar e;  

  // Интерфейс
  drawWindow(" nakopitelx ");
  drawWindowText(6, 2, "prowerka...");  

  // Выполняем
  if(e = fs_getfree()) { 
    drawError("o{ibka ~teniq", e);
  } else {
    // Вывод данных
    cmd_freespace_1(2, "swobodno: ");

    // Запрос общего места
    if(!fs_gettotal()) cmd_freespace_1(1, "wsego:");

    // Ждем пользователя
    drawAnyKeyButton();
    getch1();
  }

  drawScreen();
}
