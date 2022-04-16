#include "logo.h"
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, const char** argv)
{
    int buf2len = 100000;
    char* buf = new char[buf2len];
    char* buf2 = new char[buf2len];
    char* b2 = buf2;
    char* b = buf;
    int n = 0;
    char msk = 0;
    for(unsigned pn=0; pn<1; pn++)
    {
        for(int x=width-8; x>=0; x-=8)
        {
            for(int iy=0; iy<1; iy++)
            for(int y=height-1; y>=0; y--)
            {
                unsigned d = 0;
                for(unsigned ix=0; ix<8; ix++)
                {
                    uint32_t p = 0;
                    HEADER_PIXEL((header_data+(x+ix)*4+(y+iy)*width*4), ((uint8_t*)&p));
                    uint8_t c = 0;
                    switch(p)
                    {
                        case 0x000000: c=0; break;
                        case 0x0000AA: c=1; break;
                        case 0xFFFF55: c=2; break;
                        case 0xFFFFFF: c=3; break;
                        default: printf("bad color %u %u %06X\n", x, y, p);
                    }
                    d = (d << 1) | ((c >> pn) & 1);
                }
//                if(n--==0) { n = 64; b += sprintf(b, "\n  .db "); } else b += sprintf(b, ",");
//                b += sprintf(b, "%u", d);
                *b++ = d;
            }
        }
    }

       int s = creat("test2.bin", 0666);
       write(s, buf, b - buf);
       close(s);

       system("wine megalz.exe test2.bin");

       s = open("test2.bin.mlz", O_RDONLY);
       int l = read(s, buf, buf2len);
       close(s);

    for(int i=0; i<l; i++)
    {
        if(n--==0) { n = 64; b2 += sprintf(b2, "\n  .db "); } else b2 += sprintf(b2, ",");
        b2 += sprintf(b2, "%u", (unsigned char)buf[i]);
    }

    l = b2 - buf2;
    printf("len2 %u\n", l);
    s = creat("logo.inc", 0666);
    write(s, buf2, l);
    close(s);

    return 0;
}
