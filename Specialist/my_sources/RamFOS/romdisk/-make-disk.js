//----------------------------------------------------------------------------
// RAMFOS
// Создание образа диска из отдельных файлов
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

// Константы

unmlzOffset	= 0x0063;
ramfosOffset	= 0x0430;
romdiskOffset	= 0x1880;
romdiskSize	= 0x10000-4-romdiskOffset;
loader1Offset	= 0x8000;

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
shell = new ActiveXObject("WScript.Shell");
function kill(name) { if(fso.FileExists(name)) fso.DeleteFile(name); }
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }

// Расчет контрольной суммы файла

function specialistSum(data) {
  s = 0;
  for(i=0; i<data.length-1; i++)
    s += decode[data.charCodeAt(i)] * 257;
  s = (s & 0xFF00) + ((s + decode[data.charCodeAt(i)]) & 0xFF);
  return (s & 0xFFFF);
}

// Удаляем временные файлы

kill("list.tmp");

// Создание списка файлов

shell.Run("cmd /c dir /b /on *.* >list.tmp", 2, true);

// Файлы, которые не надо добавлять на диск

ignore = [];
ignore["list.tmp"] = 1;
ignore["tbl.bin"] = 1;
ignore["-make-disk.js"] = 1;

// Обрабатываем каждый файл

dest = "";

list = fso.OpenTextFile("list.tmp", 1, false, 0);
while(!list.AtEndOfStream) {
  fileName = list.readLine();

  // Этот файл не нужен

  if(ignore[fileName.toLowerCase()]) continue;

  // Загружаем файл

  data = loadAll(fileName);
  fileStartAddr = romdiskOffset + dest.length;
  startAddr = 0;

  // Получаем адрес загрузки

  ext = fso.GetExtensionName(fileName).toUpperCase();
  if(ext == "RKS") {
    // Получаем адрес загрузки из заголовка файла
    startAddr = decode[data.charCodeAt(0)] + decode[data.charCodeAt(1)] * 256;
    endAddr   = decode[data.charCodeAt(2)] + decode[data.charCodeAt(3)] * 256;
    len = endAddr - startAddr + 1;
    data = data.substr(4, len);    
  } else {
    // Получаем адрес загрузки из имени файла
    fileName = fso.GetBaseName(fileName);
    startAddr = fso.GetExtensionName(fileName) * 1;
  }

  // Заголовок файла Ramfos

  dest += encode[0xD3]+encode[0xD3]+encode[0xD3];
  dest += (fso.GetBaseName(fileName)+"        ").substr(0,8);
  dest += " ";
  dest += (ext+"   ").substr(0,3);  
  dest += encode[0x8C];
  dest += encode[0x01]+encode[0x11]+encode[0x13];
  dest += encode[0x00]+encode[0x00]+encode[0x00]+encode[0x00]+encode[0x00];
  dest += encode[startAddr & 0xFF]+encode[startAddr >> 8];
  endAddr = startAddr + data.length - 1;
  dest += encode[endAddr & 0xFF]+encode[endAddr >> 8];
  crc = specialistSum(data);  
  dest += encode[crc & 0xFF]+encode[crc >> 8];

  // Файл

  dest += data;

  // В конце файла указатель на начало

  dest += encode[fileStartAddr & 0xFF]+encode[fileStartAddr >> 8];
}

// В конце диска байт терминатор

dest += encode[8];

// Контроль размера

if(dest.length > romdiskSize) throw "Слишком много файлов";
while(dest.length < romdiskSize) dest += encode[0];

// Сохраняем

fso.CreateTextFile("../romdisk.bin", true).Write(dest);