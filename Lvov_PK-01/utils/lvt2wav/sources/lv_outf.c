/********************************************************************
*     (C) 07-Jun-1999y by Hard Wisdom "LVOV File To WaveDev" v1.0   *
*     (C) 13-Aug-2012y by Hard Wisdom "LVOV File To WavFile" v1.0   *
********************************************************************/
#include <stdio.h>
#include <string.h>
#include <malloc.h>

#define erOK 0
#define erIO 1
#define erLogic 2
#define erParam 3
#define erHardw 4
#define erCancel 5

/*-----------------------------------------------------------------*/
int TapeLowSample, TapeHighSample, TapeSpeed=3;
/*                                 ^^^^^^^^^^^
     somebody at zx forum said that speed was 1.5x slow
*/
char *TapeBuf=NULL, *TapePtr=NULL; long TapeSz=0;
void ToTape(int What) {int s=TapeSpeed;while(s--){*TapePtr++=What; TapeSz++;}}

FILE *f;

int InitTape(char *FN) {f=fopen(FN ? FN : "out.wav", "wb"); return f != NULL;}
int DoneTape(void) {fclose(f); return ferror(f) == 0;}

void FlushTape(void Meter(void)) {
 size_t sz;
/*
https://ccrma.stanford.edu/courses/422/projects/WaveFormat/

The canonical WAVE format starts with the RIFF header:

0         4   ChunkID          Contains the letters "RIFF" in ASCII form
                               (0x52494646 big-endian form).
4         4   ChunkSize        36 + SubChunk2Size, or more precisely:
                               4 + (8 + SubChunk1Size) + (8 + SubChunk2Size)
                               This is the size of the rest of the chunk 
                               following this number.  This is the size of the 
                               entire file in bytes minus 8 bytes for the
                               two fields not included in this count:
                               ChunkID and ChunkSize.
8         4   Format           Contains the letters "WAVE"
                               (0x57415645 big-endian form).

The "WAVE" format consists of two subchunks: "fmt " and "data":
The "fmt " subchunk describes the sound data's format:

12        4   Subchunk1ID      Contains the letters "fmt "
                               (0x666d7420 big-endian form).
16        4   Subchunk1Size    16 for PCM.  This is the size of the
                               rest of the Subchunk which follows this number.
20        2   AudioFormat      PCM = 1 (i.e. Linear quantization)
                               Values other than 1 indicate some 
                               form of compression.
22        2   NumChannels      Mono = 1, Stereo = 2, etc.
24        4   SampleRate       8000, 44100, etc.
28        4   ByteRate         == SampleRate * NumChannels * BitsPerSample/8
32        2   BlockAlign       == NumChannels * BitsPerSample/8
                               The number of bytes for one sample including
                               all channels. I wonder what happens when
                               this number isn't an integer?
34        2   BitsPerSample    8 bits = 8, 16 bits = 16, etc.
          2   ExtraParamSize   if PCM, then doesn't exist
          X   ExtraParams      space for extra parameters

The "data" subchunk contains the size of the data and the actual sound:

36        4   Subchunk2ID      Contains the letters "data"
                               (0x64617461 big-endian form).
40        4   Subchunk2Size    == NumSamples * NumChannels * BitsPerSample/8
                               This is the number of bytes in the data.
                               You can also think of this as the size
                               of the read of the subchunk following this 
                               number.
44        *   Data             The actual sound data.
*/
 sz = TapeSz + 36;
 fwrite("RIFF", 4, 1, f);
 fwrite(&sz, 4, 1, f);
 fwrite("WAVE", 4, 1, f);
 fwrite("fmt ", 4, 1, f);
 fwrite("\x10\x00\x00\x00", 4, 1, f);
 fwrite("\x01\x00", 2, 1, f);
 fwrite("\x01\x00", 2, 1, f);
 sz = 8000;
 fwrite(&sz, 4, 1, f);
 fwrite(&sz, 4, 1, f);
 fwrite("\x01\x00", 2, 1, f);
 fwrite("\x08\x00", 2, 1, f);
 fwrite("data", 4, 1, f);
 sz = TapeSz;
 fwrite(&sz, 4, 1, f);
 fwrite(TapeBuf, sz, 1, f);
}

/*-----------------------------------------------------------------*/
void TapePause(int Length) {
 while (Length--) {ToTape(TapeLowSample);ToTape(TapeLowSample);}
}

void TapePilot(int Length) {
 while (Length--) {ToTape(TapeLowSample);ToTape(TapeHighSample);}
}

void TapeByte(int Byte) { int i;
 ToTape(TapeLowSample); ToTape(TapeLowSample); // Start bit 0
 ToTape(TapeHighSample); ToTape(TapeHighSample);
 for (i=0;i<8;i++,Byte>>=1) { // Data bits 0..7
  if (Byte & 0x01) {
   ToTape(TapeLowSample); ToTape(TapeHighSample); // Bit 1
   ToTape(TapeLowSample); ToTape(TapeHighSample);
  } else {
   ToTape(TapeLowSample); ToTape(TapeLowSample); // Bit 0
   ToTape(TapeHighSample); ToTape(TapeHighSample);
  }
 }
 ToTape(TapeLowSample); ToTape(TapeHighSample); // Stop bit 1
 ToTape(TapeLowSample); ToTape(TapeHighSample);
 ToTape(TapeLowSample); ToTape(TapeHighSample); // Stop bit 2
 ToTape(TapeLowSample); ToTape(TapeHighSample);
}

/*-----------------------------------------------------------------*/
void Rolo(void) {
 static int q=0; fputc("|/-\\"[q++],stderr); fputc('\b',stderr); if (q>3) q=0;
}

char* ExportFile(char* FName, int Low, int High, char* NewName) {
 FILE *f; char Sign[9]; unsigned char Body[0x10000]; int BodySz,i; long OutSz;
 f=fopen(FName,"rb"); if (!f) return "Unable to open file";
 if (fread(Sign,sizeof(Sign),1,f)!=1) return "Unable to read file signature";
 if (strncmp(Sign,"LVOV/2.0/",9)) return "Not the LVOV v2.0 file";
 BodySz=fread(Body,1,0x10000,f); fclose(f);
 printf("Well, readed all %u bytes of the source file.\n",BodySz);

 OutSz=(10240+2048+2560)*2*TapeSpeed+(BodySz+9)*11*4*TapeSpeed;
 printf("Preparing %lu bytes of memory for the target waveform...\n",OutSz);
 TapeBuf=TapePtr=malloc(OutSz); if (!TapeBuf) return "No enough memory";
 TapeSz=0; TapeLowSample=Low; TapeHighSample=High;

 printf("Generating %s header...\n",Body[0]==0xD0?"BSAVE":
                                    Body[0]==0xD3?"CSAVE":"UNKNOWN");
 TapePilot(10240); for(i=0;i<10;i++) TapeByte(Body[0]);
 for (i=1;i<=6;i++) TapeByte(Body[i]);
 TapePause(2048);

 puts("Generating body (rest of other datas)...");
 TapePilot(2560); for(i=7;i<BodySz;i++) TapeByte(Body[i]);

 printf("  Wave has been done. Saving it...\r");
 if (!InitTape(NewName)) {free(TapeBuf); return "Unable to open waveform file";}
 FlushTape(&Rolo); puts("û"); free(TapeBuf);
 if (!DoneTape()) return "Unable to close waveform file";

 return NULL;
}

/*-----------------------------------------------------------------*/
int main(int argc, char* argv[]) { char Name[0x100],*m; int LL=0,HL=255;
 char NewName[0x100];

 puts("(C) 13-Aug-2012y by Hard Wisdom 'LVOV File To WavFile' v1.0\n"\
      "                                ~~~~~~~~~~~~~~~~~~~~~~"
 );
 if (argc<=1) {
  puts("USAGE: LV_OUTW.EXE <InFile> [LowLevel/HighLevel] [FileName]\n"\
       "       where  InFile - input LVOV file either CLOAD or BLOAD\n"\
       "            LowLevel - low output level (0 by default)\n"\
       "           HighLevel - high output level (255 by default)\n"\
       "            FileName - name of file if InFile.wav isn't good\n"\
       "       if You wish to inverse output wave than You may use\n"\
       "       the 255/0 instead of the 0/255 by default ;-)\n"
  ); return erParam;
 }

 strcpy(Name,argv[1]); if (argc>2) {
  if (sscanf(argv[2],"%u/%u",&LL,&HL)!=2) {
   puts("Unable to recognize the levels parameter, must be a Num/Num !");
   return erParam;
 }}
 if (argc>3) strcpy(NewName, argv[3]); else {
  strcpy(NewName, Name);
  if (strrchr(NewName, '.')) strcpy(strrchr(NewName,'.'), ".wav");
  else strcat(NewName, ".wav");
 }

 printf("Exporting '%s' with levels %u/%u into '%s'\n\n",Name,LL,HL,NewName);
 if (m=ExportFile(Name,LL,HL,NewName)) {printf("\nError: %s !\n",m);return erHardw;}
 else {puts("\nExported successfully!");return erOK;}
}
