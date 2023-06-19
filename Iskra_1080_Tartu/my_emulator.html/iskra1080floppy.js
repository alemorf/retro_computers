// Iskra 1080 Tartu online emulator / Floppy drive
// Copyright 26-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

function Floppy(n) {
    const sector_size = 128;

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

    try {
        data = new Uint8Array(fromBase64(localStorage.getItem("floppy" + n)));
    } catch (e) {
        data = new Uint8Array(4000 * sector_size);
    }

    this.save = function() {
        localStorage.setItem("floppy" + n, toBase64(data));
    };

    this.select = function(d) {
        data = new Uint8Array(d);
        this.save();
    };

    this.get0 = function() {
        return 40; // TODO: data[0];
    };

    this.read = function(offset) {
        let o = offset * sector_size;
        if (o + sector_size > data.length)
            return [];
        let result = [];
        for (let i = 0; i < sector_size; i++)
            result[i] = data[o + i];
        return result;
    };

    this.write = function(offset, d) {
        let o = offset * sector_size;
        if (o + sector_size > data.length)
            return false;
        for (let i = 0; i < sector_size; i++)
            data[o + i] = d[i];
        this.save();
        return true;
    };
}
