// Iskra 1080 Tartu online emulator
// Copyright 3-May-2023 Alemorf, aleksey.f.morozov@yandex.ru

function Debuger(cpu, onDebugStart) {
    let self = this;
    let debuger = document.getElementById("debuger");

    let traceMode = 0;
    let traceNext = -1;
    let disassemblerAddess = 0;
    let breakpoints = {};
    let window = 0;
    let dataOffset = 0;
    let modifyMemoryStep = -1;

    this.paused = function() {
        return traceMode == 2;
    };

    this.cpuTick = function() {
        if (breakpoints[cpu.pc]) {
            show();
            return true;
        }
        switch (traceMode) {
        case 1:
            show();
            return true;
        case 3:
            if (traceNext == cpu.pc) {
                show();
                return true;
            }
        }
        return false;
    };

    function show() {
        if (traceMode == 2)
            return;
        traceMode = 2;
        onDebugStart();
        debugerUpdate(true);
    }

    function hide() {
        traceMode = 0;
        debuger.innerHTML = "";
    }

    this.stop = function() {
        if (traceMode == 2)
            hide();
        else
            show();
    };

    function step() {
        if (traceMode != 2)
            return;
        traceMode = 1;
    }
    this.step = step;

    function stepOver() {
        if (traceMode != 2)
            return;
        hide();
        traceMode = 3;
    }
    this.stepOver = stepOver;

    var onScreenAddresses = [];

    function ad(x) {
        return (x + 0x10000) % 0x10000;
    }

    function findFirstLineAddress(address) {
        const MAX_COMMAND_SIZE = 3;
        const CURSOR_LINE = 10;
        let a = ad(address - MAX_COMMAND_SIZE * CURSOR_LINE);
        for (let j = 0; j < MAX_COMMAND_SIZE; j++) {
            let result = [];
            for (let i = 0; i < MAX_COMMAND_SIZE * CURSOR_LINE; i++) {
                result.push(a);
                a = ad(a + getInstructionSize(a));
                if (a == address)
                    return result[result.length >= CURSOR_LINE ? result.length - CURSOR_LINE : 0];
                if (ad(a - address) < 0x8000)
                    break;
            }
            a = ad(a + 1);
        }
        return address;
    }

    function debugerUpdate(reset) {
        let text = "<table><tr><td>";

        if (reset)
            disassemblerAddess = cpu.pc;

        let context = {addr : findFirstLineAddress(disassemblerAddess)};
        onScreenAddresses = [];
        for (var i = 0; i < 20; i++) {
            onScreenAddresses[i] = context.addr;
            text += "<div";
            const cur = (context.addr == cpu.pc);
            if (context.addr == disassemblerAddess && window == 0)
                text += " class='cur'";
            else if (cur)
                text += " class='pc'";
            text += ">";
            text += breakpoints[context.addr] ? "●" : "&nbsp;"
            let s = context.addr;
            const c = disassembler(context);
            text += f4(s) + "&nbsp;&nbsp;";
            for (let j = 0; j < 3; j++) {
                if (s != context.addr) {
                    text += f2(cpu.readMemory(s, 0)) + "&nbsp;";
                    s = ad(s + 1);
                } else {
                    text += "&nbsp;&nbsp;&nbsp;";
                }
            }
            text += "&nbsp;" + c + "</div>";
            if (cur)
                traceNext = context.addr;
        }
        text += "</td><td>";
        text += "&nbsp;A&nbsp; " + f2(cpu.a()) + "<br>" +
                "&nbsp;BC " + f4(cpu.bc()) + "<br>" +
                "&nbsp;DE " + f4(cpu.de()) + "<br>" +
                "&nbsp;HL " + f4(cpu.hl()) + "<br>" +
                "&nbsp;PC " + f4(cpu.pc) + "<br>" +
                "&nbsp;SP " + f4(cpu.sp) + "<br>" +
                "&nbsp;FL " + cpu.store_flags() + "<br>" +
                "&nbsp;IE " + (cpu.iff ? 1 : 0);
        text += "</td></tr><tr><td>";
        let a = ad((dataOffset & ~0xF) - 0x30);
        for (let j = 0; j < 7; j++) {
            text += "&nbsp;" + f4(a) + " &nbsp;"
            for (var i = 0; i < 16; i++) {
                const cur = dataOffset == i + a && window == 1;
                if (cur)
                    text += "<span class='cur'>";
                text += f2(cpu.readMemory(a + i, 0));
                if (cur)
                    text += "</span>";
                text += " ";
            }
            text += " &nbsp;"
            for (var i = 0; i < 16; i++) {
                const c = cpu.readMemory(a + i, 0);
                text += (c >= 0x20 && c < 0x7F && c != 0x3C && c != 0x26 ? String.fromCharCode(c) : ".");
            }
            text += "<br>";
            a = ad(a + 0x10);
        }
        text += "</td><td></td></tr></table>";
        debuger.innerHTML = text;
    }

    function moveToAddress(address) {
        if (traceMode != 2)
            return;
        if (window == 1)
            dataOffset = address & 0xFFFF;
        else
            disassemblerAddess = address & 0xFFFF;
        debugerUpdate(false);
    }

    function prevInstruction(address) {
        var s = 1;
        while (getInstructionSize((address - s + 0x10000) % 0x10000) > s)
            s++;
        return (address - s + 0x10000) % 0x10000;
    }

    function cursorUp() {
        if (traceMode != 2)
            return;
        if (window == 0) {
            for (let i = 1; i < onScreenAddresses.length; i++) {
                if (onScreenAddresses[i] == disassemblerAddess) {
                    disassemblerAddess = onScreenAddresses[i - 1];
                    debugerUpdate(false);
                    return;
                }
            }
            return;
        }
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset - 16);
            debugerUpdate(false);
        }
    }

    function cursorDown() {
        if (traceMode != 2)
            return;
        if (window == 0) {
            for (let i = 0; i < onScreenAddresses.length - 1; i++) {
                if (onScreenAddresses[i] == disassemblerAddess) {
                    disassemblerAddess = onScreenAddresses[i + 1];
                    debugerUpdate(false);
                    return;
                }
            }
        }
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset + 16);
            debugerUpdate(false);
        }
    }

    function cursorPgUp() {
        if (traceMode != 2)
            return;
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset - 0x70);
            debugerUpdate(false);
        }
    }

    function cursorPgDn() {
        if (traceMode != 2)
            return;
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset + 0x70);
            debugerUpdate(false);
        }
    }

    function cursorLeft() {
        if (traceMode != 2)
            return;
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset - 1);
            debugerUpdate(false);
        }
    }

    function cursorRight() {
        if (traceMode != 2)
            return;
        if (window == 1) {
            modifyMemoryStep = -1;
            dataOffset = ad(dataOffset + 1);
            debugerUpdate(false);
        }
    }

    function addBreakpoint() {
        if (traceMode != 2)
            return;
        if (window == 0) {
            if (breakpoints[disassemblerAddess])
                delete breakpoints[disassemblerAddess];
            else
                breakpoints[disassemblerAddess] = 1;
            debugerUpdate(false);
        }
    }

    function modifyMemory(value) {
        if (window == 1) {
            if (modifyMemoryStep == -1) {
                modifyMemoryStep = value << 4;
                cpu.writeMemory(dataOffset, modifyMemoryStep);
                debugerUpdate(false);
            } else {
                cpu.writeMemory(dataOffset, modifyMemoryStep | value);
                dataOffset = ad(dataOffset + 1);
                debugerUpdate(false);
                modifyMemoryStep = -1;
            }
        }
    }

    function switchWindow() {
        window = 1 - window;
        debugerUpdate(false);
    }

    // Disassembler

    const R16Psw = [ "bc", "de", "hl", "af" ];
    const R16Sp = [ "bc", "de", "hl", "sp" ];
    const R8 = [ "b", "c", "d", "e", "h", "l", "(hl)", "a" ];
    const Alu = [ "add", "adc", "sub", "sbc", "and", "xor", "or", "cp" ];
    const CC = [ "nz", "z", "nc", "c", "po", "pe", "p", "m" ];

    function getByte(context) {
        const v = cpu.readMemory(context.addr, 0);
        context.addr = (context.addr + 1) & 0xFFFF;
        return v;
    }

    function getWord(context) {
        const l = getByte(context);
        const h = getByte(context);
        return l | (h << 8);
    }

    function f4(n) {
        return ("000" + n.toString(16).toUpperCase()).substr(-4);
    }

    function f2(n) {
        return ("0" + n.toString(16).toUpperCase()).substr(-2);
    }

    function getInstructionSize(address) {
        let context = {addr : address};
        disassembler(context);
        return (context.addr - address + 0x10000) % 0x10000;
    }

    function disassembler(context) {
        const opcode = getByte(context);
        if ((opcode & 0xC0) == 0x40) {
            if (opcode == 0x76)
                return "halt";
            return "ld " + R8[(opcode >> 3) & 7] + ", " + R8[opcode & 7];
        }
        if ((opcode & 0xC7) == 0xC7)
            return "rst " + (opcode & 0x38);
        if ((opcode & 0xCF) == 0xC5)
            return "push " + R16Psw[(opcode >> 4) & 3];
        if ((opcode & 0xCF) == 0xC1)
            return "pop " + R16Psw[(opcode >> 4) & 3];
        if ((opcode & 0xC0) == 0x80)
            return Alu[(opcode >> 3) & 7] + " " + R8[opcode & 7];
        if ((opcode & 0xC7) == 0xC0)
            return "ret " + CC[(opcode >> 3) & 3];
        if ((opcode & 0xC7) == 0xC2)
            return "jp " + CC[(opcode >> 3) & 3] + ", " + f4(getWord(context));
        if ((opcode & 0xC7) == 0xC4)
            return "call " + CC[(opcode >> 3) & 3] + ", " + f4(getWord(context));
        if ((opcode & 0xC7) == 0xC6)
            return Alu[(opcode >> 3) & 7] + " " + f2(getByte(context));
        if ((opcode & 0xCF) == 0xCD)
            return "call " + f4(getWord(context));
        switch (opcode) {
        case 0xE9:
            return "jp hl";
        case 0xD3: /* out port8 */
            return "out (" + f2(getByte(context)) + "), a";
        case 0xDB: /* in port8 */
            return "in a, (" + f2(getByte(context)) + ")";
        case 0x22:
            return "ld (" + f4(getWord(context)) + "), hl";
        case 0x2A: /* ldhl addr */
            return "ld hl, (" + f4(getWord(context)) + ")";
        case 0x32: /* sta addr */
            return "ld (" + f4(getWord(context)) + "), a";
        case 0x3A: /* lda addr */
            return "ld a, (" + f4(getWord(context)) + ")";
        case 0x00: /* nop */
            return "nop";
        case 0x08: /* nop */
        case 0x10: /* nop */
        case 0x18: /* nop */
        case 0x20: /* nop */
        case 0x28: /* nop */
        case 0x30: /* nop */
        case 0x38: /* nop */
            return "nop [" + f2(opcode) + "]";
        case 0xF3: /* di */
            return "di";
        case 0xFB: /* ei */
            return "ei";
        case 0xF9: /* sphl */
            return "ld sp, hl";
        case 0x2F: /* cma */
            return "cpl";
        case 0x37: /* stc */
            return "scf";
        case 0x3F: /* cmc */
            return "ccf";
        case 0x76: /* hlt */
            return "halt";
        case 0xC9: /* ret */
            return "ret";
        case 0xD9: /* ret, undocumented */
            return "ret [d9]";
        case 0xE3:
            return "ex (sp), hl";

        case 0x01: /* lxi b, data16 */
        case 0x11: /* lxi d, data16 */
        case 0x21: /* lxi h, data16 */
        case 0x31: /* lxi sp, data16 */
            return "ld " + R16Sp[(opcode >> 4) & 3] + ", " + f4(getWord(context));
        case 0xC3: /* jmp addr */
            return "jp " + f4(getWord(context));
        case 0xCB: /* jmp addr, undocumented */
            return "jp " + f4(getWord(context));
        case 0x02: /* stax b */
        case 0x12: /* stax d */
            return "ld (" + R16Psw[(opcode >> 4) & 1] + "), a";
        case 0x03: /* inx b */
        case 0x13: /* inx d */
        case 0x23: /* inx h */
        case 0x33: /* inx sp */
            return "inc " + R16Sp[(opcode >> 4) & 3];
        case 0x04: /* inr b */
        case 0x0C: /* inr c */
        case 0x14: /* inr d */
        case 0x1C: /* inr e */
        case 0x24: /* inr h */
        case 0x2C: /* inr l */
        case 0x34: /* inr m */
        case 0x3C: /* inr a */
            return "inc " + R8[(opcode >> 3) & 7];

        case 0x05: /* dcr b */
        case 0x0D: /* dcr c */
        case 0x15: /* dcr d */
        case 0x1D: /* dcr e */
        case 0x25: /* dcr h */
        case 0x2D: /* dcr l */
        case 0x35: /* dcr m */
        case 0x3D: /* dcr a */
            return "dec " + R8[(opcode >> 3) & 7];

        case 0x06: /* mvi b, data8 */
        case 0x0E: /* mvi c, data8 */
        case 0x16: /* mvi d, data8 */
        case 0x1E: /* mvi e, data8 */
        case 0x26: /* mvi h, data8 */
        case 0x2E: /* mvi l, data8 */
        case 0x36: /* mvi m, data8 */
        case 0x3E: /* mvi a, data8 */
            return "ld " + R8[(opcode >> 3) & 7] + ", " + f2(getByte(context));
        case 0x07: /* rlc */
            return "rlca";

        case 0x0F: /* rrc */
            return "rrca";

        case 0x17: /* ral */
            return "rla";

        case 0x1F: /* rar */
            return "rra";

        case 0x27: /* daa */
            return "daa";
        case 0xEB: /* xchg */
            return "ex hl, de";

        case 0x09: /* dad b */
        case 0x19: /* dad d */
        case 0x29: /* dad hl */
        case 0x39: /* dad sp */
            return "add hl,  " + R16Sp[(opcode >> 4) & 3];

        // ldax, 0x0A, 000r1010
        // r - 0 (bc), 1 (de)
        case 0x0A: /* ldax b */
        case 0x1A: /* ldax d */
            return "ld a, (" + R16Psw[(opcode >> 4) & 1] + ")";

        case 0x0B: /* dcx b */
        case 0x1B: /* dcx d */
        case 0x2B: /* dcx h */
        case 0x3B: /* dcx sp */
            return "dec " + R16Sp[(opcode >> 4) & 3];

        default:
            return "0x" + f2(opcode);
        }
    }

    // Bind keyboard

    document.addEventListener("keydown", function(e) {
        if (traceMode != 2) {
            if (e.keyCode == 120) { // F9
                e.stopPropagation();
                show();
            }
            return;
        }

        document.title = e.keyCode;

        switch (e.keyCode) {
        case 120: // F9
            addBreakpoint();
            return;
        case 119: // F8
            step();
            return;
        case 118: // F7
            stepOver();
            return;
        case 116: // F5
            self.stop();
            break;
        case 37: // Left
            cursorLeft();
            break;
        case 38: // Up
            cursorUp();
            break;
        case 39: // Right
            cursorRight();
            break;
        case 40: // Down
            cursorDown();
            break;
        case 33: // PgUP
            cursorPgUp();
            break;
        case 34: // PgDn
            cursorPgDn();
            break;
        case 71: // G
            const address = parseInt(prompt('Enter address'), 16);
            moveToAddress(address);
            break;
        case 9: // TAB
            switchWindow();
            break;
        case 48: // 0 - 9
        case 49:
        case 50:
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
        case 56:
        case 57:
            modifyMemory(e.keyCode - 48);
            break;
        case 65: // A - F
        case 66:
        case 67:
        case 68:
        case 69:
        case 70:
            modifyMemory(e.keyCode - 55);
            break;
        default:
            return;
        }
        e.stopPropagation();
    });
}
