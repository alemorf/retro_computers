    ; ut88.cmm:2 // Восстановил Алексей Морозов, версия от 13-06-2020
    ; ut88.cmm:3 
    ; ut88.cmm:4 extern uint8_t outputFileBegin = 0xF800;
outputFileBegin=63488
    ; ut88.cmm:5 extern uint8_t outputFileEnd = 0x10000;
outputFileEnd=65536
    ; ut88.cmm:6 
    ; ut88.cmm:7 // Константы
    ; ut88.cmm:8 
    ; ut88.cmm:9 const int screenWidth        = 64;
    ; ut88.cmm:10 const int screenHeight       = 28;
    ; ut88.cmm:11 const int screenAddr         = 0xE800;
    ; ut88.cmm:12 const int screenAddrEnd2     = 0xF000;
    ; ut88.cmm:13 const int lastRamAddr        = 0xDFFF;
    ; ut88.cmm:14 const int initalStackAddr    = 0xF7AF;
    ; ut88.cmm:15 const int ioSysConfigValue   = 0x8B;
    ; ut88.cmm:16 const int ioUserConfigValue  = 0x82;
    ; ut88.cmm:17 const int tapeSpeedInitValue = 0x1D2A;
    ; ut88.cmm:18 
    ; ut88.cmm:19 // Системные переменные
    ; ut88.cmm:20 
    ; ut88.cmm:21 const int systemVariablesBegin = 0xF7B0;
    ; ut88.cmm:22 const int systemVariablesEnd   = 0xF7FF;
    ; ut88.cmm:23 
    ; ut88.cmm:24 extern uint16_t vCursorPos          = 0xF7B0;
vCursorPos=63408
    ; ut88.cmm:25 extern uint16_t vCursor             = 0xF7B2;
vCursor=63410
    ; ut88.cmm:26 extern uint16_t vBreakSavedPc       = 0xF7B4;
vBreakSavedPc=63412
    ; ut88.cmm:27 extern uint8_t  vBreakSavedHl       = 0xF7B6;
vBreakSavedHl=63414
    ; ut88.cmm:28 extern uint8_t  vBreakRegs          = 0xF7B8;
vBreakRegs=63416
    ; ut88.cmm:29 extern uint8_t  vInitalStackAddr    = 0xF7BC;
vInitalStackAddr=63420
    ; ut88.cmm:30 extern uint16_t vBreakSavedPsw      = 0xF7BE;
vBreakSavedPsw=63422
    ; ut88.cmm:31 extern uint16_t vSp                 = 0xF7C0;
vSp=63424
    ; ut88.cmm:32 extern uint8_t  vBreakAddr          = 0xF7C3;
vBreakAddr=63427
    ; ut88.cmm:33 extern uint8_t  vBreakPrevCmd       = 0xF7C5;
vBreakPrevCmd=63429
    ; ut88.cmm:34 extern uint8_t  vJmp                = 0xF7C6;
vJmp=63430
    ; ut88.cmm:35 extern uint16_t vCmdArg1            = 0xF7C7;
vCmdArg1=63431
    ; ut88.cmm:36 extern uint16_t vCmdArg2            = 0xF7C9;
vCmdArg2=63433
    ; ut88.cmm:37 extern uint16_t vCmdArg3            = 0xF7CB;
vCmdArg3=63435
    ; ut88.cmm:38 extern uint8_t  vCmdArg2Able        = 0xF7CD;
vCmdArg2Able=63437
    ; ut88.cmm:39 extern uint8_t  vTapeInverted       = 0xF7CE;
vTapeInverted=63438
    ; ut88.cmm:40 extern uint8_t  vTapeSpeedRd        = 0xF7CF;
vTapeSpeedRd=63439
    ; ut88.cmm:41 extern uint8_t  vTapeSpeedWr        = 0xF7D0;
vTapeSpeedWr=63440
    ; ut88.cmm:42 extern uint16_t vLastRamAddr        = 0xF7D1;
vLastRamAddr=63441
    ; ut88.cmm:43 extern uint8_t  vLineBuffer         = 0xF7D3; // Максимальная длина строки 31 байт без учета завершающего символа.
vLineBuffer=63443
    ; ut88.cmm:44 extern uint8_t  vLineBufferLastByte = 0xF7F2;
vLineBufferLastByte=63474
    ; ut88.cmm:45 extern uint8_t  vFirstPressCounter  = 0xF7F3;
vFirstPressCounter=63475
    ; ut88.cmm:46 extern uint8_t  vFirstPress         = 0xF7F4;
vFirstPress=63476
    ; ut88.cmm:47 extern uint8_t  vPutchEscMode       = 0xF7F8;
vPutchEscMode=63480
    ; ut88.cmm:48 
    ; ut88.cmm:49 // Вызов этих команд запускает подпрограммы по этим адресам
    ; ut88.cmm:50 
    ; ut88.cmm:51 extern uint8_t  cmdW = 0xC000;
cmdW=49152
    ; ut88.cmm:52 extern uint8_t  cmdU = 0xF000;
cmdU=61440
    ; ut88.cmm:53 
    ; ut88.cmm:54 // Порты ввода вывода
    ; ut88.cmm:55 
    ; ut88.cmm:56 const int ioSysConfig  = 0x04; // КР580ВВ55А. Системный порт и порт клавиатуры.
    ; ut88.cmm:57 const int ioSysC       = 0x05;
    ; ut88.cmm:58 const int ioSysB       = 0x06;
    ; ut88.cmm:59 const int ioSysA       = 0x07;
    ; ut88.cmm:60 const int ioTape       = 0xA1; // Порт накопителя на магнитной ленте.
    ; ut88.cmm:61 const int ioUserA      = 0xF8; // КР580ВВ55А. Пользовательский порт. Сюда подключается внешее ПЗУ.
    ; ut88.cmm:62 const int ioUserB      = 0xF9;
    ; ut88.cmm:63 const int ioUserC      = 0xFA;
    ; ut88.cmm:64 const int ioUserConfig = 0xFB;
    ; ut88.cmm:65 
    ; ut88.cmm:66 // Коды команд КР580ВМ80А
    ; ut88.cmm:67 
    ; ut88.cmm:68 const int opcodeJmp = 0xC3;
    ; ut88.cmm:69 const int opcodeRst6 = 0xF7;
    ; ut88.cmm:70 
    ; ut88.cmm:71 // Коды символов для putch, getch и inkey
    ; ut88.cmm:72 
    ; ut88.cmm:73 const int charCodeLeft        = 0x08;
    ; ut88.cmm:74 const int charCodeNextLine    = 0x0A;
    ; ut88.cmm:75 const int charCodeHome        = 0x0C;
    ; ut88.cmm:76 const int charCodeEnter       = 0x0D;
    ; ut88.cmm:77 const int charCodeRight       = 0x18;
    ; ut88.cmm:78 const int charCodeUp          = 0x19;
    ; ut88.cmm:79 const int charCodeDown        = 0x1A;
    ; ut88.cmm:80 const int charCodeEsc         = 0x1B;
    ; ut88.cmm:81 const int charCodeClearScreen = 0x1F;
    ; ut88.cmm:82 const int charCodeSpace       = 0x20;
    ; ut88.cmm:83 const int charCodeBackspace   = 0x7F;
    ; ut88.cmm:84 
    ; ut88.cmm:85 // Точки входа
    ; ut88.cmm:86 
    ; ut88.cmm:87 #org 0xF800
    ; ut88.cmm:88 
    org 63488
    ; ut88.cmm:89 void entryPoints()
entryPoints:
    ; ut88.cmm:90 {
    ; ut88.cmm:91 // Точки входа соответствуют Радио 86РК
    ; ut88.cmm:92 return reboot();
    jp   reboot
    ; ut88.cmm:93 return getch();
    jp   getch
    ; ut88.cmm:94 return tapeInput();
    jp   tapeInput
    ; ut88.cmm:95 return putch(c);
    jp   putch
    ; ut88.cmm:96 return tapeOutput(c);
    jp   tapeOutput
    ; ut88.cmm:97 return putch(c);
    jp   putch
    ; ut88.cmm:98 return isAnyKeyPressed();
    jp   isAnyKeyPressed
    ; ut88.cmm:99 return put8(a);
    jp   put8
    ; ut88.cmm:100 return puts(hl);
    jp   puts
    ; ut88.cmm:101 return inkey();
    jp   inkey
    ; ut88.cmm:102 return getCursor();
    jp   getCursor
    ; ut88.cmm:103 return getCursorChar();
    jp   getCursorChar
    ; ut88.cmm:104 return tapeInputFile(hl);
    jp   tapeInputFile
    ; ut88.cmm:105 return tapeOutputFile(hl, de, bc);
    jp   tapeOutputFile
    ; ut88.cmm:106 return calcSum(hl, de);
    jp   calcSum
    ; ut88.cmm:107 return; rst(0x38); rst(0x38); // Инициализация видеоконтроллера. Не требуется.
    ret
    rst 56
    rst 56
    ; ut88.cmm:108 return getLastRamAddr();
    jp   getLastRamAddr
    ; ut88.cmm:109 return setLastRamAddr(hl);
    jp   setLastRamAddr
    ; ut88.cmm:110 noreturn;
    ; ut88.cmm:111 }
    ; ut88.cmm:112 
    ; ut88.cmm:113 // Инициализация. Выполняется после перезагрузки или пользовательской программой.
    ; ut88.cmm:114 // Параметры: нет. Функция никогда не завершается.
    ; ut88.cmm:115 
    ; ut88.cmm:116 void reboot()
reboot:
    ; ut88.cmm:117 {
    ; ut88.cmm:118 out(ioSysConfig, a = ioSysConfigValue);
    ld   a, 139
    out  (4), a
    ; ut88.cmm:119 out(ioUserConfig, a = ioUserConfigValue);
    ld   a, 130
    out  (251), a
    ; ut88.cmm:120 sp = initalStackAddr;
    ld   sp, 63407
    ; ut88.cmm:121 cmdF(hl = systemVariablesBegin, de = systemVariablesEnd, c = 0);
    ld   hl, 63408
    ld   de, 63487
    ld   c, 0
    call cmdF
    ; ut88.cmm:122 vInitalStackAddr = hl = initalStackAddr;
    ld   hl, 63407
    ld   (vInitalStackAddr), hl
    ; ut88.cmm:123 puts(hl = &aClearUt88); // Очистка экрана и вывод *ЮТ/88*
    ld   hl, aClearUt88
    call puts
    ; ut88.cmm:124 nop(3);
    nop
    nop
    nop
    ; ut88.cmm:125 vLastRamAddr = hl = lastRamAddr;
    ld   hl, 57343
    ld   (vLastRamAddr), hl
    ; ut88.cmm:126 vTapeSpeedRd = hl = tapeSpeedInitValue;
    ld   hl, 7466
    ld   (vTapeSpeedRd), hl
    ; ut88.cmm:127 vJmp = a = opcodeJmp;
    ld   a, 195
    ld   (vJmp), a
    ; ut88.cmm:128 noreturn; // Продолжение в monitor
    ; ut88.cmm:129 }
    ; ut88.cmm:130 
    ; ut88.cmm:131 // Ввод команды пользователем и её выполнение. Выполнение любой команды возвращается к этой точке.
    ; ut88.cmm:132 // Параметры: нет. Функция никогда не завершается.
    ; ut88.cmm:133 
    ; ut88.cmm:134 void monitor()
monitor:
    ; ut88.cmm:135 {
    ; ut88.cmm:136 // Возвращаем стек на место
    ; ut88.cmm:137 sp = initalStackAddr;
    ld   sp, 63407
    ; ut88.cmm:138 
    ; ut88.cmm:139 // Перевод строки и вывод на экран =>
    ; ut88.cmm:140 puts(hl = &aCrLfPrompt);
    ld   hl, aCrLfPrompt
    call puts
    ; ut88.cmm:141 
    ; ut88.cmm:142 // Ввод строки в vLineBuffer
    ; ut88.cmm:143 nop(4);
    nop
    nop
    nop
    nop
    ; ut88.cmm:144 getLine();
    call getLine
    ; ut88.cmm:145 
    ; ut88.cmm:146 // После этого любая команда может вернуться в монитор выполнив ret
    ; ut88.cmm:147 hl = &monitor;
    ld   hl, monitor
    ; ut88.cmm:148 push(hl);
    push hl
    ; ut88.cmm:149 
    ; ut88.cmm:150 // Код введеной команды
    ; ut88.cmm:151 hl = &vLineBuffer;
    ld   hl, vLineBuffer
    ; ut88.cmm:152 a = *hl;
    ld   a, (hl)
    ; ut88.cmm:153 
    ; ut88.cmm:154 // Разбор команд
    ; ut88.cmm:155 if (a == 'X') return cmdX();
    cp   88
    jp   z, cmdX
    ; ut88.cmm:156 if (a == 'U') return cmdU();
    cp   85
    jp   z, cmdU
    ; ut88.cmm:157 
    ; ut88.cmm:158 // У команды может быть от 0 до 3-х параметров, 16-ричных чисел разделенных запятой
    ; ut88.cmm:159 push(a)
    ; ut88.cmm:160 {
    push af
    ; ut88.cmm:161 parseCommandArgs();
    call parseCommandArgs
    ; ut88.cmm:162 hl = vCmdArg3; c = l; b = h;
    ld   hl, (vCmdArg3)
    ld   c, l
    ld   b, h
    ; ut88.cmm:163 hl = vCmdArg2; swap(hl, de);
    ld   hl, (vCmdArg2)
    ex de, hl
    ; ut88.cmm:164 hl = vCmdArg1;
    ld   hl, (vCmdArg1)
    ; ut88.cmm:165 }
    pop  af
    ; ut88.cmm:166 
    ; ut88.cmm:167 // Разбор команд
    ; ut88.cmm:168 if (a == 'D') return cmdD(hl, de);
    cp   68
    jp   z, cmdD
    ; ut88.cmm:169 if (a == 'C') return cmdC(hl, de, bc);
    cp   67
    jp   z, cmdC
    ; ut88.cmm:170 if (a == 'F') return cmdF(hl, de, c);
    cp   70
    jp   z, cmdF
    ; ut88.cmm:171 if (a == 'S') return cmdS(hl, de, c);
    cp   83
    jp   z, cmdS
    ; ut88.cmm:172 if (a == 'T') return cmdT(hl, de, bc);
    cp   84
    jp   z, cmdT
    ; ut88.cmm:173 if (a == 'M') return cmdM(hl);
    cp   77
    jp   z, cmdM
    ; ut88.cmm:174 if (a == 'G') return cmdG(hl, de);
    cp   71
    jp   z, cmdG
    ; ut88.cmm:175 if (a == 'I') return cmdI(hl);
    cp   73
    jp   z, cmdI
    ; ut88.cmm:176 if (a == 'O') return cmdO(hl, de);
    cp   79
    jp   z, cmdO
    ; ut88.cmm:177 if (a == 'L') return cmdL(hl, de);
    cp   76
    jp   z, cmdL
    ; ut88.cmm:178 if (a == 'R') return cmdR(hl, de, bc);
    cp   82
    jp   z, cmdR
    ; ut88.cmm:179 
    ; ut88.cmm:180 // Продолжение разбора команд в следующей функции
    ; ut88.cmm:181 return monitor2(a, hl, de);
    jp   monitor2
    ; ut88.cmm:182 noreturn;
    ; ut88.cmm:183 }
    ; ut88.cmm:184 
    ; ut88.cmm:185 // Вспомогательная функция ввода строки с клавиатуры.
    ; ut88.cmm:186 
    ; ut88.cmm:187 void getLineBackspace()
getLineBackspace:
    ; ut88.cmm:188 {
    ; ut88.cmm:189 if ((a = 0x63) == l) goto getLine0; //! Ошибка. Тут должен быть адрес начала строки, т.е. &vLineBuffer.
    ld   a, 99
    cp   l
    jp   z, getLine0
    ; ut88.cmm:190 push(hl)
    ; ut88.cmm:191 {
    push hl
    ; ut88.cmm:192 puts(hl = &aBsSpBs);
    ld   hl, aBsSpBs
    call puts
    ; ut88.cmm:193 }
    pop  hl
    ; ut88.cmm:194 hl--;
    dec  hl
    ; ut88.cmm:195 //! Ошибка. Если строка пустая, то нужно обнулить b.
    ; ut88.cmm:196 goto getLineLoop;
    jp   getLineLoop
    ; ut88.cmm:197 noreturn;
    ; ut88.cmm:198 }
    ; ut88.cmm:199 
    ; ut88.cmm:200 // Ввод строки с клавиатуры.
    ; ut88.cmm:201 // Строка сохраняется по адресам vLineBuffer .. vLineBufferLastByte.
    ; ut88.cmm:202 // Параметры: нет. Результат de = адрес vLineBuffer, b = 0, cf - если строка не пустая
    ; ut88.cmm:203 
    ; ut88.cmm:204 void getLine()
getLine:
    ; ut88.cmm:205 {
    ; ut88.cmm:206 hl = &vLineBuffer;
    ld   hl, vLineBuffer
    ; ut88.cmm:207 getLine0:
getLine0:
    ; ut88.cmm:208 b = 0; // Признак пустой строки.
    ld   b, 0
    ; ut88.cmm:209 while ()
l0:
    ; ut88.cmm:210 {
    ; ut88.cmm:211 getLineLoop:
getLineLoop:
    ; ut88.cmm:212 getch();
    call getch
    ; ut88.cmm:213 if (a == charCodeLeft) goto getLineBackspace;
    cp   8
    jp   z, getLineBackspace
    ; ut88.cmm:214 if (a == charCodeBackspace) goto getLineBackspace;
    cp   127
    jp   z, getLineBackspace
    ; ut88.cmm:215 //! Плохо. Не надо выводить непечатные и управляющие символы.
    ; ut88.cmm:216 if (flag_nz) putchA(a); //! Лишнее условие, которое всегда истинно.
    call nz, putchA
    ; ut88.cmm:217 *hl = a;
    ld   (hl), a
    ; ut88.cmm:218 if (a == charCodeEnter) break;
    cp   13
    jp   z, l1
    ; ut88.cmm:219 if (a == '.') return monitor();
    cp   46
    jp   z, monitor
    ; ut88.cmm:220 b = 0xFF;
    ld   b, 255
    ; ut88.cmm:221 if ((a = &vLineBufferLastByte) == l) return error();
    ld   a, vLineBufferLastByte
    cp   l
    jp   z, error
    ; ut88.cmm:222 hl++;
    inc  hl
    ; ut88.cmm:223 }
    jp   l0
l1:
    ; ut88.cmm:224 (a = b) <<@= 1; // Признак пустой строки. 7-ой бит помещаем во флаг CF.
    ld   a, b
    rla
    ; ut88.cmm:225 
    ; ut88.cmm:226 // Результат
    ; ut88.cmm:227 de = &vLineBuffer;
    ld   de, vLineBuffer
    ; ut88.cmm:228 b = 0; //! Лишняя команда
    ld   b, 0
    ; ut88.cmm:229 }
    ret
    ; ut88.cmm:230 
    ; ut88.cmm:231 // Функция для пользовательской программы. Вывод строки на экран.
    ; ut88.cmm:232 // Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: bc, de.
    ; ut88.cmm:233 
    ; ut88.cmm:234 void puts(hl)
puts:
    ; ut88.cmm:235 {
    ; ut88.cmm:236 while ()
l2:
    ; ut88.cmm:237 {
    ; ut88.cmm:238 a = *hl;
    ld   a, (hl)
    ; ut88.cmm:239 if (flag_z a &= a) return;
    and  a
    ret  z
    ; ut88.cmm:240 putchA(a);
    call putchA
    ; ut88.cmm:241 hl++;
    inc  hl
    ; ut88.cmm:242 }
    jp   l2
l3:
    ; ut88.cmm:243 noreturn;
    ; ut88.cmm:244 }
    ; ut88.cmm:245 
    ; ut88.cmm:246 // Выделить из введенной пользователем строки пераметры в переменные vCmdArg*
    ; ut88.cmm:247 // Параметры: нет. В случае ошибки функция переходит на error, а затем на monitor.
    ; ut88.cmm:248 
    ; ut88.cmm:249 void parseCommandArgs()
parseCommandArgs:
    ; ut88.cmm:250 {
    ; ut88.cmm:251 // Зануление переменных vCmdArg*
    ; ut88.cmm:252 cmdF(hl = &vCmdArg1, de = &vCmdArg2Able, c = 0);
    ld   hl, vCmdArg1
    ld   de, vCmdArg2Able
    ld   c, 0
    call cmdF
    ; ut88.cmm:253 
    ; ut88.cmm:254 // Указатель на введенную команду. Первый байт это код команды, мы его пропускаем.
    ; ut88.cmm:255 de = [&vLineBuffer + 1];
    ld   de, (vLineBuffer) + (1)
    ; ut88.cmm:256 
    ; ut88.cmm:257 // Преобразование 1 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
    ; ut88.cmm:258 parseHexNumber16(de);
    call parseHexNumber16
    ; ut88.cmm:259 vCmdArg1 = hl;
    ld   (vCmdArg1), hl
    ; ut88.cmm:260 vCmdArg2 = hl;
    ld   (vCmdArg2), hl
    ; ut88.cmm:261 
    ; ut88.cmm:262 // В строке больше нет параметров
    ; ut88.cmm:263 if (flag_c) return;
    ret  c
    ; ut88.cmm:264 
    ; ut88.cmm:265 // Преобразование 2 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
    ; ut88.cmm:266 vCmdArg2Able = a = 0xFF;
    ld   a, 255
    ld   (vCmdArg2Able), a
    ; ut88.cmm:267 parseHexNumber16(de);
    call parseHexNumber16
    ; ut88.cmm:268 vCmdArg2 = hl;
    ld   (vCmdArg2), hl
    ; ut88.cmm:269 
    ; ut88.cmm:270 // В строке больше нет параметров
    ; ut88.cmm:271 if (flag_c) return;
    ret  c
    ; ut88.cmm:272 
    ; ut88.cmm:273 // Преобразование 3 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
    ; ut88.cmm:274 parseHexNumber16(de);
    call parseHexNumber16
    ; ut88.cmm:275 vCmdArg3 = hl;
    ld   (vCmdArg3), hl
    ; ut88.cmm:276 
    ; ut88.cmm:277 // В строке больше нет параметров
    ; ut88.cmm:278 if (flag_c) return;
    ret  c
    ; ut88.cmm:279 
    ; ut88.cmm:280 // Вывод ошибки, если в строке еще что то осталось. Эта функция переходит на monitor.
    ; ut88.cmm:281 return error();
    jp   error
    ; ut88.cmm:282 noreturn;
    ; ut88.cmm:283 }
    ; ut88.cmm:284 
    ; ut88.cmm:285 // Преобразовать строку содержащую 16 ричное 16 битное число в число.
    ; ut88.cmm:286 // Параметры: de - адрес стороки. Результат: hl - число, cf - если в строке больше ничего нет.
    ; ut88.cmm:287 
    ; ut88.cmm:288 void parseHexNumber16(de)
parseHexNumber16:
    ; ut88.cmm:289 {
    ; ut88.cmm:290 hl = 0;
    ld   hl, 0
    ; ut88.cmm:291 while ()
l4:
    ; ut88.cmm:292 {
    ; ut88.cmm:293 a = *de; de++;
    ld   a, (de)
    inc  de
    ; ut88.cmm:294 if (a == 0x0D) break;
    cp   13
    jp   z, l5
    ; ut88.cmm:295 if (a == ',') return; // выход с флагами z nc. //! Не проверяются лишние пробелы
    cp   44
    ret  z
    ; ut88.cmm:296 if (a == ' ') continue;
    cp   32
    jp   z, l4
    ; ut88.cmm:297 a -= '0';
    sub  48
    ; ut88.cmm:298 if (flag_m) return error(); // Если получилось отрицательное число
    jp   m, error
    ; ut88.cmm:299 if (a >=$ 10)
    cp   10
    ; ut88.cmm:300 {
    jp   m, l6
    ; ut88.cmm:301 if (a <$ ['A' - '0']) return error();
    cp   17
    jp   m, error
    ; ut88.cmm:302 if (a >=$ ['F' - '0' + 1]) return error();
    cp   23
    jp   p, error
    ; ut88.cmm:303 a -= ['A' - '0' - 10];
    sub  7
    ; ut88.cmm:304 }
    ; ut88.cmm:305 c = a;
l6:
    ld   c, a
    ; ut88.cmm:306 hl += hl += hl += hl += hl;
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, hl
    ; ut88.cmm:307 if (flag_c) return error(); //! Ошибка. Не все переполнения проверяются.
    jp   c, error
    ; ut88.cmm:308 hl += bc;
    add  hl, bc
    ; ut88.cmm:309 }
    jp   l4
l5:
    ; ut88.cmm:310 setFlagC();  // выход с флагами z c
    scf
    ; ut88.cmm:311 }
    ret
    ; ut88.cmm:312 
    ; ut88.cmm:313 // Сравить hl и de.
    ; ut88.cmm:314 // Параметры: hl, de - числа. Результат: флаги. Сохраняет: bc, hl, de.
    ; ut88.cmm:315 
    ; ut88.cmm:316 void cmdHlDe(hl, de)
cmdHlDe:
    ; ut88.cmm:317 {
    ; ut88.cmm:318 if ((a = h) != d) return;
    ld   a, h
    cp   d
    ret  nz
    ; ut88.cmm:319 (a = l) ? e;
    ld   a, l
    cp   e
    ; ut88.cmm:320 }
    ret
    ; ut88.cmm:321 
    ; ut88.cmm:322 // Если hl = de или пользователь нажал СТОП, то выйти из вызывающей функции.
    ; ut88.cmm:323 // Параметры: hl, de - числа. Результат: hl на 1 больше. Сохраняет: bc, de.
    ; ut88.cmm:324 
    ; ut88.cmm:325 void ifHlEqDeThenRetElseIncHlCanStop(hl, de)
ifHlEqDeThenRetElseIncHlCanStop:
    ; ut88.cmm:326 {
    ; ut88.cmm:327 stopByUser();
    call stopByUser
    ; ut88.cmm:328 noreturn; // Продолжение в ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:329 }
    ; ut88.cmm:330 
    ; ut88.cmm:331 // Если hl = de, то выйти из вызывающей функции.
    ; ut88.cmm:332 // Параметры: hl, de - числа. Результат: нет на 1 больше. Сохраняет: bc, de.
    ; ut88.cmm:333 
    ; ut88.cmm:334 void ifHlEqDeThenRetElseIncHl(hl, de)
ifHlEqDeThenRetElseIncHl:
    ; ut88.cmm:335 {
    ; ut88.cmm:336 cmdHlDe(hl, de);
    call cmdHlDe
    ; ut88.cmm:337 if (flag_z)
    ; ut88.cmm:338 {
    jp   nz, l7
    ; ut88.cmm:339 sp++;
    inc  sp
    ; ut88.cmm:340 sp++;
    inc  sp
    ; ut88.cmm:341 return;
    ret
    ; ut88.cmm:342 }
    ; ut88.cmm:343 hl++;
l7:
    inc  hl
    ; ut88.cmm:344 }
    ret
    ; ut88.cmm:345 
    ; ut88.cmm:346 // Возможность прерывания длительной функции пользователем.
    ; ut88.cmm:347 // Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:348 
    ; ut88.cmm:349 void stopByUser()
stopByUser:
    ; ut88.cmm:350 {
    ; ut88.cmm:351 a = 0xFF; //! Ошибка. Тут должна быть проверка нажатия какой то клавиши на клавиатуре.
    ld   a, 255
    ; ut88.cmm:352 a &= a;
    and  a
    ; ut88.cmm:353 if (a != 3) return;
    cp   3
    ret  nz
    ; ut88.cmm:354 return error();
    jp   error
    ; ut88.cmm:355 noreturn;
    ; ut88.cmm:356 }
    ; ut88.cmm:357 
    ; ut88.cmm:358 // Вывод на экран: перевод строки, отступ на 4 символа
    ; ut88.cmm:359 // Параметры: нет. Результат: нет. Сохраняет: a, bc, de, hl.
    ; ut88.cmm:360 
    ; ut88.cmm:361 void putCrLfTab()
putCrLfTab:
    ; ut88.cmm:362 {
    ; ut88.cmm:363 push(hl)
    ; ut88.cmm:364 {
    push hl
    ; ut88.cmm:365 puts(hl = &aCrLfTab);
    ld   hl, aCrLfTab
    call puts
    ; ut88.cmm:366 }
    pop  hl
    ; ut88.cmm:367 }
    ret
    ; ut88.cmm:368 
    ; ut88.cmm:369 // Вывод на экран: 8 битное число из памяти по адресу HL, пробел.
    ; ut88.cmm:370 // Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:371 
    ; ut88.cmm:372 void putMSp(hl)
putMSp:
    ; ut88.cmm:373 {
    ; ut88.cmm:374 a = *hl;
    ld   a, (hl)
    ; ut88.cmm:375 noreturn;
    ; ut88.cmm:376 }
    ; ut88.cmm:377 
    ; ut88.cmm:378 // Вывод на экран: 8 битное число из регистра А, пробел.
    ; ut88.cmm:379 // Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:380 
    ; ut88.cmm:381 void put8Sp(a)
put8Sp:
    ; ut88.cmm:382 {
    ; ut88.cmm:383 push(bc)
    ; ut88.cmm:384 {
    push bc
    ; ut88.cmm:385 put8(a);
    call put8
    ; ut88.cmm:386 putchA(a = ' ');
    ld   a, 32
    call putchA
    ; ut88.cmm:387 }
    pop  bc
    ; ut88.cmm:388 }
    ret
    ; ut88.cmm:389 
    ; ut88.cmm:390 // Команда D <начальный адрес> <конечный адрес>
    ; ut88.cmm:391 // Вывод блока данных из адресного пространства на экран в 16-ричном виде
    ; ut88.cmm:392 
    ; ut88.cmm:393 void cmdD(hl, de)
cmdD:
    ; ut88.cmm:394 {
    ; ut88.cmm:395 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:396 while ()
l8:
    ; ut88.cmm:397 {
    ; ut88.cmm:398 putMSp(hl);
    call putMSp
    ; ut88.cmm:399 ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    call ifHlEqDeThenRetElseIncHlCanStop
    ; ut88.cmm:400 if (flag_z (a = l) &= 0x0F) goto cmdD;
    ld   a, l
    and  15
    jp   z, cmdD
    ; ut88.cmm:401 }
    jp   l8
l9:
    ; ut88.cmm:402 noreturn;
    ; ut88.cmm:403 }
    ; ut88.cmm:404 
    ; ut88.cmm:405 // Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
    ; ut88.cmm:406 // Сравнить два блока адресного пространство
    ; ut88.cmm:407 
    ; ut88.cmm:408 void cmdC(hl, de, bc)
cmdC:
    ; ut88.cmm:409 {
    ; ut88.cmm:410 while ()
l10:
    ; ut88.cmm:411 {
    ; ut88.cmm:412 a = *bc;
    ld   a, (bc)
    ; ut88.cmm:413 if (a != *hl)
    cp   (hl)
    ; ut88.cmm:414 {
    jp   z, l12
    ; ut88.cmm:415 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:416 putMSp(hl);
    call putMSp
    ; ut88.cmm:417 put8Sp(a = *bc);
    ld   a, (bc)
    call put8Sp
    ; ut88.cmm:418 }
    ; ut88.cmm:419 bc++;
l12:
    inc  bc
    ; ut88.cmm:420 ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    call ifHlEqDeThenRetElseIncHlCanStop
    ; ut88.cmm:421 }
    jp   l10
l11:
    ; ut88.cmm:422 noreturn;
    ; ut88.cmm:423 }
    ; ut88.cmm:424 
    ; ut88.cmm:425 // Команда S <начальный адрес> <конечный адрес> <байт>
    ; ut88.cmm:426 // Заполнить блок в адресном пространстве одним байтом
    ; ut88.cmm:427 
    ; ut88.cmm:428 void cmdF(hl, de, c)
cmdF:
    ; ut88.cmm:429 {
    ; ut88.cmm:430 while ()
l13:
    ; ut88.cmm:431 {
    ; ut88.cmm:432 *hl = c;
    ld   (hl), c
    ; ut88.cmm:433 ifHlEqDeThenRetElseIncHl(hl, de);
    call ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:434 }
    jp   l13
l14:
    ; ut88.cmm:435 noreturn;
    ; ut88.cmm:436 }
    ; ut88.cmm:437 
    ; ut88.cmm:438 // Команда S <начальный адрес> <конечный адрес> <байт>
    ; ut88.cmm:439 // Найти байт (8 битное значение) в адресном пространстве
    ; ut88.cmm:440 
    ; ut88.cmm:441 void cmdS(hl, de, c)
cmdS:
    ; ut88.cmm:442 {
    ; ut88.cmm:443 while ()
l15:
    ; ut88.cmm:444 {
    ; ut88.cmm:445 if ((a = c) == *hl)
    ld   a, c
    cp   (hl)
    ; ut88.cmm:446 putCrLfTabHlSp(hl);
    call z, putCrLfTabHlSp
    ; ut88.cmm:447 ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    call ifHlEqDeThenRetElseIncHlCanStop
    ; ut88.cmm:448 }
    jp   l15
l16:
    ; ut88.cmm:449 noreturn;
    ; ut88.cmm:450 }
    ; ut88.cmm:451 
    ; ut88.cmm:452 // Команда S <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
    ; ut88.cmm:453 // Копировать блок в адресном пространстве
    ; ut88.cmm:454 
    ; ut88.cmm:455 void cmdT(hl, de, bc)
cmdT:
    ; ut88.cmm:456 {
    ; ut88.cmm:457 while ()
l17:
    ; ut88.cmm:458 {
    ; ut88.cmm:459 *bc = a = *hl;
    ld   a, (hl)
    ld   (bc), a
    ; ut88.cmm:460 bc++;
    inc  bc
    ; ut88.cmm:461 ifHlEqDeThenRetElseIncHl(hl, de);
    call ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:462 }
    jp   l17
l18:
    ; ut88.cmm:463 noreturn;
    ; ut88.cmm:464 }
    ; ut88.cmm:465 
    ; ut88.cmm:466 // Команда L <начальный адрес> <конечный адрес>
    ; ut88.cmm:467 // Вывести на экран адресное пространство в виде текста
    ; ut88.cmm:468 
    ; ut88.cmm:469 void cmdL(hl, de)
cmdL:
    ; ut88.cmm:470 {
    ; ut88.cmm:471 // Вывод адреса
    ; ut88.cmm:472 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:473 
    ; ut88.cmm:474 while ()
l19:
    ; ut88.cmm:475 {
    ; ut88.cmm:476 a = *hl;
    ld   a, (hl)
    ; ut88.cmm:477 if (flag_m a |= a) goto cmdL1;
    or   a
    jp   m, cmdL1
    ; ut88.cmm:478 if (a < ' ')
    cp   32
    ; ut88.cmm:479 {
    jp   nc, l21
    ; ut88.cmm:480 cmdL1:      a = '.';
cmdL1:
    ld   a, 46
    ; ut88.cmm:481 }
    ; ut88.cmm:482 putchA(a);
l21:
    call putchA
    ; ut88.cmm:483 ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    call ifHlEqDeThenRetElseIncHlCanStop
    ; ut88.cmm:484 if (flag_z (a = l) &= 0xF) goto cmdL;
    ld   a, l
    and  15
    jp   z, cmdL
    ; ut88.cmm:485 }
    jp   l19
l20:
    ; ut88.cmm:486 noreturn;
    ; ut88.cmm:487 }
    ; ut88.cmm:488 
    ; ut88.cmm:489 // Команда M <начальный адрес>
    ; ut88.cmm:490 // Вывести на экран адресное пространство побайтно с возможностью изменения
    ; ut88.cmm:491 
    ; ut88.cmm:492 void cmdM(hl)
cmdM:
    ; ut88.cmm:493 {
    ; ut88.cmm:494 while ()
l22:
    ; ut88.cmm:495 {
    ; ut88.cmm:496 // Вывод адреса
    ; ut88.cmm:497 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:498 
    ; ut88.cmm:499 // Вывод значения по этому адресу
    ; ut88.cmm:500 putMSp(hl);
    call putMSp
    ; ut88.cmm:501 
    ; ut88.cmm:502 // Ввод строки пользователем
    ; ut88.cmm:503 push(hl)
    ; ut88.cmm:504 {
    push hl
    ; ut88.cmm:505 getLine();
    call getLine
    ; ut88.cmm:506 }
    pop  hl
    ; ut88.cmm:507 
    ; ut88.cmm:508 // Если пользователь ввел строку, то преобразуем её в число и записываем его в память
    ; ut88.cmm:509 if (flag_c)
    ; ut88.cmm:510 {
    jp   nc, l24
    ; ut88.cmm:511 push(hl)
    ; ut88.cmm:512 {
    push hl
    ; ut88.cmm:513 parseHexNumber16();
    call parseHexNumber16
    ; ut88.cmm:514 a = l;
    ld   a, l
    ; ut88.cmm:515 }
    pop  hl
    ; ut88.cmm:516 *hl = a;
    ld   (hl), a
    ; ut88.cmm:517 }
    ; ut88.cmm:518 
    ; ut88.cmm:519 // Следующий цикл
    ; ut88.cmm:520 hl++;
l24:
    inc  hl
    ; ut88.cmm:521 }
    jp   l22
l23:
    ; ut88.cmm:522 noreturn;
    ; ut88.cmm:523 }
    ; ut88.cmm:524 
    ; ut88.cmm:525 // Команда G <начальный адрес> <конечный адрес>
    ; ut88.cmm:526 // Запуск программы и возможным указанием точки останова.
    ; ut88.cmm:527 
    ; ut88.cmm:528 void cmdG(hl, de)
cmdG:
    ; ut88.cmm:529 {
    ; ut88.cmm:530 // Нужна точка останова?
    ; ut88.cmm:531 cmdHlDe();
    call cmdHlDe
    ; ut88.cmm:532 if (flag_nz)
    ; ut88.cmm:533 {
    jp   z, l25
    ; ut88.cmm:534 swap(hl, de);
    ex de, hl
    ; ut88.cmm:535 vBreakAddr = hl;
    ld   (vBreakAddr), hl
    ; ut88.cmm:536 vBreakPrevCmd = a = *hl;
    ld   a, (hl)
    ld   (vBreakPrevCmd), a
    ; ut88.cmm:537 *hl = opcodeRst6;
    ld   (hl), 247
    ; ut88.cmm:538 *0x30 = a = opcodeJmp;
    ld   a, 195
    ld   (48), a
    ; ut88.cmm:539 *0x31 = hl = &breakHandler;
    ld   hl, breakHandler
    ld   (49), hl
    ; ut88.cmm:540 }
    ; ut88.cmm:541 
    ; ut88.cmm:542 // Восстановление регистров
    ; ut88.cmm:543 sp = &vBreakRegs;
l25:
    ld   sp, vBreakRegs
    ; ut88.cmm:544 pop(a, hl, de, bc);
    pop  bc
    pop  de
    pop  hl
    pop  af
    ; ut88.cmm:545 sp = hl;
    ld   sp, hl
    ; ut88.cmm:546 hl = vBreakSavedHl;
    ld   hl, (vBreakSavedHl)
    ; ut88.cmm:547 
    ; ut88.cmm:548 // Запуск
    ; ut88.cmm:549 return vJmp();
    jp   vJmp
    ; ut88.cmm:550 noreturn;
    ; ut88.cmm:551 }
    ; ut88.cmm:552 
    ; ut88.cmm:553 // Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
    ; ut88.cmm:554 // Скопировать блок из внешнего ПЗУ в адресное пространство процессора
    ; ut88.cmm:555 
    ; ut88.cmm:556 void cmdR(hl, de, bc)
cmdR:
    ; ut88.cmm:557 {
    ; ut88.cmm:558 out(ioUserC, a = h);
    ld   a, h
    out  (250), a
    ; ut88.cmm:559 while ()
l26:
    ; ut88.cmm:560 {
    ; ut88.cmm:561 out(ioUserB, a = l);
    ld   a, l
    out  (249), a
    ; ut88.cmm:562 *bc = a = in(ioUserA);
    in   a, (248)
    ld   (bc), a
    ; ut88.cmm:563 bc++;
    inc  bc
    ; ut88.cmm:564 ifHlEqDeThenRetElseIncHl(hl, de);
    call ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:565 }
    jp   l26
l27:
    ; ut88.cmm:566 noreturn;
    ; ut88.cmm:567 }
    ; ut88.cmm:568 
    ; ut88.cmm:569 // Функция для пользовательской программы. Получить координаты курсора.
    ; ut88.cmm:570 // Параметры: нет. Результат: hl - координаты курсора. Сохраняет регистры: bc, de, hl.
    ; ut88.cmm:571 
    ; ut88.cmm:572 void getCursor()
getCursor:
    ; ut88.cmm:573 {
    ; ut88.cmm:574 hl = vCursorPos;
    ld   hl, (vCursorPos)
    ; ut88.cmm:575 }
    ret
    ; ut88.cmm:576 
    ; ut88.cmm:577 // Функция для пользовательской программы. Получить символ под курсором
    ; ut88.cmm:578 // Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.
    ; ut88.cmm:579 
    ; ut88.cmm:580 void getCursorChar()
getCursorChar:
    ; ut88.cmm:581 {
    ; ut88.cmm:582 push(hl)
    ; ut88.cmm:583 {
    push hl
    ; ut88.cmm:584 hl = vCursorPos; //! Ошибка. Тут нужно выполнить vCursor.
    ld   hl, (vCursorPos)
    ; ut88.cmm:585 a = *hl;
    ld   a, (hl)
    ; ut88.cmm:586 }
    pop  hl
    ; ut88.cmm:587 }
    ret
    ; ut88.cmm:588 
    ; ut88.cmm:589 // Команда I <смещение> <скорость>
    ; ut88.cmm:590 // Загрузить файл с магнитной ленты
    ; ut88.cmm:591 
    ; ut88.cmm:592 void cmdI(hl, de)
cmdI:
    ; ut88.cmm:593 {
    ; ut88.cmm:594 // Если скорость указана, то сохраняем её в системную переменную.
    ; ut88.cmm:595 if ((a = vCmdArg2Able) != 0)
    ld   a, (vCmdArg2Able)
    or   a
    ; ut88.cmm:596 {
    jp   z, l28
    ; ut88.cmm:597 vTapeSpeedRd = a = e;
    ld   a, e
    ld   (vTapeSpeedRd), a
    ; ut88.cmm:598 }
    ; ut88.cmm:599 
    ; ut88.cmm:600 // Загрузить файл с магнитной ленты
    ; ut88.cmm:601 tapeInputFile(hl);
l28:
    call tapeInputFile
    ; ut88.cmm:602 
    ; ut88.cmm:603 // Вывод адреса первого и последнего байта
    ; ut88.cmm:604 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:605 swap(de, hl);
    ex de, hl
    ; ut88.cmm:606 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:607 swap(de, hl);
    ex de, hl
    ; ut88.cmm:608 
    ; ut88.cmm:609 // Расчет и вывод контрольной суммы
    ; ut88.cmm:610 push(bc);
    push bc
    ; ut88.cmm:611 calcSum(hl, de);
    call calcSum
    ; ut88.cmm:612 hl = bc;
    ld   h, b
    ld   l, c
    ; ut88.cmm:613 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:614 pop(de);
    pop  de
    ; ut88.cmm:615 
    ; ut88.cmm:616 // Если прочитанная из файла и вычисленная контрольная суммы совпадают, то возвращаемся в монитор.
    ; ut88.cmm:617 cmdHlDe();
    call cmdHlDe
    ; ut88.cmm:618 if (flag_z) return;
    ret  z
    ; ut88.cmm:619 
    ; ut88.cmm:620 // В случае ошибки выводим 4-ое число - ожидаемую контрольную сумму и текст ошибки
    ; ut88.cmm:621 swap(de, hl);
    ex de, hl
    ; ut88.cmm:622 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:623 
    ; ut88.cmm:624 noreturn; // Продолжение на error
    ; ut88.cmm:625 }
    ; ut88.cmm:626 
    ; ut88.cmm:627 // Вывести сообщение об ошибке на экран и перейти в Монитор
    ; ut88.cmm:628 
    ; ut88.cmm:629 void error()
error:
    ; ut88.cmm:630 {
    ; ut88.cmm:631 putchA(a = '?'); //! Лучше тут написать ОШИБКА
    ld   a, 63
    call putchA
    ; ut88.cmm:632 return monitor();
    jp   monitor
    ; ut88.cmm:633 noreturn;
    ; ut88.cmm:634 }
    ; ut88.cmm:635 
    ; ut88.cmm:636 // Функция для пользовательской программы. Загрузить файл с магнитной ленты.
    ; ut88.cmm:637 // Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки
    ; ut88.cmm:638 
    ; ut88.cmm:639 void tapeInputFile(hl)
tapeInputFile:
    ; ut88.cmm:640 {
    ; ut88.cmm:641 // Ожидание начала блока данных на магнитной ленте и чтение 16 бит, это начальный адрес.
    ; ut88.cmm:642 tapeInputBcEx(a = 0xFF);
    ld   a, 255
    call tapeInputBcEx
    ; ut88.cmm:643 push(hl)
    ; ut88.cmm:644 {
    push hl
    ; ut88.cmm:645 // Прибавляем смещение загрузки, адрес загрузки временно в de
    ; ut88.cmm:646 hl += bc;
    add  hl, bc
    ; ut88.cmm:647 swap(hl, de);
    ex de, hl
    ; ut88.cmm:648 // Чтение 16 бит, это конечный адрес.
    ; ut88.cmm:649 tapeInputBc();
    call tapeInputBc
    ; ut88.cmm:650 }
    pop  hl
    ; ut88.cmm:651 // Прибавляем смещение загрузки к конечному адресу, он теперь в de, а начальный адрес в HL
    ; ut88.cmm:652 hl += bc;
    add  hl, bc
    ; ut88.cmm:653 swap(hl, de);
    ex de, hl
    ; ut88.cmm:654 push(hl)
    ; ut88.cmm:655 {
    push hl
    ; ut88.cmm:656 // Чтение данных
    ; ut88.cmm:657 tapeReadBlock(hl, de);
    call tapeReadBlock
    ; ut88.cmm:658 
    ; ut88.cmm:659 // Ожидание начала блока данных на магнитной ленте и чтение 16 бит, это контрольная сумма.
    ; ut88.cmm:660 tapeInputBcEx(a = 0xFF);
    ld   a, 255
    call tapeInputBcEx
    ; ut88.cmm:661 }
    pop  hl
    ; ut88.cmm:662 }
    ret
    ; ut88.cmm:663 
    ; ut88.cmm:664 // Неиспользуемая функция. Похоже на очистку экрана.
    ; ut88.cmm:665 
    ; ut88.cmm:666 void FAC6()
FAC6:
    ; ut88.cmm:667 {
    ; ut88.cmm:668 b = 0;
    ld   b, 0
    ; ut88.cmm:669 do
l29:
    ; ut88.cmm:670 {
    ; ut88.cmm:671 *hl = b;
    ld   (hl), b
    ; ut88.cmm:672 hl++;
    inc  hl
    ; ut88.cmm:673 } while ((a = h) != 0xF0);
    ld   a, h
    cp   240
    jp   nz, l29
l30:
    ; ut88.cmm:674 pop(hl, de);
    pop  de
    pop  hl
    ; ut88.cmm:675 }
    ret
    ; ut88.cmm:676 
    ; ut88.cmm:677 // Используется при перезагрузке. Очистка экрана и вывод текста *ЮТ/88*.
    ; ut88.cmm:678 
    ; ut88.cmm:679 uint8_t aClearUt88[1] = { "\x1F\x1A*`t/88*" };
aClearUt88:
    db 31, 26, "*`t/88*", 0
    ; ut88.cmm:680 
    ; ut88.cmm:681 // Загрузка 16 битного числа с магнитной ленты без синхронизации
    ; ut88.cmm:682 // Параметры: нет. Результат: bc - значение. Сохраяет: de, hl
    ; ut88.cmm:683 
    ; ut88.cmm:684 void tapeInputBc()
tapeInputBc:
    ; ut88.cmm:685 {
    ; ut88.cmm:686 a = 8;
    ld   a, 8
    ; ut88.cmm:687 noreturn;
    ; ut88.cmm:688 }
    ; ut88.cmm:689 
    ; ut88.cmm:690 // Загрузка 16 битного числа с магнитной ленты с синхронизацией
    ; ut88.cmm:691 // Параметры: a = 0xFF. Результат: bc - значение. Сохраяет: de, hl
    ; ut88.cmm:692 
    ; ut88.cmm:693 void tapeInputBcEx(a)
tapeInputBcEx:
    ; ut88.cmm:694 {
    ; ut88.cmm:695 tapeInput(a);
    call tapeInput
    ; ut88.cmm:696 b = a;
    ld   b, a
    ; ut88.cmm:697 tapeInput(a = 8);
    ld   a, 8
    call tapeInput
    ; ut88.cmm:698 c = a;
    ld   c, a
    ; ut88.cmm:699 }
    ret
    ; ut88.cmm:700 
    ; ut88.cmm:701 // Загрузка блока данных с магнитной ленты.
    ; ut88.cmm:702 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: нет. Сохраяет: de.
    ; ut88.cmm:703 
    ; ut88.cmm:704 void tapeReadBlock(hl, de)
tapeReadBlock:
    ; ut88.cmm:705 {
    ; ut88.cmm:706 while ()
l31:
    ; ut88.cmm:707 {
    ; ut88.cmm:708 tapeInput(a = 8);
    ld   a, 8
    call tapeInput
    ; ut88.cmm:709 *hl = a;
    ld   (hl), a
    ; ut88.cmm:710 ifHlEqDeThenRetElseIncHl(hl, de);
    call ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:711 }
    jp   l31
l32:
    ; ut88.cmm:712 noreturn;
    ; ut88.cmm:713 }
    ; ut88.cmm:714 
    ; ut88.cmm:715 // Функция для пользовательской программы. Вычистить 16-битную сумму всех байт по адресам hl..de.
    ; ut88.cmm:716 // Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.
    ; ut88.cmm:717 
    ; ut88.cmm:718 void calcSum(de, hl)
calcSum:
    ; ut88.cmm:719 {
    ; ut88.cmm:720 bc = 0;
    ld   bc, 0
    ; ut88.cmm:721 while ()
l33:
    ; ut88.cmm:722 {
    ; ut88.cmm:723 c = ((a = *hl) += c);
    ld   a, (hl)
    add  c
    ld   c, a
    ; ut88.cmm:724 if (flag_c) b++;
    jp   nc, l35
    inc  b
    ; ut88.cmm:725 cmdHlDe();
l35:
    call cmdHlDe
    ; ut88.cmm:726 if (flag_z) return;
    ret  z
    ; ut88.cmm:727 hl++;
    inc  hl
    ; ut88.cmm:728 }
    jp   l33
l34:
    ; ut88.cmm:729 noreturn;
    ; ut88.cmm:730 }
    ; ut88.cmm:731 
    ; ut88.cmm:732 // Команда O <начальный адрес> <конечный адрес> <скорость>
    ; ut88.cmm:733 // Сохранить блок данных на магнитную ленту
    ; ut88.cmm:734 
    ; ut88.cmm:735 void cmdO(c)
cmdO:
    ; ut88.cmm:736 {
    ; ut88.cmm:737 // Если скорость указана, то сохраняем её в системную переменную.
    ; ut88.cmm:738 if ((a = c) != 0)
    ld   a, c
    or   a
    ; ut88.cmm:739 {
    jp   z, l36
    ; ut88.cmm:740 vTapeSpeedWr = a;
    ld   (vTapeSpeedWr), a
    ; ut88.cmm:741 }
    ; ut88.cmm:742 
    ; ut88.cmm:743 // Расчет контрольной суммы в bc
    ; ut88.cmm:744 push(hl)
l36:
    ; ut88.cmm:745 {
    push hl
    ; ut88.cmm:746 calcSum(hl, de);
    call calcSum
    ; ut88.cmm:747 }
    pop  hl
    ; ut88.cmm:748 
    ; ut88.cmm:749 // Вывод на экран начального адреса, конечного адреса и контрольной суммы
    ; ut88.cmm:750 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:751 swap(de, hl);
    ex de, hl
    ; ut88.cmm:752 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:753 swap(de, hl);
    ex de, hl
    ; ut88.cmm:754 push(hl)
    ; ut88.cmm:755 {
    push hl
    ; ut88.cmm:756 putCrLfTabHlSp(hl = bc);
    ld   h, b
    ld   l, c
    call putCrLfTabHlSp
    ; ut88.cmm:757 }
    pop  hl
    ; ut88.cmm:758 
    ; ut88.cmm:759 // Продолжение в tapeOutputFile
    ; ut88.cmm:760 noreturn;
    ; ut88.cmm:761 }
    ; ut88.cmm:762 
    ; ut88.cmm:763 // Функция для пользовательской программы. Запись файла на магнитную ленту.
    ; ut88.cmm:764 // Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.
    ; ut88.cmm:765 
    ; ut88.cmm:766 void tapeOutputFile(de, hl, bc)
tapeOutputFile:
    ; ut88.cmm:767 {
    ; ut88.cmm:768 // Сохраняем в стеке контрольную сумму
    ; ut88.cmm:769 push(bc);
    push bc
    ; ut88.cmm:770 
    ; ut88.cmm:771 // Запись пилот тона
    ; ut88.cmm:772 bc = 0;
    ld   bc, 0
    ; ut88.cmm:773 do
l37:
    ; ut88.cmm:774 {
    ; ut88.cmm:775 tapeOutput(c); // на входе c = 0
    call tapeOutput
    ; ut88.cmm:776 b--;
    dec  b
    ; ut88.cmm:777 swap(*sp, hl);
    ex   (sp), hl
    ; ut88.cmm:778 swap(*sp, hl);
    ex   (sp), hl
    ; ut88.cmm:779 } while (flag_nz);
    jp   nz, l37
l38:
    ; ut88.cmm:780 
    ; ut88.cmm:781 // Запись стартового байта
    ; ut88.cmm:782 tapeOutput(c = 0xE6);
    ld   c, 230
    call tapeOutput
    ; ut88.cmm:783 
    ; ut88.cmm:784 // Запись адреса первого байта
    ; ut88.cmm:785 tapeOutputHl(hl);
    call tapeOutputHl
    ; ut88.cmm:786 
    ; ut88.cmm:787 // Запись адреса последнего байта
    ; ut88.cmm:788 swap(hl, de);
    ex de, hl
    ; ut88.cmm:789 tapeOutputHl(hl);
    call tapeOutputHl
    ; ut88.cmm:790 swap(hl, de);
    ex de, hl
    ; ut88.cmm:791 
    ; ut88.cmm:792 // Запись данных
    ; ut88.cmm:793 tapeOutputBlock(hl, de);
    call tapeOutputBlock
    ; ut88.cmm:794 
    ; ut88.cmm:795 // Запись пилот тона
    ; ut88.cmm:796 tapeOutputHl(hl = 0);
    ld   hl, 0
    call tapeOutputHl
    ; ut88.cmm:797 
    ; ut88.cmm:798 // Запись стартового байта
    ; ut88.cmm:799 tapeOutput(c = 0xE6);
    ld   c, 230
    call tapeOutput
    ; ut88.cmm:800 
    ; ut88.cmm:801 // Запись контрольной суммы
    ; ut88.cmm:802 pop(hl);
    pop  hl
    ; ut88.cmm:803 tapeOutputHl(hl);
    call tapeOutputHl
    ; ut88.cmm:804 }
    ret
    ; ut88.cmm:805 
    ; ut88.cmm:806 // Вывод на экран: перевод строки, отступ на 4 символа, 16 битное число, пробел.
    ; ut88.cmm:807 // Параметры: hl - число. Результат: нет. Сохраняет: bc
    ; ut88.cmm:808 
    ; ut88.cmm:809 void putCrLfTabHlSp(hl)
putCrLfTabHlSp:
    ; ut88.cmm:810 {
    ; ut88.cmm:811 push(bc)
    ; ut88.cmm:812 {
    push bc
    ; ut88.cmm:813 putCrLfTab();
    call putCrLfTab
    ; ut88.cmm:814 put8(a = h);
    ld   a, h
    call put8
    ; ut88.cmm:815 put8Sp(a = l);
    ld   a, l
    call put8Sp
    ; ut88.cmm:816 }
    pop  bc
    ; ut88.cmm:817 }
    ret
    ; ut88.cmm:818 
    ; ut88.cmm:819 // Запись блока на магнитную ленту.
    ; ut88.cmm:820 // Параметры: de - начальный адрес, hl - конечный адрес.
    ; ut88.cmm:821 
    ; ut88.cmm:822 void tapeOutputBlock(hl, de)
tapeOutputBlock:
    ; ut88.cmm:823 {
    ; ut88.cmm:824 while ()
l39:
    ; ut88.cmm:825 {
    ; ut88.cmm:826 tapeOutput(c = *hl);
    ld   c, (hl)
    call tapeOutput
    ; ut88.cmm:827 ifHlEqDeThenRetElseIncHl(hl, de);
    call ifHlEqDeThenRetElseIncHl
    ; ut88.cmm:828 }
    jp   l39
l40:
    ; ut88.cmm:829 noreturn;
    ; ut88.cmm:830 }
    ; ut88.cmm:831 
    ; ut88.cmm:832 // Запись 16 битного числа на магнитную ленту.
    ; ut88.cmm:833 // Параметры: hl - число.
    ; ut88.cmm:834 
    ; ut88.cmm:835 void tapeOutputHl(hl)
tapeOutputHl:
    ; ut88.cmm:836 {
    ; ut88.cmm:837 tapeOutput(c = h);
    ld   c, h
    call tapeOutput
    ; ut88.cmm:838 return tapeOutput(c = l);
    ld   c, l
    jp   tapeOutput
    ; ut88.cmm:839 noreturn;
    ; ut88.cmm:840 }
    ; ut88.cmm:841 
    ; ut88.cmm:842 // Функция для пользовательской программы. Загрузка байта с магнитной ленты.
    ; ut88.cmm:843 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации. Результат: a = прочитанный байт. Сохрнаяет: bc, de, hl.
    ; ut88.cmm:844 
    ; ut88.cmm:845 void tapeInput(a)
tapeInput:
    ; ut88.cmm:846 {
    ; ut88.cmm:847 return tapeInput2(a);
    jp   tapeInput2
    ; ut88.cmm:848 noreturn;
    ; ut88.cmm:849 }
    ; ut88.cmm:850 
    ; ut88.cmm:851 // Загрузка байта с магнитной ленты.
    ; ut88.cmm:852 // Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации. Результат: a = прочитанный байт.
    ; ut88.cmm:853 
    ; ut88.cmm:854 void tapeInput3(a)
tapeInput3:
    ; ut88.cmm:855 {
    ; ut88.cmm:856 d = a;
    ld   d, a
    ; ut88.cmm:857 while ()
l41:
    ; ut88.cmm:858 {
    ; ut88.cmm:859 (hl = 0) += sp;
    ld   hl, 0
    add  hl, sp
    ; ut88.cmm:860 sp = 0;
    ld   sp, 0
    ; ut88.cmm:861 vSp = hl;
    ld   (vSp), hl
    ; ut88.cmm:862 c = 0;
    ld   c, 0
    ; ut88.cmm:863 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:864 e = (a &= 1);
    and  1
    ld   e, a
    ; ut88.cmm:865 
    ; ut88.cmm:866 do
l43:
    ; ut88.cmm:867 {
    ; ut88.cmm:868 pop(a);
    pop  af
    ; ut88.cmm:869 
    ; ut88.cmm:870 c = (((a = c) &= 0x7F) <<r= 1);
    ld   a, c
    and  127
    rlca
    ld   c, a
    ; ut88.cmm:871 h = 0;
    ld   h, 0
    ; ut88.cmm:872 
    ; ut88.cmm:873 do
l45:
    ; ut88.cmm:874 {
    ; ut88.cmm:875 h--;
    dec  h
    ; ut88.cmm:876 if (flag_z) goto tapeInput3a;
    jp   z, tapeInput3a
    ; ut88.cmm:877 pop(a);
    pop  af
    ; ut88.cmm:878 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:879 a &= 1;
    and  1
    ; ut88.cmm:880 } while (a == e);
    cp   e
    jp   z, l45
l46:
    ; ut88.cmm:881 
    ; ut88.cmm:882 c = (a |= c);
    or   c
    ld   c, a
    ; ut88.cmm:883 d--;
    dec  d
    ; ut88.cmm:884 a = vTapeSpeedRd;
    ld   a, (vTapeSpeedRd)
    ; ut88.cmm:885 if (flag_z) a -= 18;
    jp   nz, l47
    sub  18
    ; ut88.cmm:886 b = a;
l47:
    ld   b, a
    ; ut88.cmm:887 do
l48:
    ; ut88.cmm:888 {
    ; ut88.cmm:889 pop (a);
    pop  af
    ; ut88.cmm:890 } while (flag_nz b--);
    dec  b
    jp   nz, l48
l49:
    ; ut88.cmm:891 d++;
    inc  d
    ; ut88.cmm:892 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:893 e = (a &= 1);
    and  1
    ld   e, a
    ; ut88.cmm:894 a = d;
    ld   a, d
    ; ut88.cmm:895 if (flag_m a |= a)
    or   a
    ; ut88.cmm:896 {
    jp   p, l50
    ; ut88.cmm:897 if ((a = c) == 0xE6)
    ld   a, c
    cp   230
    ; ut88.cmm:898 {
    jp   nz, l51
    ; ut88.cmm:899 vTapeInverted = (a ^= a);
    xor  a
    ld   (vTapeInverted), a
    ; ut88.cmm:900 }
    ; ut88.cmm:901 else
    jp   l52
l51:
    ; ut88.cmm:902 {
    ; ut88.cmm:903 if (a != [0xFF ^ 0xE6]) continue;
    cp   25
    jp   nz, l43
    ; ut88.cmm:904 vTapeInverted = a = 0xFF;
    ld   a, 255
    ld   (vTapeInverted), a
    ; ut88.cmm:905 }
l52:
    ; ut88.cmm:906 d = 9;
    ld   d, 9
    ; ut88.cmm:907 }
    ; ut88.cmm:908 } while (flag_nz d--);
l50:
    dec  d
    jp   nz, l43
l44:
    ; ut88.cmm:909 
    ; ut88.cmm:910 hl = vSp;
    ld   hl, (vSp)
    ; ut88.cmm:911 sp = hl;
    ld   sp, hl
    ; ut88.cmm:912 a = vTapeInverted;
    ld   a, (vTapeInverted)
    ; ut88.cmm:913 a ^= c;
    xor  c
    ; ut88.cmm:914 return tapeInputOutputEnd();
    jp   tapeInputOutputEnd
    ; ut88.cmm:915 
    ; ut88.cmm:916 tapeInput3a:
tapeInput3a:
    ; ut88.cmm:917 hl = vSp;
    ld   hl, (vSp)
    ; ut88.cmm:918 sp = hl;
    ld   sp, hl
    ; ut88.cmm:919 if (flag_p (a = d) |= a) return error();
    ld   a, d
    or   a
    jp   p, error
    ; ut88.cmm:920 stopByUser();
    call stopByUser
    ; ut88.cmm:921 }
    jp   l41
l42:
    ; ut88.cmm:922 noreturn;
    ; ut88.cmm:923 }
    ; ut88.cmm:924 
    ; ut88.cmm:925 // Функция для пользовательской программы. Запись байта на магнитную ленту.
    ; ut88.cmm:926 // Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.
    ; ut88.cmm:927 
    ; ut88.cmm:928 void tapeOutput(c)
tapeOutput:
    ; ut88.cmm:929 {
    ; ut88.cmm:930 return tapeOutput2(c);
    jp   tapeOutput2
    ; ut88.cmm:931 noreturn;
    ; ut88.cmm:932 }
    ; ut88.cmm:933 
    ; ut88.cmm:934 // Запись байта на магнитную ленту.
    ; ut88.cmm:935 // Параметры: c = байт. Результат: нет. Сохраняет: a.
    ; ut88.cmm:936 
    ; ut88.cmm:937 void tapeOutput3(c)
tapeOutput3:
    ; ut88.cmm:938 {
    ; ut88.cmm:939 push(a)
    ; ut88.cmm:940 {
    push af
    ; ut88.cmm:941 (hl = 0) += sp;
    ld   hl, 0
    add  hl, sp
    ; ut88.cmm:942 sp = 0;
    ld   sp, 0
    ; ut88.cmm:943 
    ; ut88.cmm:944 d = 8;
    ld   d, 8
    ; ut88.cmm:945 do
l53:
    ; ut88.cmm:946 {
    ; ut88.cmm:947 // Задержка
    ; ut88.cmm:948 pop (a);
    pop  af
    ; ut88.cmm:949 
    ; ut88.cmm:950 // Следующий бит
    ; ut88.cmm:951 c = ((a = c) <<r= 1);
    ld   a, c
    rlca
    ld   c, a
    ; ut88.cmm:952 
    ; ut88.cmm:953 // Передача бита
    ; ut88.cmm:954 a = 1;
    ld   a, 1
    ; ut88.cmm:955 a ^= c;
    xor  c
    ; ut88.cmm:956 out(ioTape, a);
    out  (161), a
    ; ut88.cmm:957 
    ; ut88.cmm:958 // Задержка
    ; ut88.cmm:959 nop();
    nop
    ; ut88.cmm:960 b = a = vTapeSpeedWr;
    ld   a, (vTapeSpeedWr)
    ld   b, a
    ; ut88.cmm:961 do
l55:
    ; ut88.cmm:962 {
    ; ut88.cmm:963 pop (a);
    pop  af
    ; ut88.cmm:964 } while (flag_nz b--);
    dec  b
    jp   nz, l55
l56:
    ; ut88.cmm:965 
    ; ut88.cmm:966 // Передача бита
    ; ut88.cmm:967 a = 0;
    ld   a, 0
    ; ut88.cmm:968 a ^= c;
    xor  c
    ; ut88.cmm:969 out(ioTape, a);
    out  (161), a
    ; ut88.cmm:970 nop();
    nop
    ; ut88.cmm:971 
    ; ut88.cmm:972 // Задержка
    ; ut88.cmm:973 d--;
    dec  d
    ; ut88.cmm:974 a = vTapeSpeedWr;
    ld   a, (vTapeSpeedWr)
    ; ut88.cmm:975 if (flag_z) a -= 14;
    jp   nz, l57
    sub  14
    ; ut88.cmm:976 b = a;
l57:
    ld   b, a
    ; ut88.cmm:977 do
l58:
    ; ut88.cmm:978 {
    ; ut88.cmm:979 pop (a);
    pop  af
    ; ut88.cmm:980 } while (flag_nz b--);
    dec  b
    jp   nz, l58
l59:
    ; ut88.cmm:981 
    ; ut88.cmm:982 d++;
    inc  d
    ; ut88.cmm:983 } while (flag_nz d--);
    dec  d
    jp   nz, l53
l54:
    ; ut88.cmm:984 
    ; ut88.cmm:985 sp = hl;
    ld   sp, hl
    ; ut88.cmm:986 }
    pop  af
    ; ut88.cmm:987 return tapeInputOutputEnd();
    jp   tapeInputOutputEnd
    ; ut88.cmm:988 noreturn;
    ; ut88.cmm:989 }
    ; ut88.cmm:990 
    ; ut88.cmm:991 // Выход из функции tapeInputOutputEnd
    ; ut88.cmm:992 
    ; ut88.cmm:993 void tapeInputOutputEnd2()
tapeInputOutputEnd2:
    ; ut88.cmm:994 {
    ; ut88.cmm:995 }
    ret
    ; ut88.cmm:996 
    ; ut88.cmm:997 // Функция для пользовательской программы. Вывод 8 битного числа на экран.
    ; ut88.cmm:998 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:999 
    ; ut88.cmm:1000 void put8(a)
put8:
    ; ut88.cmm:1001 {
    ; ut88.cmm:1002 push(a)
    ; ut88.cmm:1003 {
    push af
    ; ut88.cmm:1004 a >>r= 4;
    rrca
    rrca
    rrca
    rrca
    ; ut88.cmm:1005 put4();
    call put4
    ; ut88.cmm:1006 }
    pop  af
    ; ut88.cmm:1007 noreturn;
    ; ut88.cmm:1008 }
    ; ut88.cmm:1009 
    ; ut88.cmm:1010 // Вывод 4 битного числа на экран.
    ; ut88.cmm:1011 // Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:1012 
    ; ut88.cmm:1013 void put4(a)
put4:
    ; ut88.cmm:1014 {
    ; ut88.cmm:1015 a &= 0x0F;
    and  15
    ; ut88.cmm:1016 if (a >=$ 10) a += 7;
    cp   10
    jp   m, l60
    add  7
    ; ut88.cmm:1017 a += '0';
l60:
    add  48
    ; ut88.cmm:1018 noreturn;
    ; ut88.cmm:1019 }
    ; ut88.cmm:1020 
    ; ut88.cmm:1021 // Вывод символа на экран.
    ; ut88.cmm:1022 // Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.
    ; ut88.cmm:1023 
    ; ut88.cmm:1024 void putchA(a)
putchA:
    ; ut88.cmm:1025 {
    ; ut88.cmm:1026 c = a;
    ld   c, a
    ; ut88.cmm:1027 noreturn;
    ; ut88.cmm:1028 }
    ; ut88.cmm:1029 
    ; ut88.cmm:1030 // Функция для пользовательской программы. Вывод символа на экран.
    ; ut88.cmm:1031 // Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.
    ; ut88.cmm:1032 
    ; ut88.cmm:1033 void putch(c)
putch:
    ; ut88.cmm:1034 {
    ; ut88.cmm:1035 push(hl, bc, de, a);
    push hl
    push bc
    push de
    push af
    ; ut88.cmm:1036 
    ; ut88.cmm:1037 hl = vCursor;
    ld   hl, (vCursor)
    ; ut88.cmm:1038 
    ; ut88.cmm:1039 // Стираем курсор
    ; ut88.cmm:1040 hl++;
    inc  hl
    ; ut88.cmm:1041 *hl = ((a = *hl) &= 0x7F);
    ld   a, (hl)
    and  127
    ld   (hl), a
    ; ut88.cmm:1042 hl--;
    dec  hl
    ; ut88.cmm:1043 
    ; ut88.cmm:1044 // После этого функции putchEscMode ворнутся в putchRet
    ; ut88.cmm:1045 de = &putchRet;
    ld   de, putchRet
    ; ut88.cmm:1046 push(de);
    push de
    ; ut88.cmm:1047 
    ; ut88.cmm:1048 a = vPutchEscMode;
    ld   a, (vPutchEscMode)
    ; ut88.cmm:1049 a--;
    dec  a
    ; ut88.cmm:1050 if (flag_m) return putchEscMode0(c, hl);
    jp   m, putchEscMode0
    ; ut88.cmm:1051 if (flag_z) return putchEscMode1(c, hl);
    jp   z, putchEscMode1
    ; ut88.cmm:1052 if (flag_po) return putchEscMode2(c, hl);
    jp   po, putchEscMode2
    ; ut88.cmm:1053 noreturn; // Продолжение на putchEscMode4(c, hl)
    ; ut88.cmm:1054 }
    ; ut88.cmm:1055 
    ; ut88.cmm:1056 void putchEscMode4(c, hl)
putchEscMode4:
    ; ut88.cmm:1057 {
    ; ut88.cmm:1058 c = ((a = c) -@= 0x20); //! Ошибка. Тут не нужно вычитать CF. Не кортроллируется выход за пределы экрана.
    ld   a, c
    sbc  32
    ld   c, a
    ; ut88.cmm:1059 while ()
l61:
    ; ut88.cmm:1060 {
    ; ut88.cmm:1061 c--;
    dec  c
    ; ut88.cmm:1062 if (flag_m) break;
    jp   m, l62
    ; ut88.cmm:1063 putchRight();
    call putchRight
    ; ut88.cmm:1064 }
    jp   l61
l62:
    ; ut88.cmm:1065 noreturn; // Продолжение на putchSetEsc0
    ; ut88.cmm:1066 }
    ; ut88.cmm:1067 
    ; ut88.cmm:1068 void putchSetEsc0()
putchSetEsc0:
    ; ut88.cmm:1069 {
    ; ut88.cmm:1070 a ^= a;
    xor  a
    ; ut88.cmm:1071 noreturn; // Продолжение на putchSetEsc
    ; ut88.cmm:1072 }
    ; ut88.cmm:1073 
    ; ut88.cmm:1074 void putchSetEsc(a)
putchSetEsc:
    ; ut88.cmm:1075 {
    ; ut88.cmm:1076 vPutchEscMode = a;
    ld   (vPutchEscMode), a
    ; ut88.cmm:1077 }
    ret
    ; ut88.cmm:1078 
    ; ut88.cmm:1079 void putchEscMode0(c, hl)
putchEscMode0:
    ; ut88.cmm:1080 {
    ; ut88.cmm:1081 a = c;
    ld   a, c
    ; ut88.cmm:1082 if (a == charCodeEsc        ) return putchEsc(hl);
    cp   27
    jp   z, putchEsc
    ; ut88.cmm:1083 if (a == charCodeClearScreen) return putchClearScreen(hl);
    cp   31
    jp   z, putchClearScreen
    ; ut88.cmm:1084 if (a == charCodeLeft       ) return putchLeft(hl);
    cp   8
    jp   z, putchLeft
    ; ut88.cmm:1085 if (a == charCodeRight      ) return putchRight(hl);
    cp   24
    jp   z, putchRight
    ; ut88.cmm:1086 if (a == charCodeUp         ) return putchUp(hl);
    cp   25
    jp   z, putchUp
    ; ut88.cmm:1087 if (a == charCodeDown       ) return putchDown(hl);
    cp   26
    jp   z, putchDown
    ; ut88.cmm:1088 if (a == charCodeNextLine   ) return putchNextLine(hl);
    cp   10
    jp   z, putchNextLine
    ; ut88.cmm:1089 if (a == charCodeHome       ) return putchHome(hl);
    cp   12
    jp   z, putchHome
    ; ut88.cmm:1090 //! Ошибка, не проверяется код 0x0D. В конце каждой выводимой строки на экране будет невидимый символ 0x0D
    ; ut88.cmm:1091 
    ; ut88.cmm:1092 // Если курсор находится за экраном, то прокуручиваем экран
    ; ut88.cmm:1093 if ((a = h) == [screenAddr + screenWidth * screenHeight >> 8])
    ld   a, h
    cp   239
    ; ut88.cmm:1094 {
    jp   nz, l63
    ; ut88.cmm:1095 putchScrollUp:
putchScrollUp:
    ; ut88.cmm:1096 // Нажатие любой клавиши приостанавливает прокрутку экрана
    ; ut88.cmm:1097 isAnyKeyPressed();
    call isAnyKeyPressed
    ; ut88.cmm:1098 if (a != 0)
    or   a
    ; ut88.cmm:1099 {
    jp   z, l64
    ; ut88.cmm:1100 getch();
    call getch
    ; ut88.cmm:1101 }
    ; ut88.cmm:1102 scrollUp();
l64:
    call scrollUp
    ; ut88.cmm:1103 
    ; ut88.cmm:1104 // Новые координаты символа
    ; ut88.cmm:1105 hl = [screenAddr + screenWidth * (screenHeight - 1) - 1];  //! Ошибка
    ld   hl, 61119
    ; ut88.cmm:1106 }
    ; ut88.cmm:1107 
    ; ut88.cmm:1108 // Записываем символ в видеопамять
    ; ut88.cmm:1109 *hl = (((a = *hl) &= 0x80) |= c);
l63:
    ld   a, (hl)
    and  128
    or   c
    ld   (hl), a
    ; ut88.cmm:1110 
    ; ut88.cmm:1111 // Следующий символ
    ; ut88.cmm:1112 hl++;
    inc  hl
    ; ut88.cmm:1113 
    ; ut88.cmm:1114 // Удаляем адрес возврата (собственно putchRet) из стека
    ; ut88.cmm:1115 pop(de);
    pop  de
    ; ut88.cmm:1116 noreturn; // Продолжение на putchRet
    ; ut88.cmm:1117 }
    ; ut88.cmm:1118 
    ; ut88.cmm:1119 void putchRet(hl)
putchRet:
    ; ut88.cmm:1120 {
    ; ut88.cmm:1121 // Сохраняем новое положение курсора
    ; ut88.cmm:1122 vCursor = hl;
    ld   (vCursor), hl
    ; ut88.cmm:1123 
    ; ut88.cmm:1124 // Рисуем курсор на экране
    ; ut88.cmm:1125 hl++;
    inc  hl
    ; ut88.cmm:1126 *hl = ((a = *hl) |= 0x80);
    ld   a, (hl)
    or   128
    ld   (hl), a
    ; ut88.cmm:1127 
    ; ut88.cmm:1128 // Вычисляем координаты курсора.
    ; ut88.cmm:1129 vCursorPos = (hl += (de = [0x10000 - screenAddr])); //! Ошибка. Координаты расчитываются не правильно.
    ld   de, 6144
    add  hl, de
    ld   (vCursorPos), hl
    ; ut88.cmm:1130 
    ; ut88.cmm:1131 pop(hl, bc, de, a);
    pop  af
    pop  de
    pop  bc
    pop  hl
    ; ut88.cmm:1132 }
    ret
    ; ut88.cmm:1133 
    ; ut88.cmm:1134 void putchClearScreen()
putchClearScreen:
    ; ut88.cmm:1135 {
    ; ut88.cmm:1136 clearScreen();
    call clearScreen
    ; ut88.cmm:1137 noreturn; // Продолжение на putchHome
    ; ut88.cmm:1138 }
    ; ut88.cmm:1139 
    ; ut88.cmm:1140 void putchHome()
putchHome:
    ; ut88.cmm:1141 {
    ; ut88.cmm:1142 hl = screenAddr;
    ld   hl, 59392
    ; ut88.cmm:1143 }
    ret
    ; ut88.cmm:1144 
    ; ut88.cmm:1145 // Очисть экран.
    ; ut88.cmm:1146 // Параметры: нет. Результат: нет. Сохраняет: bc, de
    ; ut88.cmm:1147 
    ; ut88.cmm:1148 void clearScreen()
clearScreen:
    ; ut88.cmm:1149 {
    ; ut88.cmm:1150 hl = screenAddr;
    ld   hl, 59392
    ; ut88.cmm:1151 while ()
l65:
    ; ut88.cmm:1152 {
    ; ut88.cmm:1153 *hl = ' ';
    ld   (hl), 32
    ; ut88.cmm:1154 hl++;
    inc  hl
    ; ut88.cmm:1155 if ((a = h) == [screenAddrEnd2 >> 8]) return;
    ld   a, h
    cp   240
    ret  z
    ; ut88.cmm:1156 }
    jp   l65
l66:
    ; ut88.cmm:1157 noreturn;
    ; ut88.cmm:1158 }
    ; ut88.cmm:1159 
    ; ut88.cmm:1160 void putchRight(hl)
putchRight:
    ; ut88.cmm:1161 {
    ; ut88.cmm:1162 hl++;
    inc  hl
    ; ut88.cmm:1163 if ((a = h) != [screenAddr + screenWidth * screenHeight >> 8]) return;
    ld   a, h
    cp   239
    ret  nz
    ; ut88.cmm:1164 if (flag_z) return putchHome(); //! Лишнее условие, которое всегда истинно.
    jp   z, putchHome
    ; ut88.cmm:1165 noreturn;
    ; ut88.cmm:1166 }
    ; ut88.cmm:1167 
    ; ut88.cmm:1168 void putchLeft(hl)
putchLeft:
    ; ut88.cmm:1169 {
    ; ut88.cmm:1170 hl--;
    dec  hl
    ; ut88.cmm:1171 if ((a = h) != [screenAddr - 1 >> 8]) return;
    ld   a, h
    cp   231
    ret  nz
    ; ut88.cmm:1172 hl = [screenAddr + screenWidth * screenHeight - 1];
    ld   hl, 61183
    ; ut88.cmm:1173 }
    ret
    ; ut88.cmm:1174 
    ; ut88.cmm:1175 void putchDown(hl)
putchDown:
    ; ut88.cmm:1176 {
    ; ut88.cmm:1177 hl += (de = screenWidth);
    ld   de, 64
    add  hl, de
    ; ut88.cmm:1178 if ((a = h) != [screenAddr + screenWidth * screenHeight >> 8]) return;
    ld   a, h
    cp   239
    ret  nz
    ; ut88.cmm:1179 h = [screenAddr >> 8];
    ld   h, 232
    ; ut88.cmm:1180 }
    ret
    ; ut88.cmm:1181 
    ; ut88.cmm:1182 void putchUp(hl)
putchUp:
    ; ut88.cmm:1183 {
    ; ut88.cmm:1184 hl += (de = [-screenWidth]);
    ld   de, -64
    add  hl, de
    ; ut88.cmm:1185 if ((a = h) != [screenAddr - 1 >> 8]) return;
    ld   a, h
    cp   231
    ret  nz
    ; ut88.cmm:1186 hl += (de = 0x800); //! Ошибка. Курсор переместится в 31-ую строку.
    ld   de, 2048
    add  hl, de
    ; ut88.cmm:1187 }
    ret
    ; ut88.cmm:1188 
    ; ut88.cmm:1189 void putchNextLine()
putchNextLine:
    ; ut88.cmm:1190 {
    ; ut88.cmm:1191 do //! Некрасиво. Мы крутим цикл, что бы вычистить l &= 0x3F, hl += 0x40
l67:
    ; ut88.cmm:1192 {
    ; ut88.cmm:1193 hl++;
    inc  hl
    ; ut88.cmm:1194 } while (flag_nz (a = l) &= 0x3F);
    ld   a, l
    and  63
    jp   nz, l67
l68:
    ; ut88.cmm:1195 
    ; ut88.cmm:1196 if ((a = h) == [screenAddr + screenWidth * screenHeight >> 8])
    ld   a, h
    cp   239
    ; ut88.cmm:1197 return putchScrollUp();
    jp   z, putchScrollUp
    ; ut88.cmm:1198 }
    ret
    ; ut88.cmm:1199 
    ; ut88.cmm:1200 // Сместить экран на одну строку вверх.
    ; ut88.cmm:1201 // Параметры: нет. Результат: нет. Сохраняет: bc
    ; ut88.cmm:1202 
    ; ut88.cmm:1203 void scrollUp()
scrollUp:
    ; ut88.cmm:1204 {
    ; ut88.cmm:1205 hl = [screenAddr + screenWidth];
    ld   hl, 59456
    ; ut88.cmm:1206 de = screenAddr;
    ld   de, 59392
    ; ut88.cmm:1207 
    ; ut88.cmm:1208 // Сдвиг экрана вверх
    ; ut88.cmm:1209 do
l69:
    ; ut88.cmm:1210 {
    ; ut88.cmm:1211 *de = a = *hl;
    ld   a, (hl)
    ld   (de), a
    ; ut88.cmm:1212 de++;
    inc  de
    ; ut88.cmm:1213 hl++;
    inc  hl
    ; ut88.cmm:1214 } while ((a = h) != [screenAddr + screenWidth * screenHeight >> 8]);
    ld   a, h
    cp   239
    jp   nz, l69
l70:
    ; ut88.cmm:1215 
    ; ut88.cmm:1216 // Очистка нижней строки
    ; ut88.cmm:1217 hl = [screenAddr + screenWidth * (screenHeight - 1)];
    ld   hl, 61120
    ; ut88.cmm:1218 a = ' ';
    ld   a, 32
    ; ut88.cmm:1219 do
l71:
    ; ut88.cmm:1220 {
    ; ut88.cmm:1221 *hl = a;
    ld   (hl), a
    ; ut88.cmm:1222 l++;
    inc  l
    ; ut88.cmm:1223 } while (flag_nz);
    jp   nz, l71
l72:
    ; ut88.cmm:1224 }
    ret
    ; ut88.cmm:1225 
    ; ut88.cmm:1226 void putchEscMode1(c, hl)
putchEscMode1:
    ; ut88.cmm:1227 {
    ; ut88.cmm:1228 // Поддерживается только ESC-код Y
    ; ut88.cmm:1229 if ((a = c) != 'Y') return putchSetEsc0();
    ld   a, c
    cp   89
    jp   nz, putchSetEsc0
    ; ut88.cmm:1230 
    ; ut88.cmm:1231 putchHome();
    call putchHome
    ; ut88.cmm:1232 return putchSetEsc(a = 2);
    ld   a, 2
    jp   putchSetEsc
    ; ut88.cmm:1233 noreturn;
    ; ut88.cmm:1234 }
    ; ut88.cmm:1235 
    ; ut88.cmm:1236 void putchEscMode2(c, hl)
putchEscMode2:
    ; ut88.cmm:1237 {
    ; ut88.cmm:1238 c = ((a = c) -@= 0x20); //! Ошибка. Тут не нужно вычитать CF.
    ld   a, c
    sbc  32
    ld   c, a
    ; ut88.cmm:1239 while ()
l73:
    ; ut88.cmm:1240 {
    ; ut88.cmm:1241 c--;
    dec  c
    ; ut88.cmm:1242 a = 4;
    ld   a, 4
    ; ut88.cmm:1243 if (flag_m) return putchSetEsc(a);
    jp   m, putchSetEsc
    ; ut88.cmm:1244 putchDown();
    call putchDown
    ; ut88.cmm:1245 }
    jp   l73
l74:
    ; ut88.cmm:1246 noreturn;
    ; ut88.cmm:1247 }
    ; ut88.cmm:1248 
    ; ut88.cmm:1249 void putchEsc()
putchEsc:
    ; ut88.cmm:1250 {
    ; ut88.cmm:1251 return putchSetEsc(a = 1);
    ld   a, 1
    jp   putchSetEsc
    ; ut88.cmm:1252 noreturn;
    ; ut88.cmm:1253 }
    ; ut88.cmm:1254 
    ; ut88.cmm:1255 // Функция для пользовательской программы. Получить код нажатой клавиши на клавиатуре.
    ; ut88.cmm:1256 // В отличии от функции inkey, в этой функции есть задержка повтора и звук при нажатии.
    ; ut88.cmm:1257 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
    ; ut88.cmm:1258 
    ; ut88.cmm:1259 void getch()
getch:
    ; ut88.cmm:1260 {
    ; ut88.cmm:1261 push(hl, de, bc)
    ; ut88.cmm:1262 {
    push hl
    push de
    push bc
    ; ut88.cmm:1263 vFirstPressCounter = a = 127;
    ld   a, 127
    ld   (vFirstPressCounter), a
    ; ut88.cmm:1264 
    ; ut88.cmm:1265 getch1:
getch1:
    ; ut88.cmm:1266 while ()
l75:
    ; ut88.cmm:1267 {
    ; ut88.cmm:1268 inkey();
    call inkey
    ; ut88.cmm:1269 if (a != 0xFF) break;
    cp   255
    jp   nz, l76
    ; ut88.cmm:1270 vFirstPressCounter = a = 0;
    ld   a, 0
    ld   (vFirstPressCounter), a
    ; ut88.cmm:1271 vFirstPress = a = 0;
    ld   a, 0
    ld   (vFirstPress), a
    ; ut88.cmm:1272 }
    jp   l75
l76:
    ; ut88.cmm:1273 d = a;
    ld   d, a
    ; ut88.cmm:1274 
    ; ut88.cmm:1275 // Задержка перед первым повтором
    ; ut88.cmm:1276 if (flag_z (a = vFirstPress) &= a)
    ld   a, (vFirstPress)
    and  a
    ; ut88.cmm:1277 {
    jp   nz, l77
    ; ut88.cmm:1278 if (flag_nz (a = vFirstPressCounter) &= a)
    ld   a, (vFirstPressCounter)
    and  a
    ; ut88.cmm:1279 {
    jp   z, l78
    ; ut88.cmm:1280 vFirstPressCounter = --(a = vFirstPressCounter);
    ld   a, (vFirstPressCounter)
    dec  a
    ld   (vFirstPressCounter), a
    ; ut88.cmm:1281 if (flag_nz) goto getch1;
    jp   nz, getch1
    ; ut88.cmm:1282 vFirstPress = a = 1;
    ld   a, 1
    ld   (vFirstPress), a
    ; ut88.cmm:1283 }
    ; ut88.cmm:1284 }
l78:
    ; ut88.cmm:1285 
    ; ut88.cmm:1286 // Звук при нажатии
    ; ut88.cmm:1287 beep(); //! Создаёт очень сильнукю задержку
l77:
    call beep
    ; ut88.cmm:1288 a = d;
    ld   a, d
    ; ut88.cmm:1289 }
    pop  bc
    pop  de
    pop  hl
    ; ut88.cmm:1290 }
    ret
    ; ut88.cmm:1291 
    ; ut88.cmm:1292 // Функция для пользовательской программы. Получить код нажатой клавиши на клавиатуре.
    ; ut88.cmm:1293 // Эта функция с устранением дребезга контактов.
    ; ut88.cmm:1294 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
    ; ut88.cmm:1295 
    ; ut88.cmm:1296 void inkey()
inkey:
    ; ut88.cmm:1297 {
    ; ut88.cmm:1298 push(bc)
    ; ut88.cmm:1299 {
    push bc
    ; ut88.cmm:1300 do
l79:
    ; ut88.cmm:1301 {
    ; ut88.cmm:1302 // Получить код нажатой клавиши
    ; ut88.cmm:1303 inkeyInt();
    call inkeyInt
    ; ut88.cmm:1304 b = a;
    ld   b, a
    ; ut88.cmm:1305 
    ; ut88.cmm:1306 // Задержка
    ; ut88.cmm:1307 c = 0xFF; //! Некрасиво. Задержка при первом нажатии не нужна.
    ld   c, 255
    ; ut88.cmm:1308 do
l81:
    ; ut88.cmm:1309 {
    ; ut88.cmm:1310 c--;
    dec  c
    ; ut88.cmm:1311 } while (flag_nz);
    jp   nz, l81
l82:
    ; ut88.cmm:1312 
    ; ut88.cmm:1313 // Получить код нажатой клавиши. И если он отличается, то повторить всё заново.
    ; ut88.cmm:1314 inkeyInt(); //! Некрасиво. Надо отдельно считать таймауты для нажатия и отжатия, что бы правильно подавлять дребезг.
    call inkeyInt
    ; ut88.cmm:1315 } while (a != b);
    cp   b
    jp   nz, l79
l80:
    ; ut88.cmm:1316 }
    pop  bc
    ; ut88.cmm:1317 }
    ret
    ; ut88.cmm:1318 
    ; ut88.cmm:1319 // Получить код нажатой клавиши на клавиатуре.
    ; ut88.cmm:1320 // Параметры: нет. Результат: a. Сохраняет: bc, de, hl.
    ; ut88.cmm:1321 
    ; ut88.cmm:1322 void inkeyInt()
inkeyInt:
    ; ut88.cmm:1323 {
    ; ut88.cmm:1324 push(bc, de, hl);
    push bc
    push de
    push hl
    ; ut88.cmm:1325 // Проверка каждого ряда
    ; ut88.cmm:1326 b = 0;
    ld   b, 0
    ; ut88.cmm:1327 c = 0xFE;
    ld   c, 254
    ; ut88.cmm:1328 d = 8;
    ld   d, 8
    ; ut88.cmm:1329 do
l83:
    ; ut88.cmm:1330 {
    ; ut88.cmm:1331 // Запись ряда в микросхему и сразу вычисление следующего ряда
    ; ut88.cmm:1332 out(ioSysA, a = c);
    ld   a, c
    out  (7), a
    ; ut88.cmm:1333 a <<r= 1;
    rlca
    ; ut88.cmm:1334 c = a;
    ld   c, a
    ; ut88.cmm:1335 
    ; ut88.cmm:1336 // Чтение строки. Строк всего 7, поэтому накладываем маску.
    ; ut88.cmm:1337 a = in(ioSysB);
    in   a, (6)
    ; ut88.cmm:1338 a &= 0x7F;
    and  127
    ; ut88.cmm:1339 if (a != 0x7F) return inkeyDecode(); // Если клавиша нажата, то преобразуем номер в код.
    cp   127
    jp   nz, inkeyDecode
    ; ut88.cmm:1340 
    ; ut88.cmm:1341 // Увеличиваем b на 7 для расчета номера нажатой кнпоки в inkeyDecode
    ; ut88.cmm:1342 b = ((a = b) += 7);
    ld   a, b
    add  7
    ld   b, a
    ; ut88.cmm:1343 } while (flag_nz d--);
    dec  d
    jp   nz, l83
l84:
    ; ut88.cmm:1344 
    ; ut88.cmm:1345 // Если нажата клавиша РУС/ЛАТ
    ; ut88.cmm:1346 a = in(ioSysB); //! Ошибка. Эта клавиша размещена в первом бите ioSysС
    in   a, (6)
    ; ut88.cmm:1347 if (flag_nz a &= 0x80) a = 0xFE; else a = 0xFF;
    and  128
    jp   z, l85
    ld   a, 254
    jp   l86
l85:
    ld   a, 255
l86:
    ; ut88.cmm:1348 popHlDeBcAndRet:
popHlDeBcAndRet:
    ; ut88.cmm:1349 pop(bc, de, hl);
    pop  hl
    pop  de
    pop  bc
    ; ut88.cmm:1350 }
    ret
    ; ut88.cmm:1351 
    ; ut88.cmm:1352 // Преобразовать номер нажатой клавиши на клавиатуре в код
    ; ut88.cmm:1353 
    ; ut88.cmm:1354 void inkeyDecode(a, b)
inkeyDecode:
    ; ut88.cmm:1355 {
    ; ut88.cmm:1356 // Прибавляем к B позицию первого нулевого бита в A.
    ; ut88.cmm:1357 while ()
l87:
    ; ut88.cmm:1358 {
    ; ut88.cmm:1359 a >>@= 1;
    rra
    ; ut88.cmm:1360 if (flag_nc) break;
    jp   nc, l88
    ; ut88.cmm:1361 b++;
    inc  b
    ; ut88.cmm:1362 }
    jp   l87
l88:
    ; ut88.cmm:1363 
    ; ut88.cmm:1364 // Преобразование номера клавиши в код
    ; ut88.cmm:1365 a = b;
    ld   a, b
    ; ut88.cmm:1366 if (a < 0x30)
    cp   48
    ; ut88.cmm:1367 {
    jp   nc, l89
    ; ut88.cmm:1368 a += 0x30;
    add  48
    ; ut88.cmm:1369 if (a >= 0x3C)
    cp   60
    ; ut88.cmm:1370 if (a < 0x40)
    jp   c, l90
    cp   64
    ; ut88.cmm:1371 a &= 0x2F;
    jp   nc, l91
    and  47
    ; ut88.cmm:1372 c = a;
l91:
l90:
    ld   c, a
    ; ut88.cmm:1373 }
    ; ut88.cmm:1374 else
    jp   l92
l89:
    ; ut88.cmm:1375 {
    ; ut88.cmm:1376 hl = &inkeyDecodeTable;
    ld   hl, inkeyDecodeTable
    ; ut88.cmm:1377 c = (a -= 0x30);
    sub  48
    ld   c, a
    ; ut88.cmm:1378 b = 0;
    ld   b, 0
    ; ut88.cmm:1379 a = *(hl += bc);
    add  hl, bc
    ld   a, (hl)
    ; ut88.cmm:1380 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1381 }
l92:
    ; ut88.cmm:1382 
    ; ut88.cmm:1383 // Нажата ли клавиаша РУС, УС или СС ?
    ; ut88.cmm:1384 a = in(ioSysC);
    in   a, (5)
    ; ut88.cmm:1385 a &= 7;
    and  7
    ; ut88.cmm:1386 if (a == 7) return inkeyDecodeNoShift(c);
    cp   7
    jp   z, inkeyDecodeNoShift
    ; ut88.cmm:1387 a >>@= 2;
    rra
    rra
    ; ut88.cmm:1388 if (flag_nc) return inkeyDecodeUs(c);
    jp   nc, inkeyDecodeUs
    ; ut88.cmm:1389 a >>@= 1;
    rra
    ; ut88.cmm:1390 if (flag_nc) return inkeyDecodeSs(c); //! Некрасиво, при нажатой РУС/ЛАТ, клавиша СС возвращает английский язык, но не наоборот.
    jp   nc, inkeyDecodeSs
    ; ut88.cmm:1391 noreturn; // Продолджение в inkeyDecodeRus(c)
    ; ut88.cmm:1392 }
    ; ut88.cmm:1393 
    ; ut88.cmm:1394 void inkeyDecodeRus(c)
inkeyDecodeRus:
    ; ut88.cmm:1395 {
    ; ut88.cmm:1396 a = c;
    ld   a, c
    ; ut88.cmm:1397 a |= 0x20;
    or   32
    ; ut88.cmm:1398 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1399 noreturn;
    ; ut88.cmm:1400 }
    ; ut88.cmm:1401 
    ; ut88.cmm:1402 void inkeyDecodeUs(c)
inkeyDecodeUs:
    ; ut88.cmm:1403 {
    ; ut88.cmm:1404 a = c;
    ld   a, c
    ; ut88.cmm:1405 a &= 0x1F;
    and  31
    ; ut88.cmm:1406 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1407 noreturn;
    ; ut88.cmm:1408 }
    ; ut88.cmm:1409 
    ; ut88.cmm:1410 void inkeyDecodeSs(c)
inkeyDecodeSs:
    ; ut88.cmm:1411 {
    ; ut88.cmm:1412 a = c;
    ld   a, c
    ; ut88.cmm:1413 if (a >= 0x40) goto popHlDeBcAndRet;
    cp   64
    jp   nc, popHlDeBcAndRet
    ; ut88.cmm:1414 if (a < 0x30)
    cp   48
    ; ut88.cmm:1415 {
    jp   nc, l93
    ; ut88.cmm:1416 a |= 0x10;
    or   16
    ; ut88.cmm:1417 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1418 }
    ; ut88.cmm:1419 a &= 0x2F;
l93:
    and  47
    ; ut88.cmm:1420 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1421 noreturn;
    ; ut88.cmm:1422 }
    ; ut88.cmm:1423 
    ; ut88.cmm:1424 void inkeyDecodeNoShift(c)
inkeyDecodeNoShift:
    ; ut88.cmm:1425 {
    ; ut88.cmm:1426 a = c;
    ld   a, c
    ; ut88.cmm:1427 goto popHlDeBcAndRet;
    jp   popHlDeBcAndRet
    ; ut88.cmm:1428 noreturn;
    ; ut88.cmm:1429 }
    ; ut88.cmm:1430 
    ; ut88.cmm:1431 uint8_t inkeyDecodeTable[] =
    ; ut88.cmm:1432 {
    ; ut88.cmm:1433 charCodeSpace,
    ; ut88.cmm:1434 charCodeRight,
    ; ut88.cmm:1435 charCodeLeft,
    ; ut88.cmm:1436 charCodeUp,
    ; ut88.cmm:1437 charCodeDown,
    ; ut88.cmm:1438 charCodeEnter,
    ; ut88.cmm:1439 charCodeClearScreen,
    ; ut88.cmm:1440 charCodeHome
    ; ut88.cmm:1441 };
inkeyDecodeTable:
    db 32
    db 24
    db 8
    db 25
    db 26
    db 13
    db 31
    db 12
    ; ut88.cmm:1442 
    ; ut88.cmm:1443 // Звуковой сигнал
    ; ut88.cmm:1444 // Параметры: нет. Результат: нет. Сохраняет: de, hl.
    ; ut88.cmm:1445 
    ; ut88.cmm:1446 void beep()
beep:
    ; ut88.cmm:1447 {
    ; ut88.cmm:1448 c = 191;
    ld   c, 191
    ; ut88.cmm:1449 do
l94:
    ; ut88.cmm:1450 {
    ; ut88.cmm:1451 // Задежка
    ; ut88.cmm:1452 delay47();
    call delay47
    ; ut88.cmm:1453 
    ; ut88.cmm:1454 // Изменение фазы выхода магнитофона. Регистр А не имеет значения.
    ; ut88.cmm:1455 out(ioTape, a);
    out  (161), a
    ; ut88.cmm:1456 
    ; ut88.cmm:1457 // Задежка
    ; ut88.cmm:1458 invert(a); //! Смысла в этой команде нет
    cpl
    ; ut88.cmm:1459 delay47();
    call delay47
    ; ut88.cmm:1460 
    ; ut88.cmm:1461 // Изменение фазы выхода магнитофона. Регистр А не имеет значения.
    ; ut88.cmm:1462 out(ioTape, a);
    out  (161), a
    ; ut88.cmm:1463 
    ; ut88.cmm:1464 // Цикл
    ; ut88.cmm:1465 } while (flag_nz c--);
    dec  c
    jp   nz, l94
l95:
    ; ut88.cmm:1466 noreturn;
    ; ut88.cmm:1467 }
    ; ut88.cmm:1468 
    ; ut88.cmm:1469 // Задержка. Используется для вывода звука.
    ; ut88.cmm:1470 // Параметры: нет. Результат: нет. Сохраняет: a, c, de, hl.
    ; ut88.cmm:1471 
    ; ut88.cmm:1472 void delay47()
delay47:
    ; ut88.cmm:1473 {
    ; ut88.cmm:1474 b = 47;
    ld   b, 47
    ; ut88.cmm:1475 do
l96:
    ; ut88.cmm:1476 {
    ; ut88.cmm:1477 } while (flag_nz b--);
    dec  b
    jp   nz, l96
l97:
    ; ut88.cmm:1478 }
    ret
    ; ut88.cmm:1479 
    ; ut88.cmm:1480 // Эта функция не используется.
    ; ut88.cmm:1481 // Ожидать ноль на выводе B7 микросхемы системного порта КР580ВВ55А.
    ; ut88.cmm:1482 // Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:1483 
    ; ut88.cmm:1484 void FE63()
FE63:
    ; ut88.cmm:1485 {
    ; ut88.cmm:1486 do
l98:
    ; ut88.cmm:1487 {
    ; ut88.cmm:1488 a = in(ioSysB);
    in   a, (6)
    ; ut88.cmm:1489 } while (flag_nz a &= 0x80);
    and  128
    jp   nz, l98
l99:
    ; ut88.cmm:1490 }
    ret
    ; ut88.cmm:1491 
    ; ut88.cmm:1492 // Функция для пользовательской программы.
    ; ut88.cmm:1493 // Нажата ли хотя бы одна клавиша на клавиатуре?
    ; ut88.cmm:1494 // Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:1495 
    ; ut88.cmm:1496 void isAnyKeyPressed()
isAnyKeyPressed:
    ; ut88.cmm:1497 {
    ; ut88.cmm:1498 out(ioSysA, a ^= a);
    xor  a
    out  (7), a
    ; ut88.cmm:1499 a = in(ioSysB);
    in   a, (6)
    ; ut88.cmm:1500 invert(a);
    cpl
    ; ut88.cmm:1501 a &= 0x7F;
    and  127
    ; ut88.cmm:1502 if (flag_z) return;
    ret  z
    ; ut88.cmm:1503 a |= 0xFF;
    or   255
    ; ut88.cmm:1504 //! Несовместимость с Радио 86РК. Не обрабатывается клавиша РУС/ЛАТ.
    ; ut88.cmm:1505 }
    ret
    ; ut88.cmm:1506 
    ; ut88.cmm:1507 // Функция для пользовательской программы.
    ; ut88.cmm:1508 // Получить адрес последнего доступного байта оперативной памяти.
    ; ut88.cmm:1509 // Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.
    ; ut88.cmm:1510 
    ; ut88.cmm:1511 void getLastRamAddr()
getLastRamAddr:
    ; ut88.cmm:1512 {
    ; ut88.cmm:1513 hl = vLastRamAddr;
    ld   hl, (vLastRamAddr)
    ; ut88.cmm:1514 }
    ret
    ; ut88.cmm:1515 
    ; ut88.cmm:1516 // Функция для пользовательской программы. Установить адрес последнего доступного байта оперативной памяти.
    ; ut88.cmm:1517 // Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.
    ; ut88.cmm:1518 
    ; ut88.cmm:1519 void setLastRamAddr(hl)
setLastRamAddr:
    ; ut88.cmm:1520 {
    ; ut88.cmm:1521 vLastRamAddr = hl;
    ld   (vLastRamAddr), hl
    ; ut88.cmm:1522 }
    ret
    ; ut88.cmm:1523 
    ; ut88.cmm:1524 // Текстовые строки
    ; ut88.cmm:1525 
    ; ut88.cmm:1526 uint8_t aCrLfPrompt[] = { "\r\n\x18=>" };
aCrLfPrompt:
    db 13, 10, 24, "=>", 0
    ; ut88.cmm:1527 
    ; ut88.cmm:1528 uint8_t aCrLfTab[] = { "\r\n\x18\x18\x18\x18" };
aCrLfTab:
    db 13, 10, 24, 24, 24, 24, 0
    ; ut88.cmm:1529 
    ; ut88.cmm:1530 uint8_t aRegs[] = { "\r\n PC-"
    ; ut88.cmm:1531 "\r\n HL-"
    ; ut88.cmm:1532 "\r\n BC-"
    ; ut88.cmm:1533 "\r\n DE-"
    ; ut88.cmm:1534 "\r\n SP-"
    ; ut88.cmm:1535 "\r\n AF-"
    ; ut88.cmm:1536 "\x19\x19\x19\x19\x19\x19" };
aRegs:
    db 13, 10, " PC-", 13, 10, " HL-", 13, 10, " BC-", 13, 10, " DE-", 13, 10, " SP-", 13, 10, " AF-", 25, 25, 25, 25, 25, 25, 0
    ; ut88.cmm:1537 
    ; ut88.cmm:1538 uint8_t aBsSpBs[] = { "\x08 \x08" };
aBsSpBs:
    db 8, " ", 8, 0
    ; ut88.cmm:1539 
    ; ut88.cmm:1540 // Точка остановки в программе пользователя
    ; ut88.cmm:1541 
    ; ut88.cmm:1542 void breakHandler()
breakHandler:
    ; ut88.cmm:1543 {
    ; ut88.cmm:1544 // Сохраняем HL
    ; ut88.cmm:1545 vBreakSavedHl = hl;
    ld   (vBreakSavedHl), hl
    ; ut88.cmm:1546 
    ; ut88.cmm:1547 // Сохраняем PSW
    ; ut88.cmm:1548 push(a);
    push af
    ; ut88.cmm:1549 pop(hl);
    pop  hl
    ; ut88.cmm:1550 vBreakSavedPsw = hl;
    ld   (vBreakSavedPsw), hl
    ; ut88.cmm:1551 
    ; ut88.cmm:1552 // Сохраняем PC
    ; ut88.cmm:1553 pop(hl);
    pop  hl
    ; ut88.cmm:1554 hl--;
    dec  hl
    ; ut88.cmm:1555 vBreakSavedPc = hl;
    ld   (vBreakSavedPc), hl
    ; ut88.cmm:1556 
    ; ut88.cmm:1557 // Сохраняем SP, BC, DE
    ; ut88.cmm:1558 (hl = 0) += sp;
    ld   hl, 0
    add  hl, sp
    ; ut88.cmm:1559 sp = &vBreakSavedPsw;
    ld   sp, vBreakSavedPsw
    ; ut88.cmm:1560 push(hl, de, bc);
    push hl
    push de
    push bc
    ; ut88.cmm:1561 
    ; ut88.cmm:1562 // Вывод на экран адреса остановки
    ; ut88.cmm:1563 hl = vBreakSavedPc;
    ld   hl, (vBreakSavedPc)
    ; ut88.cmm:1564 sp = initalStackAddr;
    ld   sp, 63407
    ; ut88.cmm:1565 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:1566 
    ; ut88.cmm:1567 // Если команда в программе пользователя была заменена на RST, то восстанавливаем команду.
    ; ut88.cmm:1568 // И в любом случае возвращаемся в Монитор.
    ; ut88.cmm:1569 swap(de, hl);
    ex de, hl
    ; ut88.cmm:1570 hl = vBreakAddr;
    ld   hl, (vBreakAddr)
    ; ut88.cmm:1571 cmdHlDe();
    call cmdHlDe
    ; ut88.cmm:1572 if (flag_nz) return monitor();
    jp   nz, monitor
    ; ut88.cmm:1573 *hl = a = vBreakPrevCmd;
    ld   a, (vBreakPrevCmd)
    ld   (hl), a
    ; ut88.cmm:1574 return monitor();
    jp   monitor
    ; ut88.cmm:1575 noreturn;
    ; ut88.cmm:1576 }
    ; ut88.cmm:1577 
    ; ut88.cmm:1578 // Команда X
    ; ut88.cmm:1579 // Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.
    ; ut88.cmm:1580 
    ; ut88.cmm:1581 void cmdX()
cmdX:
    ; ut88.cmm:1582 {
    ; ut88.cmm:1583 // Вывод названий регистров на экран
    ; ut88.cmm:1584 puts(hl = &aRegs);
    ld   hl, aRegs
    call puts
    ; ut88.cmm:1585 
    ; ut88.cmm:1586 hl = &vBreakSavedPc; // Адрес первого регистры
    ld   hl, vBreakSavedPc
    ; ut88.cmm:1587 b = 6; // Кол-во регистров
    ld   b, 6
    ; ut88.cmm:1588 do
l100:
    ; ut88.cmm:1589 {
    ; ut88.cmm:1590 // Тенкущее значение регистра
    ; ut88.cmm:1591 e = *hl;
    ld   e, (hl)
    ; ut88.cmm:1592 hl++;
    inc  hl
    ; ut88.cmm:1593 d = *hl;
    ld   d, (hl)
    ; ut88.cmm:1594 
    ; ut88.cmm:1595 push(bc, hl)
    ; ut88.cmm:1596 {
    push bc
    push hl
    ; ut88.cmm:1597 swap(hl, de);
    ex de, hl
    ; ut88.cmm:1598 
    ; ut88.cmm:1599 // Вывод текущего значения на экран
    ; ut88.cmm:1600 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:1601 
    ; ut88.cmm:1602 // Ввод строки пользователем
    ; ut88.cmm:1603 getLine();
    call getLine
    ; ut88.cmm:1604 
    ; ut88.cmm:1605 // Если пользователь ввел строку, то преобразуем её в число и сохраняем в памяти
    ; ut88.cmm:1606 if (flag_c)
    ; ut88.cmm:1607 {
    jp   nc, l102
    ; ut88.cmm:1608 parseHexNumber16();
    call parseHexNumber16
    ; ut88.cmm:1609 pop(de);
    pop  de
    ; ut88.cmm:1610 push(de);
    push de
    ; ut88.cmm:1611 swap(hl, de);
    ex de, hl
    ; ut88.cmm:1612 *hl = d;
    ld   (hl), d
    ; ut88.cmm:1613 hl--;
    dec  hl
    ; ut88.cmm:1614 *hl = e;
    ld   (hl), e
    ; ut88.cmm:1615 }
    ; ut88.cmm:1616 }
l102:
    pop  hl
    pop  bc
    ; ut88.cmm:1617 
    ; ut88.cmm:1618 // Следующий цикл
    ; ut88.cmm:1619 b--;
    dec  b
    ; ut88.cmm:1620 hl++;
    inc  hl
    ; ut88.cmm:1621 } while (flag_nz);
    jp   nz, l100
l101:
    ; ut88.cmm:1622 }
    ret
    ; ut88.cmm:1623 
    ; ut88.cmm:1624 // Продложение разбора команды введенной пользователем.
    ; ut88.cmm:1625 // Аргументов нет. Функция никогда не завершается.
    ; ut88.cmm:1626 
    ; ut88.cmm:1627 void monitor2(a, hl, de)
monitor2:
    ; ut88.cmm:1628 {
    ; ut88.cmm:1629 // Разбор команд
    ; ut88.cmm:1630 if (a == 'B') return cmdB();
    cp   66
    jp   z, cmdB
    ; ut88.cmm:1631 if (a == 'W') return cmdW();
    cp   87
    jp   z, cmdW
    ; ut88.cmm:1632 if (a == 'V') return cmdV();
    cp   86
    jp   z, cmdV
    ; ut88.cmm:1633 
    ; ut88.cmm:1634 // Продолжение разбора команд в следующей функции
    ; ut88.cmm:1635 return monitor3(a, hl, de);
    jp   monitor3
    ; ut88.cmm:1636 noreturn;
    ; ut88.cmm:1637 }
    ; ut88.cmm:1638 
    ; ut88.cmm:1639 // Команда V
    ; ut88.cmm:1640 // Измерение константы скорости чтения данных с магнитной ленты
    ; ut88.cmm:1641 
    ; ut88.cmm:1642 void cmdV()
cmdV:
    ; ut88.cmm:1643 {
    ; ut88.cmm:1644 // Выключение прерываний для более точного измерения
    ; ut88.cmm:1645 disableInterrupts();
    di
    ; ut88.cmm:1646 
    ; ut88.cmm:1647 // Тут будет общая длительность
    ; ut88.cmm:1648 hl = 0;
    ld   hl, 0
    ; ut88.cmm:1649 
    ; ut88.cmm:1650 // Маска для чтения из порта ввода-вывода b = 1
    ; ut88.cmm:1651 // Кол-во необходимыизмерений (перепадов) с = 122
    ; ut88.cmm:1652 bc = [(1 << 8) | 122];
    ld   bc, 378
    ; ut88.cmm:1653 
    ; ut88.cmm:1654 // Ожидание изменения уровня на входе магнитной ленты
    ; ut88.cmm:1655 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:1656 a &= b; // тут b = 1
    and  b
    ; ut88.cmm:1657 e = a;
    ld   e, a
    ; ut88.cmm:1658 do
l103:
    ; ut88.cmm:1659 {
    ; ut88.cmm:1660 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:1661 a &= b; // тут b = 1
    and  b
    ; ut88.cmm:1662 } while (a == e);
    cp   e
    jp   z, l103
l104:
    ; ut88.cmm:1663 e = a;
    ld   e, a
    ; ut88.cmm:1664 
    ; ut88.cmm:1665 // Изменение длительности 122 перепадов
    ; ut88.cmm:1666 do
l105:
    ; ut88.cmm:1667 {
    ; ut88.cmm:1668 // Ожидание изменения уровня на входе магнитной ленты
    ; ut88.cmm:1669 do
l107:
    ; ut88.cmm:1670 {
    ; ut88.cmm:1671 a = in(ioTape);
    in   a, (161)
    ; ut88.cmm:1672 a &= b;
    and  b
    ; ut88.cmm:1673 hl++;
    inc  hl
    ; ut88.cmm:1674 } while (a == e);
    cp   e
    jp   z, l107
l108:
    ; ut88.cmm:1675 e = a;
    ld   e, a
    ; ut88.cmm:1676 // Цикл
    ; ut88.cmm:1677 } while (flag_nz c--);
    dec  c
    jp   nz, l105
l106:
    ; ut88.cmm:1678 
    ; ut88.cmm:1679 // Вычисляем константу на основе полученной длительности
    ; ut88.cmm:1680 hl += hl += hl;
    add  hl, hl
    add  hl, hl
    ; ut88.cmm:1681 if (flag_p (a = h) |= a)
    ld   a, h
    or   a
    ; ut88.cmm:1682 {
    jp   m, l109
    ; ut88.cmm:1683 invert(a);
    cpl
    ; ut88.cmm:1684 (a &= 0x20) >>r= 3;
    and  32
    rrca
    rrca
    rrca
    ; ut88.cmm:1685 b = a;
    ld   b, a
    ; ut88.cmm:1686 a >>r= 1 >>@= 1;
    rrca
    rra
    ; ut88.cmm:1687 a += b;
    add  b
    ; ut88.cmm:1688 a++;
    inc  a
    ; ut88.cmm:1689 b = a;
    ld   b, a
    ; ut88.cmm:1690 (a = h) -= b;
    ld   a, h
    sub  b
    ; ut88.cmm:1691 }
    ; ut88.cmm:1692 
    ; ut88.cmm:1693 // Сохранение константы
    ; ut88.cmm:1694 vTapeSpeedRd = a;
l109:
    ld   (vTapeSpeedRd), a
    ; ut88.cmm:1695 
    ; ut88.cmm:1696 // Включение прерываний
    ; ut88.cmm:1697 enableInterrupts();
    ei
    ; ut88.cmm:1698 
    ; ut88.cmm:1699 // Вывод константы на экран
    ; ut88.cmm:1700 put8Sp();
    call put8Sp
    ; ut88.cmm:1701 
    ; ut88.cmm:1702 // Возврат в Монитор
    ; ut88.cmm:1703 return monitor();
    jp   monitor
    ; ut88.cmm:1704 noreturn;
    ; ut88.cmm:1705 }
    ; ut88.cmm:1706 
    ; ut88.cmm:1707 // Выравнивание?
    ; ut88.cmm:1708 
    ; ut88.cmm:1709 uint8_t unknown[] = { 0xFF };
unknown:
    db 255
    ; ut88.cmm:1710 
    ; ut88.cmm:1711 // Загрузка байта c магнитной ленты.
    ; ut88.cmm:1712 // Параметры: a = 8 с поиском синхробайта, a = без поиска. Результат: a - считанный байт. Сохраняет: bc, de, hl.
    ; ut88.cmm:1713 
    ; ut88.cmm:1714 void tapeInput2()
tapeInput2:
    ; ut88.cmm:1715 {
    ; ut88.cmm:1716 disableInterrupts();
    di
    ; ut88.cmm:1717 push(hl, bc, de);
    push hl
    push bc
    push de
    ; ut88.cmm:1718 return tapeInput3();
    jp   tapeInput3
    ; ut88.cmm:1719 noreturn;
    ; ut88.cmm:1720 }
    ; ut88.cmm:1721 
    ; ut88.cmm:1722 // Выход из функций tapeInput3, tapeOutput3.
    ; ut88.cmm:1723 
    ; ut88.cmm:1724 void tapeInputOutputEnd(a)
tapeInputOutputEnd:
    ; ut88.cmm:1725 {
    ; ut88.cmm:1726 pop(hl, bc, de);
    pop  de
    pop  bc
    pop  hl
    ; ut88.cmm:1727 enableInterrupts();
    ei
    ; ut88.cmm:1728 return tapeInputOutputEnd2();
    jp   tapeInputOutputEnd2
    ; ut88.cmm:1729 noreturn;
    ; ut88.cmm:1730 }
    ; ut88.cmm:1731 
    ; ut88.cmm:1732 // Запись байта на магнитную ленту.
    ; ut88.cmm:1733 // Параметры: с = байт. Результат: нет. Сохраняет: bc, de, hl.
    ; ut88.cmm:1734 
    ; ut88.cmm:1735 void tapeOutput2(c)
tapeOutput2:
    ; ut88.cmm:1736 {
    ; ut88.cmm:1737 disableInterrupts();
    di
    ; ut88.cmm:1738 push(hl, bc, de);
    push hl
    push bc
    push de
    ; ut88.cmm:1739 return tapeOutput3();
    jp   tapeOutput3
    ; ut88.cmm:1740 noreturn;
    ; ut88.cmm:1741 }
    ; ut88.cmm:1742 
    ; ut88.cmm:1743 // Продложение разбора команды введенной пользователем.
    ; ut88.cmm:1744 // Параметры: нет. Функция никогда не завершается.
    ; ut88.cmm:1745 
    ; ut88.cmm:1746 void monitor3(a, hl, de)
monitor3:
    ; ut88.cmm:1747 {
    ; ut88.cmm:1748 // Разбор команд
    ; ut88.cmm:1749 if (a == 'K') return cmdK(hl, de);
    cp   75
    jp   z, cmdK
    ; ut88.cmm:1750 
    ; ut88.cmm:1751 // Возврат в Монитор, если введена неизвестная команда.
    ; ut88.cmm:1752 return monitor(); //! Ошибка. Должен быть переход на error.
    jp   monitor
    ; ut88.cmm:1753 noreturn;
    ; ut88.cmm:1754 }
    ; ut88.cmm:1755 
    ; ut88.cmm:1756 // Команда K <начальный адрес> <конечный адрес>
    ; ut88.cmm:1757 // Вычисление 16-битной суммы всех байт по адресам hl..de.
    ; ut88.cmm:1758 
    ; ut88.cmm:1759 void cmdK(hl, de)
cmdK:
    ; ut88.cmm:1760 {
    ; ut88.cmm:1761 // Расчет контрольной суммы
    ; ut88.cmm:1762 push(hl)
    ; ut88.cmm:1763 {
    push hl
    ; ut88.cmm:1764 calcSum(hl, de); // Результат в bc
    call calcSum
    ; ut88.cmm:1765 }
    pop  hl
    ; ut88.cmm:1766 
    ; ut88.cmm:1767 // Вывод: начальный адрес, конечный адрес, контрольная сумма
    ; ut88.cmm:1768 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:1769 swap(de, hl);
    ex de, hl
    ; ut88.cmm:1770 putCrLfTabHlSp(hl);
    call putCrLfTabHlSp
    ; ut88.cmm:1771 swap(de, hl);
    ex de, hl
    ; ut88.cmm:1772 push(hl)
    ; ut88.cmm:1773 {
    push hl
    ; ut88.cmm:1774 putCrLfTabHlSp(hl = bc);
    ld   h, b
    ld   l, c
    call putCrLfTabHlSp
    ; ut88.cmm:1775 }
    pop  hl
    ; ut88.cmm:1776 
    ; ut88.cmm:1777 // Возврат в Монитор
    ; ut88.cmm:1778 return monitor();
    jp   monitor
    ; ut88.cmm:1779 noreturn;
    ; ut88.cmm:1780 }
    ; ut88.cmm:1781 
    ; ut88.cmm:1782 // Выравнивание?
    ; ut88.cmm:1783 
    ; ut88.cmm:1784 uint8_t padding[] =
    ; ut88.cmm:1785 {
    ; ut88.cmm:1786 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    ; ut88.cmm:1787 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    ; ut88.cmm:1788 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    ; ut88.cmm:1789 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    ; ut88.cmm:1790 0xFF, 0xFF, 0xFF
    ; ut88.cmm:1791 };
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
    db 255
    ; ut88.cmm:1792 
    ; ut88.cmm:1793 // Эта функция не используется. Это что то связанное с микроЭВМ минимальной конфигурации.
    ; ut88.cmm:1794 
    ; ut88.cmm:1795 extern uint8_t  FFC0_var_0 = 0xF6FD;
FFC0_var_0=63229
    ; ut88.cmm:1796 extern uint16_t FFC0_var_1 = 0xF6FE;
FFC0_var_1=63230
    ; ut88.cmm:1797 
    ; ut88.cmm:1798 void FFC0()
FFC0:
    ; ut88.cmm:1799 {
    ; ut88.cmm:1800 nop();
    nop
    ; ut88.cmm:1801 disableInterrupts();
    di
    ; ut88.cmm:1802 push(a, bc, de, hl)
    ; ut88.cmm:1803 {
    push af
    push bc
    push de
    push hl
    ; ut88.cmm:1804 hl = &FFC0Table;
    ld   hl, FFC0Table
    ; ut88.cmm:1805 de = &FFC0_var_0;
    ld   de, FFC0_var_0
    ; ut88.cmm:1806 b = 3;
    ld   b, 3
    ; ut88.cmm:1807 do
l110:
    ; ut88.cmm:1808 {
    ; ut88.cmm:1809 a = *de;
    ld   a, (de)
    ; ut88.cmm:1810 a++;
    inc  a
    ; ut88.cmm:1811 daa();
    daa
    ; ut88.cmm:1812 *de = a;
    ld   (de), a
    ; ut88.cmm:1813 if (a != *hl) break;
    cp   (hl)
    jp   nz, l111
    ; ut88.cmm:1814 *de = (a ^= a);
    xor  a
    ld   (de), a
    ; ut88.cmm:1815 hl++;
    inc  hl
    ; ut88.cmm:1816 de++;
    inc  de
    ; ut88.cmm:1817 } while (flag_nz b--);
    dec  b
    jp   nz, l110
l111:
    ; ut88.cmm:1818 hl = FFC0_var_1;
    ld   hl, (FFC0_var_1)
    ; ut88.cmm:1819 a = FFC0_var_0;
    ld   a, (FFC0_var_0)
    ; ut88.cmm:1820 *0x9000 = a;
    ld   (36864), a
    ; ut88.cmm:1821 *0x9001 = hl;
    ld   (36865), hl
    ; ut88.cmm:1822 }
    pop  hl
    pop  de
    pop  bc
    pop  af
    ; ut88.cmm:1823 enableInterrupts();
    ei
    ; ut88.cmm:1824 }
    ret
    ; ut88.cmm:1825 
    ; ut88.cmm:1826 uint8_t FFC0Table[] = { 0x60, 0x60, 0x24 };
FFC0Table:
    db 96
    db 96
    db 36
    ; ut88.cmm:1827 
    ; ut88.cmm:1828 // Команда B
    ; ut88.cmm:1829 // Вывод информации о времени на светодиодные индикаторы
    ; ut88.cmm:1830 // (при одновременной работе МОНИТОРа микроЭВМ минимальной конфигурации)
    ; ut88.cmm:1831 
    ; ut88.cmm:1832 void cmdB()
cmdB:
    ; ut88.cmm:1833 {
    ; ut88.cmm:1834 // Обращение к монитору минимальной конфигурации
    ; ut88.cmm:1835 hl = *0xC3FE;
    ld   hl, (50174)
    ; ut88.cmm:1836 a = *0xC3FD;
    ld   a, (50173)
    ; ut88.cmm:1837 rst(0x28);
    rst 40
    ; ut88.cmm:1838 rst(0x18);
    rst 24
    ; ut88.cmm:1839 
    ; ut88.cmm:1840 // Возврат
    ; ut88.cmm:1841 return monitor();
    jp   monitor
    ; ut88.cmm:1842 noreturn;
    ; ut88.cmm:1843 }
    ; ut88.cmm:1844 
