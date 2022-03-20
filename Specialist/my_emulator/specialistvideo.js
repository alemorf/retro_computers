function SpecVideo(canvas, memory, memory2)
{
    var ctx = canvas.getContext("2d");
    canvas.width = 384;
    canvas.height = 256;

    var canvasData = ctx.getImageData(0, 0, 384, 256);

    for(var i=0, is=canvas.width*canvas.height*4; i<is; i++)
        canvasData.data[i] = 255;

    this.make = function()
    {
        var ma = 0x9000;
        for(var x=0; x<384; x+=8)
        {
            for(var y=0; y<256; y++)
            {
                var va = x * 4 + y * 384 * 4;
                var b = memory[ma];
                var c = memory2[ma++];
                for(var j=8; j--; b <<= 1)
                {
                    canvasData.data[va+0] = (b & 0x80) && !(c & 0x80) ? 0xFF : 0;
                    canvasData.data[va+1] = (b & 0x80) && !(c & 0x40) ? 0xFF : 0;
                    canvasData.data[va+2] = (b & 0x80) && !(c & 0x10) ? 0xFF : 0;
                    va += 4;
                }
            }
        }
        ctx.putImageData(canvasData, 0, 0);
    }
}
