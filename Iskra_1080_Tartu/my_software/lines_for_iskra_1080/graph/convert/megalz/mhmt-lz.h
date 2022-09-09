#ifndef MHMT_LZ_H
#define MHMT_LZ_H

#include "mhmt-types.h"


// variety of LZ codes to support is:
//
// copybytes code, with lengths 1,12,14,16,...,42
// 1-byte match looking back -1..-8
// 2-byte up to -768 bytes back (-2176 for zx7)
// 3-byte insert-in-the-middle match: byte from (offset), insertet byte, byte from (offset+2), -1..-79
// 3-3839-byte matches up to -65536 bytes back
//
// we code it as follows:
//
// copybytes: length = +(number of bytes)
//            disp   = 0
// ordinary match: length = +(number of bytes in match)
//                 disp   = negative displacement (-1..-65536 atm)
// insert-in-the-middle match: length = -3 (only 3-byte match)
//                             disp   = -1..-79 (atm)
// end of codes list: length = 0 <= check it!
//                    disp   = 0



struct lzcode
{
	LONG length;
	LONG disp;
};



void make_lz_codes(OFFSET position, ULONG actual_len, UBYTE * hash, struct lzcode * codes);

ULONG get_lz_price_megalz(OFFSET position, struct lzcode * lzcode);
ULONG get_lz_price_hrum  (OFFSET position, struct lzcode * lzcode);
ULONG get_lz_price_hrust (OFFSET position, struct lzcode * lzcode);
ULONG get_lz_price_zx7   (OFFSET position, struct lzcode * lzcode);




#endif

