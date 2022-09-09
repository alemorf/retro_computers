#ifndef MHMT_PACK_H
#define MHMT_PACK_H

#include "mhmt-types.h"
#include "mhmt-lz.h"


//#define MAX_CODES_SIZE 3860 // max num of codes is 3857, plus stopcode, plus some extra bytes
#define MAX_CODES_SIZE 65540

// this structure exists in array for each input byte and used to build optimal code chain
struct packinfo
{
	struct lzcode code; // code of jumping here from previous position
	ULONG price; // bitprice (bitlength) of the best chain of lzcodes going up to this point:
	             // initialized as 0xFFFFFFFF (maximum price)
	ULONG _just_a_filler_; // to make structure 8 bytes long (true for 32bit machines)
};





ULONG pack(void);




#endif

