#include <stdio.h>
#include <stdlib.h>

#include "mhmt-types.h"
#include "mhmt-globals.h"
#include "mhmt-pack.h"
#include "mhmt-hash.h"
#include "mhmt-tb.h"
#include "mhmt-lz.h"
#include "mhmt-optimal.h"
#include "mhmt-emit.h"


// entry function to pack data
// returns zero if any error
ULONG pack(void)
{


	ULONG (*get_lz_price)(OFFSET position, struct lzcode * lzcode) = NULL; // generates correct bitlen (price) of code

	ULONG (*emit)(struct optchain * optch, ULONG actual_len) = NULL; // emits lzcode to the output bit/byte stream


	ULONG success=1;


	ULONG actual_len; // actual length of packing (to account for ZX headers containing last unpacked bytes)

	UBYTE * hash;

	struct optchain * optch=NULL;

	static struct lzcode codes[MAX_CODES_SIZE]; // generate codes here; static to ensure it's not on the stack


	UBYTE curr_byte, last_byte;
	UWORD index;
	OFFSET position;


	// some preparations
	//
    get_lz_price  = &get_lz_price_megalz;
    emit          = &emit_megalz;

	actual_len = wrk.inlen;

        // initializations and preparations
	init_tb();

	hash = build_hash(wrk.indata, actual_len, wrk.prelen);
	if( !hash )
	{
		printf("mhmt-pack.c:pack() - build_hash() failed!\n");
		success = 0;
	}

	if( success )
	{
		optch = make_optch(actual_len);
		if( !optch )
		{
			printf("mhmt-pack.c:pack() - can't make optchain array!\n");
			success = 0;
		}
	}


	// go packing!
	if( success )
	{
		// fill TBs with prebinary date
		if( wrk.prebin )
		{
			curr_byte=wrk.indata[0LL-wrk.prelen];
			//
			for(position=(1LL-wrk.prelen);position<=0;position++)
			{
				last_byte = curr_byte;
				curr_byte = wrk.indata[position];

				index = (last_byte<<8) + curr_byte;
				
				if( !add_tb(index,position) )
				{
					printf("mhmt-pack.c:pack() - add_tb() failed!\n");
					success = 0;
					goto ERROR;
				}
			}
		}

		if( !wrk.greedy ) // default optimal coding
		{
			// go generating lzcodes byte-by-byte
			//
			curr_byte = wrk.indata[0];
			//
			for(position=1;position<(OFFSET)actual_len;position++)
			{
				last_byte = curr_byte;
				curr_byte = wrk.indata[position];

				// add current two-byter to the chains
				index = (last_byte<<8) + curr_byte;
				if( !add_tb(index,position) )
				{
					printf("mhmt-pack.c:pack() - add_tb() failed!\n");
					success = 0;
					goto ERROR;
				}

				// search lzcodes for given position
				make_lz_codes(position, actual_len, hash, codes);

				// update optimal chain with lzcodes
				update_optch(position, codes, get_lz_price, optch);
			}


			// all input bytes scanned, chain built, so now reverse it (prepare for scanning in output generation part)
			reverse_optch(optch, actual_len);
		}
		else // greedy coding
		{
			printf("mhmt-pack.c:pack() - greedy coding not supported!\n");
			success = 0;
		}

		// data built, now emit packed file
		success = success && (*emit)(optch, actual_len);
	}





ERROR:
	free_optch(optch);

	destroy_hash(hash, wrk.prelen);

	return success;
}
