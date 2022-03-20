//----------------------------------------------------------------------------
// RAMFOS
// Создание образа диска из отдельных файлов
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

// Стандартная ерунда

fso = new ActiveXObject("Scripting.FileSystemObject");
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }

// Расчет контрольной суммы файла

function specialistSum(data) {
  var s = 0;
  for(var i=0; i<data.length-1; i++)
    s += decode[data.charCodeAt(i)] * 257;
  s = (s & 0xFF00) + ((s + decode[data.charCodeAt(i)]) & 0xFF);
  return (s & 0xFFFF);
}


start = 0;
data = loadAll("lines.bin");
crc = specialistSum(data);
end = start+data.length-1;
save("lines.rks", encode[start&0xFF]+encode[start>>8]+encode[end&0xFF]+encode[end>>8]+data+encode[crc&0xFF]+encode[crc>>8]);