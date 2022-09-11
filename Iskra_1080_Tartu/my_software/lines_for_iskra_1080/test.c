#include <string.h>
#include <stdint.h>
#include <stddef.h>

// test.c(53,34): Can't const char* == const char[6]
//  if (!(strchr("01234", '2') == "01234" + 2 && strchr("01234", A') == NULL))

#ifdef __C8080_COMPILER
void printf(const char* text) {
    (void)text;
    asm {
        ld c, 0
        jp 0F137h
    }
}
#else
#include <stdio.h>
#endif

void main() {
    printf("TEST\r\n");

    int8_t a8 = -1;
    int8_t b8 = 1;
    if (a8 >= b8) printf("FAIL int8_t\r\n");

    int16_t a16, b16;
    a16 = 1000;
    b16 = 1000;
    if (a16 != b16) printf("FAIL int16_t 0\r\n");
    a16 = -1;
    b16 = 1;
    if (a16 >= b16) printf("FAIL int16_t 1\r\n");
    a16 = 1;
    b16 = 130;
    if (a16 > b16) printf("FAIL int16_t 2\r\n");

    // memcmp

    if (!(memcmp("01234", "01234", 5) == 0 && memcmp("ABC", "ABD", 3) < 0 && memcmp("ABD", "ABC", 3) > 0))
        printf("FAIL memcmp\r\n");

    // memcpy

    char buffer[16];
    if (memcpy(buffer, "01234", 5) != buffer) printf("FAIL memcpy\r\n");
    if (!(memcmp(buffer, "01234", 5) == 0)) printf("FAIL memcpy\r\n");

    // memmove

    if (memmove(buffer + 2, buffer, 5) != buffer + 2) printf("FAIL memmove\r\n");
    if (!(memcmp(buffer, "0101234", 7) == 0)) printf("FAIL memmove\r\n");

    // memcmp

    memset(buffer + 3, '!', 3);
    if (!(memcmp(buffer, "010!!!4", 7) == 0)) printf("FAIL memset\r\n");

        // memswap

#ifdef __C8080_COMPILER
    char buffer2[16];
    memcpy(buffer, "012345", 6);
    memcpy(buffer2, "ABCDEF", 6);
    memswap(buffer, buffer2, 6);
    if (!(memcmp(buffer, "ABCDEF", 6) == 0 && memcmp(buffer2, "012345", 6) == 0)) printf("FAIL memswap\r\n");
#endif
    // strchr

    const char* str = "01234";
    if (!(strchr(str, '2') == str + 2 && strchr("01234", 'A') == NULL)) printf("FAIL strchr\r\n");

    // strcmp

    if (!(strcmp("01234", "01234") == 0 && strcmp("ABC", "ABD") < 0 && strcmp("ABD", "ABC") > 0))
        printf("FAIL strcmp\r\n");

    // strcpy

    if (strcpy(buffer, "ABC") != buffer) printf("FAIL strcpy\r\n");

    if (!(memcmp(buffer, "ABC", 4) == 0)) printf("FAIL strcpy\r\n");

    // strlen

    if (strlen("ABC") != 3 || strlen("01234") != 5) printf("FAIL strcpy\r\n");
}
