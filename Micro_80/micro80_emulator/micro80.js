// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

const PORT_ROM = 0xFF;
const PORT_ROM_MASK = 0xFC;
const PORT_ROM__ENABLE_RAM = 1 << 2;
const PORT_ROM__ROM_SHIFT = 3;

let ram = new Uint8Array(0x10000);
let video = new Micro80Video("video", ram);
let screenKeyboard = new Micro80ScreenKeyboard();
let keyboard = new Micro80Keyboard(screenKeyboard);

let init = true;
let portFF = 0;

function readMemory(addr) {
    if (addr < 0x8000 && (portFF & PORT_ROM__ENABLE_RAM) == 0)
        return cpmBios[(addr + (portFF >> PORT_ROM__ROM_SHIFT) * 0x8000) % cpmBios.length];
    if (addr >= 0xF800)
        init = false;
    if (addr >= 0xF800 || init)
        return bios[addr % 0x800];
    return ram[addr];
}

function writeMemory(addr, byte) {
    ram[addr] = byte;
}

let port7 = 0xFF;

function readIo(addr) {
    if (addr == 6)
        return keyboard.read(port7 | 0x100);
    if (addr == 5)
        return keyboard.read(0xFF);
    return 0x82;
}

function writeIo(addr, byte) {
    if (addr == 7)
        port7 = byte;
    else if (addr == 0xFF)
        portFF = byte;
}

let cpu = new I8080(readMemory, writeMemory, readIo, writeIo);

const cpuSpeedKhz = 2500;
let lastTimeMs = 0;
let ticks = 0;

function idle(timeMs) {
    timeMs = Math.round(timeMs);
    const deltaTimeMs = timeMs - lastTimeMs;
    lastTimeMs = timeMs;

    ticks += Math.min(deltaTimeMs, 500) * cpuSpeedKhz;

    while (ticks > 0)
        ticks -= cpu.instruction();

    video.redraw();

    requestAnimationFrame(idle);
}

requestAnimationFrame(idle);

function reset(startAddress) {
    init = true;
    cpu.reset();
    if (startAddress !== undefined) {
        portFF = PORT_ROM__ENABLE_RAM;
        if (startAddress != 0x10000) {
            for (let i = 0; i < 50000 && ram[0xE040] != 0xA7; i++)
                cpu.instruction();
            cpu.jump(startAddress);
        }
    } else {
        portFF = 0;
    }    
}

function loadFile() {
    loadAs(function(name, data) {
        if (data.length <= 4)
            return;
        const startAddress = (data.charCodeAt(0) << 8) | data.charCodeAt(1);
        const length = Math.min(data.length - 4, 0x10000 - startAddress);
        reset(startAddress);
        for (let i = 0; i < length; i++)
            ram[startAddress + i] = data.charCodeAt(4 + i);
    });
}

function loadAny(org, data) {
    reset(org);
    for (let i in testApp)
        ram[(i | 0) + org] = data[i];
}

function loadBasic80() {
    loadAny(0, basic80);
}

function loadColorLines() {
    loadAny(0x100, testApp);
}

function loadKosoban() {
    loadAny(0x100, kosoban);
}

let fileInUrl = (document.URL+"").split("?");
if(fileInUrl.length == 2) {
    if (fileInUrl[1] == "ColorLines") 
        loadColorLines();
    else if (fileInUrl[1] == "Kosoban") 
        loadKosoban();
}
