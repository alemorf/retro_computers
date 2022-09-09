#include <stdio.h>

#include "mhmt-types.h"
#include "mhmt-globals.h"
#include "mhmt-emit.h"
#include "mhmt-lz.h"
#include "mhmt-optimal.h"
#include <string.h>

size_t mhmt_fwrite(const void* data, size_t data_size) {
    size_t result = 0;
    if (wrk.output_pos + data_size <= sizeof(wrk.output)) {
        (void)memcpy(&wrk.output[wrk.output_pos], data, data_size);
        wrk.output_pos += data_size;
        result = data_size;
    }
    return result;
}

// actually generate output file from optimal chain - MegaLZ version
ULONG emit_megalz(struct optchain * optch, ULONG actual_len)
{
	ULONG position;
	LONG length;
	LONG disp;

	LONG max_disp; // maximum encountered displacement


	ULONG varbits,varlen;

	ULONG success = 1;

	max_disp = 0;


	// some checks
	if( !optch )
	{
		printf("mhmt-emit.c:emit_megalz() - NULL passed!\n");
		return 0;
	}

	// initialize
	success = success && emit_file(NULL, EMIT_FILE_INIT);

	success = success && emit_byte(0, EMIT_BYTE_INIT);

	success = success && emit_bits(0, EMIT_BITS_INIT);


	// copy first byte as-is
	success = success && emit_file( wrk.indata, 1);

	// go emitting codes
	position = 1;

	while( (position<actual_len) && success )
	{
		length = optch[position].code.length;
		disp   = optch[position].code.disp;

		if( length==0 )
		{
			printf("mhmt-emit.c:emit_megalz() - encountered stop-code in optimal chain before emitting all data!\n");
			return 0;
		}
		else if( length==1 ) // either copy-byte or len=1 code
		{
			if( disp==0 ) // copy-byte (%1<byte>)
			{
				success = success && emit_bits( 0x80000000, 1 );
				success = success && emit_byte( wrk.indata[position], EMIT_BYTE_ADD );
			}
			else if( (-8)<=disp && disp<=(-1) ) // len=1, disp=-1..-8 (%000abc)
			{
				success = success && emit_bits( 0x00000000,   3 );
				success = success && emit_bits( disp<<(32-3), 3 );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_MEGALZ;
		}
		else if( length==2 )
		{
			if( (-256)<=disp && disp<=(-1) ) // %001<byte>
			{
				success = success && emit_bits( 0x20000000, 3 );
				success = success && emit_byte( (UBYTE)(0x00FF & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_MEGALZ;
		}
		else if( 3<=length && length<=255 )
		{
			// length coding
			if( length==3 ) // %010
			{
				success = success && emit_bits( 0x40000000, 3 );
			}
			else // length==4..255, %011
			{
				success = success && emit_bits( 0x60000000, 3 );

				// calculate size of variable bits
				varlen = 0;
				varbits = (length-2)>>1;
				while( varbits )
				{
					varbits >>= 1;
					varlen++;
				}

				varbits = length-2-(1<<varlen); // prepare length coding

				success = success && emit_bits(       1<<(32-varlen), varlen );
				success = success && emit_bits( varbits<<(32-varlen), varlen );
			}

			// displacement coding
			if( (-256)<=disp && disp<=(-1) )
			{
				success = success && emit_bits( 0, 1 );
				success = success && emit_byte( (UBYTE)(0x00ff & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else if( (-4352)<=disp && disp<(-256) )
			{
				success = success && emit_bits( 0x80000000, 1 );

				success = success && emit_bits( (0x0F00&(disp+0x0100))<<20, 4 );

				success = success && emit_byte( (UBYTE)(0x00FF & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_MEGALZ;
		}
		else
		{
INVALID_CODE_MEGALZ:
			printf("mhmt-emit.c:emit_megalz() - invalid code: length=%d, displacement=%d\n",length,disp);
			return 0;
		}

		position += length;
	}

	// stop-code
	success = success && emit_bits( 0x60100000, 12 );
	success = success && emit_bits( 0, EMIT_BITS_FINISH ); // this also flushes emit_byte()

	success = success && emit_file( NULL, EMIT_FILE_FINISH );

//	if( success )
//		printf("Maximum displacement actually used is %d.\n",-max_disp);

	return success;
}
















// actually generate output file from optimal chain - hrum version
ULONG emit_hrum(struct optchain * optch, ULONG actual_len)
{
	ULONG position;
	LONG length;
	LONG disp;

	LONG max_disp; // maximum encountered displacement


	ULONG varbits,varlen;

	ULONG success = 1;

	max_disp = 0;


	// some checks
	if( !optch )
	{
		printf("mhmt-emit.c:emit_hrum() - NULL passed!\n");
		return 0;
	}

	// initialize
	success = success && emit_file(NULL, EMIT_FILE_INIT);

	success = success && emit_byte(0, EMIT_BYTE_INIT);

	success = success && emit_bits(0, EMIT_BITS_INIT);


	// schedule first byte to be placed just after first bitstream word
	success = success && emit_byte( wrk.indata[0], EMIT_BYTE_ADD);

	// go emitting codes
	position = 1;

	while( (position<actual_len) && success )
	{
		length = optch[position].code.length;
		disp   = optch[position].code.disp;

		if( length==0 )
		{
			printf("mhmt-emit.c:emit_hrum() - encountered stop-code in optimal chain before emitting all data!\n");
			return 0;
		}
		else if( length==1 ) // either copy-byte or len=1 code
		{
			if( disp==0 ) // copy-byte (%1<byte>)
			{
				success = success && emit_bits( 0x80000000, 1 );
				success = success && emit_byte( wrk.indata[position], EMIT_BYTE_ADD );
			}
			else if( (-8)<=disp && disp<=(-1) ) // len=1, disp=-1..-8 (%000abc)
			{
				success = success && emit_bits( 0x00000000,   3 );
				success = success && emit_bits( disp<<(32-3), 3 );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_HRUM;
		}
		else if( length==2 )
		{
			if( (-256)<=disp && disp<=(-1) ) // %001<byte>
			{
				success = success && emit_bits( 0x20000000, 3 );
				success = success && emit_byte( (UBYTE)(0x00FF & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_HRUM;
		}
		else if( 3<=length && length<=255 )
		{
			// length coding
			if( length==3 )
			{
				success = success && emit_bits( 0x40000000, 3 );
			}
			else if( length<=15 )
			{
				varlen=2;

				varbits = (length % 3)<<30; // low 2 bits (except for length==15)
				if( length==15 ) varbits = 0xC0000000;

				if( length>=6 ) { varbits = 0xC0000000 | (varbits>>2); varlen += 2; }
				if( length>=9 ) { varbits = 0xC0000000 | (varbits>>2); varlen += 2; }
				if( length>=12) { varbits = 0xC0000000 | (varbits>>2); varlen += 2; }

				success = success && emit_bits( 0x60000000, 3 );
				success = success && emit_bits( varbits, varlen );
			}
			else // 15<length<=255: %01100<len>
			{
				success = success && emit_bits( 0x60000000, 5 );
				success = success && emit_byte( (UBYTE)(length&0x00FF), EMIT_BYTE_ADD );
			}

			// displacement coding
			if( (-256)<=disp && disp<=(-1) ) // %0<disp>
			{
				success = success && emit_bits( 0x00000000, 1 );
				success = success && emit_byte( (UBYTE)(0x00FF & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else if( (-4096)<=disp && disp<(-256) ) //%1abcd<disp>
			{
				success = success && emit_bits( 0x80000000, 1 );
				success = success && emit_bits( (0x0F00&disp)<<20, 4 );
				success = success && emit_byte( (UBYTE)(0x00FF & disp), EMIT_BYTE_ADD );

				if( max_disp > disp ) max_disp = disp;
			}
			else
				goto INVALID_CODE_HRUM;
		}
		else
		{
INVALID_CODE_HRUM:
			printf("mhmt-emit.c:emit_hrum() - invalid code: length=%d, displacement=%d\n",length,disp);
			return 0;
		}

		position += length;
	}

	// stop-code: %01100<0>
	success = success && emit_bits( 0x60000000, 5 );
	success = success && emit_byte( 0x00, EMIT_BYTE_ADD );

	success = success && emit_bits( 0, EMIT_BITS_FINISH ); // this also flushes emit_byte()
	success = success && emit_file( NULL, EMIT_FILE_FINISH );

	if( success )
		printf("Maximum displacement actually used is %d.\n",-max_disp);

	return success;
}















// emit bytes to the output buffer and flush to file when needed
// 'operation' defines what to do as described in *.h
// 'byte' is emitted only when length >=1,
// When length=EMIT_FILE_FINISH (0), flushes tail to file
// When length=EMIT_FILE_INIT (-1), initializes.
//
// returns zero in case of any problems (fails to write buffer to file), otherwise non-zero
ULONG emit_file(const UBYTE * bytes, LONG length)
{
	static UBYTE buffer[EMIT_FILEBUF_SIZE];

	static ULONG position;


	if( length==EMIT_FILE_INIT )
	{
		position = 0;

		return 1;
	}
	else if( length>0 )
	{
		while( (position+length) >= EMIT_FILEBUF_SIZE ) // if we have to flush buffer
		{
			length -= (EMIT_FILEBUF_SIZE-position);

			while( position < EMIT_FILEBUF_SIZE ) // fill buffer to the end, if possible
			{
                                buffer[position++] = *(bytes++);
			}

            if( EMIT_FILEBUF_SIZE!=mhmt_fwrite(buffer, EMIT_FILEBUF_SIZE) )
			{
				printf("mhmt-emit.c:emit_file() can't write to file!\n");
				return 0;
			}

			position=0;
		}

		while( length-- ) // if something left that does not need flushing
		{
			buffer[position++] = *(bytes++);
		}

		return 1;
	}
	else if( length==EMIT_FILE_FINISH )
	{
		if( position>0 ) // do we have anything to flush?
		{
            if( position!=mhmt_fwrite(buffer, position) )
			{
				printf("mhmt-emit.c:emit_file() can't write to file!\n");
				return 0;
			}
		}

		return 1;
	}
	else
	{
		printf("mhmt-emit.c:emit_file() encountered invalid arguments!\n");
		return 0;
	}
}



// store emitted bytes in special buffer, because emitted bits go earlier than corresponding bytes.
// then, when bits are flushed to the file, bytes are flushed just after.
// returns zero if any problems. "operation" dictates what to do (see *.h)
ULONG emit_byte(UBYTE byte, ULONG operation)
{
	static UBYTE buffer[EMIT_BYTEBUF_SIZE];

	static ULONG in_pos, out_pos;

	ULONG success;


	switch( operation )
	{
	case EMIT_BYTE_INIT:

		in_pos  = 0;
		out_pos = 0;

		return 1;


	case EMIT_BYTE_ADD:

		#ifdef DBG
			printf("<%02x>",byte&0x00FF);
		#endif

		buffer[in_pos] = byte;

		in_pos = (in_pos+1) & (EMIT_BYTEBUF_SIZE-1);


		if( in_pos==out_pos ) // overflow!
		{
			printf("mhmt-emit.c:emit_byte() buffer overflow!\n");
			return 0;
		}

		return 1;


	case EMIT_BYTE_FLUSH:

		if( in_pos==out_pos ) // nothing to do?
			return 1;
		else if( in_pos>out_pos ) // no index wraparound
		{
			success = emit_file( &buffer[out_pos], in_pos-out_pos );
		}
		else // in_pos<out_pos - wraparound
		{
			success = emit_file( &buffer[out_pos], EMIT_BYTEBUF_SIZE-out_pos );

			if( in_pos )
				success = success && emit_file( &buffer[0], in_pos );
		}

		out_pos=in_pos;
		return success;

	default:
		printf("mhmt-emit.c:emit_byte() encountered invalid arguments!\n");
		return 0;
	}
}


// collects bits, emit to output stream when needed. accounts for word or byte mode, little-big endian, empty or full bits
// length is either positive number of bits or one of two special cases (see *.h)
//
ULONG emit_bits(ULONG msb_aligned_bits, LONG length)
{
	static ULONG bit_store;
	static ULONG bit_count;

	ULONG max_bits;

	ULONG success = 1;


	max_bits = wrk.wordbit ? 16 : 8;

	if( length==EMIT_BITS_INIT )
	{
		bit_store = 0;
		bit_count = 0;
		return 1;
	}
	else if( length==EMIT_BITS_FINISH )
	{
		if( bit_count ) // some bits to flush
		{
			while( (bit_count++)<max_bits )
				bit_store <<= 1;

			success = success && emit_bits_flush(bit_store);
		}

		success = success && emit_byte(0, EMIT_BYTE_FLUSH);

		return success;
	}
	else if( length>0 ) // add bits
	{
		do
		{
			if( !wrk.fullbits ) // empty bits - check for flushing before shiftin
			{
				if( bit_count==max_bits )
				{
					success = success && emit_bits_flush(bit_store);
					success = success && emit_byte(0, EMIT_BYTE_FLUSH);

					bit_count = 0;
				}
			}


//printf("%d",1&(msb_aligned_bits>>31));

			bit_store = (bit_store<<1) | ( 1 & (msb_aligned_bits>>31) );
			msb_aligned_bits <<= 1;
			bit_count++;

			if( wrk.fullbits ) // full bits - check for flushing after bit shiftin
			{
				if( bit_count==max_bits )
				{
					success = success && emit_bits_flush(bit_store);
					success = success && emit_byte(0, EMIT_BYTE_FLUSH);

					bit_count = 0;
				}
			}

		} while( --length );

		return success;
	}
	else
	{
		printf("mhmt-emit.c:emit_bits() encountered invalid arguments!\n");
		return 0;
	}
}

// flushes either word or byte from given bits
//
ULONG emit_bits_flush(ULONG bits)
{
	UBYTE store_byte;

	ULONG success = 1;

	if( wrk.wordbit ) // 16bits
	{
		if( wrk.bigend ) // big endian
		{
			store_byte = 0x00FF & (bits >> 8);
			success = success && emit_file( &store_byte, 1);

			store_byte = 0x00FF & bits;
			success = success && emit_file( &store_byte, 1);
		}
		else // little endian
		{
			store_byte = 0x00FF & bits;
			success = success && emit_file( &store_byte, 1);

			store_byte = 0x00FF & (bits >> 8);
			success = success && emit_file( &store_byte, 1);
		}
	}
	else // 8bits
	{
		store_byte = 0x00FF & bits;
		success = success && emit_file( &store_byte, 1);
	}

	return success;
}

