//----------------------------------------------------------------------------
// Создание BRU файла (программа Орион 128)
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

// Удаляем временные файлы

fileName = "lines$.bin";
startAddr = 0;

f = loadAll(fileName);  
f = (fso.GetBaseName(fso.GetBaseName(fileName))+"        ").substr(0,8) 
    + encode[startAddr&0xFF] + encode[startAddr>>8] + encode[f.length&0xFF] + encode[f.length>>8] + encode[0]  + encode[0]  + encode[0]  + encode[0] + f;
save(fso.GetBaseName(fileName)+".bru", f);
