// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "fs.h"
#include "n.h"

const char* fs_cmdLine = "";
const char* fs_selfName = "SHELL.RK";
uint        fs_low;
uint        fs_high;

void fs_init() {
}


uchar fs_findfirst(const char* path, FileInfo* dest, uint size) {
  uchar i;
  uchar xx;
  fs_low = 0;

  xx=0; 
  for(;path[i]!=0; i++)
    if(path[i]=='/')
     xx++;

  if(xx<4)
  for(i=4; i; --i) {
    memcpy(dest[0].fname, "FOLDER     ", 11);
    i2s(dest[0].fname+6, i, 2, '0');
    memcpy(dest[0].fname+8, "   ", 3);
    dest[0].fattrib = 0x10;
    dest[0].fsize_l = i;
    dest[0].fdate = i;
    dest[0].ftime = i;
    dest++;
    fs_low++;
  }

  for(i=rand()&16; i; --i) {
    memcpy(dest[0].fname, "FILE    TXT", 11);
    i2s(dest[0].fname+4, i, 2, '0');
    i2s(dest[0].fname+6, xx, 2, '0');
    memcpy(dest[0].fname+8, "TXT", 3);
    xx++;
    dest[0].fattrib = 0;
    dest[0].fsize_l = i;
    dest[0].fdate = i;
    dest[0].ftime = i;
    dest++;
    fs_low++;
  }
  return 0;
}

ulong readEmuSize;
ulong readEmuSize2;

uchar fs_swap() {
  ulong tmp;
  set32(&tmp, &readEmuSize);
  set32(&readEmuSize, &readEmuSize2);
  set32(&readEmuSize2, &tmp);
  return 0;
}

uchar fs_write(const void* buf, uint size) {
  uint j, k;
//  for(k=100; k; --k)
    for(j=100; j; --j);
  return 0;
}

uchar fs_seek(uint low, uint high, uchar mode) {
  return 1;
}

void fs_reboot() {
  fs_exec("","");
  asm {
    jmp 0F800h
  }
}

uchar fs_read(void* buf, uint size) {
  if(((ushort*)&readEmuSize)[1] == 0 && ((ushort*)&readEmuSize)[0] < size) {
    fs_low = ((ushort*)&readEmuSize)[0];
  } else {
    fs_low = size;
  }
  sub32_16(&readEmuSize, fs_low);
  return 0;
}

uchar fs_open(const char* name) {
  SET32IMM(&readEmuSize, 240000);
  return 0;
}

uchar fs_create(const char* name) {
  SET32IMM(&readEmuSize, 240000);
  return 0;
}

uchar fs_move(const char* from, const char* to) {
  uint i;
  for(i=20000; i; --i);
  return 0;
}

uchar fs_mkdir(const char* name) {
  uint i;
  printm(0,0,64,name);
  for(i=5000; i; --i);
  return 0;
}

uchar fs_gettotal() { // fs_high:fs_low - размер в ћб
  fs_high = 200;
  fs_low = 20;
  return 0; 
}

uchar fs_getsize() { // fs_high:fs_low - размер
  set32(&fs_result, &readEmuSize);
  return 0; 
}

uchar fs_getfree() { // fs_high:fs_low - размер в ћб
  fs_high = 100;
  fs_low = 20;
  return 0; 
}

uchar fs_findnext(FileInfo* dest, uint size) {  
  return fs_findfirst(":", dest, size);
}

uchar fs_exec(const char* fileName, const char* cmdLine) {
  return 1;
}

uchar fs_delete(const char* name) {
  uint i;
  printm(0,0,64,name);
  if(0==strcmp(name, "FOLDER01")) return ERR_DIR_NOT_EMPTY;
  if(0==strcmp(name, "FOLDER01/FOLDER04")) return ERR_DIR_NOT_EMPTY;
  for(i=5000; i; --i);
  return 0;
}
