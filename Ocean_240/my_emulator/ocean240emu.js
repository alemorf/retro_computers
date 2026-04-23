// Ocean 240.2 computer emulator
// (c) 01-01-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

document.addEventListener("DOMContentLoaded", function() {
    // Тайминги
    const linePeriod = 68 * 2;
    const visibleLinePeriod = 48 * 2;
    const framePeriod = linePeriod * 312;
    const tickMax = framePeriod * 50 * 10;

    // Диски
    let floppy = [
        new Floppy(0),
        new Floppy(1),
    ];

    // Все устройства компьютера
    let memory = new Uint8Array(65536 * 2);
    let keyboard = new Ocean240Keyboard();
    let video = new Ocean240Video("ocean240canvas", memory);
    let vg93 = new Vg93(floppy[0]);
    let cpu = new I8080();

    function reset() {
        setMapper(0xFF);
        cpu.iff = 0;
        cpu.jump(0);
    }

    document.getElementById('rect1390-7').addEventListener("click", reset);

    let tickCount = 0;

    let mapper_addr_or = 0;
    let mapper_page = 0;
    let mapper_rom_enbled = 0;
    let mapper_all_rom_enabled = 0;
    let mapper_rom_page = 0;

    function setMapper(byte) {
        mapper_addr_or = (byte & 1) ? 0x8000 : 0;
        mapper_page = (byte >> 1) & 7;
        mapper_rom_disabled = (byte & (1 << 4)) != 0;
        mapper_all_rom_enabled = (byte & (1 << 5)) != 0;
        mapper_rom_page = byte >> 6;
    }

    setMapper(0xFF);

    cpu.readMemory = function(addr, flags) {
        if (mapper_all_rom_enabled)
            return mon[(0x2000 + (addr % 0x2000)) % mon.length];
        if (addr >= 0xC000 && !mapper_rom_disabled)
            return mon[(addr - 0xC000 + mapper_rom_page * 0x4000) % mon.length];
        return memory[(addr | mapper_addr_or) + (mapper_page << 16)];
    };

    cpu.writeMemory = function(addr, byte) {
        memory[(addr | mapper_addr_or) + (mapper_page << 16)] = byte;
    };

    cpu.readIo = function(addr) {
        switch (addr) {
        case 0x20:
        case 0x21:
        case 0x22:
        case 0x23:
            return vg93.read(addr - 0x20);
        case 0x24:
        case 0x25:
            return vg93.readExt() | ((floppy << 1) & 0x7E);
        case 0x40:
            return keyboard.read();
        case 0x80: // Interrupts
            let result = 0;
            if (keyboard.getIrq(tickCount, tickMax))
                result |= 2;
            if (Math.random() > 0.5)
                result |= 0x10; // Timer
            return result;
        }
        return 0;
    };

    cpu.writeIo = function(addr, byte) {
        switch (addr) {
        case 0x20:
        case 0x21:
        case 0x22:
        case 0x23:
            vg93.write(addr - 0x20, byte);
            return;
        case 0x24:
        case 0x25:
            floppy = byte;
            return;
        case 0x42:
            keyboard.write(byte, tickCount, tickMax);
            return;
        case 0xC0:
            video.setScrollY(byte);
            return;
        case 0xC1:
            setMapper(byte);
            return;
        case 0xC3:
            video.setScrollY(0);
            setMapper(0);
            return;
        case 0xE1:
            video.setColor(byte);
            return;
        }
    };

    let lastTime = new Date().getTime();
    let needTickCount = 0;

    function cpuTick() {
        // Сколько прошло времени
        const cpuFreq = 2400000;
        const now = new Date().getTime();
        let delta = now - lastTime;
        lastTime = now;

        // Больше 500 мс за раз не работаем
        if (delta > 500)
            delta = 500;

        // Если по тактам получается больше 1 секунды работать, или больше 1
        // секунды бездействовать, то вообще ничего не делаем.
        if ((tickMax + needTickCount - tickCount) % tickMax > cpuFreq)
            needTickCount = tickCount;

        // До какого такта процессора работаем
        needTickCount += Math.round(delta / 1000 * cpuFreq);

        // Работа
        while (tickCount < needTickCount) {
            keyboard.getIrq(tickCount, tickMax);
            const t = cpu.instruction(false);
            tickCount += t;
            while (tickCount >= tickMax && needTickCount >= tickMax) {
                // Не даём переполнится счетчикам
                needTickCount -= tickMax;
                tickCount -= tickMax;
            }
        }
    }

    window.setInterval(cpuTick, 20);

    function videoTick() {
        keyboard.animation();
        video.make();
    }

    window.setInterval(videoTick, 1000 / 50);
    reset();
});
