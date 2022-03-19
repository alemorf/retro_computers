// ROM-диск Апогей БК01 на основе стандартных ПЗУ
// (с) 6-12-2011 vinxru

#include "stdafx.h"
#include "vinlib/std.h"
#include "vinlib/file.h"
#include "vinlib/findfiles.h"
#include "vinlib/exec.h"
#include "vinlib/console.h"
#include "inifile.h"
#include "folders.h"
#include "romwriter.h"
#include "translateRk86.h"
#include <assert.h>

// Не выводим предуспреждения
void warning(cstring) {}
void fatal(Exception* e, const char* fn) { FatalAppExit(1, fn); }

//---------------------------------------------------------------------------
// Список файлов в прошивке                                                             

#pragma pack(push,1)
struct Map {
  char rombank;
  short romstart, ramstart;
};
#pragma pack(pop)

//---------------------------------------------------------------------------
// Параметры прошивки

class MakeRomIni : public IniFile {
public:
  enum { clRed, clGreen, clBlue, clYellow, clMagenta, clCyan, colorCnt };

  std::vector<string> colors[colorCnt];
  int romsize;
  string input, output, loader0, menu, archivator;

  void setDefault() {
    romsize = 512;
    input = ".";
    output = "49lf040.rom";
    loader0 = "loader0.bin";
    menu = "menu.bin";
    archivator = "megalz.exe";
    for(int i=0; i<colorCnt; i++)
      colors[i].clear();
  }

  void loadParam(const char* n, const char* v) {
    #pragma warning(disable:4996)

    if(0==strcmpi(n,"red"       )) colors[clRed    ].push_back(v); else
    if(0==strcmpi(n,"green"     )) colors[clGreen  ].push_back(v); else
    if(0==strcmpi(n,"blue"      )) colors[clBlue   ].push_back(v); else
    if(0==strcmpi(n,"yellow"    )) colors[clYellow ].push_back(v); else
    if(0==strcmpi(n,"magenta"   )) colors[clMagenta].push_back(v); else
    if(0==strcmpi(n,"cyan"      )) colors[clCyan   ].push_back(v); else
    if(0==strcmpi(n,"romsize"   )) romsize=atoi(v); else
    if(0==strcmpi(n,"output"    )) output=v; else
    if(0==strcmpi(n,"input"     )) input=v; else
    if(0==strcmpi(n,"loader0"   )) loader0=v; else
    if(0==strcmpi(n,"archivator")) archivator=v; else
    if(0==strcmpi(n,"menu"      )) menu=v;
  }

  ~MakeRomIni() {}
};

//---------------------------------------------------------------------------
// Используется для определения цвета

const char* processColor(MakeRomIni& ini, cstring cname) {
  static const char* colorPrefix[6] = { "\x8C", "\x85", "\x89", "\x84", "\x88", "\x81" };
  assert(ini.colorCnt==6);

  for(uint j=0; j<ini.colorCnt; j++) {
    std::vector<string>& a = ini.colors[j];
    for(uint i=0; i<a.size(); i++)
      if(cname.find(a[i])!=-1)
        return colorPrefix[j];
  }

  return 0;
}

//---------------------------------------------------------------------------

int cmain(int,const char**) {
  writeConsole("Создание прошивки ROM Диска для Апогей БК01Ц на основе стандартной ПЗУ\r\n"
	           "4-12-2011 (c) vinxru, b2m, titus, esl");

  MakeRomIni ini;
  ini.load("makerom.ini");

  // Удаляем старую прошивку
  DeleteFile(ini.output.c_str());

  // Загрузка списка файлов
  Folders folders;
  folders.find(ini.input);

  if(folders.folders.size()==1 && folders.folders.front().items.size()==0) 
    raise("Файлы не найдены.");

  // Прошивка
  RomWriter rom;
  rom.alloc(ini.romsize*1024);

  // Помещаем загрузчик во все страницы
  std::vector<byte_t> data;
  loadFile(data, ini.loader0);
  rom.loader0size = data.size();
  if(data.size()>32768) raise("Загрузчик не может быть больше 32 Кб!");
  for(uint i=32768; i+data.size()<=rom.buf.size(); i+=32768)
    rom.randomPut(i, data);

  // Помещаем меню
  loadFile(data, ini.menu);
  if(data.size()>32768) raise("Загрузчик не может быть больше 32 Кб!");
  rom.put(data);

  for(std::list<Folders::Folder>::iterator f=folders.folders.begin(); f!=folders.folders.end(); f++) {
    Folders::Folder& folder = *f;

    uint mnl=0;
    for(uint i=0; i<folder.items.size(); i++) {
      Folders::FolderItem& it = folder.items[i];

      // Расчет цвета
      const char* prefix = processColor(ini, it.shortName);
      if(prefix==0) prefix = it.link!=-1 ? "\x81" : "\x80";

      // Преобразуем кодировку в РК86, добавляем цвет, ограничиваем длину
      it.shortName = prefix+translateRk86(it.shortName);
      if(it.shortName.size()>60) it.shortName.resize(60);

      // Расчет максимальной длины имени
      if(mnl<it.shortName.size()) mnl=it.shortName.size();
    }
    mnl+=2;

    // Запонимаем адрес папки в памяти
    folder.intPtr = rom.ptr;

    // Сохраняем кол-во файлов в папке
    int c = folder.items.size();
	if(c>=256) raise("В папке не может быть больше 255 файлов ("+folder.items[0].name+")");
    rom.put(&c, 1);  

    // Сохраняем ширину колонки
    rom.put(&mnl, 1);  

    // Сохраняем адрес таблицы имен
    int namesPtr = rom.ptr + 2 + 5*folder.items.size();
    rom.put(&namesPtr, 2);  

    // Запонимаем, что тут будет находится карта
    folder.mapPtr = rom.ptr;

    // Оставляем место под карту
    std::vector<Map> map;
    map.resize(folder.items.size());
    rom.put(&map, map.size()*sizeof(Map));  

    // Сохранение наименований
    for(uint i=0; i<folder.items.size(); i++)
      rom.put(folder.items[i].shortName.c_str(), folder.items[i].shortName.size()+1);

    // Сохраняем имя нулевой длины в конце списка имен
    rom.put("", 1);
  }

  // Сохраняем размер
  if(rom.ptr>=32768) raise("Размер меню не может превышать 32 Кб");
  int s = (rom.ptr+255)/256;
  rom.randomPut(1, &s, 1);

  // Помещаем файлы в прошивку и генерируем карту
  string err;
  for(std::list<Folders::Folder>::iterator f=folders.folders.begin(); f!=folders.folders.end(); f++) {
    Folders::Folder& folder = *f;

    std::vector<Map> map;
    map.resize(folder.items.size());

    for(uint i=0; i<folder.items.size(); i++) {
      cstring name = folder.items[i].name;

	  // Это папка
      if(folder.items[i].link!=-1) {
        // Формирование карты
        map[i].rombank  = 0;
        map[i].romstart = folders.getFolder(folder.items[i].link).intPtr;
        map[i].ramstart = (short)0xF800; // Это признак папки
        continue;
      }

      // Загрузка файла
      data.resize(0);
      loadFile(data, name);

      // Расчет и проверка размера. Узнаем адрес запуска.
      int startAddr = (((int)(unsigned char)data[0])<<8) | ((int)(unsigned char)data[1]);
      int stopAddr  = (((int)(unsigned char)data[2])<<8) | ((int)(unsigned char)data[3]);
      uint len1 = stopAddr-startAddr+1;
      if(len1+4>data.size()) raise("Слишком короткий файл "+name);
      if(len1>32768) raise("Слишком длинный файл "+name);

      // Архивация
      if(!folder.items[i].pak) { 
        saveFile("archivator.tmp", fcmCreateAlways, &data[4], len1);
        int r = exec(ini.archivator, "archivator.tmp \""+name+".pak\"");
        DeleteFile("archivator.tmp");
        if(r!=0) raise(ini.archivator+" archivator.tmp \""+name+".pak\" ошибка "+i2s(r));  
      }

      // Формирование карты
      map[i].rombank  = rom.ptr>>15;
      map[i].romstart = rom.ptr&0x7FFF;
      map[i].ramstart = startAddr;

      // Помещаем файл в прошивку
      std::vector<char> packedData;
      loadFile(packedData, name+".pak");
      if(!rom.put_ne(&packedData[0], packedData.size()))
        err += "Нет места для файла "+name+"\r\n";
    }

    // Сохраняем карту
    if(map.size()>0) rom.randomPut(folder.mapPtr, &map[0], map.size()*sizeof(Map));
  }

  // Если какие то файлы не поместились, выводим список и выходим
  if(!err.empty()) {
    MessageBox(0,err.c_str(),0,0);
    return 1;
  }
  
  // Сохраняем прошивку 
  saveFile(ini.output, fcmCreateAlways, rom.buf);

  // Выводим кол-во свободный байт
  MessageBox(0,("Осталось свободно "+i2s(rom.buf.size()-rom.ptr)+" байт").c_str(),"",0);
  return 0;
}          