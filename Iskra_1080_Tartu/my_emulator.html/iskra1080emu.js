// Iskra 1080 Tartu online emulator
// Copyright 26-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

document.addEventListener("DOMContentLoaded", function() {
    // Тайминги
    const cpuFreq = 19062000 / 9; // = 2118000
    const linePeriod = 68 * 2;
    const visibleLinePeriod = 48 * 2;
    const framePeriod = linePeriod * 312;

    // Звук
    let audioContext = new (window.AudioContext || window.webkitAudioContext)();
    let audioGain = audioContext.createGain();
    audioGain.connect(audioContext.destination);
    audioGain.gain.value = 0;
    let audioConst = audioContext.createConstantSource(1);
    audioConst.connect(audioGain);
    let audioStarted = false;
    let audioTime = 0;
    let audioTick = 0;
    let audioResyncCounter = 0;
    const audioDelaySec = 0.2;

    function AudioStart() {
        if (audioStarted)
            return;
        audioConst.start();
        audioStarted = true;
        audioTime = audioContext.currentTime + audioDelaySec;
        audioTick = 0;
        removeEventListener("click", AudioStart);
    }

    document.addEventListener("click", AudioStart);

    function AudioSync() {
        if (!audioStarted)
            return;

        // Не даём переполнится счетчику audioTick
        while (audioTick >= cpuFreq) {
            audioTick -= cpuFreq;
            audioTime += 1;
        }

        // Считаем разбег реального времени аудио и внутреннего
        // Если мы обогнали на 1 секунду или нет запаса 0.2, то синхронизируемся
        const audioNow = audioContext.currentTime;
        const audioDelta = audioTime + audioTick / cpuFreq - audioNow;
        if (audioDelta <= 0 || audioDelta > audioDelaySec * 2) {
            audioTime = audioNow + audioDelaySec;
            audioTick = 0;
            audioResyncCounter++;
        }
        // debug: document.title = audioResyncCounter + " " + audioDelta;
    }

    function AudioLevel(level) {
        if (!audioStarted)
            return;
        audioGain.gain.setValueAtTime(level, audioTime + audioTick / cpuFreq);
    }

    // Динамическая подгрузка
    window.include = function(file) {
        let script = document.createElement('script');
        // script.onload = function() { ... }
        script.src = file;
        document.getElementsByTagName('head')[0].appendChild(script);
    };

    // Меню загрузки
    function makeLoadMenu() {
        let loadmenu = document.getElementById('loadMenu');
        let loadButton = document.getElementById('loadButton');

        loadButton.onclick = function() {
            const v = (loadmenu.style.display == "block");
            loadmenu.style.display = v ? "none" : "block";
        };

        function loadMenuClick(name) {
            loadmenu.style.display = "none";
            include("file." + this.innerHTML + ".js");
        }

        let html = "Выберите файл для загрузки<br><br>";
        for (let i in fileList)
            html += "<div>" + fileList[i] + "</div>";
        loadmenu.innerHTML = html;

        for (let j in loadmenu.childNodes)
            loadmenu.childNodes[j].onclick = loadMenuClick;
    }
    makeLoadMenu();

    // Для отрисовки
    let canvas = document.getElementById("iskra1080canvas");

    // Состояние
    let rom0000 = true;
    let memory_map = 0;
    let rg = [ 0, 0, 0, 0, 0, 0, 0 ];
    let palette = [ 0, 0, 0, 0 ];

    // Все устройства компьютера
    let memory = new Uint8Array(65536);
    let keyboard = new Iskra1080Keyboard();
    let video = new Iskra1080Video(canvas, memory, palette);
    let floppyController = new Iskra1080FloppyController();
    let cpu = new I8080();
    let cpmMode = false;
    let rightPortL = 0;
    let rightPortH = 0;

    function reset() {
        rom0000 = true;
        cpu.jump(0);
    }

    document.getElementById('resetButton').onclick = reset;

    function powerResetInternal(cpm) {
        rom0000 = true;
        memory_map = 0;
        rightPortL = 0;
        rightPortH = 0;
        cpmMode = cpm;
        for (let i in memory)
            memory[i] = 0xAA;
        for (let i in palette)
            palette[i] = 0;
        for (let i in rg)
            rg[i] = 0;
        cpu.jump(0);
    }

    let ledsState = 0;
    let ledsStatePrev = 3;

    let ledsObjects = [ document.getElementById("led0"), document.getElementById("led1") ];

    function setLeds(code) { ledsState = code; }
    function updateLeds() {
        if (ledsStatePrev != ledsState) {
            const change = ledsStatePrev ^ ledsState;
            for (let i = 0; i < 2; i++)
                if ((change & (1 << i)) != 0)
                    ledsObjects[i].classList.toggle("ledactive", (ledsState & (1 << i)) == 0);
            ledsStatePrev = ledsState;
        }
    }
    updateLeds(0);

    function powerReset() { powerResetInternal(false); }

    document.getElementById('powerResetButton').onclick = powerReset;

    function powerResetCpm() { powerResetInternal(true); }

    document.getElementById('powerResetCpmButton').onclick = powerResetCpm;

    function loadFile(file) {
        let type = file[0];

        if (type == 0xD0) {
            // Name 1,2,3,4,5,6
            let start = (file[8] << 8) | file[7];
            let end = (file[10] << 8) | file[9];
            // Unused 11,12
            if (end < start)
                return;
            let size = end - start + 1;
            // if (size > file.length - 13) return;
            powerReset();
            for (let i = 0; i !== 3000000; i++) {
                cpu.instruction();
                if (cpu.pc === 0xF463) // Вместо Бейсика запускаем монитор
                    cpu.pc = 0xF426;
                if (cpu.pc === 0xF44B)
                    break;
            }
            if (cpu.pc !== 0xF44B)
                alert("Load error 0x" + cpu.pc.toString(16));
            for (let i = 0; i < size; i++)
                memory[start + i] = file[13 + i];
            cpu.jump(start);
            return;
        }
        if (type == 0xD3) {
            powerReset();
            for (let i = 0; i !== 3000000; i++) // TODO: Добавить условие выхода
                cpu.instruction();
            let pos = 0x301; // Value of C833h after CLOAD ""
            for (let i = 7; i < file.length; i++)
                memory[pos++] = file[i];
            memory[0x236] = pos & 0xFF;
            memory[0x237] = (pos >> 8) & 0xFF;
            return;
        }
        alert("Unsupported file type");
    }

    window.loadFile = loadFile;

    let tickCount = 0;

    function waitRam() {
        const x = tickCount % linePeriod;
        if (rg[0]) {
            if (x < visibleLinePeriod) {
                tickCount += visibleLinePeriod - x;
                audioTick += visibleLinePeriod - x;
            }
        } else if (rg[1]) {
            if ((x % 2) == 0) {
                tickCount++;
                audioTick++;
            }
        }
    }

    cpu.readMemory = function(addr, flags) {
        if (flags & 2) {
            waitRam();
            return memory[addr]; // stack
        }

        if (addr < 0xC000) {
            if (flags & 1)
                memory_map = 0; // m1
            if (addr < 0x100 && rom0000)
                return iskra1080Rom[addr];
            waitRam();
            return memory[addr];
        }

        const romStart = 0xC000;
        const romStart2 = 0xC000 - 0x4000;

        if (addr < 0xC800) {
            if (flags & 1)
                memory_map = 0; // m1
            if (memory_map === 0)
                waitRam();
            return memory_map === 0 ? memory[addr] : iskra1080Rom[addr - (rg[2] ? romStart2 : romStart)];
        }

        if (addr < 0xD000) {
            if (flags & 1)
                memory_map = 1; // m1
            if (memory_map !== 1)
                waitRam();
            return memory_map !== 1 ? memory[addr] : iskra1080Rom[addr - (rg[2] ? romStart2 : romStart)];
        }

        if (flags & 1)
            memory_map = 2;

        if (memory_map !== 2)
            waitRam();
        return memory_map !== 2 ? memory[addr] : iskra1080Rom[addr - romStart];
    };

    cpu.writeMemory = function(addr, byte) {
        waitRam();
        memory[addr] = byte;
    };

    cpu.readIo = function(addr) {
        // console.log("IN " + addr.toString(16));
        if ((addr & 0xF8) == 0xC0)
            return keyboard.read(addr);
        switch (addr & 0xB8) {
        case 0x98:
            if (cpmMode)
                return floppyController.read(addr & 1);
            return (addr & 1) ? rightPortH : rightPortL;
        }
        return 0;
    };

    let tapeOut = false;

    cpu.writeIo = function(addr, byte) {
        // console.log("OUT " + addr.toString(16) + ", " + byte.toString(16));
        if ((addr & 0xF8) == 0xC0) {
            setLeds(byte >> 4);
            return keyboard.write(addr, byte);
        }
        switch (addr & 0xB8) {
        case 0x80:
            break; // UART
        case 0x88:
            if (cpmMode)
                floppyController.write(byte ^ 0xFF);
            break;
        case 0x90:
            palette[addr & 3] = byte;
            break;
        case 0x98:
            if (cpmMode)
                floppyController.write(addr & 1, byte);
            break;
        case 0xA0:
            for (let i = 0; i < 8; i++)
                cpu.writeIo(0xB8 + i, 0);
            break;
        case 0xA8:
            rom0000 = (byte & 0x80) == 0;
            break;
        case 0xB8:
            rg[addr & 7] = (addr & 0x40) != 0;
            if ((addr & 7) <= 1)
                video.setMode((rg[0] ? 1 : 0) | (rg[1] ? 2 : 0));
            if (cpmMode)
                floppyController.writeControl((rg[5] ? 1 : 0) | (rg[7] ? 2 : 0));
            break;
        case 0xB0: // 0B0h - 0B7h, 0F0h - 0F7h
            tapeOut = !tapeOut;
            AudioLevel(tapeOut ? 1 : -1);
            break;
        }
    };

    let lastTime = new Date().getTime();
    let needTickCount = 0;

    function cpuTick() {
        // Сколько прошло времени
        const now = new Date().getTime();
        let delta = now - lastTime;
        lastTime = now;

        // Больше 500 мс за раз не работаем
        if (delta > 500)
            delta = 500;

        // До какого такта процессора работаем
        needTickCount += Math.round(delta / 1000 * cpuFreq);

        // Если по тактам получается больше 1 секунды работать, или больше 1
        // секунды бездействовать, то вообще ничего не делаем.
        if (Math.abs(needTickCount - tickCount) > cpuFreq)
            needTickCount = tickCount;

        // Синхронизация звука
        AudioSync();

        // Работа
        while (tickCount < needTickCount) {
            const t = cpu.instruction();
            tickCount += t;
            audioTick += t;
        }

        // Не даём переполнится счетчикам
        if (tickCount >= framePeriod && needTickCount >= framePeriod) {
            needTickCount -= framePeriod;
            tickCount -= framePeriod;
        }
    }

    window.setInterval(cpuTick, 10);

    function videoTick() {
        updateLeds();
        video.make();
    }

    window.setInterval(videoTick, 1000 / 50);
    powerResetCpm();

    let fileInUrl = (document.URL + "").split("?");
    if (fileInUrl.length === 2)
        include("file." + fileInUrl[1] + ".js");
});
