#pragma once

#define SET_HL_A_PLUS_CONST(CONST) { l = (a += (CONST)); AddCarry(a, (CONST) >> 8); h = (a -= l); }
#define ADD_HL_A { l = (a += l); AddCarry(a, h); h = (a -= l); }
#define MEMCPY8(T, F, S) { hl = (T); de = (F); c = (S); do { *hl = a = *de; hl++; de++; } while(flag_nz(c--)); }


#define A_MUL_5(TMP) { TMP = a; a += a += a; a += TMP; }
