#ifndef MHMT_HASH_H
#define MHMT_HASH_H

#include "mhmt-types.h"


UBYTE * build_hash(const UBYTE * data, ULONG length, ULONG prebin_len);
void destroy_hash(UBYTE * hash, ULONG prebin_len);


#endif

