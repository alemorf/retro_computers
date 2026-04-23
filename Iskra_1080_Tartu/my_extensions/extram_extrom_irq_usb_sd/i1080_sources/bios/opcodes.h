#pragma once

static const int OPCODE_NOP         = 0x00;
static const int OPCODE_LD_DE_CONST = 0x11;
static const int OPCODE_LD_A_CONST  = 0x3E;
static const int OPCODE_LD_H_A      = 0x67;
static const int OPCODE_LD_A_D      = 0x7A;
static const int OPCODE_LD_A_H      = 0x7C;
static const int OPCODE_XOR_A       = 0xAF;
static const int OPCODE_XOR_B       = 0xA8;
static const int OPCODE_JP          = 0xC3;
static const int OPCODE_RET         = 0xC9;
static const int OPCODE_SUB_CONST   = 0xD6;
static const int OPCODE_AND_CONST   = 0xE6;
static const int OPCODE_OR_CONST    = 0xF6;
static const int OPCODE_OUT         = 0xD3;
static const int OPCODE_JMP         = 0xC3;
