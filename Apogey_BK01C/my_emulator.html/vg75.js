function Vg75(canvas, font, memory)
{
    var ctx              = canvas.getContext("2d");
    var dma_enabled      = false;
    var dma_int_start    = 0;
    var dma_int_size     = 0;
    var dma_start        = 0;
    var dma_end          = 0;
    var dma_addr         = 0;
    var transparent_attr = 0;
    var screen_width     = 78;
    var screen_height    = 30;
    var char_height      = 10;
    var underline_pos    = 0;
    var frame_trigger    = 0;
    var cmd75            = 0;
    var font_down        = 0;
    var screen           = 0;
    var screen1          = 0;
    var cursor_x         = 0;
    var cursor_y         = 0;
    var zoom_x           = 2;
    var zoom_y           = 2;
    var fps              = 1;
    var redrawFlag       = true;
    var horzRetraceCount = 0;

    this.read75 = function(addr, data)
    {
        if (addr == 1)
        {
            var now = Math.round((new Date()).getTime() / 1000 * fps);
            var result = frame_trigger == now ? 0 : 0x20; // Остальные флаги
            frame_trigger = now;
            return result;
        }
        return 0;
    };

    // Перерисовать экран
    function redrawScreen()
    {
        screen = new Uint32Array(screen_width * screen_height);
        redrawFlag = true;
    };

    redrawScreen();

    // Порты ВВ микросхемы КР580ВТ57
    this.write75 = function(addr, data)
    {
        //console.log("vg75.write("+addr+","+data+")");
        if (addr == 1)
        {
            switch (data)
            {
                case 0x80:
                    cmd75 = 10;
                    break;
                case 0:
                    cmd75 = 20;
                    break;
            }
            return;
        }

        if (addr == 0)
        {
            switch (++cmd75)
            {
                case 11:
                    cursor_x = data;
                    break;
                case 12:
                    cursor_y = data;
                    cmd75 = 0;
                    break;
                case 21:
                    screen_width = (data & 0x7f) + 1;
                    // 80 - spaced row
                    break;
                case 22:
                    screen_height = (data & 0x3f) + 1;
                    break;
                case 23:
                    char_height = (data & 0x0F) + 1;
                    underline_pos = data >> 4;
                    break;
                case 24:
                    font_down = (data & 0x80) ? 0 : 1;
                    transparent_attr = (data & 0x40) == 0;
                    // 30 - cursor mode
                    // 00 мигающий квадрат
                    // мигающее подчеркивание
                    // 00 немигающий квадрат
                    // немигающее подчеркивание
                    horzRetraceCount = (data & 0x0F);
                    fps = 16525 / (horzRetraceCount + screen_height * char_height);                    
                    redrawScreen();
                    cmd75 = 0;
                    break;
                default:
                    cmd75 = 0;
                    break;
            }
        }
    };

    // Порты ВВ микросхемы КР580ВТ57
    this.write57 = function(addr, data)
    {
        if (addr == 4)
        {
            dma_int_start = (dma_int_start >> 8) | (data << 8);
        }

        if (addr == 5)
        {
            dma_int_size = (dma_int_size >> 8) | (data << 8);
        }

        if (addr == 8)
        {
            if (data == 0x80)
            {
                dma_enabled = false;
                return;
            }
            if (data == 0xA4)
            {
                dma_enabled = true;
                dma_start  = dma_int_start;
                dma_end    = dma_int_start + (dma_int_size & 0x3FFF) + 1;
                dma_addr   = dma_start;
            }
            return;
        }
    }

    // Экран формируемый микросхемой КР580ВГ75
    function make(memory, chargen)
    {
        var blink = (new Date()).getTime() & 0x200;
        var addr = dma_addr;
        var x = 0;
        var y = 0;
        var attr = 0;
        var lock = dma_enabled ? 0 : 3;
        var c = 0;

        while(y < screen_height) 
        {
            if(!lock)
            {
                c = memory[addr];
                if(++addr >= dma_end) addr = dma_start;

                if(c == 0xFF)
                {
                    lock |= 2; //! Пробелы до конца кадра
                    c = 0;
                }
                else
                if(c >= 0x80 && c <= 0x9F)
                {
                    attr = (c & 1) | ((c & 0x1C) >> 1);
                    c = 0;
                    if(transparent_attr)
                    {
                        c = memory[addr] & 0x7F;
                        if(++addr >= dma_end) addr = dma_start;
                    }
                }
                else if(c >= 0xF0)
                {
                    lock |= 1;
                    c = 0;
                }
           }
           var cs = (x == cursor_x && y == cursor_y && blink) ? (1 << 16) : 0;
           screen[x + y * screen_width] = c + chargen + (attr << 8) + cs;
           if(++x >= screen_width) x = 0, y++, lock &= ~1;
        }
        dma_addr = addr;
    }

    // Цвета компьюетра Апогей БК01Ц
    const colors = [ "#FFF","#0FF","#FF0","#0F0","#F0F","#00F","#00F",,
                     "#000","#000","#000","#000","#000","#000","#000","#000", ];

    // Сформировать экран компьюетра Апогей БК01Ц
    this.makeApogee = function(chargen)
    {
        const char_width = 6;
        if(redrawFlag)
        {
            screen1 = new Uint32Array(screen_width * screen_height);
            for(var i in screen1)
                screen1[i] = 0xFFFFFFFF;
            ctx.fillStyle = "black";
            ctx.fillRect(0, 0, canvas.width, canvas.height);
        }

        var ch = screen_height * char_height * zoom_y;
        var offset_x = -56, offset_y = -8;
        var offset_y = ((canvas.height - ch + offset_y) >> 1) + offset_y;

        ctx.mozImageSmoothingEnabled = false;
        ctx.webkitImageSmoothingEnabled = false;
        ctx.imageSmoothingEnabled = false;

        make(memory, chargen);

        var char_height_visible = char_height < 10 ? char_height : 10;
        var underline_pos_visible = underline_pos < char_height ? underline_pos : char_height-1;
        var x, y, a, c;
        for(y=0; y<screen_height; y++)
        {
            for(x=0; x<screen_width; x++)
            {
                 var a = x + y * screen_width;
                 if((c = screen[a]) != screen1[a])
                 {
                     screen1[a] = c;
                     var gx = x * char_width;
                     var gy = y * char_height;
                     ctx.drawImage(
                         font, 
                         char_width * ((c >> 8) & 0x0F),
                         11 * (c & 0xFF) + font_down,
                         char_width,
                         char_height_visible,
                         gx * zoom_x + offset_x,
                         gy * zoom_y + offset_y, 
                         char_width * zoom_x,
                         char_height_visible * zoom_y
                     );
                     if(c & (1 << 16))
                     {
                         ctx.fillStyle = colors[(c >> 8) & 0x0F];
                         ctx.fillRect(
                             gx * zoom_x + offset_x,
                             (gy + underline_pos_visible) * zoom_y + offset_y,
                             char_width * zoom_x,
                             1 * zoom_y
                         );
                     }
                }
            }
        }
    }
}
