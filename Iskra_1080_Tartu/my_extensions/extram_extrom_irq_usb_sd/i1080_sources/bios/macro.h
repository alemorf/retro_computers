#pragma once

#define SET_HL_A_PLUS_CONST(CONST) { l = (a += (CONST)); AddCarry(a, (CONST) >> 8); h = (a -= l); }

#define ADD_HL_A { l = (a += l); AddCarry(a, h); h = (a -= l); }
