// За основу взято http://github.com/eraxillan/convert-utf8-to-cp1251/blob/master/main.cpp

#include "utf8tocp1251.h"

static unsigned cp1251ToUtf8_1(unsigned unicode_char)
{
    //if (unicode_char >= 0x80 && unicode_char <= 0xFF) return unicode_char;
    if (unicode_char >= 0x410 && unicode_char <= 0x44F) return unicode_char - 0x350;
    if (unicode_char >= 0x402 && unicode_char <= 0x403) return unicode_char - 0x382;

    switch (unicode_char)
    {
        case 0x201A: return 0x82; // SINGLE LOW-9 QUOTATION MARK
        case 0x0453: return 0x83; // CYRILLIC SMALL LETTER GJE
        case 0x201E: return 0x84; // DOUBLE LOW-9 QUOTATION MARK
        case 0x2026: return 0x85; // HORIZONTAL ELLIPSIS
        case 0x2020: return 0x86; // DAGGER
        case 0x2021: return 0x87; // DOUBLE DAGGER
        case 0x20AC: return 0x88; // EURO SIGN
        case 0x2030: return 0x89; // PER MILLE SIGN
        case 0x0409: return 0x8A; // CYRILLIC CAPITAL LETTER LJE
        case 0x2039: return 0x8B; // SINGLE LEFT-POINTING ANGLE QUOTATION MARK
        case 0x040A: return 0x8C; // CYRILLIC CAPITAL LETTER NJE
        case 0x040C: return 0x8D; // CYRILLIC CAPITAL LETTER KJE
        case 0x040B: return 0x8E; // CYRILLIC CAPITAL LETTER TSHE
        case 0x040F: return 0x8F; // CYRILLIC CAPITAL LETTER DZHE
        case 0x0452: return 0x90; // CYRILLIC SMALL LETTER DJE
        case 0x2018: return 0x91; // LEFT SINGLE QUOTATION MARK
        case 0x2019: return 0x92; // RIGHT SINGLE QUOTATION MARK
        case 0x201C: return 0x93; // LEFT DOUBLE QUOTATION MARK
        case 0x201D: return 0x94; // RIGHT DOUBLE QUOTATION MARK
        case 0x2022: return 0x95; // BULLET
        case 0x2013: return 0x96; // EN DASH
        case 0x2014: return 0x97; // EM DASH
        case 0x2122: return 0x99; // TRADE MARK SIGN
        case 0x0459: return 0x9A; // CYRILLIC SMALL LETTER LJE
        case 0x203A: return 0x9B; // SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
        case 0x045A: return 0x9C; // CYRILLIC SMALL LETTER NJE
        case 0x045C: return 0x9D; // CYRILLIC SMALL LETTER KJE
        case 0x045B: return 0x9E; // CYRILLIC SMALL LETTER TSHE
        case 0x045F: return 0x9F; // CYRILLIC SMALL LETTER DZHE
        case 0x00A0: return 0xA0; // NO-BREAK SPACE
        case 0x040E: return 0xA1; // CYRILLIC CAPITAL LETTER SHORT U
        case 0x045E: return 0xA2; // CYRILLIC SMALL LETTER SHORT U
        case 0x0408: return 0xA3; // CYRILLIC CAPITAL LETTER JE
        case 0x00A4: return 0xA4; // CURRENCY SIGN
        case 0x0490: return 0xA5; // CYRILLIC CAPITAL LETTER GHE WITH UPTURN
        case 0x00A6: return 0xA6; // BROKEN BAR
        case 0x00A7: return 0xA7; // SECTION SIGN
        //case 0x0401: return 0xA8; // CYRILLIC CAPITAL LETTER IO
        case 0x00A9: return 0xA9; // COPYRIGHT SIGN
        case 0x0404: return 0xAA; // CYRILLIC CAPITAL LETTER UKRAINIAN IE
        case 0x00AB: return 0xAB; // LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
        case 0x00AC: return 0xAC; // NOT SIGN
        case 0x00AD: return 0xAD; // SOFT HYPHEN
        case 0x00AE: return 0xAE; // REGISTERED SIGN
        case 0x0407: return 0xAF; // CYRILLIC CAPITAL LETTER YI
        case 0x00B0: return 0xB0; // DEGREE SIGN
        case 0x00B1: return 0xB1; // PLUS-MINUS SIGN
        case 0x0406: return 0xB2; // CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
        case 0x0456: return 0xB3; // CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
        case 0x0491: return 0xB4; // CYRILLIC SMALL LETTER GHE WITH UPTURN
        case 0x00B5: return 0xB5; // MICRO SIGN
        case 0x00B6: return 0xB6; // PILCROW SIGN
        case 0x00B7: return 0xB7; // MIDDLE DOT
        case 0x0451: return 0x7F; // 0xB8; // CYRILLIC SMALL LETTER IO
        case 0x2116: return 0xB9; // NUMERO SIGN
        case 0x0454: return 0xBA; // CYRILLIC SMALL LETTER UKRAINIAN IE
        case 0x00BB: return 0xBB; // RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
        case 0x0458: return 0xBC; // CYRILLIC SMALL LETTER JE
        case 0x0405: return 0xBD; // CYRILLIC CAPITAL LETTER DZE
        case 0x0455: return 0xBE; // CYRILLIC SMALL LETTER DZE
        case 0x0457: return 0xBF; // CYRILLIC SMALL LETTER YI
        default: return 0;
    }
}

bool cp1251ToUtf8(std::string& o, const std::string& i)
{
    const char* utf8 = i.data();
    const char* se = i.data() + i.size();
    o.resize(i.size());
    char* out = (char*)o.data();
    for(;utf8 != se;)
    {
        char prefix = *utf8++;

        if ((prefix & 0x80) == 0)
        {
            *out++ = prefix;
            continue;
        }

        if ((~prefix) & 0x20)
        {
            char suffix = *utf8++;
            if (suffix == 0) return false;
            int first5bit = prefix & 0x1F;
            first5bit <<= 6;
            int sec6bit = suffix & 0x3F;
            int unicode_char = first5bit + sec6bit;

            char c = (char)cp1251ToUtf8_1(unicode_char);
            if (c == 0) return false;
            *out++ = c;
            continue;
        }

        return false;
    }
    o.resize(out - o.data());
    return true;
}
