// CAS2WAV v1.1 for Poisk PC. by Tronix (C) 2013
// Compile with Virtual Pascal v2.1
// maybe Delphi or Free Pascal

// 2015 Aleksey Morozov, ported to c++

#include "stdafx.h"
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <iostream>
#include <io.h>
#include <fcntl.h>
#include <math.h>
#include <vector>
#include <windows.h>

class file_t {
public:
	HANDLE h;

	file_t() { h = INVALID_HANDLE_VALUE; }
	bool open(const wchar_t* name) { close(); h = CreateFile(name, GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,0,OPEN_EXISTING,0,0); return h != INVALID_HANDLE_VALUE; }
	bool create(const wchar_t* name) { close(); h = CreateFile(name, GENERIC_READ|GENERIC_WRITE,FILE_SHARE_READ|FILE_SHARE_WRITE,0,CREATE_ALWAYS,0,0); return h != INVALID_HANDLE_VALUE; }
	int read(void* b, size_t l) { DWORD rl; return ReadFile(h, b, l, &rl, 0) ? rl : -1; }
	int write(const void* b, size_t l) { DWORD rl; return WriteFile(h, b, l, &rl, 0) ? rl : -1; }
	int64_t size() { LARGE_INTEGER r; return GetFileSizeEx(h, &r) ? int64_t(r.QuadPart) : int64_t(-1); }
	int64_t seek(int64_t pos, unsigned m) { LARGE_INTEGER s, r; s.QuadPart = pos; return SetFilePointerEx(h, s, &r, m) ? r.QuadPart : -1; }
	void close() { if(h != INVALID_HANDLE_VALUE) { CloseHandle(h); h = INVALID_HANDLE_VALUE; } }
	~file_t() { close(); }
};

const int OUTPUT_FREQUENCY  = 8000;
const int BAUDRATE = 1200;
const int LONG_PULSE_ = 1000; //1
const int SHORT_PULSE_ = 2000; //0
const int LONG_PULSE__ = OUTPUT_FREQUENCY / (BAUDRATE * LONG_PULSE_ / 1200);
const int SHORT_PULSE__ = OUTPUT_FREQUENCY / (BAUDRATE * SHORT_PULSE_ / 1200);

uint16_t Crc16Table[256] = {
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
    0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
    0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6,
    0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE,
    0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485,
    0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D,
    0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4,
    0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC,
    0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823,
    0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B,
    0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12,
    0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A,
    0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41,
    0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49,
    0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70,
    0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78,
    0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F,
    0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067,
    0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E,
    0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256,
    0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D,
    0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
    0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C,
    0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634,
    0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB,
    0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3,
    0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A,
    0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92,
    0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9,
    0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1,
    0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8,
    0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
};

#pragma pack(push, 1)

struct Wave_Fmt {
    uint8_t   RIFFId[4];   // : Array [1..4] of Char;
    uint32_t  RIFFLen;     // : LongInt;
    uint8_t   WAV_Id[4];   // : Array [1..4] of Char;
    uint8_t   Fmt_Id[4];   // : Array [1..4] of Char;
    uint32_t  F_Len;       // : LongInt;
    uint16_t  Format;      // : Word;
    uint16_t  Channels;    // : Word;
    uint32_t  Sample_Rate; // : LongInt;
    uint32_t  Bytes_secnd; // : LongInt;
    uint16_t  Block_Align; // : Word;
    uint16_t  BPS;         // : Word;
    uint8_t   Data_Id[4];  // : Array [1..4] of Char;
    uint32_t  Data_Len;    // : LongInt;
};

struct Poisk_hdr { 
    uint8_t  Magic;        // : Byte; // A5h
    uint8_t  FName[8];     // : Array [1..8] of Char;
    uint8_t  FType;        // : Byte;
    uint16_t FLen;         // : Word;
    uint16_t Seg;          // : Word;
    uint16_t Ofs;          // : Word;
};

#pragma pack(pop)

/*
Var
   F,FF  : File;
   Hdr   : Wave_Fmt;
   Psk   : Poisk_hdr;
   Size  : LongInt;
   s     : String;
   Buf   : Array [1..64000] of Byte;
   BLen  : LongInt;
   Mas   : Array [0..255] of Byte;
   k,kk  : Byte;
*/
uint8_t   buf[32768];
size_t    blen = 0;
file_t    ff;

/*
function IntToHex(IntValue: cardinal; Digits: integer): string;
var
  i, j: cardinal;
  s: string;
begin
  s := '';
  if IntValue > 0 then
  begin
    i := IntValue;
    while i>0 do
    begin
      j := i mod 16;
      if (j<10) then
        s := Chr(Ord('0') + j) + s
      else
        s := Chr(Ord('A') + (j - 10)) + s;
      i := i div 16;
    end;
  end;
  if Digits < 1 then Digits := 1;
  i := Digits - Length(s);
  while i>0 do
  begin
    s := '0' + s;
    i := i - 1;
  end;
  IntToHex := s;
end;

function HexToInt(Str : string): integer;
var i, r : longint;
begin
  val('$'+Str,r, i);
  if i<>0 then HexToInt := 0
  else HexToInt := r;
end;
*/
uint16_t checkCRC(uint8_t* mas) // X^16+X^12+X^5+1
{
   uint16_t crc2 = 0xffff;
   for(int i=0; i<256; i++)
      crc2 = (crc2 << 8) ^ Crc16Table[((crc2 >> 8) ^ mas[i]) & 0xFF];
   return crc2 ^ 0xffff;
}

void writePulse1(int32_t ilen)
{
	if(blen + ilen >= sizeof(buf)) ff.write(buf, blen), blen = 0;
	unsigned ilen2 = ilen / 2;
	memset(buf + blen, 16, ilen2);
	memset(buf + blen + ilen2, -16, ilen - ilen2);
	blen += ilen;
}

void writeHeader(unsigned s)
{
	for(unsigned l = s * (BAUDRATE / 1200); l; l--)
		writePulse1(LONG_PULSE__);
}

void writeByte(uint8_t b)
{
   for(int i=0; i<8; i++, b <<= 1) 
      writePulse1((b & 0x80) ? LONG_PULSE__ : SHORT_PULSE__);
}

void writeBlock(uint8_t* mas)
{
   for(int i=0; i<256; i++) writeByte(mas[i]);
   uint16_t crc = checkCRC(mas);
   writeByte(uint8_t(crc >> 8));
   writeByte(uint8_t(crc));
}

int _tmain(int argc, _TCHAR* argv[])
{
	printf("CAS2WAV v1.1 for Poisk PC. by Tronix (C) 2013\r\n");
	if(argc < 2) 
	{
		printf("Usage:\r\n");
		printf("  CAS2WAV <cas_file> <wav_file> [-n NAME] [-t TYPE] [-s SEG] [-o OFS]\r\n");
        printf("Keys:\r\n");
        printf("  -n NAME    : Set program name on tape (8 chars). Ex.: -n BASIC\r\n");
        printf("  -t TYPE    : Set program type (00,01,40,80,A0).  Ex.: -t 80\r\n");
        printf("  -s SEGMENT : Set memory segment.                 Ex.: -s 0060\r\n");
        printf("  -o OFFSET  : Set memory offset.                  Ex.: -o 081E\r\n");
        printf("Defaults values:\r\n");
        printf("NAME= PROGRAMM, TYPE= 80, SEGMENT= 0060, OFFSET: 081E\r\n");
        return 1;
	}

	file_t f;
	if(!f.open(argv[1]))
	{
		printf("Error open CAS file\r\n");
		return 1;
	}
	std::vector<uint8_t> src;
	size_t src_size = f.size();
	src.resize(src_size);
	if(src_size > 0) 
	{
		if(f.read(&src[0], src_size) != src_size)
		{
			printf("Error open CAS file\r\n");
			return 1;
		}
	}
	f.close();

	if(!ff.create(argv[2]))
	{
		printf("Error create WAV file\r\n");
		return 1;
	}

	Poisk_hdr Psk;
	uint8_t   mas[256];
	Psk.Magic = 0xA5;
	memcpy(Psk.FName, "BASIC\x00\x00", 8);
	Psk.FType = 0x80;
	Psk.FLen  = src.size();
	Psk.Seg   = 0x60;
	Psk.Ofs   = 0x81E;
 /*
   if(argc > 2) 
      For k := 3 to ParamCount do
         Begin
            If ParamStr(k)[1] = '-' then
               Case UpCase(ParamStr(k)[2]) of
                  'N' : begin
                           s := ParamStr(k+1);
                           If Length(s) < 8 then
                              for kk := 1 to 8-Length(s) do s := s + ' ';
                           Move(s[1],Psk.FName,8);
                           WriteLn('Programm name : ',s);
                        end;
                  'T' : begin
                           Psk.FType := HexToInt(ParamStr(k+1));
                           WriteLn('Programm type : ',IntToHex(Psk.FType,2));
                        end;
                  'S' : begin
                           Psk.Seg := HexToInt(ParamStr(k+1));
                           WriteLn('Memory segment: ',IntToHex(Psk.Seg,4));
                        end;
                  'O' : begin
                           Psk.Ofs := HexToInt(ParamStr(k+1));
                           WriteLn('Memory offset : ',IntToHex(Psk.Ofs,4));
                        end;
               Else
                  Error('Invalid key '+ParamStr(k));
               End;
         End;
*/
	printf("Making wav    : %s\n", argv[2]);
	Wave_Fmt hdr;
	memcpy(hdr.RIFFId, "RIFF", 4);
	hdr.RIFFLen = 0;
	memcpy(hdr.WAV_Id, "WAVE", 4);
	memcpy(hdr.Fmt_Id, "fmt ", 4);
	hdr.F_Len = 16;
	hdr.Format = 1; //PCM
	hdr.Channels = 1; // Mono
	hdr.Sample_Rate = OUTPUT_FREQUENCY;
	hdr.Bytes_secnd = OUTPUT_FREQUENCY;
	hdr.Block_Align = 1;
	hdr.BPS = 8;
	memcpy(hdr.Data_Id, "data", 4);
	hdr.Data_Len = 0;

	std::cout << "Format        : " << hdr.Format << std::endl;
	std::cout << "Channels      : " << hdr.Channels << std::endl;
	std::cout << "Sample rate   : " << hdr.Sample_Rate << std::endl;
	std::cout << "Bit per sound : " << hdr.BPS << std::endl;
	ff.write(&hdr, sizeof(hdr));

	blen = 0;

	printf("Write leader1 : ");
	writeHeader(2048);
	writePulse1(SHORT_PULSE__);
	writeByte(0x16);
	std::cout << "Ok!" << std::endl;

	std::cout << "Write fileinfo: ";
	memset(mas, 0, sizeof(mas));
	memcpy(mas, &Psk, 16);
	writeBlock(mas);
	std::cout << "Ok!" << std::endl;

	std::cout << "Close stream  : ";
	for(int k=0; k<4; k++)
		writeByte(0xFF);
	std::cout << "Ok!" << std::endl;

	printf("Write leader2 : ");
	writeHeader(2048);
	writePulse1(SHORT_PULSE__);
	writeByte(0x16);
	std::cout << "Ok!" << std::endl;

	printf("Write data    : ");
	for(unsigned o=0; o<src.size(); o+=256)
	{
		memset(mas, 0, sizeof(mas));
		memcpy(mas, &src[o], o+256 < src.size() ? 256 : src.size()-o);
		writeBlock(mas);
	}
	std::cout << "Ok!" << std::endl;

	if(blen) ff.write(buf, blen);

	// Write size info in WAV header
	uint32_t s = uint32_t(ff.size());
	hdr.RIFFLen = s - 8;
	hdr.Data_Len = s - sizeof(hdr);
	ff.seek(0,0);
	ff.write(&hdr, sizeof(hdr));
 
	ff.close();

	std::cout << std::endl << "Done. Size = " << s << " bytes" << std::endl;
	return 0;
}
