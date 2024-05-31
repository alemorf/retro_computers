/* Convert standard font to Micro 80 ROM
 * (c) 31-05-2024 Aleksey Morozov aleksey.f.morozov@gmail.com
 * AS IS licence
 */

#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>

static bool load_file(const char *file_name, void *buf, size_t buf_size) {
    const int fd = open(file_name, O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "Can't create file '%s', error %i\n", file_name, errno);
        perror("");
        return false;
    }

    if (read(fd, buf, buf_size) != buf_size) {
        fprintf(stderr, "Can't read %zu bytes from %s\n", buf_size, file_name);
        close(fd);
        return false;
    }

    if (close(fd) != 0) {
        fprintf(stderr, "Can't close file '%s', errno %i\n", file_name, errno);
        perror("");
        return false;
    }

    return true;
}

static bool save_file(const char *file_name, const void *buf, size_t buf_size) {
    const int fd = open(file_name, O_CREAT | O_TRUNC | O_WRONLY, 0644);
    if (fd == -1) {
        fprintf(stderr, "Can't create file '%s', error %i\n", file_name, errno);
        perror("");
        return false;
    }

    if (write(fd, buf, buf_size) != buf_size) {
        fprintf(stderr, "Can't write %zu bytes to %s\n", sizeof(buf), file_name);
        close(fd);
        return false;
    }

    if (close(fd) != 0) {
        fprintf(stderr, "Can't close file '%s', errno %i\n", file_name, errno);
        perror("");
        return false;
    }

    return true;
}

int main(int argc, char **argv) {
    printf(
        "Convert standard font to Micro 80 ROM\n"
        "(c) 31-05-2024 Aleksey Morozov aleksey.f.morozov@gmail.com\n");

    if (argc != 3) {
        fprintf(stderr, "Usage: %s ouput_file input_file\n", argv[0]);
        return 0;
    }

    char buf[256 * 16];

    if (!load_file(argv[2], buf, sizeof(buf)))
        return 1;

    char buf2[256 * 16 * 2];
    memset(buf2, 0xFF, sizeof(buf2));
    size_t c, h, b = 0;
    for (c = 0; c < 256; c++)
        for (h = 0; h < 8; h++)
            buf2[b++] = 0xFF ^ buf[c * 16 + h];
    for (c = 0; c < 256; c++)
        for (h = 8; h < 16; h++)
            buf2[b++] = 0xFF ^ buf[c * 16 + h];
    memcpy(buf2 + sizeof(buf2) / 2, buf2, sizeof(buf2) / 2);
    for (c = 0; c < 256; c++)
        for (h = 1; h < 2; h++)
            buf2[256 * 24 + c * 8 + h] = 0;

    if (!save_file(argv[1], buf2, sizeof(buf2)))
        return 1;

    return 0;
}
