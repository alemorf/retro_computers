// Intel 8080 (KR580VM80A) microprocessor core model in JavaScript
//
// Copyright (C) 2012 Alexander Demin <alexander@demin.ws>
//
// Credits
//
// Viacheslav Slavinsky, Vector-06C FPGA Replica
// http://code.google.com/p/vector06cc/
//
// Dmitry Tselikov, Bashrikia-2M and Radio-86RK on Altera DE1
// http://bashkiria-2m.narod.ru/fpga.html
//
// Ian Bartholomew, 8080/8085 CPU Exerciser
// http://www.idb.me.uk/sunhillow/8080.html
//
// Frank Cringle, The original exerciser for the Z80.
//
// Thanks to zx.pk.ru and nedopc.org/forum communities.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

function I8080() {
  this.sp = 0;
  this.pc = 0;
  this.iff = 0;

  this.sf = 0;
  this.pf = 0;
  this.hf = 0;
  this.zf = 0;
  this.cf = 0;

  this.readIo = function(addr) {
    return this.readMemory(addr | (addr << 8));
  }

  this.writeIo = function(addr, byte) {
    this.writeMemory(addr | (addr << 8), byte);
  }

    
  // Registers: b, c, d, e, h, l, m, a
  //            0  1  2  3  4  5  6  7
  this.regs = [ 0, 0, 0, 0, 0, 0, 0, 0 ];

  this.memory_read_byte = function(addr, m1) {
    return this.readMemory(addr & 0xffff, m1) & 0xff;
  }

  this.memory_write_byte = function(addr, w8) {
    this.writeMemory(addr & 0xffff, w8 & 0xff);
  }

  this.memory_read_word = function(addr, flags) {
    return this.memory_read_byte(addr, flags) | (this.memory_read_byte(addr + 1, flags) << 8); 
  }

  this.memory_write_word = function(addr, w16, flags) {
    this.memory_write_byte(addr, w16 & 0xff, flags);
    this.memory_write_byte(addr + 1, w16 >> 8, flags);
  }

  this.reg = function(r) {
    return r != 6 ? this.regs[r] : this.memory_read_byte(this.hl());
  }

  this.set_reg = function(r, w8) {
    w8 &= 0xff;
    if (r != 6)
      this.regs[r] = w8;
    else
      this.memory_write_byte(this.hl(), w8);
  }

  // r - 00 (bc), 01 (de), 10 (hl), 11 (sp)
  this.rp = function(r) {
    return r != 6 ? (this.regs[r] << 8) | this.regs[r + 1] : this.sp;
  }

  this.set_rp = function(r, w16) {
    if (r != 6) {
      this.set_reg(r, w16 >> 8);
      this.set_reg(r + 1, w16 & 0xff);
    } else
      this.sp = w16;
  }

  this.parity_table = [
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0,
    1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1,
  ];

  this.half_carry_table = [ 0, 0, 1, 0, 1, 0, 1, 1 ];
  this.sub_half_carry_table = [ 0, 1, 1, 1, 0, 0, 0, 1 ];

  const F_CARRY  = 0x01;
  const F_UN1    = 0x02;
  const F_PARITY = 0x04;
  const F_UN3    = 0x08;
  const F_HCARRY = 0x10;
  const F_UN5    = 0x20;
  const F_ZERO   = 0x40;
  const F_NEG    = 0x80;

  this.store_flags = function() {
    var f = 0;
    if (this.sf) f |= F_NEG;    else f &= ~F_NEG;
    if (this.zf) f |= F_ZERO;   else f &= ~F_ZERO;
    if (this.hf) f |= F_HCARRY; else f &= ~F_HCARRY;
    if (this.pf) f |= F_PARITY; else f &= ~F_PARITY;
    if (this.cf) f |= F_CARRY;  else f &= ~F_CARRY;
    f |= F_UN1;    // UN1_FLAG is always 1.
    f &= ~F_UN3;   // UN3_FLAG is always 0.
    f &= ~F_UN5;   // UN5_FLAG is always 0.
    return f;
  }

  this.retrieve_flags = function(f) {
    this.sf = f & F_NEG    ? 1 : 0;
    this.zf = f & F_ZERO   ? 1 : 0;
    this.hf = f & F_HCARRY ? 1 : 0;
    this.pf = f & F_PARITY ? 1 : 0;
    this.cf = f & F_CARRY  ? 1 : 0;
  }

  this.bc = function() { return this.rp(0); }
  this.de = function() { return this.rp(2); }
  this.hl = function() { return this.rp(4); }

  this.b = function() { return this.reg(0); }
  this.c = function() { return this.reg(1); }
  this.d = function() { return this.reg(2); }
  this.e = function() { return this.reg(3); }
  this.h = function() { return this.reg(4); }
  this.l = function() { return this.reg(5); }
  this.a = function() { return this.reg(7); }

  this.set_b = function(v) { this.set_reg(0, v); }
  this.set_c = function(v) { this.set_reg(1, v); }
  this.set_d = function(v) { this.set_reg(2, v); }
  this.set_e = function(v) { this.set_reg(3, v); }
  this.set_h = function(v) { this.set_reg(4, v); }
  this.set_l = function(v) { this.set_reg(5, v); }
  this.set_a = function(v) { this.set_reg(7, v); }

  this.next_pc_byte = function(m1) {
    var v = this.memory_read_byte(this.pc, m1);
    this.pc = (this.pc + 1) & 0xffff;
    return v;
  }

  this.next_pc_word = function() {
    return this.next_pc_byte() | (this.next_pc_byte() << 8);
  }

  this.inr = function(r) {
    var v = this.reg(r);
    v = (v + 1) & 0xff;
    this.set_reg(r, v);
    this.sf = (v & 0x80) != 0;
    this.zf = (v == 0);
    this.hf = (v & 0x0f) == 0;
    this.pf = this.parity_table[v];
  }

  this.dcr = function(r) {
    var v = this.reg(r);
    v = (v - 1) & 0xff;
    this.set_reg(r, v);
    this.sf = (v & 0x80) != 0;
    this.zf = (v == 0);
    this.hf = !((v & 0x0f) == 0x0f);
    this.pf = this.parity_table[v];
  }

  this.add_im8 = function(v, carry) {
    var a = this.a();
    var w16 = a + v + carry;
    var index = ((a & 0x88) >> 1) | ((v & 0x88) >> 2) | ((w16 & 0x88) >> 3);
    a = w16 & 0xff;
    this.sf = (a & 0x80) != 0;
    this.zf = (a == 0);
    this.hf = this.half_carry_table[index & 0x7];
    this.pf = this.parity_table[a];
    this.cf = (w16 & 0x0100) != 0;
    this.set_a(a);
  }

  this.add = function(r, carry) {
    this.add_im8(this.reg(r), carry);
  }

  this.sub_im8 = function(v, carry) {
    var a = this.a();
    var w16 = (a - v - carry) & 0xffff;
    var index = ((a & 0x88) >> 1) | ((v & 0x88) >> 2) | ((w16 & 0x88) >> 3);
    a = w16 & 0xff;
    this.sf = (a & 0x80) != 0;
    this.zf = (a == 0);
    this.hf = !this.sub_half_carry_table[index & 0x7];
    this.pf = this.parity_table[a];
    this.cf = (w16 & 0x0100) != 0;
    this.set_a(a);
  }

  this.sub = function(r, carry) {
    this.sub_im8(this.reg(r), carry);
  }

  this.cmp_im8 = function(v) {
    var a = this.a();    // Store the accumulator before substraction.
    this.sub_im8(v, 0);
    this.set_a(a);       // Ignore the accumulator value after substraction.
  }

  this.cmp = function(r) {
    this.cmp_im8(this.reg(r));
  }

  this.ana_im8 = function(v) {
    var a = this.a();
    this.hf = ((a | v) & 0x08) != 0;
    a &= v;
    this.sf = (a & 0x80) != 0;
    this.zf = (a == 0);
    this.pf = this.parity_table[a];
    this.cf = 0;
    this.set_a(a);
  }

  this.ana = function(r) {
    this.ana_im8(this.reg(r));
  }

  this.xra_im8 = function(v) {
    var a = this.a();
    a ^= v;
    this.sf = (a & 0x80) != 0;
    this.zf = (a == 0);
    this.hf = 0;
    this.pf = this.parity_table[a];
    this.cf = 0;
    this.set_a(a);
  }

  this.xra = function(r) {
    this.xra_im8(this.reg(r));
  }

  this.ora_im8 = function(v) {
    var a = this.a();
    a |= v;
    this.sf = (a & 0x80) != 0;
    this.zf = (a == 0);
    this.hf = 0;
    this.pf = this.parity_table[a];
    this.cf = 0;
    this.set_a(a);
  }

  this.ora = function(r) {
    this.ora_im8(this.reg(r));
  }

  // r - 0 (bc), 2 (de), 4 (hl), 6 (sp)
  this.dad = function(r) {
    var hl = this.hl() + this.rp(r);
    this.cf = (hl & 0x10000) != 0;
    this.set_h(hl >> 8);
    this.set_l(hl & 0xff);
  }

  this.call = function(w16) {
    this.push(this.pc);
    this.pc = w16;
  }

  this.ret = function() {
    this.pc = this.pop();
  }

  this.pop = function() {
    var v = this.memory_read_word(this.sp, 2);
    this.sp = (this.sp + 2) & 0xffff;
    return v;
  }

  this.push = function(v) {
    this.sp = (this.sp - 2) & 0xffff;
    this.memory_write_word(this.sp, v, 2);
  }

  this.rst = function(addr) {
    this.push(this.pc);
    this.pc = addr;
  }

  this.execute = function(opcode) {
    var cpu_cycles = -1;
    var r, w8, w16, direction, flags;

    switch (opcode) {
      default:
        alert("Oops! Unhandled opcode " + opcode.toString(16));
        break;

      // nop, 0x00, 00rrr000
      // r - 000(0) to 111(7)
      case 0x00:            /* nop */
      // Undocumented NOP.
      case 0x08:            /* nop */
      case 0x10:            /* nop */
      case 0x18:            /* nop */
      case 0x20:            /* nop */
      case 0x28:            /* nop */
      case 0x30:            /* nop */
      case 0x38:            /* nop */
          cpu_cycles = 4;
          break;

      // lxi, 0x01, 00rr0001
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (sp)
      case 0x01:            /* lxi b, data16 */
      case 0x11:            /* lxi d, data16 */
      case 0x21:            /* lxi h, data16 */
      case 0x31:            /* lxi sp, data16 */
          cpu_cycles = 10;
          this.set_rp(opcode >> 3, this.next_pc_word());
          break;

      // stax, 0x02, 000r0010
      // r - 0 (bc), 1 (de)
      case 0x02:            /* stax b */
      case 0x12:            /* stax d */
          cpu_cycles = 7;
          this.memory_write_byte(this.rp(opcode >> 3), this.a());
          break;

      // inx, 0x03, 00rr0011
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (sp)
      case 0x03:            /* inx b */
      case 0x13:            /* inx d */
      case 0x23:            /* inx h */
      case 0x33:            /* inx sp */
          cpu_cycles = 5;
          var r = opcode >> 3;
          this.set_rp(r, (this.rp(r) + 1) & 0xffff);
          break;

      // inr, 0x04, 00rrr100
      // rrr - b, c, d, e, h, l, m, a
      case 0x04:            /* inr b */
      case 0x0C:            /* inr c */
      case 0x14:            /* inr d */
      case 0x1C:            /* inr e */
      case 0x24:            /* inr h */
      case 0x2C:            /* inr l */
      case 0x34:            /* inr m */
      case 0x3C:            /* inr a */
          cpu_cycles = opcode != 0x34 ? 5 : 10;
          this.inr(opcode >> 3);
          break;

      // dcr, 0x05, 00rrr100
      // rrr - b, c, d, e, h, l, m, a
      case 0x05:            /* dcr b */
      case 0x0D:            /* dcr c */
      case 0x15:            /* dcr d */
      case 0x1D:            /* dcr e */
      case 0x25:            /* dcr h */
      case 0x2D:            /* dcr l */
      case 0x35:            /* dcr m */
      case 0x3D:            /* dcr a */
          cpu_cycles = opcode != 0x35 ? 5 : 10;
          this.dcr(opcode >> 3);
          break;

      // mvi, 0x06, 00rrr110
      // rrr - b, c, d, e, h, l, m, a
      case 0x06:            /* mvi b, data8 */
      case 0x0E:            /* mvi c, data8 */
      case 0x16:            /* mvi d, data8 */
      case 0x1E:            /* mvi e, data8 */
      case 0x26:            /* mvi h, data8 */
      case 0x2E:            /* mvi l, data8 */
      case 0x36:            /* mvi m, data8 */
      case 0x3E:            /* mvi a, data8 */
          cpu_cycles = opcode != 0x36 ? 7 : 10;
          this.set_reg(opcode >> 3, this.next_pc_byte());
          break;

      case 0x07:            /* rlc */
          cpu_cycles = 4;
          a = this.a();
          this.cf = ((a & 0x80) != 0);
          this.set_a(((a << 1) & 0xff) | this.cf);
          break;

      // dad, 0x09, 00rr1001
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (sp)
      case 0x09:            /* dad b */
      case 0x19:            /* dad d */
      case 0x29:            /* dad hl */
      case 0x39:            /* dad sp */
          cpu_cycles = 10;
          this.dad((opcode & 0x30) >> 3);
          break;

      // ldax, 0x0A, 000r1010
      // r - 0 (bc), 1 (de)
      case 0x0A:            /* ldax b */
      case 0x1A:            /* ldax d */
          cpu_cycles = 7;
          var r = (opcode & 0x10) >> 3;
          this.set_a(this.memory_read_byte(this.rp(r)));
          break;

      // dcx, 0x0B, 00rr1011
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (sp)
      case 0x0B:            /* dcx b */
      case 0x1B:            /* dcx d */
      case 0x2B:            /* dcx h */
      case 0x3B:            /* dcx sp */
          cpu_cycles = 5;
          var r = (opcode & 0x30) >> 3;
          this.set_rp(r, (this.rp(r) - 1) & 0xffff);
          break;

      case 0x0F:            /* rrc */
          cpu_cycles = 4;
          this.cf = this.a() & 0x01;
          this.set_a((this.a() >> 1) | (this.cf << 7));
          break;

      case 0x17:            /* ral */
          cpu_cycles = 4;
          w8 = this.cf;
          this.cf = ((this.a() & 0x80) != 0);
          this.set_a((this.a() << 1) | w8);
          break;

      case 0x1F:             /* rar */
          cpu_cycles = 4;
          w8 = this.cf;
          this.cf = this.a() & 0x01;
          this.set_a((this.a() >> 1) | (w8 << 7));
          break;

      case 0x22:            /* shld addr */
          cpu_cycles = 16;
          w16 = this.next_pc_word();
          this.memory_write_byte(w16, this.l());
          this.memory_write_byte(w16 + 1, this.h());
          break;

      case 0x27:            /* daa */
          cpu_cycles = 4;
          var carry = this.cf;
          var add = 0;
          var a = this.a();
          if (this.hf || (a & 0x0f) > 9) add = 0x06;
          if (this.cf || (a >> 4) > 9 || ((a >> 4) >= 9 && (a & 0xf) > 9)) {
              add |= 0x60;
              carry = 1;
          }
          this.add_im8(add, 0);
          this.pf = this.parity_table[this.a()];
          this.cf = carry;
          break;

      case 0x2A:            /* ldhl addr */
          cpu_cycles = 16;
          var w16 = this.next_pc_word();
          this.regs[5] = this.memory_read_byte(w16);
          this.regs[4] = this.memory_read_byte(w16 + 1);
          break;

      case 0x2F:            /* cma */
          cpu_cycles = 4;
          this.set_a(this.a() ^ 0xff);
          break;

      case 0x32:            /* sta addr */
          cpu_cycles = 13;
          this.memory_write_byte(this.next_pc_word(), this.a());
          break;

      case 0x37:            /* stc */
          cpu_cycles = 4;
          this.cf = 1;
          break;

      case 0x3A:            /* lda addr */
          cpu_cycles = 13;
          this.set_a(this.memory_read_byte(this.next_pc_word()));
          break;

      case 0x3F:            /* cmc */
          cpu_cycles = 4;
          this.cf = !this.cf;
          break;

      // mov, 0x40, 01dddsss
      // ddd, sss - b, c, d, e, h, l, m, a
      //            0  1  2  3  4  5  6  7
      case 0x40:            /* mov b, b */
      case 0x41:            /* mov b, c */
      case 0x42:            /* mov b, d */
      case 0x43:            /* mov b, e */
      case 0x44:            /* mov b, h */
      case 0x45:            /* mov b, l */
      case 0x46:            /* mov b, m */
      case 0x47:            /* mov b, a */

      case 0x48:            /* mov c, b */
      case 0x49:            /* mov c, c */
      case 0x4A:            /* mov c, d */
      case 0x4B:            /* mov c, e */
      case 0x4C:            /* mov c, h */
      case 0x4D:            /* mov c, l */
      case 0x4E:            /* mov c, m */
      case 0x4F:            /* mov c, a */

      case 0x50:            /* mov d, b */
      case 0x51:            /* mov d, c */
      case 0x52:            /* mov d, d */
      case 0x53:            /* mov d, e */
      case 0x54:            /* mov d, h */
      case 0x55:            /* mov d, l */
      case 0x56:            /* mov d, m */
      case 0x57:            /* mov d, a */

      case 0x58:            /* mov e, b */
      case 0x59:            /* mov e, c */
      case 0x5A:            /* mov e, d */
      case 0x5B:            /* mov e, e */
      case 0x5C:            /* mov e, h */
      case 0x5D:            /* mov e, l */
      case 0x5E:            /* mov e, m */
      case 0x5F:            /* mov e, a */

      case 0x60:            /* mov h, b */
      case 0x61:            /* mov h, c */
      case 0x62:            /* mov h, d */
      case 0x63:            /* mov h, e */
      case 0x64:            /* mov h, h */
      case 0x65:            /* mov h, l */
      case 0x66:            /* mov h, m */
      case 0x67:            /* mov h, a */

      case 0x68:            /* mov l, b */
      case 0x69:            /* mov l, c */
      case 0x6A:            /* mov l, d */
      case 0x6B:            /* mov l, e */
      case 0x6C:            /* mov l, h */
      case 0x6D:            /* mov l, l */
      case 0x6E:            /* mov l, m */
      case 0x6F:            /* mov l, a */

      case 0x70:            /* mov m, b */
      case 0x71:            /* mov m, c */
      case 0x72:            /* mov m, d */
      case 0x73:            /* mov m, e */
      case 0x74:            /* mov m, h */
      case 0x75:            /* mov m, l */
      case 0x77:            /* mov m, a */

      case 0x78:            /* mov a, b */
      case 0x79:            /* mov a, c */
      case 0x7A:            /* mov a, d */
      case 0x7B:            /* mov a, e */
      case 0x7C:            /* mov a, h */
      case 0x7D:            /* mov a, l */
      case 0x7E:            /* mov a, m */
      case 0x7F:            /* mov a, a */
          src = opcode & 7;
          dst = (opcode >> 3) & 7;
          cpu_cycles = (src == 6 || dst == 6 ? 7 : 5);
          this.set_reg(dst, this.reg(src));
          break;

      case 0x76:            /* hlt */
          cpu_cycles = 4;
          this.pc = (this.pc - 1) & 0xffff;
          break;

     // add, 0x80, 10000rrr
     // rrr - b, c, d, e, h, l, m, a
      case 0x80:            /* add b */
      case 0x81:            /* add c */
      case 0x82:            /* add d */
      case 0x83:            /* add e */
      case 0x84:            /* add h */
      case 0x85:            /* add l */
      case 0x86:            /* add m */
      case 0x87:            /* add a */

      // adc, 0x80, 10001rrr
      // rrr - b, c, d, e, h, l, m, a
      case 0x88:            /* adc b */
      case 0x89:            /* adc c */
      case 0x8A:            /* adc d */
      case 0x8B:            /* adc e */
      case 0x8C:            /* adc h */
      case 0x8D:            /* adc l */
      case 0x8E:            /* adc m */
      case 0x8F:            /* adc a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.add(r, (opcode & 0x08 ? this.cf : 0));
          break

     // sub, 0x90, 10010rrr
     // rrr - b, c, d, e, h, l, m, a
      case 0x90:            /* sub b */
      case 0x91:            /* sub c */
      case 0x92:            /* sub d */
      case 0x93:            /* sub e */
      case 0x94:            /* sub h */
      case 0x95:            /* sub l */
      case 0x96:            /* sub m */
      case 0x97:            /* sub a */

     // sbb, 0x98, 10010rrr
     // rrr - b, c, d, e, h, l, m, a
      case 0x98:            /* sbb b */
      case 0x99:            /* sbb c */
      case 0x9A:            /* sbb d */
      case 0x9B:            /* sbb e */
      case 0x9C:            /* sbb h */
      case 0x9D:            /* sbb l */
      case 0x9E:            /* sbb m */
      case 0x9F:            /* sbb a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.sub(r, (opcode & 0x08 ? this.cf : 0));
          break;

      case 0xA0:            /* ana b */
      case 0xA1:            /* ana c */
      case 0xA2:            /* ana d */
      case 0xA3:            /* ana e */
      case 0xA4:            /* ana h */
      case 0xA5:            /* ana l */
      case 0xA6:            /* ana m */
      case 0xA7:            /* ana a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.ana(r);
          break;

      case 0xA8:            /* xra b */
      case 0xA9:            /* xra c */
      case 0xAA:            /* xra d */
      case 0xAB:            /* xra e */
      case 0xAC:            /* xra h */
      case 0xAD:            /* xra l */
      case 0xAE:            /* xra m */
      case 0xAF:            /* xra a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.xra(r);
          break;

      case 0xB0:            /* ora b */
      case 0xB1:            /* ora c */
      case 0xB2:            /* ora d */
      case 0xB3:            /* ora e */
      case 0xB4:            /* ora h */
      case 0xB5:            /* ora l */
      case 0xB6:            /* ora m */
      case 0xB7:            /* ora a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.ora(r);
          break;

      case 0xB8:            /* cmp b */
      case 0xB9:            /* cmp c */
      case 0xBA:            /* cmp d */
      case 0xBB:            /* cmp e */
      case 0xBC:            /* cmp h */
      case 0xBD:            /* cmp l */
      case 0xBE:            /* cmp m */
      case 0xBF:            /* cmp a */
          r = opcode & 0x07;
          cpu_cycles = (r != 6 ? 4 : 7);
          this.cmp(r);
          break;

      // rnz, rz, rnc, rc, rpo, rpe, rp, rm
      // 0xC0, 11ccd000
      // cc - 00 (zf), 01 (cf), 10 (pf), 11 (sf)
      // d - 0 (negate) or 1.
      case 0xC0:            /* rnz */
      case 0xC8:            /* rz */
      case 0xD0:            /* rnc */
      case 0xD8:            /* rc */
      case 0xE0:            /* rpo */
      case 0xE8:            /* rpe */
      case 0xF0:            /* rp */
      case 0xF8:            /* rm */
          flags = [this.zf, this.cf, this.pf, this.sf];
          r = (opcode >> 4) & 0x03;
          direction = (opcode & 0x08) != 0;
          cpu_cycles = 5;
          if (flags[r] == direction) {
            cpu_cycles = 11;
            this.ret();
          }
          break;

      // pop, 0xC1, 11rr0001
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (psw)
      case 0xC1:            /* pop b */
      case 0xD1:            /* pop d */
      case 0xE1:            /* pop h */
      case 0xF1:            /* pop psw */
          r = (opcode & 0x30) >> 3;
          cpu_cycles = 11;
          w16 = this.pop();
          if (r != 6) {
            this.set_rp(r, w16);
          } else {
            this.set_a(w16 >> 8);
            this.retrieve_flags(w16 & 0xff);
          }
          break;

      // jnz, jz, jnc, jc, jpo, jpe, jp, jm
      // 0xC2, 11ccd010
      // cc - 00 (zf), 01 (cf), 10 (pf), 11 (sf)
      // d - 0 (negate) or 1.
      case 0xC2:            /* jnz addr */
      case 0xCA:            /* jz addr */
      case 0xD2:            /* jnc addr */
      case 0xDA:            /* jc addr */
      case 0xE2:            /* jpo addr */
      case 0xEA:            /* jpe addr */
      case 0xF2:            /* jp addr */
      case 0xFA:            /* jm addr */
          flags = [this.zf, this.cf, this.pf, this.sf];
          r = (opcode >> 4) & 0x03;
          direction = (opcode & 0x08) != 0;
          cpu_cycles = 10;
          w16 = this.next_pc_word();
          this.pc = flags[r] == direction ? w16 : this.pc;
          break;

      // jmp, 0xc3, 1100r011
      case 0xC3:            /* jmp addr */
      case 0xCB:            /* jmp addr, undocumented */
          cpu_cycles = 10;
          this.pc = this.next_pc_word();
          break;

      // cnz, cz, cnc, cc, cpo, cpe, cp, cm
      // 0xC4, 11ccd100
      // cc - 00 (zf), 01 (cf), 10 (pf), 11 (sf)
      // d - 0 (negate) or 1.
      case 0xC4:            /* cnz addr */
      case 0xCC:            /* cz addr */
      case 0xD4:            /* cnc addr */
      case 0xDC:            /* cc addr */
      case 0xE4:            /* cpo addr */
      case 0xEC:            /* cpe addr */
      case 0xF4:            /* cp addr */
      case 0xFC:            /* cm addr */
          flags = [this.zf, this.cf, this.pf, this.sf];
          r = (opcode >> 4) & 0x03;
          direction = (opcode & 0x08) != 0;
          w16 = this.next_pc_word();
          cpu_cycles = 11;
          if (flags[r] == direction) {
            cpu_cycles = 17;
            this.call(w16);
          }
          break;

      // push, 0xC5, 11rr0101
      // rr - 00 (bc), 01 (de), 10 (hl), 11 (psw)
      case 0xC5:            /* push b */
      case 0xD5:            /* push d */
      case 0xE5:            /* push h */
      case 0xF5:            /* push psw */
          r = (opcode & 0x30) >> 3;
          cpu_cycles = 11;
          w16 = r != 6 ? this.rp(r) : (this.a() << 8) | this.store_flags();
          this.push(w16);
          break;

      case 0xC6:            /* adi data8 */
          cpu_cycles = 7;
          this.add_im8(this.next_pc_byte(), 0);
          break;

      // rst, 0xC7, 11aaa111
      // aaa - 000(0)-111(7), address = aaa*8 (0 to 0x38).
      case 0xC7:            /* rst 0 */
      case 0xCF:            /* rst 1 */
      case 0xD7:            /* rst 2 */
      case 0xDF:            /* rst 3 */
      case 0xE7:            /* rst 4 */
      case 0xEF:            /* rst 5 */
      case 0xF7:            /* rst 5 */
      case 0xFF:            /* rst 7 */
          cpu_cycles = 11;
          this.rst(opcode & 0x38);
          break;

      // ret, 0xc9, 110r1001
      case 0xC9:            /* ret */
      case 0xD9:            /* ret, undocumented */
          cpu_cycles = 10;
          this.ret();
          break;

      // call, 0xcd, 11rr1101
      case 0xCD:            /* call addr */
      case 0xDD:            /* call, undocumented */
      case 0xED:
      case 0xFD:
          cpu_cycles = 17;
          this.call(this.next_pc_word());
          break;

      case 0xCE:            /* aci data8 */
          cpu_cycles = 7;
          this.add_im8(this.next_pc_byte(), this.cf);
          break;

      case 0xD3:            /* out port8 */
          cpu_cycles = 10;
          this.writeIo(this.next_pc_byte(), this.a());
          break;

      case 0xD6:            /* sui data8 */
          cpu_cycles = 7;
          this.sub_im8(this.next_pc_byte(), 0);
          break;

      case 0xDB:            /* in port8 */
          cpu_cycles = 10;
          this.set_a(this.readIo(this.next_pc_byte()));
          break;

      case 0xDE:            /* sbi data8 */
          cpu_cycles = 7;
          this.sub_im8(this.next_pc_byte(), this.cf);
          break;

      case 0xE3:            /* xthl */
          cpu_cycles = 18;
          w16 = this.memory_read_word(this.sp);
          this.memory_write_word(this.sp, this.hl());
          this.set_l(w16 & 0xff);
          this.set_h(w16 >> 8);
          break;

      case 0xE6:            /* ani data8 */
          cpu_cycles = 7;
          this.ana_im8(this.next_pc_byte());
          break;

      case 0xE9:            /* pchl */
          cpu_cycles = 5;
          this.pc = this.hl();
          break;

      case 0xEB:            /* xchg */
          cpu_cycles = 4;
          w8 = this.l();
          this.set_l(this.e());
          this.set_e(w8);
          w8 = this.h();
          this.set_h(this.d());
          this.set_d(w8);
          break;

      case 0xEE:            /* xri data8 */
          cpu_cycles = 7;
          this.xra_im8(this.next_pc_byte());
          break;

      // di/ei, 1111c011
      // c - 0 (di), 1 (ei)
      case 0xF3:            /* di */
      case 0xFB:            /* ei */
          cpu_cycles = 4;
          this.iff = (opcode & 0x08) != 0;
          //this.io.interrupt(this.iff);
          break;

      case 0xF6:            /* ori data8 */
          cpu_cycles = 7;
          this.ora_im8(this.next_pc_byte());
          break;

      case 0xF9:            /* sphl */
          cpu_cycles = 5;
          this.sp = this.hl();
          break;

      case 0xFE:            /* cpi data8 */
          cpu_cycles = 7;
          this.cmp_im8(this.next_pc_byte());
          break;
    }
    return cpu_cycles;
  }

  this.instruction = function() {
    return this.execute(this.next_pc_byte(1));
  }

  this.jump = function(addr) {
    this.pc = addr & 0xffff;
  }
}
