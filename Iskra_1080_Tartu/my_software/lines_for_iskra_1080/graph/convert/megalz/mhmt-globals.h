#ifndef MHMT_GLOBALS_H

#define MHMT_GLOBALS_H


#include <stdio.h>
#include <stdint.h>
#include "mhmt-types.h"

//#define DBG


// packer/depacker type constants, used in struct global
#define PK_MLZ  1

// definition of a global configuration/working structure:
// holding parsed commandline options, file sizes/descriptors,
// allocated memory arrays etc.
struct globals
{
    ULONG packtype; // packer/depacker type: one of PK_* constants

    ULONG greedy; // zero if no greedy mode coding (optimal coding), non-zero if greedy mode

	ULONG mode; // zero if packing, non-zero if depacking

	ULONG wordbit; // zero if bitstream is spread in 8bit (one-byte) chunks across bytestream,
	               // non-zero if chunks are 16bit (two-byte).

	ULONG bigend; // zero if 16bit bitstream chunks are little-endian, non-zero if big-endian:
	              // for 16 consecutive bits abcdefghijklmnop, big-endian will be
	              // consecutive bytes [abcdefgh],[ijklmnop], little-endian [ijklmnop],[abcdefgh]

	ULONG fullbits; // nonzero if 'full bits', i.e. new bitword in depacker fetched after last bit consumed
	                // zero if 'empty bits', new bitword fetched when bit is needed but no ones left

	ULONG maxwin; // maximum window (or lookback), positive number, which is one of:
	             // 256,512,1024,2048,4096,4352,8192,16384,32768 or 65536

	ULONG prebin; // nonzero if pre-binary file is specified in arguments


//	char * fname_in;
//	char * fname_out;
//	char * fname_prebin; // filename of prebin file
//
//	FILE * file_in;
//	FILE * file_out;
//	FILE * file_prebin;

    const UBYTE * indata;     // to use in normal depacking process -- begins from input file data
    const UBYTE * indata_raw; // to pre-parse prebin file or to free() array -- begins from prebin file if any or from input file (if no prebin)

	ULONG inlen;

	ULONG prelen;

    uint8_t output[65536];
    size_t output_pos;
};


extern struct globals wrk;



void init_globals(void);
void free_globals(void);

int mhmt_main(int argc, const char *argv[]);


#endif

