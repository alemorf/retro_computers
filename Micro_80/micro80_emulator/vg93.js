// Micro 80 computer emulator from Radio magazine 1983
// (c) 22-11-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Vg93(floppies, getConfigBits) {
    const TRACK_COUNT = 80;
    const SECTOR_COUNT = 9;
    const SECTOR_SIZE = 512;

    let state = 0;
    let track = 0;
    let sector = 0;
    let data = 0;
    let ext = 0;
    let sectorOffsetLba = 0;
    let sectorOffset = SECTOR_SIZE;
    let sectorData = new Uint8Array(SECTOR_SIZE);
    const IRQ = 2, DRQ = 1;

    const CONFIG_DRIVE = 1 << 0;
    const CONFIG_SIDE = 1 << 1;

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
            if (sectorOffset < SECTOR_SIZE) {
                sectorOffset++;
                if (sectorOffset == SECTOR_SIZE) {
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
        const config = getConfigBits();
        const drive = (config & CONFIG_DRIVE) ? 1 : 0;
        const side = (config & CONFIG_SIDE) ? TRACK_COUNT : 0;
        switch (byte & 0xF0) {
        case 0x00: // Home h V r1 r0
            track = 0;
            state = 4;
            console.log("Home");
            break;
        case 0x10: // Seek h V r1 r0
            track = data;
            state = (track == 0) ? 4 : 0;
            console.log("Seek " + track + " ");
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
            console.log("R " + drive + " " + side + " " + track + " " + sector);
            if (sector > 0 && sector <= SECTOR_COUNT) {
                sectorOffsetLba = (track + side) * SECTOR_COUNT + sector - 1;
                sectorOffset = 0;
                sectorData = floppies[drive].read(sectorOffsetLba);
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
            console.log("W " + drive + " " + side + " " + track + " " + sector);
            if (sector > 0 && sector <= SECTOR_COUNT) {
                sectorOffsetLba = (track + side) * SECTOR_COUNT + sector - 1;
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
    };

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
            if (sectorOffset < SECTOR_SIZE) {
                sectorData[sectorOffset] = byte;
                sectorOffset++;
                if (sectorOffset == SECTOR_SIZE) {
                    const drive = (getConfigBits() & CONFIG_DRIVE) ? 1 : 0;
                    floppies[drive].write(sectorOffsetLba, sectorData);
                    ext = IRQ;
                    state = 0;
                }
            }
            return;
        };
    }
}
