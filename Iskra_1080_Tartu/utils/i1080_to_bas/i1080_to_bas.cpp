// Convert a basic programm from I1080 to TXT format
// License GNU2
// (c) 2-Sep-2018 Aleksey Morozov aleksey.f.morozov@gmail.com

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>

const char* words[] = {
    /*80h*/ "CLS",
    /*81h*/ "REM",
    /*82h*/ "LIST",
    /*83h*/ "RUN",
    /*84h*/ "INPUT",
    /*85h*/ "DIM",
    /*86h*/ "READ",
    /*87h*/ "LOCATE",
    /*88h*/ "GOTO",
    /*89h*/ "FOR",
    /*8Ah*/ "IF",
    /*8Bh*/ "RESTORE",
    /*8Ch*/ "GOSUB",
    /*8Dh*/ "RETURN",
    /*8Eh*/ "NEXT",
    /*8Fh*/ "STOP",
    /*90h*/ "OUT",
    /*91h*/ "ON",
    /*92h*/ "PSET",
    /*93h*/ "LINE",
    /*94h*/ "POKE",
    /*95h*/ "PRINT",
    /*96h*/ "DEF",
    /*97h*/ "CONT",
    /*98h*/ "DATA",
    /*99h*/ "CLEAR",
    /*9Ah*/ "CLOAD",
    /*9Bh*/ "CSAVE",
    /*9Ch*/ "VERIFY",
    /*9Dh*/ "BEEP",
    /*9Eh*/ "NEW",
    /*9Fh*/ "INVERSE",
    /*A0h*/ "NORMAL",
    /*A1h*/ "RENUM",
    /*A2h*/ "END",
    /*A3h*/ 0,
    /*A4h*/ "CIRCLE",
    /*A5h*/ "PAINT",
    /*A6h*/ "ASAVE",
    /*A7h*/ "ALOAD",
    /*A8h*/ "LUT",
    /*A9h*/ "PRESET",
    /*AAh*/ "COLOR",
    /*ABh*/ "PCLS",
    /*ACh*/ "TAB(",
    /*ADh*/ "TO",
    /*AEh*/ "SRC(",
    /*AFh*/ "FN",
    /*B0h*/ "THEN",
    /*B1h*/ "NOT",
    /*B2h*/ "STEP",
    /*B3h*/ "+",
    /*B4h*/ "-",
    /*B5h*/ "*",
    /*B6h*/ "/",
    /*B7h*/ "^",
    /*B8h*/ "AND",
    /*B9h*/ "OR",
    /*BAh*/ ">",
    /*BBh*/ "=",
    /*BCh*/ "<",
    /*BDh*/ "SGN",
    /*BEh*/ "INT",
    /*BFh*/ "ABS",
    /*C0h*/ "USR",
    /*C1h*/ "FRE",
    /*C2h*/ "INP",
    /*C3h*/ "POS",
    /*C4h*/ "SQR",
    /*C5h*/ "RND",
    /*C6h*/ "LOG",
    /*C7h*/ "EXP",
    /*C8h*/ "COS",
    /*C9h*/ "SIN",
    /*CAh*/ "TAN",
    /*CBh*/ "ATN",
    /*CCh*/ "PEEK",
    /*CDh*/ "LEN",
    /*CEh*/ "STR$",
    /*CFh*/ "VAL",
    /*D0h*/ "ASC",
    /*D1h*/ "CHR$",
    /*D2h*/ "LEFT$",
    /*D3h*/ "RIGHT$",
    /*D4h*/ "MID$",
    /*D5h*/ "POINT",
};

const char* convert[256] = {
    "⓪", "Ⓐ", "Ⓑ", "Ⓒ", "Ⓓ",  "Ⓔ", "Ⓕ", "Ⓖ", "Ⓗ", "Ⓘ", "Ⓙ", "Ⓚ", "Ⓛ",  "Ⓜ", "Ⓝ", "Ⓞ", "Ⓟ", "Ⓠ", "Ⓡ", "Ⓢ", "Ⓣ", "Ⓤ",
    "Ⓥ", "Ⓦ", "Ⓧ", "Ⓨ", "Ⓩ",  "ⓐ", "ⓑ", "ⓒ", "ⓓ", "ⓔ", " ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+",
    ",", "-", ".", "/", "0",  "1", "2", "3", "4", "5", "6", "7", "8",  "9", ":", ";", "<", "=", ">", "?", "@", "A",
    "B", "C", "D", "E", "F",  "G", "H", "I", "J", "K", "L", "M", "N",  "O", "P", "Q", "R", "S", "T", "U", "V", "W",
    "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d",  "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r",  "s", "t", "u", "v", "w", "x", "y", "z",  "{", "|", "}", "~", "☺", "╠", "═", "╬", "│",
    "┤", "╦", "╔", "╝", "╚",  "╣", "║", "╗", "╡", "╞", "╢", "┐", "└",  "┴", "┬", "├", "─", "┼", "Õ", "Ä", "Ö", "Ü",
    "õ", "ä", "ö", "ü", "╬",  "╖", "╕", "Ё", "╜", "╛", "╞", "╨", "╧",  "╤", "╥", "┘", "┌", "╙", "╘", "╒", "╓", "╪",
    "А", "Б", "В", "Г", "Д",  "Е", "Ж", "З", "И", "Й", "К", "Л", "М",  "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х",
    "Ц", "Ч", "Ш", "Щ", "Ъ",  "Ы", "Ь", "Э", "Ю", "Я", "а", "б", "в",  "г", "д", "е", "ж", "з", "и", "й", "к", "л",
    "м", "н", "о", "п", "р",  "с", "т", "у", "ф", "х", "ц", "ч", "ш",  "щ", "ъ", "ы", "ь", "э", "ю", "я", "╫", "ё",
    "±", "÷", "°", "²", "³",  "♪", "↑", "↓", "→", "←", "▶", "◆", "▒",  "▓"};

bool isNumOrAlpha(char c) {
    if (c >= 'A' && c <= 'Z') return true;
    if (c >= 'a' && c <= 'z') return true;
    if (c >= '0' && c <= '9') return true;
    return false;
}

int main(int argc, char** argv) {
    if (argc != 2) return 1;
    int h = open(argv[1], O_RDONLY);
    if (h == -1) {
        printf("Can't open file\n");
        return 1;
    }

    char buf[65536];
    int len = read(h, buf, sizeof(buf));
    bool stringMode = false;

    buf[15] = 0;
    char lastChar = '0';
    char lastWordChar = 0;
    for (int i = 15; i < len; i++) {
        uint8_t c = buf[i];
        if (c == 0) {
            if (i != 15) printf("\n");
            i += 2;
            int line = *(uint16_t*)(buf + i + 1);
            if (line == 0) break;
            printf("%u ", line);
            stringMode = false;
            //            needSpace = false;
            i += 2;
            lastChar = ' ';
            lastWordChar = 0;
            continue;
        }
        if (!stringMode) {
            if (c == 0xF0) {
                int line = *(uint16_t*)(buf + i + 1);
                printf(" %u", line);
                i += 2;
                lastChar = '0';
                lastWordChar = 0;
                continue;
            }
            if (c >= 128 && c < 128 + sizeof(words) / sizeof(words[0]) && words[c - 128] != 0) {
                const char* f = words[c - 128];
                if (isNumOrAlpha(lastChar) && isNumOrAlpha(f[0])) printf(" ");
                printf("%s", f);
                lastWordChar = lastChar = f[strlen(f) - 1];
                continue;
            }
        }
        if (c == '"') stringMode = !stringMode;
        const char* f = convert[c];
        if (isNumOrAlpha(lastWordChar) && isNumOrAlpha(f[0])) printf(" ");
        printf("%s", f);
        lastChar = f[0];
        lastWordChar = 0;
    }

    return 0;
}
