fso = new ActiveXObject("Scripting.FileSystemObject");
function fileSize(name) { return fso.GetFile(name).Size; }
function loadAll(name) { return fso.OpenTextFile(name, 1, false, 0).Read(fileSize(name)); } // File.LoadAll глючит 
function save(fileName, data) { fso.CreateTextFile(fileName).Write(data); }
src = loadAll("tbl.bin"); encode = []; decode = []; for(i=0; i<256; i++) { encode[i] = src.charAt(i); decode[src.charCodeAt(i)] = i; }


film = loadAll("film.src");

film = film.toUpperCase().split('~').join("-").split('`').join("'").split('\x09').join("        ");

var LINES_PER_FRAME = 14;

a = film.split("\n");

display = "";
zip = "";           
prevDisplay = "";

function TrimStr(s) {
  if(!s) return "";
  if(!s.length) return "";
  var l = s.length;
  while(s.charAt(l-1) == " ") l--;
  return s.substr(0, l);
}

corp="";

filmN=0;
swap=0;
speed = 0;
for(i=0; i<a.length; i+=LINES_PER_FRAME) {
  display = "";
  speed += a[i]*1;
  for(j=1; j<LINES_PER_FRAME; j++) {
    display += (TrimStr(a[i+j])+"                                                                                     ").substr(0,64);// + "\x7F";
  }  

  packed = "";
  for(k=0; k<display.length; k++) {
    x = 126;
    for(;x<255 && k<display.length && display.charCodeAt(k)==prevDisplay.charCodeAt(k); k++)
      x++;
    if(x>=128) packed += encode[x]; else
    if(x==127) k--;
    if(k>=display.length) break;
    c = display.charAt(k);
    if(c==' ') {
      x = 0;
      for(;x<25 && k<display.length && display.charAt(k)==c; k++)
        x++;
      if(x) packed += encode[97+x];
      k--;
    } else {
      packed += c;    
      k++;
      x = 0;
      for(;x<31 && k<display.length && display.charAt(k)==c; k++)
      x++;
      if(x) packed += encode[x];
      k--;
    }
  }

  c=0;
  for(j=0; j<packed.length; j++)
    if(packed.charAt(j) >= 'A' && packed.charAt(j) <= 'Z')
      c++

  packed = packed.split('|').join('I');
  packed = packed.split('{').join('<');
  packed = packed.split('}').join('>');

  swap++;
  if(c<30 && swap<3) continue;
  swap=0;

  if(speed>=256) throw "speed";

  for(j=0; j<display.length; j+=64)
    corp += display.substr(j,64) + "\r\n";
  corp += "--------------------------------------------------------------------\r\n";

  zip += packed + encode[speed];  
  if(zip.length > 9900) {
    save("film_" + filmN + ".txt", zip +encode[0x7F]);
    filmN++;
    zip = "";
    display = "";
  }
             
  speed = 0;
  prevDisplay = display;
}

save("film_" + filmN + ".txt", zip +encode[0x7F]);

save("corp.txt", corp);