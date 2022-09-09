#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mhmt-types.h"

#include "mhmt-lz.h"
#include "mhmt-tb.h"
#include "mhmt-globals.h"



// Universal search function
//
void make_lz_codes(OFFSET position, ULONG actual_len, UBYTE * hash, struct lzcode * codes)
{
	OFFSET i;
	ULONG codepos;
	ULONG codelen;
	ULONG was_match;
	UBYTE curr_byte,next_byte;
	struct tb_chain * curr_tb;
	UWORD index;
	ULONG max_lookback,max_length,max_tbdisp;

	// copy-byte code is always present
	codes[0].length = 1;
	codes[0].disp   = 0;

	// start more filling of codes[] from that position
	codepos = 1;







	curr_byte=wrk.indata[position];



    // check for one-byter (-1..-8)
    //
    i = (position > (8LL-wrk.prelen) ) ? position-8 : (0LL-wrk.prelen);
    do
    {
        if( wrk.indata[i] == curr_byte )
        {
            codes[codepos].length = 1;
            codes[codepos].disp   = -(LONG)(position-i);
            codepos++;
            break;
        }
    } while( (++i)<position );

    max_lookback = (wrk.maxwin<4352) ? wrk.maxwin : 4352;
    max_length = 255;
    max_tbdisp = 256;

	// check for two-byter (-1..-max_tbdisp)
	//
	curr_tb = NULL;
	//
	if( position<(OFFSET)(actual_len-1) ) // don't try two-byter if we are at the byte before last one
	{
		next_byte = wrk.indata[position+1];
		index=(curr_byte<<8) + next_byte;
		curr_tb = tb_entry[index];

		// there are two-byters!
		if( curr_tb )
		{
			if( ((position-curr_tb->pos)<=(OFFSET)max_tbdisp) && ((position-curr_tb->pos)<=(OFFSET)max_lookback) )
			{
				codes[codepos].length = 2;
				codes[codepos].disp   = -(LONG)(position - curr_tb->pos);
				codepos++;
			}
		}
	}


	// at last, check for lengths=3..max_length up to max_lookback 
	if(  curr_tb  &&  ( (position-curr_tb->pos)<=(OFFSET)max_lookback )  &&  ( position<(OFFSET)(actual_len-2) )  ) // if we can proceed at all
	{
		was_match = 1; // there was match at codelen-1

		for( codelen=3; ( codelen<=max_length )&&( position<(OFFSET)(actual_len-codelen+1) ); /*nothing*/ )
		{
			if( was_match ) // for codelen-1
			{
				// codelen-1 bytes are matched, compare one more byte
				if( wrk.indata[position+codelen-1] == wrk.indata[curr_tb->pos+codelen-1] )
				{
					// add code to the table
					codes[codepos].length = codelen;
					codes[codepos].disp   = -(LONG)(position - curr_tb->pos);
					codepos++;

					codelen++; // next time do comparision of greater size
				}
				else // last bytes do not match
				{

MATCH_FAIL: // entrance for failed matches here: used 3-fold so we set "goto" here

					// go for older twobyter
					curr_tb = curr_tb->next;

					// no more twobyters or they are too far - stop search at all
					if( !curr_tb ) break;
					if( (position - curr_tb->pos)>(OFFSET)max_lookback ) break;

					// mark there was no matches
					was_match = 0;
				}
			}
			else // there were no matches for previous codelen
			{
				// next twobyter is already taken, but no comparision is done for codelen bytes
				// first we check if we need to do such comparision at all by seeing to the hashes of the ends of strings
				if( hash[position+codelen-1] == hash[curr_tb->pos+codelen-1] )
				{	// hashes match, so try matching complete string
					if( !memcmp( &wrk.indata[position], &wrk.indata[curr_tb->pos], codelen ) )
					{
						was_match = 1;
						codes[codepos].length = codelen;
						codes[codepos].disp   = -(LONG)(position - curr_tb->pos);
						codepos++;

						codelen++;
					}
					else
						// no match of whole string
						goto MATCH_FAIL;
				}
				else
					// no match of hashes
					goto MATCH_FAIL;
			}
		}
	}

	// here we assume to have found all possible matches. check for codes[] table overflow:
	// there could be matches for length 1..3839, and there is copy-1-byte, 16 copymanybyters, 1 insertion match, total 3857 entries for hrust, 256 for megalz & hrum
	// 65536 for zx7
    if(   codepos > 256   ) // this should not happen!
	{
		printf("mhmt-lz.c:make_lz_codes() encountered too many entries in codes[] table. Fatal error.\n");
		exit(1);
	}

	// mark end-of-records in codes[]
	codes[codepos].length = 0;
	codes[codepos].disp   = 0;
}







// returns price in bits or zero if error
//										
ULONG get_lz_price_megalz(OFFSET position, struct lzcode * lzcode)
{
	ULONG varbits,varlen;
	LONG length,disp;

	length = lzcode->length;
	disp   = lzcode->disp;

	if( length==1 )
	{
		if( disp==0 )
			return 9;
		else if( (-8)<=disp && disp<=(-1) )
			return 6;
		else
			goto INVALID_CODE_MEGALZ;
	}
	else if( length==2 )
	{
		if( (-256)<=disp && disp<=(-1) )
			return 11;
		else
			goto INVALID_CODE_MEGALZ;
	}
	else if( length==3 )
	{
		if( (-256)<=disp && disp<=(-1) )
			return 12;
		else if( (-4352)<=disp && disp<(-256) )
			return 16;
		else
			goto INVALID_CODE_MEGALZ;
	}
	else if( 4<=length && length<=255 )
	{
		varlen = 0;
		varbits = (length-2)>>1;
		while( varbits )
		{
			varbits >>= 1;
			varlen+=2;
		}

		if( (-256)<=disp && disp<=(-1) )
			varlen += 9;
		else if( (-4352)<=disp && disp<(-256) )
			varlen += 13;
		else
			goto INVALID_CODE_MEGALZ;

		return varlen+3;
	}
	else
	{
INVALID_CODE_MEGALZ:
		printf("mhmt-lz.c:get_lz_price_megalz(): Found invalid code length=%d, displacement=%d\n",length, disp);
		return 0;
	}
}
