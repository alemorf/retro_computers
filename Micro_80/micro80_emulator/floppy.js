// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Floppy(n) {
    const SIDE_COUNT = 2;
    const TRACK_COUNT = 80;
    const SECTOR_COUNT = 9;
    const SECTOR_SIZE = 512;
    const BYTES_COUNT = TRACK_COUNT * SIDE_COUNT * SECTOR_COUNT * SECTOR_SIZE;

    let data = 0;

    function toBase64(bytes) {
        const len = bytes.byteLength;
        let binary = '';
        for (let i = 0; i < len; i++)
            binary += String.fromCharCode(bytes[i]);
        return window.btoa(binary);
    }

    function fromBase64(base64) {
        const binary_string = window.atob(base64);
        const len = binary_string.length;
        let bytes = new Uint8Array(len);
        for (let i = 0; i < len; i++)
            bytes[i] = binary_string.charCodeAt(i);
        return bytes.buffer;
    }

    this.save = function() {
        localStorage.setItem("floppy" + n, toBase64(data));
    };

    this.reset = function() {
        data = new Uint8Array(BYTES_COUNT);
        for (let i = 0; i < size; i++)
            data[i] = 0xE5;
        this.save();
    };

    this.select = function(d) {
        data = new Uint8Array(d);
        this.save();
    };

    this.read = function(offset) {
        let o = offset * SECTOR_SIZE;
        if (o + SECTOR_SIZE > data.length)
            return [];
        let result = new Uint8Array(SECTOR_SIZE);
        for (let i = 0; i < SECTOR_SIZE; i++)
            result[i] = data[o + i];
        return result;
    };

    this.write = function(offset, d) {
        let o = offset * SECTOR_SIZE;
        if (o + SECTOR_SIZE > data.length)
            return false;
        for (let i = 0; i < SECTOR_SIZE; i++)
            data[o + i] = d[i];
        this.save();
        return true;
    };

    // load

    try {
        data = new Uint8Array(fromBase64(localStorage.getItem("floppy" + n)));
    } catch (e) {
    }

    if (data.length != BYTES_COUNT)
        this.reset();
}
