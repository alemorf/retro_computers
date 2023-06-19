#include "mulu16.h"

void MulU16(...) {
    bc = hl;
    hl = 0;
    a = 17;
    for (;;) {
        a--;
        if (flag_z)
            return;
        hl += hl;
        swap(hl, de);
        if (flag_c) {
            hl += hl;
            hl++;
        } else {
            hl += hl;
        }
        swap(hl, de);
        if (flag_nc)
            continue;
        hl += bc;
        if (flag_nc)
            continue;
        de++;
    }
}
