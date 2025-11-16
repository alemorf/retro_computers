all: micro80.bin
	cp micro80.bin ../micro80_emulator/
	cd ../micro80_emulator && make

.PHONY: clean
clean:
	rm micro80.bin micro80.lst micro80.asm

micro80.bin: micro80.c Makefile
	./bin/c8080 -m micro80.c