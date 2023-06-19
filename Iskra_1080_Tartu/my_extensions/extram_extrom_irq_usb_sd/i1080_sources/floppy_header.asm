    .org 0

#define SECTOR_PER_TRACK 40
#define RESERVED_TRACKS 2
#define TRACKS 160
#define BLOCK_SIZE 1024
#define ENTRIES 64

#define ENTRIES_MASK(A) (0xFFFF ^ (0xFFFF >> (ENTRIES / (BLOCK_SIZE / 32))))

    DW SECTOR_PER_TRACK
    DB 4      ; bsh  Block shift. 3 => 1k, 4 => 2k, 5 => 4k....
    DB 0Fh    ; blm  Block mask. 7 => 1k, 0Fh => 2k, 1Fh => 4k...
    DB 0      ; exm  Extent mask, see later
    DW (((TRACKS - RESERVED_TRACKS) * SECTOR_PER_TRACK * 128) / BLOCK_SIZE) - 1
    DW ENTRIES - 1
    DB ENTRIES_MASK(0) >> 8
    DB ENTRIES_MASK(0)
    DW (ENTRIES + 3) / 4
    DW RESERVED_TRACKS

    savebin "floppy_header.bin", 0, $
