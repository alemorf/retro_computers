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
; 47  uint8_t rst38Opcode __address(0x38);
; 48 extern uint16_t rst38Address __address(0x39);
; 49 
; 50 // Прототипы
; 51 void Reboot();
; 52 void ReadKey();
; 53 void ReadKey0();
; 54 void ReadKey1(...);
; 55 void ReadKey2(...);
; 56 void ReadKeyDelay();
; 57 void ReadTapeByte(...);
; 58 void PrintChar(...);
; 59 void WriteTapeByte(...);
; 60 void PrintChar(...);
; 61 void IsAnyKeyPressed();
; 62 void PrintHexByte(...);
; 63 void PrintString(...);
; 64 void Monitor();
; 65 void MonitorExecute();
; 66 void PrintCharA(...);
; 67 void ReadString();
; 68 void MonitorError();
; 69 void ReadStringLoop(...);
; 70 void CommonBs(...);
; 71 void PrintSpace(...);
; 72 void InputBs(...);
; 73 void InputEndSpace(...);
; 74 void PopWordReturn(...);
; 75 void InputLoop(...);
; 76 void InputInit(...);
; 77 void ParseWord(...);
; 78 void CompareHlDe(...);
; 79 void ParseWordReturnCf(...);
; 80 void PrintHex(...);
; 81 void PrintParam1Space();
; 82 void PrintHexWordSpace(...);
; 83 void IncWord(...);
; 84 void PrintRegs();
; 85 void CmdXS(...);
; 86 void FindRegister(...);
; 87 void ReadKey(...);
; 88 void PrintRegMinus(...);
; 89 void InitRst38();
; 90 void BreakPoint(...);
; 91 void BreakPointAt2(...);
; 92 void BreakpointAt3(...);
; 93 void Run();
; 94 void ContinueBreakpoint(...);
; 95 void CmdQResult(...);
; 96 void CmdIEnd(...);
; 97 void ReadTapeDelay(...);
; 98 void PrintCharInt(...);
; 99 void WriteTapeDelay(...);
; 100 void TapeDelay(...);
; 101 void ClearScreen();
; 102 void MoveCursorLeft(...);
; 103 void MoveCursorRight(...);
; 104 void MoveCursorUp(...);
; 105 void MoveCursorDown(...);
; 106 void MoveCursorNextLine(...);
; 107 void MoveCursorHome();
; 108 void ClearScreenInt();
; 109 void MoveCursor(...);
; 110 void MoveCursorNextLine1(...);
; 111 void ReadStringBs(...);
; 112 void ReadStringCr(...);
; 113 
; 114 extern uint8_t aPrompt[22];
; 115 extern uint8_t monitorCommands;
; 116 extern uint8_t regList[19];
; 117 extern uint8_t aLf[2];
; 118 extern uint8_t keyTable[8];
; 119 
; 120 // Переменные монитора
; 121 void jumpParam1(void) __address(0xF750);
; 122 extern uint8_t jumpOpcode __address(0xF750);
; 123 extern uint16_t param1 __address(0xF751);
; 124 extern uint8_t param1h __address(0xF752);
; 125 extern uint16_t param2 __address(0xF753);
; 126 extern uint8_t param2h __address(0xF754);
; 127 extern uint16_t param3 __address(0xF755);
; 128 extern uint8_t param3h __address(0xF756);
; 129 extern uint8_t tapePolarity __address(0xF757);
; 130 // Unused 0xF758
; 131 // Unused 0xF759
; 132 extern uint16_t cursor __address(0xF75A);
; 133 extern uint8_t readDelay __address(0xF75C);
; 134 extern uint8_t writeDelay __address(0xF75D);
; 135 extern uint8_t tapeStartL __address(0xF75E);
; 136 extern uint8_t tapeStartH __address(0xF75F);
; 137 extern uint8_t tapeStopL __address(0xF760);
; 138 extern uint8_t tapeStopH __address(0xF761);
; 139 // Unused 0xF762
; 140 // Unused 0xF763
; 141 extern uint8_t keyLast __address(0xF764);
; 142 extern uint16_t regs __address(0xF765);
; 143 extern uint16_t regSP __address(0xF765);
; 144 extern uint8_t regSPH __address(0xF766);
; 145 extern uint16_t regF __address(0xF767);
; 146 extern uint16_t regA __address(0xF768);
; 147 extern uint16_t regC __address(0xF769);
; 148 extern uint16_t regB __address(0xF76A);
; 149 extern uint16_t regE __address(0xF76B);
; 150 extern uint16_t regD __address(0xF76C);
; 151 extern uint16_t regL __address(0xF76D);
; 152 extern uint16_t regHL __address(0xF76D);
; 153 extern uint16_t regH __address(0xF76E);
; 154 extern uint16_t lastBreakAddress __address(0xF76F);
; 155 extern uint8_t lastBreakAddressHigh __address(0xF770);
; 156 extern uint8_t breakCounter __address(0xF771);
; 157 extern uint16_t breakAddress __address(0xF772);
; 158 extern uint8_t breakPrevByte __address(0xF774);
; 159 extern uint16_t breakAddress2 __address(0xF775);
; 160 extern uint8_t breakPrevByte2 __address(0xF777);
; 161 extern uint16_t breakAddress3 __address(0xF778);
; 162 extern uint8_t breakPrevByte3 __address(0xF77A);
; 163 extern uint8_t cmdBuffer __address(0xF77B);
; 164 extern uint8_t cmdBuffer1 __address(0xF77B + 1);
; 165 extern uint8_t cmdBufferEnd __address(0xF77B + 32);
; 166 
; 167 const int USER_STACK_TOP = 0xF7C0;
; 168 const int STACK_TOP = 0xF7FF;
; 169 
; 170 // Точки входа
; 171 
; 172 void EntryF800_Reboot() {
entryf800_reboot:
; 173     Reboot();
	jp reboot
; 174 }
; 175 
; 176 void EntryF803_ReadKey() {
entryf803_readkey:
; 177     ReadKey();
	jp readkey
; 178 }
; 179 
; 180 void EntryF806_ReadTapeByte(...) {
entryf806_readtapebyte:
; 181     ReadTapeByte(a);
	jp readtapebyte
; 182 }
; 183 
; 184 void EntryF809_PrintChar(...) {
entryf809_printchar:
; 185     PrintChar(c);
	jp printchar
; 186 }
; 187 
; 188 void EntryF80C_WriteTapeByte(...) {
entryf80c_writetapebyte:
; 189     WriteTapeByte(c);
	jp writetapebyte
; 190 }
; 191 
; 192 void EntryF80F_TranslateCodePage(...) {
entryf80f_translatecodepage:
; 193     PrintChar(c);
	jp printchar
; 194 }
; 195 
; 196 void EntryF812_IsAnyKeyPressed() {
entryf812_isanykeypressed:
; 197     IsAnyKeyPressed();
	jp isanykeypressed
; 198 }
; 199 
; 200 void EntryF815_PrintHexByte(...) {
entryf815_printhexbyte:
; 201     PrintHexByte(a);
	jp printhexbyte
; 202 }
; 203 
; 204 void EntryF818_PrintString(...) {
entryf818_printstring:
; 205     PrintString(hl);
	jp printstring
; 206 }
; 207 
; 208 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
; 209 // Параметры: нет. Функция никогда не завершается.
; 210 
; 211 void Reboot() {
reboot:
; 212     regSP = hl = USER_STACK_TOP;
	ld hl, 63424
	ld (regsp), hl
; 213     sp = STACK_TOP;
	ld sp, 63487
; 214     PrintCharA(a = 0x1F);  // Clear screen
	ld a, 31
	call printchara
; 215     Monitor();
; 216 }
; 217 
; 218 void Monitor() {
monitor:
; 219     out(PORT_KEYBOARD_MODE, a = 0x8B);
	ld a, 139
	out (4), a
; 220     sp = STACK_TOP;
	ld sp, 63487
; 221     PrintString(hl = &aPrompt);
	ld hl, aprompt
	call printstring
; 222     ReadString();
	call readstring
; 223     push(hl = &Monitor);
	ld hl, 0FFFFh & (monitor)
	push hl
; 224     MonitorExecute();
; 225 }
; 226 
; 227 void MonitorExecute() {
monitorexecute:
; 228     hl = &cmdBuffer;
	ld hl, 0FFFFh & (cmdbuffer)
; 229     b = *hl;
	ld b, (hl)
; 230     hl = &monitorCommands;
	ld hl, 0FFFFh & (monitorcommands)
; 231 
; 232     for (;;) {
l_1:
; 233         a = *hl;
	ld a, (hl)
; 234         if (flag_z(a &= a))
	and a
; 235             return MonitorError();
	jp z, monitorerror
; 236         if (a == b)
	cp b
; 237             break;
	jp z, l_2
; 238         hl++;
	inc hl
; 239         hl++;
	inc hl
; 240         hl++;
	inc hl
	jp l_1
l_2:
; 241     }
; 242 
; 243     hl++;
	inc hl
; 244     sp = hl;
	ld sp, hl
; 245     pop(hl);
	pop hl
; 246     sp = STACK_TOP - 2;
	ld sp, 63485
; 247     return hl();
	jp hl
; 248 }
; 249 
; 250 void ReadString() {
readstring:
; 251     return ReadStringLoop(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 252 }
; 253 
; 254 void ReadStringLoop(...) {
readstringloop:
; 255     do {
l_3:
; 256         ReadKey();
	call readkey
; 257         if (a == 8)
	cp 8
; 258             return ReadStringBs();
	jp z, readstringbs
; 259         if (flag_nz)
; 260             PrintCharA();
	call nz, printchara
; 261         *hl = a;
	ld (hl), a
; 262         if (a == 0x0D)
	cp 13
; 263             return ReadStringCr(hl);
	jp z, readstringcr
; 264         a = &cmdBufferEnd - 1;
	ld a, 0FFh & ((cmdbufferend) - (1))
; 265         compare(a, l);
	cp l
; 266         hl++;
	inc hl
l_4:
	jp nz, l_3
; 267     } while (flag_nz);
; 268     MonitorError();
; 269 }
; 270 
; 271 void MonitorError() {
monitorerror:
; 272     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 273     Monitor();
	jp monitor
; 274 }
; 275 
; 276 void ReadStringCr(...) {
readstringcr:
; 277     *hl = 0x0D;
	ld (hl), 13
	ret
; 278 }
; 279 
; 280 void ReadStringBs(...) {
readstringbs:
; 281     CommonBs();
	call commonbs
; 282     ReadStringLoop();
	jp readstringloop
; 283 }
; 284 
; 285 void CommonBs(...) {
commonbs:
; 286     if ((a = &cmdBuffer) == l)
	ld a, 0FFh & (cmdbuffer)
	cp l
; 287         return;
	ret z
; 288     PrintCharA(a = 8);
	ld a, 8
	call printchara
; 289     hl--;
	dec hl
	ret
; 290 }
; 291 
; 292 void Input(...) {
input:
; 293     PrintSpace();
	call printspace
; 294     InputInit(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 295 }
; 296 
; 297 void InputInit(...) {
inputinit:
; 298     InputLoop(b = 0);
	ld b, 0
; 299 }
; 300 
; 301 void InputLoop(...) {
inputloop:
; 302     for (;;) {
l_7:
; 303         ReadKey();
	call readkey
; 304         if (a == 8)
	cp 8
; 305             return InputBs();
	jp z, inputbs
; 306         if (flag_nz)
; 307             PrintCharA();
	call nz, printchara
; 308         *hl = a;
	ld (hl), a
; 309         if (a == ' ')
	cp 32
; 310             return InputEndSpace();
	jp z, inputendspace
; 311         if (a == 0x0D)
	cp 13
; 312             return PopWordReturn();
	jp z, popwordreturn
; 313         b = 0xFF;
	ld b, 255
; 314         if ((a = &cmdBufferEnd - 1) == l)
	ld a, 0FFh & ((cmdbufferend) - (1))
	cp l
; 315             return MonitorError();
	jp z, monitorerror
; 316         hl++;
	inc hl
	jp l_7
; 317     }
; 318 }
; 319 
; 320 void InputEndSpace(...) {
inputendspace:
; 321     *hl = 0x0D;
	ld (hl), 13
; 322     a = b;
	ld a, b
; 323     carry_rotate_left(a, 1);
	rla
; 324     de = &cmdBuffer;
	ld de, 0FFFFh & (cmdbuffer)
; 325     b = 0;
	ld b, 0
	ret
; 326 }
; 327 
; 328 void InputBs(...) {
inputbs:
; 329     CommonBs();
	call commonbs
; 330     if (flag_z)
; 331         return InputInit();
	jp z, inputinit
; 332     InputLoop();
	jp inputloop
; 333 }
; 334 
; 335 void PopWordReturn(...) {
popwordreturn:
; 336     sp++;
	inc sp
; 337     sp++;
	inc sp
	ret
; 338 }
; 339 
; 340 void PrintLf(...) {
printlf:
; 341     PrintString(hl = &aLf);
	ld hl, alf
; 342 }
; 343 
; 344 void PrintString(...) {
printstring:
; 345     for (;;) {
l_10:
; 346         a = *hl;
	ld a, (hl)
; 347         if (flag_z(a &= a))
	and a
; 348             return;
	ret z
; 349         PrintCharA(a);
	call printchara
; 350         hl++;
	inc hl
	jp l_10
; 351     }
; 352 }
; 353 
; 354 void ParseParams() {
parseparams:
; 355     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 356     b = 6;
	ld b, 6
; 357     a ^= a;
	xor a
; 358     do {
l_12:
; 359         *hl = a;
	ld (hl), a
l_13:
; 360     } while (flag_nz(b--));
	dec b
	jp nz, l_12
; 361 
; 362     de = &cmdBuffer + 1;
	ld de, 0FFFFh & ((cmdbuffer) + (1))
; 363     ParseWord();
	call parseword
; 364     param1 = hl;
	ld (param1), hl
; 365     param2 = hl;
	ld (param2), hl
; 366     if (flag_c)
; 367         return;
	ret c
; 368 
; 369     ParseWord();
	call parseword
; 370     param2 = hl;
	ld (param2), hl
; 371     push_pop(a, de) {
	push af
	push de
; 372         swap(hl, de);
	ex hl, de
; 373         hl = param1;
	ld hl, (param1)
; 374         swap(hl, de);
	ex hl, de
; 375         CompareHlDe();
	call comparehlde
; 376         if (flag_c)
; 377             return MonitorError();
	jp c, monitorerror
	pop de
	pop af
; 378     }
; 379     if (flag_c)
; 380         return;
	ret c
; 381 
; 382     ParseWord();
	call parseword
; 383     param3 = hl;
	ld (param3), hl
; 384     if (flag_c)
; 385         return;
	ret c
; 386 
; 387     MonitorError();
	jp monitorerror
; 388 }
; 389 
; 390 void ParseWord(...) {
parseword:
; 391     hl = 0;
	ld hl, 0
; 392     for (;;) {
l_16:
; 393         a = *de;
	ld a, (de)
; 394         de++;
	inc de
; 395         if (a == 13)
	cp 13
; 396             return ParseWordReturnCf(hl);
	jp z, parsewordreturncf
; 397         if (a == ',')
	cp 44
; 398             return;
	ret z
; 399         if (a == ' ')
	cp 32
; 400             continue;
	jp z, l_16
; 401         a -= '0';
	sub 48
; 402         if (flag_m)
; 403             return MonitorError();
	jp m, monitorerror
; 404         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_18
; 405             if (flag_m(compare(a, 17)))
	cp 17
; 406                 return MonitorError();
	jp m, monitorerror
; 407             if (flag_p(compare(a, 23)))
	cp 23
; 408                 return MonitorError();
	jp p, monitorerror
; 409             a -= 7;
	sub 7
l_18:
; 410         }
; 411         c = a;
	ld c, a
; 412         hl += hl;
	add hl, hl
; 413         hl += hl;
	add hl, hl
; 414         hl += hl;
	add hl, hl
; 415         hl += hl;
	add hl, hl
; 416         if (flag_c)
; 417             return MonitorError();
	jp c, monitorerror
; 418         hl += bc;
	add hl, bc
	jp l_16
; 419     }
; 420 }
; 421 
; 422 void ParseWordReturnCf(...) {
parsewordreturncf:
; 423     set_flag_c();
	scf
	ret
; 424 }
; 425 
; 426 void PrintByteFromParam1(...) {
printbytefromparam1:
; 427     hl = param1;
	ld hl, (param1)
; 428     PrintHexByte(a = *hl);
	ld a, (hl)
; 429 }
; 430 
; 431 void PrintHexByte(...) {
printhexbyte:
; 432     b = a;
	ld b, a
; 433     a = b;
	ld a, b
; 434     cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 435     PrintHex(a);
	call printhex
; 436     PrintHex(a = b);
	ld a, b
; 437 }
; 438 
; 439 void PrintHex(...) {
printhex:
; 440     a &= 0x0F;
	and 15
; 441     if (flag_p(compare(a, 10)))
	cp 10
; 442         a += 'A' - '0' - 10;
	jp m, l_20
	add 7
l_20:
; 443     a += '0';
	add 48
; 444     PrintCharA(a);
	jp printchara
; 445 }
; 446 
; 447 void PrintLfParam1(...) {
printlfparam1:
; 448     PrintLf();
	call printlf
; 449     PrintParam1Space();
; 450 }
; 451 
; 452 void PrintParam1Space() {
printparam1space:
; 453     PrintHexWordSpace(hl = &param1h);
	ld hl, 0FFFFh & (param1h)
; 454 }
; 455 
; 456 void PrintHexWordSpace(...) {
printhexwordspace:
; 457     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 458     hl--;
	dec hl
; 459     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 460     PrintSpace();
; 461 }
; 462 
; 463 void PrintSpace(...) {
printspace:
; 464     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 465 }
; 466 
; 467 void Loop(...) {
loop:
; 468     push_pop(de) {
	push de
; 469         hl = param1;
	ld hl, (param1)
; 470         swap(hl, de);
	ex hl, de
; 471         hl = param2;
	ld hl, (param2)
; 472         CompareHlDe(hl, de);
	call comparehlde
	pop de
; 473     }
; 474     if (flag_z)
; 475         return PopWordReturn();
	jp z, popwordreturn
; 476     IncWord(hl = &param1);
	ld hl, 0FFFFh & (param1)
; 477 }
; 478 
; 479 void IncWord(...) {
incword:
; 480     (*hl)++;
	inc (hl)
; 481     if (flag_nz)
; 482         return;
	ret nz
; 483     hl++;
	inc hl
; 484     (*hl)++;
	inc (hl)
	ret
; 485 }
; 486 
; 487 void CompareHlDe(...) {
comparehlde:
; 488     if ((a = h) != d)
	ld a, h
	cp d
; 489         return;
	ret nz
; 490     compare(a = l, e);
	ld a, l
	cp e
	ret
; 491 }
; 492 
; 493 // Команда X
; 494 // Изменение содержимого внутреннего регистра микропроцессора
; 495 
; 496 void CmdX() {
cmdx:
; 497     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 498     a = *hl;
	ld a, (hl)
; 499     if (a == 0x0D)
	cp 13
; 500         return PrintRegs();
	jp z, printregs
; 501     if (a == 'S')
	cp 83
; 502         return CmdXS();
	jp z, cmdxs
; 503     FindRegister(de = &regList);
	ld de, reglist
	call findregister
; 504     hl = &regs;
	ld hl, 0FFFFh & (regs)
; 505     de++;
	inc de
; 506     l = a = *de;
	ld a, (de)
	ld l, a
; 507     push_pop(hl) {
	push hl
; 508         PrintSpace();
	call printspace
; 509         PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 510         Input();
	call input
; 511         if (flag_nc)
; 512             return Monitor();
	jp nc, monitor
; 513         ParseWord();
	call parseword
; 514         a = l;
	ld a, l
	pop hl
; 515     }
; 516     *hl = a;
	ld (hl), a
	ret
; 517 }
; 518 
; 519 void CmdXS() {
cmdxs:
; 520     PrintSpace();
	call printspace
; 521     PrintHexWordSpace(hl = &regSPH);
	ld hl, 0FFFFh & (regsph)
	call printhexwordspace
; 522     Input();
	call input
; 523     if (flag_nc)
; 524         return Monitor();
	jp nc, monitor
; 525     ParseWord();
	call parseword
; 526     regSP = hl;
	ld (regsp), hl
	ret
; 527 }
; 528 
; 529 void FindRegister(...) {
findregister:
; 530     for (;;) {
l_23:
; 531         a = *de;
	ld a, (de)
; 532         if (flag_z(a &= a))
	and a
; 533             return MonitorError();
	jp z, monitorerror
; 534         if (a == *hl)
	cp (hl)
; 535             return;
	ret z
; 536         de++;
	inc de
; 537         de++;
	inc de
	jp l_23
; 538     }
; 539 }
; 540 
; 541 void PrintRegs(...) {
printregs:
; 542     de = &regList;
	ld de, reglist
; 543     b = 8;
	ld b, 8
; 544     PrintLf();
	call printlf
; 545     do {
l_25:
; 546         c = a = *de;
	ld a, (de)
	ld c, a
; 547         de++;
	inc de
; 548         push_pop(bc) {
	push bc
; 549             PrintRegMinus(c);
	call printregminus
; 550             a = *de;
	ld a, (de)
; 551             hl = &regs;
	ld hl, 0FFFFh & (regs)
; 552             l = a;
	ld l, a
; 553             PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
	pop bc
; 554         }
; 555         de++;
	inc de
l_26:
; 556     } while (flag_nz(b--));
	dec b
	jp nz, l_25
; 557 
; 558     c = a = *de;
	ld a, (de)
	ld c, a
; 559     PrintRegMinus();
	call printregminus
; 560     param1 = hl = regs;
	ld hl, (regs)
	ld (param1), hl
; 561     PrintParam1Space();
	call printparam1space
; 562     PrintRegMinus(c = 'O');
	ld c, 79
	call printregminus
; 563     PrintHexWordSpace(hl = &lastBreakAddressHigh);
	ld hl, 0FFFFh & (lastbreakaddresshigh)
	call printhexwordspace
; 564     PrintLf();
	jp printlf
; 565 }
; 566 
; 567 void PrintRegMinus(...) {
printregminus:
; 568     PrintSpace();
	call printspace
; 569     PrintCharA(a = c);
	ld a, c
	call printchara
; 570     PrintCharA(a = '-');
	ld a, 45
	jp printchara
; 571 }
; 572 
; 573 uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC,
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
; 578  aStart[] = "\x0ASTART-";
astart:
	db 10
	db 83
	db 84
	db 65
	db 82
	db 84
	db 45
	ds 1
; 579  aDir_[] = "\x0ADIR. -";
adir_:
	db 10
	db 68
	db 73
	db 82
	db 46
	db 32
	db 45
	ds 1
; 584  CmdB() {
cmdb:
; 585     ParseParams();
	call parseparams
; 586     InitRst38();
	call initrst38
; 587     hl = param1;
	ld hl, (param1)
; 588     a = *hl;
	ld a, (hl)
; 589     *hl = OPCODE_RST_38;
	ld (hl), 255
; 590     breakAddress = hl;
	ld (breakaddress), hl
; 591     breakPrevByte = a;
	ld (breakprevbyte), a
	ret
; 592 }
; 593 
; 594 void InitRst38() {
initrst38:
; 595     rst38Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst38opcode), a
; 596     rst38Address = hl = &BreakPoint;
	ld hl, 0FFFFh & (breakpoint)
	ld (rst38address), hl
	ret
; 597 }
; 598 
; 599 void BreakPoint(...) {
breakpoint:
; 600     regHL = hl;
	ld (reghl), hl
; 601     push(a);
	push af
; 602     hl = 4;
	ld hl, 4
; 603     hl += sp;
	add hl, sp
; 604     regs = hl;
	ld (regs), hl
; 605     pop(a);
	pop af
; 606     swap(*sp, hl);
	ex (sp), hl
; 607     hl--;
	dec hl
; 608     swap(*sp, hl);
	ex (sp), hl
; 609     sp = &regHL;
	ld sp, 0FFFFh & (reghl)
; 610     push(de, bc, a);
	push de
	push bc
	push af
; 611     sp = STACK_TOP;
	ld sp, 63487
; 612 
; 613     hl = regSP;
	ld hl, (regsp)
; 614     hl--;
	dec hl
; 615     d = *hl;
	ld d, (hl)
; 616     hl--;
	dec hl
; 617     e = *hl;
	ld e, (hl)
; 618     l = e;
	ld l, e
; 619     h = d;
	ld h, d
; 620     lastBreakAddress = hl;
	ld (lastbreakaddress), hl
; 621 
; 622     hl = breakAddress;
	ld hl, (breakaddress)
; 623     CompareHlDe();
	call comparehlde
; 624     if (flag_nz) {
	jp z, l_28
; 625         hl = breakAddress2;
	ld hl, (breakaddress2)
; 626         CompareHlDe(hl, de);
	call comparehlde
; 627         if (flag_z)
; 628             return BreakPointAt2();
	jp z, breakpointat2
; 629 
; 630         hl = breakAddress3;
	ld hl, (breakaddress3)
; 631         CompareHlDe(hl, de);
	call comparehlde
; 632         if (flag_z)
; 633             return BreakpointAt3();
	jp z, breakpointat3
; 634 
; 635         return MonitorError();
	jp monitorerror
l_28:
; 636     }
; 637     *hl = a = breakPrevByte;
	ld a, (breakprevbyte)
	ld (hl), a
; 638     breakAddress = hl = 0xFFFF;
	ld hl, 65535
	ld (breakaddress), hl
; 639     return Monitor();
	jp monitor
; 640 }
; 641 
; 642 // Команда G<адрес>
; 643 // Запуск программы в отладочном режиме
; 644 
; 645 void CmdG() {
cmdg:
; 646     ParseParams();
	call parseparams
; 647     if ((a = cmdBuffer1) == 0x0D)
	ld a, (cmdbuffer1)
	cp 13
; 648         param1 = hl = lastBreakAddress;
	jp nz, l_30
	ld hl, (lastbreakaddress)
	ld (param1), hl
l_30:
; 649     Run();
; 650 }
; 651 
; 652 void Run() {
run:
; 653     jumpOpcode = a = OPCODE_JMP;
	ld a, 195
	ld (jumpopcode), a
; 654     sp = &regs;
	ld sp, 0FFFFh & (regs)
; 655     pop(de, bc, a, hl);
	pop hl
	pop af
	pop bc
	pop de
; 656     sp = hl;
	ld sp, hl
; 657     hl = regHL;
	ld hl, (reghl)
; 658     jumpParam1();
	jp jumpparam1
; 659 }
; 660 
; 661 void CmdP(...) {
cmdp:
; 662     ParseParams();
	call parseparams
; 663     InitRst38();
	call initrst38
; 664 
; 665     breakAddress2 = hl = param1;
	ld hl, (param1)
	ld (breakaddress2), hl
; 666     a = *hl;
	ld a, (hl)
; 667     *hl = OPCODE_RST_38;
	ld (hl), 255
; 668     breakPrevByte2 = a;
	ld (breakprevbyte2), a
; 669 
; 670     breakAddress3 = hl = param2;
	ld hl, (param2)
	ld (breakaddress3), hl
; 671     a = *hl;
	ld a, (hl)
; 672     *hl = OPCODE_RST_38;
	ld (hl), 255
; 673     breakPrevByte3 = a;
	ld (breakprevbyte3), a
; 674 
; 675     breakCounter = a = param3;
	ld a, (param3)
	ld (breakcounter), a
; 676 
; 677     PrintString(hl = &aStart);
	ld hl, astart
	call printstring
; 678 
; 679     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 680     ReadStringLoop();
	call readstringloop
; 681     ParseParams();
	call parseparams
; 682     PrintString(hl = &aDir_);
	ld hl, adir_
	call printstring
; 683     ReadString();
	call readstring
; 684     Run();
	jp run
; 685 }
; 686 
; 687 void BreakPointAt2(...) {
breakpointat2:
; 688     *hl = a = breakPrevByte2;
	ld a, (breakprevbyte2)
	ld (hl), a
; 689 
; 690     hl = breakAddress3;
	ld hl, (breakaddress3)
; 691     a = OPCODE_RST_38;
	ld a, 255
; 692     if (a != *hl) {
	cp (hl)
	jp z, l_32
; 693         b = *hl;
	ld b, (hl)
; 694         *hl = a;
	ld (hl), a
; 695         breakPrevByte3 = a = b;
	ld a, b
	ld (breakprevbyte3), a
l_32:
; 696     }
; 697     ContinueBreakpoint();
; 698 }
; 699 
; 700 void ContinueBreakpoint(...) {
continuebreakpoint:
; 701     PrintRegs();
	call printregs
; 702     MonitorExecute();
	call monitorexecute
; 703     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 704     Run();
	jp run
; 705 }
; 706 
; 707 void BreakpointAt3(...) {
breakpointat3:
; 708     *hl = a = breakPrevByte3;
	ld a, (breakprevbyte3)
	ld (hl), a
; 709 
; 710     hl = breakAddress2;
	ld hl, (breakaddress2)
; 711     a = OPCODE_RST_38;
	ld a, 255
; 712     if (a == *hl)
	cp (hl)
; 713         return ContinueBreakpoint();
	jp z, continuebreakpoint
; 714     b = *hl;
	ld b, (hl)
; 715     *hl = a;
	ld (hl), a
; 716     breakPrevByte2 = a = b;
	ld a, b
	ld (breakprevbyte2), a
; 717 
; 718     hl = &breakCounter;
	ld hl, 0FFFFh & (breakcounter)
; 719     (*hl)--;
	dec (hl)
; 720     if (flag_nz)
; 721         return ContinueBreakpoint();
	jp nz, continuebreakpoint
; 722 
; 723     a = breakPrevByte2;
	ld a, (breakprevbyte2)
; 724     hl = breakAddress2;
	ld hl, (breakaddress2)
; 725     *hl = a;
	ld (hl), a
; 726     Monitor();
	jp monitor
; 727 }
; 728 
; 729 // Команда D<адрес>,<адрес>
; 730 // Просмотр содержимого области памяти в шестнадцатеричном виде
; 731 
; 732 void CmdD() {
cmdd:
; 733     ParseParams();
	call parseparams
; 734     PrintLf();
	call printlf
; 735 CmdDLine:
cmddline:
; 736     PrintLfParam1();
	call printlfparam1
; 737     for (;;) {
l_35:
; 738         PrintSpace();
	call printspace
; 739         PrintByteFromParam1();
	call printbytefromparam1
; 740         Loop();
	call loop
; 741         a = param1;
	ld a, (param1)
; 742         a &= 0x0F;
	and 15
; 743         if (flag_z)
; 744             goto CmdDLine;
	jp z, cmddline
	jp l_35
; 745     }
; 746 }
; 747 
; 748 // Команда C<адрес от>,<адрес до>,<адрес от 2>
; 749 // Сравнение содержимого двух областей памяти
; 750 
; 751 void CmdC() {
cmdc:
; 752     ParseParams();
	call parseparams
; 753     hl = param3;
	ld hl, (param3)
; 754     swap(hl, de);
	ex hl, de
; 755     for (;;) {
l_38:
; 756         hl = param1;
	ld hl, (param1)
; 757         a = *de;
	ld a, (de)
; 758         if (a != *hl) {
	cp (hl)
	jp z, l_40
; 759             PrintLfParam1();
	call printlfparam1
; 760             PrintSpace();
	call printspace
; 761             PrintByteFromParam1();
	call printbytefromparam1
; 762             PrintSpace();
	call printspace
; 763             a = *de;
	ld a, (de)
; 764             PrintHexByte();
	call printhexbyte
l_40:
; 765         }
; 766         de++;
	inc de
; 767         Loop();
	call loop
	jp l_38
; 768     }
; 769 }
; 770 
; 771 // Команда F<адрес>,<адрес>,<байт>
; 772 // Запись байта во все ячейки области памяти
; 773 
; 774 void CmdF() {
cmdf:
; 775     ParseParams();
	call parseparams
; 776     b = a = param3;
	ld a, (param3)
	ld b, a
; 777     for (;;) {
l_43:
; 778         hl = param1;
	ld hl, (param1)
; 779         *hl = b;
	ld (hl), b
; 780         Loop();
	call loop
	jp l_43
; 781     }
; 782 }
; 783 
; 784 // Команда S<адрес>,<адрес>,<байт>
; 785 // Поиск байта в области памяти
; 786 
; 787 void CmdS() {
cmds:
; 788     ParseParams();
	call parseparams
; 789     c = l;
	ld c, l
; 790     for (;;) {
l_46:
; 791         hl = param1;
	ld hl, (param1)
; 792         a = c;
	ld a, c
; 793         if (a == *hl)
	cp (hl)
; 794             PrintLfParam1();
	call z, printlfparam1
; 795         Loop();
	call loop
	jp l_46
; 796     }
; 797 }
; 798 
; 799 // Команда T<начало>,<конец>,<куда>
; 800 // Пересылка содержимого одной области в другую
; 801 
; 802 void CmdT() {
cmdt:
; 803     ParseParams();
	call parseparams
; 804     hl = param3;
	ld hl, (param3)
; 805     swap(hl, de);
	ex hl, de
; 806     for (;;) {
l_49:
; 807         hl = param1;
	ld hl, (param1)
; 808         *de = a = *hl;
	ld a, (hl)
	ld (de), a
; 809         de++;
	inc de
; 810         Loop();
	call loop
	jp l_49
; 811     }
; 812 }
; 813 
; 814 // Команда M<адрес>
; 815 // Просмотр или изменение содержимого ячейки (ячеек) памяти
; 816 
; 817 void CmdM() {
cmdm:
; 818     ParseParams();
	call parseparams
; 819     for (;;) {
l_52:
; 820         PrintSpace();
	call printspace
; 821         PrintByteFromParam1();
	call printbytefromparam1
; 822         Input();
	call input
; 823         if (flag_c) {
	jp nc, l_54
; 824             ParseWord();
	call parseword
; 825             a = l;
	ld a, l
; 826             hl = param1;
	ld hl, (param1)
; 827             *hl = a;
	ld (hl), a
l_54:
; 828         }
; 829         hl = &param1;
	ld hl, 0FFFFh & (param1)
; 830         IncWord();
	call incword
; 831         PrintLfParam1();
	call printlfparam1
	jp l_52
; 832     }
; 833 }
; 834 
; 835 // Команда J<адрес>
; 836 // Запуск программы с указанного адреса
; 837 
; 838 void CmdJ() {
cmdj:
; 839     ParseParams();
	call parseparams
; 840     hl = param1;
	ld hl, (param1)
; 841     return hl();
	jp hl
; 842 }
; 843 
; 844 // Команда А<символ>
; 845 // Вывод кода символа на экран
; 846 
; 847 void CmdA() {
cmda:
; 848     PrintLf();
	call printlf
; 849     PrintHexByte(a = cmdBuffer1);
	ld a, (cmdbuffer1)
	call printhexbyte
; 850     PrintLf();
	jp printlf
; 851 }
; 852 
; 853 // Команда K
; 854 // Вывод символа с клавиатуры на экран
; 855 
; 856 void CmdK() {
cmdk:
; 857     for (;;) {
l_57:
; 858         ReadKey();
	call readkey
; 859         if (a == 1)  // УС + А
	cp 1
; 860             return Monitor();
	jp z, monitor
; 861         PrintCharA(a);
	call printchara
	jp l_57
; 862     }
; 863 }
; 864 
; 865 // Команда Q<начало>,<конец>
; 866 // Тестирование области памяти
; 867 
; 868 void CmdQ() {
cmdq:
; 869     ParseParams();
	call parseparams
; 870     for (;;) {
l_60:
; 871         hl = param1;
	ld hl, (param1)
; 872         c = *hl;
	ld c, (hl)
; 873 
; 874         a = 0x55;
	ld a, 85
; 875         *hl = a;
	ld (hl), a
; 876         if (a != *hl)
	cp (hl)
; 877             CmdQResult();
	call nz, cmdqresult
; 878 
; 879         a = 0xAA;
	ld a, 170
; 880         *hl = a;
	ld (hl), a
; 881         if (a != *hl)
	cp (hl)
; 882             CmdQResult();
	call nz, cmdqresult
; 883 
; 884         *hl = c;
	ld (hl), c
; 885         Loop();
	call loop
	jp l_60
; 886     }
; 887 }
; 888 
; 889 void CmdQResult(...) {
cmdqresult:
; 890     push_pop(a) {
	push af
; 891         PrintLfParam1();
	call printlfparam1
; 892         PrintSpace();
	call printspace
; 893         PrintByteFromParam1();
	call printbytefromparam1
; 894         PrintSpace();
	call printspace
	pop af
; 895     }
; 896     PrintHexByte(a);
	call printhexbyte
; 897     return;
	ret
; 898 }
; 899 
; 900 // Команда L<начало>,<конец>
; 901 // Посмотр области памяти в символьном виде
; 902 
; 903 void CmdL() {
cmdl:
; 904     ParseParams();
	call parseparams
; 905     PrintLf();
	call printlf
; 906 
; 907 CmdLLine:
cmdlline:
; 908     PrintLfParam1();
	call printlfparam1
; 909 
; 910     for (;;) {
l_63:
; 911         PrintSpace();
	call printspace
; 912         hl = param1;
	ld hl, (param1)
; 913         a = *hl;
	ld a, (hl)
; 914         if (a >= 0x20) {
	cp 32
	jp c, l_65
; 915             if (a < 0x80) {
	cp 128
	jp nc, l_67
; 916                 goto CmdLShow;
	jp cmdlshow
l_67:
l_65:
; 917             }
; 918         }
; 919         a = '.';
	ld a, 46
; 920     CmdLShow:
cmdlshow:
; 921         PrintCharA();
	call printchara
; 922         Loop();
	call loop
; 923         if (flag_z((a = param1) &= 0x0F))
	ld a, (param1)
	and 15
; 924             goto CmdLLine;
	jp z, cmdlline
	jp l_63
; 925     }
; 926 }
; 927 
; 928 // Команда H<число 1>,<число 2>
; 929 // Сложение и вычитание чисел
; 930 
; 931 void CmdH(...) {
cmdh:
; 932     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 933     b = 6;
	ld b, 6
; 934     a ^= a;
	xor a
; 935     do {
l_69:
; 936         *hl = a;
	ld (hl), a
l_70:
; 937     } while (flag_nz(b--));
	dec b
	jp nz, l_69
; 938 
; 939     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 940 
; 941     ParseWord();
	call parseword
; 942     param1 = hl;
	ld (param1), hl
; 943 
; 944     ParseWord();
	call parseword
; 945     param2 = hl;
	ld (param2), hl
; 946 
; 947     PrintLf();
	call printlf
; 948     param3 = hl = param1;
	ld hl, (param1)
	ld (param3), hl
; 949     swap(hl, de);
	ex hl, de
; 950     hl = param2;
	ld hl, (param2)
; 951     hl += de;
	add hl, de
; 952     param1 = hl;
	ld (param1), hl
; 953     PrintParam1Space();
	call printparam1space
; 954 
; 955     hl = param2;
	ld hl, (param2)
; 956     swap(hl, de);
	ex hl, de
; 957     hl = param3;
	ld hl, (param3)
; 958     a = e;
	ld a, e
; 959     invert(a);
	cpl
; 960     e = a;
	ld e, a
; 961     a = d;
	ld a, d
; 962     invert(a);
	cpl
; 963     d = a;
	ld d, a
; 964     de++;
	inc de
; 965     hl += de;
	add hl, de
; 966     param1 = hl;
	ld (param1), hl
; 967     PrintParam1Space();
	call printparam1space
; 968     PrintLf();
	jp printlf
; 969 }
; 970 
; 971 // Команда I
; 972 // Ввод информации с магнитной ленты
; 973 
; 974 void CmdI() {
cmdi:
; 975     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 976     param1h = a;
	ld (param1h), a
; 977     tapeStartH = a;
	ld (tapestarth), a
; 978 
; 979     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 980     param1 = a;
	ld (param1), a
; 981     tapeStartL = a;
	ld (tapestartl), a
; 982 
; 983     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 984     param2h = a;
	ld (param2h), a
; 985     tapeStopH = a;
	ld (tapestoph), a
; 986 
; 987     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 988     param2 = a;
	ld (param2), a
; 989     tapeStopL = a;
	ld (tapestopl), a
; 990 
; 991     a = READ_TAPE_NEXT_BYTE;
	ld a, 8
; 992     hl = &CmdIEnd;
	ld hl, 0FFFFh & (cmdiend)
; 993     push(hl);
	push hl
; 994 
; 995     for (;;) {
l_73:
; 996         hl = param1;
	ld hl, (param1)
; 997         ReadTapeByte(a);
	call readtapebyte
; 998         *hl = a;
	ld (hl), a
; 999         Loop();
	call loop
; 1000         a = READ_TAPE_NEXT_BYTE;
	ld a, 8
	jp l_73
; 1001     }
; 1002 }
; 1003 
; 1004 void CmdIEnd(...) {
cmdiend:
; 1005     PrintHexWordSpace(hl = &tapeStartH);
	ld hl, 0FFFFh & (tapestarth)
	call printhexwordspace
; 1006     PrintHexWordSpace(hl = &tapeStopH);
	ld hl, 0FFFFh & (tapestoph)
	call printhexwordspace
; 1007     PrintLf();
	jp printlf
; 1008 }
; 1009 
; 1010 // Команда O<начало>,<конец>
; 1011 // Вывод содержимого области памяти на магнитную ленту
; 1012 
; 1013 void CmdO() {
cmdo:
; 1014     ParseParams();
	call parseparams
; 1015     a ^= a;
	xor a
; 1016     b = 0;
	ld b, 0
; 1017     do {
l_75:
; 1018         WriteTapeByte(a);
	call writetapebyte
l_76:
; 1019     } while (flag_nz(b--));
	dec b
	jp nz, l_75
; 1020     WriteTapeByte(a = TAPE_START);
	ld a, 230
	call writetapebyte
; 1021     WriteTapeByte(a = param1h);
	ld a, (param1h)
	call writetapebyte
; 1022     WriteTapeByte(a = param1);
	ld a, (param1)
	call writetapebyte
; 1023     WriteTapeByte(a = param2h);
	ld a, (param2h)
	call writetapebyte
; 1024     WriteTapeByte(a = param2);
	ld a, (param2)
	call writetapebyte
; 1025     for (;;) {
l_79:
; 1026         hl = param1;
	ld hl, (param1)
; 1027         a = *hl;
	ld a, (hl)
; 1028         WriteTapeByte(a);
	call writetapebyte
; 1029         Loop();
	call loop
	jp l_79
; 1030     }
; 1031 }
; 1032 
; 1033 // Команда V
; 1034 // Сравнение информации на магнитной ленте с содержимым области памяти
; 1035 
; 1036 void CmdV() {
cmdv:
; 1037     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 1038     param1h = a;
	ld (param1h), a
; 1039     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1040     param1 = a;
	ld (param1), a
; 1041     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1042     param2h = a;
	ld (param2h), a
; 1043     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1044     param2 = a;
	ld (param2), a
; 1045     for (;;) {
l_82:
; 1046         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 1047         hl = param1;
	ld hl, (param1)
; 1048         if (a != *hl) {
	cp (hl)
	jp z, l_84
; 1049             push_pop(a) {
	push af
; 1050                 PrintLfParam1();
	call printlfparam1
; 1051                 PrintSpace();
	call printspace
; 1052                 PrintByteFromParam1();
	call printbytefromparam1
; 1053                 PrintSpace();
	call printspace
	pop af
; 1054             }
; 1055             PrintHexByte();
	call printhexbyte
l_84:
; 1056         }
; 1057         Loop();
	call loop
	jp l_82
; 1058     }
; 1059 }
; 1060 
; 1061 void ReadTapeByte(...) {
readtapebyte:
; 1062     push(bc, de);
	push bc
	push de
; 1063     c = 0;
	ld c, 0
; 1064     d = a;
	ld d, a
; 1065     e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 1066     do {
l_86:
; 1067     loc_FD9D:
loc_fd9d:
; 1068         a = c;
	ld a, c
; 1069         a &= 0x7F;
	and 127
; 1070         cyclic_rotate_left(a, 1);
	rlca
; 1071         c = a;
	ld c, a
; 1072 
; 1073         do {
l_89:
; 1074             a = in(PORT_TAPE);
	in a, (1)
l_90:
; 1075         } while (a == e);
	cp e
	jp z, l_89
; 1076         a &= 1;
	and 1
; 1077         a |= c;
	or c
; 1078         c = a;
	ld c, a
; 1079         ReadTapeDelay();
	call readtapedelay
; 1080         e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 1081         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_92
; 1082             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_94
; 1083                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_95
l_94:
; 1084             } else {
; 1085                 if (a != (0xFF ^ TAPE_START))
	cp 25
; 1086                     goto loc_FD9D;
	jp nz, loc_fd9d
; 1087                 tapePolarity = a = 0xFF;
	ld a, 255
	ld (tapepolarity), a
l_95:
; 1088             }
; 1089             d = 8 + 1;
	ld d, 9
l_92:
l_87:
; 1090         }
; 1091     } while (flag_nz(d--));
	dec d
	jp nz, l_86
; 1092     a = tapePolarity;
	ld a, (tapepolarity)
; 1093     a ^= c;
	xor c
; 1094     pop(bc, de);
	pop de
	pop bc
	ret
; 1095 }
; 1096 
; 1097 void ReadTapeDelay(...) {
readtapedelay:
; 1098     push(a);
	push af
; 1099     TapeDelay(a = readDelay);
	ld a, (readdelay)
; 1100 }
; 1101 
; 1102 void TapeDelay(...) {
tapedelay:
; 1103     b = a;
	ld b, a
; 1104     pop(a);
	pop af
; 1105     do {
l_96:
l_97:
; 1106     } while (flag_nz(b--));
	dec b
	jp nz, l_96
	ret
; 1107 }
; 1108 
; 1109 void WriteTapeByte(...) {
writetapebyte:
; 1110     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 1111         d = a;
	ld d, a
; 1112         c = 8;
	ld c, 8
; 1113         do {
l_99:
; 1114             a = d;
	ld a, d
; 1115             cyclic_rotate_left(a, 1);
	rlca
; 1116             d = a;
	ld d, a
; 1117 
; 1118             out(PORT_TAPE, (a = 1) ^= d);
	ld a, 1
	xor d
	out (1), a
; 1119             WriteTapeDelay();
	call writetapedelay
; 1120 
; 1121             out(PORT_TAPE, (a = 0) ^= d);
	ld a, 0
	xor d
	out (1), a
; 1122             WriteTapeDelay();
	call writetapedelay
l_100:
; 1123         } while (flag_nz(c--));
	dec c
	jp nz, l_99
	pop af
	pop de
	pop bc
	ret
; 1124     }
; 1125 }
; 1126 
; 1127 void WriteTapeDelay(...) {
writetapedelay:
; 1128     push(a);
	push af
; 1129     TapeDelay(a = writeDelay);
	ld a, (writedelay)
	jp tapedelay
; 1130 }
; 1131 
; 1132 uint8_t monitorCommands = 'M';
monitorcommands:
	db 77
; 1133  monitorCommandsMa = (uintptr_t)&CmdM;
monitorcommandsma:
	dw 0FFFFh & (cmdm)
; 1134  monitorCommandsC = 'C';
monitorcommandsc:
	db 67
; 1135  monitorCommandsCa = (uintptr_t)&CmdC;
monitorcommandsca:
	dw 0FFFFh & (cmdc)
; 1136  monitorCommandsD = 'D';
monitorcommandsd:
	db 68
; 1137  monitorCommandsDa = (uintptr_t)&CmdD;
monitorcommandsda:
	dw 0FFFFh & (cmdd)
; 1138  monitorCommandsB = 'B';
monitorcommandsb:
	db 66
; 1139  monitorCommandsBa = (uintptr_t)&CmdB;
monitorcommandsba:
	dw 0FFFFh & (cmdb)
; 1140  monitorCommandsG = 'G';
monitorcommandsg:
	db 71
; 1141  monitorCommandsGa = (uintptr_t)&CmdG;
monitorcommandsga:
	dw 0FFFFh & (cmdg)
; 1142  monitorCommandsP = 'P';
monitorcommandsp:
	db 80
; 1143  monitorCommandsPa = (uintptr_t)&CmdP;
monitorcommandspa:
	dw 0FFFFh & (cmdp)
; 1144  monitorCommandsX = 'X';
monitorcommandsx:
	db 88
; 1145  monitorCommandsXa = (uintptr_t)&CmdX;
monitorcommandsxa:
	dw 0FFFFh & (cmdx)
; 1146  monitorCommandsF = 'F';
monitorcommandsf:
	db 70
; 1147  monitorCommandsFa = (uintptr_t)&CmdF;
monitorcommandsfa:
	dw 0FFFFh & (cmdf)
; 1148  monitorCommandsS = 'S';
monitorcommandss:
	db 83
; 1149  monitorCommandsSa = (uintptr_t)&CmdS;
monitorcommandssa:
	dw 0FFFFh & (cmds)
; 1150  monitorCommandsT = 'T';
monitorcommandst:
	db 84
; 1151  monitorCommandsTa = (uintptr_t)&CmdT;
monitorcommandsta:
	dw 0FFFFh & (cmdt)
; 1152  monitorCommandsI = 'I';
monitorcommandsi:
	db 73
; 1153  monitorCommandsIa = (uintptr_t)&CmdI;
monitorcommandsia:
	dw 0FFFFh & (cmdi)
; 1154  monitorCommandsO = 'O';
monitorcommandso:
	db 79
; 1155  monitorCommandsOa = (uintptr_t)&CmdO;
monitorcommandsoa:
	dw 0FFFFh & (cmdo)
; 1156  monitorCommandsV = 'V';
monitorcommandsv:
	db 86
; 1157  monitorCommandsVa = (uintptr_t)&CmdV;
monitorcommandsva:
	dw 0FFFFh & (cmdv)
; 1158  monitorCommandsJ = 'J';
monitorcommandsj:
	db 74
; 1159  monitorCommandsJa = (uintptr_t)&CmdJ;
monitorcommandsja:
	dw 0FFFFh & (cmdj)
; 1160  monitorCommandsA = 'A';
monitorcommandsa:
	db 65
; 1161  monitorCommandsAa = (uintptr_t)&CmdA;
monitorcommandsaa:
	dw 0FFFFh & (cmda)
; 1162  monitorCommandsK = 'K';
monitorcommandsk:
	db 75
; 1163  monitorCommandsKa = (uintptr_t)&CmdK;
monitorcommandska:
	dw 0FFFFh & (cmdk)
; 1164  monitorCommandsQ = 'Q';
monitorcommandsq:
	db 81
; 1165  monitorCommandsQa = (uintptr_t)&CmdQ;
monitorcommandsqa:
	dw 0FFFFh & (cmdq)
; 1166  monitorCommandsL = 'L';
monitorcommandsl:
	db 76
; 1167  monitorCommandsLa = (uintptr_t)&CmdL;
monitorcommandsla:
	dw 0FFFFh & (cmdl)
; 1168  monitorCommandsH = 'H';
monitorcommandsh:
	db 72
; 1169  monitorCommandsHa = (uintptr_t)&CmdH;
monitorcommandsha:
	dw 0FFFFh & (cmdh)
; 1170  monitorCommandsEnd = 0;
monitorcommandsend:
	db 0
; 1172  aPrompt[] = "\x0A*MИКРO/80* MONITOR\x0A>";
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
; 1173  aLf[] = "\x0A";
alf:
	db 10
	ds 1
; 1175  PrintCharA(...) {
printchara:
; 1176     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1177     PrintCharInt(c = a);
	ld c, a
	jp printcharint
; 1178 }
; 1179 
; 1180 void PrintChar(...) {
printchar:
; 1181     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1182     return PrintCharInt(c);
; 1183 }
; 1184 
; 1185 void PrintCharInt(...) {
printcharint:
; 1186     hl = cursor;
	ld hl, (cursor)
; 1187     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1188     hl += de;
	add hl, de
; 1189     *hl = SCREEN_ATTRIB_DEFAULT;
	ld (hl), 0
; 1190 
; 1191     hl = cursor;
	ld hl, (cursor)
; 1192     a = c;
	ld a, c
; 1193     if (a == 0x1F)
	cp 31
; 1194         return ClearScreen();
	jp z, clearscreen
; 1195     if (a == 0x08)
	cp 8
; 1196         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1197     if (a == 0x18)
	cp 24
; 1198         return MoveCursorRight(hl);
	jp z, movecursorright
; 1199     if (a == 0x19)
	cp 25
; 1200         return MoveCursorUp(hl);
	jp z, movecursorup
; 1201     if (a == 0x1A)
	cp 26
; 1202         return MoveCursorDown(hl);
	jp z, movecursordown
; 1203     if (a == 0x0A)
	cp 10
; 1204         return MoveCursorNextLine(hl);
	jp z, movecursornextline
; 1205     if (a == 0x0C)
	cp 12
; 1206         return MoveCursorHome();
	jp z, movecursorhome
; 1207 
; 1208     if ((a = h) == SCREEN_END >> 8) {
	ld a, h
	cp 65520
	jp nz, l_102
; 1209         IsAnyKeyPressed();
	call isanykeypressed
; 1210         if (a != 0) {
	or a
	jp z, l_104
; 1211             ReadKey();
	call readkey
l_104:
; 1212         }
; 1213         ClearScreenInt();
	call clearscreenint
; 1214         hl = SCREEN_BEGIN;
	ld hl, 59392
l_102:
; 1215     }
; 1216     *hl = c;
	ld (hl), c
; 1217     hl++;
	inc hl
; 1218     return MoveCursor();
; 1219 }
; 1220 
; 1221 void MoveCursor(...) {
movecursor:
; 1222     cursor = hl;
	ld (cursor), hl
; 1223     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1224     hl += de;
	add hl, de
; 1225     *hl = SCREEN_ATTRIB_DEFAULT | SCREEN_ATTRIB_UNDERLINE;
	ld (hl), 128
; 1226     pop(hl, bc, de, a);
	pop af
	pop de
	pop bc
	pop hl
	ret
; 1227 }
; 1228 
; 1229 void ClearScreen() {
clearscreen:
; 1230     ClearScreenInt();
	call clearscreenint
; 1231     MoveCursorHome();
; 1232 }
; 1233 
; 1234 void MoveCursorHome() {
movecursorhome:
; 1235     MoveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp movecursor
; 1236 }
; 1237 
; 1238 void ClearScreenInt() {
clearscreenint:
; 1239     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1240     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1241     for (;;) {
l_107:
; 1242         *hl = ' ';
	ld (hl), 32
; 1243         hl++;
	inc hl
; 1244         a = 0;
	ld a, 0
; 1245         *de = a;
	ld (de), a
; 1246         de++;
	inc de
; 1247         a = h;
	ld a, h
; 1248         if (a == SCREEN_END >> 8)
	cp 65520
; 1249             return;
	ret z
	jp l_107
; 1250     }
; 1251 }
; 1252 
; 1253 void MoveCursorRight(...) {
movecursorright:
; 1254     hl++;
	inc hl
; 1255     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1256         return MoveCursor(hl);
	jp nz, movecursor
; 1257     if (flag_z)  // Лишнее
; 1258         return MoveCursorHome();
	jp z, movecursorhome
; 1259     MoveCursorLeft(hl);  // Лишнее
; 1260 }
; 1261 
; 1262 void MoveCursorLeft(...) {
movecursorleft:
; 1263     hl--;
	dec hl
; 1264     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1265         return MoveCursor(hl);
	jp nz, movecursor
; 1266     MoveCursor(hl = SCREEN_END - 1);
	ld hl, 61439
	jp movecursor
; 1267 }
; 1268 
; 1269 void MoveCursorDown(...) {
movecursordown:
; 1270     hl += (de = SCREEN_WIDTH);
	ld de, 64
	add hl, de
; 1271     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1272         return MoveCursor(hl);
	jp nz, movecursor
; 1273     h = SCREEN_BEGIN >> 8;
	ld h, 232
; 1274     MoveCursor(hl);
	jp movecursor
; 1275 }
; 1276 
; 1277 void MoveCursorUp(...) {
movecursorup:
; 1278     hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
; 1279     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1280         return MoveCursor(hl);
	jp nz, movecursor
; 1281     hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 2048
	add hl, de
; 1282     MoveCursor(hl);
	jp movecursor
; 1283 }
; 1284 
; 1285 void MoveCursorNextLine(...) {
movecursornextline:
; 1286     for (;;) {
l_110:
; 1287         hl++;
	inc hl
; 1288         a = l;
	ld a, l
; 1289         if (a == SCREEN_WIDTH * 0)
	or a
; 1290             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1291         if (a == SCREEN_WIDTH * 1)
	cp 64
; 1292             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1293         if (a == SCREEN_WIDTH * 2)
	cp 128
; 1294             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1295         if (a == SCREEN_WIDTH * 3)
	cp 192
; 1296             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
	jp l_110
; 1297     }
; 1298 }
; 1299 
; 1300 void MoveCursorNextLine1(...) {
movecursornextline1:
; 1301     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1302         return MoveCursor(hl);
	jp nz, movecursor
; 1303 
; 1304     IsAnyKeyPressed();
	call isanykeypressed
; 1305     if (a == 0)
	or a
; 1306         return ClearScreen();
	jp z, clearscreen
; 1307     ReadKey();
	call readkey
; 1308     ClearScreen();
	jp clearscreen
; 1309 }
; 1310 
; 1311 void ReadKey() {
readkey:
; 1312     push(bc, de, hl);
	push bc
	push de
	push hl
; 1313 
; 1314     for (;;) {
l_113:
; 1315         b = 0;
	ld b, 0
; 1316         c = 1 ^ 0xFF;
	ld c, 254
; 1317         d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1318         do {
l_115:
; 1319             out(PORT_KEYBOARD_COLUMN, a = c);
	ld a, c
	out (7), a
; 1320             cyclic_rotate_left(a, 1);
	rlca
; 1321             c = a;
	ld c, a
; 1322             a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1323             a &= KEYBOARD_ROW_MASK;
	and 127
; 1324             if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1325                 return ReadKey1(a, b);
	jp nz, readkey1
; 1326             b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_116:
; 1327         } while (flag_nz(d--));
	dec d
	jp nz, l_115
	jp l_113
; 1328     }
; 1329 }
; 1330 
; 1331 void ReadKey1(...) {
readkey1:
; 1332     keyLast = a;
	ld (keylast), a
; 1333 
; 1334     for (;;) {
l_119:
; 1335         carry_rotate_right(a, 1);
	rra
; 1336         if (flag_nc)
; 1337             break;
	jp nc, l_120
; 1338         b++;
	inc b
	jp l_119
l_120:
; 1339     }
; 1340 
; 1341     // b - key number
; 1342 
; 1343     //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1344     //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1345     // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1346     // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1347     // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1348     // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1349     // 48   Space Right Left  Up    Down  Vk    Str   Home
; 1350 
; 1351     a = b;
	ld a, b
; 1352     if (a < 48) {
	cp 48
	jp nc, l_121
; 1353         a += '0';
	add 48
; 1354         if (a >= 0x3C)
	cp 60
; 1355             if (a < 0x40)
	jp c, l_123
	cp 64
; 1356                 a &= 0x2F;  // <=>? to .-./
	jp nc, l_125
	and 47
l_125:
l_123:
; 1357         c = a;
	ld c, a
	jp l_122
l_121:
; 1358     } else {
; 1359         hl = &keyTable;
	ld hl, keytable
; 1360         a -= 48;
	sub 48
; 1361         c = a;
	ld c, a
; 1362         b = 0;
	ld b, 0
; 1363         hl += bc;
	add hl, bc
; 1364         a = *hl;
	ld a, (hl)
; 1365         return ReadKey2(a);
	jp readkey2
l_122:
; 1366     }
; 1367 
; 1368     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1369     a &= KEYBOARD_MODS_MASK;
	and 7
; 1370     if (a == KEYBOARD_MODS_MASK)
	cp 7
; 1371         goto ReadKeyNoMods;
	jp z, readkeynomods
; 1372     carry_rotate_right(a, 2);
	rra
	rra
; 1373     if (flag_nc)
; 1374         goto ReadKeyControl;
	jp nc, readkeycontrol
; 1375     carry_rotate_right(a, 1);
	rra
; 1376     if (flag_nc)
; 1377         goto ReadKeyShift;
	jp nc, readkeyshift
; 1378 
; 1379     // RUS key pressed
; 1380     a = c;
	ld a, c
; 1381     a |= 0x20;
	or 32
; 1382     return ReadKey2(a);
	jp readkey2
; 1383 
; 1384     // US (Control) key pressed
; 1385 ReadKeyControl:
readkeycontrol:
; 1386     a = c;
	ld a, c
; 1387     a &= 0x1F;
	and 31
; 1388     return ReadKey2(a);
	jp readkey2
; 1389 
; 1390     // SS (Shift) key pressed
; 1391 ReadKeyShift:
readkeyshift:
; 1392     a = c;
	ld a, c
; 1393     if (a >= 0x40)  // @ A-Z [ \ ] ^ _
	cp 64
; 1394         return ReadKey2(a);
	jp nc, readkey2
; 1395     if (a < 0x30) {  // .-./ to <=>?
	cp 48
	jp nc, l_127
; 1396         a |= 0x10;
	or 16
; 1397         return ReadKey2(a);
	jp readkey2
l_127:
; 1398     }
; 1399     a &= 0x2F;  // 0123456789:; to !@#$%&'()*+
	and 47
; 1400     return ReadKey2(a);
	jp readkey2
; 1401 
; 1402 ReadKeyNoMods:
readkeynomods:
; 1403     ReadKey2(a = c);
	ld a, c
; 1404 }
; 1405 
; 1406 void ReadKey2(...) {
readkey2:
; 1407     c = a;
	ld c, a
; 1408 
; 1409     ReadKeyDelay();
	call readkeydelay
; 1410 
; 1411     hl = &keyLast;
	ld hl, 0FFFFh & (keylast)
; 1412     do {
l_129:
; 1413         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
l_130:
; 1414     } while (a == *hl);
	cp (hl)
	jp z, l_129
; 1415 
; 1416     ReadKeyDelay();
	call readkeydelay
; 1417 
; 1418     a = c;
	ld a, c
; 1419     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1420 }
; 1421 
; 1422 void ReadKeyDelay() {
readkeydelay:
; 1423     de = 0x1000;
	ld de, 4096
; 1424     for (;;) {
l_133:
; 1425         de--;
	dec de
; 1426         if (flag_z((a = d) |= e))
	ld a, d
	or e
; 1427             return;
	ret z
	jp l_133
; 1428     }
; 1429 }
; 1430 
; 1431 uint8_t keyTable[] = {
keytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1442  IsAnyKeyPressed() {
isanykeypressed:
; 1443     out(PORT_KEYBOARD_COLUMN, a = 0);
	ld a, 0
	out (7), a
; 1444     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1445     a &= KEYBOARD_ROW_MASK;
	and 127
; 1446     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_135
; 1447         a ^= a;  // Returns 0 if no key is pressed
	xor a
; 1448         return;
	ret
l_135:
; 1449     }
; 1450     a = 0xFF;  // Returns 0xFF if there are any keys pressed
	ld a, 255
	ret
 savebin "micro80.bin", 0xF800, 0x10000
