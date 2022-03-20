//----------------------------------------------------------------------------
// RAMFOS
// Распаковка существующего rom-диска
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

romdiskStart = 0xC000;
unpackStdApps = 1;

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
shell = new ActiveXObject("WScript.Shell");
function kill(name) { if(fso.FileExists(name)) fso.DeleteFile(name); }
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }

// Удаление прошлых файлов

ignore = [];
ignore["romdisk.bin"] = 1;
ignore["tbl.bin"] = 1;
ignore["-unpack.js"] = 1;

shell.Run("cmd /c dir /b /on *.* >list.tmp", 2, true);
list = fso.OpenTextFile("list.tmp", 1, false, 0);
files = [];
while(!list.AtEndOfStream)
  files.push(list.readLine());
list.Close();

for(i=0; i<files.length; i++)
  if(!ignore[files[i].toLowerCase()])
    kill(files[i]);

// Распаковка

src = loadAll("romdisk.bin");

if(unpackStdApps) {
  save("Asm.59392.EXE",     src.substr(0x8000+0x3800, 0x800 ));
  save("DisAsm.59392.EXE",  src.substr(0x8000+0x2000, 0x800 ));
  save("Debuger.59392.EXE", src.substr(0x8000+0x2800, 0x1000));
  save("Editor.59392.EXE",  src.substr(0x8000+0x1800, 0x800 ));
}

// unpackStdApps

src = src.substr(romdiskStart);
p = 0;
fileHeader = encode[0xD3]+encode[0xD3]+encode[0xD3];
while(p+33 < src.length) {
  if(src.substr(p,3)!=fileHeader) break;
  name = src.substr(p+3, 8).replace(' ', '');
  ext = src.substr(p+12, 3).replace(' ', '');
  start = decode[src.charCodeAt(p+24)] + decode[src.charCodeAt(p+25)]*256;
  end = decode[src.charCodeAt(p+26)] + decode[src.charCodeAt(p+27)]*256;  
  len = end - start + 1;  
  save(name+"."+start+"."+ext, src.substr(p+30, len));
  p += len + 32;
}