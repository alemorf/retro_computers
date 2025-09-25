// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

// TODO: Я еще не успел запустить на этом эмуляторе
// программу проверки корректности эмуляции.
// Называется i8080 exerciser. Некоторые
// флаги могут эмулироваться не точно.

// TODO: Попробовать хранить флаги в одной переменной и
// рассчитывать флаги с помощью массивов flags = add_flags[a]

function I8080(readMemory, writeMemory, readIo, writeIo) {
    if (!readIo) {
        readIo = function(addr) {
            return readMemory(addr | (addr << 8));
        };
    }

    if (!writeIo) {
        writeIo = function(addr, byte) {
            writeMemory(addr | (addr << 8), byte);
        };
    }

    let b = 0, c = 0, d = 0, e = 0, h = 0, l = 0, a = 0;
    let sp = 0, pc = 0;
    let ie = false, halt = false;
    let sf = false, pf = false, ac = false, zf = false, cf = false;

    function bc() {
        return (b << 8) | c;
    };

    function de() {
        return (d << 8) | e;
    };

    function hl() {
        return (h << 8) | l;
    };

    function setBc(value) {
        b = value >> 8;
        c = value & 0xFF;
    };

    function setDe(value) {
        d = value >> 8;
        e = value & 0xFF;
    };

    function setHl(value) {
        h = value >> 8;
        l = value & 0xFF;
    };

    function f() {
        let result = 2;
        if (sf)
            result |= 0x80;
        if (zf)
            result |= 0x40;
        if (ac)
            result |= 0x10;
        if (pf)
            result |= 0x04;
        if (cf)
            result |= 0x01;
        return result;
    };

    function setF(value) {
        sf = (value & 0x80) != 0;
        zf = (value & 0x40) != 0;
        ac = (value & 0x10) != 0;
        pf = (value & 0x04) != 0;
        cf = (value & 0x01) != 0;
    };

    function readMemoryWord(addr) {
        return readMemory(addr) | (readMemory((addr + 1) & 0xFFFF) << 8);
    };

    function writeMemoryWord(addr, value) {
        writeMemory(addr, value & 0xFF);
        writeMemory((addr + 1) & 0xFFFF, value >> 8);
    };

    function readCommandByte() {
        const v = readMemory(pc);
        pc = (pc + 1) & 0xFFFF;
        return v;
    };

    function readCommandWord() {
        return readCommandByte() | (readCommandByte() << 8);
    };

    const parityTable = [
        1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1,
        0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0,
        0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0,
        1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1,
        0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1,
        0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1,
        1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1
    ];

    function setInrFlags(value) {
        ac = (value & 0x0F) == 0;
        sf = (value & 0x80) != 0;
        zf = (value == 0);
        pf = parityTable[value];
    };

    function setDcrFlags(value) {
        ac = (value & 0x0F) != 0x0F;
        sf = (value & 0x80) != 0;
        zf = (value == 0);
        pf = parityTable[value];
    };

    function add(value, carry) {
        ac = ((a & 0xF) + (value & 0xF) + (carry ? 1 : 0)) > 0xF;
        const t = a + value + (carry ? 1 : 0);
        a = t & 0xFF;
        cf = (t & 0x100) != 0;
        sf = (a & 0x80) != 0;
        zf = (a == 0);
        pf = parityTable[a];
    };

    function sub(value, carry) {
        ac = (a & 0x0F) >= ((value & 0x0F) - (carry ? 1 : 0)); // TODO: Проверить
        const t = a - value - (carry ? 1 : 0);
        a = t & 0xFF;
        cf = (t & 0x100) != 0;
        sf = (a & 0x80) != 0;
        zf = (a == 0);
        pf = parityTable[a];
    };

    function setLogicalFlags() {
        ac = false; // TODO: AND changes AC, but ANI resets
        sf = (a & 0x80) != 0;
        zf = (a == 0);
        pf = parityTable[a];
        cf = false;
    };

    function pop() {
        let value = readMemoryWord(sp);
        sp = (sp + 2) & 0xFFFF;
        return value;
    };

    function push(value) {
        sp = (sp - 2) & 0xFFFF;
        writeMemoryWord(sp, value);
    };

    function execute(opcode) {
        let t;
        switch (opcode) {
        case 0x00: /* nop */
            return 4;
        case 0x01: /* lxi b, data16 */
            setBc(readCommandWord());
            return 10;
        case 0x02: /* stax b */
            writeMemory(bc(), a);
            return 7;
        case 0x03: /* inx b */
            setBc((bc() + 1) & 0xFFFF);
            return 5;
        case 0x04: /* inr b */
            b = (b + 1) & 0xFF;
            setInrFlags(b);
            return 5;
        case 0x05: /* dcr b */
            b = (b - 1) & 0xFF;
            setDcrFlags(b);
            return 5;
        case 0x06: /* mvi b, data8 */
            b = readCommandByte();
            return 7;
        case 0x07: /* rlc */
            a = ((a << 1) | (a >> 7)) & 0xFF;
            cf = ((a & 1) != 0);
            return 4;
        case 0x08: /* nop */
            return 4;
        case 0x09: /* dad b */
            t = hl() + bc();
            setHl(t & 0xFFFF);
            cf = (t >= 0x10000);
            return 10;
        case 0x0A: /* ldax b */
            a = readMemory(bc());
            return 7;
        case 0x0B: /* dcx b */
            setBc((bc() - 1) & 0xFFFF);
            return 5;
        case 0x0C: /* inr c */
            c = (c + 1) & 0xFF;
            setInrFlags(c);
            return 5;
        case 0x0D: /* dcr c */
            c = (c - 1) & 0xFF;
            setDcrFlags(c);
            return 5;
        case 0x0E: /* mvi c, data8 */
            c = readCommandByte();
            return 7;
        case 0x0F: /* rrc */
            a = ((a >> 1) | (a << 7)) & 0xFF;
            cf = ((a & 0x80) != 0);
            return 4;
        case 0x10: /* nop */
            return 4;
        case 0x11: /* lxi d, data16 */
            setDe(readCommandWord());
            return 10;
        case 0x12: /* stax d */
            writeMemory(de(), a);
            return 7;
        case 0x13: /* inx d */
            setDe((de() + 1) & 0xFFFF);
            return 5;
        case 0x14: /* inr d */
            d = (d + 1) & 0xFF;
            setInrFlags(d);
            return 5;
        case 0x15: /* dcr d */
            d = (d - 1) & 0xFF;
            setDcrFlags(d);
            return 5;
        case 0x16: /* mvi d, data8 */
            d = readCommandByte();
            return 7;
        case 0x17: /* ral */
            t = a;
            a = ((a << 1) | (cf ? 0x01 : 0)) & 0xFF;
            cf = ((t & 0x80) != 0);
            return 4;
        case 0x18: /* nop */
            return 4;
        case 0x19: /* dad d */
            t = hl() + de();
            setHl(t & 0xFFFF);
            cf = (t >= 0x10000);
            return 10;
        case 0x1A: /* ldax d */
            a = readMemory(de());
            return 7;
        case 0x1B: /* dcx d */
            setDe((de() - 1) & 0xFFFF);
            return 5;
        case 0x1C: /* inr e */
            e = (e + 1) & 0xFF;
            setInrFlags(e);
            return 5;
        case 0x1D: /* dcr e */
            e = (e - 1) & 0xFF;
            setDcrFlags(e);
            return 5;
        case 0x1E: /* mvi e, data8 */
            e = readCommandByte();
            return 7;
        case 0x1F: /* rar */
            t = a;
            a = ((a >> 1) | (cf ? 0x80 : 0)) & 0xFF;
            cf = ((t & 0x01) != 0);
            return 4;
        case 0x20: /* nop */
            return 4;
        case 0x21: /* lxi h, data16 */
            setHl(readCommandWord());
            return 10;
        case 0x22: /* shld addr */
            writeMemoryWord(readCommandWord(), hl());
            return 16;
        case 0x23: /* inx h */
            setHl((hl() + 1) & 0xFFFF);
            return 5;
        case 0x24: /* inr h */
            h = (h + 1) & 0xFF;
            setInrFlags(h);
            return 5;
        case 0x25: /* dcr h */
            h = (h - 1) & 0xFF;
            setDcrFlags(h);
            return 5;
        case 0x26: /* mvi h, data8 */
            h = readCommandByte();
            return 7;
        case 0x27: /* daa */
            add((((a & 0x0F) > 9 || ac) ? 6 : 0) + ((a > 0x9F || cf) ? 0x60 : 0), 0);
            return 4;
        case 0x28: /* nop */
            return 4;
        case 0x29: /* dad h */
            t = hl() << 1;
            setHl(t & 0xFFFF);
            cf = (t >= 0x10000);
            return 10;
        case 0x2A: /* ldhl addr */
            setHl(readMemoryWord(readCommandWord()));
            return 16;
        case 0x2B: /* dcx h */
            setHl((hl() - 1) & 0xFFFF);
            return 5;
        case 0x2C: /* inr l */
            l = (l + 1) & 0xFF;
            setInrFlags(l);
            return 5;
        case 0x2D: /* dcr l */
            l = (l - 1) & 0xFF;
            setDcrFlags(l);
            return 5;
        case 0x2E: /* mvi l, data8 */
            l = readCommandByte();
            return 7;
        case 0x2F: /* cma */
            a ^= 0xFF;
            return 4;
        case 0x30: /* nop */
            return 4;
        case 0x31: /* lxi sp, data16 */
            sp = readCommandWord();
            return 10;
        case 0x32: /* sta addr */
            writeMemory(readCommandWord(), a);
            return 13;
        case 0x33: /* inx sp */
            sp = (sp + 1) & 0xFFFF;
            return 5;
        case 0x34: /* inr m */
            t = (readMemory(hl()) + 1) & 0xFF;
            writeMemory(hl(), t);
            setInrFlags(t);
            return 10;
        case 0x35: /* dcr m */
            t = (readMemory(hl()) - 1) & 0xFF;
            writeMemory(hl(), t);
            setDcrFlags(t);
            return 10;
        case 0x36: /* mvi m, data8 */
            writeMemory(hl(), readCommandByte());
            return 10;
        case 0x37: /* stc */
            cf = 1;
            return 4;
        case 0x38: /* nop */
            return 4;
        case 0x39: /* dad sp */
            t = hl() + sp;
            setHl(t & 0xFFFF);
            cf = (t >= 0x10000);
            return 10;
        case 0x3A: /* lda addr */
            a = readMemory(readCommandWord());
            return 13;
        case 0x3B: /* dcx sp */
            sp = (sp - 1) & 0xFFFF;
            return 5;
        case 0x3C: /* inr a */
            a = (a + 1) & 0xFF;
            setInrFlags(a);
            return 5;
        case 0x3D: /* dcr a */
            a = (a - 1) & 0xFF;
            setDcrFlags(a);
            return 5;
        case 0x3E: /* mvi a, data8 */
            a = readCommandByte();
            return 7;
        case 0x3F: /* cmc */
            cf = !cf;
            return 4;
        case 0x40: /* mov b, b */
            b = b;
            return 5;
        case 0x41: /* mov b, c */
            b = c;
            return 5;
        case 0x42: /* mov b, d */
            b = d;
            return 5;
        case 0x43: /* mov b, e */
            b = e;
            return 5;
        case 0x44: /* mov b, h */
            b = h;
            return 5;
        case 0x45: /* mov b, l */
            b = l;
            return 5;
        case 0x46: /* mov b, m */
            b = readMemory(hl());
            return 7;
        case 0x47: /* mov b, a */
            b = a;
            return 5;
        case 0x48: /* mov c, b */
            c = b;
            return 5;
        case 0x49: /* mov c, c */
            c = c;
            return 5;
        case 0x4A: /* mov c, d */
            c = d;
            return 5;
        case 0x4B: /* mov c, e */
            c = e;
            return 5;
        case 0x4C: /* mov c, h */
            c = h;
            return 5;
        case 0x4D: /* mov c, l */
            c = l;
            return 5;
        case 0x4E: /* mov c, m */
            c = readMemory(hl());
            return 7;
        case 0x4F: /* mov c, a */
            c = a;
            return 5;
        case 0x50: /* mov d, b */
            d = b;
            return 5;
        case 0x51: /* mov d, c */
            d = c;
            return 5;
        case 0x52: /* mov d, d */
            d = d;
            return 5;
        case 0x53: /* mov d, e */
            d = e;
            return 5;
        case 0x54: /* mov d, h */
            d = h;
            return 5;
        case 0x55: /* mov d, l */
            d = l;
            return 5;
        case 0x56: /* mov d, m */
            d = readMemory(hl());
            return 7;
        case 0x57: /* mov d, a */
            d = a;
            return 5;
        case 0x58: /* mov e, b */
            e = b;
            return 5;
        case 0x59: /* mov e, c */
            e = c;
            return 5;
        case 0x5A: /* mov e, d */
            e = d;
            return 5;
        case 0x5B: /* mov e, e */
            e = e;
            return 5;
        case 0x5C: /* mov e, h */
            e = h;
            return 5;
        case 0x5D: /* mov e, l */
            e = l;
            return 5;
        case 0x5E: /* mov e, m */
            e = readMemory(hl());
            return 7;
        case 0x5F: /* mov e, a */
            e = a;
            return 5;
        case 0x60: /* mov h, b */
            h = b;
            return 5;
        case 0x61: /* mov h, c */
            h = c;
            return 5;
        case 0x62: /* mov h, d */
            h = d;
            return 5;
        case 0x63: /* mov h, e */
            h = e;
            return 5;
        case 0x64: /* mov h, h */
            h = h;
            return 5;
        case 0x65: /* mov h, l */
            h = l;
            return 5;
        case 0x66: /* mov h, m */
            h = readMemory(hl());
            return 7;
        case 0x67: /* mov h, a */
            h = a;
            return 5;
        case 0x68: /* mov l, b */
            l = b;
            return 5;
        case 0x69: /* mov l, c */
            l = c;
            return 5;
        case 0x6A: /* mov l, d */
            l = d;
            return 5;
        case 0x6B: /* mov l, e */
            l = e;
            return 5;
        case 0x6C: /* mov l, h */
            l = h;
            return 5;
        case 0x6D: /* mov l, l */
            l = l;
            return 5;
        case 0x6E: /* mov l, m */
            l = readMemory(hl());
            return 7;
        case 0x6F: /* mov l, a */
            l = a;
            return 5;
        case 0x70: /* mov m, b */
            writeMemory(hl(), b);
            return 7;
        case 0x71: /* mov m, c */
            writeMemory(hl(), c);
            return 7;
        case 0x72: /* mov m, d */
            writeMemory(hl(), d);
            return 7;
        case 0x73: /* mov m, e */
            writeMemory(hl(), e);
            return 7;
        case 0x74: /* mov m, h */
            writeMemory(hl(), h);
            return 7;
        case 0x75: /* mov m, l */
            writeMemory(hl(), l);
            return 7;
        case 0x76: /* hlt */
            halt = true;
            return 4;
        case 0x77: /* mov m, a */
            writeMemory(hl(), a);
            return 7;
        case 0x78: /* mov a, b */
            a = b;
            return 5;
        case 0x79: /* mov a, c */
            a = c;
            return 5;
        case 0x7A: /* mov a, d */
            a = d;
            return 5;
        case 0x7B: /* mov a, e */
            a = e;
            return 5;
        case 0x7C: /* mov a, h */
            a = h;
            return 5;
        case 0x7D: /* mov a, l */
            a = l;
            return 5;
        case 0x7E: /* mov a, m */
            a = readMemory(hl());
            return 7;
        case 0x7F: /* mov a, a */
            a = a;
            return 5;
        case 0x80: /* add b */
            add(b, false);
            return 4;
        case 0x81: /* add c */
            add(c, false);
            return 4;
        case 0x82: /* add d */
            add(d, false);
            return 4;
        case 0x83: /* add e */
            add(e, false);
            return 4;
        case 0x84: /* add h */
            add(h, false);
            return 4;
        case 0x85: /* add l */
            add(l, false);
            return 4;
        case 0x86: /* add m */
            add(readMemory(hl()), false);
            return 7;
        case 0x87: /* add a */
            add(a, false);
            return 4;
        case 0x88: /* adc b */
            add(b, cf);
            return 4;
        case 0x89: /* adc c */
            add(c, cf);
            return 4;
        case 0x8A: /* adc d */
            add(d, cf);
            return 4;
        case 0x8B: /* adc e */
            add(e, cf);
            return 4;
        case 0x8C: /* adc h */
            add(h, cf);
            return 4;
        case 0x8D: /* adc l */
            add(l, cf);
            return 4;
        case 0x8E: /* adc m */
            add(readMemory(hl()), cf);
            return 7;
        case 0x8F: /* adc a */
            add(a, cf);
            return 4;
        case 0x90: /* sub b */
            sub(b, false);
            return 4;
        case 0x91: /* sub c */
            sub(c, false);
            return 4;
        case 0x92: /* sub d */
            sub(d, false);
            return 4;
        case 0x93: /* sub e */
            sub(e, false);
            return 4;
        case 0x94: /* sub h */
            sub(h, false);
            return 4;
        case 0x95: /* sub l */
            sub(l, false);
            return 4;
        case 0x96: /* sub m */
            sub(readMemory(hl()), false);
            return 4;
        case 0x97: /* sub a */
            sub(a, false);
            return 4;
        case 0x98: /* sbb b */
            sub(b, cf);
            return 4;
        case 0x99: /* sbb c */
            sub(c, cf);
            return 4;
        case 0x9A: /* sbb d */
            sub(d, cf);
            return 4;
        case 0x9B: /* sbb e */
            sub(e, cf);
            return 4;
        case 0x9C: /* sbb h */
            sub(h, cf);
            return 4;
        case 0x9D: /* sbb l */
            sub(l, cf);
            return 4;
        case 0x9E: /* sbb m */
            sub(readMemory(hl()), cf);
            return 4;
        case 0x9F: /* sbb a */
            sub(a, cf);
            return 4;
        case 0xA0: /* ana b */
            a &= b;
            setLogicalFlags();
            return 4;
        case 0xA1: /* ana c */
            a &= c;
            setLogicalFlags();
            return 4;
        case 0xA2: /* ana d */
            a &= d;
            setLogicalFlags();
            return 4;
        case 0xA3: /* ana e */
            a &= e;
            setLogicalFlags();
            return 4;
        case 0xA4: /* ana h */
            a &= h;
            setLogicalFlags();
            return 4;
        case 0xA5: /* ana l */
            a &= l;
            setLogicalFlags();
            return 4;
        case 0xA6: /* ana m */
            a &= readMemory(hl());
            setLogicalFlags();
            return 7;
        case 0xA7: /* ana a */
            a &= a;
            setLogicalFlags();
            return 4;
        case 0xA8: /* xra b */
            a ^= b;
            setLogicalFlags();
            return 4;
        case 0xA9: /* xra c */
            a ^= c;
            setLogicalFlags();
            return 4;
        case 0xAA: /* xra d */
            a ^= d;
            setLogicalFlags();
            return 4;
        case 0xAB: /* xra e */
            a ^= e;
            setLogicalFlags();
            return 4;
        case 0xAC: /* xra h */
            a ^= h;
            setLogicalFlags();
            return 4;
        case 0xAD: /* xra l */
            a ^= l;
            setLogicalFlags();
            return 4;
        case 0xAE: /* xra m */
            a ^= readMemory(hl());
            setLogicalFlags();
            return 7;
        case 0xAF: /* xra a */
            a ^= a;
            setLogicalFlags();
            return 4;
        case 0xB0: /* ora b */
            a |= b;
            setLogicalFlags();
            return 4;
        case 0xB1: /* ora c */
            a |= c;
            setLogicalFlags();
            return 4;
        case 0xB2: /* ora d */
            a |= d;
            setLogicalFlags();
            return 4;
        case 0xB3: /* ora e */
            a |= e;
            setLogicalFlags();
            return 4;
        case 0xB4: /* ora h */
            a |= h;
            setLogicalFlags();
            return 4;
        case 0xB5: /* ora l */
            a |= l;
            setLogicalFlags();
            return 4;
        case 0xB6: /* ora m */
            a |= readMemory(hl());
            setLogicalFlags();
            return 7;
        case 0xB7: /* ora a */
            a |= a;
            setLogicalFlags();
            return 4;
        case 0xB8: /* cmp b */
            t = a;
            sub(b, false);
            a = t;
            return 4;
        case 0xB9: /* cmp c */
            t = a;
            sub(c, false);
            a = t;
            return 4;
        case 0xBA: /* cmp d */
            t = a;
            sub(d, false);
            a = t;
            return 4;
        case 0xBB: /* cmp e */
            t = a;
            sub(e, false);
            a = t;
            return 4;
        case 0xBC: /* cmp h */
            t = a;
            sub(h, false);
            a = t;
            return 4;
        case 0xBD: /* cmp l */
            t = a;
            sub(l, false);
            a = t;
            return 4;
        case 0xBE: /* cmp m */
            t = a;
            sub(readMemory(hl()), false);
            a = t;
            return 7;
        case 0xBF: /* cmp a */
            t = a;
            sub(a, false);
            a = t;
            return 4;
        case 0xC0: /* rnz */
            if (zf)
                return 5;
            pc = pop();
            return 11;
        case 0xC1: /* pop b */
            setBc(pop());
            return 11;
        case 0xC2: /* jnz addr */
            t = readCommandWord();
            if (!zf)
                pc = t;
            return 10;
        case 0xC3: /* jmp addr */
            pc = readCommandWord();
            return 10;
        case 0xC4: /* cnz addr */
            t = readCommandWord();
            if (zf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xC5: /* push b */
            push(bc());
            return 11;
        case 0xC6: /* adi data8 */
            add(readCommandByte(), 0);
            return 7;
        case 0xC7: /* rst 0 */
            push(pc);
            pc = 0x0000;
            return 11;
        case 0xC8: /* rz */
            if (!zf)
                return 5;
            pc = pop();
            return 11;
        case 0xC9: /* ret */
            pc = pop();
            return 10;
        case 0xCA: /* jz addr */
            t = readCommandWord();
            if (zf)
                pc = t;
            return 10;
        case 0xCB: /* jmp addr, undocumented */
            pc = readCommandWord();
            return 10;
        case 0xCC: /* cz addr */
            t = readCommandWord();
            if (!zf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xCD: /* call addr */
            t = readCommandWord();
            push(pc);
            pc = t;
            return 17;
        case 0xCE: /* aci data8 */
            add(readCommandByte(), cf);
            return 7;
        case 0xCF: /* rst 1 */
            push(pc);
            pc = 0x0008;
            return 11;
        case 0xD0: /* rnc */
            if (cf)
                return 5;
            pc = pop();
            return 11;
        case 0xD1: /* pop d */
            setDe(pop());
            return 11;
        case 0xD2: /* jnc addr */
            t = readCommandWord();
            if (!cf)
                pc = t;
            return 10;
        case 0xD3: /* out port8 */
            writeIo(readCommandByte(), a);
            return 10;
        case 0xD4: /* cnc addr */
            t = readCommandWord();
            if (cf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xD5: /* push d */
            push(de());
            return 11;
        case 0xD6: /* sui data8 */
            sub(readCommandByte(), 0);
            return 7;
        case 0xD7: /* rst 2 */
            push(pc);
            pc = 0x0010;
            return 11;
        case 0xD8: /* rc */
            if (!cf)
                return 5;
            pc = pop();
            return 11;
        case 0xD9: /* ret, undocumented */
            pc = pop();
            return 10;
        case 0xDA: /* jc addr */
            t = readCommandWord();
            if (cf)
                pc = t;
            return 10;
        case 0xDB: /* in port8 */
            a = readIo(readCommandByte());
            return 10;
        case 0xDC: /* cc addr */
            t = readCommandWord();
            if (!cf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xDD: /* call, undocumented */
            t = readCommandWord();
            push(pc);
            pc = t;
            return 17;
        case 0xDE: /* sbi data8 */
            sub(readCommandByte(), cf);
            return 7;
        case 0xDF: /* rst 3 */
            push(pc);
            pc = 0x0018;
            return 11;
        case 0xE0: /* rpo */
            if (pf)
                return 5;
            pc = pop();
            return 11;
        case 0xE1: /* pop h */
            setHl(pop());
            return 11;
        case 0xE2: /* jpo addr */
            t = readCommandWord();
            if (!pf)
                pc = t;
            return 10;
        case 0xE3: /* xthl */
            t = readMemoryWord(sp);
            writeMemoryWord(sp, hl());
            setHl(t);
            return 18;
        case 0xE4: /* cpo addr */
            t = readCommandWord();
            if (pf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xE5: /* push h */
            push(hl());
            return 11;
        case 0xE6: /* ani data8 */
            a &= readCommandByte();
            setLogicalFlags();
            return 7;
        case 0xE7: /* rst 4 */
            push(pc);
            pc = 0x0020;
            return 11;
        case 0xE8: /* rpe */
            if (!pf)
                return 5;
            pc = pop();
            return 11;
        case 0xE9: /* pchl */
            pc = hl();
            return 5;
        case 0xEA: /* jpe addr */
            t = readCommandWord();
            if (pf)
                pc = t;
            return 10;
        case 0xEB: /* xchg */
            t = l;
            l = e;
            e = t;
            t = h;
            h = d;
            d = t;
            return 4;
        case 0xEC: /* cpe addr */
            t = readCommandWord();
            if (!pf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xED: /* call, undocumented */
            t = readCommandWord();
            push(pc);
            pc = t;
            return 17;
        case 0xEE: /* xri data8 */
            a ^= readCommandByte();
            setLogicalFlags();
            return 7;
        case 0xEF: /* rst 5 */
            push(pc);
            pc = 0x0028;
            return 11;
        case 0xF0: /* rp */
            if (sf)
                return 5;
            pc = pop();
            return 11;
        case 0xF1: /* pop psw */
            t = pop();
            a = t >> 8;
            setF(t & 0xff);
            return 11;
        case 0xF2: /* jp addr */
            t = readCommandWord();
            if (!sf)
                pc = t;
            return 10;
        case 0xF3: /* di */
            ie = false;
            return 4;
        case 0xF4: /* cp addr */
            t = readCommandWord();
            if (sf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xF5: /* push psw */
            push((a << 8) | f());
            return 11;
        case 0xF6: /* ori data8 */
            a |= readCommandByte();
            setLogicalFlags();
            return 7;
        case 0xF7: /* rst 6 */
            push(pc);
            pc = 0x0030;
            return 11;
        case 0xF8: /* rm */
            if (!sf)
                return 5;
            pc = pop();
            return 11;
        case 0xF9: /* sphl */
            sp = hl();
            return 5;
        case 0xFA: /* jm addr */
            t = readCommandWord();
            if (sf)
                pc = t;
            return 10;
        case 0xFB: /* ei */
            ie = true;
            return 4;
        case 0xFC: /* cm addr */
            t = readCommandWord();
            if (!sf)
                return 11;
            push(pc);
            pc = t;
            return 17;
        case 0xFD: /* call, undocumented */
            t = readCommandWord();
            push(pc);
            pc = t;
            return 17;
        case 0xFE: /* cpi data8 */
            t = a;
            sub(readCommandByte(), false);
            a = t;
            return 7;
        case 0xFF: /* rst 7 */
            push(pc);
            pc = 0x0038;
            return 11;
        }
        return 4;
    };

    this.instruction = function() {
        if (halt)
            return 4;
        return execute(readCommandByte());
    };

    this.jump = function(addr) {
        pc = addr & 0xFFFF;
    };

    this.reset = function(addr) {
        ie = false;
        halt = false;
        pc = addr & 0xFFFF;
    };

    this.getPc = function() {
        return pc;
    }
}
