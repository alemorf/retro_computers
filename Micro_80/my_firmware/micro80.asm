    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst30opcode equ 48
rst30address equ 49
rst38opcode equ 56
rst38address equ 57
keycode equ 63319
keyboardmode equ 63320
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
 .org 0xF800
; 67  uint8_t rst30Opcode __address(0x30);
; 68 extern uint16_t rst30Address __address(0x31);
; 69 extern uint8_t rst38Opcode __address(0x38);
; 70 extern uint16_t rst38Address __address(0x39);
; 71 
; 72 // Прототипы
; 73 void Reboot(...);
; 74 void EntryF86C_Monitor(...);
; 75 void Monitor(...);
; 76 void Monitor2();
; 77 void ReadString(...);
; 78 void PrintString(...);
; 79 void ParseParams(...);
; 80 void ParseWord(...);
; 81 void CompareHlDe(...);
; 82 void LoopWithBreak(...);
; 83 void Loop(...);
; 84 void PopRet();
; 85 void IncHl(...);
; 86 void CtrlC(...);
; 87 void PrintCrLfTab();
; 88 void PrintHexByteFromHlSpace(...);
; 89 void PrintHexByteSpace(...);
; 90 #ifdef CMD_R_ENABLED
; 91 void CmdR(...);
; 92 #endif
; 93 void GetRamTop(...);
; 94 void SetRamTop(...);
; 95 #ifdef CMD_A_ENABLED
; 96 void CmdA(...);
; 97 #endif
; 98 void CmdD(...);
; 99 void PrintSpacesTo(...);
; 100 void PrintSpace();
; 101 void CmdC(...);
; 102 void CmdF(...);
; 103 void CmdS(...);
; 104 void CmdW(...);
; 105 void CmdT(...);
; 106 void CmdM(...);
; 107 void CmdG(...);
; 108 void BreakPointHandler(...);
; 109 void CmdX(...);
; 110 void GetCursor();
; 111 void GetCursorChar();
; 112 void CmdH(...);
; 113 void CmdI(...);
; 114 void MonitorError();
; 115 void ReadTapeFile(...);
; 116 void ReadTapeWordNext();
; 117 void ReadTapeWord(...);
; 118 void ReadTapeBlock(...);
; 119 void CalculateCheckSum(...);
; 120 void CmdO(...);
; 121 void WriteTapeFile(...);
; 122 void PrintCrLfTabHexWordSpace(...);
; 123 void PrintHexWordSpace(...);
; 124 void WriteTapeBlock(...);
; 125 void WriteTapeWord(...);
; 126 void ReadTapeByte(...);
; 127 void ReadTapeByteInternal(...);
; 128 void ReadTapeByteTimeout(...);
; 129 void WriteTapeByte(...);
; 130 void PrintHexByte(...);
; 131 void PrintHexNibble(...);
; 132 void PrintCharA(...);
; 133 void PrintChar(...);
; 134 void PrintCharSetEscState(...);
; 135 void PrintCharSaveCursor(...);
; 136 void PrintCharExit(...);
; 137 void DrawCursor(...);
; 138 void PrintCharEscY2(...);
; 139 void PrintCharResetEscState(...);
; 140 void PrintCharEsc(...);
; 141 void SetCursorVisible(...);
; 142 void PrintCharNoEsc(...);
; 143 void PrintChar4(...);
; 144 void ClearScreen(...);
; 145 void MoveCursorHome(...);
; 146 void PrintChar3(...);
; 147 void PrintCharBeep(...);
; 148 void MoveCursorCr(...);
; 149 void MoveCursorRight(...);
; 150 void MoveCursorBoundary(...);
; 151 void MoveCursorLeft(...);
; 152 void MoveCursorLf(...);
; 153 void MoveCursorUp(...);
; 154 void MoveCursor(...);
; 155 void MoveCursorDown(...);
; 156 void IsAnyKeyPressed();
; 157 void ReadKey();
; 158 void ReadKeyInternal(...);
; 159 void ScanKey();
; 160 void ScanKey2(...);
; 161 void ScanKey3(...);
; 162 void ScanKeyExit(...);
; 163 void ScanKeyControl(...);
; 164 void ScanKeySpecial(...);
; 165 #ifdef CMD_A_ENABLED
; 166 void TranslateCodePageDefault(...);
; 167 #endif
; 168 void TryScrollUp(...);
; 169 void PrintKeyStatusInt(...);
; 170 void PrintKeyStatus();
; 171 
; 172 // Переменные Монитора
; 173 
; 174 extern uint8_t keyCode __address(0xF757);
; 175 extern uint8_t keyboardMode __address(0xF758);
; 176 extern uint8_t color __address(0xF759);
; 177 extern uint16_t cursor __address(0xF75A);
; 178 extern uint8_t tapeReadSpeed __address(0xF75C);
; 179 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 180 extern uint8_t cursorVisible __address(0xF75E);
; 181 extern uint8_t escState __address(0xF75F);
; 182 extern uint16_t keyDelay __address(0xF760);
; 183 extern uint16_t regPC __address(0xF762);
; 184 extern uint16_t regHL __address(0xF764);
; 185 extern uint16_t regBC __address(0xF766);
; 186 extern uint16_t regDE __address(0xF768);
; 187 extern uint16_t regSP __address(0xF76A);
; 188 extern uint16_t regAF __address(0xF76C);
; 189 extern uint16_t breakPointAddress __address(0xF771);
; 190 extern uint8_t breakPointValue __address(0xF773);
; 191 extern uint8_t jmpParam1Opcode __address(0xF774);
; 192 extern uint16_t param1 __address(0xF775);
; 193 extern uint16_t param2 __address(0xF777);
; 194 extern uint16_t param3 __address(0xF779);
; 195 extern uint8_t param2Exists __address(0xF77B);
; 196 extern uint8_t tapePolarity __address(0xF77C);
; 197 #ifdef CMD_A_ENABLED
; 198 extern uint8_t translateCodeEnabled __address(0xF77D);
; 199 extern uint8_t translateCodePageJump __address(0xF77E);
; 200 extern uint16_t translateCodePageAddress __address(0xF77F);
; 201 #endif
; 202 extern uint16_t ramTop __address(0xF781);
; 203 extern uint8_t inputBuffer[32] __address(0xF783);
; 204 
; 205 #define firstVariableAddress (&keyboardMode)
; 206 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 207 
; 208 extern uint8_t specialKeyTable[9];
; 209 extern uint8_t aPrompt[6];
; 210 extern uint8_t aCrLfTab[6];
; 211 extern uint8_t aRegisters[37];
; 212 extern uint8_t aBackspace[4];
; 213 extern uint8_t aHello[12];
; 214 
; 215 // Для удобства
; 216 
; 217 void JmpParam1() __address(0xF774);
; 218 #ifdef CMD_A_ENABLED
; 219 void TranslateCodePage() __address(0xF77E);
; 220 #endif
; 221 
; 222 // Точки входа
; 223 
; 224 void EntryF800_Reboot() {
entryf800_reboot:
; 225     Reboot();
	jp reboot
; 226 }
; 227 
; 228 void EntryF803_ReadKey() {
entryf803_readkey:
; 229     ReadKey();
	jp readkey
; 230 }
; 231 
; 232 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 233     ReadTapeByte(a);
	jp readtapebyte
; 234 }
; 235 
; 236 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 237     PrintChar(c);
	jp printchar
; 238 }
; 239 
; 240 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 241     WriteTapeByte(c);
	jp writetapebyte
; 242 }
; 243 
; 244 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 245 #ifdef CMD_A_ENABLED
; 246     TranslateCodePage(c);
; 247 #else
; 248     return;
	ret
; 249     return;
	ret
; 250     return;
	ret
; 251 #endif
; 252 }
; 253 
; 254 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 255     IsAnyKeyPressed();
	jp isanykeypressed
; 256 }
; 257 
; 258 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 259     PrintHexByte(a);
	jp printhexbyte
; 260 }
; 261 
; 262 void EntryF818_PrintString(...) {
entryf818_printstring:
; 263     PrintString(hl);
	jp printstring
; 264 }
; 265 
; 266 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 267     ScanKey();
	jp scankey
; 268 }
; 269 
; 270 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 271     GetCursor();
	jp getcursor
; 272 }
; 273 
; 274 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 275     GetCursorChar();
	jp getcursorchar
; 276 }
; 277 
; 278 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 279     ReadTapeFile(hl);
	jp readtapefile
; 280 }
; 281 
; 282 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 283     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 284 }
; 285 
; 286 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 287     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 288 }
; 289 
; 290 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 291     return;
	ret
; 292     return;
	ret
; 293     return;
	ret
; 294 }
; 295 
; 296 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 297     GetRamTop();
	jp getramtop
; 298 }
; 299 
; 300 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 301     SetRamTop(hl);
	jp setramtop
; 302 }
; 303 
; 304 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 305 // Параметры: нет. Функция никогда не завершается.
; 306 
; 307 void Reboot(...) {
reboot:
; 308     disable_interrupts();
	di
; 309     sp = STACK_TOP;
	ld sp, 63488
; 310 
; 311     // Очистка памяти
; 312     hl = firstVariableAddress;
	ld hl, 0FFFFh & (keyboardmode)
; 313     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 314     c = 0;
	ld c, 0
; 315     CmdF();
	call cmdf
; 316 
; 317     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 39
	ld (color), a
; 318 #ifdef CMD_A_ENABLED
; 319     translateCodePageJump = a = OPCODE_JMP;
; 320 #endif
; 321 
; 322     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 323 
; 324     ramTop = hl = SCREEN_ATTRIB_BEGIN - 1;
	ld hl, 57343
	ld (ramtop), hl
; 325     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 326 #ifdef CMD_A_ENABLED
; 327     translateCodePageAddress = hl = &TranslateCodePageDefault;
; 328 #endif
; 329     regSP = hl = 0xF7FE;
	ld hl, 63486
	ld (regsp), hl
; 330     EntryF86C_Monitor();
	jp entryf86c_monitor
 .org 0xF86C
; 331 }
; 332 
; 333 asm(" .org 0xF86C");
; 334 
; 335 void EntryF86C_Monitor() {
entryf86c_monitor:
; 336     Monitor();
; 337 }
; 338 
; 339 void Monitor() {
monitor:
; 340     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 341     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 342     Monitor2();
; 343 }
; 344 
; 345 void Monitor2() {
monitor2:
; 346     sp = STACK_TOP;
	ld sp, 63488
; 347     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 348 
; 349     ReadString();
	call readstring
; 350 
; 351     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 352 
; 353     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 354     a = *hl;
	ld a, (hl)
; 355     a &= 0x7F;
	and 127
; 356 
; 357     if (a == 'X')
	cp 88
; 358         return CmdX();
	jp z, cmdx
; 359 
; 360     push_pop(a) {
	push af
; 361         ParseParams();
	call parseparams
; 362         hl = param3;
	ld hl, (param3)
; 363         c = l;
	ld c, l
; 364         b = h;
	ld b, h
; 365         hl = param2;
	ld hl, (param2)
; 366         swap(hl, de);
	ex hl, de
; 367         hl = param1;
	ld hl, (param1)
	pop af
; 368     }
; 369 
; 370     if (a == 'D')
	cp 68
; 371         return CmdD();
	jp z, cmdd
; 372     if (a == 'C')
	cp 67
; 373         return CmdC();
	jp z, cmdc
; 374     if (a == 'F')
	cp 70
; 375         return CmdF();
	jp z, cmdf
; 376     if (a == 'S')
	cp 83
; 377         return CmdS();
	jp z, cmds
; 378     if (a == 'T')
	cp 84
; 379         return CmdT();
	jp z, cmdt
; 380     if (a == 'M')
	cp 77
; 381         return CmdM();
	jp z, cmdm
; 382     if (a == 'G')
	cp 71
; 383         return CmdG();
	jp z, cmdg
; 384     if (a == 'I')
	cp 73
; 385         return CmdI();
	jp z, cmdi
; 386     if (a == 'O')
	cp 79
; 387         return CmdO();
	jp z, cmdo
; 388     if (a == 'W')
	cp 87
; 389         return CmdW();
	jp z, cmdw
; 390 #ifdef CMD_A_ENABLED
; 391     if (a == 'A')
; 392         return CmdA();
; 393 #endif
; 394     if (a == 'H')
	cp 72
; 395         return CmdH();
	jp z, cmdh
; 396 #ifdef CMD_R_ENABLED
; 397     if (a == 'R')
; 398         return CmdR();
; 399 #endif
; 400     MonitorError();
	jp monitorerror
; 401 }
; 402 
; 403 void ReadString() {
readstring:
; 404     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 405     h = d;
	ld h, d
; 406     l = e;
	ld l, e
; 407     for (;;) {
l_1:
; 408         ReadKey();
	call readkey
; 409         if (a == KEY_BACKSPACE) {
	cp 127
	jp nz, l_3
; 410             if ((a = e) == l)
	ld a, e
	cp l
; 411                 continue;
	jp z, l_1
; 412             hl--;
	dec hl
; 413             push_pop(hl) {
	push hl
; 414                 PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 415             }
; 416             continue;
	jp l_1
l_3:
; 417         }
; 418         *hl = a;
	ld (hl), a
; 419         if (a == 13) {
	cp 13
	jp nz, l_5
; 420             if ((a = e) != l)
	ld a, e
	cp l
; 421                 set_flag_c();
	jp z, l_7
	scf
l_7:
; 422             return;
	ret
l_5:
; 423         }
; 424         if (a == '.')
	cp 46
; 425             return Monitor2();
	jp z, monitor2
; 426         if (a < 32)
	cp 32
; 427             a = '.';
	jp nc, l_9
	ld a, 46
l_9:
; 428         PrintCharA(a);
	call printchara
; 429         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 430             return MonitorError();
	jp z, monitorerror
; 431         hl++;
	inc hl
	jp l_1
; 432     }
; 433 }
; 434 
; 435 // Функция для пользовательской программы.
; 436 // Вывод строки на экран.
; 437 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 438 
; 439 void PrintString(...) {
printstring:
; 440     for (;;) {
l_12:
; 441         a = *hl;
	ld a, (hl)
; 442         if (a == 0)
	or a
; 443             return;
	ret z
; 444         PrintCharA(a);
	call printchara
; 445         hl++;
	inc hl
	jp l_12
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
; 463     param2Exists = a = d; /* Not 0 */
	ld a, d
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
l_15:
; 480         a = *de;
	ld a, (de)
; 481         compare(a, 13);
	cp 13
; 482         set_flag_c();
	scf
; 483         if (flag_z)
; 484             return;
	ret z
; 485         de++;
	inc de
; 486         if (a == ',')
	cp 44
; 487             return;
	ret z
; 488         if (a == ' ')
	cp 32
; 489             continue;
	jp z, l_15
; 490         push(bc = &MonitorError);
	ld bc, 0FFFFh & (monitorerror)
	push bc
; 491         a &= 0x7F;
	and 127
; 492         a -= '0';
	sub 48
; 493         if (flag_c)
; 494             return;
	ret c
; 495         if (a >= 10) {
	cp 10
	jp c, l_17
; 496             if (a < 17)
	cp 17
; 497                 return;
	ret c
; 498             if (a >= 23)
	cp 23
; 499                 return;
	ret nc
; 500             a -= 7;
	sub 7
l_17:
; 501         }
; 502         hl += hl;
	add hl, hl
; 503         if (flag_c)
; 504             return;
	ret c
; 505         hl += hl;
	add hl, hl
; 506         if (flag_c)
; 507             return;
	ret c
; 508         hl += hl;
	add hl, hl
; 509         if (flag_c)
; 510             return;
	ret c
; 511         hl += hl;
	add hl, hl
; 512         if (flag_c)
; 513             return;
	ret c
; 514         b = 0;
	ld b, 0
; 515         c = a;
	ld c, a
; 516         hl += bc;
	add hl, bc
; 517         pop(bc);
	pop bc
	jp l_15
; 518     }
; 519 }
; 520 
; 521 void CompareHlDe(...) {
comparehlde:
; 522     if ((a = h) != d)
	ld a, h
	cp d
; 523         return;
	ret nz
; 524     compare(a = l, e);
	ld a, l
	cp e
	ret
; 525 }
; 526 
; 527 void LoopWithBreak(...) {
loopwithbreak:
; 528     CtrlC();
	call ctrlc
; 529     Loop(hl, de);
; 530 }
; 531 
; 532 void Loop(...) {
loop:
; 533     CompareHlDe(hl, de);
	call comparehlde
; 534     if (flag_nz)
; 535         return IncHl(hl);
	jp nz, inchl
; 536     PopRet();
; 537 }
; 538 
; 539 void PopRet() {
popret:
; 540     sp++;
	inc sp
; 541     sp++;
	inc sp
	ret
; 542 }
; 543 
; 544 void IncHl(...) {
inchl:
; 545     hl++;
	inc hl
	ret
; 546 }
; 547 
; 548 void CtrlC() {
ctrlc:
; 549     ScanKey();
	call scankey
; 550     if (a != 3)  // УПР + C
	cp 3
; 551         return;
	ret nz
; 552     MonitorError();
	jp monitorerror
; 553 }
; 554 
; 555 void PrintCrLfTab() {
printcrlftab:
; 556     push_pop(hl) {
	push hl
; 557         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 558     }
; 559 }
; 560 
; 561 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 562     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 563 }
; 564 
; 565 void PrintHexByteSpace(...) {
printhexbytespace:
; 566     push_pop(bc) {
	push bc
; 567         PrintHexByte(a);
	call printhexbyte
; 568         PrintSpace();
	call printspace
	pop bc
	ret
; 569     }
; 570 }
; 571 
; 572 #ifdef CMD_R_ENABLED
; 573 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 574 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 575 
; 576 void CmdR(...) {
; 577     out(PORT_EXT_MODE, a = 0x90);
; 578     for (;;) {
; 579         out(PORT_EXT_ADDR_LOW, a = l);
; 580         out(PORT_EXT_ADDR_HIGH, a = h);
; 581         *bc = a = in(PORT_EXT_DATA);
; 582         bc++;
; 583         Loop();
; 584     }
; 585 }
; 586 #endif
; 587 
; 588 // Функция для пользовательской программы.
; 589 // Получить адрес последнего доступного байта оперативной памяти.
; 590 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 591 
; 592 void GetRamTop(...) {
getramtop:
; 593     hl = ramTop;
	ld hl, (ramtop)
	ret
; 594 }
; 595 
; 596 // Функция для пользовательской программы.
; 597 // Установить адрес последнего доступного байта оперативной памяти.
; 598 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 599 
; 600 void SetRamTop(...) {
setramtop:
; 601     ramTop = hl;
	ld (ramtop), hl
	ret
; 602 }
; 603 
; 604 #ifdef CMD_A_ENABLED
; 605 // Команда A <адрес>
; 606 // Установить программу преобразования кодировки символов выводимых на экран
; 607 
; 608 void CmdA(...) {
; 609     translateCodePageAddress = hl;
; 610 }
; 611 #endif
; 612 
; 613 // Команда D <начальный адрес> <конечный адрес>
; 614 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 615 
; 616 void CmdD(...) {
cmdd:
; 617     for (;;) {
l_20:
; 618         PrintChar(c = 13);
	ld c, 13
	call printchar
; 619         PrintChar(c = 10);
	ld c, 10
	call printchar
; 620         PrintHexWordSpace(hl);
	call printhexwordspace
; 621         push_pop(hl) {
	push hl
; 622             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 623             carry_rotate_right(a, 1);
	rra
; 624             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 625             PrintSpacesTo();
	call printspacesto
; 626             do {
l_22:
; 627                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 628                 CompareHlDe(hl, de);
	call comparehlde
; 629                 hl++;
	inc hl
; 630                 if (flag_z)
; 631                     break;
	jp z, l_24
; 632                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 633                 push_pop(a) {
	push af
; 634                     a &= 1;
	and 1
; 635                     if (flag_z)
; 636                         PrintSpace();
	call z, printspace
	pop af
l_23:
	jp nz, l_22
l_24:
	pop hl
; 637                 }
; 638             } while (flag_nz);
; 639         }
; 640 
; 641         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 642         PrintSpacesTo(b);
	call printspacesto
; 643 
; 644         do {
l_25:
; 645             a = *hl;
	ld a, (hl)
; 646             if (a < 32)
	cp 32
; 647                 a = '.';
	jp nc, l_28
	ld a, 46
l_28:
; 648             PrintCharA(a);
	call printchara
; 649             CompareHlDe(hl, de);
	call comparehlde
; 650             if (flag_z)
; 651                 return;
	ret z
; 652             hl++;
	inc hl
; 653             (a = l) &= 0x0F;
	ld a, l
	and 15
l_26:
	jp nz, l_25
	jp l_20
; 654         } while (flag_nz);
; 655     }
; 656 }
; 657 
; 658 void PrintSpacesTo(...) {
printspacesto:
; 659     for (;;) {
l_31:
; 660         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 661             return;
	ret nc
; 662         PrintSpace();
	call printspace
	jp l_31
; 663     }
; 664 }
; 665 
; 666 void PrintSpace() {
printspace:
; 667     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 668 }
; 669 
; 670 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 671 // Сравнить два блока адресного пространство
; 672 
; 673 void CmdC(...) {
cmdc:
; 674     for (;;) {
l_34:
; 675         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_36
; 676             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 677             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 678             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_36:
; 679         }
; 680         bc++;
	inc bc
; 681         LoopWithBreak();
	call loopwithbreak
	jp l_34
; 682     }
; 683 }
; 684 
; 685 // Команда F <начальный адрес> <конечный адрес> <байт>
; 686 // Заполнить блок в адресном пространстве одним байтом
; 687 
; 688 void CmdF(...) {
cmdf:
; 689     for (;;) {
l_39:
; 690         *hl = c;
	ld (hl), c
; 691         Loop();
	call loop
	jp l_39
; 692     }
; 693 }
; 694 
; 695 // Команда S <начальный адрес> <конечный адрес> <байт>
; 696 // Найти байт (8 битное значение) в адресном пространстве
; 697 
; 698 void CmdS(...) {
cmds:
; 699     for (;;) {
l_42:
; 700         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 701             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 702         LoopWithBreak();
	call loopwithbreak
	jp l_42
; 703     }
; 704 }
; 705 
; 706 // Команда W <начальный адрес> <конечный адрес> <слово>
; 707 // Найти слово (16 битное значение) в адресном пространстве
; 708 
; 709 void CmdW(...) {
cmdw:
; 710     for (;;) {
l_45:
; 711         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_47
; 712             hl++;
	inc hl
; 713             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 714             hl--;
	dec hl
; 715             if (flag_z)
; 716                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_47:
; 717         }
; 718         LoopWithBreak();
	call loopwithbreak
	jp l_45
; 719     }
; 720 }
; 721 
; 722 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 723 // Копировать блок в адресном пространстве
; 724 
; 725 void CmdT(...) {
cmdt:
; 726     for (;;) {
l_50:
; 727         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 728         bc++;
	inc bc
; 729         Loop();
	call loop
	jp l_50
; 730     }
; 731 }
; 732 
; 733 // Команда M <начальный адрес>
; 734 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 735 
; 736 void CmdM(...) {
cmdm:
; 737     for (;;) {
l_53:
; 738         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 739         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 740         push_pop(hl) {
	push hl
; 741             ReadString();
	call readstring
	pop hl
; 742         }
; 743         if (flag_c) {
	jp nc, l_55
; 744             push_pop(hl) {
	push hl
; 745                 ParseWord();
	call parseword
; 746                 a = l;
	ld a, l
	pop hl
; 747             }
; 748             *hl = a;
	ld (hl), a
l_55:
; 749         }
; 750         hl++;
	inc hl
	jp l_53
; 751     }
; 752 }
; 753 
; 754 // Команда G <начальный адрес> <конечный адрес>
; 755 // Запуск программы и возможным указанием точки останова.
; 756 
; 757 void CmdG(...) {
cmdg:
; 758     CompareHlDe(hl, de);
	call comparehlde
; 759     if (flag_nz) {
	jp z, l_57
; 760         swap(hl, de);
	ex hl, de
; 761         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 762         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 763         *hl = OPCODE_RST_30;
	ld (hl), 247
; 764         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 765         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_57:
; 766     }
; 767     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 768     pop(bc);
	pop bc
; 769     pop(de);
	pop de
; 770     pop(hl);
	pop hl
; 771     pop(a);
	pop af
; 772     sp = hl;
	ld sp, hl
; 773     hl = regHL;
	ld hl, (reghl)
; 774     JmpParam1();
	jp jmpparam1
; 775 }
; 776 
; 777 void BreakPointHandler(...) {
breakpointhandler:
; 778     regHL = hl;
	ld (reghl), hl
; 779     push(a);
	push af
; 780     pop(hl);
	pop hl
; 781     regAF = hl;
	ld (regaf), hl
; 782     pop(hl);
	pop hl
; 783     hl--;
	dec hl
; 784     regPC = hl;
	ld (regpc), hl
; 785     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 786     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 787     push(hl);
	push hl
; 788     push(de);
	push de
; 789     push(bc);
	push bc
; 790     sp = STACK_TOP;
	ld sp, 63488
; 791     hl = regPC;
	ld hl, (regpc)
; 792     swap(hl, de);
	ex hl, de
; 793     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 794     CompareHlDe(hl, de);
	call comparehlde
; 795     if (flag_nz)
; 796         return CmdX();
	jp nz, cmdx
; 797     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 798     CmdX();
; 799 }
; 800 
; 801 // Команда X
; 802 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 803 
; 804 void CmdX(...) {
cmdx:
; 805     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 806     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 807     b = 6;
	ld b, 6
; 808     do {
l_59:
; 809         e = *hl;
	ld e, (hl)
; 810         hl++;
	inc hl
; 811         d = *hl;
	ld d, (hl)
; 812         push(bc);
	push bc
; 813         push(hl);
	push hl
; 814         swap(hl, de);
	ex hl, de
; 815         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 816         ReadString();
	call readstring
; 817         if (flag_c) {
	jp nc, l_62
; 818             ParseWord();
	call parseword
; 819             pop(de);
	pop de
; 820             push(de);
	push de
; 821             swap(hl, de);
	ex hl, de
; 822             *hl = d;
	ld (hl), d
; 823             hl--;
	dec hl
; 824             *hl = e;
	ld (hl), e
l_62:
; 825         }
; 826         pop(hl);
	pop hl
; 827         pop(bc);
	pop bc
; 828         b--;
	dec b
; 829         hl++;
	inc hl
l_60:
	jp nz, l_59
; 830     } while (flag_nz);
; 831     EntryF86C_Monitor();
	jp entryf86c_monitor
; 832 }
; 833 
; 834 // Функция для пользовательской программы.
; 835 // Получить координаты курсора.
; 836 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 837 
; 838 void GetCursor() {
getcursor:
; 839     push_pop(a) {
	push af
; 840         hl = cursor;
	ld hl, (cursor)
; 841         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 842 
; 843         // Вычисление X
; 844         a = l;
	ld a, l
; 845         a &= (SCREEN_WIDTH - 1);
	and 63
; 846         a += 8;  // Смещение Радио 86РК
	add 8
; 847 
; 848         // Вычисление Y
; 849         hl += hl;
	add hl, hl
; 850         hl += hl;
	add hl, hl
; 851         h++;  // Смещение Радио 86РК
	inc h
; 852         h++;
	inc h
; 853         h++;
	inc h
; 854 
; 855         l = a;
	ld l, a
	pop af
	ret
; 856     }
; 857 }
; 858 
; 859 // Функция для пользовательской программы.
; 860 // Получить символ под курсором.
; 861 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 862 
; 863 void GetCursorChar() {
getcursorchar:
; 864     push_pop(hl) {
	push hl
; 865         hl = cursor;
	ld hl, (cursor)
; 866         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 867     }
; 868 }
; 869 
; 870 // Команда H
; 871 // Определить скорости записанной программы.
; 872 // Выводит 4 цифры на экран.
; 873 // Первые две цифры - константа вывода для команды O
; 874 // Последние две цифры - константа вввода для команды I
; 875 
; 876 void CmdH(...) {
cmdh:
; 877     PrintCrLfTab();
	call printcrlftab
; 878     hl = 65408;
	ld hl, 65408
; 879     b = 123;
	ld b, 123
; 880 
; 881     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 882 
; 883     do {
l_64:
l_65:
; 884     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_64
; 885 
; 886     do {
l_67:
; 887         c = a;
	ld c, a
; 888         do {
l_70:
; 889             hl++;
	inc hl
l_71:
; 890         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_70
l_68:
; 891     } while (flag_nz(b--));
	dec b
	jp nz, l_67
; 892 
; 893     hl += hl;
	add hl, hl
; 894     a = h;
	ld a, h
; 895     hl += hl;
	add hl, hl
; 896     l = (a += h);
	add h
	ld l, a
; 897 
; 898     PrintHexWordSpace();
	jp printhexwordspace
; 899 }
; 900 
; 901 // Команда I <смещение> <скорость>
; 902 // Загрузить файл с магнитной ленты
; 903 
; 904 void CmdI(...) {
cmdi:
; 905     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 906         tapeReadSpeed = a = e;
	jp z, l_73
	ld a, e
	ld (tapereadspeed), a
l_73:
; 907     ReadTapeFile();
	call readtapefile
; 908     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 909     swap(hl, de);
	ex hl, de
; 910     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 911     swap(hl, de);
	ex hl, de
; 912     push(bc);
	push bc
; 913     CalculateCheckSum();
	call calculatechecksum
; 914     h = b;
	ld h, b
; 915     l = c;
	ld l, c
; 916     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 917     pop(de);
	pop de
; 918     CompareHlDe(hl, de);
	call comparehlde
; 919     if (flag_z)
; 920         return;
	ret z
; 921     swap(hl, de);
	ex hl, de
; 922     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 923     MonitorError();
; 924 }
; 925 
; 926 void MonitorError() {
monitorerror:
; 927     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 928     Monitor2();
	jp monitor2
; 929 }
; 930 
; 931 // Функция для пользовательской программы.
; 932 // Загрузить файл с магнитной ленты.
; 933 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 934 
; 935 void ReadTapeFile(...) {
readtapefile:
; 936     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 937     push_pop(hl) {
	push hl
; 938         hl += bc;
	add hl, bc
; 939         swap(hl, de);
	ex hl, de
; 940         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 941     }
; 942     hl += bc;
	add hl, bc
; 943     swap(hl, de);
	ex hl, de
; 944 
; 945     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 946     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 947     if (flag_z)
; 948         return;
	ret z
; 949 
; 950     push_pop(hl) {
	push hl
; 951         ReadTapeBlock();
	call readtapeblock
; 952         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 953     }
; 954 }
; 955 
; 956 void ReadTapeWordNext() {
readtapewordnext:
; 957     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 958 }
; 959 
; 960 void ReadTapeWord(...) {
readtapeword:
; 961     ReadTapeByte(a);
	call readtapebyte
; 962     b = a;
	ld b, a
; 963     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 964     c = a;
	ld c, a
	ret
; 965 }
; 966 
; 967 void ReadTapeBlock(...) {
readtapeblock:
; 968     for (;;) {
l_76:
; 969         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 970         *hl = a;
	ld (hl), a
; 971         Loop();
	call loop
	jp l_76
; 972     }
; 973 }
; 974 
; 975 // Функция для пользовательской программы.
; 976 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 977 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 978 
; 979 void CalculateCheckSum(...) {
calculatechecksum:
; 980     bc = 0;
	ld bc, 0
; 981     for (;;) {
l_79:
; 982         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 983         push_pop(a) {
	push af
; 984             CompareHlDe(hl, de);
	call comparehlde
; 985             if (flag_z)
; 986                 return PopRet();
	jp z, popret
	pop af
; 987         }
; 988         a = b;
	ld a, b
; 989         carry_add(a, *hl);
	adc (hl)
; 990         b = a;
	ld b, a
; 991         Loop();
	call loop
	jp l_79
; 992     }
; 993 }
; 994 
; 995 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 996 // Сохранить блок данных на магнитную ленту
; 997 
; 998 void CmdO(...) {
cmdo:
; 999     if ((a = c) != 0)
	ld a, c
	or a
; 1000         tapeWriteSpeed = a;
	jp z, l_81
	ld (tapewritespeed), a
l_81:
; 1001     push_pop(hl) {
	push hl
; 1002         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 1003     }
; 1004     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1005     swap(hl, de);
	ex hl, de
; 1006     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1007     swap(hl, de);
	ex hl, de
; 1008     push_pop(hl) {
	push hl
; 1009         h = b;
	ld h, b
; 1010         l = c;
	ld l, c
; 1011         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1012     }
; 1013     WriteTapeFile(hl, de);
	jp writetapefile
; 1014 }
; 1015 
; 1016 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1017     push_pop(bc) {
	push bc
; 1018         PrintCrLfTab();
	call printcrlftab
; 1019         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1020     }
; 1021 }
; 1022 
; 1023 void PrintHexWordSpace(...) {
printhexwordspace:
; 1024     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1025     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1026 }
; 1027 
; 1028 void WriteTapeBlock(...) {
writetapeblock:
; 1029     for (;;) {
l_84:
; 1030         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1031         Loop();
	call loop
	jp l_84
; 1032     }
; 1033 }
; 1034 
; 1035 // Функция для пользовательской программы.
; 1036 // Запись файла на магнитную ленту.
; 1037 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1038 
; 1039 void WriteTapeFile(...) {
writetapefile:
; 1040     push(bc);
	push bc
; 1041     bc = 0;
	ld bc, 0
; 1042     do {
l_86:
; 1043         WriteTapeByte(c);
	call writetapebyte
; 1044         b--;
	dec b
; 1045         swap(hl, *sp);
	ex (sp), hl
; 1046         swap(hl, *sp);
	ex (sp), hl
l_87:
	jp nz, l_86
; 1047     } while (flag_nz);
; 1048     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1049     WriteTapeWord(hl);
	call writetapeword
; 1050     swap(hl, de);
	ex hl, de
; 1051     WriteTapeWord(hl);
	call writetapeword
; 1052     swap(hl, de);
	ex hl, de
; 1053     WriteTapeBlock(hl, de);
	call writetapeblock
; 1054     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1055     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1056     pop(hl);
	pop hl
; 1057     WriteTapeWord(hl);
; 1058 }
; 1059 
; 1060 void WriteTapeWord(...) {
writetapeword:
; 1061     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1062     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1063 }
; 1064 
; 1065 // Загрузка байта с магнитной ленты.
; 1066 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1067 // Результат: a = прочитанный байт.
; 1068 
; 1069 void ReadTapeByte(...) {
readtapebyte:
; 1070     push(hl, bc, de);
	push hl
	push bc
	push de
; 1071     d = a;
	ld d, a
; 1072     ReadTapeByteInternal(d);
; 1073 }
; 1074 
; 1075 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1076     c = 0;
	ld c, 0
; 1077     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1078     do {
l_89:
; 1079 retry:  // Сдвиг результата
retry:
; 1080         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1081         cyclic_rotate_left(a, 1);
	rlca
; 1082         c = a;
	ld c, a
; 1083 
; 1084         // Ожидание изменения бита
; 1085         h = 0;
	ld h, 0
; 1086         do {
l_92:
; 1087             h--;
	dec h
; 1088             if (flag_z)
; 1089                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_93:
; 1090         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_92
; 1091 
; 1092         // Сохранение бита
; 1093         c = (a |= c);
	or c
	ld c, a
; 1094 
; 1095         // Задержка
; 1096         d--;
	dec d
; 1097         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1098         if (flag_z)
; 1099             a -= 18;
	jp nz, l_95
	sub 18
l_95:
; 1100         b = a;
	ld b, a
; 1101         do {
l_97:
l_98:
; 1102         } while (flag_nz(b--));
	dec b
	jp nz, l_97
; 1103         d++;
	inc d
; 1104 
; 1105         // Новое значение бита
; 1106         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1107 
; 1108         // Режим поиска синхробайта
; 1109         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_100
; 1110             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_102
; 1111                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_103
l_102:
; 1112             } else {
; 1113                 if (a != ~TAPE_START)
	cp 65305
; 1114                     goto retry;
	jp nz, retry
; 1115                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_103:
; 1116             }
; 1117             d = 8 + 1;
	ld d, 9
l_100:
l_90:
; 1118         }
; 1119     } while (flag_nz(d--));
	dec d
	jp nz, l_89
; 1120     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1121     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1122 }
; 1123 
; 1124 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1125     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1126         return MonitorError();
	jp p, monitorerror
; 1127     CtrlC();
	call ctrlc
; 1128     ReadTapeByteInternal();
	jp readtapebyteinternal
; 1129 }
; 1130 
; 1131 // Функция для пользовательской программы.
; 1132 // Запись байта на магнитную ленту.
; 1133 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1134 
; 1135 void WriteTapeByte(...) {
writetapebyte:
; 1136     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1137         d = 8;
	ld d, 8
; 1138         do {
l_104:
; 1139             // Сдвиг исходного байта
; 1140             a = c;
	ld a, c
; 1141             cyclic_rotate_left(a, 1);
	rlca
; 1142             c = a;
	ld c, a
; 1143 
; 1144             // Вывод
; 1145             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1146             out(PORT_TAPE, a);
	out (1), a
; 1147 
; 1148             // Задержка
; 1149             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1150             do {
l_107:
; 1151                 b--;
	dec b
l_108:
	jp nz, l_107
; 1152             } while (flag_nz);
; 1153 
; 1154             // Вывод
; 1155             (a = 0) ^= c;
	ld a, 0
	xor c
; 1156             out(PORT_TAPE, a);
	out (1), a
; 1157 
; 1158             // Задержка
; 1159             d--;
	dec d
; 1160             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1161             if (flag_z)
; 1162                 a -= 14;
	jp nz, l_110
	sub 14
l_110:
; 1163             b = a;
	ld b, a
; 1164             do {
l_112:
; 1165                 b--;
	dec b
l_113:
	jp nz, l_112
; 1166             } while (flag_nz);
; 1167             d++;
	inc d
l_105:
; 1168         } while (flag_nz(d--));
	dec d
	jp nz, l_104
	pop af
	pop de
	pop bc
	ret
; 1169     }
; 1170 }
; 1171 
; 1172 // Функция для пользовательской программы.
; 1173 // Вывод 8 битного числа на экран.
; 1174 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1175 
; 1176 void PrintHexByte(...) {
printhexbyte:
; 1177     push_pop(a) {
	push af
; 1178         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1179         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1180     }
; 1181     PrintHexNibble(a);
; 1182 }
; 1183 
; 1184 void PrintHexNibble(...) {
printhexnibble:
; 1185     a &= 0x0F;
	and 15
; 1186     if (flag_p(compare(a, 10)))
	cp 10
; 1187         a += 'A' - '0' - 10;
	jp m, l_115
	add 7
l_115:
; 1188     a += '0';
	add 48
; 1189     PrintCharA(a);
; 1190 }
; 1191 
; 1192 // Вывод символа на экран.
; 1193 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1194 
; 1195 void PrintCharA(...) {
printchara:
; 1196     PrintChar(c = a);
	ld c, a
; 1197 }
; 1198 
; 1199 // Функция для пользовательской программы.
; 1200 // Вывод символа на экран.
; 1201 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1202 
; 1203 void PrintChar(...) {
printchar:
; 1204     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1205     hl = cursor;
	ld hl, (cursor)
; 1206     DrawCursor(hl);
	call drawcursor
; 1207     a = escState;
	ld a, (escstate)
; 1208     a--;
	dec a
; 1209     if (flag_m)
; 1210         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1211     if (flag_z)
; 1212         return PrintCharEsc();
	jp z, printcharesc
; 1213     a--;
	dec a
; 1214     if (flag_nz)
; 1215         return PrintCharEscY2();
	jp nz, printcharescy2
; 1216 
; 1217     // Первый параметр ESC Y
; 1218     a = c;
	ld a, c
; 1219     a -= ' ';
	sub 32
; 1220     if (flag_m) {
	jp p, l_117
; 1221         a ^= a;
	xor a
	jp l_118
l_117:
; 1222     } else {
; 1223         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 25
; 1224             a = SCREEN_HEIGHT - 1;
	jp m, l_119
	ld a, 24
l_119:
l_118:
; 1225     }
; 1226     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1227     c = a;
	ld c, a
; 1228     b = (a &= 192);
	and 192
	ld b, a
; 1229     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1230     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1231     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1232     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1233 }
; 1234 
; 1235 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1236     escState = a;
	ld (escstate), a
; 1237     PrintCharSaveCursor(hl);
; 1238 }
; 1239 
; 1240 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1241     cursor = hl;
	ld (cursor), hl
; 1242     PrintCharExit();
; 1243 }
; 1244 
; 1245 void PrintCharExit(...) {
printcharexit:
; 1246     DrawCursor(hl);
	call drawcursor
; 1247     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1248 }
; 1249 
; 1250 void DrawCursor(...) {
drawcursor:
; 1251     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1252         return;
	ret z
; 1253     d = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld d, a
; 1254     e = l;
	ld e, l
; 1255     a = *de;
	ld a, (de)
; 1256     a ^= SCREEN_ATTRIB_UNDERLINE;
	xor 128
; 1257     *de = a;
	ld (de), a
	ret
; 1258 }
; 1259 
; 1260 void PrintCharEscY2(...) {
printcharescy2:
; 1261     a = c;
	ld a, c
; 1262     a -= ' ';
	sub 32
; 1263     if (flag_m) {
	jp p, l_121
; 1264         a ^= a;
	xor a
	jp l_122
l_121:
; 1265     } else {
; 1266         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1267             a = SCREEN_WIDTH - 1;
	jp m, l_123
	ld a, 63
l_123:
l_122:
; 1268     }
; 1269     b = a;
	ld b, a
; 1270     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1271     PrintCharResetEscState();
; 1272 }
; 1273 
; 1274 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1275     a ^= a;
	xor a
; 1276     PrintCharSetEscState();
	jp printcharsetescstate
; 1277 }
; 1278 
; 1279 void PrintCharEsc(...) {
printcharesc:
; 1280     a = c;
	ld a, c
; 1281     if (a == 'Y') {
	cp 89
	jp nz, l_125
; 1282         a = 2;
	ld a, 2
; 1283         return PrintCharSetEscState();
	jp printcharsetescstate
l_125:
; 1284     }
; 1285     if (a == 97) {
	cp 97
	jp nz, l_127
; 1286         a ^= a;
	xor a
; 1287         return SetCursorVisible();
	jp setcursorvisible
l_127:
; 1288     }
; 1289     if (a != 98)
	cp 98
; 1290         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1291     SetCursorVisible();
; 1292 }
; 1293 
; 1294 void SetCursorVisible(...) {
setcursorvisible:
; 1295     cursorVisible = a;
	ld (cursorvisible), a
; 1296     PrintCharResetEscState();
	jp printcharresetescstate
; 1297 }
; 1298 
; 1299 void PrintCharNoEsc(...) {
printcharnoesc:
; 1300     // Остановка вывода нажатием УС + Шифт
; 1301     do {
l_129:
; 1302         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_130:
; 1303     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_129
; 1304 
; 1305 #ifdef CMD_A_ENABLED
; 1306     compare(a = 16, c);
; 1307     a = translateCodeEnabled;
; 1308     if (flag_z) {
; 1309         invert(a);
; 1310         translateCodeEnabled = a;
; 1311         return PrintCharSaveCursor();
; 1312     }
; 1313     if (a != 0)
; 1314         TranslateCodePage(c);
; 1315 #endif
; 1316     a = c;
	ld a, c
; 1317     if (a == 31)
	cp 31
; 1318         return ClearScreen();
	jp z, clearscreen
; 1319     if (flag_m)
; 1320         return PrintChar3(a);
	jp m, printchar3
; 1321     PrintChar4(a);
; 1322 }
; 1323 
; 1324 void PrintChar4(...) {
printchar4:
; 1325     *hl = a;
	ld (hl), a
; 1326     d = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld d, a
; 1327     e = l;
	ld e, l
; 1328     *de = a = color;
	ld a, (color)
	ld (de), a
; 1329     hl++;
	inc hl
; 1330     TryScrollUp(hl);
	jp tryscrollup
; 1331 }
; 1332 
; 1333 void ClearScreenInt(...) {
clearscreenint:
; 1334     do {
l_132:
; 1335         do {
l_135:
; 1336             *hl = 0;
	ld (hl), 0
; 1337             hl++;
	inc hl
; 1338             *de = a;
	ld (de), a
; 1339             de++;
	inc de
l_136:
; 1340         } while (flag_nz(c--));
	dec c
	jp nz, l_135
l_133:
; 1341     } while (flag_nz(b--));
	dec b
	jp nz, l_132
	ret
; 1342 }
; 1343 
; 1344 void ClearScreen() {
clearscreen:
; 1345     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1346     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1347     bc = 25 * SCREEN_WIDTH + 0x100;  // 25 строк
	ld bc, 1856
; 1348     a = color;
	ld a, (color)
; 1349     ClearScreenInt();
	call clearscreenint
; 1350     a = SCREEN_ATTRIB_BLANK;
	ld a, 7
; 1351     bc = 7 * SCREEN_WIDTH + 0x100;  // 7 строк
	ld bc, 704
; 1352     ClearScreenInt();
	call clearscreenint
; 1353     PrintKeyStatus();
	call printkeystatus
; 1354     MoveCursorHome();
; 1355 }
; 1356 
; 1357 void MoveCursorHome(...) {
movecursorhome:
; 1358     PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1359 }
; 1360 
; 1361 void PrintChar3(...) {
printchar3:
; 1362     if (a == 12)
	cp 12
; 1363         return MoveCursorHome();
	jp z, movecursorhome
; 1364     if (a == 13)
	cp 13
; 1365         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1366     if (a == 10)
	cp 10
; 1367         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1368     if (a == 8)
	cp 8
; 1369         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1370     if (a == 24)
	cp 24
; 1371         return MoveCursorRight(hl);
	jp z, movecursorright
; 1372     if (a == 25)
	cp 25
; 1373         return MoveCursorUp(hl);
	jp z, movecursorup
; 1374     if (a == 7)
	cp 7
; 1375 #ifdef BEEP_ENABLED
; 1376         return PrintCharBeep();
	jp z, printcharbeep
; 1377 #else
; 1378         return PrintCharExit();
; 1379 #endif
; 1380     if (a == 26)
	cp 26
; 1381         return MoveCursorDown();
	jp z, movecursordown
; 1382     if (a != 27)
	cp 27
; 1383         return PrintChar4(hl, a);
	jp nz, printchar4
; 1384     a = 1;
	ld a, 1
; 1385     PrintCharSetEscState();
	jp printcharsetescstate
; 1386 }
; 1387 
; 1388 #ifdef BEEP_ENABLED
; 1389 void PrintCharBeep(...) {
printcharbeep:
; 1390     bc = (32 << 8) | 128; // Частота, Длительность
	ld bc, 8320
; 1391     do {
l_138:
; 1392         e = b;
	ld e, b
; 1393         do {
l_141:
; 1394             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
	ld a, 15
	out (4), a
l_142:
; 1395         } while (flag_nz(e--));
	dec e
	jp nz, l_141
; 1396         e = b;
	ld e, b
; 1397         do {
l_144:
; 1398             out(PORT_KEYBOARD_MODE, a = (7 << 1));
	ld a, 14
	out (4), a
l_145:
; 1399         } while (flag_nz(e--));
	dec e
	jp nz, l_144
l_139:
; 1400     } while (flag_nz(c--));
	dec c
	jp nz, l_138
; 1401 
; 1402     PrintCharExit();
	jp printcharexit
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
; 1416 const int ZERO_LINE = (SCREEN_BEGIN >> 6) & 0xFF;
; 1417 
; 1418 void MoveCursorBoundary(...) {
movecursorboundary:
; 1419     push_pop(hl) {
	push hl
; 1420         hl += hl;
	add hl, hl
; 1421         hl += hl;
	add hl, hl
; 1422         a = h;
	ld a, h
	pop hl
; 1423     }
; 1424 
; 1425     if (a < ZERO_LINE)
	cp 160
; 1426         hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	jp nc, l_147
	ld de, 1600
	add hl, de
l_147:
; 1427 
; 1428     if (a >= SCREEN_HEIGHT + ZERO_LINE)
	cp 185
; 1429         hl += (de = -SCREEN_WIDTH * SCREEN_HEIGHT);
	jp c, l_149
	ld de, 63936
	add hl, de
l_149:
; 1430 
; 1431     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1432 }
; 1433 
; 1434 void MoveCursorLeft(...) {
movecursorleft:
; 1435     hl--;
	dec hl
; 1436     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1437 }
; 1438 
; 1439 void MoveCursorLf(...) {
movecursorlf:
; 1440     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1441     TryScrollUp(hl);
; 1442 }
; 1443 
; 1444 void TryScrollUp(...) {
tryscrollup:
; 1445     swap(hl, de);
	ex hl, de
; 1446     hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT);
	ld hl, 4544
; 1447     hl += de;
	add hl, de
; 1448     swap(hl, de);
	ex hl, de
; 1449     if (flag_nc)
; 1450         return PrintCharSaveCursor(hl);
	jp nc, printcharsavecursor
; 1451 
; 1452     push_pop(hl) {
	push hl
; 1453         hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1;
	ld hl, 60991
; 1454         c = SCREEN_WIDTH;
	ld c, 64
; 1455         do {
l_151:
; 1456             push_pop(hl) {
	push hl
; 1457                 de = SCREEN_SIZE - SCREEN_WIDTH;
	ld de, 1984
; 1458                 b = 0;
	ld b, 0
; 1459                 c = a = color;
	ld a, (color)
	ld c, a
; 1460                 do {
l_154:
; 1461                     a = b;
	ld a, b
; 1462                     b = *hl;
	ld b, (hl)
; 1463                     *hl = a;
	ld (hl), a
; 1464                     h = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld h, a
; 1465                     a = c;
	ld a, c
; 1466                     c = *hl;
	ld c, (hl)
; 1467                     *hl = a;
	ld (hl), a
; 1468                     hl += de;
	add hl, de
l_155:
; 1469                 } while ((a = h) != (SCREEN_BEGIN >> 8) - 1);
	ld a, h
	cp 65511
	jp nz, l_154
	pop hl
; 1470             }
; 1471             l--;
	dec l
l_152:
; 1472         } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
	ld a, l
	cp 60927
	jp nz, l_151
	pop hl
; 1473     }
; 1474     MoveCursorUp();
; 1475 }
; 1476 
; 1477 void MoveCursorUp(...) {
movecursorup:
; 1478     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1479 }
; 1480 
; 1481 void MoveCursor(...) {
movecursor:
; 1482     hl += bc;
	add hl, bc
; 1483     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1484 }
; 1485 
; 1486 void MoveCursorDown(...) {
movecursordown:
; 1487     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1488 }
; 1489 
; 1490 // Функция для пользовательской программы.
; 1491 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1492 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1493 
; 1494 void IsAnyKeyPressed() {
isanykeypressed:
; 1495     out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1496     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1497     invert(a);
	cpl
; 1498     a += a;
	add a
; 1499     if (flag_z)
; 1500         return;
	ret z
; 1501     a = 0xFF;
	ld a, 255
	ret
; 1502 }
; 1503 
; 1504 // Функция для пользовательской программы.
; 1505 // Получить код нажатой клавиши на клавиатуре.
; 1506 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1507 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1508 
; 1509 void ReadKey() {
readkey:
; 1510     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 1511 retry:
retry_1804289383:
; 1512         hl = keyDelay;
	ld hl, (keydelay)
; 1513         ReadKeyInternal(hl);
	call readkeyinternal
; 1514         l = 32;         // Задержка повтора нажатия клавиши
	ld l, 32
; 1515         if (flag_nz) {  // Не таймаут
	jp z, l_157
; 1516             do {
l_159:
; 1517                 do {
l_162:
; 1518                     l = 2;
	ld l, 2
; 1519                     ReadKeyInternal(hl);
	call readkeyinternal
l_163:
	jp nz, l_162
l_160:
; 1520                 } while (flag_nz);  // Цикл длится, пока не наступит таймаут
; 1521             } while (a == 255);     // Цикл длится, пока не нажата клавиша
	cp 255
	jp z, l_159
; 1522             l = 128;                // Задержка повтора первого нажатия клавиши
	ld l, 128
l_157:
; 1523         }
; 1524         keyDelay = hl;
	ld (keydelay), hl
; 1525 
; 1526         if (a == SCAN_RUS) {
	cp 54
	jp nz, l_165
; 1527             a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1528             carry_rotate_right(a, 3); // Shift
	rra
	rra
	rra
; 1529             a = KEYBOARD_MODE_CAP;
	ld a, 2
; 1530             carry_sub(a, 0); // KEYBOARD_MODE_CAP -> KEYBOARD_MODE_RUS
	sbc 0
; 1531             hl = &keyboardMode;
	ld hl, 0FFFFh & (keyboardmode)
; 1532             a ^= *hl;
	xor (hl)
; 1533             *hl = a;
	ld (hl), a
; 1534             PrintKeyStatus();
	call printkeystatus
; 1535             goto retry;
	jp retry_1804289383
l_165:
; 1536         }
; 1537         a = c;
	ld a, c
	pop hl
	pop de
	pop bc
	ret
; 1538     }
; 1539 }
; 1540 
; 1541 void ReadKeyInternal(...) {
readkeyinternal:
; 1542     do {
l_167:
; 1543         ScanKey();
	call scankey
; 1544         c = a;
	ld c, a
; 1545         a = keyCode;
	ld a, (keycode)
; 1546         if (a != h)
	cp h
; 1547             break;
	jp nz, l_169
; 1548 
; 1549         // Задержка
; 1550         a ^= a;
	xor a
; 1551         do {
l_170:
; 1552             swap(hl, de);
	ex hl, de
; 1553             swap(hl, de);
	ex hl, de
l_171:
; 1554         } while (flag_nz(a--));
	dec a
	jp nz, l_170
; 1555         a = h;
	ld a, h
l_168:
; 1556     } while (flag_nz(l--));
	dec l
	jp nz, l_167
l_169:
; 1557     h = a;
	ld h, a
	ret
; 1558 }
; 1559 
; 1560 // Функция для пользовательской программы.
; 1561 // Получить код нажатой клавиши на клавиатуре.
; 1562 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1563 
; 1564 void ScanKey() {
scankey:
; 1565     push(bc, de, hl);
	push bc
	push de
	push hl
; 1566 
; 1567     bc = 0xFEFE;
	ld bc, 65278
; 1568     do {
l_173:
; 1569         a = c;
	ld a, c
; 1570         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1571         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1572         invert(a);
	cpl
; 1573         a += a;
	add a
; 1574         if (flag_nz)
; 1575             return ScanKey2(a);
	jp nz, scankey2
; 1576         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
; 1577         a = c;
	ld a, c
; 1578         cyclic_rotate_left(a, 1);
	rlca
; 1579         c = a;
	ld c, a
l_174:
	jp c, l_173
; 1580     } while (flag_c);
; 1581 
; 1582     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1583     carry_rotate_right(a, 1);
	rra
; 1584     b++;
	inc b
; 1585     b++;
	inc b
; 1586     if (flag_nc)
; 1587         return ScanKey3(b);
	jp nc, scankey3
; 1588     keyCode = a = 0xFF;
	ld a, 255
	ld (keycode), a
; 1589     ScanKeyExit(a);
	jp scankeyexit
; 1590 }
; 1591 
; 1592 void ScanKey2(...) {
scankey2:
; 1593     do {
l_176:
; 1594         b++;
	inc b
; 1595         carry_rotate_right(a, 1);
	rra
l_177:
	jp nc, l_176
; 1596     } while (flag_nc);
; 1597     ScanKey3(b);
; 1598 }
; 1599 
; 1600 void ScanKey3(...) {
scankey3:
; 1601     // b - key number
; 1602 
; 1603     //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1604     //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1605     // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1606     // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1607     // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1608     // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1609     // 48   Space Right Left  Up    Down  Vk    Str   Home
; 1610 
; 1611     a = b;
	ld a, b
; 1612     keyCode = a;
	ld (keycode), a
; 1613     if (a >= 48)
	cp 48
; 1614         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1615     a += 48;
	add 48
; 1616     if (a >= 60)
	cp 60
; 1617         if (a < 64)
	jp c, l_179
	cp 64
; 1618             a &= 47;
	jp nc, l_181
	and 47
l_181:
l_179:
; 1619 
; 1620     c = a;
	ld c, a
; 1621 
; 1622     a = keyboardMode;
	ld a, (keyboardmode)
; 1623     carry_rotate_right(a, 1);
	rra
; 1624     d = a;
	ld d, a
; 1625     if (flag_c) { // KEYBOARD_MODE_RUS
	jp nc, l_183
; 1626         a = c;
	ld a, c
; 1627         a |= 0x20;
	or 32
; 1628         c = a;
	ld c, a
l_183:
; 1629     }
; 1630 
; 1631     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1632     carry_rotate_right(a, 2);
	rra
	rra
; 1633     if (flag_nc)
; 1634         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1635     carry_rotate_right(a, 1);
	rra
; 1636     a = c;
	ld a, c
; 1637     if (flag_nc) {
	jp c, l_185
; 1638         a ^= 0x10;
	xor 16
; 1639         if (a >= 64)
	cp 64
; 1640             a ^= 0x80 | 0x10;
	jp c, l_187
	xor 144
l_187:
l_185:
; 1641     }
; 1642     c = a;
	ld c, a
; 1643     a = d;
	ld a, d
; 1644     carry_rotate_right(a, 1);
	rra
; 1645     if (flag_c) { // KEYBOARD_MODE_CAP
	jp nc, l_189
; 1646         a = c;
	ld a, c
; 1647         a &= 0x7F;
	and 127
; 1648         if (a >= 0x60)  // Кириллица
	cp 96
; 1649             goto convert;
	jp nc, convert
; 1650         if (a >= 'A') {
	cp 65
	jp c, l_191
; 1651             if (a < 'Z' + 1) {
	cp 91
	jp nc, l_193
; 1652 convert:        a = c;
convert:
	ld a, c
; 1653                 a ^= 0x80;
	xor 128
; 1654                 c = a;
	ld c, a
l_193:
l_191:
l_189:
; 1655             }
; 1656         }
; 1657     }
; 1658     a = c;
	ld a, c
; 1659     ScanKeyExit(a);
; 1660 }
; 1661 
; 1662 void ScanKeyExit(...) {
scankeyexit:
; 1663     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1664 }
; 1665 
; 1666 void ScanKeyControl(...) {
scankeycontrol:
; 1667     a = c;
	ld a, c
; 1668     a &= 0x1F;
	and 31
; 1669     ScanKeyExit(a);
	jp scankeyexit
; 1670 }
; 1671 
; 1672 void ScanKeySpecial(...) {
scankeyspecial:
; 1673     h = (uintptr_t)specialKeyTable >> 8;
	ld h, 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) >> (8))
; 1674     l = (a += (uintptr_t)specialKeyTable - 48);
	add 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) - (48))
	ld l, a
; 1675     a = *hl;
	ld a, (hl)
; 1676     ScanKeyExit(a);
	jp scankeyexit
; 1677 }
; 1678 
; 1679 uint8_t specialKeyTable[] = {
specialkeytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
	db 127
; 1691  aPrompt[] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1692  aCrLfTab[] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1693  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1694  aBackspace[] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1695  aHello[] = "\x1FМИКРО 80\x1BБ";
ahello:
	db 31
	db 109
	db 105
	db 107
	db 114
	db 111
	db 32
	db 56
	db 48
	db 27
	db 98
	ds 1
; 1702  aZag[3] = "Заг";
azag:
	db 122
	db 225
	db 231
; 1703  aStr[3] = "Стр";
astr:
	db 115
	db 244
	db 242
; 1704  aLat[3] = "Лат";
alat:
	db 108
	db 225
	db 244
; 1705  aRus[3] = "Рус";
arus:
	db 114
	db 245
	db 243
; 1707  PrintKeyStatus() {
printkeystatus:
; 1708     bc = SCREEN_BEGIN + 56 + 31 * SCREEN_WIDTH;
	ld bc, 61432
; 1709     a = keyboardMode;
	ld a, (keyboardmode)
; 1710     hl = aLat;
	ld hl, 0FFFFh & (alat)
; 1711     PrintKeyStatusInt(a, bc, hl);
	call printkeystatusint
; 1712     bc++;
	inc bc
; 1713     l = aZag;
	ld l, 0FFh & (azag)
; 1714     PrintKeyStatusInt(a, bc, hl);
; 1715 }
; 1716 
; 1717 void PrintKeyStatusInt(...) {
printkeystatusint:
; 1718     de = sizeof(aZag);
	ld de, 3
; 1719     cyclic_rotate_right(a, 1);
	rrca
; 1720     if (flag_c)
; 1721         hl += de;
	jp nc, l_195
	add hl, de
l_195:
; 1722     d = a;
	ld d, a
; 1723     do {
l_197:
; 1724         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 1725         bc++;
	inc bc
; 1726         hl++;
	inc hl
l_198:
; 1727     } while (flag_nz(e--));
	dec e
	jp nz, l_197
; 1728     a = d;
	ld a, d
	ret
 savebin "micro80.bin", 0xF800, 0x10000
