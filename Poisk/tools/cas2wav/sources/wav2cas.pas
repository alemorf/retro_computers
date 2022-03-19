// WAV2CAS v1.1 for Poisk PC. by Tronix (C) 2013
// Compile with Virtual Pascal v2.1
// maybe Delphi or Free Pascal
// History:
// v1.0
//   - initial release
// v1.1
//   - fix MC1502 CRC error
Uses SysUtils, Windows;

const
TxtPol : Array [0..1] of Char = ('-','+');
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
  BufferType    = Array[0..MaxLongInt-1] of Byte;
  pBuffer       = ^BufferType;

    Wave_Fmt      = Packed Record
      RIFFId      : Array [1..4] of Byte;
      RIFFLen     : LongInt;
      WAV_Id      : Array [1..4] of Byte;
      Fmt_Id      : Array [1..4] of Byte;
      F_Len       : LongInt;
      Format      : Word;
      Channels    : Word;
      Sample_Rate : Word;
      Bytes_secnd : Word;
      Block_Align : Word;
      BPS         : Word;

      Data_Id     : Array [1..4] of Char;
      Data_Len    : LongInt;
    End;

    Poisk_hdr     = Packed Record
      Magic       : Byte; // A5h
      FName       : Array [1..8] of Byte;
      FType       : Byte;
      FLen        : Word;
      Seg         : Word;
      Ofs         : Word;
    End;

    mc1502_hdr    = Packed Record
      Magic       : Byte; // A5h
      FName       : Array [1..8] of Byte;
      FLen        : Word;
      FType       : Byte;
      Seg         : Word;
      Ofs         : Word;
    End;

    Results_type  = Packed Record
      Filter      : Byte;
      Polar       : Boolean;
      errors      : LongInt;
    end;

Var
   F      : File;
   FLog   : Text;
   Hdr    : Wave_Fmt;
   PHdr   : Poisk_HDR;
   MHdr   : mc1502_hdr;
   Results: Array [0..($A0-$40)*2] of Results_type;
   Tmp_res: Results_type;
   s      : String;
   Buf    : Pointer;
   BufCnt : Cardinal;
   i,
   j,
   Size   : Cardinal;
   Speed  : LongInt;
   Filter : byte = $40;
   Polar  : Boolean;
   Mas    : Array [0..256] of Byte;

   errors : longint;
   res2,
   res    : longint;
   res_id : longint;
   Poisk  : boolean = True;
   Log    : boolean = False;

   timer  : cardinal;       //timer

Procedure Error(ss: string);
Begin
   WriteLn(#13#10'Fatal error   : ',ss);
   If Log then Close(Flog);
   Halt(255);
End;

Procedure WriteLog(s : string);
Begin
   If Log then WriteLn(FLog,s);
End;

procedure OpenFile;
begin
   AssignFile(F,ParamStr(1));
   {$I-}
   Reset(F,1);
   {$I+}
   If IOResult <> 0 then Error('Can''t open WAV file');
   BlockRead(F,Hdr,44);

   WriteLn('Format        : '+IntToStr(Hdr.Format));
   WriteLn('Channels      : '+IntToStr(Hdr.Channels));
   WriteLn('Sample rate   : '+IntToStr(Hdr.Sample_Rate));
   WriteLn('Bit per sound : '+IntToStr(Hdr.BPS));

   If (Hdr.Format <> 1) or (Hdr.Channels <> 1) then
      Error('WAV file must be mono 8 bit unsigned PCM format');

   Size := FileSize(F)-44;
   GetMem(Buf,Size);
   BlockRead(F,pBuffer(Buf)^,Size);
   CloseFile(F);

end;


function GetNextSample: byte;
var
  curr : byte;
begin
  If BufCnt >= Size then exit else
  curr:=pBuffer(Buf)^[BufCnt];
  Inc(BufCnt);
  GetNextSample := curr;
end;

function Polarity(Pol: boolean): longint;
var
  RealPol: boolean;
  cur : shortint;
begin
  RealPol:=Pol xor Polar;
  if (pBuffer(Buf)^[BufCnt]>Filter)<>RealPol then
  repeat
  until (RealPol=(GetNextSample>Filter)) or (bufcnt >= size);
  Polarity:=BufCnt;
end;

function LoadPilot:boolean;
var
  Cnt,Avg,Now,Posit: longint;
begin
  Cnt:=0;
  Avg:=0;
  repeat
   Posit:=Polarity(true);
   Polarity(false);
   Now:=Polarity(true)-Posit;
   if Cnt=0 then
      begin
        Avg:=Now;
        Inc(Cnt);
      end
    else
      if Abs(Avg-Now)>Avg/4 then
        Cnt:=0
      else
        begin
          Inc(Cnt);
          Avg:=(Avg+Now) shr 1;
        end;
  until (Cnt>=2000) or (bufcnt >= size);
  if bufcnt >= size then loadpilot := false else loadpilot := true;
  Speed:=Round(Avg*1.5);
end;


function LoadBit: boolean;
var
  Tmp,
  Posit:  longint;
  b:      boolean;
begin
  Posit:=Polarity(true);
  Polarity(false);
  Tmp := Polarity(true);
  LoadBit:=(Tmp-Posit)>Round(Speed/2);
end;

function LoadByte: byte;
var
  b,i:    byte;
  Posit:  longint;
begin
  b:=0;
  for i:=7 downto 0 do
   if LoadBit then b:=b or (1 shl i); //(b shr 1) or $80
  LoadByte:=b;
end;

function LoadWord: word;
var
  h,l: word;
begin
  l:=LoadByte; h:=LoadByte;
  LoadWord:=(l shl 8) or h;
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

// correct envelope and denoise signal
Procedure correctEnvelope;
Var
  i : Cardinal;
Begin
  for i := 1 to Size-1 do

    pBuffer(Buf)^[i] := Round(( 0.5*pBuffer(Buf)^[i-1] +
           1.0*pBuffer(Buf)^[i]   +
           2.0*pBuffer(Buf)^[i+1]   ) / 3.5);
End;

// make signal as loud as possible
Procedure normalizeAmplitude;
Var
  i : Cardinal;
  maximum : Byte;
Begin
  maximum :=0;
  for i := 0 to size do
    if (abs(shortint(pBuffer(Buf)^[i]))>maximum) then maximum :=abs(shortint(pBuffer(Buf)^[i]));
  for i := 0 to size do pBuffer(Buf)^[i] := Round(shortint(pBuffer(Buf)^[i])*(127/maximum));
End;


function AnalyseFile(WriteFile : Boolean): LongInt;
// Result:
// -1 = cant find pilot tone
// -2 = header not found
//  0 = all ok
// +1.. = CRC errors
Var
FF: File;
j : Word;
crc : Word;
TotalCnt : Longint;
tmppos2,
tmppos : cardinal;
fspd : integer;
begin
  //normalizeAmplitude;
  //for i := 1 to 1 do CorrectEnvelope;
  If not LoadPilot then
    begin
      WriteLog('Can''t find pilot tone');
      AnalyseFile := -1;
      exit;
    end;
  WriteLog('speed: '+IntToStr(speed)+'; offset: '+IntToStr(BufCnt));
  Repeat
  Until not LoadBit;
  WriteLog('offset: '+IntToStr(BufCnt));

  i := loadbyte;
  WriteLog('marker: '+IntToHex(i,2)+'h');
  if i <> $16 then
    begin
      WriteLog('header not found');
      AnalyseFile := -2;
      exit;
    end;


  for i := 0 to 255 do
    Mas[i] := LoadByte;
  Move(Mas,PHdr,16);
  Move(Mas,MHdr,16);
  s := '';
  for I := 1 to 8 do
    s := s + Chr(Phdr.FName[i]);
  WriteLog('fname: '+s);
  If Poisk then
   begin
   WriteLog('fsize: '+IntToStr(Phdr.FLen));
   WriteLog('ftype: '+IntToStr(Phdr.Ftype));
   end
  else
   begin
   WriteLog('fsize: '+IntToStr(Mhdr.FLen));
   WriteLog('ftype: '+IntToStr(Mhdr.Ftype));
  end;
   WriteLog('seg:ofs: '+IntToHex(Phdr.seg,4)+':'+IntToHex(phdr.Ofs,4));

  If WriteFile then
   begin
   WriteLn(#13#10'Header info');
      WriteLn('File name : '+s);
      If Poisk then
         begin
            WriteLn('Size      : '+IntToStr(Phdr.FLen));
            WriteLn('Type      : '+IntToHex(Phdr.Ftype,2));
         end
      else
         begin
            WriteLn('Size      : '+IntToStr(Mhdr.FLen)+' (-256 bytes)');
            WriteLn('Type      : '+IntToHex(Mhdr.Ftype,2));
         end;
      WriteLn('seg:ofs   : '+IntToHex(Phdr.seg,4)+':'+IntToHex(phdr.Ofs,4));
   end;
  If Poisk then TotalCnt := Phdr.FLen else TotalCnt := Mhdr.Flen-256;

{  assignfile(ff,'d:\poisk\hdr.out');
  Rewrite(ff,1);
  blockWrite(Ff,Mas,256);
  closefile(ff);}
  crc := loadword;
  if crc <> CheckCRC then
   begin
      WriteLog('bad header crc at: '+IntToStr(tmppos));
      AnalyseFile := -3;
      exit;
   end;

  s := '';
  for i := 1 to 4 do
    s := s + IntToStr(loadbyte);
  WriteLog('end bytes: '+s);

  If not LoadPilot then
    begin
      WriteLog('Can''t find pilot tone');
      AnalyseFile := -1;
      exit;
    end;
  WriteLog('speed: '+IntToStr(speed)+'; offset: '+IntToStr(BufCnt));
  Repeat
  Until not LoadBit;
  WriteLog('offset: '+IntToStr(BufCnt));
   i := loadbyte;
  WriteLog('marker: '+IntToHex(i,2)+'h');
  if i <> $16 then
    begin
      WriteLog('header not found');
      AnalyseFile := -2;
      exit;
    end;

  If WriteFile then
      begin
         AssignFile(FF,ParamStr(2));
         {$I-}
         Rewrite(FF,1);
         {$I+}
         If IOResult <> 0 then Error('Can''t create CAS file');
      end;
  j := 0;
  errors := 0;
  Repeat
    tmppos := bufcnt;
    for i := 0 to 255 do
      Mas[i] := LoadByte;
    tmppos2 := bufcnt;
    crc := loadword;

    fspd := -1;
    if crc <> CheckCRC then
      begin
        WriteLog('bad crc at: '+IntToStr(tmppos));
        Repeat
          bufcnt := tmppos + fspd;
          for i := 0 to 255 do
            Mas[i] := LoadByte;
          crc := loadword;
          If fspd <0 then fspd := fspd * -1 else
            fspd := (fspd + 1) * -1;
        Until (crc = CheckCRC) or (fspd > speed shr 1);
        if crc = CheckCRC then
          WriteLog('crc correct successful... FSPD: '+IntToStr(fspd))
        else
          begin
            WriteLog('crc ERROR... FSPD: '+IntToStr(fspd));
            Inc(errors);
          end;
        //bufcnt := tmppos2;
      end;

    If WriteFile then
      If j=totalcnt div 256 then BlockWrite(FF,Mas,TotalCnt-j*256)
      else BlockWrite(FF,Mas,256);
    Inc(j);
  Until j > TotalCnt div 256;
  If WriteFile then CloseFile(FF);
  WriteLog('done: '+IntToStr(errors)+' CRC unrecovered errors');
  AnalyseFile := errors;
end;

begin
   WriteLn('WAV2CAS v1.1 for Poisk PC / MC-1502. by Tronix (C) 2013'#13#10);
   If ParamCount < 2 then
      begin
         WriteLn(' Usage:');
         WriteLn('   CAS2WAV <wav_file> <cas_file> [/mc] [/log]'#13#10);
         WriteLn(' Keys:');
         WriteLn('   /mc        : Set MC-1502 mode (default Poisk)');
         WriteLn('   /log       : Create log file wav2cas.log in current directory');
         Halt(1);
      end;
   If ParamCount > 2 then
      For j := 3 to ParamCount do
         Begin
            {If ParamStr(j)[1] = '-' then
               Case UpCase(ParamStr(j)[2]) of
               End;}
            If UpperCase(ParamStr(j)) = '/MC' then Poisk := False;
            If UpperCase(ParamStr(j)) = '/LOG' then Log := True;
         End;
   If Log then
      Begin
         WriteLn('Creating LOG file: wav2cas.log');
         Assign(Flog,'wav2cas.log');
         Rewrite(FLog);
      End;

   OpenFile;
   Res_id := 0;
   Timer := GetTickCount;
   Write(#13#10'Analysing WAVE stream... MODE = ');
   If Poisk then WriteLn('Poisk PC') else WriteLn('MC-1502');
   Repeat
      Write(#13'filter: 0x'+IntToHex(Filter,2)+'; polarity: '+TxtPol[0]);
      WriteLog('--- Probe: filter: 0x'+IntToHex(Filter,2)+'; polarity: '+TxtPol[0]);
      BufCnt := 0;

      Polar := False;
      res := AnalyseFile(False);
      If Res >= 0 then
         begin
            Results[res_id].Filter := Filter;
            Results[res_id].Polar := Polar;
            Results[res_id].errors := res;
            Inc(res_id);
         end;
      BufCnt := 0;
      Polar := True;
      Write(#13'filter: 0x'+IntToHex(Filter,2)+'; polarity: '+TxtPol[1]);
      WriteLog('--- Probe: filter: 0x'+IntToHex(Filter,2)+'; polarity: '+TxtPol[1]);
      res2 := AnalyseFile(False);
      If Res2 >= 0 then
         begin
            Results[res_id].Filter := Filter;
            Results[res_id].Polar := Polar;
            Results[res_id].errors := res2;
            Inc(res_id);
         end;
      Inc(Filter);
   Until (Filter > $90) or (Res = 0) or (Res2 = 0);


   If (Res = 0) or (Res2 = 0) then
      begin
         WriteLn(#10#13#10#13'Success done without errors');
         If Res = 0 then Polar := False else Polar := true;
         Dec(Filter);
         WriteLn('A better result with filter = ',IntToHex(Filter,2),' polarity: ',TxtPol[Ord(Polar)]);
         bufcnt := 0;
         WriteLog(' --- Write final stream. Filter = '+IntToHex(Results[0].Filter,2)+' polarity: '+TxtPol[Ord(Results[0].Polar)]);
         res := AnalyseFile(True);
      end
   else If res_id <> 0 then
      begin
         WriteLn(#10#13#10#13'Done with CRC errors');

         for j:=1 to res_id-1 do
            for i:=0 to res_id-1-j do
               if Results[i].errors > Results[i+1].errors then
                  begin
                     Tmp_Res := Results[i];
                     Results[i] := Results[i+1];
                     Results[i+1] := Tmp_Res;
                  end;
         WriteLn('A better approximation with filter = ',IntToHex(Results[0].Filter,2),' polarity: ',TxtPol[Ord(Results[0].Polar)]);
         WriteLn('Unrecovered CRC errors: ',Results[0].errors);

         Polar := Results[0].Polar;
         Filter := Results[0].Filter;
         bufcnt := 0;
         WriteLog(' --- Write final stream. Filter = '+IntToHex(Results[0].Filter,2)+' polarity: '+TxtPol[Ord(Results[0].Polar)]);
         res := AnalyseFile(True);
         WriteLog('SUMMARY STATISTIC:');
         If res_id > 0 then
            For i := 0 to res_id-1 do WriteLog('errors: '+IntToStr(Results[i].errors)+' filter: '+IntToHex(Results[i].filter,2)+' polarity: '+TxtPol[Ord(Results[i].Polar)]);
      end
   else
      begin
         WriteLn(#10#13#10#13'Sorry, no pilot tone or header found');
      end;

   WriteLn(#13#10'Done in ',GetTickCount - Timer,' ms!');
   If Log then Close(Flog);
end.
