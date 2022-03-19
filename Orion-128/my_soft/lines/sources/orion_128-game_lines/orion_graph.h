extern uchar color;

#define PRINTARGS(XX,YY) ((uchar*)(0xC000+1)+((YY)*10)+(((XX)*3/4)*256) ), (XX)&3
#define PIXELCOORDS(XX,YY) ((uchar*)(0xC000+1)+(YY)+((XX)*256) )

void graph0(); 
void graph1(); 
void graphXor(); 
void print(uchar x, uchar y, uchar n, char* text);
void print1(uchar* addr, uchar step, uchar n, char* text);
void bitBlt_bw(uchar* d, uchar* s, uint wh);
void bitBlt(uchar* d, uchar* s, uint wh);
void colorRect(uchar* d, uint wh);
void colorizer_rand();
void himem();

