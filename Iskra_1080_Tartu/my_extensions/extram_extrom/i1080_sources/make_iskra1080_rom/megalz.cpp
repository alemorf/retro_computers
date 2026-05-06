/*
 * MegaLZ packer
 * (c) https://github.com/lvd2
 * Refactored (in progress) by Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "megalz.h"
#include <stdexcept>
#include <string.h>

typedef signed char BYTE;
typedef unsigned char UBYTE;
typedef signed short int WORD;
typedef unsigned short int UWORD;
typedef signed int LONG;
typedef unsigned int ULONG;
typedef off_t OFFSET;  // this will be 32bit signed in 32bit systems and 64bit signed in 64bit linux, don't care of
                       // other 64bits yet...

//---------------------------------------------------------------------------
// mhmt-globals.h
//---------------------------------------------------------------------------

//#define DBG

// definition of a global configuration/working structure:
// holding parsed commandline options, file sizes/descriptors,
// allocated memory arrays etc.
struct globals {
    ULONG fullbits;       // nonzero if 'full bits', i.e. new bitword in depacker fetched after last bit consumed
                          // zero if 'empty bits', new bitword fetched when bit is needed but no ones left
    ULONG maxwin;         // maximum window (or lookback), positive number, which is one of:
                          // 256,512,1024,2048,4096,4352,8192,16384,32768 or 65536
    ULONG prebin;         // nonzero if pre-binary file is specified in arguments
    const UBYTE *indata;  // to use in normal depacking process -- begins from input file data
    ULONG inlen;
    ULONG prelen;
    uint8_t output[65536];
    size_t output_pos;
};

static struct globals wrk;

//---------------------------------------------------------------------------
// mhmt-emit.h
//---------------------------------------------------------------------------

#define EMIT_FILEBUF_SIZE 4096 /* file buffer */
#define EMIT_BYTEBUF_SIZE 256  /* !! MUST BE 2^N !! */

ULONG emit_megalz(struct optchain *optch, ULONG actual_len);

#define EMIT_FILE_INIT (-1)
#define EMIT_FILE_FINISH (0)
// what should emit_file do: init channel, add bytes or finish (flush) channel to disk
//
ULONG emit_file(const UBYTE *bytes, LONG length);

#define EMIT_BITS_INIT (-1)
#define EMIT_BITS_FINISH (0)
// length>0 or one of two special cases
ULONG emit_bits(ULONG msb_aligned_bits, LONG length);
ULONG emit_bits_flush(ULONG bits);

enum { EMIT_BYTE_INIT, EMIT_BYTE_FLUSH, EMIT_BYTE_ADD };

ULONG emit_byte(UBYTE byte, ULONG operation);

//---------------------------------------------------------------------------
// mhmt-tb.h
//---------------------------------------------------------------------------

// chained two-byter element: pos is position in input file
struct tb_chain {
    OFFSET pos;
    struct tb_chain *next;
};

#define BUNCHSIZE 4096

struct tb_bunch {
    struct tb_bunch *next;
    struct tb_chain bunch[BUNCHSIZE];
};

static void init_tb(void);
static void free_tb(void);
ULONG add_tb(UWORD index, OFFSET position);
void cutoff_tb_chain(UWORD index, OFFSET position);
ULONG add_bunch_of_tb(void);
struct tb_chain *get_free_tb(void);

//---------------------------------------------------------------------------
// mhmt-hash.h
//---------------------------------------------------------------------------

UBYTE *build_hash(const UBYTE *data, ULONG length, ULONG prebin_len);
void destroy_hash(UBYTE *hash, ULONG prebin_len);

//---------------------------------------------------------------------------
// mhmt-lz.h
//---------------------------------------------------------------------------

// variety of LZ codes to support is:
//
// copybytes code, with lengths 1,12,14,16,...,42
// 1-byte match looking back -1..-8
// 2-byte up to -768 bytes back (-2176 for zx7)
// 3-byte insert-in-the-middle match: byte from (offset), insertet byte, byte from (offset+2), -1..-79
// 3-3839-byte matches up to -65536 bytes back
//
// we code it as follows:
//
// copybytes: length = +(number of bytes)
//            disp   = 0
// ordinary match: length = +(number of bytes in match)
//                 disp   = negative displacement (-1..-65536 atm)
// insert-in-the-middle match: length = -3 (only 3-byte match)
//                             disp   = -1..-79 (atm)
// end of codes list: length = 0 <= check it!
//                    disp   = 0

struct lzcode {
    LONG length;
    LONG disp;
};

void make_lz_codes(OFFSET position, ULONG actual_len, UBYTE *hash, struct lzcode *codes);
ULONG get_lz_price_megalz(OFFSET position, struct lzcode *lzcode);

//---------------------------------------------------------------------------
// mhmt-optimal.h
//---------------------------------------------------------------------------

// this structure exists in array for each input byte and used to build optimal code chain
struct optchain {
    struct lzcode code;     // code of jumping here from previous position
    ULONG price;            // bitprice (bitlength) of the best chain of lzcodes going up to this point:
                            // initialized as 0xFFFFFFFF (maximum price)
    ULONG _just_a_filler_;  // to make structure 8 bytes long (true for 32bit machines)
};

struct optchain *make_optch(ULONG actual_len);

// makes path of 8 optchains
void update_optch(ULONG position, struct lzcode *codes, ULONG (*get_lz_price)(OFFSET position, struct lzcode *lzcode),
                  struct optchain *optch);
void reverse_optch(struct optchain *optch, ULONG actual_len);
void free_optch(struct optchain *optch);

//---------------------------------------------------------------------------
// mhmt-tb.c
//---------------------------------------------------------------------------

// entry for twobyters search and add
static struct tb_chain *tb_entry[65536];
static struct tb_chain *tb_free;     // linked list of freed tb_chain entries - NULL at the beginning
static struct tb_bunch *tb_bunches;  // all allocated bunches as linked list

static void init_tb(void) {
    tb_free = NULL;                       // init linked list of free tb_chain elements
    tb_bunches = NULL;                    // no bunches already allocated
    for (uint32_t i = 0; i < 65536; i++)  // init array of 2-byte match pointers
        tb_entry[i] = NULL;
}

static void free_tb(void) {
    while (tb_bunches) {
        struct tb_bunch *tbtmp = tb_bunches;
        tb_bunches = tb_bunches->next;
        free(tbtmp);
    }
}

// addw new twobyter:
// index=(prev<<8)+curr - index into tb_entry,
// position - position in input file for 'curr' byte
// returns zero if any error (cant allocate mem), otherwise 1
ULONG add_tb(UWORD index, OFFSET position) {
    struct tb_chain *newtb = get_free_tb();
    if (!newtb) {  // no free elements
        if ((OFFSET)(position + wrk.prelen) > (OFFSET)wrk.maxwin) { // if there could be enough tbs to try to flush
            // try to flush current chain
            cutoff_tb_chain(index, position);
        }

        newtb = get_free_tb();
        if (!newtb) {  // nothing free - allocate new bunch
            if (!add_bunch_of_tb())
                return 0;
            newtb = get_free_tb();  // here is no chance to fail!... hopefully...
        }
    }

    newtb->pos = position - 1;  // points to the first byte of given two bytes
    newtb->next = tb_entry[index];
    tb_entry[index] = newtb;
    return 1;
}

// shorten given twobyter chain to have only actual (<wrk.maxwin old) elements, giving some free elements to reuse
void cutoff_tb_chain(UWORD index, OFFSET position) {
    struct tb_chain *curr, *prev;

    curr = tb_entry[index];
    if (!curr)
        return;  // if nothing to remove

    // see if we should delete some elements after first element in the given chain
    prev = curr;
    curr = curr->next;

    while (curr) {
        if ((position - (curr->pos)) >
            (OFFSET)wrk.maxwin)  // found some old element: delete rest of chain along with it
        {
            // find end of chain
            while (curr->next)
                curr = curr->next;

            // now curr - last chain element, prev->next - beginning of orphaned chain
            // add orphaned chain to free list
            curr->next = tb_free;
            tb_free = prev->next;

            prev->next = NULL;  // cut off chain

            break;
        } else {
            prev = curr;
            curr = curr->next;
        }
    }

    // delete first (entry) element in chain if needed (in this case, all subsequent els are already deleted)
    curr = tb_entry[index];
    if (position - curr->pos > (OFFSET)wrk.maxwin) {
        tb_entry[index] = NULL;

        curr->next = tb_free;  // element goes to free list
        tb_free = curr;
    }
}

// adds new bunch of TBs when needed
// zero - error
ULONG add_bunch_of_tb(void) {
    ULONG i;
    struct tb_bunch *newbunch;

    // alloc new bunch
    newbunch = (struct tb_bunch *)malloc(sizeof(struct tb_bunch));
    if (!newbunch)
        return 0;

    // link every twobyter into one list
    for (i = 0; i < BUNCHSIZE - 1; i++)
        newbunch->bunch[i].next = &(newbunch->bunch[i + 1]);

    // add this list to the free list
    newbunch->bunch[BUNCHSIZE - 1].next = tb_free;
    tb_free = &(newbunch->bunch[0]);

    // add bunch to bunches list
    newbunch->next = tb_bunches;
    tb_bunches = newbunch;

    return 1;
}

// find free tb, if any, otherwise NULL

struct tb_chain *get_free_tb(void) {
    if (!tb_free)
        return NULL;
    struct tb_chain *newtb = tb_free;
    tb_free = tb_free->next;
    return newtb;
}

//---------------------------------------------------------------------------
// mhmt-optimal.c
//---------------------------------------------------------------------------

// allocate place for optimal chain building amd initialize it
struct optchain *make_optch(ULONG actual_len) {
    // we allocate length+1 because all codes at the end of input stream will point
    // to the length+1 place. Also we'll start reversing from length+1 position in optch array
    struct optchain *optch = (struct optchain *)malloc((actual_len + 1) * sizeof(struct optchain));

    if (optch) {
        optch[0].code.length = 1;  // 1st byte is always copied 'as-is', however, this is just filler,
        optch[0].code.disp = 0;    // not accounted elsewhere

        // init prices to absolute maximum for optimal chain build-up
        optch[0].price = 0;
        optch[1].price = 8;
        for (ULONG i = 2; i < (actual_len + 1); i++)
            optch[i].price = 0xFFFFFFFF;
    }

    return optch;
}

// free optchain array
void free_optch(struct optchain *optch) {
    free(optch);
}

// update prices at the position given all lzcodes.
// it also needs pointer to the function that calculates bit length of given LZ code
void update_optch(ULONG position, struct lzcode *codes, ULONG (*get_lz_price)(OFFSET position, struct lzcode *lzcode),
                  struct optchain *optch) {
    ULONG codepos;
    ULONG bitlen;
    ULONG newpos;
    LONG len;

    for (codepos = 0; len = codes[codepos].length; codepos++)  // loop through all existing lz codes
    {
        bitlen = (*get_lz_price)(position, &codes[codepos]);  // get bit length of given lz code
        if (!bitlen) {
            printf("mhmt-optimal.c: update_optch() found zero bitlength of lz code. Fatal error.\n");
            exit(1);
        } else {
            if (len < 0)
                len = (-len);  // deal with negative lengths (special markers)

            newpos = position +
                     len;  // look where current lz code points to and take from there old price reaching that location

            if (optch[newpos].price > bitlen + optch[position].price)  // if oldprice is worse than with current lz code
            {
                optch[newpos].price = bitlen + optch[position].price;
                optch[newpos].code = codes[codepos];
            }
        }
    }
}

// reverses optimal chain making it ready for scanning (fetching optimal chain)

void reverse_optch(struct optchain *optch, ULONG actual_len) {
    ULONG position = actual_len;
    struct lzcode temp = optch[position].code;
    while (position > 1) {
        LONG len = temp.length;
        if (len < 0)
            len = -len;
        position -= len;
        struct lzcode curr = temp;
        temp = optch[position].code;
        optch[position].code = curr;
    }
}

//---------------------------------------------------------------------------
// mhmt-hash.c
//---------------------------------------------------------------------------

// allocate mem for hash (length) and build it from data
// length must be at least 3 bytes, since hash[0] and hash[1] are not valid hashes
UBYTE *build_hash(const UBYTE *data, ULONG length, ULONG prebin_len) {
    UBYTE *hash;
    ULONG i;
    const UBYTE *src;
    UBYTE *dst;
    UBYTE curr, prev, prev2;

    if (!length)
        return NULL;

    hash = (UBYTE *)malloc(length + prebin_len);
    if (!hash)
        return NULL;

    prev = curr = 0;
    i = length + prebin_len;
    src = data - prebin_len;
    dst = hash;

    do {
        prev2 = (UBYTE)((prev >> 1) | (prev << 7));
        prev = (UBYTE)((curr >> 1) | (curr << 7));
        curr = *(src++);

        *(dst++) = curr ^ prev ^ prev2;

    } while (--i);

    return hash + prebin_len;  // negative indices must be used to access prebin hashes
}

// free hash

void destroy_hash(UBYTE *hash, ULONG prebin_len) {
    if (hash)
        free(hash - prebin_len);
}

//---------------------------------------------------------------------------
// mhmt-emit.c
//---------------------------------------------------------------------------

static size_t mhmt_fwrite(const void *data, size_t data_size) {
    size_t result = 0;
    if (wrk.output_pos + data_size <= sizeof(wrk.output)) {
        (void)memcpy(&wrk.output[wrk.output_pos], data, data_size);
        wrk.output_pos += data_size;
        result = data_size;
    }
    return result;
}

// actually generate output file from optimal chain - MegaLZ version
ULONG emit_megalz(struct optchain *optch, ULONG actual_len) {
    ULONG position;
    LONG length;
    LONG disp;
    LONG max_disp;  // maximum encountered displacement
    ULONG varbits, varlen;
    ULONG success = 1;

    max_disp = 0;

    // some checks
    if (!optch) {
        printf("mhmt-emit.c:emit_megalz() - NULL passed!\n");
        return 0;
    }

    // initialize
    success = success && emit_file(NULL, EMIT_FILE_INIT);
    success = success && emit_byte(0, EMIT_BYTE_INIT);
    success = success && emit_bits(0, EMIT_BITS_INIT);

    // copy first byte as-is
    success = success && emit_file(wrk.indata, 1);

    // go emitting codes
    position = 1;

    while ((position < actual_len) && success) {
        length = optch[position].code.length;
        disp = optch[position].code.disp;

        if (length == 0) {
            printf("mhmt-emit.c:emit_megalz() - encountered stop-code in optimal chain before emitting all data!\n");
            return 0;
        } else if (length == 1)  // either copy-byte or len=1 code
        {
            if (disp == 0)  // copy-byte (%1<byte>)
            {
                success = success && emit_bits(0x80000000, 1);
                success = success && emit_byte(wrk.indata[position], EMIT_BYTE_ADD);
            } else if ((-8) <= disp && disp <= (-1))  // len=1, disp=-1..-8 (%000abc)
            {
                success = success && emit_bits(0x00000000, 3);
                success = success && emit_bits(disp << (32 - 3), 3);

                if (max_disp > disp)
                    max_disp = disp;
            } else
                goto INVALID_CODE_MEGALZ;
        } else if (length == 2) {
            if ((-256) <= disp && disp <= (-1))  // %001<byte>
            {
                success = success && emit_bits(0x20000000, 3);
                success = success && emit_byte((UBYTE)(0x00FF & disp), EMIT_BYTE_ADD);

                if (max_disp > disp)
                    max_disp = disp;
            } else
                goto INVALID_CODE_MEGALZ;
        } else if (3 <= length && length <= 255) {
            // length coding
            if (length == 3)  // %010
            {
                success = success && emit_bits(0x40000000, 3);
            } else  // length==4..255, %011
            {
                success = success && emit_bits(0x60000000, 3);

                // calculate size of variable bits
                varlen = 0;
                varbits = (length - 2) >> 1;
                while (varbits) {
                    varbits >>= 1;
                    varlen++;
                }

                varbits = length - 2 - (1 << varlen);  // prepare length coding

                success = success && emit_bits(1 << (32 - varlen), varlen);
                success = success && emit_bits(varbits << (32 - varlen), varlen);
            }

            // displacement coding
            if ((-256) <= disp && disp <= (-1)) {
                success = success && emit_bits(0, 1);
                success = success && emit_byte((UBYTE)(0x00ff & disp), EMIT_BYTE_ADD);

                if (max_disp > disp)
                    max_disp = disp;
            } else if ((-4352) <= disp && disp < (-256)) {
                success = success && emit_bits(0x80000000, 1);

                success = success && emit_bits((0x0F00 & (disp + 0x0100)) << 20, 4);

                success = success && emit_byte((UBYTE)(0x00FF & disp), EMIT_BYTE_ADD);

                if (max_disp > disp)
                    max_disp = disp;
            } else
                goto INVALID_CODE_MEGALZ;
        } else {
        INVALID_CODE_MEGALZ:
            printf("mhmt-emit.c:emit_megalz() - invalid code: length=%d, displacement=%d\n", length, disp);
            return 0;
        }

        position += length;
    }

    // stop-code
    success = success && emit_bits(0x60100000, 12);
    success = success && emit_bits(0, EMIT_BITS_FINISH);  // this also flushes emit_byte()
    success = success && emit_file(NULL, EMIT_FILE_FINISH);

    return success;
}

// emit bytes to the output buffer and flush to file when needed
// 'operation' defines what to do as described in *.h
// 'byte' is emitted only when length >=1,
// When length=EMIT_FILE_FINISH (0), flushes tail to file
// When length=EMIT_FILE_INIT (-1), initializes.
//
// returns zero in case of any problems (fails to write buffer to file), otherwise non-zero
ULONG emit_file(const UBYTE *bytes, LONG length) {
    static UBYTE buffer[EMIT_FILEBUF_SIZE];
    static ULONG position;

    if (length == EMIT_FILE_INIT) {
        position = 0;
        return 1;
    }

    if (length > 0) {
        while (position + length >= EMIT_FILEBUF_SIZE) { // if we have to flush buffer
            length -= (EMIT_FILEBUF_SIZE - position);

            while (position < EMIT_FILEBUF_SIZE)  // fill buffer to the end, if possible
                buffer[position++] = *(bytes++);

            if (EMIT_FILEBUF_SIZE != mhmt_fwrite(buffer, EMIT_FILEBUF_SIZE)) {
                printf("mhmt-emit.c:emit_file() can't write to file!\n");
                return 0;
            }

            position = 0;
        }

        while (length--)  // if something left that does not need flushing
            buffer[position++] = *(bytes++);

        return 1;
    }

    if (length == EMIT_FILE_FINISH) {
        if (position > 0) { // do we have anything to flush?
            if (position != mhmt_fwrite(buffer, position)) {
                printf("mhmt-emit.c:emit_file() can't write to file!\n");
                return 0;
            }
        }
        return 1;
    }

    printf("mhmt-emit.c:emit_file() encountered invalid arguments!\n");
    return 0;
}

// store emitted bytes in special buffer, because emitted bits go earlier than corresponding bytes.
// then, when bits are flushed to the file, bytes are flushed just after.
// returns zero if any problems. "operation" dictates what to do (see *.h)
ULONG emit_byte(UBYTE byte, ULONG operation) {
    static UBYTE buffer[EMIT_BYTEBUF_SIZE];

    static ULONG in_pos, out_pos;

    ULONG success;

    switch (operation) {
        case EMIT_BYTE_INIT:

            in_pos = 0;
            out_pos = 0;

            return 1;

        case EMIT_BYTE_ADD:

#ifdef DBG
            printf("<%02x>", byte & 0x00FF);
#endif

            buffer[in_pos] = byte;

            in_pos = (in_pos + 1) & (EMIT_BYTEBUF_SIZE - 1);

            if (in_pos == out_pos)  // overflow!
            {
                printf("mhmt-emit.c:emit_byte() buffer overflow!\n");
                return 0;
            }

            return 1;

        case EMIT_BYTE_FLUSH:

            if (in_pos == out_pos)  // nothing to do?
                return 1;
            else if (in_pos > out_pos)  // no index wraparound
            {
                success = emit_file(&buffer[out_pos], in_pos - out_pos);
            } else  // in_pos<out_pos - wraparound
            {
                success = emit_file(&buffer[out_pos], EMIT_BYTEBUF_SIZE - out_pos);

                if (in_pos)
                    success = success && emit_file(&buffer[0], in_pos);
            }

            out_pos = in_pos;
            return success;

        default:
            printf("mhmt-emit.c:emit_byte() encountered invalid arguments!\n");
            return 0;
    }
}

// collects bits, emit to output stream when needed. accounts for word or byte mode, little-big endian, empty or full
// bits length is either positive number of bits or one of two special cases (see *.h)
//
ULONG emit_bits(ULONG msb_aligned_bits, LONG length) {
    static ULONG bit_store;
    static ULONG bit_count;

    ULONG max_bits;

    ULONG success = 1;

    max_bits = 8;

    if (length == EMIT_BITS_INIT) {
        bit_store = 0;
        bit_count = 0;
        return 1;
    } else if (length == EMIT_BITS_FINISH) {
        if (bit_count)  // some bits to flush
        {
            while ((bit_count++) < max_bits)
                bit_store <<= 1;

            success = success && emit_bits_flush(bit_store);
        }

        success = success && emit_byte(0, EMIT_BYTE_FLUSH);

        return success;
    } else if (length > 0)  // add bits
    {
        do {
            if (!wrk.fullbits)  // empty bits - check for flushing before shiftin
            {
                if (bit_count == max_bits) {
                    success = success && emit_bits_flush(bit_store);
                    success = success && emit_byte(0, EMIT_BYTE_FLUSH);

                    bit_count = 0;
                }
            }

            // printf("%d",1&(msb_aligned_bits>>31));

            bit_store = (bit_store << 1) | (1 & (msb_aligned_bits >> 31));
            msb_aligned_bits <<= 1;
            bit_count++;

            if (wrk.fullbits)  // full bits - check for flushing after bit shiftin
            {
                if (bit_count == max_bits) {
                    success = success && emit_bits_flush(bit_store);
                    success = success && emit_byte(0, EMIT_BYTE_FLUSH);

                    bit_count = 0;
                }
            }

        } while (--length);

        return success;
    } else {
        printf("mhmt-emit.c:emit_bits() encountered invalid arguments!\n");
        return 0;
    }
}

// flushes either word or byte from given bits

ULONG emit_bits_flush(ULONG bits) {
    UBYTE store_byte = 0x00FF & bits;
    return emit_file(&store_byte, 1);
}

//---------------------------------------------------------------------------
// mhmt-lz.c
//---------------------------------------------------------------------------

// Universal search function
//
void make_lz_codes(OFFSET position, ULONG actual_len, UBYTE *hash, struct lzcode *codes) {
    OFFSET i;
    ULONG codepos;
    ULONG codelen;
    ULONG was_match;
    UBYTE curr_byte, next_byte;
    struct tb_chain *curr_tb;
    UWORD index;
    ULONG max_lookback, max_length, max_tbdisp;

    // copy-byte code is always present
    codes[0].length = 1;
    codes[0].disp = 0;

    // start more filling of codes[] from that position
    codepos = 1;

    curr_byte = wrk.indata[position];

    // check for one-byter (-1..-8)
    //
    i = (position > (8LL - wrk.prelen)) ? position - 8 : (0LL - wrk.prelen);
    do {
        if (wrk.indata[i] == curr_byte) {
            codes[codepos].length = 1;
            codes[codepos].disp = -(LONG)(position - i);
            codepos++;
            break;
        }
    } while ((++i) < position);

    max_lookback = (wrk.maxwin < 4352) ? wrk.maxwin : 4352;
    max_length = 255;
    max_tbdisp = 256;

    // check for two-byter (-1..-max_tbdisp)
    //
    curr_tb = NULL;
    //
    if (position < (OFFSET)(actual_len - 1))  // don't try two-byter if we are at the byte before last one
    {
        next_byte = wrk.indata[position + 1];
        index = (curr_byte << 8) + next_byte;
        curr_tb = tb_entry[index];

        // there are two-byters!
        if (curr_tb) {
            if (((position - curr_tb->pos) <= (OFFSET)max_tbdisp) &&
                ((position - curr_tb->pos) <= (OFFSET)max_lookback)) {
                codes[codepos].length = 2;
                codes[codepos].disp = -(LONG)(position - curr_tb->pos);
                codepos++;
            }
        }
    }

    // at last, check for lengths=3..max_length up to max_lookback
    if (curr_tb && ((position - curr_tb->pos) <= (OFFSET)max_lookback) &&
        (position < (OFFSET)(actual_len - 2)))  // if we can proceed at all
    {
        was_match = 1;  // there was match at codelen-1

        for (codelen = 3; (codelen <= max_length) && (position < (OFFSET)(actual_len - codelen + 1)); /*nothing*/) {
            if (was_match)  // for codelen-1
            {
                // codelen-1 bytes are matched, compare one more byte
                if (wrk.indata[position + codelen - 1] == wrk.indata[curr_tb->pos + codelen - 1]) {
                    // add code to the table
                    codes[codepos].length = codelen;
                    codes[codepos].disp = -(LONG)(position - curr_tb->pos);
                    codepos++;

                    codelen++;  // next time do comparision of greater size
                } else          // last bytes do not match
                {
                MATCH_FAIL:  // entrance for failed matches here: used 3-fold so we set "goto" here

                    // go for older twobyter
                    curr_tb = curr_tb->next;

                    // no more twobyters or they are too far - stop search at all
                    if (!curr_tb)
                        break;
                    if ((position - curr_tb->pos) > (OFFSET)max_lookback)
                        break;

                    // mark there was no matches
                    was_match = 0;
                }
            } else  // there were no matches for previous codelen
            {
                // next twobyter is already taken, but no comparision is done for codelen bytes
                // first we check if we need to do such comparision at all by seeing to the hashes of the ends of
                // strings
                if (hash[position + codelen - 1] ==
                    hash[curr_tb->pos + codelen - 1]) {  // hashes match, so try matching complete string
                    if (!memcmp(&wrk.indata[position], &wrk.indata[curr_tb->pos], codelen)) {
                        was_match = 1;
                        codes[codepos].length = codelen;
                        codes[codepos].disp = -(LONG)(position - curr_tb->pos);
                        codepos++;

                        codelen++;
                    } else
                        // no match of whole string
                        goto MATCH_FAIL;
                } else
                    // no match of hashes
                    goto MATCH_FAIL;
            }
        }
    }

    // here we assume to have found all possible matches. check for codes[] table overflow:
    // there could be matches for length 1..3839, and there is copy-1-byte, 16 copymanybyters, 1 insertion match, total
    // 3857 entries for hrust, 256 for megalz & hrum 65536 for zx7
    if (codepos > 256) {  // this should not happen!
        printf("mhmt-lz.c:make_lz_codes() encountered too many entries in codes[] table. Fatal error.\n");
        exit(1);
    }

    // mark end-of-records in codes[]
    codes[codepos].length = 0;
    codes[codepos].disp = 0;
}

// returns price in bits or zero if error
//
ULONG get_lz_price_megalz(OFFSET position, struct lzcode *lzcode) {
    ULONG varbits, varlen;
    LONG length, disp;

    length = lzcode->length;
    disp = lzcode->disp;

    if (length == 1) {
        if (disp == 0)
            return 9;
        else if ((-8) <= disp && disp <= (-1))
            return 6;
        else
            goto INVALID_CODE_MEGALZ;
    } else if (length == 2) {
        if ((-256) <= disp && disp <= (-1))
            return 11;
        else
            goto INVALID_CODE_MEGALZ;
    } else if (length == 3) {
        if ((-256) <= disp && disp <= (-1))
            return 12;
        else if ((-4352) <= disp && disp < (-256))
            return 16;
        else
            goto INVALID_CODE_MEGALZ;
    } else if (4 <= length && length <= 255) {
        varlen = 0;
        varbits = (length - 2) >> 1;
        while (varbits) {
            varbits >>= 1;
            varlen += 2;
        }

        if ((-256) <= disp && disp <= (-1))
            varlen += 9;
        else if ((-4352) <= disp && disp < (-256))
            varlen += 13;
        else
            goto INVALID_CODE_MEGALZ;

        return varlen + 3;
    } else {
    INVALID_CODE_MEGALZ:
        printf("mhmt-lz.c:get_lz_price_megalz(): Found invalid code length=%d, displacement=%d\n", length, disp);
        return 0;
    }
}

//---------------------------------------------------------------------------
// mhmt-pack.h
//---------------------------------------------------------------------------

//#define MAX_CODES_SIZE 3860 // max num of codes is 3857, plus stopcode, plus some extra bytes
#define MAX_CODES_SIZE 65540

// this structure exists in array for each input byte and used to build optimal code chain
struct packinfo {
    struct lzcode code;     // code of jumping here from previous position
    ULONG price;            // bitprice (bitlength) of the best chain of lzcodes going up to this point:
                            // initialized as 0xFFFFFFFF (maximum price)
    ULONG _just_a_filler_;  // to make structure 8 bytes long (true for 32bit machines)
};

//---------------------------------------------------------------------------
// mhmt-pack.c
//---------------------------------------------------------------------------

// entry function to pack data
// returns zero if any error
static ULONG pack(void) {
    ULONG (*get_lz_price)(OFFSET position, struct lzcode * lzcode) = NULL;  // generates correct bitlen (price) of code
    ULONG (*emit)(struct optchain * optch, ULONG actual_len) = NULL;  // emits lzcode to the output bit/byte stream
    ULONG success = 1;
    ULONG actual_len;  // actual length of packing (to account for ZX headers containing last unpacked bytes)
    UBYTE *hash;
    struct optchain *optch = NULL;
    static struct lzcode codes[MAX_CODES_SIZE];  // generate codes here; static to ensure it's not on the stack
    UBYTE curr_byte, last_byte;
    UWORD index;
    OFFSET position;

    // some preparations
    get_lz_price = &get_lz_price_megalz;
    emit = &emit_megalz;

    actual_len = wrk.inlen;

    // initializations and preparations
    init_tb();

    hash = build_hash(wrk.indata, actual_len, wrk.prelen);
    if (!hash) {
        printf("mhmt-pack.c:pack() - build_hash() failed!\n");
        success = 0;
    }

    if (success) {
        optch = make_optch(actual_len);
        if (!optch) {
            printf("mhmt-pack.c:pack() - can't make optchain array!\n");
            success = 0;
        }
    }

    // go packing!
    if (success) {
        // fill TBs with prebinary date
        if (wrk.prebin) {
            curr_byte = wrk.indata[0LL - wrk.prelen];
            //
            for (position = (1LL - wrk.prelen); position <= 0; position++) {
                last_byte = curr_byte;
                curr_byte = wrk.indata[position];

                index = (last_byte << 8) + curr_byte;

                if (!add_tb(index, position)) {
                    printf("mhmt-pack.c:pack() - add_tb() failed!\n");
                    success = 0;
                    goto ERROR;
                }
            }
        }

        // go generating lzcodes byte-by-byte
        //
        curr_byte = wrk.indata[0];
        //
        for (position = 1; position < (OFFSET)actual_len; position++) {
            last_byte = curr_byte;
            curr_byte = wrk.indata[position];

            // add current two-byter to the chains
            index = (last_byte << 8) + curr_byte;
            if (!add_tb(index, position)) {
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

        // data built, now emit packed file
        success = success && (*emit)(optch, actual_len);
    }

ERROR:
    free_optch(optch);

    destroy_hash(hash, wrk.prelen);

    return success;
}

//---------------------------------------------------------------------------

void PackMegaLz(const void *src, size_t src_size, std::vector<uint8_t> &output) {
    memset(&wrk, 0, sizeof(wrk));
    wrk.maxwin = 4352;
    wrk.inlen = src_size;
    wrk.indata = (const UBYTE *)src;
    if (!pack())
        throw std::runtime_error("Can't pack");
    output.assign(wrk.output, wrk.output + wrk.output_pos);
}
