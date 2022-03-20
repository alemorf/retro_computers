//----------------------------------------------------------------------------
// RAMFOS
// Распаковка существующего rom-диска
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

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
ignore["-pack.js"] = 1;

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

// unpackStdApps

function trim(s) { var i=s.length; while(i>0 && s.charAt(i-1)==' ') i--; return s.substr(0, i); } // replace(' ', '') не работает иногда
                                                                                              
p = 0;
check = [];
for(i=0; i<48; i++) {
  a = 256 + i * 16;
  if(decode[src.charCodeAt(a)]==0xFF) continue;

  name = trim(src.substr(a, 6));
  ext = trim(src.substr(a+6, 3));
  start = decode[src.charCodeAt(a+10)] + decode[src.charCodeAt(a+11)]*256;
  len = decode[src.charCodeAt(a+12)] + decode[src.charCodeAt(a+13)]*256 + 1;  
  clust = decode[src.charCodeAt(a+15)];  
  clust[0] = 1;
  clust[1] = 1;
  clust[2] = 1;
  data = "";
  l = len;
  for(;;) {
    if(check[clust] == 1) { save("error.txt", "Кластер "+clust+" уже используется"); throw "!"; }
    check[clust] = 1;
    data += src.substr(clust*256, 256); 
    if(l<=256) break;
    l -= 256;
    clust = decode[src.charCodeAt(clust)];
  }
  if(data.length != ((len+255)&~255) ) { save("error.txt", "Некорректная длина файла "+name+"."+ext); throw "!"; }
  save(name+"."+start+"."+ext, data.substr(0, len));
  p += len + 32;
}