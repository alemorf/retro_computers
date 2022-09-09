#ifndef MHMT_TB_H
#define MHMT_TB_H

#include "mhmt-types.h"



extern struct tb_chain * tb_entry[];



// chained two-byter element: pos is position in input file
struct tb_chain
{
	OFFSET pos;
	struct tb_chain * next;
};




#define BUNCHSIZE 4096

struct tb_bunch
{
	struct tb_bunch * next;
	struct tb_chain bunch[BUNCHSIZE];
};




void init_tb(void);
void free_tb(void);
ULONG add_tb(UWORD index, OFFSET position);
void cutoff_tb_chain(UWORD index,OFFSET position);
ULONG add_bunch_of_tb(void);
struct tb_chain * get_free_tb(void);




#endif

