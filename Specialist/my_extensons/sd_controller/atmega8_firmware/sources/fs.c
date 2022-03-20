/*
It is an open source software to implement FAT file system to
small embedded systems. This is a free software and is opened for education,
research and commercial developments under license policy of following trems.

(C) 2013 vinxru
(C) 2010, ChaN, all right reserved.

It is a free software and there is NO WARRANTY.
No restriction on use. You can use, modify and redistribute it for
personal, non-profit or commercial use UNDER YOUR RESPONSIBILITY.
Redistributions of source code must retain the above copyright notice.

Version 0.99 30-05-2013

P.S. goto allows you to save memory! Like other horrors bellow.

Program size: 3070 words (6140 bytes), 75% of FLASH at ATMega8 !!!
*/

/* 
Я не стал добавлять контроль на специальные имена
CON,PRN,AUX,CLOCK$,NUL,COM1,COM2,COM3,COM4,LPT1,LPT2,LPT3
что бы не занимать микроконтроллер. Файлы с такими именами
оставляю на совести программиста.
*/

//#include <stdafx.h>
#include "fs.h"
#include "sd.h"
#include <string.h>

/* Для наглядности */

#define	LD_WORD(ptr)    (*(WORD*)(ptr))
#define	LD_DWORD(ptr)   (*(DWORD*)(ptr))

/* Значения fs_type */
                  
#define FS_FAT16	0
#define FS_FAT32	1
#define FS_ERROR	2

/* Специальные значения кластеров */

#define FREE_CLUSTER    0
#define LAST_CLUSTER    0x0FFFFFFF

/* Системные переменные. Информация из boot-сектора */

typedef struct { 
#ifndef FS_DISABLE_CHECK
  BYTE  opened;              /* Что открыто: OPENED_NONE, OPENED_FILE, OPENED_DIR */
#endif
  BYTE  entry_able;          /* Результат выполнения функции fs_dirread */
  WORD  entry_index;         /* Номер записи в каталоге */
  DWORD entry_cluster;       /* Кластер записи в каталоге */
  DWORD entry_sector;        /* Сектор записи в каталоге */
  DWORD entry_start_cluster; /* Первый сектор файла или каталога (0 - корневой каталог FAT16) */
  DWORD ptr;                 /* Указатель чтения/записи файла*/
  DWORD size;                /* Размер файла / File size */
  DWORD cluster;             /* Текущий кластер файла */
  DWORD sector;              /* Текущий сектор файла */
  BYTE  changed;             /* Размер файла изменился, надо сохранить */
} File;

BYTE  fs_type;         /* FS_FAT16, FS_FAT32, FS_ERROR */
DWORD fs_fatbase;      /* Адрес первой FAT */
DWORD fs_fatbase2;     /* Адрес второй FAT */
BYTE  fs_csize;        /* Размер кластера в секторах */
WORD  fs_n_rootdir;    /* Кол-во записей в корневом каталоге (только FAT16) */
DWORD fs_n_fatent;     /* Кол-во кластеров */
DWORD fs_dirbase;      /* Корневой каталог (сектор для FAT16, кластер для FAT32) */
DWORD fs_database;     /* Адрес второго кластера */

/* Системные переменные. Остальное */

BYTE  lastError;       /* Последняя ошибка */
DWORD fs_fatoptim;     /* Первый свободный кластер */
DWORD fs_tmp;          /* Используеются для разных целей */
WORD  fs_wtotal;       /* Используется функциями fs_write_start, fs_write_end*/

/* Открытые файлы/папки */

File fs_file;

#ifndef FS_DISABLE_SWAP
File fs_secondFile;
#endif

/* Структура boot-сектора */

#define BPB_SecPerClus    13
#define BPB_RsvdSecCnt    14
#define BPB_NumFATs       16
#define BPB_RootEntCnt    17
#define BPB_TotSec16      19
#define BPB_FATSz16       22
#define BPB_TotSec32      32
#define BS_FilSysType     54
#define BPB_FATSz32       36
#define BPB_RootClus      44
#define BS_FilSysType32   82
#define MBR_Table         446

/**************************************************************************
*  Чтение сектора в буфер                                                 *
**************************************************************************/

static BYTE sd_readBuf(DWORD sector) {
  return sd_read(buf, sector, 0, 512);
}

/**************************************************************************
*  Запись буфера в сектор                                                 *
**************************************************************************/

static BYTE sd_writeBuf(DWORD sector) {
  return sd_write512(buf, sector);
}

/**************************************************************************
*  Инициализация                                                          *
**************************************************************************/

BYTE fs_init() {
  DWORD bsect, fsize, tsect;

  /* Сбрасываем оптимизацию */
  fs_fatoptim = 2;

  /* Предотвращаем ошибки программиста */
#ifndef FS_DISABLE_CHECK
  fs_file.opened = OPENED_NONE;
#ifndef FS_DISABLE_SWAP  
  fs_secondFile.opened = OPENED_NONE;
#endif 
  fs_type = FS_ERROR;
#endif

  /* Инициализация накопителя */
  if(sd_init()) return 1;
  
  /* Ищем файловую систему */
  bsect = 0;               
  while(1) {                 
    if(sd_readBuf(bsect)) return 1;
    if(LD_WORD(buf + 510) == 0xAA55) {
      if(LD_WORD(buf + BS_FilSysType  ) == 0x4146) break;
      if(LD_WORD(buf + BS_FilSysType32) == 0x4146) break;
      /* Возможно это MBR */       
      if(bsect == 0 && buf[MBR_Table+4]) { 
        bsect = LD_DWORD(buf + (MBR_Table + 8));
        if(bsect != 0) continue;
      }      
    }   
abort_noFS:
    lastError = ERR_NO_FILESYSTEM; return 1;
  }
        
  /* Размер таблицы FAT в секторах */
  fsize = LD_WORD(buf + BPB_FATSz16);
  if(fsize == 0) fsize = LD_DWORD(buf + BPB_FATSz32);
  
  /* Размер файловой системы в секторах */
  tsect = LD_WORD( buf + BPB_TotSec16);  
  if(tsect == 0) tsect = LD_DWORD(buf + BPB_TotSec32);
  
  /* Размер корневого каталога (должно быть кратно 16 и для FAT32 должно быть рано нулю) */
  fs_n_rootdir = LD_WORD(buf + BPB_RootEntCnt);
  
  /* Адреса таблиц FAT в секторах */
  fs_fatbase  = bsect + LD_WORD(buf + BPB_RsvdSecCnt);
  fs_fatbase2 = 0;
  if(buf[BPB_NumFATs] >= 2) fs_fatbase2 = fs_fatbase + fsize;

  /* Кол-во секторов на кластер */
  fs_csize = buf[BPB_SecPerClus];

  /* Кол-во кластеров */
  fsize *= buf[BPB_NumFATs];
  fs_n_fatent = (tsect - LD_WORD(buf + BPB_RsvdSecCnt) - fsize - fs_n_rootdir / 16) / fs_csize + 2;

  /* Адрес 2-ого кластера */
  fs_database = fs_fatbase + fsize + fs_n_rootdir / 16;
  
  /* Определение файловой системы */
  
  /* FAT 12 */
  if(fs_n_fatent < 0xFF7) goto abort_noFS; 
  
  /* FAT 16 */
  if(fs_n_fatent < 0xFFF7) {
    fs_dirbase = fs_fatbase + fsize; 
    fs_type = FS_FAT16;
    return 0;
  }    
   
  /* FAT 32 */
  fs_dirbase = LD_DWORD(buf + BPB_RootClus);
  
  /* Сбрасываем счетчик свободного места */
  if(LD_WORD(buf + BPB_RsvdSecCnt)>0) {
    bsect++;
    if(sd_readBuf(bsect)) return 1;
    if(LD_DWORD(buf) == 0x41615252 && LD_DWORD(buf + 0x1E4) == 0x61417272 && LD_DWORD(buf + 0x1FC) == 0xAA550000) {
      LD_DWORD(buf + 0x1E8) = 0xFFFFFFFF;
      LD_DWORD(buf + 0x1EC) = 0xFFFFFFFF;
      if(sd_writeBuf(bsect)) return 1;
    }
  }
  fs_type = FS_FAT32;
      
  return 0;
}

/**************************************************************************
*  Проверка наличия диска и если нужно, то его инициализация              *
**************************************************************************/

BYTE fs_check() {
  if(!sd_check()) return 0;
  return fs_init();
}

/**************************************************************************
*  Получить кластер из FS_DIRENTRY                                        *
*  Функция не портит buf (функции, в которых этого не написано, портят)   *
**************************************************************************/

static DWORD fs_getEntryCluster() {
  DWORD c = LD_WORD(FS_DIRENTRY + DIR_FstClusLO);
  if(fs_type != FS_FAT16) c |= ((DWORD)LD_WORD(FS_DIRENTRY + DIR_FstClusHI)) << 16;  
  return c;
}

/**************************************************************************
*  Получить следующий кластер.                                            *
*  Аргумент и результат находятся в fs_tmp.                               *
**************************************************************************/

static BYTE fs_nextCluster() {
  if(fs_type == FS_FAT16) {                                                                                    
    if(sd_read((BYTE*)&fs_tmp, fs_fatbase + fs_tmp / 256, (WORD)(BYTE)fs_tmp * 2, 2)) goto abort;
    fs_tmp &= 0xFFFF;
  } else {
    if(sd_read((BYTE*)&fs_tmp, fs_fatbase + fs_tmp / 128, (WORD)((BYTE)fs_tmp % 128) * 4, 4)) goto abort;
    fs_tmp &= 0x0FFFFFFF;
  }                            
  /* Для удобства разработки заменяем последний кластер на ноль. */
  if(fs_tmp < 2 || fs_tmp >= fs_n_fatent)
    fs_tmp = 0;
  return 0;
abort:
  return 1;
}

/**************************************************************************
*  Преобразовать номер кластера в номер сектора                           *
*  Аргумент и результат находятся в fs_tmp.                               *
*  Функция не портит buf                                                  *
***************************************************************************/

static void fs_clust2sect() {
  fs_tmp = (fs_tmp - 2) * fs_csize + fs_database;
}

/**************************************************************************
*  Получить очередной файл или папку                                      *
*  Удаленные файлы, метки тома, последний элемент, LFN показываются       *
*                                                                         *
*  Описание работы полностью идентично функции ниже, поэтому здесь не     *
*  приведено                                                              *
*                                                                         *
*  Функция не портит buf[0..MAX_FILENAME-1]                               *
***************************************************************************/
 
static BYTE fs_readdirInt() {
  if(fs_file.entry_able) {
    fs_file.entry_index++;

    /* В папке не может быть больше 65536 файлов, а в корне FAT16 не больше  fs_n_rootdir */
    if(fs_file.entry_index == 0 || (fs_file.entry_cluster == 0 && fs_file.entry_index == fs_n_rootdir)) { 
      fs_file.entry_index = 0;
retEnd:
      FS_DIRENTRY[DIR_Name] = 0; /* Признак последнего файла для пользователя вызывающего fs_dirread */
      fs_file.entry_able = 0; 
      return 0; 
    }	
      
    /* Граница сектора */
    if(fs_file.entry_index % 16 == 0) {        
      fs_file.entry_sector++;		

      /* Граница кластера */
      if(fs_file.entry_cluster != 0 && ((fs_file.entry_index / 16) % fs_csize) == 0) {

        /* Следующий кластер */ 
        fs_tmp = fs_file.entry_cluster;
        if(fs_nextCluster()) return 1;
        if(fs_tmp == 0) goto retEnd; /* Последний кластер, устаналиваем fs_file.entry_able = 0 */
         
        /* Сохраняем */
        fs_file.entry_cluster = fs_tmp;
        fs_clust2sect();
        fs_file.entry_sector = fs_tmp;
      }
    }
  } else {
    fs_file.entry_index = 0;
    fs_file.entry_able  = 1;
    fs_tmp = fs_file.entry_start_cluster; 

    /* Первый кластер и сектор папки. Этот код не имеет смысла выполнять 
    для FAT16, но зато код хорошо сжимается. Т.к. этот кусок кода аналогичен 
    куску выше. */
    fs_file.entry_cluster = fs_tmp;
    fs_clust2sect();
    fs_file.entry_sector = fs_tmp;

    /* Корневая папка FS_FAT16 */  
    if(fs_file.entry_cluster == 0) fs_file.entry_sector = fs_dirbase;
  }

  return sd_read(FS_DIRENTRY, fs_file.entry_sector, (WORD)((fs_file.entry_index % 16) * 32), 32);
}

/**************************************************************************
*  Получить очередной файл или папку (удаленные файлы пропускаются)       *
*                                                                         *
*  Эта функция вызывается после fs_opendir, которая настраивает все       *
*  нужные переменные, поэтому вам ничего трогать не надо. Информация      *
*  ниже приведена для лучшего понимания работы                            *
*                                                                         *
*  Если на входе entry_able=0,  то начинается новый поиск в папке         *
*  по адресу entry_start_cluster. При этом инициализируются переменные:   *
*  entry_able, entry_index, entry_sector, entry_cluster.                  *   
*                                                                         *
*  Если на входе fs_file.entry_able=1, то используются эти 4 переменные.  *
*                                                                         *
*  На выходе                                                              *
*    entry_able     - если 0 значит достигнут конец каталога              *
*    entry_sector   - сектор описателя                                    *
*    entry_cluster  - кластер описателя                                   *
*    entry_index    - номер описателя                                     *
*    FS_DIRENTRY    - описатель                                           *
*                                                                         *
*  Функция не портит buf[0..MAX_FILENAME-1]                               *
**************************************************************************/

BYTE fs_readdir_nocheck() {
  while(!fs_readdirInt()) {
    if(FS_DIRENTRY[DIR_Name] == 0) fs_file.entry_able = 0;
    if(fs_file.entry_able == 0) return 0;
    if(FS_DIRENTRY[DIR_Name] == 0xE5) continue; /*  Может быть еще 0x05 */
    if(FS_DIRENTRY[DIR_Name] == '.') continue;
    if((FS_DIRENTRY[DIR_Attr] & AM_VOL) == 0) return 0;
  }
  return 1;
}

BYTE fs_readdir() {
#ifndef FS_DISABLE_CHECK
  /* Папка должна быть открыта */
  if(fs_file.opened != OPENED_DIR) { lastError = ERR_NOT_OPENED; return 1; }
#endif
  return fs_readdir_nocheck();
}

/**************************************************************************
*  Сохранить изменения в обе таблицы FAT                                  *
**************************************************************************/

static BYTE fs_saveFatSector(DWORD sector) { 
  if(fs_fatbase2) if(sd_writeBuf(fs_fatbase2+sector)) return 1;
  return sd_writeBuf(fs_fatbase+sector);
}

/**************************************************************************
*  Выделить кластер                                                       *
*                                                                         *
*  Найденный кластер сохраняется в fs_tmp                                 *
**************************************************************************/

/* Ради функции fs_getfree пришлось усложнить функцию fs_allocCluster.
Если функция не используется, то можно с помощью макроса FS_DISABLE_GETFREESPACE
исключить лишний код */

#ifdef FS_DISABLE_GETFREESPACE
#define DIS(X)
#define ALLOCCLUSTER
#else
#define DIS(X) X
#define ALLOCCLUSTER 0
#endif

static BYTE fs_allocCluster(DIS(BYTE freeSpace)) {
  BYTE i;
  DWORD s;
  BYTE *a;

  /* Начинаем поиск с этого кластера */
  fs_tmp = fs_fatoptim;
  
  /* Последовательно перебираем сектора */
  while(1) {
    /* Сектор и смещение */ 
    s = fs_tmp / 256, i = (BYTE)fs_tmp, a = (BYTE*)((WORD*)buf + i);    
    if(fs_type != FS_FAT16) s = fs_tmp / 128, i |= 128, a = (BYTE*)((DWORD*)buf - 128 + i); 
    
    /* Читаем сектор */
    if(sd_readBuf(fs_fatbase + s)) goto abort;   
    
    /* Среди 128/256 чисел в секторе ищем 0 */    
    /* Куча проверок внутри цикла не самое быстрое решение, но зато получается очень компактный код. */    
    do {
      /* Кластеры кончились */
      if(fs_tmp >= fs_n_fatent) { DIS(if(freeSpace) return 0;) lastError = ERR_NO_FREE_SPACE; goto abort; }
      
      /* Ищем свободный кластер и помечаем как последний */
      if(fs_type == FS_FAT16) {
        if(LD_WORD(a) == 0) { DIS(if(!freeSpace) {) LD_WORD(a) = (WORD)LAST_CLUSTER; goto founded; DIS(} fs_file.sector++;) }
        a += 2;
      } else {
        if(LD_DWORD(a) == 0) { DIS(if(!freeSpace) {) LD_DWORD(a) = LAST_CLUSTER; goto founded; DIS(} fs_file.sector++;) }
        a += 4;
      }
      
      /* Счетчик */
      ++fs_tmp, ++i;
    } while(i != 0);
  }          
founded:  
  /* Оптимизация */
  fs_fatoptim = fs_tmp;
  
  /* Сохраняем изменения */
  return fs_saveFatSector(s);
abort:
  return 1;
}

#undef DIS

/**************************************************************************
*  Изменение таблицы FAT                                                  *
*                                                                         *
*  Если fs_tmp!=0, то FAT[cluster] = fs_tmp                               *
*  Если fs_tmp==0, то swap(FAT[cluster], fs_tmp)                          *
**************************************************************************/

static BYTE fs_setNextCluster(DWORD cluster) {
  DWORD s, prev;
  void* a;                                            
  
  /* Вычисляем сектор */  
  s = cluster / 128;
  if(fs_type == FS_FAT16) s = cluster / 256;
  
  /* Читаем сектор */  
  if(sd_readBuf(fs_fatbase + s)) return 1;
               
  /* Изменяем отдельный кластер */ 
  if(fs_type == FS_FAT16) {                                                                                    
    a = (WORD*)buf + (BYTE)cluster;
    prev = LD_WORD(a);
    LD_WORD(a) = (WORD)fs_tmp;
  } else {
    a = (DWORD*)buf + (BYTE)cluster % 128;
    prev = LD_DWORD(a);
    LD_DWORD(a) = fs_tmp;
  }
    
  /* Оптимизация поиска свободного кластера. Внезапно if() if() занимает меньше ПЗУ, чем && */
  if(fs_tmp == FREE_CLUSTER) if(cluster < fs_fatoptim) fs_fatoptim = cluster;

  /* Результат */
  if(fs_tmp == LAST_CLUSTER || fs_tmp == FREE_CLUSTER) 
    fs_tmp = prev;
  
  /* Сохраняем сектор */ 
  return fs_saveFatSector(s);
}

/**************************************************************************
*  Установить в описатель кластер                                         *
**************************************************************************/

static void fs_setEntryCluster(BYTE* entry, DWORD cluster) {  
  LD_WORD(entry + DIR_FstClusLO) = (WORD)(cluster);
  LD_WORD(entry + DIR_FstClusHI) = (WORD)(cluster >> 16);
}

/**************************************************************************
*  Очистить кластер и буфер                                               *
**************************************************************************/

static BYTE fs_eraseCluster(BYTE i) {
  memset(buf, 0, 512);
  for(; i < fs_csize; ++i)
    if(sd_writeBuf(fs_tmp + i)) return 1;
  return 0;
}

/**************************************************************************
*  Выделить описатель в каталоге                                          *
*                                                                         *
*  entry_able должно быть равно 0                                         *
*  entry_start_cluster должен содержать первый кластер папки              *
**************************************************************************/

static BYTE* fs_allocEntry() {
  /* Ищем в папке пустой описатель. */
  while(1) {
    if(fs_readdirInt()) return 0;

    /* Кластеры кончились */
    if(!fs_file.entry_able) break;

    /* Это свободный описатель */
    if(FS_DIRENTRY[0] == 0xE5 || FS_DIRENTRY[0] == 0) { /* Может быть еще 0x05 */

      /* Читаем сектор */
      if(sd_readBuf(fs_file.entry_sector)) return 0; 

      /* Найденный описатель */
      return buf + (fs_file.entry_index % 16) * 32;
    }
  }               
    
  /* Ограничение по кол-ву файлов */ 
  /* Корневой каталог FAT16 так же вернет fs_file.entry_index == 0 */
  if(fs_file.entry_index == 0) { lastError = ERR_DIR_FULL; return 0; }

  /* Выделить кластер. Результат в fs_tmp */
  if(fs_allocCluster(ALLOCCLUSTER)) return 0;

  /* Добавить еще один кластер к папке. */
  if(fs_setNextCluster(fs_file.entry_cluster)) return 0; /* fs_tmp сохранится, так как он не LAST и не FREE */

  /* Заполняем ответ */ 
  fs_file.entry_cluster = fs_tmp;
  fs_clust2sect();   
  fs_file.entry_sector  = fs_tmp;

  /* Очищаем кластер и за одно BUF (используется переменная fs_tmp) */
  fs_eraseCluster(0);

  /* Найденный описатель */
  return buf;
}

/**************************************************************************
*  Открыть/создать файл или папку                                         *
*                                                                         *
*  Имя файла в buf. Оно не должно превышать FS_MAXFILE симолов включая 0  *
*                                                                         *
*  what = OPENED_NONE - Открыть файл или папку                            *
*  what = OPENED_FILE - Создать файл (созданный файл открыт)              *
*  what = OPENED_DIR  - Создать папку (созданная папка не открыта)        *
*  what | 0x80        - Не создавать файл в папке entry_start_cluster     *
*                                                                         *
*  На выходе                                                              *
*   FS_DIRENTRY                 - описатель                               *
*   fs_file.entry_able          - 0 (если открыт существующий файл/папка) *
*   fs_file.entry_sector        - сектор описателя                        *
*   fs_file.entry_cluster       - кластер описателя                       *
*   fs_file.entry_index         - номер описателя                         *
*   fs_file.entry_start_cluster - первый кластер файла или папки          *
*   fs_parent_dir_cluster       - первый кластер папки предка (CREATE)    *
*   fs_file.ptr                 - 0 (если открыт файл)                    *
*   fs_file.size                - размер файла (если открыт файл)         *
*                                                                         *
*  Функция не портит buf[0..MAX_FILENAME-1]                               *
**************************************************************************/

static BYTE fs_open0_create(BYTE dir); /* forward */    
static CONST BYTE* fs_open0_name(CONST BYTE *p); /* forward */

#define FS_DIRFIND      (buf + 469)           /* 11 байт использующиеся внутри функции fs_open0 */
#define fs_notrootdir (*(BYTE*)&fs_file.size) /* Используется fs_open0, в это время переменные fs_file. не содежат нужных значения */  
#define fs_parent_dir_cluster fs_file.sector  /* Так же используется fs_file.sector для хранения первого кластера папки предка. */

BYTE fs_open0(BYTE what) {
  CONST BYTE *path;  
  BYTE r;  

  /* Проверка ошибок программиста */               
#ifndef FS_DISABLE_CHECK
  if(fs_type == FS_ERROR) { lastError = ERR_NO_FILESYSTEM; goto abort; }  
  fs_file.opened = OPENED_NONE;
#endif

  /* Предотвращение рекурсии */                      
  r = what & 0x80; what &= 0x7F;
  fs_parent_dir_cluster = fs_file.entry_start_cluster;
  
  /* Корневой каталог */
  fs_notrootdir = 0;
  fs_file.entry_start_cluster = fs_dirbase;
  if(fs_type == FS_FAT16) fs_file.entry_start_cluster =  0;                             

  /* Корневая папка */
  if(buf[0] == 0) {	
    if(what) goto abort_noPath;		
    FS_DIRENTRY[0] = 0;             /* Признак корневой папки */
    FS_DIRENTRY[DIR_Attr] = AM_DIR; /* Для упрощения определения файл/папка запишем сюда AM_DIR */
  } else {                        
    path = buf;
    while(1) {
      /* Получаем очередное имя из path в FS_DIRFIND */
      path = fs_open0_name(path);
      if(path == (CONST BYTE*)1) goto abort_noPath;      	
      /* Ищем имя в папке */      
      fs_file.entry_able = 0;
      while(1) {              
        if(fs_readdir_nocheck()) return 1;    
        if(fs_file.entry_able == 0) break;
        if(!memcmp(FS_DIRENTRY, FS_DIRFIND, 11)) break;
      }
      /* Последний элементу пути в режиме создания */            
      if(what && path == 0) {                        
        fs_parent_dir_cluster = fs_file.entry_start_cluster; /* Сохраняем в этой переменной результат для фунции fs_move */
        if(fs_type == FS_FAT32 && fs_parent_dir_cluster == fs_dirbase) fs_parent_dir_cluster = 0; 
        if(fs_file.entry_able == 0) return fs_open0_create(what-1); /* Продолжим там */          
        lastError = ERR_FILE_EXISTS; goto abort; 
      }
      /* Файл/папка не найдена */            
      if(fs_file.entry_able == 0) goto abort_noPath;
      
      /* Что то найдено */            
      fs_file.entry_start_cluster = fs_getEntryCluster();
      /* Это был последний элемент пути */            
      if(path == 0) break;                      
      /* Это должна быть папка */            
      if((FS_DIRENTRY[DIR_Attr] & AM_DIR) == 0) goto abort_noPath;
      /* Предотвращаем рекурсию для функции fs_move */
      if(r && fs_file.entry_start_cluster == fs_parent_dir_cluster) goto abort_noPath;
      /* Наденная папка уже не будет корневой */            
      fs_notrootdir = 1;
    }
  }
  /* Устанавливаем переменные */   
  fs_file.entry_able = 0;
  fs_file.size  = LD_DWORD(FS_DIRENTRY + DIR_FileSize);
  fs_file.ptr   = 0;  
#ifndef FS_DISABLE_CHECK
  fs_file.opened     = OPENED_FILE;
  if(FS_DIRENTRY[DIR_Attr] & AM_DIR) fs_file.opened = OPENED_DIR; 
#endif

  /* Нельзя дважды открывать файл */
#ifndef FS_DISABLE_CHECK
#ifndef FS_DISABLE_SWAP
  if(fs_secondFile.opened==OPENED_FILE && fs_file.opened==OPENED_FILE && fs_secondFile.entry_sector == fs_file.entry_sector && fs_secondFile.entry_index==fs_file.entry_index) {
    fs_file.opened  = OPENED_NONE;
    lastError = ERR_ALREADY_OPENED;
    goto abort;
  }
#endif
#endif

  return 0;
abort_noPath:
  lastError = ERR_NO_PATH;
abort: 
  return 1;
}

static BYTE exists(const flash BYTE* str, BYTE c) {
  while(*str)   
    if(*str++ == c) 
      return c;
  return 0;
}

static CONST BYTE * fs_open0_name(CONST BYTE *p) {
  BYTE c, ni, i;

  memset(FS_DIRFIND, ' ', 11);    
  i = 0; ni = 8;
  while(1) {
    c = *p++;
    if(c == 0) {
      if(i == 0) break; /* Пустое имя файла */
      return 0;
    }                                                     	
    if(c == '/') return p;
    if(c == '.') {
      if(i == 0) break; /* Пустое имя файла */
#ifndef FS_DISABLE_CHECK    
      if(ni != 8) break; /* Вторая точка */
#endif    
      i = 8; ni = 11;
      continue;
    }                 
    /* Слишком длинное име */
    if(i == ni) break;
    /* Запрещенные символы */
#ifndef FS_DISABLE_CHECK    
    if(exists((const flash BYTE* )"+,;=[]*?<:>\\|\"", c)) break;
    if(c <= 0x20) break;
    if(c >= 0x80) break;
#endif    
    /* Приводим к верхнему регистру */
    if(c >= 'a' && c <= 'z') c -= 0x20;
    /* Сохраняем имя */
    FS_DIRFIND[i++] = c;
  }                     
  /* Ошибка */
  return (CONST BYTE*)1;
}

static BYTE fs_open0_create(BYTE dir) {
  BYTE  new_name[11];
  DWORD allocatedCluster;     
  BYTE* allocatedEntry;

  /* Сохраняем имя, так как весь буфер будет затерт */
  memcpy(new_name, FS_DIRFIND, 11); 

  /* Выделяем кластер для папки */   
  if(dir) {
    if(fs_allocCluster(ALLOCCLUSTER)) goto abort; /* fs_file.entry_start_cluster изменен не будет, там первый кластер папки в которой мы создадим файл */
    allocatedCluster = fs_tmp;
  }

  /* Добавляем в папку описатель (сектор не сохранен) */
  allocatedEntry = fs_allocEntry();
  if(allocatedEntry == 0) {       
  
    /* В случае ошибки освобождаем кластер */
    fs_tmp = FREE_CLUSTER; 
    fs_setNextCluster(allocatedCluster);
    goto abort;
  }

  /* Устаналиваем имя в описатель. */
  memset(allocatedEntry, 0, 32);
  memcpy(allocatedEntry, new_name, 11);        

  if(!dir) {    
    /* Сохраняем описатель на диск */
    if(sd_writeBuf(fs_file.entry_sector)) goto abort;
    /* fs_file.entry_sector, fs_file.entry_index - устанавлиается в fs_allocCluster */
    fs_file.entry_start_cluster = 0; 
    fs_file.size           = 0;
    fs_file.ptr            = 0;
#ifndef FS_DISABLE_CHECK
    fs_file.opened              = OPENED_FILE;
#endif
    return 0;
  }
  
  /* Это папка */
  allocatedEntry[DIR_Attr] = AM_DIR;
  fs_setEntryCluster(allocatedEntry, allocatedCluster);

  /* Сохраняем описатель на диск */
  if(sd_writeBuf(fs_file.entry_sector)) goto abort;
           
  /* Сектор для новой папки */ 
  fs_tmp = allocatedCluster;
  fs_clust2sect();

  /* Очищаем fs_tmp и за одно buf */
  fs_eraseCluster(1); 
  
  /* Создаем пустую папку */
  memset(buf, ' ', 11); buf[0] = '.'; buf[11] = 0x10;
  fs_setEntryCluster(buf, allocatedCluster);         
  
  memset(buf+32, ' ', 11); buf[32] = '.'; buf[33] = '.'; buf[32+11] = 0x10;
  if(fs_notrootdir) fs_setEntryCluster(buf + 32, fs_file.entry_start_cluster); /* Сейчас в fs_file.size==0 значит корневой каталог */

  /* Сохраняем папку */
  return sd_writeBuf(fs_tmp);      
abort:
  return 1;
}

/**************************************************************************
*  Открыть файл                                                           *
**************************************************************************/

BYTE fs_open() {
  if(fs_openany()) goto abort;
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened == OPENED_FILE) return 0;
  fs_file.opened = OPENED_NONE;
#else  
  if((FS_DIRENTRY[DIR_Attr] & AM_DIR) == 0) return 0;
#endif
  lastError = ERR_NO_PATH;
abort:
  return 1;
}

/**************************************************************************
*  Открыть папку                                                          *
**************************************************************************/

BYTE fs_opendir() {
  if(fs_openany()) goto abort;
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened == OPENED_DIR) return 0;
  fs_file.opened = OPENED_NONE;
#else  
  if(FS_DIRENTRY[DIR_Attr] & AM_DIR) return 0;
#endif
  lastError = ERR_NO_PATH;
abort:
  return 1;
}

/**************************************************************************
*  Вычислить номер следующего сектора для чтения/записи                   *
*  Вызывается только из fs_read0, fs_write_start                          *
**************************************************************************/

static BYTE fs_nextRWSector() {
  if(fs_file.ptr == 0) {
    /* Чтение файла еще не начато */
    fs_tmp = fs_file.entry_start_cluster;
  } else {
    /* Еще не конец сектора */
    if((WORD)fs_file.ptr % 512) return 0;
        
    /* Следующий сектор */    
    fs_file.sector++;
        
    /* Еще не конец кластера */
    if(((fs_file.sector - fs_database) % fs_csize) != 0) return 0;

    /* Следующий кластер */
    fs_tmp = fs_file.cluster;
    if(fs_nextCluster()) return 1;
  }

  /* Если это был последний кластер, добавляем новый */
  if(fs_tmp == 0) {                
    if(fs_allocCluster(ALLOCCLUSTER)) return 1;
    if(fs_file.ptr == 0) fs_file.entry_start_cluster = fs_tmp;
                    else fs_setNextCluster(fs_file.cluster); /* fs_tmp сохранится, так как он не LAST и не FREE */
  }

  /* Ок */
  fs_file.cluster = fs_tmp;
  fs_clust2sect();
  fs_file.sector  = fs_tmp;
  return 0;
}

/**************************************************************************
*  Прочитать из файла несколько байт в buf                                *
*                                                                         *
*  Пользователь не должен выходить за пределы файла при чтении, иначе     *
*  возникнет утечка свобожного места на диске.                            *
*                                                                         *
*  Аргументы:                                                             *
*    ptr      - буфер для чтения, может быть buf                          *
*    len      - кол-во байт, которые необходимо прочитать                 *
**************************************************************************/

BYTE fs_read0(BYTE* ptr, WORD len) {
  WORD sectorLen;

  /* Проверка ошибок программиста */
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
#endif

  while(len) {
    /* Если указатель находится на границе сектора */    
    if(fs_nextRWSector()) goto abort;
  
    /* Кол-во байт до конца сектора */      
    sectorLen = 512 - ((WORD)fs_file.ptr % 512);
    if(len < sectorLen) sectorLen = len;

    /* Читаем данные */
    if(ptr) {
      if(sd_read(ptr, fs_file.sector, (WORD)fs_file.ptr % 512, sectorLen)) goto abort;
      ptr += sectorLen;         
    }
  
    /* Увеличиваем смещение */
    fs_file.ptr += sectorLen;
    len -= sectorLen;
  }

  /* Увеличение размера файла */
  if(fs_file.ptr > fs_file.size) fs_file.size = fs_file.ptr, fs_file.changed = 1;
    
  return 0;
abort:
#ifndef FS_DISABLE_CHECK
  fs_file.opened = OPENED_NONE;
#endif
  return 1;
}

/**************************************************************************
*  Прочитать из файла несколько байт в buf                                *
*                                                                         *
*  Аргументы:                                                             *
*    ptr      - буфер для чтения, может быть buf                          *
*    len      - кол-во байт, которые необходимо прочитать                 *
*    readed   - указатель, для сохранения кол-ва реально прочитанных байт *
**************************************************************************/

BYTE fs_read(BYTE* ptr, WORD len, WORD* readed) {
  /* Ограничиваем кол-во байт для чтения */
  if(len > fs_file.size - fs_file.ptr) len = (WORD)(fs_file.size - fs_file.ptr);
  *readed = len; 
  
  /* Проверка на ошибки происходит там */
  return fs_read0(ptr, len);
}

/**************************************************************************
*  Сохранить длину файла и превый кластер в опистаель                     *
*  Вызывается из fs_lseek, fs_write_start, fs_write_end, fs_write_eof     *
**************************************************************************/

static char fs_saveFileLength() {
  BYTE* entry;

  if(fs_file.changed == 0) return 0;
  fs_file.changed = 0;

  /* Изменение описателя файла */
  if(sd_readBuf(fs_file.entry_sector)) return 1;

  entry = buf + (fs_file.entry_index % 16) * 32;
  LD_DWORD(entry + DIR_FileSize) = fs_file.size;  
  fs_setEntryCluster(entry, fs_file.entry_start_cluster);

  return sd_writeBuf(fs_file.entry_sector);
}

/**************************************************************************
*  Установить смещение чтения/записи файла                                *
**************************************************************************/

#define LSEEK_STEP 32768

BYTE fs_lseek(DWORD off, BYTE mode) {
  DWORD l;

  /* Режим */
  if(mode==1) off += fs_file.ptr; else
  if(mode==2) off += fs_file.size;                        

  /* Можно заменить на fs_file.ptr = 0 для уменьшения кода*/ 
  if(off >= fs_file.ptr) off -= fs_file.ptr; else fs_file.ptr = 0;
  
  do { /* Выполняем один цикл даже для off=0, так как внутри происходит проверка на ошибки */
    l = off;
    if(l > LSEEK_STEP) l = LSEEK_STEP;
    if(fs_read0(0, (WORD)l)) return 1;
    off -= l;
  } while(off);

  /* Размер файла мог изменится */
  fs_saveFileLength();
  
  /* Результат */
  fs_tmp = fs_file.ptr;

  return 0;
}

/**************************************************************************
*  Записать в файл (шаг 1)                                                *
***************************************************************************/

BYTE fs_write_start() {
  WORD len;

  /* Проверка ошибок программиста */
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
  if(fs_wtotal == 0) { lastError = ERR_NO_DATA; goto abort; }
#endif

  /* Сколько можно еще дописать в этот сектор? */
  len = 512 - (WORD)fs_file.ptr % 512;
    
  /* Ограничиваем остатком данных в файле */
  if(len > fs_wtotal) len = (WORD)fs_wtotal;

  /* Вычисление fs_file.sector, выделение кластеров */
  if(fs_nextRWSector()) goto abort; /* Должно вылетать только по ошибкам ERR_NO_FREE_SPACE, ERR_DISK_ERR */

  /* Корректируем длину файла */
  if(fs_file.size < fs_file.ptr + len) {
    fs_file.size = fs_file.ptr + len;
    fs_file.changed = 1;
  }

  /* Читаем данные сектора, если не весь сектор будет заполнен */
  if(len != 512) {      
    if(sd_readBuf(fs_file.sector)) goto abort;
  }
                              
  fs_file_wlen = len;
  fs_file_woff = (WORD)fs_file.ptr % 512;
  return 0;
abort:
  /* Скорее всего это ошибка ERR_NO_FREE_SPACE */
  /* Если размер файла был изменен, то надо бы сохранить изменения в описатель файла. */
  fs_saveFileLength();
  /* Закрываем файл */ 
#ifndef FS_DISABLE_CHECK
  fs_file.opened = OPENED_NONE;
#endif
  return 1;
}

/**************************************************************************
*  Записать в файл (шаг 2)                                                *
***************************************************************************/

BYTE fs_write_end() {
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
#endif

  /* Записываем изменения на диск */
  if(sd_writeBuf(fs_file.sector)) goto abort;
  
  /* В случае ошибки файл может содержать больше кластеров, чем требуется по его размеру. */
  /* Но это не плохо, данные не повреждены. А эта ошибка проявится лишь в уменьшении */ 
  /* места на диске. */
  
  /* Счетчики */
  fs_file.ptr += fs_file_wlen;
  fs_wtotal   -= fs_file_wlen;

  /* Если запись закончена, сохраняем размера файла и первый кластер */   
  if(fs_wtotal == 0) {
    if(fs_saveFileLength()) goto abort;
  }

  /* Ок */  
  return 0;  
abort:  
#ifndef FS_DISABLE_CHECK
    fs_file.opened = OPENED_NONE;
#endif
  return 1;
}

/**************************************************************************
*  Освободить цепочку кластеров начиная с fs_tmp                          *
**************************************************************************/

static BYTE fs_freeChain() {
  DWORD c;
  while(1) {
    if(fs_tmp < 2 || fs_tmp >= fs_n_fatent) return 0;
    /* Освободить кластер fs_tmp и записть в fs_tmp следующий за ним кластер */
    c = fs_tmp, fs_tmp = FREE_CLUSTER;
    if(fs_setNextCluster(c)) break; /* fs_tmp будет содержать следующий кластер, так как записывается FREE_CLUSTER */
  }
  return 1;
}

/**************************************************************************
*  Переместить файл/папку                                                 *
**************************************************************************/

BYTE fs_move0() {
  BYTE* entry;
  BYTE tmp[21];
  WORD old_index;
  DWORD old_sector, old_start_cluster;

#ifndef FS_DISABLE_CHECK
  if(fs_file.opened == OPENED_NONE) { lastError = ERR_NOT_OPENED; goto abort; }
#endif

  /* Запоминаем старый описатель */
  old_index         = fs_file.entry_index;
  old_sector        = fs_file.entry_sector;
  old_start_cluster = fs_file.entry_start_cluster;

  /* Создаем новый файл. В папку он превратится позже. 0x80 - это предотвращаем рекурсию. */  
  if(fs_open0(OPENED_FILE | 0x80)) goto abort;
  
  /* Предотвращаем ошибки программиста */
#ifndef FS_DISABLE_CHECK
  fs_file.opened = OPENED_NONE;
#ifndef FS_DISABLE_SWAP  
  fs_secondFile.opened = OPENED_NONE; 
#endif
#endif
  /* fs_file.sector содежит первый кластер папки, в которой находится созданный файл. */

  /* Удаление старого файла/папки и перенос всех свойств */
  if(sd_readBuf(old_sector)) goto abort;
  entry = buf + (old_index % 16) * 32;
  memcpy(tmp, entry+11, 21);
  entry[0] = 0xE5;
  if(sd_writeBuf(old_sector)) goto abort;

  /* Копируем все свойства новому файлу, тем самым превращая его в папку */
  if(sd_readBuf(fs_file.entry_sector)) goto abort;
  entry = buf + (fs_file.entry_index % 16) * 32;
  memcpy(entry+11, tmp, 21);
  if(sd_writeBuf(fs_file.entry_sector)) goto abort;

  /* В папке надо еще скорретировать описатель .. */
  if(entry[DIR_Attr] & AM_DIR) {
    fs_tmp = old_start_cluster; /* Первый кластер нашей папки */
    fs_clust2sect();
    if(sd_readBuf(fs_tmp)) goto abort;
    fs_setEntryCluster(buf+32, fs_parent_dir_cluster); /* Первый кластер папки предка.*/
    if(sd_writeBuf(fs_tmp)) goto abort;
  }
                    
  return 0;
abort:
  return 1;
}

BYTE fs_move(const char* from, const char* to) {
  strcpy((char*)buf, from);
  if(fs_openany()) return 1;
  strcpy((char*)buf, to);
  return fs_move0();
}

/**************************************************************************
*  Удалить файл или пустую папку                                          *
*  Имя файла должно содержаться в buf и не превышать FS_MAXFILE симолов   *
*  включая терминатор                                                     *
**************************************************************************/

BYTE fs_delete() {
  DWORD entrySector;
  BYTE* entry;
     
  /* Там будет проверен fs_type == FS_ERROR */
  if(fs_openany()) goto abort;
    
  /* Предотвращаем ошибки программиста */
  fs_file.opened = OPENED_NONE;
#ifndef FS_DISABLE_SWAP  
  fs_secondFile.opened = OPENED_NONE; 
#endif
                                                                   
  /* Корневую папку удалять нельзя */
  if(FS_DIRENTRY[0] == 0) { lastError = ERR_NO_PATH; goto abort; } 

  /* Сохраняем интерформацию о найденном файле, так как fs_readdir ниже их прибьет */
  entrySector = fs_file.entry_sector;
  entry = buf + (fs_file.entry_index % 16) * 32;

  /* В папке не должно быть файлов */
  if(FS_DIRENTRY[DIR_Attr] & AM_DIR) {
    /* Перематывем папку на начало */
    fs_file.entry_able = 0;                                                      
    /* Ищем первый файл или папку */
    /* fs_file.entry_start_cluster сохряняется (содержит первый кластер файла или папки) */   
    if(fs_readdir_nocheck()) goto abort;
    /* Если нашли, то ошибка */                                        
    if(fs_file.entry_able) { lastError = ERR_DIR_NOT_EMPTY; goto abort; } 
  }

  /* Удаляем описатель */
  if(sd_readBuf(entrySector)) goto abort;
  entry[0] = 0xE5;
  if(sd_writeBuf(entrySector)) goto abort;

  /* Освобождаем цепочку кластеров */
  fs_tmp = fs_file.entry_start_cluster;
  return fs_freeChain();  
abort:
  return 1;
}

/**************************************************************************
*  Установить конец файла                                                 *
**************************************************************************/

BYTE fs_write_eof() {
  /* Проверка ошибок программиста */
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }  
#endif

  /* Корректируем либо FAT, либо описатель файла. */
  if(fs_file.ptr == 0) {
    /* Удалем все кластеры файла */
    fs_tmp = fs_file.entry_start_cluster;
    fs_file.entry_start_cluster = 0;
  } else {
    /* Этот кластер файла последний. */
    fs_tmp = LAST_CLUSTER;
    if(fs_setNextCluster(fs_file.cluster)) goto abort; /* fs_tmp будет содержать следующий кластер, так как записывается LAST_CLUSTER */
  }

  /* Удалем все кластеры файла после этого. (они содержатся в fs_tmp); */
  if(fs_freeChain()) goto abort;

  /* Сохраняем длну и первый кластер */
  fs_file.size    = fs_file.ptr;
  fs_file.changed = 1;
  if(!fs_saveFileLength()) return 0;

abort:
#ifndef FS_DISABLE_CHECK
  fs_file.opened = OPENED_NONE;
#endif
  return 1;
}

/**************************************************************************
*  Записать в файл                                                        *
**************************************************************************/

BYTE fs_write(CONST BYTE* ptr, WORD len) {
  /* Проверка на ошибки происходит в вызываемых функциях */

  /* Конец файла */
  if(len == 0) return fs_write_eof();

  fs_wtotal = len;
  do {
    if(fs_write_start()) goto abort;
    memcpy(fs_file_wbuf, ptr, fs_file_wlen);
    ptr += fs_file_wlen;
    if(fs_write_end()) goto abort;
  } while(fs_wtotal);

  return 0;
abort:
  return 1;
}

/**************************************************************************
*  Переключить файлы                                                      *
**************************************************************************/

#ifndef FS_DISABLE_SWAP
void fs_swap() {
  /* Это занимает меньше ПЗУ, чем три функции memcpy */
  BYTE t, *a = (BYTE*)&fs_file, *b = (BYTE*)&fs_secondFile, n = sizeof(File);  
  do {
    t=*a, *a=*b, *b=t; ++a; ++b;
  } while(--n);
}
#endif

/**************************************************************************
*  Расчет свободного места                                                *
*                                                                         *
*  Результат в переменной fs_tmp в мегабайтах                             *
*  Функция закрывает файл                                                 *
**************************************************************************/

#ifndef FS_DISABLE_GETFREESPACE
BYTE fs_getfree() {
  /* Мы испортим переменную fs_file.sector, поэтому закрываем файл */
  fs_file.opened = OPENED_NONE;  

  /* Кол-во свободных кластеров будет в fs_file.sector */  
  fs_file.sector = 0;  
  if(fs_allocCluster(1)) return 1; 

  /* Пересчет в мегабайты */  
  fs_tmp = ((fs_file.sector >> 10) + 1) / 2 * fs_csize;

  return 0;
}  
#endif

/**************************************************************************
*  Размер накопителя в мегабайтах                                         *
**************************************************************************/

BYTE fs_gettotal() {
  /* Проверка ошибок программиста */               
#ifndef FS_DISABLE_CHECK
  if(fs_type == FS_ERROR) { lastError = ERR_NO_FILESYSTEM; return 1; }  
#endif

  fs_tmp = ((fs_n_fatent >> 10) + 1) / 2 * fs_csize;
  return 0;
}  

/**************************************************************************
*  Размер файла                                                           *
**************************************************************************/

BYTE fs_getfilesize() {
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) {
    lastError = ERR_NOT_OPENED;
    return 1;
  }
#endif
  fs_tmp = fs_file.size;
  return 0;
}

/**************************************************************************
*  Указатель чтения записи файла                                          *
**************************************************************************/

BYTE fs_tell() {
#ifndef FS_DISABLE_CHECK
  if(fs_file.opened != OPENED_FILE) {
    lastError = ERR_NOT_OPENED;
    return 1;
  }
#endif
  fs_tmp = fs_file.ptr;
  return 0;
}
