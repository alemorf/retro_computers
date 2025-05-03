    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst38opcode equ 56
rst38address equ 57
jumpparam1 equ 63312
jumpopcode equ 63312
param1 equ 63313
param1h equ 63314
param2 equ 63315
param2h equ 63316
param3 equ 63317
param3h equ 63318
tapepolarity equ 63319
cursor equ 63322
readdelay equ 63324
writedelay equ 63325
tapestartl equ 63326
tapestarth equ 63327
tapestopl equ 63328
tapestoph equ 63329
keylast equ 63332
regs equ 63333
regsp equ 63333
regsph equ 63334
regf equ 63335
rega equ 63336
regc equ 63337
regb equ 63338
rege equ 63339
regd equ 63340
regl equ 63341
reghl equ 63341
regh equ 63342
lastbreakaddress equ 63343
lastbreakaddresshigh equ 63344
breakcounter equ 63345
breakaddress equ 63346
breakprevbyte equ 63348
breakaddress2 equ 63349
breakprevbyte2 equ 63351
breakaddress3 equ 63352
breakprevbyte3 equ 63354
cmdbuffer equ 63355
cmdbuffer1 equ 63356
cmdbufferend equ 63387
 .org 0xF800
; 45  uint8_t rst38Opcode __address(0x38);
; 46 extern uint16_t rst38Address __address(0x39);
; 47 
; 48 // Прототипы
; 49 void Reboot();
; 50 void ReadKey();
; 51 void ReadKey0();
; 52 void ReadKey1(...);
; 53 void ReadKey2(...);
; 54 void ReadKeyDelay();
; 55 void ReadTapeByte(...);
; 56 void PrintChar(...);
; 57 void WriteTapeByte(...);
; 58 void PrintChar(...);
; 59 void IsAnyKeyPressed();
; 60 void PrintHexByte(...);
; 61 void PrintString(...);
; 62 void Monitor();
; 63 void MonitorExecute();
; 64 void PrintCharA(...);
; 65 void ReadString();
; 66 void MonitorError();
; 67 void ReadStringLoop(...);
; 68 void CommonBs(...);
; 69 void PrintSpace(...);
; 70 void InputBs(...);
; 71 void InputEndSpace(...);
; 72 void PopWordReturn(...);
; 73 void InputLoop(...);
; 74 void InputInit(...);
; 75 void ParseWord(...);
; 76 void CompareHlDe(...);
; 77 void ParseWordReturnCf(...);
; 78 void PrintHex(...);
; 79 void PrintParam1Space();
; 80 void PrintHexWordSpace(...);
; 81 void IncWord(...);
; 82 void PrintRegs();
; 83 void CmdXS(...);
; 84 void FindRegister(...);
; 85 void ReadKey(...);
; 86 void PrintRegMinus(...);
; 87 void InitRst38();
; 88 void BreakPoint(...);
; 89 void BreakPointAt2(...);
; 90 void BreakpointAt3(...);
; 91 void Run();
; 92 void ContinueBreakpoint(...);
; 93 void CmdQResult(...);
; 94 void CmdIEnd(...);
; 95 void ReadTapeDelay(...);
; 96 void PrintCharInt(...);
; 97 void WriteTapeDelay(...);
; 98 void TapeDelay(...);
; 99 void ClearScreen();
; 100 void MoveCursorLeft(...);
; 101 void MoveCursorRight(...);
; 102 void MoveCursorUp(...);
; 103 void MoveCursorDown(...);
; 104 void MoveCursorNextLine(...);
; 105 void MoveCursorHome();
; 106 void ClearScreenInt();
; 107 void MoveCursor(...);
; 108 void MoveCursorNextLine1(...);
; 109 void ReadStringBs(...);
; 110 void ReadStringCr(...);
; 111 
; 112 extern uint8_t aPrompt[22];
; 113 extern uint8_t monitorCommands;
; 114 extern uint8_t regList[19];
; 115 extern uint8_t aLf[2];
; 116 extern uint8_t keyTable[8];
; 117 
; 118 // Переменные монитора
; 119 void jumpParam1(void) __address(0xF750);
; 120 extern uint8_t jumpOpcode __address(0xF750);
; 121 extern uint16_t param1 __address(0xF751);
; 122 extern uint8_t param1h __address(0xF752);
; 123 extern uint16_t param2 __address(0xF753);
; 124 extern uint8_t param2h __address(0xF754);
; 125 extern uint16_t param3 __address(0xF755);
; 126 extern uint8_t param3h __address(0xF756);
; 127 extern uint8_t tapePolarity __address(0xF757);
; 128 // Unused 0xF758
; 129 // Unused 0xF759
; 130 extern uint16_t cursor __address(0xF75A);
; 131 extern uint8_t readDelay __address(0xF75C);
; 132 extern uint8_t writeDelay __address(0xF75D);
; 133 extern uint8_t tapeStartL __address(0xF75E);
; 134 extern uint8_t tapeStartH __address(0xF75F);
; 135 extern uint8_t tapeStopL __address(0xF760);
; 136 extern uint8_t tapeStopH __address(0xF761);
; 137 // Unused 0xF762
; 138 // Unused 0xF763
; 139 extern uint8_t keyLast __address(0xF764);
; 140 extern uint16_t regs __address(0xF765);
; 141 extern uint16_t regSP __address(0xF765);
; 142 extern uint8_t regSPH __address(0xF766);
; 143 extern uint16_t regF __address(0xF767);
; 144 extern uint16_t regA __address(0xF768);
; 145 extern uint16_t regC __address(0xF769);
; 146 extern uint16_t regB __address(0xF76A);
; 147 extern uint16_t regE __address(0xF76B);
; 148 extern uint16_t regD __address(0xF76C);
; 149 extern uint16_t regL __address(0xF76D);
; 150 extern uint16_t regHL __address(0xF76D);
; 151 extern uint16_t regH __address(0xF76E);
; 152 extern uint16_t lastBreakAddress __address(0xF76F);
; 153 extern uint8_t lastBreakAddressHigh __address(0xF770);
; 154 extern uint8_t breakCounter __address(0xF771);
; 155 extern uint16_t breakAddress __address(0xF772);
; 156 extern uint8_t breakPrevByte __address(0xF774);
; 157 extern uint16_t breakAddress2 __address(0xF775);
; 158 extern uint8_t breakPrevByte2 __address(0xF777);
; 159 extern uint16_t breakAddress3 __address(0xF778);
; 160 extern uint8_t breakPrevByte3 __address(0xF77A);
; 161 extern uint8_t cmdBuffer __address(0xF77B);
; 162 extern uint8_t cmdBuffer1 __address(0xF77B + 1);
; 163 extern uint8_t cmdBufferEnd __address(0xF77B + 32);
; 164 
; 165 const int USER_STACK_TOP = 0xF7C0;
; 166 const int STACK_TOP = 0xF7FF;
; 167 
; 168 // Точки входа
; 169 
; 170 void EntryF800_Reboot() {
entryf800_reboot:
; 171     Reboot();
	jp reboot
; 172 }
; 173 
; 174 void EntryF803_ReadKey() {
entryf803_readkey:
; 175     ReadKey();
	jp readkey
; 176 }
; 177 
; 178 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 179     ReadTapeByte(a);
	jp readtapebyte
; 180 }
; 181 
; 182 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 183     PrintChar(c);
	jp printchar
; 184 }
; 185 
; 186 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 187     WriteTapeByte(c);
	jp writetapebyte
; 188 }
; 189 
; 190 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 191     PrintChar(c);
	jp printchar
; 192 }
; 193 
; 194 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 195     IsAnyKeyPressed();
	jp isanykeypressed
; 196 }
; 197 
; 198 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 199     PrintHexByte(a);
	jp printhexbyte
; 200 }
; 201 
; 202 void EntryF818_PrintString(...) {
entryf818_printstring:
; 203     PrintString(hl);
	jp printstring
; 204 }
; 205 
; 206 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 207 // Параметры: нет. Функция никогда не завершается.
; 208 
; 209 void Reboot() {
reboot:
; 210     regSP = hl = USER_STACK_TOP;
	ld hl, 63424
	ld (regsp), hl
; 211     sp = STACK_TOP;
	ld sp, 63487
; 212     PrintCharA(a = 0x1F);  // Clear screen
	ld a, 31
	call printchara
; 213     Monitor();
; 214 }
; 215 
; 216 void Monitor() {
monitor:
; 217     out(PORT_KEYBOARD_MODE, a = 0x8B);
	ld a, 139
	out (4), a
; 218     sp = STACK_TOP;
	ld sp, 63487
; 219     PrintString(hl = &aPrompt);
	ld hl, aprompt
	call printstring
; 220     ReadString();
	call readstring
; 221     push(hl = &Monitor);
	ld hl, 0FFFFh & (monitor)
	push hl
; 222     MonitorExecute();
; 223 }
; 224 
; 225 void MonitorExecute() {
monitorexecute:
; 226     hl = &cmdBuffer;
	ld hl, 0FFFFh & (cmdbuffer)
; 227     b = *hl;
	ld b, (hl)
; 228     hl = &monitorCommands;
	ld hl, 0FFFFh & (monitorcommands)
; 229 
; 230     for (;;) {
l_1:
; 231         a = *hl;
	ld a, (hl)
; 232         if (flag_z(a &= a))
	and a
; 233             return MonitorError();
	jp z, monitorerror
; 234         if (a == b)
	cp b
; 235             break;
	jp z, l_2
; 236         hl++;
	inc hl
; 237         hl++;
	inc hl
; 238         hl++;
	inc hl
	jp l_1
l_2:
; 239     }
; 240 
; 241     hl++;
	inc hl
; 242     sp = hl;
	ld sp, hl
; 243     pop(hl);
	pop hl
; 244     sp = STACK_TOP - 2;
	ld sp, 63485
; 245     return hl();
	jp hl
; 246 }
; 247 
; 248 void ReadString() {
readstring:
; 249     return ReadStringLoop(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 250 }
; 251 
; 252 void ReadStringLoop(...) {
readstringloop:
; 253     do {
l_3:
; 254         ReadKey();
	call readkey
; 255         if (a == 8)
	cp 8
; 256             return ReadStringBs();
	jp z, readstringbs
; 257         if (flag_nz)
; 258             PrintCharA();
	call nz, printchara
; 259         *hl = a;
	ld (hl), a
; 260         if (a == 0x0D)
	cp 13
; 261             return ReadStringCr(hl);
	jp z, readstringcr
; 262         a = &cmdBufferEnd - 1;
	ld a, 0FFh & ((cmdbufferend) - (1))
; 263         compare(a, l);
	cp l
; 264         hl++;
	inc hl
l_4:
	jp nz, l_3
; 265     } while (flag_nz);
; 266     MonitorError();
; 267 }
; 268 
; 269 void MonitorError() {
monitorerror:
; 270     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 271     Monitor();
	jp monitor
; 272 }
; 273 
; 274 void ReadStringCr(...) {
readstringcr:
; 275     *hl = 0x0D;
	ld (hl), 13
	ret
; 276 }
; 277 
; 278 void ReadStringBs(...) {
readstringbs:
; 279     CommonBs();
	call commonbs
; 280     ReadStringLoop();
	jp readstringloop
; 281 }
; 282 
; 283 void CommonBs(...) {
commonbs:
; 284     if ((a = &cmdBuffer) == l)
	ld a, 0FFh & (cmdbuffer)
	cp l
; 285         return;
	ret z
; 286     PrintCharA(a = 8);
	ld a, 8
	call printchara
; 287     hl--;
	dec hl
	ret
; 288 }
; 289 
; 290 void Input(...) {
input:
; 291     PrintSpace();
	call printspace
; 292     InputInit(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 293 }
; 294 
; 295 void InputInit(...) {
inputinit:
; 296     InputLoop(b = 0);
	ld b, 0
; 297 }
; 298 
; 299 void InputLoop(...) {
inputloop:
; 300     for (;;) {
l_7:
; 301         ReadKey();
	call readkey
; 302         if (a == 8)
	cp 8
; 303             return InputBs();
	jp z, inputbs
; 304         if (flag_nz)
; 305             PrintCharA();
	call nz, printchara
; 306         *hl = a;
	ld (hl), a
; 307         if (a == ' ')
	cp 32
; 308             return InputEndSpace();
	jp z, inputendspace
; 309         if (a == 0x0D)
	cp 13
; 310             return PopWordReturn();
	jp z, popwordreturn
; 311         b = 0xFF;
	ld b, 255
; 312         if ((a = &cmdBufferEnd - 1) == l)
	ld a, 0FFh & ((cmdbufferend) - (1))
	cp l
; 313             return MonitorError();
	jp z, monitorerror
; 314         hl++;
	inc hl
	jp l_7
; 315     }
; 316 }
; 317 
; 318 void InputEndSpace(...) {
inputendspace:
; 319     *hl = 0x0D;
	ld (hl), 13
; 320     a = b;
	ld a, b
; 321     carry_rotate_left(a, 1);
	rla
; 322     de = &cmdBuffer;
	ld de, 0FFFFh & (cmdbuffer)
; 323     b = 0;
	ld b, 0
	ret
; 324 }
; 325 
; 326 void InputBs(...) {
inputbs:
; 327     CommonBs();
	call commonbs
; 328     if (flag_z)
; 329         return InputInit();
	jp z, inputinit
; 330     InputLoop();
	jp inputloop
; 331 }
; 332 
; 333 void PopWordReturn(...) {
popwordreturn:
; 334     sp++;
	inc sp
; 335     sp++;
	inc sp
	ret
; 336 }
; 337 
; 338 void PrintLf(...) {
printlf:
; 339     PrintString(hl = &aLf);
	ld hl, alf
; 340 }
; 341 
; 342 void PrintString(...) {
printstring:
; 343     for (;;) {
l_10:
; 344         a = *hl;
	ld a, (hl)
; 345         if (flag_z(a &= a))
	and a
; 346             return;
	ret z
; 347         PrintCharA(a);
	call printchara
; 348         hl++;
	inc hl
	jp l_10
; 349     }
; 350 }
; 351 
; 352 void ParseParams() {
parseparams:
; 353     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 354     b = 6;
	ld b, 6
; 355     a ^= a;
	xor a
; 356     do {
l_12:
; 357         *hl = a;
	ld (hl), a
l_13:
; 358     } while (flag_nz(b--));
	dec b
	jp nz, l_12
; 359 
; 360     de = &cmdBuffer + 1;
	ld de, 0FFFFh & ((cmdbuffer) + (1))
; 361     ParseWord();
	call parseword
; 362     param1 = hl;
	ld (param1), hl
; 363     param2 = hl;
	ld (param2), hl
; 364     if (flag_c)
; 365         return;
	ret c
; 366 
; 367     ParseWord();
	call parseword
; 368     param2 = hl;
	ld (param2), hl
; 369     push_pop(a, de) {
	push af
	push de
; 370         swap(hl, de);
	ex hl, de
; 371         hl = param1;
	ld hl, (param1)
; 372         swap(hl, de);
	ex hl, de
; 373         CompareHlDe();
	call comparehlde
; 374         if (flag_c)
; 375             return MonitorError();
	jp c, monitorerror
	pop de
	pop af
; 376     }
; 377     if (flag_c)
; 378         return;
	ret c
; 379 
; 380     ParseWord();
	call parseword
; 381     param3 = hl;
	ld (param3), hl
; 382     if (flag_c)
; 383         return;
	ret c
; 384 
; 385     MonitorError();
	jp monitorerror
; 386 }
; 387 
; 388 void ParseWord(...) {
parseword:
; 389     hl = 0;
	ld hl, 0
; 390     for (;;) {
l_16:
; 391         a = *de;
	ld a, (de)
; 392         de++;
	inc de
; 393         if (a == 13)
	cp 13
; 394             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 395         if (a == ',')
	cp 44
; 396             return;
	ret z
; 397         if (a == ' ')
	cp 32
; 398             continue;
	jp z, l_16
; 399         a -= '0';
	sub 48
; 400         if (flag_m)
; 401             return MonitorError();
	jp m, monitorerror
; 402         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_18
; 403             if (flag_m(compare(a, 17)))
	cp 17
; 404                 return MonitorError();
	jp m, monitorerror
; 405             if (flag_p(compare(a, 23)))
	cp 23
; 406                 return MonitorError();
	jp p, monitorerror
; 407             a -= 7;
	sub 7
l_18:
; 408         }
; 409         c = a;
	ld c, a
; 410         hl += hl;
	add hl, hl
; 411         hl += hl;
	add hl, hl
; 412         hl += hl;
	add hl, hl
; 413         hl += hl;
	add hl, hl
; 414         if (flag_c)
; 415             return MonitorError();
	jp c, monitorerror
; 416         hl += bc;
	add hl, bc
	jp l_16
; 417     }
; 418 }
; 419 
; 420 void ParseWordReturnCf(...) {
parsewordreturncf:
; 421     set_flag_c();
	scf
	ret
; 422 }
; 423 
; 424 void PrintByteFromParam1(...) {
printbytefromparam1:
; 425     hl = param1;
	ld hl, (param1)
; 426     PrintHexByte(a = *hl);
	ld a, (hl)
; 427 }
; 428 
; 429 void PrintHexByte(...) {
printhexbyte:
; 430     b = a;
	ld b, a
; 431     a = b;
	ld a, b
; 432     cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 433     PrintHex(a);
	call printhex
; 434     PrintHex(a = b);
	ld a, b
; 435 }
; 436 
; 437 void PrintHex(...) {
printhex:
; 438     a &= 0x0F;
	and 15
; 439     if (flag_p(compare(a, 10)))
	cp 10
; 440         a += 'A' - '0' - 10;
	jp m, l_20
	add 7
l_20:
; 441     a += '0';
	add 48
; 442     PrintCharA(a);
	jp printchara
; 443 }
; 444 
; 445 void PrintLfParam1(...) {
printlfparam1:
; 446     PrintLf();
	call printlf
; 447     PrintParam1Space();
; 448 }
; 449 
; 450 void PrintParam1Space() {
printparam1space:
; 451     PrintHexWordSpace(hl = &param1h);
	ld hl, 0FFFFh & (param1h)
; 452 }
; 453 
; 454 void PrintHexWordSpace(...) {
printhexwordspace:
; 455     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 456     hl--;
	dec hl
; 457     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 458     PrintSpace();
; 459 }
; 460 
; 461 void PrintSpace(...) {
printspace:
; 462     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 463 }
; 464 
; 465 void Loop(...) {
loop:
; 466     push_pop(de) {
	push de
; 467         hl = param1;
	ld hl, (param1)
; 468         swap(hl, de);
	ex hl, de
; 469         hl = param2;
	ld hl, (param2)
; 470         CompareHlDe(hl, de);
	call comparehlde
	pop de
; 471     }
; 472     if (flag_z)
; 473         return PopWordReturn();
	jp z, popwordreturn
; 474     IncWord(hl = &param1);
	ld hl, 0FFFFh & (param1)
; 475 }
; 476 
; 477 void IncWord(...) {
incword:
; 478     (*hl)++;
	inc (hl)
; 479     if (flag_nz)
; 480         return;
	ret nz
; 481     hl++;
	inc hl
; 482     (*hl)++;
	inc (hl)
	ret
; 483 }
; 484 
; 485 void CompareHlDe(...) {
comparehlde:
; 486     if ((a = h) != d)
	ld a, h
	cp d
; 487         return;
	ret nz
; 488     compare(a = l, e);
	ld a, l
	cp e
	ret
; 489 }
; 490 
; 491 // Команда X
; 492 // Изменение содержимого внутреннего регистра микропроцессора
; 493 
; 494 void CmdX() {
cmdx:
; 495     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 496     a = *hl;
	ld a, (hl)
; 497     if (a == 0x0D)
	cp 13
; 498         return PrintRegs();
	jp z, printregs
; 499     if (a == 'S')
	cp 83
; 500         return CmdXS();
	jp z, cmdxs
; 501     FindRegister(de = &regList);
	ld de, reglist
	call findregister
; 502     hl = &regs;
	ld hl, 0FFFFh & (regs)
; 503     de++;
	inc de
; 504     l = a = *de;
	ld a, (de)
	ld l, a
; 505     push_pop(hl) {
	push hl
; 506         PrintSpace();
	call printspace
; 507         PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 508         Input();
	call input
; 509         if (flag_nc)
; 510             return Monitor();
	jp nc, monitor
; 511         ParseWord();
	call parseword
; 512         a = l;
	ld a, l
	pop hl
; 513     }
; 514     *hl = a;
	ld (hl), a
	ret
; 515 }
; 516 
; 517 void CmdXS() {
cmdxs:
; 518     PrintSpace();
	call printspace
; 519     PrintHexWordSpace(hl = &regSPH);
	ld hl, 0FFFFh & (regsph)
	call printhexwordspace
; 520     Input();
	call input
; 521     if (flag_nc)
; 522         return Monitor();
	jp nc, monitor
; 523     ParseWord();
	call parseword
; 524     regSP = hl;
	ld (regsp), hl
	ret
; 525 }
; 526 
; 527 void FindRegister(...) {
findregister:
; 528     for (;;) {
l_23:
; 529         a = *de;
	ld a, (de)
; 530         if (flag_z(a &= a))
	and a
; 531             return MonitorError();
	jp z, monitorerror
; 532         if (a == *hl)
	cp (hl)
; 533             return;
	ret z
; 534         de++;
	inc de
; 535         de++;
	inc de
	jp l_23
; 536     }
; 537 }
; 538 
; 539 void PrintRegs(...) {
printregs:
; 540     de = &regList;
	ld de, reglist
; 541     b = 8;
	ld b, 8
; 542     PrintLf();
	call printlf
; 543     do {
l_25:
; 544         c = a = *de;
	ld a, (de)
	ld c, a
; 545         de++;
	inc de
; 546         push_pop(bc) {
	push bc
; 547             PrintRegMinus(c);
	call printregminus
; 548             a = *de;
	ld a, (de)
; 549             hl = &regs;
	ld hl, 0FFFFh & (regs)
; 550             l = a;
	ld l, a
; 551             PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
	pop bc
; 552         }
; 553         de++;
	inc de
l_26:
; 554     } while (flag_nz(b--));
	dec b
	jp nz, l_25
; 555 
; 556     c = a = *de;
	ld a, (de)
	ld c, a
; 557     PrintRegMinus();
	call printregminus
; 558     param1 = hl = regs;
	ld hl, (regs)
	ld (param1), hl
; 559     PrintParam1Space();
	call printparam1space
; 560     PrintRegMinus(c = 'O');
	ld c, 79
	call printregminus
; 561     PrintHexWordSpace(hl = &lastBreakAddressHigh);
	ld hl, 0FFFFh & (lastbreakaddresshigh)
	call printhexwordspace
; 562     PrintLf();
	jp printlf
; 563 }
; 564 
; 565 void PrintRegMinus(...) {
printregminus:
; 566     PrintSpace();
	call printspace
; 567     PrintCharA(a = c);
	ld a, c
	call printchara
; 568     PrintCharA(a = '-');
	ld a, 45
	jp printchara
; 569 }
; 570 
; 571 uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC,
reglist:
	db 65
	db 0FFh & (0FFFFh & (rega))
	db 66
	db 0FFh & (0FFFFh & (regb))
	db 67
	db 0FFh & (0FFFFh & (regc))
	db 68
	db 0FFh & (0FFFFh & (regd))
	db 69
	db 0FFh & (0FFFFh & (rege))
	db 70
	db 0FFh & (0FFFFh & (regf))
	db 72
	db 0FFh & (0FFFFh & (regh))
	db 76
	db 0FFh & (0FFFFh & (regl))
	db 83
	db 0FFh & (0FFFFh & (regsp))
	db 0
; 576  aStart[] = "\x0ASTART-";
astart:
	db 10
	db 83
	db 84
	db 65
	db 82
	db 84
	db 45
	ds 1
; 577  aDir_[] = "\x0ADIR. -";
adir_:
	db 10
	db 68
	db 73
	db 82
	db 46
	db 32
	db 45
	ds 1
; 582  CmdB() {
cmdb:
; 583     ParseParams();
	call parseparams
; 584     InitRst38();
	call initrst38
; 585     hl = param1;
	ld hl, (param1)
; 586     a = *hl;
	ld a, (hl)
; 587     *hl = OPCODE_RST_38;
	ld (hl), 255
; 588     breakAddress = hl;
	ld (breakaddress), hl
; 589     breakPrevByte = a;
	ld (breakprevbyte), a
	ret
; 590 }
; 591 
; 592 void InitRst38() {
initrst38:
; 593     rst38Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst38opcode), a
; 594     rst38Address = hl = &BreakPoint;
	ld hl, 0FFFFh & (breakpoint)
	ld (rst38address), hl
	ret
; 595 }
; 596 
; 597 void BreakPoint(...) {
breakpoint:
; 598     regHL = hl;
	ld (reghl), hl
; 599     push(a);
	push af
; 600     hl = 4;
	ld hl, 4
; 601     hl += sp;
	add hl, sp
; 602     regs = hl;
	ld (regs), hl
; 603     pop(a);
	pop af
; 604     swap(*sp, hl);
	ex (sp), hl
; 605     hl--;
	dec hl
; 606     swap(*sp, hl);
	ex (sp), hl
; 607     sp = &regHL;
	ld sp, 0FFFFh & (reghl)
; 608     push(de, bc, a);
	push de
	push bc
	push af
; 609     sp = STACK_TOP;
	ld sp, 63487
; 610 
; 611     hl = regSP;
	ld hl, (regsp)
; 612     hl--;
	dec hl
; 613     d = *hl;
	ld d, (hl)
; 614     hl--;
	dec hl
; 615     e = *hl;
	ld e, (hl)
; 616     l = e;
	ld l, e
; 617     h = d;
	ld h, d
; 618     lastBreakAddress = hl;
	ld (lastbreakaddress), hl
; 619 
; 620     hl = breakAddress;
	ld hl, (breakaddress)
; 621     CompareHlDe();
	call comparehlde
; 622     if (flag_nz) {
	jp z, l_28
; 623         hl = breakAddress2;
	ld hl, (breakaddress2)
; 624         CompareHlDe(hl, de);
	call comparehlde
; 625         if (flag_z)
; 626             return BreakPointAt2();
	jp z, breakpointat2
; 627 
; 628         hl = breakAddress3;
	ld hl, (breakaddress3)
; 629         CompareHlDe(hl, de);
	call comparehlde
; 630         if (flag_z)
; 631             return BreakpointAt3();
	jp z, breakpointat3
; 632 
; 633         return MonitorError();
	jp monitorerror
l_28:
; 634     }
; 635     *hl = a = breakPrevByte;
	ld a, (breakprevbyte)
	ld (hl), a
; 636     breakAddress = hl = 0xFFFF;
	ld hl, 65535
	ld (breakaddress), hl
; 637     return Monitor();
	jp monitor
; 638 }
; 639 
; 640 // Команда G<адрес>
; 641 // Запуск программы в отладочном режиме
; 642 
; 643 void CmdG() {
cmdg:
; 644     ParseParams();
	call parseparams
; 645     if ((a = cmdBuffer1) == 0x0D)
	ld a, (cmdbuffer1)
	cp 13
; 646         param1 = hl = lastBreakAddress;
	jp nz, l_30
	ld hl, (lastbreakaddress)
	ld (param1), hl
l_30:
; 647     Run();
; 648 }
; 649 
; 650 void Run() {
run:
; 651     jumpOpcode = a = OPCODE_JMP;
	ld a, 195
	ld (jumpopcode), a
; 652     sp = &regs;
	ld sp, 0FFFFh & (regs)
; 653     pop(de, bc, a, hl);
	pop hl
	pop af
	pop bc
	pop de
; 654     sp = hl;
	ld sp, hl
; 655     hl = regHL;
	ld hl, (reghl)
; 656     jumpParam1();
	jp jumpparam1
; 657 }
; 658 
; 659 void CmdP(...) {
cmdp:
; 660     ParseParams();
	call parseparams
; 661     InitRst38();
	call initrst38
; 662 
; 663     breakAddress2 = hl = param1;
	ld hl, (param1)
	ld (breakaddress2), hl
; 664     a = *hl;
	ld a, (hl)
; 665     *hl = OPCODE_RST_38;
	ld (hl), 255
; 666     breakPrevByte2 = a;
	ld (breakprevbyte2), a
; 667 
; 668     breakAddress3 = hl = param2;
	ld hl, (param2)
	ld (breakaddress3), hl
; 669     a = *hl;
	ld a, (hl)
; 670     *hl = OPCODE_RST_38;
	ld (hl), 255
; 671     breakPrevByte3 = a;
	ld (breakprevbyte3), a
; 672 
; 673     breakCounter = a = param3;
	ld a, (param3)
	ld (breakcounter), a
; 674 
; 675     PrintString(hl = &aStart);
	ld hl, astart
	call printstring
; 676 
; 677     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 678     ReadStringLoop();
	call readstringloop
; 679     ParseParams();
	call parseparams
; 680     PrintString(hl = &aDir_);
	ld hl, adir_
	call printstring
; 681     ReadString();
	call readstring
; 682     Run();
	jp run
; 683 }
; 684 
; 685 void BreakPointAt2(...) {
breakpointat2:
; 686     *hl = a = breakPrevByte2;
	ld a, (breakprevbyte2)
	ld (hl), a
; 687 
; 688     hl = breakAddress3;
	ld hl, (breakaddress3)
; 689     a = OPCODE_RST_38;
	ld a, 255
; 690     if (a != *hl) {
	cp (hl)
	jp z, l_32
; 691         b = *hl;
	ld b, (hl)
; 692         *hl = a;
	ld (hl), a
; 693         breakPrevByte3 = a = b;
	ld a, b
	ld (breakprevbyte3), a
l_32:
; 694     }
; 695     ContinueBreakpoint();
; 696 }
; 697 
; 698 void ContinueBreakpoint(...) {
continuebreakpoint:
; 699     PrintRegs();
	call printregs
; 700     MonitorExecute();
	call monitorexecute
; 701     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 702     Run();
	jp run
; 703 }
; 704 
; 705 void BreakpointAt3(...) {
breakpointat3:
; 706     *hl = a = breakPrevByte3;
	ld a, (breakprevbyte3)
	ld (hl), a
; 707 
; 708     hl = breakAddress2;
	ld hl, (breakaddress2)
; 709     a = OPCODE_RST_38;
	ld a, 255
; 710     if (a == *hl)
	cp (hl)
; 711         return ContinueBreakpoint();
	jp z, continuebreakpoint
; 712     b = *hl;
	ld b, (hl)
; 713     *hl = a;
	ld (hl), a
; 714     breakPrevByte2 = a = b;
	ld a, b
	ld (breakprevbyte2), a
; 715 
; 716     hl = &breakCounter;
	ld hl, 0FFFFh & (breakcounter)
; 717     (*hl)--;
	dec (hl)
; 718     if (flag_nz)
; 719         return ContinueBreakpoint();
	jp nz, continuebreakpoint
; 720 
; 721     a = breakPrevByte2;
	ld a, (breakprevbyte2)
; 722     hl = breakAddress2;
	ld hl, (breakaddress2)
; 723     *hl = a;
	ld (hl), a
; 724     Monitor();
	jp monitor
; 725 }
; 726 
; 727 // Команда D<адрес>,<адрес>
; 728 // Просмотр содержимого области памяти в шестнадцатеричном виде
; 729 
; 730 void CmdD() {
cmdd:
; 731     ParseParams();
	call parseparams
; 732     PrintLf();
	call printlf
; 733 CmdDLine:
cmddline:
; 734     PrintLfParam1();
	call printlfparam1
; 735     for (;;) {
l_35:
; 736         PrintSpace();
	call printspace
; 737         PrintByteFromParam1();
	call printbytefromparam1
; 738         Loop();
	call loop
; 739         a = param1;
	ld a, (param1)
; 740         a &= 0x0F;
	and 15
; 741         if (flag_z)
; 742             goto CmdDLine;
	jp z, cmddline
	jp l_35
; 743     }
; 744 }
; 745 
; 746 // Команда C<адрес от>,<адрес до>,<адрес от 2>
; 747 // Сравнение содержимого двух областей памяти
; 748 
; 749 void CmdC() {
cmdc:
; 750     ParseParams();
	call parseparams
; 751     hl = param3;
	ld hl, (param3)
; 752     swap(hl, de);
	ex hl, de
; 753     for (;;) {
l_38:
; 754         hl = param1;
	ld hl, (param1)
; 755         a = *de;
	ld a, (de)
; 756         if (a != *hl) {
	cp (hl)
	jp z, l_40
; 757             PrintLfParam1();
	call printlfparam1
; 758             PrintSpace();
	call printspace
; 759             PrintByteFromParam1();
	call printbytefromparam1
; 760             PrintSpace();
	call printspace
; 761             a = *de;
	ld a, (de)
; 762             PrintHexByte();
	call printhexbyte
l_40:
; 763         }
; 764         de++;
	inc de
; 765         Loop();
	call loop
	jp l_38
; 766     }
; 767 }
; 768 
; 769 // Команда F<адрес>,<адрес>,<байт>
; 770 // Запись байта во все ячейки области памяти
; 771 
; 772 void CmdF() {
cmdf:
; 773     ParseParams();
	call parseparams
; 774     b = a = param3;
	ld a, (param3)
	ld b, a
; 775     for (;;) {
l_43:
; 776         hl = param1;
	ld hl, (param1)
; 777         *hl = b;
	ld (hl), b
; 778         Loop();
	call loop
	jp l_43
; 779     }
; 780 }
; 781 
; 782 // Команда S<адрес>,<адрес>,<байт>
; 783 // Поиск байта в области памяти
; 784 
; 785 void CmdS() {
cmds:
; 786     ParseParams();
	call parseparams
; 787     c = l;
	ld c, l
; 788     for (;;) {
l_46:
; 789         hl = param1;
	ld hl, (param1)
; 790         a = c;
	ld a, c
; 791         if (a == *hl)
	cp (hl)
; 792             PrintLfParam1();
	call z, printlfparam1
; 793         Loop();
	call loop
	jp l_46
; 794     }
; 795 }
; 796 
; 797 // Команда T<начало>,<конец>,<куда>
; 798 // Пересылка содержимого одной области в другую
; 799 
; 800 void CmdT() {
cmdt:
; 801     ParseParams();
	call parseparams
; 802     hl = param3;
	ld hl, (param3)
; 803     swap(hl, de);
	ex hl, de
; 804     for (;;) {
l_49:
; 805         hl = param1;
	ld hl, (param1)
; 806         *de = a = *hl;
	ld a, (hl)
	ld (de), a
; 807         de++;
	inc de
; 808         Loop();
	call loop
	jp l_49
; 809     }
; 810 }
; 811 
; 812 // Команда M<адрес>
; 813 // Просмотр или изменение содержимого ячейки (ячеек) памяти
; 814 
; 815 void CmdM() {
cmdm:
; 816     ParseParams();
	call parseparams
; 817     for (;;) {
l_52:
; 818         PrintSpace();
	call printspace
; 819         PrintByteFromParam1();
	call printbytefromparam1
; 820         Input();
	call input
; 821         if (flag_c) {
	jp nc, l_54
; 822             ParseWord();
	call parseword
; 823             a = l;
	ld a, l
; 824             hl = param1;
	ld hl, (param1)
; 825             *hl = a;
	ld (hl), a
l_54:
; 826         }
; 827         hl = &param1;
	ld hl, 0FFFFh & (param1)
; 828         IncWord();
	call incword
; 829         PrintLfParam1();
	call printlfparam1
	jp l_52
; 830     }
; 831 }
; 832 
; 833 // Команда J<адрес>
; 834 // Запуск программы с указанного адреса
; 835 
; 836 void CmdJ() {
cmdj:
; 837     ParseParams();
	call parseparams
; 838     hl = param1;
	ld hl, (param1)
; 839     return hl();
	jp hl
; 840 }
; 841 
; 842 // Команда А<символ>
; 843 // Вывод кода символа на экран
; 844 
; 845 void CmdA() {
cmda:
; 846     PrintLf();
	call printlf
; 847     PrintHexByte(a = cmdBuffer1);
	ld a, (cmdbuffer1)
	call printhexbyte
; 848     PrintLf();
	jp printlf
; 849 }
; 850 
; 851 // Команда K
; 852 // Вывод символа с клавиатуры на экран
; 853 
; 854 void CmdK() {
cmdk:
; 855     for (;;) {
l_57:
; 856         ReadKey();
	call readkey
; 857         if (a == 1)  // УС + А
	cp 1
; 858             return Monitor();
	jp z, monitor
; 859         PrintCharA(a);
	call printchara
	jp l_57
; 860     }
; 861 }
; 862 
; 863 // Команда Q<начало>,<конец>
; 864 // Тестирование области памяти
; 865 
; 866 void CmdQ() {
cmdq:
; 867     ParseParams();
	call parseparams
; 868     for (;;) {
l_60:
; 869         hl = param1;
	ld hl, (param1)
; 870         c = *hl;
	ld c, (hl)
; 871 
; 872         a = 0x55;
	ld a, 85
; 873         *hl = a;
	ld (hl), a
; 874         if (a != *hl)
	cp (hl)
; 875             CmdQResult();
	call nz, cmdqresult
; 876 
; 877         a = 0xAA;
	ld a, 170
; 878         *hl = a;
	ld (hl), a
; 879         if (a != *hl)
	cp (hl)
; 880             CmdQResult();
	call nz, cmdqresult
; 881 
; 882         *hl = c;
	ld (hl), c
; 883         Loop();
	call loop
	jp l_60
; 884     }
; 885 }
; 886 
; 887 void CmdQResult(...) {
cmdqresult:
; 888     push_pop(a) {
	push af
; 889         PrintLfParam1();
	call printlfparam1
; 890         PrintSpace();
	call printspace
; 891         PrintByteFromParam1();
	call printbytefromparam1
; 892         PrintSpace();
	call printspace
	pop af
; 893     }
; 894     PrintHexByte(a);
	call printhexbyte
; 895     return;
	ret
; 896 }
; 897 
; 898 // Команда L<начало>,<конец>
; 899 // Посмотр области памяти в символьном виде
; 900 
; 901 void CmdL() {
cmdl:
; 902     ParseParams();
	call parseparams
; 903     PrintLf();
	call printlf
; 904 
; 905 CmdLLine:
cmdlline:
; 906     PrintLfParam1();
	call printlfparam1
; 907 
; 908     for (;;) {
l_63:
; 909         PrintSpace();
	call printspace
; 910         hl = param1;
	ld hl, (param1)
; 911         a = *hl;
	ld a, (hl)
; 912         if (a >= 0x20) {
	cp 32
	jp c, l_65
; 913             if (a < 0x80) {
	cp 128
	jp nc, l_67
; 914                 goto CmdLShow;
	jp cmdlshow
l_67:
l_65:
; 915             }
; 916         }
; 917         a = '.';
	ld a, 46
; 918     CmdLShow:
cmdlshow:
; 919         PrintCharA();
	call printchara
; 920         Loop();
	call loop
; 921         if (flag_z((a = param1) &= 0x0F))
	ld a, (param1)
	and 15
; 922             goto CmdLLine;
	jp z, cmdlline
	jp l_63
; 923     }
; 924 }
; 925 
; 926 // Команда H<число 1>,<число 2>
; 927 // Сложение и вычитание чисел
; 928 
; 929 void CmdH(...) {
cmdh:
; 930     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 931     b = 6;
	ld b, 6
; 932     a ^= a;
	xor a
; 933     do {
l_69:
; 934         *hl = a;
	ld (hl), a
l_70:
; 935     } while (flag_nz(b--));
	dec b
	jp nz, l_69
; 936 
; 937     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 938 
; 939     ParseWord();
	call parseword
; 940     param1 = hl;
	ld (param1), hl
; 941 
; 942     ParseWord();
	call parseword
; 943     param2 = hl;
	ld (param2), hl
; 944 
; 945     PrintLf();
	call printlf
; 946     param3 = hl = param1;
	ld hl, (param1)
	ld (param3), hl
; 947     swap(hl, de);
	ex hl, de
; 948     hl = param2;
	ld hl, (param2)
; 949     hl += de;
	add hl, de
; 950     param1 = hl;
	ld (param1), hl
; 951     PrintParam1Space();
	call printparam1space
; 952 
; 953     hl = param2;
	ld hl, (param2)
; 954     swap(hl, de);
	ex hl, de
; 955     hl = param3;
	ld hl, (param3)
; 956     a = e;
	ld a, e
; 957     invert(a);
	cpl
; 958     e = a;
	ld e, a
; 959     a = d;
	ld a, d
; 960     invert(a);
	cpl
; 961     d = a;
	ld d, a
; 962     de++;
	inc de
; 963     hl += de;
	add hl, de
; 964     param1 = hl;
	ld (param1), hl
; 965     PrintParam1Space();
	call printparam1space
; 966     PrintLf();
	jp printlf
; 967 }
; 968 
; 969 // Команда I
; 970 // Ввод информации с магнитной ленты
; 971 
; 972 void CmdI() {
cmdi:
; 973     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 974     param1h = a;
	ld (param1h), a
; 975     tapeStartH = a;
	ld (tapestarth), a
; 976 
; 977     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 978     param1 = a;
	ld (param1), a
; 979     tapeStartL = a;
	ld (tapestartl), a
; 980 
; 981     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 982     param2h = a;
	ld (param2h), a
; 983     tapeStopH = a;
	ld (tapestoph), a
; 984 
; 985     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 986     param2 = a;
	ld (param2), a
; 987     tapeStopL = a;
	ld (tapestopl), a
; 988 
; 989     a = READ_TAPE_NEXT_BYTE;
	ld a, 8
; 990     hl = &CmdIEnd;
	ld hl, 0FFFFh & (cmdiend)
; 991     push(hl);
	push hl
; 992 
; 993     for (;;) {
l_73:
; 994         hl = param1;
	ld hl, (param1)
; 995         ReadTapeByte(a);
	call readtapebyte
; 996         *hl = a;
	ld (hl), a
; 997         Loop();
	call loop
; 998         a = READ_TAPE_NEXT_BYTE;
	ld a, 8
	jp l_73
; 999     }
; 1000 }
; 1001 
; 1002 void CmdIEnd(...) {
cmdiend:
; 1003     PrintHexWordSpace(hl = &tapeStartH);
	ld hl, 0FFFFh & (tapestarth)
	call printhexwordspace
; 1004     PrintHexWordSpace(hl = &tapeStopH);
	ld hl, 0FFFFh & (tapestoph)
	call printhexwordspace
; 1005     PrintLf();
	jp printlf
; 1006 }
; 1007 
; 1008 // Команда O<начало>,<конец>
; 1009 // Вывод содержимого области памяти на магнитную ленту
; 1010 
; 1011 void CmdO() {
cmdo:
; 1012     ParseParams();
	call parseparams
; 1013     a ^= a;
	xor a
; 1014     b = 0;
	ld b, 0
; 1015     do {
l_75:
; 1016         WriteTapeByte(a);
	call writetapebyte
l_76:
; 1017     } while (flag_nz(b--));
	dec b
	jp nz, l_75
; 1018     WriteTapeByte(a = TAPE_START);
	ld a, 230
	call writetapebyte
; 1019     WriteTapeByte(a = param1h);
	ld a, (param1h)
	call writetapebyte
; 1020     WriteTapeByte(a = param1);
	ld a, (param1)
	call writetapebyte
; 1021     WriteTapeByte(a = param2h);
	ld a, (param2h)
	call writetapebyte
; 1022     WriteTapeByte(a = param2);
	ld a, (param2)
	call writetapebyte
; 1023     for (;;) {
l_79:
; 1024         hl = param1;
	ld hl, (param1)
; 1025         a = *hl;
	ld a, (hl)
; 1026         WriteTapeByte(a);
	call writetapebyte
; 1027         Loop();
	call loop
	jp l_79
; 1028     }
; 1029 }
; 1030 
; 1031 // Команда V
; 1032 // Сравнение информации на магнитной ленте с содержимым области памяти
; 1033 
; 1034 void CmdV() {
cmdv:
; 1035     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 1036     param1h = a;
	ld (param1h), a
; 1037     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1038     param1 = a;
	ld (param1), a
; 1039     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1040     param2h = a;
	ld (param2h), a
; 1041     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1042     param2 = a;
	ld (param2), a
; 1043     for (;;) {
l_82:
; 1044         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1045         hl = param1;
	ld hl, (param1)
; 1046         if (a != *hl) {
	cp (hl)
	jp z, l_84
; 1047             push_pop(a) {
	push af
; 1048                 PrintLfParam1();
	call printlfparam1
; 1049                 PrintSpace();
	call printspace
; 1050                 PrintByteFromParam1();
	call printbytefromparam1
; 1051                 PrintSpace();
	call printspace
	pop af
; 1052             }
; 1053             PrintHexByte();
	call printhexbyte
l_84:
; 1054         }
; 1055         Loop();
	call loop
	jp l_82
; 1056     }
; 1057 }
; 1058 
; 1059 void ReadTapeByte(...) {
readtapebyte:
; 1060     push(bc, de);
	push bc
	push de
; 1061     c = 0;
	ld c, 0
; 1062     d = a;
	ld d, a
; 1063     e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 1064     do {
l_86:
; 1065     loc_FD9D:
loc_fd9d:
; 1066         a = c;
	ld a, c
; 1067         a &= 0x7F;
	and 127
; 1068         cyclic_rotate_left(a, 1);
	rlca
; 1069         c = a;
	ld c, a
; 1070 
; 1071         do {
l_89:
; 1072             a = in(PORT_TAPE);
	in a, (1)
l_90:
; 1073         } while (a == e);
	cp e
	jp z, l_89
; 1074         a &= 1;
	and 1
; 1075         a |= c;
	or c
; 1076         c = a;
	ld c, a
; 1077         ReadTapeDelay();
	call readtapedelay
; 1078         e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 1079         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_92
; 1080             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_94
; 1081                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_95
l_94:
; 1082             } else {
; 1083                 if (a != (0xFF ^ TAPE_START))
	cp 25
; 1084                     goto loc_FD9D;
	jp nz, loc_fd9d
; 1085                 tapePolarity = a = 0xFF;
	ld a, 255
	ld (tapepolarity), a
l_95:
; 1086             }
; 1087             d = 8 + 1;
	ld d, 9
l_92:
l_87:
; 1088         }
; 1089     } while (flag_nz(d--));
	dec d
	jp nz, l_86
; 1090     a = tapePolarity;
	ld a, (tapepolarity)
; 1091     a ^= c;
	xor c
; 1092     pop(bc, de);
	pop de
	pop bc
	ret
; 1093 }
; 1094 
; 1095 void ReadTapeDelay(...) {
readtapedelay:
; 1096     push(a);
	push af
; 1097     TapeDelay(a = readDelay);
	ld a, (readdelay)
; 1098 }
; 1099 
; 1100 void TapeDelay(...) {
tapedelay:
; 1101     b = a;
	ld b, a
; 1102     pop(a);
	pop af
; 1103     do {
l_96:
l_97:
; 1104     } while (flag_nz(b--));
	dec b
	jp nz, l_96
	ret
; 1105 }
; 1106 
; 1107 void WriteTapeByte(...) {
writetapebyte:
; 1108     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1109         d = a;
	ld d, a
; 1110         c = 8;
	ld c, 8
; 1111         do {
l_99:
; 1112             a = d;
	ld a, d
; 1113             cyclic_rotate_left(a, 1);
	rlca
; 1114             d = a;
	ld d, a
; 1115 
; 1116             out(PORT_TAPE, (a = 1) ^= d);
	ld a, 1
	xor d
	out (1), a
; 1117             WriteTapeDelay();
	call writetapedelay
; 1118 
; 1119             out(PORT_TAPE, (a = 0) ^= d);
	ld a, 0
	xor d
	out (1), a
; 1120             WriteTapeDelay();
	call writetapedelay
l_100:
; 1121         } while (flag_nz(c--));
	dec c
	jp nz, l_99
	pop af
	pop de
	pop bc
	ret
; 1122     }
; 1123 }
; 1124 
; 1125 void WriteTapeDelay(...) {
writetapedelay:
; 1126     push(a);
	push af
; 1127     TapeDelay(a = writeDelay);
	ld a, (writedelay)
	jp tapedelay
; 1128 }
; 1129 
; 1130 uint8_t monitorCommands = 'M';
monitorcommands:
	db 77
; 1131  monitorCommandsMa = (uintptr_t)&CmdM;
monitorcommandsma:
	dw 0FFFFh & (cmdm)
; 1132  monitorCommandsC = 'C';
monitorcommandsc:
	db 67
; 1133  monitorCommandsCa = (uintptr_t)&CmdC;
monitorcommandsca:
	dw 0FFFFh & (cmdc)
; 1134  monitorCommandsD = 'D';
monitorcommandsd:
	db 68
; 1135  monitorCommandsDa = (uintptr_t)&CmdD;
monitorcommandsda:
	dw 0FFFFh & (cmdd)
; 1136  monitorCommandsB = 'B';
monitorcommandsb:
	db 66
; 1137  monitorCommandsBa = (uintptr_t)&CmdB;
monitorcommandsba:
	dw 0FFFFh & (cmdb)
; 1138  monitorCommandsG = 'G';
monitorcommandsg:
	db 71
; 1139  monitorCommandsGa = (uintptr_t)&CmdG;
monitorcommandsga:
	dw 0FFFFh & (cmdg)
; 1140  monitorCommandsP = 'P';
monitorcommandsp:
	db 80
; 1141  monitorCommandsPa = (uintptr_t)&CmdP;
monitorcommandspa:
	dw 0FFFFh & (cmdp)
; 1142  monitorCommandsX = 'X';
monitorcommandsx:
	db 88
; 1143  monitorCommandsXa = (uintptr_t)&CmdX;
monitorcommandsxa:
	dw 0FFFFh & (cmdx)
; 1144  monitorCommandsF = 'F';
monitorcommandsf:
	db 70
; 1145  monitorCommandsFa = (uintptr_t)&CmdF;
monitorcommandsfa:
	dw 0FFFFh & (cmdf)
; 1146  monitorCommandsS = 'S';
monitorcommandss:
	db 83
; 1147  monitorCommandsSa = (uintptr_t)&CmdS;
monitorcommandssa:
	dw 0FFFFh & (cmds)
; 1148  monitorCommandsT = 'T';
monitorcommandst:
	db 84
; 1149  monitorCommandsTa = (uintptr_t)&CmdT;
monitorcommandsta:
	dw 0FFFFh & (cmdt)
; 1150  monitorCommandsI = 'I';
monitorcommandsi:
	db 73
; 1151  monitorCommandsIa = (uintptr_t)&CmdI;
monitorcommandsia:
	dw 0FFFFh & (cmdi)
; 1152  monitorCommandsO = 'O';
monitorcommandso:
	db 79
; 1153  monitorCommandsOa = (uintptr_t)&CmdO;
monitorcommandsoa:
	dw 0FFFFh & (cmdo)
; 1154  monitorCommandsV = 'V';
monitorcommandsv:
	db 86
; 1155  monitorCommandsVa = (uintptr_t)&CmdV;
monitorcommandsva:
	dw 0FFFFh & (cmdv)
; 1156  monitorCommandsJ = 'J';
monitorcommandsj:
	db 74
; 1157  monitorCommandsJa = (uintptr_t)&CmdJ;
monitorcommandsja:
	dw 0FFFFh & (cmdj)
; 1158  monitorCommandsA = 'A';
monitorcommandsa:
	db 65
; 1159  monitorCommandsAa = (uintptr_t)&CmdA;
monitorcommandsaa:
	dw 0FFFFh & (cmda)
; 1160  monitorCommandsK = 'K';
monitorcommandsk:
	db 75
; 1161  monitorCommandsKa = (uintptr_t)&CmdK;
monitorcommandska:
	dw 0FFFFh & (cmdk)
; 1162  monitorCommandsQ = 'Q';
monitorcommandsq:
	db 81
; 1163  monitorCommandsQa = (uintptr_t)&CmdQ;
monitorcommandsqa:
	dw 0FFFFh & (cmdq)
; 1164  monitorCommandsL = 'L';
monitorcommandsl:
	db 76
; 1165  monitorCommandsLa = (uintptr_t)&CmdL;
monitorcommandsla:
	dw 0FFFFh & (cmdl)
; 1166  monitorCommandsH = 'H';
monitorcommandsh:
	db 72
; 1167  monitorCommandsHa = (uintptr_t)&CmdH;
monitorcommandsha:
	dw 0FFFFh & (cmdh)
; 1168  monitorCommandsEnd = 0;
monitorcommandsend:
	db 0
; 1170  aPrompt[] = "\x0A*MikrO/80* MONITOR\x0A>";
aprompt:
	db 10
	db 42
	db 77
	db 105
	db 107
	db 114
	db 79
	db 47
	db 56
	db 48
	db 42
	db 32
	db 77
	db 79
	db 78
	db 73
	db 84
	db 79
	db 82
	db 10
	db 62
	ds 1
; 1171  aLf[] = "\x0A";
alf:
	db 10
	ds 1
; 1173  PrintCharA(...) {
printchara:
; 1174     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1175     PrintCharInt(c = a);
	ld c, a
	jp printcharint
; 1176 }
; 1177 
; 1178 void PrintChar(...) {
printchar:
; 1179     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1180     return PrintCharInt(c);
; 1181 }
; 1182 
; 1183 void PrintCharInt(...) {
printcharint:
; 1184     hl = cursor;
	ld hl, (cursor)
; 1185     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1186     hl += de;
	add hl, de
; 1187     *hl = SCREEN_ATTRIB_DEFAULT;
	ld (hl), 0
; 1188 
; 1189     hl = cursor;
	ld hl, (cursor)
; 1190     a = c;
	ld a, c
; 1191     if (a == 0x1F)
	cp 31
; 1192         return ClearScreen();
	jp z, clearscreen
; 1193     if (a == 0x08)
	cp 8
; 1194         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1195     if (a == 0x18)
	cp 24
; 1196         return MoveCursorRight(hl);
	jp z, movecursorright
; 1197     if (a == 0x19)
	cp 25
; 1198         return MoveCursorUp(hl);
	jp z, movecursorup
; 1199     if (a == 0x1A)
	cp 26
; 1200         return MoveCursorDown(hl);
	jp z, movecursordown
; 1201     if (a == 0x0A)
	cp 10
; 1202         return MoveCursorNextLine(hl);
	jp z, movecursornextline
; 1203     if (a == 0x0C)
	cp 12
; 1204         return MoveCursorHome();
	jp z, movecursorhome
; 1205 
; 1206     if ((a = h) == SCREEN_END >> 8) {
	ld a, h
	cp 65520
	jp nz, l_102
; 1207         IsAnyKeyPressed();
	call isanykeypressed
; 1208         if (a != 0) {
	or a
	jp z, l_104
; 1209             ReadKey();
	call readkey
l_104:
; 1210         }
; 1211         ClearScreenInt();
	call clearscreenint
; 1212         hl = SCREEN_BEGIN;
	ld hl, 59392
l_102:
; 1213     }
; 1214     *hl = c;
	ld (hl), c
; 1215     hl++;
	inc hl
; 1216     return MoveCursor();
; 1217 }
; 1218 
; 1219 void MoveCursor(...) {
movecursor:
; 1220     cursor = hl;
	ld (cursor), hl
; 1221     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1222     hl += de;
	add hl, de
; 1223     *hl = SCREEN_ATTRIB_DEFAULT | SCREEN_ATTRIB_UNDERLINE;
	ld (hl), 128
; 1224     pop(hl, bc, de, a);
	pop af
	pop de
	pop bc
	pop hl
	ret
; 1225 }
; 1226 
; 1227 void ClearScreen() {
clearscreen:
; 1228     ClearScreenInt();
	call clearscreenint
; 1229     MoveCursorHome();
; 1230 }
; 1231 
; 1232 void MoveCursorHome() {
movecursorhome:
; 1233     MoveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp movecursor
; 1234 }
; 1235 
; 1236 void ClearScreenInt() {
clearscreenint:
; 1237     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1238     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1239     for (;;) {
l_107:
; 1240         *hl = ' ';
	ld (hl), 32
; 1241         hl++;
	inc hl
; 1242         a = 0;
	ld a, 0
; 1243         *de = a;
	ld (de), a
; 1244         de++;
	inc de
; 1245         a = h;
	ld a, h
; 1246         if (a == SCREEN_END >> 8)
	cp 65520
; 1247             return;
	ret z
	jp l_107
; 1248     }
; 1249 }
; 1250 
; 1251 void MoveCursorRight(...) {
movecursorright:
; 1252     hl++;
	inc hl
; 1253     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1254         return MoveCursor(hl);
	jp nz, movecursor
; 1255     if (flag_z)  // Лишнее
; 1256         return MoveCursorHome();
	jp z, movecursorhome
; 1257     MoveCursorLeft(hl);  // Лишнее
; 1258 }
; 1259 
; 1260 void MoveCursorLeft(...) {
movecursorleft:
; 1261     hl--;
	dec hl
; 1262     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1263         return MoveCursor(hl);
	jp nz, movecursor
; 1264     MoveCursor(hl = SCREEN_END - 1);
	ld hl, 61439
	jp movecursor
; 1265 }
; 1266 
; 1267 void MoveCursorDown(...) {
movecursordown:
; 1268     hl += (de = SCREEN_WIDTH);
	ld de, 64
	add hl, de
; 1269     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1270         return MoveCursor(hl);
	jp nz, movecursor
; 1271     h = SCREEN_BEGIN >> 8;
	ld h, 232
; 1272     MoveCursor(hl);
	jp movecursor
; 1273 }
; 1274 
; 1275 void MoveCursorUp(...) {
movecursorup:
; 1276     hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
; 1277     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1278         return MoveCursor(hl);
	jp nz, movecursor
; 1279     hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 2048
	add hl, de
; 1280     MoveCursor(hl);
	jp movecursor
; 1281 }
; 1282 
; 1283 void MoveCursorNextLine(...) {
movecursornextline:
; 1284     for (;;) {
l_110:
; 1285         hl++;
	inc hl
; 1286         a = l;
	ld a, l
; 1287         if (a == SCREEN_WIDTH * 0)
	or a
; 1288             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1289         if (a == SCREEN_WIDTH * 1)
	cp 64
; 1290             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1291         if (a == SCREEN_WIDTH * 2)
	cp 128
; 1292             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1293         if (a == SCREEN_WIDTH * 3)
	cp 192
; 1294             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
	jp l_110
; 1295     }
; 1296 }
; 1297 
; 1298 void MoveCursorNextLine1(...) {
movecursornextline1:
; 1299     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1300         return MoveCursor(hl);
	jp nz, movecursor
; 1301 
; 1302     IsAnyKeyPressed();
	call isanykeypressed
; 1303     if (a == 0)
	or a
; 1304         return ClearScreen();
	jp z, clearscreen
; 1305     ReadKey();
	call readkey
; 1306     ClearScreen();
	jp clearscreen
; 1307 }
; 1308 
; 1309 void ReadKey() {
readkey:
; 1310     push(bc, de, hl);
	push bc
	push de
	push hl
; 1311 
; 1312     for (;;) {
l_113:
; 1313         b = 0;
	ld b, 0
; 1314         c = 1 ^ 0xFF;
	ld c, 254
; 1315         d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1316         do {
l_115:
; 1317             out(PORT_KEYBOARD_COLUMN, a = c);
	ld a, c
	out (7), a
; 1318             cyclic_rotate_left(a, 1);
	rlca
; 1319             c = a;
	ld c, a
; 1320             a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1321             a &= KEYBOARD_ROW_MASK;
	and 127
; 1322             if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1323                 return ReadKey1(a, b);
	jp nz, readkey1
; 1324             b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_116:
; 1325         } while (flag_nz(d--));
	dec d
	jp nz, l_115
	jp l_113
; 1326     }
; 1327 }
; 1328 
; 1329 void ReadKey1(...) {
readkey1:
; 1330     keyLast = a;
	ld (keylast), a
; 1331 
; 1332     for (;;) {
l_119:
; 1333         carry_rotate_right(a, 1);
	rra
; 1334         if (flag_nc)
; 1335             break;
	jp nc, l_120
; 1336         b++;
	inc b
	jp l_119
l_120:
; 1337     }
; 1338 
; 1339     // b - key number
; 1340 
; 1341     //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1342     //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1343     // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1344     // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1345     // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1346     // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1347     // 48   Space Right Left  Up    Down  Vk    Str   Home
; 1348 
; 1349     a = b;
	ld a, b
; 1350     if (a < 48) {
	cp 48
	jp nc, l_121
; 1351         a += '0';
	add 48
; 1352         if (a >= 0x3C)
	cp 60
; 1353             if (a < 0x40)
	jp c, l_123
	cp 64
; 1354                 a &= 0x2F;  // <=>? to .-./
	jp nc, l_125
	and 47
l_125:
l_123:
; 1355         c = a;
	ld c, a
	jp l_122
l_121:
; 1356     } else {
; 1357         hl = &keyTable;
	ld hl, keytable
; 1358         a -= 48;
	sub 48
; 1359         c = a;
	ld c, a
; 1360         b = 0;
	ld b, 0
; 1361         hl += bc;
	add hl, bc
; 1362         a = *hl;
	ld a, (hl)
; 1363         return ReadKey2(a);
	jp readkey2
l_122:
; 1364     }
; 1365 
; 1366     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1367     a &= KEYBOARD_MODS_MASK;
	and 7
; 1368     if (a == KEYBOARD_MODS_MASK)
	cp 7
; 1369         goto ReadKeyNoMods;
	jp z, readkeynomods
; 1370     carry_rotate_right(a, 2);
	rra
	rra
; 1371     if (flag_nc)
; 1372         goto ReadKeyControl;
	jp nc, readkeycontrol
; 1373     carry_rotate_right(a, 1);
	rra
; 1374     if (flag_nc)
; 1375         goto ReadKeyShift;
	jp nc, readkeyshift
; 1376 
; 1377     // RUS key pressed
; 1378     a = c;
	ld a, c
; 1379     a |= 0x20;
	or 32
; 1380     return ReadKey2(a);
	jp readkey2
; 1381 
; 1382     // US (Control) key pressed
; 1383 ReadKeyControl:
readkeycontrol:
; 1384     a = c;
	ld a, c
; 1385     a &= 0x1F;
	and 31
; 1386     return ReadKey2(a);
	jp readkey2
; 1387 
; 1388     // SS (Shift) key pressed
; 1389 ReadKeyShift:
readkeyshift:
; 1390     a = c;
	ld a, c
; 1391     if (a >= 0x40)  // @ A-Z [ \ ] ^ _
	cp 64
; 1392         return ReadKey2(a);
	jp nc, readkey2
; 1393     if (a < 0x30) {  // .-./ to <=>?
	cp 48
	jp nc, l_127
; 1394         a |= 0x10;
	or 16
; 1395         return ReadKey2(a);
	jp readkey2
l_127:
; 1396     }
; 1397     a &= 0x2F;  // 0123456789:; to !@#$%&'()*+
	and 47
; 1398     return ReadKey2(a);
	jp readkey2
; 1399 
; 1400 ReadKeyNoMods:
readkeynomods:
; 1401     ReadKey2(a = c);
	ld a, c
; 1402 }
; 1403 
; 1404 void ReadKey2(...) {
readkey2:
; 1405     c = a;
	ld c, a
; 1406 
; 1407     ReadKeyDelay();
	call readkeydelay
; 1408 
; 1409     hl = &keyLast;
	ld hl, 0FFFFh & (keylast)
; 1410     do {
l_129:
; 1411         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
l_130:
; 1412     } while (a == *hl);
	cp (hl)
	jp z, l_129
; 1413 
; 1414     ReadKeyDelay();
	call readkeydelay
; 1415 
; 1416     a = c;
	ld a, c
; 1417     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1418 }
; 1419 
; 1420 void ReadKeyDelay() {
readkeydelay:
; 1421     de = 0x1000;
	ld de, 4096
; 1422     for (;;) {
l_133:
; 1423         de--;
	dec de
; 1424         if (flag_z((a = d) |= e))
	ld a, d
	or e
; 1425             return;
	ret z
	jp l_133
; 1426     }
; 1427 }
; 1428 
; 1429 uint8_t keyTable[] = {
keytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1440  IsAnyKeyPressed() {
isanykeypressed:
; 1441     out(PORT_KEYBOARD_COLUMN, a = 0);
	ld a, 0
	out (7), a
; 1442     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1443     a &= KEYBOARD_ROW_MASK;
	and 127
; 1444     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_135
; 1445         a ^= a;  // Returns 0 if no key is pressed
	xor a
; 1446         return;
	ret
l_135:
; 1447     }
; 1448     a = 0xFF;  // Returns 0xFF if there are any keys pressed
	ld a, 255
	ret
 savebin "micro80.bin", 0xF800, 0x10000
