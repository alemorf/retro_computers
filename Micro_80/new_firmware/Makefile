all: micro80.bin

.PHONY: clean
clean:
	rm micro80.bin micro80.lst micro80.asm

micro80.bin: Makefile micro80.c
	~/a/work/c8080/c8080 -m micro80.c

.PHONY: format
format:
	clang-format -i micro80.c
