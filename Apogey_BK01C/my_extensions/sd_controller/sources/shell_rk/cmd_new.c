// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

char cmd_new1(uchar dir) {
  // Очищаем ком строку
  cmdLine[0] = 0;

  // Ввод имени файла
  if(!inputBox(dir ? " sozdatx papku " : " sozdatx fajl ") && cmdline[0]!=0) return 0;

  if(!absolutePath(cmdline)) return ERR_RECV_STRING;

  // Если мы создаем файл
  if(!dir) {
    if(strlen(cmdline) >= 255) return ERR_RECV_STRING;

    // Добавляем в начало ком строки звездочку
    memcpy_back(cmdline+1, cmdline, 255);
    cmdline[0] = '*';

    // Запуск редактора (внутри вызывается drawScreen)
    run(editorApp, cmdLine);
    return 0;
  }

  // Создание папки
  dir = fs_mkdir(cmdline);

  // Обновление списка файлов, если не было ошибки
  if(!dir) {
    getFiles();
    dupFiles(0);
  }

  return dir;
}

void cmd_new(uchar dir) {
  drawError("o{ibka sozdaniq papki", cmd_new1(dir));
  // Перериосвать экран
  drawScreen();
}