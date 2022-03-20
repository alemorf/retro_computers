#include "shell.h"

void cmd_run2(const char* prog, const char* cmdLine) {
  char e;

  // Запуск
  e = fs_exec(prog, cmdLine);

  // Выводим ошибку
  drawError(prog, e); 

  // Восстанавлиаем экран и ком строку
  repairScreen(0);
}

void cmd_run(const char* prog, uchar selectedFile) {  
  char *p, *c;

  if(selectedFile) getSelectedName(cmdline);

  // Если указано имя програмы, то ком строка передается полностью 
  c = cmdLine;

  // Если не указано имя програмы
  if(prog == 0)  {

    // Преобразование относительного пути в абсолютный
    absolutePath();

    // Разделение ком строки по первому пробелу
    prog = cmdLine;
    c = strchr(prog, 32);
    if(c) *c=0, ++c; else c="";
  }

  cmd_run2(prog, c);
}
