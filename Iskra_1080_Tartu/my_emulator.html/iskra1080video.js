// Iskra 1080 Tartu online emulator
// Copyright 26-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

function Iskra1080Video(canvas, memory, palette) {
    let ctx = canvas.getContext("2d");
    canvas.width = 384;
    canvas.height = 256;

    let canvasData = ctx.getImageData(0, 0, 384, 256);

    for (let i = 0, is = canvas.width * canvas.height * 4; i < is; i++)
        canvasData.data[i] = 255;

    let mode = 0;

    this.setMode = function(m) { mode = m; };

    const palette16 = [
        [
            0xFF,
            0xFF,
            0xFF,
        ],
        [
            0x00,
            0xFF,
            0xFF,
        ],
        [
            0xFF,
            0x00,
            0xFF,
        ],
        [
            0x00,
            0x00,
            0xFF,
        ],
        [
            0xFF,
            0xFF,
            0x00,
        ],
        [
            0x00,
            0xFF,
            0x00,
        ],
        [
            0xFF,
            0x00,
            0x00,
        ],
        [
            0x00,
            0x00,
            0x00,
        ],
        [
            0x90,
            0x90,
            0x90,
        ],
        [
            0x00,
            0x90,
            0x90,
        ],
        [
            0x90,
            0x00,
            0x90,
        ],
        [
            0x00,
            0x00,
            0x90,
        ],
        [
            0x90,
            0x90,
            0x00,
        ],
        [
            0x00,
            0x90,
            0x00,
        ],
        [
            0x90,
            0x00,
            0x00,
        ],
        [
            0x00,
            0x00,
            0x00,
        ],
    ];

    this.make = function() {
        let ma = 0xFFFF;
        let mc = 0xBFFF;
        for (let x = 0; x < 384; x += 8) {
            for (let y = 0; y < 256; y++) {
                let va = x * 4 + y * 384 * 4;
                let b = memory[ma];
                ma--;
                let c = (mode === 2) ? 0 : memory[mc];
                mc--;
                for (let j = 8; j--; b <<= 1, c <<= 1) {
                    const color4 = ((b & 0x80) ? 2 : 0) | ((c & 0x80) ? 1 : 0);
                    const color16 = palette16[palette[color4]];
                    canvasData.data[va + 0] = color16[0];
                    canvasData.data[va + 1] = color16[1];
                    canvasData.data[va + 2] = color16[2];
                    va += 4;
                }
            }
        }
        ctx.putImageData(canvasData, 0, 0);
    };
}
