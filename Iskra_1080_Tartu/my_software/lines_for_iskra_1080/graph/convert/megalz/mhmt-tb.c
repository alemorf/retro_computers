#include <stdio.h>
#include <stdlib.h>

#include "mhmt-types.h"
#include "mhmt-globals.h"
#include "mhmt-tb.h"

// entry for twobyters search and add
struct tb_chain * tb_entry[65536];

struct tb_chain * tb_free; // linked list of freed tb_chain entries - NULL at the beginning

struct tb_bunch * tb_bunches; // all allocated bunches as linked list




void init_tb(void)
{
	ULONG i;

	tb_free=NULL;    // init linked list of free tb_chain elements
	tb_bunches=NULL; // no bunches already allocated

	for(i=0;i<65536;i++) // init array of 2-byte match pointers
	{
		tb_entry[i]=NULL;
	}
}


void free_tb(void)
{
	// free all allocated bunches

	struct tb_bunch * tbtmp;

	while( tb_bunches )
	{
		tbtmp=tb_bunches;
		tb_bunches=tb_bunches->next;
		free( tbtmp );
	}
}

// addw new twobyter:
// index=(prev<<8)+curr - index into tb_entry,
// position - position in input file for 'curr' byte
// returns zero if any error (cant allocate mem), otherwise 1
ULONG add_tb(UWORD index, OFFSET position)
{
	struct tb_chain * newtb;

	newtb=get_free_tb();
	if( !newtb )
	{ // no free elements

		if( (OFFSET)(position+wrk.prelen) > (OFFSET)wrk.maxwin ) // if there could be enough tbs to try to flush
		{
			// try to flush current chain
			cutoff_tb_chain(index,position);
		}

		newtb=get_free_tb();
		if( !newtb )
		{ // nothing free - allocate new bunch
			if( !add_bunch_of_tb() )
			{
				return 0;
			}

			newtb=get_free_tb(); // here is no chance to fail!... hopefully...
		}

	}



	newtb->pos=position-1; // points to the first byte of given two bytes
	newtb->next=tb_entry[index];
	tb_entry[index]=newtb;


	return 1;
}


// shorten given twobyter chain to have only actual (<wrk.maxwin old) elements, giving some free elements to reuse
void cutoff_tb_chain(UWORD index,OFFSET position)
{
	struct tb_chain * curr, * prev;


	curr=tb_entry[index];
	if( !curr ) return; // if nothing to remove


	// see if we should delete some elements after first element in the given chain
	prev=curr;
	curr=curr->next;

	while( curr )
	{
		if( (position-(curr->pos)) > (OFFSET)wrk.maxwin ) // found some old element: delete rest of chain along with it
		{
			// find end of chain
			while( curr->next )
			{
				curr = curr->next;
			}

			// now curr - last chain element, prev->next - beginning of orphaned chain
			// add orphaned chain to free list
			curr->next = tb_free;
			tb_free = prev->next;

			prev->next = NULL; // cut off chain

			break;
		}
		else
		{
			prev=curr;
			curr=curr->next;
		}
	}

	// delete first (entry) element in chain if needed (in this case, all subsequent els are already deleted)
	curr=tb_entry[index];
	if( (position-(curr->pos)) > (OFFSET)wrk.maxwin )
	{
		tb_entry[index] = NULL;

		curr->next=tb_free; // element goes to free list
		tb_free=curr;
	}
}


// adds new bunch of TBs when needed
// zero - error
ULONG add_bunch_of_tb(void)
{
	ULONG i;
	struct tb_bunch * newbunch;

	// alloc new bunch
	newbunch=(struct tb_bunch *)malloc( sizeof(struct tb_bunch) );
	if( !newbunch ) return 0;

	// link every twobyter into one list
	for(i=0;i<(BUNCHSIZE-1);i++)
	{
		newbunch->bunch[i].next=&(newbunch->bunch[i+1]);
	}

	// add this list to the free list
	newbunch->bunch[BUNCHSIZE-1].next=tb_free;
	tb_free=&(newbunch->bunch[0]);

	// add bunch to bunches list
	newbunch->next=tb_bunches;
	tb_bunches=newbunch;

	return 1;
}


// find free tb, if any, otherwise NULL
struct tb_chain * get_free_tb(void)
{
	struct tb_chain * newtb;

	if( tb_free )
	{
		newtb=tb_free;
		tb_free=tb_free->next;

		return newtb;
	}
	else
	{
		return NULL;
	}
}

