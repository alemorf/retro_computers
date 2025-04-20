    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
rst38opcode equ 56
rst38address equ 57
jumpopcode equ 63312
param1 equ 63313
param1h equ 63314
param2 equ 63315
param2h equ 63316
param3 equ 63317
param3h equ 63318
tapepolarity equ 63319
keybmode equ 63320
color equ 63321
cursor equ 63322
readdelay equ 63324
writedelay equ 63325
tapestartl equ 63326
tapestarth equ 63327
tapestopl equ 63328
tapestoph equ 63329
keydelay equ 63330
keylast equ 63331
keysaved equ 63332
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
; 43  uint8_t rst38Opcode __address(0x38);
; 44 extern uint16_t rst38Address __address(0x39);
; 45 
; 46 /* Переменные */
; 47 extern uint8_t jumpOpcode __address(0xF750);
; 48 extern uint16_t param1 __address(0xF751);
; 49 extern uint8_t param1h __address(0xF752);
; 50 extern uint16_t param2 __address(0xF753);
; 51 extern uint8_t param2h __address(0xF754);
; 52 extern uint16_t param3 __address(0xF755);
; 53 extern uint8_t param3h __address(0xF756);
; 54 extern uint8_t tapePolarity __address(0xF757);
; 55 extern uint8_t keybMode __address(0xF758);
; 56 extern uint8_t color __address(0xF759);
; 57 extern uint16_t cursor __address(0xF75A);
; 58 extern uint8_t readDelay __address(0xF75C);
; 59 extern uint8_t writeDelay __address(0xF75D);
; 60 extern uint8_t tapeStartL __address(0xF75E);
; 61 extern uint8_t tapeStartH __address(0xF75F);
; 62 extern uint8_t tapeStopL __address(0xF760);
; 63 extern uint8_t tapeStopH __address(0xF761);
; 64 extern uint8_t keyDelay __address(0xF762);
; 65 extern uint8_t keyLast __address(0xF763);
; 66 extern uint8_t keySaved __address(0xF764);
; 67 extern uint16_t regs __address(0xF765);
; 68 extern uint16_t regSP __address(0xF765);
; 69 extern uint8_t regSPH __address(0xF766);
; 70 extern uint16_t regF __address(0xF767);
; 71 extern uint16_t regA __address(0xF768);
; 72 extern uint16_t regC __address(0xF769);
; 73 extern uint16_t regB __address(0xF76A);
; 74 extern uint16_t regE __address(0xF76B);
; 75 extern uint16_t regD __address(0xF76C);
; 76 extern uint16_t regL __address(0xF76D);
; 77 extern uint16_t regHL __address(0xF76D);
; 78 extern uint16_t regH __address(0xF76E);
; 79 extern uint16_t lastBreakAddress __address(0xF76F);
; 80 extern uint8_t lastBreakAddressHigh __address(0xF770);
; 81 extern uint8_t breakCounter __address(0xF771);
; 82 extern uint16_t breakAddress __address(0xF772);
; 83 extern uint8_t breakPrevByte __address(0xF774);
; 84 extern uint16_t breakAddress2 __address(0xF775);
; 85 extern uint8_t breakPrevByte2 __address(0xF777);
; 86 extern uint16_t breakAddress3 __address(0xF778);
; 87 extern uint8_t breakPrevByte3 __address(0xF77A);
; 88 extern uint8_t cmdBuffer __address(0xF77B);
; 89 extern uint8_t cmdBuffer1 __address(0xF77B + 1);
; 90 extern uint8_t cmdBufferEnd __address(0xF77B + 32);
 org 0F800h
; 86  EntryReboot() {
entryreboot:
; 87     Reboot();
	jp reboot
; 88 }
; 89 
; 90 void EntryReadChar(...) {
entryreadchar:
; 91     ReadKey();
	jp readkey
; 92 }
; 93 
; 94 void EntryReadTapeByte(...) {
entryreadtapebyte:
; 95     ReadTapeByte();
	jp readtapebyte
; 96 }
; 97 
; 98 void EntryPrintChar(...) {
entryprintchar:
; 99     PrintChar();
	jp printchar
; 100 }
; 101 
; 102 void EntryWriteTapeByte(...) {
entrywritetapebyte:
; 103     WriteTapeByte();
	jp writetapebyte
; 104 }
; 105 
; 106 void EntryPrintChar2(...) {
entryprintchar2:
; 107     PrintChar();
	jp printchar
; 108 }
; 109 
; 110 void EntryIsKeyPressed() {
entryiskeypressed:
; 111     IsKeyPressed();
	jp iskeypressed
; 112 }
; 113 
; 114 void EntryPrintHexByte(...) {
entryprinthexbyte:
; 115     PrintHexByte();
	jp printhexbyte
; 116 }
; 117 
; 118 void EntryPrintString(...) {
entryprintstring:
; 119     PrintString();
	jp printstring
; 120 }
; 121 
; 122 void Reboot() {
reboot:
; 123     disable_interrupts();
	di
; 124     readDelay = hl = 0x324B;
	ld hl, 12875
	ld (readdelay), hl
; 125     keybMode = (a ^= a);
	xor a
	ld (keybmode), a
; 126     a--;
	dec a
; 127     keySaved = a; /* = 0xFF */
	ld (keysaved), a
; 128     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 39
	ld (color), a
; 129     regSP = hl = USER_STACK_TOP;
	ld hl, 63424
	ld (regsp), hl
; 130     sp = STACK_TOP;
	ld sp, 63487
; 131     PrintString(hl = &aHello);
	ld hl, ahello
	call printstring
; 132     Monitor();
; 133 }
; 134 
; 135 void Monitor() {
monitor:
; 136     out(PORT_KEYBOARD_MODE, a = 0x8B);
	ld a, 139
	out (4), a
; 137     sp = STACK_TOP;
	ld sp, 63487
; 138     color = a = SCREEN_ATTRIB_INPUT;
	ld a, 35
	ld (color), a
; 139     PrintString(hl = &aPrompt);
	ld hl, aprompt
	call printstring
; 140     ReadString();
	call readstring
; 141     color = a = SCREEN_ATTRIB_DEFAULT;
	ld a, 39
	ld (color), a
; 142     push(hl = &Monitor);
	ld hl, 0FFFFh & (monitor)
	push hl
; 143     MonitorExecute();
; 144 }
; 145 
; 146 void MonitorExecute() {
monitorexecute:
; 147     a = cmdBuffer;
	ld a, (cmdbuffer)
; 148     a &= 0x7F; /* Lowercase support */
	and 127
; 149     hl = &monitorCommands;
	ld hl, 0FFFFh & (monitorcommands)
; 150     do {
l_0:
; 151         b = *hl;
	ld b, (hl)
; 152         b--;
	dec b
; 153         b++;
	inc b
; 154         if (flag_z)
; 155             return MonitorError();
	jp z, monitorerror
; 156         hl++;
	inc hl
; 157         e = *hl;
	ld e, (hl)
; 158         hl++;
	inc hl
; 159         d = *hl;
	ld d, (hl)
; 160         hl++;
	inc hl
l_1:
; 161     } while (a != b);
	cp b
	jp nz, l_0
; 162     swap(hl, de);
	ex hl, de
; 163     return hl();
	jp hl
; 164 }
; 165 
; 166 void ReadString() {
readstring:
; 167     hl = &cmdBuffer;
	ld hl, 0FFFFh & (cmdbuffer)
; 168     d = h;
	ld d, h
; 169     e = l;
	ld e, l
; 170     for (;;) {
l_4:
; 171         ReadKey();
	call readkey
; 172         if (a == 8) {
	cp 8
	jp nz, l_6
; 173             if ((a = e) == l)
	ld a, e
	cp l
; 174                 continue;
	jp z, l_4
; 175             PrintChar(c = 8);
	ld c, 8
	call printchar
; 176             hl--;
	dec hl
; 177             continue;
	jp l_4
l_6:
; 178         }
; 179         *hl = a;
	ld (hl), a
; 180         if (a == 0x0D)
	cp 13
; 181             return;
	ret z
; 182         if (a < 32)
	cp 32
; 183             a = '.';
	jp nc, l_8
	ld a, 46
l_8:
; 184         PrintCharA(a);
	call printchara
; 185         hl++;
	inc hl
; 186         if ((a = l) == (uintptr_t)&cmdBufferEnd)
	ld a, l
	cp 0FFFFh & (0FFFFh & (cmdbufferend))
; 187             return MonitorError();
	jp z, monitorerror
	jp l_4
; 188     }
; 189 }
; 190 
; 191 void PrintString(...) {
printstring:
; 192     for (;;) {
l_11:
; 193         a = *hl;
	ld a, (hl)
; 194         if (flag_z(a &= a))
	and a
; 195             return;
	ret z
; 196         PrintCharA(a);
	call printchara
; 197         hl++;
	inc hl
	jp l_11
; 198     }
; 199 }
; 200 
; 201 void ParseParams() {
parseparams:
; 202     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 203     b = 6;
	ld b, 6
; 204     a ^= a;
	xor a
; 205     do {
l_13:
; 206         *hl = a;
	ld (hl), a
l_14:
; 207     } while (flag_nz(b--));
	dec b
	jp nz, l_13
; 208 
; 209     de = &cmdBuffer + 1;
	ld de, 0FFFFh & ((cmdbuffer) + (1))
; 210     ParseDword();
	call parsedword
; 211     param1 = hl;
	ld (param1), hl
; 212     param2 = hl;
	ld (param2), hl
; 213     if (flag_c)
; 214         return;
	ret c
; 215     ParseDword();
	call parsedword
; 216     param2 = hl;
	ld (param2), hl
; 217     push_pop(a, de) {
	push af
	push de
; 218         swap(hl, de);
	ex hl, de
; 219         hl = param1;
	ld hl, (param1)
; 220         swap(hl, de);
	ex hl, de
; 221         CmpHlDe();
	call cmphlde
; 222         if (flag_c)
; 223             return MonitorError();
	jp c, monitorerror
	pop de
	pop af
; 224     }
; 225     if (flag_c)
; 226         return;
	ret c
; 227     ParseDword();
	call parsedword
; 228     param3 = hl;
	ld (param3), hl
; 229     if (flag_c)
; 230         return;
	ret c
; 231     MonitorError();
; 232 }
; 233 
; 234 void MonitorError() {
monitorerror:
; 235     PrintChar(c = '?');
	ld c, 63
	call printchar
; 236     return Monitor();
	jp monitor
; 237 }
; 238 
; 239 void ParseDword(...) {
parsedword:
; 240     push(hl = &MonitorError);
	ld hl, 0FFFFh & (monitorerror)
	push hl
; 241     hl = 0;
	ld hl, 0
; 242     for (;;) {
l_17:
; 243         a = *de;
	ld a, (de)
; 244         if (a == 0x0D)
	cp 13
; 245             return PopReturnCf();
	jp z, popreturncf
; 246         de++;
	inc de
; 247         if (a == ',')
	cp 44
; 248             return PopReturn();
	jp z, popreturn
; 249         if (a == ' ')
	cp 32
; 250             continue;
	jp z, l_17
; 251         a &= 0x7F; /* Lowercase support */
	and 127
; 252         a -= '0';
	sub 48
; 253         if (flag_m)
; 254             return;
	ret m
; 255         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_19
; 256             if (flag_m(compare(a, 0x11)))
	cp 17
; 257                 return;
	ret m
; 258             if (flag_p(compare(a, 0x17)))
	cp 23
; 259                 return;
	ret p
; 260             a -= 7;
	sub 7
l_19:
; 261         }
; 262         b = 0;
	ld b, 0
; 263         c = a;
	ld c, a
; 264         hl += hl;
	add hl, hl
; 265         if (flag_c)
; 266             return;
	ret c
; 267         hl += hl;
	add hl, hl
; 268         if (flag_c)
; 269             return;
	ret c
; 270         hl += hl;
	add hl, hl
; 271         if (flag_c)
; 272             return;
	ret c
; 273         hl += hl;
	add hl, hl
; 274         if (flag_c)
; 275             return;
	ret c
; 276         hl += bc;
	add hl, bc
	jp l_17
; 277     }
; 278 }
; 279 
; 280 void PopReturnCf() {
popreturncf:
; 281     set_flag_c();
	scf
; 282     PopReturn();
; 283 }
; 284 
; 285 void PopReturn() {
popreturn:
; 286     pop(bc);
	pop bc
	ret
; 287 }
; 288 
; 289 void PrintByteFromParam1(...) {
printbytefromparam1:
; 290     hl = param1;
	ld hl, (param1)
; 291     PrintHexByte(a = *hl);
	ld a, (hl)
; 292 }
; 293 
; 294 void PrintHexByte(...) {
printhexbyte:
; 295     b = a;
	ld b, a
; 296     cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 297     PrintHex(a);
	call printhex
; 298     PrintHex(a = b);
	ld a, b
; 299 }
; 300 
; 301 void PrintHex(...) {
printhex:
; 302     a &= 0x0F;
	and 15
; 303     if (flag_p(compare(a, 10)))
	cp 10
; 304         a += 'A' - '0' - 10;
	jp m, l_21
	add 7
l_21:
; 305     a += '0';
	add 48
; 306     PrintCharA(a);
	jp printchara
; 307 }
; 308 
; 309 void PrintLfParam1Space(...) {
printlfparam1space:
; 310     PrintLf();
	call printlf
; 311     PrintParam1Space();
; 312 }
; 313 
; 314 void PrintParam1Space() {
printparam1space:
; 315     PrintHexWordSpace(hl = &param1h);
	ld hl, 0FFFFh & (param1h)
; 316 }
; 317 
; 318 void PrintHexWordSpace(...) {
printhexwordspace:
; 319     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 320     hl--;
	dec hl
; 321     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 322     PrintSpace();
; 323 }
; 324 
; 325 void PrintSpace(...) {
printspace:
; 326     PrintChar(c = ' ');
	ld c, 32
	jp printchar
; 327 }
; 328 
; 329 void Loop() {
loop:
; 330     push_pop(de) {
	push de
; 331         hl = param2;
	ld hl, (param2)
; 332         swap(hl, de);
	ex hl, de
; 333         hl = param1;
	ld hl, (param1)
; 334         CmpHlDe(hl, de);
	call cmphlde
; 335         hl++;
	inc hl
; 336         param1 = hl;
	ld (param1), hl
	pop de
; 337     }
; 338     if (flag_nz)
; 339         return;
	ret nz
; 340     pop(hl);
	pop hl
	ret
; 341 }
; 342 
; 343 void CmpHlDe(...) {
cmphlde:
; 344     if ((a = h) != d)
	ld a, h
	cp d
; 345         return;
	ret nz
; 346     compare(a = l, e);
	ld a, l
	cp e
	ret
; 347 }
; 348 
; 349 /* X - Изменение содержимого внутреннего регистра микропроцессора */
; 350 
; 351 void CmdX() {
cmdx:
; 352     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 353     a = *de;
	ld a, (de)
; 354     if (a == 0x0D)
	cp 13
; 355         return PrintRegs();
	jp z, printregs
; 356     de++;
	inc de
; 357     push_pop(a) {
	push af
; 358         ParseDword();
	call parsedword
	pop af
; 359     }
; 360     if (a == 'S') {
	cp 83
	jp nz, l_23
; 361         regSP = hl;
	ld (regsp), hl
; 362         return;
	ret
l_23:
; 363     }
; 364     c = l;
	ld c, l
; 365     b = a;
	ld b, a
; 366     hl = regList - 1;
	ld hl, 0FFFFh & ((reglist) - (1))
; 367     do {
l_25:
; 368         hl++;
	inc hl
; 369         a = *hl;
	ld a, (hl)
; 370         if (a == 0)
	or a
; 371             return MonitorError();
	jp z, monitorerror
; 372         hl++;
	inc hl
l_26:
; 373     } while (a != b);
	cp b
	jp nz, l_25
; 374     l = *hl;
	ld l, (hl)
; 375     h = (uintptr_t)&regs >> 8;
	ld h, 0FFh & ((0FFFFh & (0FFFFh & (regs))) >> (8))
; 376     *hl = c;
	ld (hl), c
	ret
; 377 }
; 378 
; 379 void PrintRegs(...) {
printregs:
; 380     de = &regList;
	ld de, reglist
; 381     b = 8;
	ld b, 8
; 382     PrintLf();
	call printlf
; 383     do {
l_28:
; 384         c = a = *de;
	ld a, (de)
	ld c, a
; 385         de++;
	inc de
; 386         push_pop(bc) {
	push bc
; 387             PrintRegMinus(c);
	call printregminus
; 388             a = *de;
	ld a, (de)
; 389             hl = &regs;
	ld hl, 0FFFFh & (regs)
; 390             l = a;
	ld l, a
; 391             PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 392             PrintSpace();
	call printspace
	pop bc
; 393         }
; 394         de++;
	inc de
l_29:
; 395     } while (flag_nz(b--));
	dec b
	jp nz, l_28
; 396 
; 397     c = a = *de;
	ld a, (de)
	ld c, a
; 398     PrintRegMinus();
	call printregminus
; 399     param1 = hl = regs;
	ld hl, (regs)
	ld (param1), hl
; 400     PrintParam1Space();
	call printparam1space
; 401     PrintRegMinus(c = 'O');
	ld c, 79
	call printregminus
; 402     PrintHexWordSpace(hl = &lastBreakAddressHigh);
	ld hl, 0FFFFh & (lastbreakaddresshigh)
	jp printhexwordspace
; 403 }
; 404 
; 405 void PrintRegMinus(...) {
printregminus:
; 406     PrintChar(c);
	call printchar
; 407     PrintChar(c = '-');
	ld c, 45
	jp printchar
; 408 }
; 409 
; 410 uint8_t regList[] = {'A', &regA, 'B', &regB, 'C', &regC, 'D', &regD,  'E', &regE,
reglist:
	db 65
	db 0FFh & (rega)
	db 66
	db 0FFh & (regb)
	db 67
	db 0FFh & (regc)
	db 68
	db 0FFh & (regd)
	db 69
	db 0FFh & (rege)
	db 70
	db 0FFh & (regf)
	db 72
	db 0FFh & (regh)
	db 76
	db 0FFh & (regl)
	db 83
	db 0FFh & (regsp)
	db 0
; 413  aStart[] = "\x0ASTART-";
astart:
	db 10
	db 83
	db 84
	db 65
	db 82
	db 84
	db 45
	ds 1
; 414  aDir_[] = "\x0ADIR  -";
adir_:
	db 10
	db 68
	db 73
	db 82
	db 32
	db 32
	db 45
	ds 1
; 418  CmdB() {
cmdb:
; 419     ParseParams();
	call parseparams
; 420     InitRst38();
	call initrst38
; 421     hl = param1;
	ld hl, (param1)
; 422     a = *hl;
	ld a, (hl)
; 423     *hl = OPCODE_RST_38;
	ld (hl), 255
; 424     breakAddress = hl;
	ld (breakaddress), hl
; 425     breakPrevByte = a;
	ld (breakprevbyte), a
	ret
; 426 }
; 427 
; 428 void InitRst38() {
initrst38:
; 429     rst38Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst38opcode), a
; 430     rst38Address = hl = &BreakPoint;
	ld hl, 0FFFFh & (breakpoint)
	ld (rst38address), hl
	ret
; 431 }
; 432 
; 433 void BreakPoint(...) {
breakpoint:
; 434     regHL = hl;
	ld (reghl), hl
; 435     push(a);
	push af
; 436     hl = 4;
	ld hl, 4
; 437     hl += sp;
	add hl, sp
; 438     regs = hl;
	ld (regs), hl
; 439     pop(a);
	pop af
; 440     swap(*sp, hl);
	ex (sp), hl
; 441     hl--;
	dec hl
; 442     swap(*sp, hl);
	ex (sp), hl
; 443     sp = &regHL;
	ld sp, 0FFFFh & (reghl)
; 444     push(de, bc, a);
	push de
	push bc
	push af
; 445     sp = STACK_TOP;
	ld sp, 63487
; 446 
; 447     hl = regSP;
	ld hl, (regsp)
; 448     hl--;
	dec hl
; 449     d = *hl;
	ld d, (hl)
; 450     hl--;
	dec hl
; 451     e = *hl;
	ld e, (hl)
; 452     l = e;
	ld l, e
; 453     h = d;
	ld h, d
; 454     lastBreakAddress = hl;
	ld (lastbreakaddress), hl
; 455 
; 456     hl = breakAddress;
	ld hl, (breakaddress)
; 457     CmpHlDe();
	call cmphlde
; 458     if (flag_nz) {
	jp z, l_31
; 459         hl = breakAddress2;
	ld hl, (breakaddress2)
; 460         CmpHlDe(hl, de);
	call cmphlde
; 461         if (flag_z)
; 462             return BreakPointAt2();
	jp z, breakpointat2
; 463 
; 464         hl = breakAddress3;
	ld hl, (breakaddress3)
; 465         CmpHlDe(hl, de);
	call cmphlde
; 466         if (flag_z)
; 467             return BreakpointAt3();
	jp z, breakpointat3
; 468 
; 469         return MonitorError();
	jp monitorerror
l_31:
; 470     }
; 471     *hl = a = breakPrevByte;
	ld a, (breakprevbyte)
	ld (hl), a
; 472     breakAddress = hl = 0xFFFF;
	ld hl, 65535
	ld (breakaddress), hl
; 473     return Monitor();
	jp monitor
; 474 }
; 475 
; 476 /* G<адрес> - Запуск программы в отладочном режиме */
; 477 
; 478 void CmdG() {
cmdg:
; 479     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 480     if ((a = cmdBuffer1) != 0x0D)
	ld a, (cmdbuffer1)
	cp 13
; 481         ParseParams();
	call nz, parseparams
; 482     Run();
; 483 }
; 484 
; 485 void Run() {
run:
; 486     jumpOpcode = a = OPCODE_JMP;
	ld a, 195
	ld (jumpopcode), a
; 487     sp = &regs;
	ld sp, 0FFFFh & (regs)
; 488     pop(de, bc, a, hl);
	pop hl
	pop af
	pop bc
	pop de
; 489     sp = hl;
	ld sp, hl
; 490     hl = regHL;
	ld hl, (reghl)
; 491     jumpOpcode();
	jp jumpopcode
; 492 }
; 493 
; 494 void CmdP(...) {
cmdp:
; 495     ParseParams();
	call parseparams
; 496     InitRst38();
	call initrst38
; 497 
; 498     breakAddress2 = hl = param1;
	ld hl, (param1)
	ld (breakaddress2), hl
; 499     a = *hl;
	ld a, (hl)
; 500     *hl = OPCODE_RST_38;
	ld (hl), 255
; 501     breakPrevByte2 = a;
	ld (breakprevbyte2), a
; 502 
; 503     breakAddress3 = hl = param2;
	ld hl, (param2)
	ld (breakaddress3), hl
; 504     a = *hl;
	ld a, (hl)
; 505     *hl = OPCODE_RST_38;
	ld (hl), 255
; 506     breakPrevByte3 = a;
	ld (breakprevbyte3), a
; 507 
; 508     breakCounter = a = param3;
	ld a, (param3)
	ld (breakcounter), a
; 509 
; 510     PrintString(hl = &aStart);
	ld hl, astart
	call printstring
; 511     ReadString();
	call readstring
; 512     ParseParams();
	call parseparams
; 513 
; 514     PrintString(hl = &aDir_);
	ld hl, adir_
	call printstring
; 515     ReadString();
	call readstring
; 516 
; 517     Run();
	jp run
; 518 }
; 519 
; 520 void BreakPointAt2(...) {
breakpointat2:
; 521     *hl = a = breakPrevByte2;
	ld a, (breakprevbyte2)
	ld (hl), a
; 522 
; 523     hl = breakAddress3;
	ld hl, (breakaddress3)
; 524     a = OPCODE_RST_38;
	ld a, 255
; 525     if (a != *hl) {
	cp (hl)
	jp z, l_33
; 526         b = *hl;
	ld b, (hl)
; 527         *hl = a;
	ld (hl), a
; 528         breakPrevByte3 = a = b;
	ld a, b
	ld (breakprevbyte3), a
l_33:
; 529     }
; 530     ContinueBreakpoint();
; 531 }
; 532 
; 533 void ContinueBreakpoint(...) {
continuebreakpoint:
; 534     PrintRegs();
	call printregs
; 535     MonitorExecute();
	call monitorexecute
; 536     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 537     Run();
	jp run
; 538 }
; 539 
; 540 void BreakpointAt3(...) {
breakpointat3:
; 541     *hl = a = breakPrevByte3;
	ld a, (breakprevbyte3)
	ld (hl), a
; 542 
; 543     hl = breakAddress2;
	ld hl, (breakaddress2)
; 544     a = OPCODE_RST_38;
	ld a, 255
; 545     if (a == *hl)
	cp (hl)
; 546         return ContinueBreakpoint();
	jp z, continuebreakpoint
; 547     b = *hl;
	ld b, (hl)
; 548     *hl = a;
	ld (hl), a
; 549     breakPrevByte2 = a = b;
	ld a, b
	ld (breakprevbyte2), a
; 550 
; 551     hl = &breakCounter;
	ld hl, 0FFFFh & (breakcounter)
; 552     (*hl)--;
	dec (hl)
; 553     if (flag_nz)
; 554         return ContinueBreakpoint();
	jp nz, continuebreakpoint
; 555 
; 556     a = breakPrevByte2;
	ld a, (breakprevbyte2)
; 557     hl = breakAddress2;
	ld hl, (breakaddress2)
; 558     *hl = a;
	ld (hl), a
; 559     Monitor();
	jp monitor
; 560 }
; 561 
; 562 /* D<адрес>,<адрес> - Просмотр содержимого области памяти в шестнадцатеричном виде */
; 563 
; 564 void CmdD() {
cmdd:
; 565     ParseParams();
	call parseparams
; 566     PrintLfParam1Space();
	call printlfparam1space
; 567     for (;;) {
l_36:
; 568         PrintByteFromParam1();
	call printbytefromparam1
; 569         PrintSpace();
	call printspace
; 570         Loop();
	call loop
; 571         a = param1;
	ld a, (param1)
; 572         a &= 0x0F;
	and 15
; 573         if (flag_z)
; 574             PrintLfParam1Space();
	call z, printlfparam1space
	jp l_36
; 575     }
; 576 }
; 577 
; 578 /* C<адрес от>,<адрес до>,<адрес от 2> - Сравнение содержимого двух областей памяти */
; 579 
; 580 void CmdC() {
cmdc:
; 581     ParseParams();
	call parseparams
; 582     hl = param3;
	ld hl, (param3)
; 583     swap(hl, de);
	ex hl, de
; 584     for (;;) {
l_39:
; 585         hl = param1;
	ld hl, (param1)
; 586         a = *de;
	ld a, (de)
; 587         if (a != *hl) {
	cp (hl)
	jp z, l_41
; 588             PrintLfParam1Space();
	call printlfparam1space
; 589             PrintByteFromParam1();
	call printbytefromparam1
; 590             PrintSpace();
	call printspace
; 591             a = *de;
	ld a, (de)
; 592             PrintHexByte();
	call printhexbyte
l_41:
; 593         }
; 594         de++;
	inc de
; 595         Loop();
	call loop
	jp l_39
; 596     }
; 597 }
; 598 
; 599 /* F<адрес>,<адрес>,<байт> - Запись байта во все ячейки области памяти */
; 600 
; 601 void CmdF() {
cmdf:
; 602     ParseParams();
	call parseparams
; 603     b = a = param3;
	ld a, (param3)
	ld b, a
; 604     for (;;) {
l_44:
; 605         hl = param1;
	ld hl, (param1)
; 606         *hl = b;
	ld (hl), b
; 607         Loop();
	call loop
	jp l_44
; 608     }
; 609 }
; 610 
; 611 /* S<адрес>,<адрес>,<байт> - Поиск байта в области памяти */
; 612 
; 613 void CmdS() {
cmds:
; 614     ParseParams();
	call parseparams
; 615     c = l;
	ld c, l
; 616     for (;;) {
l_47:
; 617         hl = param1;
	ld hl, (param1)
; 618         a = c;
	ld a, c
; 619         if (a == *hl)
	cp (hl)
; 620             PrintLfParam1Space();
	call z, printlfparam1space
; 621         Loop();
	call loop
	jp l_47
; 622     }
; 623 }
; 624 
; 625 /* T<начало>,<конец>,<куда> - Пересылка содержимого одной области в другую */
; 626 
; 627 void CmdT() {
cmdt:
; 628     ParseParams();
	call parseparams
; 629     hl = param3;
	ld hl, (param3)
; 630     swap(hl, de);
	ex hl, de
; 631     for (;;) {
l_50:
; 632         hl = param1;
	ld hl, (param1)
; 633         *de = a = *hl;
	ld a, (hl)
	ld (de), a
; 634         de++;
	inc de
; 635         Loop();
	call loop
	jp l_50
; 636     }
; 637 }
; 638 
; 639 /* M<адрес> - Просмотр или изменение содержимого ячейки (ячеек) памяти */
; 640 
; 641 void CmdM() {
cmdm:
; 642     ParseParams();
	call parseparams
; 643     for (;;) {
l_53:
; 644         PrintLfParam1Space();
	call printlfparam1space
; 645         PrintByteFromParam1();
	call printbytefromparam1
; 646         PrintSpace();
	call printspace
; 647         ReadString();
	call readstring
; 648         hl = param1;
	ld hl, (param1)
; 649         a = *de;
	ld a, (de)
; 650         if (a != 0x0D) {
	cp 13
	jp z, l_55
; 651             push_pop(hl) {
	push hl
; 652                 ParseDword();
	call parsedword
; 653                 a = l;
	ld a, l
	pop hl
; 654             }
; 655             *hl = a;
	ld (hl), a
l_55:
; 656         }
; 657         hl++;
	inc hl
; 658         param1 = hl;
	ld (param1), hl
	jp l_53
; 659     }
; 660 }
; 661 
; 662 /* J<адрес> - Запуск программы с указанного адреса */
; 663 
; 664 void CmdJ() {
cmdj:
; 665     ParseParams();
	call parseparams
; 666     hl = param1;
	ld hl, (param1)
; 667     return hl();
	jp hl
; 668 }
; 669 
; 670 /* А<символ> - Вывод кода символа на экран */
; 671 
; 672 void CmdA() {
cmda:
; 673     PrintLf();
	call printlf
; 674     PrintHexByte(a = cmdBuffer1);
	ld a, (cmdbuffer1)
	jp printhexbyte
; 675 }
; 676 
; 677 /* K - Вывод символа с клавиатуры на экран */
; 678 
; 679 void CmdK() {
cmdk:
; 680     PrintLf();
	call printlf
; 681     for (;;) {
l_58:
; 682         ReadKey();
	call readkey
; 683         if (a == 0) /* УС + @ */
	or a
; 684             return;
	ret z
; 685         PrintCharA(a);
	call printchara
	jp l_58
; 686     }
; 687 }
; 688 
; 689 /* Q<начало>,<конец> - Тестирование области памяти */
; 690 
; 691 void CmdQ() {
cmdq:
; 692     ParseParams();
	call parseparams
; 693     for (;;) {
l_61:
; 694         hl = param1;
	ld hl, (param1)
; 695         c = *hl;
	ld c, (hl)
; 696 
; 697         a = 0x55;
	ld a, 85
; 698         *hl = a;
	ld (hl), a
; 699         if (a != *hl)
	cp (hl)
; 700             CmdQResult();
	call nz, cmdqresult
; 701 
; 702         a = 0xAA;
	ld a, 170
; 703         *hl = a;
	ld (hl), a
; 704         if (a != *hl)
	cp (hl)
; 705             CmdQResult();
	call nz, cmdqresult
; 706 
; 707         *hl = c;
	ld (hl), c
; 708         Loop();
	call loop
	jp l_61
; 709     }
; 710 }
; 711 
; 712 void CmdQResult(...) {
cmdqresult:
; 713     push_pop(a) {
	push af
; 714         PrintLfParam1Space();
	call printlfparam1space
; 715         PrintByteFromParam1();
	call printbytefromparam1
; 716         PrintSpace();
	call printspace
	pop af
; 717     }
; 718     PrintHexByte(a);
	jp printhexbyte
; 719 }
; 720 
; 721 /* L<начало>,<конец> - Посмотр области памяти в символьном виде */
; 722 
; 723 void CmdL() {
cmdl:
; 724     ParseParams();
	call parseparams
; 725     PrintLfParam1Space();
	call printlfparam1space
; 726     for (;;) {
l_64:
; 727         hl = param1;
	ld hl, (param1)
; 728         a = *hl;
	ld a, (hl)
; 729         if (a < 0x20)
	cp 32
; 730             a = '.';
	jp nc, l_66
	ld a, 46
l_66:
; 731         PrintCharA();
	call printchara
; 732         Loop();
	call loop
; 733         PrintSpace();
	call printspace
; 734         if (flag_z((a = param1) &= 0x0F))
	ld a, (param1)
	and 15
; 735             PrintLfParam1Space();
	call z, printlfparam1space
	jp l_64
; 736     }
; 737 }
; 738 
; 739 /* H<число 1>,<число 2> - Сложение и вычитание чисел */
; 740 
; 741 void CmdH(...) {
cmdh:
; 742     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 743     ParseDword();
	call parsedword
; 744     param1 = hl;
	ld (param1), hl
; 745     ParseDword();
	call parsedword
; 746     param2 = hl;
	ld (param2), hl
; 747 
; 748     /* param1 + param2 */
; 749     swap(hl, de);
	ex hl, de
; 750     hl = param1;
	ld hl, (param1)
; 751     push(hl);
	push hl
; 752     hl += de;
	add hl, de
; 753     param1 = hl;
	ld (param1), hl
; 754     PrintLfParam1Space();
	call printlfparam1space
; 755 
; 756     /* param1 - param2 */
; 757     pop(hl);
	pop hl
; 758     a = e;
	ld a, e
; 759     invert(a);
	cpl
; 760     e = a;
	ld e, a
; 761     a = d;
	ld a, d
; 762     invert(a);
	cpl
; 763     d = a;
	ld d, a
; 764     de++;
	inc de
; 765     hl += de;
	add hl, de
; 766     param1 = hl;
	ld (param1), hl
; 767     PrintParam1Space();
	jp printparam1space
; 768 }
; 769 
; 770 /* I - Ввод информации с магнитной ленты */
; 771 
; 772 void CmdI() {
cmdi:
; 773     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 774     param1h = a;
	ld (param1h), a
; 775     tapeStartH = a;
	ld (tapestarth), a
; 776 
; 777     ReadTapeByteNext();
	call readtapebytenext
; 778     param1 = a;
	ld (param1), a
; 779     tapeStartL = a;
	ld (tapestartl), a
; 780 
; 781     ReadTapeByteNext();
	call readtapebytenext
; 782     param2h = a;
	ld (param2h), a
; 783     tapeStopH = a;
	ld (tapestoph), a
; 784 
; 785     ReadTapeByteNext();
	call readtapebytenext
; 786     param2 = a;
	ld (param2), a
; 787     tapeStopL = a;
	ld (tapestopl), a
; 788 
; 789     hl = &CmdIEnd;
	ld hl, 0FFFFh & (cmdiend)
; 790     push(hl);
	push hl
; 791 
; 792     for (;;) {
l_69:
; 793         hl = param1;
	ld hl, (param1)
; 794         ReadTapeByteNext(a);
	call readtapebytenext
; 795         *hl = a;
	ld (hl), a
; 796         Loop();
	call loop
	jp l_69
; 797     }
; 798 }
; 799 
; 800 void CmdIEnd(...) {
cmdiend:
; 801     PrintLf();
	call printlf
; 802     PrintHexWordSpace(hl = &tapeStartH);
	ld hl, 0FFFFh & (tapestarth)
	call printhexwordspace
; 803     PrintHexWordSpace(hl = &tapeStopH);
	ld hl, 0FFFFh & (tapestoph)
	jp printhexwordspace
; 804 }
; 805 
; 806 /* O<начало>,<конец> - Вывод содержимого области памяти на магнитную ленту */
; 807 
; 808 void CmdO() {
cmdo:
; 809     ParseParams();
	call parseparams
; 810     a ^= a;
	xor a
; 811     b = a;
	ld b, a
; 812     do {
l_71:
; 813         WriteTapeByte(a);
	call writetapebyte
l_72:
; 814     } while (flag_nz(b--));
	dec b
	jp nz, l_71
; 815     WriteTapeByte(a = TAPE_START);
	ld a, 230
	call writetapebyte
; 816     WriteTapeByte(a = param1h);
	ld a, (param1h)
	call writetapebyte
; 817     WriteTapeByte(a = param1);
	ld a, (param1)
	call writetapebyte
; 818     WriteTapeByte(a = param2h);
	ld a, (param2h)
	call writetapebyte
; 819     WriteTapeByte(a = param2);
	ld a, (param2)
	call writetapebyte
; 820     for (;;) {
l_75:
; 821         hl = param1;
	ld hl, (param1)
; 822         a = *hl;
	ld a, (hl)
; 823         WriteTapeByte(a);
	call writetapebyte
; 824         Loop();
	call loop
	jp l_75
; 825     }
; 826 }
; 827 
; 828 /* V - Сравнение информации на магнитной ленте с содержимым области памяти */
; 829 
; 830 void CmdV() {
cmdv:
; 831     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 832     param1h = a;
	ld (param1h), a
; 833     ReadTapeByteNext();
	call readtapebytenext
; 834     param1 = a;
	ld (param1), a
; 835     ReadTapeByteNext();
	call readtapebytenext
; 836     param2h = a;
	ld (param2h), a
; 837     ReadTapeByteNext();
	call readtapebytenext
; 838     param2 = a;
	ld (param2), a
; 839     for (;;) {
l_78:
; 840         ReadTapeByteNext();
	call readtapebytenext
; 841         hl = param1;
	ld hl, (param1)
; 842         if (a != *hl) {
	cp (hl)
	jp z, l_80
; 843             push_pop(a) {
	push af
; 844                 PrintLfParam1Space();
	call printlfparam1space
; 845                 PrintByteFromParam1();
	call printbytefromparam1
; 846                 PrintSpace();
	call printspace
	pop af
; 847             }
; 848             PrintHexByte();
	call printhexbyte
l_80:
; 849         }
; 850         Loop();
	call loop
	jp l_78
; 851     }
; 852 }
; 853 
; 854 void ReadTapeByteNext() {
readtapebytenext:
; 855     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
; 856 }
; 857 
; 858 void ReadTapeByte(...) {
readtapebyte:
; 859     push(bc, de);
	push bc
	push de
; 860     c = 0;
	ld c, 0
; 861     d = a;
	ld d, a
; 862     e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 863     do {
l_82:
; 864     loc_FD9D:
loc_fd9d:
; 865         a = c;
	ld a, c
; 866         a &= 0x7F;
	and 127
; 867         cyclic_rotate_left(a, 1);
	rlca
; 868         c = a;
	ld c, a
; 869 
; 870         do {
l_85:
; 871             a = in(PORT_TAPE);
	in a, (1)
l_86:
; 872         } while (a == e);
	cp e
	jp z, l_85
; 873         a &= 1;
	and 1
; 874         a |= c;
	or c
; 875         c = a;
	ld c, a
; 876         ReadTapeDelay();
	call readtapedelay
; 877         e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 878         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_88
; 879             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_90
; 880                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_91
l_90:
; 881             } else {
; 882                 if (a != (0xFF ^ TAPE_START))
	cp 25
; 883                     goto loc_FD9D;
	jp nz, loc_fd9d
; 884                 tapePolarity = a = 0xFF;
	ld a, 255
	ld (tapepolarity), a
l_91:
; 885             }
; 886             d = 8 + 1;
	ld d, 9
l_88:
l_83:
; 887         }
; 888     } while (flag_nz(d--));
	dec d
	jp nz, l_82
; 889     a = tapePolarity;
	ld a, (tapepolarity)
; 890     a ^= c;
	xor c
; 891     pop(bc, de);
	pop de
	pop bc
	ret
; 892 }
; 893 
; 894 void ReadTapeDelay(...) {
readtapedelay:
; 895     push(a);
	push af
; 896     TapeDelay(a = readDelay);
	ld a, (readdelay)
; 897 }
; 898 
; 899 void TapeDelay(...) {
tapedelay:
; 900     b = a;
	ld b, a
; 901     pop(a);
	pop af
; 902     do {
l_92:
l_93:
; 903     } while (flag_nz(b--));
	dec b
	jp nz, l_92
	ret
; 904 }
; 905 
; 906 void WriteTapeByte(...) {
writetapebyte:
; 907     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 908         d = a;
	ld d, a
; 909         c = 8;
	ld c, 8
; 910         do {
l_95:
; 911             a = d;
	ld a, d
; 912             cyclic_rotate_left(a, 1);
	rlca
; 913             d = a;
	ld d, a
; 914 
; 915             out(PORT_TAPE, (a = 1) ^= d);
	ld a, 1
	xor d
	out (1), a
; 916             WriteTapeDelay();
	call writetapedelay
; 917 
; 918             out(PORT_TAPE, (a = 0) ^= d);
	ld a, 0
	xor d
	out (1), a
; 919             WriteTapeDelay();
	call writetapedelay
l_96:
; 920         } while (flag_nz(c--));
	dec c
	jp nz, l_95
	pop af
	pop de
	pop bc
	ret
; 921     }
; 922 }
; 923 
; 924 void WriteTapeDelay(...) {
writetapedelay:
; 925     push(a);
	push af
; 926     TapeDelay(a = writeDelay);
	ld a, (writedelay)
	jp tapedelay
; 927 }
; 928 
; 929 uint8_t monitorCommands = 'M';
monitorcommands:
	db 77
; 930  monitorCommandsMa = &CmdM;
monitorcommandsma:
	dw 0FFFFh & (cmdm)
; 931  monitorCommandsC = 'C';
monitorcommandsc:
	db 67
; 932  monitorCommandsCa = &CmdC;
monitorcommandsca:
	dw 0FFFFh & (cmdc)
; 933  monitorCommandsD = 'D';
monitorcommandsd:
	db 68
; 934  monitorCommandsDa = &CmdD;
monitorcommandsda:
	dw 0FFFFh & (cmdd)
; 935  monitorCommandsB = 'B';
monitorcommandsb:
	db 66
; 936  monitorCommandsBa = &CmdB;
monitorcommandsba:
	dw 0FFFFh & (cmdb)
; 937  monitorCommandsG = 'G';
monitorcommandsg:
	db 71
; 938  monitorCommandsGa = &CmdG;
monitorcommandsga:
	dw 0FFFFh & (cmdg)
; 939  monitorCommandsP = 'P';
monitorcommandsp:
	db 80
; 940  monitorCommandsPa = &CmdP;
monitorcommandspa:
	dw 0FFFFh & (cmdp)
; 941  monitorCommandsX = 'X';
monitorcommandsx:
	db 88
; 942  monitorCommandsXa = &CmdX;
monitorcommandsxa:
	dw 0FFFFh & (cmdx)
; 943  monitorCommandsF = 'F';
monitorcommandsf:
	db 70
; 944  monitorCommandsFa = &CmdF;
monitorcommandsfa:
	dw 0FFFFh & (cmdf)
; 945  monitorCommandsS = 'S';
monitorcommandss:
	db 83
; 946  monitorCommandsSa = &CmdS;
monitorcommandssa:
	dw 0FFFFh & (cmds)
; 947  monitorCommandsT = 'T';
monitorcommandst:
	db 84
; 948  monitorCommandsTa = &CmdT;
monitorcommandsta:
	dw 0FFFFh & (cmdt)
; 949  monitorCommandsI = 'I';
monitorcommandsi:
	db 73
; 950  monitorCommandsIa = &CmdI;
monitorcommandsia:
	dw 0FFFFh & (cmdi)
; 951  monitorCommandsO = 'O';
monitorcommandso:
	db 79
; 952  monitorCommandsOa = &CmdO;
monitorcommandsoa:
	dw 0FFFFh & (cmdo)
; 953  monitorCommandsV = 'V';
monitorcommandsv:
	db 86
; 954  monitorCommandsVa = &CmdV;
monitorcommandsva:
	dw 0FFFFh & (cmdv)
; 955  monitorCommandsJ = 'J';
monitorcommandsj:
	db 74
; 956  monitorCommandsJa = &CmdJ;
monitorcommandsja:
	dw 0FFFFh & (cmdj)
; 957  monitorCommandsA = 'A';
monitorcommandsa:
	db 65
; 958  monitorCommandsAa = &CmdA;
monitorcommandsaa:
	dw 0FFFFh & (cmda)
; 959  monitorCommandsK = 'K';
monitorcommandsk:
	db 75
; 960  monitorCommandsKa = &CmdK;
monitorcommandska:
	dw 0FFFFh & (cmdk)
; 961  monitorCommandsQ = 'Q';
monitorcommandsq:
	db 81
; 962  monitorCommandsQa = &CmdQ;
monitorcommandsqa:
	dw 0FFFFh & (cmdq)
; 963  monitorCommandsL = 'L';
monitorcommandsl:
	db 76
; 964  monitorCommandsLa = &CmdL;
monitorcommandsla:
	dw 0FFFFh & (cmdl)
; 965  monitorCommandsH = 'H';
monitorcommandsh:
	db 72
; 966  monitorCommandsHa = &CmdH;
monitorcommandsha:
	dw 0FFFFh & (cmdh)
; 967  monitorCommandsEnd = 0;
monitorcommandsend:
	db 0
; 969  aHello[] = "\x1F*MikrO/80* MONITOR";
ahello:
	db 31
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
	ds 1
; 970  aPrompt[] = "\x0A>";
aprompt:
	db 10
	db 62
	ds 1
; 972  PrintLf(...) {
printlf:
; 973     PrintCharA(a = 0x0A);
	ld a, 10
; 974 }
; 975 
; 976 void PrintCharA(...) {
printchara:
; 977     push(bc);
	push bc
; 978     PrintCharInt(c = a);
	ld c, a
	jp printcharint
; 979 }
; 980 
; 981 void PrintChar(...) {
printchar:
; 982     push(bc);
	push bc
; 983     PrintCharInt(c);
; 984 }
; 985 
; 986 void PrintCharInt(...) {
printcharint:
; 987     push(hl, de, a);
	push hl
	push de
	push af
; 988 
; 989     /* Hide cursor */
; 990     hl = cursor;
	ld hl, (cursor)
; 991     de = -SCREEN_SIZE;
	ld de, 63488
; 992     push_pop(hl) {
	push hl
; 993         hl += de;
	add hl, de
; 994         a = *hl;
	ld a, (hl)
; 995         a &= 0xFF ^ SCREEN_ATTRIB_UNDERLINE;
	and 127
; 996         *hl = a;
	ld (hl), a
	pop hl
; 997     }
; 998 
; 999     a = c;
	ld a, c
; 1000     if (a < 32) {
	cp 32
	jp nc, l_98
; 1001         a -= 0x08;
	sub 8
; 1002         if (flag_z)
; 1003             return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1004         a -= 0x0A - 0x08;
	sub 2
; 1005         if (flag_z)
; 1006             return MoveCursorNextLine(hl);
	jp z, movecursornextline
; 1007         a -= 0x0C - 0x0A;
	sub 2
; 1008         if (flag_z)
; 1009             return MoveCursorHome();
	jp z, movecursorhome
; 1010         a -= 0x18 - 0x0C;
	sub 12
; 1011         if (flag_z)
; 1012             return MoveCursorRight(hl);
	jp z, movecursorright
; 1013         a--; /* 0x19 */
	dec a
; 1014         if (flag_z)
; 1015             return MoveCursorUp(hl);
	jp z, movecursorup
; 1016         a--; /* 0x1A */
	dec a
; 1017         if (flag_z)
; 1018             return MoveCursorDown(hl);
	jp z, movecursordown
; 1019         a -= 0x1F - 0x1A;
	sub 5
; 1020         if (flag_z)
; 1021             return ClearScreen();
	jp z, clearscreen
l_98:
; 1022     }
; 1023 
; 1024     *hl = c;
	ld (hl), c
; 1025     push_pop(hl) {
	push hl
; 1026         hl += de;
	add hl, de
; 1027         *hl = a = color;
	ld a, (color)
	ld (hl), a
	pop hl
; 1028     }
; 1029     return MoveCursorRight();
; 1030 }
; 1031 
; 1032 void MoveCursorRight(...) {
movecursorright:
; 1033     hl++;
	inc hl
; 1034     return MoveCursor(hl);
; 1035 }
; 1036 
; 1037 void MoveCursor(...) {
movecursor:
; 1038     swap(hl, de);
	ex hl, de
; 1039     hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT);
	ld hl, 4544
; 1040     hl += de;
	add hl, de
; 1041     swap(hl, de);
	ex hl, de
; 1042     if (flag_c) {
	jp nc, l_100
; 1043         push_pop(hl) {
	push hl
; 1044             /* Scroll up */
; 1045             hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1;
	ld hl, 60991
; 1046             c = SCREEN_WIDTH;
	ld c, 64
; 1047             do {
l_102:
; 1048                 push_pop(hl) {
	push hl
; 1049                     de = SCREEN_SIZE - SCREEN_WIDTH;
	ld de, 1984
; 1050                     b = 0;
	ld b, 0
; 1051                     c = a = color;
	ld a, (color)
	ld c, a
; 1052                     do {
l_105:
; 1053                         a = b;
	ld a, b
; 1054                         b = *hl;
	ld b, (hl)
; 1055                         *hl = a;
	ld (hl), a
; 1056                         h = ((a = h) -= 8);
	ld a, h
	sub 8
	ld h, a
; 1057                         a = c;
	ld a, c
; 1058                         c = *hl;
	ld c, (hl)
; 1059                         *hl = a;
	ld (hl), a
; 1060                         hl += de;
	add hl, de
l_106:
; 1061                     } while ((a = h) != 0xE7);
	ld a, h
	cp 231
	jp nz, l_105
	pop hl
; 1062                 }
; 1063                 l--;
	dec l
l_103:
; 1064             } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
	ld a, l
	cp 60927
	jp nz, l_102
	pop hl
; 1065         }
; 1066         hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
l_100:
; 1067     }
; 1068 
; 1069     cursor = hl;
	ld (cursor), hl
; 1070 
; 1071     /* Show cursor */
; 1072     hl += (de = -SCREEN_SIZE);
	ld de, 63488
	add hl, de
; 1073     a = *hl;
	ld a, (hl)
; 1074     a |= SCREEN_ATTRIB_UNDERLINE;
	or 128
; 1075     *hl = a;
	ld (hl), a
; 1076 
; 1077     pop(bc, hl, de, a);
	pop af
	pop de
	pop hl
	pop bc
	ret
; 1078 }
; 1079 
; 1080 void ClearScreenInt() {
clearscreenint:
; 1081     do {
l_108:
; 1082         do {
l_111:
; 1083             *hl = 0;
	ld (hl), 0
; 1084             hl++;
	inc hl
; 1085             *de = a;
	ld (de), a
; 1086             de++;
	inc de
l_112:
; 1087         } while (flag_nz(c--));
	dec c
	jp nz, l_111
l_109:
; 1088     } while (flag_nz(b--));
	dec b
	jp nz, l_108
	ret
; 1089 }
; 1090 
; 1091 void ClearScreen() {
clearscreen:
; 1092     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1093     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1094     bc = 0x740; /* 25 rows */
	ld bc, 1856
; 1095     a = color;
	ld a, (color)
; 1096     ClearScreenInt();
	call clearscreenint
; 1097     a = SCREEN_ATTRIB_BLANK;
	ld a, 7
; 1098     bc = 0x2C0; /* 7 rows */
	ld bc, 704
; 1099     ClearScreenInt();
	call clearscreenint
; 1100     PrintKeyStatus();
	call printkeystatus
; 1101     MoveCursorHome();
; 1102 }
; 1103 
; 1104 void MoveCursorHome() {
movecursorhome:
; 1105     MoveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp movecursor
; 1106 }
; 1107 
; 1108 void MoveCursorLeft(...) {
movecursorleft:
; 1109     hl--;
	dec hl
; 1110     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1111         return MoveCursor(hl);
	jp nz, movecursor
; 1112     MoveCursor(hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1);
	ld hl, 60991
	jp movecursor
; 1113 }
; 1114 
; 1115 void MoveCursorNextLine(...) {
movecursornextline:
; 1116     a = l;
	ld a, l
; 1117     a &= 0xFF ^ (SCREEN_WIDTH - 1);
	and 192
; 1118     l = a;
	ld l, a
; 1119     MoveCursorDown();
; 1120 }
; 1121 
; 1122 void MoveCursorDown(...) {
movecursordown:
; 1123     hl += (de = SCREEN_WIDTH);
	ld de, 64
	add hl, de
; 1124     MoveCursor(hl);
	jp movecursor
; 1125 }
; 1126 
; 1127 void MoveCursorUp(...) {
movecursorup:
; 1128     hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
; 1129     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1130         return MoveCursor(hl);
	jp nz, movecursor
; 1131     hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 1600
	add hl, de
; 1132     MoveCursor(hl);
	jp movecursor
; 1133 }
; 1134 
; 1135 void ReadKey() {
readkey:
; 1136     do {
l_114:
; 1137         ScanKey();
	call scankey
l_115:
	jp z, l_114
; 1138     } while (flag_z);
; 1139     a--;
	dec a
; 1140 
; 1141     push_pop(a) {
	push af
; 1142         keySaved = a = 0xFF;
	ld a, 255
	ld (keysaved), a
	pop af
	ret
; 1143     }
; 1144 }
; 1145 
; 1146 uint8_t aZag[] = {'z', 'a' | 0x80, 'g' | 0x80, 's', 't' | 0x80, 'r' | 0x80};
azag:
	db 122
	db 225
	db 231
	db 115
	db 244
	db 242
; 1147  aLat[] = {'l', 'a' | 0x80, 't' | 0x80, 'r', 'u' | 0x80, 's' | 0x80};
alat:
	db 108
	db 225
	db 244
	db 114
	db 245
	db 243
; 1149  PrintKeyStatus() {
printkeystatus:
; 1150     bc = 0xEFF9;
	ld bc, 61433
; 1151     a = keybMode;
	ld a, (keybmode)
; 1152     hl = &aZag;
	ld hl, azag
; 1153     PrintKeyStatus1();
	call printkeystatus1
; 1154     bc++;
	inc bc
; 1155     hl = &aLat;
	ld hl, alat
; 1156     PrintKeyStatus1();
; 1157 }
; 1158 
; 1159 void PrintKeyStatus1() {
printkeystatus1:
; 1160     de = 3; /* String size */
	ld de, 3
; 1161     cyclic_rotate_right(a);
	rrca
; 1162     if (flag_c)
; 1163         hl += de;
	jp nc, l_117
	add hl, de
l_117:
; 1164     d = a;
	ld d, a
; 1165     do {
l_119:
; 1166         *bc = a = *hl;
	ld a, (hl)
	ld (bc), a
; 1167         bc++;
	inc bc
; 1168         hl++;
	inc hl
l_120:
; 1169     } while (flag_nz(e--));
	dec e
	jp nz, l_119
; 1170     a = d;
	ld a, d
	ret
; 1171 }
; 1172 
; 1173 void ScanKey() {
scankey:
; 1174     push(bc, de, hl);
	push bc
	push de
	push hl
; 1175     ScanKey0();
; 1176 }
; 1177 
; 1178 void ScanKey0() {
scankey0:
; 1179     b = -1;
	ld b, 255
; 1180     c = 1 ^ 0xFF;
	ld c, 254
; 1181     d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1182     do {
l_122:
; 1183         out(PORT_KEYBOARD_COLUMN, a = c);
	ld a, c
	out (7), a
; 1184         cyclic_rotate_left(a, 1);
	rlca
; 1185         c = a;
	ld c, a
; 1186         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1187         a &= KEYBOARD_ROW_MASK;
	and 127
; 1188         if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1189             return ScanKey1(a, b);
	jp nz, scankey1
; 1190         b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_123:
; 1191     } while (flag_nz(d--));
	dec d
	jp nz, l_122
; 1192 
; 1193     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1194     if (flag_z(a &= KEYBOARD_RUS_MOD))
	and 1
; 1195         return ScanKey1(a, b);
	jp z, scankey1
; 1196 
; 1197     keyLast = a = 0xFF;
	ld a, 255
	ld (keylast), a
; 1198 
; 1199     return ScanKeyExit();
	jp scankeyexit
; 1200 }
; 1201 
; 1202 void ScanKey1(...) {
scankey1:
; 1203     do {
l_125:
; 1204         b++;
	inc b
; 1205         cyclic_rotate_right(a);
	rrca
l_126:
	jp c, l_125
; 1206     } while (flag_c);
; 1207 
; 1208     /* Delay */
; 1209     a ^= a;
	xor a
; 1210     do {
l_128:
; 1211         a--;
	dec a
l_129:
	jp nz, l_128
; 1212     } while (flag_nz);
; 1213 
; 1214     /* b - key number */
; 1215 
; 1216     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1217      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1218      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1219      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1220      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1221      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1222      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1223     hl = &keyLast;
	ld hl, 0FFFFh & (keylast)
; 1224     a = *hl;
	ld a, (hl)
; 1225     hl--; /* keyDelay */
	dec hl
; 1226     if (a == b) {
	cp b
	jp nz, l_131
; 1227         (*hl)--;
	dec (hl)
; 1228         if (flag_nz)
; 1229             return ScanKey0();
	jp nz, scankey0
; 1230         *hl = 0x30; /* Next repeat delay */
	ld (hl), 48
	jp l_132
l_131:
; 1231     } else {
; 1232         *hl = 0xFF; /* First repeat delay */
	ld (hl), 255
l_132:
; 1233     }
; 1234     hl++;
	inc hl
; 1235     *hl = b; /* Key last */
	ld (hl), b
; 1236 
; 1237     a = b;
	ld a, b
; 1238     if (a >= 48) {
	cp 48
	jp c, l_133
; 1239         if (a == 56) { /* RUS/LAT */
	cp 56
	jp nz, l_135
; 1240             a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1241             carry_rotate_right(a, 3); /* Shift */
	rra
	rra
	rra
; 1242             a = KEYB_MODE_CAP;
	ld a, 1
; 1243             carry_add(a, 0); /* KEYB_MODE_CAP -> KEYB_MODE_RUS */
	adc 0
; 1244             hl = &keybMode;
	ld hl, 0FFFFh & (keybmode)
; 1245             a ^= *hl;
	xor (hl)
; 1246             *hl = a;
	ld (hl), a
; 1247 
; 1248             PrintKeyStatus();
	call printkeystatus
; 1249             return ScanKey0();
	jp scankey0
l_135:
; 1250         }
; 1251         a += (keyTable - 48);
	add 0FFh & ((keytable) - (48))
; 1252         l = a;
	ld l, a
; 1253         h = ((uintptr_t)keyTable - 48) >> 8;
	ld h, 0FFh & (((0FFFFh & (0FFFFh & (keytable))) - (48)) >> (8))
; 1254         a = *hl;
	ld a, (hl)
; 1255         return ScanKey2(a);
	jp scankey2
l_133:
; 1256     }
; 1257 
; 1258     a += '0';
	add 48
; 1259     if (a >= 0x3C)
	cp 60
; 1260         if (a < 0x40)
	jp c, l_137
	cp 64
; 1261             a &= 0x2F; /* <=>? to .-./ */
	jp nc, l_139
	and 47
l_139:
l_137:
; 1262     c = a;
	ld c, a
; 1263 
; 1264     a = keybMode;
	ld a, (keybmode)
; 1265     cyclic_rotate_right(a, 2); /* KEYB_MODE_RUS */
	rrca
	rrca
; 1266     if (flag_c) {
	jp nc, l_141
; 1267         a = c;
	ld a, c
; 1268         a |= 0x20;
	or 32
; 1269         c = a;
	ld c, a
l_141:
; 1270     }
; 1271 
; 1272     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1273     cyclic_rotate_right(a, 2); /* Ctrl */
	rrca
	rrca
; 1274     if (flag_nc) {
	jp c, l_143
; 1275         a = c;
	ld a, c
; 1276         a &= 0x1F;
	and 31
; 1277         return ScanKey2(a);
	jp scankey2
l_143:
; 1278     }
; 1279 
; 1280     carry_rotate_right(a, 1); /* Shift */
	rra
; 1281     a = c;
	ld a, c
; 1282     if (flag_nc) {
	jp c, l_145
; 1283         if (a >= 0x40) {
	cp 64
	jp c, l_147
; 1284             a |= 0x80;
	or 128
; 1285             return ScanKey2(a);
	jp scankey2
l_147:
; 1286         }
; 1287         a ^= 0x10;
	xor 16
l_145:
; 1288     }
; 1289 
; 1290     ScanKey2(a);
; 1291 }
; 1292 
; 1293 void ScanKey2(...) {
scankey2:
; 1294     keySaved = a;
	ld (keysaved), a
; 1295     c = a;
	ld c, a
; 1296 
; 1297     a = keybMode;
	ld a, (keybmode)
; 1298     cyclic_rotate_right(a, 1); /* KEYB_MODE_CAP */
	rrca
; 1299     if (flag_nc)
; 1300         return ScanKeyExit();
	jp nc, scankeyexit
; 1301 
; 1302     a = c;
	ld a, c
; 1303     a &= 0x7F;
	and 127
; 1304     if (a < 0x60) { /* Cyr chars */
	cp 96
	jp nc, l_149
; 1305         if (a < 'A')
	cp 65
; 1306             return ScanKeyExit();
	jp c, scankeyexit
; 1307         if (a >= 'Z' + 1)
	cp 91
; 1308             return ScanKeyExit();
	jp nc, scankeyexit
l_149:
; 1309     }
; 1310     a = c;
	ld a, c
; 1311     a ^= 0x80;
	xor 128
; 1312     keySaved = a;
	ld (keysaved), a
; 1313     ScanKeyExit();
; 1314 }
; 1315 
; 1316 void ScanKeyExit(...) {
scankeyexit:
; 1317     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
; 1318     a = keySaved;
	ld a, (keysaved)
; 1319     a++; /* Returns ZF and A = 0 if no key is pressed */
	inc a
	ret
; 1320 }
; 1321 
; 1322 uint8_t keyTable[] = {
keytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1333  IsKeyPressed() {
iskeypressed:
; 1334     ScanKey();
	call scankey
; 1335     if (flag_z)
; 1336         return; /* Returns 0 if no key is pressed */
	ret z
; 1337     a = 0xFF;   /* Returns 0xFF if there are any keys pressed */
	ld a, 255
	ret
 savebin "micro80.bin", 0xF800, 0x10000
