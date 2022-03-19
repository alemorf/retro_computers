// SD Controller for Computer "Radio 86RK" / "Apogee BK01"
// (c) 10-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "common.h"

#define DATA_OUT    DDRD = 0b11111111;
#define DATA_IN     DDRD = 0b00000000;

void wait();
void sendStart(BYTE c); 
void send(BYTE c);
void recvStart();
BYTE wrecv();
