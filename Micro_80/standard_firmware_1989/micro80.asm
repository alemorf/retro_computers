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
; 54  uint8_t rst30Opcode __address(0x30);
; 55 extern uint16_t rst30Address __address(0x31);
; 56 extern uint8_t rst38Opcode __address(0x38);
; 57 extern uint16_t rst38Address __address(0x39);
; 58 
; 59 // Прототипы
; 60 void Reboot(...);
; 61 void EntryF86C_Monitor(...);
; 62 void Reboot2(...);
; 63 void Monitor(...);
; 64 void Monitor2();
; 65 void ReadStringBackspace(...);
; 66 void ReadString(...);
; 67 void ReadStringBegin(...);
; 68 void ReadStringLoop(...);
; 69 void ReadStringExit(...);
; 70 void PrintString(...);
; 71 void ParseParams(...);
; 72 void ParseWord(...);
; 73 void ParseWordReturnCf(...);
; 74 void CompareHlDe(...);
; 75 void LoopWithBreak(...);
; 76 void Loop(...);
; 77 void PopRet();
; 78 void IncHl(...);
; 79 void CtrlC(...);
; 80 void PrintCrLfTab();
; 81 void PrintHexByteFromHlSpace(...);
; 82 void PrintHexByteSpace(...);
; 83 void CmdR(...);
; 84 void GetRamTop(...);
; 85 void SetRamTop(...);
; 86 void CmdA(...);
; 87 void CmdD(...);
; 88 void PrintSpacesTo(...);
; 89 void PrintSpace();
; 90 void CmdC(...);
; 91 void CmdF(...);
; 92 void CmdS(...);
; 93 void CmdW(...);
; 94 void CmdT(...);
; 95 void CmdM(...);
; 96 void CmdG(...);
; 97 void BreakPointHandler(...);
; 98 void CmdX(...);
; 99 void GetCursor();
; 100 void GetCursorChar();
; 101 void CmdH(...);
; 102 void CmdI(...);
; 103 void MonitorError();
; 104 void ReadTapeFile(...);
; 105 void ReadTapeWordNext();
; 106 void ReadTapeWord(...);
; 107 void ReadTapeBlock(...);
; 108 void CalculateCheckSum(...);
; 109 void CmdO(...);
; 110 void WriteTapeFile(...);
; 111 void PrintCrLfTabHexWordSpace(...);
; 112 void PrintHexWordSpace(...);
; 113 void WriteTapeBlock(...);
; 114 void WriteTapeWord(...);
; 115 void ReadTapeByte(...);
; 116 void ReadTapeByteInternal(...);
; 117 void ReadTapeByteTimeout(...);
; 118 void WriteTapeByte(...);
; 119 void PrintHexByte(...);
; 120 void PrintHexNibble(...);
; 121 void PrintCharA(...);
; 122 void PrintChar(...);
; 123 void PrintCharSetEscState(...);
; 124 void PrintCharSaveCursor(...);
; 125 void PrintCharExit(...);
; 126 void DrawCursor(...);
; 127 void PrintCharEscY2(...);
; 128 void PrintCharResetEscState(...);
; 129 void PrintCharEsc(...);
; 130 void SetCursorVisible(...);
; 131 void PrintCharNoEsc(...);
; 132 void PrintChar4(...);
; 133 void ClearScreen(...);
; 134 void MoveCursorHome(...);
; 135 void PrintChar3(...);
; 136 void PrintCharBeep(...);
; 137 void MoveCursorCr(...);
; 138 void MoveCursorRight(...);
; 139 void MoveCursorBoundary(...);
; 140 void MoveCursorLeft(...);
; 141 void MoveCursorLf(...);
; 142 void MoveCursorUp(...);
; 143 void MoveCursor(...);
; 144 void MoveCursorDown(...);
; 145 void PrintCrLf();
; 146 void IsAnyKeyPressed();
; 147 void ReadKey();
; 148 void ReadKeyInternal(...);
; 149 void ScanKey();
; 150 void ScanKey2(...);
; 151 void ScanKeyExit(...);
; 152 void ScanKeyControl(...);
; 153 void ScanKeyShift(...);
; 154 void ScanKeySpecial(...);
; 155 void TranslateCodePageDefault(...);
; 156 void TryScrollUp(...);
; 157 
; 158 // Переменные Монитора
; 159 
; 160 extern uint16_t cursor __address(0xF75A);
; 161 extern uint8_t tapeReadSpeed __address(0xF75C);
; 162 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 163 extern uint8_t cursorVisible __address(0xF75E);
; 164 extern uint8_t escState __address(0xF75F);
; 165 extern uint16_t keyDelay __address(0xF760);
; 166 extern uint16_t regPC __address(0xF762);
; 167 extern uint16_t regHL __address(0xF764);
; 168 extern uint16_t regBC __address(0xF766);
; 169 extern uint16_t regDE __address(0xF768);
; 170 extern uint16_t regSP __address(0xF76A);
; 171 extern uint16_t regAF __address(0xF76C);
; 172 extern uint16_t breakPointAddress __address(0xF771);
; 173 extern uint8_t breakPointValue __address(0xF773);
; 174 extern uint8_t jmpParam1Opcode __address(0xF774);
; 175 extern uint16_t param1 __address(0xF775);
; 176 extern uint16_t param2 __address(0xF777);
; 177 extern uint16_t param3 __address(0xF779);
; 178 extern uint8_t param2Exists __address(0xF77B);
; 179 extern uint8_t tapePolarity __address(0xF77C);
; 180 extern uint8_t translateCodeEnabled __address(0xF77D);
; 181 extern uint8_t translateCodePageJump __address(0xF77E);
; 182 extern uint16_t translateCodePageAddress __address(0xF77F);
; 183 extern uint16_t ramTop __address(0xF781);
; 184 extern uint8_t inputBuffer[32] __address(0xF783);
; 185 
; 186 #define firstVariableAddress (&tapeWriteSpeed)
; 187 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 188 
; 189 extern uint8_t specialKeyTable[8];
; 190 extern uint8_t aPrompt[6];
; 191 extern uint8_t aCrLfTab[6];
; 192 extern uint8_t aRegisters[37];
; 193 extern uint8_t aBackspace[4];
; 194 extern uint8_t aHello[9];
; 195 
; 196 // Для удобства
; 197 
; 198 void JmpParam1() __address(0xF774);
; 199 void TranslateCodePage() __address(0xF77E);
; 200 
; 201 // Точки входа
; 202 
; 203 void EntryF800_Reboot() {
entryf800_reboot:
; 204     Reboot();
	jp reboot
; 205 }
; 206 
; 207 void EntryF803_ReadKey() {
entryf803_readkey:
; 208     ReadKey();
	jp readkey
; 209 }
; 210 
; 211 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 212     ReadTapeByte(a);
	jp readtapebyte
; 213 }
; 214 
; 215 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 216     PrintChar(c);
	jp printchar
; 217 }
; 218 
; 219 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 220     WriteTapeByte(c);
	jp writetapebyte
; 221 }
; 222 
; 223 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 224     TranslateCodePage(c);
	jp translatecodepage
; 225 }
; 226 
; 227 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 228     IsAnyKeyPressed();
	jp isanykeypressed
; 229 }
; 230 
; 231 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 232     PrintHexByte(a);
	jp printhexbyte
; 233 }
; 234 
; 235 void EntryF818_PrintString(...) {
entryf818_printstring:
; 236     PrintString(hl);
	jp printstring
; 237 }
; 238 
; 239 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 240     ScanKey();
	jp scankey
; 241 }
; 242 
; 243 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 244     GetCursor();
	jp getcursor
; 245 }
; 246 
; 247 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 248     GetCursorChar();
	jp getcursorchar
; 249 }
; 250 
; 251 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 252     ReadTapeFile(hl);
	jp readtapefile
; 253 }
; 254 
; 255 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 256     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 257 }
; 258 
; 259 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 260     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 261 }
; 262 
; 263 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 264     return;
	ret
; 265     return;
	ret
; 266     return;
	ret
; 267 }
; 268 
; 269 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 270     GetRamTop();
	jp getramtop
; 271 }
; 272 
; 273 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 274     SetRamTop(hl);
	jp setramtop
; 275 }
; 276 
; 277 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 278 // Параметры: нет. Функция никогда не завершается.
; 279 
; 280 void Reboot(...) {
reboot:
; 281     sp = STACK_TOP;
	ld sp, 63488
; 282 
; 283     // Очистка памяти
; 284     hl = firstVariableAddress;
	ld hl, 0FFFFh & (tapewritespeed)
; 285     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 286     bc = 0;
	ld bc, 0
; 287     CmdF();
	call cmdf
; 288 
; 289     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 290 
; 291     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 292 
; 293     // Проверка ОЗУ
; 294     hl = 0;
	ld hl, 0
; 295     for (;;) {
l_1:
; 296         c = *hl;
	ld c, (hl)
; 297         a = 0x55;
	ld a, 85
; 298         *hl = a;
	ld (hl), a
; 299         a ^= *hl;
	xor (hl)
; 300         b = a;
	ld b, a
; 301         a = 0xAA;
	ld a, 170
; 302         *hl = a;
	ld (hl), a
; 303         a ^= *hl;
	xor (hl)
; 304         a |= b;
	or b
; 305         if (flag_nz)
; 306             return Reboot2();
	jp nz, reboot2
; 307         *hl = c;
	ld (hl), c
; 308         hl++;
	inc hl
; 309         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 310             return Reboot2();
	jp z, reboot2
	jp l_1
; 311     }
; 312 
; 313     Reboot2();
	jp reboot2
 .org 0xF86C
; 314 }
; 315 
; 316 asm(" .org 0xF86C");
; 317 
; 318 void EntryF86C_Monitor() {
entryf86c_monitor:
; 319     Monitor();
	jp monitor
; 320 }
; 321 
; 322 void Reboot2(...) {
reboot2:
; 323     hl--;
	dec hl
; 324     ramTop = hl;
	ld (ramtop), hl
; 325     PrintHexWordSpace(hl);
	call printhexwordspace
; 326     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 327     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 328     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 329     Monitor();
; 330 }
; 331 
; 332 void Monitor() {
monitor:
; 333     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 334     cursorVisible = a;
	ld (cursorvisible), a
; 335     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 336     Monitor2();
; 337 }
; 338 
; 339 void Monitor2() {
monitor2:
; 340     sp = STACK_TOP;
	ld sp, 63488
; 341     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 342     ReadString();
	call readstring
; 343 
; 344     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 345 
; 346     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 347     a = *hl;
	ld a, (hl)
; 348 
; 349     if (a == 'X')
	cp 88
; 350         return CmdX();
	jp z, cmdx
; 351 
; 352     push_pop(a) {
	push af
; 353         ParseParams();
	call parseparams
; 354         hl = param3;
	ld hl, (param3)
; 355         c = l;
	ld c, l
; 356         b = h;
	ld b, h
; 357         hl = param2;
	ld hl, (param2)
; 358         swap(hl, de);
	ex hl, de
; 359         hl = param1;
	ld hl, (param1)
	pop af
; 360     }
; 361 
; 362     if (a == 'D')
	cp 68
; 363         return CmdD();
	jp z, cmdd
; 364     if (a == 'C')
	cp 67
; 365         return CmdC();
	jp z, cmdc
; 366     if (a == 'F')
	cp 70
; 367         return CmdF();
	jp z, cmdf
; 368     if (a == 'S')
	cp 83
; 369         return CmdS();
	jp z, cmds
; 370     if (a == 'T')
	cp 84
; 371         return CmdT();
	jp z, cmdt
; 372     if (a == 'M')
	cp 77
; 373         return CmdM();
	jp z, cmdm
; 374     if (a == 'G')
	cp 71
; 375         return CmdG();
	jp z, cmdg
; 376     if (a == 'I')
	cp 73
; 377         return CmdI();
	jp z, cmdi
; 378     if (a == 'O')
	cp 79
; 379         return CmdO();
	jp z, cmdo
; 380     if (a == 'W')
	cp 87
; 381         return CmdW();
	jp z, cmdw
; 382     if (a == 'A')
	cp 65
; 383         return CmdA();
	jp z, cmda
; 384     if (a == 'H')
	cp 72
; 385         return CmdH();
	jp z, cmdh
; 386     if (a == 'R')
	cp 82
; 387         return CmdR();
	jp z, cmdr
; 388     MonitorError();
	jp monitorerror
; 389 }
; 390 
; 391 void ReadStringBackspace(...) {
readstringbackspace:
; 392     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 393         return ReadStringBegin(hl);
	jp z, readstringbegin
; 394     push_pop(hl) {
	push hl
; 395         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 396     }
; 397     hl--;
	dec hl
; 398     ReadStringLoop(b, hl);
	jp readstringloop
; 399 }
; 400 
; 401 void ReadString() {
readstring:
; 402     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 403     ReadStringBegin(hl);
; 404 }
; 405 
; 406 void ReadStringBegin(...) {
readstringbegin:
; 407     b = 0;
	ld b, 0
; 408     ReadStringLoop(b, hl);
; 409 }
; 410 
; 411 void ReadStringLoop(...) {
readstringloop:
; 412     for (;;) {
l_4:
; 413         ReadKey();
	call readkey
; 414         if (a == 127)
	cp 127
; 415             return ReadStringBackspace();
	jp z, readstringbackspace
; 416         if (a == 8)
	cp 8
; 417             return ReadStringBackspace();
	jp z, readstringbackspace
; 418         if (flag_nz)
; 419             PrintCharA(a);
	call nz, printchara
; 420         *hl = a;
	ld (hl), a
; 421         if (a == 13)
	cp 13
; 422             return ReadStringExit(b);
	jp z, readstringexit
; 423         if (a == '.')
	cp 46
; 424             return Monitor2();
	jp z, monitor2
; 425         b = 255;
	ld b, 255
; 426         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 427             return MonitorError();
	jp z, monitorerror
; 428         hl++;
	inc hl
	jp l_4
; 429     }
; 430 }
; 431 
; 432 void ReadStringExit(...) {
readstringexit:
; 433     a = b;
	ld a, b
; 434     carry_rotate_left(a, 1);
	rla
; 435     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 436     b = 0;
	ld b, 0
	ret
; 437 }
; 438 
; 439 // Функция для пользовательской программы.
; 440 // Вывод строки на экран.
; 441 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 442 
; 443 void PrintString(...) {
printstring:
; 444     for (;;) {
l_7:
; 445         a = *hl;
	ld a, (hl)
; 446         if (flag_z(a &= a))
	and a
; 447             return;
	ret z
; 448         PrintCharA(a);
	call printchara
; 449         hl++;
	inc hl
	jp l_7
; 450     }
; 451 }
; 452 
; 453 void ParseParams(...) {
parseparams:
; 454     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 455     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 456     c = 0;
	ld c, 0
; 457     CmdF();
	call cmdf
; 458 
; 459     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 460 
; 461     ParseWord();
	call parseword
; 462     param1 = hl;
	ld (param1), hl
; 463     param2 = hl;
	ld (param2), hl
; 464     if (flag_c)
; 465         return;
	ret c
; 466 
; 467     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 468     ParseWord();
	call parseword
; 469     param2 = hl;
	ld (param2), hl
; 470     if (flag_c)
; 471         return;
	ret c
; 472 
; 473     ParseWord();
	call parseword
; 474     param3 = hl;
	ld (param3), hl
; 475     if (flag_c)
; 476         return;
	ret c
; 477 
; 478     MonitorError();
	jp monitorerror
; 479 }
; 480 
; 481 void ParseWord(...) {
parseword:
; 482     hl = 0;
	ld hl, 0
; 483     for (;;) {
l_10:
; 484         a = *de;
	ld a, (de)
; 485         de++;
	inc de
; 486         if (a == 13)
	cp 13
; 487             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 488         if (a == ',')
	cp 44
; 489             return;
	ret z
; 490         if (a == ' ')
	cp 32
; 491             continue;
	jp z, l_10
; 492         a -= '0';
	sub 48
; 493         if (flag_m)
; 494             return MonitorError();
	jp m, monitorerror
; 495         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 496             if (flag_m(compare(a, 17)))
	cp 17
; 497                 return MonitorError();
	jp m, monitorerror
; 498             if (flag_p(compare(a, 23)))
	cp 23
; 499                 return MonitorError();
	jp p, monitorerror
; 500             a -= 7;
	sub 7
l_12:
; 501         }
; 502         c = a;
	ld c, a
; 503         hl += hl;
	add hl, hl
; 504         hl += hl;
	add hl, hl
; 505         hl += hl;
	add hl, hl
; 506         hl += hl;
	add hl, hl
; 507         if (flag_c)
; 508             return MonitorError();
	jp c, monitorerror
; 509         hl += bc;
	add hl, bc
	jp l_10
; 510     }
; 511 }
; 512 
; 513 void ParseWordReturnCf(...) {
parsewordreturncf:
; 514     set_flag_c();
	scf
	ret
; 515 }
; 516 
; 517 void CompareHlDe(...) {
comparehlde:
; 518     if ((a = h) != d)
	ld a, h
	cp d
; 519         return;
	ret nz
; 520     compare(a = l, e);
	ld a, l
	cp e
	ret
; 521 }
; 522 
; 523 void LoopWithBreak(...) {
loopwithbreak:
; 524     CtrlC();
	call ctrlc
; 525     Loop(hl, de);
; 526 }
; 527 
; 528 void Loop(...) {
loop:
; 529     CompareHlDe(hl, de);
	call comparehlde
; 530     if (flag_nz)
; 531         return IncHl(hl);
	jp nz, inchl
; 532     PopRet();
; 533 }
; 534 
; 535 void PopRet() {
popret:
; 536     sp++;
	inc sp
; 537     sp++;
	inc sp
	ret
; 538 }
; 539 
; 540 void IncHl(...) {
inchl:
; 541     hl++;
	inc hl
	ret
; 542 }
; 543 
; 544 void CtrlC() {
ctrlc:
; 545     ScanKey();
	call scankey
; 546     if (a != 3)  // УПР + C
	cp 3
; 547         return;
	ret nz
; 548     MonitorError();
	jp monitorerror
; 549 }
; 550 
; 551 void PrintCrLfTab() {
printcrlftab:
; 552     push_pop(hl) {
	push hl
; 553         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 554     }
; 555 }
; 556 
; 557 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 558     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 559 }
; 560 
; 561 void PrintHexByteSpace(...) {
printhexbytespace:
; 562     push_pop(bc) {
	push bc
; 563         PrintHexByte(a);
	call printhexbyte
; 564         PrintSpace();
	call printspace
	pop bc
	ret
; 565     }
; 566 }
; 567 
; 568 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 569 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 570 
; 571 void CmdR(...) {
cmdr:
; 572     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 573     for (;;) {
l_15:
; 574         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 575         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 576         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 577         bc++;
	inc bc
; 578         Loop();
	call loop
	jp l_15
; 579     }
; 580 }
; 581 
; 582 // Функция для пользовательской программы.
; 583 // Получить адрес последнего доступного байта оперативной памяти.
; 584 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 585 
; 586 void GetRamTop(...) {
getramtop:
; 587     hl = ramTop;
	ld hl, (ramtop)
	ret
; 588 }
; 589 
; 590 // Функция для пользовательской программы.
; 591 // Установить адрес последнего доступного байта оперативной памяти.
; 592 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 593 
; 594 void SetRamTop(...) {
setramtop:
; 595     ramTop = hl;
	ld (ramtop), hl
	ret
; 596 }
; 597 
; 598 // Команда A <адрес>
; 599 // Установить программу преобразования кодировки символов выводимых на экран
; 600 
; 601 void CmdA(...) {
cmda:
; 602     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 603 }
; 604 
; 605 // Команда D <начальный адрес> <конечный адрес>
; 606 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 607 
; 608 void CmdD(...) {
cmdd:
; 609     for (;;) {
l_18:
; 610         PrintCrLf();
	call printcrlf
; 611         PrintHexWordSpace(hl);
	call printhexwordspace
; 612         push_pop(hl) {
	push hl
; 613             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 614             carry_rotate_right(a, 1);
	rra
; 615             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 616             PrintSpacesTo();
	call printspacesto
; 617             do {
l_20:
; 618                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 619                 CompareHlDe(hl, de);
	call comparehlde
; 620                 hl++;
	inc hl
; 621                 if (flag_z)
; 622                     break;
	jp z, l_22
; 623                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 624                 push_pop(a) {
	push af
; 625                     a &= 1;
	and 1
; 626                     if (flag_z)
; 627                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 628                 }
; 629             } while (flag_nz);
; 630         }
; 631 
; 632         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 633         PrintSpacesTo(b);
	call printspacesto
; 634 
; 635         do {
l_23:
; 636             a = *hl;
	ld a, (hl)
; 637             if (a < 127)
	cp 127
; 638                 if (a >= 32)
	jp nc, l_26
	cp 32
; 639                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 640             a = '.';
	ld a, 46
; 641         loc_fa49:
loc_fa49:
; 642             PrintCharA(a);
	call printchara
; 643             CompareHlDe(hl, de);
	call comparehlde
; 644             if (flag_z)
; 645                 return;
	ret z
; 646             hl++;
	inc hl
; 647             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 648         } while (flag_nz);
; 649     }
; 650 }
; 651 
; 652 void PrintSpacesTo(...) {
printspacesto:
; 653     for (;;) {
l_29:
; 654         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 655             return;
	ret nc
; 656         PrintSpace();
	call printspace
	jp l_29
; 657     }
; 658 }
; 659 
; 660 void PrintSpace() {
printspace:
; 661     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 662 }
; 663 
; 664 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 665 // Сравнить два блока адресного пространство
; 666 
; 667 void CmdC(...) {
cmdc:
; 668     for (;;) {
l_32:
; 669         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 670             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 671             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 672             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 673         }
; 674         bc++;
	inc bc
; 675         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 676     }
; 677 }
; 678 
; 679 // Команда F <начальный адрес> <конечный адрес> <байт>
; 680 // Заполнить блок в адресном пространстве одним байтом
; 681 
; 682 void CmdF(...) {
cmdf:
; 683     for (;;) {
l_37:
; 684         *hl = c;
	ld (hl), c
; 685         Loop();
	call loop
	jp l_37
; 686     }
; 687 }
; 688 
; 689 // Команда S <начальный адрес> <конечный адрес> <байт>
; 690 // Найти байт (8 битное значение) в адресном пространстве
; 691 
; 692 void CmdS(...) {
cmds:
; 693     for (;;) {
l_40:
; 694         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 695             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 696         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 697     }
; 698 }
; 699 
; 700 // Команда W <начальный адрес> <конечный адрес> <слово>
; 701 // Найти слово (16 битное значение) в адресном пространстве
; 702 
; 703 void CmdW(...) {
cmdw:
; 704     for (;;) {
l_43:
; 705         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 706             hl++;
	inc hl
; 707             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 708             hl--;
	dec hl
; 709             if (flag_z)
; 710                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 711         }
; 712         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 713     }
; 714 }
; 715 
; 716 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 717 // Копировать блок в адресном пространстве
; 718 
; 719 void CmdT(...) {
cmdt:
; 720     for (;;) {
l_48:
; 721         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 722         bc++;
	inc bc
; 723         Loop();
	call loop
	jp l_48
; 724     }
; 725 }
; 726 
; 727 // Команда M <начальный адрес>
; 728 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 729 
; 730 void CmdM(...) {
cmdm:
; 731     for (;;) {
l_51:
; 732         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 733         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 734         push_pop(hl) {
	push hl
; 735             ReadString();
	call readstring
	pop hl
; 736         }
; 737         if (flag_c) {
	jp nc, l_53
; 738             push_pop(hl) {
	push hl
; 739                 ParseWord();
	call parseword
; 740                 a = l;
	ld a, l
	pop hl
; 741             }
; 742             *hl = a;
	ld (hl), a
l_53:
; 743         }
; 744         hl++;
	inc hl
	jp l_51
; 745     }
; 746 }
; 747 
; 748 // Команда G <начальный адрес> <конечный адрес>
; 749 // Запуск программы и возможным указанием точки останова.
; 750 
; 751 void CmdG(...) {
cmdg:
; 752     CompareHlDe(hl, de);
	call comparehlde
; 753     if (flag_nz) {
	jp z, l_55
; 754         swap(hl, de);
	ex hl, de
; 755         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 756         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 757         *hl = OPCODE_RST_30;
	ld (hl), 247
; 758         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 759         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 760     }
; 761     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 762     pop(bc);
	pop bc
; 763     pop(de);
	pop de
; 764     pop(hl);
	pop hl
; 765     pop(a);
	pop af
; 766     sp = hl;
	ld sp, hl
; 767     hl = regHL;
	ld hl, (reghl)
; 768     JmpParam1();
	jp jmpparam1
; 769 }
; 770 
; 771 void BreakPointHandler(...) {
breakpointhandler:
; 772     regHL = hl;
	ld (reghl), hl
; 773     push(a);
	push af
; 774     pop(hl);
	pop hl
; 775     regAF = hl;
	ld (regaf), hl
; 776     pop(hl);
	pop hl
; 777     hl--;
	dec hl
; 778     regPC = hl;
	ld (regpc), hl
; 779     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 780     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 781     push(hl);
	push hl
; 782     push(de);
	push de
; 783     push(bc);
	push bc
; 784     sp = STACK_TOP;
	ld sp, 63488
; 785     hl = regPC;
	ld hl, (regpc)
; 786     swap(hl, de);
	ex hl, de
; 787     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 788     CompareHlDe(hl, de);
	call comparehlde
; 789     if (flag_nz)
; 790         return CmdX();
	jp nz, cmdx
; 791     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 792     CmdX();
; 793 }
; 794 
; 795 // Команда X
; 796 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 797 
; 798 void CmdX(...) {
cmdx:
; 799     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 800     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 801     b = 6;
	ld b, 6
; 802     do {
l_57:
; 803         e = *hl;
	ld e, (hl)
; 804         hl++;
	inc hl
; 805         d = *hl;
	ld d, (hl)
; 806         push(bc);
	push bc
; 807         push(hl);
	push hl
; 808         swap(hl, de);
	ex hl, de
; 809         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 810         ReadString();
	call readstring
; 811         if (flag_c) {
	jp nc, l_60
; 812             ParseWord();
	call parseword
; 813             pop(de);
	pop de
; 814             push(de);
	push de
; 815             swap(hl, de);
	ex hl, de
; 816             *hl = d;
	ld (hl), d
; 817             hl--;
	dec hl
; 818             *hl = e;
	ld (hl), e
l_60:
; 819         }
; 820         pop(hl);
	pop hl
; 821         pop(bc);
	pop bc
; 822         b--;
	dec b
; 823         hl++;
	inc hl
l_58:
	jp nz, l_57
; 824     } while (flag_nz);
; 825     EntryF86C_Monitor();
	jp entryf86c_monitor
; 826 }
; 827 
; 828 // Функция для пользовательской программы.
; 829 // Получить координаты курсора.
; 830 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 831 
; 832 void GetCursor() {
getcursor:
; 833     push_pop(a) {
	push af
; 834         hl = cursor;
	ld hl, (cursor)
; 835         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 836 
; 837         // Вычисление X
; 838         a = l;
	ld a, l
; 839         a &= (SCREEN_WIDTH - 1);
	and 63
; 840         a += 8;  // Смещение Радио 86РК
	add 8
; 841 
; 842         // Вычисление Y
; 843         hl += hl;
	add hl, hl
; 844         hl += hl;
	add hl, hl
; 845         h++;  // Смещение Радио 86РК
	inc h
; 846         h++;
	inc h
; 847         h++;
	inc h
; 848 
; 849         l = a;
	ld l, a
	pop af
	ret
; 850     }
; 851 }
; 852 
; 853 // Функция для пользовательской программы.
; 854 // Получить символ под курсором.
; 855 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 856 
; 857 void GetCursorChar() {
getcursorchar:
; 858     push_pop(hl) {
	push hl
; 859         hl = cursor;
	ld hl, (cursor)
; 860         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 861     }
; 862 }
; 863 
; 864 // Команда H
; 865 // Определить скорости записанной программы.
; 866 // Выводит 4 цифры на экран.
; 867 // Первые две цифры - константа вывода для команды O
; 868 // Последние две цифры - константа вввода для команды I
; 869 
; 870 void CmdH(...) {
cmdh:
; 871     PrintCrLfTab();
	call printcrlftab
; 872     hl = 65408;
	ld hl, 65408
; 873     b = 123;
	ld b, 123
; 874 
; 875     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 876 
; 877     do {
l_62:
l_63:
; 878     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 879 
; 880     do {
l_65:
; 881         c = a;
	ld c, a
; 882         do {
l_68:
; 883             hl++;
	inc hl
l_69:
; 884         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 885     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 886 
; 887     hl += hl;
	add hl, hl
; 888     a = h;
	ld a, h
; 889     hl += hl;
	add hl, hl
; 890     l = (a += h);
	add h
	ld l, a
; 891 
; 892     PrintHexWordSpace();
	jp printhexwordspace
; 893 }
; 894 
; 895 // Команда I <смещение> <скорость>
; 896 // Загрузить файл с магнитной ленты
; 897 
; 898 void CmdI(...) {
cmdi:
; 899     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 900         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 901     ReadTapeFile();
	call readtapefile
; 902     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 903     swap(hl, de);
	ex hl, de
; 904     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 905     swap(hl, de);
	ex hl, de
; 906     push(bc);
	push bc
; 907     CalculateCheckSum();
	call calculatechecksum
; 908     h = b;
	ld h, b
; 909     l = c;
	ld l, c
; 910     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 911     pop(de);
	pop de
; 912     CompareHlDe(hl, de);
	call comparehlde
; 913     if (flag_z)
; 914         return;
	ret z
; 915     swap(hl, de);
	ex hl, de
; 916     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 917     MonitorError();
; 918 }
; 919 
; 920 void MonitorError() {
monitorerror:
; 921     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 922     Monitor2();
	jp monitor2
; 923 }
; 924 
; 925 // Функция для пользовательской программы.
; 926 // Загрузить файл с магнитной ленты.
; 927 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 928 
; 929 void ReadTapeFile(...) {
readtapefile:
; 930     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 931     push_pop(hl) {
	push hl
; 932         hl += bc;
	add hl, bc
; 933         swap(hl, de);
	ex hl, de
; 934         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 935     }
; 936     hl += bc;
	add hl, bc
; 937     swap(hl, de);
	ex hl, de
; 938 
; 939     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 940     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 941     if (flag_z)
; 942         return;
	ret z
; 943 
; 944     push_pop(hl) {
	push hl
; 945         ReadTapeBlock();
	call readtapeblock
; 946         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 947     }
; 948 }
; 949 
; 950 void ReadTapeWordNext() {
readtapewordnext:
; 951     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 952 }
; 953 
; 954 void ReadTapeWord(...) {
readtapeword:
; 955     ReadTapeByte(a);
	call readtapebyte
; 956     b = a;
	ld b, a
; 957     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 958     c = a;
	ld c, a
	ret
; 959 }
; 960 
; 961 void ReadTapeBlock(...) {
readtapeblock:
; 962     for (;;) {
l_74:
; 963         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 964         *hl = a;
	ld (hl), a
; 965         Loop();
	call loop
	jp l_74
; 966     }
; 967 }
; 968 
; 969 // Функция для пользовательской программы.
; 970 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 971 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 972 
; 973 void CalculateCheckSum(...) {
calculatechecksum:
; 974     bc = 0;
	ld bc, 0
; 975     for (;;) {
l_77:
; 976         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 977         push_pop(a) {
	push af
; 978             CompareHlDe(hl, de);
	call comparehlde
; 979             if (flag_z)
; 980                 return PopRet();
	jp z, popret
	pop af
; 981         }
; 982         a = b;
	ld a, b
; 983         carry_add(a, *hl);
	adc (hl)
; 984         b = a;
	ld b, a
; 985         Loop();
	call loop
	jp l_77
; 986     }
; 987 }
; 988 
; 989 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 990 // Сохранить блок данных на магнитную ленту
; 991 
; 992 void CmdO(...) {
cmdo:
; 993     if ((a = c) != 0)
	ld a, c
	or a
; 994         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 995     push_pop(hl) {
	push hl
; 996         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 997     }
; 998     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 999     swap(hl, de);
	ex hl, de
; 1000     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1001     swap(hl, de);
	ex hl, de
; 1002     push_pop(hl) {
	push hl
; 1003         h = b;
	ld h, b
; 1004         l = c;
	ld l, c
; 1005         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1006     }
; 1007     WriteTapeFile(hl, de);
; 1008 }
; 1009 
; 1010 // Функция для пользовательской программы.
; 1011 // Запись файла на магнитную ленту.
; 1012 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1013 
; 1014 void WriteTapeFile(...) {
writetapefile:
; 1015     push(bc);
	push bc
; 1016     bc = 0;
	ld bc, 0
; 1017     do {
l_81:
; 1018         WriteTapeByte(c);
	call writetapebyte
; 1019         b--;
	dec b
; 1020         swap(hl, *sp);
	ex (sp), hl
; 1021         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1022     } while (flag_nz);
; 1023     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1024     WriteTapeWord(hl);
	call writetapeword
; 1025     swap(hl, de);
	ex hl, de
; 1026     WriteTapeWord(hl);
	call writetapeword
; 1027     swap(hl, de);
	ex hl, de
; 1028     WriteTapeBlock(hl, de);
	call writetapeblock
; 1029     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1030     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1031     pop(hl);
	pop hl
; 1032     WriteTapeWord(hl);
	call writetapeword
; 1033     return;
	ret
; 1034 }
; 1035 
; 1036 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1037     push_pop(bc) {
	push bc
; 1038         PrintCrLfTab();
	call printcrlftab
; 1039         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1040     }
; 1041 }
; 1042 
; 1043 void PrintHexWordSpace(...) {
printhexwordspace:
; 1044     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1045     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1046 }
; 1047 
; 1048 void WriteTapeBlock(...) {
writetapeblock:
; 1049     for (;;) {
l_85:
; 1050         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1051         Loop();
	call loop
	jp l_85
; 1052     }
; 1053 }
; 1054 
; 1055 void WriteTapeWord(...) {
writetapeword:
; 1056     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1057     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1058 }
; 1059 
; 1060 // Загрузка байта с магнитной ленты.
; 1061 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1062 // Результат: a = прочитанный байт.
; 1063 
; 1064 void ReadTapeByte(...) {
readtapebyte:
; 1065     push(hl, bc, de);
	push hl
	push bc
	push de
; 1066     d = a;
	ld d, a
; 1067     ReadTapeByteInternal(d);
; 1068 }
; 1069 
; 1070 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1071     c = 0;
	ld c, 0
; 1072     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1073     do {
l_87:
; 1074     retry:  // Сдвиг результата
retry:
; 1075         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1076         cyclic_rotate_left(a, 1);
	rlca
; 1077         c = a;
	ld c, a
; 1078 
; 1079         // Ожидание изменения бита
; 1080         h = 0;
	ld h, 0
; 1081         do {
l_90:
; 1082             h--;
	dec h
; 1083             if (flag_z)
; 1084                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1085         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1086 
; 1087         // Сохранение бита
; 1088         c = (a |= c);
	or c
	ld c, a
; 1089 
; 1090         // Задержка
; 1091         d--;
	dec d
; 1092         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1093         if (flag_z)
; 1094             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1095         b = a;
	ld b, a
; 1096         do {
l_95:
l_96:
; 1097         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1098         d++;
	inc d
; 1099 
; 1100         // Новое значение бита
; 1101         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1102 
; 1103         // Режим поиска синхробайта
; 1104         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1105             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1106                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1107             } else {
; 1108                 if (a != ~TAPE_START)
	cp 65305
; 1109                     goto retry;
	jp nz, retry
; 1110                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1111             }
; 1112             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1113         }
; 1114     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1115     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1116     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1117 }
; 1118 
; 1119 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1120     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1121         return MonitorError();
	jp p, monitorerror
; 1122     CtrlC();
	call ctrlc
; 1123     ReadTapeByteInternal();
	jp readtapebyteinternal
; 1124 }
; 1125 
; 1126 // Функция для пользовательской программы.
; 1127 // Запись байта на магнитную ленту.
; 1128 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1129 
; 1130 void WriteTapeByte(...) {
writetapebyte:
; 1131     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1132         d = 8;
	ld d, 8
; 1133         do {
l_102:
; 1134             // Сдвиг исходного байта
; 1135             a = c;
	ld a, c
; 1136             cyclic_rotate_left(a, 1);
	rlca
; 1137             c = a;
	ld c, a
; 1138 
; 1139             // Вывод
; 1140             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1141             out(PORT_TAPE, a);
	out (1), a
; 1142 
; 1143             // Задержка
; 1144             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1145             do {
l_105:
; 1146                 b--;
	dec b
l_106:
	jp nz, l_105
; 1147             } while (flag_nz);
; 1148 
; 1149             // Вывод
; 1150             (a = 0) ^= c;
	ld a, 0
	xor c
; 1151             out(PORT_TAPE, a);
	out (1), a
; 1152 
; 1153             // Задержка
; 1154             d--;
	dec d
; 1155             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1156             if (flag_z)
; 1157                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1158             b = a;
	ld b, a
; 1159             do {
l_110:
; 1160                 b--;
	dec b
l_111:
	jp nz, l_110
; 1161             } while (flag_nz);
; 1162             d++;
	inc d
l_103:
; 1163         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1164     }
; 1165 }
; 1166 
; 1167 // Функция для пользовательской программы.
; 1168 // Вывод 8 битного числа на экран.
; 1169 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1170 
; 1171 void PrintHexByte(...) {
printhexbyte:
; 1172     push_pop(a) {
	push af
; 1173         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1174         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1175     }
; 1176     PrintHexNibble(a);
; 1177 }
; 1178 
; 1179 void PrintHexNibble(...) {
printhexnibble:
; 1180     a &= 0x0F;
	and 15
; 1181     if (flag_p(compare(a, 10)))
	cp 10
; 1182         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1183     a += '0';
	add 48
; 1184     PrintCharA(a);
; 1185 }
; 1186 
; 1187 // Вывод символа на экран.
; 1188 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1189 
; 1190 void PrintCharA(...) {
printchara:
; 1191     PrintChar(c = a);
	ld c, a
; 1192 }
; 1193 
; 1194 // Функция для пользовательской программы.
; 1195 // Вывод символа на экран.
; 1196 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1197 
; 1198 void PrintChar(...) {
printchar:
; 1199     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1200     IsAnyKeyPressed();
	call isanykeypressed
; 1201     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1202     hl = cursor;
	ld hl, (cursor)
; 1203     a = escState;
	ld a, (escstate)
; 1204     a--;
	dec a
; 1205     if (flag_m)
; 1206         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1207     if (flag_z)
; 1208         return PrintCharEsc();
	jp z, printcharesc
; 1209     a--;
	dec a
; 1210     if (flag_nz)
; 1211         return PrintCharEscY2();
	jp nz, printcharescy2
; 1212 
; 1213     // Первый параметр ESC Y
; 1214     a = c;
	ld a, c
; 1215     a -= ' ';
	sub 32
; 1216     if (flag_m) {
	jp p, l_115
; 1217         a ^= a;
	xor a
	jp l_116
l_115:
; 1218     } else {
; 1219         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1220             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1221     }
; 1222     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1223     c = a;
	ld c, a
; 1224     b = (a &= 192);
	and 192
	ld b, a
; 1225     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1226     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1227     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1228     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1229 }
; 1230 
; 1231 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1232     escState = a;
	ld (escstate), a
; 1233     PrintCharSaveCursor(hl);
; 1234 }
; 1235 
; 1236 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1237     cursor = hl;
	ld (cursor), hl
; 1238     PrintCharExit();
; 1239 }
; 1240 
; 1241 void PrintCharExit(...) {
printcharexit:
; 1242     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1243     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1244 }
; 1245 
; 1246 void DrawCursor(...) {
drawcursor:
; 1247     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1248         return;
	ret z
; 1249     hl = cursor;
	ld hl, (cursor)
; 1250     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1251     *hl = b;
	ld (hl), b
	ret
; 1252 }
; 1253 
; 1254 void PrintCharEscY2(...) {
printcharescy2:
; 1255     a = c;
	ld a, c
; 1256     a -= ' ';
	sub 32
; 1257     if (flag_m) {
	jp p, l_119
; 1258         a ^= a;
	xor a
	jp l_120
l_119:
; 1259     } else {
; 1260         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1261             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1262     }
; 1263     b = a;
	ld b, a
; 1264     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1265     PrintCharResetEscState();
; 1266 }
; 1267 
; 1268 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1269     a ^= a;
	xor a
; 1270     PrintCharSetEscState();
	jp printcharsetescstate
; 1271 }
; 1272 
; 1273 void PrintCharEsc(...) {
printcharesc:
; 1274     a = c;
	ld a, c
; 1275     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1276         a = 2;
	ld a, 2
; 1277         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1278     }
; 1279     if (a == 97) {
	cp 97
	jp nz, l_125
; 1280         a ^= a;
	xor a
; 1281         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1282     }
; 1283     if (a != 98)
	cp 98
; 1284         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1285     SetCursorVisible();
; 1286 }
; 1287 
; 1288 void SetCursorVisible(...) {
setcursorvisible:
; 1289     cursorVisible = a;
	ld (cursorvisible), a
; 1290     PrintCharResetEscState();
	jp printcharresetescstate
; 1291 }
; 1292 
; 1293 void PrintCharNoEsc(...) {
printcharnoesc:
; 1294     // Остановка вывода нажатием УС + Шифт
; 1295     do {
l_127:
; 1296         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1297     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1298 
; 1299     compare(a = 16, c);
	ld a, 16
	cp c
; 1300     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1301     if (flag_z) {
	jp nz, l_130
; 1302         invert(a);
	cpl
; 1303         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1304         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1305     }
; 1306     if (a != 0)
	or a
; 1307         TranslateCodePage(c);
	call nz, translatecodepage
; 1308     a = c;
	ld a, c
; 1309     if (a == 31)
	cp 31
; 1310         return ClearScreen();
	jp z, clearscreen
; 1311     if (flag_m)
; 1312         return PrintChar3(a);
	jp m, printchar3
; 1313     PrintChar4(a);
; 1314 }
; 1315 
; 1316 void PrintChar4(...) {
printchar4:
; 1317     *hl = a;
	ld (hl), a
; 1318     hl++;
	inc hl
; 1319     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1320         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1321     PrintCrLf();
	call printcrlf
; 1322     PrintCharExit();
	jp printcharexit
; 1323 }
; 1324 
; 1325 void ClearScreen(...) {
clearscreen:
; 1326     b = ' ';
	ld b, 32
; 1327     a = SCREEN_END >> 8;
	ld a, 240
; 1328     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1329     do {
l_132:
; 1330         *hl = b;
	ld (hl), b
; 1331         hl++;
	inc hl
; 1332         *hl = b;
	ld (hl), b
; 1333         hl++;
	inc hl
l_133:
; 1334     } while (a != h);
	cp h
	jp nz, l_132
; 1335     MoveCursorHome();
; 1336 }
; 1337 
; 1338 void MoveCursorHome(...) {
movecursorhome:
; 1339     PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1340 }
; 1341 
; 1342 void PrintChar3(...) {
printchar3:
; 1343     if (a == 12)
	cp 12
; 1344         return MoveCursorHome();
	jp z, movecursorhome
; 1345     if (a == 13)
	cp 13
; 1346         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1347     if (a == 10)
	cp 10
; 1348         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1349     if (a == 8)
	cp 8
; 1350         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1351     if (a == 24)
	cp 24
; 1352         return MoveCursorRight(hl);
	jp z, movecursorright
; 1353     if (a == 25)
	cp 25
; 1354         return MoveCursorUp(hl);
	jp z, movecursorup
; 1355     if (a == 7)
	cp 7
; 1356         return PrintCharBeep();
	jp z, printcharbeep
; 1357     if (a == 26)
	cp 26
; 1358         return MoveCursorDown();
	jp z, movecursordown
; 1359     if (a != 27)
	cp 27
; 1360         return PrintChar4(hl, a);
	jp nz, printchar4
; 1361     a = 1;
	ld a, 1
; 1362     PrintCharSetEscState();
	jp printcharsetescstate
; 1363 }
; 1364 
; 1365 void PrintCharBeep(...) {
printcharbeep:
; 1366     c = 128;  // Длительность
	ld c, 128
; 1367     e = 32;   // Частота
	ld e, 32
; 1368     do {
l_135:
; 1369         d = e;
	ld d, e
; 1370         do {
l_138:
; 1371             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1372         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1373         e = d;
	ld e, d
; 1374         do {
l_141:
; 1375             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1376         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1377     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1378 
; 1379     PrintCharExit();
	jp printcharexit
; 1380 }
; 1381 
; 1382 void MoveCursorCr(...) {
movecursorcr:
; 1383     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1384     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1385 }
; 1386 
; 1387 void MoveCursorRight(...) {
movecursorright:
; 1388     hl++;
	inc hl
; 1389     MoveCursorBoundary(hl);
; 1390 }
; 1391 
; 1392 void MoveCursorBoundary(...) {
movecursorboundary:
; 1393     a = h;
	ld a, h
; 1394     a &= 7;
	and 7
; 1395     a |= SCREEN_BEGIN >> 8;
	or 232
; 1396     h = a;
	ld h, a
; 1397     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1398 }
; 1399 
; 1400 void MoveCursorLeft(...) {
movecursorleft:
; 1401     hl--;
	dec hl
; 1402     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1403 }
; 1404 
; 1405 void MoveCursorLf(...) {
movecursorlf:
; 1406     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1407     TryScrollUp(hl);
; 1408 }
; 1409 
; 1410 void TryScrollUp(...) {
tryscrollup:
; 1411     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1412         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1413 
; 1414     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1415     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1416     do {
l_144:
; 1417         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1418         hl++;
	inc hl
; 1419         bc++;
	inc bc
; 1420         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1421         hl++;
	inc hl
; 1422         bc++;
	inc bc
l_145:
; 1423     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1424     a = SCREEN_END >> 8;
	ld a, 240
; 1425     c = ' ';
	ld c, 32
; 1426     do {
l_147:
; 1427         *hl = c;
	ld (hl), c
; 1428         hl++;
	inc hl
; 1429         *hl = c;
	ld (hl), c
; 1430         hl++;
	inc hl
l_148:
; 1431     } while (a != h);
	cp h
	jp nz, l_147
; 1432     hl = cursor;
	ld hl, (cursor)
; 1433     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1434     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1435     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1436 }
; 1437 
; 1438 void MoveCursorUp(...) {
movecursorup:
; 1439     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1440 }
; 1441 
; 1442 void MoveCursor(...) {
movecursor:
; 1443     hl += bc;
	add hl, bc
; 1444     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1445 }
; 1446 
; 1447 void MoveCursorDown(...) {
movecursordown:
; 1448     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1449 }
; 1450 
; 1451 void PrintCrLf() {
printcrlf:
; 1452     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1453     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1454 }
; 1455 
; 1456 // Функция для пользовательской программы.
; 1457 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1458 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1459 
; 1460 void IsAnyKeyPressed() {
isanykeypressed:
; 1461     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1462     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1463     a &= KEYBOARD_ROW_MASK;
	and 127
; 1464     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1465         a ^= a;
	xor a
; 1466         return;
	ret
l_150:
; 1467     }
; 1468     a = 0xFF;
	ld a, 255
	ret
; 1469 }
; 1470 
; 1471 // Функция для пользовательской программы.
; 1472 // Получить код нажатой клавиши на клавиатуре.
; 1473 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1474 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1475 
; 1476 void ReadKey() {
readkey:
; 1477     push_pop(hl) {
	push hl
; 1478         hl = keyDelay;
	ld hl, (keydelay)
; 1479         ReadKeyInternal(hl);
	call readkeyinternal
; 1480         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1481         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1482             do {
l_154:
; 1483                 do {
l_157:
; 1484                     l = 2;
	ld l, 2
; 1485                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1486                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1487             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1488             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1489         }
; 1490         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1491     }
; 1492 }
; 1493 
; 1494 void ReadKeyInternal(...) {
readkeyinternal:
; 1495     do {
l_160:
; 1496         ScanKey();
	call scankey
; 1497         if (a != h)
	cp h
; 1498             break;
	jp nz, l_162
; 1499 
; 1500         // Задержка
; 1501         push_pop(a) {
	push af
; 1502             a ^= a;
	xor a
; 1503             do {
l_163:
; 1504                 swap(hl, de);
	ex hl, de
; 1505                 swap(hl, de);
	ex hl, de
l_164:
; 1506             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1507         }
; 1508     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1509     h = a;
	ld h, a
	ret
; 1510 }
; 1511 
; 1512 // Функция для пользовательской программы.
; 1513 // Получить код нажатой клавиши на клавиатуре.
; 1514 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1515 
; 1516 void ScanKey() {
scankey:
; 1517     push(bc, de, hl);
	push bc
	push de
	push hl
; 1518 
; 1519     bc = 0x00FE;
	ld bc, 254
; 1520     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1521     do {
l_166:
; 1522         a = c;
	ld a, c
; 1523         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1524         cyclic_rotate_left(a, 1);
	rlca
; 1525         c = a;
	ld c, a
; 1526         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1527         a &= KEYBOARD_ROW_MASK;
	and 127
; 1528         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1529             return ScanKey2(a);
	jp nz, scankey2
; 1530         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1531     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1532 
; 1533     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1534     carry_rotate_right(a, 1);
	rra
; 1535     a = 0xFF;  // Клавиша не нажата
	ld a, 255
; 1536     if (flag_c)
; 1537         return ScanKeyExit(a);
	jp c, scankeyexit
; 1538     a--;  // Рус/Лат
	dec a
; 1539     ScanKeyExit(a);
	jp scankeyexit
; 1540 }
; 1541 
; 1542 void ScanKey2(...) {
scankey2:
; 1543     for (;;) {
l_170:
; 1544         carry_rotate_right(a, 1);
	rra
; 1545         if (flag_nc)
; 1546             break;
	jp nc, l_171
; 1547         b++;
	inc b
	jp l_170
l_171:
; 1548     }
; 1549 
; 1550     /* b - key number */
; 1551 
; 1552     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1553      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1554      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1555      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1556      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1557      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1558      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1559 
; 1560     a = b;
	ld a, b
; 1561     if (a >= 48)
	cp 48
; 1562         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1563     a += 48;
	add 48
; 1564     if (a >= 60)
	cp 60
; 1565         if (a < 64)
	jp c, l_172
	cp 64
; 1566             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1567 
; 1568     if (a == 95)
	cp 95
; 1569         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1570 
; 1571     c = a;
	ld c, a
; 1572     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1573     a &= KEYBOARD_MODS_MASK;
	and 7
; 1574     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1575     b = a;
	ld b, a
; 1576     a = c;
	ld a, c
; 1577     if (flag_z)
; 1578         return ScanKeyExit(a);
	jp z, scankeyexit
; 1579     a = b;
	ld a, b
; 1580     carry_rotate_right(a, 2);
	rra
	rra
; 1581     if (flag_nc)
; 1582         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1583     carry_rotate_right(a, 1);
	rra
; 1584     if (flag_nc)
; 1585         return ScanKeyShift();
	jp nc, scankeyshift
; 1586     (a = c) |= 0x20;
	ld a, c
	or 32
; 1587     ScanKeyExit(a);
; 1588 }
; 1589 
; 1590 void ScanKeyExit(...) {
scankeyexit:
; 1591     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1592 }
; 1593 
; 1594 void ScanKeyControl(...) {
scankeycontrol:
; 1595     a = c;
	ld a, c
; 1596     a &= 0x1F;
	and 31
; 1597     ScanKeyExit(a);
	jp scankeyexit
; 1598 }
; 1599 
; 1600 void ScanKeyShift(...) {
scankeyshift:
; 1601     a = c;
	ld a, c
; 1602     if (a == 127)
	cp 127
; 1603         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1604     if (a >= 64)
	cp 64
; 1605         return ScanKeyExit(a);
	jp nc, scankeyexit
; 1606     if (a < 48) {
	cp 48
	jp nc, l_180
; 1607         a |= 16;
	or 16
; 1608         return ScanKeyExit(a);
	jp scankeyexit
l_180:
; 1609     }
; 1610     a &= 47;
	and 47
; 1611     ScanKeyExit();
	jp scankeyexit
; 1612 }
; 1613 
; 1614 void ScanKeySpecial(...) {
scankeyspecial:
; 1615     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1616     c = (a -= 48);
	sub 48
	ld c, a
; 1617     b = 0;
	ld b, 0
; 1618     hl += bc;
	add hl, bc
; 1619     a = *hl;
	ld a, (hl)
; 1620     ScanKeyExit(a);
	jp scankeyexit
; 1621 }
; 1622 
; 1623 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1634  aPrompt[] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1635  aCrLfTab[] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1636  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1637  aBackspace[] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1638  aHello[] = "\x1F\nМ/80К ";
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
; 1640  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1641 }
; 1642 
; 1643 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
