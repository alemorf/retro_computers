#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(stderr, "%s input.bin output.bin\n", argv[0]);
        return 1;
    }
    int s = open(argv[1], O_RDONLY);
    if (s == -1) {
        fprintf(stderr, "Can't open file %s, error %i\n", argv[1], errno);
        return 1;
    }
    int d = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (d == -1) {
        fprintf(stderr, "Can't create file %s, error %i\n", argv[2], errno);
        return 1;
    }
    char buf[256 * 10];
    if (read(s, buf, sizeof(buf)) != sizeof(buf)) {
        fprintf(stderr, "Can't read file %s, error %i\n", argv[1], errno);
        return 1;
    }    
    unsigned i;
    for (i = 0; i < sizeof(buf); i++)
        buf[i] = (buf[i] << 4) | (buf[i] & 0x0F);
    if (write(d, buf, sizeof(buf)) != sizeof(buf)) {
        fprintf(stderr, "Can't read file %s, error %i\n", argv[1], errno);
        return 1;
    }
    close(s);
    close(d);
    return 0;
}
