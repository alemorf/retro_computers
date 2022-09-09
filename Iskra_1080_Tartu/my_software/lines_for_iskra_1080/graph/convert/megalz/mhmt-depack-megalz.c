// this is not a code to be separately compiled!
// instead, it is included in mhmt-depack.c several times and depends on existing at include moment #define's to generate some compiling code
//
//                   // example defines:
//#define DPK_CHECK  // check input stream for consistency
//#define DPK_DEPACK // do depacking
//#define DPK_REPERR // report errors via printf
{
	ULONG check;
	ULONG byte,bits,bitlen;
	LONG disp;
	ULONG length;

	ULONG stop;


	ULONG success = 1;





	// rewind input stream
	//
	check = depack_getbyte(DEPACK_GETBYTE_REWIND);
#ifdef DPK_CHECK
	if( 0xFFFFFFFF == check )
	{
 #ifdef DPK_REPERR
		printf("mhmt-depack-megalz.c:{} - Can't rewind input stream!\n");
 #endif
		return 0;
	}
#endif


	// first byte of input stream goes to the output unchanged
	//
	byte = depack_getbyte(DEPACK_GETBYTE_NEXT);
#ifdef DPK_CHECK
	if( 0xFFFFFFFF == byte )
	{
NO_BYTE:
 #ifdef DPK_REPERR
		printf("mhmt-depack-megalz.c:{} - Can't get byte from input stream!\n");
 #endif
		return 0;
	}
#endif

#ifdef DPK_DEPACK
	success = success && depack_outbyte( (UBYTE)(0x00FF&byte), DEPACK_OUTBYTE_ADD );
#endif


#ifdef DPK_CHECK
 #ifdef DPK_REPERR
 #endif
#endif
	// next is byte to the bitstream
	//
	check = depack_getbits(8,DEPACK_GETBITS_FORCE);
#ifdef DPK_CHECK
	if( 0xFFFFFFFF == check )
	{
NO_BITS:
 #ifdef DPK_REPERR
		printf("mhmt-depack-megalz.c:{} - Can't get bits from input stream!\n");
 #endif
		return 0;
	}
#endif



	// now normal depacking loop
	//
	stop = 0;
	while( (!stop) && success )
 	{
		bits = depack_getbits(1,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
		if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif

		if( 1&bits ) // %1<byte>
		{
			byte = depack_getbyte(DEPACK_GETBYTE_NEXT);
#ifdef DPK_CHECK
			if( 0xFFFFFFFF == byte ) goto NO_BYTE;
#endif

#ifdef DPK_DEPACK
			success = success && depack_outbyte( (UBYTE)(0x00FF&byte), DEPACK_OUTBYTE_ADD );
#endif
		}
		else // %0xx
		{
			bits = depack_getbits(2,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
			if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif

			switch( 0x03 & bits )
			{
			case 0x00: // %000xxx

				bits = depack_getbits(3,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
				if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif

				disp = (-8) | (bits&0x07); // FFFFFFF8..FFFFFFFF (-8..-1)
#ifdef DPK_CHECK
				if( (ULONG)(-disp) > wrk.maxwin )
				{
WRONG_DISP:
 #ifdef DPK_REPERR
					printf("mhmt-depack-megalz.c:{} - Wrong lookback displacement of %d, greater than maxwin\n",(-disp) );
 #endif
					return 0;
				}
#endif

#ifdef DPK_DEPACK
				success = success && depack_repeat(disp,1);
#endif
				break;


			case 0x01: // %001

				byte = depack_getbyte(DEPACK_GETBYTE_NEXT);
#ifdef DPK_CHECK
				if( 0xFFFFFFFF == byte ) goto NO_BYTE;
#endif

				disp = (-256) | (0x00FF&byte); // -1..-256
#ifdef DPK_CHECK
				if( (ULONG)(-disp) > wrk.maxwin ) goto WRONG_DISP;
#endif

#ifdef DPK_DEPACK
				success = success && depack_repeat(disp,2);
#endif
				break;


			case 0x02: // %010

				length = 3;
FAR_DISP:
				bits = depack_getbits(1,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
				if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif
				if( !(1&bits) ) // -1..-256
				{
					byte = depack_getbyte(DEPACK_GETBYTE_NEXT);
#ifdef DPK_CHECK
					if( 0xFFFFFFFF == byte ) goto NO_BYTE;
#endif
					disp = (-256) | (0x00FF&byte); // -1..-256
#ifdef DPK_CHECK
					if( (ULONG)(-disp) > wrk.maxwin ) goto WRONG_DISP;
#endif

#ifdef DPK_DEPACK
					success = success && depack_repeat(disp,length);
#endif
				}
				else // -257..-4352
				{
					bits = depack_getbits(4,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
					if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif
					byte = depack_getbyte(DEPACK_GETBYTE_NEXT);
#ifdef DPK_CHECK
					if( 0xFFFFFFFF == byte ) goto NO_BYTE;
#endif
					disp = ( ((-16)|(15&bits)) - 1 )*0x100 + byte;
#ifdef DPK_CHECK
					if( (ULONG)(-disp) > wrk.maxwin ) goto WRONG_DISP;
#endif

#ifdef DPK_DEPACK
					success = success && depack_repeat(disp,length);
#endif
				}

				break;


			case 0x03: // %011 - variable length

				bitlen = 0;
				do
				{
					bits = depack_getbits(1,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
					if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif
					bitlen++;

				} while ( !(1&bits) );

				if( bitlen==9 ) // happy final! WARNING: does not check whether there is remaining of input stream left unused!
				{
					stop = 1;
					break; // exit switch(){}
				}
#ifdef DPK_CHECK
				if( bitlen>7 )
				{
 #ifdef DPK_REPERR
					printf("mhmt-depack-megalz.c:{} - Wrong LZ code\n");
 #endif
					return 0;
				}
#endif
				bits = depack_getbits(bitlen,DEPACK_GETBITS_NEXT);
#ifdef DPK_CHECK
				if( 0xFFFFFFFF == bits ) goto NO_BITS;
#endif
				length = 2 + (1<<bitlen) + ( bits & ((1<<bitlen)-1) );
#ifdef DPK_CHECK
				if( length>255 )
				{
 #ifdef DPK_REPERR
					printf("mhmt-depack-megalz.c:{} - Wrong LZ code\n");
 #endif
					return 0;
				}
#endif
				goto FAR_DISP;

				break;
			}
		}

	}

	return success;
}
