function SpecialistKeyboard()
{
    const translate = 
    {
       112:  71,  // F1
       113:  70,  // F2
       114:  69,  // F3
       115:  68,  // F4
       116:  67,  // F5
       117:  66,  // F6
       118:  65,  // F7
       119:  64,  // F8
       120:  63,  // F9
       121:  62,  // F10
       122:  61,  // F11
       123:  60,  // F12

        61:  59, // ;+
        49:  58, // 1
        50:  57, // 2
        51:  56, // 3
        52:  55, // 4
        53:  54, // 5
        54:  53, // 6
        55:  52, // 7
        56:  51, // 8
        57:  50, // 9
        48:  49, // 0
       173:  48, // -=

        74:  47, // J
        67:  46, // C
        85:  45, // U
        75:  44, // K
        69:  43, // E
        78:  42, // N
        71:  41, // G
       219:  40, // [
       221:  39, // ]
        90:  38, // Z
        72:  37, // H
        59:  36, // : 

        70:  35, // F
        89:  34, // Y
        87:  33, // W
        65:  32, // A
        80:  31, // P
        82:  30, // R
        79:  29, // O
        76:  28, // L
        68:  27, // D
        86:  26, // V
        220: 25, // \
        190: 24, // >

        81:  23, // Q
        192: 22, // |
        83:  21, // S
        77:  20, // M
        73:  19, // I
        84:  18, // T
        88:  17, // X
        66:  16, // B
        222: 15, // @
        188: 14, // <
        191: 13, // ?
        8:   12, // ЗБ

        17:  11, // РУС
        36:  10, // HOME
        38:  9,  // UP
        40:  8,  // DOWN
        9:   7,  // TAB
        27:  6,  // ESC
        32:  5,  // SPACE
        37:  4,  // LEFT
        35:  3,  // PV
        39:  2,  // RIGHT
        34:  1,  // PS
        13:  0,  // ENTER

        16:  72, // Shift
    };

    // Пользовательский интерфейс
    var ui = [];
    for(var i=0; i<73; i++)
    {
        var o = document.getElementById("key" + i);
        if(o)
        {
            ui[i] = o;
            o._i = i;
            o.onmousedown = function() { processSpecialistKey(true, this._i); };
            o.onmouseup = function() { processSpecialistKey(false, this._i); };
        }
    }

    var matrixA = [ 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF ];
    var matrixB = [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];

    function processKey(pressed, e)
    {
        var pcCode = 'which' in e ? e.which : e.keyCode;
        //document.title = pcCode;
        return processSpecialistKey(pressed, translate[pcCode]);
    }

    function processSpecialistKey(pressed, code)
    {
        if (code == undefined) return true;
        var row = code % 12, col = (code - row) / 12;
        if(pressed) matrixB[row] &= ~(4 << col), matrixA[col] &= ~(1 << row);
               else matrixB[row] |=  (4 << col), matrixA[col] |=  (1 << row);
        var u = ui[code];
        if(u) u.style.background = pressed ? "#A0A0A0" : "";
        return false;
    }

    //    C3,C2,C1,C0,A7,A6,A5,A4,A3,A2,A1,A0
    // B7 F1 F2 F3 F4 F5 F6 F7 F8 F9 F10
    // B6    1  2  3  4  5  6  7  8  9
    // B5 Й  Ц  У  К  Е  Н  Г  Ш  Щ  З  Х  *
    // B4 Ф  Ы  В  А  П  Р  О  Л  Д  Ж  Э
    // B3 Я  Ч  С  М  И  Т  Ь  Б  Ю
    // B2 

    var b = [ 0, 0, 0, 0 ];
    this.b = b;

    this.read = function(addr)
    {
        if(addr == 3) return b[3];
        if(addr == 1)
        {
            if((b[3] & 2) == 0) return b[2];
            var mask = b[0] | (b[2] << 8);
            var result = 0xFF;
            for (var i = 0; i < 12; i++, mask >>= 1)
                if ((mask & 1) == 0)
                    result &= matrixB[i];
            if((matrixA[6] & 1) == 0) result &= ~2;
            return result;
        }
        if(addr == 0 || addr == 2)
        {
            // проверить режим!
            var mask = b[1] >> 2;
            var result = 0xFFFF;
            for (var i = 0; i < 6; i++, mask >>= 1)
                if ((mask & 1) == 0)
                    result &= matrixA[i];
            return addr == 0 ? (result & 0xFF) : (result >> 8);
        }
    }

    this.write = function(addr, data)
    {
        if(addr == 3)
        {
            b[0] = 0;
            b[1] = 0;
            b[2] = 0;
            // [ 1 MODE MODE A C2 MODE B C1 ]
        }
        b[addr] = data;
    }

    document.onkeydown = function(e)
    {
        return processKey(true, e);
    }

    document.onkeyup = function(e)
    {
        return processKey(false, e);
    }
}