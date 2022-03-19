// CAS2WAV v1.1 for Poisk PC. by Tronix (C) 2013
// Compile with Virtual Pascal v2.1
// maybe Delphi or Free Pascal

Const

   OUTPUT_FREQUENCY  = 43200;
   BAUDRATE = 1200;
   LONG_PULSE      = 1000; //1
   SHORT_PULSE       = 2000; //0

Crc16Table: array[0..255] of WORD = (
    $0000, $1021, $2042, $3063, $4084, $50A5, $60C6, $70E7,
    $8108, $9129, $A14A, $B16B, $C18C, $D1AD, $E1CE, $F1EF,
    $1231, $0210, $3273, $2252, $52B5, $4294, $72F7, $62D6,
    $9339, $8318, $B37B, $A35A, $D3BD, $C39C, $F3FF, $E3DE,
    $2462, $3443, $0420, $1401, $64E6, $74C7, $44A4, $5485,
    $A56A, $B54B, $8528, $9509, $E5EE, $F5CF, $C5AC, $D58D,
    $3653, $2672, $1611, $0630, $76D7, $66F6, $5695, $46B4,
    $B75B, $A77A, $9719, $8738, $F7DF, $E7FE, $D79D, $C7BC,
    $48C4, $58E5, $6886, $78A7, $0840, $1861, $2802, $3823,
    $C9CC, $D9ED, $E98E, $F9AF, $8948, $9969, $A90A, $B92B,
    $5AF5, $4AD4, $7AB7, $6A96, $1A71, $0A50, $3A33, $2A12,
    $DBFD, $CBDC, $FBBF, $EB9E, $9B79, $8B58, $BB3B, $AB1A,
    $6CA6, $7C87, $4CE4, $5CC5, $2C22, $3C03, $0C60, $1C41,
    $EDAE, $FD8F, $CDEC, $DDCD, $AD2A, $BD0B, $8D68, $9D49,
    $7E97, $6EB6, $5ED5, $4EF4, $3E13, $2E32, $1E51, $0E70,
    $FF9F, $EFBE, $DFDD, $CFFC, $BF1B, $AF3A, $9F59, $8F78,
    $9188, $81A9, $B1CA, $A1EB, $D10C, $C12D, $F14E, $E16F,
    $1080, $00A1, $30C2, $20E3, $5004, $4025, $7046, $6067,
    $83B9, $9398, $A3FB, $B3DA, $C33D, $D31C, $E37F, $F35E,
    $02B1, $1290, $22F3, $32D2, $4235, $5214, $6277, $7256,
    $B5EA, $A5CB, $95A8, $8589, $F56E, $E54F, $D52C, $C50D,
    $34E2, $24C3, $14A0, $0481, $7466, $6447, $5424, $4405,
    $A7DB, $B7FA, $8799, $97B8, $E75F, $F77E, $C71D, $D73C,
    $26D3, $36F2, $0691, $16B0, $6657, $7676, $4615, $5634,
    $D94C, $C96D, $F90E, $E92F, $99C8, $89E9, $B98A, $A9AB,
    $5844, $4865, $7806, $6827, $18C0, $08E1, $3882, $28A3,
    $CB7D, $DB5C, $EB3F, $FB1E, $8BF9, $9BD8, $ABBB, $BB9A,
    $4A75, $5A54, $6A37, $7A16, $0AF1, $1AD0, $2AB3, $3A92,
    $FD2E, $ED0F, $DD6C, $CD4D, $BDAA, $AD8B, $9DE8, $8DC9,
    $7C26, $6C07, $5C64, $4C45, $3CA2, $2C83, $1CE0, $0CC1,
    $EF1F, $FF3E, $CF5D, $DF7C, $AF9B, $BFBA, $8FD9, $9FF8,
    $6E17, $7E36, $4E55, $5E74, $2E93, $3EB2, $0ED1, $1EF0);

Type
    Wave_Fmt      = Record
      RIFFId      : Array [1..4] of Char;
      RIFFLen     : LongInt;
      WAV_Id      : Array [1..4] of Char;
      Fmt_Id      : Array [1..4] of Char;
      F_Len       : LongInt;
      Format      : Word;
      Channels    : Word;
      Sample_Rate : LongInt;
      Bytes_secnd : LongInt;
      Block_Align : Word;
      BPS         : Word;

      Data_Id     : Array [1..4] of Char;
      Data_Len    : LongInt;
    End;

    Poisk_hdr     = Packed Record
      Magic       : Byte; // A5h
      FName       : Array [1..8] of Char;
      FType       : Byte;
      FLen        : Word;
      Seg         : Word;
      Ofs         : Word;
    End;

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

Procedure Error(ss: string);
Begin
   WriteLn(#13#10'Fatal error   : ',ss);
   Halt(255);
End;

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

Function CheckCRC: Word;  //X^16+X^12+X^5+1
Var
  i : Word;
  crc2 : Word;
Begin
  crc2 := $ffff;
  for I := 0 to 255 do
    crc2 := word(crc2 shl 8) xor Crc16Table[word(crc2 shr 8) xor Mas[i]];
   CheckCRC := crc2 xor $ffff;
End;

Procedure WritePulse(f : longint);
Var
   len, scale : Real;
   n : Longint;
   b : Byte;
Begin
  len := OUTPUT_FREQUENCY/(BAUDRATE*(f/1200));
  scale  := 2.0*PI/len;

  For n := 0 to Round(len)-1 do
      Begin
         b := Byte(Round(sin(n*scale)*127)) xor 128;
         Buf[Blen] := b;
         Inc(Blen);
         If Blen > 64000 then
            begin
               BlockWrite(FF,Buf,64000);
               Blen := 1;
            end;
         Inc(Size);
      End;

End;

Procedure WriteHeader(s : longint);
Var
   i : longint;
Begin
   For i := 0 to Round(s*(BAUDRATE/1200)) do WritePulse(LONG_PULSE);
End;

Procedure WriteByte(b : Byte);
Var
   i : Byte;
Begin
   For i := 7 downto 0 do
      If (b shr i) and 1 = 1 then
         WritePulse(LONG_PULSE)
      else
         WritePulse(SHORT_PULSE);
End;

Procedure WriteBlock;
Var
   i : Byte;
   crc : Word;
Begin
   For i := 0 to 255 do WriteByte(Mas[i]);
   crc := CheckCRC;
   WriteByte(hi(crc));
   WriteByte(lo(crc));
End;

Begin
   WriteLn('CAS2WAV v1.1 for Poisk PC. by Tronix (C) 2013'#13#10);
   If ParamCount < 2 then
      begin
         WriteLn(' Usage:');
         WriteLn('   CAS2WAV <cas_file> <wav_file> [-n NAME] [-t TYPE] [-s SEG] [-o OFS]'#13#10);
         WriteLn(' Keys:');
         WriteLn('   -n NAME    : Set program name on tape (8 chars). Ex.: -n BASIC');
         WriteLn('   -t TYPE    : Set program type (00,01,40,80,A0).  Ex.: -t 80');
         WriteLn('   -s SEGMENT : Set memory segment.                 Ex.: -s 0060');
         WriteLn('   -o OFFSET  : Set memory offset.                  Ex.: -o 081E'#13#10);
         WriteLn(' Defaults values:');
         WriteLn(' NAME= PROGRAMM, TYPE= 80, SEGMENT= 0060, OFFSET: 081E');
         Halt(1);
      end;

   Assign(F,ParamStr(1));
   {$I-}
   Reset(F,1);
   {$I+}
   If IOResult <> 0 then Error('Error open CAS file');

   Assign(FF,ParamStr(2));
   {$I-}
   Rewrite(FF,1);
   {$I+}
   If IOResult <> 0 then Error('Error create WAV file');

   Psk.Magic := $A5;
   Psk.FName := 'PROGRAMM';
   Psk.FType := 128;
   Psk.FLen := FileSize(F);
   Psk.Seg := $0060;
   Psk.Ofs := $081E;

   If ParamCount > 2 then
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

   WriteLn('Making wav    : ',ParamStr(2));
   Hdr.RIFFId := 'RIFF';
   Hdr.RIFFLen := 0;
   Hdr.WAV_Id := 'WAVE';
   Hdr.Fmt_Id := 'fmt ';
   Hdr.F_Len := 16;
   Hdr.Format := 1; //PCM
   Hdr.Channels := 1; // Mono
   Hdr.Sample_Rate := OUTPUT_FREQUENCY;
   Hdr.Bytes_secnd := OUTPUT_FREQUENCY;
   Hdr.Block_Align := 1;
   Hdr.BPS := 8;
   Hdr.Data_Id := 'data';
   Hdr.Data_Len := 0;

   WriteLn('Format        : ',Hdr.Format);
   WriteLn('Channels      : ',Hdr.Channels);
   WriteLn('Sample rate   : ',Hdr.Sample_Rate);
   WriteLn('Bit per sound : ',Hdr.BPS,#13#10);
   BlockWrite(FF,Hdr,44);

   Size := 1;
   Blen := 1;

   Write(  'Write leader1 : ');
   WriteHeader(2048);
   WritePulse(SHORT_PULSE);
   WriteByte($16);
   WriteLn('Ok!');


   Write(  'Write fileinfo: ');

   FillChar(Mas,256,0);
   Move(Psk,Mas,16);
   WriteBlock;
   WriteLn('Ok!');

   Write(  'Close stream  : ');
   For k := 1 to 4 do WriteByte($FF);
   WriteLn('Ok!'#13#10);

   Write(  'Write leader2 : ');
   WriteHeader(2048);
   WritePulse(SHORT_PULSE);
   WriteByte($16);
   WriteLn('Ok!');

   Write(  'Write data    : ');
   While not Eof(F) do
    begin
      FillChar(Mas,256,0);
      If FilePos(F) < FileSize(F) - 256 then
         BlockRead(F,Mas,256)
      else
         BlockRead(F,Mas,FileSize(F) - FilePos(F));
      WriteBlock;
    end;
   WriteLn('Ok!');

   If Blen <= 64000 then
      BlockWrite(FF,Buf,Blen);

   // Write size info in WAV header
   Seek(FF,0);
   Hdr.RiffLen := Size+44-8;
   Hdr.Data_Len := Size;
   BlockWrite(FF,Hdr,44);

   Close(F);
   Close(FF);
   WriteLn(#13#10'Done. Size = ',size,' bytes');
End.
