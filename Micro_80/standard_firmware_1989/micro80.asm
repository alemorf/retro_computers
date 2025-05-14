    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst30opcode equ 48
rst30address equ 49
rst38opcode equ 56
rst38address equ 57
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
; 53  uint8_t rst30Opcode __address(0x30);
; 54 extern uint16_t rst30Address __address(0x31);
; 55 extern uint8_t rst38Opcode __address(0x38);
; 56 extern uint16_t rst38Address __address(0x39);
; 57 
; 58 // Прототипы
; 59 void Reboot(...);
; 60 void EntryF86C_Monitor(...);
; 61 void Reboot2(...);
; 62 void Monitor(...);
; 63 void Monitor2();
; 64 void ReadStringBackspace(...);
; 65 void ReadString(...);
; 66 void ReadStringBegin(...);
; 67 void ReadStringLoop(...);
; 68 void ReadStringExit(...);
; 69 void PrintString(...);
; 70 void ParseParams(...);
; 71 void ParseWord(...);
; 72 void ParseWordReturnCf(...);
; 73 void CompareHlDe(...);
; 74 void LoopWithBreak(...);
; 75 void Loop(...);
; 76 void PopRet();
; 77 void IncHl(...);
; 78 void CtrlC(...);
; 79 void PrintCrLfTab();
; 80 void PrintHexByteFromHlSpace(...);
; 81 void PrintHexByteSpace(...);
; 82 void CmdR(...);
; 83 void GetRamTop(...);
; 84 void SetRamTop(...);
; 85 void CmdA(...);
; 86 void CmdD(...);
; 87 void PrintSpacesTo(...);
; 88 void PrintSpace();
; 89 void CmdC(...);
; 90 void CmdF(...);
; 91 void CmdS(...);
; 92 void CmdW(...);
; 93 void CmdT(...);
; 94 void CmdM(...);
; 95 void CmdG(...);
; 96 void BreakPointHandler(...);
; 97 void CmdX(...);
; 98 void GetCursor();
; 99 void GetCursorChar();
; 100 void CmdH(...);
; 101 void CmdI(...);
; 102 void MonitorError();
; 103 void ReadTapeFile(...);
; 104 void ReadTapeWordNext();
; 105 void ReadTapeWord(...);
; 106 void ReadTapeBlock(...);
; 107 void CalculateCheckSum(...);
; 108 void CmdO(...);
; 109 void WriteTapeFile(...);
; 110 void PrintCrLfTabHexWordSpace(...);
; 111 void PrintHexWordSpace(...);
; 112 void WriteTapeBlock(...);
; 113 void WriteTapeWord(...);
; 114 void ReadTapeByte(...);
; 115 void ReadTapeByteInternal(...);
; 116 void ReadTapeByteTimeout(...);
; 117 void WriteTapeByte(...);
; 118 void PrintHexByte(...);
; 119 void PrintHexNibble(...);
; 120 void PrintCharA(...);
; 121 void PrintChar(...);
; 122 void PrintCharSetEscState(...);
; 123 void PrintCharSaveCursor(...);
; 124 void PrintCharExit(...);
; 125 void DrawCursor(...);
; 126 void PrintCharEscY2(...);
; 127 void PrintCharResetEscState(...);
; 128 void PrintCharEsc(...);
; 129 void SetCursorVisible(...);
; 130 void PrintCharNoEsc(...);
; 131 void PrintChar4(...);
; 132 void ClearScreen(...);
; 133 void MoveCursorHome(...);
; 134 void PrintChar3(...);
; 135 void PrintCharBeep(...);
; 136 void MoveCursorCr(...);
; 137 void MoveCursorRight(...);
; 138 void MoveCursorBoundary(...);
; 139 void MoveCursorLeft(...);
; 140 void MoveCursorLf(...);
; 141 void MoveCursorUp(...);
; 142 void MoveCursor(...);
; 143 void MoveCursorDown(...);
; 144 void PrintCrLf();
; 145 void IsAnyKeyPressed();
; 146 void ReadKey();
; 147 void ReadKeyInternal(...);
; 148 void ScanKey();
; 149 void ScanKey2(...);
; 150 void ScanKeyExit(...);
; 151 void ScanKeyControl(...);
; 152 void ScanKeyShift(...);
; 153 void ScanKeySpecial(...);
; 154 void TranslateCodePageDefault(...);
; 155 void TryScrollUp(...);
; 156 
; 157 // Переменные Монитора
; 158 
; 159 extern uint16_t cursor __address(0xF75A);
; 160 extern uint8_t tapeReadSpeed __address(0xF75C);
; 161 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 162 extern uint8_t cursorVisible __address(0xF75E);
; 163 extern uint8_t escState __address(0xF75F);
; 164 extern uint16_t keyDelay __address(0xF760);
; 165 extern uint16_t regPC __address(0xF762);
; 166 extern uint16_t regHL __address(0xF764);
; 167 extern uint16_t regBC __address(0xF766);
; 168 extern uint16_t regDE __address(0xF768);
; 169 extern uint16_t regSP __address(0xF76A);
; 170 extern uint16_t regAF __address(0xF76C);
; 171 extern uint16_t breakPointAddress __address(0xF771);
; 172 extern uint8_t breakPointValue __address(0xF773);
; 173 extern uint8_t jmpParam1Opcode __address(0xF774);
; 174 extern uint16_t param1 __address(0xF775);
; 175 extern uint16_t param2 __address(0xF777);
; 176 extern uint16_t param3 __address(0xF779);
; 177 extern uint8_t param2Exists __address(0xF77B);
; 178 extern uint8_t tapePolarity __address(0xF77C);
; 179 extern uint8_t translateCodeEnabled __address(0xF77D);
; 180 extern uint8_t translateCodePageJump __address(0xF77E);
; 181 extern uint16_t translateCodePageAddress __address(0xF77F);
; 182 extern uint16_t ramTop __address(0xF781);
; 183 extern uint8_t inputBuffer[32] __address(0xF783);
; 184 
; 185 #define firstVariableAddress (&tapeWriteSpeed)
; 186 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 187 
; 188 extern uint8_t specialKeyTable[8];
; 189 extern uint8_t aPrompt[6];
; 190 extern uint8_t aCrLfTab[6];
; 191 extern uint8_t aRegisters[37];
; 192 extern uint8_t aBackspace[4];
; 193 extern uint8_t aHello[9];
; 194 
; 195 // Для удобства
; 196 
; 197 void JmpParam1() __address(0xF774);
; 198 void TranslateCodePage() __address(0xF77E);
; 199 
; 200 // Точки входа
; 201 
; 202 void EntryF800_Reboot() {
entryf800_reboot:
; 203     Reboot();
	jp reboot
; 204 }
; 205 
; 206 void EntryF803_ReadKey() {
entryf803_readkey:
; 207     ReadKey();
	jp readkey
; 208 }
; 209 
; 210 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 211     ReadTapeByte(a);
	jp readtapebyte
; 212 }
; 213 
; 214 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 215     PrintChar(c);
	jp printchar
; 216 }
; 217 
; 218 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 219     WriteTapeByte(c);
	jp writetapebyte
; 220 }
; 221 
; 222 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 223     TranslateCodePage(c);
	jp translatecodepage
; 224 }
; 225 
; 226 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 227     IsAnyKeyPressed();
	jp isanykeypressed
; 228 }
; 229 
; 230 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 231     PrintHexByte(a);
	jp printhexbyte
; 232 }
; 233 
; 234 void EntryF818_PrintString(...) {
entryf818_printstring:
; 235     PrintString(hl);
	jp printstring
; 236 }
; 237 
; 238 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 239     ScanKey();
	jp scankey
; 240 }
; 241 
; 242 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 243     GetCursor();
	jp getcursor
; 244 }
; 245 
; 246 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 247     GetCursorChar();
	jp getcursorchar
; 248 }
; 249 
; 250 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 251     ReadTapeFile(hl);
	jp readtapefile
; 252 }
; 253 
; 254 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 255     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 256 }
; 257 
; 258 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 259     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 260 }
; 261 
; 262 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 263     return;
	ret
; 264     return;
	ret
; 265     return;
	ret
; 266 }
; 267 
; 268 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 269     GetRamTop();
	jp getramtop
; 270 }
; 271 
; 272 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 273     SetRamTop(hl);
	jp setramtop
; 274 }
; 275 
; 276 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 277 // Параметры: нет. Функция никогда не завершается.
; 278 
; 279 void Reboot(...) {
reboot:
; 280     sp = STACK_TOP;
	ld sp, 63488
; 281 
; 282     // Очистка памяти
; 283     hl = firstVariableAddress;
	ld hl, 0FFFFh & (tapewritespeed)
; 284     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 285     bc = 0;
	ld bc, 0
; 286     CmdF();
	call cmdf
; 287 
; 288     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 289 
; 290     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 291 
; 292     // Проверка ОЗУ
; 293     hl = 0;
	ld hl, 0
; 294     for (;;) {
l_1:
; 295         c = *hl;
	ld c, (hl)
; 296         a = 0x55;
	ld a, 85
; 297         *hl = a;
	ld (hl), a
; 298         a ^= *hl;
	xor (hl)
; 299         b = a;
	ld b, a
; 300         a = 0xAA;
	ld a, 170
; 301         *hl = a;
	ld (hl), a
; 302         a ^= *hl;
	xor (hl)
; 303         a |= b;
	or b
; 304         if (flag_nz)
; 305             return Reboot2();
	jp nz, reboot2
; 306         *hl = c;
	ld (hl), c
; 307         hl++;
	inc hl
; 308         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 309             return Reboot2();
	jp z, reboot2
	jp l_1
; 310     }
; 311 
; 312     Reboot2();
	jp reboot2
 .org 0xF86C
; 313 }
; 314 
; 315 asm(" .org 0xF86C");
; 316 
; 317 void EntryF86C_Monitor() {
entryf86c_monitor:
; 318     Monitor();
	jp monitor
; 319 }
; 320 
; 321 void Reboot2(...) {
reboot2:
; 322     hl--;
	dec hl
; 323     ramTop = hl;
	ld (ramtop), hl
; 324     PrintHexWordSpace(hl);
	call printhexwordspace
; 325     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 326     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 327     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 328     Monitor();
; 329 }
; 330 
; 331 void Monitor() {
monitor:
; 332     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 333     cursorVisible = a;
	ld (cursorvisible), a
; 334     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 335     Monitor2();
; 336 }
; 337 
; 338 void Monitor2() {
monitor2:
; 339     sp = STACK_TOP;
	ld sp, 63488
; 340     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 341     ReadString();
	call readstring
; 342 
; 343     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 344 
; 345     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 346     a = *hl;
	ld a, (hl)
; 347 
; 348     if (a == 'X')
	cp 88
; 349         return CmdX();
	jp z, cmdx
; 350 
; 351     push_pop(a) {
	push af
; 352         ParseParams();
	call parseparams
; 353         hl = param3;
	ld hl, (param3)
; 354         c = l;
	ld c, l
; 355         b = h;
	ld b, h
; 356         hl = param2;
	ld hl, (param2)
; 357         swap(hl, de);
	ex hl, de
; 358         hl = param1;
	ld hl, (param1)
	pop af
; 359     }
; 360 
; 361     if (a == 'D')
	cp 68
; 362         return CmdD();
	jp z, cmdd
; 363     if (a == 'C')
	cp 67
; 364         return CmdC();
	jp z, cmdc
; 365     if (a == 'F')
	cp 70
; 366         return CmdF();
	jp z, cmdf
; 367     if (a == 'S')
	cp 83
; 368         return CmdS();
	jp z, cmds
; 369     if (a == 'T')
	cp 84
; 370         return CmdT();
	jp z, cmdt
; 371     if (a == 'M')
	cp 77
; 372         return CmdM();
	jp z, cmdm
; 373     if (a == 'G')
	cp 71
; 374         return CmdG();
	jp z, cmdg
; 375     if (a == 'I')
	cp 73
; 376         return CmdI();
	jp z, cmdi
; 377     if (a == 'O')
	cp 79
; 378         return CmdO();
	jp z, cmdo
; 379     if (a == 'W')
	cp 87
; 380         return CmdW();
	jp z, cmdw
; 381     if (a == 'A')
	cp 65
; 382         return CmdA();
	jp z, cmda
; 383     if (a == 'H')
	cp 72
; 384         return CmdH();
	jp z, cmdh
; 385     if (a == 'R')
	cp 82
; 386         return CmdR();
	jp z, cmdr
; 387     return MonitorError();
	jp monitorerror
; 388 }
; 389 
; 390 void ReadStringBackspace(...) {
readstringbackspace:
; 391     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 392         return ReadStringBegin(hl);
	jp z, readstringbegin
; 393     push_pop(hl) {
	push hl
; 394         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 395     }
; 396     hl--;
	dec hl
; 397     return ReadStringLoop(b, hl);
	jp readstringloop
; 398 }
; 399 
; 400 void ReadString() {
readstring:
; 401     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 402     ReadStringBegin(hl);
; 403 }
; 404 
; 405 void ReadStringBegin(...) {
readstringbegin:
; 406     b = 0;
	ld b, 0
; 407     ReadStringLoop(b, hl);
; 408 }
; 409 
; 410 void ReadStringLoop(...) {
readstringloop:
; 411     for (;;) {
l_4:
; 412         ReadKey();
	call readkey
; 413         if (a == 127)
	cp 127
; 414             return ReadStringBackspace();
	jp z, readstringbackspace
; 415         if (a == 8)
	cp 8
; 416             return ReadStringBackspace();
	jp z, readstringbackspace
; 417         if (flag_nz)
; 418             PrintCharA(a);
	call nz, printchara
; 419         *hl = a;
	ld (hl), a
; 420         if (a == 13)
	cp 13
; 421             return ReadStringExit(b);
	jp z, readstringexit
; 422         if (a == '.')
	cp 46
; 423             return Monitor2();
	jp z, monitor2
; 424         b = 255;
	ld b, 255
; 425         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 426             return MonitorError();
	jp z, monitorerror
; 427         hl++;
	inc hl
	jp l_4
; 428     }
; 429 }
; 430 
; 431 void ReadStringExit(...) {
readstringexit:
; 432     a = b;
	ld a, b
; 433     carry_rotate_left(a, 1);
	rla
; 434     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 435     b = 0;
	ld b, 0
	ret
; 436 }
; 437 
; 438 // Функция для пользовательской программы.
; 439 // Вывод строки на экран.
; 440 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 441 
; 442 void PrintString(...) {
printstring:
; 443     for (;;) {
l_7:
; 444         a = *hl;
	ld a, (hl)
; 445         if (flag_z(a &= a))
	and a
; 446             return;
	ret z
; 447         PrintCharA(a);
	call printchara
; 448         hl++;
	inc hl
	jp l_7
; 449     }
; 450 }
; 451 
; 452 void ParseParams(...) {
parseparams:
; 453     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 454     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 455     c = 0;
	ld c, 0
; 456     CmdF();
	call cmdf
; 457 
; 458     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 459 
; 460     ParseWord();
	call parseword
; 461     param1 = hl;
	ld (param1), hl
; 462     param2 = hl;
	ld (param2), hl
; 463     if (flag_c)
; 464         return;
	ret c
; 465 
; 466     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 467     ParseWord();
	call parseword
; 468     param2 = hl;
	ld (param2), hl
; 469     if (flag_c)
; 470         return;
	ret c
; 471 
; 472     ParseWord();
	call parseword
; 473     param3 = hl;
	ld (param3), hl
; 474     if (flag_c)
; 475         return;
	ret c
; 476 
; 477     MonitorError();
	jp monitorerror
; 478 }
; 479 
; 480 void ParseWord(...) {
parseword:
; 481     hl = 0;
	ld hl, 0
; 482     for (;;) {
l_10:
; 483         a = *de;
	ld a, (de)
; 484         de++;
	inc de
; 485         if (a == 13)
	cp 13
; 486             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 487         if (a == ',')
	cp 44
; 488             return;
	ret z
; 489         if (a == ' ')
	cp 32
; 490             continue;
	jp z, l_10
; 491         a -= '0';
	sub 48
; 492         if (flag_m)
; 493             return MonitorError();
	jp m, monitorerror
; 494         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 495             if (flag_m(compare(a, 17)))
	cp 17
; 496                 return MonitorError();
	jp m, monitorerror
; 497             if (flag_p(compare(a, 23)))
	cp 23
; 498                 return MonitorError();
	jp p, monitorerror
; 499             a -= 7;
	sub 7
l_12:
; 500         }
; 501         c = a;
	ld c, a
; 502         hl += hl;
	add hl, hl
; 503         hl += hl;
	add hl, hl
; 504         hl += hl;
	add hl, hl
; 505         hl += hl;
	add hl, hl
; 506         if (flag_c)
; 507             return MonitorError();
	jp c, monitorerror
; 508         hl += bc;
	add hl, bc
	jp l_10
; 509     }
; 510 }
; 511 
; 512 void ParseWordReturnCf(...) {
parsewordreturncf:
; 513     set_flag_c();
	scf
	ret
; 514 }
; 515 
; 516 void CompareHlDe(...) {
comparehlde:
; 517     if ((a = h) != d)
	ld a, h
	cp d
; 518         return;
	ret nz
; 519     compare(a = l, e);
	ld a, l
	cp e
	ret
; 520 }
; 521 
; 522 void LoopWithBreak(...) {
loopwithbreak:
; 523     CtrlC();
	call ctrlc
; 524     Loop(hl, de);
; 525 }
; 526 
; 527 void Loop(...) {
loop:
; 528     CompareHlDe(hl, de);
	call comparehlde
; 529     if (flag_nz)
; 530         return IncHl(hl);
	jp nz, inchl
; 531     PopRet();
; 532 }
; 533 
; 534 void PopRet() {
popret:
; 535     sp++;
	inc sp
; 536     sp++;
	inc sp
	ret
; 537 }
; 538 
; 539 void IncHl(...) {
inchl:
; 540     hl++;
	inc hl
	ret
; 541 }
; 542 
; 543 void CtrlC() {
ctrlc:
; 544     ScanKey();
	call scankey
; 545     if (a != 3)  // УПР + C
	cp 3
; 546         return;
	ret nz
; 547     MonitorError();
	jp monitorerror
; 548 }
; 549 
; 550 void PrintCrLfTab() {
printcrlftab:
; 551     push_pop(hl) {
	push hl
; 552         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 553     }
; 554 }
; 555 
; 556 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 557     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 558 }
; 559 
; 560 void PrintHexByteSpace(...) {
printhexbytespace:
; 561     push_pop(bc) {
	push bc
; 562         PrintHexByte(a);
	call printhexbyte
; 563         PrintSpace();
	call printspace
	pop bc
	ret
; 564     }
; 565 }
; 566 
; 567 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 568 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 569 
; 570 void CmdR(...) {
cmdr:
; 571     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 572     for (;;) {
l_15:
; 573         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 574         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 575         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 576         bc++;
	inc bc
; 577         Loop();
	call loop
	jp l_15
; 578     }
; 579 }
; 580 
; 581 // Функция для пользовательской программы.
; 582 // Получить адрес последнего доступного байта оперативной памяти.
; 583 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 584 
; 585 void GetRamTop(...) {
getramtop:
; 586     hl = ramTop;
	ld hl, (ramtop)
	ret
; 587 }
; 588 
; 589 // Функция для пользовательской программы.
; 590 // Установить адрес последнего доступного байта оперативной памяти.
; 591 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 592 
; 593 void SetRamTop(...) {
setramtop:
; 594     ramTop = hl;
	ld (ramtop), hl
	ret
; 595 }
; 596 
; 597 // Команда A <адрес>
; 598 // Установить программу преобразования кодировки символов выводимых на экран
; 599 
; 600 void CmdA(...) {
cmda:
; 601     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 602 }
; 603 
; 604 // Команда D <начальный адрес> <конечный адрес>
; 605 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 606 
; 607 void CmdD(...) {
cmdd:
; 608     for (;;) {
l_18:
; 609         PrintCrLf();
	call printcrlf
; 610         PrintHexWordSpace(hl);
	call printhexwordspace
; 611         push_pop(hl) {
	push hl
; 612             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 613             carry_rotate_right(a, 1);
	rra
; 614             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 615             PrintSpacesTo();
	call printspacesto
; 616             do {
l_20:
; 617                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 618                 CompareHlDe(hl, de);
	call comparehlde
; 619                 hl++;
	inc hl
; 620                 if (flag_z)
; 621                     break;
	jp z, l_22
; 622                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 623                 push_pop(a) {
	push af
; 624                     a &= 1;
	and 1
; 625                     if (flag_z)
; 626                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 627                 }
; 628             } while (flag_nz);
; 629         }
; 630 
; 631         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 632         PrintSpacesTo(b);
	call printspacesto
; 633 
; 634         do {
l_23:
; 635             a = *hl;
	ld a, (hl)
; 636             if (a < 127)
	cp 127
; 637                 if (a >= 32)
	jp nc, l_26
	cp 32
; 638                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 639             a = '.';
	ld a, 46
; 640         loc_fa49:
loc_fa49:
; 641             PrintCharA(a);
	call printchara
; 642             CompareHlDe(hl, de);
	call comparehlde
; 643             if (flag_z)
; 644                 return;
	ret z
; 645             hl++;
	inc hl
; 646             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 647         } while (flag_nz);
; 648     }
; 649 }
; 650 
; 651 void PrintSpacesTo(...) {
printspacesto:
; 652     for (;;) {
l_29:
; 653         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 654             return;
	ret nc
; 655         PrintSpace();
	call printspace
	jp l_29
; 656     }
; 657 }
; 658 
; 659 void PrintSpace() {
printspace:
; 660     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 661 }
; 662 
; 663 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 664 // Сравнить два блока адресного пространство
; 665 
; 666 void CmdC(...) {
cmdc:
; 667     for (;;) {
l_32:
; 668         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 669             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 670             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 671             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 672         }
; 673         bc++;
	inc bc
; 674         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 675     }
; 676 }
; 677 
; 678 // Команда F <начальный адрес> <конечный адрес> <байт>
; 679 // Заполнить блок в адресном пространстве одним байтом
; 680 
; 681 void CmdF(...) {
cmdf:
; 682     for (;;) {
l_37:
; 683         *hl = c;
	ld (hl), c
; 684         Loop();
	call loop
	jp l_37
; 685     }
; 686 }
; 687 
; 688 // Команда S <начальный адрес> <конечный адрес> <байт>
; 689 // Найти байт (8 битное значение) в адресном пространстве
; 690 
; 691 void CmdS(...) {
cmds:
; 692     for (;;) {
l_40:
; 693         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 694             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 695         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 696     }
; 697 }
; 698 
; 699 // Команда W <начальный адрес> <конечный адрес> <слово>
; 700 // Найти слово (16 битное значение) в адресном пространстве
; 701 
; 702 void CmdW(...) {
cmdw:
; 703     for (;;) {
l_43:
; 704         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 705             hl++;
	inc hl
; 706             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 707             hl--;
	dec hl
; 708             if (flag_z)
; 709                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 710         }
; 711         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 712     }
; 713 }
; 714 
; 715 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 716 // Копировать блок в адресном пространстве
; 717 
; 718 void CmdT(...) {
cmdt:
; 719     for (;;) {
l_48:
; 720         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 721         bc++;
	inc bc
; 722         Loop();
	call loop
	jp l_48
; 723     }
; 724 }
; 725 
; 726 // Команда M <начальный адрес>
; 727 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 728 
; 729 void CmdM(...) {
cmdm:
; 730     for (;;) {
l_51:
; 731         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 732         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 733         push_pop(hl) {
	push hl
; 734             ReadString();
	call readstring
	pop hl
; 735         }
; 736         if (flag_c) {
	jp nc, l_53
; 737             push_pop(hl) {
	push hl
; 738                 ParseWord();
	call parseword
; 739                 a = l;
	ld a, l
	pop hl
; 740             }
; 741             *hl = a;
	ld (hl), a
l_53:
; 742         }
; 743         hl++;
	inc hl
	jp l_51
; 744     }
; 745 }
; 746 
; 747 // Команда G <начальный адрес> <конечный адрес>
; 748 // Запуск программы и возможным указанием точки останова.
; 749 
; 750 void CmdG(...) {
cmdg:
; 751     CompareHlDe(hl, de);
	call comparehlde
; 752     if (flag_nz) {
	jp z, l_55
; 753         swap(hl, de);
	ex hl, de
; 754         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 755         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 756         *hl = OPCODE_RST_30;
	ld (hl), 247
; 757         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 758         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 759     }
; 760     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 761     pop(bc);
	pop bc
; 762     pop(de);
	pop de
; 763     pop(hl);
	pop hl
; 764     pop(a);
	pop af
; 765     sp = hl;
	ld sp, hl
; 766     hl = regHL;
	ld hl, (reghl)
; 767     JmpParam1();
	jp jmpparam1
; 768 }
; 769 
; 770 void BreakPointHandler(...) {
breakpointhandler:
; 771     regHL = hl;
	ld (reghl), hl
; 772     push(a);
	push af
; 773     pop(hl);
	pop hl
; 774     regAF = hl;
	ld (regaf), hl
; 775     pop(hl);
	pop hl
; 776     hl--;
	dec hl
; 777     regPC = hl;
	ld (regpc), hl
; 778     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 779     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 780     push(hl);
	push hl
; 781     push(de);
	push de
; 782     push(bc);
	push bc
; 783     sp = STACK_TOP;
	ld sp, 63488
; 784     hl = regPC;
	ld hl, (regpc)
; 785     swap(hl, de);
	ex hl, de
; 786     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 787     CompareHlDe(hl, de);
	call comparehlde
; 788     if (flag_nz)
; 789         return CmdX();
	jp nz, cmdx
; 790     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 791     CmdX();
; 792 }
; 793 
; 794 // Команда X
; 795 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 796 
; 797 void CmdX(...) {
cmdx:
; 798     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 799     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 800     b = 6;
	ld b, 6
; 801     do {
l_57:
; 802         e = *hl;
	ld e, (hl)
; 803         hl++;
	inc hl
; 804         d = *hl;
	ld d, (hl)
; 805         push(bc);
	push bc
; 806         push(hl);
	push hl
; 807         swap(hl, de);
	ex hl, de
; 808         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 809         ReadString();
	call readstring
; 810         if (flag_c) {
	jp nc, l_60
; 811             ParseWord();
	call parseword
; 812             pop(de);
	pop de
; 813             push(de);
	push de
; 814             swap(hl, de);
	ex hl, de
; 815             *hl = d;
	ld (hl), d
; 816             hl--;
	dec hl
; 817             *hl = e;
	ld (hl), e
l_60:
; 818         }
; 819         pop(hl);
	pop hl
; 820         pop(bc);
	pop bc
; 821         b--;
	dec b
; 822         hl++;
	inc hl
l_58:
	jp nz, l_57
; 823     } while (flag_nz);
; 824     EntryF86C_Monitor();
	jp entryf86c_monitor
; 825 }
; 826 
; 827 // Функция для пользовательской программы.
; 828 // Получить координаты курсора.
; 829 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 830 
; 831 void GetCursor() {
getcursor:
; 832     push_pop(a) {
	push af
; 833         hl = cursor;
	ld hl, (cursor)
; 834         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 835 
; 836         // Вычисление X
; 837         a = l;
	ld a, l
; 838         a &= (SCREEN_WIDTH - 1);
	and 63
; 839         a += 8;  // Смещение Радио 86РК
	add 8
; 840 
; 841         // Вычисление Y
; 842         hl += hl;
	add hl, hl
; 843         hl += hl;
	add hl, hl
; 844         h++;  // Смещение Радио 86РК
	inc h
; 845         h++;
	inc h
; 846         h++;
	inc h
; 847 
; 848         l = a;
	ld l, a
	pop af
	ret
; 849     }
; 850 }
; 851 
; 852 // Функция для пользовательской программы.
; 853 // Получить символ под курсором.
; 854 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 855 
; 856 void GetCursorChar() {
getcursorchar:
; 857     push_pop(hl) {
	push hl
; 858         hl = cursor;
	ld hl, (cursor)
; 859         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 860     }
; 861 }
; 862 
; 863 // Команда H
; 864 // Определить скорости записанной программы.
; 865 // Выводит 4 цифры на экран.
; 866 // Первые две цифры - константа вывода для команды O
; 867 // Последние две цифры - константа вввода для команды I
; 868 
; 869 void CmdH(...) {
cmdh:
; 870     PrintCrLfTab();
	call printcrlftab
; 871     hl = 65408;
	ld hl, 65408
; 872     b = 123;
	ld b, 123
; 873 
; 874     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 875 
; 876     do {
l_62:
l_63:
; 877     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 878 
; 879     do {
l_65:
; 880         c = a;
	ld c, a
; 881         do {
l_68:
; 882             hl++;
	inc hl
l_69:
; 883         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 884     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 885 
; 886     hl += hl;
	add hl, hl
; 887     a = h;
	ld a, h
; 888     hl += hl;
	add hl, hl
; 889     l = (a += h);
	add h
	ld l, a
; 890 
; 891     PrintHexWordSpace();
	jp printhexwordspace
; 892 }
; 893 
; 894 // Команда I <смещение> <скорость>
; 895 // Загрузить файл с магнитной ленты
; 896 
; 897 void CmdI(...) {
cmdi:
; 898     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 899         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 900     ReadTapeFile();
	call readtapefile
; 901     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 902     swap(hl, de);
	ex hl, de
; 903     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 904     swap(hl, de);
	ex hl, de
; 905     push(bc);
	push bc
; 906     CalculateCheckSum();
	call calculatechecksum
; 907     h = b;
	ld h, b
; 908     l = c;
	ld l, c
; 909     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 910     pop(de);
	pop de
; 911     CompareHlDe(hl, de);
	call comparehlde
; 912     if (flag_z)
; 913         return;
	ret z
; 914     swap(hl, de);
	ex hl, de
; 915     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 916     MonitorError();
; 917 }
; 918 
; 919 void MonitorError() {
monitorerror:
; 920     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 921     Monitor2();
	jp monitor2
; 922 }
; 923 
; 924 // Функция для пользовательской программы.
; 925 // Загрузить файл с магнитной ленты.
; 926 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 927 
; 928 void ReadTapeFile(...) {
readtapefile:
; 929     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 930     push_pop(hl) {
	push hl
; 931         hl += bc;
	add hl, bc
; 932         swap(hl, de);
	ex hl, de
; 933         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 934     }
; 935     hl += bc;
	add hl, bc
; 936     swap(hl, de);
	ex hl, de
; 937 
; 938     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 939     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 940     if (flag_z)
; 941         return;
	ret z
; 942 
; 943     push_pop(hl) {
	push hl
; 944         ReadTapeBlock();
	call readtapeblock
; 945         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 946     }
; 947 }
; 948 
; 949 void ReadTapeWordNext() {
readtapewordnext:
; 950     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 951 }
; 952 
; 953 void ReadTapeWord(...) {
readtapeword:
; 954     ReadTapeByte(a);
	call readtapebyte
; 955     b = a;
	ld b, a
; 956     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 957     c = a;
	ld c, a
	ret
; 958 }
; 959 
; 960 void ReadTapeBlock(...) {
readtapeblock:
; 961     for (;;) {
l_74:
; 962         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 963         *hl = a;
	ld (hl), a
; 964         Loop();
	call loop
	jp l_74
; 965     }
; 966 }
; 967 
; 968 // Функция для пользовательской программы.
; 969 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 970 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 971 
; 972 void CalculateCheckSum(...) {
calculatechecksum:
; 973     bc = 0;
	ld bc, 0
; 974     for (;;) {
l_77:
; 975         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 976         push_pop(a) {
	push af
; 977             CompareHlDe(hl, de);
	call comparehlde
; 978             if (flag_z)
; 979                 return PopRet();
	jp z, popret
	pop af
; 980         }
; 981         a = b;
	ld a, b
; 982         carry_add(a, *hl);
	adc (hl)
; 983         b = a;
	ld b, a
; 984         Loop();
	call loop
	jp l_77
; 985     }
; 986 }
; 987 
; 988 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 989 // Сохранить блок данных на магнитную ленту
; 990 
; 991 void CmdO(...) {
cmdo:
; 992     if ((a = c) != 0)
	ld a, c
	or a
; 993         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 994     push_pop(hl) {
	push hl
; 995         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 996     }
; 997     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 998     swap(hl, de);
	ex hl, de
; 999     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1000     swap(hl, de);
	ex hl, de
; 1001     push_pop(hl) {
	push hl
; 1002         h = b;
	ld h, b
; 1003         l = c;
	ld l, c
; 1004         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1005     }
; 1006     WriteTapeFile(hl, de);
; 1007 }
; 1008 
; 1009 // Функция для пользовательской программы.
; 1010 // Запись файла на магнитную ленту.
; 1011 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1012 
; 1013 void WriteTapeFile(...) {
writetapefile:
; 1014     push(bc);
	push bc
; 1015     bc = 0;
	ld bc, 0
; 1016     do {
l_81:
; 1017         WriteTapeByte(c);
	call writetapebyte
; 1018         b--;
	dec b
; 1019         swap(hl, *sp);
	ex (sp), hl
; 1020         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1021     } while (flag_nz);
; 1022     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1023     WriteTapeWord(hl);
	call writetapeword
; 1024     swap(hl, de);
	ex hl, de
; 1025     WriteTapeWord(hl);
	call writetapeword
; 1026     swap(hl, de);
	ex hl, de
; 1027     WriteTapeBlock(hl, de);
	call writetapeblock
; 1028     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1029     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1030     pop(hl);
	pop hl
; 1031     WriteTapeWord(hl);
	call writetapeword
; 1032     return;
	ret
; 1033 }
; 1034 
; 1035 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1036     push_pop(bc) {
	push bc
; 1037         PrintCrLfTab();
	call printcrlftab
; 1038         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1039     }
; 1040 }
; 1041 
; 1042 void PrintHexWordSpace(...) {
printhexwordspace:
; 1043     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1044     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1045 }
; 1046 
; 1047 void WriteTapeBlock(...) {
writetapeblock:
; 1048     for (;;) {
l_85:
; 1049         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1050         Loop();
	call loop
	jp l_85
; 1051     }
; 1052 }
; 1053 
; 1054 void WriteTapeWord(...) {
writetapeword:
; 1055     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1056     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1057 }
; 1058 
; 1059 // Загрузка байта с магнитной ленты.
; 1060 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1061 // Результат: a = прочитанный байт.
; 1062 
; 1063 void ReadTapeByte(...) {
readtapebyte:
; 1064     push(hl, bc, de);
	push hl
	push bc
	push de
; 1065     d = a;
	ld d, a
; 1066     ReadTapeByteInternal(d);
; 1067 }
; 1068 
; 1069 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1070     c = 0;
	ld c, 0
; 1071     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1072     do {
l_87:
; 1073     retry:  // Сдвиг результата
retry:
; 1074         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1075         cyclic_rotate_left(a, 1);
	rlca
; 1076         c = a;
	ld c, a
; 1077 
; 1078         // Ожидание изменения бита
; 1079         h = 0;
	ld h, 0
; 1080         do {
l_90:
; 1081             h--;
	dec h
; 1082             if (flag_z)
; 1083                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1084         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1085 
; 1086         // Сохранение бита
; 1087         c = (a |= c);
	or c
	ld c, a
; 1088 
; 1089         // Задержка
; 1090         d--;
	dec d
; 1091         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1092         if (flag_z)
; 1093             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1094         b = a;
	ld b, a
; 1095         do {
l_95:
l_96:
; 1096         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1097         d++;
	inc d
; 1098 
; 1099         // Новое значение бита
; 1100         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1101 
; 1102         // Режим поиска синхробайта
; 1103         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1104             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1105                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1106             } else {
; 1107                 if (a != ~TAPE_START)
	cp 65305
; 1108                     goto retry;
	jp nz, retry
; 1109                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1110             }
; 1111             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1112         }
; 1113     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1114     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1115     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1116 }
; 1117 
; 1118 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1119     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1120         return MonitorError();
	jp p, monitorerror
; 1121     CtrlC();
	call ctrlc
; 1122     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1123 }
; 1124 
; 1125 // Функция для пользовательской программы.
; 1126 // Запись байта на магнитную ленту.
; 1127 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1128 
; 1129 void WriteTapeByte(...) {
writetapebyte:
; 1130     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1131         d = 8;
	ld d, 8
; 1132         do {
l_102:
; 1133             // Сдвиг исходного байта
; 1134             a = c;
	ld a, c
; 1135             cyclic_rotate_left(a, 1);
	rlca
; 1136             c = a;
	ld c, a
; 1137 
; 1138             // Вывод
; 1139             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1140             out(PORT_TAPE, a);
	out (1), a
; 1141 
; 1142             // Задержка
; 1143             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1144             do {
l_105:
; 1145                 b--;
	dec b
l_106:
	jp nz, l_105
; 1146             } while (flag_nz);
; 1147 
; 1148             // Вывод
; 1149             (a = 0) ^= c;
	ld a, 0
	xor c
; 1150             out(PORT_TAPE, a);
	out (1), a
; 1151 
; 1152             // Задержка
; 1153             d--;
	dec d
; 1154             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1155             if (flag_z)
; 1156                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1157             b = a;
	ld b, a
; 1158             do {
l_110:
; 1159                 b--;
	dec b
l_111:
	jp nz, l_110
; 1160             } while (flag_nz);
; 1161             d++;
	inc d
l_103:
; 1162         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1163     }
; 1164 }
; 1165 
; 1166 // Функция для пользовательской программы.
; 1167 // Вывод 8 битного числа на экран.
; 1168 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1169 
; 1170 void PrintHexByte(...) {
printhexbyte:
; 1171     push_pop(a) {
	push af
; 1172         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1173         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1174     }
; 1175     PrintHexNibble(a);
; 1176 }
; 1177 
; 1178 void PrintHexNibble(...) {
printhexnibble:
; 1179     a &= 0x0F;
	and 15
; 1180     if (flag_p(compare(a, 10)))
	cp 10
; 1181         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1182     a += '0';
	add 48
; 1183     PrintCharA(a);
; 1184 }
; 1185 
; 1186 // Вывод символа на экран.
; 1187 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1188 
; 1189 void PrintCharA(...) {
printchara:
; 1190     PrintChar(c = a);
	ld c, a
; 1191 }
; 1192 
; 1193 // Функция для пользовательской программы.
; 1194 // Вывод символа на экран.
; 1195 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1196 
; 1197 void PrintChar(...) {
printchar:
; 1198     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1199     IsAnyKeyPressed();
	call isanykeypressed
; 1200     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1201     hl = cursor;
	ld hl, (cursor)
; 1202     a = escState;
	ld a, (escstate)
; 1203     a--;
	dec a
; 1204     if (flag_m)
; 1205         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1206     if (flag_z)
; 1207         return PrintCharEsc();
	jp z, printcharesc
; 1208     a--;
	dec a
; 1209     if (flag_nz)
; 1210         return PrintCharEscY2();
	jp nz, printcharescy2
; 1211 
; 1212     // Первый параметр ESC Y
; 1213     a = c;
	ld a, c
; 1214     a -= ' ';
	sub 32
; 1215     if (flag_m) {
	jp p, l_115
; 1216         a ^= a;
	xor a
	jp l_116
l_115:
; 1217     } else {
; 1218         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1219             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1220     }
; 1221     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1222     c = a;
	ld c, a
; 1223     b = (a &= 192);
	and 192
	ld b, a
; 1224     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1225     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1226     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1227     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1228 }
; 1229 
; 1230 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1231     escState = a;
	ld (escstate), a
; 1232     PrintCharSaveCursor(hl);
; 1233 }
; 1234 
; 1235 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1236     cursor = hl;
	ld (cursor), hl
; 1237     PrintCharExit();
; 1238 }
; 1239 
; 1240 void PrintCharExit(...) {
printcharexit:
; 1241     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1242     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1243 }
; 1244 
; 1245 void DrawCursor(...) {
drawcursor:
; 1246     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1247         return;
	ret z
; 1248     hl = cursor;
	ld hl, (cursor)
; 1249     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1250     *hl = b;
	ld (hl), b
	ret
; 1251 }
; 1252 
; 1253 void PrintCharEscY2(...) {
printcharescy2:
; 1254     a = c;
	ld a, c
; 1255     a -= ' ';
	sub 32
; 1256     if (flag_m) {
	jp p, l_119
; 1257         a ^= a;
	xor a
	jp l_120
l_119:
; 1258     } else {
; 1259         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1260             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1261     }
; 1262     b = a;
	ld b, a
; 1263     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1264     PrintCharResetEscState();
; 1265 }
; 1266 
; 1267 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1268     a ^= a;
	xor a
; 1269     return PrintCharSetEscState();
	jp printcharsetescstate
; 1270 }
; 1271 
; 1272 void PrintCharEsc(...) {
printcharesc:
; 1273     a = c;
	ld a, c
; 1274     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1275         a = 2;
	ld a, 2
; 1276         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1277     }
; 1278     if (a == 97) {
	cp 97
	jp nz, l_125
; 1279         a ^= a;
	xor a
; 1280         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1281     }
; 1282     if (a != 98)
	cp 98
; 1283         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1284     SetCursorVisible();
; 1285 }
; 1286 
; 1287 void SetCursorVisible(...) {
setcursorvisible:
; 1288     cursorVisible = a;
	ld (cursorvisible), a
; 1289     return PrintCharResetEscState();
	jp printcharresetescstate
; 1290 }
; 1291 
; 1292 void PrintCharNoEsc(...) {
printcharnoesc:
; 1293     // Остановка вывода нажатием УС + Шифт
; 1294     do {
l_127:
; 1295         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1296     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1297 
; 1298     compare(a = 16, c);
	ld a, 16
	cp c
; 1299     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1300     if (flag_z) {
	jp nz, l_130
; 1301         invert(a);
	cpl
; 1302         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1303         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1304     }
; 1305     if (a != 0)
	or a
; 1306         TranslateCodePage(c);
	call nz, translatecodepage
; 1307     a = c;
	ld a, c
; 1308     if (a == 31)
	cp 31
; 1309         return ClearScreen();
	jp z, clearscreen
; 1310     if (flag_m)
; 1311         return PrintChar3(a);
	jp m, printchar3
; 1312     PrintChar4(a);
; 1313 }
; 1314 
; 1315 void PrintChar4(...) {
printchar4:
; 1316     *hl = a;
	ld (hl), a
; 1317     hl++;
	inc hl
; 1318     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1319         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1320     PrintCrLf();
	call printcrlf
; 1321     PrintCharExit();
	jp printcharexit
; 1322 }
; 1323 
; 1324 void ClearScreen(...) {
clearscreen:
; 1325     b = ' ';
	ld b, 32
; 1326     a = SCREEN_END >> 8;
	ld a, 240
; 1327     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1328     do {
l_132:
; 1329         *hl = b;
	ld (hl), b
; 1330         hl++;
	inc hl
; 1331         *hl = b;
	ld (hl), b
; 1332         hl++;
	inc hl
l_133:
; 1333     } while (a != h);
	cp h
	jp nz, l_132
; 1334     MoveCursorHome();
; 1335 }
; 1336 
; 1337 void MoveCursorHome(...) {
movecursorhome:
; 1338     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1339 }
; 1340 
; 1341 void PrintChar3(...) {
printchar3:
; 1342     if (a == 12)
	cp 12
; 1343         return MoveCursorHome();
	jp z, movecursorhome
; 1344     if (a == 13)
	cp 13
; 1345         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1346     if (a == 10)
	cp 10
; 1347         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1348     if (a == 8)
	cp 8
; 1349         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1350     if (a == 24)
	cp 24
; 1351         return MoveCursorRight(hl);
	jp z, movecursorright
; 1352     if (a == 25)
	cp 25
; 1353         return MoveCursorUp(hl);
	jp z, movecursorup
; 1354     if (a == 7)
	cp 7
; 1355         return PrintCharBeep();
	jp z, printcharbeep
; 1356     if (a == 26)
	cp 26
; 1357         return MoveCursorDown();
	jp z, movecursordown
; 1358     if (a != 27)
	cp 27
; 1359         return PrintChar4(hl, a);
	jp nz, printchar4
; 1360     a = 1;
	ld a, 1
; 1361     PrintCharSetEscState();
	jp printcharsetescstate
; 1362 }
; 1363 
; 1364 void PrintCharBeep(...) {
printcharbeep:
; 1365     c = 128;  // Длительность
	ld c, 128
; 1366     e = 32;   // Частота
	ld e, 32
; 1367     do {
l_135:
; 1368         d = e;
	ld d, e
; 1369         do {
l_138:
; 1370             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1371         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1372         e = d;
	ld e, d
; 1373         do {
l_141:
; 1374             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1375         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1376     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1377 
; 1378     PrintCharExit();
	jp printcharexit
; 1379 }
; 1380 
; 1381 void MoveCursorCr(...) {
movecursorcr:
; 1382     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1383     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1384 }
; 1385 
; 1386 void MoveCursorRight(...) {
movecursorright:
; 1387     hl++;
	inc hl
; 1388     MoveCursorBoundary(hl);
; 1389 }
; 1390 
; 1391 void MoveCursorBoundary(...) {
movecursorboundary:
; 1392     a = h;
	ld a, h
; 1393     a &= 7;
	and 7
; 1394     a |= SCREEN_BEGIN >> 8;
	or 232
; 1395     h = a;
	ld h, a
; 1396     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1397 }
; 1398 
; 1399 void MoveCursorLeft(...) {
movecursorleft:
; 1400     hl--;
	dec hl
; 1401     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1402 }
; 1403 
; 1404 void MoveCursorLf(...) {
movecursorlf:
; 1405     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1406     TryScrollUp(hl);
; 1407 }
; 1408 
; 1409 void TryScrollUp(...) {
tryscrollup:
; 1410     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1411         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1412 
; 1413     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1414     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1415     do {
l_144:
; 1416         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1417         hl++;
	inc hl
; 1418         bc++;
	inc bc
; 1419         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1420         hl++;
	inc hl
; 1421         bc++;
	inc bc
l_145:
; 1422     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1423     a = SCREEN_END >> 8;
	ld a, 240
; 1424     c = ' ';
	ld c, 32
; 1425     do {
l_147:
; 1426         *hl = c;
	ld (hl), c
; 1427         hl++;
	inc hl
; 1428         *hl = c;
	ld (hl), c
; 1429         hl++;
	inc hl
l_148:
; 1430     } while (a != h);
	cp h
	jp nz, l_147
; 1431     hl = cursor;
	ld hl, (cursor)
; 1432     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1433     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1434     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1435 }
; 1436 
; 1437 void MoveCursorUp(...) {
movecursorup:
; 1438     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1439 }
; 1440 
; 1441 void MoveCursor(...) {
movecursor:
; 1442     hl += bc;
	add hl, bc
; 1443     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1444 }
; 1445 
; 1446 void MoveCursorDown(...) {
movecursordown:
; 1447     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1448 }
; 1449 
; 1450 void PrintCrLf() {
printcrlf:
; 1451     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1452     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1453 }
; 1454 
; 1455 // Функция для пользовательской программы.
; 1456 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1457 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1458 
; 1459 void IsAnyKeyPressed() {
isanykeypressed:
; 1460     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1461     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1462     a &= KEYBOARD_ROW_MASK;
	and 127
; 1463     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1464         a ^= a;
	xor a
; 1465         return;
	ret
l_150:
; 1466     }
; 1467     a = 0xFF;
	ld a, 255
	ret
; 1468 }
; 1469 
; 1470 // Функция для пользовательской программы.
; 1471 // Получить код нажатой клавиши на клавиатуре.
; 1472 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1473 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1474 
; 1475 void ReadKey() {
readkey:
; 1476     push_pop(hl) {
	push hl
; 1477         hl = keyDelay;
	ld hl, (keydelay)
; 1478         ReadKeyInternal(hl);
	call readkeyinternal
; 1479         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1480         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1481             do {
l_154:
; 1482                 do {
l_157:
; 1483                     l = 2;
	ld l, 2
; 1484                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1485                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1486             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1487             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1488         }
; 1489         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1490     }
; 1491 }
; 1492 
; 1493 void ReadKeyInternal(...) {
readkeyinternal:
; 1494     do {
l_160:
; 1495         ScanKey();
	call scankey
; 1496         if (a != h)
	cp h
; 1497             break;
	jp nz, l_162
; 1498 
; 1499         // Задержка
; 1500         push_pop(a) {
	push af
; 1501             a ^= a;
	xor a
; 1502             do {
l_163:
; 1503                 swap(hl, de);
	ex hl, de
; 1504                 swap(hl, de);
	ex hl, de
l_164:
; 1505             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1506         }
; 1507     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1508     h = a;
	ld h, a
	ret
; 1509 }
; 1510 
; 1511 // Функция для пользовательской программы.
; 1512 // Получить код нажатой клавиши на клавиатуре.
; 1513 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1514 
; 1515 void ScanKey() {
scankey:
; 1516     push(bc, de, hl);
	push bc
	push de
	push hl
; 1517 
; 1518     bc = 0x00FE;
	ld bc, 254
; 1519     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1520     do {
l_166:
; 1521         a = c;
	ld a, c
; 1522         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1523         cyclic_rotate_left(a, 1);
	rlca
; 1524         c = a;
	ld c, a
; 1525         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1526         a &= KEYBOARD_ROW_MASK;
	and 127
; 1527         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1528             return ScanKey2(a);
	jp nz, scankey2
; 1529         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1530     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1531 
; 1532     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1533     carry_rotate_right(a, 1);
	rra
; 1534     a = 0xFF;  // Клавиша не нажата
	ld a, 255
; 1535     if (flag_c)
; 1536         return ScanKeyExit(a);
	jp c, scankeyexit
; 1537     a--;  // Рус/Лат
	dec a
; 1538     ScanKeyExit(a);
	jp scankeyexit
; 1539 }
; 1540 
; 1541 void ScanKey2(...) {
scankey2:
; 1542     for (;;) {
l_170:
; 1543         carry_rotate_right(a, 1);
	rra
; 1544         if (flag_nc)
; 1545             break;
	jp nc, l_171
; 1546         b++;
	inc b
	jp l_170
l_171:
; 1547     }
; 1548 
; 1549     /* b - key number */
; 1550 
; 1551     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1552      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1553      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1554      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1555      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1556      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1557      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1558 
; 1559     a = b;
	ld a, b
; 1560     if (a >= 48)
	cp 48
; 1561         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1562     a += 48;
	add 48
; 1563     if (a >= 60)
	cp 60
; 1564         if (a < 64)
	jp c, l_172
	cp 64
; 1565             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1566 
; 1567     if (a == 95)
	cp 95
; 1568         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1569 
; 1570     c = a;
	ld c, a
; 1571     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1572     a &= KEYBOARD_MODS_MASK;
	and 7
; 1573     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1574     b = a;
	ld b, a
; 1575     a = c;
	ld a, c
; 1576     if (flag_z)
; 1577         return ScanKeyExit(a);
	jp z, scankeyexit
; 1578     a = b;
	ld a, b
; 1579     carry_rotate_right(a, 2);
	rra
	rra
; 1580     if (flag_nc)
; 1581         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1582     carry_rotate_right(a, 1);
	rra
; 1583     if (flag_nc)
; 1584         return ScanKeyShift();
	jp nc, scankeyshift
; 1585     (a = c) |= 0x20;
	ld a, c
	or 32
; 1586     ScanKeyExit(a);
; 1587 }
; 1588 
; 1589 void ScanKeyExit(...) {
scankeyexit:
; 1590     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1591 }
; 1592 
; 1593 void ScanKeyControl(...) {
scankeycontrol:
; 1594     a = c;
	ld a, c
; 1595     a &= 0x1F;
	and 31
; 1596     return ScanKeyExit(a);
	jp scankeyexit
; 1597 }
; 1598 
; 1599 void ScanKeyShift(...) {
scankeyshift:
; 1600     a = c;
	ld a, c
; 1601     if (a == 127)
	cp 127
; 1602         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1603     if (a >= 64)
	cp 64
; 1604         return ScanKeyExit(a);
	jp nc, scankeyexit
; 1605     if (a < 48) {
	cp 48
	jp nc, l_180
; 1606         a |= 16;
	or 16
; 1607         return ScanKeyExit(a);
	jp scankeyexit
l_180:
; 1608     }
; 1609     a &= 47;
	and 47
; 1610     ScanKeyExit();
	jp scankeyexit
; 1611 }
; 1612 
; 1613 void ScanKeySpecial(...) {
scankeyspecial:
; 1614     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1615     c = (a -= 48);
	sub 48
	ld c, a
; 1616     b = 0;
	ld b, 0
; 1617     hl += bc;
	add hl, bc
; 1618     a = *hl;
	ld a, (hl)
; 1619     ScanKeyExit(a);
	jp scankeyexit
; 1620 }
; 1621 
; 1622 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1633  aPrompt[] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1634  aCrLfTab[] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1635  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1636  aBackspace[] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1637  aHello[] = "\x1F\nМ/80К ";
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
; 1639  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1640 }
; 1641 
; 1642 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
