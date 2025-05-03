    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst30opcode equ 48
rst30address equ 49
rst38opcode equ 56
rst38address equ 57
pressedkey equ 63321
cursor equ 63322
tapereadspeed equ 63324
tapewritespeed equ 63325
cursorvisible equ 63326
escstate equ 63327
keydelay equ 63328
regpc equ 63330
reghl equ 63332
regbc equ 63334
regde equ 63336
regsp equ 63338
regaf equ 63340
breakpointaddress equ 63345
breakpointvalue equ 63347
jmpparam1opcode equ 63348
param1 equ 63349
param2 equ 63351
param3 equ 63353
param2exists equ 63355
tapepolarity equ 63356
translatecodeenabled equ 63357
translatecodepagejump equ 63358
translatecodepageaddress equ 63359
ramtop equ 63361
inputbuffer equ 63363
jmpparam1 equ 63348
translatecodepage equ 63358
 .org 0xF800
; 52  uint8_t rst30Opcode __address(0x30);
; 53 extern uint16_t rst30Address __address(0x31);
; 54 extern uint8_t rst38Opcode __address(0x38);
; 55 extern uint16_t rst38Address __address(0x39);
; 56 
; 57 // Прототипы
; 58 void Reboot(...);
; 59 void EntryF86C_Monitor(...);
; 60 void Reboot2(...);
; 61 void Monitor(...);
; 62 void Monitor2();
; 63 void ReadStringBackspace(...);
; 64 void ReadString(...);
; 65 void ReadStringBegin(...);
; 66 void ReadStringLoop(...);
; 67 void ReadStringExit(...);
; 68 void PrintString(...);
; 69 void ParseParams(...);
; 70 void ParseWord(...);
; 71 void ParseWordReturnCf(...);
; 72 void CompareHlDe(...);
; 73 void LoopWithBreak(...);
; 74 void Loop(...);
; 75 void PopRet();
; 76 void IncHl(...);
; 77 void CtrlC(...);
; 78 void PrintCrLfTab();
; 79 void PrintHexByteFromHlSpace(...);
; 80 void PrintHexByteSpace(...);
; 81 void CmdR(...);
; 82 void GetRamTop(...);
; 83 void SetRamTop(...);
; 84 void CmdA(...);
; 85 void CmdD(...);
; 86 void PrintSpacesTo(...);
; 87 void PrintSpace();
; 88 void CmdC(...);
; 89 void CmdF(...);
; 90 void CmdS(...);
; 91 void CmdW(...);
; 92 void CmdT(...);
; 93 void CmdM(...);
; 94 void CmdG(...);
; 95 void BreakPointHandler(...);
; 96 void CmdX(...);
; 97 void GetCursor();
; 98 void GetCursorChar();
; 99 void CmdH(...);
; 100 void CmdI(...);
; 101 void MonitorError();
; 102 void ReadTapeFile(...);
; 103 void ReadTapeWordNext();
; 104 void ReadTapeWord(...);
; 105 void ReadTapeBlock(...);
; 106 void CalculateCheckSum(...);
; 107 void CmdO(...);
; 108 void WriteTapeFile(...);
; 109 void PrintCrLfTabHexWordSpace(...);
; 110 void PrintHexWordSpace(...);
; 111 void WriteTapeBlock(...);
; 112 void WriteTapeWord(...);
; 113 void ReadTapeByte(...);
; 114 void ReadTapeByteInternal(...);
; 115 void ReadTapeByteTimeout(...);
; 116 void WriteTapeByte(...);
; 117 void PrintHexByte(...);
; 118 void PrintHexNibble(...);
; 119 void PrintCharA(...);
; 120 void PrintChar(...);
; 121 void PrintCharSetEscState(...);
; 122 void PrintCharSaveCursor(...);
; 123 void PrintCharExit(...);
; 124 void DrawCursor(...);
; 125 void PrintCharEscY2(...);
; 126 void PrintCharResetEscState(...);
; 127 void PrintCharEsc(...);
; 128 void SetCursorVisible(...);
; 129 void PrintCharNoEsc(...);
; 130 void PrintChar4(...);
; 131 void ClearScreen(...);
; 132 void MoveCursorHome(...);
; 133 void PrintChar3(...);
; 134 void PrintCharBeep(...);
; 135 void MoveCursorCr(...);
; 136 void MoveCursorRight(...);
; 137 void MoveCursorBoundary(...);
; 138 void MoveCursorLeft(...);
; 139 void MoveCursorLf(...);
; 140 void MoveCursorUp(...);
; 141 void MoveCursor(...);
; 142 void MoveCursorDown(...);
; 143 void PrintCrLf();
; 144 void IsAnyKeyPressed();
; 145 void ReadKey();
; 146 void ReadKeyInternal(...);
; 147 void ScanKey();
; 148 void ScanKey2(...);
; 149 void ScanKeyExit(...);
; 150 void ScanKeyControl(...);
; 151 void ScanKeyShift(...);
; 152 void ScanKeySpecial(...);
; 153 void TranslateCodePageDefault(...);
; 154 
; 155 // Переменные Монитора
; 156 
; 157 extern uint8_t pressedKey __address(0xF759);
; 158 extern uint16_t cursor __address(0xF75A);
; 159 extern uint8_t tapeReadSpeed __address(0xF75C);
; 160 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 161 extern uint8_t cursorVisible __address(0xF75E);
; 162 extern uint8_t escState __address(0xF75F);
; 163 extern uint16_t keyDelay __address(0xF760);
; 164 extern uint16_t regPC __address(0xF762);
; 165 extern uint16_t regHL __address(0xF764);
; 166 extern uint16_t regBC __address(0xF766);
; 167 extern uint16_t regDE __address(0xF768);
; 168 extern uint16_t regSP __address(0xF76A);
; 169 extern uint16_t regAF __address(0xF76C);
; 170 extern uint16_t breakPointAddress __address(0xF771);
; 171 extern uint8_t breakPointValue __address(0xF773);
; 172 extern uint8_t jmpParam1Opcode __address(0xF774);
; 173 extern uint16_t param1 __address(0xF775);
; 174 extern uint16_t param2 __address(0xF777);
; 175 extern uint16_t param3 __address(0xF779);
; 176 extern uint8_t param2Exists __address(0xF77B);
; 177 extern uint8_t tapePolarity __address(0xF77C);
; 178 extern uint8_t translateCodeEnabled __address(0xF77D);
; 179 extern uint8_t translateCodePageJump __address(0xF77E);
; 180 extern uint16_t translateCodePageAddress __address(0xF77F);
; 181 extern uint16_t ramTop __address(0xF781);
; 182 extern uint8_t inputBuffer[32] __address(0xF783);
; 183 
; 184 extern uint8_t specialKeyTable[8];
; 185 extern uint8_t aPrompt[6];
; 186 extern uint8_t aCrLfTab[6];
; 187 extern uint8_t aRegisters[37];
; 188 extern uint8_t aBackspace[4];
; 189 extern uint8_t aHello[9];
; 190 
; 191 // Для удобства
; 192 
; 193 void JmpParam1() __address(0xF774);
; 194 void TranslateCodePage() __address(0xF77E);
; 195 
; 196 // Точки входа
; 197 
; 198 void EntryF800_Reboot() {
entryf800_reboot:
; 199     Reboot();
	jp reboot
; 200 }
; 201 
; 202 void EntryF803_ReadKey() {
entryf803_readkey:
; 203     ReadKey();
	jp readkey
; 204 }
; 205 
; 206 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 207     ReadTapeByte(a);
	jp readtapebyte
; 208 }
; 209 
; 210 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 211     PrintChar(c);
	jp printchar
; 212 }
; 213 
; 214 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 215     WriteTapeByte(c);
	jp writetapebyte
; 216 }
; 217 
; 218 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 219     TranslateCodePage(c);
	jp translatecodepage
; 220 }
; 221 
; 222 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 223     IsAnyKeyPressed();
	jp isanykeypressed
; 224 }
; 225 
; 226 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 227     PrintHexByte(a);
	jp printhexbyte
; 228 }
; 229 
; 230 void EntryF818_PrintString(...) {
entryf818_printstring:
; 231     PrintString(hl);
	jp printstring
; 232 }
; 233 
; 234 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 235     ScanKey();
	jp scankey
; 236 }
; 237 
; 238 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 239     GetCursor();
	jp getcursor
; 240 }
; 241 
; 242 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 243     GetCursorChar();
	jp getcursorchar
; 244 }
; 245 
; 246 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 247     ReadTapeFile(hl);
	jp readtapefile
; 248 }
; 249 
; 250 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 251     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 252 }
; 253 
; 254 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 255     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 256 }
; 257 
; 258 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
	ret
; 259 }
; 260 
; 261 uint16_t empty = 0;
empty:
	dw 0
; 263  EntryF830_GetRamTop() {
entryf830_getramtop:
; 264     GetRamTop();
	jp getramtop
; 265 }
; 266 
; 267 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 268     SetRamTop(hl);
	jp setramtop
; 269 }
; 270 
; 271 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 272 // Параметры: нет. Функция никогда не завершается.
; 273 
; 274 void Reboot(...) {
reboot:
; 275     sp = STACK_TOP;
	ld sp, 63488
; 276 
; 277     // Очистка памяти
; 278     hl = &tapeWriteSpeed;
	ld hl, 0FFFFh & (tapewritespeed)
; 279     de = inputBuffer + sizeof(inputBuffer) - 1;
	ld de, 0FFFFh & (((inputbuffer) + (32)) - (1))
; 280     bc = 0;
	ld bc, 0
; 281     CmdF();
	call cmdf
; 282 
; 283     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 284 
; 285     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 286 
; 287     // Проверка ОЗУ
; 288     hl = 0;
	ld hl, 0
; 289     for (;;) {
l_1:
; 290         c = *hl;
	ld c, (hl)
; 291         a = 0x55;
	ld a, 85
; 292         *hl = a;
	ld (hl), a
; 293         a ^= *hl;
	xor (hl)
; 294         b = a;
	ld b, a
; 295         a = 0xAA;
	ld a, 170
; 296         *hl = a;
	ld (hl), a
; 297         a ^= *hl;
	xor (hl)
; 298         a |= b;
	or b
; 299         if (flag_nz)
; 300             return Reboot2();
	jp nz, reboot2
; 301         *hl = c;
	ld (hl), c
; 302         hl++;
	inc hl
; 303         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 304             return Reboot2();
	jp z, reboot2
	jp l_1
; 305     }
; 306 
; 307     Reboot2();
	jp reboot2
 .org 0xF86C
; 308 }
; 309 
; 310 asm(" .org 0xF86C");
; 311 
; 312 void EntryF86C_Monitor() {
entryf86c_monitor:
; 313     return Monitor();
	jp monitor
; 314 }
; 315 
; 316 void Reboot2(...) {
reboot2:
; 317     hl--;
	dec hl
; 318     ramTop = hl;
	ld (ramtop), hl
; 319     PrintHexWordSpace(hl);
	call printhexwordspace
; 320     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 321     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 322     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 323     Monitor();
; 324 }
; 325 
; 326 void Monitor() {
monitor:
; 327     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 328     cursorVisible = a;
	ld (cursorvisible), a
; 329     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 330     Monitor2();
; 331 }
; 332 
; 333 void Monitor2() {
monitor2:
; 334     sp = STACK_TOP;
	ld sp, 63488
; 335     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 336     ReadString();
	call readstring
; 337 
; 338     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 339 
; 340     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 341     a = *hl;
	ld a, (hl)
; 342 
; 343     if (a == 'X')
	cp 88
; 344         return CmdX();
	jp z, cmdx
; 345 
; 346     push_pop(a) {
	push af
; 347         ParseParams();
	call parseparams
; 348         hl = param3;
	ld hl, (param3)
; 349         c = l;
	ld c, l
; 350         b = h;
	ld b, h
; 351         hl = param2;
	ld hl, (param2)
; 352         swap(hl, de);
	ex hl, de
; 353         hl = param1;
	ld hl, (param1)
	pop af
; 354     }
; 355 
; 356     if (a == 'D')
	cp 68
; 357         return CmdD();
	jp z, cmdd
; 358     if (a == 'C')
	cp 67
; 359         return CmdC();
	jp z, cmdc
; 360     if (a == 'F')
	cp 70
; 361         return CmdF();
	jp z, cmdf
; 362     if (a == 'S')
	cp 83
; 363         return CmdS();
	jp z, cmds
; 364     if (a == 'T')
	cp 84
; 365         return CmdT();
	jp z, cmdt
; 366     if (a == 'M')
	cp 77
; 367         return CmdM();
	jp z, cmdm
; 368     if (a == 'G')
	cp 71
; 369         return CmdG();
	jp z, cmdg
; 370     if (a == 'I')
	cp 73
; 371         return CmdI();
	jp z, cmdi
; 372     if (a == 'O')
	cp 79
; 373         return CmdO();
	jp z, cmdo
; 374     if (a == 'W')
	cp 87
; 375         return CmdW();
	jp z, cmdw
; 376     if (a == 'A')
	cp 65
; 377         return CmdA();
	jp z, cmda
; 378     if (a == 'H')
	cp 72
; 379         return CmdH();
	jp z, cmdh
; 380     if (a == 'R')
	cp 82
; 381         return CmdR();
	jp z, cmdr
; 382     return MonitorError();
	jp monitorerror
; 383 }
; 384 
; 385 void ReadStringBackspace(...) {
readstringbackspace:
; 386     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 387         return ReadStringBegin(hl);
	jp z, readstringbegin
; 388     push_pop(hl) {
	push hl
; 389         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 390     }
; 391     hl--;
	dec hl
; 392     return ReadStringLoop(b, hl);
	jp readstringloop
; 393 }
; 394 
; 395 void ReadString() {
readstring:
; 396     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 397     ReadStringBegin(hl);
; 398 }
; 399 
; 400 void ReadStringBegin(...) {
readstringbegin:
; 401     b = 0;
	ld b, 0
; 402     ReadStringLoop(b, hl);
; 403 }
; 404 
; 405 void ReadStringLoop(...) {
readstringloop:
; 406     for (;;) {
l_4:
; 407         ReadKey();
	call readkey
; 408         if (a == 127)
	cp 127
; 409             return ReadStringBackspace();
	jp z, readstringbackspace
; 410         if (a == 8)
	cp 8
; 411             return ReadStringBackspace();
	jp z, readstringbackspace
; 412         if (flag_nz)
; 413             PrintCharA(a);
	call nz, printchara
; 414         *hl = a;
	ld (hl), a
; 415         if (a == 13)
	cp 13
; 416             return ReadStringExit(b);
	jp z, readstringexit
; 417         if (a == '.')
	cp 46
; 418             return Monitor2();
	jp z, monitor2
; 419         b = 255;
	ld b, 255
; 420         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 421             return MonitorError();
	jp z, monitorerror
; 422         hl++;
	inc hl
	jp l_4
; 423     }
; 424 }
; 425 
; 426 void ReadStringExit(...) {
readstringexit:
; 427     a = b;
	ld a, b
; 428     carry_rotate_left(a, 1);
	rla
; 429     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 430     b = 0;
	ld b, 0
	ret
; 431 }
; 432 
; 433 // Функция для пользовательской программы.
; 434 // Вывод строки на экран.
; 435 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 436 
; 437 void PrintString(...) {
printstring:
; 438     for (;;) {
l_7:
; 439         a = *hl;
	ld a, (hl)
; 440         if (flag_z(a &= a))
	and a
; 441             return;
	ret z
; 442         PrintCharA(a);
	call printchara
; 443         hl++;
	inc hl
	jp l_7
; 444     }
; 445 }
; 446 
; 447 void ParseParams(...) {
parseparams:
; 448     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 449     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 450     c = 0;
	ld c, 0
; 451     CmdF();
	call cmdf
; 452 
; 453     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 454 
; 455     ParseWord();
	call parseword
; 456     param1 = hl;
	ld (param1), hl
; 457     param2 = hl;
	ld (param2), hl
; 458     if (flag_c)
; 459         return;
	ret c
; 460 
; 461     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 462     ParseWord();
	call parseword
; 463     param2 = hl;
	ld (param2), hl
; 464     if (flag_c)
; 465         return;
	ret c
; 466 
; 467     ParseWord();
	call parseword
; 468     param3 = hl;
	ld (param3), hl
; 469     if (flag_c)
; 470         return;
	ret c
; 471 
; 472     MonitorError();
	jp monitorerror
; 473 }
; 474 
; 475 void ParseWord(...) {
parseword:
; 476     hl = 0;
	ld hl, 0
; 477     for (;;) {
l_10:
; 478         a = *de;
	ld a, (de)
; 479         de++;
	inc de
; 480         if (a == 13)
	cp 13
; 481             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 482         if (a == ',')
	cp 44
; 483             return;
	ret z
; 484         if (a == ' ')
	cp 32
; 485             continue;
	jp z, l_10
; 486         a -= '0';
	sub 48
; 487         if (flag_m)
; 488             return MonitorError();
	jp m, monitorerror
; 489         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 490             if (flag_m(compare(a, 17)))
	cp 17
; 491                 return MonitorError();
	jp m, monitorerror
; 492             if (flag_p(compare(a, 23)))
	cp 23
; 493                 return MonitorError();
	jp p, monitorerror
; 494             a -= 7;
	sub 7
l_12:
; 495         }
; 496         c = a;
	ld c, a
; 497         hl += hl;
	add hl, hl
; 498         hl += hl;
	add hl, hl
; 499         hl += hl;
	add hl, hl
; 500         hl += hl;
	add hl, hl
; 501         if (flag_c)
; 502             return MonitorError();
	jp c, monitorerror
; 503         hl += bc;
	add hl, bc
	jp l_10
; 504     }
; 505 }
; 506 
; 507 void ParseWordReturnCf(...) {
parsewordreturncf:
; 508     set_flag_c();
	scf
	ret
; 509 }
; 510 
; 511 void CompareHlDe(...) {
comparehlde:
; 512     if ((a = h) != d)
	ld a, h
	cp d
; 513         return;
	ret nz
; 514     compare(a = l, e);
	ld a, l
	cp e
	ret
; 515 }
; 516 
; 517 void LoopWithBreak(...) {
loopwithbreak:
; 518     CtrlC();
	call ctrlc
; 519     Loop(hl, de);
; 520 }
; 521 
; 522 void Loop(...) {
loop:
; 523     CompareHlDe(hl, de);
	call comparehlde
; 524     if (flag_nz)
; 525         return IncHl(hl);
	jp nz, inchl
; 526     PopRet();
; 527 }
; 528 
; 529 void PopRet() {
popret:
; 530     sp++;
	inc sp
; 531     sp++;
	inc sp
	ret
; 532 }
; 533 
; 534 void IncHl(...) {
inchl:
; 535     hl++;
	inc hl
	ret
; 536 }
; 537 
; 538 void CtrlC() {
ctrlc:
; 539     ScanKey();
	call scankey
; 540     if (a != 3)  // УПР + C
	cp 3
; 541         return;
	ret nz
; 542     MonitorError();
	jp monitorerror
; 543 }
; 544 
; 545 void PrintCrLfTab() {
printcrlftab:
; 546     push_pop(hl) {
	push hl
; 547         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 548     }
; 549 }
; 550 
; 551 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 552     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 553 }
; 554 
; 555 void PrintHexByteSpace(...) {
printhexbytespace:
; 556     push_pop(bc) {
	push bc
; 557         PrintHexByte(a);
	call printhexbyte
; 558         PrintSpace();
	call printspace
	pop bc
	ret
; 559     }
; 560 }
; 561 
; 562 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 563 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 564 
; 565 void CmdR(...) {
cmdr:
; 566     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 567     for (;;) {
l_15:
; 568         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 569         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 570         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 571         bc++;
	inc bc
; 572         Loop();
	call loop
	jp l_15
; 573     }
; 574 }
; 575 
; 576 // Функция для пользовательской программы.
; 577 // Получить адрес последнего доступного байта оперативной памяти.
; 578 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 579 
; 580 void GetRamTop(...) {
getramtop:
; 581     hl = ramTop;
	ld hl, (ramtop)
	ret
; 582 }
; 583 
; 584 // Функция для пользовательской программы.
; 585 // Установить адрес последнего доступного байта оперативной памяти.
; 586 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 587 
; 588 void SetRamTop(...) {
setramtop:
; 589     ramTop = hl;
	ld (ramtop), hl
	ret
; 590 }
; 591 
; 592 // Команда A <адрес>
; 593 // Установить программу преобразования кодировки символов выводимых на экран
; 594 
; 595 void CmdA(...) {
cmda:
; 596     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 597 }
; 598 
; 599 // Команда D <начальный адрес> <конечный адрес>
; 600 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 601 
; 602 void CmdD(...) {
cmdd:
; 603     for (;;) {
l_18:
; 604         PrintCrLf();
	call printcrlf
; 605         PrintHexWordSpace(hl);
	call printhexwordspace
; 606         push_pop(hl) {
	push hl
; 607             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 608             carry_rotate_right(a, 1);
	rra
; 609             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 610             PrintSpacesTo();
	call printspacesto
; 611             do {
l_20:
; 612                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 613                 CompareHlDe(hl, de);
	call comparehlde
; 614                 hl++;
	inc hl
; 615                 if (flag_z)
; 616                     break;
	jp z, l_22
; 617                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 618                 push_pop(a) {
	push af
; 619                     a &= 1;
	and 1
; 620                     if (flag_z)
; 621                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 622                 }
; 623             } while (flag_nz);
; 624         }
; 625 
; 626         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 627         PrintSpacesTo(b);
	call printspacesto
; 628 
; 629         do {
l_23:
; 630             a = *hl;
	ld a, (hl)
; 631             if (a < 127)
	cp 127
; 632                 if (a >= 32)
	jp nc, l_26
	cp 32
; 633                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 634             a = '.';
	ld a, 46
; 635         loc_fa49:
loc_fa49:
; 636             PrintCharA(a);
	call printchara
; 637             CompareHlDe(hl, de);
	call comparehlde
; 638             if (flag_z)
; 639                 return;
	ret z
; 640             hl++;
	inc hl
; 641             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 642         } while (flag_nz);
; 643     }
; 644 }
; 645 
; 646 void PrintSpacesTo(...) {
printspacesto:
; 647     for (;;) {
l_29:
; 648         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 649             return;
	ret nc
; 650         PrintSpace();
	call printspace
	jp l_29
; 651     }
; 652 }
; 653 
; 654 void PrintSpace() {
printspace:
; 655     return PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 656 }
; 657 
; 658 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 659 // Сравнить два блока адресного пространство
; 660 
; 661 void CmdC(...) {
cmdc:
; 662     for (;;) {
l_32:
; 663         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 664             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 665             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 666             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 667         }
; 668         bc++;
	inc bc
; 669         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 670     }
; 671 }
; 672 
; 673 // Команда F <начальный адрес> <конечный адрес> <байт>
; 674 // Заполнить блок в адресном пространстве одним байтом
; 675 
; 676 void CmdF(...) {
cmdf:
; 677     for (;;) {
l_37:
; 678         *hl = c;
	ld (hl), c
; 679         Loop();
	call loop
	jp l_37
; 680     }
; 681 }
; 682 
; 683 // Команда S <начальный адрес> <конечный адрес> <байт>
; 684 // Найти байт (8 битное значение) в адресном пространстве
; 685 
; 686 void CmdS(...) {
cmds:
; 687     for (;;) {
l_40:
; 688         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 689             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 690         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 691     }
; 692 }
; 693 
; 694 // Команда W <начальный адрес> <конечный адрес> <слово>
; 695 // Найти слово (16 битное значение) в адресном пространстве
; 696 
; 697 void CmdW(...) {
cmdw:
; 698     for (;;) {
l_43:
; 699         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 700             hl++;
	inc hl
; 701             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 702             hl--;
	dec hl
; 703             if (flag_z)
; 704                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 705         }
; 706         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 707     }
; 708 }
; 709 
; 710 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 711 // Копировать блок в адресном пространстве
; 712 
; 713 void CmdT(...) {
cmdt:
; 714     for (;;) {
l_48:
; 715         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 716         bc++;
	inc bc
; 717         Loop();
	call loop
	jp l_48
; 718     }
; 719 }
; 720 
; 721 // Команда M <начальный адрес>
; 722 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 723 
; 724 void CmdM(...) {
cmdm:
; 725     for (;;) {
l_51:
; 726         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 727         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 728         push_pop(hl) {
	push hl
; 729             ReadString();
	call readstring
	pop hl
; 730         }
; 731         if (flag_c) {
	jp nc, l_53
; 732             push_pop(hl) {
	push hl
; 733                 ParseWord();
	call parseword
; 734                 a = l;
	ld a, l
	pop hl
; 735             }
; 736             *hl = a;
	ld (hl), a
l_53:
; 737         }
; 738         hl++;
	inc hl
	jp l_51
; 739     }
; 740 }
; 741 
; 742 // Команда G <начальный адрес> <конечный адрес>
; 743 // Запуск программы и возможным указанием точки останова.
; 744 
; 745 void CmdG(...) {
cmdg:
; 746     CompareHlDe(hl, de);
	call comparehlde
; 747     if (flag_nz) {
	jp z, l_55
; 748         swap(hl, de);
	ex hl, de
; 749         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 750         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 751         *hl = OPCODE_RST_30;
	ld (hl), 247
; 752         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 753         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 754     }
; 755     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 756     pop(bc);
	pop bc
; 757     pop(de);
	pop de
; 758     pop(hl);
	pop hl
; 759     pop(a);
	pop af
; 760     sp = hl;
	ld sp, hl
; 761     hl = regHL;
	ld hl, (reghl)
; 762     return JmpParam1();
	jp jmpparam1
; 763 }
; 764 
; 765 void BreakPointHandler(...) {
breakpointhandler:
; 766     regHL = hl;
	ld (reghl), hl
; 767     push(a);
	push af
; 768     pop(hl);
	pop hl
; 769     regAF = hl;
	ld (regaf), hl
; 770     pop(hl);
	pop hl
; 771     hl--;
	dec hl
; 772     regPC = hl;
	ld (regpc), hl
; 773     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 774     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 775     push(hl);
	push hl
; 776     push(de);
	push de
; 777     push(bc);
	push bc
; 778     sp = STACK_TOP;
	ld sp, 63488
; 779     hl = regPC;
	ld hl, (regpc)
; 780     swap(hl, de);
	ex hl, de
; 781     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 782     CompareHlDe(hl, de);
	call comparehlde
; 783     if (flag_nz)
; 784         return CmdX();
	jp nz, cmdx
; 785     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 786     CmdX();
; 787 }
; 788 
; 789 // Команда X
; 790 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 791 
; 792 void CmdX(...) {
cmdx:
; 793     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 794     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 795     b = 6;
	ld b, 6
; 796     do {
l_57:
; 797         e = *hl;
	ld e, (hl)
; 798         hl++;
	inc hl
; 799         d = *hl;
	ld d, (hl)
; 800         push(bc);
	push bc
; 801         push(hl);
	push hl
; 802         swap(hl, de);
	ex hl, de
; 803         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 804         ReadString();
	call readstring
; 805         if (flag_c) {
	jp nc, l_60
; 806             ParseWord();
	call parseword
; 807             pop(de);
	pop de
; 808             push(de);
	push de
; 809             swap(hl, de);
	ex hl, de
; 810             *hl = d;
	ld (hl), d
; 811             hl--;
	dec hl
; 812             *hl = e;
	ld (hl), e
l_60:
; 813         }
; 814         pop(hl);
	pop hl
; 815         pop(bc);
	pop bc
; 816         b--;
	dec b
; 817         hl++;
	inc hl
l_58:
	jp nz, l_57
; 818     } while (flag_nz);
; 819     EntryF86C_Monitor();
	jp entryf86c_monitor
; 820 }
; 821 
; 822 // Функция для пользовательской программы.
; 823 // Получить координаты курсора.
; 824 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 825 
; 826 void GetCursor() {
getcursor:
; 827     push_pop(a) {
	push af
; 828         hl = cursor;
	ld hl, (cursor)
; 829         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 830 
; 831         // Вычисление X
; 832         a = l;
	ld a, l
; 833         a &= (SCREEN_WIDTH - 1);
	and 63
; 834         a += 8;  // Смещение Радио 86РК
	add 8
; 835 
; 836         // Вычисление Y
; 837         hl += hl;
	add hl, hl
; 838         hl += hl;
	add hl, hl
; 839         h++;  // Смещение Радио 86РК
	inc h
; 840         h++;
	inc h
; 841         h++;
	inc h
; 842 
; 843         l = a;
	ld l, a
	pop af
	ret
; 844     }
; 845 }
; 846 
; 847 // Функция для пользовательской программы.
; 848 // Получить символ под курсором.
; 849 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 850 
; 851 void GetCursorChar() {
getcursorchar:
; 852     push_pop(hl) {
	push hl
; 853         hl = cursor;
	ld hl, (cursor)
; 854         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 855     }
; 856 }
; 857 
; 858 // Команда H
; 859 // Определить скорости записанной программы.
; 860 // Выводит 4 цифры на экран.
; 861 // Первые две цифры - константа вывода для команды O
; 862 // Последние две цифры - константа вввода для команды I
; 863 
; 864 void CmdH(...) {
cmdh:
; 865     PrintCrLfTab();
	call printcrlftab
; 866     hl = 65408;
	ld hl, 65408
; 867     b = 123;
	ld b, 123
; 868 
; 869     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 870 
; 871     do {
l_62:
l_63:
; 872     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 873 
; 874     do {
l_65:
; 875         c = a;
	ld c, a
; 876         do {
l_68:
; 877             hl++;
	inc hl
l_69:
; 878         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 879     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 880 
; 881     hl += hl;
	add hl, hl
; 882     a = h;
	ld a, h
; 883     hl += hl;
	add hl, hl
; 884     l = (a += h);
	add h
	ld l, a
; 885 
; 886     PrintHexWordSpace();
	jp printhexwordspace
; 887 }
; 888 
; 889 // Команда I <смещение> <скорость>
; 890 // Загрузить файл с магнитной ленты
; 891 
; 892 void CmdI(...) {
cmdi:
; 893     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 894         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 895     ReadTapeFile();
	call readtapefile
; 896     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 897     swap(hl, de);
	ex hl, de
; 898     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 899     swap(hl, de);
	ex hl, de
; 900     push(bc);
	push bc
; 901     CalculateCheckSum();
	call calculatechecksum
; 902     h = b;
	ld h, b
; 903     l = c;
	ld l, c
; 904     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 905     pop(de);
	pop de
; 906     CompareHlDe(hl, de);
	call comparehlde
; 907     if (flag_z)
; 908         return;
	ret z
; 909     swap(hl, de);
	ex hl, de
; 910     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 911     MonitorError();
; 912 }
; 913 
; 914 void MonitorError() {
monitorerror:
; 915     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 916     Monitor2();
	jp monitor2
; 917 }
; 918 
; 919 // Функция для пользовательской программы.
; 920 // Загрузить файл с магнитной ленты.
; 921 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 922 
; 923 void ReadTapeFile(...) {
readtapefile:
; 924     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 925     push_pop(hl) {
	push hl
; 926         hl += bc;
	add hl, bc
; 927         swap(hl, de);
	ex hl, de
; 928         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 929     }
; 930     hl += bc;
	add hl, bc
; 931     swap(hl, de);
	ex hl, de
; 932 
; 933     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 934     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 935     if (flag_z)
; 936         return;
	ret z
; 937 
; 938     push_pop(hl) {
	push hl
; 939         ReadTapeBlock();
	call readtapeblock
; 940         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 941     }
; 942 }
; 943 
; 944 void ReadTapeWordNext() {
readtapewordnext:
; 945     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 946 }
; 947 
; 948 void ReadTapeWord(...) {
readtapeword:
; 949     ReadTapeByte(a);
	call readtapebyte
; 950     b = a;
	ld b, a
; 951     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 952     c = a;
	ld c, a
	ret
; 953 }
; 954 
; 955 void ReadTapeBlock(...) {
readtapeblock:
; 956     for (;;) {
l_74:
; 957         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 958         *hl = a;
	ld (hl), a
; 959         Loop();
	call loop
	jp l_74
; 960     }
; 961 }
; 962 
; 963 // Функция для пользовательской программы.
; 964 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 965 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 966 
; 967 void CalculateCheckSum(...) {
calculatechecksum:
; 968     bc = 0;
	ld bc, 0
; 969     for (;;) {
l_77:
; 970         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 971         push_pop(a) {
	push af
; 972             CompareHlDe(hl, de);
	call comparehlde
; 973             if (flag_z)
; 974                 return PopRet();
	jp z, popret
	pop af
; 975         }
; 976         a = b;
	ld a, b
; 977         carry_add(a, *hl);
	adc (hl)
; 978         b = a;
	ld b, a
; 979         Loop();
	call loop
	jp l_77
; 980     }
; 981 }
; 982 
; 983 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 984 // Сохранить блок данных на магнитную ленту
; 985 
; 986 void CmdO(...) {
cmdo:
; 987     if ((a = c) != 0)
	ld a, c
	or a
; 988         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 989     push_pop(hl) {
	push hl
; 990         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 991     }
; 992     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 993     swap(hl, de);
	ex hl, de
; 994     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 995     swap(hl, de);
	ex hl, de
; 996     push_pop(hl) {
	push hl
; 997         h = b;
	ld h, b
; 998         l = c;
	ld l, c
; 999         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1000     }
; 1001     WriteTapeFile(hl, de);
; 1002 }
; 1003 
; 1004 // Функция для пользовательской программы.
; 1005 // Запись файла на магнитную ленту.
; 1006 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1007 
; 1008 void WriteTapeFile(...) {
writetapefile:
; 1009     push(bc);
	push bc
; 1010     bc = 0;
	ld bc, 0
; 1011     do {
l_81:
; 1012         WriteTapeByte(c);
	call writetapebyte
; 1013         b--;
	dec b
; 1014         swap(hl, *sp);
	ex (sp), hl
; 1015         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1016     } while (flag_nz);
; 1017     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1018     WriteTapeWord(hl);
	call writetapeword
; 1019     swap(hl, de);
	ex hl, de
; 1020     WriteTapeWord(hl);
	call writetapeword
; 1021     swap(hl, de);
	ex hl, de
; 1022     WriteTapeBlock(hl, de);
	call writetapeblock
; 1023     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1024     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1025     pop(hl);
	pop hl
; 1026     WriteTapeWord(hl);
	call writetapeword
; 1027     return;
	ret
; 1028 }
; 1029 
; 1030 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1031     push_pop(bc) {
	push bc
; 1032         PrintCrLfTab();
	call printcrlftab
; 1033         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1034     }
; 1035 }
; 1036 
; 1037 void PrintHexWordSpace(...) {
printhexwordspace:
; 1038     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1039     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1040 }
; 1041 
; 1042 void WriteTapeBlock(...) {
writetapeblock:
; 1043     for (;;) {
l_85:
; 1044         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1045         Loop();
	call loop
	jp l_85
; 1046     }
; 1047 }
; 1048 
; 1049 void WriteTapeWord(...) {
writetapeword:
; 1050     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1051     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1052 }
; 1053 
; 1054 // Загрузка байта с магнитной ленты.
; 1055 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1056 // Результат: a = прочитанный байт.
; 1057 
; 1058 void ReadTapeByte(...) {
readtapebyte:
; 1059     push(hl, bc, de);
	push hl
	push bc
	push de
; 1060     d = a;
	ld d, a
; 1061     ReadTapeByteInternal(d);
; 1062 }
; 1063 
; 1064 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1065     c = 0;
	ld c, 0
; 1066     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1067     do {
l_87:
; 1068     retry:  // Сдвиг результата
retry:
; 1069         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1070         cyclic_rotate_left(a, 1);
	rlca
; 1071         c = a;
	ld c, a
; 1072 
; 1073         // Ожидание изменения бита
; 1074         h = 0;
	ld h, 0
; 1075         do {
l_90:
; 1076             h--;
	dec h
; 1077             if (flag_z)
; 1078                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1079         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1080 
; 1081         // Сохранение бита
; 1082         c = (a |= c);
	or c
	ld c, a
; 1083 
; 1084         // Задержка
; 1085         d--;
	dec d
; 1086         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1087         if (flag_z)
; 1088             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1089         b = a;
	ld b, a
; 1090         do {
l_95:
l_96:
; 1091         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1092         d++;
	inc d
; 1093 
; 1094         // Новое значение бита
; 1095         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1096 
; 1097         // Режим поиска синхробайта
; 1098         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1099             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1100                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1101             } else {
; 1102                 if (a != ~TAPE_START)
	cp 65305
; 1103                     goto retry;
	jp nz, retry
; 1104                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1105             }
; 1106             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1107         }
; 1108     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1109     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1110     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1111 }
; 1112 
; 1113 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1114     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1115         return MonitorError();
	jp p, monitorerror
; 1116     CtrlC();
	call ctrlc
; 1117     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1118 }
; 1119 
; 1120 // Функция для пользовательской программы.
; 1121 // Запись байта на магнитную ленту.
; 1122 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1123 
; 1124 void WriteTapeByte(...) {
writetapebyte:
; 1125     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1126         d = 8;
	ld d, 8
; 1127         do {
l_102:
; 1128             // Сдвиг исходного байта
; 1129             a = c;
	ld a, c
; 1130             cyclic_rotate_left(a, 1);
	rlca
; 1131             c = a;
	ld c, a
; 1132 
; 1133             // Вывод
; 1134             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1135             out(PORT_TAPE, a);
	out (1), a
; 1136 
; 1137             // Задержка
; 1138             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1139             do {
l_105:
; 1140                 b--;
	dec b
l_106:
	jp nz, l_105
; 1141             } while (flag_nz);
; 1142 
; 1143             // Вывод
; 1144             (a = 0) ^= c;
	ld a, 0
	xor c
; 1145             out(PORT_TAPE, a);
	out (1), a
; 1146 
; 1147             // Задержка
; 1148             d--;
	dec d
; 1149             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1150             if (flag_z)
; 1151                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1152             b = a;
	ld b, a
; 1153             do {
l_110:
; 1154                 b--;
	dec b
l_111:
	jp nz, l_110
; 1155             } while (flag_nz);
; 1156             d++;
	inc d
l_103:
; 1157         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1158     }
; 1159 }
; 1160 
; 1161 // Функция для пользовательской программы.
; 1162 // Вывод 8 битного числа на экран.
; 1163 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1164 
; 1165 void PrintHexByte(...) {
printhexbyte:
; 1166     push_pop(a) {
	push af
; 1167         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1168         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1169     }
; 1170     PrintHexNibble(a);
; 1171 }
; 1172 
; 1173 void PrintHexNibble(...) {
printhexnibble:
; 1174     a &= 0x0F;
	and 15
; 1175     if (flag_p(compare(a, 10)))
	cp 10
; 1176         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1177     a += '0';
	add 48
; 1178     PrintCharA(a);
; 1179 }
; 1180 
; 1181 // Вывод символа на экран.
; 1182 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1183 
; 1184 void PrintCharA(...) {
printchara:
; 1185     PrintChar(c = a);
	ld c, a
; 1186 }
; 1187 
; 1188 // Функция для пользовательской программы.
; 1189 // Вывод символа на экран.
; 1190 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1191 
; 1192 void PrintChar(...) {
printchar:
; 1193     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1194     IsAnyKeyPressed();
	call isanykeypressed
; 1195     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1196     hl = cursor;
	ld hl, (cursor)
; 1197     a = escState;
	ld a, (escstate)
; 1198     a--;
	dec a
; 1199     if (flag_m)
; 1200         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1201     if (flag_z)
; 1202         return PrintCharEsc();
	jp z, printcharesc
; 1203     a--;
	dec a
; 1204     if (flag_nz)
; 1205         return PrintCharEscY2();
	jp nz, printcharescy2
; 1206 
; 1207     // Первый параметр ESC Y
; 1208     a = c;
	ld a, c
; 1209     a -= ' ';
	sub 32
; 1210     if (flag_m) {
	jp p, l_115
; 1211         a ^= a;
	xor a
	jp l_116
l_115:
; 1212     } else {
; 1213         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1214             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1215     }
; 1216     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1217     c = a;
	ld c, a
; 1218     b = (a &= 192);
	and 192
	ld b, a
; 1219     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1220     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1221     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1222     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1223 }
; 1224 
; 1225 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1226     escState = a;
	ld (escstate), a
; 1227     PrintCharSaveCursor(hl);
; 1228 }
; 1229 
; 1230 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1231     cursor = hl;
	ld (cursor), hl
; 1232     PrintCharExit();
; 1233 }
; 1234 
; 1235 void PrintCharExit(...) {
printcharexit:
; 1236     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1237     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1238 }
; 1239 
; 1240 void DrawCursor(...) {
drawcursor:
; 1241     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1242         return;
	ret z
; 1243     hl = cursor;
	ld hl, (cursor)
; 1244     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1245     *hl = b;
	ld (hl), b
	ret
; 1246 }
; 1247 
; 1248 void PrintCharEscY2(...) {
printcharescy2:
; 1249     a = c;
	ld a, c
; 1250     a -= ' ';
	sub 32
; 1251     if (flag_m) {
	jp p, l_119
; 1252         a ^= a;
	xor a
	jp l_120
l_119:
; 1253     } else {
; 1254         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1255             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1256     }
; 1257     b = a;
	ld b, a
; 1258     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1259     PrintCharResetEscState();
; 1260 }
; 1261 
; 1262 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1263     a ^= a;
	xor a
; 1264     return PrintCharSetEscState();
	jp printcharsetescstate
; 1265 }
; 1266 
; 1267 void PrintCharEsc(...) {
printcharesc:
; 1268     a = c;
	ld a, c
; 1269     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1270         a = 2;
	ld a, 2
; 1271         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1272     }
; 1273     if (a == 97) {
	cp 97
	jp nz, l_125
; 1274         a ^= a;
	xor a
; 1275         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1276     }
; 1277     if (a != 98)
	cp 98
; 1278         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1279     SetCursorVisible();
; 1280 }
; 1281 
; 1282 void SetCursorVisible(...) {
setcursorvisible:
; 1283     cursorVisible = a;
	ld (cursorvisible), a
; 1284     return PrintCharResetEscState();
	jp printcharresetescstate
; 1285 }
; 1286 
; 1287 void PrintCharNoEsc(...) {
printcharnoesc:
; 1288     // Остановка вывода нажатием УС + Шифт
; 1289     do {
l_127:
; 1290         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1291     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1292 
; 1293     compare(a = 16, c);
	ld a, 16
	cp c
; 1294     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1295     if (flag_z) {
	jp nz, l_130
; 1296         invert(a);
	cpl
; 1297         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1298         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1299     }
; 1300     if (a != 0)
	or a
; 1301         TranslateCodePage(c);
	call nz, translatecodepage
; 1302     a = c;
	ld a, c
; 1303     if (a == 31)
	cp 31
; 1304         return ClearScreen();
	jp z, clearscreen
; 1305     if (flag_m)
; 1306         return PrintChar3(a);
	jp m, printchar3
; 1307     PrintChar4(a);
; 1308 }
; 1309 
; 1310 void PrintChar4(...) {
printchar4:
; 1311     *hl = a;
	ld (hl), a
; 1312     hl++;
	inc hl
; 1313     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1314         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1315     PrintCrLf();
	call printcrlf
; 1316     PrintCharExit();
	jp printcharexit
; 1317 }
; 1318 
; 1319 void ClearScreen(...) {
clearscreen:
; 1320     b = ' ';
	ld b, 32
; 1321     a = SCREEN_END >> 8;
	ld a, 240
; 1322     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1323     do {
l_132:
; 1324         *hl = b;
	ld (hl), b
; 1325         hl++;
	inc hl
; 1326         *hl = b;
	ld (hl), b
; 1327         hl++;
	inc hl
l_133:
; 1328     } while (a != h);
	cp h
	jp nz, l_132
; 1329     MoveCursorHome();
; 1330 }
; 1331 
; 1332 void MoveCursorHome(...) {
movecursorhome:
; 1333     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1334 }
; 1335 
; 1336 void PrintChar3(...) {
printchar3:
; 1337     if (a == 12)
	cp 12
; 1338         return MoveCursorHome();
	jp z, movecursorhome
; 1339     if (a == 13)
	cp 13
; 1340         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1341     if (a == 10)
	cp 10
; 1342         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1343     if (a == 8)
	cp 8
; 1344         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1345     if (a == 24)
	cp 24
; 1346         return MoveCursorRight(hl);
	jp z, movecursorright
; 1347     if (a == 25)
	cp 25
; 1348         return MoveCursorUp(hl);
	jp z, movecursorup
; 1349     if (a == 7)
	cp 7
; 1350         return PrintCharBeep();
	jp z, printcharbeep
; 1351     if (a == 26)
	cp 26
; 1352         return MoveCursorDown();
	jp z, movecursordown
; 1353     if (a != 27)
	cp 27
; 1354         return PrintChar4(hl, a);
	jp nz, printchar4
; 1355     a = 1;
	ld a, 1
; 1356     return PrintCharSetEscState();
	jp printcharsetescstate
; 1357 }
; 1358 
; 1359 void PrintCharBeep(...) {
printcharbeep:
; 1360     c = 128;  // Длительность
	ld c, 128
; 1361     e = 32;   // Частота
	ld e, 32
; 1362     do {
l_135:
; 1363         d = e;
	ld d, e
; 1364         do {
l_138:
; 1365             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1366         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1367         e = d;
	ld e, d
; 1368         do {
l_141:
; 1369             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1370         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1371     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1372 
; 1373     return PrintCharExit();
	jp printcharexit
; 1374 }
; 1375 
; 1376 void MoveCursorCr(...) {
movecursorcr:
; 1377     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1378     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1379 }
; 1380 
; 1381 void MoveCursorRight(...) {
movecursorright:
; 1382     hl++;
	inc hl
; 1383     MoveCursorBoundary(hl);
; 1384 }
; 1385 
; 1386 void MoveCursorBoundary(...) {
movecursorboundary:
; 1387     a = h;
	ld a, h
; 1388     a &= 7;
	and 7
; 1389     a |= SCREEN_BEGIN >> 8;
	or 232
; 1390     h = a;
	ld h, a
; 1391     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1392 }
; 1393 
; 1394 void MoveCursorLeft(...) {
movecursorleft:
; 1395     hl--;
	dec hl
; 1396     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1397 }
; 1398 
; 1399 void MoveCursorLf(...) {
movecursorlf:
; 1400     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1401     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1402         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1403 
; 1404     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1405     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1406     do {
l_144:
; 1407         *hl = (a = *bc);
	ld a, (bc)
	ld (hl), a
; 1408         hl++;
	inc hl
; 1409         bc++;
	inc bc
; 1410         *hl = (a = *bc);
	ld a, (bc)
	ld (hl), a
; 1411         hl++;
	inc hl
; 1412         bc++;
	inc bc
l_145:
; 1413     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1414     a = SCREEN_END >> 8;
	ld a, 240
; 1415     c = ' ';
	ld c, 32
; 1416     do {
l_147:
; 1417         *hl = c;
	ld (hl), c
; 1418         hl++;
	inc hl
; 1419         *hl = c;
	ld (hl), c
; 1420         hl++;
	inc hl
l_148:
; 1421     } while (a != h);
	cp h
	jp nz, l_147
; 1422     hl = cursor;
	ld hl, (cursor)
; 1423     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1424     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1425     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1426 }
; 1427 
; 1428 void MoveCursorUp(...) {
movecursorup:
; 1429     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1430 }
; 1431 
; 1432 void MoveCursor(...) {
movecursor:
; 1433     hl += bc;
	add hl, bc
; 1434     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1435 }
; 1436 
; 1437 void MoveCursorDown(...) {
movecursordown:
; 1438     return MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1439 }
; 1440 
; 1441 void PrintCrLf() {
printcrlf:
; 1442     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1443     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1444 }
; 1445 
; 1446 // Функция для пользовательской программы.
; 1447 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1448 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1449 
; 1450 void IsAnyKeyPressed() {
isanykeypressed:
; 1451     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1452     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1453     a &= KEYBOARD_ROW_MASK;
	and 127
; 1454     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1455         a ^= a;
	xor a
; 1456         return;
	ret
l_150:
; 1457     }
; 1458     a = 0xFF;
	ld a, 255
	ret
; 1459 }
; 1460 
; 1461 // Функция для пользовательской программы.
; 1462 // Получить код нажатой клавиши на клавиатуре.
; 1463 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1464 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1465 
; 1466 void ReadKey() {
readkey:
; 1467     push_pop(hl) {
	push hl
; 1468         hl = keyDelay;
	ld hl, (keydelay)
; 1469         ReadKeyInternal(hl);
	call readkeyinternal
; 1470         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1471         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1472             do {
l_154:
; 1473                 do {
l_157:
; 1474                     l = 2;
	ld l, 2
; 1475                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1476                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1477             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1478             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1479         }
; 1480         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1481     }
; 1482 }
; 1483 
; 1484 void ReadKeyInternal(...) {
readkeyinternal:
; 1485     do {
l_160:
; 1486         ScanKey();
	call scankey
; 1487         if (a != h)
	cp h
; 1488             break;
	jp nz, l_162
; 1489 
; 1490         // Задержка
; 1491         push_pop(a) {
	push af
; 1492             a ^= a;
	xor a
; 1493             do {
l_163:
; 1494                 swap(hl, de);
	ex hl, de
; 1495                 swap(hl, de);
	ex hl, de
l_164:
; 1496             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1497         }
; 1498     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1499     h = a;
	ld h, a
	ret
; 1500 }
; 1501 
; 1502 // Функция для пользовательской программы.
; 1503 // Получить код нажатой клавиши на клавиатуре.
; 1504 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1505 
; 1506 void ScanKey() {
scankey:
; 1507     push(bc, de, hl);
	push bc
	push de
	push hl
; 1508 
; 1509     bc = 0x00FE;
	ld bc, 254
; 1510     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1511     do {
l_166:
; 1512         a = c;
	ld a, c
; 1513         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1514         cyclic_rotate_left(a, 1);
	rlca
; 1515         c = a;
	ld c, a
; 1516         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1517         a &= KEYBOARD_ROW_MASK;
	and 127
; 1518         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1519             return ScanKey2(a);
	jp nz, scankey2
; 1520         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1521     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1522 
; 1523     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1524     carry_rotate_right(a, 1);
	rra
; 1525     a = 0xFF;  // No key
	ld a, 255
; 1526     if (flag_c)
; 1527         return ScanKeyExit(a);
	jp c, scankeyexit
; 1528     a--;  // Rus key
	dec a
; 1529     return ScanKeyExit(a);
	jp scankeyexit
; 1530 }
; 1531 
; 1532 void ScanKey2(...) {
scankey2:
; 1533     for (;;) {
l_170:
; 1534         carry_rotate_right(a, 1);
	rra
; 1535         if (flag_nc)
; 1536             break;
	jp nc, l_171
; 1537         b++;
	inc b
	jp l_170
l_171:
; 1538     }
; 1539     a = b;
	ld a, b
; 1540     if (a >= 48)
	cp 48
; 1541         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1542     a += 48;
	add 48
; 1543     if (a >= 60)
	cp 60
; 1544         if (a < 64)
	jp c, l_172
	cp 64
; 1545             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1546 
; 1547     if (a == 95)
	cp 95
; 1548         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1549 
; 1550     c = a;
	ld c, a
; 1551     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1552     a &= KEYBOARD_MODS_MASK;
	and 7
; 1553     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1554     b = a;
	ld b, a
; 1555     a = c;
	ld a, c
; 1556     if (flag_z)
; 1557         return ScanKeyExit(a);
	jp z, scankeyexit
; 1558     a = b;
	ld a, b
; 1559     carry_rotate_right(a, 2);
	rra
	rra
; 1560     if (flag_nc)
; 1561         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1562     carry_rotate_right(a, 1);
	rra
; 1563     if (flag_nc)
; 1564         return ScanKeyShift();
	jp nc, scankeyshift
; 1565     (a = c) |= 0x20;
	ld a, c
	or 32
; 1566     ScanKeyExit(a);
; 1567 }
; 1568 
; 1569 void ScanKeyExit(...) {
scankeyexit:
; 1570     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1571 }
; 1572 
; 1573 void ScanKeyControl(...) {
scankeycontrol:
; 1574     a = c;
	ld a, c
; 1575     a &= 0x1F;
	and 31
; 1576     return ScanKeyExit(a);
	jp scankeyexit
; 1577 }
; 1578 
; 1579 void ScanKeyShift(...) {
scankeyshift:
; 1580     if ((a = c) == 127)
	ld a, c
	cp 127
; 1581         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1582     if (a >= 64)
	cp 64
; 1583         return ScanKeyExit();
	jp nc, scankeyexit
; 1584     if (a < 48) {
	cp 48
	jp nc, l_180
; 1585         a |= 16;
	or 16
; 1586         return ScanKeyExit();
	jp scankeyexit
l_180:
; 1587     }
; 1588     a &= 47;
	and 47
; 1589     return ScanKeyExit();
	jp scankeyexit
; 1590 }
; 1591 
; 1592 void ScanKeySpecial(...) {
scankeyspecial:
; 1593     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1594     c = (a -= 48);
	sub 48
	ld c, a
; 1595     b = 0;
	ld b, 0
; 1596     hl += bc;
	add hl, bc
; 1597     a = *hl;
	ld a, (hl)
; 1598     return ScanKeyExit(a);
	jp scankeyexit
; 1599 }
; 1600 
; 1601 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1612  aPrompt[6] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1613  aCrLfTab[6] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1614  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
aregisters:
	db 13
	db 10
	db 80
	db 67
	db 45
	db 13
	db 10
	db 72
	db 76
	db 45
	db 13
	db 10
	db 66
	db 67
	db 45
	db 13
	db 10
	db 68
	db 69
	db 45
	db 13
	db 10
	db 83
	db 80
	db 45
	db 13
	db 10
	db 65
	db 70
	db 45
	db 25
	db 25
	db 25
	db 25
	db 25
	db 25
	ds 1
; 1615  aBackspace[4] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1616  aHello[] = "\x1F\nm/80k ";
ahello:
	db 31
	db 10
	db 109
	db 47
	db 56
	db 48
	db 107
	db 32
	ds 1
; 1618  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1619 }
; 1620 
; 1621 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
padding:
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
 savebin "micro80.bin", 0xF800, 0x10000
