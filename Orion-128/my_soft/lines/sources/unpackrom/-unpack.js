//----------------------------------------------------------------------------
// Распаковка существующего rom-диска для Ориона 128
//
// 2014-1-19 Разработано vinxru
//----------------------------------------------------------------------------

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
shell = new ActiveXObject("WScript.Shell");
function kill(name) { if(fso.FileExists(name)) fso.DeleteFile(name); }
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { var f=fso.OpenTextFile(name, 1, false, 0); var t = f.Read(fileSize(name)); f.Close(); return t; } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }
function trim(s) { var i=s.length; while(i>0 && s.charAt(i-1)==' ') i--; return s.substr(0, i); } // replace(' ', '') не работает иногда

// Удаление прошлых файлов

shell.Run("cmd /c dir /b /on *.bru >list.tmp", 2, true);
list = fso.OpenTextFile("list.tmp", 1, false, 0)
while(!list.AtEndOfStream)
  kill(list.readLine());
list.Close();
kill("BOOT");
kill("list.tmp");

// Распаковка

src = loadAll("romdisk.bin");
pos = 0x800;                                                                                              
save("BOOT", src.substr(0, pos));
while(pos < src.length) {
  if(decode[src.charCodeAt(pos)]==0xFF) continue;
  name = trim(src.substr(pos, 8));
  start = decode[src.charCodeAt(pos+8)] + decode[src.charCodeAt(pos+9)]*256;
  len = decode[src.charCodeAt(pos+10)] + decode[src.charCodeAt(pos+11)]*256;  
  data = src.substr(pos, len+16); 
  save(name+".BRU", data);
  pos += len + 16;
}