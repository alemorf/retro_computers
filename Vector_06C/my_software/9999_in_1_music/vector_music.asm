    ; vector_music.c:2 
    ; vector_music.c:3 asm(" org 0x100");
 org 0x100
    ; vector_music.c:4 asm("begin:");
begin:
    ; vector_music.c:5 
    ; vector_music.c:6 // Sound chip
    ; vector_music.c:7 const int PORT_VI53_A = 0x0B;
    ; vector_music.c:8 const int PORT_VI53_B = 0x0A;
    ; vector_music.c:9 const int PORT_VI53_C = 0x09;
    ; vector_music.c:10 const int PORT_VI53_CONTROL = 0x08;
    ; vector_music.c:11 const int VI53_MODE_MUTE = 0;
    ; vector_music.c:12 const int VI53_MODE_MEANDER = 6;
    ; vector_music.c:13 const int VI53_SET_CHANNEL_MODE_0 = 0x30;
    ; vector_music.c:14 const int VI53_SET_CHANNEL_MODE_1 = 0x70;
    ; vector_music.c:15 const int VI53_SET_CHANNEL_MODE_2 = 0xB0;
    ; vector_music.c:16 
    ; vector_music.c:17 // Interrupt handler
    ; vector_music.c:18 const int INTERRUPT_HANDLER_ENABLE = 0xC3;
    ; vector_music.c:19 const int INTERRUPT_HANDLER_EMPTY = 0xC9;
    ; vector_music.c:20 extern uint8_t interrupt_handler_mode = 0x38;
interrupt_handler_mode=56
    ; vector_music.c:21 extern uint16_t interrupt_handler_address = 0x39;
interrupt_handler_address=57
    ; vector_music.c:22 
    ; vector_music.c:23 // System port
    ; vector_music.c:24 const int PORT_SYSTEM_A = 3;
    ; vector_music.c:25 const int PORT_SYSTEM_B = 2;
    ; vector_music.c:26 const int PORT_SYSTEM_C = 1;
    ; vector_music.c:27 const int PORT_SYSTEM_MODE = 0;
    ; vector_music.c:28 
    ; vector_music.c:29 // Palette
    ; vector_music.c:30 const int PALELLE_PROGRAMMING_MODE = 0x88;
    ; vector_music.c:31 const int PORT_PALETTE_INDEX = 0x02;
    ; vector_music.c:32 const int PORT_PALETTE_VALUE = 0x0C;
    ; vector_music.c:33 
    ; vector_music.c:34 // Video
    ; vector_music.c:35 const int VIDEO_ADDRESS = 0x8000;
    ; vector_music.c:36 const int PALETTE_COUNT = 16;
    ; vector_music.c:37 
    ; vector_music.c:38 // Main programm
    ; vector_music.c:39 void main() {
main:
    ; vector_music.c:40 disableInterrupts();
    di
    ; vector_music.c:41 
    ; vector_music.c:42 // Init stack
    ; vector_music.c:43 sp = &main;
    ld   sp, main
    ; vector_music.c:44 
    ; vector_music.c:45 // Reset palette
    ; vector_music.c:46 setPalette(hl = &black_palette);
    ld   hl, black_palette
    call setPalette
    ; vector_music.c:47 
    ; vector_music.c:48 // Clear screen
    ; vector_music.c:49 hl = VIDEO_ADDRESS;
    ld   hl, 32768
    ; vector_music.c:50 a ^= a; // a = 0
    xor  a
    ; vector_music.c:51 do {
l0:
    ; vector_music.c:52 *hl = a;
    ld   (hl), a
    ; vector_music.c:53 hl++;
    inc  hl
    ; vector_music.c:54 } while(a != h);
    cp   h
    jp   nz, l0
l1:
    ; vector_music.c:55 
    ; vector_music.c:56 // Init music
    ; vector_music.c:57 musicInit();
    call musicInit
    ; vector_music.c:58 
    ; vector_music.c:59 // Set irq handler
    ; vector_music.c:60 interrupt_handler_mode = a = INTERRUPT_HANDLER_ENABLE;
    ld   a, 195
    ld   (interrupt_handler_mode), a
    ; vector_music.c:61 interrupt_handler_address = hl = &irqHandler;
    ld   hl, irqHandler
    ld   (interrupt_handler_address), hl
    ; vector_music.c:62 
    ; vector_music.c:63 // Enable interrupts
    ; vector_music.c:64 enableInterrupts();
    ei
    ; vector_music.c:65 
    ; vector_music.c:66 // Infinite loop
    ; vector_music.c:67 while() {
l2:
    ; vector_music.c:68 halt();
    halt
    ; vector_music.c:69 }
    jp   l2
l3:
    ; vector_music.c:70 }
    ret
    ; vector_music.c:71 
    ; vector_music.c:72 uint8_t black_palette[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
black_palette:
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    ; vector_music.c:73 
    ; vector_music.c:74 void irqHandler() {
irqHandler:
    ; vector_music.c:75 push(a, bc, de, hl) {
    push af
    push bc
    push de
    push hl
    ; vector_music.c:76 musicTick();
    call musicTick
    ; vector_music.c:77 }
    pop  hl
    pop  de
    pop  bc
    pop  af
    ; vector_music.c:78 enable_interrupts();    
    ei
    ; vector_music.c:79 }
    ret
    ; vector_music.c:80 
    ; vector_music.c:81 void memcpy(de, hl, c) {
memcpy:
    ; vector_music.c:82 do {
l4:
    ; vector_music.c:83 *de = a = *hl; hl++; de++;
    ld   a, (hl)
    ld   (de), a
    inc  hl
    inc  de
    ; vector_music.c:84 } while(flag_nz --c);
    dec  c
    jp   nz, l4
l5:
    ; vector_music.c:85 }
    ret
    ; vector_music.c:86 
    ; vector_music.c:87 void setPalette(hl) {
setPalette:
    ; vector_music.c:88 // Сan change the palette only during horizontal blanking. 
    ; vector_music.c:89 // These are columns 0, 32 - 47 of 48. 
    ; vector_music.c:90 
    ; vector_music.c:91 // Setup GPIO mode for palette programming
    ; vector_music.c:92 out(PORT_SYSTEM_MODE, a = PALELLE_PROGRAMMING_MODE);
    ld   a, 136
    out  (0), a
    ; vector_music.c:93 
    ; vector_music.c:94 // Set empty interrupt handler
    ; vector_music.c:95 interrupt_handler_mode = a = INTERRUPT_HANDLER_EMPTY;
    ld   a, 201
    ld   (interrupt_handler_mode), a
    ; vector_music.c:96 
    ; vector_music.c:97 // Synchronize the processor with the video controller 
    ; vector_music.c:98 a ^= a;
    xor  a
    ; vector_music.c:99 enable_interrupts();
    ei
    ; vector_music.c:100 halt();
    halt
    ; vector_music.c:101 
    ; vector_music.c:102 // Not 9-th column (if the interrupt handler is empty)
    ; vector_music.c:103 
    ; vector_music.c:104 c = a;                  // 9-11
    ld   c, a
    ; vector_music.c:105 do {
l6:
    ; vector_music.c:106 out(PORT_PALETTE_INDEX, a);       // 11-14
    out  (2), a
    ; vector_music.c:107 a = *hl;            // 14-16
    ld   a, (hl)
    ; vector_music.c:108 out(PORT_PALETTE_VALUE, a);       // 16-19 ---
    out  (12), a
    ; vector_music.c:109 hl++;               // 19-21
    inc  hl
    ; vector_music.c:110 c++;                // 21-23
    inc  c
    ; vector_music.c:111 
    ; vector_music.c:112 out(PORT_PALETTE_INDEX, a = c);   // 24-29
    ld   a, c
    out  (2), a
    ; vector_music.c:113 a = *hl;            // 29-31
    ld   a, (hl)
    ; vector_music.c:114 out(PORT_PALETTE_VALUE, a);       // 31-34 ---
    out  (12), a
    ; vector_music.c:115 hl++;               // 34-36
    inc  hl
    ; vector_music.c:116 c++;                // 36-38
    inc  c
    ; vector_music.c:117 
    ; vector_music.c:118 swap(*sp, hl);      // 38-44
    ex   (sp), hl
    ; vector_music.c:119 swap(*sp, hl);      // 44-2
    ex   (sp), hl
    ; vector_music.c:120 a = c; a = c;       // 3-6
    ld   a, c
    ld   a, c
    ; vector_music.c:121 } while(a < PALETTE_COUNT);        // 7-11
    cp   16
    jp   c, l6
l7:
    ; vector_music.c:122 }
    ret
    ; vector_music.c:123 
    ; vector_music.c:124 // *** Music algorithm ***
    ; vector_music.c:125 
    ; vector_music.c:126 // State of current music channel. Temporary variables.
    ; vector_music.c:127 uint8_t  musicDelay = 0;
musicDelay db 0
    ; vector_music.c:128 uint16_t musicPtr = 0;
musicPtr dw 0
    ; vector_music.c:129 uint8_t  musicSubRepeatCounter = 0;
musicSubRepeatCounter db 0
    ; vector_music.c:130 uint16_t musicSubRet = 0;
musicSubRet dw 0
    ; vector_music.c:131 
    ; vector_music.c:132 // Music channel 0 state
    ; vector_music.c:133 uint8_t  music1Delay = 0;
music1Delay db 0
    ; vector_music.c:134 uint16_t music1Ptr = 0;
music1Ptr dw 0
    ; vector_music.c:135 uint8_t  music1SubCnt = 0;
music1SubCnt db 0
    ; vector_music.c:136 uint16_t music1SubRet = 0;
music1SubRet dw 0
    ; vector_music.c:137 
    ; vector_music.c:138 // Music channel 1 state
    ; vector_music.c:139 uint8_t  music2Delay = 0;
music2Delay db 0
    ; vector_music.c:140 uint16_t music2Ptr = 0;
music2Ptr dw 0
    ; vector_music.c:141 uint8_t  music2SubCnt = 0;
music2SubCnt db 0
    ; vector_music.c:142 uint16_t music2SubRet = 0;
music2SubRet dw 0
    ; vector_music.c:143 
    ; vector_music.c:144 // Music channel 2 state
    ; vector_music.c:145 uint8_t  music3Delay = 0;
music3Delay db 0
    ; vector_music.c:146 uint16_t music3Ptr = 0;
music3Ptr dw 0
    ; vector_music.c:147 uint8_t  music3SubCnt = 0;
music3SubCnt db 0
    ; vector_music.c:148 uint16_t music3SubRet = 0;
music3SubRet dw 0
    ; vector_music.c:149 
    ; vector_music.c:150 // Music rythm state
    ; vector_music.c:151 uint8_t  musicRythm = 0;
musicRythm db 0
    ; vector_music.c:152 uint16_t musicRythmFreq = 0;
musicRythmFreq dw 0
    ; vector_music.c:153 
    ; vector_music.c:154 const int MUSIC_RYTHM_PERIOD = 12 * 6;
    ; vector_music.c:155 
    ; vector_music.c:156 const int MUSIC_COMMAND_DELAY = 0x81;
    ; vector_music.c:157 const int MUSIC_COMMAND_SUBROUTINE = 0x84;
    ; vector_music.c:158 const int MUSIC_COMMAND_END_SUBROUTINE = 0x85;
    ; vector_music.c:159 
    ; vector_music.c:160 void musicInit() {
musicInit:
    ; vector_music.c:161 music1Ptr = hl = &musicChannel1;
    ld   hl, musicChannel1
    ld   (music1Ptr), hl
    ; vector_music.c:162 music2Ptr = hl = &musicChannel2;
    ld   hl, musicChannel2
    ld   (music2Ptr), hl
    ; vector_music.c:163 music3Ptr = hl = &musicChannel3;
    ld   hl, musicChannel3
    ld   (music3Ptr), hl
    ; vector_music.c:164 music1Delay = (a ^= a);
    xor  a
    ld   (music1Delay), a
    ; vector_music.c:165 music2Delay = a;
    ld   (music2Delay), a
    ; vector_music.c:166 music3Delay = a;
    ld   (music3Delay), a
    ; vector_music.c:167 a++;
    inc  a
    ; vector_music.c:168 musicRythm = a; // a = 1
    ld   (musicRythm), a
    ; vector_music.c:169 noreturn;
    ; vector_music.c:170 }
    ; vector_music.c:171 
    ; vector_music.c:172 void musicOff() {
musicOff:
    ; vector_music.c:173 out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_0 | VI53_MODE_MUTE]);
    ld   a, 48
    out  (8), a
    ; vector_music.c:174 out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_1 | VI53_MODE_MUTE]);
    ld   a, 112
    out  (8), a
    ; vector_music.c:175 out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_2 | VI53_MODE_MUTE]);
    ld   a, 176
    out  (8), a
    ; vector_music.c:176 }
    ret
    ; vector_music.c:177 
    ; vector_music.c:178 void musicTick() {
musicTick:
    ; vector_music.c:179 musicChannel(hl = &music1Delay);
    ld   hl, music1Delay
    call musicChannel
    ; vector_music.c:180 if (flag_nc) {
    jp   c, l8
    ; vector_music.c:181 a |= VI53_SET_CHANNEL_MODE_0;
    or   48
    ; vector_music.c:182 out(PORT_VI53_CONTROL, a);
    out  (8), a
    ; vector_music.c:183 out(PORT_VI53_A, a = l);
    ld   a, l
    out  (11), a
    ; vector_music.c:184 out(PORT_VI53_A, a = h);
    ld   a, h
    out  (11), a
    ; vector_music.c:185 }
    ; vector_music.c:186 musicChannel(hl = &music2Delay);
l8:
    ld   hl, music2Delay
    call musicChannel
    ; vector_music.c:187 if (flag_nc) {
    jp   c, l9
    ; vector_music.c:188 a |= VI53_SET_CHANNEL_MODE_1;
    or   112
    ; vector_music.c:189 out(PORT_VI53_CONTROL, a);
    out  (8), a
    ; vector_music.c:190 out(PORT_VI53_B, a = l);
    ld   a, l
    out  (10), a
    ; vector_music.c:191 out(PORT_VI53_B, a = h);
    ld   a, h
    out  (10), a
    ; vector_music.c:192 }
    ; vector_music.c:193 musicChannel(hl = &music3Delay);
l9:
    ld   hl, music3Delay
    call musicChannel
    ; vector_music.c:194 if (flag_nc) {
    jp   c, l10
    ; vector_music.c:195 a |= VI53_SET_CHANNEL_MODE_2;
    or   176
    ; vector_music.c:196 out(PORT_VI53_CONTROL, a);
    out  (8), a
    ; vector_music.c:197 hl += hl; // -1 octave
    add  hl, hl
    ; vector_music.c:198 musicRythmFreq = hl;
    ld   (musicRythmFreq), hl
    ; vector_music.c:199 }
    ; vector_music.c:200 
    ; vector_music.c:201 hl = musicRythmFreq;
l10:
    ld   hl, (musicRythmFreq)
    ; vector_music.c:202 a = musicRythm;
    ld   a, (musicRythm)
    ; vector_music.c:203 a--;
    dec  a
    ; vector_music.c:204 if (flag_z) {
    jp   nz, l11
    ; vector_music.c:205 a = MUSIC_RYTHM_PERIOD;
    ld   a, 72
    ; vector_music.c:206 hl += hl; // -1 octave
    add  hl, hl
    ; vector_music.c:207 }
    ; vector_music.c:208 musicRythm = a;
l11:
    ld   (musicRythm), a
    ; vector_music.c:209 out(PORT_VI53_C, a = l);
    ld   a, l
    out  (9), a
    ; vector_music.c:210 out(PORT_VI53_C, a = h);
    ld   a, h
    out  (9), a
    ; vector_music.c:211 }
    ret
    ; vector_music.c:212 
    ; vector_music.c:213 void musicChannel(hl) {
musicChannel:
    ; vector_music.c:214 // Delay before processing the next command 
    ; vector_music.c:215 a = *hl;
    ld   a, (hl)
    ; vector_music.c:216 if (a >= 2) {
    cp   2
    jp   c, l12
    ; vector_music.c:217 a--;
    dec  a
    ; vector_music.c:218 *hl = a;
    ld   (hl), a
    ; vector_music.c:219 (a ^= a) -= 1; // Set flag C for return
    xor  a
    sub  1
    ; vector_music.c:220 return;
    ret
    ; vector_music.c:221 }
    ; vector_music.c:222 
    ; vector_music.c:223 // Copy music channel state
    ; vector_music.c:224 push(hl);
l12:
    push hl
    ; vector_music.c:225 memcpy(de = &musicDelay, hl, c = [&music2Delay - &music1Delay]);
    ld   de, musicDelay
    ld   c, (music2Delay) - (music1Delay)
    call memcpy
    ; vector_music.c:226 
    ; vector_music.c:227 // Read 2 bypes from the music programm
    ; vector_music.c:228 hl = musicPtr;
    ld   hl, (musicPtr)
    ; vector_music.c:229 musicRetry:
musicRetry:
    ; vector_music.c:230 a = *hl; hl++;
    ld   a, (hl)
    inc  hl
    ; vector_music.c:231 b = *hl; hl++;
    ld   b, (hl)
    inc  hl
    ; vector_music.c:232 musicPtr = hl;
    ld   (musicPtr), hl
    ; vector_music.c:233 
    ; vector_music.c:234 // This is a musical note
    ; vector_music.c:235 if (a < [(&notesEnd - &notes) / 2]) {
    cp   (+((notesEnd) - (notes))) / (2)
    jp   nc, l13
    ; vector_music.c:236 l = ((a += a) += &notes); // Convert the musical note number to period by table
    add  a
    add  notes
    ld   l, a
    ; vector_music.c:237 h = ((a +@= [&notes >> 8]) -= l);
    adc  (notes) >> (8)
    sub  l
    ld   h, a
    ; vector_music.c:238 musicDelay = a = b; // The second byte is a delay
    ld   a, b
    ld   (musicDelay), a
    ; vector_music.c:239 c = *hl; hl++;
    ld   c, (hl)
    inc  hl
    ; vector_music.c:240 b = *hl;
    ld   b, (hl)
    ; vector_music.c:241 } else {
    jp   l14
l13:
    ; vector_music.c:242 // This is a delay
    ; vector_music.c:243 if (a == MUSIC_COMMAND_DELAY) {
    cp   129
    jp   nz, l15
    ; vector_music.c:244 musicDelay = a = b;  // The second byte is a delay
    ld   a, b
    ld   (musicDelay), a
    ; vector_music.c:245 bc = 0;
    ld   bc, 0
    ; vector_music.c:246 } else {
    jp   l16
l15:
    ; vector_music.c:247 // This is a subroutine
    ; vector_music.c:248 if (a == MUSIC_COMMAND_SUBROUTINE) {
    cp   132
    jp   nz, l17
    ; vector_music.c:249 a = b;  // The second byte is a subroutine repeat counter
    ld   a, b
    ; vector_music.c:250 a++;
    inc  a
    ; vector_music.c:251 musicSubRet = hl; 
    ld   (musicSubRet), hl
    ; vector_music.c:252 goto musicReturn; // Third and fourth bytes are a subroutine address
    jp   musicReturn
    ; vector_music.c:253 }
    ; vector_music.c:254 // This is the end of the subroutine
    ; vector_music.c:255 if (a == MUSIC_COMMAND_END_SUBROUTINE) {
l17:
    cp   133
    jp   nz, l18
    ; vector_music.c:256 hl = musicSubRet; // Read the subroutime start address from the main programm
    ld   hl, (musicSubRet)
    ; vector_music.c:257 a = musicSubRepeatCounter;
    ld   a, (musicSubRepeatCounter)
    ; vector_music.c:258 musicReturn:    e = *hl; hl++;
musicReturn:
    ld   e, (hl)
    inc  hl
    ; vector_music.c:259 d = *hl; hl++;
    ld   d, (hl)
    inc  hl
    ; vector_music.c:260 a--;  // Decrease the subroutime repeat counter
    dec  a
    ; vector_music.c:261 musicSubRepeatCounter = a;
    ld   (musicSubRepeatCounter), a
    ; vector_music.c:262 if (flag_nz) { // If the subroutime repeat counter is zero,
    jp   z, l19
    ; vector_music.c:263 swap(hl, de); // then change the subroutine start address to the main programm address
    ex de, hl
    ; vector_music.c:264 }
    ; vector_music.c:265 goto musicRetry;
l19:
    jp   musicRetry
    ; vector_music.c:266 }
    ; vector_music.c:267 // Any other command resets the music channel
    ; vector_music.c:268 pop(hl);
l18:
    pop  hl
    ; vector_music.c:269 pop(hl); // Remove the return address to the musicTick() function
    pop  hl
    ; vector_music.c:270 musicInit();
    call musicInit
    ; vector_music.c:271 return musicTick();
    jp   musicTick
    ; vector_music.c:272 }
l16:
    ; vector_music.c:273 }
l14:
    ; vector_music.c:274 
    ; vector_music.c:275 pop(de); // Save music channel state
    pop  de
    ; vector_music.c:276 push(bc);
    push bc
    ; vector_music.c:277 memcpy(de, hl = &musicDelay, c = [&music2Delay - &music1Delay]);
    ld   hl, musicDelay
    ld   c, (music2Delay) - (music1Delay)
    call memcpy
    ; vector_music.c:278 pop(hl);
    pop  hl
    ; vector_music.c:279 a ^= a; // Reset flag C for return
    xor  a
    ; vector_music.c:280 a = VI53_MODE_MEANDER;
    ld   a, 6
    ; vector_music.c:281 }
    ret
    ; vector_music.c:282 
    ; vector_music.c:283 // *** Music ***
    ; vector_music.c:284 
    ; vector_music.c:285 uint16_t notes[] = {
    ; vector_music.c:286 0x6AE0,
    ; vector_music.c:287 0x5F30,
    ; vector_music.c:288 0x59E0,
    ; vector_music.c:289 0x54D0,
    ; vector_music.c:290 0x5010,
    ; vector_music.c:291 0x4B90,
    ; vector_music.c:292 0x4750,
    ; vector_music.c:293 0x4350,
    ; vector_music.c:294 0x3F80,
    ; vector_music.c:295 0x3BF0,
    ; vector_music.c:296 0x3890,
    ; vector_music.c:297 0x3570,
    ; vector_music.c:298 0x3270,
    ; vector_music.c:299 0x2F90,
    ; vector_music.c:300 0x2CF0,
    ; vector_music.c:301 0x2A60,
    ; vector_music.c:302 0x2800,
    ; vector_music.c:303 0x25C0,
    ; vector_music.c:304 0x23A0,
    ; vector_music.c:305 0x21A0,
    ; vector_music.c:306 0x1FC0,
    ; vector_music.c:307 0x1DF0,
    ; vector_music.c:308 0x1C40,
    ; vector_music.c:309 0x1AB0,
    ; vector_music.c:310 0x1930,
    ; vector_music.c:311 0x17C0,
    ; vector_music.c:312 0x1670,
    ; vector_music.c:313 0x1520,
    ; vector_music.c:314 0x13F0,
    ; vector_music.c:315 0x12D0,
    ; vector_music.c:316 0x11C0,
    ; vector_music.c:317 0x10C0,
    ; vector_music.c:318 0x0FD0,
    ; vector_music.c:319 0x0EE0,
    ; vector_music.c:320 0x0E10,
    ; vector_music.c:321 0x0D40,
    ; vector_music.c:322 0x0C80,
    ; vector_music.c:323 0x0BD0,
    ; vector_music.c:324 0x0B20,
    ; vector_music.c:325 0x0A80,
    ; vector_music.c:326 0x09F0,
    ; vector_music.c:327 0x0960,
    ; vector_music.c:328 0x08D0,
    ; vector_music.c:329 0x0850,
    ; vector_music.c:330 0x07E0,
    ; vector_music.c:331 0x0760,
    ; vector_music.c:332 0x0700,
    ; vector_music.c:333 0x0690,
    ; vector_music.c:334 0x0630,
    ; vector_music.c:335 0x05E0,
    ; vector_music.c:336 0x0580,
    ; vector_music.c:337 0x0530,
    ; vector_music.c:338 0x04F0,
    ; vector_music.c:339 0x04A0,
    ; vector_music.c:340 0x0460,
    ; vector_music.c:341 0x0420,
    ; vector_music.c:342 0x03E0,
    ; vector_music.c:343 0x03A0,
    ; vector_music.c:344 0x0370,
    ; vector_music.c:345 0x0340,
    ; vector_music.c:346 0x0310,
    ; vector_music.c:347 0x02E0,
    ; vector_music.c:348 0x02B0,
    ; vector_music.c:349 0x0290,
    ; vector_music.c:350 0x0270,
    ; vector_music.c:351 0x0240,
    ; vector_music.c:352 0x0220,
    ; vector_music.c:353 0x0200,
    ; vector_music.c:354 0x01E0,
    ; vector_music.c:355 0x01C0,
    ; vector_music.c:356 0x01B0
    ; vector_music.c:357 };
notes:
    dw 27360
    dw 24368
    dw 23008
    dw 21712
    dw 20496
    dw 19344
    dw 18256
    dw 17232
    dw 16256
    dw 15344
    dw 14480
    dw 13680
    dw 12912
    dw 12176
    dw 11504
    dw 10848
    dw 10240
    dw 9664
    dw 9120
    dw 8608
    dw 8128
    dw 7664
    dw 7232
    dw 6832
    dw 6448
    dw 6080
    dw 5744
    dw 5408
    dw 5104
    dw 4816
    dw 4544
    dw 4288
    dw 4048
    dw 3808
    dw 3600
    dw 3392
    dw 3200
    dw 3024
    dw 2848
    dw 2688
    dw 2544
    dw 2400
    dw 2256
    dw 2128
    dw 2016
    dw 1888
    dw 1792
    dw 1680
    dw 1584
    dw 1504
    dw 1408
    dw 1328
    dw 1264
    dw 1184
    dw 1120
    dw 1056
    dw 992
    dw 928
    dw 880
    dw 832
    dw 784
    dw 736
    dw 688
    dw 656
    dw 624
    dw 576
    dw 544
    dw 512
    dw 480
    dw 448
    dw 432
    ; vector_music.c:358 notesEnd:
notesEnd:
    ; vector_music.c:359 
    ; vector_music.c:360 uint8_t musicChannel1[] = {
    ; vector_music.c:361 0x24, 0x60,
    ; vector_music.c:362 0x81, 0xC,
    ; vector_music.c:363 0x28, 0x30,
    ; vector_music.c:364 0x26, 0xC,
    ; vector_music.c:365 0x24, 0xC,
    ; vector_music.c:366 0x26, 0xC,
    ; vector_music.c:367 0x24, 0x48,
    ; vector_music.c:368 0x81, 0xC,
    ; vector_music.c:369 0x26, 0xC,
    ; vector_music.c:370 0x28, 0xC,
    ; vector_music.c:371 0x24, 0xC,
    ; vector_music.c:372 0x24, 0x60,
    ; vector_music.c:373 0x81, 0xC,
    ; vector_music.c:374 0x24, 0xC,
    ; vector_music.c:375 0x1F, 0x30,
    ; vector_music.c:376 0x23, 0x18,
    ; vector_music.c:377 0x26, 0x30,
    ; vector_music.c:378 0x28, 0x18,
    ; vector_music.c:379 0x24, 0x18,
    ; vector_music.c:380 0x24, 0x60,
    ; vector_music.c:381 0x81, 0xC,
    ; vector_music.c:382 0x26, 0xC,
    ; vector_music.c:383 0x24, 0x60,
    ; vector_music.c:384 0x81, 0xC,
    ; vector_music.c:385 0x1C, 0x18,
    ; vector_music.c:386 0x1D, 0xC,
    ; vector_music.c:387 0x1F, 0x90,
    ; vector_music.c:388 0x81, 0x90,
    ; vector_music.c:389 0x24, 0x60,
    ; vector_music.c:390 0x81, 0x18,
    ; vector_music.c:391 0x28, 0x24,
    ; vector_music.c:392 0x81, 6,
    ; vector_music.c:393 0x26, 6,
    ; vector_music.c:394 0x24, 6,
    ; vector_music.c:395 0x26, 6,
    ; vector_music.c:396 0x24, 0x60,
    ; vector_music.c:397 0x26, 0x18,
    ; vector_music.c:398 0x28, 6,
    ; vector_music.c:399 0x24, 6,
    ; vector_music.c:400 0x24, 6,
    ; vector_music.c:401 0x26, 6,
    ; vector_music.c:402 0x21, 0x60,
    ; vector_music.c:403 0x24, 0xC,
    ; vector_music.c:404 0x1F, 0x30,
    ; vector_music.c:405 0x23, 0x18,
    ; vector_music.c:406 0x26, 0x48,
    ; vector_music.c:407 0x28, 0xC,
    ; vector_music.c:408 0x24, 0xC,
    ; vector_music.c:409 0x26, 0xC,
    ; vector_music.c:410 0x24, 0x48,
    ; vector_music.c:411 0x28, 0x12,
    ; vector_music.c:412 0x26, 6,
    ; vector_music.c:413 0x24, 6,
    ; vector_music.c:414 0x26, 6,
    ; vector_music.c:415 0x24, 0x60,
    ; vector_music.c:416 0x81, 0x18,
    ; vector_music.c:417 0x24, 0x18,
    ; vector_music.c:418 0x2B, 0x90,
    ; vector_music.c:419 0x2F, 0x48,
    ; vector_music.c:420 0x2D, 6,
    ; vector_music.c:421 0x2F, 6,
    ; vector_music.c:422 0x2D, 6,
    ; vector_music.c:423 0x2B, 6,
    ; vector_music.c:424 0x2D, 6,
    ; vector_music.c:425 0x2B, 6,
    ; vector_music.c:426 0x29, 0x24,
    ; vector_music.c:427 0x28, 0x30,
    ; vector_music.c:428 0x24, 0x18,
    ; vector_music.c:429 0x1F, 0x90,
    ; vector_music.c:430 0x81, 0x48,
    ; vector_music.c:431 0x24, 0x30,
    ; vector_music.c:432 0x81, 6,
    ; vector_music.c:433 0x26, 6,
    ; vector_music.c:434 0x24, 6,
    ; vector_music.c:435 0x26, 6,
    ; vector_music.c:436 0x24, 0x48,
    ; vector_music.c:437 0x23, 0x12,
    ; vector_music.c:438 0x1F, 0x12,
    ; vector_music.c:439 0x1C, 0x60,
    ; vector_music.c:440 0x23, 0x48,
    ; vector_music.c:441 0x21, 0xC,
    ; vector_music.c:442 0x1D, 0xC,
    ; vector_music.c:443 0x1A, 0x30,
    ; vector_music.c:444 0x81, 0xC,
    ; vector_music.c:445 0x26, 0x48,
    ; vector_music.c:446 0x28, 0xC,
    ; vector_music.c:447 0x26, 0xC,
    ; vector_music.c:448 0x28, 0xC,
    ; vector_music.c:449 0x2B, 0xC,
    ; vector_music.c:450 0x2D, 0x12,
    ; vector_music.c:451 0x28, 6,
    ; vector_music.c:452 0x26, 6,
    ; vector_music.c:453 0x24, 6,
    ; vector_music.c:454 0x26, 6,
    ; vector_music.c:455 0x24, 0x90,
    ; vector_music.c:456 0x81, 0x7E,
    ; vector_music.c:457 0x84, 1, &F6B9, [&F6B9 >> 8],
    ; vector_music.c:458 0x26, 0xC,
    ; vector_music.c:459 0x24, 0xC,
    ; vector_music.c:460 0x28, 0xC,
    ; vector_music.c:461 0x2B, 0x24,
    ; vector_music.c:462 0x2D, 0xC,
    ; vector_music.c:463 0x28, 0xC,
    ; vector_music.c:464 0x24, 6,
    ; vector_music.c:465 0x26, 6,
    ; vector_music.c:466 0x24, 0x30,
    ; vector_music.c:467 0x81, 0xC,
    ; vector_music.c:468 0x84, 1, &F6B9, [&F6B9 >> 8],
    ; vector_music.c:469 0x28, 0xC,
    ; vector_music.c:470 0x26, 0xC,
    ; vector_music.c:471 0x24, 0x90,
    ; vector_music.c:472 0x86
    ; vector_music.c:473 };
musicChannel1:
    db 36
    db 96
    db 129
    db 12
    db 40
    db 48
    db 38
    db 12
    db 36
    db 12
    db 38
    db 12
    db 36
    db 72
    db 129
    db 12
    db 38
    db 12
    db 40
    db 12
    db 36
    db 12
    db 36
    db 96
    db 129
    db 12
    db 36
    db 12
    db 31
    db 48
    db 35
    db 24
    db 38
    db 48
    db 40
    db 24
    db 36
    db 24
    db 36
    db 96
    db 129
    db 12
    db 38
    db 12
    db 36
    db 96
    db 129
    db 12
    db 28
    db 24
    db 29
    db 12
    db 31
    db 144
    db 129
    db 144
    db 36
    db 96
    db 129
    db 24
    db 40
    db 36
    db 129
    db 6
    db 38
    db 6
    db 36
    db 6
    db 38
    db 6
    db 36
    db 96
    db 38
    db 24
    db 40
    db 6
    db 36
    db 6
    db 36
    db 6
    db 38
    db 6
    db 33
    db 96
    db 36
    db 12
    db 31
    db 48
    db 35
    db 24
    db 38
    db 72
    db 40
    db 12
    db 36
    db 12
    db 38
    db 12
    db 36
    db 72
    db 40
    db 18
    db 38
    db 6
    db 36
    db 6
    db 38
    db 6
    db 36
    db 96
    db 129
    db 24
    db 36
    db 24
    db 43
    db 144
    db 47
    db 72
    db 45
    db 6
    db 47
    db 6
    db 45
    db 6
    db 43
    db 6
    db 45
    db 6
    db 43
    db 6
    db 41
    db 36
    db 40
    db 48
    db 36
    db 24
    db 31
    db 144
    db 129
    db 72
    db 36
    db 48
    db 129
    db 6
    db 38
    db 6
    db 36
    db 6
    db 38
    db 6
    db 36
    db 72
    db 35
    db 18
    db 31
    db 18
    db 28
    db 96
    db 35
    db 72
    db 33
    db 12
    db 29
    db 12
    db 26
    db 48
    db 129
    db 12
    db 38
    db 72
    db 40
    db 12
    db 38
    db 12
    db 40
    db 12
    db 43
    db 12
    db 45
    db 18
    db 40
    db 6
    db 38
    db 6
    db 36
    db 6
    db 38
    db 6
    db 36
    db 144
    db 129
    db 126
    db 132
    db 1
    db F6B9
    db +((F6B9) >> (8))
    db 38
    db 12
    db 36
    db 12
    db 40
    db 12
    db 43
    db 36
    db 45
    db 12
    db 40
    db 12
    db 36
    db 6
    db 38
    db 6
    db 36
    db 48
    db 129
    db 12
    db 132
    db 1
    db F6B9
    db +((F6B9) >> (8))
    db 40
    db 12
    db 38
    db 12
    db 36
    db 144
    db 134
    ; vector_music.c:474 
    ; vector_music.c:475 uint8_t F6B9[] = {
    ; vector_music.c:476 0x1D, 0xC,
    ; vector_music.c:477 0x1F, 0x24,
    ; vector_music.c:478 0x21, 0xC,
    ; vector_music.c:479 0x24, 0xC,
    ; vector_music.c:480 0x23, 0x30,
    ; vector_music.c:481 0x24, 0xC,
    ; vector_music.c:482 0x23, 0xC,
    ; vector_music.c:483 0x21, 0x30,
    ; vector_music.c:484 0x1D, 0xC,
    ; vector_music.c:485 0x21, 0xC,
    ; vector_music.c:486 0x1F, 0x48,
    ; vector_music.c:487 0x1D, 0xC,
    ; vector_music.c:488 0x1F, 0x24,
    ; vector_music.c:489 0x21, 0xC,
    ; vector_music.c:490 0x24, 0xC,
    ; vector_music.c:491 0x26, 0x30,
    ; vector_music.c:492 0x85
    ; vector_music.c:493 };
F6B9:
    db 29
    db 12
    db 31
    db 36
    db 33
    db 12
    db 36
    db 12
    db 35
    db 48
    db 36
    db 12
    db 35
    db 12
    db 33
    db 48
    db 29
    db 12
    db 33
    db 12
    db 31
    db 72
    db 29
    db 12
    db 31
    db 36
    db 33
    db 12
    db 36
    db 12
    db 38
    db 48
    db 133
    ; vector_music.c:494 
    ; vector_music.c:495 uint8_t musicChannel2[] = {
    ; vector_music.c:496 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:497 0x84, 2, &F79E, [&F79E >> 8],
    ; vector_music.c:498 0x84, 2, &F7AB, [&F7AB >> 8],
    ; vector_music.c:499 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:500 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:501 0x84, 2, &F79E, [&F79E >> 8],
    ; vector_music.c:502 0x84, 2, &F7C5, [&F7C5 >> 8],
    ; vector_music.c:503 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:504 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:505 0x84, 2, &F79E, [&F79E >> 8],
    ; vector_music.c:506 0x84, 2, &F7AB, [&F7AB >> 8],
    ; vector_music.c:507 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:508 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:509 0x84, 2, &F79E, [&F79E >> 8],
    ; vector_music.c:510 0x84, 2, &F7C5, [&F7C5 >> 8],
    ; vector_music.c:511 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:512 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:513 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:514 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:515 0x10, 0xC,
    ; vector_music.c:516 0x13, 0xC,
    ; vector_music.c:517 0x17, 0xC,
    ; vector_music.c:518 0x1C, 0xC,
    ; vector_music.c:519 0x17, 0xC,
    ; vector_music.c:520 0x1F, 0xC,
    ; vector_music.c:521 0x84, 1, &F7C5, [&F7C5 >> 8],
    ; vector_music.c:522 0x11, 0xC,
    ; vector_music.c:523 0x15, 0xC,
    ; vector_music.c:524 0x18, 0xC,
    ; vector_music.c:525 0x1D, 0xC,
    ; vector_music.c:526 0xC, 0xC,
    ; vector_music.c:527 0x15, 0xC,
    ; vector_music.c:528 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:529 0x84, 2, &F7B8, [&F7B8 >> 8],
    ; vector_music.c:530 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:531 0x84, 2, &F7D2, [&F7D2 >> 8],
    ; vector_music.c:532 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:533 0x84, 1, &F7DF, [&F7DF >> 8],
    ; vector_music.c:534 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:535 0x84, 1, &F7EC, [&F7EC >> 8],
    ; vector_music.c:536 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:537 0x84, 1, &F7DF, [&F7DF >> 8],
    ; vector_music.c:538 0x84, 1, &F791, [&F791 >> 8],
    ; vector_music.c:539 0x84, 1, &F7D2, [&F7D2 >> 8],
    ; vector_music.c:540 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:541 0x84, 1, &F7DF, [&F7DF >> 8],
    ; vector_music.c:542 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:543 0x84, 1, &F7EC, [&F7EC >> 8],
    ; vector_music.c:544 0x84, 1, &F7AB, [&F7AB >> 8],
    ; vector_music.c:545 0x84, 1, &F7DF, [&F7DF >> 8],
    ; vector_music.c:546 0x84, 2, &F791, [&F791 >> 8],
    ; vector_music.c:547 0x86
    ; vector_music.c:548 };
musicChannel2:
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F79E
    db +((F79E) >> (8))
    db 132
    db 2
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F79E
    db +((F79E) >> (8))
    db 132
    db 2
    db F7C5
    db +((F7C5) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F79E
    db +((F79E) >> (8))
    db 132
    db 2
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F79E
    db +((F79E) >> (8))
    db 132
    db 2
    db F7C5
    db +((F7C5) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 16
    db 12
    db 19
    db 12
    db 23
    db 12
    db 28
    db 12
    db 23
    db 12
    db 31
    db 12
    db 132
    db 1
    db F7C5
    db +((F7C5) >> (8))
    db 17
    db 12
    db 21
    db 12
    db 24
    db 12
    db 29
    db 12
    db 12
    db 12
    db 21
    db 12
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 2
    db F7B8
    db +((F7B8) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 132
    db 2
    db F7D2
    db +((F7D2) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7DF
    db +((F7DF) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7EC
    db +((F7EC) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7DF
    db +((F7DF) >> (8))
    db 132
    db 1
    db F791
    db +((F791) >> (8))
    db 132
    db 1
    db F7D2
    db +((F7D2) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7DF
    db +((F7DF) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7EC
    db +((F7EC) >> (8))
    db 132
    db 1
    db F7AB
    db +((F7AB) >> (8))
    db 132
    db 1
    db F7DF
    db +((F7DF) >> (8))
    db 132
    db 2
    db F791
    db +((F791) >> (8))
    db 134
    ; vector_music.c:549 
    ; vector_music.c:550 uint8_t F791[] = {
    ; vector_music.c:551 0x18, 0xC,
    ; vector_music.c:552 0x1C, 0xC,
    ; vector_music.c:553 0x1F, 0xC,
    ; vector_music.c:554 0x24, 0xC,
    ; vector_music.c:555 0x1F, 0xC,
    ; vector_music.c:556 0x1C, 0xC,
    ; vector_music.c:557 0x85
    ; vector_music.c:558 };
F791:
    db 24
    db 12
    db 28
    db 12
    db 31
    db 12
    db 36
    db 12
    db 31
    db 12
    db 28
    db 12
    db 133
    ; vector_music.c:559 
    ; vector_music.c:560 uint8_t F79E[] = {
    ; vector_music.c:561 0x15, 0xC,
    ; vector_music.c:562 0x18, 0xC,
    ; vector_music.c:563 0x1C, 0xC,
    ; vector_music.c:564 0x21, 0xC,
    ; vector_music.c:565 0x1C, 0xC,
    ; vector_music.c:566 0x18, 0xC,
    ; vector_music.c:567 0x85
    ; vector_music.c:568 };
F79E:
    db 21
    db 12
    db 24
    db 12
    db 28
    db 12
    db 33
    db 12
    db 28
    db 12
    db 24
    db 12
    db 133
    ; vector_music.c:569 
    ; vector_music.c:570 uint8_t F7AB[] = {
    ; vector_music.c:571 0x11, 0xC,
    ; vector_music.c:572 0x15, 0xC,
    ; vector_music.c:573 0x18, 0xC,
    ; vector_music.c:574 0x1D, 0xC,
    ; vector_music.c:575 0x18, 0xC,
    ; vector_music.c:576 0x15, 0xC,
    ; vector_music.c:577 0x85
    ; vector_music.c:578 };
F7AB:
    db 17
    db 12
    db 21
    db 12
    db 24
    db 12
    db 29
    db 12
    db 24
    db 12
    db 21
    db 12
    db 133
    ; vector_music.c:579 
    ; vector_music.c:580 uint8_t F7B8[] = {
    ; vector_music.c:581 0x13, 0xC,
    ; vector_music.c:582 0x17, 0xC,
    ; vector_music.c:583 0x1A, 0xC,
    ; vector_music.c:584 0x1F, 0xC,
    ; vector_music.c:585 0x1A, 0xC,
    ; vector_music.c:586 0x17, 0xC,
    ; vector_music.c:587 0x85
    ; vector_music.c:588 };
F7B8:
    db 19
    db 12
    db 23
    db 12
    db 26
    db 12
    db 31
    db 12
    db 26
    db 12
    db 23
    db 12
    db 133
    ; vector_music.c:589 
    ; vector_music.c:590 uint8_t F7C5[] = {
    ; vector_music.c:591 0x10, 0xC,
    ; vector_music.c:592 0x13, 0xC,
    ; vector_music.c:593 0x17, 0xC,
    ; vector_music.c:594 0x1C, 0xC,
    ; vector_music.c:595 0x17, 0xC,
    ; vector_music.c:596 0x13, 0xC,
    ; vector_music.c:597 0x85
    ; vector_music.c:598 };
F7C5:
    db 16
    db 12
    db 19
    db 12
    db 23
    db 12
    db 28
    db 12
    db 23
    db 12
    db 19
    db 12
    db 133
    ; vector_music.c:599 
    ; vector_music.c:600 uint8_t F7D2[] = {
    ; vector_music.c:601 0x18, 0xC,
    ; vector_music.c:602 0x1C, 0xC,
    ; vector_music.c:603 0x1F, 0xC,
    ; vector_music.c:604 0x22, 0xC,
    ; vector_music.c:605 0x1F, 0xC,
    ; vector_music.c:606 0x1C, 0xC,
    ; vector_music.c:607 0x85
    ; vector_music.c:608 };
F7D2:
    db 24
    db 12
    db 28
    db 12
    db 31
    db 12
    db 34
    db 12
    db 31
    db 12
    db 28
    db 12
    db 133
    ; vector_music.c:609 
    ; vector_music.c:610 uint8_t F7DF[] = {
    ; vector_music.c:611 0x13, 0xC,
    ; vector_music.c:612 0x17, 0xC,
    ; vector_music.c:613 0x1A, 0xC,
    ; vector_music.c:614 0x1D, 0xC,
    ; vector_music.c:615 0x1A, 0xC,
    ; vector_music.c:616 0x17, 0xC,
    ; vector_music.c:617 0x85
    ; vector_music.c:618 };
F7DF:
    db 19
    db 12
    db 23
    db 12
    db 26
    db 12
    db 29
    db 12
    db 26
    db 12
    db 23
    db 12
    db 133
    ; vector_music.c:619 
    ; vector_music.c:620 uint8_t F7EC[] = {
    ; vector_music.c:621 0xF, 0xC,
    ; vector_music.c:622 0x13, 0xC,
    ; vector_music.c:623 0x16, 0xC,
    ; vector_music.c:624 0x1B, 0xC,
    ; vector_music.c:625 0x16, 0xC,
    ; vector_music.c:626 0x13, 0xC,
    ; vector_music.c:627 0x85
    ; vector_music.c:628 };
F7EC:
    db 15
    db 12
    db 19
    db 12
    db 22
    db 12
    db 27
    db 12
    db 22
    db 12
    db 19
    db 12
    db 133
    ; vector_music.c:629 
    ; vector_music.c:630 uint8_t musicChannel3[] = {
    ; vector_music.c:631 0x18, 0x90,
    ; vector_music.c:632 0x15, 0x90,
    ; vector_music.c:633 0x11, 0x90,
    ; vector_music.c:634 0x13, 0x90,
    ; vector_music.c:635 0x18, 0x90,
    ; vector_music.c:636 0x15, 0x90,
    ; vector_music.c:637 0x10, 0x90,
    ; vector_music.c:638 0x13, 0x24,
    ; vector_music.c:639 0x1F, 0x24,
    ; vector_music.c:640 0x23, 0x24,
    ; vector_music.c:641 0x26, 0x24,
    ; vector_music.c:642 0x1C, 0x24,
    ; vector_music.c:643 0x84, 1, &F856, [&F856 >> 8],
    ; vector_music.c:644 0x24, 0x48,
    ; vector_music.c:645 0x1D, 0x24,
    ; vector_music.c:646 0x26, 0x24,
    ; vector_music.c:647 0x24, 0x24,
    ; vector_music.c:648 0x23, 0x24,
    ; vector_music.c:649 0x1F, 0x24,
    ; vector_music.c:650 0x28, 0x24,
    ; vector_music.c:651 0x26, 0x24,
    ; vector_music.c:652 0x81, 0x24,
    ; vector_music.c:653 0x84, 1, &F856, [&F856 >> 8],
    ; vector_music.c:654 0x24, 0x24,
    ; vector_music.c:655 0x1F, 0x90,
    ; vector_music.c:656 0x26, 0x90,
    ; vector_music.c:657 0x24, 0x90,
    ; vector_music.c:658 0x23, 0x24,
    ; vector_music.c:659 0x1F, 0x24,
    ; vector_music.c:660 0x23, 0x24,
    ; vector_music.c:661 0x26, 0x24,
    ; vector_music.c:662 0x18, 0x90,
    ; vector_music.c:663 0x1C, 0x90,
    ; vector_music.c:664 0x1D, 0x90,
    ; vector_music.c:665 0x1F, 0x90,
    ; vector_music.c:666 0x18, 0x90,
    ; vector_music.c:667 0x81, 0x90,
    ; vector_music.c:668 0x84, 1, &F861, [&F861 >> 8],
    ; vector_music.c:669 0x16, 0x48,
    ; vector_music.c:670 0x84, 1, &F861, [&F861 >> 8],
    ; vector_music.c:671 0x18, 0x48,
    ; vector_music.c:672 0x86
    ; vector_music.c:673 };
musicChannel3:
    db 24
    db 144
    db 21
    db 144
    db 17
    db 144
    db 19
    db 144
    db 24
    db 144
    db 21
    db 144
    db 16
    db 144
    db 19
    db 36
    db 31
    db 36
    db 35
    db 36
    db 38
    db 36
    db 28
    db 36
    db 132
    db 1
    db F856
    db +((F856) >> (8))
    db 36
    db 72
    db 29
    db 36
    db 38
    db 36
    db 36
    db 36
    db 35
    db 36
    db 31
    db 36
    db 40
    db 36
    db 38
    db 36
    db 129
    db 36
    db 132
    db 1
    db F856
    db +((F856) >> (8))
    db 36
    db 36
    db 31
    db 144
    db 38
    db 144
    db 36
    db 144
    db 35
    db 36
    db 31
    db 36
    db 35
    db 36
    db 38
    db 36
    db 24
    db 144
    db 28
    db 144
    db 29
    db 144
    db 31
    db 144
    db 24
    db 144
    db 129
    db 144
    db 132
    db 1
    db F861
    db +((F861) >> (8))
    db 22
    db 72
    db 132
    db 1
    db F861
    db +((F861) >> (8))
    db 24
    db 72
    db 134
    ; vector_music.c:674 
    ; vector_music.c:675 uint8_t F856[] = {
    ; vector_music.c:676 0x1C, 0x24,
    ; vector_music.c:677 0x1F, 0x24,
    ; vector_music.c:678 0x24, 0x48,
    ; vector_music.c:679 0x1C, 0x24,
    ; vector_music.c:680 0x21, 0x24,
    ; vector_music.c:681 0x85
    ; vector_music.c:682 };
F856:
    db 28
    db 36
    db 31
    db 36
    db 36
    db 72
    db 28
    db 36
    db 33
    db 36
    db 133
    ; vector_music.c:683 
    ; vector_music.c:684 uint8_t F861[] = {
    ; vector_music.c:685 0x11, 0x48,
    ; vector_music.c:686 0x13, 0x48,
    ; vector_music.c:687 0x15, 0x48,
    ; vector_music.c:688 0x16, 0x48,
    ; vector_music.c:689 0x11, 0x48,
    ; vector_music.c:690 0x13, 0x48,
    ; vector_music.c:691 0x18, 0x48,
    ; vector_music.c:692 0x85
    ; vector_music.c:693 };
F861:
    db 17
    db 72
    db 19
    db 72
    db 21
    db 72
    db 22
    db 72
    db 17
    db 72
    db 19
    db 72
    db 24
    db 72
    db 133
    ; vector_music.c:694 
    ; vector_music.c:695 
