// SD Controller for Computer "Radio 86RK" / "Apogee BK01"
// (c) 10-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "proto.h"

void wait() {
    // ∆дем перепад 0->1
    while(!PINC.5);
    while(PINC.5); 
//    while((PINC&0x3F)==0); 
//    while((PINC&0x3F)==0x20);
    if((PINC&0x3F)==0) return;
#asm 
    RJMP 0
#endasm
}

void sendStart(BYTE c) {
    wait();
    DATA_OUT
    PORTD = c;
}

void recvStart() {
    wait();
    DATA_IN
    PORTD = 0xFF;
} 

BYTE wrecv() {    
    wait();   
    return PIND;
}

void send(BYTE c) {
    wait();   
    PORTD = c;
}
