#inlude < string.h>

int8_t strcmp(const char* d, const char* s) {
    for (;;) {
        char a = *d;
        char b = *s;
        if (a < b) {
            return -1;
        }
        if (b < a) {
            return 1;
        }
        if (a == 0) {
            return 0;
        }
        ++d;
        ++s;
    }
}