// SD Controller for Computer "Specialst"
// (c) 26-05-2013 vinxru (aleksey.f.morozov@gmail.com)

//#include <stdafx.h>

#define F_CPU 8000000UL        //freq 8 MHz

#include "common.h"
#include <string.h>
#include "sd.h"
#include "fs.h"
#include "proto.h"

#ifndef X86_DEBUG
#include <delay.h>
#endif

#define O_OPEN   0
#define O_CREATE 1
#define O_MKDIR  2
#define O_DELETE 100
#define O_SWAP   101

#define ERR_START       0x40
#define ERR_WAIT        0x41
#define ERR_OK_NEXT         0x42
#define ERR_OK_CMD          0x43
#define ERR_OK_READ         0x44
#define ERR_OK_ENTRY        0x45
#define ERR_OK_WRITE        0x46
#define ERR_OK_RKS          0x47

unsigned char buf[512];

/*******************************************************************************
* Для удобства                                                                 *
*******************************************************************************/

void recvBin(BYTE* d, WORD l) {
  for(; l; --l) {
    *d++ = wrecv();
  }  
}

void recvString() {
  BYTE c;
  BYTE* p = buf;       
  do {
    c = wrecv();
    if(p != buf + FS_MAXFILE) *p++ = c; else lastError = ERR_RECV_STRING;
  } while(c);
}

void sendBin(BYTE* p, WORD l) {
  for(; l; l--)
    send(*p++);
}

void sendBinf(flash BYTE* d, BYTE l) {
  for(; l; --l)
    send(*d++);
}

/*******************************************************************************
* Отправка всех блоков файла                                                   *
*******************************************************************************/

WORD readLength;

void readInt(char rks) { 
  WORD readedLength, lengthFromFile;
  BYTE* wptr;

  while(readLength) { 
    // Расчет длины блока (выравниваем чтение на сектор)
    if(fs_tell()) return;
    readedLength = 512 - (fs_tmp % 512);
    if(readedLength > readLength) readedLength = readLength;

    // Уменьшаем счетчик
    readLength -= readedLength;

    // Читаем блок
    if(fs_read0(buf, readedLength)) return;

    // Заголовок RKS файла
    wptr = buf;
    if(rks) { // Если rks=1, перед вызовом надо проверить, что бы readLength>4 и fs_file.ptr=0, иначе может быть злостный сбой
      rks = 0;

      // Посылаем адрес загрузки
      send(ERR_OK_RKS);
      sendBin(buf, 2);    
      send(ERR_WAIT);

      // Корректируем указатели
      wptr += 4;
      readedLength -= 4;

      // Длина из файла
      lengthFromFile = *(WORD*)(buf+2) - *(WORD*)(buf) + 1;

      // Корректируем длину  
      if(readedLength > lengthFromFile) {
        readedLength = lengthFromFile;
      } else {          
        lengthFromFile -= readedLength;
        if(readLength > lengthFromFile) lengthFromFile = readedLength;
      }
    }  

    // Отправляем блок
    send(0);    
    sendBin((BYTE*)&readedLength, 2);
    sendBin(wptr, readedLength);
    send(ERR_WAIT);
  }

  // Если все ОК
  if(!lastError) lastError = ERR_OK_READ;
}

/*******************************************************************************
* Версия команд контроллера                                                    *
*******************************************************************************/

void cmd_ver() {
  sendStart(1);
    
  // Версия + Производитель
  sendBinf("V1.0 23-05-2013 ", 16);
              //0123456789ABCDEF
}

/*******************************************************************************
* BOOT / EXEC                                                                  *
*******************************************************************************/

void cmd_boot_exec() {
  // Файл по умолчанию
  if(buf[0]==0) strcpyf(buf, "boot/sdbios.rks");      

  // Открываем файл
  if(fs_open()) return;
  
  // Максимальный размер файла
  readLength = 0xFFFF;  
  if(fs_getfilesize()) return;
  if(readLength > fs_tmp) readLength = (WORD)fs_tmp;

  // Файлы RKS должны быть длиной >4 байт. Мы заносим в readLength = 0 и программа
  // получает ERR_OK. Но так как она ждем ERR_OK_RKS, это будет ошибкой 
  if(readLength < 4) readLength = 0;

  readInt(/*rks*/1);  
}

void cmd_boot() { 
  buf[0] = 0;
  cmd_boot_exec();  
}

void cmd_exec() {     
  // Прием имени файла
  recvString();

  // Режим передачи и подтверждение
  sendStart(ERR_WAIT);
  if(lastError) return; // Переполнение строки
  
  cmd_boot_exec();    
}

/*******************************************************************************
* Начать/продолжить посик файлов в папке                                       *
*******************************************************************************/

typedef struct {
    char    fname[11];    // File name
    BYTE    fattrib;    // Attribute
    DWORD   fsize;        // File size
    union {
      struct {
        WORD    ftime;        // Last modified time
        WORD    fdate;        // Last modified date 
      };
      DWORD ftimedate;
    };
} FILINFO2;

void cmd_find() {
  WORD n;
  FILINFO2 info;              
  
  // Принимаем путь
  recvString();

  // Принимаем макс кол-во элементов
  recvBin((BYTE*)&n, 2);

  // Режим передачи и подтверждение
  sendStart(ERR_WAIT);
  if(lastError) return;

  // Открываем папку
  if(buf[0] != ':') {
    if(fs_opendir()) return;
  }

  for(; n; --n) {
    /* Читаем очереной описатель */
    if(fs_readdir()) return;

    /* Конец */
    if(FS_DIRENTRY[0] == 0) {
      lastError = ERR_OK_CMD;
      return;
    }

    /* Сжимаем ответ для компьютера */
    memcpy(info.fname, FS_DIRENTRY+DIR_Name, 12);
    memcpy(&info.fsize, FS_DIRENTRY+DIR_FileSize, 4);
    memcpy(&info.ftimedate, FS_DIRENTRY+DIR_WrtTime, 4);
    //memcpy(memcpy(memcpy(info.fname, FS_DIRENTRY+DIR_Name, 12, FS_DIRENTRY+DIR_FileSize, 4), FS_DIRENTRY+DIR_WrtTime, 4);

    /* Отправляем */
    send(ERR_OK_ENTRY);
    sendBin((BYTE*)&info, sizeof(info));
    send(ERR_WAIT);
  }

  /* Ограничение по размеру */  
  lastError = ERR_MAX_FILES; /*! Надо опеределать, что бы не было ложных ошибок */
}

/*******************************************************************************
* Открыть/создать файл/папку                                                   *
*******************************************************************************/

void cmd_open() {
  BYTE mode;
 
  /* Принимаем режим */
  mode = wrecv();    

  // Принимаем имя файла
  recvString();

  // Режим передачи и подтверждение
  sendStart(ERR_WAIT);

  // Открываем/создаем файл/папку
  if(mode == O_SWAP) {
    fs_swap();
  } else
  if(mode == O_DELETE) {
    fs_delete();
  } else
  if(mode == O_OPEN) {
    fs_open();
  } else 
  if(mode < 3) {
    fs_open0(mode);
  } else {
    lastError = ERR_INVALID_COMMAND;
  }

  // Ок
  if(!lastError) lastError = ERR_OK_CMD;
}

/*******************************************************************************
* Переместить файл/папку                                                       *
*******************************************************************************/

void cmd_move() {
  recvString();
  sendStart(ERR_WAIT);
  fs_openany();
  sendStart(ERR_OK_WRITE);
  recvStart();
  recvString();
  sendStart(ERR_WAIT);
  if(!lastError) fs_move0();
  if(!lastError) lastError = ERR_OK_CMD;
}

/*******************************************************************************
* Установить/прочитать указатель чтения                                        *
*******************************************************************************/

void cmd_lseek() {
  BYTE mode;
  DWORD off;

  // Принимаем режим и смещение
  mode = wrecv();    
  recvBin((BYTE*)&off, 4);    

  // Режим передачи и подтверждение
  sendStart(ERR_WAIT);

  // Размер файла
  if(mode==100) {
    if(fs_getfilesize()) return;
  }

  // Размер диска  
  else if(mode==101) {
    if(fs_gettotal()) return;
  }
 
  // Свободное место на диске
  else if(mode==102) {
    if(fs_getfree()) return;
  }

  else {
    /* Устаналиваем смещение. fs_tmp сохраняется */
    if(fs_lseek(off, mode)) return;
  }

  // Передаем результат
  send(ERR_OK_CMD);
  sendBin((BYTE*)&fs_tmp, 4);  
  lastError = 0; // На всякий случай, результат уже передан
}

/*******************************************************************************
* Прочитать из файла                                                           *
*******************************************************************************/

void cmd_read() {
  DWORD s;

  // Длина
  recvBin((BYTE*)&readLength, 2);

  // Режим передачи и подтверждение
  sendStart(ERR_WAIT);

  // Ограничиваем длину длиной файла
  if(fs_getfilesize()) return;
  s = fs_tmp; 
  if(fs_tell()) return;
  s -= fs_tmp;
                    
  if(readLength > s)
    readLength = (WORD)s;

  // Отправляем все блоки файла
  readInt(/*rks*/0);
}

/*******************************************************************************
* Записать данные в файл                                                       *
*******************************************************************************/

void cmd_write() {
  // Аргументы
  recvBin((BYTE*)&fs_wtotal, 2); 

  // Ответ
  sendStart(ERR_WAIT);
           
  // Конец файла
  if(fs_wtotal==0) {
    fs_write_eof();
    lastError = ERR_OK_CMD;
    return;
  }
  
  // Запись данных
  do {
    if(fs_write_start()) return;

    // Принимаем от компьюетра блок данных
    send(ERR_OK_WRITE);
    sendBin((BYTE*)&fs_file_wlen, 2);
    recvStart();    
    recvBin(fs_file_wbuf, fs_file_wlen);
    sendStart(ERR_WAIT);

    if(fs_write_end()) return;
  } while(fs_wtotal);

  lastError = ERR_OK_CMD;
}

/*******************************************************************************
*                                                                              *
*******************************************************************************/

#define TAPE_DELAY         (1000000/1400/2)
#define TAPE               PORTC.1
#define TAPE_ON            DDRC.1
#define TAPE_PILOT_SIZE    32

void tape(BYTE data) {
  BYTE i = 8;
  do {
    if(data & 0x80) {
      TAPE = 1; delay_us(TAPE_DELAY); // TAPE = const - это одна команда ассемблера,
      TAPE = 0; delay_us(TAPE_DELAY); // поэтому оптимальнее расписать программу.
    } else {
      TAPE = 0; delay_us(TAPE_DELAY);
      TAPE = 1; delay_us(TAPE_DELAY);    
    }
    data <<= 1;
  } while(--i);
}

BYTE tapeEmulator() {
  WORD i, s;
  BYTE* p;

  strcpyf(buf, "boot/boot.rks");
  if(fs_open()) goto abort;
  if(fs_getfilesize()) goto abort;  
  if(fs_tmp < 7) goto abort;
  if(fs_tmp > 512) goto abort;
  s = (WORD)fs_tmp; 
  if(fs_read0(buf, s)) goto abort;
      
  TAPE_ON = 1;
  
  i = TAPE_PILOT_SIZE;
  do {
    tape(0);
  } while(--i);
        
  tape(0xE6);

  p = buf;
  do {
    tape(*p++);
  } while(--s);

  TAPE = 0;
  TAPE_ON = 0;
    
  return 0;                   
abort:
  return 1;
}

/*******************************************************************************
* Главная процедура                                                            *
*******************************************************************************/

#ifdef X86_DEBUG
void test() {
  BYTE c;  
#else
void main() {
  BYTE c;

  // Настройка портов ввода-вывода
  DDRD  = 0;
  PORTD = 0xFF;
  DDRB  = 0b00101101; // MISO
  PORTB = 0b00010001; // Подтягивающий резистор на MISO  
  DDRC  = 0b00000000; // TAPEEN, TAPE, PULSE
  PORTC = 0b00000101; // TAPEEN, TAPE, PULSE
  
  // Пауза, пока не стабилизируется питание
  delay_ms(100);
#endif  

  // Запуск файловой системы
  fs_init();

  // Если вход С2 посажен на землю, запускаем эмулятор магнитофона
  if(PINC.2==0) {
    if(tapeEmulator()) {
      // В случае ошибки мигаем светодиодом
      while(1) { PORTB.0 = !PORTB.0; delay_ms(100); }    
    }    
  } 
          
  //strcpyf(buf, "boot.rks");
  //if(fs_open()) {
    //while(1) { PORTB.0 = !PORTB.0; delay_ms(100); }    
  //}  
        
  while(1) {
#ifndef X86_DEBUG
    // Гасим светодиод
    PORTB.0 = 0;
#endif
    // Последний байт прошлой команды
    recvStart();
    // Принимаем начало команды
step2:    
    c = wrecv();
retry:
    if(c != 19) goto step2;
    c = wrecv();
    if(c != 180) goto retry;
    c = wrecv();
    if(c != 87) goto retry;
    c = wrecv();
    
#ifndef X86_DEBUG
    // Зажигаем светодиод
    PORTB.0 = 1;
#endif

    // Проверяем наличие карты
    sendStart(ERR_START);
    send(ERR_WAIT);
    if(fs_check()) {
      send(ERR_DISK_ERR);
      continue;
    }

    // Сбрасываем ошибку
    lastError = 0;
    
    /* Принимаем аргументы */
    if(c == 0) { 
      cmd_boot();
    } else { 
      send(ERR_OK_NEXT);
      recvStart();
           
      switch(c) {
        case 1:  cmd_ver();          break;
        case 2:  cmd_exec();         break; 
        case 3:  cmd_find();         break;
        case 4:  cmd_open();         break;     
        case 5:  cmd_lseek();        break;     
        case 6:  cmd_read();         break;     
        case 7:  cmd_write();        break; 
        case 8:  cmd_move();         break;
        default: lastError = ERR_INVALID_COMMAND;      
      }
    }
    
    // Вывод ошибки
    if(lastError) sendStart(lastError);
  }
}

/*
BYTE buf[512];
void main() {
 fs_init();     
 fs_check();    
 fs_readdir();  
 fs_delete();   
 fs_open0(0);   
 fs_move();     
 fs_lseek(0);   
 fs_read0(0,0); 
 fs_read(0,0,0);
 fs_write_eof();
 fs_write_start(); 
 fs_write_end();
}
*/
