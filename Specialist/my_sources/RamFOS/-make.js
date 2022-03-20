//----------------------------------------------------------------------------
// RAMFOS
// Создание прошивки ПЗУ
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

// Константы

unmlzOffset	= 0x0063;
ramfosOffset	= 0x0430;
romdiskOffset	= 0x1880;
romdiskSize	= 0x10000-romdiskOffset-4; // 4 это page0start
loader1Offset	= 0x8000;

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
shell = new ActiveXObject("WScript.Shell");
function kill(name) { if(fso.FileExists(name)) fso.DeleteFile(name); }
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function exec(cmd) { if(shell.Run(cmd, 2, true)) throw cmd; }
src = loadAll("tbl.bin"); decode = []; encode = []; for(i=0; i<256; i++) { decode[src.charCodeAt(i)] = i; encode[i] = src.charAt(i); }

// Преобразование BIN->INC

function bin2inc(src, dest, x) {
  abc = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' ];
  src = loadAll(src); 
  s = "";
  pos = 0;
  for(i=0; i<src.length; i++) {
    if((i%x)!=0) s += ","; else { if(i!=0) s += " ; "+(pos++)+"\r\n"; s += "	.db "; }
    v = decode[src.charCodeAt(i)];
    s += '0' + abc[v>>4] + abc[v&0xF] + 'h';
  }
  fso.CreateTextFile(dest, true).Write(s);
}

// Удаляем файлы, что бы в случае ошибки их не было

function killTmpFiles() {
  kill("loader1.lst");
  kill("loader1.bin");
  kill("loader1.mlz");
  kill("loader1.inc");
  kill("loader0.lst");
  kill("loader0.bin");
  kill("ramfos.bin");
  kill("ramfos.mlz");
}
killTmpFiles();
kill("SpecialistMX2.bin");

// Загрузчик на нулевой странице

page0start = encode[0x31] + encode[0xFF] + encode[0xF7] + encode[0xC7]; // lxi sp, 0F7FFh / rst 0

// Компиляция загрузчика

exec("tasm -gb -b -85 loader1.asm loader1.bin");
exec("megalz loader1.bin loader1.mlz");
bin2inc("loader1.mlz", "loader1.inc", 16);
exec("tasm -gb -b -85 loader0.asm loader0.bin");

// Вырезаем пустое место из образа RAMFOS

src = loadAll("ramfos/ramfos.bin");
offset = 0xC000;
end1   = 0xD2A0 - offset;
start2 = 0xF800 - offset;
end2   = 0xFFE0 - offset;
fso.CreateTextFile("ramfos.bin", true).Write(src.substr(0, end1) + src.substr(start2, end2 - start2));

// Сжимаем его

exec("megalz ramfos.bin ramfos.mlz");

// Нулевой байт

byte0 = encode[0];

// Собираем образ

// Первая страница
romdisk = loadAll("romdisk.bin");
dest = page0start;
dest += romdisk.substr(32768-romdiskOffset, 32768-page0start.length);
while(dest.length < 0x8000) dest += byte0;

// Вторая страница
dest += loadAll("loader0.bin");
if(dest.length > 0x8000+ramfosOffset) throw "ramfosOffset";
while(dest.length < 0x8000+ramfosOffset) dest += byte0;
dest += loadAll("ramfos.mlz");
if(dest.length > 0x8000+romdiskOffset) throw "romdiskOffset";
while(dest.length < 0x8000+romdiskOffset) dest += byte0;
dest += romdisk.substr(0, 32768-romdiskOffset);
while(dest.length < 0x10000) dest += byte0;

// Сохраняем
fso.CreateTextFile("SpecialistMX2.bin", true).Write(dest);

// Копируем в эмулятор
fso.GetFile("SpecialistMX2.bin").Copy("C:/emu/Specialist/specsvga.bin", true); 

// Удалем временные файлы
killTmpFiles();