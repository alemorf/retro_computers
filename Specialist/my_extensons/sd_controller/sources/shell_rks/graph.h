extern uint graphOffset;

void fillRect1(uchar* a, ushort c, uchar l, uchar r, uchar h);
void print1(uchar* addr, uchar step, uchar n, char* text);
void rect1(uchar* a, ushort c, uchar ll, uchar rr, uchar l, uchar r, uchar h);

#define RECTARGS(X0,Y,X1,Y1) \
  (uchar*)((((X0)/8)*256) + (Y) + 0x9000), \
  ((X1)+1)/8-(X0/8), \
  (0x80 >> ((uchar)(X0) & 7)), \
  (0x80 >> ((uchar)((X1)+1) & 7)), \
  (0xFF >> ((uchar)(X0) & 7)), \
  (0xFF >> ((uchar)((X1)+1) & 7)) ^ 0xFF, \
  (Y1)-(Y)+1

#define FILLRECTARGS(X0,Y,X1,Y1) (uchar*)((((X0)/8)*256) + (Y) + 0x9000), ((X1)+1)/8-(X0/8), (0xFF >> ((uchar)(X0) & 7)), (0xFF >> ((uchar)((X1)+1) & 7)) ^ 0xFF, (Y1)-(Y)+1

#define VERTLINEARGS(X,Y) (uchar*)((((X) / 8) * 256) + (Y) + 0x9000), 0x80 >> (uchar)((X) & 7)
#define HORZALINEARGS(X0,Y,X1) (uchar*)((((X0)/8)*256) + (Y) + 0x9000), ((X1)+1)/8-(X0/8), (0xFF >> ((uchar)(X0) & 7)), (0xFF >> ((uchar)((X1)+1) & 7)) ^ 0xFF 
#define PRINTARGS(XX,YY) ((uchar*)(0x9000+1)+((YY)*10)+(((XX)*3/4)*256) ), (XX)&3
#define TEXTCOORDS(XX,YY) ((uchar*)(0x9000+1)+((YY)*10)+(((XX)*3/4)*256) )
#define PIXELCOORDS(XX,YY) ((uchar*)(0x9000+1)+((YY)*10)+((XX)*256) )

void graph0(); 
void graph1(); 
void graphXor(); 
void clrscr10(void* t, uchar w, uchar h);
void fillRect(ushort x, uchar y, ushort x1, uchar y1);
void print(uchar x, uchar y, uchar n, char* text);

void rect(ushort x, uchar y, ushort x1, uchar y1);
void scroll(char* d, char* s, uchar w, uchar h);