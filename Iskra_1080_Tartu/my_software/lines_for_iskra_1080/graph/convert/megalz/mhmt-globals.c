#include <stdlib.h>
#include <string.h>
#include "mhmt-globals.h"


struct globals wrk;

// init wrk container
void init_globals(void)
{
    wrk.packtype = PK_MLZ;
    wrk.greedy   = 0;
	wrk.mode     = 0;
	wrk.wordbit  = 0;
	wrk.bigend   = 0;
	wrk.fullbits = 0;
	wrk.maxwin   = 4352;
	wrk.prebin   = 0;

//	wrk.fname_in     = NULL;
//	wrk.fname_out    = NULL;
//	wrk.fname_prebin = NULL;
//
//	wrk.file_in     = NULL;
//	wrk.file_out    = NULL;
//	wrk.file_prebin = NULL;

	wrk.indata     = NULL;
	wrk.indata_raw = NULL;
	
	wrk.inlen  = 0;

	wrk.prelen  = 0;

    (void)memset(wrk.output, 0, sizeof(wrk.output));
    wrk.output_pos = 0;
}



// free all stuff from wrk container
void free_globals(void)
{
    //if( wrk.indata_raw ) free( wrk.indata_raw );

    //if( wrk.file_out    ) fclose( wrk.file_out    );
    //if( wrk.file_in     ) fclose( wrk.file_in     );
    //if( wrk.file_prebin ) fclose( wrk.file_prebin );
    //
    //if( wrk.fname_out    ) free( wrk.fname_out    );
    //if( wrk.fname_in     ) free( wrk.fname_in     );
    //if( wrk.fname_prebin ) free( wrk.fname_prebin );
}

