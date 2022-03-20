//----------------------------------------------------------------------------
// RAMFOS
//
// 2013-11-01 Разработано vinxru
//----------------------------------------------------------------------------

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
  for(i=0;;i++) {
    if((i%x)==0) { if(i!=0) s += " ; "+(pos++)+"\r\n"; }
    if(i>=src.length) break;
    if((i%x)!=0) s += ","; else s += "	.db ";
    v = decode[src.charCodeAt(i)];
    s += '0' + abc[v>>4] + abc[v&0xF] + 'h';
  }
  fso.CreateTextFile(dest, true).Write(s);
}


//exec("megalz font.bin font.mlz");
bin2inc("font.bin", "font.inc", 8);