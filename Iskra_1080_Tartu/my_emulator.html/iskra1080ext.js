// Iskra 1080 Tartu online emulator / extension card
// Copyright 9-Apr-2023 Alemorf, aleksey.f.morozov@yandex.ru

function Iskra1080SdController(floppy) {
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

    const RESULT_OK = 0;
    const RESULT_WORK = 0xFF;
    const RESULT_INVALID_COMMAND = 0xFF - 1;
    const RESULT_TO_SD_ERROR = 0xFF - 2;
    const RESULT_TO_SD = 0xFF - 3;
    const RESULT_FROM_SD_ERROR = 0xFF - 4;
    const RESULT_FROM_SD = 0xFF - 5;

    const PORT_COMMAND = 0;
    const PORT_STATE = 0;
    const PORT_DATA = 1;

    const COMMAND_READ = 1;
    const COMMAND_WRITE = 2;

    let result = RESULT_INVALID_COMMAND;
    let buffer = [];
    let sendCounter = 0;
    let sendTotal = 1;
    let currentCommand = 0xFF;
    let recvCounter = 0;
    let recvTotal = 0;
    let ext_config = 0;
    
    try {
        ext_config = new Uint8Array(fromBase64(localStorage.getItem("ext_config")));
        if (ext_config.length != 128)
            throw "Incorrect config";
    } catch (e) {
        ext_config = new Uint8Array(128);
    }

    function saveConfig() {
        localStorage.setItem("ext_config", toBase64(ext_config));
    };
     saveConfig();
    

    this.readIo = function(address) {
        switch (address) {
        case 0:
            let r = buffer[sendCounter];
            if (sendCounter + 1 < sendTotal) {
                sendCounter++;
                return r;
            }
            return r;
        case 1:
            return result;
        }
    };

    this.writeIo = function(address, byte) {
        switch (address) {
        case 1:
            sendCounter = 0xFF;
            recvCounter = 0;
            recvTotal = byte + 1;
            break;
        case 0:
            buffer[recvCounter] = byte;
            recvCounter++;
            if (recvCounter >= recvTotal) {
                switch (buffer[0]) {
                case COMMAND_READ: {
                    const drive = buffer[1];
                    const offset = buffer[2] | (buffer[3] << 8) | (buffer[4] << 16) | (buffer[5] << 24);
                    console.log("Read floppy " + drive + " " + offset);
                    if (drive == 0) {
                        buffer = [];
                        const o = offset * 128;
                        if (o + 128 > iskra1080extboot.length) {
                            result = 1;
                            return;
                        }
                        for (let i = 0; i < 128; i++)
                            buffer[i] = iskra1080extboot[i + o];
                    } else if (drive == 1) {
                        for (let i = 0; i < 128; i++)
                            buffer[i] = ext_config[i + offset * 128];
                    } else if (drive - 2 < floppy.length) {
                        buffer = floppy[drive - 2].read(offset);
                        if (buffer.length == 0) {
                            result = 1;
                            return;
                        }
                    } else {
                        result = 1;
                        return;
                    }
                    sendTotal = 128;
                    sendCounter = 0;
                    result = 0;
                    return;
                }
                case COMMAND_WRITE: {
                    const drive = buffer[1];
                    const offset = buffer[2] | (buffer[3] << 8) | (buffer[4] << 16) | (buffer[5] << 24);
                    console.log("Write floppy " + drive + " " + offset);
                    if (drive == 0) {
                        result = 1;
                        return;
                    }
                    if (drive == 1) {
                        for (let i = 0; i < 128; i++)
                            ext_config[i + offset * 128] = buffer[6 + i];
                        saveConfig();
                        result = 0;
                        return 0;
                    }                     
                    var b = [];
                    for (let i = 0; i < 128; i++)
                        b[i] = buffer[6 + i];
                    if (!floppy[drive - 2].write(offset, b)) {
                        result = 1;
                        return;
                    }
                    result = 0;
                    return;
                }
                default:
                    result = 1;
                }
            }
            break;
        }
    };
}

function Iskra1080ExtensionCard(rom, floppy) {
    let romEnabled = false;
    let mapperEnabled = false;
    let mapper = [ 0xF, 0xF, 0xF, 0xF ];
    let ram = new Uint8Array(128 * 1024);
    let interrupt = false;
    let sd = new Iskra1080SdController(floppy);

    this.romEnable = function(enabled) {
        romEnabled = enabled;
    };

    this.powerReset = function() {
        for (let i in ram)
            ram[i] = 0xAA;
    };

    this.reset = function() {
        mapperEnabled = false;
    };

    function readMapper(address) {
        return mapperEnabled ? mapper[address >> 14] : romEnabled ? 0xFF : 0xFD;
    }

    this.read = function(address) {
        const x = readMapper(address);
        if ((x & 1) == 0)
            return ram[((address & 0x3FFF) + ((x >> 1) << 14)) % ram.length];
        if ((x & 3) == 3)
            return rom[((address & 0x3FFF) + ((x >> 2) << 14)) % rom.length];
        return undefined;
    };

    this.write = function(address, byte) {
        const x = readMapper(address);
        if ((x & 1) == 0) {
            ram[(((address & 0x3FFF) + ((x >> 1) << 14))) % ram.length] = byte;
            return true;
        }
        if ((x & 3) == 3)
            return true;
        return false;
    };

    this.readIo = function(address) {
        switch (address & ~3) {
        case 0:
            return mapper[address & 3];
        case 4:
            return (interrupt ? 0 : 1);
        case 8:
            let byte = sd.readIo(address & 3);
            // console.log("SDRD " + address + " " + byte);
            return byte;
        }
        return undefined;
    };

    this.writeIo = function(address, byte) {
        switch (address & ~3) {
        case 0:
            mapper[address & 3] = byte;
            mapperEnabled = true;
            break;
        case 4:
            interrupt = false;
            break;
        case 8:
            // console.log("SDWR " + address + " " + byte);
            sd.writeIo(address & 3, byte);
            break;
        }
    };

    this.horzSync = function() {
        interrupt = true;
    };

    this.getInterrupt = function() {
        return interrupt;
    };
}
