#define COLOR_WHITE  0x00
#define COLOR_YELLOW 0x10
#define COLOR_VIOLET 0x40
#define COLOR_RED    0x50
#define COLOR_CYAN   0x80
#define COLOR_GREEN  0x90
#define COLOR_BLUE   0xC0
#define COLOR_BLACK  0xD0

#define SET_COLOR(C) { *(uchar*)(0xFFFE)=(C); }

void setColor(char) @ "spec/setcolor.c";
void setColorAutoDisable() @ "spec/setcolorautodisable.c";