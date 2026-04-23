// Ocean 240.2 computer emulator
// (c) 01-01-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Ocean240Keyboard() {
    const keys = [
        [ "rect1390", 3, 0, 'F1' ],     // k1
        [ "rect1390-3", 4, 0, 'F2' ],   // k2
        [ "rect1390-5", 5, 0, 'F3' ],   // k3
        [ "rect1390-6", 7, 0, 'F4' ],   // k4
        [ "rect1390-9", 8, 0, 'F5' ],   // k5
        [ "rect1390-2", 5, 7, 'F6' ],   // Pom
        [ "rect1390-0", 5, 6, 'F7' ],   // Ust
        [ "rect1390-62", 4, 6, 'F8' ],  // Isp
        [ "rect1390-61", 4, 7, 'F10' ], // Reset
        [ "rect1390-7", 11, 0, 'F11' ], // Real Reset

        [ "rect1390-1", 1, 0, 'ESCAPE' ],       // AP2
        [ "rect1390-1-3", 2, 0, '=', '+' ],     // ; +
        [ "rect1390-1-7", 3, 1, '1', '!' ],     // 1
        [ "rect1390-1-5", 4, 1, '2', '@' ],     // 2
        [ "rect1390-1-0", 5, 1, '3', '#' ],     // 3
        [ "rect1390-1-3-6", 6, 0, '4', '$' ],   // 4
        [ "rect1390-1-7-1", 7, 1, '5', '%' ],   // 5
        [ "rect1390-1-5-5", 8, 1, '6', '^' ],   // 6
        [ "rect1390-1-78", 9, 0, '7', '&' ],    // 7
        [ "rect1390-1-3-68", 10, 0, '8', '*' ], // 8
        [ "rect1390-1-7-8", 10, 7, '9', '(' ],  // 9
        [ "rect1390-1-5-4", 9, 7, '0', ')' ],   // 0
        [ "rect1390-1-7-8-4", 8, 7, '-', '_' ], // - =
        [ "rect1390-1-5-4-9", 8, 6, '`', '~' ], // : *
        [ "rect1390-02", 5, 5, 'BACKSPACE' ],   // Backspace

        [ "rect1390-37", 1, 1, 'TAB' ],            // Tab
        [ "rect1390-1-3-5", 2, 1, 'J' ],           // j
        [ "rect1390-1-7-0", 3, 2, 'C' ],           // c
        [ "rect1390-1-5-6", 4, 2, 'U' ],           // u
        [ "rect1390-1-0-4", 5, 2, 'K' ],           // k
        [ "rect1390-1-3-6-6", 6, 1, 'E' ],         // e
        [ "rect1390-1-7-1-2", 7, 2, 'N' ],         // n
        [ "rect1390-1-5-5-5", 8, 2, 'G' ],         // g
        [ "rect1390-1-78-8", 9, 1 ],               // [
        [ "rect1390-1-3-68-6", 10, 1 ],            // ]
        [ "rect1390-1-7-8-2", 10, 6, 'Z' ],        //  z
        [ "rect1390-1-5-4-8", 9, 6, 'H' ],         //  h
        [ "rect1390-1-7-8-4-4", 7, 7 ],            // _
        [ "rect1390-1-5-4-9-7", 6, 7 ],            // ?
        [ "rect1390-1-5-4-9-7-3", 6, 6, 'ENTER' ], // Enter

        [ "rect1390-37-3", 1, 2, 'CONTROL' ], // Ctrl
        [ "rect1390-1-3-56", 2, 2, 'F' ],     // f
        [ "rect1390-1-7-6", 3, 3, 'Y' ],      // y
        [ "rect1390-1-5-40", 4, 3, 'W' ],     // w
        [ "rect1390-1-0-0", 5, 3, 'A' ],      // a
        [ "rect1390-1-3-6-4", 6, 2, 'P' ],    // p
        [ "rect1390-1-7-1-6", 7, 3, 'R' ],    // r
        [ "rect1390-1-5-5-2", 8, 3, 'O' ],    // o
        [ "rect1390-1-78-6", 9, 2, 'L' ],     // l
        [ "rect1390-1-3-68-7", 10, 2, 'D' ],  // d
        [ "rect1390-1-7-8-5", 10, 5, 'V' ],   // v
        [ "rect1390-1-5-4-6", 9, 5 ],         // \
        [ "rect1390-1-7-8-4-9", 8, 5, '.' ],  // >

        [ "rect1390-1-3-3-3", 1, 4, 'ALT' ],            // Alf
        [ "rect1390-1-3-3", 1, 3 ],                     // Graf
        [ "rect1390-1-7-14", 2, 3, 'Q' ],               // q
        [ "rect1390-1-5-69", 3, 4 ],                    // _
        [ "rect1390-1-0-42", 4, 4, 'S' ],               // s
        [ "rect1390-1-3-6-2", 5, 4, 'M' ],              // m
        [ "rect1390-1-7-1-64", 6, 3, 'I' ],             // i
        [ "rect1390-1-5-5-1", 7, 4, 'T' ],              // t
        [ "rect1390-1-78-2", 8, 4, 'X' ],               // x
        [ "rect1390-1-3-68-8", 9, 3, 'B' ],             // b
        [ "rect1390-1-7-8-8", 10, 3 ],                  // `
        [ "rect1390-1-5-4-92", 10, 4, ',' ],            // <
        [ "rect1390-1-7-8-4-8", 9, 4, "ARROWLEFT" ],    // left
        [ "rect1390-1-5-4-9-88", 7, 6, "ARROWUP" ],     // up
        [ "rect1390-1-5-4-9-88-0", 7, 5, "ARROWDOWN" ], // down
        [ "rect1390-1-7-8-4-8-3", 6, 5, "ARROWRIGHT" ], // right

        [ "rect1390-37-3-8", 0, 4, 'SHIFT' ],       // Shift
        [ "rect1390-1-3-3-3-8", 2, 4, 'CAPSLOCK' ], // Fix
        [ "rect1390-1-3-3-3-0", 6, 4, ' ' ],        // Space
        [ "rect1390-37-3-8-9", 0, 4 ],              // Shift

        [ "rect1390-1-5-4-8-6", 4, 5 ],    // + *
        [ "rect1390-1-7-8-4-4-5", 0, 1 ],  // - /
        [ "rect1390-1-5-4-9-7-2", 0, 0 ],  // `
        [ "rect1390-1-5-4-8-9", 0, 5 ],    // 7
        [ "rect1390-1-7-8-4-4-1", 0, 6 ],  // 8
        [ "rect1390-1-5-4-9-7-5", 0, 7 ],  // 9
        [ "rect1390-1-5-4-8-7", 3, 5 ],    // 4
        [ "rect1390-1-7-8-4-4-4", 3, 6 ],  // 5
        [ "rect1390-1-5-4-9-7-9", 3, 7 ],  // 6
        [ "rect1390-1-5-4-8-94", 2, 5 ],   // 1
        [ "rect1390-1-7-8-4-4-59", 2, 6 ], // 2
        [ "rect1390-1-5-4-9-7-35", 2, 7 ], // 3
        [ "rect1390-1-5-4-8-70", 9, 7 ],   // 0
        [ "rect1390-1-7-8-4-4-8", 1, 6 ],  // .
        [ "rect1390-1-5-4-9-7-1", 1, 7 ],  // Enter
    ];

    let matrix = [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];

    let led0 = document.getElementById("path2638");
    let led1 = document.getElementById("path2638-5");

    function doKey(pressed, key) {
        let o = key[5];
        o.pressed = pressed;
        if (pressed) {
            o.style.transition = "all 0.1s";
            o.style.opacity = 0.5;
            matrix[key[1]] &= ~(0x80 >> key[2]);
        } else {
            o.style.opacity = 0.1;
            matrix[key[1]] |= (0x80 >> key[2]);
        }
    }

    for (i in keys) {
        let o = document.getElementById(keys[i][0]);
        keys[i][5] = o;
        o._keys = keys[i];
        o.style.opacity = 0.1;
        o.onmousedown = function() {
            doKey(true, this._keys);
        };
        o.onmouseup = function() {
            doKey(false, this._keys);
        };
    }

    let irq = -2;
    let control = 0;

    this.getIrq = function(tick, tickMax) {
        if (irq == -1)
            return false;
        if (irq >= 0 && (tickMax + tick - irq) % tickMax * 2 < tickMax)
            irq = -2;
        return irq == -2;
    };

    const irqDelay = 2400000 / 50;

    let nn = 0;

    this.write = function(byte, tick, tickMax) {
        control = byte;
        if (control & 0x20) {
            irq = -1;
        } else if (irq == -1) {
            irq = tick + irqDelay;
        }
    };

    let led0_state = -1;
    let led1_state = -1;

    this.animation = function() {
        const a = (control & 0x40);
        if (led0_state != a) {
            led0_state = a;
            led0.style.opacity = a ? 0 : 1;
        }
        const b = (control & 0x80);
        if (led1_state != b) {
            led1_state = b;
            led1.style.opacity = b ? 0 : 1;
        }
    };

    this.read = function(addr) {
        let result = 0xFF;
        const i = control & 0x0F;
        if (i < 10)
            result &= matrix[i];
        if (control & 0x10)
            result &= matrix[10];
        return result;
    };

    function processKey(pressed, e) {
        const c = (e.key + "").toUpperCase();
        for (i in keys) {
            let o = document.getElementById(keys[i][0]);
            if (keys[i][3] == c || keys[i][4] == c) {
                doKey(pressed, keys[i]);
                e.preventDefault();
                return false;
            }
        }
        return true;
    }

    document.onkeydown = function(e) {
        return processKey(true, e);
    };

    document.onkeyup = function(e) {
        return processKey(false, e);
    };
}
