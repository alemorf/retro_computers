function Vi53(freq)
{
    var context = new (window.AudioContext || window.webkitAudioContext)();

    function Channel(id)
    {
        var gain = context.createGain();
        var oscillator = context.createOscillator();
        oscillator.type = 'square';
        oscillator.frequency.value = 0;
        oscillator.connect(gain);
        gain.connect(context.destination);
        gain.gain.value = 0.3;
        oscillator.start();

        this.value  = 0;
        this.value0 = 0;
        this.rwMode = 0;
        this.mode   = 0;
        this.bcd    = 0;
        var started = false;

        this.update = function()
        {
            var f = this.value != 0 && this.bcd == 0 && ((this.mode & 3) == 3) ? (freq / this.value) : 0;
            oscillator.frequency.setValueAtTime(f, window._time + context.currentTime); // value in hertz
        }
    }

    var channels = [ new Channel(0), new Channel(1), new Channel(2) ];

    this.read = function(addr, data)
    {
        return 0; // Чтение не реализовано
    }

    // Порты ВВ микросхемы КР580ВТ57
    this.write = function(addr, data)
    {
        if (addr < 3)
        {
            var c = channels[addr];
            switch(c.rwMode)
            {
                case 1: c.value = data; c.update(); break;
                case 2: c.value = data << 8; c.update(); break;
                case 3: c.value0 = data; c.rwMode = 4; break;
                case 4: c.value = c.value0 | (data << 8); c.rwMode = 3; c.update(); break;
            }
        }
        else
        if (addr == 3)
        {
            var channel = (data >> 6) & 3;
            if(channel < 3)
            {
                var c = channels[channel];
                var rwMode = (data >> 4) & 3;
                if(rwMode == 0) return; // Чтение на лету не реализовано
                c.value = 0;
                c.rwMode = rwMode;
                c.mode = (data >> 1) & 7;
                c.bcd = data & 1;
                c.update();
            }
        }
    };
}
