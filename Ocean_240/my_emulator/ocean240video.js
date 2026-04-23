// Ocean 240.2 computer emulator
// (c) 01-01-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Ocean240Video(canvasId, memory) {
    let canvas = document.getElementById(canvasId);
    let ctx = canvas.getContext("2d");
    let w = 1024;
    canvas.style.width = w + "px";
    canvas.style.height = Math.round(w / 4 * 3) + "px";
    canvas.width = 512;
    canvas.height = 512;

    let canvasData = ctx.getImageData(0, 0, 512, 512);

    for (let i = 0, is = canvas.width * canvas.height * 4; i < is; i++)
        canvasData.data[i] = 255;

    let mode = 0;

    this.setMode = function(m) {
        mode = m;
    };

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

    let scrollY = 0;

    this.setScrollY =
        function(value) {
        scrollY = value;
    }

    let color = 0;

    this.setColor =
        function(value) {
        color = value;
    }

        this.make = function() {
        const br = (color & 0x08) ? 0x80 : 0;
        const bg = (color & 0x10) ? 0x80 : 0;
        const bb = (color & 0x20) ? 0x80 : 0;

        let ma = 0xC000;
        if (color & 0x40) {
            const color_palette = [
                [ 1, 2, 4, 8 ], [ 0xE, 2, 4, 8 ], [ 2, 4, 0xC, 6 ], [ 1, 2, 0xA, 0xE ], [ 1, 2, 6, 8 ], [ 1, 8, 4, 6 ],
                [ 4, 0xE, 6, 8 ], [ 0, 0, 0, 0 ]
            ];

            const cur_palette = color_palette[color & 7];

            for (let x = 0; x < 256; x += 8) {
                for (let y = 0; y < 256; y++) {
                    let va = x * 8 + (y + 256 - scrollY) % 256 * 1024 * 4;
                    let b = memory[ma] | memory[ma + 256] << 8;
                    ma++;
                    for (let j = 8; j--; b >>= 1) {
                        const color4 = cur_palette[(b & 1) | ((b >> 7) & 2)];
                        const cr = (color4 & 8) ? 0xFF : ((color4 & 1) ? br : 0);
                        const cg = (color4 & 2) ? 0xFF : ((color4 & 1) ? bg : 0);
                        const cb = (color4 & 4) ? 0xFF : ((color4 & 1) ? bb : 0);
                        canvasData.data[va + 0] = cr;
                        canvasData.data[va + 1] = cg;
                        canvasData.data[va + 2] = cb;
                        canvasData.data[va + 4] = cr;
                        canvasData.data[va + 5] = cg;
                        canvasData.data[va + 6] = cb;
                        canvasData.data[va + 2048] = cr;
                        canvasData.data[va + 2049] = cg;
                        canvasData.data[va + 2050] = cb;
                        canvasData.data[va + 2052] = cr;
                        canvasData.data[va + 2053] = cg;
                        canvasData.data[va + 2054] = cb;
                        va += 8;
                    }
                }
                ma += 256;
            }
        } else {
            const mono_palette = [
                [ 1, 0xE ],
                [ 1, 2 ],
                [ 1, 4 ],
                [ 1, 8 ],
                [ 1, 0xC ],
                [ 1, 6 ],
                [ 4, 1 ],
                [ 0, 0 ],
            ];

            const cur_palette = mono_palette[color & 7];

            for (let x = 0; x < 256; x += 8) {
                for (let y = 0; y < 256; y++) {
                    let va = x * 8 + (y + 256 - scrollY) % 256 * 1024 * 4;
                    let b = memory[ma] | memory[ma + 256] << 8;
                    ma++;
                    for (let j = 16; j--; b >>= 1) {
                        const color4 = cur_palette[b & 1];
                        const cr = (color4 & 2) ? 0xFF : ((color4 & 1) ? br : 0);
                        const cg = (color4 & 4) ? 0xFF : ((color4 & 1) ? bg : 0);
                        const cb = (color4 & 8) ? 0xFF : ((color4 & 1) ? bb : 0);
                        canvasData.data[va + 0] = cr;
                        canvasData.data[va + 1] = cg;
                        canvasData.data[va + 2] = cb;
                        canvasData.data[va + 2048] = cr;
                        canvasData.data[va + 2049] = cg;
                        canvasData.data[va + 2050] = cb;
                        va += 4;
                    }
                }
                ma += 256;
            }
        }
        ctx.putImageData(canvasData, 0, 0);
    };
}
