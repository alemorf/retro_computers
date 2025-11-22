// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

const PORT_ROM = 0xFF;
const PORT_ROM_MASK = 0xFC;
const PORT_ROM__ENABLE_RAM = 1 << 2;
const PORT_ROM__ROM_SHIFT = 3;
const PORT_VG93 = 0xE0;
const PORT_VG93_MASK = 0xFC;
const PORT_ROM__FLOPPY_B = 1 << 0;
const PORT_ROM__FLOPPY_SIDE = 1 << 1;

let ram = new Uint8Array(0x10000);
let video = new Micro80Video("video", ram);
let screenKeyboard = new Micro80ScreenKeyboard();
let keyboard = new Micro80Keyboard(screenKeyboard);
let floppies = [ new Floppy(0), new Floppy(1) ];
let portFF = 0;
let vg93 = new Vg93(floppies, function() {
    return portFF;
});
let init = false;

function readMemory(addr) {
    //    if (addr == 0x8001)
    //	return 0x77;
    if (addr < 0x8000 && (portFF & PORT_ROM__ENABLE_RAM) == 0)
        return cpmBios[((addr ^ 0x7FFF) + (portFF >> PORT_ROM__ROM_SHIFT) * 0x8000) % cpmBios.length];
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
    if ((addr & PORT_VG93_MASK) == PORT_VG93)
        return vg93.read(addr & ~PORT_VG93_MASK);
    return 0x82;
}

function resetFloppy(n) {
    floppies[n].reset();
}

function writeIo(addr, byte) {
    if (addr == 7)
        port7 = byte;
    else if (addr == 0xFF)
        portFF = byte;
    else if ((addr & PORT_VG93_MASK) == PORT_VG93)
        vg93.write(addr & ~PORT_VG93_MASK, byte);
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
        init = false;
    }
}

// File menu

function loadUserFile() {
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

this.loadFile = function(data) {
    if (data.length <= 4)
        return;
    const startAddress = (data[0] << 8) | data[1];
    const length = Math.min(data.length - 4, 0x10000 - startAddress);
    reset(startAddress);
    for (let i = 0; i < length; i++)
        ram[startAddress + i] = data[4 + i];
};

function executeJsFile(url) {
    var script = document.createElement('script');
    // script.onload = function() { ... }
    script.src = url;
    document.getElementsByTagName('head')[0].appendChild(script);
};

let fileInUrl = (document.URL + "").split("?");
if (fileInUrl.length == 2)
    executeJsFile("files/" + fileInUrl[1] + ".rk.js");

function addFilesInMenu() {
    let menu = document.getElementById("softMenu");
    let html = "<hr></hr>";
    for (let i in fileList)
        html += "<li onclick='executeJsFile(\"" + fileList[i] + ".js\")'><div>" + fileList[i] + "</div></li>";
    menu.innerHTML += html;
}
addFilesInMenu();
