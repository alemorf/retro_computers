// (c) 2012 vinxru

fso = new ActiveXObject("Scripting.FileSystemObject");
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }


data = loadAll("share_and_enjoy.mod"); useCh = [0,2,3];

notes = [0, 10];
notesIdx = [];
notesIdx[0] = 0;
notesIdx[10] = 1;

channel = [ -1,-1,-1 ];

buf = [];

function find(a, v) {
  for(i=0; i<a.length; i++)
    if(a[i]==v)
      return i;
  return -1;
}   

for(i=0; i<128; i++) {
  ii = decode[data.charCodeAt(0x3B8+i)];
  ii1 = decode[data.charCodeAt(0x3B8+i+1)];
  ii2 = decode[data.charCodeAt(0x3B8+i+2)];
  if(ii==0 && ii1==0 && ii2==0) break;
  p = 0x43C + ii*1024;
  for(n=0; n<64; n++) {
    for(c=0; c<3; c++) {
      if(useCh[c]==-1) {
        hz = 0;
      } else {
        p1 = p + useCh[c]*4;
        inst = (decode[data.charCodeAt(p1+2)] >> 4) & 0xF;
        hz = decode[data.charCodeAt(p1+1)] + (decode[data.charCodeAt(p1)] & 0xF) * 256;
        hz <<= 4;
      }
      // pause
      if(hz==0) {          
        if(channel[c] != -1 && buf[channel[c]] < 0xE0) {
          buf[channel[c]] += 0x20;
        } else {
          channel[c] = buf.length;
          buf[buf.length] = 0;
        }
      } else {
        // note
        ni = notesIdx[hz];
        if(!ni) { ni=notes.length; notes[ni] = hz; notesIdx[hz] = ni; }
        channel[c] = buf.length;
        buf[buf.length] = ni;
      }
    }
    // Пропускаем 4-ый канал
    p+=16;
  }
}

buf[buf.length] = 0xFF;

notes1 = "  ";
for(i=0; i<notes.length; i++) {
  if(i%16) notes1 += ","; else notes1 += "\r\n .dw ";
  notes1 += notes[i];
}

save("music_notes.inc", notes1);

music1 = "  ";
for(i=0; i<buf.length; i++) {
  if(i%16) music1 += ","; else music1 += "\r\n .db ";
  music1 += buf[i];
}

save("music_data.inc", music1);