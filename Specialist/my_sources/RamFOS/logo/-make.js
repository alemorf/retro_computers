//----------------------------------------------------------------------------
// RAMFOS
// Конвертер логотипа Специалист MX2
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
  //src = loadAll(src); 
  s = "";
  pos = 0;
  for(i=0; i<src.length; i++) {
    if((i%x)!=0) s += ","; else { if(i!=0) s += " ; "+(pos++)+"\r\n"; s += "	.db "; }
    v = decode[src.charCodeAt(i)];
    s += '0' + abc[v>>4] + abc[v&0xF] + 'h';
  }
  fso.CreateTextFile(dest, true).Write(s);
}

// Преобразование изображения

dest = "";

src = loadAll("logo.bmp"); 
for(x=0; x<368; x+=8) {
  for(y=0; y<39; y++) {
    v = 0;
    for(z=0; z<8; z++) {
      v <<= 1;
      if(src.charCodeAt(54+(z+x)*3+(38-y)*368*3) != 0)
        v |= 1;     
    }
    dest += encode[v];
  }
}

bin2inc(dest, "../logo.inc", 16);