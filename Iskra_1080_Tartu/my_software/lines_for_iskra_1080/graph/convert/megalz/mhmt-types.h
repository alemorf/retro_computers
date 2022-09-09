#ifndef MHMT_TYPES_H

#define MHMT_TYPES_H


#ifdef _AMIGA
	#include <exec/types.h>
	typedef signed int OFFSET;
#else
	#include <sys/types.h>
	#define MHMT_OWNTYPES
#endif


#ifdef MHMT_OWNTYPES
typedef        signed char  BYTE;
typedef      unsigned char UBYTE;

typedef   signed short int  WORD;
typedef unsigned short int UWORD;

typedef         signed int  LONG;
typedef       unsigned int ULONG;

typedef off_t OFFSET; // this will be 32bit signed in 32bit systems and 64bit signed in 64bit linux, don't care of other 64bits yet...
#endif

#endif

