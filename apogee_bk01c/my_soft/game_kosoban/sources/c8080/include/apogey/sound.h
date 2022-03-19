#define SET_SOUND(CH, FREQ) { ((uchar*)0xEC00)[CH] = (uchar)(FREQ); ((uchar*)0xEC00)[CH] = (FREQ)>>8; }

#define MUTE_SOUND(CH) { *(uchar*)0xEC03 = ((CH)==0 ? 0x3E : ((CH)==1 ? 0x7E : 0xBE)); }
