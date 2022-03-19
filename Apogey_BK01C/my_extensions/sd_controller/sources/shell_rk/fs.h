// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

extern const char* fs_cmdLine;
extern const char* fs_selfName;

typedef struct {
  char   fname[11];	/* File name */
  uchar  fattrib;	/* Attribute */
  union {
    ulong fsize;	/* File size */
    struct {
      ushort fsize_l, fsize_h;	/* File size */
    };
  };
  ushort ftime;		/* Last modified time */
  ushort fdate;		/* Last modified date */
} FileInfo;

extern uint fs_low, fs_high;

#define fs_result (*(ulong*)&fs_low)

#define ERR_OK              0   // Нет ошибки
#define ERR_NO_FILESYSTEM   1   // Файловая система не обнаружена
#define ERR_DISK_ERR        2   // Ошибка чтения/записи
#define	ERR_NOT_OPENED      3   // Файл/папка не открыта
#define	ERR_NO_PATH         4   // Файл/папка не найдена
#define ERR_DIR_FULL        5   // Папка содержит максимальное кол-во файлов
#define ERR_NO_FREE_SPACE   6   // Нет свободного места
#define ERR_DIR_NOT_EMPTY   7   // Нельзя удалить папку, она не пуста
#define ERR_FILE_EXISTS     8   // Файл/папка с таким именем уже существует
#define ERR_NO_DATA         9   // fs_file_wtotal=0 при вызове функции fs_write_begin
#define ERR_MAX_FILES       10  // fs_findfirst вернула не все файлы
#define ERR_RECV_STRING     11  // Слишком длинный путь

// Остальные коды ошибок - ошибка протокола передачи

void  fs_init();
void  fs_reboot();
uchar fs_exec(const char* name, const char* cmdLine);
uchar fs_open(const char* name);
uchar fs_create(const char* name);
uchar fs_mkdir(const char* name);
uchar fs_findfirst(const char* path, FileInfo* dest, uint size);
uchar fs_findnext(FileInfo* dest, uint size);
uchar fs_delete(const char* name);
uchar fs_seek(uint low, uint high, uchar mode);
uchar fs_read(void* buf, uint size);
uchar fs_write(const void* buf, uint size);
uchar fs_getsize();
uchar fs_move(const char* f, const char* t);
uchar fs_swap();
uchar fs_getfree();
uchar fs_gettotal();