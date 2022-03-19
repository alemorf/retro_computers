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
src = loadAll("../tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }

// Работа

kill("list.tmp");
shell.Run("cmd /c dir /b /on *.bru >list.tmp", 2, true);
shell.Run("cmd /c dir /b /on *.or? >>list.tmp", 2, true);
shell.Run("cmd /c dir /b /on *.com >>list.tmp", 2, true);
shell.Run("cmd /c dir /b /on *.rko >>list.tmp", 2, true);
list = fso.OpenTextFile("list.tmp", 1, false, 0);
image = loadAll("../BOOT");
fa = [];
while(!list.AtEndOfStream)
  fa.push(list.readLine().toUpperCase());
fa.push("../VC$.BRU");
fa.sort();
for(var i in fa) {
  fileName = fa[i];

  f = loadAll(fileName);  

  if(fso.GetExtensionName(fileName) == "RKO") {
      i = f.indexOf(encode[0xE6]);
      if(i != -1) f = f.substr(i+5, decode[f.charCodeAt(i+3)] * 256 + decode[f.charCodeAt(i+4)]);
  } else
  if(fso.GetExtensionName(fileName) == "ORI") {
      f = f.substr(16);
  } else
  if(fso.GetExtensionName(fileName) == "COM") {
      f = "????????" + encode[0] + encode[1] + encode[0] + encode[0] + encode[0] + encode[0] + encode[0] + encode[0] + f;
      fileName = fso.GetBaseName(fso.GetBaseName(fileName)) + "$";
  }
  
  image += (fso.GetBaseName(fso.GetBaseName(fileName))+"        ").substr(0,8) 
           + f.substr(8, 2) + encode[(f.length-16)&0xFF] + encode[(f.length-16)>>8] + f.substr(12);      
}
list.Close();
kill("list.tmp");

while(image.length < 65536) image += encode[0xFF];

save("romdisk.bin", image);

// И сразу в эмулятор
save("d:\\bin\\emu\\Orion\\romdisk.bin", image);
