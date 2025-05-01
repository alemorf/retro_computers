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
; 41 void jumpParam1(void) __address(0xF750);
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
; 80  EntryReboot() {
entryreboot:
; 81     Reboot();
	jp reboot
; 82 }
; 83 
; 84 void EntryReadChar(...) {
entryreadchar:
; 85     ReadKey();
	jp readkey
; 86 }
; 87 
; 88 void EntryReadTapeByte(...) {
entryreadtapebyte:
; 89     ReadTapeByte();
	jp readtapebyte
; 90 }
; 91 
; 92 void EntryPrintChar(...) {
entryprintchar:
; 93     PrintChar();
	jp printchar
; 94 }
; 95 
; 96 void EntryWriteTapeByte(...) {
entrywritetapebyte:
; 97     WriteTapeByte();
	jp writetapebyte
; 98 }
; 99 
; 100 void EntryPrintChar2(...) {
entryprintchar2:
; 101     PrintChar();
	jp printchar
; 102 }
; 103 
; 104 void EntryIsKeyPressed() {
entryiskeypressed:
; 105     IsKeyPressed();
	jp iskeypressed
; 106 }
; 107 
; 108 void EntryPrintHexByte(...) {
entryprinthexbyte:
; 109     PrintHexByte();
	jp printhexbyte
; 110 }
; 111 
; 112 void EntryPrintString(...) {
entryprintstring:
; 113     PrintString();
	jp printstring
; 114 }
; 115 
; 116 void Reboot() {
reboot:
; 117     regSP = hl = USER_STACK_TOP;
	ld hl, 63424
	ld (regsp), hl
; 118     sp = STACK_TOP;
	ld sp, 63487
; 119     PrintCharA(a = 0x1F); /* Clear screen */
	ld a, 31
	call printchara
; 120     Monitor();
; 121 }
; 122 
; 123 void Monitor() {
monitor:
; 124     out(PORT_KEYBOARD_MODE, a = 0x8B);
	ld a, 139
	out (4), a
; 125     sp = STACK_TOP;
	ld sp, 63487
; 126     PrintString(hl = &aPrompt);
	ld hl, aprompt
	call printstring
; 127     ReadString();
	call readstring
; 128     push(hl = &Monitor);
	ld hl, 0FFFFh & (monitor)
	push hl
; 129     MonitorExecute();
; 130 }
; 131 
; 132 void MonitorExecute() {
monitorexecute:
; 133     hl = &cmdBuffer;
	ld hl, 0FFFFh & (cmdbuffer)
; 134     b = *hl;
	ld b, (hl)
; 135     hl = &monitorCommands;
	ld hl, 0FFFFh & (monitorcommands)
; 136 
; 137     for (;;) {
l_1:
; 138         a = *hl;
	ld a, (hl)
; 139         if (flag_z(a &= a))
	and a
; 140             return MonitorError();
	jp z, monitorerror
; 141         if (a == b)
	cp b
; 142             break;
	jp z, l_2
; 143         hl++;
	inc hl
; 144         hl++;
	inc hl
; 145         hl++;
	inc hl
	jp l_1
l_2:
; 146     }
; 147 
; 148     hl++;
	inc hl
; 149     sp = hl;
	ld sp, hl
; 150     pop(hl);
	pop hl
; 151     sp = STACK_TOP - 2;
	ld sp, 63485
; 152     return hl();
	jp hl
; 153 }
; 154 
; 155 void ReadString() {
readstring:
; 156     return ReadStringLoop(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 157 }
; 158 
; 159 void ReadStringLoop(...) {
readstringloop:
; 160     do {
l_3:
; 161         ReadKey();
	call readkey
; 162         if (a == 8)
	cp 8
; 163             return ReadStringBs();
	jp z, readstringbs
; 164         if (flag_nz)
; 165             PrintCharA();
	call nz, printchara
; 166         *hl = a;
	ld (hl), a
; 167         if (a == 0x0D)
	cp 13
; 168             return ReadStringCr(hl);
	jp z, readstringcr
; 169         a = &cmdBufferEnd - 1;
	ld a, 0FFh & ((cmdbufferend) - (1))
; 170         compare(a, l);
	cp l
; 171         hl++;
	inc hl
l_4:
	jp nz, l_3
; 172     } while (flag_nz);
; 173     MonitorError();
; 174 }
; 175 
; 176 void MonitorError() {
monitorerror:
; 177     PrintCharA(a = '?');
	ld a, 63
	call printchara
; 178     Monitor();
	jp monitor
; 179 }
; 180 
; 181 void ReadStringCr(...) {
readstringcr:
; 182     *hl = 0x0D;
	ld (hl), 13
	ret
; 183 }
; 184 
; 185 void ReadStringBs(...) {
readstringbs:
; 186     CommonBs();
	call commonbs
; 187     ReadStringLoop();
	jp readstringloop
; 188 }
; 189 
; 190 void CommonBs(...) {
commonbs:
; 191     if ((a = &cmdBuffer) == l)
	ld a, 0FFh & (cmdbuffer)
	cp l
; 192         return;
	ret z
; 193     PrintCharA(a = 8);
	ld a, 8
	call printchara
; 194     hl--;
	dec hl
	ret
; 195 }
; 196 
; 197 void Input(...) {
input:
; 198     PrintSpace();
	call printspace
; 199     InputInit(hl = &cmdBuffer);
	ld hl, 0FFFFh & (cmdbuffer)
; 200 }
; 201 
; 202 void InputInit(...) {
inputinit:
; 203     InputLoop(b = 0);
	ld b, 0
; 204 }
; 205 
; 206 void InputLoop(...) {
inputloop:
; 207     for (;;) {
l_7:
; 208         ReadKey();
	call readkey
; 209         if (a == 8)
	cp 8
; 210             return InputBs();
	jp z, inputbs
; 211         if (flag_nz)
; 212             PrintCharA();
	call nz, printchara
; 213         *hl = a;
	ld (hl), a
; 214         if (a == ' ')
	cp 32
; 215             return InputEndSpace();
	jp z, inputendspace
; 216         if (a == 0x0D)
	cp 13
; 217             return PopWordReturn();
	jp z, popwordreturn
; 218         b = 0xFF;
	ld b, 255
; 219         if ((a = &cmdBufferEnd - 1) == l)
	ld a, 0FFh & ((cmdbufferend) - (1))
	cp l
; 220             return MonitorError();
	jp z, monitorerror
; 221         hl++;
	inc hl
	jp l_7
; 222     }
; 223 }
; 224 
; 225 void InputEndSpace(...) {
inputendspace:
; 226     *hl = 0x0D;
	ld (hl), 13
; 227     a = b;
	ld a, b
; 228     carry_rotate_left(a, 1);
	rla
; 229     de = &cmdBuffer;
	ld de, 0FFFFh & (cmdbuffer)
; 230     b = 0;
	ld b, 0
	ret
; 231 }
; 232 
; 233 void InputBs(...) {
inputbs:
; 234     CommonBs();
	call commonbs
; 235     if (flag_z)
; 236         return InputInit();
	jp z, inputinit
; 237     InputLoop();
	jp inputloop
; 238 }
; 239 
; 240 void PopWordReturn(...) {
popwordreturn:
; 241     sp++;
	inc sp
; 242     sp++;
	inc sp
	ret
; 243 }
; 244 
; 245 void PrintLf(...) {
printlf:
; 246     PrintString(hl = &aLf);
	ld hl, alf
; 247 }
; 248 
; 249 void PrintString(...) {
printstring:
; 250     for (;;) {
l_10:
; 251         a = *hl;
	ld a, (hl)
; 252         if (flag_z(a &= a))
	and a
; 253             return;
	ret z
; 254         PrintCharA(a);
	call printchara
; 255         hl++;
	inc hl
	jp l_10
; 256     }
; 257 }
; 258 
; 259 void ParseParams() {
parseparams:
; 260     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 261     b = 6;
	ld b, 6
; 262     a ^= a;
	xor a
; 263     do {
l_12:
; 264         *hl = a;
	ld (hl), a
l_13:
; 265     } while (flag_nz(b--));
	dec b
	jp nz, l_12
; 266 
; 267     de = &cmdBuffer + 1;
	ld de, 0FFFFh & ((cmdbuffer) + (1))
; 268     ParseDword();
	call parsedword
; 269     param1 = hl;
	ld (param1), hl
; 270     param2 = hl;
	ld (param2), hl
; 271     if (flag_c)
; 272         return;
	ret c
; 273     ParseDword();
	call parsedword
; 274     param2 = hl;
	ld (param2), hl
; 275     push_pop(a, de) {
	push af
	push de
; 276         swap(hl, de);
	ex hl, de
; 277         hl = param1;
	ld hl, (param1)
; 278         swap(hl, de);
	ex hl, de
; 279         CmpHlDe();
	call cmphlde
; 280         if (flag_c)
; 281             return MonitorError();
	jp c, monitorerror
	pop de
	pop af
; 282     }
; 283     if (flag_c)
; 284         return;
	ret c
; 285     ParseDword();
	call parsedword
; 286     param3 = hl;
	ld (param3), hl
; 287     if (flag_c)
; 288         return;
	ret c
; 289     MonitorError();
	jp monitorerror
; 290 }
; 291 
; 292 void ParseDword(...) {
parsedword:
; 293     hl = 0;
	ld hl, 0
; 294     ParseDword1();
; 295 }
; 296 
; 297 void ParseDword1(...) {
parsedword1:
; 298     for (;;) {
l_16:
; 299         a = *de;
	ld a, (de)
; 300         de++;
	inc de
; 301         if (a == 0x0D)
	cp 13
; 302             return ReturnCf();
	jp z, returncf
; 303         if (a == ',')
	cp 44
; 304             return;
	ret z
; 305         if (a == ' ')
	cp 32
; 306             continue;
	jp z, l_16
; 307         a -= '0';
	sub 48
; 308         if (flag_m)
; 309             return MonitorError();
	jp m, monitorerror
; 310         if (flag_p(compare(a, 10))) {
	cp 10
	jp m, l_18
; 311             if (flag_m(compare(a, 0x11)))
	cp 17
; 312                 return MonitorError();
	jp m, monitorerror
; 313             if (flag_p(compare(a, 0x17)))
	cp 23
; 314                 return MonitorError();
	jp p, monitorerror
; 315             a -= 7;
	sub 7
l_18:
; 316         }
; 317         c = a;
	ld c, a
; 318         hl += hl;
	add hl, hl
; 319         hl += hl;
	add hl, hl
; 320         hl += hl;
	add hl, hl
; 321         hl += hl;
	add hl, hl
; 322         if (flag_c)
; 323             return MonitorError();
	jp c, monitorerror
; 324         hl += bc;
	add hl, bc
	jp l_16
; 325     }
; 326 }
; 327 
; 328 void ReturnCf(...) {
returncf:
; 329     set_flag_c();
	scf
	ret
; 330 }
; 331 
; 332 void PrintByteFromParam1(...) {
printbytefromparam1:
; 333     hl = param1;
	ld hl, (param1)
; 334     PrintHexByte(a = *hl);
	ld a, (hl)
; 335 }
; 336 
; 337 void PrintHexByte(...) {
printhexbyte:
; 338     b = a;
	ld b, a
; 339     a = b;
	ld a, b
; 340     cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 341     PrintHex(a);
	call printhex
; 342     PrintHex(a = b);
	ld a, b
; 343 }
; 344 
; 345 void PrintHex(...) {
printhex:
; 346     a &= 0x0F;
	and 15
; 347     if (flag_p(compare(a, 10)))
	cp 10
; 348         a += 'A' - '0' - 10;
	jp m, l_20
	add 7
l_20:
; 349     a += '0';
	add 48
; 350     PrintCharA(a);
	jp printchara
; 351 }
; 352 
; 353 void PrintLfParam1(...) {
printlfparam1:
; 354     PrintLf();
	call printlf
; 355     PrintParam1Space();
; 356 }
; 357 
; 358 void PrintParam1Space() {
printparam1space:
; 359     PrintHexWordSpace(hl = &param1h);
	ld hl, 0FFFFh & (param1h)
; 360 }
; 361 
; 362 void PrintHexWordSpace(...) {
printhexwordspace:
; 363     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 364     hl--;
	dec hl
; 365     PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 366     PrintSpace();
; 367 }
; 368 
; 369 void PrintSpace(...) {
printspace:
; 370     PrintCharA(a = ' ');
	ld a, 32
	jp printchara
; 371 }
; 372 
; 373 void Loop(...) {
loop:
; 374     push_pop(de) {
	push de
; 375         hl = param1;
	ld hl, (param1)
; 376         swap(hl, de);
	ex hl, de
; 377         hl = param2;
	ld hl, (param2)
; 378         CmpHlDe(hl, de);
	call cmphlde
	pop de
; 379     }
; 380     if (flag_z)
; 381         return PopWordReturn();
	jp z, popwordreturn
; 382     IncWord(hl = &param1);
	ld hl, 0FFFFh & (param1)
; 383 }
; 384 
; 385 void IncWord(...) {
incword:
; 386     (*hl)++;
	inc (hl)
; 387     if (flag_nz)
; 388         return;
	ret nz
; 389     hl++;
	inc hl
; 390     (*hl)++;
	inc (hl)
	ret
; 391 }
; 392 
; 393 void CmpHlDe(...) {
cmphlde:
; 394     if ((a = h) != d)
	ld a, h
	cp d
; 395         return;
	ret nz
; 396     compare(a = l, e);
	ld a, l
	cp e
	ret
; 397 }
; 398 
; 399 /* X - Изменение содержимого внутреннего регистра микропроцессора */
; 400 
; 401 void CmdX() {
cmdx:
; 402     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 403     a = *hl;
	ld a, (hl)
; 404     if (a == 0x0D)
	cp 13
; 405         return PrintRegs();
	jp z, printregs
; 406     if (a == 'S')
	cp 83
; 407         return CmdXS();
	jp z, cmdxs
; 408     FindRegister(de = &regList);
	ld de, reglist
	call findregister
; 409     hl = &regs;
	ld hl, 0FFFFh & (regs)
; 410     de++;
	inc de
; 411     l = a = *de;
	ld a, (de)
	ld l, a
; 412     push_pop(hl) {
	push hl
; 413         PrintSpace();
	call printspace
; 414         PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
; 415         Input();
	call input
; 416         if (flag_nc)
; 417             return Monitor();
	jp nc, monitor
; 418         ParseDword();
	call parsedword
; 419         a = l;
	ld a, l
	pop hl
; 420     }
; 421     *hl = a;
	ld (hl), a
	ret
; 422 }
; 423 
; 424 void CmdXS() {
cmdxs:
; 425     PrintSpace();
	call printspace
; 426     PrintHexWordSpace(hl = &regSPH);
	ld hl, 0FFFFh & (regsph)
	call printhexwordspace
; 427     Input();
	call input
; 428     if (flag_nc)
; 429         return Monitor();
	jp nc, monitor
; 430     ParseDword();
	call parsedword
; 431     regSP = hl;
	ld (regsp), hl
	ret
; 432 }
; 433 
; 434 void FindRegister(...) {
findregister:
; 435     for (;;) {
l_23:
; 436         a = *de;
	ld a, (de)
; 437         if (flag_z(a &= a))
	and a
; 438             return MonitorError();
	jp z, monitorerror
; 439         if (a == *hl)
	cp (hl)
; 440             return;
	ret z
; 441         de++;
	inc de
; 442         de++;
	inc de
	jp l_23
; 443     }
; 444 }
; 445 
; 446 void PrintRegs(...) {
printregs:
; 447     de = &regList;
	ld de, reglist
; 448     b = 8;
	ld b, 8
; 449     PrintLf();
	call printlf
; 450     do {
l_25:
; 451         c = a = *de;
	ld a, (de)
	ld c, a
; 452         de++;
	inc de
; 453         push_pop(bc) {
	push bc
; 454             PrintRegMinus(c);
	call printregminus
; 455             a = *de;
	ld a, (de)
; 456             hl = &regs;
	ld hl, 0FFFFh & (regs)
; 457             l = a;
	ld l, a
; 458             PrintHexByte(a = *hl);
	ld a, (hl)
	call printhexbyte
	pop bc
; 459         }
; 460         de++;
	inc de
l_26:
; 461     } while (flag_nz(b--));
	dec b
	jp nz, l_25
; 462 
; 463     c = a = *de;
	ld a, (de)
	ld c, a
; 464     PrintRegMinus();
	call printregminus
; 465     param1 = hl = regs;
	ld hl, (regs)
	ld (param1), hl
; 466     PrintParam1Space();
	call printparam1space
; 467     PrintRegMinus(c = 'O');
	ld c, 79
	call printregminus
; 468     PrintHexWordSpace(hl = &lastBreakAddressHigh);
	ld hl, 0FFFFh & (lastbreakaddresshigh)
	call printhexwordspace
; 469     PrintLf();
	jp printlf
; 470 }
; 471 
; 472 void PrintRegMinus(...) {
printregminus:
; 473     PrintSpace();
	call printspace
; 474     PrintCharA(a = c);
	ld a, c
	call printchara
; 475     PrintCharA(a = '-');
	ld a, 45
	jp printchara
; 476 }
; 477 
; 478 uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC, 'D', (uint8_t)(uintptr_t)&regD,  'E', (uint8_t)(uintptr_t)&regE,
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
; 481  aStart[] = "\x0ASTART-";
astart:
	db 10
	db 83
	db 84
	db 65
	db 82
	db 84
	db 45
	ds 1
; 482  aDir_[] = "\x0ADIR. -";
adir_:
	db 10
	db 68
	db 73
	db 82
	db 46
	db 32
	db 45
	ds 1
; 486  CmdB() {
cmdb:
; 487     ParseParams();
	call parseparams
; 488     InitRst38();
	call initrst38
; 489     hl = param1;
	ld hl, (param1)
; 490     a = *hl;
	ld a, (hl)
; 491     *hl = OPCODE_RST_38;
	ld (hl), 255
; 492     breakAddress = hl;
	ld (breakaddress), hl
; 493     breakPrevByte = a;
	ld (breakprevbyte), a
	ret
; 494 }
; 495 
; 496 void InitRst38() {
initrst38:
; 497     rst38Opcode = a = OPCODE_JMP;
	ld a, 195
	ld (rst38opcode), a
; 498     rst38Address = hl = &BreakPoint;
	ld hl, 0FFFFh & (breakpoint)
	ld (rst38address), hl
	ret
; 499 }
; 500 
; 501 void BreakPoint(...) {
breakpoint:
; 502     regHL = hl;
	ld (reghl), hl
; 503     push(a);
	push af
; 504     hl = 4;
	ld hl, 4
; 505     hl += sp;
	add hl, sp
; 506     regs = hl;
	ld (regs), hl
; 507     pop(a);
	pop af
; 508     swap(*sp, hl);
	ex (sp), hl
; 509     hl--;
	dec hl
; 510     swap(*sp, hl);
	ex (sp), hl
; 511     sp = &regHL;
	ld sp, 0FFFFh & (reghl)
; 512     push(de, bc, a);
	push de
	push bc
	push af
; 513     sp = STACK_TOP;
	ld sp, 63487
; 514 
; 515     hl = regSP;
	ld hl, (regsp)
; 516     hl--;
	dec hl
; 517     d = *hl;
	ld d, (hl)
; 518     hl--;
	dec hl
; 519     e = *hl;
	ld e, (hl)
; 520     l = e;
	ld l, e
; 521     h = d;
	ld h, d
; 522     lastBreakAddress = hl;
	ld (lastbreakaddress), hl
; 523 
; 524     hl = breakAddress;
	ld hl, (breakaddress)
; 525     CmpHlDe();
	call cmphlde
; 526     if (flag_nz) {
	jp z, l_28
; 527         hl = breakAddress2;
	ld hl, (breakaddress2)
; 528         CmpHlDe(hl, de);
	call cmphlde
; 529         if (flag_z)
; 530             return BreakPointAt2();
	jp z, breakpointat2
; 531 
; 532         hl = breakAddress3;
	ld hl, (breakaddress3)
; 533         CmpHlDe(hl, de);
	call cmphlde
; 534         if (flag_z)
; 535             return BreakpointAt3();
	jp z, breakpointat3
; 536 
; 537         return MonitorError();
	jp monitorerror
l_28:
; 538     }
; 539     *hl = a = breakPrevByte;
	ld a, (breakprevbyte)
	ld (hl), a
; 540     breakAddress = hl = 0xFFFF;
	ld hl, 65535
	ld (breakaddress), hl
; 541     return Monitor();
	jp monitor
; 542 }
; 543 
; 544 /* G<адрес> - Запуск программы в отладочном режиме */
; 545 
; 546 void CmdG() {
cmdg:
; 547     ParseParams();
	call parseparams
; 548     if ((a = cmdBuffer1) == 0x0D)
	ld a, (cmdbuffer1)
	cp 13
; 549         param1 = hl = lastBreakAddress;
	jp nz, l_30
	ld hl, (lastbreakaddress)
	ld (param1), hl
l_30:
; 550     Run();
; 551 }
; 552 
; 553 void Run() {
run:
; 554     jumpOpcode = a = OPCODE_JMP;
	ld a, 195
	ld (jumpopcode), a
; 555     sp = &regs;
	ld sp, 0FFFFh & (regs)
; 556     pop(de, bc, a, hl);
	pop hl
	pop af
	pop bc
	pop de
; 557     sp = hl;
	ld sp, hl
; 558     hl = regHL;
	ld hl, (reghl)
; 559     jumpParam1();
	jp jumpparam1
; 560 }
; 561 
; 562 void CmdP(...) {
cmdp:
; 563     ParseParams();
	call parseparams
; 564     InitRst38();
	call initrst38
; 565 
; 566     breakAddress2 = hl = param1;
	ld hl, (param1)
	ld (breakaddress2), hl
; 567     a = *hl;
	ld a, (hl)
; 568     *hl = OPCODE_RST_38;
	ld (hl), 255
; 569     breakPrevByte2 = a;
	ld (breakprevbyte2), a
; 570 
; 571     breakAddress3 = hl = param2;
	ld hl, (param2)
	ld (breakaddress3), hl
; 572     a = *hl;
	ld a, (hl)
; 573     *hl = OPCODE_RST_38;
	ld (hl), 255
; 574     breakPrevByte3 = a;
	ld (breakprevbyte3), a
; 575 
; 576     breakCounter = a = param3;
	ld a, (param3)
	ld (breakcounter), a
; 577 
; 578     PrintString(hl = &aStart);
	ld hl, astart
	call printstring
; 579 
; 580     hl = &cmdBuffer1;
	ld hl, 0FFFFh & (cmdbuffer1)
; 581     ReadStringLoop();
	call readstringloop
; 582     ParseParams();
	call parseparams
; 583     PrintString(hl = &aDir_);
	ld hl, adir_
	call printstring
; 584     ReadString();
	call readstring
; 585     Run();
	jp run
; 586 }
; 587 
; 588 void BreakPointAt2(...) {
breakpointat2:
; 589     *hl = a = breakPrevByte2;
	ld a, (breakprevbyte2)
	ld (hl), a
; 590 
; 591     hl = breakAddress3;
	ld hl, (breakaddress3)
; 592     a = OPCODE_RST_38;
	ld a, 255
; 593     if (a != *hl) {
	cp (hl)
	jp z, l_32
; 594         b = *hl;
	ld b, (hl)
; 595         *hl = a;
	ld (hl), a
; 596         breakPrevByte3 = a = b;
	ld a, b
	ld (breakprevbyte3), a
l_32:
; 597     }
; 598     ContinueBreakpoint();
; 599 }
; 600 
; 601 void ContinueBreakpoint(...) {
continuebreakpoint:
; 602     PrintRegs();
	call printregs
; 603     MonitorExecute();
	call monitorexecute
; 604     param1 = hl = lastBreakAddress;
	ld hl, (lastbreakaddress)
	ld (param1), hl
; 605     Run();
	jp run
; 606 }
; 607 
; 608 void BreakpointAt3(...) {
breakpointat3:
; 609     *hl = a = breakPrevByte3;
	ld a, (breakprevbyte3)
	ld (hl), a
; 610 
; 611     hl = breakAddress2;
	ld hl, (breakaddress2)
; 612     a = OPCODE_RST_38;
	ld a, 255
; 613     if (a == *hl)
	cp (hl)
; 614         return ContinueBreakpoint();
	jp z, continuebreakpoint
; 615     b = *hl;
	ld b, (hl)
; 616     *hl = a;
	ld (hl), a
; 617     breakPrevByte2 = a = b;
	ld a, b
	ld (breakprevbyte2), a
; 618 
; 619     hl = &breakCounter;
	ld hl, 0FFFFh & (breakcounter)
; 620     (*hl)--;
	dec (hl)
; 621     if (flag_nz)
; 622         return ContinueBreakpoint();
	jp nz, continuebreakpoint
; 623 
; 624     a = breakPrevByte2;
	ld a, (breakprevbyte2)
; 625     hl = breakAddress2;
	ld hl, (breakaddress2)
; 626     *hl = a;
	ld (hl), a
; 627     Monitor();
	jp monitor
; 628 }
; 629 
; 630 /* D<адрес>,<адрес> - Просмотр содержимого области памяти в шестнадцатеричном виде */
; 631 
; 632 void CmdD() {
cmdd:
; 633     ParseParams();
	call parseparams
; 634     PrintLf();
	call printlf
; 635 CmdDLine:
cmddline:
; 636     PrintLfParam1();
	call printlfparam1
; 637     for (;;) {
l_35:
; 638         PrintSpace();
	call printspace
; 639         PrintByteFromParam1();
	call printbytefromparam1
; 640         Loop();
	call loop
; 641         a = param1;
	ld a, (param1)
; 642         a &= 0x0F;
	and 15
; 643         if (flag_z)
; 644             goto CmdDLine;
	jp z, cmddline
	jp l_35
; 645     }
; 646 }
; 647 
; 648 /* C<адрес от>,<адрес до>,<адрес от 2> - Сравнение содержимого двух областей памяти */
; 649 
; 650 void CmdC() {
cmdc:
; 651     ParseParams();
	call parseparams
; 652     hl = param3;
	ld hl, (param3)
; 653     swap(hl, de);
	ex hl, de
; 654     for (;;) {
l_38:
; 655         hl = param1;
	ld hl, (param1)
; 656         a = *de;
	ld a, (de)
; 657         if (a != *hl) {
	cp (hl)
	jp z, l_40
; 658             PrintLfParam1();
	call printlfparam1
; 659             PrintSpace();
	call printspace
; 660             PrintByteFromParam1();
	call printbytefromparam1
; 661             PrintSpace();
	call printspace
; 662             a = *de;
	ld a, (de)
; 663             PrintHexByte();
	call printhexbyte
l_40:
; 664         }
; 665         de++;
	inc de
; 666         Loop();
	call loop
	jp l_38
; 667     }
; 668 }
; 669 
; 670 /* F<адрес>,<адрес>,<байт> - Запись байта во все ячейки области памяти */
; 671 
; 672 void CmdF() {
cmdf:
; 673     ParseParams();
	call parseparams
; 674     b = a = param3;
	ld a, (param3)
	ld b, a
; 675     for (;;) {
l_43:
; 676         hl = param1;
	ld hl, (param1)
; 677         *hl = b;
	ld (hl), b
; 678         Loop();
	call loop
	jp l_43
; 679     }
; 680 }
; 681 
; 682 /* S<адрес>,<адрес>,<байт> - Поиск байта в области памяти */
; 683 
; 684 void CmdS() {
cmds:
; 685     ParseParams();
	call parseparams
; 686     c = l;
	ld c, l
; 687     for (;;) {
l_46:
; 688         hl = param1;
	ld hl, (param1)
; 689         a = c;
	ld a, c
; 690         if (a == *hl)
	cp (hl)
; 691             PrintLfParam1();
	call z, printlfparam1
; 692         Loop();
	call loop
	jp l_46
; 693     }
; 694 }
; 695 
; 696 /* T<начало>,<конец>,<куда> - Пересылка содержимого одной области в другую */
; 697 
; 698 void CmdT() {
cmdt:
; 699     ParseParams();
	call parseparams
; 700     hl = param3;
	ld hl, (param3)
; 701     swap(hl, de);
	ex hl, de
; 702     for (;;) {
l_49:
; 703         hl = param1;
	ld hl, (param1)
; 704         *de = a = *hl;
	ld a, (hl)
	ld (de), a
; 705         de++;
	inc de
; 706         Loop();
	call loop
	jp l_49
; 707     }
; 708 }
; 709 
; 710 /* M<адрес> - Просмотр или изменение содержимого ячейки (ячеек) памяти */
; 711 
; 712 void CmdM() {
cmdm:
; 713     ParseParams();
	call parseparams
; 714     for (;;) {
l_52:
; 715         PrintSpace();
	call printspace
; 716         PrintByteFromParam1();
	call printbytefromparam1
; 717         Input();
	call input
; 718         if (flag_c) {
	jp nc, l_54
; 719             ParseDword();
	call parsedword
; 720             a = l;
	ld a, l
; 721             hl = param1;
	ld hl, (param1)
; 722             *hl = a;
	ld (hl), a
l_54:
; 723         }
; 724         hl = &param1;
	ld hl, 0FFFFh & (param1)
; 725         IncWord();
	call incword
; 726         PrintLfParam1();
	call printlfparam1
	jp l_52
; 727     }
; 728 }
; 729 
; 730 /* J<адрес> - Запуск программы с указанного адреса */
; 731 
; 732 void CmdJ() {
cmdj:
; 733     ParseParams();
	call parseparams
; 734     hl = param1;
	ld hl, (param1)
; 735     return hl();
	jp hl
; 736 }
; 737 
; 738 /* А<символ> - Вывод кода символа на экран */
; 739 
; 740 void CmdA() {
cmda:
; 741     PrintLf();
	call printlf
; 742     PrintHexByte(a = cmdBuffer1);
	ld a, (cmdbuffer1)
	call printhexbyte
; 743     PrintLf();
	jp printlf
; 744 }
; 745 
; 746 /* K - Вывод символа с клавиатуры на экран */
; 747 
; 748 void CmdK() {
cmdk:
; 749     for (;;) {
l_57:
; 750         ReadKey();
	call readkey
; 751         if (a == 1) /* УС + А */
	cp 1
; 752             return Monitor();
	jp z, monitor
; 753         PrintCharA(a);
	call printchara
	jp l_57
; 754     }
; 755 }
; 756 
; 757 /* Q<начало>,<конец> - Тестирование области памяти */
; 758 
; 759 void CmdQ() {
cmdq:
; 760     ParseParams();
	call parseparams
; 761     for (;;) {
l_60:
; 762         hl = param1;
	ld hl, (param1)
; 763         c = *hl;
	ld c, (hl)
; 764 
; 765         a = 0x55;
	ld a, 85
; 766         *hl = a;
	ld (hl), a
; 767         if (a != *hl)
	cp (hl)
; 768             CmdQResult();
	call nz, cmdqresult
; 769 
; 770         a = 0xAA;
	ld a, 170
; 771         *hl = a;
	ld (hl), a
; 772         if (a != *hl)
	cp (hl)
; 773             CmdQResult();
	call nz, cmdqresult
; 774 
; 775         *hl = c;
	ld (hl), c
; 776         Loop();
	call loop
	jp l_60
; 777     }
; 778 }
; 779 
; 780 void CmdQResult(...) {
cmdqresult:
; 781     push_pop(a) {
	push af
; 782         PrintLfParam1();
	call printlfparam1
; 783         PrintSpace();
	call printspace
; 784         PrintByteFromParam1();
	call printbytefromparam1
; 785         PrintSpace();
	call printspace
	pop af
; 786     }
; 787     PrintHexByte(a);
	call printhexbyte
; 788     return;
	ret
; 789 }
; 790 
; 791 /* L<начало>,<конец> - Посмотр области памяти в символьном виде */
; 792 
; 793 void CmdL() {
cmdl:
; 794     ParseParams();
	call parseparams
; 795     PrintLf();
	call printlf
; 796 
; 797 CmdLLine:
cmdlline:
; 798     PrintLfParam1();
	call printlfparam1
; 799 
; 800     for (;;) {
l_63:
; 801         PrintSpace();
	call printspace
; 802         hl = param1;
	ld hl, (param1)
; 803         a = *hl;
	ld a, (hl)
; 804         if (a >= 0x20) {
	cp 32
	jp c, l_65
; 805             if (a < 0x80) {
	cp 128
	jp nc, l_67
; 806                 goto CmdLShow;
	jp cmdlshow
l_67:
l_65:
; 807             }
; 808         }
; 809         a = '.';
	ld a, 46
; 810     CmdLShow:
cmdlshow:
; 811         PrintCharA();
	call printchara
; 812         Loop();
	call loop
; 813         if (flag_z((a = param1) &= 0x0F))
	ld a, (param1)
	and 15
; 814             goto CmdLLine;
	jp z, cmdlline
	jp l_63
; 815     }
; 816 }
; 817 
; 818 /* H<число 1>,<число 2> - Сложение и вычитание чисел */
; 819 
; 820 void CmdH(...) {
cmdh:
; 821     hl = &param1;
	ld hl, 0FFFFh & (param1)
; 822     b = 6;
	ld b, 6
; 823     a ^= a;
	xor a
; 824     do {
l_69:
; 825         *hl = a;
	ld (hl), a
l_70:
; 826     } while (flag_nz(b--));
	dec b
	jp nz, l_69
; 827 
; 828     de = &cmdBuffer1;
	ld de, 0FFFFh & (cmdbuffer1)
; 829 
; 830     ParseDword();
	call parsedword
; 831     param1 = hl;
	ld (param1), hl
; 832 
; 833     ParseDword();
	call parsedword
; 834     param2 = hl;
	ld (param2), hl
; 835 
; 836     PrintLf();
	call printlf
; 837     param3 = hl = param1;
	ld hl, (param1)
	ld (param3), hl
; 838     swap(hl, de);
	ex hl, de
; 839     hl = param2;
	ld hl, (param2)
; 840     hl += de;
	add hl, de
; 841     param1 = hl;
	ld (param1), hl
; 842     PrintParam1Space();
	call printparam1space
; 843 
; 844     hl = param2;
	ld hl, (param2)
; 845     swap(hl, de);
	ex hl, de
; 846     hl = param3;
	ld hl, (param3)
; 847     a = e;
	ld a, e
; 848     invert(a);
	cpl
; 849     e = a;
	ld e, a
; 850     a = d;
	ld a, d
; 851     invert(a);
	cpl
; 852     d = a;
	ld d, a
; 853     de++;
	inc de
; 854     hl += de;
	add hl, de
; 855     param1 = hl;
	ld (param1), hl
; 856     PrintParam1Space();
	call printparam1space
; 857     PrintLf();
	jp printlf
; 858 }
; 859 
; 860 /* I - Ввод информации с магнитной ленты */
; 861 
; 862 void CmdI() {
cmdi:
; 863     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 864     param1h = a;
	ld (param1h), a
; 865     tapeStartH = a;
	ld (tapestarth), a
; 866 
; 867     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 868     param1 = a;
	ld (param1), a
; 869     tapeStartL = a;
	ld (tapestartl), a
; 870 
; 871     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 872     param2h = a;
	ld (param2h), a
; 873     tapeStopH = a;
	ld (tapestoph), a
; 874 
; 875     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 876     param2 = a;
	ld (param2), a
; 877     tapeStopL = a;
	ld (tapestopl), a
; 878 
; 879     a = READ_TAPE_NEXT_BYTE;
	ld a, 8
; 880     hl = &CmdIEnd;
	ld hl, 0FFFFh & (cmdiend)
; 881     push(hl);
	push hl
; 882 
; 883     for (;;) {
l_73:
; 884         hl = param1;
	ld hl, (param1)
; 885         ReadTapeByte(a);
	call readtapebyte
; 886         *hl = a;
	ld (hl), a
; 887         Loop();
	call loop
; 888         a = READ_TAPE_NEXT_BYTE;
	ld a, 8
	jp l_73
; 889     }
; 890 }
; 891 
; 892 void CmdIEnd(...) {
cmdiend:
; 893     PrintHexWordSpace(hl = &tapeStartH);
	ld hl, 0FFFFh & (tapestarth)
	call printhexwordspace
; 894     PrintHexWordSpace(hl = &tapeStopH);
	ld hl, 0FFFFh & (tapestoph)
	call printhexwordspace
; 895     PrintLf();
	jp printlf
; 896 }
; 897 
; 898 /* O<начало>,<конец> - Вывод содержимого области памяти на магнитную ленту */
; 899 
; 900 void CmdO() {
cmdo:
; 901     ParseParams();
	call parseparams
; 902     a ^= a;
	xor a
; 903     b = 0;
	ld b, 0
; 904     do {
l_75:
; 905         WriteTapeByte(a);
	call writetapebyte
l_76:
; 906     } while (flag_nz(b--));
	dec b
	jp nz, l_75
; 907     WriteTapeByte(a = TAPE_START);
	ld a, 230
	call writetapebyte
; 908     WriteTapeByte(a = param1h);
	ld a, (param1h)
	call writetapebyte
; 909     WriteTapeByte(a = param1);
	ld a, (param1)
	call writetapebyte
; 910     WriteTapeByte(a = param2h);
	ld a, (param2h)
	call writetapebyte
; 911     WriteTapeByte(a = param2);
	ld a, (param2)
	call writetapebyte
; 912     for (;;) {
l_79:
; 913         hl = param1;
	ld hl, (param1)
; 914         a = *hl;
	ld a, (hl)
; 915         WriteTapeByte(a);
	call writetapebyte
; 916         Loop();
	call loop
	jp l_79
; 917     }
; 918 }
; 919 
; 920 /* V - Сравнение информации на магнитной ленте с содержимым области памяти */
; 921 
; 922 void CmdV() {
cmdv:
; 923     ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
	ld a, 255
	call readtapebyte
; 924     param1h = a;
	ld (param1h), a
; 925     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 926     param1 = a;
	ld (param1), a
; 927     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 928     param2h = a;
	ld (param2h), a
; 929     ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 930     param2 = a;
	ld (param2), a
; 931     for (;;) {
l_82:
; 932         ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
	ld a, 8
	call readtapebyte
; 933         hl = param1;
	ld hl, (param1)
; 934         if (a != *hl) {
	cp (hl)
	jp z, l_84
; 935             push_pop(a) {
	push af
; 936                 PrintLfParam1();
	call printlfparam1
; 937                 PrintSpace();
	call printspace
; 938                 PrintByteFromParam1();
	call printbytefromparam1
; 939                 PrintSpace();
	call printspace
	pop af
; 940             }
; 941             PrintHexByte();
	call printhexbyte
l_84:
; 942         }
; 943         Loop();
	call loop
	jp l_82
; 944     }
; 945 }
; 946 
; 947 void ReadTapeByte(...) {
readtapebyte:
; 948     push(bc, de);
	push bc
	push de
; 949     c = 0;
	ld c, 0
; 950     d = a;
	ld d, a
; 951     e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 952     do {
l_86:
; 953     loc_FD9D:
loc_fd9d:
; 954         a = c;
	ld a, c
; 955         a &= 0x7F;
	and 127
; 956         cyclic_rotate_left(a, 1);
	rlca
; 957         c = a;
	ld c, a
; 958 
; 959         do {
l_89:
; 960             a = in(PORT_TAPE);
	in a, (1)
l_90:
; 961         } while (a == e);
	cp e
	jp z, l_89
; 962         a &= 1;
	and 1
; 963         a |= c;
	or c
; 964         c = a;
	ld c, a
; 965         ReadTapeDelay();
	call readtapedelay
; 966         e = a = in(PORT_TAPE);
	in a, (1)
	ld e, a
; 967         if (flag_m((a = d) |= a)) {
	ld a, d
	or a
	jp p, l_92
; 968             if ((a = c) == TAPE_START) {
	ld a, c
	cp 230
	jp nz, l_94
; 969                 tapePolarity = (a ^= a);
	xor a
	ld (tapepolarity), a
	jp l_95
l_94:
; 970             } else {
; 971                 if (a != (0xFF ^ TAPE_START))
	cp 25
; 972                     goto loc_FD9D;
	jp nz, loc_fd9d
; 973                 tapePolarity = a = 0xFF;
	ld a, 255
	ld (tapepolarity), a
l_95:
; 974             }
; 975             d = 8 + 1;
	ld d, 9
l_92:
l_87:
; 976         }
; 977     } while (flag_nz(d--));
	dec d
	jp nz, l_86
; 978     a = tapePolarity;
	ld a, (tapepolarity)
; 979     a ^= c;
	xor c
; 980     pop(bc, de);
	pop de
	pop bc
	ret
; 981 }
; 982 
; 983 void ReadTapeDelay(...) {
readtapedelay:
; 984     push(a);
	push af
; 985     TapeDelay(a = readDelay);
	ld a, (readdelay)
; 986 }
; 987 
; 988 void TapeDelay(...) {
tapedelay:
; 989     b = a;
	ld b, a
; 990     pop(a);
	pop af
; 991     do {
l_96:
l_97:
; 992     } while (flag_nz(b--));
	dec b
	jp nz, l_96
	ret
; 993 }
; 994 
; 995 void WriteTapeByte(...) {
writetapebyte:
; 996     push_pop(bc, de, a) {
	push bc
	push de
	push af
; 997         d = a;
	ld d, a
; 998         c = 8;
	ld c, 8
; 999         do {
l_99:
; 1000             a = d;
	ld a, d
; 1001             cyclic_rotate_left(a, 1);
	rlca
; 1002             d = a;
	ld d, a
; 1003 
; 1004             out(PORT_TAPE, (a = 1) ^= d);
	ld a, 1
	xor d
	out (1), a
; 1005             WriteTapeDelay();
	call writetapedelay
; 1006 
; 1007             out(PORT_TAPE, (a = 0) ^= d);
	ld a, 0
	xor d
	out (1), a
; 1008             WriteTapeDelay();
	call writetapedelay
l_100:
; 1009         } while (flag_nz(c--));
	dec c
	jp nz, l_99
	pop af
	pop de
	pop bc
	ret
; 1010     }
; 1011 }
; 1012 
; 1013 void WriteTapeDelay(...) {
writetapedelay:
; 1014     push(a);
	push af
; 1015     TapeDelay(a = writeDelay);
	ld a, (writedelay)
	jp tapedelay
; 1016 }
; 1017 
; 1018 uint8_t monitorCommands = 'M';
monitorcommands:
	db 77
; 1019  monitorCommandsMa = (uintptr_t)&CmdM;
monitorcommandsma:
	dw 0FFFFh & (cmdm)
; 1020  monitorCommandsC = 'C';
monitorcommandsc:
	db 67
; 1021  monitorCommandsCa = (uintptr_t)&CmdC;
monitorcommandsca:
	dw 0FFFFh & (cmdc)
; 1022  monitorCommandsD = 'D';
monitorcommandsd:
	db 68
; 1023  monitorCommandsDa = (uintptr_t)&CmdD;
monitorcommandsda:
	dw 0FFFFh & (cmdd)
; 1024  monitorCommandsB = 'B';
monitorcommandsb:
	db 66
; 1025  monitorCommandsBa = (uintptr_t)&CmdB;
monitorcommandsba:
	dw 0FFFFh & (cmdb)
; 1026  monitorCommandsG = 'G';
monitorcommandsg:
	db 71
; 1027  monitorCommandsGa = (uintptr_t)&CmdG;
monitorcommandsga:
	dw 0FFFFh & (cmdg)
; 1028  monitorCommandsP = 'P';
monitorcommandsp:
	db 80
; 1029  monitorCommandsPa = (uintptr_t)&CmdP;
monitorcommandspa:
	dw 0FFFFh & (cmdp)
; 1030  monitorCommandsX = 'X';
monitorcommandsx:
	db 88
; 1031  monitorCommandsXa = (uintptr_t)&CmdX;
monitorcommandsxa:
	dw 0FFFFh & (cmdx)
; 1032  monitorCommandsF = 'F';
monitorcommandsf:
	db 70
; 1033  monitorCommandsFa = (uintptr_t)&CmdF;
monitorcommandsfa:
	dw 0FFFFh & (cmdf)
; 1034  monitorCommandsS = 'S';
monitorcommandss:
	db 83
; 1035  monitorCommandsSa = (uintptr_t)&CmdS;
monitorcommandssa:
	dw 0FFFFh & (cmds)
; 1036  monitorCommandsT = 'T';
monitorcommandst:
	db 84
; 1037  monitorCommandsTa = (uintptr_t)&CmdT;
monitorcommandsta:
	dw 0FFFFh & (cmdt)
; 1038  monitorCommandsI = 'I';
monitorcommandsi:
	db 73
; 1039  monitorCommandsIa = (uintptr_t)&CmdI;
monitorcommandsia:
	dw 0FFFFh & (cmdi)
; 1040  monitorCommandsO = 'O';
monitorcommandso:
	db 79
; 1041  monitorCommandsOa = (uintptr_t)&CmdO;
monitorcommandsoa:
	dw 0FFFFh & (cmdo)
; 1042  monitorCommandsV = 'V';
monitorcommandsv:
	db 86
; 1043  monitorCommandsVa = (uintptr_t)&CmdV;
monitorcommandsva:
	dw 0FFFFh & (cmdv)
; 1044  monitorCommandsJ = 'J';
monitorcommandsj:
	db 74
; 1045  monitorCommandsJa = (uintptr_t)&CmdJ;
monitorcommandsja:
	dw 0FFFFh & (cmdj)
; 1046  monitorCommandsA = 'A';
monitorcommandsa:
	db 65
; 1047  monitorCommandsAa = (uintptr_t)&CmdA;
monitorcommandsaa:
	dw 0FFFFh & (cmda)
; 1048  monitorCommandsK = 'K';
monitorcommandsk:
	db 75
; 1049  monitorCommandsKa = (uintptr_t)&CmdK;
monitorcommandska:
	dw 0FFFFh & (cmdk)
; 1050  monitorCommandsQ = 'Q';
monitorcommandsq:
	db 81
; 1051  monitorCommandsQa = (uintptr_t)&CmdQ;
monitorcommandsqa:
	dw 0FFFFh & (cmdq)
; 1052  monitorCommandsL = 'L';
monitorcommandsl:
	db 76
; 1053  monitorCommandsLa = (uintptr_t)&CmdL;
monitorcommandsla:
	dw 0FFFFh & (cmdl)
; 1054  monitorCommandsH = 'H';
monitorcommandsh:
	db 72
; 1055  monitorCommandsHa = (uintptr_t)&CmdH;
monitorcommandsha:
	dw 0FFFFh & (cmdh)
; 1056  monitorCommandsEnd = 0;
monitorcommandsend:
	db 0
; 1058  aPrompt[] = "\x0A*MikrO/80* MONITOR\x0A>";
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
; 1059  aLf[] = "\x0A";
alf:
	db 10
	ds 1
; 1061  PrintCharA(...) {
printchara:
; 1062     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1063     PrintCharInt(c = a);
	ld c, a
	jp printcharint
; 1064 }
; 1065 
; 1066 void PrintChar(...) {
printchar:
; 1067     push(hl, bc, de, a);
	push hl
	push bc
	push de
	push af
; 1068     return PrintCharInt(c);
; 1069 }
; 1070 
; 1071 void PrintCharInt(...) {
printcharint:
; 1072     hl = cursor;
	ld hl, (cursor)
; 1073     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1074     hl += de;
	add hl, de
; 1075     *hl = SCREEN_ATTRIB_DEFAULT;
	ld (hl), 0
; 1076 
; 1077     hl = cursor;
	ld hl, (cursor)
; 1078     a = c;
	ld a, c
; 1079     if (a == 0x1F)
	cp 31
; 1080         return ClearScreen();
	jp z, clearscreen
; 1081     if (a == 0x08)
	cp 8
; 1082         return MoveCursorLeft(hl);
	jp z, movecursorleft
; 1083     if (a == 0x18)
	cp 24
; 1084         return MoveCursorRight(hl);
	jp z, movecursorright
; 1085     if (a == 0x19)
	cp 25
; 1086         return MoveCursorUp(hl);
	jp z, movecursorup
; 1087     if (a == 0x1A)
	cp 26
; 1088         return MoveCursorDown(hl);
	jp z, movecursordown
; 1089     if (a == 0x0A)
	cp 10
; 1090         return MoveCursorNextLine(hl);
	jp z, movecursornextline
; 1091     if (a == 0x0C)
	cp 12
; 1092         return MoveCursorHome();
	jp z, movecursorhome
; 1093 
; 1094     if ((a = h) == SCREEN_END >> 8) {
	ld a, h
	cp 65520
	jp nz, l_102
; 1095         IsKeyPressed();
	call iskeypressed
; 1096         if (a != 0) {
	or a
	jp z, l_104
; 1097             ReadKey();
	call readkey
l_104:
; 1098         }
; 1099         ClearScreenInt();
	call clearscreenint
; 1100         hl = SCREEN_BEGIN;
	ld hl, 59392
l_102:
; 1101     }
; 1102     *hl = c;
	ld (hl), c
; 1103     hl++;
	inc hl
; 1104     return MoveCursor();
; 1105 }
; 1106 
; 1107 void MoveCursor(...) {
movecursor:
; 1108     cursor = hl;
	ld (cursor), hl
; 1109     de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
	ld de, 63489
; 1110     hl += de;
	add hl, de
; 1111     *hl = SCREEN_ATTRIB_DEFAULT | SCREEN_ATTRIB_UNDERLINE;
	ld (hl), 128
; 1112     pop(hl, bc, de, a);
	pop af
	pop de
	pop bc
	pop hl
	ret
; 1113 }
; 1114 
; 1115 void ClearScreen() {
clearscreen:
; 1116     ClearScreenInt();
	call clearscreenint
; 1117     MoveCursorHome();
; 1118 }
; 1119 
; 1120 void MoveCursorHome() {
movecursorhome:
; 1121     MoveCursor(hl = SCREEN_BEGIN);
	ld hl, 59392
	jp movecursor
; 1122 }
; 1123 
; 1124 void ClearScreenInt() {
clearscreenint:
; 1125     hl = SCREEN_BEGIN;
	ld hl, 59392
; 1126     de = SCREEN_ATTRIB_BEGIN;
	ld de, 57344
; 1127     for (;;) {
l_107:
; 1128         *hl = ' ';
	ld (hl), 32
; 1129         hl++;
	inc hl
; 1130         a = 0;
	ld a, 0
; 1131         *de = a;
	ld (de), a
; 1132         de++;
	inc de
; 1133         a = h;
	ld a, h
; 1134         if (a == SCREEN_END >> 8)
	cp 65520
; 1135             return;
	ret z
	jp l_107
; 1136     }
; 1137 }
; 1138 
; 1139 void MoveCursorRight(...) {
movecursorright:
; 1140     hl++;
	inc hl
; 1141     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1142         return MoveCursor(hl);
	jp nz, movecursor
; 1143     if (flag_z) /* Not needed */
; 1144         return MoveCursorHome();
	jp z, movecursorhome
; 1145     MoveCursorLeft(hl); /* Not needed */
; 1146 }
; 1147 
; 1148 void MoveCursorLeft(...) {
movecursorleft:
; 1149     hl--;
	dec hl
; 1150     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1151         return MoveCursor(hl);
	jp nz, movecursor
; 1152     MoveCursor(hl = SCREEN_END - 1);
	ld hl, 61439
	jp movecursor
; 1153 }
; 1154 
; 1155 void MoveCursorDown(...) {
movecursordown:
; 1156     hl += (de = SCREEN_WIDTH);
	ld de, 64
	add hl, de
; 1157     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1158         return MoveCursor(hl);
	jp nz, movecursor
; 1159     h = SCREEN_BEGIN >> 8;
	ld h, 232
; 1160     MoveCursor(hl);
	jp movecursor
; 1161 }
; 1162 
; 1163 void MoveCursorUp(...) {
movecursorup:
; 1164     hl += (de = -SCREEN_WIDTH);
	ld de, 65472
	add hl, de
; 1165     if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
	ld a, h
	cp 65511
; 1166         return MoveCursor(hl);
	jp nz, movecursor
; 1167     hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
	ld de, 2048
	add hl, de
; 1168     MoveCursor(hl);
	jp movecursor
; 1169 }
; 1170 
; 1171 void MoveCursorNextLine(...) {
movecursornextline:
; 1172     for (;;) {
l_110:
; 1173         hl++;
	inc hl
; 1174         a = l;
	ld a, l
; 1175         if (a == SCREEN_WIDTH * 0)
	or a
; 1176             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1177         if (a == SCREEN_WIDTH * 1)
	cp 64
; 1178             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1179         if (a == SCREEN_WIDTH * 2)
	cp 128
; 1180             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
; 1181         if (a == SCREEN_WIDTH * 3)
	cp 192
; 1182             return MoveCursorNextLine1(hl);
	jp z, movecursornextline1
	jp l_110
; 1183     }
; 1184 }
; 1185 
; 1186 void MoveCursorNextLine1(...) {
movecursornextline1:
; 1187     if ((a = h) != SCREEN_END >> 8)
	ld a, h
	cp 65520
; 1188         return MoveCursor(hl);
	jp nz, movecursor
; 1189 
; 1190     IsKeyPressed();
	call iskeypressed
; 1191     if (a == 0)
	or a
; 1192         return ClearScreen();
	jp z, clearscreen
; 1193     ReadKey();
	call readkey
; 1194     ClearScreen();
	jp clearscreen
; 1195 }
; 1196 
; 1197 void ReadKey() {
readkey:
; 1198     push(bc, de, hl);
	push bc
	push de
	push hl
; 1199 
; 1200     for (;;) {
l_113:
; 1201         b = 0;
	ld b, 0
; 1202         c = 1 ^ 0xFF;
	ld c, 254
; 1203         d = KEYBOARD_COLUMN_COUNT;
	ld d, 8
; 1204         do {
l_115:
; 1205             out(PORT_KEYBOARD_COLUMN, a = c);
	ld a, c
	out (7), a
; 1206             cyclic_rotate_left(a, 1);
	rlca
; 1207             c = a;
	ld c, a
; 1208             a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1209             a &= KEYBOARD_ROW_MASK;
	and 127
; 1210             if (a != KEYBOARD_ROW_MASK)
	cp 127
; 1211                 return ReadKey1(a, b);
	jp nz, readkey1
; 1212             b = ((a = b) += KEYBOARD_ROW_COUNT);
	ld a, b
	add 7
	ld b, a
l_116:
; 1213         } while (flag_nz(d--));
	dec d
	jp nz, l_115
	jp l_113
; 1214     }
; 1215 }
; 1216 
; 1217 void ReadKey1(...) {
readkey1:
; 1218     keyLast = a;
	ld (keylast), a
; 1219 
; 1220     for (;;) {
l_119:
; 1221         carry_rotate_right(a, 1);
	rra
; 1222         if (flag_nc)
; 1223             break;
	jp nc, l_120
; 1224         b++;
	inc b
	jp l_119
l_120:
; 1225     }
; 1226 
; 1227     /* b - key number */
; 1228 
; 1229     /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
; 1230      *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
; 1231      * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
; 1232      * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
; 1233      * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
; 1234      * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
; 1235      * 48   Space Right Left  Up    Down  Vk    Str   Home */
; 1236 
; 1237     a = b;
	ld a, b
; 1238     if (a < 48) {
	cp 48
	jp nc, l_121
; 1239         a += '0';
	add 48
; 1240         if (a >= 0x3C)
	cp 60
; 1241             if (a < 0x40)
	jp c, l_123
	cp 64
; 1242                 a &= 0x2F; /* <=>? to .-./ */
	jp nc, l_125
	and 47
l_125:
l_123:
; 1243         c = a;
	ld c, a
	jp l_122
l_121:
; 1244     } else {
; 1245         hl = &keyTable;
	ld hl, keytable
; 1246         a -= 48;
	sub 48
; 1247         c = a;
	ld c, a
; 1248         b = 0;
	ld b, 0
; 1249         hl += bc;
	add hl, bc
; 1250         a = *hl;
	ld a, (hl)
; 1251         return ReadKey2(a);
	jp readkey2
l_122:
; 1252     }
; 1253 
; 1254     a = in(PORT_KEYBOARD_MODS);
	in a, (5)
; 1255     a &= KEYBOARD_MODS_MASK;
	and 7
; 1256     if (a == KEYBOARD_MODS_MASK)
	cp 7
; 1257         goto ReadKeyNoMods;
	jp z, readkeynomods
; 1258     carry_rotate_right(a, 2);
	rra
	rra
; 1259     if (flag_nc)
; 1260         goto ReadKeyControl;
	jp nc, readkeycontrol
; 1261     carry_rotate_right(a, 1);
	rra
; 1262     if (flag_nc)
; 1263         goto ReadKeyShift;
	jp nc, readkeyshift
; 1264 
; 1265     /* RUS key pressed */
; 1266     a = c;
	ld a, c
; 1267     a |= 0x20;
	or 32
; 1268     return ReadKey2(a);
	jp readkey2
; 1269 
; 1270     /* US (Control) key pressed */
; 1271 ReadKeyControl:
readkeycontrol:
; 1272     a = c;
	ld a, c
; 1273     a &= 0x1F;
	and 31
; 1274     return ReadKey2(a);
	jp readkey2
; 1275 
; 1276     /* SS (Shift) key pressed */
; 1277 ReadKeyShift:
readkeyshift:
; 1278     a = c;
	ld a, c
; 1279     if (a >= 0x40) /* @ A-Z [ \ ] ^ _ */
	cp 64
; 1280         return ReadKey2(a);
	jp nc, readkey2
; 1281     if (a < 0x30) { /* .-./ to <=>? */
	cp 48
	jp nc, l_127
; 1282         a |= 0x10;
	or 16
; 1283         return ReadKey2(a);
	jp readkey2
l_127:
; 1284     }
; 1285     a &= 0x2F; /* 0123456789:; to !@#$%&'()*+ */
	and 47
; 1286     return ReadKey2(a);
	jp readkey2
; 1287 
; 1288 ReadKeyNoMods:
readkeynomods:
; 1289     ReadKey2(a = c);
	ld a, c
; 1290 }
; 1291 
; 1292 void ReadKey2(...) {
readkey2:
; 1293     c = a;
	ld c, a
; 1294 
; 1295     ReadKeyDelay();
	call readkeydelay
; 1296 
; 1297     hl = &keyLast;
	ld hl, 0FFFFh & (keylast)
; 1298     do {
l_129:
; 1299         a = in(PORT_KEYBOARD_ROW);
	in a, (6)
l_130:
; 1300     } while (a == *hl);
	cp (hl)
	jp z, l_129
; 1301 
; 1302     ReadKeyDelay();
	call readkeydelay
; 1303 
; 1304     a = c;
	ld a, c
; 1305     pop(bc, de, hl);
	pop hl
	pop de
	pop bc
	ret
; 1306 }
; 1307 
; 1308 void ReadKeyDelay() {
readkeydelay:
; 1309     de = 0x1000;
	ld de, 4096
; 1310     for (;;) {
l_133:
; 1311         de--;
	dec de
; 1312         if (flag_z((a = d) |= e))
	ld a, d
	or e
; 1313             return;
	ret z
	jp l_133
; 1314     }
; 1315 }
; 1316 
; 1317 uint8_t keyTable[] = {
keytable:
	db 32
	db 24
	db 8
	db 25
	db 26
	db 13
	db 31
	db 12
; 1328  IsKeyPressed() {
iskeypressed:
; 1329     out(PORT_KEYBOARD_COLUMN, a = 0);
	ld a, 0
	out (7), a
; 1330     a = in(PORT_KEYBOARD_ROW);
	in a, (6)
; 1331     a &= KEYBOARD_ROW_MASK;
	and 127
; 1332     if (a == KEYBOARD_ROW_MASK) {
	cp 127
	jp nz, l_135
; 1333         a ^= a; /* Returns 0 if no key is pressed */
	xor a
; 1334         return;
	ret
l_135:
; 1335     }
; 1336     a = 0xFF; /* Returns 0xFF if there are any keys pressed */
	ld a, 255
	ret
 savebin "micro80.bin", 0xF800, 0x10000
