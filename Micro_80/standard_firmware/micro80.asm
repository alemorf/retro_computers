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
; 37  uint8_t rst38Opcode __address(0x38);
; 38 extern uint16_t rst38Address __address(0x39);
; 39 
; 40 /* BIOS variables */
; 41 void jumpParam1() __address(0xF750);
; 42 extern uint8_t jumpOpcode __address(0xF750);
; 43 extern uint16_t param1 __address(0xF751);
; 44 extern uint8_t param1h __address(0xF752);
; 45 extern uint16_t param2 __address(0xF753);
; 46 extern uint8_t param2h __address(0xF754);
; 47 extern uint16_t param3 __address(0xF755);
; 48 extern uint8_t param3h __address(0xF756);
; 49 extern uint8_t tapePolarity __address(0xF757);
; 50 /* Unused 0xF758 */
; 51 /* Unused 0xF759 */
; 52 extern uint16_t cursor __address(0xF75A);
; 53 extern uint8_t readDelay __address(0xF75C);
; 54 extern uint8_t writeDelay __address(0xF75D);
; 55 extern uint8_t tapeStartL __address(0xF75E);
; 56 extern uint8_t tapeStartH __address(0xF75F);
; 57 extern uint8_t tapeStopL __address(0xF760);
; 58 extern uint8_t tapeStopH __address(0xF761);
; 59 /* Unused 0xF762 */
; 60 /* Unused 0xF763 */
; 61 extern uint8_t keyLast __address(0xF764);
; 62 extern uint16_t regs __address(0xF765);
; 63 extern uint16_t regSP __address(0xF765);
; 64 extern uint8_t regSPH __address(0xF766);
; 65 extern uint16_t regF __address(0xF767);
; 66 extern uint16_t regA __address(0xF768);
; 67 extern uint16_t regC __address(0xF769);
; 68 extern uint16_t regB __address(0xF76A);
; 69 extern uint16_t regE __address(0xF76B);
; 70 extern uint16_t regD __address(0xF76C);
; 71 extern uint16_t regL __address(0xF76D);
; 72 extern uint16_t regHL __address(0xF76D);
; 73 extern uint16_t regH __address(0xF76E);
; 74 extern uint16_t lastBreakAddress __address(0xF76F);
; 75 extern uint8_t lastBreakAddressHigh __address(0xF770);
; 76 extern uint8_t breakCounter __address(0xF771);
; 77 extern uint16_t breakAddress __address(0xF772);
; 78 extern uint8_t breakPrevByte __address(0xF774);
; 79 extern uint16_t breakAddress2 __address(0xF775);
; 80 extern uint8_t breakPrevByte2 __address(0xF777);
; 81 extern uint16_t breakAddress3 __address(0xF778);
; 82 extern uint8_t breakPrevByte3 __address(0xF77A);
; 83 extern uint8_t cmdBuffer __address(0xF77B);
; 84 extern uint8_t cmdBuffer1 __address(0xF77B + 1);
; 85 extern uint8_t cmdBufferEnd __address(0xF77B + 32);
 org 0F800h
; 77  EntryReboot(...) {
entryreboot:
; 78     Reboot();
	jp reboot
; 79 }
; 80 
; 81 void EntryReadChar(...) {
entryreadchar:
; 82     ReadKey();
	jp readkey
; 83 }
; 84 
; 85 void EntryReadTapeByte(...) {
entryreadtapebyte:
; 86     ReadTapeByte();
	jp readtapebyte
; 87 }
; 88 
; 89 void EntryPrintChar(...) {
entryprintchar:
; 90     PrintChar();
	jp printchar
; 91 }
; 92 
; 93 void EntryWriteTapeByte(...) {
entrywritetapebyte:
; 94     WriteTapeByte();
	jp writetapebyte
; 95 }
; 96 
; 97 void EntryPrintChar2(...) {
entryprintchar2:
; 98     PrintChar();
	jp printchar
; 99 }
; 100 
; 101 void EntryIsKeyPressed(...) {
entryiskeypressed:
; 102     IsKeyPressed();
	jp iskeypressed
; 103 }
; 104 
; 105 void EntryPrintHexByte(...) {
entryprinthexbyte:
; 106     PrintHexByte();
	jp printhexbyte
; 107 }
; 108 
; 109 void EntryPrintString(...) {
entryprintstring:
; 110     PrintString();
	jp printstring
; 111 }
; 112 
; 113 void Reboot(...) {
reboot:
; 114     regSP = hl = USER_STACK_TOP;
	ld hl, 63424
	ld (regsp), hl
; 115     sp = STACK_TOP;
	ld sp, 63487
; 116     PrintCharA(a = 0x1F); /* Clear screen */
	ld a, 31
	call printchara
; 117     Monitor();
; 118 }
; 119 
; 120 void Monitor(...) {
monitor:
; 121     out(PORT_KEYBOARD_MODE, a = 0x8B);
	ld a, 139
	out (4), a
; 122     sp = STACK_TOP;
	ld sp, 63487
; 123     PrintString(hl = &aPrompt);
	ld hl, aprompt
	call printstring
; 124     ReadString();
	call readstring
; 125     push(hl = &Monitor);
	ld hl, 0FFFFh & (monitor)
	push hl
; 126     MonitorExecute();
; 127 }
; 128 
; 129 void MonitorExecute(...) {
monitorexecute:
; 130     hl = &cmdBuffer;
	ld hl, 0FFFFh & (cmdbuffer)
; 131     b = *hl;
	ld b, (hl)
; 132     hl = &monitorCommands;
	ld hl, 0FFFFh & (monitorcommands)
; 133 
; 134     for (;;) {
l_1:
; 135         a = *hl;
	ld a, (hl)
; 136         if (flag_z(a &= a))
	and a
; 137             return MonitorError();
	jp z, monitorerror
; 138         if (a == b)
	cp b
; 139             break;
	jp z, l_2
; 140         hl++;
	inc hl
; 141         hl++;
	inc hl
; 142         hl++;
	inc hl
	jp l_1
l_2:
; 143     }
; 144 
; 145     hl++;
	inc hl
; 146     sp = hl;
	ld sp, hl
; 147     pop(hl);
	pop hl
; 148     sp = STACK_TOP - 2;
	ld sp, 63485
; 149     return hl();
	jp hl
; 150 }
; 151 
; 152 void ReadString(...) {
readstring:
; 153     return ReadStringLoop(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 154 }
; 155 
; 156 void ReadStringLoop(...) {
readstringloop:
; 157     do {
l_3:
; 158         ReadKey();
	call readkey
; 159         if (a == 8)
	cp 8
; 160             return ReadStringBs();
	jp z, readstringbs
; 161         if (flag_nz)
; 162             PrintCharA();
	call nz, printchara
; 163         *hl = a;
	ld (hl), a
; 164         if (a == 0x0D)
	cp 13
; 165             return ReadStringCr(hl);
	jp z, readstringcr
; 166         a = &cmdBufferEnd - 1;
	ld a, 0FFh & ((cmdbufferend) - (1))
; 167         compare(a, l);
	cp l
; 168         hl++;
	inc hl
l_4:
	jp nz, l_3
; 169     } while (flag_nz);
; 170     MonitorError();
; 171 }
; 172 
; 173 void MonitorError(...) {
monitorerror:
; 174     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 175     Monitor();
	jp monitor
; 176 }
; 177 
; 178 void ReadStringCr(...) {
readstringcr:
; 179     *hl = 0x0D;
	ld (hl), 13
	ret
; 180 }
; 181 
; 182 void ReadStringBs(...) {
readstringbs:
; 183     CommonBs();
	call commonbs
; 184     ReadStringLoop();
	jp readstringloop
; 185 }
; 186 
; 187 void CommonBs(...) {
commonbs:
; 188     if ((a = &cmdBuffer) == l)
	ld a, 0FFh & (cmdbuffer)
	cp l
; 189         return;
	ret z
; 190     PrintCharA(a = 8);
	ld a, 8
	call printchara
; 191     hl--;
	dec hl
	ret
; 192 }
; 193 
; 194 void Input(...) {
input:
; 195     PrintSpace();
	call printspace
; 196     InputInit(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 197 }
; 198 
; 199 void InputInit(...) {
inputinit:
; 200     InputLoop(b = 0);
	ld b, 0
; 201 }
; 202 
; 203 void InputLoop(...) {
inputloop:
; 204     for (;;) {
l_7:
; 205         ReadKey();
	call readkey
; 206         if (a == 8)
	cp 8
; 207             return InputBs();
	jp z, inputbs
; 208         if (flag_nz)
; 209             PrintCharA();
	call nz, printchara
; 210         *hl = a;
	ld (hl), a
; 211         if (a == ' ')
	cp 32
; 212             return InputEndSpace();
	jp z, inputendspace
; 213         if (a == 0x0D)
	cp 13
; 214             return PopWordReturn();
	jp z, popwordreturn
; 215         b = 0xFF;
	ld b, 255
; 216         if ((a = &cmdBufferEnd - 1) == l)
	ld a, 0FFh & ((cmdbufferend) - (1))
	cp l
; 217             return MonitorError();
	jp z, monitorerror
; 218         hl++;
	inc hl
	jp l_7
; 219     }
; 220 }
; 221 
; 222 void InputEndSpace(...) {
inputendspace:
; 223     *hl = 0x0D;
	ld (hl), 13
; 224     a = b;
	ld a, b
; 225     carry_rotate_left(a, 1);
	rla
; 226     de = &cmdBuffer;
	ld de, 0FFFFh & (cmdbuffer)
; 227     b = 0;
	ld b, 0
	ret
; 228 }
; 229 
; 230 void InputBs(...) {
inputbs:
; 231     CommonBs();
	call commonbs
; 232     if (flag_z)
; 233         return InputInit();
	jp z, inputinit
; 234     InputLoop();
	jp inputloop
; 235 }
; 236 
; 237 void PopWordReturn(...) {
popwordreturn:
; 238     sp++;
	inc sp
; 239     sp++;
	inc sp
	ret
; 240 }
; 241 
; 242 void PrintLf(...) {
printlf:
; 243     PrintString(hl = &aLf);
	ld hl, alf
; 244 }
; 245 
; 246 void PrintString(...) {
printstring:
; 247     for (;;) {
l_10:
; 248         a = *hl;
	ld a, (hl)
; 249         if (flag_z(a &= a))
	and a
; 250             return;
	ret z
; 251         PrintCharA(a);
	call printchara
; 252         hl++;
	inc hl
	jp l_10
; 253     }
; 254 }
; 255 
; 256 void ParseParams(...) {
parseparams:
; 257     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 258     b = 6;
	ld b, 6
; 259     a ^= a;
	xor a
; 260     do {
l_12:
; 261         *hl = a;
	ld (hl), a
l_13:
; 262     } while (flag_nz(b--));
	dec b
	jp nz, l_12
; 263 
; 264     de = &cmdBuffer + 1;
	ld de, 0FFFFh & ((cmdbuffer) + (1))
; 265     ParseDword();
	call parsedword
; 266     param1 = hl;
	ld (param1), hl
; 267     param2 = hl;
	ld (param2), hl
; 268     if (flag_c)
; 269         return;
	ret c
; 270     ParseDword();
	call parsedword
; 271     param2 = hl;
	ld (param2), hl
; 272     push_pop(a, de) {
	push af
	push de
; 273         swap(hl, de);
	ex hl, de
; 274         hl = param1;
	ld hl, (param1)
; 275         swap(hl, de);
	ex hl, de
; 276         CmpHlDe();
	call cmphlde
; 277         if (flag_c)
; 278             return MonitorError();
	jp c, monitorerror
	pop de
	pop af
; 279     }
; 280     if (flag_c)
; 281         return;
	ret c
; 282     ParseDword();
	call parsedword
; 283     param3 = hl;
	ld (param3), hl
; 284     if (flag_c)
; 285         return;
	ret c
; 286     MonitorError();
	jp monitorerror
; 287 }
; 288 
; 289 void ParseDword(...) {
parsedword:
; 290     hl = 0;
	ld hl, 0
; 291     ParseDword1();
; 292 }
; 293 
; 294 void ParseDword1(...) {
parsedword1:
; 295     for (;;) {
l_16:
; 296         a = *de;
	ld a, (de)
; 297         de++;
	inc de
; 298         if (a == 0x0D)
	cp 13
; 299             return ReturnCf();
	jp z, returncf
; 300         if (a == ',')
	cp 44
; 301             return;
	ret z
; 302         if (a == ' ')
	cp 32
; 303             continue;
	jp z, l_16
; 304         a -= '0';
	sub 48
; 305         if (flag_m)
; 306             return MonitorError();
	jp m, monitorerror
; 307         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_18
; 308             if (flag_m(compare(a, 0x11)))
	cp 17
; 309                 return MonitorError();
	jp m, monitorerror
; 310             if (flag_p(compare(a, 0x17)))
	cp 23
; 311                 return MonitorError();
	jp p, monitorerror
; 312             a -= 7;
	sub 7
l_18:
; 313         }
; 314         c = a;
	ld c, a
; 315         hl += hl;
	add hl, hl
; 316         hl += hl;
	add hl, hl
; 317         hl += hl;
	add hl, hl
; 318         hl += hl;
	add hl, hl
; 319         if (flag_c)
; 320             return MonitorError();
	jp c, monitorerror
; 321         hl += bc;
	add hl, bc
	jp l_16
; 322     }
; 323 }
; 324 
; 325 void ReturnCf(...) {
returncf:
; 326     set_flag_c();
	scf
	ret
; 327 }
; 328 
; 329 void PrintByteFromParam1(...) {
printbytefromparam1:
; 330     hl = param1;
	ld hl, (param1)
; 331     PrintHexByte(a = *hl);
	ld a, (hl)
; 332 }
; 333 
; 334 void PrintHexByte(...) {
printhexbyte:
; 335     b = a;
	ld b, a
; 336     a = b;
	ld a, b
; 337     cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 338     PrintHex(a);
	call printhex
; 339     PrintHex(a = b);
	ld a, b
; 340 }
; 341 
; 342 void PrintHex(...) {
printhex:
; 343     a &= 0x0F;
	and 15
; 344     if (flag_p(compare(a, 10)))
	cp 10
; 345         a += 'A' - '0' - 10;
	jp m, l_20
	add 7
l_20:
; 346     a += '0';
	add 48
; 347     PrintCharA(a);
	jp printchara
; 348 }
; 349 
; 350 void PrintLfParam1(...) {
printlfparam1:
; 351     PrintLf();
	call printlf
; 352     PrintParam1Space();
; 353 }
; 354 
; 355 void PrintParam1Space(...) {
printparam1space:
; 356     PrintHexWordSpace(hl = &param1h);
	ld hl, 0FFFFh & (param1h)
; 357 }
; 358 
; 359 void PrintHexWordSpace(...) {
printhexwordspace:
; 360     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 361     hl--;
	dec hl
; 362     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 363     PrintSpace();
; 364 }
; 365 
; 366 void PrintSpace(...) {
printspace:
; 367     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 368 }
; 369 
; 370 void Loop(...) {
loop:
; 371     push_pop(de) {
	push de
; 372         hl = param1;
	ld hl, (param1)
; 373         swap(hl, de);
	ex hl, de
; 374         hl = param2;
	ld hl, (param2)
; 375         CmpHlDe(hl, de);
	call cmphlde
	pop de
; 376     }
; 377     if (flag_z)
; 378         return PopWordReturn();
	jp z, popwordreturn
; 379     IncWord(hl = &param1);
	ld hl, 0FFFFh & (param1)
; 380 }
; 381 
; 382 void IncWord(...) {
incword:
; 383     (*hl)++;
	inc (hl)
; 384     if (flag_nz)
; 385         return;
	ret nz
; 386     hl++;
	inc hl
; 387     (*hl)++;
	inc (hl)
	ret
; 388 }
; 389 
; 390 void CmpHlDe(...) {
cmphlde:
; 391     if ((a = h) != d)
	ld a, h
	cp d
; 392         return;
	ret nz
; 393     compare(a = l, e);
	ld a, l
	cp e
	ret
; 394 }
; 395 
; 396 /* X - Изменение содержимого внутреннего регистра микропроцессора */
; 397 
; 398 void CmdX(...) {
cmdx:
; 399     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 400     a = *hl;
	ld a, (hl)
; 401     if (a == 0x0D)
	cp 13
; 402         return PrintRegs();
	jp z, printregs
; 403     if (a == 'S')
	cp 83
; 404         return CmdXS();
	jp z, cmdxs
; 405     FindRegister(de = &regList);
	ld de, reglist
	call findregister
; 406     hl = &regs;
	ld hl, 0FFFFh & (regs)
; 407     de++;
	inc de
; 408     l = a = *de;
	ld a, (de)
	ld l, a
; 409     push_pop(hl) {
	push hl
; 410         PrintSpace();
	call printspace
; 411         PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 412         Input();
	call input
; 413         if (flag_nc)
; 414             return Monitor();
	jp nc, monitor
; 415         ParseDword();
	call parsedword
; 416         a = l;
	ld a, l
	pop hl
; 417     }
; 418     *hl = a;
	ld (hl), a
	ret
; 419 }
; 420 
; 421 void CmdXS(...) {
cmdxs:
; 422     PrintSpace();
	call printspace
; 423     PrintHexWordSpace(hl = &regSPH);
	ld hl, 0FFFFh & (regsph)
	call printhexwordspace
; 424     Input();
	call input
; 425     if (flag_nc)
; 426         return Monitor();
	jp nc, monitor
; 427     ParseDword();
	call parsedword
; 428     regSP = hl;
	ld (regsp), hl
	ret
; 429 }
; 430 
; 431 void FindRegister(...) {
findregister:
; 432     for (;;) {
l_23:
; 433         a = *de;
	ld a, (de)
; 434         if (flag_z(a &= a))
	and a
; 435             return MonitorError();
	jp z, monitorerror
; 436         if (a == *hl)
	cp (hl)
; 437             return;
	ret z
; 438         de++;
	inc de
; 439         de++;
	inc de
	jp l_23
; 440     }
; 441 }
; 442 
; 443 void PrintRegs(...) {
printregs:
; 444     de = &regList;
	ld de, reglist
; 445     b = 8;
	ld b, 8
; 446     PrintLf();
	call printlf
; 447     do {
l_25:
; 448         c = a = *de;
	ld a, (de)
	ld c, a
; 449         de++;
	inc de
; 450         push_pop(bc) {
	push bc
; 451             PrintRegMinus(c);
	call printregminus
; 452             a = *de;
	ld a, (de)
; 453             hl = &regs;
	ld hl, 0FFFFh & (regs)
; 454             l = a;
	ld l, a
; 455             PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
	pop bc
; 456         }
; 457         de++;
	inc de
l_26:
; 458     } while (flag_nz(b--));
	dec b
	jp nz, l_25
; 459 
; 460     c = a = *de;
	ld a, (de)
	ld c, a
; 461     PrintRegMinus();
	call printregminus
; 462     param1 = hl = regs;
	ld hl, (regs)
	ld (param1), hl
; 463     PrintParam1Space();
	call printparam1space
; 464     PrintRegMinus(c = 'O');
	ld c, 79
	call printregminus
; 465     PrintHexWordSpace(hl = &lastBreakAddressHigh);
	ld hl, 0FFFFh & (lastbreakaddresshigh)
	call printhexwordspace
; 466     PrintLf();
	jp printlf
; 467 }
; 468 
; 469 void PrintRegMinus(...) {
printregminus:
; 470     PrintSpace();
	call printspace
; 471     PrintCharA(a = c);
	ld a, c
	call printchara
; 472     PrintCharA(a = '-');
	ld a, 45
	jp printchara
; 473 }
; 474 
; 475 uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC, 'D', (uint8_t)(uintptr_t)&regD,  'E', (uint8_t)(uintptr_t)&regE,
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
; 478  aStart[] = "\x0ASTART-";
astart:
	db 10
	db 83
	db 84
	db 65
	db 82
	db 84
	db 45
	ds 1
; 479  aDir_[] = "\x0ADIR. -";
adir_:
	db 10
	db 68
	db 73
	db 82
	db 46
	db 32
	db 45
	ds 1
; 483  CmdB(...) {
cmdb:
; 484     ParseParams();
	call parseparams
; 485     InitRst38();
	call initrst38
; 486     hl = param1;
	ld hl, (param1)
; 487     a = *hl;
	ld a, (hl)
; 488     *hl = OPCODE_RST_38;
	ld (hl), 255
; 489     breakAddress = hl;
	ld (breakaddress), hl
; 490     breakPrevByte = a;
	ld (breakprevbyte), a
	ret
; 491 }
; 492 
; 493 void InitRst38(...) {
initrst38:
; 494     rst38Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst38opcode), a
; 495     rst38Address = hl = &BreakPoint;
	ld hl, 0FFFFh & (breakpoint)
	ld (rst38address), hl
	ret
; 496 }
; 497 
; 498 void BreakPoint(...) {
breakpoint:
; 499     regHL = hl;
	ld (reghl), hl
; 500     push(a);
	push af
; 501     hl = 4;
	ld hl, 4
; 502     hl += sp;
	add hl, sp
; 503     regs = hl;
	ld (regs), hl
; 504     pop(a);
	pop af
; 505     swap(*sp, hl);
	ex (sp), hl
; 506     hl--;
	dec hl
; 507     swap(*sp, hl);
	ex (sp), hl
; 508     sp = &regHL;
	ld sp, 0FFFFh & (reghl)
; 509     push(de, bc, a);
	push de
	push bc
	push af
; 510     sp = &cmdBuffer + 0x84;
	ld sp, 0FFFFh & ((cmdbuffer) + (132))
; 511 
; 512     hl = regSP;
	ld hl, (regsp)
; 513     hl--;
	dec hl
; 514     d = *hl;
	ld d, (hl)
; 515     hl--;
	dec hl
; 516     e = *hl;
	ld e, (hl)
; 517     l = e;
	ld l, e
; 518     h = d;
	ld h, d
; 519     lastBreakAddress = hl;
	ld (lastbreakaddress), hl
; 520 
; 521     hl = breakAddress;
	ld hl, (breakaddress)
; 522     CmpHlDe();
	call cmphlde
; 523     if (flag_nz) {
	jp z, l_28
; 524         hl = breakAddress2;
	ld hl, (breakaddress2)
; 525         CmpHlDe(hl, de);
	call cmphlde
; 526         if (flag_z)
; 527             return BreakPointAt2();
	jp z, breakpointat2
; 528 
; 529         hl = breakAddress3;
	ld hl, (breakaddress3)
; 530         CmpHlDe(hl, de);
	call cmphlde
; 531         if (flag_z)
; 532             return BreakpointAt3();
	jp z, breakpointat3
; 533 
; 534         return MonitorError();
	jp monitorerror
l_28:
; 535     }
; 536     *hl = a = breakPrevByte;
	ld a, (breakprevbyte)
	ld (hl), a
; 537     breakAddress = hl = 0xFFFF;
	ld hl, 65535
	ld (breakaddress), hl
; 538     return Monitor();
	jp monitor
; 539 }
; 540 
; 541 /* G<адрес> - Запуск программы в отладочном режиме */
; 542 
; 543 void CmdG(...) {
cmdg:
; 544     ParseParams();
	call parseparams
; 545     if ((a = cmdBuffer1) == 0x0D)
	ld a, (cmdbuffer1)
	cp 13
; 546         param1 = hl = lastBreakAddress;
	jp nz, l_30
	ld hl, (lastbreakaddress)
	ld (param1), hl
l_30:
; 547     Run();
; 548 }
; 549 
; 550 void Run(...) {
run:
; 551     jumpOpcode = a = OPCODE_JMP;
	ld a, 195
	ld (jumpopcode), a
; 552     sp = &regs;
	ld sp, 0FFFFh & (regs)
; 553     pop(de, bc, a, hl);
	pop hl
	pop af
	pop bc
	pop de
; 554     sp = hl;
	ld sp, hl
; 555     hl = regHL;
	ld hl, (reghl)
; 556     jumpParam1();
	jp jumpparam1
; 557 }
; 558 
; 559 void CmdP(...) {
cmdp:
; 560     ParseParams();
	call parseparams
; 561     InitRst38();
	call initrst38
; 562 
; 563     breakAddress2 = hl = param1;
	ld hl, (param1)
	ld (breakaddress2), hl
; 564     a = *hl;
	ld a, (hl)
; 565     *hl = OPCODE_RST_38;
	ld (hl), 255
; 566     breakPrevByte2 = a;
	ld (breakprevbyte2), a
; 567 
; 568     breakAddress3 = hl = param2;
	ld hl, (param2)
	ld (breakaddress3), hl
; 569     a = *hl;
	ld a, (hl)
; 570     *hl = OPCODE_RST_38;
	ld (hl), 255
; 571     breakPrevByte3 = a;
	ld (breakprevbyte3), a
; 572 
; 573     breakCounter = a = param3;
	ld a, (param3)
	ld (breakcounter), a
; 574 
; 575     PrintString(hl = &aStart);
	ld hl, astart
	call printstring
; 576 
; 577     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 578     ReadStringLoop();
	call readstringloop
; 579     ParseParams();
	call parseparams
; 580     PrintString(hl = &aDir_);
	ld hl, adir_
	call printstring
; 581     ReadString();
	call readstring
; 582     Run();
	jp run
; 583 }
; 584 
; 585 void BreakPointAt2(...) {
breakpointat2:
; 586     *hl = a = breakPrevByte2;
	ld a, (breakprevbyte2)
	ld (hl), a
; 587 
; 588     hl = breakAddress3;
	ld hl, (breakaddress3)
; 589     a = OPCODE_RST_38;
	ld a, 255
; 590     if (a != *hl) {
	cp (hl)
	jp z, l_32
; 591         b = *hl;
	ld b, (hl)
; 592         *hl = a;
	ld (hl), a
; 593         breakPrevByte3 = a = b;
	ld a, b
	ld (breakprevbyte3), a
l_32:
; 594     }
; 595     ContinueBreakpoint();
; 596 }
; 597 
; 598 void ContinueBreakpoint(...) {
continuebreakpoint:
; 599     PrintRegs();
	call printregs
; 600     MonitorExecute();
	call monitorexecute
; 601     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 602     Run();
	jp run
; 603 }
; 604 
; 605 void BreakpointAt3(...) {
breakpointat3:
; 606     *hl = a = breakPrevByte3;
	ld a, (breakprevbyte3)
	ld (hl), a
; 607 
; 608     hl = breakAddress2;
	ld hl, (breakaddress2)
; 609     a = OPCODE_RST_38;
	ld a, 255
; 610     if (a == *hl)
	cp (hl)
; 611         return ContinueBreakpoint();
	jp z, continuebreakpoint
; 612     b = *hl;
	ld b, (hl)
; 613     *hl = a;
	ld (hl), a
; 614     breakPrevByte2 = a = b;
	ld a, b
	ld (breakprevbyte2), a
; 615 
; 616     hl = &breakCounter;
	ld hl, 0FFFFh & (breakcounter)
; 617     (*hl)--;
	dec (hl)
; 618     if (flag_nz)
; 619         return ContinueBreakpoint();
	jp nz, continuebreakpoint
; 620 
; 621     a = breakPrevByte2;
	ld a, (breakprevbyte2)
; 622     hl = breakAddress2;
	ld hl, (breakaddress2)
; 623     *hl = a;
	ld (hl), a
; 624     Monitor();
	jp monitor
; 625 }
; 626 
; 627 /* D<адрес>,<адрес> - Просмотр содержимого области памяти в шестнадцатеричном виде */
; 628 
; 629 void CmdD(...) {
cmdd:
; 630     ParseParams();
	call parseparams
; 631     PrintLf();
	call printlf
; 632 CmdDLine:
cmddline:
; 633     PrintLfParam1();
	call printlfparam1
; 634     for (;;) {
l_35:
; 635         PrintSpace();
	call printspace
; 636         PrintByteFromParam1();
	call printbytefromparam1
; 637         Loop();
	call loop
; 638         a = param1;
	ld a, (param1)
; 639         a &= 0x0F;
	and 15
; 640         if (flag_z)
; 641             goto CmdDLine;
	jp z, cmddline
	jp l_35
; 642     }
; 643 }
; 644 
; 645 /* C<адрес от>,<адрес до>,<адрес от 2> - Сравнение содержимого двух областей памяти */
; 646 
; 647 void CmdC(...) {
cmdc:
; 648     ParseParams();
	call parseparams
; 649     hl = param3;
	ld hl, (param3)
; 650     swap(hl, de);
	ex hl, de
; 651     for (;;) {
l_38:
; 652         hl = param1;
	ld hl, (param1)
; 653         a = *de;
	ld a, (de)
; 654         if (a != *hl) {
	cp (hl)
	jp z, l_40
; 655             PrintLfParam1();
	call printlfparam1
; 656             PrintSpace();
	call printspace
; 657             PrintByteFromParam1();
	call printbytefromparam1
; 658             PrintSpace();
	call printspace
; 659             a = *de;
	ld a, (de)
; 660             PrintHexByte();
	call printhexbyte
l_40:
; 661         }
; 662         de++;
	inc de
; 663         Loop();
	call loop
	jp l_38
; 664     }
; 665 }
; 666 
; 667 /* F<адрес>,<адрес>,<байт> - Запись байта во все ячейки области памяти */
; 668 
; 669 void CmdF(...) {
cmdf:
; 670     ParseParams();
	call parseparams
; 671     b = a = param3;
	ld a, (param3)
	ld b, a
; 672     for (;;) {
l_43:
; 673         hl = param1;
	ld hl, (param1)
; 674         *hl = b;
	ld (hl), b
; 675         Loop();
	call loop
	jp l_43
; 676     }
; 677 }
; 678 
; 679 /* S<адрес>,<адрес>,<байт> - Поиск байта в области памяти */
; 680 
; 681 void CmdS(...) {
cmds:
; 682     ParseParams();
	call parseparams
; 683     c = l;
	ld c, l
; 684     for (;;) {
l_46:
; 685         hl = param1;
	ld hl, (param1)
; 686         a = c;
	ld a, c
; 687         if (a == *hl)
	cp (hl)
; 688             PrintLfParam1();
	call z, printlfparam1
; 689         Loop();
	call loop
	jp l_46
; 690     }
; 691 }
; 692 
; 693 /* T<начало>,<конец>,<куда> - Пересылка содержимого одной области в другую */
; 694 
; 695 void CmdT(...) {
cmdt:
; 696     ParseParams();
	call parseparams
; 697     hl = param3;
	ld hl, (param3)
; 698     swap(hl, de);
	ex hl, de
; 699     for (;;) {
l_49:
; 700         hl = param1;
	ld hl, (param1)
; 701         *de = a = *hl;
	ld a, (hl)
	ld (de), a
; 702         de++;
	inc de
; 703         Loop();
	call loop
	jp l_49
; 704     }
; 705 }
; 706 
; 707 /* M<адрес> - Просмотр или изменение содержимого ячейки (ячеек) памяти */
; 708 
; 709 void CmdM(...) {
cmdm:
; 710     ParseParams();
	call parseparams
; 711     for (;;) {
l_52:
; 712         PrintSpace();
	call printspace
; 713         PrintByteFromParam1();
	call printbytefromparam1
; 714         Input();
	call input
; 715         if (flag_c) {
	jp nc, l_54
; 716             ParseDword();
	call parsedword
; 717             a = l;
	ld a, l
; 718             hl = param1;
	ld hl, (param1)
; 719             *hl = a;
	ld (hl), a
l_54:
; 720         }
; 721         hl = &param1;
	ld hl, 0FFFFh & (param1)
; 722         IncWord();
	call incword
; 723         PrintLfParam1();
	call printlfparam1
	jp l_52
; 724     }
; 725 }
; 726 
; 727 /* J<адрес> - Запуск программы с указанного адреса */
; 728 
; 729 void CmdJ(...) {
cmdj:
; 730     ParseParams();
	call parseparams
; 731     hl = param1;
	ld hl, (param1)
; 732     return hl();
	jp hl
; 733 }
; 734 
; 735 /* А<символ> - Вывод кода символа на экран */
; 736 
; 737 void CmdA(...) {
cmda:
; 738     PrintLf();
	call printlf
; 739     PrintHexByte(a = cmdBuffer1);
	ld a, (cmdbuffer1)
	call printhexbyte
; 740     PrintLf();
	jp printlf
; 741 }
; 742 
; 743 /* K - Вывод символа с клавиатуры на экран */
; 744 
; 745 void CmdK(...) {
cmdk:
; 746     for (;;) {
l_57:
; 747         ReadKey();
	call readkey
; 748         if (a == 1) /* УС + А */
	cp 1
; 749             return Monitor();
	jp z, monitor
; 750         PrintCharA(a);
	call printchara
	jp l_57
; 751     }
; 752 }
; 753 
; 754 /* Q<начало>,<конец> - Тестирование области памяти */
; 755 
; 756 void CmdQ(...) {
cmdq:
; 757     ParseParams();
	call parseparams
; 758     for (;;) {
l_60:
; 759         hl = param1;
	ld hl, (param1)
; 760         c = *hl;
	ld c, (hl)
; 761 
; 762         a = 0x55;
	ld a, 85
; 763         *hl = a;
	ld (hl), a
; 764         if (a != *hl)
	cp (hl)
; 765             CmdQResult();
	call nz, cmdqresult
; 766 
; 767         a = 0xAA;
	ld a, 170
; 768         *hl = a;
	ld (hl), a
; 769         if (a != *hl)
	cp (hl)
; 770             CmdQResult();
	call nz, cmdqresult
; 771 
; 772         *hl = c;
	ld (hl), c
; 773         Loop();
	call loop
	jp l_60
; 774     }
; 775 }
; 776 
; 777 void CmdQResult(...) {
cmdqresult:
; 778     push_pop(a) {
	push af
; 779         PrintLfParam1();
	call printlfparam1
; 780         PrintSpace();
	call printspace
; 781         PrintByteFromParam1();
	call printbytefromparam1
; 782         PrintSpace();
	call printspace
	pop af
; 783     }
; 784     PrintHexByte(a);
	call printhexbyte
; 785     return;
	ret
; 786 }
; 787 
; 788 /* L<начало>,<конец> - Посмотр области памяти в символьном виде */
; 789 
; 790 void CmdL(...) {
cmdl:
; 791     ParseParams();
	call parseparams
; 792     PrintLf();
	call printlf
; 793 
; 794 CmdLLine:
cmdlline:
; 795     PrintLfParam1();
	call printlfparam1
; 796 
; 797     for (;;) {
l_63:
; 798         PrintSpace();
	call printspace
; 799         hl = param1;
	ld hl, (param1)
; 800         a = *hl;
	ld a, (hl)
; 801         if (a >= 0x20) {
	cp 32
	jp c, l_65
; 802             if (a < 0x80) {
	cp 128
	jp nc, l_67
; 803                 goto CmdLShow;
	jp cmdlshow
l_67:
l_65:
; 804             }
; 805         }
; 806         a = '.';
	ld a, 46
; 807 CmdLShow:
cmdlshow:
; 808         PrintCharA();
	call printchara
; 809         Loop();
	call loop
; 810         if (flag_z((a = param1) &= 0x0F))
	ld a, (param1)
	and 15
; 811             goto CmdLLine;
	jp z, cmdlline
	jp l_63
; 812     }
; 813 }
; 814 
; 815 /* H<число 1>,<число 2> - Сложение и вычитание чисел */
; 816 
; 817 void CmdH(...) {
cmdh:
; 818     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 819     b = 6;
	ld b, 6
; 820     a ^= a;
	xor a
; 821     do {
l_69:
; 822         *hl = a;
	ld (hl), a
l_70:
; 823     } while (flag_nz(b--));
	dec b
	jp nz, l_69
; 824 
; 825     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 826 
; 827     ParseDword();
	call parsedword
; 828     param1 = hl;
	ld (param1), hl
; 829 
; 830     ParseDword();
	call parsedword
; 831     param2 = hl;
	ld (param2), hl
; 832 
; 833     PrintLf();
	call printlf
; 834     param3 = hl = param1;
	ld hl, (param1)
	ld (param3), hl
; 835     swap(hl, de);
	ex hl, de
; 836     hl = param2;
	ld hl, (param2)
; 837     hl += de;
	add hl, de
; 838     param1 = hl;
	ld (param1), hl
; 839     PrintParam1Space();
	call printparam1space
; 840 
; 841     hl = param2;
	ld hl, (param2)
; 842     swap(hl, de);
	ex hl, de
; 843     hl = param3;
	ld hl, (param3)
; 844     a = e;
	ld a, e
; 845     invert(a);
	cpl
; 846     e = a;
	ld e, a
; 847     a = d;
	ld a, d
; 848     invert(a);
	cpl
; 849     d = a;
	ld d, a
; 850     de++;
	inc de
; 851     hl += de;
	add hl, de
; 852     param1 = hl;
	ld (param1), hl
; 853     PrintParam1Space();
	call printparam1space
; 854     PrintLf();
	jp printlf
; 855 }
; 856 
; 857 /* I - Ввод информации с магнитной ленты */
; 858 
; 859 void CmdI(...) {
cmdi:
; 860     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 861     param1h = a;
	ld (param1h), a
; 862     tapeStartH = a;
	ld (tapestarth), a
; 863 
; 864     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 865     param1 = a;
	ld (param1), a
; 866     tapeStartL = a;
	ld (tapestartl), a
; 867 
; 868     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 869     param2h = a;
	ld (param2h), a
; 870     tapeStopH = a;
	ld (tapestoph), a
; 871 
; 872     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 873     param2 = a;
	ld (param2), a
; 874     tapeStopL = a;
	ld (tapestopl), a
; 875 
; 876     a = READ_TAPE_NEXT_BYTE;
	ld a, 8
; 877     hl = &CmdIEnd;
	ld hl, 0FFFFh & (cmdiend)
; 878     push(hl);
	push hl
; 879 
; 880     for (;;) {
l_73:
; 881         hl = param1;
	ld hl, (param1)
; 882         ReadTapeByte(a);
	call readtapebyte
; 883         *hl = a;
	ld (hl), a
; 884         Loop();
	call loop
; 885         a = READ_TAPE_NEXT_BYTE;
	ld a, 8
	jp l_73
; 886     }
; 887 }
; 888 
; 889 void CmdIEnd(...) {
cmdiend:
; 890     PrintHexWordSpace(hl = &tapeStartH);
	ld hl, 0FFFFh & (tapestarth)
	call printhexwordspace
; 891     PrintHexWordSpace(hl = &tapeStopH);
	ld hl, 0FFFFh & (tapestoph)
	call printhexwordspace
; 892     PrintLf();
	jp printlf
; 893 }
; 894 
; 895 /* O<начало>,<конец> - Вывод содержимого области памяти на магнитную ленту */
; 896 
; 897 void CmdO(...) {
cmdo:
; 898     ParseParams();
	call parseparams
; 899     a ^= a;
	xor a
; 900     b = 0;
	ld b, 0
; 901     do {
l_75:
; 902         WriteTapeByte(a);
	call writetapebyte
l_76:
; 903     } while (flag_nz(b--));
	dec b
	jp nz, l_75
; 904     WriteTapeByte(a = TAPE_START);
	ld a, 230
	call writetapebyte
; 905     WriteTapeByte(a = param1h);
	ld a, (param1h)
	call writetapebyte
; 906     WriteTapeByte(a = param1);
	ld a, (param1)
	call writetapebyte
; 907     WriteTapeByte(a = param2h);
	ld a, (param2h)
	call writetapebyte
; 908     WriteTapeByte(a = param2);
	ld a, (param2)
	call writetapebyte
; 909     for (;;) {
l_79:
; 910         hl = param1;
	ld hl, (param1)
; 911         a = *hl;
	ld a, (hl)
; 912         WriteTapeByte(a);
	call writetapebyte
; 913         Loop();
	call loop
	jp l_79
; 914     }
; 915 }
; 916 
; 917 /* V - Сравнение информации на магнитной ленте с содержимым области памяти */
; 918 
; 919 void CmdV(...) {
cmdv:
; 920     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 921     param1h = a;
	ld (param1h), a
; 922     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 923     param1 = a;
	ld (param1), a
; 924     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 925     param2h = a;
	ld (param2h), a
; 926     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 927     param2 = a;
	ld (param2), a
; 928     for (;;) {
l_82:
; 929         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 930         hl = param1;
	ld hl, (param1)
; 931         if (a != *hl) {
	cp (hl)
	jp z, l_84
; 932             push_pop(a) {
	push af
; 933                 PrintLfParam1();
	call printlfparam1
; 934                 PrintSpace();
	call printspace
; 935                 PrintByteFromParam1();
	call printbytefromparam1
; 936                 PrintSpace();
	call printspace
	pop af
; 937             }
; 938             PrintHexByte();
	call printhexbyte
l_84:
; 939         }
; 940         Loop();
	call loop
	jp l_82
; 941     }
; 942 }
; 943 
; 944 void ReadTapeByte(...) {
readtapebyte:
; 945     push(bc, de);
	push bc
	push de
; 946     c = 0;
	ld c, 0
; 947     d = a;
	ld d, a
; 948     e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 949     do {
l_86:
; 950     loc_FD9D:
loc_fd9d:
; 951         a = c;
	ld a, c
; 952         a &= 0x7F;
	and 127
; 953         cyclic_rotate_left(a, 1);
	rlca
; 954         c = a;
	ld c, a
; 955 
; 956         do {
l_89:
; 957             a = in(PORT_TAPE);
	in a, (1)
l_90:
; 958         } while (a == e);
	cp e
	jp z, l_89
; 959         a &= 1;
	and 1
; 960         a |= c;
	or c
; 961         c = a;
	ld c, a
; 962         ReadTapeDelay();
	call readtapedelay
; 963         e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 964         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_92
; 965             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_94
; 966                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_95
l_94:
; 967             } else {
; 968                 if (a != (0xFF ^ TAPE_START))
	cp 25
; 969                     goto loc_FD9D;
	jp nz, loc_fd9d
; 970                 tapePolarity = a = 0xFF;
	ld a, 255
	ld (tapepolarity), a
l_95:
; 971             }
; 972             d = 8 + 1;
	ld d, 9
l_92:
l_87:
; 973         }
; 974     } while (flag_nz(d--));
	dec d
	jp nz, l_86
; 975     a = tapePolarity;
	ld a, (tapepolarity)
; 976     a ^= c;
	xor c
; 977     pop(bc, de);
	pop de
	pop bc
	ret
; 978 }
; 979 
; 980 void ReadTapeDelay(...) {
readtapedelay:
; 981     push(a);
	push af
; 982     TapeDelay(a = readDelay);
	ld a, (readdelay)
; 983 }
; 984 
; 985 void TapeDelay(...) {
tapedelay:
; 986     b = a;
	ld b, a
; 987     pop(a);
	pop af
; 988     do {
l_96:
l_97:
; 989     } while (flag_nz(b--));
	dec b
	jp nz, l_96
	ret
; 990 }
; 991 
; 992 void WriteTapeByte(...) {
writetapebyte:
; 993     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 994         d = a;
	ld d, a
; 995         c = 8;
	ld c, 8
; 996         do {
l_99:
; 997             a = d;
	ld a, d
; 998             cyclic_rotate_left(a, 1);
	rlca
; 999             d = a;
	ld d, a
; 1000 
; 1001             out(PORT_TAPE, (a = 1) ^= d);
	ld a, 1
	xor d
	out (1), a
; 1002             WriteTapeDelay();
	call writetapedelay
; 1003 
; 1004             out(PORT_TAPE, (a = 0) ^= d);
	ld a, 0
	xor d
	out (1), a
; 1005             WriteTapeDelay();
	call writetapedelay
l_100:
; 1006         } while (flag_nz(c--));
	dec c
	jp nz, l_99
	pop af
	pop de
	pop bc
	ret
; 1007     }
; 1008 }
; 1009 
; 1010 void WriteTapeDelay(...) {
writetapedelay:
; 1011     push(a);
	push af
; 1012     TapeDelay(a = writeDelay);
	ld a, (writedelay)
	jp tapedelay
; 1013 }
; 1014 
; 1015 uint8_t monitorCommands = 'M';
monitorcommands:
	db 77
; 1016  monitorCommandsMa = (uintptr_t)&CmdM;
monitorcommandsma:
	dw 0FFFFh & (cmdm)
; 1017  monitorCommandsC = 'C';
monitorcommandsc:
	db 67
; 1018  monitorCommandsCa = (uintptr_t)&CmdC;
monitorcommandsca:
	dw 0FFFFh & (cmdc)
; 1019  monitorCommandsD = 'D';
monitorcommandsd:
	db 68
; 1020  monitorCommandsDa = (uintptr_t)&CmdD;
monitorcommandsda:
	dw 0FFFFh & (cmdd)
; 1021  monitorCommandsB = 'B';
monitorcommandsb:
	db 66
; 1022  monitorCommandsBa = (uintptr_t)&CmdB;
monitorcommandsba:
	dw 0FFFFh & (cmdb)
; 1023  monitorCommandsG = 'G';
monitorcommandsg:
	db 71
; 1024  monitorCommandsGa = (uintptr_t)&CmdG;
monitorcommandsga:
	dw 0FFFFh & (cmdg)
; 1025  monitorCommandsP = 'P';
monitorcommandsp:
	db 80
; 1026  monitorCommandsPa = (uintptr_t)&CmdP;
monitorcommandspa:
	dw 0FFFFh & (cmdp)
; 1027  monitorCommandsX = 'X';
monitorcommandsx:
	db 88
; 1028  monitorCommandsXa = (uintptr_t)&CmdX;
monitorcommandsxa:
	dw 0FFFFh & (cmdx)
; 1029  monitorCommandsF = 'F';
monitorcommandsf:
	db 70
; 1030  monitorCommandsFa = (uintptr_t)&CmdF;
monitorcommandsfa:
	dw 0FFFFh & (cmdf)
; 1031  monitorCommandsS = 'S';
monitorcommandss:
	db 83
; 1032  monitorCommandsSa = (uintptr_t)&CmdS;
monitorcommandssa:
	dw 0FFFFh & (cmds)
; 1033  monitorCommandsT = 'T';
monitorcommandst:
	db 84
; 1034  monitorCommandsTa = (uintptr_t)&CmdT;
monitorcommandsta:
	dw 0FFFFh & (cmdt)
; 1035  monitorCommandsI = 'I';
monitorcommandsi:
	db 73
; 1036  monitorCommandsIa = (uintptr_t)&CmdI;
monitorcommandsia:
	dw 0FFFFh & (cmdi)
; 1037  monitorCommandsO = 'O';
monitorcommandso:
	db 79
; 1038  monitorCommandsOa = (uintptr_t)&CmdO;
monitorcommandsoa:
	dw 0FFFFh & (cmdo)
; 1039  monitorCommandsV = 'V';
monitorcommandsv:
	db 86
; 1040  monitorCommandsVa = (uintptr_t)&CmdV;
monitorcommandsva:
	dw 0FFFFh & (cmdv)
; 1041  monitorCommandsJ = 'J';
monitorcommandsj:
	db 74
; 1042  monitorCommandsJa = (uintptr_t)&CmdJ;
monitorcommandsja:
	dw 0FFFFh & (cmdj)
; 1043  monitorCommandsA = 'A';
monitorcommandsa:
	db 65
; 1044  monitorCommandsAa = (uintptr_t)&CmdA;
monitorcommandsaa:
	dw 0FFFFh & (cmda)
; 1045  monitorCommandsK = 'K';
monitorcommandsk:
	db 75
; 1046  monitorCommandsKa = (uintptr_t)&CmdK;
monitorcommandska:
	dw 0FFFFh & (cmdk)
; 1047  monitorCommandsQ = 'Q';
monitorcommandsq:
	db 81
; 1048  monitorCommandsQa = (uintptr_t)&CmdQ;
monitorcommandsqa:
	dw 0FFFFh & (cmdq)
; 1049  monitorCommandsL = 'L';
monitorcommandsl:
	db 76
; 1050  monitorCommandsLa = (uintptr_t)&CmdL;
monitorcommandsla:
	dw 0FFFFh & (cmdl)
; 1051  monitorCommandsH = 'H';
monitorcommandsh:
	db 72
; 1052  monitorCommandsHa = (uintptr_t)&CmdH;
monitorcommandsha:
	dw 0FFFFh & (cmdh)
; 1053  monitorCommandsEnd = 0;
monitorcommandsend:
	db 0
; 1055  aPrompt[] = "\x0A*MikrO/80* MONITOR\x0A>";
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
; 1056  aLf[] = "\x0A";
alf:
	db 10
	ds 1
; 1058  PrintCharA(...) {
printchara:
; 1059     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1060     PrintCharInt(c = a);
	ld c, a
	jp printcharint
; 1061 }
; 1062 
; 1063 void PrintChar(...) {
printchar:
; 1064     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1065     return PrintCharInt(c);
; 1066 }
; 1067 
; 1068 void PrintCharInt(...) {
printcharint:
; 1069     hl = cursor;
	ld hl, (cursor)
; 1070     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1071     hl += de;
	add hl, de
; 1072     *hl = SCREEN_ATTRIB_DEFAULT;
	ld (hl), 0
; 1073 
; 1074     hl = cursor;
	ld hl, (cursor)
; 1075     a = c;
	ld a, c
; 1076     if (a == 0x1F)
	cp 31
; 1077         return ClearScreen();
	jp z, clearscreen
; 1078     if (a == 0x08)
	cp 8
; 1079         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1080     if (a == 0x18)
	cp 24
; 1081         return MoveCursorRight(hl);
	jp z, movecursorright
; 1082     if (a == 0x19)
	cp 25
; 1083         return MoveCursorUp(hl);
	jp z, movecursorup
; 1084     if (a == 0x1A)
	cp 26
; 1085         return MoveCursorDown(hl);
	jp z, movecursordown
; 1086     if (a == 0x0A)
	cp 10
; 1087         return MoveCursorNextLine(hl);
	jp z, movecursornextline
; 1088     if (a == 0x0C)
	cp 12
; 1089         return MoveCursorHome();
	jp z, movecursorhome
; 1090 
; 1091     if ((a = h) == SCREEN_END >> 8) {
	ld a, h
	cp 65520
	jp nz, l_102
; 1092         IsKeyPressed();
	call iskeypressed
; 1093         if (a != 0) {
	or a
	jp z, l_104
; 1094             ReadKey();
	call readkey
l_104:
; 1095         }
; 1096         ClearScreenInt();
	call clearscreenint
; 1097         hl = SCREEN_BEGIN;
	ld hl, 59392
l_102:
; 1098     }
; 1099     *hl = c;
	ld (hl), c
; 1100     hl++;
	inc hl
; 1101     return MoveCursor();
; 1102 }
; 1103 
; 1104 void MoveCursor(...) {
movecursor:
; 1105     cursor = hl;
	ld (cursor), hl
; 1106     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1107     hl += de;
	add hl, de
; 1108     *hl = SCREEN_ATTRIB_DEFAULT | SCREEN_ATTRIB_UNDERLINE;
	ld (hl), 128
; 1109     pop(hl, bc, de, a);
	pop af
	pop de
	pop bc
	pop hl
	ret
; 1110 }
; 1111 
; 1112 void ClearScreen(...) {
clearscreen:
; 1113     ClearScreenInt();
	call clearscreenint
; 1114     MoveCursorHome();
; 1115 }
; 1116 
; 1117 void MoveCursorHome(...) {
movecursorhome:
; 1118     MoveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp movecursor
; 1119 }
; 1120 
; 1121 void ClearScreenInt(...) {
clearscreenint:
; 1122     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1123     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1124     for (;;) {
l_107:
; 1125         *hl = ' ';
	ld (hl), 32
; 1126         hl++;
	inc hl
; 1127         a = 0;
	ld a, 0
; 1128         *de = a;
	ld (de), a
; 1129         de++;
	inc de
; 1130         a = h;
	ld a, h
; 1131         if (a == SCREEN_END >> 8)
	cp 65520
; 1132             return;
	ret z
	jp l_107
; 1133     }
; 1134 }
; 1135 
; 1136 void MoveCursorRight(...) {
movecursorright:
; 1137     hl++;
	inc hl
; 1138     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1139         return MoveCursor(hl);
	jp nz, movecursor
; 1140     if (flag_z) /* Not needed */
; 1141         return MoveCursorHome();
	jp z, movecursorhome
; 1142     MoveCursorLeft(hl); /* Not needed */
; 1143 }
; 1144 
; 1145 void MoveCursorLeft(...) {
movecursorleft:
; 1146     hl--;
	dec hl
; 1147     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1148         return MoveCursor(hl);
	jp nz, movecursor
; 1149     MoveCursor(hl = SCREEN_END - 1);
	ld hl, 61439
	jp movecursor
; 1150 }
; 1151 
; 1152 void MoveCursorDown(...) {
movecursordown:
; 1153     hl += (de = SCREEN_WIDTH);
	ld de, 64
	add hl, de
; 1154     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1155         return MoveCursor(hl);
	jp nz, movecursor
; 1156     h = SCREEN_BEGIN >> 8;
	ld h, 232
; 1157     MoveCursor(hl);
	jp movecursor
; 1158 }
; 1159 
; 1160 void MoveCursorUp(...) {
movecursorup:
; 1161     hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
; 1162     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1163         return MoveCursor(hl);
	jp nz, movecursor
; 1164     hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 2048
	add hl, de
; 1165     MoveCursor(hl);
	jp movecursor
; 1166 }
; 1167 
; 1168 void MoveCursorNextLine(...) {
movecursornextline:
; 1169     for (;;) {
l_110:
; 1170         hl++;
	inc hl
; 1171         a = l;
	ld a, l
; 1172         if (a == SCREEN_WIDTH * 0)
	or a
; 1173             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1174         if (a == SCREEN_WIDTH * 1)
	cp 64
; 1175             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1176         if (a == SCREEN_WIDTH * 2)
	cp 128
; 1177             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1178         if (a == SCREEN_WIDTH * 3)
	cp 192
; 1179             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
	jp l_110
; 1180     }
; 1181 }
; 1182 
; 1183 void MoveCursorNextLine1(...) {
movecursornextline1:
; 1184     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1185         return MoveCursor(hl);
	jp nz, movecursor
; 1186 
; 1187     IsKeyPressed();
	call iskeypressed
; 1188     if (a == 0)
	or a
; 1189         return ClearScreen();
	jp z, clearscreen
; 1190     ReadKey();
	call readkey
; 1191     ClearScreen();
	jp clearscreen
; 1192 }
; 1193 
; 1194 void ReadKey(...) {
readkey:
; 1195     push(bc, de, hl);
	push bc
	push de
	push hl
; 1196 
; 1197     for (;;) {
l_113:
; 1198         b = 0;
	ld b, 0
; 1199         c = 1 ^ 0xFF;
	ld c, 254
; 1200         d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1201         do {
l_115:
; 1202             out(PORT_KEYBOARD_COLUMN, a = c);
	ld a, c
	out (7), a
; 1203             cyclic_rotate_left(a, 1);
	rlca
; 1204             c = a;
	ld c, a
; 1205             a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1206             a &= KEYBOARD_ROW_MASK;
	and 127
; 1207             if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1208                 return ReadKey1(a, b);
	jp nz, readkey1
; 1209             b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_116:
; 1210         } while (flag_nz(d--));
	dec d
	jp nz, l_115
	jp l_113
; 1211     }
; 1212 }
; 1213 
; 1214 void ReadKey1(...) {
readkey1:
; 1215     keyLast = a;
	ld (keylast), a
; 1216 
; 1217     for (;;) {
l_119:
; 1218         carry_rotate_right(a, 1);
	rra
; 1219         if (flag_nc)
; 1220             break;
	jp nc, l_120
; 1221         b++;
	inc b
	jp l_119
l_120:
; 1222     }
; 1223 
; 1224     /* b - key number */
; 1225 
; 1226     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1227      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1228      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1229      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1230      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1231      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1232      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1233 
; 1234     a = b;
	ld a, b
; 1235     if (a < 48) {
	cp 48
	jp nc, l_121
; 1236         a += '0';
	add 48
; 1237         if (a >= 0x3C)
	cp 60
; 1238             if (a < 0x40)
	jp c, l_123
	cp 64
; 1239                 a &= 0x2F; /* <=>? to .-./ */
	jp nc, l_125
	and 47
l_125:
l_123:
; 1240         c = a;
	ld c, a
	jp l_122
l_121:
; 1241     } else {
; 1242         hl = &keyTable;
	ld hl, keytable
; 1243         a -= 48;
	sub 48
; 1244         c = a;
	ld c, a
; 1245         b = 0;
	ld b, 0
; 1246         hl += bc;
	add hl, bc
; 1247         a = *hl;
	ld a, (hl)
; 1248         return ReadKey2(a);
	jp readkey2
l_122:
; 1249     }
; 1250 
; 1251     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1252     a &= KEYBOARD_MODS_MASK;
	and 7
; 1253     if (a == KEYBOARD_MODS_MASK)
	cp 7
; 1254         goto ReadKeyNoMods;
	jp z, readkeynomods
; 1255     carry_rotate_right(a, 2);
	rra
	rra
; 1256     if (flag_nc)
; 1257         goto ReadKeyControl;
	jp nc, readkeycontrol
; 1258     carry_rotate_right(a, 1);
	rra
; 1259     if (flag_nc)
; 1260         goto ReadKeyShift;
	jp nc, readkeyshift
; 1261 
; 1262     /* RUS key pressed */
; 1263     a = c;
	ld a, c
; 1264     a |= 0x20;
	or 32
; 1265     return ReadKey2(a);
	jp readkey2
; 1266 
; 1267     /* US (Control) key pressed */
; 1268 ReadKeyControl:
readkeycontrol:
; 1269     a = c;
	ld a, c
; 1270     a &= 0x1F;
	and 31
; 1271     return ReadKey2(a);
	jp readkey2
; 1272 
; 1273     /* SS (Shift) key pressed */
; 1274 ReadKeyShift:
readkeyshift:
; 1275     a = c;
	ld a, c
; 1276     if (a >= 0x40) /* @ A-Z [ \ ] ^ _ */
	cp 64
; 1277         return ReadKey2(a);
	jp nc, readkey2
; 1278     if (a < 0x30) { /* .-./ to <=>? */
	cp 48
	jp nc, l_127
; 1279         a |= 0x10;
	or 16
; 1280         return ReadKey2(a);
	jp readkey2
l_127:
; 1281     }
; 1282     a &= 0x2F; /* 0123456789:; to !@#$%&'()*+ */
	and 47
; 1283     return ReadKey2(a);
	jp readkey2
; 1284 
; 1285 ReadKeyNoMods:
readkeynomods:
; 1286     ReadKey2(a = c);
	ld a, c
; 1287 }
; 1288 
; 1289 void ReadKey2(...) {
readkey2:
; 1290     c = a;
	ld c, a
; 1291 
; 1292     ReadKeyDelay();
	call readkeydelay
; 1293 
; 1294     hl = &keyLast;
	ld hl, 0FFFFh & (keylast)
; 1295     do {
l_129:
; 1296         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
l_130:
; 1297     } while (a == *hl);
	cp (hl)
	jp z, l_129
; 1298 
; 1299     ReadKeyDelay();
	call readkeydelay
; 1300 
; 1301     a = c;
	ld a, c
; 1302     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1303 }
; 1304 
; 1305 void ReadKeyDelay(...) {
readkeydelay:
; 1306     de = 0x1000;
	ld de, 4096
; 1307     for (;;) {
l_133:
; 1308         de--;
	dec de
; 1309         if (flag_z((a = d) |= e))
	ld a, d
	or e
; 1310             return;
	ret z
	jp l_133
; 1311     }
; 1312 }
; 1313 
; 1314 uint8_t keyTable[] = {
keytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1325  IsKeyPressed(...) {
iskeypressed:
; 1326     out(PORT_KEYBOARD_COLUMN, a = 0);
	ld a, 0
	out (7), a
; 1327     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1328     a &= KEYBOARD_ROW_MASK;
	and 127
; 1329     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_135
; 1330         a ^= a; /* Returns 0 if no key is pressed */
	xor a
; 1331         return;
	ret
l_135:
; 1332     }
; 1333     a = 0xFF; /* Returns 0xFF if there are any keys pressed */
	ld a, 255
	ret
 savebin "micro80.bin", 0xF800, 0x10000
