function Rk86Keyboard()
{
    const pcToRkTranslate = 
    {
         36: 0,  // UpLeft = Home
         35: 1,  // CTP = End
         27: 2,  // AP2 = Esc
        112: 3,  // F1
        113: 4,  // F2
        114: 5,  // F3
        115: 6,  // F4
          9: 8,  // Tab
         34: 9,  // ПС = Page Down
         13: 10, // BK = Enter
          8: 11, // ЗБ = Backspace
         37: 12, // Left
         38: 13, // Up
         39: 14, // Right
         40: 15, // Down
         48: 16, // 0
         49: 17, // 1
         50: 18, // 2
         51: 19, // 3
         52: 20, // 4
         53: 21, // 5
         54: 22, // 6
         55: 23, // 7
         56: 24, // 8
         57: 25, // 9
         59: 26, // :
         61: 27, // ;+
        188: 28, // ,
        173: 29, // -
        190: 30, // .
        191: 31, // /
        222: 32, // @ = '
         65: 33, // A
         66: 34, // B
         67: 35, // C
         68: 36, // D
         69: 37, // E
         70: 38, // F
         71: 39, // G
         72: 40, // H
         73: 41, // I
         74: 42, // J
         75: 43, // K
         76: 44, // L
         77: 45, // M
         78: 46, // N
         79: 47, // O
         80: 48, // P
         81: 49, // Q
         82: 50, // R
         83: 51, // S
         84: 52, // T
         85: 53, // U
         86: 54, // V
         87: 55, // W
         88: 56, // X
         89: 57, // Y
         90: 58, // Z
        219: 59, // [
        220: 60, // \
        221: 61, // ]
        192: 62, // ^ = `
         32: 63, // Space
         16: 69, // SS = Shift
        117: 70, // US = F6
         20: 71, // Rus = Caps
    };

    // Пользовательский интерфейс
    var ui = [];
    for(var i=0; i<72; i++)
    {
        var o = document.getElementById("key" + i);
        if(o)
        {
            ui[i] = o;
            o._i = i;
            o.onmousedown = function() { processRkKey(true, this._i); };
            o.onmouseup = function() { processRkKey(false, this._i); };
        }
    }

    var matrix = [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];

    function processKey(pressed, e)
    {
	var pcCode = 'which' in e ? e.which : e.keyCode;
        return processRkKey(pressed, pcToRkTranslate[pcCode]);
    }

    function processRkKey(pressed, rkCode)
    {
        if (rkCode == undefined) return true;
        var row = rkCode >> 3, mask = 1 << (rkCode & 7);
        if(pressed)
        {
           matrix[row] &= ~mask;
        }
        else
        {
           matrix[row] |= mask;
        }
        var u = ui[rkCode];
        if(u) u.style.background = pressed ? "#A0A0A0" : "";
        return false;
    }
    
    this.read = function(mask)
    {
        var result = 0xFF;
        for (var i = 0; i < 8; i++, mask >>= 1)
            if ((mask & 1) == 0)
                result &= matrix[i];
        return result;
    }

    this.readShifts = function()
    {
        return matrix[8];
    }
    
    document.body.addEventListener("mouseup", function () { 
        matrix = [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];
        for (let o in ui) {
            ui[o].style.background = "";
        }
    });

    document.onkeydown = function(e)
    {
        return processKey(true, e);
    }

    document.onkeyup = function(e)
    {
        return processKey(false, e);
    }
}
