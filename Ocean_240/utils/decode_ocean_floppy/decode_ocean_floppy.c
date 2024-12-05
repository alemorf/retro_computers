/* Convert Ocean 240 floppy images to normal format
 * Copyright (c) 2024 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <errno.h>

static const unsigned interleave[] = {1, 8, 6, 4, 2, 9, 7, 5, 3};

/* For Windows O.o */
#ifndef O_BINARY
#define O_BINARY 0
#endif

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr,
                "Convert Ocean 240 floppy images to normal format\n"
                "Usage: %s to.imd from.img\n",
                argv[0]);
        return 1;
    }

    int fd = open(argv[2], O_RDONLY | O_BINARY);
    if (fd == -1) {
        fprintf(stderr, "Can't open file %s, errno %i\n", argv[2], errno);
        return 1;
    }

    int fd2 = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0644);
    if (fd2 == -1) {
        fprintf(stderr, "Can't create file %s, errno %i\n", argv[1], errno);
        close(fd);
        return 1;
    }

    for (unsigned side = 0; side < 2; side++) {
        for (unsigned track = 0; track < 80; track++) {
            for (unsigned sector = 0; sector < 9; sector++) {
                const unsigned offset = (track * 18 + side * 9 + interleave[sector] - 1) * 512;
                if (lseek(fd, offset, SEEK_SET) != offset) {
                    fprintf(stderr, "Can't seek file %s, errno %i\n", argv[2], errno);
                    close(fd);
                    close(fd2);
                    return 1;
                }

                char buf[512];
                int r = read(fd, buf, 512);
                if (r != 512) {
                    fprintf(stderr, "Can't read file %s, result %i, offset %u, errno %i\n", argv[2], (int)r, offset, errno);
                    close(fd);
                    close(fd2);
                    return 1;
                }

                if (write(fd2, buf, 512) != 512) {
                    fprintf(stderr, "Can't write file %s, errno %i\n", argv[1], errno);
                    close(fd);
                    close(fd2);
                    return 1;
                }
            }
        }
    }

    printf("Done\n");

    close(fd);
    close(fd2);

    return 0;
}
