#pragma once

#include <stddef.h>

class Compare
{
public:
    const char* t;
    const char* f;

    Compare(const char* _t = nullptr, const char* _f = nullptr) : t(_t), f(_f) {}
};

inline const char* asmTypeDecl(unsigned size)
{
    switch(size)
    {
        case 1: return "db";
        case 2: return "dw";
        case 4: return "dd";
        case 8: return "dq";
        default: throw "Неподдерживаемый размер";
    }
}

inline void onlyA(const auto& l)
{
    if (l != "a") throw "Только регистр A";
}

inline void onlyHl(const auto& l)
{
    if (l != "hl" && l != "ix" && l != "iy") throw "Только регистры HL, IX, IY";
}

inline void onlyIxIy(const auto& l)
{
    if (l != "ix" && l != "iy") throw "Только регистры IX, IY";
}
inline void onlyBc(const auto& l)
{
    if (l != "bc") throw "Только регистр BC";
}

inline bool isBcDe(const auto& l)
{
    return l == "bc" || l == "de";
}

inline bool isIxIy(const auto& l)
{
    return l == "ix" || l == "iy";
}

inline unsigned getBit(long long int vv)
{
    unsigned v = ((unsigned)vv) & 0xFF;
    switch (v)
    {
        case 0x01: return 0;
        case 0x02: return 1;
        case 0x04: return 2;
        case 0x08: return 3;
        case 0x10: return 4;
        case 0x20: return 5;
        case 0x40: return 6;
        case 0x80: return 7;
        default: throw "Только один бит";
    }
}

inline long long strtoll_throw(std::string& str)
{
    char* end = nullptr;
    long long v = strtoll(str.c_str(), &end, 10);
    if (end[0] != 0) throw "Need const (" + str + ")";
    return v;
}
