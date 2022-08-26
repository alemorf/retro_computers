// Iskra 1080 Tartu online emulator
// Copyright 26-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

document.addEventListener("DOMContentLoaded", function() {
    // Динамичкская подгрузка
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

        loadButton.onclick = function() { loadmenu.style.display = "block"; }

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
    let cpu = new I8080();

    function reset() {
        rom0000 = true;
        cpu.jump(0);
    }

    document.getElementById('resetButton').onclick = reset;

    function loadFile(file) {
        let type = file[0];
        // Name 1,2,3,4,5,6
        let start = (file[8] << 8) | file[7];
        let end = (file[10] << 8) | file[9];
        // Unused 11,12
        if (end < start)
            return;
        let size = end - start + 1;
        // if (size > file.length - 13) return;
        reset();
        keyboard.emulate(67, true);
        for (let i = 0; i < 300000; i++) {
            cpu.instruction();
            if (cpu.pc === 0xF44B)
                break;
        }
        keyboard.emulate(67, false);
        for (let i = 0; i < size; i++)
            memory[start + i] = file[13 + i];
        cpu.jump(start);
    }

    window.loadFile = loadFile;

    cpu.readMemory = function(addr, flags) {
        if (flags & 2)
            return memory[addr]; // stack

        if (addr < 0xC000) {
            if (flags & 1)
                memory_map = 0; // m1
            if (addr < 0x100 && rom0000)
                return iskra1080Rom[addr];
            return memory[addr];
        }

        const romStart = 0xC000;
        const romStart2 = 0xC000 - 0x4000;

        if (addr < 0xC800) {
            if (flags & 1)
                memory_map = 0; // m1
            return memory_map === 0 ? memory[addr] : iskra1080Rom[addr - (rg[2] ? romStart2 : romStart)];
        }

        if (addr < 0xD000) {
            if (flags & 1)
                memory_map = 1; // m1
            return memory_map !== 1 ? memory[addr] : iskra1080Rom[addr - (rg[2] ? romStart2 : romStart)];
        }

        if (flags & 1)
            memory_map = 2;
        return memory_map !== 2 ? memory[addr] : iskra1080Rom[addr - romStart];
    };

    cpu.writeMemory = function(addr, byte) { memory[addr] = byte; }

                      cpu.readIo = function(addr) {
        // console.log("IN " + addr.toString(16));
        if ((addr & 0xF8) == 0xC0)
            return keyboard.read(addr);
        return 0;
    };

    cpu.writeIo = function(addr, byte) {
        // console.log("OUT " + addr.toString(16) + ", " + byte.toString(16));
        if ((addr & 0xF8) == 0xC0)
            return keyboard.write(addr, byte);
        switch (addr & 0xB8) {
        case 0x80:
            break; // UART
        case 0x90:
            palette[addr & 3] = byte;
            break;
        case 0xA8:
            rom0000 = (byte & 0x80) == 0;
            break;
        case 0xB8:
            rg[addr & 7] = (addr & 0x40) != 0;
            if ((addr & 7) <= 1)
                video.setMode((rg[0] ? 1 : 0) | (rg[1] ? 2 : 0));
            break;
        }
    };

    let last_time = 0;
    const cpuSpeed = 2000000 / 1000;

    function cpuTick() {
        let now = new Date().getTime();
        let delta = now - last_time;
        if (delta > 500)
            delta = 500;
        last_time = now;

        for (let i = 0, is = delta * cpuSpeed; i < is;) {
            window._time = i / cpuSpeed / 1000;
            i += cpu.instruction();
        }
    }

    window.setInterval(cpuTick, 10);

    function videoTick() { video.make(); }

    window.setInterval(videoTick, 1000 / 50);
    reset();

    let fileInUrl = (document.URL + "").split("?");
    if (fileInUrl.length === 2)
        include("file." + fileInUrl[1] + ".js");
});
