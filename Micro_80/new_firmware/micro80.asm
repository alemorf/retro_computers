    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst30opcode equ 48
rst30address equ 49
rst38opcode equ 56
rst38address equ 57
keycode equ 63319
keymode equ 63320
color equ 63321
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
ramtop equ 63361
inputbuffer equ 63363
jmpparam1 equ 63348
translatecodepage equ 63358
 .org 0xF800
; 58  uint8_t rst30Opcode __address(0x30);
; 59 extern uint16_t rst30Address __address(0x31);
; 60 extern uint8_t rst38Opcode __address(0x38);
; 61 extern uint16_t rst38Address __address(0x39);
; 62 
; 63 // Прототипы
; 64 void Reboot(...);
; 65 void EntryF86C_Monitor(...);
; 66 void Monitor(...);
; 67 void Monitor2();
; 68 void ReadStringBackspace(...);
; 69 void ReadString(...);
; 70 void ReadStringBegin(...);
; 71 void ReadStringLoop(...);
; 72 void ReadStringExit(...);
; 73 void PrintString(...);
; 74 void ParseParams(...);
; 75 void ParseWord(...);
; 76 void ParseWordReturnCf(...);
; 77 void CompareHlDe(...);
; 78 void LoopWithBreak(...);
; 79 void Loop(...);
; 80 void PopRet();
; 81 void IncHl(...);
; 82 void CtrlC(...);
; 83 void PrintCrLfTab();
; 84 void PrintHexByteFromHlSpace(...);
; 85 void PrintHexByteSpace(...);
; 86 #ifdef CMD_R_ENABLED
; 87 void CmdR(...);
; 88 #endif
; 89 void GetRamTop(...);
; 90 void SetRamTop(...);
; 91 #ifdef CMD_A_ENABLED
; 92 void CmdA(...);
; 93 #endif
; 94 void CmdD(...);
; 95 void PrintSpacesTo(...);
; 96 void PrintSpace();
; 97 void CmdC(...);
; 98 void CmdF(...);
; 99 void CmdS(...);
; 100 void CmdW(...);
; 101 void CmdT(...);
; 102 void CmdM(...);
; 103 void CmdG(...);
; 104 void BreakPointHandler(...);
; 105 void CmdX(...);
; 106 void GetCursor();
; 107 void GetCursorChar();
; 108 void CmdH(...);
; 109 void CmdI(...);
; 110 void MonitorError();
; 111 void ReadTapeFile(...);
; 112 void ReadTapeWordNext();
; 113 void ReadTapeWord(...);
; 114 void ReadTapeBlock(...);
; 115 void CalculateCheckSum(...);
; 116 void CmdO(...);
; 117 void WriteTapeFile(...);
; 118 void PrintCrLfTabHexWordSpace(...);
; 119 void PrintHexWordSpace(...);
; 120 void WriteTapeBlock(...);
; 121 void WriteTapeWord(...);
; 122 void ReadTapeByte(...);
; 123 void ReadTapeByteInternal(...);
; 124 void ReadTapeByteTimeout(...);
; 125 void WriteTapeByte(...);
; 126 void PrintHexByte(...);
; 127 void PrintHexNibble(...);
; 128 void PrintCharA(...);
; 129 void PrintChar(...);
; 130 void PrintCharSetEscState(...);
; 131 void PrintCharSaveCursor(...);
; 132 void PrintCharExit(...);
; 133 void DrawCursor(...);
; 134 void PrintCharEscY2(...);
; 135 void PrintCharResetEscState(...);
; 136 void PrintCharEsc(...);
; 137 void SetCursorVisible(...);
; 138 void PrintCharNoEsc(...);
; 139 void PrintChar4(...);
; 140 void ClearScreen(...);
; 141 void MoveCursorHome(...);
; 142 void PrintChar3(...);
; 143 void PrintCharBeep(...);
; 144 void MoveCursorCr(...);
; 145 void MoveCursorRight(...);
; 146 void MoveCursorBoundary(...);
; 147 void MoveCursorLeft(...);
; 148 void MoveCursorLf(...);
; 149 void MoveCursorUp(...);
; 150 void MoveCursor(...);
; 151 void MoveCursorDown(...);
; 152 void PrintCrLf();
; 153 void IsAnyKeyPressed();
; 154 void ReadKey();
; 155 void ReadKeyInternal(...);
; 156 void ScanKey();
; 157 void ScanKey2(...);
; 158 void ScanKeyExit(...);
; 159 #ifdef CMD_A_ENABLED
; 160 void TranslateCodePageDefault(...);
; 161 #endif
; 162 void PrintKeyStatus1(...);
; 163 void PrintKeyStatus();
; 164 
; 165 // Переменные Монитора
; 166 
; 167 extern uint8_t keyCode __address(0xF757);
; 168 extern uint8_t keyMode __address(0xF758);
; 169 extern uint8_t color __address(0xF759);
; 170 extern uint16_t cursor __address(0xF75A);
; 171 extern uint8_t tapeReadSpeed __address(0xF75C);
; 172 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 173 extern uint8_t cursorVisible __address(0xF75E);
; 174 extern uint8_t escState __address(0xF75F);
; 175 extern uint16_t keyDelay __address(0xF760);
; 176 extern uint16_t regPC __address(0xF762);
; 177 extern uint16_t regHL __address(0xF764);
; 178 extern uint16_t regBC __address(0xF766);
; 179 extern uint16_t regDE __address(0xF768);
; 180 extern uint16_t regSP __address(0xF76A);
; 181 extern uint16_t regAF __address(0xF76C);
; 182 extern uint16_t breakPointAddress __address(0xF771);
; 183 extern uint8_t breakPointValue __address(0xF773);
; 184 extern uint8_t jmpParam1Opcode __address(0xF774);
; 185 extern uint16_t param1 __address(0xF775);
; 186 extern uint16_t param2 __address(0xF777);
; 187 extern uint16_t param3 __address(0xF779);
; 188 extern uint8_t param2Exists __address(0xF77B);
; 189 extern uint8_t tapePolarity __address(0xF77C);
; 190 #ifdef CMD_A_ENABLED
; 191 extern uint8_t translateCodeEnabled __address(0xF77D);
; 192 extern uint8_t translateCodePageJump __address(0xF77E);
; 193 extern uint16_t translateCodePageAddress __address(0xF77F);
; 194 #endif
; 195 extern uint16_t ramTop __address(0xF781);
; 196 extern uint8_t inputBuffer[32] __address(0xF783);
; 197 
; 198 #define firstVariableAddress (&keyMode)
; 199 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 200 
; 201 extern uint8_t specialKeyTable[8];
; 202 extern uint8_t aPrompt[8];
; 203 extern uint8_t aCrLfTab[6];
; 204 extern uint8_t aRegisters[37];
; 205 extern uint8_t aBackspace[4];
; 206 extern uint8_t aHello[9];
; 207 
; 208 // Для удобства
; 209 
; 210 void JmpParam1() __address(0xF774);
; 211 void TranslateCodePage() __address(0xF77E);
; 212 
; 213 // Точки входа
; 214 
; 215 void EntryF800_Reboot() {
entryf800_reboot:
; 216     Reboot();
	jp reboot
; 217 }
; 218 
; 219 void EntryF803_ReadKey() {
entryf803_readkey:
; 220     ReadKey();
	jp readkey
; 221 }
; 222 
; 223 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 224     ReadTapeByte(a);
	jp readtapebyte
; 225 }
; 226 
; 227 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 228     PrintChar(c);
	jp printchar
; 229 }
; 230 
; 231 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 232     WriteTapeByte(c);
	jp writetapebyte
; 233 }
; 234 
; 235 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 236 #ifdef CMD_A_ENABLED
; 237     TranslateCodePage(c);
; 238 #else
; 239     return;
	ret
; 240     return;
	ret
; 241     return;
	ret
; 242 #endif
; 243 }
; 244 
; 245 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 246     IsAnyKeyPressed();
	jp isanykeypressed
; 247 }
; 248 
; 249 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 250     PrintHexByte(a);
	jp printhexbyte
; 251 }
; 252 
; 253 void EntryF818_PrintString(...) {
entryf818_printstring:
; 254     PrintString(hl);
	jp printstring
; 255 }
; 256 
; 257 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 258     ScanKey();
	jp scankey
; 259 }
; 260 
; 261 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 262     GetCursor();
	jp getcursor
; 263 }
; 264 
; 265 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 266     GetCursorChar();
	jp getcursorchar
; 267 }
; 268 
; 269 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 270     ReadTapeFile(hl);
	jp readtapefile
; 271 }
; 272 
; 273 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 274     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 275 }
; 276 
; 277 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 278     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 279 }
; 280 
; 281 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 282     return;
	ret
; 283     return;
	ret
; 284     return;
	ret
; 285 }
; 286 
; 287 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 288     GetRamTop();
	jp getramtop
; 289 }
; 290 
; 291 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 292     SetRamTop(hl);
	jp setramtop
; 293 }
; 294 
; 295 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 296 // Параметры: нет. Функция никогда не завершается.
; 297 
; 298 void Reboot(...) {
reboot:
; 299     sp = STACK_TOP;
	ld sp, 63488
; 300 
; 301     // Очистка памяти
; 302     hl = firstVariableAddress;
	ld hl, 0FFFFh & (keymode)
; 303     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 304     c = 0;
	ld c, 0
; 305     CmdF();
	call cmdf
; 306 
; 307 #ifdef CMD_A_ENABLED
; 308     translateCodePageJump = a = OPCODE_JMP;
; 309 #endif
; 310     ramTop = hl = SCREEN_ATTRIB_BEGIN - 1;
	ld hl, 57343
	ld (ramtop), hl
; 311     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 312 #ifdef CMD_A_ENABLED
; 313     translateCodePageAddress = hl = &TranslateCodePageDefault;
; 314 #endif
; 315     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 316     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 39
	ld (color), a
; 317 
; 318     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 319 
; 320     EntryF86C_Monitor();
	jp entryf86c_monitor
 .org 0xF86C
; 321 }
; 322 
; 323 asm(" .org 0xF86C");
; 324 
; 325 void EntryF86C_Monitor() {
entryf86c_monitor:
; 326     Monitor();
; 327 }
; 328 
; 329 void Monitor() {
monitor:
; 330     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
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
; 338     color = a = SCREEN_ATTRIB_INPUT;
	ld a, 35
	ld (color), a
; 339     ReadString();
	call readstring
; 340     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 39
	ld (color), a
; 341 
; 342     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 343 
; 344     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 345     a = *hl;
	ld a, (hl)
; 346 
; 347     if (a == 'X')
	cp 88
; 348         return CmdX();
	jp z, cmdx
; 349 
; 350     push_pop(a) {
	push af
; 351         ParseParams();
	call parseparams
; 352         hl = param3;
	ld hl, (param3)
; 353         c = l;
	ld c, l
; 354         b = h;
	ld b, h
; 355         hl = param2;
	ld hl, (param2)
; 356         swap(hl, de);
	ex hl, de
; 357         hl = param1;
	ld hl, (param1)
	pop af
; 358     }
; 359 
; 360     if (a == 'D')
	cp 68
; 361         return CmdD();
	jp z, cmdd
; 362     if (a == 'C')
	cp 67
; 363         return CmdC();
	jp z, cmdc
; 364     if (a == 'F')
	cp 70
; 365         return CmdF();
	jp z, cmdf
; 366     if (a == 'S')
	cp 83
; 367         return CmdS();
	jp z, cmds
; 368     if (a == 'T')
	cp 84
; 369         return CmdT();
	jp z, cmdt
; 370     if (a == 'M')
	cp 77
; 371         return CmdM();
	jp z, cmdm
; 372     if (a == 'G')
	cp 71
; 373         return CmdG();
	jp z, cmdg
; 374     if (a == 'I')
	cp 73
; 375         return CmdI();
	jp z, cmdi
; 376     if (a == 'O')
	cp 79
; 377         return CmdO();
	jp z, cmdo
; 378     if (a == 'W')
	cp 87
; 379         return CmdW();
	jp z, cmdw
; 380 #ifdef CMD_A_ENABLED
; 381     if (a == 'A')
; 382         return CmdA();
; 383 #endif
; 384     if (a == 'H')
	cp 72
; 385         return CmdH();
	jp z, cmdh
; 386 #ifdef CMD_R_ENABLED
; 387     if (a == 'R')
; 388         return CmdR();
; 389 #endif
; 390     return MonitorError();
	jp monitorerror
; 391 }
; 392 
; 393 void ReadStringBackspace(...) {
readstringbackspace:
; 394     if ((a = inputBuffer) == l)
	ld a, 0FFh & (inputbuffer)
	cp l
; 395         return ReadStringBegin(hl);
	jp z, readstringbegin
; 396     push_pop(hl) {
	push hl
; 397         PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 398     }
; 399     hl--;
	dec hl
; 400     return ReadStringLoop(b, hl);
	jp readstringloop
; 401 }
; 402 
; 403 void ReadString() {
readstring:
; 404     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 405     ReadStringBegin(hl);
; 406 }
; 407 
; 408 void ReadStringBegin(...) {
readstringbegin:
; 409     b = 0;
	ld b, 0
; 410     ReadStringLoop(b, hl);
; 411 }
; 412 
; 413 void ReadStringLoop(...) {
readstringloop:
; 414     for (;;) {
l_1:
; 415         ReadKey();
	call readkey
; 416         if (a == 127)
	cp 127
; 417             return ReadStringBackspace();
	jp z, readstringbackspace
; 418         if (a == 8)
	cp 8
; 419             return ReadStringBackspace();
	jp z, readstringbackspace
; 420         if (flag_nz)
; 421             PrintCharA(a);
	call nz, printchara
; 422         *hl = a;
	ld (hl), a
; 423         if (a == 13)
	cp 13
; 424             return ReadStringExit(b);
	jp z, readstringexit
; 425         if (a == '.')
	cp 46
; 426             return Monitor2();
	jp z, monitor2
; 427         b = 255;
	ld b, 255
; 428         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 429             return MonitorError();
	jp z, monitorerror
; 430         hl++;
	inc hl
	jp l_1
; 431     }
; 432 }
; 433 
; 434 void ReadStringExit(...) {
readstringexit:
; 435     a = b;
	ld a, b
; 436     carry_rotate_left(a, 1);
	rla
; 437     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 438     b = 0;
	ld b, 0
	ret
; 439 }
; 440 
; 441 // Функция для пользовательской программы.
; 442 // Вывод строки на экран.
; 443 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 444 
; 445 void PrintString(...) {
printstring:
; 446     for (;;) {
l_4:
; 447         a = *hl;
	ld a, (hl)
; 448         if (flag_z(a &= a))
	and a
; 449             return;
	ret z
; 450         PrintCharA(a);
	call printchara
; 451         hl++;
	inc hl
	jp l_4
; 452     }
; 453 }
; 454 
; 455 void ParseParams(...) {
parseparams:
; 456     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 457     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 458     c = 0;
	ld c, 0
; 459     CmdF();
	call cmdf
; 460 
; 461     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 462 
; 463     ParseWord();
	call parseword
; 464     param1 = hl;
	ld (param1), hl
; 465     param2 = hl;
	ld (param2), hl
; 466     if (flag_c)
; 467         return;
	ret c
; 468 
; 469     param2Exists = a = 0xFF;
	ld a, 255
	ld (param2exists), a
; 470     ParseWord();
	call parseword
; 471     param2 = hl;
	ld (param2), hl
; 472     if (flag_c)
; 473         return;
	ret c
; 474 
; 475     ParseWord();
	call parseword
; 476     param3 = hl;
	ld (param3), hl
; 477     if (flag_c)
; 478         return;
	ret c
; 479 
; 480     MonitorError();
	jp monitorerror
; 481 }
; 482 
; 483 void ParseWord(...) {
parseword:
; 484     hl = 0;
	ld hl, 0
; 485     for (;;) {
l_7:
; 486         a = *de;
	ld a, (de)
; 487         de++;
	inc de
; 488         if (a == 13)
	cp 13
; 489             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 490         if (a == ',')
	cp 44
; 491             return;
	ret z
; 492         if (a == ' ')
	cp 32
; 493             continue;
	jp z, l_7
; 494         a -= '0';
	sub 48
; 495         if (flag_m)
; 496             return MonitorError();
	jp m, monitorerror
; 497         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_9
; 498             if (flag_m(compare(a, 17)))
	cp 17
; 499                 return MonitorError();
	jp m, monitorerror
; 500             if (flag_p(compare(a, 23)))
	cp 23
; 501                 return MonitorError();
	jp p, monitorerror
; 502             a -= 7;
	sub 7
l_9:
; 503         }
; 504         c = a;
	ld c, a
; 505         hl += hl;
	add hl, hl
; 506         hl += hl;
	add hl, hl
; 507         hl += hl;
	add hl, hl
; 508         hl += hl;
	add hl, hl
; 509         if (flag_c)
; 510             return MonitorError();
	jp c, monitorerror
; 511         hl += bc;
	add hl, bc
	jp l_7
; 512     }
; 513 }
; 514 
; 515 void ParseWordReturnCf(...) {
parsewordreturncf:
; 516     set_flag_c();
	scf
	ret
; 517 }
; 518 
; 519 void CompareHlDe(...) {
comparehlde:
; 520     if ((a = h) != d)
	ld a, h
	cp d
; 521         return;
	ret nz
; 522     compare(a = l, e);
	ld a, l
	cp e
	ret
; 523 }
; 524 
; 525 void LoopWithBreak(...) {
loopwithbreak:
; 526     CtrlC();
	call ctrlc
; 527     Loop(hl, de);
; 528 }
; 529 
; 530 void Loop(...) {
loop:
; 531     CompareHlDe(hl, de);
	call comparehlde
; 532     if (flag_nz)
; 533         return IncHl(hl);
	jp nz, inchl
; 534     PopRet();
; 535 }
; 536 
; 537 void PopRet() {
popret:
; 538     sp++;
	inc sp
; 539     sp++;
	inc sp
	ret
; 540 }
; 541 
; 542 void IncHl(...) {
inchl:
; 543     hl++;
	inc hl
	ret
; 544 }
; 545 
; 546 void CtrlC() {
ctrlc:
; 547     ScanKey();
	call scankey
; 548     if (a != 3)  // УПР + C
	cp 3
; 549         return;
	ret nz
; 550     MonitorError();
	jp monitorerror
; 551 }
; 552 
; 553 void PrintCrLfTab() {
printcrlftab:
; 554     push_pop(hl) {
	push hl
; 555         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 556     }
; 557 }
; 558 
; 559 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 560     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 561 }
; 562 
; 563 void PrintHexByteSpace(...) {
printhexbytespace:
; 564     push_pop(bc) {
	push bc
; 565         PrintHexByte(a);
	call printhexbyte
; 566         PrintSpace();
	call printspace
	pop bc
	ret
; 567     }
; 568 }
; 569 
; 570 #ifdef CMD_R_ENABLED
; 571 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 572 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 573 
; 574 void CmdR(...) {
; 575     out(PORT_EXT_MODE, a = 0x90);
; 576     for (;;) {
; 577         out(PORT_EXT_ADDR_LOW, a = l);
; 578         out(PORT_EXT_ADDR_HIGH, a = h);
; 579         *bc = a = in(PORT_EXT_DATA);
; 580         bc++;
; 581         Loop();
; 582     }
; 583 }
; 584 #endif
; 585 
; 586 // Функция для пользовательской программы.
; 587 // Получить адрес последнего доступного байта оперативной памяти.
; 588 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 589 
; 590 void GetRamTop(...) {
getramtop:
; 591     hl = ramTop;
	ld hl, (ramtop)
	ret
; 592 }
; 593 
; 594 // Функция для пользовательской программы.
; 595 // Установить адрес последнего доступного байта оперативной памяти.
; 596 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 597 
; 598 void SetRamTop(...) {
setramtop:
; 599     ramTop = hl;
	ld (ramtop), hl
	ret
; 600 }
; 601 
; 602 #ifdef CMD_A_ENABLED
; 603 // Команда A <адрес>
; 604 // Установить программу преобразования кодировки символов выводимых на экран
; 605 
; 606 void CmdA(...) {
; 607     translateCodePageAddress = hl;
; 608 }
; 609 #endif
; 610 
; 611 // Команда D <начальный адрес> <конечный адрес>
; 612 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 613 
; 614 void CmdD(...) {
cmdd:
; 615     for (;;) {
l_12:
; 616         PrintCrLf();
	call printcrlf
; 617         PrintHexWordSpace(hl);
	call printhexwordspace
; 618         push_pop(hl) {
	push hl
; 619             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 620             carry_rotate_right(a, 1);
	rra
; 621             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 622             PrintSpacesTo();
	call printspacesto
; 623             do {
l_14:
; 624                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 625                 CompareHlDe(hl, de);
	call comparehlde
; 626                 hl++;
	inc hl
; 627                 if (flag_z)
; 628                     break;
	jp z, l_16
; 629                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 630                 push_pop(a) {
	push af
; 631                     a &= 1;
	and 1
; 632                     if (flag_z)
; 633                         PrintSpace();
	call z, printspace
	pop af
l_15:
	jp nz, l_14
l_16:
	pop hl
; 634                 }
; 635             } while (flag_nz);
; 636         }
; 637 
; 638         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 639         PrintSpacesTo(b);
	call printspacesto
; 640 
; 641         do {
l_17:
; 642             a = *hl;
	ld a, (hl)
; 643             if (a < 32)
	cp 32
; 644                 a = '.';
	jp nc, l_20
	ld a, 46
l_20:
; 645             PrintCharA(a);
	call printchara
; 646             CompareHlDe(hl, de);
	call comparehlde
; 647             if (flag_z)
; 648                 return;
	ret z
; 649             hl++;
	inc hl
; 650             (a = l) &= 0x0F;
	ld a, l
	and 15
l_18:
	jp nz, l_17
	jp l_12
; 651         } while (flag_nz);
; 652     }
; 653 }
; 654 
; 655 void PrintSpacesTo(...) {
printspacesto:
; 656     for (;;) {
l_23:
; 657         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 658             return;
	ret nc
; 659         PrintSpace();
	call printspace
	jp l_23
; 660     }
; 661 }
; 662 
; 663 void PrintSpace() {
printspace:
; 664     return PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 665 }
; 666 
; 667 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 668 // Сравнить два блока адресного пространство
; 669 
; 670 void CmdC(...) {
cmdc:
; 671     for (;;) {
l_26:
; 672         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_28
; 673             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 674             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 675             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_28:
; 676         }
; 677         bc++;
	inc bc
; 678         LoopWithBreak();
	call loopwithbreak
	jp l_26
; 679     }
; 680 }
; 681 
; 682 // Команда F <начальный адрес> <конечный адрес> <байт>
; 683 // Заполнить блок в адресном пространстве одним байтом
; 684 
; 685 void CmdF(...) {
cmdf:
; 686     for (;;) {
l_31:
; 687         *hl = c;
	ld (hl), c
; 688         Loop();
	call loop
	jp l_31
; 689     }
; 690 }
; 691 
; 692 // Команда S <начальный адрес> <конечный адрес> <байт>
; 693 // Найти байт (8 битное значение) в адресном пространстве
; 694 
; 695 void CmdS(...) {
cmds:
; 696     for (;;) {
l_34:
; 697         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 698             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 699         LoopWithBreak();
	call loopwithbreak
	jp l_34
; 700     }
; 701 }
; 702 
; 703 // Команда W <начальный адрес> <конечный адрес> <слово>
; 704 // Найти слово (16 битное значение) в адресном пространстве
; 705 
; 706 void CmdW(...) {
cmdw:
; 707     for (;;) {
l_37:
; 708         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_39
; 709             hl++;
	inc hl
; 710             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 711             hl--;
	dec hl
; 712             if (flag_z)
; 713                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_39:
; 714         }
; 715         LoopWithBreak();
	call loopwithbreak
	jp l_37
; 716     }
; 717 }
; 718 
; 719 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 720 // Копировать блок в адресном пространстве
; 721 
; 722 void CmdT(...) {
cmdt:
; 723     for (;;) {
l_42:
; 724         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 725         bc++;
	inc bc
; 726         Loop();
	call loop
	jp l_42
; 727     }
; 728 }
; 729 
; 730 // Команда M <начальный адрес>
; 731 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 732 
; 733 void CmdM(...) {
cmdm:
; 734     for (;;) {
l_45:
; 735         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 736         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 737         push_pop(hl) {
	push hl
; 738             ReadString();
	call readstring
	pop hl
; 739         }
; 740         if (flag_c) {
	jp nc, l_47
; 741             push_pop(hl) {
	push hl
; 742                 ParseWord();
	call parseword
; 743                 a = l;
	ld a, l
	pop hl
; 744             }
; 745             *hl = a;
	ld (hl), a
l_47:
; 746         }
; 747         hl++;
	inc hl
	jp l_45
; 748     }
; 749 }
; 750 
; 751 // Команда G <начальный адрес> <конечный адрес>
; 752 // Запуск программы и возможным указанием точки останова.
; 753 
; 754 void CmdG(...) {
cmdg:
; 755     CompareHlDe(hl, de);
	call comparehlde
; 756     if (flag_nz) {
	jp z, l_49
; 757         swap(hl, de);
	ex hl, de
; 758         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 759         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 760         *hl = OPCODE_RST_30;
	ld (hl), 247
; 761         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 762         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_49:
; 763     }
; 764     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 765     pop(bc);
	pop bc
; 766     pop(de);
	pop de
; 767     pop(hl);
	pop hl
; 768     pop(a);
	pop af
; 769     sp = hl;
	ld sp, hl
; 770     hl = regHL;
	ld hl, (reghl)
; 771     return JmpParam1();
	jp jmpparam1
; 772 }
; 773 
; 774 void BreakPointHandler(...) {
breakpointhandler:
; 775     regHL = hl;
	ld (reghl), hl
; 776     push(a);
	push af
; 777     pop(hl);
	pop hl
; 778     regAF = hl;
	ld (regaf), hl
; 779     pop(hl);
	pop hl
; 780     hl--;
	dec hl
; 781     regPC = hl;
	ld (regpc), hl
; 782     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 783     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 784     push(hl);
	push hl
; 785     push(de);
	push de
; 786     push(bc);
	push bc
; 787     sp = STACK_TOP;
	ld sp, 63488
; 788     hl = regPC;
	ld hl, (regpc)
; 789     swap(hl, de);
	ex hl, de
; 790     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 791     CompareHlDe(hl, de);
	call comparehlde
; 792     if (flag_nz)
; 793         return CmdX();
	jp nz, cmdx
; 794     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 795     CmdX();
; 796 }
; 797 
; 798 // Команда X
; 799 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 800 
; 801 void CmdX(...) {
cmdx:
; 802     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 803     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 804     b = 6;
	ld b, 6
; 805     do {
l_51:
; 806         e = *hl;
	ld e, (hl)
; 807         hl++;
	inc hl
; 808         d = *hl;
	ld d, (hl)
; 809         push(bc);
	push bc
; 810         push(hl);
	push hl
; 811         swap(hl, de);
	ex hl, de
; 812         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 813         ReadString();
	call readstring
; 814         if (flag_c) {
	jp nc, l_54
; 815             ParseWord();
	call parseword
; 816             pop(de);
	pop de
; 817             push(de);
	push de
; 818             swap(hl, de);
	ex hl, de
; 819             *hl = d;
	ld (hl), d
; 820             hl--;
	dec hl
; 821             *hl = e;
	ld (hl), e
l_54:
; 822         }
; 823         pop(hl);
	pop hl
; 824         pop(bc);
	pop bc
; 825         b--;
	dec b
; 826         hl++;
	inc hl
l_52:
	jp nz, l_51
; 827     } while (flag_nz);
; 828     EntryF86C_Monitor();
	jp entryf86c_monitor
; 829 }
; 830 
; 831 // Функция для пользовательской программы.
; 832 // Получить координаты курсора.
; 833 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 834 
; 835 void GetCursor() {
getcursor:
; 836     push_pop(a) {
	push af
; 837         hl = cursor;
	ld hl, (cursor)
; 838         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 839 
; 840         // Вычисление X
; 841         a = l;
	ld a, l
; 842         a &= (SCREEN_WIDTH - 1);
	and 63
; 843         a += 8;  // Смещение Радио 86РК
	add 8
; 844 
; 845         // Вычисление Y
; 846         hl += hl;
	add hl, hl
; 847         hl += hl;
	add hl, hl
; 848         h++;  // Смещение Радио 86РК
	inc h
; 849         h++;
	inc h
; 850         h++;
	inc h
; 851 
; 852         l = a;
	ld l, a
	pop af
	ret
; 853     }
; 854 }
; 855 
; 856 // Функция для пользовательской программы.
; 857 // Получить символ под курсором.
; 858 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 859 
; 860 void GetCursorChar() {
getcursorchar:
; 861     push_pop(hl) {
	push hl
; 862         hl = cursor;
	ld hl, (cursor)
; 863         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 864     }
; 865 }
; 866 
; 867 // Команда H
; 868 // Определить скорости записанной программы.
; 869 // Выводит 4 цифры на экран.
; 870 // Первые две цифры - константа вывода для команды O
; 871 // Последние две цифры - константа вввода для команды I
; 872 
; 873 void CmdH(...) {
cmdh:
; 874     PrintCrLfTab();
	call printcrlftab
; 875     hl = 65408;
	ld hl, 65408
; 876     b = 123;
	ld b, 123
; 877 
; 878     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 879 
; 880     do {
l_56:
l_57:
; 881     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_56
; 882 
; 883     do {
l_59:
; 884         c = a;
	ld c, a
; 885         do {
l_62:
; 886             hl++;
	inc hl
l_63:
; 887         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_62
l_60:
; 888     } while (flag_nz(b--));
	dec b
	jp nz, l_59
; 889 
; 890     hl += hl;
	add hl, hl
; 891     a = h;
	ld a, h
; 892     hl += hl;
	add hl, hl
; 893     l = (a += h);
	add h
	ld l, a
; 894 
; 895     PrintHexWordSpace();
	jp printhexwordspace
; 896 }
; 897 
; 898 // Команда I <смещение> <скорость>
; 899 // Загрузить файл с магнитной ленты
; 900 
; 901 void CmdI(...) {
cmdi:
; 902     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 903         tapeReadSpeed = a = e;
	jp z, l_65
	ld a, e
	ld (tapereadspeed), a
l_65:
; 904     ReadTapeFile();
	call readtapefile
; 905     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 906     swap(hl, de);
	ex hl, de
; 907     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 908     swap(hl, de);
	ex hl, de
; 909     push(bc);
	push bc
; 910     CalculateCheckSum();
	call calculatechecksum
; 911     h = b;
	ld h, b
; 912     l = c;
	ld l, c
; 913     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 914     pop(de);
	pop de
; 915     CompareHlDe(hl, de);
	call comparehlde
; 916     if (flag_z)
; 917         return;
	ret z
; 918     swap(hl, de);
	ex hl, de
; 919     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 920     MonitorError();
; 921 }
; 922 
; 923 void MonitorError() {
monitorerror:
; 924     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 925     Monitor2();
	jp monitor2
; 926 }
; 927 
; 928 // Функция для пользовательской программы.
; 929 // Загрузить файл с магнитной ленты.
; 930 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 931 
; 932 void ReadTapeFile(...) {
readtapefile:
; 933     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 934     push_pop(hl) {
	push hl
; 935         hl += bc;
	add hl, bc
; 936         swap(hl, de);
	ex hl, de
; 937         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 938     }
; 939     hl += bc;
	add hl, bc
; 940     swap(hl, de);
	ex hl, de
; 941 
; 942     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 943     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 944     if (flag_z)
; 945         return;
	ret z
; 946 
; 947     push_pop(hl) {
	push hl
; 948         ReadTapeBlock();
	call readtapeblock
; 949         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 950     }
; 951 }
; 952 
; 953 void ReadTapeWordNext() {
readtapewordnext:
; 954     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 955 }
; 956 
; 957 void ReadTapeWord(...) {
readtapeword:
; 958     ReadTapeByte(a);
	call readtapebyte
; 959     b = a;
	ld b, a
; 960     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 961     c = a;
	ld c, a
	ret
; 962 }
; 963 
; 964 void ReadTapeBlock(...) {
readtapeblock:
; 965     for (;;) {
l_68:
; 966         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 967         *hl = a;
	ld (hl), a
; 968         Loop();
	call loop
	jp l_68
; 969     }
; 970 }
; 971 
; 972 // Функция для пользовательской программы.
; 973 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 974 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 975 
; 976 void CalculateCheckSum(...) {
calculatechecksum:
; 977     bc = 0;
	ld bc, 0
; 978     for (;;) {
l_71:
; 979         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 980         push_pop(a) {
	push af
; 981             CompareHlDe(hl, de);
	call comparehlde
; 982             if (flag_z)
; 983                 return PopRet();
	jp z, popret
	pop af
; 984         }
; 985         a = b;
	ld a, b
; 986         carry_add(a, *hl);
	adc (hl)
; 987         b = a;
	ld b, a
; 988         Loop();
	call loop
	jp l_71
; 989     }
; 990 }
; 991 
; 992 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 993 // Сохранить блок данных на магнитную ленту
; 994 
; 995 void CmdO(...) {
cmdo:
; 996     if ((a = c) != 0)
	ld a, c
	or a
; 997         tapeWriteSpeed = a;
	jp z, l_73
	ld (tapewritespeed), a
l_73:
; 998     push_pop(hl) {
	push hl
; 999         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 1000     }
; 1001     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1002     swap(hl, de);
	ex hl, de
; 1003     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1004     swap(hl, de);
	ex hl, de
; 1005     push_pop(hl) {
	push hl
; 1006         h = b;
	ld h, b
; 1007         l = c;
	ld l, c
; 1008         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1009     }
; 1010     WriteTapeFile(hl, de);
; 1011 }
; 1012 
; 1013 // Функция для пользовательской программы.
; 1014 // Запись файла на магнитную ленту.
; 1015 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1016 
; 1017 void WriteTapeFile(...) {
writetapefile:
; 1018     push(bc);
	push bc
; 1019     bc = 0;
	ld bc, 0
; 1020     do {
l_75:
; 1021         WriteTapeByte(c);
	call writetapebyte
; 1022         b--;
	dec b
; 1023         swap(hl, *sp);
	ex (sp), hl
; 1024         swap(hl, *sp);
	ex (sp), hl
l_76:
	jp nz, l_75
; 1025     } while (flag_nz);
; 1026     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1027     WriteTapeWord(hl);
	call writetapeword
; 1028     swap(hl, de);
	ex hl, de
; 1029     WriteTapeWord(hl);
	call writetapeword
; 1030     swap(hl, de);
	ex hl, de
; 1031     WriteTapeBlock(hl, de);
	call writetapeblock
; 1032     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1033     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1034     pop(hl);
	pop hl
; 1035     WriteTapeWord(hl);
	call writetapeword
; 1036     return;
	ret
; 1037 }
; 1038 
; 1039 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1040     push_pop(bc) {
	push bc
; 1041         PrintCrLfTab();
	call printcrlftab
; 1042         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1043     }
; 1044 }
; 1045 
; 1046 void PrintHexWordSpace(...) {
printhexwordspace:
; 1047     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1048     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1049 }
; 1050 
; 1051 void WriteTapeBlock(...) {
writetapeblock:
; 1052     for (;;) {
l_79:
; 1053         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1054         Loop();
	call loop
	jp l_79
; 1055     }
; 1056 }
; 1057 
; 1058 void WriteTapeWord(...) {
writetapeword:
; 1059     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1060     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1061 }
; 1062 
; 1063 // Загрузка байта с магнитной ленты.
; 1064 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1065 // Результат: a = прочитанный байт.
; 1066 
; 1067 void ReadTapeByte(...) {
readtapebyte:
; 1068     push(hl, bc, de);
	push hl
	push bc
	push de
; 1069     d = a;
	ld d, a
; 1070     ReadTapeByteInternal(d);
; 1071 }
; 1072 
; 1073 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1074     c = 0;
	ld c, 0
; 1075     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1076     do {
l_81:
; 1077     retry:  // Сдвиг результата
retry:
; 1078         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1079         cyclic_rotate_left(a, 1);
	rlca
; 1080         c = a;
	ld c, a
; 1081 
; 1082         // Ожидание изменения бита
; 1083         h = 0;
	ld h, 0
; 1084         do {
l_84:
; 1085             h--;
	dec h
; 1086             if (flag_z)
; 1087                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_85:
; 1088         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_84
; 1089 
; 1090         // Сохранение бита
; 1091         c = (a |= c);
	or c
	ld c, a
; 1092 
; 1093         // Задержка
; 1094         d--;
	dec d
; 1095         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1096         if (flag_z)
; 1097             a -= 18;
	jp nz, l_87
	sub 18
l_87:
; 1098         b = a;
	ld b, a
; 1099         do {
l_89:
l_90:
; 1100         } while (flag_nz(b--));
	dec b
	jp nz, l_89
; 1101         d++;
	inc d
; 1102 
; 1103         // Новое значение бита
; 1104         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1105 
; 1106         // Режим поиска синхробайта
; 1107         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_92
; 1108             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_94
; 1109                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_95
l_94:
; 1110             } else {
; 1111                 if (a != ~TAPE_START)
	cp 65305
; 1112                     goto retry;
	jp nz, retry
; 1113                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_95:
; 1114             }
; 1115             d = 8 + 1;
	ld d, 9
l_92:
l_82:
; 1116         }
; 1117     } while (flag_nz(d--));
	dec d
	jp nz, l_81
; 1118     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1119     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1120 }
; 1121 
; 1122 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1123     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1124         return MonitorError();
	jp p, monitorerror
; 1125     CtrlC();
	call ctrlc
; 1126     return ReadTapeByteInternal();
	jp readtapebyteinternal
; 1127 }
; 1128 
; 1129 // Функция для пользовательской программы.
; 1130 // Запись байта на магнитную ленту.
; 1131 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1132 
; 1133 void WriteTapeByte(...) {
writetapebyte:
; 1134     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1135         d = 8;
	ld d, 8
; 1136         do {
l_96:
; 1137             // Сдвиг исходного байта
; 1138             a = c;
	ld a, c
; 1139             cyclic_rotate_left(a, 1);
	rlca
; 1140             c = a;
	ld c, a
; 1141 
; 1142             // Вывод
; 1143             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1144             out(PORT_TAPE, a);
	out (1), a
; 1145 
; 1146             // Задержка
; 1147             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1148             do {
l_99:
; 1149                 b--;
	dec b
l_100:
	jp nz, l_99
; 1150             } while (flag_nz);
; 1151 
; 1152             // Вывод
; 1153             (a = 0) ^= c;
	ld a, 0
	xor c
; 1154             out(PORT_TAPE, a);
	out (1), a
; 1155 
; 1156             // Задержка
; 1157             d--;
	dec d
; 1158             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1159             if (flag_z)
; 1160                 a -= 14;
	jp nz, l_102
	sub 14
l_102:
; 1161             b = a;
	ld b, a
; 1162             do {
l_104:
; 1163                 b--;
	dec b
l_105:
	jp nz, l_104
; 1164             } while (flag_nz);
; 1165             d++;
	inc d
l_97:
; 1166         } while (flag_nz(d--));
	dec d
	jp nz, l_96
	pop af
	pop de
	pop bc
	ret
; 1167     }
; 1168 }
; 1169 
; 1170 // Функция для пользовательской программы.
; 1171 // Вывод 8 битного числа на экран.
; 1172 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1173 
; 1174 void PrintHexByte(...) {
printhexbyte:
; 1175     push_pop(a) {
	push af
; 1176         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1177         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1178     }
; 1179     PrintHexNibble(a);
; 1180 }
; 1181 
; 1182 void PrintHexNibble(...) {
printhexnibble:
; 1183     a &= 0x0F;
	and 15
; 1184     if (flag_p(compare(a, 10)))
	cp 10
; 1185         a += 'A' - '0' - 10;
	jp m, l_107
	add 7
l_107:
; 1186     a += '0';
	add 48
; 1187     PrintCharA(a);
; 1188 }
; 1189 
; 1190 // Вывод символа на экран.
; 1191 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1192 
; 1193 void PrintCharA(...) {
printchara:
; 1194     PrintChar(c = a);
	ld c, a
; 1195 }
; 1196 
; 1197 // Функция для пользовательской программы.
; 1198 // Вывод символа на экран.
; 1199 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1200 
; 1201 void PrintChar(...) {
printchar:
; 1202     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1203     DrawCursor();
	call drawcursor
; 1204     hl = cursor;
	ld hl, (cursor)
; 1205     a = escState;
	ld a, (escstate)
; 1206     a--;
	dec a
; 1207     if (flag_m)
; 1208         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1209     if (flag_z)
; 1210         return PrintCharEsc();
	jp z, printcharesc
; 1211     a--;
	dec a
; 1212     if (flag_nz)
; 1213         return PrintCharEscY2();
	jp nz, printcharescy2
; 1214 
; 1215     // Первый параметр ESC Y
; 1216     a = c;
	ld a, c
; 1217     a -= ' ';
	sub 32
; 1218     if (flag_m) {
	jp p, l_109
; 1219         a ^= a;
	xor a
	jp l_110
l_109:
; 1220     } else {
; 1221         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 25
; 1222             a = SCREEN_HEIGHT - 1;
	jp m, l_111
	ld a, 24
l_111:
l_110:
; 1223     }
; 1224     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1225     c = a;
	ld c, a
; 1226     b = (a &= 192);
	and 192
	ld b, a
; 1227     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1228     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1229     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1230     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1231 }
; 1232 
; 1233 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1234     escState = a;
	ld (escstate), a
; 1235     PrintCharSaveCursor(hl);
; 1236 }
; 1237 
; 1238 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1239     cursor = hl;
	ld (cursor), hl
; 1240     PrintCharExit();
; 1241 }
; 1242 
; 1243 void PrintCharExit(...) {
printcharexit:
; 1244     DrawCursor();
	call drawcursor
; 1245     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1246 }
; 1247 
; 1248 void DrawCursor(...) {
drawcursor:
; 1249     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1250         return;
	ret z
; 1251     hl = cursor;
	ld hl, (cursor)
; 1252     hl += (de = -SCREEN_SIZE);
	ld de, 63488
	add hl, de
; 1253     a = *hl;
	ld a, (hl)
; 1254     a ^= SCREEN_ATTRIB_UNDERLINE;
	xor 128
; 1255     *hl = a;
	ld (hl), a
	ret
; 1256 }
; 1257 
; 1258 void PrintCharEscY2(...) {
printcharescy2:
; 1259     a = c;
	ld a, c
; 1260     a -= ' ';
	sub 32
; 1261     if (flag_m) {
	jp p, l_113
; 1262         a ^= a;
	xor a
	jp l_114
l_113:
; 1263     } else {
; 1264         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1265             a = SCREEN_WIDTH - 1;
	jp m, l_115
	ld a, 63
l_115:
l_114:
; 1266     }
; 1267     b = a;
	ld b, a
; 1268     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1269     PrintCharResetEscState();
; 1270 }
; 1271 
; 1272 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1273     a ^= a;
	xor a
; 1274     return PrintCharSetEscState();
	jp printcharsetescstate
; 1275 }
; 1276 
; 1277 void PrintCharEsc(...) {
printcharesc:
; 1278     a = c;
	ld a, c
; 1279     if (a == 'Y') {
	cp 89
	jp nz, l_117
; 1280         a = 2;
	ld a, 2
; 1281         return PrintCharSetEscState();
	jp printcharsetescstate
l_117:
; 1282     }
; 1283     if (a == 97) {
	cp 97
	jp nz, l_119
; 1284         a ^= a;
	xor a
; 1285         return SetCursorVisible();
	jp setcursorvisible
l_119:
; 1286     }
; 1287     if (a != 98)
	cp 98
; 1288         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1289     SetCursorVisible();
; 1290 }
; 1291 
; 1292 void SetCursorVisible(...) {
setcursorvisible:
; 1293     cursorVisible = a;
	ld (cursorvisible), a
; 1294     return PrintCharResetEscState();
	jp printcharresetescstate
; 1295 }
; 1296 
; 1297 void PrintCharNoEsc(...) {
printcharnoesc:
; 1298     // Остановка вывода нажатием УС + Шифт
; 1299     do {
l_121:
; 1300         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_122:
; 1301     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_121
; 1302 
; 1303 #ifdef CMD_A_ENABLED
; 1304     compare(a = 16, c);
; 1305     a = translateCodeEnabled;
; 1306     if (flag_z) {
; 1307         invert(a);
; 1308         translateCodeEnabled = a;
; 1309         return PrintCharSaveCursor();
; 1310     }
; 1311     if (a != 0)
; 1312         TranslateCodePage(c);
; 1313 #endif
; 1314 
; 1315     a = c;
	ld a, c
; 1316     if (a == 31)
	cp 31
; 1317         return ClearScreen();
	jp z, clearscreen
; 1318     if (flag_m)
; 1319         return PrintChar3(a);
	jp m, printchar3
; 1320     PrintChar4(a);
; 1321 }
; 1322 
; 1323 void PrintChar4(...) {
printchar4:
; 1324     *hl = a;
	ld (hl), a
; 1325     push_pop(hl) {
	push hl
; 1326         hl += (de = -SCREEN_SIZE);
	ld de, 63488
	add hl, de
; 1327         *hl = a = color;
	ld a, (color)
	ld (hl), a
	pop hl
; 1328     }
; 1329     MoveCursorRight(hl);
	jp movecursorright
; 1330 }
; 1331 
; 1332 void ClearScreenInt() {
clearscreenint:
; 1333     do {
l_124:
; 1334         do {
l_127:
; 1335             *hl = 0;
	ld (hl), 0
; 1336             hl++;
	inc hl
; 1337             *de = a;
	ld (de), a
; 1338             de++;
	inc de
l_128:
; 1339         } while (flag_nz(c--));
	dec c
	jp nz, l_127
l_125:
; 1340     } while (flag_nz(b--));
	dec b
	jp nz, l_124
	ret
; 1341 }
; 1342 
; 1343 void ClearScreen() {
clearscreen:
; 1344     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1345     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1346     bc = 25 * SCREEN_WIDTH + 0x100;  // 25 строк
	ld bc, 1856
; 1347     a = color;
	ld a, (color)
; 1348     ClearScreenInt();
	call clearscreenint
; 1349     a = SCREEN_ATTRIB_BLANK;
	ld a, 7
; 1350     bc = 7 * SCREEN_WIDTH + 0x100;  // 7 строк
	ld bc, 704
; 1351     ClearScreenInt();
	call clearscreenint
; 1352     PrintKeyStatus();
	call printkeystatus
; 1353     MoveCursorHome();
; 1354 }
; 1355 
; 1356 void MoveCursorHome(...) {
movecursorhome:
; 1357     return PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1358 }
; 1359 
; 1360 void PrintChar3(...) {
printchar3:
; 1361     if (a == 12)
	cp 12
; 1362         return MoveCursorHome();
	jp z, movecursorhome
; 1363     if (a == 13)
	cp 13
; 1364         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1365     if (a == 10)
	cp 10
; 1366         return MoveCursorDown(hl);
	jp z, movecursordown
; 1367     if (a == 8)
	cp 8
; 1368         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1369     if (a == 24)
	cp 24
; 1370         return MoveCursorRight(hl);
	jp z, movecursorright
; 1371     if (a == 25)
	cp 25
; 1372         return MoveCursorUp(hl);
	jp z, movecursorup
; 1373     if (a == 7)
	cp 7
; 1374 #ifdef BEEP_ENABLED
; 1375         return PrintCharBeep();
; 1376 #else
; 1377         return PrintCharExit();
	jp z, printcharexit
; 1378 #endif
; 1379     if (a == 26)
	cp 26
; 1380         return MoveCursorDown();
	jp z, movecursordown
; 1381     if (a != 27)
	cp 27
; 1382         return PrintChar4(hl, a);
	jp nz, printchar4
; 1383     a = 1;
	ld a, 1
; 1384     PrintCharSetEscState();
	jp printcharsetescstate
; 1385 }
; 1386 
; 1387 #ifdef BEEP_ENABLED
; 1388 void PrintCharBeep(...) {
; 1389     c = 128;  // Длительность
; 1390     e = 32;   // Частота
; 1391     do {
; 1392         d = e;
; 1393         do {
; 1394             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
; 1395         } while (flag_nz(e--));
; 1396         e = d;
; 1397         do {
; 1398             out(PORT_KEYBOARD_MODE, a = (7 << 1));
; 1399         } while (flag_nz(d--));
; 1400     } while (flag_nz(c--));
; 1401 
; 1402     PrintCharExit();
; 1403 }
; 1404 #endif
; 1405 
; 1406 void MoveCursorCr(...) {
movecursorcr:
; 1407     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1408     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1409 }
; 1410 
; 1411 void MoveCursorRight(...) {
movecursorright:
; 1412     hl++;
	inc hl
; 1413     MoveCursorBoundary(hl);
; 1414 }
; 1415 
; 1416 void MoveCursorBoundary(...) {
movecursorboundary:
; 1417     a = h;
	ld a, h
; 1418     if (a == (SCREEN_BEGIN >> 8) - 1) {
	cp 65511
	jp nz, l_130
; 1419         hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 1600
	add hl, de
; 1420         return PrintCharSaveCursor(hl);
	jp printcharsavecursor
l_130:
; 1421     }
; 1422 
; 1423     swap(hl, de);
	ex hl, de
; 1424     hl = -(SCREEN_BEGIN + SCREEN_WIDTH * (SCREEN_HEIGHT + 0));
	ld hl, 4544
; 1425     hl += de;
	add hl, de
; 1426     swap(hl, de);
	ex hl, de
; 1427     if (flag_c) {
	jp nc, l_132
; 1428         push_pop(hl) {
	push hl
; 1429             // Scroll up
; 1430             hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1;
	ld hl, 60991
; 1431             c = SCREEN_WIDTH;
	ld c, 64
; 1432             do {
l_134:
; 1433                 push_pop(hl) {
	push hl
; 1434                     de = SCREEN_SIZE - SCREEN_WIDTH;
	ld de, 1984
; 1435                     b = 0;
	ld b, 0
; 1436                     c = a = color;
	ld a, (color)
	ld c, a
; 1437                     do {
l_137:
; 1438                         a = b;
	ld a, b
; 1439                         b = *hl;
	ld b, (hl)
; 1440                         *hl = a;
	ld (hl), a
; 1441                         h = ((a = h) -= 8);
	ld a, h
	sub 8
	ld h, a
; 1442                         a = c;
	ld a, c
; 1443                         c = *hl;
	ld c, (hl)
; 1444                         *hl = a;
	ld (hl), a
; 1445                         hl += de;
	add hl, de
l_138:
; 1446                     } while ((a = h) != 0xE7);
	ld a, h
	cp 231
	jp nz, l_137
	pop hl
; 1447                 }
; 1448                 l--;
	dec l
l_135:
; 1449             } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
	ld a, l
	cp 60927
	jp nz, l_134
	pop hl
; 1450         }
; 1451         hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
l_132:
; 1452     }
; 1453 
; 1454     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1455 }
; 1456 
; 1457 void MoveCursorLeft(...) {
movecursorleft:
; 1458     hl--;
	dec hl
; 1459     return MoveCursorBoundary(hl);
	jp movecursorboundary
; 1460 }
; 1461 
; 1462 void MoveCursorUp(...) {
movecursorup:
; 1463     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1464 }
; 1465 
; 1466 void MoveCursor(...) {
movecursor:
; 1467     hl += bc;
	add hl, bc
; 1468     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1469 }
; 1470 
; 1471 void MoveCursorDown(...) {
movecursordown:
; 1472     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1473 }
; 1474 
; 1475 void PrintCrLf() {
printcrlf:
; 1476     PrintChar(c = 13);
	ld c, 13
	call printchar
; 1477     PrintChar(c = 10);
	ld c, 10
	jp printchar
; 1478 }
; 1479 
; 1480 // Функция для пользовательской программы.
; 1481 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1482 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1483 
; 1484 void IsAnyKeyPressed() {
isanykeypressed:
; 1485     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1486     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1487     a &= KEYBOARD_ROW_MASK;
	and 127
; 1488     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_140
; 1489         a ^= a;
	xor a
; 1490         return;
	ret
l_140:
; 1491     }
; 1492     a = 0xFF;
	ld a, 255
	ret
; 1493 }
; 1494 
; 1495 // Функция для пользовательской программы.
; 1496 // Получить код нажатой клавиши на клавиатуре.
; 1497 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1498 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1499 
; 1500 void ReadKey() {
readkey:
; 1501     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 1502     retry:
retry_1804289383:
; 1503         do {
l_142:
; 1504             hl = keyDelay;
	ld hl, (keydelay)
; 1505             ReadKeyInternal(hl);
	call readkeyinternal
; 1506             l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1507             if (flag_nz) {  // Не таймаут
	jp z, l_145
; 1508                 do {
l_147:
; 1509                     l = 2;
	ld l, 2
; 1510                     ReadKeyInternal(hl);
	call readkeyinternal
l_148:
	jp nz, l_147
; 1511                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1512                 l = 128;            // Задержка повтора первого нажатия клавиши
	ld l, 128
l_145:
; 1513             }
; 1514             keyDelay = hl;
	ld (keydelay), hl
; 1515             a++;
	inc a
l_143:
	jp z, l_142
; 1516         } while (flag_z);  // Цикл длится, пока не нажата клавиша
; 1517 
; 1518         // Переключение Рус/Лат, Заг/Стр
; 1519         a++;
	inc a
; 1520         if (flag_z) {
	jp nz, l_150
; 1521             a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1522             carry_rotate_right(a, 3); /* Shift */
	rra
	rra
	rra
; 1523             a = KEYB_MODE_CAP;
	ld a, 1
; 1524             carry_add(a, 0); /* KEYB_MODE_CAP -> KEYB_MODE_RUS */
	adc 0
; 1525             hl = &keyMode;
	ld hl, 0FFFFh & (keymode)
; 1526             a ^= *hl;
	xor (hl)
; 1527             *hl = a;
	ld (hl), a
; 1528             PrintKeyStatus();
	call printkeystatus
; 1529             goto retry;
	jp retry_1804289383
l_150:
; 1530         }
; 1531 
; 1532         a = c;
	ld a, c
	pop hl
	pop de
	pop bc
	ret
; 1533     }
; 1534 }
; 1535 
; 1536 void ReadKeyInternal(...) {
readkeyinternal:
; 1537     do {
l_152:
; 1538         ScanKey();
	call scankey
; 1539         c = a;
	ld c, a
; 1540         a = keyCode;
	ld a, (keycode)
; 1541         if (a != h)
	cp h
; 1542             break;
	jp nz, l_154
; 1543 
; 1544         // Задержка
; 1545         a ^= a;
	xor a
; 1546         do {
l_155:
; 1547             swap(hl, de);
	ex hl, de
; 1548             swap(hl, de);
	ex hl, de
l_156:
; 1549         } while (flag_nz(a--));
	dec a
	jp nz, l_155
; 1550         a = h;
	ld a, h
l_153:
; 1551     } while (flag_nz(l--));
	dec l
	jp nz, l_152
l_154:
; 1552     h = a;
	ld h, a
	ret
; 1553 }
; 1554 
; 1555 // Функция для пользовательской программы.
; 1556 // Получить код нажатой клавиши на клавиатуре.
; 1557 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1558 
; 1559 void ScanKey() {
scankey:
; 1560     push(bc, de, hl);
	push bc
	push de
	push hl
; 1561 
; 1562     bc = 0x00FE;
	ld bc, 254
; 1563     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1564     do {
l_158:
; 1565         a = c;
	ld a, c
; 1566         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1567         cyclic_rotate_left(a, 1);
	rlca
; 1568         c = a;
	ld c, a
; 1569         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1570         a &= KEYBOARD_ROW_MASK;
	and 127
; 1571         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1572             return ScanKey2(a);
	jp nz, scankey2
; 1573         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_159:
; 1574     } while (flag_nz(d--));
	dec d
	jp nz, l_158
; 1575 
; 1576     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1577     carry_rotate_right(a, 1);
	rra
; 1578     a = 0xFE;         // Рус/Лат
	ld a, 254
; 1579     carry_add(a, 0);  // Клавиша не нажата
	adc 0
; 1580 
; 1581     keyCode = a;
	ld (keycode), a
; 1582     ScanKeyExit(a);
	jp scankeyexit
; 1583 }
; 1584 
; 1585 void ScanKey2(...) {
scankey2:
; 1586     for (;;) {
l_162:
; 1587         carry_rotate_right(a, 1);
	rra
; 1588         if (flag_nc)
; 1589             break;
	jp nc, l_163
; 1590         b++;
	inc b
	jp l_162
l_163:
; 1591     }
; 1592 
; 1593     /* b - key number */
; 1594 
; 1595     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1596      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1597      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1598      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1599      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1600      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1601      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1602 
; 1603     a = b;
	ld a, b
; 1604     keyCode = a;
	ld (keycode), a
; 1605 
; 1606     if (a >= 48) {
	cp 48
	jp c, l_164
; 1607         h = (uintptr_t)specialKeyTable >> 8;
	ld h, 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) >> (8))
; 1608         l = (a += (uintptr_t)specialKeyTable - 48);
	add 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) - (48))
	ld l, a
; 1609         a = *hl;
	ld a, (hl)
; 1610         return ScanKeyExit(a);
	jp scankeyexit
l_164:
; 1611     }
; 1612 
; 1613     a += 48;
	add 48
; 1614     if (a >= 60)
	cp 60
; 1615         if (a < 64)
	jp c, l_166
	cp 64
; 1616             a &= 47;
	jp nc, l_168
	and 47
l_168:
l_166:
; 1617 
; 1618     if (a == 95)
	cp 95
; 1619         a = 127;
	jp nz, l_170
	ld a, 127
l_170:
; 1620 
; 1621     c = a;
	ld c, a
; 1622 
; 1623     a = keyMode;
	ld a, (keymode)
; 1624     carry_rotate_right(a, 2);
	rra
	rra
; 1625     if (flag_c) {  // Рус/Лат
	jp nc, l_172
; 1626         a = c;
	ld a, c
; 1627         a |= 0x20;
	or 32
; 1628         c = a;
	ld c, a
l_172:
; 1629     }
; 1630 
; 1631     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1632     carry_rotate_right(a, 2);
	rra
	rra
; 1633     if (flag_nc) {  // Ус
	jp c, l_174
; 1634         a = c;
	ld a, c
; 1635         a &= 0x1F;
	and 31
; 1636         return ScanKeyExit(a);
	jp scankeyexit
l_174:
; 1637     }
; 1638 
; 1639     carry_rotate_right(a, 1);
	rra
; 1640     a = c;
	ld a, c
; 1641     if (flag_nc) {  // Шифт
	jp c, l_176
; 1642         if (a == 127)
	cp 127
; 1643             a = 95;
	jp nz, l_178
	ld a, 95
l_178:
; 1644         a ^= 0x10;
	xor 16
; 1645         if (a >= 0x40)
	cp 64
; 1646             a ^= 0x80 | 0x10;
	jp c, l_180
	xor 144
l_180:
l_176:
; 1647     }
; 1648     c = a;
	ld c, a
; 1649 
; 1650     a = keyMode;
	ld a, (keymode)
; 1651     cyclic_rotate_right(a, 1);  // Заг/Стр
	rrca
; 1652     if (flag_c) {
	jp nc, l_182
; 1653         a = c;
	ld a, c
; 1654         a &= 0x7F;
	and 127
; 1655         if (a >= 0x60)  // Кириллица
	cp 96
; 1656             goto convert;
	jp nc, convert
; 1657         if (a >= 'A') {
	cp 65
	jp c, l_184
; 1658             if (a < 'Z' + 1) {
	cp 91
	jp nc, l_186
; 1659             convert:
convert:
; 1660                 a = c;
	ld a, c
; 1661                 a ^= 0x80;
	xor 128
; 1662                 c = a;
	ld c, a
l_186:
l_184:
l_182:
; 1663             }
; 1664         }
; 1665     }
; 1666 
; 1667     a = c;
	ld a, c
; 1668 
; 1669     ScanKeyExit(a);
; 1670 }
; 1671 
; 1672 void ScanKeyExit(...) {
scankeyexit:
; 1673     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1674 }
; 1675 
; 1676 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1687  aPrompt[] = "\r\n\x1B\x62-->";
aprompt:
	db 13
	db 10
	db 27
	db 98
	db 45
	db 45
	db 62
	ds 1
; 1688  aCrLfTab[] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1689  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1690  aBackspace[] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1691  aHello[] = "\x1F\x1B\x62m/80k";
ahello:
	db 31
	db 27
	db 98
	db 109
	db 47
	db 56
	db 48
	db 107
	ds 1
; 1701  PrintKeyStatus() {
printkeystatus:
; 1702     bc = SCREEN_BEGIN + 56 + 31 * SCREEN_WIDTH;
	ld bc, 61432
; 1703     a = keyMode;
	ld a, (keymode)
; 1704     hl = &aZag;
	ld hl, azag
; 1705     PrintKeyStatus1(a, bc, hl);
	call printkeystatus1
; 1706     bc++;
	inc bc
; 1707     l = &aLat;  // Оптимизация hl = &aLat;
	ld l, alat
; 1708     PrintKeyStatus1(a, bc, hl);
; 1709 }
; 1710 
; 1711 void PrintKeyStatus1(...) {
printkeystatus1:
; 1712     de = 3;  // Размер строки
	ld de, 3
; 1713     cyclic_rotate_right(a, 1);
	rrca
; 1714     if (flag_c)
; 1715         hl += de;
	jp nc, l_188
	add hl, de
l_188:
; 1716     d = a;
	ld d, a
; 1717     do {
l_190:
; 1718         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 1719         bc++;
	inc bc
; 1720         hl++;
	inc hl
l_191:
; 1721     } while (flag_nz(e--));
	dec e
	jp nz, l_190
; 1722     a = d;
	ld a, d
	ret
; 1723 }
; 1724 
; 1725 uint8_t aZag[] = {'z', 'a' | 0x80, 'g' | 0x80, 's', 't' | 0x80, 'r' | 0x80};
azag:
	db 122
	db 225
	db 231
	db 115
	db 244
	db 242
; 1726  aLat[] = {'l', 'a' | 0x80, 't' | 0x80, 'r', 'u' | 0x80, 's' | 0x80};
alat:
	db 108
	db 225
	db 244
	db 114
	db 245
	db 243
 savebin "micro80.bin", 0xF800, 0x10000
