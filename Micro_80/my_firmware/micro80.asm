    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst30opcode equ 48
rst30address equ 49
rst38opcode equ 56
rst38address equ 57
keybuffer equ 63318
keycode equ 63319
keyboardmode equ 63320
color equ 63321
cursor equ 63322
tapereadspeed equ 63324
tapewritespeed equ 63325
cursorvisible equ 63326
escstate equ 63327
keydelay equ 63328
keylast equ 63329
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
; 66  uint8_t rst30Opcode __address(0x30);
; 67 extern uint16_t rst30Address __address(0x31);
; 68 extern uint8_t rst38Opcode __address(0x38);
; 69 extern uint16_t rst38Address __address(0x39);
; 70 
; 71 // Прототипы
; 72 void Reboot(...);
; 73 void EntryF86C_Monitor(...);
; 74 void Monitor(...);
; 75 void Monitor2();
; 76 void ReadString(...);
; 77 void PrintString(...);
; 78 void ParseParams(...);
; 79 void ParseWord(...);
; 80 void CompareHlDe(...);
; 81 void LoopWithBreak(...);
; 82 void Loop(...);
; 83 void PopRet();
; 84 void IncHl(...);
; 85 void CtrlC(...);
; 86 void PrintCrLfTab();
; 87 void PrintHexByteFromHlSpace(...);
; 88 void PrintHexByteSpace(...);
; 89 #ifdef CMD_R_ENABLED
; 90 void CmdR(...);
; 91 #endif
; 92 void GetRamTop(...);
; 93 void SetRamTop(...);
; 94 #ifdef CMD_A_ENABLED
; 95 void CmdA(...);
; 96 #endif
; 97 void CmdD(...);
; 98 void PrintSpacesTo(...);
; 99 void PrintSpace();
; 100 void CmdC(...);
; 101 void CmdF(...);
; 102 void CmdS(...);
; 103 void CmdW(...);
; 104 void CmdT(...);
; 105 void CmdM(...);
; 106 void CmdG(...);
; 107 void BreakPointHandler(...);
; 108 void CmdX(...);
; 109 void GetCursor();
; 110 void GetCursorChar();
; 111 void CmdH(...);
; 112 void CmdI(...);
; 113 void MonitorError();
; 114 void ReadTapeFile(...);
; 115 void ReadTapeWordNext();
; 116 void ReadTapeWord(...);
; 117 void ReadTapeBlock(...);
; 118 void CalculateCheckSum(...);
; 119 void CmdO(...);
; 120 void WriteTapeFile(...);
; 121 void PrintCrLfTabHexWordSpace(...);
; 122 void PrintHexWordSpace(...);
; 123 void WriteTapeBlock(...);
; 124 void WriteTapeWord(...);
; 125 void ReadTapeByte(...);
; 126 void ReadTapeByteInternal(...);
; 127 void ReadTapeByteTimeout(...);
; 128 void WriteTapeByte(...);
; 129 void PrintHexByte(...);
; 130 void PrintHexNibble(...);
; 131 void PrintCharA(...);
; 132 void PrintChar(...);
; 133 void PrintCharSetEscState(...);
; 134 void PrintCharSaveCursor(...);
; 135 void PrintCharExit(...);
; 136 void DrawCursor(...);
; 137 void PrintCharEscY2(...);
; 138 void PrintCharResetEscState(...);
; 139 void PrintCharEsc(...);
; 140 void SetCursorVisible(...);
; 141 void PrintCharNoEsc(...);
; 142 void PrintChar4(...);
; 143 void ClearScreen(...);
; 144 void MoveCursorHome(...);
; 145 void PrintChar3(...);
; 146 void PrintCharBeep(...);
; 147 void MoveCursorCr(...);
; 148 void MoveCursorRight(...);
; 149 void MoveCursorBoundary(...);
; 150 void MoveCursorLeft(...);
; 151 void MoveCursorLf(...);
; 152 void MoveCursorUp(...);
; 153 void MoveCursor(...);
; 154 void MoveCursorDown(...);
; 155 void IsAnyKeyPressed();
; 156 void IsAnyKeyPressed2();
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
; 174 extern uint8_t keyBuffer __address(0xF756);
; 175 extern uint8_t keyCode __address(0xF757);
; 176 extern uint8_t keyboardMode __address(0xF758);
; 177 extern uint8_t color __address(0xF759);
; 178 extern uint16_t cursor __address(0xF75A);
; 179 extern uint8_t tapeReadSpeed __address(0xF75C);
; 180 extern uint8_t tapeWriteSpeed __address(0xF75D);
; 181 extern uint8_t cursorVisible __address(0xF75E);
; 182 extern uint8_t escState __address(0xF75F);
; 183 extern uint16_t keyDelay __address(0xF760);
; 184 extern uint16_t keyLast __address(0xF761);
; 185 extern uint16_t regPC __address(0xF762);
; 186 extern uint16_t regHL __address(0xF764);
; 187 extern uint16_t regBC __address(0xF766);
; 188 extern uint16_t regDE __address(0xF768);
; 189 extern uint16_t regSP __address(0xF76A);
; 190 extern uint16_t regAF __address(0xF76C);
; 191 extern uint16_t breakPointAddress __address(0xF771);
; 192 extern uint8_t breakPointValue __address(0xF773);
; 193 extern uint8_t jmpParam1Opcode __address(0xF774);
; 194 extern uint16_t param1 __address(0xF775);
; 195 extern uint16_t param2 __address(0xF777);
; 196 extern uint16_t param3 __address(0xF779);
; 197 extern uint8_t param2Exists __address(0xF77B);
; 198 extern uint8_t tapePolarity __address(0xF77C);
; 199 #ifdef CMD_A_ENABLED
; 200 extern uint8_t translateCodeEnabled __address(0xF77D);
; 201 extern uint8_t translateCodePageJump __address(0xF77E);
; 202 extern uint16_t translateCodePageAddress __address(0xF77F);
; 203 #endif
; 204 extern uint16_t ramTop __address(0xF781);
; 205 extern uint8_t inputBuffer[32] __address(0xF783);
; 206 
; 207 #define firstVariableAddress (&keyBuffer)
; 208 #define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])
; 209 
; 210 extern uint8_t specialKeyTable[9];
; 211 extern uint8_t aPrompt[6];
; 212 extern uint8_t aCrLfTab[6];
; 213 extern uint8_t aRegisters[37];
; 214 extern uint8_t aBackspace[4];
; 215 extern uint8_t aHello[12];
; 216 
; 217 // Для удобства
; 218 
; 219 void JmpParam1() __address(0xF774);
; 220 #ifdef CMD_A_ENABLED
; 221 void TranslateCodePage() __address(0xF77E);
; 222 #endif
; 223 
; 224 // Точки входа
; 225 
; 226 void EntryF800_Reboot() {
entryf800_reboot:
; 227     Reboot();
	jp reboot
; 228 }
; 229 
; 230 void EntryF803_ReadKey() {
entryf803_readkey:
; 231     ReadKey();
	jp readkey
; 232 }
; 233 
; 234 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 235     ReadTapeByte(a);
	jp readtapebyte
; 236 }
; 237 
; 238 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 239     PrintChar(c);
	jp printchar
; 240 }
; 241 
; 242 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 243     WriteTapeByte(c);
	jp writetapebyte
; 244 }
; 245 
; 246 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 247 #ifdef CMD_A_ENABLED
; 248     TranslateCodePage(c);
; 249 #else
; 250     return;
	ret
; 251     return;
	ret
; 252     return;
	ret
; 253 #endif
; 254 }
; 255 
; 256 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 257     IsAnyKeyPressed();
	jp isanykeypressed
; 258 }
; 259 
; 260 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 261     PrintHexByte(a);
	jp printhexbyte
; 262 }
; 263 
; 264 void EntryF818_PrintString(...) {
entryf818_printstring:
; 265     PrintString(hl);
	jp printstring
; 266 }
; 267 
; 268 void EntryF81B_ScanKey() {
entryf81b_scankey:
; 269     ScanKey();
	jp scankey
; 270 }
; 271 
; 272 void EntryF81E_GetCursor() {
entryf81e_getcursor:
; 273     GetCursor();
	jp getcursor
; 274 }
; 275 
; 276 void EntryF821_GetCursorChar() {
entryf821_getcursorchar:
; 277     GetCursorChar();
	jp getcursorchar
; 278 }
; 279 
; 280 void EntryF824_ReadTapeFile(...) {
entryf824_readtapefile:
; 281     ReadTapeFile(hl);
	jp readtapefile
; 282 }
; 283 
; 284 void EntryF827_WriteTapeFile(...) {
entryf827_writetapefile:
; 285     WriteTapeFile(bc, de, hl);
	jp writetapefile
; 286 }
; 287 
; 288 void EntryF82A_CalculateCheckSum(...) {
entryf82a_calculatechecksum:
; 289     CalculateCheckSum(hl, de);
	jp calculatechecksum
; 290 }
; 291 
; 292 void EntryF82D_EnableScreen() {
entryf82d_enablescreen:
; 293     return;
	ret
; 294     return;
	ret
; 295     return;
	ret
; 296 }
; 297 
; 298 void EntryF830_GetRamTop() {
entryf830_getramtop:
; 299     GetRamTop();
	jp getramtop
; 300 }
; 301 
; 302 void EntryF833_SetRamTop(...) {
entryf833_setramtop:
; 303     SetRamTop(hl);
	jp setramtop
; 304 }
; 305 
; 306 void EntryF836_InitMonitor(...) {
entryf836_initmonitor:
; 307     // Очистка памяти
; 308     hl = firstVariableAddress;
	ld hl, 0FFFFh & (keybuffer)
; 309     de = lastVariableAddress;
	ld de, 0FFFFh & ((inputbuffer) + (31))
; 310     c = 0;
	ld c, 0
; 311     CmdF();
	call cmdf
; 312 
; 313     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 23
	ld (color), a
; 314 #ifdef CMD_A_ENABLED
; 315     translateCodePageJump = a = OPCODE_JMP;
; 316 #endif
; 317 
; 318     PrintString(hl = aHello);
	ld hl, 0FFFFh & (ahello)
	call printstring
; 319 
; 320     ramTop = hl = SCREEN_ATTRIB_BEGIN - 1;
	ld hl, 57343
	ld (ramtop), hl
; 321     tapeReadSpeed = hl = TAPE_SPEED;
	ld hl, 14420
	ld (tapereadspeed), hl
; 322 #ifdef CMD_A_ENABLED
; 323     translateCodePageAddress = hl = &TranslateCodePageDefault;
; 324 #endif
; 325     regSP = hl = STACK_TOP - 2;
	ld hl, 63486
	ld (regsp), hl
; 326     
; 327     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
	ret
; 328 }
; 329 
; 330 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 331 // Параметры: нет. Функция никогда не завершается.
; 332 
; 333 void Reboot(...) {
reboot:
; 334     disable_interrupts();
	di
; 335     sp = STACK_TOP;
	ld sp, 63488
; 336     EntryF836_InitMonitor();
	call entryf836_initmonitor
; 337     asm(" nop");
 nop
; 338     asm(" nop");
 nop
	ret
 .org 0xF86C
; 339 }
; 340 
; 341 asm(" .org 0xF86C");
; 342 
; 343 void EntryF86C_Monitor() {
entryf86c_monitor:
; 344     Monitor();
; 345 }
; 346 
; 347 void Monitor() {
monitor:
; 348     out(PORT_KEYBOARD_MODE, a = 0x83);
	ld a, 131
	out (4), a
; 349     jmpParam1Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (jmpparam1opcode), a
; 350     Monitor2();
; 351 }
; 352 
; 353 void Monitor2() {
monitor2:
; 354     sp = STACK_TOP;
	ld sp, 63488
; 355     PrintString(hl = aPrompt);
	ld hl, 0FFFFh & (aprompt)
	call printstring
; 356 
; 357     ReadString();
	call readstring
; 358 
; 359     push(hl = &EntryF86C_Monitor);
	ld hl, 0FFFFh & (entryf86c_monitor)
	push hl
; 360 
; 361     hl = inputBuffer;
	ld hl, 0FFFFh & (inputbuffer)
; 362     a = *hl;
	ld a, (hl)
; 363     a &= 0x7F;
	and 127
; 364 
; 365     if (a == 'X')
	cp 88
; 366         return CmdX();
	jp z, cmdx
; 367 
; 368     push_pop(a) {
	push af
; 369         ParseParams();
	call parseparams
; 370         hl = param3;
	ld hl, (param3)
; 371         c = l;
	ld c, l
; 372         b = h;
	ld b, h
; 373         hl = param2;
	ld hl, (param2)
; 374         swap(hl, de);
	ex hl, de
; 375         hl = param1;
	ld hl, (param1)
	pop af
; 376     }
; 377 
; 378     if (a == 'D')
	cp 68
; 379         return CmdD();
	jp z, cmdd
; 380     if (a == 'C')
	cp 67
; 381         return CmdC();
	jp z, cmdc
; 382     if (a == 'F')
	cp 70
; 383         return CmdF();
	jp z, cmdf
; 384     if (a == 'S')
	cp 83
; 385         return CmdS();
	jp z, cmds
; 386     if (a == 'T')
	cp 84
; 387         return CmdT();
	jp z, cmdt
; 388     if (a == 'M')
	cp 77
; 389         return CmdM();
	jp z, cmdm
; 390     if (a == 'G')
	cp 71
; 391         return CmdG();
	jp z, cmdg
; 392     if (a == 'I')
	cp 73
; 393         return CmdI();
	jp z, cmdi
; 394     if (a == 'O')
	cp 79
; 395         return CmdO();
	jp z, cmdo
; 396     if (a == 'W')
	cp 87
; 397         return CmdW();
	jp z, cmdw
; 398 #ifdef CMD_A_ENABLED
; 399     if (a == 'A')
; 400         return CmdA();
; 401 #endif
; 402     if (a == 'H')
	cp 72
; 403         return CmdH();
	jp z, cmdh
; 404 #ifdef CMD_R_ENABLED
; 405     if (a == 'R')
; 406         return CmdR();
; 407 #endif
; 408     MonitorError();
	jp monitorerror
; 409 }
; 410 
; 411 void ReadString() {
readstring:
; 412     de = inputBuffer;
	ld de, 0FFFFh & (inputbuffer)
; 413     h = d;
	ld h, d
; 414     l = e;
	ld l, e
; 415     for (;;) {
l_1:
; 416         ReadKey();
	call readkey
; 417         if (a == KEY_BACKSPACE) {
	cp 127
	jp nz, l_3
; 418             if ((a = e) == l)
	ld a, e
	cp l
; 419                 continue;
	jp z, l_1
; 420             hl--;
	dec hl
; 421             push_pop(hl) {
	push hl
; 422                 PrintString(hl = aBackspace);
	ld hl, 0FFFFh & (abackspace)
	call printstring
	pop hl
; 423             }
; 424             continue;
	jp l_1
l_3:
; 425         }
; 426         *hl = a;
	ld (hl), a
; 427         if (a == 13) {
	cp 13
	jp nz, l_5
; 428             if ((a = e) != l)
	ld a, e
	cp l
; 429                 set_flag_c();
	jp z, l_7
	scf
l_7:
; 430             return;
	ret
l_5:
; 431         }
; 432         if (a == '.')
	cp 46
; 433             return Monitor2();
	jp z, monitor2
; 434         if (a < 32)
	cp 32
; 435             a = '.';
	jp nc, l_9
	ld a, 46
l_9:
; 436         PrintCharA(a);
	call printchara
; 437         if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
	ld a, 0FFh & (((inputbuffer) + (32)) - (1))
	cp l
; 438             return MonitorError();
	jp z, monitorerror
; 439         hl++;
	inc hl
	jp l_1
; 440     }
; 441 }
; 442 
; 443 // Функция для пользовательской программы.
; 444 // Вывод строки на экран.
; 445 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.
; 446 
; 447 void PrintString(...) {
printstring:
; 448     for (;;) {
l_12:
; 449         a = *hl;
	ld a, (hl)
; 450         if (a == 0)
	or a
; 451             return;
	ret z
; 452         PrintCharA(a);
	call printchara
; 453         hl++;
	inc hl
	jp l_12
; 454     }
; 455 }
; 456 
; 457 void ParseParams(...) {
parseparams:
; 458     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 459     de = &param2Exists;
	ld de, 0FFFFh & (param2exists)
; 460     c = 0;
	ld c, 0
; 461     CmdF();
	call cmdf
; 462 
; 463     de = inputBuffer + 1;
	ld de, 0FFFFh & ((inputbuffer) + (1))
; 464 
; 465     ParseWord();
	call parseword
; 466     param1 = hl;
	ld (param1), hl
; 467     param2 = hl;
	ld (param2), hl
; 468     if (flag_c)
; 469         return;
	ret c
; 470 
; 471     param2Exists = a = d; /* Not 0 */
	ld a, d
	ld (param2exists), a
; 472     ParseWord();
	call parseword
; 473     param2 = hl;
	ld (param2), hl
; 474     if (flag_c)
; 475         return;
	ret c
; 476 
; 477     ParseWord();
	call parseword
; 478     param3 = hl;
	ld (param3), hl
; 479     if (flag_c)
; 480         return;
	ret c
; 481 
; 482     MonitorError();
	jp monitorerror
; 483 }
; 484 
; 485 void ParseWord(...) {
parseword:
; 486     hl = 0;
	ld hl, 0
; 487     for (;;) {
l_15:
; 488         a = *de;
	ld a, (de)
; 489         compare(a, 13);
	cp 13
; 490         set_flag_c();
	scf
; 491         if (flag_z)
; 492             return;
	ret z
; 493         de++;
	inc de
; 494         if (a == ',')
	cp 44
; 495             return;
	ret z
; 496         if (a == ' ')
	cp 32
; 497             continue;
	jp z, l_15
; 498         push(bc = &MonitorError);
	ld bc, 0FFFFh & (monitorerror)
	push bc
; 499         a &= 0x7F;
	and 127
; 500         a -= '0';
	sub 48
; 501         if (flag_c)
; 502             return;
	ret c
; 503         if (a >= 10) {
	cp 10
	jp c, l_17
; 504             if (a < 17)
	cp 17
; 505                 return;
	ret c
; 506             if (a >= 23)
	cp 23
; 507                 return;
	ret nc
; 508             a -= 7;
	sub 7
l_17:
; 509         }
; 510         hl += hl;
	add hl, hl
; 511         if (flag_c)
; 512             return;
	ret c
; 513         hl += hl;
	add hl, hl
; 514         if (flag_c)
; 515             return;
	ret c
; 516         hl += hl;
	add hl, hl
; 517         if (flag_c)
; 518             return;
	ret c
; 519         hl += hl;
	add hl, hl
; 520         if (flag_c)
; 521             return;
	ret c
; 522         b = 0;
	ld b, 0
; 523         c = a;
	ld c, a
; 524         hl += bc;
	add hl, bc
; 525         pop(bc);
	pop bc
	jp l_15
; 526     }
; 527 }
; 528 
; 529 void CompareHlDe(...) {
comparehlde:
; 530     if ((a = h) != d)
	ld a, h
	cp d
; 531         return;
	ret nz
; 532     compare(a = l, e);
	ld a, l
	cp e
	ret
; 533 }
; 534 
; 535 void LoopWithBreak(...) {
loopwithbreak:
; 536     CtrlC();
	call ctrlc
; 537     Loop(hl, de);
; 538 }
; 539 
; 540 void Loop(...) {
loop:
; 541     CompareHlDe(hl, de);
	call comparehlde
; 542     if (flag_nz)
; 543         return IncHl(hl);
	jp nz, inchl
; 544     PopRet();
; 545 }
; 546 
; 547 void PopRet() {
popret:
; 548     sp++;
	inc sp
; 549     sp++;
	inc sp
	ret
; 550 }
; 551 
; 552 void IncHl(...) {
inchl:
; 553     hl++;
	inc hl
	ret
; 554 }
; 555 
; 556 void CtrlC() {
ctrlc:
; 557     ScanKey();
	call scankey
; 558     if (a != 3)  // УПР + C
	cp 3
; 559         return;
	ret nz
; 560     MonitorError();
	jp monitorerror
; 561 }
; 562 
; 563 void PrintCrLfTab() {
printcrlftab:
; 564     push_pop(hl) {
	push hl
; 565         PrintString(hl = aCrLfTab);
	ld hl, 0FFFFh & (acrlftab)
	call printstring
	pop hl
	ret
; 566     }
; 567 }
; 568 
; 569 void PrintHexByteFromHlSpace(...) {
printhexbytefromhlspace:
; 570     PrintHexByteSpace(a = *hl);
	ld a, (hl)
; 571 }
; 572 
; 573 void PrintHexByteSpace(...) {
printhexbytespace:
; 574     push_pop(bc) {
	push bc
; 575         PrintHexByte(a);
	call printhexbyte
; 576         PrintSpace();
	call printspace
	pop bc
	ret
; 577     }
; 578 }
; 579 
; 580 #ifdef CMD_R_ENABLED
; 581 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
; 582 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
; 583 
; 584 void CmdR(...) {
; 585     out(PORT_EXT_MODE, a = 0x90);
; 586     for (;;) {
; 587         out(PORT_EXT_ADDR_LOW, a = l);
; 588         out(PORT_EXT_ADDR_HIGH, a = h);
; 589         *bc = a = in(PORT_EXT_DATA);
; 590         bc++;
; 591         Loop();
; 592     }
; 593 }
; 594 #endif
; 595 
; 596 // Функция для пользовательской программы.
; 597 // Получить адрес последнего доступного байта оперативной памяти.
; 598 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
; 599 
; 600 void GetRamTop(...) {
getramtop:
; 601     hl = ramTop;
	ld hl, (ramtop)
	ret
; 602 }
; 603 
; 604 // Функция для пользовательской программы.
; 605 // Установить адрес последнего доступного байта оперативной памяти.
; 606 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
; 607 
; 608 void SetRamTop(...) {
setramtop:
; 609     ramTop = hl;
	ld (ramtop), hl
	ret
; 610 }
; 611 
; 612 #ifdef CMD_A_ENABLED
; 613 // Команда A <адрес>
; 614 // Установить программу преобразования кодировки символов выводимых на экран
; 615 
; 616 void CmdA(...) {
; 617     translateCodePageAddress = hl;
; 618 }
; 619 #endif
; 620 
; 621 // Команда D <начальный адрес> <конечный адрес>
; 622 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
; 623 
; 624 void CmdD(...) {
cmdd:
; 625     for (;;) {
l_20:
; 626         PrintChar(c = 13);
	ld c, 13
	call printchar
; 627         PrintChar(c = 10);
	ld c, 10
	call printchar
; 628         PrintHexWordSpace(hl);
	call printhexwordspace
; 629         push_pop(hl) {
	push hl
; 630             c = ((a = l) &= 0x0F);
	ld a, l
	and 15
	ld c, a
; 631             carry_rotate_right(a, 1);
	rra
; 632             b = (((a += c) += c) += 5);
	add c
	add c
	add 5
	ld b, a
; 633             PrintSpacesTo();
	call printspacesto
; 634             do {
l_22:
; 635                 PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 636                 CompareHlDe(hl, de);
	call comparehlde
; 637                 hl++;
	inc hl
; 638                 if (flag_z)
; 639                     break;
	jp z, l_24
; 640                 (a = l) &= 0x0F;
	ld a, l
	and 15
; 641                 push_pop(a) {
	push af
; 642                     a &= 1;
	and 1
; 643                     if (flag_z)
; 644                         PrintSpace();
	call z, printspace
	pop af
l_23:
	jp nz, l_22
l_24:
	pop hl
; 645                 }
; 646             } while (flag_nz);
; 647         }
; 648 
; 649         b = (((a = l) &= 0x0F) += 46);
	ld a, l
	and 15
	add 46
	ld b, a
; 650         PrintSpacesTo(b);
	call printspacesto
; 651 
; 652         do {
l_25:
; 653             a = *hl;
	ld a, (hl)
; 654             if (a < 32)
	cp 32
; 655                 a = '.';
	jp nc, l_28
	ld a, 46
l_28:
; 656             PrintCharA(a);
	call printchara
; 657             CompareHlDe(hl, de);
	call comparehlde
; 658             if (flag_z)
; 659                 return;
	ret z
; 660             hl++;
	inc hl
; 661             (a = l) &= 0x0F;
	ld a, l
	and 15
l_26:
	jp nz, l_25
	jp l_20
; 662         } while (flag_nz);
; 663     }
; 664 }
; 665 
; 666 void PrintSpacesTo(...) {
printspacesto:
; 667     for (;;) {
l_31:
; 668         if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
	ld a, (cursor)
	and 63
	cp b
; 669             return;
	ret nc
; 670         PrintSpace();
	call printspace
	jp l_31
; 671     }
; 672 }
; 673 
; 674 void PrintSpace() {
printspace:
; 675     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 676 }
; 677 
; 678 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
; 679 // Сравнить два блока адресного пространство
; 680 
; 681 void CmdC(...) {
cmdc:
; 682     for (;;) {
l_34:
; 683         if ((a = *bc) != *hl) {
	ld a, (bc)
	cp (hl)
	jp z, l_36
; 684             PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 685             PrintHexByteFromHlSpace(hl);
	call printhexbytefromhlspace
; 686             PrintHexByteSpace(a = *bc);
	ld a, (bc)
	call printhexbytespace
l_36:
; 687         }
; 688         bc++;
	inc bc
; 689         LoopWithBreak();
	call loopwithbreak
	jp l_34
; 690     }
; 691 }
; 692 
; 693 // Команда F <начальный адрес> <конечный адрес> <байт>
; 694 // Заполнить блок в адресном пространстве одним байтом
; 695 
; 696 void CmdF(...) {
cmdf:
; 697     for (;;) {
l_39:
; 698         *hl = c;
	ld (hl), c
; 699         Loop();
	call loop
	jp l_39
; 700     }
; 701 }
; 702 
; 703 // Команда S <начальный адрес> <конечный адрес> <байт>
; 704 // Найти байт (8 битное значение) в адресном пространстве
; 705 
; 706 void CmdS(...) {
cmds:
; 707     for (;;) {
l_42:
; 708         if ((a = c) == *hl)
	ld a, c
	cp (hl)
; 709             PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
; 710         LoopWithBreak();
	call loopwithbreak
	jp l_42
; 711     }
; 712 }
; 713 
; 714 // Команда W <начальный адрес> <конечный адрес> <слово>
; 715 // Найти слово (16 битное значение) в адресном пространстве
; 716 
; 717 void CmdW(...) {
cmdw:
; 718     for (;;) {
l_45:
; 719         if ((a = *hl) == c) {
	ld a, (hl)
	cp c
	jp nz, l_47
; 720             hl++;
	inc hl
; 721             compare((a = *hl), b);
	ld a, (hl)
	cp b
; 722             hl--;
	dec hl
; 723             if (flag_z)
; 724                 PrintCrLfTabHexWordSpace(hl);
	call z, printcrlftabhexwordspace
l_47:
; 725         }
; 726         LoopWithBreak();
	call loopwithbreak
	jp l_45
; 727     }
; 728 }
; 729 
; 730 // Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
; 731 // Копировать блок в адресном пространстве
; 732 
; 733 void CmdT(...) {
cmdt:
; 734     for (;;) {
l_50:
; 735         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 736         bc++;
	inc bc
; 737         Loop();
	call loop
	jp l_50
; 738     }
; 739 }
; 740 
; 741 // Команда M <начальный адрес>
; 742 // Вывести на экран адресное пространство побайтно с возможностью изменения
; 743 
; 744 void CmdM(...) {
cmdm:
; 745     for (;;) {
l_53:
; 746         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 747         PrintHexByteFromHlSpace();
	call printhexbytefromhlspace
; 748         push_pop(hl) {
	push hl
; 749             ReadString();
	call readstring
	pop hl
; 750         }
; 751         if (flag_c) {
	jp nc, l_55
; 752             push_pop(hl) {
	push hl
; 753                 ParseWord();
	call parseword
; 754                 a = l;
	ld a, l
	pop hl
; 755             }
; 756             *hl = a;
	ld (hl), a
l_55:
; 757         }
; 758         hl++;
	inc hl
	jp l_53
; 759     }
; 760 }
; 761 
; 762 // Команда G <начальный адрес> <конечный адрес>
; 763 // Запуск программы и возможным указанием точки останова.
; 764 
; 765 void CmdG(...) {
cmdg:
; 766     CompareHlDe(hl, de);
	call comparehlde
; 767     if (flag_nz) {
	jp z, l_57
; 768         swap(hl, de);
	ex hl, de
; 769         breakPointAddress = hl;
	ld (breakpointaddress), hl
; 770         breakPointValue = a = *hl;
	ld a, (hl)
	ld (breakpointvalue), a
; 771         *hl = OPCODE_RST_30;
	ld (hl), 247
; 772         rst30Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst30opcode), a
; 773         rst30Address = hl = &BreakPointHandler;
	ld hl, 0FFFFh & (breakpointhandler)
	ld (rst30address), hl
l_57:
; 774     }
; 775     sp = &regBC;
	ld sp, 0FFFFh & (regbc)
; 776     pop(bc);
	pop bc
; 777     pop(de);
	pop de
; 778     pop(hl);
	pop hl
; 779     pop(a);
	pop af
; 780     sp = hl;
	ld sp, hl
; 781     hl = regHL;
	ld hl, (reghl)
; 782     JmpParam1();
	jp jmpparam1
; 783 }
; 784 
; 785 void BreakPointHandler(...) {
breakpointhandler:
; 786     regHL = hl;
	ld (reghl), hl
; 787     push(a);
	push af
; 788     pop(hl);
	pop hl
; 789     regAF = hl;
	ld (regaf), hl
; 790     pop(hl);
	pop hl
; 791     hl--;
	dec hl
; 792     regPC = hl;
	ld (regpc), hl
; 793     (hl = 0) += sp;
	ld hl, 0
	add hl, sp
; 794     sp = &regAF;
	ld sp, 0FFFFh & (regaf)
; 795     push(hl);
	push hl
; 796     push(de);
	push de
; 797     push(bc);
	push bc
; 798     sp = STACK_TOP;
	ld sp, 63488
; 799     hl = regPC;
	ld hl, (regpc)
; 800     swap(hl, de);
	ex hl, de
; 801     hl = breakPointAddress;
	ld hl, (breakpointaddress)
; 802     CompareHlDe(hl, de);
	call comparehlde
; 803     if (flag_nz)
; 804         return CmdX();
	jp nz, cmdx
; 805     *hl = a = breakPointValue;
	ld a, (breakpointvalue)
	ld (hl), a
; 806     CmdX();
; 807 }
; 808 
; 809 // Команда X
; 810 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
; 811 
; 812 void CmdX(...) {
cmdx:
; 813     PrintString(hl = aRegisters);
	ld hl, 0FFFFh & (aregisters)
	call printstring
; 814     hl = &regPC;
	ld hl, 0FFFFh & (regpc)
; 815     b = 6;
	ld b, 6
; 816     do {
l_59:
; 817         e = *hl;
	ld e, (hl)
; 818         hl++;
	inc hl
; 819         d = *hl;
	ld d, (hl)
; 820         push(bc);
	push bc
; 821         push(hl);
	push hl
; 822         swap(hl, de);
	ex hl, de
; 823         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 824         ReadString();
	call readstring
; 825         if (flag_c) {
	jp nc, l_62
; 826             ParseWord();
	call parseword
; 827             pop(de);
	pop de
; 828             push(de);
	push de
; 829             swap(hl, de);
	ex hl, de
; 830             *hl = d;
	ld (hl), d
; 831             hl--;
	dec hl
; 832             *hl = e;
	ld (hl), e
l_62:
; 833         }
; 834         pop(hl);
	pop hl
; 835         pop(bc);
	pop bc
; 836         b--;
	dec b
; 837         hl++;
	inc hl
l_60:
	jp nz, l_59
; 838     } while (flag_nz);
; 839     EntryF86C_Monitor();
	jp entryf86c_monitor
; 840 }
; 841 
; 842 // Функция для пользовательской программы.
; 843 // Получить координаты курсора.
; 844 // Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.
; 845 
; 846 void GetCursor() {
getcursor:
; 847     push_pop(a) {
	push af
; 848         hl = cursor;
	ld hl, (cursor)
; 849         h = ((a = h) &= 7);
	ld a, h
	and 7
	ld h, a
; 850 
; 851         // Вычисление X
; 852         a = l;
	ld a, l
; 853         a &= (SCREEN_WIDTH - 1);
	and 63
; 854         a += 8;  // Смещение Радио 86РК
	add 8
; 855 
; 856         // Вычисление Y
; 857         hl += hl;
	add hl, hl
; 858         hl += hl;
	add hl, hl
; 859         h++;  // Смещение Радио 86РК
	inc h
; 860         h++;
	inc h
; 861         h++;
	inc h
; 862 
; 863         l = a;
	ld l, a
	pop af
	ret
; 864     }
; 865 }
; 866 
; 867 // Функция для пользовательской программы.
; 868 // Получить символ под курсором.
; 869 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
; 870 
; 871 void GetCursorChar() {
getcursorchar:
; 872     push_pop(hl) {
	push hl
; 873         hl = cursor;
	ld hl, (cursor)
; 874         a = *hl;
	ld a, (hl)
	pop hl
	ret
; 875     }
; 876 }
; 877 
; 878 // Команда H
; 879 // Определить скорости записанной программы.
; 880 // Выводит 4 цифры на экран.
; 881 // Первые две цифры - константа вывода для команды O
; 882 // Последние две цифры - константа вввода для команды I
; 883 
; 884 void CmdH(...) {
cmdh:
; 885     PrintCrLfTab();
	call printcrlftab
; 886     hl = 65408;
	ld hl, 65408
; 887     b = 123;
	ld b, 123
; 888 
; 889     c = a = in(PORT_TAPE);
	in a, (1)
	ld c, a
; 890 
; 891     do {
l_64:
l_65:
; 892     } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_64
; 893 
; 894     do {
l_67:
; 895         c = a;
	ld c, a
; 896         do {
l_70:
; 897             hl++;
	inc hl
l_71:
; 898         } while ((a = in(PORT_TAPE)) == c);
	in a, (1)
	cp c
	jp z, l_70
l_68:
; 899     } while (flag_nz(b--));
	dec b
	jp nz, l_67
; 900 
; 901     hl += hl;
	add hl, hl
; 902     a = h;
	ld a, h
; 903     hl += hl;
	add hl, hl
; 904     l = (a += h);
	add h
	ld l, a
; 905 
; 906     PrintHexWordSpace();
	jp printhexwordspace
; 907 }
; 908 
; 909 // Команда I <смещение> <скорость>
; 910 // Загрузить файл с магнитной ленты
; 911 
; 912 void CmdI(...) {
cmdi:
; 913     if ((a = param2Exists) != 0)
	ld a, (param2exists)
	or a
; 914         tapeReadSpeed = a = e;
	jp z, l_73
	ld a, e
	ld (tapereadspeed), a
l_73:
; 915     ReadTapeFile();
	call readtapefile
; 916     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 917     swap(hl, de);
	ex hl, de
; 918     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 919     swap(hl, de);
	ex hl, de
; 920     push(bc);
	push bc
; 921     CalculateCheckSum();
	call calculatechecksum
; 922     h = b;
	ld h, b
; 923     l = c;
	ld l, c
; 924     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 925     pop(de);
	pop de
; 926     CompareHlDe(hl, de);
	call comparehlde
; 927     if (flag_z)
; 928         return;
	ret z
; 929     swap(hl, de);
	ex hl, de
; 930     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 931     MonitorError();
; 932 }
; 933 
; 934 void MonitorError() {
monitorerror:
; 935     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 936     Monitor2();
	jp monitor2
; 937 }
; 938 
; 939 // Функция для пользовательской программы.
; 940 // Загрузить файл с магнитной ленты.
; 941 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
; 942 
; 943 void ReadTapeFile(...) {
readtapefile:
; 944     ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
; 945     push_pop(hl) {
	push hl
; 946         hl += bc;
	add hl, bc
; 947         swap(hl, de);
	ex hl, de
; 948         ReadTapeWordNext();
	call readtapewordnext
	pop hl
; 949     }
; 950     hl += bc;
	add hl, bc
; 951     swap(hl, de);
	ex hl, de
; 952 
; 953     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 954     a &= KEYBOARD_SHIFT_MOD;
	and 4
; 955     if (flag_z)
; 956         return;
	ret z
; 957 
; 958     push_pop(hl) {
	push hl
; 959         ReadTapeBlock();
	call readtapeblock
; 960         ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapeword
	pop hl
	ret
; 961     }
; 962 }
; 963 
; 964 void ReadTapeWordNext() {
readtapewordnext:
; 965     ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 966 }
; 967 
; 968 void ReadTapeWord(...) {
readtapeword:
; 969     ReadTapeByte(a);
	call readtapebyte
; 970     b = a;
	ld b, a
; 971     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 972     c = a;
	ld c, a
	ret
; 973 }
; 974 
; 975 void ReadTapeBlock(...) {
readtapeblock:
; 976     for (;;) {
l_76:
; 977         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 978         *hl = a;
	ld (hl), a
; 979         Loop();
	call loop
	jp l_76
; 980     }
; 981 }
; 982 
; 983 // Функция для пользовательской программы.
; 984 // Вычистить 16-битную сумму всех байт по адресам hl..de.
; 985 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
; 986 
; 987 void CalculateCheckSum(...) {
calculatechecksum:
; 988     bc = 0;
	ld bc, 0
; 989     for (;;) {
l_79:
; 990         c = ((a = *hl) += c);
	ld a, (hl)
	add c
	ld c, a
; 991         push_pop(a) {
	push af
; 992             CompareHlDe(hl, de);
	call comparehlde
; 993             if (flag_z)
; 994                 return PopRet();
	jp z, popret
	pop af
; 995         }
; 996         a = b;
	ld a, b
; 997         carry_add(a, *hl);
	adc (hl)
; 998         b = a;
	ld b, a
; 999         Loop();
	call loop
	jp l_79
; 1000     }
; 1001 }
; 1002 
; 1003 // Команда O <начальный адрес> <конечный адрес> <скорость>
; 1004 // Сохранить блок данных на магнитную ленту
; 1005 
; 1006 void CmdO(...) {
cmdo:
; 1007     if ((a = c) != 0)
	ld a, c
	or a
; 1008         tapeWriteSpeed = a;
	jp z, l_81
	ld (tapewritespeed), a
l_81:
; 1009     push_pop(hl) {
	push hl
; 1010         CalculateCheckSum(hl, de);
	call calculatechecksum
	pop hl
; 1011     }
; 1012     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1013     swap(hl, de);
	ex hl, de
; 1014     PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
; 1015     swap(hl, de);
	ex hl, de
; 1016     push_pop(hl) {
	push hl
; 1017         h = b;
	ld h, b
; 1018         l = c;
	ld l, c
; 1019         PrintCrLfTabHexWordSpace(hl);
	call printcrlftabhexwordspace
	pop hl
; 1020     }
; 1021     WriteTapeFile(hl, de);
	jp writetapefile
; 1022 }
; 1023 
; 1024 void PrintCrLfTabHexWordSpace(...) {
printcrlftabhexwordspace:
; 1025     push_pop(bc) {
	push bc
; 1026         PrintCrLfTab();
	call printcrlftab
; 1027         PrintHexWordSpace(hl);
	call printhexwordspace
	pop bc
	ret
; 1028     }
; 1029 }
; 1030 
; 1031 void PrintHexWordSpace(...) {
printhexwordspace:
; 1032     PrintHexByte(a = h);
	ld a, h
	call printhexbyte
; 1033     PrintHexByteSpace(a = l);
	ld a, l
	jp printhexbytespace
; 1034 }
; 1035 
; 1036 void WriteTapeBlock(...) {
writetapeblock:
; 1037     for (;;) {
l_84:
; 1038         WriteTapeByte(c = *hl);
	ld c, (hl)
	call writetapebyte
; 1039         Loop();
	call loop
	jp l_84
; 1040     }
; 1041 }
; 1042 
; 1043 // Функция для пользовательской программы.
; 1044 // Запись файла на магнитную ленту.
; 1045 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
; 1046 
; 1047 void WriteTapeFile(...) {
writetapefile:
; 1048     push(bc);
	push bc
; 1049     bc = 0;
	ld bc, 0
; 1050     do {
l_86:
; 1051         WriteTapeByte(c);
	call writetapebyte
; 1052         b--;
	dec b
; 1053         swap(hl, *sp);
	ex (sp), hl
; 1054         swap(hl, *sp);
	ex (sp), hl
l_87:
	jp nz, l_86
; 1055     } while (flag_nz);
; 1056     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1057     WriteTapeWord(hl);
	call writetapeword
; 1058     swap(hl, de);
	ex hl, de
; 1059     WriteTapeWord(hl);
	call writetapeword
; 1060     swap(hl, de);
	ex hl, de
; 1061     WriteTapeBlock(hl, de);
	call writetapeblock
; 1062     WriteTapeWord(hl = 0);
	ld hl, 0
	call writetapeword
; 1063     WriteTapeByte(c = TAPE_START);
	ld c, 230
	call writetapebyte
; 1064     pop(hl);
	pop hl
; 1065     WriteTapeWord(hl);
; 1066 }
; 1067 
; 1068 void WriteTapeWord(...) {
writetapeword:
; 1069     WriteTapeByte(c = h);
	ld c, h
	call writetapebyte
; 1070     WriteTapeByte(c = l);
	ld c, l
	jp writetapebyte
; 1071 }
; 1072 
; 1073 // Загрузка байта с магнитной ленты.
; 1074 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
; 1075 // Результат: a = прочитанный байт.
; 1076 
; 1077 void ReadTapeByte(...) {
readtapebyte:
; 1078     push(hl, bc, de);
	push hl
	push bc
	push de
; 1079     d = a;
	ld d, a
; 1080     ReadTapeByteInternal(d);
; 1081 }
; 1082 
; 1083 void ReadTapeByteInternal(...) {
readtapebyteinternal:
; 1084     c = 0;
	ld c, 0
; 1085     e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1086     do {
l_89:
; 1087 retry:  // Сдвиг результата
retry:
; 1088         (a = c) &= 0x7F;
	ld a, c
	and 127
; 1089         cyclic_rotate_left(a, 1);
	rlca
; 1090         c = a;
	ld c, a
; 1091 
; 1092         // Ожидание изменения бита
; 1093         h = 0;
	ld h, 0
; 1094         do {
l_92:
; 1095             h--;
	dec h
; 1096             if (flag_z)
; 1097                 return ReadTapeByteTimeout(d);
	jp z, readtapebytetimeout
l_93:
; 1098         } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);
	in a, (1)
	and 1
	cp e
	jp z, l_92
; 1099 
; 1100         // Сохранение бита
; 1101         c = (a |= c);
	or c
	ld c, a
; 1102 
; 1103         // Задержка
; 1104         d--;
	dec d
; 1105         a = tapeReadSpeed;
	ld a, (tapereadspeed)
; 1106         if (flag_z)
; 1107             a -= 18;
	jp nz, l_95
	sub 18
l_95:
; 1108         b = a;
	ld b, a
; 1109         do {
l_97:
l_98:
; 1110         } while (flag_nz(b--));
	dec b
	jp nz, l_97
; 1111         d++;
	inc d
; 1112 
; 1113         // Новое значение бита
; 1114         e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
	in a, (1)
	and 1
	ld e, a
; 1115 
; 1116         // Режим поиска синхробайта
; 1117         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_100
; 1118             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_102
; 1119                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_103
l_102:
; 1120             } else {
; 1121                 if (a != ~TAPE_START)
	cp 65305
; 1122                     goto retry;
	jp nz, retry
; 1123                 tapePolarity = a = 255;
	ld a, 255
	ld (tapepolarity), a
l_103:
; 1124             }
; 1125             d = 8 + 1;
	ld d, 9
l_100:
l_90:
; 1126         }
; 1127     } while (flag_nz(d--));
	dec d
	jp nz, l_89
; 1128     (a = tapePolarity) ^= c;
	ld a, (tapepolarity)
	xor c
; 1129     pop(hl, bc, de);
	pop de
	pop bc
	pop hl
	ret
; 1130 }
; 1131 
; 1132 void ReadTapeByteTimeout(...) {
readtapebytetimeout:
; 1133     if (flag_p((a = d) |= a))
	ld a, d
	or a
; 1134         return MonitorError();
	jp p, monitorerror
; 1135     CtrlC();
	call ctrlc
; 1136     ReadTapeByteInternal();
	jp readtapebyteinternal
; 1137 }
; 1138 
; 1139 // Функция для пользовательской программы.
; 1140 // Запись байта на магнитную ленту.
; 1141 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
; 1142 
; 1143 void WriteTapeByte(...) {
writetapebyte:
; 1144     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1145         d = 8;
	ld d, 8
; 1146         do {
l_104:
; 1147             // Сдвиг исходного байта
; 1148             a = c;
	ld a, c
; 1149             cyclic_rotate_left(a, 1);
	rlca
; 1150             c = a;
	ld c, a
; 1151 
; 1152             // Вывод
; 1153             (a = PORT_TAPE_BIT) ^= c;
	ld a, 1
	xor c
; 1154             out(PORT_TAPE, a);
	out (1), a
; 1155 
; 1156             // Задержка
; 1157             b = a = tapeWriteSpeed;
	ld a, (tapewritespeed)
	ld b, a
; 1158             do {
l_107:
; 1159                 b--;
	dec b
l_108:
	jp nz, l_107
; 1160             } while (flag_nz);
; 1161 
; 1162             // Вывод
; 1163             (a = 0) ^= c;
	ld a, 0
	xor c
; 1164             out(PORT_TAPE, a);
	out (1), a
; 1165 
; 1166             // Задержка
; 1167             d--;
	dec d
; 1168             a = tapeWriteSpeed;
	ld a, (tapewritespeed)
; 1169             if (flag_z)
; 1170                 a -= 14;
	jp nz, l_110
	sub 14
l_110:
; 1171             b = a;
	ld b, a
; 1172             do {
l_112:
; 1173                 b--;
	dec b
l_113:
	jp nz, l_112
; 1174             } while (flag_nz);
; 1175             d++;
	inc d
l_105:
; 1176         } while (flag_nz(d--));
	dec d
	jp nz, l_104
	pop af
	pop de
	pop bc
	ret
; 1177     }
; 1178 }
; 1179 
; 1180 // Функция для пользовательской программы.
; 1181 // Вывод 8 битного числа на экран.
; 1182 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
; 1183 
; 1184 void PrintHexByte(...) {
printhexbyte:
; 1185     push_pop(a) {
	push af
; 1186         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 1187         PrintHexNibble(a);
	call printhexnibble
	pop af
; 1188     }
; 1189     PrintHexNibble(a);
; 1190 }
; 1191 
; 1192 void PrintHexNibble(...) {
printhexnibble:
; 1193     a &= 0x0F;
	and 15
; 1194     if (flag_p(compare(a, 10)))
	cp 10
; 1195         a += 'A' - '0' - 10;
	jp m, l_115
	add 7
l_115:
; 1196     a += '0';
	add 48
; 1197     PrintCharA(a);
; 1198 }
; 1199 
; 1200 // Вывод символа на экран.
; 1201 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
; 1202 
; 1203 void PrintCharA(...) {
printchara:
; 1204     PrintChar(c = a);
	ld c, a
; 1205 }
; 1206 
; 1207 // Функция для пользовательской программы.
; 1208 // Вывод символа на экран.
; 1209 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
; 1210 
; 1211 void PrintChar(...) {
printchar:
; 1212     push(a, bc, de, hl);
	push af
	push bc
	push de
	push hl
; 1213     hl = cursor;
	ld hl, (cursor)
; 1214     DrawCursor(hl);
	call drawcursor
; 1215     a = escState;
	ld a, (escstate)
; 1216     a--;
	dec a
; 1217     if (flag_m)
; 1218         return PrintCharNoEsc();
	jp m, printcharnoesc
; 1219     if (flag_z)
; 1220         return PrintCharEsc();
	jp z, printcharesc
; 1221     a--;
	dec a
; 1222     if (flag_nz)
; 1223         return PrintCharEscY2();
	jp nz, printcharescy2
; 1224 
; 1225     // Первый параметр ESC Y
; 1226     a = c;
	ld a, c
; 1227     a -= ' ';
	sub 32
; 1228     if (flag_m) {
	jp p, l_117
; 1229         a ^= a;
	xor a
	jp l_118
l_117:
; 1230     } else {
; 1231         if (flag_p(compare(a, SCREEN_HEIGHT)))
	cp 25
; 1232             a = SCREEN_HEIGHT - 1;
	jp m, l_119
	ld a, 24
l_119:
l_118:
; 1233     }
; 1234     cyclic_rotate_right(a, 2);
	rrca
	rrca
; 1235     c = a;
	ld c, a
; 1236     b = (a &= 192);
	and 192
	ld b, a
; 1237     l = (((a = l) &= 63) |= b);
	ld a, l
	and 63
	or b
	ld l, a
; 1238     b = ((a = c) &= 7);
	ld a, c
	and 7
	ld b, a
; 1239     h = (((a = h) &= 248) |= b);
	ld a, h
	and 248
	or b
	ld h, a
; 1240     PrintCharSetEscState(hl, a = 3);
	ld a, 3
; 1241 }
; 1242 
; 1243 void PrintCharSetEscState(...) {
printcharsetescstate:
; 1244     escState = a;
	ld (escstate), a
; 1245     PrintCharSaveCursor(hl);
; 1246 }
; 1247 
; 1248 void PrintCharSaveCursor(...) {
printcharsavecursor:
; 1249     cursor = hl;
	ld (cursor), hl
; 1250     PrintCharExit();
; 1251 }
; 1252 
; 1253 void PrintCharExit(...) {
printcharexit:
; 1254     DrawCursor(hl);
	call drawcursor
; 1255     pop(a, bc, de, hl);
	pop hl
	pop de
	pop bc
	pop af
	ret
; 1256 }
; 1257 
; 1258 void DrawCursor(...) {
drawcursor:
; 1259     if ((a = cursorVisible) == 0)
	ld a, (cursorvisible)
	or a
; 1260         return;
	ret z
; 1261     d = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld d, a
; 1262     e = l;
	ld e, l
; 1263     a = *de;
	ld a, (de)
; 1264     a ^= SCREEN_ATTRIB_UNDERLINE;
	xor 128
; 1265     *de = a;
	ld (de), a
	ret
; 1266 }
; 1267 
; 1268 void PrintCharEscY2(...) {
printcharescy2:
; 1269     a = c;
	ld a, c
; 1270     a -= ' ';
	sub 32
; 1271     if (flag_m) {
	jp p, l_121
; 1272         a ^= a;
	xor a
	jp l_122
l_121:
; 1273     } else {
; 1274         if (flag_p(compare(a, SCREEN_WIDTH)))
	cp 64
; 1275             a = SCREEN_WIDTH - 1;
	jp m, l_123
	ld a, 63
l_123:
l_122:
; 1276     }
; 1277     b = a;
	ld b, a
; 1278     l = (((a = l) &= 192) |= b);
	ld a, l
	and 192
	or b
	ld l, a
; 1279     PrintCharResetEscState();
; 1280 }
; 1281 
; 1282 void PrintCharResetEscState(...) {
printcharresetescstate:
; 1283     a ^= a;
	xor a
; 1284     PrintCharSetEscState();
	jp printcharsetescstate
; 1285 }
; 1286 
; 1287 void PrintCharEsc(...) {
printcharesc:
; 1288     a = c;
	ld a, c
; 1289     if (a == 'Y') {
	cp 89
	jp nz, l_125
; 1290         a = 2;
	ld a, 2
; 1291         return PrintCharSetEscState();
	jp printcharsetescstate
l_125:
; 1292     }
; 1293     if (a == 97) {
	cp 97
	jp nz, l_127
; 1294         a ^= a;
	xor a
; 1295         return SetCursorVisible();
	jp setcursorvisible
l_127:
; 1296     }
; 1297     if (a != 98)
	cp 98
; 1298         return PrintCharResetEscState();
	jp nz, printcharresetescstate
; 1299     SetCursorVisible();
; 1300 }
; 1301 
; 1302 void SetCursorVisible(...) {
setcursorvisible:
; 1303     cursorVisible = a;
	ld (cursorvisible), a
; 1304     PrintCharResetEscState();
	jp printcharresetescstate
; 1305 }
; 1306 
; 1307 void PrintCharNoEsc(...) {
printcharnoesc:
; 1308     // Остановка вывода нажатием УС + Шифт
; 1309     do {
l_129:
; 1310         a = in(PORT_KEYBOARD_MODS);
	in a, (5)
l_130:
; 1311     } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));
	and 6
	jp z, l_129
; 1312 
; 1313 #ifdef CMD_A_ENABLED
; 1314     compare(a = 16, c);
; 1315     a = translateCodeEnabled;
; 1316     if (flag_z) {
; 1317         invert(a);
; 1318         translateCodeEnabled = a;
; 1319         return PrintCharSaveCursor();
; 1320     }
; 1321     if (a != 0)
; 1322         TranslateCodePage(c);
; 1323 #endif
; 1324     a = c;
	ld a, c
; 1325     if (a == 31)
	cp 31
; 1326         return ClearScreen();
	jp z, clearscreen
; 1327     if (flag_m)
; 1328         return PrintChar3(a);
	jp m, printchar3
; 1329     PrintChar4(a);
; 1330 }
; 1331 
; 1332 void PrintChar4(...) {
printchar4:
; 1333     *hl = a;
	ld (hl), a
; 1334     d = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld d, a
; 1335     e = l;
	ld e, l
; 1336     *de = a = color;
	ld a, (color)
	ld (de), a
; 1337     hl++;
	inc hl
; 1338     TryScrollUp(hl);
	jp tryscrollup
; 1339 }
; 1340 
; 1341 void ClearScreenInt(...) {
clearscreenint:
; 1342     do {
l_132:
; 1343         do {
l_135:
; 1344             *hl = 0;
	ld (hl), 0
; 1345             hl++;
	inc hl
; 1346             *de = a;
	ld (de), a
; 1347             de++;
	inc de
l_136:
; 1348         } while (flag_nz(c--));
	dec c
	jp nz, l_135
l_133:
; 1349     } while (flag_nz(b--));
	dec b
	jp nz, l_132
	ret
; 1350 }
; 1351 
; 1352 void ClearScreen() {
clearscreen:
; 1353     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1354     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1355     bc = 25 * SCREEN_WIDTH + 0x100;  // 25 строк
	ld bc, 1856
; 1356     a = color;
	ld a, (color)
; 1357     ClearScreenInt();
	call clearscreenint
; 1358     a = SCREEN_ATTRIB_BLANK;
	ld a, 7
; 1359     bc = 7 * SCREEN_WIDTH + 0x100;  // 7 строк
	ld bc, 704
; 1360     ClearScreenInt();
	call clearscreenint
; 1361     PrintKeyStatus();
	call printkeystatus
; 1362     MoveCursorHome();
; 1363 }
; 1364 
; 1365 void MoveCursorHome(...) {
movecursorhome:
; 1366     PrintCharSaveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp printcharsavecursor
; 1367 }
; 1368 
; 1369 void PrintChar3(...) {
printchar3:
; 1370     if (a == 12)
	cp 12
; 1371         return MoveCursorHome();
	jp z, movecursorhome
; 1372     if (a == 13)
	cp 13
; 1373         return MoveCursorCr(hl);
	jp z, movecursorcr
; 1374     if (a == 10)
	cp 10
; 1375         return MoveCursorLf(hl);
	jp z, movecursorlf
; 1376     if (a == 8)
	cp 8
; 1377         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1378     if (a == 24)
	cp 24
; 1379         return MoveCursorRight(hl);
	jp z, movecursorright
; 1380     if (a == 25)
	cp 25
; 1381         return MoveCursorUp(hl);
	jp z, movecursorup
; 1382     if (a == 7)
	cp 7
; 1383 #ifdef BEEP_ENABLED
; 1384         return PrintCharBeep();
; 1385 #else
; 1386         return PrintCharExit();
	jp z, printcharexit
; 1387 #endif
; 1388     if (a == 26)
	cp 26
; 1389         return MoveCursorDown();
	jp z, movecursordown
; 1390     if (a != 27)
	cp 27
; 1391         return PrintChar4(hl, a);
	jp nz, printchar4
; 1392     a = 1;
	ld a, 1
; 1393     PrintCharSetEscState();
	jp printcharsetescstate
; 1394 }
; 1395 
; 1396 #ifdef BEEP_ENABLED
; 1397 void PrintCharBeep(...) {
; 1398     bc = (32 << 8) | 128; // Частота, Длительность
; 1399     do {
; 1400         e = b;
; 1401         do {
; 1402             out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
; 1403         } while (flag_nz(e--));
; 1404         e = b;
; 1405         do {
; 1406             out(PORT_KEYBOARD_MODE, a = (7 << 1));
; 1407         } while (flag_nz(e--));
; 1408     } while (flag_nz(c--));
; 1409 
; 1410     PrintCharExit();
; 1411 }
; 1412 #endif
; 1413 
; 1414 void MoveCursorCr(...) {
movecursorcr:
; 1415     l = ((a = l) &= ~(SCREEN_WIDTH - 1));
	ld a, l
	and 192
	ld l, a
; 1416     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1417 }
; 1418 
; 1419 void MoveCursorRight(...) {
movecursorright:
; 1420     hl++;
	inc hl
; 1421     MoveCursorBoundary(hl);
; 1422 }
; 1423 
; 1424 const int ZERO_LINE = (SCREEN_BEGIN >> 6) & 0xFF;
; 1425 
; 1426 void MoveCursorBoundary(...) {
movecursorboundary:
; 1427     push_pop(hl) {
	push hl
; 1428         hl += hl;
	add hl, hl
; 1429         hl += hl;
	add hl, hl
; 1430         a = h;
	ld a, h
	pop hl
; 1431     }
; 1432 
; 1433     if (a < ZERO_LINE)
	cp 160
; 1434         hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	jp nc, l_138
	ld de, 1600
	add hl, de
l_138:
; 1435 
; 1436     if (a >= SCREEN_HEIGHT + ZERO_LINE)
	cp 185
; 1437         hl += (de = -SCREEN_WIDTH * SCREEN_HEIGHT);
	jp c, l_140
	ld de, 63936
	add hl, de
l_140:
; 1438 
; 1439     PrintCharSaveCursor(hl);
	jp printcharsavecursor
; 1440 }
; 1441 
; 1442 void MoveCursorLeft(...) {
movecursorleft:
; 1443     hl--;
	dec hl
; 1444     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1445 }
; 1446 
; 1447 void MoveCursorLf(...) {
movecursorlf:
; 1448     hl += (bc = SCREEN_WIDTH);
	ld bc, 64
	add hl, bc
; 1449     TryScrollUp(hl);
; 1450 }
; 1451 
; 1452 void TryScrollUp(...) {
tryscrollup:
; 1453     swap(hl, de);
	ex hl, de
; 1454     hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT);
	ld hl, 4544
; 1455     hl += de;
	add hl, de
; 1456     swap(hl, de);
	ex hl, de
; 1457     if (flag_nc)
; 1458         return PrintCharSaveCursor(hl);
	jp nc, printcharsavecursor
; 1459 
; 1460     push_pop(hl) {
	push hl
; 1461         hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1;
	ld hl, 60991
; 1462         c = SCREEN_WIDTH;
	ld c, 64
; 1463         do {
l_142:
; 1464             push_pop(hl) {
	push hl
; 1465                 de = SCREEN_SIZE - SCREEN_WIDTH;
	ld de, 1984
; 1466                 b = 0;
	ld b, 0
; 1467                 c = a = color;
	ld a, (color)
	ld c, a
; 1468                 do {
l_145:
; 1469                     a = b;
	ld a, b
; 1470                     b = *hl;
	ld b, (hl)
; 1471                     *hl = a;
	ld (hl), a
; 1472                     h = ((a = h) -= (SCREEN_SIZE >> 8));
	ld a, h
	sub 8
	ld h, a
; 1473                     a = c;
	ld a, c
; 1474                     c = *hl;
	ld c, (hl)
; 1475                     *hl = a;
	ld (hl), a
; 1476                     hl += de;
	add hl, de
l_146:
; 1477                 } while ((a = h) != (SCREEN_BEGIN >> 8) - 1);
	ld a, h
	cp 65511
	jp nz, l_145
	pop hl
; 1478             }
; 1479             l--;
	dec l
l_143:
; 1480         } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
	ld a, l
	cp 60927
	jp nz, l_142
	pop hl
; 1481     }
; 1482     MoveCursorUp();
; 1483 }
; 1484 
; 1485 void MoveCursorUp(...) {
movecursorup:
; 1486     MoveCursor(hl, bc = -SCREEN_WIDTH);
	ld bc, 65472
; 1487 }
; 1488 
; 1489 void MoveCursor(...) {
movecursor:
; 1490     hl += bc;
	add hl, bc
; 1491     MoveCursorBoundary(hl);
	jp movecursorboundary
; 1492 }
; 1493 
; 1494 void MoveCursorDown(...) {
movecursordown:
; 1495     MoveCursor(hl, bc = SCREEN_WIDTH);
	ld bc, 64
	jp movecursor
; 1496 }
; 1497 
; 1498 // Функция для пользовательской программы.
; 1499 // 1) Эта функция вызывается из CP/M при выводе каждого символа.
; 1500 // 2) Эта функция вызывается из игры Zork перед вызовом ReadKey
; 1501 // Нажата ли хотя бы одна клавиша на клавиатуре?
; 1502 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
; 1503 
; 1504 void IsAnyKeyPressed3();
; 1505 
; 1506 void IsAnyKeyPressed() {
isanykeypressed:
; 1507     // Если ли клавиша в буфере
; 1508     IsAnyKeyPressed3();
	call isanykeypressed3
; 1509     if (flag_nz)
; 1510         return;
	ret nz
; 1511     
; 1512     // Если при прошлом вызове была нажата клавиша
; 1513     a = keyLast;
	ld a, (keylast)
; 1514     a++;
	inc a
; 1515     if (flag_nz) {
	jp z, l_148
; 1516         // Если клавиша все еще нажата
; 1517         out(PORT_KEYBOARD_COLUMN, a ^= a);
	xor a
	out (7), a
; 1518         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1519         invert(a);
	cpl
; 1520         a += a;
	add a
; 1521         // Выход с кодом 0, если клавиша все еще нажата 
; 1522         a = 0;
	ld a, 0
; 1523         if (flag_nz)
; 1524             return;
	ret nz
l_148:
; 1525     }
; 1526     
; 1527     IsAnyKeyPressed2();
; 1528 }
; 1529 
; 1530 void IsAnyKeyPressed2() {
isanykeypressed2:
; 1531     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 1532         hl = keyDelay;
	ld hl, (keydelay)
; 1533         ReadKeyInternal(hl);
	call readkeyinternal
; 1534         l = 32; // Задержка повтора нажатия клавиши
	ld l, 32
; 1535         if (flag_nz) { // Это было первое нажатие клавиши. Антидребезг.
	jp z, l_150
; 1536             l = 2;
	ld l, 2
; 1537             ReadKeyInternal(hl);
	call readkeyinternal
; 1538             if (flag_nz)
; 1539                 a = 0xFF;
	jp z, l_152
	ld a, 255
l_152:
; 1540             l = 128; // Задержка повтора первого нажатия клавиши
	ld l, 128
l_150:
; 1541         }
; 1542         keyDelay = hl;
	ld (keydelay), hl
; 1543 
; 1544         if (a == SCAN_RUS) {
	cp 54
	jp nz, l_154
; 1545             a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1546             carry_rotate_right(a, 3); // Shift
	rra
	rra
	rra
; 1547             a = KEYBOARD_MODE_CAP;
	ld a, 2
; 1548             carry_sub(a, 0); // KEYBOARD_MODE_CAP -> KEYBOARD_MODE_RUS
	sbc 0
; 1549             hl = &keyboardMode;
	ld hl, 0FFFFh & (keyboardmode)
; 1550             a ^= *hl;
	xor (hl)
; 1551             *hl = a;
	ld (hl), a
; 1552             PrintKeyStatus();
	call printkeystatus
	jp l_155
l_154:
; 1553         } else {
; 1554             a = c;
	ld a, c
; 1555             a++;
	inc a
; 1556             keyBuffer = a;
	ld (keybuffer), a
l_155:
	pop hl
	pop de
	pop bc
; 1557         }
; 1558     }
; 1559     IsAnyKeyPressed3();
; 1560 }
; 1561 
; 1562 void IsAnyKeyPressed3() {
isanykeypressed3:
; 1563     a = keyBuffer;
	ld a, (keybuffer)
; 1564     a += 0xFF;
	add 255
; 1565     carry_sub(a, a);
	sbc a
	ret
; 1566 }
; 1567 
; 1568 void ReadKeyInternal(...) {
readkeyinternal:
; 1569     do {
l_156:
; 1570         ScanKey();
	call scankey
; 1571         c = a;
	ld c, a
; 1572         a = keyCode;
	ld a, (keycode)
; 1573         compare(a, h);
	cp h
; 1574         h = a;
	ld h, a
; 1575         if (flag_nz) // Нажата другая клавиша
; 1576             return;
	ret nz
; 1577         if (a == 0xFF)
	cp 255
; 1578             return; // Ни одна клавиша не нажата
	ret z
; 1579         
; 1580         // Задержка
; 1581         b = 0;
	ld b, 0
; 1582         do {
l_159:
; 1583             swap(hl, de);
	ex hl, de
; 1584             swap(hl, de);
	ex hl, de
l_160:
; 1585         } while (flag_nz(b--));
	dec b
	jp nz, l_159
l_157:
; 1586     } while (flag_nz(l--));
	dec l
	jp nz, l_156
	ret
; 1587 }
; 1588 
; 1589 
; 1590 // Функция для пользовательской программы.
; 1591 // Получить код нажатой клавиши на клавиатуре.
; 1592 // В отличии от функции ScanKey, в этой функции есть задержка повтора.
; 1593 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1594 
; 1595 void ReadKey() {
readkey:
; 1596     push_pop(hl) {
	push hl
; 1597         hl = &keyBuffer;
	ld hl, 0FFFFh & (keybuffer)
; 1598         for (;;) {
l_163:
; 1599             a = *hl;
	ld a, (hl)
; 1600             if (a != 0)
	or a
; 1601                 break;
	jp nz, l_164
; 1602             IsAnyKeyPressed2();
	call isanykeypressed2
	jp l_163
l_164:
; 1603         }
; 1604         *hl = 0;
	ld (hl), 0
; 1605         a--;
	dec a
	pop hl
	ret
; 1606     }
; 1607 }
; 1608     
; 1609 // Функция для пользовательской программы.
; 1610 // Получить код нажатой клавиши на клавиатуре.
; 1611 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
; 1612 
; 1613 void ScanKey() {
scankey:
; 1614     push(bc, de, hl);
	push bc
	push de
	push hl
; 1615 
; 1616     bc = 0xFEFE;
	ld bc, 65278
; 1617     do {
l_165:
; 1618         a = c;
	ld a, c
; 1619         out(PORT_KEYBOARD_COLUMN, a);
	out (7), a
; 1620         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1621         invert(a);
	cpl
; 1622         a += a;
	add a
; 1623         if (flag_nz)
; 1624             return ScanKey2(a);
	jp nz, scankey2
; 1625         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
; 1626         a = c;
	ld a, c
; 1627         cyclic_rotate_left(a, 1);
	rlca
; 1628         c = a;
	ld c, a
l_166:
	jp c, l_165
; 1629     } while (flag_c);
; 1630 
; 1631     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1632     carry_rotate_right(a, 1);
	rra
; 1633     b++;
	inc b
; 1634     b++;
	inc b
; 1635     if (flag_nc)
; 1636         return ScanKey3(b);
	jp nc, scankey3
; 1637     keyCode = a = 0xFF;
	ld a, 255
	ld (keycode), a
; 1638     ScanKeyExit(a);
	jp scankeyexit
; 1639 }
; 1640 
; 1641 void ScanKey2(...) {
scankey2:
; 1642     do {
l_168:
; 1643         b++;
	inc b
; 1644         carry_rotate_right(a, 1);
	rra
l_169:
	jp nc, l_168
; 1645     } while (flag_nc);
; 1646     ScanKey3(b);
; 1647 }
; 1648 
; 1649 void ScanKey3(...) {
scankey3:
; 1650     // b - key number
; 1651 
; 1652     //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1653     //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1654     // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1655     // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1656     // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1657     // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1658     // 48   Space Right Left  Up    Down  Vk    Str   Home
; 1659 
; 1660     a = b;
	ld a, b
; 1661     keyCode = a;
	ld (keycode), a
; 1662     if (a >= 48)
	cp 48
; 1663         return ScanKeySpecial(a);
	jp nc, scankeyspecial
; 1664     a += 48;
	add 48
; 1665     if (a >= 60)
	cp 60
; 1666         if (a < 64)
	jp c, l_171
	cp 64
; 1667             a &= 47;
	jp nc, l_173
	and 47
l_173:
l_171:
; 1668 
; 1669     c = a;
	ld c, a
; 1670 
; 1671     a = keyboardMode;
	ld a, (keyboardmode)
; 1672     carry_rotate_right(a, 1);
	rra
; 1673     d = a;
	ld d, a
; 1674     if (flag_c) { // KEYBOARD_MODE_RUS
	jp nc, l_175
; 1675         a = c;
	ld a, c
; 1676         a |= 0x20;
	or 32
; 1677         c = a;
	ld c, a
l_175:
; 1678     }
; 1679 
; 1680     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1681     carry_rotate_right(a, 2);
	rra
	rra
; 1682     if (flag_nc)
; 1683         return ScanKeyControl(c);
	jp nc, scankeycontrol
; 1684     carry_rotate_right(a, 1);
	rra
; 1685     a = c;
	ld a, c
; 1686     if (flag_nc) {
	jp c, l_177
; 1687         a ^= 0x10;
	xor 16
; 1688         if (a >= 64)
	cp 64
; 1689             a ^= 0x80 | 0x10;
	jp c, l_179
	xor 144
l_179:
l_177:
; 1690     }
; 1691     c = a;
	ld c, a
; 1692     a = d;
	ld a, d
; 1693     carry_rotate_right(a, 1);
	rra
; 1694     if (flag_c) { // KEYBOARD_MODE_CAP
	jp nc, l_181
; 1695         a = c;
	ld a, c
; 1696         a &= 0x7F;
	and 127
; 1697         if (a >= 0x60)  // Кириллица
	cp 96
; 1698             goto convert;
	jp nc, convert
; 1699         if (a >= 'A') {
	cp 65
	jp c, l_183
; 1700             if (a < 'Z' + 1) {
	cp 91
	jp nc, l_185
; 1701 convert:        a = c;
convert:
	ld a, c
; 1702                 a ^= 0x80;
	xor 128
; 1703                 c = a;
	ld c, a
l_185:
l_183:
l_181:
; 1704             }
; 1705         }
; 1706     }
; 1707     a = c;
	ld a, c
; 1708     ScanKeyExit(a);
; 1709 }
; 1710 
; 1711 void ScanKeyExit(...) {
scankeyexit:
; 1712     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1713 }
; 1714 
; 1715 void ScanKeyControl(...) {
scankeycontrol:
; 1716     a = c;
	ld a, c
; 1717     a &= 0x1F;
	and 31
; 1718     ScanKeyExit(a);
	jp scankeyexit
; 1719 }
; 1720 
; 1721 void ScanKeySpecial(...) {
scankeyspecial:
; 1722     h = (uintptr_t)specialKeyTable >> 8;
	ld h, 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) >> (8))
; 1723     l = (a += (uintptr_t)specialKeyTable - 48);
	add 0FFh & ((0FFFFh & (0FFFFh & (specialkeytable))) - (48))
	ld l, a
; 1724     a = *hl;
	ld a, (hl)
; 1725     ScanKeyExit(a);
	jp scankeyexit
; 1726 }
; 1727 
; 1728 uint8_t specialKeyTable[] = {
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
; 1740  aPrompt[] = "\r\n-->";
aprompt:
	db 13
	db 10
	db 45
	db 45
	db 62
	ds 1
; 1741  aCrLfTab[] = "\r\n\x18\x18\x18";
acrlftab:
	db 13
	db 10
	db 24
	db 24
	db 24
	ds 1
; 1742  aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
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
; 1743  aBackspace[] = "\x08 \x08";
abackspace:
	db 8
	db 32
	db 8
	ds 1
; 1744  aHello[] = "\x1FМИКРО 80\x1BБ";
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
; 1751  aZag[3] = "Заг";
azag:
	db 122
	db 225
	db 231
; 1752  aStr[3] = "Стр";
astr:
	db 115
	db 244
	db 242
; 1753  aLat[3] = "Лат";
alat:
	db 108
	db 225
	db 244
; 1754  aRus[3] = "Рус";
arus:
	db 114
	db 245
	db 243
; 1756  PrintKeyStatus() {
printkeystatus:
; 1757     bc = SCREEN_BEGIN + 56 + 31 * SCREEN_WIDTH;
	ld bc, 61432
; 1758     a = keyboardMode;
	ld a, (keyboardmode)
; 1759     hl = aLat;
	ld hl, 0FFFFh & (alat)
; 1760     PrintKeyStatusInt(a, bc, hl);
	call printkeystatusint
; 1761     bc++;
	inc bc
; 1762     l = aZag;
	ld l, 0FFh & (azag)
; 1763     PrintKeyStatusInt(a, bc, hl);
; 1764 }
; 1765 
; 1766 void PrintKeyStatusInt(...) {
printkeystatusint:
; 1767     de = sizeof(aZag);
	ld de, 3
; 1768     cyclic_rotate_right(a, 1);
	rrca
; 1769     if (flag_c)
; 1770         hl += de;
	jp nc, l_187
	add hl, de
l_187:
; 1771     d = a;
	ld d, a
; 1772     do {
l_189:
; 1773         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 1774         bc++;
	inc bc
; 1775         hl++;
	inc hl
l_190:
; 1776     } while (flag_nz(e--));
	dec e
	jp nz, l_189
; 1777     a = d;
	ld a, d
	ret
 savebin "micro80.bin", 0xF800, 0x10000
