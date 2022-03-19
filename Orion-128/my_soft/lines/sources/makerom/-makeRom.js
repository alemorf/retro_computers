//----------------------------------------------------------------------------
// Создание образа диска для Ориона 128
//
// 2014-1-19 Разработано vinxru
//----------------------------------------------------------------------------

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
shell = new ActiveXObject("WScript.Shell");
function kill(name) { if(fso.FileExists(name)) fso.DeleteFile(name); }
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }

// Работа

kill("list.tmp");
shell.Run("cmd /c dir /b /on *.bru >list.tmp", 2, true);
list = fso.OpenTextFile("list.tmp", 1, false, 0);
image = loadAll("BOOT");
while(!list.AtEndOfStream) {
  fileName = list.readLine().toUpperCase();
  f = loadAll(fileName);  
  image += (fso.GetBaseName(fso.GetBaseName(fileName))+"        ").substr(0,8) 
           + f.substr(8, 2) + encode[(f.length-16)&0xFF] + encode[(f.length-16)>>8] + f.substr(12);      
}
list.Close();
kill("list.tmp");

while(image.length < 65536) image += encode[0];

save("romdisk.bin", image);

// И сразу в эмулятор
// save("C:\\emu\\Orion\\romdisk.bin", image);
