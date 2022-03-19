#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include <stdint.h>
typedef union {
    uint16_t x16;
    uint8_t x8[2];
} uni16_t;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#define VARIANT_RK      1
#define VARIANT_MIKR    2
#define VARIANT_SP_MON  3
#define __USERNAME__    "CoolHacker"

const uint8_t wavheader[] = {
    0x52, 0x49, 0x46, 0x46, 0x00, 0x00, 0x00, 0x00, 0x57, 0x41, 0x56, 0x45,
    0x66, 0x6d, 0x74, 0x20, 0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
    0x22, 0x56, 0x00, 0x00, 0x22, 0x56, 0x00, 0x00, 0x01, 0x00, 0x08, 0x00,
    0x64, 0x61, 0x74, 0x61, 0x00, 0x00, 0x00, 0x00
};

uint16_t loadAddr = 0x0100,     /* load address */
         binSize = 0;
char tapeName[256] = { 0 },     /* file name in the tape headers */
     romFile[256] = { 0 },      /* input bin/rom file name */
     outFile[256] = { 0 },      /* output wav file name */
     machine[256] = { 0 };
uint8_t romData[65536] = { 0 },
        data[131072] = { 0 },
        www[512] = { 0 };
int variant = 0,
    speed = 12;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int str_to_u16(const char *str, uint16_t * x)
{
    int rdx;
    if ((str[0] == '0') && (str[1] == 'x'))
        rdx = 16;
    else
        rdx = 10;
    char *strend;
    double rez = strtoul(str, &strend, rdx);
    int err = errno;
    if ((err == ERANGE) || (rez > 0xffff))
        return 1;
    else {
        *x = (uint16_t) rez;
        return 0;
    }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

int MakeWAV(int Size)
{
    FILE *f2 = fopen(outFile, "wb");
    if (f2) {
        fwrite(wavheader, 1, 0x002c, f2);
        memset(romData, 0x80, 8820);
        fwrite(romData, 1, 8820, f2);
        int i = 0;
        do {
            uint8_t octet = data[i];
            int b, dptr = 0;
            for (b = 0; b < 8; ++b, octet <<= 1) {
                uint8_t phase = (octet & 0x80) ? 32 : (255 - 32);
                int q;
                for (q = 0; q < speed; ++q)
                    www[dptr++] = phase;
                phase ^= 255;
                for (q = 0; q < speed; ++q)
                    www[dptr++] = phase;
            }
            fwrite(www, 1, dptr, f2);
        } while (++i < Size);
        fwrite(romData, 1, 8820, f2);
        uint32_t fsz = ftell(f2) - 8;
        fseek(f2, 0x0004, SEEK_SET);
        fwrite(&fsz, 1, 4, f2);
        fsz -= 36;
        fseek(f2, 0x0028, SEEK_SET);
        fwrite(&fsz, 1, 4, f2);
        fclose(f2);
        return 0;
    } else
        return 1;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int maketape_specialist(void)
{
    uni16_t chksum;
    chksum.x16 = 0;
    int dptr = 0, i;
    if (variant == VARIANT_SP_MON) {
        for (i = 0; i < 256; ++i)
            data[dptr++] = 0;
        data[dptr++] = 0xe6;
        data[dptr++] = 0xd9;
        data[dptr++] = 0xd9;
        data[dptr++] = 0xd9;
        int sz_tapeName = strlen(tapeName);
        if (sz_tapeName > 16)
            sz_tapeName = 16;
        memcpy(data + dptr, tapeName, sz_tapeName);
        dptr += sz_tapeName;
    }
    for (i = 0; i < 768; ++i)
        data[dptr++] = 0;
    data[dptr++] = 0xe6;
    data[dptr++] = loadAddr & 0xff;
    data[dptr++] = (loadAddr >> 8) & 0xff;
    data[dptr++] = (loadAddr + binSize - 1) & 0xff;
    data[dptr++] = ((loadAddr + binSize - 1) >> 8) & 0xff;
    memcpy(data + dptr, romData, binSize);
    dptr += binSize;
    i = 0;
    do {
        uint8_t b = romData[i];
        chksum.x16 += (b | (b << 8));
    } while (++i < (binSize - 1));
    chksum.x8[0] += romData[i];
    data[dptr++] = chksum.x8[0];
    data[dptr++] = chksum.x8[1];
    return MakeWAV(dptr);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int maketape_krista(void)
{
    // Krista: Vector-06c ugly sister.
    //
    // 256[55]

    uint16_t nblocks = (binSize + 255) / 256, block;
    int i, dofs = 0, sofs = 0;
    /* Preamble */
    for (i = 0; i < 200; ++i)
        data[dofs++] = (((i / 25) % 2) == 0) ? 0x00 : 0x55;

    uint8_t cs = 0;
    /* Header block */
    data[dofs++] = 0xe6;
    data[dofs++] = 0xff;
    uint8_t startblock = 0xff & (loadAddr >> 8);
    cs = data[dofs++] = startblock;
    cs += data[dofs++] = 0xff & (startblock + nblocks);
    data[dofs++] = cs;
    /* Blocks */
    for (block = startblock; block < (startblock + nblocks); ++block) {
        cs = 0;
        /* Block preamble */
        for (i = 0; i < 16; ++i)
            data[dofs++] = 0x55;
        data[dofs++] = 0xE6;
        data[dofs++] = block;   /* hi byte of block address */
        data[dofs++] = 0;       /* low byte of block address */
        data[dofs++] = 0;       /* payload size + 1 */
        /* Data: 256 octets */
        for (i = 0; i < 256; ++i) {
            cs += data[dofs++] = (sofs < binSize) ? romData[sofs++] : 0x00;
        }
        data[dofs++] = 0xff & cs;
    }
    return MakeWAV(dofs);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int maketape_v06c_rom(void)
{
    // 4[ 25[00] 25[55] ]  record preamble
    // 16[00]   block preamble
    //  4[55] [E6]
    //      4[00] 25[filename] 2[00]  [hi(addr)] [block count] [block number] [cs0]
    //  4[00] [E6]
    //      [80] [cs0]
    //      32[data] [checksum_data]
    //  4[00] [E6]
    //      [81] [cs0]
    //      32[data] [checksum_data]
    //   . . .
    //  4[00] [E6]
    //      [87] [cs0]
    //      32[data] [checksum_data]
    //
    // Sizes:
    //      record preamble                 =200
    //
    //      one block:
    //          preamble             16
    //          name:                40
    //          data:                40 x 8
    //          total:                      =376
    //      N_blocks=(data size + 255) / 256
    //      Grand Total                     =200 + N_blocks * 376 + end padding 8

    uint16_t nblocks = (binSize + 255) / 256, sofs = 0, block;
    int i, dofs = 0;
    /* Preamble */
    for (i = 0; i < 200; ++i)
        data[dofs++] = (((i / 25) % 2) == 0) ? 0x00 : 0x55;
    /* Blocks */
    for (block = 0; block < nblocks; ++block) {
        /* Checksum of the name subbbbblock */
        uint16_t cs0 = 0;
        /* Block preamble */
        for (i = 0; i < 16; ++i)
            data[dofs++] = 0x00;
        /* Name subblock id */
        for (i = 0; i < 4; ++i)
            data[dofs++] = 0x55;
        data[dofs++] = 0xE6;
        for (i = 0; i < 4; ++i)
            data[dofs++] = 0x00;
        /* Name */
        int sz_tapeName = strlen(tapeName);
        for (i = 0; i < 25; ++i)
            cs0 += data[dofs++] = (i < sz_tapeName) ? tapeName[i] : 0x20;
        data[dofs++] = 0;
        data[dofs++] = 0;
        /* High nibble of org address */
        cs0 += data[dofs++] = 0xff & (loadAddr >> 8);   /* TODO: fix misaligned loadAddr */
        /* Block count */
        cs0 += data[dofs++] = nblocks;
        /* Block number */
        cs0 += data[dofs++] = nblocks - block;
        data[dofs++] = cs0 & 0xff;
        /* Now the actual data: 8x32 octets */
        uint8_t sblk;
        for (sblk = 0x80; sblk < 0x88; ++sblk) {
            uint16_t cs = 0;
            for (i = 0; i < 4; ++i)
                data[dofs++] = 0x00;
            data[dofs++] = 0xE6;
            cs += data[dofs++] = sblk;
            cs += data[dofs++] = cs0;
            for (i = 0; i < 32; ++i) {
                cs += data[dofs++] =
                    (sofs < binSize) ? romData[sofs++] : 0;
            }
            data[dofs++] = 0xff & cs;
        }
    }
    return MakeWAV(dofs);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int maketape_nekrosha(void)
{
    // Элемент  Размер, байт
    // Ракорд (нулевые байты)   256
    // Синхробайт (E6h)         1
    // Начальный адрес в ОЗУ    2
    // Конечный адрес в ОЗУ     2
    // Данные   (конечный адрес - начальный адрес + 1)
    // Ракорд (нулевые байты)   2
    // Синхробайт (E6h)         1
    // Контрольная сумма        2

    int dptr = 0, i;
    for (i = 0; i < 256; ++i)
        data[dptr++] = 0;
    data[dptr++] = 0xe6;
    data[dptr++] = (loadAddr >> 8) & 0xff;
    data[dptr++] = loadAddr & 0xff;
    data[dptr++] = ((loadAddr + binSize - 1) >> 8) & 0xff;
    data[dptr++] = (loadAddr + binSize - 1) & 0xff;
    memcpy(data + dptr, romData, binSize);
    dptr += binSize;

    if (variant == VARIANT_RK) {
        uni16_t chksum;
        chksum.x16 = 0;
        i = 0;
        do {
            uint8_t b = romData[i];
            chksum.x16 += (b | (b << 8));
        } while (++i < (binSize - 1));
        chksum.x8[0] += romData[i];
        data[dptr++] = 0;
        data[dptr++] = 0;
        data[dptr++] = 0xe6;
        data[dptr++] = chksum.x8[1];
        data[dptr++] = chksum.x8[0];
    } else {
        uni16_t chksum;
        chksum.x16 = 0;
        i = 0;
        do {
            chksum.x8[i & 1] ^= romData[i];
        } while (++i < binSize);
        data[dptr++] = chksum.x8[1];
        data[dptr++] = chksum.x8[0];
    }

    return MakeWAV(dptr);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

static int MakeTape(void)
{
    if (machine[0] == 'r') {
        if ((strcmp(machine, "rk-bin") == 0)
            || (strcmp(machine, "rk86-bin") == 0)
            ) {
            speed = 10;
            variant = VARIANT_RK;
            return maketape_nekrosha();
        }
    } else if (machine[0] == '8') {
        if (strcmp(machine, "86rk-bin") == 0) {
            speed = 10;
            variant = VARIANT_RK;
            return maketape_nekrosha();
        }
    } else if (machine[0] == 'm') {
        if ((strcmp(machine, "mikrosha-bin") == 0)
            || (strcmp(machine, "microsha-bin") == 0)
            || (strcmp(machine, "microcha-bin") == 0)
            ) {
            speed = 15;
            variant = VARIANT_MIKR;
            return maketape_nekrosha();
        }
    } else if (machine[0] == 'n') {
        if ((strcmp(machine, "necrosha-bin") == 0)
            || (strcmp(machine, "nekrosha-bin") == 0)
            || (strcmp(machine, "necro-bin") == 0)
            || (strcmp(machine, "nekro-bin") == 0)
            ) {
            speed = 15;
            variant = VARIANT_MIKR;
            return maketape_nekrosha();
        }
    } else if (machine[0] == 'p') {
        if (strcmp(machine, "partner-bin") == 0) {
            speed = 10;
            variant = VARIANT_RK;
            return maketape_nekrosha();
        }
    } else if (machine[0] == 'v') {
        if (strcmp(machine, "v06c-rom") == 0) {
            speed = 8;
            return maketape_v06c_rom();
        }
    } else if (machine[0] == 'k') {
        if (strcmp(machine, "krista-rom") == 0) {
            speed = 8;
            return maketape_krista();
        }
    } else if (machine[0] == 's') {
        if ((strcmp(machine, "spetsialist-rks") == 0)
            || (strcmp(machine, "specialist-rks") == 0)
            || (strcmp(machine, "spec-rks") == 0)
            ) {
            speed = 8;
            return maketape_specialist();
        }
        if ((strcmp(machine, "spetsialist-mon") == 0)
            || (strcmp(machine, "specialist-mon") == 0)
            || (strcmp(machine, "spec-mon") == 0)
            ) {
            speed = 8;
            variant = VARIANT_SP_MON;
            return maketape_specialist();
        }
    }
    return 1;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void showhelp(void)
{
    puts("\n"
         "Usage: bin2wav program.rom program.wav [options]\n"
         "   -s load_addr in C-like notation e.g. 256, 0x100. Default 0x100.\n"
         "   -n tape_name for Vector-06C name to put in tape headers. Default: rom file name\n"
         "   -m machine-format (default v06c-rom)\n"
         "Available formats:\n"
         "   rk-bin          Радио 86РК\n"
         "   mikrosha-bin    Микроша\n"
         "   partner-bin     Партнер\n"
         "   v06c-rom        Вектор-06ц\n"
         "   krista-rom      Криста-2\n"
         "   specialist-rks  Специалист .RKS\n"
         "   specialist-mon  Специалист .MON");
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

int main(int argc, char *argv[])
{
    strcpy(machine, "v06c-rom");
    char s2[256];
    int i = 0;
    while (++i < argc) {
        strncpy(s2, argv[i], 255);
        if (s2[0] == '-') {
            switch (s2[1]) {
            case 's':
                if (++i < argc) {
                    strncpy(s2, argv[i], 255);
                    if (str_to_u16(s2, &loadAddr)) {
                        showhelp();
                        return 2;
                    }
                    break;
                } else {
                    showhelp();
                    return 2;
                }
            case 'n':
                if (++i < argc) {
                    strncpy(tapeName, argv[i], 255);
                    break;
                } else {
                    showhelp();
                    return 2;
                }
            case 'm':
                if (++i < argc) {
                    strncpy(machine, argv[i], 255);
                    break;
                } else {
                    showhelp();
                    return 2;
                }
            case 'v':
            case 'h':
                puts("\nBIN to WAV (" __DATE__ ") win32-version by "
                     __USERNAME__ ", algo by svofski.");
                break;
            default:
                showhelp();
                return 2;
            }
        } else {
            if (romFile[0] == 0)
                strcpy(romFile, s2);
            else if (outFile[0] == 0)
                strcpy(outFile, s2);
        }

    }

    if ((romFile[0] == 0) || (outFile[0] == 0)) {
        showhelp();
        return 2;
    }
    if (strcmp(romFile, outFile) == 0) {
        showhelp();
        return 2;
    }

    if ((romFile[0]) && (tapeName[0] == 0))
        strcpy(tapeName, romFile);

    printf("Input file:    %s\n"
           "Output file:   %s\n"
           "Load address:  0x%04X\n"
           "Tape name:     %s\n"
           "Tape format:   %s\n", romFile, outFile, loadAddr, tapeName,
           machine);

    FILE *f1 = fopen(romFile, "rb");
    if (f1) {
        binSize = (uint16_t) fread(romData, 1, 65535, f1);
        fclose(f1);
    }
    if ((f1 == NULL) || (binSize == 0)) {
        printf("Error reading input file: %s\n", romFile);
        return 1;
    }

    i = MakeTape();
    if (i == 0)
        printf("WAV file written to %s", outFile);
    else
        printf("Error writing WAV data to %s", outFile);

    return i;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
