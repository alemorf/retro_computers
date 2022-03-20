#include "shell.h"

void cmd_delete() {
  uchar e;

  // Поместить в буфер имя без пути
  getSelectedName(cmdLine);
  if(cmdline[0]==0) { 
    clearCmdLine();
    return;
  }
  cmdLine_pos = strlen(cmdLine);

  // Спросить у пользователя
  if(inputBox(" Удаление ")) {

    // Преобразование относительного пути в абсолютный
    absolutePath();

    // Удаление файла
    e = fs_delete(cmdline);

    // Обновление списка файлов
    if(!e) getFiles();

    // Вывод ошибок
    drawError("Ошибка удаления файла", e);
  }

  // Восстанавлиаем экран и ком строку
  repairScreen(0);
}
