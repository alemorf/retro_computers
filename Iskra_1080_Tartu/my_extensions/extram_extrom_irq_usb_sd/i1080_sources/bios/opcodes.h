#pragma once

const int OPCODE_NOP         = 0x00;
const int OPCODE_LD_DE_CONST = 0x11;
const int OPCODE_LD_A_CONST  = 0x3E;
const int OPCODE_LD_H_A      = 0x67;
const int OPCODE_LD_A_D      = 0x7A;
const int OPCODE_LD_A_H      = 0x7C;
const int OPCODE_XOR_B       = 0xA8;
const int OPCODE_JP          = 0xC3;
const int OPCODE_RET         = 0xC9;
const int OPCODE_SUB_CONST   = 0xD6;
const int OPCODE_AND_CONST   = 0xE6;
const int OPCODE_OR_CONST    = 0xF6;

