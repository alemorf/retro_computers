// KR1818VG93 emulator
// (c) 01-01-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Vg93(floppy) {
    let state = 0;
    let track = 0;
    let sector = 0;
    let data = 0;
    let ext = 0;
    let sectorOffsetLba = 0;
    let sectorOffset = 512;
    let sectorData = new Uint8Array(512);
    const IRQ = 0x80, DRQ = 1;
    const interleave = [ 0, 1, 8, 6, 4, 2, 9, 7, 5, 3 ];

    let back_interleave = [];
    for (i in interleave)
        back_interleave[interleave[i]] = i * 1;

    this.readExt = function() {
        return ext;
    };

    this.read = function(addr) {
        switch (addr & 3) {
        case 0:
            return state;
        case 1:
            return track;
        case 2:
            return sector;
        case 3:
            if (sectorOffset < 512) {
                sectorOffset++;
                if (sectorOffset == 512) {
                    ext = IRQ;
                    state = 0;
                }
                return sectorData[sectorOffset - 1];
            }
            return 0;
        }
    };

    function command(byte) {
        dataCount = 0;
        ext = 0;
        state = 0;
        switch (byte & 0xF0) {
        case 0x00: // Home h V r1 r0
            track = 0;
            state = 4;
            break;
        case 0x10: // Seek h V r1 r0
            track = data;
            state = (track == 0) ? 4 : 0;
            break;
        case 0x20: // Hidden step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x30: // Step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x40: // Hidden forward step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x50: // Forward Step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x60: // Hidden backward step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x70: // Backward Step h V r1 r0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0x80: // Read sector m s E C 0
            document.title = "R " + track + " " + sector;
            if (back_interleave[sector]) {
                sectorOffsetLba = track * 9 + back_interleave[sector] - 1;
                sectorOffset = 0;
                sectorData = floppy.read(sectorOffsetLba);
                ext = DRQ;
                state = 2;
            } else {
                ext = IRQ;
                state = 0xFF;
            }
            break;
        case 0x90:
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0xA0: // Write sector m s E C a0
            document.title = "W " + track + " " + sector;
            if (back_interleave[sector]) {
                sectorOffsetLba = track * 9 + back_interleave[sector] - 1;
                sectorOffset = 0;
                ext = DRQ;
                state = 2;
            } else {
                ext = IRQ;
                state = 0xFF;
            }
            break;
        case 0xB0:
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0xC0: // Read address 0 E 0 0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0xD0: // Break J3 J2 J1 J0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0xE0: // Read track 0 E 0 0
            console.log("Unsupported VG93 command " + byte.toString(16));
            break;
        case 0xF0: // Write track 0 E 0 0
            console.log("Write track " + byte.toString(16) + " " + track);
            break;
        }
    }

    this.write = function(addr, byte) {
        switch (addr & 3) {
        case 0:
            command(byte);
            return;
        case 1:
            track = byte;
            return;
        case 2:
            sector = byte;
            return;
        case 3:
            data = byte;
            if (sectorOffset < 512) {
                sectorData[sectorOffset] = byte;
                sectorOffset++;
                if (sectorOffset == 512) {
                    floppy.write(sectorOffsetLba, sectorData);
                    ext = IRQ;
                    state = 0;
                }
            }
            return;
        }
    };
}
