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
; 157 extern uint16_t cursor __address(0xF75A);
; 158 extern uint8_t tapeReadSpeed __address(0xF75C);
; 159 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 160 extern uint8_t cursorVisible __address(0xF75E);
; 161 extern uint8_t escState __address(0xF75F);
; 162 extern uint16_t keyDelay __address(0xF760);
; 163 extern uint16_t regPC __address(0xF762);
; 164 extern uint16_t regHL __address(0xF764);
; 165 extern uint16_t regBC __address(0xF766);
; 166 extern uint16_t regDE __address(0xF768);
; 167 extern uint16_t regSP __address(0xF76A);
; 168 extern uint16_t regAF __address(0xF76C);
; 169 extern uint16_t breakPointAddress __address(0xF771);
; 170 extern uint8_t breakPointValue __address(0xF773);
; 171 extern uint8_t jmpParam1Opcode __address(0xF774);
; 172 extern uint16_t param1 __address(0xF775);
; 173 extern uint16_t param2 __address(0xF777);
; 174 extern uint16_t param3 __address(0xF779);
; 175 extern uint8_t param2Exists __address(0xF77B);
; 176 extern uint8_t tapePolarity __address(0xF77C);
; 177 extern uint8_t translateCodeEnabled __address(0xF77D);
; 178 extern uint8_t translateCodePageJump __address(0xF77E);
; 179 extern uint16_t translateCodePageAddress __address(0xF77F);
; 180 extern uint16_t ramTop __address(0xF781);
; 181 extern uint8_t inputBuffer[32] __address(0xF783);
; 182 
; 183 extern uint8_t specialKeyTable[8];
; 184 extern uint8_t aPrompt[6];
; 185 extern uint8_t aCrLfTab[6];
; 186 extern uint8_t aRegisters[37];
; 187 extern uint8_t aBackspace[4];
; 188 extern uint8_t aHello[9];
; 189 
; 190 // Для удобства
; 191 
; 192 void JmpParam1() __address(0xF774);
; 193 void TranslateCodePage() __address(0xF77E);
; 194 
; 195 // Точки входа
; 196 
; 197 void EntryF800_Reboot() {
entryf800_reboot:
; 198     Reboot();
	jp reboot
; 199 }
; 200 
; 201 void EntryF803_ReadKey() {
entryf803_readkey:
; 202     ReadKey();
	jp readkey
; 203 }
; 204 
; 205 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 206     ReadTapeByte(a);
	jp readtapebyte
; 207 }
; 208 
; 209 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 210     PrintChar(c);
	jp printchar
; 211 }
; 212 
; 213 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 214     WriteTapeByte(c);
	jp writetapebyte
; 215 }
; 216 
; 217 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 218     TranslateCodePage(c);
	jp translatecodepage
; 219 }
; 220 
; 221 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 222     IsAnyKeyPressed();
	jp isanykeypressed
; 223 }
; 224 
; 225 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 226     PrintHexByte(a);
	jp printhexbyte
; 227 }
; 228 
; 229 void EntryF818_PrintString(...) {
entryf818_printstring:
; 230     PrintString(hl);
	jp printstring
; 231 }
; 232 
; 233 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 234     ScanKey();
	jp scankey
; 235 }
; 236 
; 237 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 238     GetCursor();
	jp getcursor
; 239 }
; 240 
; 241 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 242     GetCursorChar();
	jp getcursorchar
; 243 }
; 244 
; 245 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 246     ReadTapeFile(hl);
	jp readtapefile
; 247 }
; 248 
; 249 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 250     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 251 }
; 252 
; 253 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 254     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 255 }
; 256 
; 257 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
	ret
; 258 }
; 259 
; 260 uint16_t empty = 0;
empty:
	dw 0
; 262  EntryF830_GetRamTop() {
entryf830_getramtop:
; 263     GetRamTop();
	jp getramtop
; 264 }
; 265 
; 266 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 267     SetRamTop(hl);
	jp setramtop
; 268 }
; 269 
; 270 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 271 // Параметры: нет. Функция никогда не завершается.
; 272 
; 273 void Reboot(...) {
reboot:
; 274     sp = STACK_TOP;
	ld sp, 63488
; 275 
; 276     // Очистка памяти
; 277     hl = &tapeWriteSpeed;
	ld hl, 0FFFFh & (tapewritespeed)
; 278     de = inputBuffer + sizeof(inputBuffer) - 1;
	ld de, 0FFFFh & (((inputbuffer) + (32)) - (1))
; 279     bc = 0;
	ld bc, 0
; 280     CmdF();
	call cmdf
; 281 
; 282     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 283 
; 284     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 285 
; 286     // Проверка ОЗУ
; 287     hl = 0;
	ld hl, 0
; 288     for (;;) {
l_1:
; 289         c = *hl;
	ld c, (hl)
; 290         a = 0x55;
	ld a, 85
; 291         *hl = a;
	ld (hl), a
; 292         a ^= *hl;
	xor (hl)
; 293         b = a;
	ld b, a
; 294         a = 0xAA;
	ld a, 170
; 295         *hl = a;
	ld (hl), a
; 296         a ^= *hl;
	xor (hl)
; 297         a |= b;
	or b
; 298         if (flag_nz)
; 299             return Reboot2();
	jp nz, reboot2
; 300         *hl = c;
	ld (hl), c
; 301         hl++;
	inc hl
; 302         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 303             return Reboot2();
	jp z, reboot2
	jp l_1
; 304     }
; 305 
; 306     Reboot2();
	jp reboot2
 .org 0xF86C
; 307 }
; 308 
; 309 asm(" .org 0xF86C");
; 310 
; 311 void EntryF86C_Monitor() {
entryf86c_monitor:
; 312     Monitor();
	jp monitor
; 313 }
; 314 
; 315 void Reboot2(...) {
reboot2:
; 316     hl--;
	dec hl
; 317     ramTop = hl;
	ld (ramtop), hl
; 318     PrintHexWordSpace(hl);
	call printhexwordspace
; 319     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 320     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 321     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 322     Monitor();
; 323 }
; 324 
; 325 void Monitor() {
monitor:
; 326     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 327     cursorVisible = a;
	ld (cursorvisible), a
; 328     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 329     Monitor2();
; 330 }
; 331 
; 332 void Monitor2() {
monitor2:
; 333     sp = STACK_TOP;
	ld sp, 63488
; 334     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 335     ReadString();
	call readstring
; 336 
; 337     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 338 
; 339     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 340     a = *hl;
	ld a, (hl)
; 341 
; 342     if (a == 'X')
	cp 88
; 343         return CmdX();
	jp z, cmdx
; 344 
; 345     push_pop(a) {
	push af
; 346         ParseParams();
	call parseparams
; 347         hl = param3;
	ld hl, (param3)
; 348         c = l;
	ld c, l
; 349         b = h;
	ld b, h
; 350         hl = param2;
	ld hl, (param2)
; 351         swap(hl, de);
	ex hl, de
; 352         hl = param1;
	ld hl, (param1)
	pop af
; 353     }
; 354 
; 355     if (a == 'D')
	cp 68
; 356         return CmdD();
	jp z, cmdd
; 357     if (a == 'C')
	cp 67
; 358         return CmdC();
	jp z, cmdc
; 359     if (a == 'F')
	cp 70
; 360         return CmdF();
	jp z, cmdf
; 361     if (a == 'S')
	cp 83
; 362         return CmdS();
	jp z, cmds
; 363     if (a == 'T')
	cp 84
; 364         return CmdT();
	jp z, cmdt
; 365     if (a == 'M')
	cp 77
; 366         return CmdM();
	jp z, cmdm
; 367     if (a == 'G')
	cp 71
; 368         return CmdG();
	jp z, cmdg
; 369     if (a == 'I')
	cp 73
; 370         return CmdI();
	jp z, cmdi
; 371     if (a == 'O')
	cp 79
; 372         return CmdO();
	jp z, cmdo
; 373     if (a == 'W')
	cp 87
; 374         return CmdW();
	jp z, cmdw
; 375     if (a == 'A')
	cp 65
; 376         return CmdA();
	jp z, cmda
; 377     if (a == 'H')
	cp 72
; 378         return CmdH();
	jp z, cmdh
; 379     if (a == 'R')
	cp 82
; 380         return CmdR();
	jp z, cmdr
; 381     return MonitorError();
	jp monitorerror
; 382 }
; 383 
; 384 void ReadStringBackspace(...) {
readstringbackspace:
; 385     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 386         return ReadStringBegin(hl);
	jp z, readstringbegin
; 387     push_pop(hl) {
	push hl
; 388         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 389     }
; 390     hl--;
	dec hl
; 391     return ReadStringLoop(b, hl);
	jp readstringloop
; 392 }
; 393 
; 394 void ReadString() {
readstring:
; 395     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 396     ReadStringBegin(hl);
; 397 }
; 398 
; 399 void ReadStringBegin(...) {
readstringbegin:
; 400     b = 0;
	ld b, 0
; 401     ReadStringLoop(b, hl);
; 402 }
; 403 
; 404 void ReadStringLoop(...) {
readstringloop:
; 405     for (;;) {
l_4:
; 406         ReadKey();
	call readkey
; 407         if (a == 127)
	cp 127
; 408             return ReadStringBackspace();
	jp z, readstringbackspace
; 409         if (a == 8)
	cp 8
; 410             return ReadStringBackspace();
	jp z, readstringbackspace
; 411         if (flag_nz)
; 412             PrintCharA(a);
	call nz, printchara
; 413         *hl = a;
	ld (hl), a
; 414         if (a == 13)
	cp 13
; 415             return ReadStringExit(b);
	jp z, readstringexit
; 416         if (a == '.')
	cp 46
; 417             return Monitor2();
	jp z, monitor2
; 418         b = 255;
	ld b, 255
; 419         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 420             return MonitorError();
	jp z, monitorerror
; 421         hl++;
	inc hl
	jp l_4
; 422     }
; 423 }
; 424 
; 425 void ReadStringExit(...) {
readstringexit:
; 426     a = b;
	ld a, b
; 427     carry_rotate_left(a, 1);
	rla
; 428     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 429     b = 0;
	ld b, 0
	ret
; 430 }
; 431 
; 432 // Функция для пользовательской программы.
; 433 // Вывод строки на экран.
; 434 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 435 
; 436 void PrintString(...) {
printstring:
; 437     for (;;) {
l_7:
; 438         a = *hl;
	ld a, (hl)
; 439         if (flag_z(a &= a))
	and a
; 440             return;
	ret z
; 441         PrintCharA(a);
	call printchara
; 442         hl++;
	inc hl
	jp l_7
; 443     }
; 444 }
; 445 
; 446 void ParseParams(...) {
parseparams:
; 447     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 448     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 449     c = 0;
	ld c, 0
; 450     CmdF();
	call cmdf
; 451 
; 452     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 453 
; 454     ParseWord();
	call parseword
; 455     param1 = hl;
	ld (param1), hl
; 456     param2 = hl;
	ld (param2), hl
; 457     if (flag_c)
; 458         return;
	ret c
; 459 
; 460     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 461     ParseWord();
	call parseword
; 462     param2 = hl;
	ld (param2), hl
; 463     if (flag_c)
; 464         return;
	ret c
; 465 
; 466     ParseWord();
	call parseword
; 467     param3 = hl;
	ld (param3), hl
; 468     if (flag_c)
; 469         return;
	ret c
; 470 
; 471     MonitorError();
	jp monitorerror
; 472 }
; 473 
; 474 void ParseWord(...) {
parseword:
; 475     hl = 0;
	ld hl, 0
; 476     for (;;) {
l_10:
; 477         a = *de;
	ld a, (de)
; 478         de++;
	inc de
; 479         if (a == 13)
	cp 13
; 480             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 481         if (a == ',')
	cp 44
; 482             return;
	ret z
; 483         if (a == ' ')
	cp 32
; 484             continue;
	jp z, l_10
; 485         a -= '0';
	sub 48
; 486         if (flag_m)
; 487             return MonitorError();
	jp m, monitorerror
; 488         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 489             if (flag_m(compare(a, 17)))
	cp 17
; 490                 return MonitorError();
	jp m, monitorerror
; 491             if (flag_p(compare(a, 23)))
	cp 23
; 492                 return MonitorError();
	jp p, monitorerror
; 493             a -= 7;
	sub 7
l_12:
; 494         }
; 495         c = a;
	ld c, a
; 496         hl += hl;
	add hl, hl
; 497         hl += hl;
	add hl, hl
; 498         hl += hl;
	add hl, hl
; 499         hl += hl;
	add hl, hl
; 500         if (flag_c)
; 501             return MonitorError();
	jp c, monitorerror
; 502         hl += bc;
	add hl, bc
	jp l_10
; 503     }
; 504 }
; 505 
; 506 void ParseWordReturnCf(...) {
parsewordreturncf:
; 507     set_flag_c();
	scf
	ret
; 508 }
; 509 
; 510 void CompareHlDe(...) {
comparehlde:
; 511     if ((a = h) != d)
	ld a, h
	cp d
; 512         return;
	ret nz
; 513     compare(a = l, e);
	ld a, l
	cp e
	ret
; 514 }
; 515 
; 516 void LoopWithBreak(...) {
loopwithbreak:
; 517     CtrlC();
	call ctrlc
; 518     Loop(hl, de);
; 519 }
; 520 
; 521 void Loop(...) {
loop:
; 522     CompareHlDe(hl, de);
	call comparehlde
; 523     if (flag_nz)
; 524         return IncHl(hl);
	jp nz, inchl
; 525     PopRet();
; 526 }
; 527 
; 528 void PopRet() {
popret:
; 529     sp++;
	inc sp
; 530     sp++;
	inc sp
	ret
; 531 }
; 532 
; 533 void IncHl(...) {
inchl:
; 534     hl++;
	inc hl
	ret
; 535 }
; 536 
; 537 void CtrlC() {
ctrlc:
; 538     ScanKey();
	call scankey
; 539     if (a != 3)  // УПР + C
	cp 3
; 540         return;
	ret nz
; 541     MonitorError();
	jp monitorerror
; 542 }
; 543 
; 544 void PrintCrLfTab() {
printcrlftab:
; 545     push_pop(hl) {
	push hl
; 546         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 547     }
; 548 }
; 549 
; 550 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 551     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 552 }
; 553 
; 554 void PrintHexByteSpace(...) {
printhexbytespace:
; 555     push_pop(bc) {
	push bc
; 556         PrintHexByte(a);
	call printhexbyte
; 557         PrintSpace();
	call printspace
	pop bc
	ret
; 558     }
; 559 }
; 560 
; 561 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 562 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 563 
; 564 void CmdR(...) {
cmdr:
; 565     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 566     for (;;) {
l_15:
; 567         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 568         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 569         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 570         bc++;
	inc bc
; 571         Loop();
	call loop
	jp l_15
; 572     }
; 573 }
; 574 
; 575 // Функция для пользовательской программы.
; 576 // Получить адрес последнего доступного байта оперативной памяти.
; 577 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 578 
; 579 void GetRamTop(...) {
getramtop:
; 580     hl = ramTop;
	ld hl, (ramtop)
	ret
; 581 }
; 582 
; 583 // Функция для пользовательской программы.
; 584 // Установить адрес последнего доступного байта оперативной памяти.
; 585 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 586 
; 587 void SetRamTop(...) {
setramtop:
; 588     ramTop = hl;
	ld (ramtop), hl
	ret
; 589 }
; 590 
; 591 // Команда A <адрес>
; 592 // Установить программу преобразования кодировки символов выводимых на экран
; 593 
; 594 void CmdA(...) {
cmda:
; 595     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 596 }
; 597 
; 598 // Команда D <начальный адрес> <конечный адрес>
; 599 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 600 
; 601 void CmdD(...) {
cmdd:
; 602     for (;;) {
l_18:
; 603         PrintCrLf();
	call printcrlf
; 604         PrintHexWordSpace(hl);
	call printhexwordspace
; 605         push_pop(hl) {
	push hl
; 606             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 607             carry_rotate_right(a, 1);
	rra
; 608             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 609             PrintSpacesTo();
	call printspacesto
; 610             do {
l_20:
; 611                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 612                 CompareHlDe(hl, de);
	call comparehlde
; 613                 hl++;
	inc hl
; 614                 if (flag_z)
; 615                     break;
	jp z, l_22
; 616                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 617                 push_pop(a) {
	push af
; 618                     a &= 1;
	and 1
; 619                     if (flag_z)
; 620                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 621                 }
; 622             } while (flag_nz);
; 623         }
; 624 
; 625         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 626         PrintSpacesTo(b);
	call printspacesto
; 627 
; 628         do {
l_23:
; 629             a = *hl;
	ld a, (hl)
; 630             if (a < 127)
	cp 127
; 631                 if (a >= 32)
	jp nc, l_26
	cp 32
; 632                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 633             a = '.';
	ld a, 46
; 634         loc_fa49:
loc_fa49:
; 635             PrintCharA(a);
	call printchara
; 636             CompareHlDe(hl, de);
	call comparehlde
; 637             if (flag_z)
; 638                 return;
	ret z
; 639             hl++;
	inc hl
; 640             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 641         } while (flag_nz);
; 642     }
; 643 }
; 644 
; 645 void PrintSpacesTo(...) {
printspacesto:
; 646     for (;;) {
l_29:
; 647         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 648             return;
	ret nc
; 649         PrintSpace();
	call printspace
	jp l_29
; 650     }
; 651 }
; 652 
; 653 void PrintSpace() {
printspace:
; 654     return PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 655 }
; 656 
; 657 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 658 // Сравнить два блока адресного пространство
; 659 
; 660 void CmdC(...) {
cmdc:
; 661     for (;;) {
l_32:
; 662         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 663             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 664             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 665             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 666         }
; 667         bc++;
	inc bc
; 668         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 669     }
; 670 }
; 671 
; 672 // Команда F <начальный адрес> <конечный адрес> <байт>
; 673 // Заполнить блок в адресном пространстве одним байтом
; 674 
; 675 void CmdF(...) {
cmdf:
; 676     for (;;) {
l_37:
; 677         *hl = c;
	ld (hl), c
; 678         Loop();
	call loop
	jp l_37
; 679     }
; 680 }
; 681 
; 682 // Команда S <начальный адрес> <конечный адрес> <байт>
; 683 // Найти байт (8 битное значение) в адресном пространстве
; 684 
; 685 void CmdS(...) {
cmds:
; 686     for (;;) {
l_40:
; 687         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 688             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 689         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 690     }
; 691 }
; 692 
; 693 // Команда W <начальный адрес> <конечный адрес> <слово>
; 694 // Найти слово (16 битное значение) в адресном пространстве
; 695 
; 696 void CmdW(...) {
cmdw:
; 697     for (;;) {
l_43:
; 698         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 699             hl++;
	inc hl
; 700             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 701             hl--;
	dec hl
; 702             if (flag_z)
; 703                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 704         }
; 705         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 706     }
; 707 }
; 708 
; 709 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 710 // Копировать блок в адресном пространстве
; 711 
; 712 void CmdT(...) {
cmdt:
; 713     for (;;) {
l_48:
; 714         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 715         bc++;
	inc bc
; 716         Loop();
	call loop
	jp l_48
; 717     }
; 718 }
; 719 
; 720 // Команда M <начальный адрес>
; 721 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 722 
; 723 void CmdM(...) {
cmdm:
; 724     for (;;) {
l_51:
; 725         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 726         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 727         push_pop(hl) {
	push hl
; 728             ReadString();
	call readstring
	pop hl
; 729         }
; 730         if (flag_c) {
	jp nc, l_53
; 731             push_pop(hl) {
	push hl
; 732                 ParseWord();
	call parseword
; 733                 a = l;
	ld a, l
	pop hl
; 734             }
; 735             *hl = a;
	ld (hl), a
l_53:
; 736         }
; 737         hl++;
	inc hl
	jp l_51
; 738     }
; 739 }
; 740 
; 741 // Команда G <начальный адрес> <конечный адрес>
; 742 // Запуск программы и возможным указанием точки останова.
; 743 
; 744 void CmdG(...) {
cmdg:
; 745     CompareHlDe(hl, de);
	call comparehlde
; 746     if (flag_nz) {
	jp z, l_55
; 747         swap(hl, de);
	ex hl, de
; 748         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 749         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 750         *hl = OPCODE_RST_30;
	ld (hl), 247
; 751         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 752         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 753     }
; 754     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 755     pop(bc);
	pop bc
; 756     pop(de);
	pop de
; 757     pop(hl);
	pop hl
; 758     pop(a);
	pop af
; 759     sp = hl;
	ld sp, hl
; 760     hl = regHL;
	ld hl, (reghl)
; 761     return JmpParam1();
	jp jmpparam1
; 762 }
; 763 
; 764 void BreakPointHandler(...) {
breakpointhandler:
; 765     regHL = hl;
	ld (reghl), hl
; 766     push(a);
	push af
; 767     pop(hl);
	pop hl
; 768     regAF = hl;
	ld (regaf), hl
; 769     pop(hl);
	pop hl
; 770     hl--;
	dec hl
; 771     regPC = hl;
	ld (regpc), hl
; 772     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 773     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 774     push(hl);
	push hl
; 775     push(de);
	push de
; 776     push(bc);
	push bc
; 777     sp = STACK_TOP;
	ld sp, 63488
; 778     hl = regPC;
	ld hl, (regpc)
; 779     swap(hl, de);
	ex hl, de
; 780     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 781     CompareHlDe(hl, de);
	call comparehlde
; 782     if (flag_nz)
; 783         return CmdX();
	jp nz, cmdx
; 784     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 785     CmdX();
; 786 }
; 787 
; 788 // Команда X
; 789 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 790 
; 791 void CmdX(...) {
cmdx:
; 792     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 793     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 794     b = 6;
	ld b, 6
; 795     do {
l_57:
; 796         e = *hl;
	ld e, (hl)
; 797         hl++;
	inc hl
; 798         d = *hl;
	ld d, (hl)
; 799         push(bc);
	push bc
; 800         push(hl);
	push hl
; 801         swap(hl, de);
	ex hl, de
; 802         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 803         ReadString();
	call readstring
; 804         if (flag_c) {
	jp nc, l_60
; 805             ParseWord();
	call parseword
; 806             pop(de);
	pop de
; 807             push(de);
	push de
; 808             swap(hl, de);
	ex hl, de
; 809             *hl = d;
	ld (hl), d
; 810             hl--;
	dec hl
; 811             *hl = e;
	ld (hl), e
l_60:
; 812         }
; 813         pop(hl);
	pop hl
; 814         pop(bc);
	pop bc
; 815         b--;
	dec b
; 816         hl++;
	inc hl
l_58:
	jp nz, l_57
; 817     } while (flag_nz);
; 818     EntryF86C_Monitor();
	jp entryf86c_monitor
; 819 }
; 820 
; 821 // Функция для пользовательской программы.
; 822 // Получить координаты курсора.
; 823 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 824 
; 825 void GetCursor() {
getcursor:
; 826     push_pop(a) {
	push af
; 827         hl = cursor;
	ld hl, (cursor)
; 828         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 829 
; 830         // Вычисление X
; 831         a = l;
	ld a, l
; 832         a &= (SCREEN_WIDTH - 1);
	and 63
; 833         a += 8;  // Смещение Радио 86РК
	add 8
; 834 
; 835         // Вычисление Y
; 836         hl += hl;
	add hl, hl
; 837         hl += hl;
	add hl, hl
; 838         h++;  // Смещение Радио 86РК
	inc h
; 839         h++;
	inc h
; 840         h++;
	inc h
; 841 
; 842         l = a;
	ld l, a
	pop af
	ret
; 843     }
; 844 }
; 845 
; 846 // Функция для пользовательской программы.
; 847 // Получить символ под курсором.
; 848 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 849 
; 850 void GetCursorChar() {
getcursorchar:
; 851     push_pop(hl) {
	push hl
; 852         hl = cursor;
	ld hl, (cursor)
; 853         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 854     }
; 855 }
; 856 
; 857 // Команда H
; 858 // Определить скорости записанной программы.
; 859 // Выводит 4 цифры на экран.
; 860 // Первые две цифры - константа вывода для команды O
; 861 // Последние две цифры - константа вввода для команды I
; 862 
; 863 void CmdH(...) {
cmdh:
; 864     PrintCrLfTab();
	call printcrlftab
; 865     hl = 65408;
	ld hl, 65408
; 866     b = 123;
	ld b, 123
; 867 
; 868     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 869 
; 870     do {
l_62:
l_63:
; 871     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 872 
; 873     do {
l_65:
; 874         c = a;
	ld c, a
; 875         do {
l_68:
; 876             hl++;
	inc hl
l_69:
; 877         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 878     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 879 
; 880     hl += hl;
	add hl, hl
; 881     a = h;
	ld a, h
; 882     hl += hl;
	add hl, hl
; 883     l = (a += h);
	add h
	ld l, a
; 884 
; 885     PrintHexWordSpace();
	jp printhexwordspace
; 886 }
; 887 
; 888 // Команда I <смещение> <скорость>
; 889 // Загрузить файл с магнитной ленты
; 890 
; 891 void CmdI(...) {
cmdi:
; 892     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 893         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 894     ReadTapeFile();
	call readtapefile
; 895     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 896     swap(hl, de);
	ex hl, de
; 897     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 898     swap(hl, de);
	ex hl, de
; 899     push(bc);
	push bc
; 900     CalculateCheckSum();
	call calculatechecksum
; 901     h = b;
	ld h, b
; 902     l = c;
	ld l, c
; 903     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 904     pop(de);
	pop de
; 905     CompareHlDe(hl, de);
	call comparehlde
; 906     if (flag_z)
; 907         return;
	ret z
; 908     swap(hl, de);
	ex hl, de
; 909     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 910     MonitorError();
; 911 }
; 912 
; 913 void MonitorError() {
monitorerror:
; 914     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 915     Monitor2();
	jp monitor2
; 916 }
; 917 
; 918 // Функция для пользовательской программы.
; 919 // Загрузить файл с магнитной ленты.
; 920 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 921 
; 922 void ReadTapeFile(...) {
readtapefile:
; 923     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 924     push_pop(hl) {
	push hl
; 925         hl += bc;
	add hl, bc
; 926         swap(hl, de);
	ex hl, de
; 927         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 928     }
; 929     hl += bc;
	add hl, bc
; 930     swap(hl, de);
	ex hl, de
; 931 
; 932     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 933     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 934     if (flag_z)
; 935         return;
	ret z
; 936 
; 937     push_pop(hl) {
	push hl
; 938         ReadTapeBlock();
	call readtapeblock
; 939         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 940     }
; 941 }
; 942 
; 943 void ReadTapeWordNext() {
readtapewordnext:
; 944     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 945 }
; 946 
; 947 void ReadTapeWord(...) {
readtapeword:
; 948     ReadTapeByte(a);
	call readtapebyte
; 949     b = a;
	ld b, a
; 950     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 951     c = a;
	ld c, a
	ret
; 952 }
; 953 
; 954 void ReadTapeBlock(...) {
readtapeblock:
; 955     for (;;) {
l_74:
; 956         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 957         *hl = a;
	ld (hl), a
; 958         Loop();
	call loop
	jp l_74
; 959     }
; 960 }
; 961 
; 962 // Функция для пользовательской программы.
; 963 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 964 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 965 
; 966 void CalculateCheckSum(...) {
calculatechecksum:
; 967     bc = 0;
	ld bc, 0
; 968     for (;;) {
l_77:
; 969         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 970         push_pop(a) {
	push af
; 971             CompareHlDe(hl, de);
	call comparehlde
; 972             if (flag_z)
; 973                 return PopRet();
	jp z, popret
	pop af
; 974         }
; 975         a = b;
	ld a, b
; 976         carry_add(a, *hl);
	adc (hl)
; 977         b = a;
	ld b, a
; 978         Loop();
	call loop
	jp l_77
; 979     }
; 980 }
; 981 
; 982 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 983 // Сохранить блок данных на магнитную ленту
; 984 
; 985 void CmdO(...) {
cmdo:
; 986     if ((a = c) != 0)
	ld a, c
	or a
; 987         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 988     push_pop(hl) {
	push hl
; 989         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 990     }
; 991     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 992     swap(hl, de);
	ex hl, de
; 993     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 994     swap(hl, de);
	ex hl, de
; 995     push_pop(hl) {
	push hl
; 996         h = b;
	ld h, b
; 997         l = c;
	ld l, c
; 998         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 999     }
; 1000     WriteTapeFile(hl, de);
; 1001 }
; 1002 
; 1003 // Функция для пользовательской программы.
; 1004 // Запись файла на магнитную ленту.
; 1005 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1006 
; 1007 void WriteTapeFile(...) {
writetapefile:
; 1008     push(bc);
	push bc
; 1009     bc = 0;
	ld bc, 0
; 1010     do {
l_81:
; 1011         WriteTapeByte(c);
	call writetapebyte
; 1012         b--;
	dec b
; 1013         swap(hl, *sp);
	ex (sp), hl
; 1014         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1015     } while (flag_nz);
; 1016     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1017     WriteTapeWord(hl);
	call writetapeword
; 1018     swap(hl, de);
	ex hl, de
; 1019     WriteTapeWord(hl);
	call writetapeword
; 1020     swap(hl, de);
	ex hl, de
; 1021     WriteTapeBlock(hl, de);
	call writetapeblock
; 1022     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1023     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1024     pop(hl);
	pop hl
; 1025     WriteTapeWord(hl);
	call writetapeword
; 1026     return;
	ret
; 1027 }
; 1028 
; 1029 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1030     push_pop(bc) {
	push bc
; 1031         PrintCrLfTab();
	call printcrlftab
; 1032         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1033     }
; 1034 }
; 1035 
; 1036 void PrintHexWordSpace(...) {
printhexwordspace:
; 1037     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1038     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1039 }
; 1040 
; 1041 void WriteTapeBlock(...) {
writetapeblock:
; 1042     for (;;) {
l_85:
; 1043         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1044         Loop();
	call loop
	jp l_85
; 1045     }
; 1046 }
; 1047 
; 1048 void WriteTapeWord(...) {
writetapeword:
; 1049     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1050     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1051 }
; 1052 
; 1053 // Загрузка байта с магнитной ленты.
; 1054 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1055 // Результат: a = прочитанный байт.
; 1056 
; 1057 void ReadTapeByte(...) {
readtapebyte:
; 1058     push(hl, bc, de);
	push hl
	push bc
	push de
; 1059     d = a;
	ld d, a
; 1060     ReadTapeByteInternal(d);
; 1061 }
; 1062 
; 1063 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1064     c = 0;
	ld c, 0
; 1065     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1066     do {
l_87:
; 1067     retry:  // Сдвиг результата
retry:
; 1068         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1069         cyclic_rotate_left(a, 1);
	rlca
; 1070         c = a;
	ld c, a
; 1071 
; 1072         // Ожидание изменения бита
; 1073         h = 0;
	ld h, 0
; 1074         do {
l_90:
; 1075             h--;
	dec h
; 1076             if (flag_z)
; 1077                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1078         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1079 
; 1080         // Сохранение бита
; 1081         c = (a |= c);
	or c
	ld c, a
; 1082 
; 1083         // Задержка
; 1084         d--;
	dec d
; 1085         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1086         if (flag_z)
; 1087             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1088         b = a;
	ld b, a
; 1089         do {
l_95:
l_96:
; 1090         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1091         d++;
	inc d
; 1092 
; 1093         // Новое значение бита
; 1094         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1095 
; 1096         // Режим поиска синхробайта
; 1097         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1098             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1099                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1100             } else {
; 1101                 if (a != ~TAPE_START)
	cp 65305
; 1102                     goto retry;
	jp nz, retry
; 1103                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1104             }
; 1105             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1106         }
; 1107     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1108     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1109     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1110 }
; 1111 
; 1112 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1113     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1114         return MonitorError();
	jp p, monitorerror
; 1115     CtrlC();
	call ctrlc
; 1116     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1117 }
; 1118 
; 1119 // Функция для пользовательской программы.
; 1120 // Запись байта на магнитную ленту.
; 1121 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1122 
; 1123 void WriteTapeByte(...) {
writetapebyte:
; 1124     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1125         d = 8;
	ld d, 8
; 1126         do {
l_102:
; 1127             // Сдвиг исходного байта
; 1128             a = c;
	ld a, c
; 1129             cyclic_rotate_left(a, 1);
	rlca
; 1130             c = a;
	ld c, a
; 1131 
; 1132             // Вывод
; 1133             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1134             out(PORT_TAPE, a);
	out (1), a
; 1135 
; 1136             // Задержка
; 1137             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1138             do {
l_105:
; 1139                 b--;
	dec b
l_106:
	jp nz, l_105
; 1140             } while (flag_nz);
; 1141 
; 1142             // Вывод
; 1143             (a = 0) ^= c;
	ld a, 0
	xor c
; 1144             out(PORT_TAPE, a);
	out (1), a
; 1145 
; 1146             // Задержка
; 1147             d--;
	dec d
; 1148             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1149             if (flag_z)
; 1150                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1151             b = a;
	ld b, a
; 1152             do {
l_110:
; 1153                 b--;
	dec b
l_111:
	jp nz, l_110
; 1154             } while (flag_nz);
; 1155             d++;
	inc d
l_103:
; 1156         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1157     }
; 1158 }
; 1159 
; 1160 // Функция для пользовательской программы.
; 1161 // Вывод 8 битного числа на экран.
; 1162 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1163 
; 1164 void PrintHexByte(...) {
printhexbyte:
; 1165     push_pop(a) {
	push af
; 1166         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1167         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1168     }
; 1169     PrintHexNibble(a);
; 1170 }
; 1171 
; 1172 void PrintHexNibble(...) {
printhexnibble:
; 1173     a &= 0x0F;
	and 15
; 1174     if (flag_p(compare(a, 10)))
	cp 10
; 1175         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1176     a += '0';
	add 48
; 1177     PrintCharA(a);
; 1178 }
; 1179 
; 1180 // Вывод символа на экран.
; 1181 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1182 
; 1183 void PrintCharA(...) {
printchara:
; 1184     PrintChar(c = a);
	ld c, a
; 1185 }
; 1186 
; 1187 // Функция для пользовательской программы.
; 1188 // Вывод символа на экран.
; 1189 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1190 
; 1191 void PrintChar(...) {
printchar:
; 1192     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1193     IsAnyKeyPressed();
	call isanykeypressed
; 1194     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1195     hl = cursor;
	ld hl, (cursor)
; 1196     a = escState;
	ld a, (escstate)
; 1197     a--;
	dec a
; 1198     if (flag_m)
; 1199         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1200     if (flag_z)
; 1201         return PrintCharEsc();
	jp z, printcharesc
; 1202     a--;
	dec a
; 1203     if (flag_nz)
; 1204         return PrintCharEscY2();
	jp nz, printcharescy2
; 1205 
; 1206     // Первый параметр ESC Y
; 1207     a = c;
	ld a, c
; 1208     a -= ' ';
	sub 32
; 1209     if (flag_m) {
	jp p, l_115
; 1210         a ^= a;
	xor a
	jp l_116
l_115:
; 1211     } else {
; 1212         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1213             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1214     }
; 1215     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1216     c = a;
	ld c, a
; 1217     b = (a &= 192);
	and 192
	ld b, a
; 1218     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1219     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1220     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1221     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1222 }
; 1223 
; 1224 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1225     escState = a;
	ld (escstate), a
; 1226     PrintCharSaveCursor(hl);
; 1227 }
; 1228 
; 1229 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1230     cursor = hl;
	ld (cursor), hl
; 1231     PrintCharExit();
; 1232 }
; 1233 
; 1234 void PrintCharExit(...) {
printcharexit:
; 1235     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1236     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1237 }
; 1238 
; 1239 void DrawCursor(...) {
drawcursor:
; 1240     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1241         return;
	ret z
; 1242     hl = cursor;
	ld hl, (cursor)
; 1243     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1244     *hl = b;
	ld (hl), b
	ret
; 1245 }
; 1246 
; 1247 void PrintCharEscY2(...) {
printcharescy2:
; 1248     a = c;
	ld a, c
; 1249     a -= ' ';
	sub 32
; 1250     if (flag_m) {
	jp p, l_119
; 1251         a ^= a;
	xor a
	jp l_120
l_119:
; 1252     } else {
; 1253         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1254             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1255     }
; 1256     b = a;
	ld b, a
; 1257     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1258     PrintCharResetEscState();
; 1259 }
; 1260 
; 1261 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1262     a ^= a;
	xor a
; 1263     return PrintCharSetEscState();
	jp printcharsetescstate
; 1264 }
; 1265 
; 1266 void PrintCharEsc(...) {
printcharesc:
; 1267     a = c;
	ld a, c
; 1268     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1269         a = 2;
	ld a, 2
; 1270         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1271     }
; 1272     if (a == 97) {
	cp 97
	jp nz, l_125
; 1273         a ^= a;
	xor a
; 1274         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1275     }
; 1276     if (a != 98)
	cp 98
; 1277         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1278     SetCursorVisible();
; 1279 }
; 1280 
; 1281 void SetCursorVisible(...) {
setcursorvisible:
; 1282     cursorVisible = a;
	ld (cursorvisible), a
; 1283     return PrintCharResetEscState();
	jp printcharresetescstate
; 1284 }
; 1285 
; 1286 void PrintCharNoEsc(...) {
printcharnoesc:
; 1287     // Остановка вывода нажатием УС + Шифт
; 1288     do {
l_127:
; 1289         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1290     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1291 
; 1292     compare(a = 16, c);
	ld a, 16
	cp c
; 1293     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1294     if (flag_z) {
	jp nz, l_130
; 1295         invert(a);
	cpl
; 1296         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1297         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1298     }
; 1299     if (a != 0)
	or a
; 1300         TranslateCodePage(c);
	call nz, translatecodepage
; 1301     a = c;
	ld a, c
; 1302     if (a == 31)
	cp 31
; 1303         return ClearScreen();
	jp z, clearscreen
; 1304     if (flag_m)
; 1305         return PrintChar3(a);
	jp m, printchar3
; 1306     PrintChar4(a);
; 1307 }
; 1308 
; 1309 void PrintChar4(...) {
printchar4:
; 1310     *hl = a;
	ld (hl), a
; 1311     hl++;
	inc hl
; 1312     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1313         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1314     PrintCrLf();
	call printcrlf
; 1315     PrintCharExit();
	jp printcharexit
; 1316 }
; 1317 
; 1318 void ClearScreen(...) {
clearscreen:
; 1319     b = ' ';
	ld b, 32
; 1320     a = SCREEN_END >> 8;
	ld a, 240
; 1321     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1322     do {
l_132:
; 1323         *hl = b;
	ld (hl), b
; 1324         hl++;
	inc hl
; 1325         *hl = b;
	ld (hl), b
; 1326         hl++;
	inc hl
l_133:
; 1327     } while (a != h);
	cp h
	jp nz, l_132
; 1328     MoveCursorHome();
; 1329 }
; 1330 
; 1331 void MoveCursorHome(...) {
movecursorhome:
; 1332     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1333 }
; 1334 
; 1335 void PrintChar3(...) {
printchar3:
; 1336     if (a == 12)
	cp 12
; 1337         return MoveCursorHome();
	jp z, movecursorhome
; 1338     if (a == 13)
	cp 13
; 1339         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1340     if (a == 10)
	cp 10
; 1341         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1342     if (a == 8)
	cp 8
; 1343         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1344     if (a == 24)
	cp 24
; 1345         return MoveCursorRight(hl);
	jp z, movecursorright
; 1346     if (a == 25)
	cp 25
; 1347         return MoveCursorUp(hl);
	jp z, movecursorup
; 1348     if (a == 7)
	cp 7
; 1349         return PrintCharBeep();
	jp z, printcharbeep
; 1350     if (a == 26)
	cp 26
; 1351         return MoveCursorDown();
	jp z, movecursordown
; 1352     if (a != 27)
	cp 27
; 1353         return PrintChar4(hl, a);
	jp nz, printchar4
; 1354     a = 1;
	ld a, 1
; 1355     PrintCharSetEscState();
	jp printcharsetescstate
; 1356 }
; 1357 
; 1358 void PrintCharBeep(...) {
printcharbeep:
; 1359     c = 128;  // Длительность
	ld c, 128
; 1360     e = 32;   // Частота
	ld e, 32
; 1361     do {
l_135:
; 1362         d = e;
	ld d, e
; 1363         do {
l_138:
; 1364             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1365         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1366         e = d;
	ld e, d
; 1367         do {
l_141:
; 1368             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1369         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1370     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1371 
; 1372     PrintCharExit();
	jp printcharexit
; 1373 }
; 1374 
; 1375 void MoveCursorCr(...) {
movecursorcr:
; 1376     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1377     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1378 }
; 1379 
; 1380 void MoveCursorRight(...) {
movecursorright:
; 1381     hl++;
	inc hl
; 1382     MoveCursorBoundary(hl);
; 1383 }
; 1384 
; 1385 void MoveCursorBoundary(...) {
movecursorboundary:
; 1386     a = h;
	ld a, h
; 1387     a &= 7;
	and 7
; 1388     a |= SCREEN_BEGIN >> 8;
	or 232
; 1389     h = a;
	ld h, a
; 1390     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1391 }
; 1392 
; 1393 void MoveCursorLeft(...) {
movecursorleft:
; 1394     hl--;
	dec hl
; 1395     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1396 }
; 1397 
; 1398 void MoveCursorLf(...) {
movecursorlf:
; 1399     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1400     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1401         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1402 
; 1403     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1404     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1405     do {
l_144:
; 1406         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1407         hl++;
	inc hl
; 1408         bc++;
	inc bc
; 1409         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1410         hl++;
	inc hl
; 1411         bc++;
	inc bc
l_145:
; 1412     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1413     a = SCREEN_END >> 8;
	ld a, 240
; 1414     c = ' ';
	ld c, 32
; 1415     do {
l_147:
; 1416         *hl = c;
	ld (hl), c
; 1417         hl++;
	inc hl
; 1418         *hl = c;
	ld (hl), c
; 1419         hl++;
	inc hl
l_148:
; 1420     } while (a != h);
	cp h
	jp nz, l_147
; 1421     hl = cursor;
	ld hl, (cursor)
; 1422     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1423     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1424     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1425 }
; 1426 
; 1427 void MoveCursorUp(...) {
movecursorup:
; 1428     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1429 }
; 1430 
; 1431 void MoveCursor(...) {
movecursor:
; 1432     hl += bc;
	add hl, bc
; 1433     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1434 }
; 1435 
; 1436 void MoveCursorDown(...) {
movecursordown:
; 1437     return MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1438 }
; 1439 
; 1440 void PrintCrLf() {
printcrlf:
; 1441     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1442     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1443 }
; 1444 
; 1445 // Функция для пользовательской программы.
; 1446 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1447 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1448 
; 1449 void IsAnyKeyPressed() {
isanykeypressed:
; 1450     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1451     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1452     a &= KEYBOARD_ROW_MASK;
	and 127
; 1453     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1454         a ^= a;
	xor a
; 1455         return;
	ret
l_150:
; 1456     }
; 1457     a = 0xFF;
	ld a, 255
	ret
; 1458 }
; 1459 
; 1460 // Функция для пользовательской программы.
; 1461 // Получить код нажатой клавиши на клавиатуре.
; 1462 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1463 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1464 
; 1465 void ReadKey() {
readkey:
; 1466     push_pop(hl) {
	push hl
; 1467         hl = keyDelay;
	ld hl, (keydelay)
; 1468         ReadKeyInternal(hl);
	call readkeyinternal
; 1469         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1470         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1471             do {
l_154:
; 1472                 do {
l_157:
; 1473                     l = 2;
	ld l, 2
; 1474                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1475                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1476             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1477             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1478         }
; 1479         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1480     }
; 1481 }
; 1482 
; 1483 void ReadKeyInternal(...) {
readkeyinternal:
; 1484     do {
l_160:
; 1485         ScanKey();
	call scankey
; 1486         if (a != h)
	cp h
; 1487             break;
	jp nz, l_162
; 1488 
; 1489         // Задержка
; 1490         push_pop(a) {
	push af
; 1491             a ^= a;
	xor a
; 1492             do {
l_163:
; 1493                 swap(hl, de);
	ex hl, de
; 1494                 swap(hl, de);
	ex hl, de
l_164:
; 1495             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1496         }
; 1497     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1498     h = a;
	ld h, a
	ret
; 1499 }
; 1500 
; 1501 // Функция для пользовательской программы.
; 1502 // Получить код нажатой клавиши на клавиатуре.
; 1503 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1504 
; 1505 void ScanKey() {
scankey:
; 1506     push(bc, de, hl);
	push bc
	push de
	push hl
; 1507 
; 1508     bc = 0x00FE;
	ld bc, 254
; 1509     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1510     do {
l_166:
; 1511         a = c;
	ld a, c
; 1512         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1513         cyclic_rotate_left(a, 1);
	rlca
; 1514         c = a;
	ld c, a
; 1515         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1516         a &= KEYBOARD_ROW_MASK;
	and 127
; 1517         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1518             return ScanKey2(a);
	jp nz, scankey2
; 1519         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1520     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1521 
; 1522     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1523     carry_rotate_right(a, 1);
	rra
; 1524     a = 0xFF;  // No key
	ld a, 255
; 1525     if (flag_c)
; 1526         return ScanKeyExit(a);
	jp c, scankeyexit
; 1527     a--;  // Rus key
	dec a
; 1528     return ScanKeyExit(a);
	jp scankeyexit
; 1529 }
; 1530 
; 1531 void ScanKey2(...) {
scankey2:
; 1532     for (;;) {
l_170:
; 1533         carry_rotate_right(a, 1);
	rra
; 1534         if (flag_nc)
; 1535             break;
	jp nc, l_171
; 1536         b++;
	inc b
	jp l_170
l_171:
; 1537     }
; 1538 
; 1539     /* b - key number */
; 1540 
; 1541     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1542      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1543      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1544      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1545      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1546      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1547      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1548 
; 1549     a = b;
	ld a, b
; 1550     if (a >= 48)
	cp 48
; 1551         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1552     a += 48;
	add 48
; 1553     if (a >= 60)
	cp 60
; 1554         if (a < 64)
	jp c, l_172
	cp 64
; 1555             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1556 
; 1557     if (a == 95)
	cp 95
; 1558         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1559 
; 1560     c = a;
	ld c, a
; 1561     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1562     a &= KEYBOARD_MODS_MASK;
	and 7
; 1563     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1564     b = a;
	ld b, a
; 1565     a = c;
	ld a, c
; 1566     if (flag_z)
; 1567         return ScanKeyExit(a);
	jp z, scankeyexit
; 1568     a = b;
	ld a, b
; 1569     carry_rotate_right(a, 2);
	rra
	rra
; 1570     if (flag_nc)
; 1571         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1572     carry_rotate_right(a, 1);
	rra
; 1573     if (flag_nc)
; 1574         return ScanKeyShift();
	jp nc, scankeyshift
; 1575     (a = c) |= 0x20;
	ld a, c
	or 32
; 1576     ScanKeyExit(a);
; 1577 }
; 1578 
; 1579 void ScanKeyExit(...) {
scankeyexit:
; 1580     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1581 }
; 1582 
; 1583 void ScanKeyControl(...) {
scankeycontrol:
; 1584     a = c;
	ld a, c
; 1585     a &= 0x1F;
	and 31
; 1586     return ScanKeyExit(a);
	jp scankeyexit
; 1587 }
; 1588 
; 1589 void ScanKeyShift(...) {
scankeyshift:
; 1590     if ((a = c) == 127)
	ld a, c
	cp 127
; 1591         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1592     if (a >= 64)
	cp 64
; 1593         return ScanKeyExit();
	jp nc, scankeyexit
; 1594     if (a < 48) {
	cp 48
	jp nc, l_180
; 1595         a |= 16;
	or 16
; 1596         return ScanKeyExit();
	jp scankeyexit
l_180:
; 1597     }
; 1598     a &= 47;
	and 47
; 1599     return ScanKeyExit();
	jp scankeyexit
; 1600 }
; 1601 
; 1602 void ScanKeySpecial(...) {
scankeyspecial:
; 1603     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1604     c = (a -= 48);
	sub 48
	ld c, a
; 1605     b = 0;
	ld b, 0
; 1606     hl += bc;
	add hl, bc
; 1607     a = *hl;
	ld a, (hl)
; 1608     return ScanKeyExit(a);
	jp scankeyexit
; 1609 }
; 1610 
; 1611 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1622  aPrompt[6] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1623  aCrLfTab[6] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1624  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1625  aBackspace[4] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1626  aHello[] = "\x1F\nm/80k ";
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
; 1628  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1629 }
; 1630 
; 1631 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
