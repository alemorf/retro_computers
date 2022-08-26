// Iskra 1080 Tartu online emulator
// Copyright 26-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

function Iskra1080Keyboard() {
    const translate = {
        54 : 0,  // 6
        85 : 1,  // U
        74 : 2,  // J
        77 : 3,  // M
        55 : 4,  // 7
        73 : 5,  // I
        75 : 6,  // K
        117 : 7, // Б` на F6

        53 : 8,   // 5
        89 : 9,   // Y
        72 : 10,  // H
        78 : 11,  // N
        56 : 12,  // 8
        79 : 13,  // O
        76 : 14,  // L
        118 : 15, // Ю@ на F7

        52 : 16,  // 4
        84 : 17,  // T
        71 : 18,  // G
        66 : 19,  // B
        57 : 20,  // 9
        80 : 21,  // P
        59 : 22,  // Ж[
        192 : 23, // ÕЁ

        115 : 24, // RUS
        116 : 25, // LAT
        45 : 26,  // COP на Insert
        16 : 27,  // SHIFT
        111 : 28, // NUM LOCK на правом /*
        46 : 29,  // DEL
        20 : 30,  // CAPS
        32 : 31,  // SPACE

        51 : 32,  // ;3
        82 : 33,  // R
        70 : 34,  // F
        86 : 35,  // V
        48 : 36,  // 0
        219 : 37, // [{Х  Х{
        222 : 38, // '"Э  Э]
        188 : 39, // ,

        50 : 40,  // 2
        69 : 41,  // E
        68 : 42,  // D
        67 : 43,  // C
        173 : 44, // -= на -_
        221 : 45, // }Ъ
        106 : 46, // :* на правой *
        190 : 47, // .>

        49 : 48,  // 1
        110 : 49, // Правая .
        65 : 50,  // A
        90 : 51,  // Z
        61 : 52,  // ~^ на правом +=
        191 : 53, // /?
        107 : 54, // +; на правом +
        96 : 55,  // Правый 0

        // : 56, // Неизвестная клавиша!
        87 : 57, // W
        83 : 58, // S
        88 : 59, // X
        8 : 60,  // RUB
        36 : 61,
        103 : 61, // 7 HOME
        37 : 62,
        100 : 62, // 4 LEFT
        35 : 63,
        97 : 63, // 1 END

        13 : 64,  // ENTER
        81 : 65,  // Q
        9 : 66,   // TAB
        17 : 67,  // CTRL
        220 : 68, // \
        38 : 69,
        104 : 69, // 8 UP
        12 : 70,
        101 : 70, // Правая 5
        40 : 71,
        98 : 71, // 2 DOWN

        114 : 72, // F3
        // : 73, // Неизвестная клавиша!
        112 : 74, // F2
        113 : 75, // F3
        27 : 76,  // ESC
        33 : 77,
        105 : 77, // 9 PGUP
        39 : 78,
        102 : 78, // 6 RIGHT
        34 : 79,
        99 : 79, // 3 PGDN
    };

    // Пользовательский интерфейс
    let ui = [];
    for (let i = 0; i < 100; i++) {
        let o = document.getElementById("key" + i);
        if (o) {
            ui[i] = o;
            o._i = i;
            o.onmousedown = function() { processIskra1080Key(true, this._i); };
            o.onmouseup = function() { processIskra1080Key(false, this._i); };
        }
    }

    let matrix = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];

    function processKey(pressed, e) {
        let pcCode = 'which' in e ? e.which : e.keyCode;
        // document.title = pcCode;
        return processIskra1080Key(pressed, translate[pcCode]);
    }

    function processIskra1080Key2(code, pressed) {
        let row = code % 8, col = (code - row) / 8;
        if (pressed)
            matrix[col] |= (1 << row);
        else
            matrix[col] &= ~(1 << row);
        let u = ui[code];
        if (u)
            u.style.background = pressed ? "#A0A0A0" : "";
    }

    this.emulate = processIskra1080Key2;

    function processIskra1080Key(pressed, code) {
        if (code === undefined)
            return true;
        processIskra1080Key2(code, pressed);
        return false;
    }

    let select = 0;

    this.read = function(addr) { return matrix[select]; }

                this.write = function(addr, data) {
        select = data & 0x0F;
        // TODO: LEDS
    };

    document.onkeydown = function(e) { return processKey(true, e); };

    document.onkeyup = function(e) { return processKey(false, e); };
}
