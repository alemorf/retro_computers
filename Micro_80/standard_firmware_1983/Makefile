all: micro80.bin

.PHONY: clean
clean:
	rm micro80.bin micro80.lst micro80.asm

micro80.bin: Makefile micro80.c
	~/bin/c8080 -m micro80.c

.PHONY: format
format:
	clang-format -i micro80.c