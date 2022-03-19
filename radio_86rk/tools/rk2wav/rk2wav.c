#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>

#define INBUFF_SIZE 65544
#define OUTBUFF_SIZE 32768

#define P_NRM 0
#define P_EDM 1

#define I_NULL  0
#define I_ONE   1
#define I_END   2

#define F_SQR 0
#define F_SIN 1

 static const int16_t t_ss[]=
 {
  96,288,481,673,865,1057,1249,1441,
  1632,1824,2015,2206,2397,2587,2777,2967,
  3157,3346,3535,3723,3911,4099,4286,4472,
  4659,4844,5029,5214,5398,5581,5764,5946,
  6128,6308,6489,6668,6847,7025,7202,7378,
  7554,7729,7902,8076,8248,8419,8590,8759,
  8928,9096,9262,9428,9593,9756,9919,10081,
  10242,10401,10560,10717,10873,11029,11183,11336,
  11488,11638,11788,11936,12083,12229,12374,12518,
  12660,12801,12941,13079,13217,13353,13487,13621,
  13753,13884,14013,14142,14269,14394,14519,14642,
  14763,14884,15003,15120,15237,15352,15465,15578,
  15688,15798,15906,16013,16118,16223,16325,16427,
  16527,16626,16723,16819,16914,17007,17099,17189,
  17279,17367,17453,17538,17622,17705,17786,17866,
  17945,18023,18099,18173,18247,18319,18390,18460,
  18529,18596,18662,18727,18790,18853,18914,18974,
  19032,19090,19146,19202,19256,19309,19361,19411,
  19461,19510,19557,19603,19649,19693,19736,19779,
  19820,19860,19899,19937,19975,20011,20046,20081,
  20114,20147,20179,20210,20240,20269,20297,20325,
  20351,20377,20402,20427,20450,20473,20495,20516,
  20537,20557,20576,20595,20613,20630,20647,20663,
  20679,20694,20708,20722,20735,20748,20760,20772,
  20783,20794,20804,20814,20824,20833,20841,20849,
  20857,20864,20872,20878,20885,20891,20896,20902,
  20907,20912,20916,20920,20924,20928,20932,20935,
  20938,20941,20944,20946,20948,20951,20953,20954,
  20956,20958,20959,20960,20962,20963,20964,20965,
  20965,20966,20967,20967,20968,20968,20969,20969,
  20970,20970,20970,20970,20970
 };

uint8_t  sform, p_cnt, p_buff[2], p_prev;
int16_t targetlevel;
uint32_t opz, p_dx, p_val;
uint8_t  inbuff[INBUFF_SIZE], outbuff[OUTBUFF_SIZE];
int16_t ss0[512], ss1[1024], sse[4096];
FILE  *f1;

//-----------------------------------------------------------------------------

void push_b(uint8_t x)
{
 outbuff[opz]=x;
 opz++;
 if (opz>=OUTBUFF_SIZE)
 {
  fwrite(outbuff,1,OUTBUFF_SIZE,f1);
  opz=0;
 }
}

//-----------------------------------------------------------------------------

void push_w(int16_t x)
{
 push_b(((uint16_t)x)&0xff);
 push_b((((uint16_t)x)>>8)&0xff);
}

//-----------------------------------------------------------------------------

void pulseend()
{
 int16_t mlt;
 if (p_prev) mlt=-4; else mlt=4;
 do
 {
  push_w(sse[(p_val>>4)&0x0fff]/mlt);
  p_val+=(p_dx>>3);
 }
 while (p_val<0x10000);
 p_val-=0x10000;
 mlt=-mlt*2;
 do
 {
  push_w(sse[(p_val>>4)&0x0fff]/mlt);
  p_val+=(p_dx>>3);
 }
 while (p_val<0x10000);
 p_val-=0x10000;
}

//-----------------------------------------------------------------------------

void pulse(uint8_t x)
{
 p_buff[p_cnt++]=x;
 if (p_cnt==2)
 {
  if (p_buff[0]==p_buff[1])
  {
   if (p_buff[0]==I_END)
    pulseend();
   else
   {
    p_prev=p_buff[0];
    do
    {
     if (p_prev) push_w(ss1[(p_val>>6)&0x03ff]); else push_w(-ss1[(p_val>>6)&0x03ff]);
     p_val+=(p_dx>>1);
    }
    while (p_val<0x10000);
    p_val-=0x10000;
   }
   p_cnt=0;
  }
  else
  {
   if (p_buff[0]==I_END)
    pulseend();
   else
   {
    p_prev=p_buff[0];
    do
    {
     if (p_prev) push_w(ss0[(p_val>>7)&0x01ff]); else push_w(-ss0[(p_val>>7)&0x01ff]);
     p_val+=p_dx;
    }
    while (p_val<0x10000);
    p_val-=0x10000;
   }
   p_buff[0]=p_buff[1];
   p_cnt=1;
  }
 }
}

//-----------------------------------------------------------------------------

void outbyte(uint8_t data)
{
 uint8_t i;
 for (i=0;i<8;i++)
 {
  if (data&0x80)
  { pulse(I_NULL); pulse(I_ONE); }
  else
  { pulse(I_ONE); pulse(I_NULL); }
  data<<=1;
 }
}

//-----------------------------------------------------------------------------

void help()
{
 printf("\
Использовать так: RK2WAV [ключи] входной_rk_файл\n\
Ключи:  -s    - форма сигнала прямоугольная \"сглаженная\"\n\
        -l n  - амплитуда сигнала, n - значение в процентах (1...99)\n\
        -f n  - частота дискретизации, n - значение в Гц\n\
        -k n  - скорость в процентах относительно скорости РК86 (10...1000)\n\
по-умолчанию: форма сигнала - прямоугольная, амплитуда - 75,\n\
скорость - 100, частота дискретизации - автомат.\n\
");
}

//-----------------------------------------------------------------------------

int main(int argc, char *argv[])
{
 static const uint8_t errstr[]="\nRK2WAV: Ошибка! ";
 static const uint8_t WAVheader[]={
  0x52,0x49,0x46,0x46,0x00,0x00,0x00,0x00,0x57,0x41,0x56,0x45,0x66,0x6D,0x74,0x20,  // |RIFFxxxxWAVEfmt |
  0x10,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,  // |........ffffFFFF|
  0x02,0x00,0x10,0x00,0x64,0x61,0x74,0x61,0x00,0x00,0x00,0x00 };                    // |....dataxxxx    |

 uint8_t   b0, b1, pilottype, plvl;
 uint16_t  w0;
 uint32_t  dw0, dw1, fsz, fpz, freq, koef;
 char      s1[256], s2[256];

 p_prev=I_NULL;
 p_cnt=0;
 p_val=0;
 pilottype=P_NRM;
 freq=0;
 koef=100;
 plvl=75;
 sform=F_SQR;
 memset(s1,0,256);
 memset(s2,0,256);

 if (argc<2) { help(); return 3; }

 b1=0;
 dw0=1;
 while ((dw0+1)<argc)
 {
  strncpy(s2,argv[dw0],255);
  if (b1)
  {
   dw1=atoi(s2);
   switch (b1)
   {
    case 'l': if ( (dw1<1) || (dw1>99) ) { help(); return 3; }
              plvl=dw1&0xff;
              dw1*=20971;
              targetlevel=(int16_t)(dw1>>6);
              break;
    case 'f': if ( (dw1<8000) || (dw1>0x7fffff) ) { help(); return 3; }
              freq=dw1;
              break;
    case 'k': if ( (dw1<10) || (dw1>1000) ) { help(); return 3; }
              koef=dw1;
              //break;
   }
   b1=0;
  }
  else if (s2[0]=='-')
  {
   b0=tolower(s2[1]);
   if (b0=='s') sform=F_SIN;
   else if (b0=='l') b1=b0;
   else if (b0=='f') b1=b0;
   else if (b0=='k') b1=b0;
   else { help(); return 3; }
  }
  else { help(); return 3; }
  dw0++;
 }
 if (b1) { help(); return 3; }

 strncpy(s1,argv[dw0],249);
 f1=fopen(s1,"rb");
 if (!f1) { printf("%sНемогу открыть файл %s !\n",errstr,s1); return 2; }

 fseek(f1,0,SEEK_END);
 fsz=ftell(f1);
 fseek(f1,0,SEEK_SET);
 if (fsz==0) { printf("%sФайл %s слишком короткий.\n",errstr,s1); fclose(f1); return 1; }
 if (fsz>65544) { printf("%sФайл %s слишком длинный.\n",errstr,s1); fclose(f1); return 1; }
 fread(inbuff,1,fsz,f1);
 fpz=0;
 fclose(f1);

 dw1=plvl;
 dw1*=20971;
 targetlevel=(int16_t)(dw1>>6);
 for (w0=0;w0<512;w0++)  ss0[w0]=targetlevel;
 for (w0=0;w0<1024;w0++) ss1[w0]=targetlevel;
 for (w0=0;w0<4096;w0++) sse[w0]=targetlevel;
 if (sform==F_SIN)
 {
  for (w0=0;w0<245;w0++)
  {
   int tmp;
   tmp=t_ss[w0];
   tmp*=plvl;
   tmp>>=6;
   ss0[w0]=ss1[w0]=sse[w0]=ss0[511-w0]=ss1[1023-w0]=sse[4095-w0]=(int16_t)tmp;
  }
 }

 if (freq)
  p_dx=144506880L/((freq*100L)/koef);
 else
 {
  if (sform==F_SQR)
  {
   uint32_t n=4;
   do
   {
    freq=(2205L*n*koef)/100L;
    p_dx=0x10000L/n;
    n*=2;
   }while (freq<8000);
  }
  else
  {
   uint32_t n=16;
   do
   {
    freq=(2205L*n*koef)/100L;
    p_dx=0x10000L/n;
    if (freq<22050) n*=2;
    if (freq>44100) n/=2;
   }while ( (freq<22050) || ( (freq>44100) && (n>=4) ) );
  }
 }

 b0=strlen(s1)-1;
 b1=0;
 while ( (s1[b0]!='.') && (b0) && (b1<3) ) { b0--; b1++; }
 if (s1[b0]=='.')
 {
  strncpy(s2,&s1[b0],255);
  if (s2[0]=='.')
   if (tolower(s2[1])=='e')
    if (tolower(s2[2])=='d')
     if (tolower(s2[3])=='m')
      pilottype=P_EDM;
  s1[b0]=0;
 }
 strcat(s1,".wav");
 f1=fopen(s1,"wb");

 opz=0;
 for (b0=0;b0<0x18;b0++) push_b(WAVheader[b0]);
 push_b(freq&0xff); push_b((freq>>8)&0xff); push_b((freq>>16)&0xff); push_b(0);
 push_b((freq<<1)&0xfe); push_b((freq>>7)&0xff); push_b((freq>>15)&0xff); push_b(0);
 for (b0=0x20;b0<0x2c;b0++) push_b(WAVheader[b0]);

 dw1=freq>>3;
 for (dw0=0;dw0<dw1;dw0++) push_w(0);
 switch (pilottype)
 {
  case P_EDM: for (w0=0;w0<256;w0++) if (w0&0x40) outbyte(0); else outbyte(0x55);
              break;
  case P_NRM: for (w0=0;w0<256;w0++) outbyte(0);
 }
 outbyte(0xe6);
 do
 {
  outbyte(inbuff[fpz]);
  fpz++;
 }
 while (fpz<fsz);

 pulse(I_END); pulse(I_END);
 dw1=freq>>3;
 for (dw0=0;dw0<dw1;dw0++) push_w(0);
 if (opz) fwrite(outbuff,1,opz,f1);
 fsz=ftell(f1)-8;
 fseek(f1,0x0004,SEEK_SET);
 fwrite(&fsz,1,4,f1);
 fsz-=36;
 fseek(f1,0x0028,SEEK_SET);
 fwrite(&fsz,1,4,f1);
 fclose(f1);

 return 0;
}

//-----------------------------------------------------------------------------
