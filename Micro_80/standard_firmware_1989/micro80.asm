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
; 183 #define firstVariableAddress (&tapeWriteSpeed)
; 184 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 185 
; 186 extern uint8_t specialKeyTable[8];
; 187 extern uint8_t aPrompt[6];
; 188 extern uint8_t aCrLfTab[6];
; 189 extern uint8_t aRegisters[37];
; 190 extern uint8_t aBackspace[4];
; 191 extern uint8_t aHello[9];
; 192 
; 193 // Для удобства
; 194 
; 195 void JmpParam1() __address(0xF774);
; 196 void TranslateCodePage() __address(0xF77E);
; 197 
; 198 // Точки входа
; 199 
; 200 void EntryF800_Reboot() {
entryf800_reboot:
; 201     Reboot();
	jp reboot
; 202 }
; 203 
; 204 void EntryF803_ReadKey() {
entryf803_readkey:
; 205     ReadKey();
	jp readkey
; 206 }
; 207 
; 208 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 209     ReadTapeByte(a);
	jp readtapebyte
; 210 }
; 211 
; 212 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 213     PrintChar(c);
	jp printchar
; 214 }
; 215 
; 216 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 217     WriteTapeByte(c);
	jp writetapebyte
; 218 }
; 219 
; 220 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 221     TranslateCodePage(c);
	jp translatecodepage
; 222 }
; 223 
; 224 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 225     IsAnyKeyPressed();
	jp isanykeypressed
; 226 }
; 227 
; 228 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 229     PrintHexByte(a);
	jp printhexbyte
; 230 }
; 231 
; 232 void EntryF818_PrintString(...) {
entryf818_printstring:
; 233     PrintString(hl);
	jp printstring
; 234 }
; 235 
; 236 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 237     ScanKey();
	jp scankey
; 238 }
; 239 
; 240 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 241     GetCursor();
	jp getcursor
; 242 }
; 243 
; 244 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 245     GetCursorChar();
	jp getcursorchar
; 246 }
; 247 
; 248 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 249     ReadTapeFile(hl);
	jp readtapefile
; 250 }
; 251 
; 252 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 253     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 254 }
; 255 
; 256 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 257     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 258 }
; 259 
; 260 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 261     return;
	ret
; 262     return;
	ret
; 263     return;
	ret
; 264 }
; 265 
; 266 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 267     GetRamTop();
	jp getramtop
; 268 }
; 269 
; 270 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 271     SetRamTop(hl);
	jp setramtop
; 272 }
; 273 
; 274 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 275 // Параметры: нет. Функция никогда не завершается.
; 276 
; 277 void Reboot(...) {
reboot:
; 278     sp = STACK_TOP;
	ld sp, 63488
; 279 
; 280     // Очистка памяти
; 281     hl = firstVariableAddress;
	ld hl, 0FFFFh & (tapewritespeed)
; 282     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 283     bc = 0;
	ld bc, 0
; 284     CmdF();
	call cmdf
; 285 
; 286     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 287 
; 288     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 289 
; 290     // Проверка ОЗУ
; 291     hl = 0;
	ld hl, 0
; 292     for (;;) {
l_1:
; 293         c = *hl;
	ld c, (hl)
; 294         a = 0x55;
	ld a, 85
; 295         *hl = a;
	ld (hl), a
; 296         a ^= *hl;
	xor (hl)
; 297         b = a;
	ld b, a
; 298         a = 0xAA;
	ld a, 170
; 299         *hl = a;
	ld (hl), a
; 300         a ^= *hl;
	xor (hl)
; 301         a |= b;
	or b
; 302         if (flag_nz)
; 303             return Reboot2();
	jp nz, reboot2
; 304         *hl = c;
	ld (hl), c
; 305         hl++;
	inc hl
; 306         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 307             return Reboot2();
	jp z, reboot2
	jp l_1
; 308     }
; 309 
; 310     Reboot2();
	jp reboot2
 .org 0xF86C
; 311 }
; 312 
; 313 asm(" .org 0xF86C");
; 314 
; 315 void EntryF86C_Monitor() {
entryf86c_monitor:
; 316     Monitor();
	jp monitor
; 317 }
; 318 
; 319 void Reboot2(...) {
reboot2:
; 320     hl--;
	dec hl
; 321     ramTop = hl;
	ld (ramtop), hl
; 322     PrintHexWordSpace(hl);
	call printhexwordspace
; 323     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 324     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 325     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 326     Monitor();
; 327 }
; 328 
; 329 void Monitor() {
monitor:
; 330     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 331     cursorVisible = a;
	ld (cursorvisible), a
; 332     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 333     Monitor2();
; 334 }
; 335 
; 336 void Monitor2() {
monitor2:
; 337     sp = STACK_TOP;
	ld sp, 63488
; 338     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 339     ReadString();
	call readstring
; 340 
; 341     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 342 
; 343     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 344     a = *hl;
	ld a, (hl)
; 345 
; 346     if (a == 'X')
	cp 88
; 347         return CmdX();
	jp z, cmdx
; 348 
; 349     push_pop(a) {
	push af
; 350         ParseParams();
	call parseparams
; 351         hl = param3;
	ld hl, (param3)
; 352         c = l;
	ld c, l
; 353         b = h;
	ld b, h
; 354         hl = param2;
	ld hl, (param2)
; 355         swap(hl, de);
	ex hl, de
; 356         hl = param1;
	ld hl, (param1)
	pop af
; 357     }
; 358 
; 359     if (a == 'D')
	cp 68
; 360         return CmdD();
	jp z, cmdd
; 361     if (a == 'C')
	cp 67
; 362         return CmdC();
	jp z, cmdc
; 363     if (a == 'F')
	cp 70
; 364         return CmdF();
	jp z, cmdf
; 365     if (a == 'S')
	cp 83
; 366         return CmdS();
	jp z, cmds
; 367     if (a == 'T')
	cp 84
; 368         return CmdT();
	jp z, cmdt
; 369     if (a == 'M')
	cp 77
; 370         return CmdM();
	jp z, cmdm
; 371     if (a == 'G')
	cp 71
; 372         return CmdG();
	jp z, cmdg
; 373     if (a == 'I')
	cp 73
; 374         return CmdI();
	jp z, cmdi
; 375     if (a == 'O')
	cp 79
; 376         return CmdO();
	jp z, cmdo
; 377     if (a == 'W')
	cp 87
; 378         return CmdW();
	jp z, cmdw
; 379     if (a == 'A')
	cp 65
; 380         return CmdA();
	jp z, cmda
; 381     if (a == 'H')
	cp 72
; 382         return CmdH();
	jp z, cmdh
; 383     if (a == 'R')
	cp 82
; 384         return CmdR();
	jp z, cmdr
; 385     return MonitorError();
	jp monitorerror
; 386 }
; 387 
; 388 void ReadStringBackspace(...) {
readstringbackspace:
; 389     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 390         return ReadStringBegin(hl);
	jp z, readstringbegin
; 391     push_pop(hl) {
	push hl
; 392         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 393     }
; 394     hl--;
	dec hl
; 395     return ReadStringLoop(b, hl);
	jp readstringloop
; 396 }
; 397 
; 398 void ReadString() {
readstring:
; 399     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 400     ReadStringBegin(hl);
; 401 }
; 402 
; 403 void ReadStringBegin(...) {
readstringbegin:
; 404     b = 0;
	ld b, 0
; 405     ReadStringLoop(b, hl);
; 406 }
; 407 
; 408 void ReadStringLoop(...) {
readstringloop:
; 409     for (;;) {
l_4:
; 410         ReadKey();
	call readkey
; 411         if (a == 127)
	cp 127
; 412             return ReadStringBackspace();
	jp z, readstringbackspace
; 413         if (a == 8)
	cp 8
; 414             return ReadStringBackspace();
	jp z, readstringbackspace
; 415         if (flag_nz)
; 416             PrintCharA(a);
	call nz, printchara
; 417         *hl = a;
	ld (hl), a
; 418         if (a == 13)
	cp 13
; 419             return ReadStringExit(b);
	jp z, readstringexit
; 420         if (a == '.')
	cp 46
; 421             return Monitor2();
	jp z, monitor2
; 422         b = 255;
	ld b, 255
; 423         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 424             return MonitorError();
	jp z, monitorerror
; 425         hl++;
	inc hl
	jp l_4
; 426     }
; 427 }
; 428 
; 429 void ReadStringExit(...) {
readstringexit:
; 430     a = b;
	ld a, b
; 431     carry_rotate_left(a, 1);
	rla
; 432     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 433     b = 0;
	ld b, 0
	ret
; 434 }
; 435 
; 436 // Функция для пользовательской программы.
; 437 // Вывод строки на экран.
; 438 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 439 
; 440 void PrintString(...) {
printstring:
; 441     for (;;) {
l_7:
; 442         a = *hl;
	ld a, (hl)
; 443         if (flag_z(a &= a))
	and a
; 444             return;
	ret z
; 445         PrintCharA(a);
	call printchara
; 446         hl++;
	inc hl
	jp l_7
; 447     }
; 448 }
; 449 
; 450 void ParseParams(...) {
parseparams:
; 451     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 452     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 453     c = 0;
	ld c, 0
; 454     CmdF();
	call cmdf
; 455 
; 456     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 457 
; 458     ParseWord();
	call parseword
; 459     param1 = hl;
	ld (param1), hl
; 460     param2 = hl;
	ld (param2), hl
; 461     if (flag_c)
; 462         return;
	ret c
; 463 
; 464     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 465     ParseWord();
	call parseword
; 466     param2 = hl;
	ld (param2), hl
; 467     if (flag_c)
; 468         return;
	ret c
; 469 
; 470     ParseWord();
	call parseword
; 471     param3 = hl;
	ld (param3), hl
; 472     if (flag_c)
; 473         return;
	ret c
; 474 
; 475     MonitorError();
	jp monitorerror
; 476 }
; 477 
; 478 void ParseWord(...) {
parseword:
; 479     hl = 0;
	ld hl, 0
; 480     for (;;) {
l_10:
; 481         a = *de;
	ld a, (de)
; 482         de++;
	inc de
; 483         if (a == 13)
	cp 13
; 484             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 485         if (a == ',')
	cp 44
; 486             return;
	ret z
; 487         if (a == ' ')
	cp 32
; 488             continue;
	jp z, l_10
; 489         a -= '0';
	sub 48
; 490         if (flag_m)
; 491             return MonitorError();
	jp m, monitorerror
; 492         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 493             if (flag_m(compare(a, 17)))
	cp 17
; 494                 return MonitorError();
	jp m, monitorerror
; 495             if (flag_p(compare(a, 23)))
	cp 23
; 496                 return MonitorError();
	jp p, monitorerror
; 497             a -= 7;
	sub 7
l_12:
; 498         }
; 499         c = a;
	ld c, a
; 500         hl += hl;
	add hl, hl
; 501         hl += hl;
	add hl, hl
; 502         hl += hl;
	add hl, hl
; 503         hl += hl;
	add hl, hl
; 504         if (flag_c)
; 505             return MonitorError();
	jp c, monitorerror
; 506         hl += bc;
	add hl, bc
	jp l_10
; 507     }
; 508 }
; 509 
; 510 void ParseWordReturnCf(...) {
parsewordreturncf:
; 511     set_flag_c();
	scf
	ret
; 512 }
; 513 
; 514 void CompareHlDe(...) {
comparehlde:
; 515     if ((a = h) != d)
	ld a, h
	cp d
; 516         return;
	ret nz
; 517     compare(a = l, e);
	ld a, l
	cp e
	ret
; 518 }
; 519 
; 520 void LoopWithBreak(...) {
loopwithbreak:
; 521     CtrlC();
	call ctrlc
; 522     Loop(hl, de);
; 523 }
; 524 
; 525 void Loop(...) {
loop:
; 526     CompareHlDe(hl, de);
	call comparehlde
; 527     if (flag_nz)
; 528         return IncHl(hl);
	jp nz, inchl
; 529     PopRet();
; 530 }
; 531 
; 532 void PopRet() {
popret:
; 533     sp++;
	inc sp
; 534     sp++;
	inc sp
	ret
; 535 }
; 536 
; 537 void IncHl(...) {
inchl:
; 538     hl++;
	inc hl
	ret
; 539 }
; 540 
; 541 void CtrlC() {
ctrlc:
; 542     ScanKey();
	call scankey
; 543     if (a != 3)  // УПР + C
	cp 3
; 544         return;
	ret nz
; 545     MonitorError();
	jp monitorerror
; 546 }
; 547 
; 548 void PrintCrLfTab() {
printcrlftab:
; 549     push_pop(hl) {
	push hl
; 550         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 551     }
; 552 }
; 553 
; 554 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 555     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 556 }
; 557 
; 558 void PrintHexByteSpace(...) {
printhexbytespace:
; 559     push_pop(bc) {
	push bc
; 560         PrintHexByte(a);
	call printhexbyte
; 561         PrintSpace();
	call printspace
	pop bc
	ret
; 562     }
; 563 }
; 564 
; 565 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 566 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 567 
; 568 void CmdR(...) {
cmdr:
; 569     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 570     for (;;) {
l_15:
; 571         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 572         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 573         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 574         bc++;
	inc bc
; 575         Loop();
	call loop
	jp l_15
; 576     }
; 577 }
; 578 
; 579 // Функция для пользовательской программы.
; 580 // Получить адрес последнего доступного байта оперативной памяти.
; 581 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 582 
; 583 void GetRamTop(...) {
getramtop:
; 584     hl = ramTop;
	ld hl, (ramtop)
	ret
; 585 }
; 586 
; 587 // Функция для пользовательской программы.
; 588 // Установить адрес последнего доступного байта оперативной памяти.
; 589 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 590 
; 591 void SetRamTop(...) {
setramtop:
; 592     ramTop = hl;
	ld (ramtop), hl
	ret
; 593 }
; 594 
; 595 // Команда A <адрес>
; 596 // Установить программу преобразования кодировки символов выводимых на экран
; 597 
; 598 void CmdA(...) {
cmda:
; 599     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 600 }
; 601 
; 602 // Команда D <начальный адрес> <конечный адрес>
; 603 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 604 
; 605 void CmdD(...) {
cmdd:
; 606     for (;;) {
l_18:
; 607         PrintCrLf();
	call printcrlf
; 608         PrintHexWordSpace(hl);
	call printhexwordspace
; 609         push_pop(hl) {
	push hl
; 610             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 611             carry_rotate_right(a, 1);
	rra
; 612             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 613             PrintSpacesTo();
	call printspacesto
; 614             do {
l_20:
; 615                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 616                 CompareHlDe(hl, de);
	call comparehlde
; 617                 hl++;
	inc hl
; 618                 if (flag_z)
; 619                     break;
	jp z, l_22
; 620                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 621                 push_pop(a) {
	push af
; 622                     a &= 1;
	and 1
; 623                     if (flag_z)
; 624                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 625                 }
; 626             } while (flag_nz);
; 627         }
; 628 
; 629         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 630         PrintSpacesTo(b);
	call printspacesto
; 631 
; 632         do {
l_23:
; 633             a = *hl;
	ld a, (hl)
; 634             if (a < 127)
	cp 127
; 635                 if (a >= 32)
	jp nc, l_26
	cp 32
; 636                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 637             a = '.';
	ld a, 46
; 638         loc_fa49:
loc_fa49:
; 639             PrintCharA(a);
	call printchara
; 640             CompareHlDe(hl, de);
	call comparehlde
; 641             if (flag_z)
; 642                 return;
	ret z
; 643             hl++;
	inc hl
; 644             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 645         } while (flag_nz);
; 646     }
; 647 }
; 648 
; 649 void PrintSpacesTo(...) {
printspacesto:
; 650     for (;;) {
l_29:
; 651         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 652             return;
	ret nc
; 653         PrintSpace();
	call printspace
	jp l_29
; 654     }
; 655 }
; 656 
; 657 void PrintSpace() {
printspace:
; 658     return PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 659 }
; 660 
; 661 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 662 // Сравнить два блока адресного пространство
; 663 
; 664 void CmdC(...) {
cmdc:
; 665     for (;;) {
l_32:
; 666         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 667             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 668             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 669             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 670         }
; 671         bc++;
	inc bc
; 672         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 673     }
; 674 }
; 675 
; 676 // Команда F <начальный адрес> <конечный адрес> <байт>
; 677 // Заполнить блок в адресном пространстве одним байтом
; 678 
; 679 void CmdF(...) {
cmdf:
; 680     for (;;) {
l_37:
; 681         *hl = c;
	ld (hl), c
; 682         Loop();
	call loop
	jp l_37
; 683     }
; 684 }
; 685 
; 686 // Команда S <начальный адрес> <конечный адрес> <байт>
; 687 // Найти байт (8 битное значение) в адресном пространстве
; 688 
; 689 void CmdS(...) {
cmds:
; 690     for (;;) {
l_40:
; 691         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 692             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 693         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 694     }
; 695 }
; 696 
; 697 // Команда W <начальный адрес> <конечный адрес> <слово>
; 698 // Найти слово (16 битное значение) в адресном пространстве
; 699 
; 700 void CmdW(...) {
cmdw:
; 701     for (;;) {
l_43:
; 702         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 703             hl++;
	inc hl
; 704             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 705             hl--;
	dec hl
; 706             if (flag_z)
; 707                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 708         }
; 709         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 710     }
; 711 }
; 712 
; 713 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 714 // Копировать блок в адресном пространстве
; 715 
; 716 void CmdT(...) {
cmdt:
; 717     for (;;) {
l_48:
; 718         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 719         bc++;
	inc bc
; 720         Loop();
	call loop
	jp l_48
; 721     }
; 722 }
; 723 
; 724 // Команда M <начальный адрес>
; 725 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 726 
; 727 void CmdM(...) {
cmdm:
; 728     for (;;) {
l_51:
; 729         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 730         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 731         push_pop(hl) {
	push hl
; 732             ReadString();
	call readstring
	pop hl
; 733         }
; 734         if (flag_c) {
	jp nc, l_53
; 735             push_pop(hl) {
	push hl
; 736                 ParseWord();
	call parseword
; 737                 a = l;
	ld a, l
	pop hl
; 738             }
; 739             *hl = a;
	ld (hl), a
l_53:
; 740         }
; 741         hl++;
	inc hl
	jp l_51
; 742     }
; 743 }
; 744 
; 745 // Команда G <начальный адрес> <конечный адрес>
; 746 // Запуск программы и возможным указанием точки останова.
; 747 
; 748 void CmdG(...) {
cmdg:
; 749     CompareHlDe(hl, de);
	call comparehlde
; 750     if (flag_nz) {
	jp z, l_55
; 751         swap(hl, de);
	ex hl, de
; 752         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 753         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 754         *hl = OPCODE_RST_30;
	ld (hl), 247
; 755         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 756         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 757     }
; 758     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 759     pop(bc);
	pop bc
; 760     pop(de);
	pop de
; 761     pop(hl);
	pop hl
; 762     pop(a);
	pop af
; 763     sp = hl;
	ld sp, hl
; 764     hl = regHL;
	ld hl, (reghl)
; 765     return JmpParam1();
	jp jmpparam1
; 766 }
; 767 
; 768 void BreakPointHandler(...) {
breakpointhandler:
; 769     regHL = hl;
	ld (reghl), hl
; 770     push(a);
	push af
; 771     pop(hl);
	pop hl
; 772     regAF = hl;
	ld (regaf), hl
; 773     pop(hl);
	pop hl
; 774     hl--;
	dec hl
; 775     regPC = hl;
	ld (regpc), hl
; 776     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 777     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 778     push(hl);
	push hl
; 779     push(de);
	push de
; 780     push(bc);
	push bc
; 781     sp = STACK_TOP;
	ld sp, 63488
; 782     hl = regPC;
	ld hl, (regpc)
; 783     swap(hl, de);
	ex hl, de
; 784     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 785     CompareHlDe(hl, de);
	call comparehlde
; 786     if (flag_nz)
; 787         return CmdX();
	jp nz, cmdx
; 788     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 789     CmdX();
; 790 }
; 791 
; 792 // Команда X
; 793 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 794 
; 795 void CmdX(...) {
cmdx:
; 796     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 797     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 798     b = 6;
	ld b, 6
; 799     do {
l_57:
; 800         e = *hl;
	ld e, (hl)
; 801         hl++;
	inc hl
; 802         d = *hl;
	ld d, (hl)
; 803         push(bc);
	push bc
; 804         push(hl);
	push hl
; 805         swap(hl, de);
	ex hl, de
; 806         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 807         ReadString();
	call readstring
; 808         if (flag_c) {
	jp nc, l_60
; 809             ParseWord();
	call parseword
; 810             pop(de);
	pop de
; 811             push(de);
	push de
; 812             swap(hl, de);
	ex hl, de
; 813             *hl = d;
	ld (hl), d
; 814             hl--;
	dec hl
; 815             *hl = e;
	ld (hl), e
l_60:
; 816         }
; 817         pop(hl);
	pop hl
; 818         pop(bc);
	pop bc
; 819         b--;
	dec b
; 820         hl++;
	inc hl
l_58:
	jp nz, l_57
; 821     } while (flag_nz);
; 822     EntryF86C_Monitor();
	jp entryf86c_monitor
; 823 }
; 824 
; 825 // Функция для пользовательской программы.
; 826 // Получить координаты курсора.
; 827 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 828 
; 829 void GetCursor() {
getcursor:
; 830     push_pop(a) {
	push af
; 831         hl = cursor;
	ld hl, (cursor)
; 832         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 833 
; 834         // Вычисление X
; 835         a = l;
	ld a, l
; 836         a &= (SCREEN_WIDTH - 1);
	and 63
; 837         a += 8;  // Смещение Радио 86РК
	add 8
; 838 
; 839         // Вычисление Y
; 840         hl += hl;
	add hl, hl
; 841         hl += hl;
	add hl, hl
; 842         h++;  // Смещение Радио 86РК
	inc h
; 843         h++;
	inc h
; 844         h++;
	inc h
; 845 
; 846         l = a;
	ld l, a
	pop af
	ret
; 847     }
; 848 }
; 849 
; 850 // Функция для пользовательской программы.
; 851 // Получить символ под курсором.
; 852 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 853 
; 854 void GetCursorChar() {
getcursorchar:
; 855     push_pop(hl) {
	push hl
; 856         hl = cursor;
	ld hl, (cursor)
; 857         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 858     }
; 859 }
; 860 
; 861 // Команда H
; 862 // Определить скорости записанной программы.
; 863 // Выводит 4 цифры на экран.
; 864 // Первые две цифры - константа вывода для команды O
; 865 // Последние две цифры - константа вввода для команды I
; 866 
; 867 void CmdH(...) {
cmdh:
; 868     PrintCrLfTab();
	call printcrlftab
; 869     hl = 65408;
	ld hl, 65408
; 870     b = 123;
	ld b, 123
; 871 
; 872     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 873 
; 874     do {
l_62:
l_63:
; 875     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 876 
; 877     do {
l_65:
; 878         c = a;
	ld c, a
; 879         do {
l_68:
; 880             hl++;
	inc hl
l_69:
; 881         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 882     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 883 
; 884     hl += hl;
	add hl, hl
; 885     a = h;
	ld a, h
; 886     hl += hl;
	add hl, hl
; 887     l = (a += h);
	add h
	ld l, a
; 888 
; 889     PrintHexWordSpace();
	jp printhexwordspace
; 890 }
; 891 
; 892 // Команда I <смещение> <скорость>
; 893 // Загрузить файл с магнитной ленты
; 894 
; 895 void CmdI(...) {
cmdi:
; 896     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 897         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 898     ReadTapeFile();
	call readtapefile
; 899     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 900     swap(hl, de);
	ex hl, de
; 901     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 902     swap(hl, de);
	ex hl, de
; 903     push(bc);
	push bc
; 904     CalculateCheckSum();
	call calculatechecksum
; 905     h = b;
	ld h, b
; 906     l = c;
	ld l, c
; 907     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 908     pop(de);
	pop de
; 909     CompareHlDe(hl, de);
	call comparehlde
; 910     if (flag_z)
; 911         return;
	ret z
; 912     swap(hl, de);
	ex hl, de
; 913     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 914     MonitorError();
; 915 }
; 916 
; 917 void MonitorError() {
monitorerror:
; 918     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 919     Monitor2();
	jp monitor2
; 920 }
; 921 
; 922 // Функция для пользовательской программы.
; 923 // Загрузить файл с магнитной ленты.
; 924 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 925 
; 926 void ReadTapeFile(...) {
readtapefile:
; 927     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 928     push_pop(hl) {
	push hl
; 929         hl += bc;
	add hl, bc
; 930         swap(hl, de);
	ex hl, de
; 931         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 932     }
; 933     hl += bc;
	add hl, bc
; 934     swap(hl, de);
	ex hl, de
; 935 
; 936     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 937     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 938     if (flag_z)
; 939         return;
	ret z
; 940 
; 941     push_pop(hl) {
	push hl
; 942         ReadTapeBlock();
	call readtapeblock
; 943         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 944     }
; 945 }
; 946 
; 947 void ReadTapeWordNext() {
readtapewordnext:
; 948     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 949 }
; 950 
; 951 void ReadTapeWord(...) {
readtapeword:
; 952     ReadTapeByte(a);
	call readtapebyte
; 953     b = a;
	ld b, a
; 954     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 955     c = a;
	ld c, a
	ret
; 956 }
; 957 
; 958 void ReadTapeBlock(...) {
readtapeblock:
; 959     for (;;) {
l_74:
; 960         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 961         *hl = a;
	ld (hl), a
; 962         Loop();
	call loop
	jp l_74
; 963     }
; 964 }
; 965 
; 966 // Функция для пользовательской программы.
; 967 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 968 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 969 
; 970 void CalculateCheckSum(...) {
calculatechecksum:
; 971     bc = 0;
	ld bc, 0
; 972     for (;;) {
l_77:
; 973         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 974         push_pop(a) {
	push af
; 975             CompareHlDe(hl, de);
	call comparehlde
; 976             if (flag_z)
; 977                 return PopRet();
	jp z, popret
	pop af
; 978         }
; 979         a = b;
	ld a, b
; 980         carry_add(a, *hl);
	adc (hl)
; 981         b = a;
	ld b, a
; 982         Loop();
	call loop
	jp l_77
; 983     }
; 984 }
; 985 
; 986 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 987 // Сохранить блок данных на магнитную ленту
; 988 
; 989 void CmdO(...) {
cmdo:
; 990     if ((a = c) != 0)
	ld a, c
	or a
; 991         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 992     push_pop(hl) {
	push hl
; 993         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 994     }
; 995     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 996     swap(hl, de);
	ex hl, de
; 997     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 998     swap(hl, de);
	ex hl, de
; 999     push_pop(hl) {
	push hl
; 1000         h = b;
	ld h, b
; 1001         l = c;
	ld l, c
; 1002         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1003     }
; 1004     WriteTapeFile(hl, de);
; 1005 }
; 1006 
; 1007 // Функция для пользовательской программы.
; 1008 // Запись файла на магнитную ленту.
; 1009 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1010 
; 1011 void WriteTapeFile(...) {
writetapefile:
; 1012     push(bc);
	push bc
; 1013     bc = 0;
	ld bc, 0
; 1014     do {
l_81:
; 1015         WriteTapeByte(c);
	call writetapebyte
; 1016         b--;
	dec b
; 1017         swap(hl, *sp);
	ex (sp), hl
; 1018         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1019     } while (flag_nz);
; 1020     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1021     WriteTapeWord(hl);
	call writetapeword
; 1022     swap(hl, de);
	ex hl, de
; 1023     WriteTapeWord(hl);
	call writetapeword
; 1024     swap(hl, de);
	ex hl, de
; 1025     WriteTapeBlock(hl, de);
	call writetapeblock
; 1026     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1027     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1028     pop(hl);
	pop hl
; 1029     WriteTapeWord(hl);
	call writetapeword
; 1030     return;
	ret
; 1031 }
; 1032 
; 1033 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1034     push_pop(bc) {
	push bc
; 1035         PrintCrLfTab();
	call printcrlftab
; 1036         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1037     }
; 1038 }
; 1039 
; 1040 void PrintHexWordSpace(...) {
printhexwordspace:
; 1041     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1042     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1043 }
; 1044 
; 1045 void WriteTapeBlock(...) {
writetapeblock:
; 1046     for (;;) {
l_85:
; 1047         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1048         Loop();
	call loop
	jp l_85
; 1049     }
; 1050 }
; 1051 
; 1052 void WriteTapeWord(...) {
writetapeword:
; 1053     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1054     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1055 }
; 1056 
; 1057 // Загрузка байта с магнитной ленты.
; 1058 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1059 // Результат: a = прочитанный байт.
; 1060 
; 1061 void ReadTapeByte(...) {
readtapebyte:
; 1062     push(hl, bc, de);
	push hl
	push bc
	push de
; 1063     d = a;
	ld d, a
; 1064     ReadTapeByteInternal(d);
; 1065 }
; 1066 
; 1067 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1068     c = 0;
	ld c, 0
; 1069     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1070     do {
l_87:
; 1071     retry:  // Сдвиг результата
retry:
; 1072         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1073         cyclic_rotate_left(a, 1);
	rlca
; 1074         c = a;
	ld c, a
; 1075 
; 1076         // Ожидание изменения бита
; 1077         h = 0;
	ld h, 0
; 1078         do {
l_90:
; 1079             h--;
	dec h
; 1080             if (flag_z)
; 1081                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1082         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1083 
; 1084         // Сохранение бита
; 1085         c = (a |= c);
	or c
	ld c, a
; 1086 
; 1087         // Задержка
; 1088         d--;
	dec d
; 1089         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1090         if (flag_z)
; 1091             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1092         b = a;
	ld b, a
; 1093         do {
l_95:
l_96:
; 1094         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1095         d++;
	inc d
; 1096 
; 1097         // Новое значение бита
; 1098         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1099 
; 1100         // Режим поиска синхробайта
; 1101         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1102             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1103                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1104             } else {
; 1105                 if (a != ~TAPE_START)
	cp 65305
; 1106                     goto retry;
	jp nz, retry
; 1107                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1108             }
; 1109             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1110         }
; 1111     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1112     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1113     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1114 }
; 1115 
; 1116 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1117     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1118         return MonitorError();
	jp p, monitorerror
; 1119     CtrlC();
	call ctrlc
; 1120     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1121 }
; 1122 
; 1123 // Функция для пользовательской программы.
; 1124 // Запись байта на магнитную ленту.
; 1125 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1126 
; 1127 void WriteTapeByte(...) {
writetapebyte:
; 1128     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1129         d = 8;
	ld d, 8
; 1130         do {
l_102:
; 1131             // Сдвиг исходного байта
; 1132             a = c;
	ld a, c
; 1133             cyclic_rotate_left(a, 1);
	rlca
; 1134             c = a;
	ld c, a
; 1135 
; 1136             // Вывод
; 1137             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1138             out(PORT_TAPE, a);
	out (1), a
; 1139 
; 1140             // Задержка
; 1141             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1142             do {
l_105:
; 1143                 b--;
	dec b
l_106:
	jp nz, l_105
; 1144             } while (flag_nz);
; 1145 
; 1146             // Вывод
; 1147             (a = 0) ^= c;
	ld a, 0
	xor c
; 1148             out(PORT_TAPE, a);
	out (1), a
; 1149 
; 1150             // Задержка
; 1151             d--;
	dec d
; 1152             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1153             if (flag_z)
; 1154                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1155             b = a;
	ld b, a
; 1156             do {
l_110:
; 1157                 b--;
	dec b
l_111:
	jp nz, l_110
; 1158             } while (flag_nz);
; 1159             d++;
	inc d
l_103:
; 1160         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1161     }
; 1162 }
; 1163 
; 1164 // Функция для пользовательской программы.
; 1165 // Вывод 8 битного числа на экран.
; 1166 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1167 
; 1168 void PrintHexByte(...) {
printhexbyte:
; 1169     push_pop(a) {
	push af
; 1170         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1171         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1172     }
; 1173     PrintHexNibble(a);
; 1174 }
; 1175 
; 1176 void PrintHexNibble(...) {
printhexnibble:
; 1177     a &= 0x0F;
	and 15
; 1178     if (flag_p(compare(a, 10)))
	cp 10
; 1179         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1180     a += '0';
	add 48
; 1181     PrintCharA(a);
; 1182 }
; 1183 
; 1184 // Вывод символа на экран.
; 1185 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1186 
; 1187 void PrintCharA(...) {
printchara:
; 1188     PrintChar(c = a);
	ld c, a
; 1189 }
; 1190 
; 1191 // Функция для пользовательской программы.
; 1192 // Вывод символа на экран.
; 1193 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1194 
; 1195 void PrintChar(...) {
printchar:
; 1196     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1197     IsAnyKeyPressed();
	call isanykeypressed
; 1198     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1199     hl = cursor;
	ld hl, (cursor)
; 1200     a = escState;
	ld a, (escstate)
; 1201     a--;
	dec a
; 1202     if (flag_m)
; 1203         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1204     if (flag_z)
; 1205         return PrintCharEsc();
	jp z, printcharesc
; 1206     a--;
	dec a
; 1207     if (flag_nz)
; 1208         return PrintCharEscY2();
	jp nz, printcharescy2
; 1209 
; 1210     // Первый параметр ESC Y
; 1211     a = c;
	ld a, c
; 1212     a -= ' ';
	sub 32
; 1213     if (flag_m) {
	jp p, l_115
; 1214         a ^= a;
	xor a
	jp l_116
l_115:
; 1215     } else {
; 1216         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1217             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1218     }
; 1219     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1220     c = a;
	ld c, a
; 1221     b = (a &= 192);
	and 192
	ld b, a
; 1222     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1223     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1224     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1225     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1226 }
; 1227 
; 1228 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1229     escState = a;
	ld (escstate), a
; 1230     PrintCharSaveCursor(hl);
; 1231 }
; 1232 
; 1233 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1234     cursor = hl;
	ld (cursor), hl
; 1235     PrintCharExit();
; 1236 }
; 1237 
; 1238 void PrintCharExit(...) {
printcharexit:
; 1239     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1240     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1241 }
; 1242 
; 1243 void DrawCursor(...) {
drawcursor:
; 1244     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1245         return;
	ret z
; 1246     hl = cursor;
	ld hl, (cursor)
; 1247     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1248     *hl = b;
	ld (hl), b
	ret
; 1249 }
; 1250 
; 1251 void PrintCharEscY2(...) {
printcharescy2:
; 1252     a = c;
	ld a, c
; 1253     a -= ' ';
	sub 32
; 1254     if (flag_m) {
	jp p, l_119
; 1255         a ^= a;
	xor a
	jp l_120
l_119:
; 1256     } else {
; 1257         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1258             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1259     }
; 1260     b = a;
	ld b, a
; 1261     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1262     PrintCharResetEscState();
; 1263 }
; 1264 
; 1265 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1266     a ^= a;
	xor a
; 1267     return PrintCharSetEscState();
	jp printcharsetescstate
; 1268 }
; 1269 
; 1270 void PrintCharEsc(...) {
printcharesc:
; 1271     a = c;
	ld a, c
; 1272     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1273         a = 2;
	ld a, 2
; 1274         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1275     }
; 1276     if (a == 97) {
	cp 97
	jp nz, l_125
; 1277         a ^= a;
	xor a
; 1278         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1279     }
; 1280     if (a != 98)
	cp 98
; 1281         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1282     SetCursorVisible();
; 1283 }
; 1284 
; 1285 void SetCursorVisible(...) {
setcursorvisible:
; 1286     cursorVisible = a;
	ld (cursorvisible), a
; 1287     return PrintCharResetEscState();
	jp printcharresetescstate
; 1288 }
; 1289 
; 1290 void PrintCharNoEsc(...) {
printcharnoesc:
; 1291     // Остановка вывода нажатием УС + Шифт
; 1292     do {
l_127:
; 1293         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1294     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1295 
; 1296     compare(a = 16, c);
	ld a, 16
	cp c
; 1297     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1298     if (flag_z) {
	jp nz, l_130
; 1299         invert(a);
	cpl
; 1300         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1301         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1302     }
; 1303     if (a != 0)
	or a
; 1304         TranslateCodePage(c);
	call nz, translatecodepage
; 1305     a = c;
	ld a, c
; 1306     if (a == 31)
	cp 31
; 1307         return ClearScreen();
	jp z, clearscreen
; 1308     if (flag_m)
; 1309         return PrintChar3(a);
	jp m, printchar3
; 1310     PrintChar4(a);
; 1311 }
; 1312 
; 1313 void PrintChar4(...) {
printchar4:
; 1314     *hl = a;
	ld (hl), a
; 1315     hl++;
	inc hl
; 1316     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1317         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1318     PrintCrLf();
	call printcrlf
; 1319     PrintCharExit();
	jp printcharexit
; 1320 }
; 1321 
; 1322 void ClearScreen(...) {
clearscreen:
; 1323     b = ' ';
	ld b, 32
; 1324     a = SCREEN_END >> 8;
	ld a, 240
; 1325     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1326     do {
l_132:
; 1327         *hl = b;
	ld (hl), b
; 1328         hl++;
	inc hl
; 1329         *hl = b;
	ld (hl), b
; 1330         hl++;
	inc hl
l_133:
; 1331     } while (a != h);
	cp h
	jp nz, l_132
; 1332     MoveCursorHome();
; 1333 }
; 1334 
; 1335 void MoveCursorHome(...) {
movecursorhome:
; 1336     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1337 }
; 1338 
; 1339 void PrintChar3(...) {
printchar3:
; 1340     if (a == 12)
	cp 12
; 1341         return MoveCursorHome();
	jp z, movecursorhome
; 1342     if (a == 13)
	cp 13
; 1343         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1344     if (a == 10)
	cp 10
; 1345         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1346     if (a == 8)
	cp 8
; 1347         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1348     if (a == 24)
	cp 24
; 1349         return MoveCursorRight(hl);
	jp z, movecursorright
; 1350     if (a == 25)
	cp 25
; 1351         return MoveCursorUp(hl);
	jp z, movecursorup
; 1352     if (a == 7)
	cp 7
; 1353         return PrintCharBeep();
	jp z, printcharbeep
; 1354     if (a == 26)
	cp 26
; 1355         return MoveCursorDown();
	jp z, movecursordown
; 1356     if (a != 27)
	cp 27
; 1357         return PrintChar4(hl, a);
	jp nz, printchar4
; 1358     a = 1;
	ld a, 1
; 1359     PrintCharSetEscState();
	jp printcharsetescstate
; 1360 }
; 1361 
; 1362 void PrintCharBeep(...) {
printcharbeep:
; 1363     c = 128;  // Длительность
	ld c, 128
; 1364     e = 32;   // Частота
	ld e, 32
; 1365     do {
l_135:
; 1366         d = e;
	ld d, e
; 1367         do {
l_138:
; 1368             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1369         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1370         e = d;
	ld e, d
; 1371         do {
l_141:
; 1372             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1373         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1374     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1375 
; 1376     PrintCharExit();
	jp printcharexit
; 1377 }
; 1378 
; 1379 void MoveCursorCr(...) {
movecursorcr:
; 1380     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1381     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1382 }
; 1383 
; 1384 void MoveCursorRight(...) {
movecursorright:
; 1385     hl++;
	inc hl
; 1386     MoveCursorBoundary(hl);
; 1387 }
; 1388 
; 1389 void MoveCursorBoundary(...) {
movecursorboundary:
; 1390     a = h;
	ld a, h
; 1391     a &= 7;
	and 7
; 1392     a |= SCREEN_BEGIN >> 8;
	or 232
; 1393     h = a;
	ld h, a
; 1394     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1395 }
; 1396 
; 1397 void MoveCursorLeft(...) {
movecursorleft:
; 1398     hl--;
	dec hl
; 1399     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1400 }
; 1401 
; 1402 void MoveCursorLf(...) {
movecursorlf:
; 1403     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1404     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1405         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1406 
; 1407     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1408     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1409     do {
l_144:
; 1410         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1411         hl++;
	inc hl
; 1412         bc++;
	inc bc
; 1413         *hl = a = *bc;
	ld a, (bc)
	ld (hl), a
; 1414         hl++;
	inc hl
; 1415         bc++;
	inc bc
l_145:
; 1416     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1417     a = SCREEN_END >> 8;
	ld a, 240
; 1418     c = ' ';
	ld c, 32
; 1419     do {
l_147:
; 1420         *hl = c;
	ld (hl), c
; 1421         hl++;
	inc hl
; 1422         *hl = c;
	ld (hl), c
; 1423         hl++;
	inc hl
l_148:
; 1424     } while (a != h);
	cp h
	jp nz, l_147
; 1425     hl = cursor;
	ld hl, (cursor)
; 1426     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1427     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1428     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1429 }
; 1430 
; 1431 void MoveCursorUp(...) {
movecursorup:
; 1432     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1433 }
; 1434 
; 1435 void MoveCursor(...) {
movecursor:
; 1436     hl += bc;
	add hl, bc
; 1437     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1438 }
; 1439 
; 1440 void MoveCursorDown(...) {
movecursordown:
; 1441     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1442 }
; 1443 
; 1444 void PrintCrLf() {
printcrlf:
; 1445     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1446     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1447 }
; 1448 
; 1449 // Функция для пользовательской программы.
; 1450 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1451 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1452 
; 1453 void IsAnyKeyPressed() {
isanykeypressed:
; 1454     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1455     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1456     a &= KEYBOARD_ROW_MASK;
	and 127
; 1457     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1458         a ^= a;
	xor a
; 1459         return;
	ret
l_150:
; 1460     }
; 1461     a = 0xFF;
	ld a, 255
	ret
; 1462 }
; 1463 
; 1464 // Функция для пользовательской программы.
; 1465 // Получить код нажатой клавиши на клавиатуре.
; 1466 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1467 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1468 
; 1469 void ReadKey() {
readkey:
; 1470     push_pop(hl) {
	push hl
; 1471         hl = keyDelay;
	ld hl, (keydelay)
; 1472         ReadKeyInternal(hl);
	call readkeyinternal
; 1473         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1474         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1475             do {
l_154:
; 1476                 do {
l_157:
; 1477                     l = 2;
	ld l, 2
; 1478                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1479                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1480             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1481             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1482         }
; 1483         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1484     }
; 1485 }
; 1486 
; 1487 void ReadKeyInternal(...) {
readkeyinternal:
; 1488     do {
l_160:
; 1489         ScanKey();
	call scankey
; 1490         if (a != h)
	cp h
; 1491             break;
	jp nz, l_162
; 1492 
; 1493         // Задержка
; 1494         push_pop(a) {
	push af
; 1495             a ^= a;
	xor a
; 1496             do {
l_163:
; 1497                 swap(hl, de);
	ex hl, de
; 1498                 swap(hl, de);
	ex hl, de
l_164:
; 1499             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1500         }
; 1501     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1502     h = a;
	ld h, a
	ret
; 1503 }
; 1504 
; 1505 // Функция для пользовательской программы.
; 1506 // Получить код нажатой клавиши на клавиатуре.
; 1507 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1508 
; 1509 void ScanKey() {
scankey:
; 1510     push(bc, de, hl);
	push bc
	push de
	push hl
; 1511 
; 1512     bc = 0x00FE;
	ld bc, 254
; 1513     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1514     do {
l_166:
; 1515         a = c;
	ld a, c
; 1516         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1517         cyclic_rotate_left(a, 1);
	rlca
; 1518         c = a;
	ld c, a
; 1519         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1520         a &= KEYBOARD_ROW_MASK;
	and 127
; 1521         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1522             return ScanKey2(a);
	jp nz, scankey2
; 1523         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1524     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1525 
; 1526     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1527     carry_rotate_right(a, 1);
	rra
; 1528     a = 0xFF;  // Клавиша не нажата
	ld a, 255
; 1529     if (flag_c)
; 1530         return ScanKeyExit(a);
	jp c, scankeyexit
; 1531     a--;  // Рус/Лат
	dec a
; 1532     ScanKeyExit(a);
	jp scankeyexit
; 1533 }
; 1534 
; 1535 void ScanKey2(...) {
scankey2:
; 1536     for (;;) {
l_170:
; 1537         carry_rotate_right(a, 1);
	rra
; 1538         if (flag_nc)
; 1539             break;
	jp nc, l_171
; 1540         b++;
	inc b
	jp l_170
l_171:
; 1541     }
; 1542 
; 1543     /* b - key number */
; 1544 
; 1545     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1546      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1547      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1548      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1549      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1550      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1551      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1552 
; 1553     a = b;
	ld a, b
; 1554     if (a >= 48)
	cp 48
; 1555         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1556     a += 48;
	add 48
; 1557     if (a >= 60)
	cp 60
; 1558         if (a < 64)
	jp c, l_172
	cp 64
; 1559             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1560 
; 1561     if (a == 95)
	cp 95
; 1562         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1563 
; 1564     c = a;
	ld c, a
; 1565     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1566     a &= KEYBOARD_MODS_MASK;
	and 7
; 1567     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1568     b = a;
	ld b, a
; 1569     a = c;
	ld a, c
; 1570     if (flag_z)
; 1571         return ScanKeyExit(a);
	jp z, scankeyexit
; 1572     a = b;
	ld a, b
; 1573     carry_rotate_right(a, 2);
	rra
	rra
; 1574     if (flag_nc)
; 1575         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1576     carry_rotate_right(a, 1);
	rra
; 1577     if (flag_nc)
; 1578         return ScanKeyShift();
	jp nc, scankeyshift
; 1579     (a = c) |= 0x20;
	ld a, c
	or 32
; 1580     ScanKeyExit(a);
; 1581 }
; 1582 
; 1583 void ScanKeyExit(...) {
scankeyexit:
; 1584     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1585 }
; 1586 
; 1587 void ScanKeyControl(...) {
scankeycontrol:
; 1588     a = c;
	ld a, c
; 1589     a &= 0x1F;
	and 31
; 1590     return ScanKeyExit(a);
	jp scankeyexit
; 1591 }
; 1592 
; 1593 void ScanKeyShift(...) {
scankeyshift:
; 1594     if ((a = c) == 127)
	ld a, c
	cp 127
; 1595         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1596     if (a >= 64)
	cp 64
; 1597         return ScanKeyExit();
	jp nc, scankeyexit
; 1598     if (a < 48) {
	cp 48
	jp nc, l_180
; 1599         a |= 16;
	or 16
; 1600         return ScanKeyExit();
	jp scankeyexit
l_180:
; 1601     }
; 1602     a &= 47;
	and 47
; 1603     return ScanKeyExit();
	jp scankeyexit
; 1604 }
; 1605 
; 1606 void ScanKeySpecial(...) {
scankeyspecial:
; 1607     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1608     c = (a -= 48);
	sub 48
	ld c, a
; 1609     b = 0;
	ld b, 0
; 1610     hl += bc;
	add hl, bc
; 1611     a = *hl;
	ld a, (hl)
; 1612     return ScanKeyExit(a);
	jp scankeyexit
; 1613 }
; 1614 
; 1615 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1626  aPrompt[6] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1627  aCrLfTab[6] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1628  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1629  aBackspace[4] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1630  aHello[] = "\x1F\nm/80k ";
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
; 1632  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1633 }
; 1634 
; 1635 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
