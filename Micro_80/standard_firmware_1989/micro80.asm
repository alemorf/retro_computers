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
; 155 
; 156 // Переменные Монитора
; 157 
; 158 extern uint8_t pressedKey __address(0xF759);
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
; 185 extern uint8_t specialKeyTable[8];
; 186 extern uint8_t aPrompt[6];
; 187 extern uint8_t aCrLfTab[6];
; 188 extern uint8_t aRegisters[37];
; 189 extern uint8_t aBackspace[4];
; 190 extern uint8_t aHello[9];
; 191 
; 192 // Для удобства
; 193 
; 194 void JmpParam1() __address(0xF774);
; 195 void TranslateCodePage() __address(0xF77E);
; 196 
; 197 // Точки входа
; 198 
; 199 void EntryF800_Reboot() {
entryf800_reboot:
; 200     Reboot();
	jp reboot
; 201 }
; 202 
; 203 void EntryF803_ReadKey() {
entryf803_readkey:
; 204     ReadKey();
	jp readkey
; 205 }
; 206 
; 207 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 208     ReadTapeByte(a);
	jp readtapebyte
; 209 }
; 210 
; 211 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 212     PrintChar(c);
	jp printchar
; 213 }
; 214 
; 215 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 216     WriteTapeByte(c);
	jp writetapebyte
; 217 }
; 218 
; 219 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 220     TranslateCodePage(c);
	jp translatecodepage
; 221 }
; 222 
; 223 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 224     IsAnyKeyPressed();
	jp isanykeypressed
; 225 }
; 226 
; 227 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 228     PrintHexByte(a);
	jp printhexbyte
; 229 }
; 230 
; 231 void EntryF818_PrintString(...) {
entryf818_printstring:
; 232     PrintString(hl);
	jp printstring
; 233 }
; 234 
; 235 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 236     ScanKey();
	jp scankey
; 237 }
; 238 
; 239 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 240     GetCursor();
	jp getcursor
; 241 }
; 242 
; 243 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 244     GetCursorChar();
	jp getcursorchar
; 245 }
; 246 
; 247 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 248     ReadTapeFile(hl);
	jp readtapefile
; 249 }
; 250 
; 251 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 252     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 253 }
; 254 
; 255 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 256     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 257 }
; 258 
; 259 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 260     return;
	ret
; 261 }
; 262 
; 263 uint16_t empty = 0;
empty:
	dw 0
; 265  EntryF830_GetRamTop() {
entryf830_getramtop:
; 266     return GetRamTop();
	jp getramtop
; 267 }
; 268 
; 269 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 270     return SetRamTop(hl);
	jp setramtop
; 271 }
; 272 
; 273 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 274 // Параметры: нет. Функция никогда не завершается.
; 275 
; 276 void Reboot(...) {
reboot:
; 277     sp = STACK_TOP;
	ld sp, 63488
; 278 
; 279     // Очистка памяти
; 280     hl = &tapeWriteSpeed;
	ld hl, 0FFFFh & (tapewritespeed)
; 281     de = inputBuffer + sizeof(inputBuffer) - 1;
	ld de, 0FFFFh & (((inputbuffer) + (32)) - (1))
; 282     bc = 0;
	ld bc, 0
; 283     CmdF();
	call cmdf
; 284 
; 285     translateCodePageJump = a = OPCODE_JMP;
	ld a, 195
	ld (translatecodepagejump), a
; 286 
; 287     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 288 
; 289     // Проверка ОЗУ
; 290     hl = 0;
	ld hl, 0
; 291     for (;;) {
l_1:
; 292         c = *hl;
	ld c, (hl)
; 293         a = 0x55;
	ld a, 85
; 294         *hl = a;
	ld (hl), a
; 295         a ^= *hl;
	xor (hl)
; 296         b = a;
	ld b, a
; 297         a = 0xAA;
	ld a, 170
; 298         *hl = a;
	ld (hl), a
; 299         a ^= *hl;
	xor (hl)
; 300         a |= b;
	or b
; 301         if (flag_nz)
; 302             return Reboot2();
	jp nz, reboot2
; 303         *hl = c;
	ld (hl), c
; 304         hl++;
	inc hl
; 305         if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
	ld a, h
	cp 65504
; 306             return Reboot2();
	jp z, reboot2
	jp l_1
; 307     }
; 308 
; 309     Reboot2();
	jp reboot2
 .org 0xF86C
; 310 }
; 311 
; 312 asm(" .org 0xF86C");
; 313 
; 314 void EntryF86C_Monitor() {
entryf86c_monitor:
; 315     return Monitor();
	jp monitor
; 316 }
; 317 
; 318 void Reboot2(...) {
reboot2:
; 319     hl--;
	dec hl
; 320     ramTop = hl;
	ld (ramtop), hl
; 321     PrintHexWordSpace(hl);
	call printhexwordspace
; 322     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 323     translateCodePageAddress = hl = &TranslateCodePageDefault;
	ld hl, 0FFFFh & (translatecodepagedefault)
	ld (translatecodepageaddress), hl
; 324     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 325     Monitor();
; 326 }
; 327 
; 328 void Monitor() {
monitor:
; 329     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 330     cursorVisible = a;
	ld (cursorvisible), a
; 331     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 332     Monitor2();
; 333 }
; 334 
; 335 void Monitor2() {
monitor2:
; 336     sp = STACK_TOP;
	ld sp, 63488
; 337     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 338     ReadString();
	call readstring
; 339 
; 340     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 341 
; 342     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 343     a = *hl;
	ld a, (hl)
; 344 
; 345     if (a == 'X')
	cp 88
; 346         return CmdX();
	jp z, cmdx
; 347 
; 348     push_pop(a) {
	push af
; 349         ParseParams();
	call parseparams
; 350         hl = param3;
	ld hl, (param3)
; 351         c = l;
	ld c, l
; 352         b = h;
	ld b, h
; 353         hl = param2;
	ld hl, (param2)
; 354         swap(hl, de);
	ex hl, de
; 355         hl = param1;
	ld hl, (param1)
	pop af
; 356     }
; 357 
; 358     if (a == 'D')
	cp 68
; 359         return CmdD();
	jp z, cmdd
; 360     if (a == 'C')
	cp 67
; 361         return CmdC();
	jp z, cmdc
; 362     if (a == 'F')
	cp 70
; 363         return CmdF();
	jp z, cmdf
; 364     if (a == 'S')
	cp 83
; 365         return CmdS();
	jp z, cmds
; 366     if (a == 'T')
	cp 84
; 367         return CmdT();
	jp z, cmdt
; 368     if (a == 'M')
	cp 77
; 369         return CmdM();
	jp z, cmdm
; 370     if (a == 'G')
	cp 71
; 371         return CmdG();
	jp z, cmdg
; 372     if (a == 'I')
	cp 73
; 373         return CmdI();
	jp z, cmdi
; 374     if (a == 'O')
	cp 79
; 375         return CmdO();
	jp z, cmdo
; 376     if (a == 'W')
	cp 87
; 377         return CmdW();
	jp z, cmdw
; 378     if (a == 'A')
	cp 65
; 379         return CmdA();
	jp z, cmda
; 380     if (a == 'H')
	cp 72
; 381         return CmdH();
	jp z, cmdh
; 382     if (a == 'R')
	cp 82
; 383         return CmdR();
	jp z, cmdr
; 384     return MonitorError();
	jp monitorerror
; 385 }
; 386 
; 387 void ReadStringBackspace(...) {
readstringbackspace:
; 388     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 389         return ReadStringBegin(hl);
	jp z, readstringbegin
; 390     push_pop(hl) {
	push hl
; 391         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 392     }
; 393     hl--;
	dec hl
; 394     return ReadStringLoop(b, hl);
	jp readstringloop
; 395 }
; 396 
; 397 void ReadString() {
readstring:
; 398     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 399     ReadStringBegin(hl);
; 400 }
; 401 
; 402 void ReadStringBegin(...) {
readstringbegin:
; 403     b = 0;
	ld b, 0
; 404     ReadStringLoop(b, hl);
; 405 }
; 406 
; 407 void ReadStringLoop(...) {
readstringloop:
; 408     for (;;) {
l_4:
; 409         ReadKey();
	call readkey
; 410         if (a == 127)
	cp 127
; 411             return ReadStringBackspace();
	jp z, readstringbackspace
; 412         if (a == 8)
	cp 8
; 413             return ReadStringBackspace();
	jp z, readstringbackspace
; 414         if (flag_nz)
; 415             PrintCharA(a);
	call nz, printchara
; 416         *hl = a;
	ld (hl), a
; 417         if (a == 13)
	cp 13
; 418             return ReadStringExit(b);
	jp z, readstringexit
; 419         if (a == '.')
	cp 46
; 420             return Monitor2();
	jp z, monitor2
; 421         b = 255;
	ld b, 255
; 422         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 423             return MonitorError();
	jp z, monitorerror
; 424         hl++;
	inc hl
	jp l_4
; 425     }
; 426 }
; 427 
; 428 void ReadStringExit(...) {
readstringexit:
; 429     a = b;
	ld a, b
; 430     carry_rotate_left(a, 1);
	rla
; 431     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 432     b = 0;
	ld b, 0
	ret
; 433 }
; 434 
; 435 // Функция для пользовательской программы.
; 436 // Вывод строки на экран.
; 437 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 438 
; 439 void PrintString(...) {
printstring:
; 440     for (;;) {
l_7:
; 441         a = *hl;
	ld a, (hl)
; 442         if (flag_z(a &= a))
	and a
; 443             return;
	ret z
; 444         PrintCharA(a);
	call printchara
; 445         hl++;
	inc hl
	jp l_7
; 446     }
; 447 }
; 448 
; 449 void ParseParams(...) {
parseparams:
; 450     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 451     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 452     c = 0;
	ld c, 0
; 453     CmdF();
	call cmdf
; 454 
; 455     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 456 
; 457     ParseWord();
	call parseword
; 458     param1 = hl;
	ld (param1), hl
; 459     param2 = hl;
	ld (param2), hl
; 460     if (flag_c)
; 461         return;
	ret c
; 462 
; 463     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 464     ParseWord();
	call parseword
; 465     param2 = hl;
	ld (param2), hl
; 466     if (flag_c)
; 467         return;
	ret c
; 468 
; 469     ParseWord();
	call parseword
; 470     param3 = hl;
	ld (param3), hl
; 471     if (flag_c)
; 472         return;
	ret c
; 473 
; 474     MonitorError();
	jp monitorerror
; 475 }
; 476 
; 477 void ParseWord(...) {
parseword:
; 478     hl = 0;
	ld hl, 0
; 479     for (;;) {
l_10:
; 480         a = *de;
	ld a, (de)
; 481         de++;
	inc de
; 482         if (a == 13)
	cp 13
; 483             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 484         if (a == ',')
	cp 44
; 485             return;
	ret z
; 486         if (a == ' ')
	cp 32
; 487             continue;
	jp z, l_10
; 488         a -= '0';
	sub 48
; 489         if (flag_m)
; 490             return MonitorError();
	jp m, monitorerror
; 491         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_12
; 492             if (flag_m(compare(a, 17)))
	cp 17
; 493                 return MonitorError();
	jp m, monitorerror
; 494             if (flag_p(compare(a, 23)))
	cp 23
; 495                 return MonitorError();
	jp p, monitorerror
; 496             a -= 7;
	sub 7
l_12:
; 497         }
; 498         c = a;
	ld c, a
; 499         hl += hl;
	add hl, hl
; 500         hl += hl;
	add hl, hl
; 501         hl += hl;
	add hl, hl
; 502         hl += hl;
	add hl, hl
; 503         if (flag_c)
; 504             return MonitorError();
	jp c, monitorerror
; 505         hl += bc;
	add hl, bc
	jp l_10
; 506     }
; 507 }
; 508 
; 509 void ParseWordReturnCf(...) {
parsewordreturncf:
; 510     set_flag_c();
	scf
	ret
; 511 }
; 512 
; 513 void CompareHlDe(...) {
comparehlde:
; 514     if ((a = h) != d)
	ld a, h
	cp d
; 515         return;
	ret nz
; 516     compare(a = l, e);
	ld a, l
	cp e
	ret
; 517 }
; 518 
; 519 void LoopWithBreak(...) {
loopwithbreak:
; 520     CtrlC();
	call ctrlc
; 521     Loop(hl, de);
; 522 }
; 523 
; 524 void Loop(...) {
loop:
; 525     CompareHlDe(hl, de);
	call comparehlde
; 526     if (flag_nz)
; 527         return IncHl(hl);
	jp nz, inchl
; 528     PopRet();
; 529 }
; 530 
; 531 void PopRet() {
popret:
; 532     sp++;
	inc sp
; 533     sp++;
	inc sp
	ret
; 534 }
; 535 
; 536 void IncHl(...) {
inchl:
; 537     hl++;
	inc hl
	ret
; 538 }
; 539 
; 540 void CtrlC() {
ctrlc:
; 541     ScanKey();
	call scankey
; 542     if (a != 3)  // УПР + C
	cp 3
; 543         return;
	ret nz
; 544     MonitorError();
	jp monitorerror
; 545 }
; 546 
; 547 void PrintCrLfTab() {
printcrlftab:
; 548     push_pop(hl) {
	push hl
; 549         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 550     }
; 551 }
; 552 
; 553 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 554     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 555 }
; 556 
; 557 void PrintHexByteSpace(...) {
printhexbytespace:
; 558     push_pop(bc) {
	push bc
; 559         PrintHexByte(a);
	call printhexbyte
; 560         PrintSpace();
	call printspace
	pop bc
	ret
; 561     }
; 562 }
; 563 
; 564 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 565 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 566 
; 567 void CmdR(...) {
cmdr:
; 568     out(PORT_EXT_MODE, a = 0x90);
	ld a, 144
	out (163), a
; 569     for (;;) {
l_15:
; 570         out(PORT_EXT_ADDR_LOW, a = l);
	ld a, l
	out (161), a
; 571         out(PORT_EXT_ADDR_HIGH, a = h);
	ld a, h
	out (162), a
; 572         *bc = a = in(PORT_EXT_DATA);
	in a, (160)
	ld (bc), a
; 573         bc++;
	inc bc
; 574         Loop();
	call loop
	jp l_15
; 575     }
; 576 }
; 577 
; 578 // Функция для пользовательской программы.
; 579 // Получить адрес последнего доступного байта оперативной памяти.
; 580 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 581 
; 582 void GetRamTop(...) {
getramtop:
; 583     hl = ramTop;
	ld hl, (ramtop)
	ret
; 584 }
; 585 
; 586 // Функция для пользовательской программы.
; 587 // Установить адрес последнего доступного байта оперативной памяти.
; 588 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 589 
; 590 void SetRamTop(...) {
setramtop:
; 591     ramTop = hl;
	ld (ramtop), hl
	ret
; 592 }
; 593 
; 594 // Команда A <адрес>
; 595 // Установить программу преобразования кодировки символов выводимых на экран
; 596 
; 597 void CmdA(...) {
cmda:
; 598     translateCodePageAddress = hl;
	ld (translatecodepageaddress), hl
	ret
; 599 }
; 600 
; 601 // Команда D <начальный адрес> <конечный адрес>
; 602 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 603 
; 604 void CmdD(...) {
cmdd:
; 605     for (;;) {
l_18:
; 606         PrintCrLf();
	call printcrlf
; 607         PrintHexWordSpace(hl);
	call printhexwordspace
; 608         push_pop(hl) {
	push hl
; 609             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 610             carry_rotate_right(a, 1);
	rra
; 611             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 612             PrintSpacesTo();
	call printspacesto
; 613             do {
l_20:
; 614                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 615                 CompareHlDe(hl, de);
	call comparehlde
; 616                 hl++;
	inc hl
; 617                 if (flag_z)
; 618                     break;
	jp z, l_22
; 619                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 620                 push_pop(a) {
	push af
; 621                     a &= 1;
	and 1
; 622                     if (flag_z)
; 623                         PrintSpace();
	call z, printspace
	pop af
l_21:
	jp nz, l_20
l_22:
	pop hl
; 624                 }
; 625             } while (flag_nz);
; 626         }
; 627 
; 628         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 629         PrintSpacesTo(b);
	call printspacesto
; 630 
; 631         do {
l_23:
; 632             a = *hl;
	ld a, (hl)
; 633             if (a < 127)
	cp 127
; 634                 if (a >= 32)
	jp nc, l_26
	cp 32
; 635                     goto loc_fa49;
	jp nc, loc_fa49
l_26:
; 636             a = '.';
	ld a, 46
; 637         loc_fa49:
loc_fa49:
; 638             PrintCharA(a);
	call printchara
; 639             CompareHlDe(hl, de);
	call comparehlde
; 640             if (flag_z)
; 641                 return;
	ret z
; 642             hl++;
	inc hl
; 643             (a = l) &= 0x0F;
	ld a, l
	and 15
l_24:
	jp nz, l_23
	jp l_18
; 644         } while (flag_nz);
; 645     }
; 646 }
; 647 
; 648 void PrintSpacesTo(...) {
printspacesto:
; 649     for (;;) {
l_29:
; 650         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 651             return;
	ret nc
; 652         PrintSpace();
	call printspace
	jp l_29
; 653     }
; 654 }
; 655 
; 656 void PrintSpace() {
printspace:
; 657     return PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 658 }
; 659 
; 660 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 661 // Сравнить два блока адресного пространство
; 662 
; 663 void CmdC(...) {
cmdc:
; 664     for (;;) {
l_32:
; 665         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_34
; 666             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 667             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 668             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_34:
; 669         }
; 670         bc++;
	inc bc
; 671         LoopWithBreak();
	call loopwithbreak
	jp l_32
; 672     }
; 673 }
; 674 
; 675 // Команда F <начальный адрес> <конечный адрес> <байт>
; 676 // Заполнить блок в адресном пространстве одним байтом
; 677 
; 678 void CmdF(...) {
cmdf:
; 679     for (;;) {
l_37:
; 680         *hl = c;
	ld (hl), c
; 681         Loop();
	call loop
	jp l_37
; 682     }
; 683 }
; 684 
; 685 // Команда S <начальный адрес> <конечный адрес> <байт>
; 686 // Найти байт (8 битное значение) в адресном пространстве
; 687 
; 688 void CmdS(...) {
cmds:
; 689     for (;;) {
l_40:
; 690         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 691             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 692         LoopWithBreak();
	call loopwithbreak
	jp l_40
; 693     }
; 694 }
; 695 
; 696 // Команда W <начальный адрес> <конечный адрес> <слово>
; 697 // Найти слово (16 битное значение) в адресном пространстве
; 698 
; 699 void CmdW(...) {
cmdw:
; 700     for (;;) {
l_43:
; 701         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_45
; 702             hl++;
	inc hl
; 703             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 704             hl--;
	dec hl
; 705             if (flag_z)
; 706                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_45:
; 707         }
; 708         LoopWithBreak();
	call loopwithbreak
	jp l_43
; 709     }
; 710 }
; 711 
; 712 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 713 // Копировать блок в адресном пространстве
; 714 
; 715 void CmdT(...) {
cmdt:
; 716     for (;;) {
l_48:
; 717         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 718         bc++;
	inc bc
; 719         Loop();
	call loop
	jp l_48
; 720     }
; 721 }
; 722 
; 723 // Команда M <начальный адрес>
; 724 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 725 
; 726 void CmdM(...) {
cmdm:
; 727     for (;;) {
l_51:
; 728         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 729         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 730         push_pop(hl) {
	push hl
; 731             ReadString();
	call readstring
	pop hl
; 732         }
; 733         if (flag_c) {
	jp nc, l_53
; 734             push_pop(hl) {
	push hl
; 735                 ParseWord();
	call parseword
; 736                 a = l;
	ld a, l
	pop hl
; 737             }
; 738             *hl = a;
	ld (hl), a
l_53:
; 739         }
; 740         hl++;
	inc hl
	jp l_51
; 741     }
; 742 }
; 743 
; 744 // Команда G <начальный адрес> <конечный адрес>
; 745 // Запуск программы и возможным указанием точки останова.
; 746 
; 747 void CmdG(...) {
cmdg:
; 748     CompareHlDe(hl, de);
	call comparehlde
; 749     if (flag_nz) {
	jp z, l_55
; 750         swap(hl, de);
	ex hl, de
; 751         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 752         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 753         *hl = OPCODE_RST_30;
	ld (hl), 247
; 754         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 755         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_55:
; 756     }
; 757     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 758     pop(bc);
	pop bc
; 759     pop(de);
	pop de
; 760     pop(hl);
	pop hl
; 761     pop(a);
	pop af
; 762     sp = hl;
	ld sp, hl
; 763     hl = regHL;
	ld hl, (reghl)
; 764     return JmpParam1();
	jp jmpparam1
; 765 }
; 766 
; 767 void BreakPointHandler(...) {
breakpointhandler:
; 768     regHL = hl;
	ld (reghl), hl
; 769     push(a);
	push af
; 770     pop(hl);
	pop hl
; 771     regAF = hl;
	ld (regaf), hl
; 772     pop(hl);
	pop hl
; 773     hl--;
	dec hl
; 774     regPC = hl;
	ld (regpc), hl
; 775     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 776     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 777     push(hl);
	push hl
; 778     push(de);
	push de
; 779     push(bc);
	push bc
; 780     sp = STACK_TOP;
	ld sp, 63488
; 781     hl = regPC;
	ld hl, (regpc)
; 782     swap(hl, de);
	ex hl, de
; 783     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 784     CompareHlDe(hl, de);
	call comparehlde
; 785     if (flag_nz)
; 786         return CmdX();
	jp nz, cmdx
; 787     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 788     CmdX();
; 789 }
; 790 
; 791 // Команда X
; 792 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 793 
; 794 void CmdX(...) {
cmdx:
; 795     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 796     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 797     b = 6;
	ld b, 6
; 798     do {
l_57:
; 799         e = *hl;
	ld e, (hl)
; 800         hl++;
	inc hl
; 801         d = *hl;
	ld d, (hl)
; 802         push(bc);
	push bc
; 803         push(hl);
	push hl
; 804         swap(hl, de);
	ex hl, de
; 805         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 806         ReadString();
	call readstring
; 807         if (flag_c) {
	jp nc, l_60
; 808             ParseWord();
	call parseword
; 809             pop(de);
	pop de
; 810             push(de);
	push de
; 811             swap(hl, de);
	ex hl, de
; 812             *hl = d;
	ld (hl), d
; 813             hl--;
	dec hl
; 814             *hl = e;
	ld (hl), e
l_60:
; 815         }
; 816         pop(hl);
	pop hl
; 817         pop(bc);
	pop bc
; 818         b--;
	dec b
; 819         hl++;
	inc hl
l_58:
	jp nz, l_57
; 820     } while (flag_nz);
; 821     EntryF86C_Monitor();
	jp entryf86c_monitor
; 822 }
; 823 
; 824 // Функция для пользовательской программы.
; 825 // Получить координаты курсора.
; 826 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 827 
; 828 void GetCursor() {
getcursor:
; 829     push_pop(a) {
	push af
; 830         hl = cursor;
	ld hl, (cursor)
; 831         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 832 
; 833         // Вычисление X
; 834         a = l;
	ld a, l
; 835         a &= (SCREEN_WIDTH - 1);
	and 63
; 836         a += 8;  // Смещение Радио 86РК
	add 8
; 837 
; 838         // Вычисление Y
; 839         hl += hl;
	add hl, hl
; 840         hl += hl;
	add hl, hl
; 841         h++;  // Смещение Радио 86РК
	inc h
; 842         h++;
	inc h
; 843         h++;
	inc h
; 844 
; 845         l = a;
	ld l, a
	pop af
	ret
; 846     }
; 847 }
; 848 
; 849 // Функция для пользовательской программы.
; 850 // Получить символ под курсором.
; 851 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 852 
; 853 void GetCursorChar() {
getcursorchar:
; 854     push_pop(hl) {
	push hl
; 855         hl = cursor;
	ld hl, (cursor)
; 856         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 857     }
; 858 }
; 859 
; 860 // Команда H
; 861 // Определить скорости записанной программы.
; 862 // Выводит 4 цифры на экран.
; 863 // Первые две цифры - константа вывода для команды O
; 864 // Последние две цифры - константа вввода для команды I
; 865 
; 866 void CmdH(...) {
cmdh:
; 867     PrintCrLfTab();
	call printcrlftab
; 868     hl = 65408;
	ld hl, 65408
; 869     b = 123;
	ld b, 123
; 870 
; 871     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 872 
; 873     do {
l_62:
l_63:
; 874     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
; 875 
; 876     do {
l_65:
; 877         c = a;
	ld c, a
; 878         do {
l_68:
; 879             hl++;
	inc hl
l_69:
; 880         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_68
l_66:
; 881     } while (flag_nz(b--));
	dec b
	jp nz, l_65
; 882 
; 883     hl += hl;
	add hl, hl
; 884     a = h;
	ld a, h
; 885     hl += hl;
	add hl, hl
; 886     l = (a += h);
	add h
	ld l, a
; 887 
; 888     PrintHexWordSpace();
	jp printhexwordspace
; 889 }
; 890 
; 891 // Команда I <смещение> <скорость>
; 892 // Загрузить файл с магнитной ленты
; 893 
; 894 void CmdI(...) {
cmdi:
; 895     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 896         tapeReadSpeed = a = e;
	jp z, l_71
	ld a, e
	ld (tapereadspeed), a
l_71:
; 897     ReadTapeFile();
	call readtapefile
; 898     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 899     swap(hl, de);
	ex hl, de
; 900     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 901     swap(hl, de);
	ex hl, de
; 902     push(bc);
	push bc
; 903     CalculateCheckSum();
	call calculatechecksum
; 904     h = b;
	ld h, b
; 905     l = c;
	ld l, c
; 906     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 907     pop(de);
	pop de
; 908     CompareHlDe(hl, de);
	call comparehlde
; 909     if (flag_z)
; 910         return;
	ret z
; 911     swap(hl, de);
	ex hl, de
; 912     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 913     MonitorError();
; 914 }
; 915 
; 916 void MonitorError() {
monitorerror:
; 917     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 918     Monitor2();
	jp monitor2
; 919 }
; 920 
; 921 // Функция для пользовательской программы.
; 922 // Загрузить файл с магнитной ленты.
; 923 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 924 
; 925 void ReadTapeFile(...) {
readtapefile:
; 926     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 927     push_pop(hl) {
	push hl
; 928         hl += bc;
	add hl, bc
; 929         swap(hl, de);
	ex hl, de
; 930         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 931     }
; 932     hl += bc;
	add hl, bc
; 933     swap(hl, de);
	ex hl, de
; 934 
; 935     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 936     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 937     if (flag_z)
; 938         return;
	ret z
; 939 
; 940     push_pop(hl) {
	push hl
; 941         ReadTapeBlock();
	call readtapeblock
; 942         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 943     }
; 944 }
; 945 
; 946 void ReadTapeWordNext() {
readtapewordnext:
; 947     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 948 }
; 949 
; 950 void ReadTapeWord(...) {
readtapeword:
; 951     ReadTapeByte(a);
	call readtapebyte
; 952     b = a;
	ld b, a
; 953     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 954     c = a;
	ld c, a
	ret
; 955 }
; 956 
; 957 void ReadTapeBlock(...) {
readtapeblock:
; 958     for (;;) {
l_74:
; 959         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 960         *hl = a;
	ld (hl), a
; 961         Loop();
	call loop
	jp l_74
; 962     }
; 963 }
; 964 
; 965 // Функция для пользовательской программы.
; 966 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 967 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 968 
; 969 void CalculateCheckSum(...) {
calculatechecksum:
; 970     bc = 0;
	ld bc, 0
; 971     for (;;) {
l_77:
; 972         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 973         push_pop(a) {
	push af
; 974             CompareHlDe(hl, de);
	call comparehlde
; 975             if (flag_z)
; 976                 return PopRet();
	jp z, popret
	pop af
; 977         }
; 978         a = b;
	ld a, b
; 979         carry_add(a, *hl);
	adc (hl)
; 980         b = a;
	ld b, a
; 981         Loop();
	call loop
	jp l_77
; 982     }
; 983 }
; 984 
; 985 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 986 // Сохранить блок данных на магнитную ленту
; 987 
; 988 void CmdO(...) {
cmdo:
; 989     if ((a = c) != 0)
	ld a, c
	or a
; 990         tapeWriteSpeed = a;
	jp z, l_79
	ld (tapewritespeed), a
l_79:
; 991     push_pop(hl) {
	push hl
; 992         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 993     }
; 994     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 995     swap(hl, de);
	ex hl, de
; 996     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 997     swap(hl, de);
	ex hl, de
; 998     push_pop(hl) {
	push hl
; 999         h = b;
	ld h, b
; 1000         l = c;
	ld l, c
; 1001         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1002     }
; 1003     WriteTapeFile(hl, de);
; 1004 }
; 1005 
; 1006 // Функция для пользовательской программы.
; 1007 // Запись файла на магнитную ленту.
; 1008 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1009 
; 1010 void WriteTapeFile(...) {
writetapefile:
; 1011     push(bc);
	push bc
; 1012     bc = 0;
	ld bc, 0
; 1013     do {
l_81:
; 1014         WriteTapeByte(c);
	call writetapebyte
; 1015         b--;
	dec b
; 1016         swap(hl, *sp);
	ex (sp), hl
; 1017         swap(hl, *sp);
	ex (sp), hl
l_82:
	jp nz, l_81
; 1018     } while (flag_nz);
; 1019     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1020     WriteTapeWord(hl);
	call writetapeword
; 1021     swap(hl, de);
	ex hl, de
; 1022     WriteTapeWord(hl);
	call writetapeword
; 1023     swap(hl, de);
	ex hl, de
; 1024     WriteTapeBlock(hl, de);
	call writetapeblock
; 1025     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1026     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1027     pop(hl);
	pop hl
; 1028     WriteTapeWord(hl);
	call writetapeword
; 1029     return;
	ret
; 1030 }
; 1031 
; 1032 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1033     push_pop(bc) {
	push bc
; 1034         PrintCrLfTab();
	call printcrlftab
; 1035         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1036     }
; 1037 }
; 1038 
; 1039 void PrintHexWordSpace(...) {
printhexwordspace:
; 1040     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1041     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1042 }
; 1043 
; 1044 void WriteTapeBlock(...) {
writetapeblock:
; 1045     for (;;) {
l_85:
; 1046         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1047         Loop();
	call loop
	jp l_85
; 1048     }
; 1049 }
; 1050 
; 1051 void WriteTapeWord(...) {
writetapeword:
; 1052     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1053     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1054 }
; 1055 
; 1056 // Загрузка байта с магнитной ленты.
; 1057 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1058 // Результат: a = прочитанный байт.
; 1059 
; 1060 void ReadTapeByte(...) {
readtapebyte:
; 1061     push(hl, bc, de);
	push hl
	push bc
	push de
; 1062     d = a;
	ld d, a
; 1063     ReadTapeByteInternal(d);
; 1064 }
; 1065 
; 1066 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1067     c = 0;
	ld c, 0
; 1068     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1069     do {
l_87:
; 1070     retry:  // Сдвиг результата
retry:
; 1071         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1072         cyclic_rotate_left(a, 1);
	rlca
; 1073         c = a;
	ld c, a
; 1074 
; 1075         // Ожидание изменения бита
; 1076         h = 0;
	ld h, 0
; 1077         do {
l_90:
; 1078             h--;
	dec h
; 1079             if (flag_z)
; 1080                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_91:
; 1081         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_90
; 1082 
; 1083         // Сохранение бита
; 1084         c = (a |= c);
	or c
	ld c, a
; 1085 
; 1086         // Задержка
; 1087         d--;
	dec d
; 1088         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1089         if (flag_z)
; 1090             a -= 18;
	jp nz, l_93
	sub 18
l_93:
; 1091         b = a;
	ld b, a
; 1092         do {
l_95:
l_96:
; 1093         } while (flag_nz(b--));
	dec b
	jp nz, l_95
; 1094         d++;
	inc d
; 1095 
; 1096         // Новое значение бита
; 1097         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1098 
; 1099         // Режим поиска синхробайта
; 1100         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_98
; 1101             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_100
; 1102                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_101
l_100:
; 1103             } else {
; 1104                 if (a != ~TAPE_START)
	cp 65305
; 1105                     goto retry;
	jp nz, retry
; 1106                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_101:
; 1107             }
; 1108             d = 8 + 1;
	ld d, 9
l_98:
l_88:
; 1109         }
; 1110     } while (flag_nz(d--));
	dec d
	jp nz, l_87
; 1111     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1112     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1113 }
; 1114 
; 1115 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1116     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1117         return MonitorError();
	jp p, monitorerror
; 1118     CtrlC();
	call ctrlc
; 1119     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1120 }
; 1121 
; 1122 // Функция для пользовательской программы.
; 1123 // Запись байта на магнитную ленту.
; 1124 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1125 
; 1126 void WriteTapeByte(...) {
writetapebyte:
; 1127     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1128         d = 8;
	ld d, 8
; 1129         do {
l_102:
; 1130             // Сдвиг исходного байта
; 1131             a = c;
	ld a, c
; 1132             cyclic_rotate_left(a, 1);
	rlca
; 1133             c = a;
	ld c, a
; 1134 
; 1135             // Вывод
; 1136             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1137             out(PORT_TAPE, a);
	out (1), a
; 1138 
; 1139             // Задержка
; 1140             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1141             do {
l_105:
; 1142                 b--;
	dec b
l_106:
	jp nz, l_105
; 1143             } while (flag_nz);
; 1144 
; 1145             // Вывод
; 1146             (a = 0) ^= c;
	ld a, 0
	xor c
; 1147             out(PORT_TAPE, a);
	out (1), a
; 1148 
; 1149             // Задержка
; 1150             d--;
	dec d
; 1151             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1152             if (flag_z)
; 1153                 a -= 14;
	jp nz, l_108
	sub 14
l_108:
; 1154             b = a;
	ld b, a
; 1155             do {
l_110:
; 1156                 b--;
	dec b
l_111:
	jp nz, l_110
; 1157             } while (flag_nz);
; 1158             d++;
	inc d
l_103:
; 1159         } while (flag_nz(d--));
	dec d
	jp nz, l_102
	pop af
	pop de
	pop bc
	ret
; 1160     }
; 1161 }
; 1162 
; 1163 // Функция для пользовательской программы.
; 1164 // Вывод 8 битного числа на экран.
; 1165 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1166 
; 1167 void PrintHexByte(...) {
printhexbyte:
; 1168     push_pop(a) {
	push af
; 1169         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1170         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1171     }
; 1172     PrintHexNibble(a);
; 1173 }
; 1174 
; 1175 void PrintHexNibble(...) {
printhexnibble:
; 1176     a &= 0x0F;
	and 15
; 1177     if (flag_p(compare(a, 10)))
	cp 10
; 1178         a += 'A' - '0' - 10;
	jp m, l_113
	add 7
l_113:
; 1179     a += '0';
	add 48
; 1180     PrintCharA(a);
; 1181 }
; 1182 
; 1183 // Вывод символа на экран.
; 1184 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1185 
; 1186 void PrintCharA(...) {
printchara:
; 1187     PrintChar(c = a);
	ld c, a
; 1188 }
; 1189 
; 1190 // Функция для пользовательской программы.
; 1191 // Вывод символа на экран.
; 1192 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1193 
; 1194 void PrintChar(...) {
printchar:
; 1195     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1196     IsAnyKeyPressed();
	call isanykeypressed
; 1197     DrawCursor(b = 0);
	ld b, 0
	call drawcursor
; 1198     hl = cursor;
	ld hl, (cursor)
; 1199     a = escState;
	ld a, (escstate)
; 1200     a--;
	dec a
; 1201     if (flag_m)
; 1202         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1203     if (flag_z)
; 1204         return PrintCharEsc();
	jp z, printcharesc
; 1205     a--;
	dec a
; 1206     if (flag_nz)
; 1207         return PrintCharEscY2();
	jp nz, printcharescy2
; 1208 
; 1209     // Первый параметр ESC Y
; 1210     a = c;
	ld a, c
; 1211     a -= ' ';
	sub 32
; 1212     if (flag_m) {
	jp p, l_115
; 1213         a ^= a;
	xor a
	jp l_116
l_115:
; 1214     } else {
; 1215         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 32
; 1216             a = SCREEN_HEIGHT - 1;
	jp m, l_117
	ld a, 31
l_117:
l_116:
; 1217     }
; 1218     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1219     c = a;
	ld c, a
; 1220     b = (a &= 192);
	and 192
	ld b, a
; 1221     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1222     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1223     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1224     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1225 }
; 1226 
; 1227 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1228     escState = a;
	ld (escstate), a
; 1229     PrintCharSaveCursor(hl);
; 1230 }
; 1231 
; 1232 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1233     cursor = hl;
	ld (cursor), hl
; 1234     PrintCharExit();
; 1235 }
; 1236 
; 1237 void PrintCharExit(...) {
printcharexit:
; 1238     DrawCursor(b = 0xFF);
	ld b, 255
	call drawcursor
; 1239     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1240 }
; 1241 
; 1242 void DrawCursor(...) {
drawcursor:
; 1243     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1244         return;
	ret z
; 1245     hl = cursor;
	ld hl, (cursor)
; 1246     hl += (de = -SCREEN_SIZE + 1);
	ld de, 63489
	add hl, de
; 1247     *hl = b;
	ld (hl), b
	ret
; 1248 }
; 1249 
; 1250 void PrintCharEscY2(...) {
printcharescy2:
; 1251     a = c;
	ld a, c
; 1252     a -= ' ';
	sub 32
; 1253     if (flag_m) {
	jp p, l_119
; 1254         a ^= a;
	xor a
	jp l_120
l_119:
; 1255     } else {
; 1256         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1257             a = SCREEN_WIDTH - 1;
	jp m, l_121
	ld a, 63
l_121:
l_120:
; 1258     }
; 1259     b = a;
	ld b, a
; 1260     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1261     PrintCharResetEscState();
; 1262 }
; 1263 
; 1264 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1265     a ^= a;
	xor a
; 1266     return PrintCharSetEscState();
	jp printcharsetescstate
; 1267 }
; 1268 
; 1269 void PrintCharEsc(...) {
printcharesc:
; 1270     a = c;
	ld a, c
; 1271     if (a == 'Y') {
	cp 89
	jp nz, l_123
; 1272         a = 2;
	ld a, 2
; 1273         return PrintCharSetEscState();
	jp printcharsetescstate
l_123:
; 1274     }
; 1275     if (a == 97) {
	cp 97
	jp nz, l_125
; 1276         a ^= a;
	xor a
; 1277         return SetCursorVisible();
	jp setcursorvisible
l_125:
; 1278     }
; 1279     if (a != 98)
	cp 98
; 1280         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1281     SetCursorVisible();
; 1282 }
; 1283 
; 1284 void SetCursorVisible(...) {
setcursorvisible:
; 1285     cursorVisible = a;
	ld (cursorvisible), a
; 1286     return PrintCharResetEscState();
	jp printcharresetescstate
; 1287 }
; 1288 
; 1289 void PrintCharNoEsc(...) {
printcharnoesc:
; 1290     // Остановка вывода нажатием УС + Шифт
; 1291     do {
l_127:
; 1292         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_128:
; 1293     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_127
; 1294 
; 1295     compare(a = 16, c);
	ld a, 16
	cp c
; 1296     a = translateCodeEnabled;
	ld a, (translatecodeenabled)
; 1297     if (flag_z) {
	jp nz, l_130
; 1298         invert(a);
	cpl
; 1299         translateCodeEnabled = a;
	ld (translatecodeenabled), a
; 1300         return PrintCharSaveCursor();
	jp printcharsavecursor
l_130:
; 1301     }
; 1302     if (a != 0)
	or a
; 1303         TranslateCodePage(c);
	call nz, translatecodepage
; 1304     a = c;
	ld a, c
; 1305     if (a == 31)
	cp 31
; 1306         return ClearScreen();
	jp z, clearscreen
; 1307     if (flag_m)
; 1308         return PrintChar3(a);
	jp m, printchar3
; 1309     PrintChar4(a);
; 1310 }
; 1311 
; 1312 void PrintChar4(...) {
printchar4:
; 1313     *hl = a;
	ld (hl), a
; 1314     hl++;
	inc hl
; 1315     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1316         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1317     PrintCrLf();
	call printcrlf
; 1318     PrintCharExit();
	jp printcharexit
; 1319 }
; 1320 
; 1321 void ClearScreen(...) {
clearscreen:
; 1322     b = ' ';
	ld b, 32
; 1323     a = SCREEN_END >> 8;
	ld a, 240
; 1324     hl = SCREEN_ATTRIB_BEGIN;
	ld hl, 57344
; 1325     do {
l_132:
; 1326         *hl = b;
	ld (hl), b
; 1327         hl++;
	inc hl
; 1328         *hl = b;
	ld (hl), b
; 1329         hl++;
	inc hl
l_133:
; 1330     } while (a != h);
	cp h
	jp nz, l_132
; 1331     MoveCursorHome();
; 1332 }
; 1333 
; 1334 void MoveCursorHome(...) {
movecursorhome:
; 1335     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1336 }
; 1337 
; 1338 void PrintChar3(...) {
printchar3:
; 1339     if (a == 12)
	cp 12
; 1340         return MoveCursorHome();
	jp z, movecursorhome
; 1341     if (a == 13)
	cp 13
; 1342         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1343     if (a == 10)
	cp 10
; 1344         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1345     if (a == 8)
	cp 8
; 1346         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1347     if (a == 24)
	cp 24
; 1348         return MoveCursorRight(hl);
	jp z, movecursorright
; 1349     if (a == 25)
	cp 25
; 1350         return MoveCursorUp(hl);
	jp z, movecursorup
; 1351     if (a == 7)
	cp 7
; 1352         return PrintCharBeep();
	jp z, printcharbeep
; 1353     if (a == 26)
	cp 26
; 1354         return MoveCursorDown();
	jp z, movecursordown
; 1355     if (a != 27)
	cp 27
; 1356         return PrintChar4(hl, a);
	jp nz, printchar4
; 1357     a = 1;
	ld a, 1
; 1358     return PrintCharSetEscState();
	jp printcharsetescstate
; 1359 }
; 1360 
; 1361 void PrintCharBeep(...) {
printcharbeep:
; 1362     c = 128;  // Длительность
	ld c, 128
; 1363     e = 32;   // Частота
	ld e, 32
; 1364     do {
l_135:
; 1365         d = e;
	ld d, e
; 1366         do {
l_138:
; 1367             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_139:
; 1368         } while (flag_nz(e--));
	dec e
	jp nz, l_138
; 1369         e = d;
	ld e, d
; 1370         do {
l_141:
; 1371             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_142:
; 1372         } while (flag_nz(d--));
	dec d
	jp nz, l_141
l_136:
; 1373     } while (flag_nz(c--));
	dec c
	jp nz, l_135
; 1374 
; 1375     return PrintCharExit();
	jp printcharexit
; 1376 }
; 1377 
; 1378 void MoveCursorCr(...) {
movecursorcr:
; 1379     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1380     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1381 }
; 1382 
; 1383 void MoveCursorRight(...) {
movecursorright:
; 1384     hl++;
	inc hl
; 1385     MoveCursorBoundary(hl);
; 1386 }
; 1387 
; 1388 void MoveCursorBoundary(...) {
movecursorboundary:
; 1389     a = h;
	ld a, h
; 1390     a &= 7;
	and 7
; 1391     a |= SCREEN_BEGIN >> 8;
	or 232
; 1392     h = a;
	ld h, a
; 1393     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1394 }
; 1395 
; 1396 void MoveCursorLeft(...) {
movecursorleft:
; 1397     hl--;
	dec hl
; 1398     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1399 }
; 1400 
; 1401 void MoveCursorLf(...) {
movecursorlf:
; 1402     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1403     if (flag_m(compare(a = h, SCREEN_END >> 8)))
	ld a, h
	cp 240
; 1404         return PrintCharSaveCursor(hl);
	jp m, printcharsavecursor
; 1405 
; 1406     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1407     bc = (SCREEN_BEGIN + SCREEN_WIDTH);
	ld bc, 59456
; 1408     do {
l_144:
; 1409         *hl = (a = *bc);
	ld a, (bc)
	ld (hl), a
; 1410         hl++;
	inc hl
; 1411         bc++;
	inc bc
; 1412         *hl = (a = *bc);
	ld a, (bc)
	ld (hl), a
; 1413         hl++;
	inc hl
; 1414         bc++;
	inc bc
l_145:
; 1415     } while (flag_m(compare(a = b, SCREEN_END >> 8)));
	ld a, b
	cp 240
	jp m, l_144
; 1416     a = SCREEN_END >> 8;
	ld a, 240
; 1417     c = ' ';
	ld c, 32
; 1418     do {
l_147:
; 1419         *hl = c;
	ld (hl), c
; 1420         hl++;
	inc hl
; 1421         *hl = c;
	ld (hl), c
; 1422         hl++;
	inc hl
l_148:
; 1423     } while (a != h);
	cp h
	jp nz, l_147
; 1424     hl = cursor;
	ld hl, (cursor)
; 1425     h = ((SCREEN_END >> 8) - 1);
	ld h, 239
; 1426     l = ((a = l) |= 192);
	ld a, l
	or 192
	ld l, a
; 1427     return PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1428 }
; 1429 
; 1430 void MoveCursorUp(...) {
movecursorup:
; 1431     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1432 }
; 1433 
; 1434 void MoveCursor(...) {
movecursor:
; 1435     hl += bc;
	add hl, bc
; 1436     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1437 }
; 1438 
; 1439 void MoveCursorDown(...) {
movecursordown:
; 1440     return MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1441 }
; 1442 
; 1443 void PrintCrLf() {
printcrlf:
; 1444     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1445     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1446 }
; 1447 
; 1448 // Функция для пользовательской программы.
; 1449 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1450 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1451 
; 1452 void IsAnyKeyPressed() {
isanykeypressed:
; 1453     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1454     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1455     a &= KEYBOARD_ROW_MASK;
	and 127
; 1456     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_150
; 1457         a ^= a;
	xor a
; 1458         return;
	ret
l_150:
; 1459     }
; 1460     a = 0xFF;
	ld a, 255
	ret
; 1461 }
; 1462 
; 1463 // Функция для пользовательской программы.
; 1464 // Получить код нажатой клавиши на клавиатуре.
; 1465 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1466 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1467 
; 1468 void ReadKey() {
readkey:
; 1469     push_pop(hl) {
	push hl
; 1470         hl = keyDelay;
	ld hl, (keydelay)
; 1471         ReadKeyInternal(hl);
	call readkeyinternal
; 1472         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1473         if (flag_nz) {  // Не таймаут
	jp z, l_152
; 1474             do {
l_154:
; 1475                 do {
l_157:
; 1476                     l = 2;
	ld l, 2
; 1477                     ReadKeyInternal(hl);
	call readkeyinternal
l_158:
	jp nz, l_157
l_155:
; 1478                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1479             } while (a >= 128);     // Цикл длится, пока не нажата клавиша
	cp 128
	jp nc, l_154
; 1480             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_152:
; 1481         }
; 1482         keyDelay = hl;
	ld (keydelay), hl
	pop hl
	ret
; 1483     }
; 1484 }
; 1485 
; 1486 void ReadKeyInternal(...) {
readkeyinternal:
; 1487     do {
l_160:
; 1488         ScanKey();
	call scankey
; 1489         if (a != h)
	cp h
; 1490             break;
	jp nz, l_162
; 1491 
; 1492         // Задержка
; 1493         push_pop(a) {
	push af
; 1494             a ^= a;
	xor a
; 1495             do {
l_163:
; 1496                 swap(hl, de);
	ex hl, de
; 1497                 swap(hl, de);
	ex hl, de
l_164:
; 1498             } while (flag_nz(a--));
	dec a
	jp nz, l_163
	pop af
l_161:
; 1499         }
; 1500     } while (flag_nz(l--));
	dec l
	jp nz, l_160
l_162:
; 1501     h = a;
	ld h, a
	ret
; 1502 }
; 1503 
; 1504 // Функция для пользовательской программы.
; 1505 // Получить код нажатой клавиши на клавиатуре.
; 1506 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1507 
; 1508 void ScanKey() {
scankey:
; 1509     push(bc, de, hl);
	push bc
	push de
	push hl
; 1510 
; 1511     bc = 0x00FE;
	ld bc, 254
; 1512     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1513     do {
l_166:
; 1514         a = c;
	ld a, c
; 1515         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1516         cyclic_rotate_left(a, 1);
	rlca
; 1517         c = a;
	ld c, a
; 1518         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1519         a &= KEYBOARD_ROW_MASK;
	and 127
; 1520         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1521             return ScanKey2(a);
	jp nz, scankey2
; 1522         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_167:
; 1523     } while (flag_nz(d--));
	dec d
	jp nz, l_166
; 1524 
; 1525     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1526     carry_rotate_right(a, 1);
	rra
; 1527     a = 0xFF;  // No key
	ld a, 255
; 1528     if (flag_c)
; 1529         return ScanKeyExit(a);
	jp c, scankeyexit
; 1530     a--;  // Rus key
	dec a
; 1531     return ScanKeyExit(a);
	jp scankeyexit
; 1532 }
; 1533 
; 1534 void ScanKey2(...) {
scankey2:
; 1535     for (;;) {
l_170:
; 1536         carry_rotate_right(a, 1);
	rra
; 1537         if (flag_nc)
; 1538             break;
	jp nc, l_171
; 1539         b++;
	inc b
	jp l_170
l_171:
; 1540     }
; 1541     a = b;
	ld a, b
; 1542     if (a >= 48)
	cp 48
; 1543         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1544     a += 48;
	add 48
; 1545     if (a >= 60)
	cp 60
; 1546         if (a < 64)
	jp c, l_172
	cp 64
; 1547             a &= 47;
	jp nc, l_174
	and 47
l_174:
l_172:
; 1548 
; 1549     if (a == 95)
	cp 95
; 1550         a = 127;
	jp nz, l_176
	ld a, 127
l_176:
; 1551 
; 1552     c = a;
	ld c, a
; 1553     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1554     a &= KEYBOARD_MODS_MASK;
	and 7
; 1555     compare(a, KEYBOARD_MODS_MASK);
	cp 7
; 1556     b = a;
	ld b, a
; 1557     a = c;
	ld a, c
; 1558     if (flag_z)
; 1559         return ScanKeyExit(a);
	jp z, scankeyexit
; 1560     a = b;
	ld a, b
; 1561     carry_rotate_right(a, 2);
	rra
	rra
; 1562     if (flag_nc)
; 1563         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1564     carry_rotate_right(a, 1);
	rra
; 1565     if (flag_nc)
; 1566         return ScanKeyShift();
	jp nc, scankeyshift
; 1567     (a = c) |= 0x20;
	ld a, c
	or 32
; 1568     ScanKeyExit(a);
; 1569 }
; 1570 
; 1571 void ScanKeyExit(...) {
scankeyexit:
; 1572     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1573 }
; 1574 
; 1575 void ScanKeyControl(...) {
scankeycontrol:
; 1576     a = c;
	ld a, c
; 1577     a &= 0x1F;
	and 31
; 1578     return ScanKeyExit(a);
	jp scankeyexit
; 1579 }
; 1580 
; 1581 void ScanKeyShift(...) {
scankeyshift:
; 1582     if ((a = c) == 127)
	ld a, c
	cp 127
; 1583         a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1584     if (a >= 64)
	cp 64
; 1585         return ScanKeyExit();
	jp nc, scankeyexit
; 1586     if (a < 48) {
	cp 48
	jp nc, l_180
; 1587         a |= 16;
	or 16
; 1588         return ScanKeyExit();
	jp scankeyexit
l_180:
; 1589     }
; 1590     a &= 47;
	and 47
; 1591     return ScanKeyExit();
	jp scankeyexit
; 1592 }
; 1593 
; 1594 void ScanKeySpecial(...) {
scankeyspecial:
; 1595     hl = specialKeyTable;
	ld hl, 0FFFFh & (specialkeytable)
; 1596     c = (a -= 48);
	sub 48
	ld c, a
; 1597     b = 0;
	ld b, 0
; 1598     hl += bc;
	add hl, bc
; 1599     a = *hl;
	ld a, (hl)
; 1600     return ScanKeyExit(a);
	jp scankeyexit
; 1601 }
; 1602 
; 1603 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1614  aPrompt[6] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1615  aCrLfTab[6] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1616  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1617  aBackspace[4] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1618  aHello[] = "\x1F\nm/80k ";
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
; 1620  TranslateCodePageDefault(...) {
translatecodepagedefault:
	ret
; 1621 }
; 1622 
; 1623 uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
