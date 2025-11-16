// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Micro80Video(id, ram) {
    let canvas = document.getElementById(id);
    let ctx = canvas.getContext("2d");
    let canvasData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    const charWidth = 8;
    const charHeight = 10;
    const textWidth = 64;
    const textHeight = 32;
    const bytesPerPixel = 4;
    const normalColor = 0xA0;

    function drawChar(x, y, b, c) {
        const textH = ((c >> 6) & 1) * (0xFF - normalColor);
        const textR = ((c >> 0) & 1) * normalColor + textH;
        const textG = ((c >> 1) & 1) * normalColor + textH;
        const textB = ((c >> 2) & 1) * normalColor + textH;
        const backR = ((c >> 3) & 1) * normalColor;
        const backG = ((c >> 4) & 1) * normalColor;
        const backB = ((c >> 5) & 1) * normalColor;

        let va = (x * charWidth + y * charHeight * canvas.width) * bytesPerPixel;
        for (let cy = 0; cy < charHeight; cy++) {
            const d = font[cy % 8 + b * 8 + (cy & 8 ? 0x800 : 0) + (c & 0x80 ? 0x1000 : 0)];
            for (let cx = 0; cx < charWidth; cx++) {
                if (d & (0x80 >> cx)) {
                    canvasData.data[va++] = backR;
                    canvasData.data[va++] = backG;
                    canvasData.data[va++] = backB;
                } else {
                    canvasData.data[va++] = textR;
                    canvasData.data[va++] = textG;
                    canvasData.data[va++] = textB;
                }
                canvasData.data[va++] = 0xFF;
            }
            va += (textWidth - 1) * charWidth * bytesPerPixel;
        }
    }

    this.redraw = function() {
        let a = 0xE800, b = 0xE000;
        for (let y = 2; y < textHeight; y++)
            for (let x = 0; x < textWidth; x++)
                drawChar(x, y, ram[a++], ram[b++]);
        for (let y = 0; y < 2; y++)
            for (let x = 0; x < textWidth; x++)
                drawChar(x, y, ram[a++], ram[b++]);

        ctx.putImageData(canvasData, 0, 0);
    };
}
