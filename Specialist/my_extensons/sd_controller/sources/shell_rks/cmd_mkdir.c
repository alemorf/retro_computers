#include "shell.h"
#include "dlg.h"

void cmd_new(uchar dir) {
  uchar e;
  char* title;

  // Очищаем ком строку
  clearCmdLine();

  // Ввод имени файла
  title = dir ? " Создание папки " : " Создание файла ";
  if(inputBox(title)) {

    // Если имя введено
    if(cmdline_pos) {    

      // Преобразование относительного пути в абсолютный
      absolutePath();

      if(dir) {
        // Создание папки
        e = fs_mkdir(cmdline);

        // Обновление списка файлов
        if(!e) getFiles();

        // Вывод ошибок
        drawError("Ошибка создания папки", e);
      } else {
        // Добавляем в ком строку *
        if(cmdline_pos==255) { 
          drawError("Ошибка создания файла", ERR_RECV_STRING);
        } else {
//!          memcpy_back(cmdline+1, cmdline, strlen(cmdline)+1);
//!          cmdline[0] = '*';

          // Запуск редактора
          drawError("Ошибка создания файла", fs_create(cmdline));

//!          cmd_run("edit.rks", 0);
          return; // Там вызывается repairScreen

          // Функция fs_exec стирает строку, а не должна
//          if(!dir) drawHelp(); 
        }
      }
    }
  }

  // Восстанавлиаем экран и ком строку
  repairScreen(0);
}
