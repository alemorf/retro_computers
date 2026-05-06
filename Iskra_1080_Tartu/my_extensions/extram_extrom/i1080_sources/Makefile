EMU=../../../my_emulator.html
F=$(EMU)/iskra1080extrom.js

all: iskra1080cpm.bin iskra1080.files $F
	echo $(subst $(empty) ,"\n",${CLEAN}) >.gitignore

CLEAN += iskra1080.creator.user
CLEAN += iskra1080.files
.PHONY: iskra1080.files
iskra1080.files:
	find . -type f >iskra1080.files

CLEAN += loader.bin
CLEAN += loader.lst
CLEAN += loader.asm
loader.bin: loader/loader.c *.h bios.bin cpm22.bin
	bin/c8080 -o loader.bin -m loader/loader.c

CLEAN += bios/graph/4x10/prepare_font/prepare_font
bios/graph/4x10/prepare_font/prepare_font: bios/graph/4x10/prepare_font/prepare_font.cpp
	g++ $^ -o$@

CLEAN += bios/graph/4x10/font4.tmp
bios/graph/4x10/font4.tmp: bios/graph/4x10/font4.bin bios/graph/4x10/prepare_font/prepare_font
	bios/graph/4x10/prepare_font/prepare_font bios/graph/4x10/font4.bin bios/graph/4x10/font4.tmp

CLEAN += bios.asm
CLEAN += bios.lst
CLEAN += bios.bin
bios.bin: $(shell find bios) *.h bios/graph/4x10/font4.tmp Makefile
	bin/c8080 -a bios.asm -m bios/entry.c $(shell find bios -name "*.c" -and -not -name entry.c -and -not -name save.c) bios/save.c

CLEAN += cpm22.asm
CLEAN += cpm22.bin
CLEAN += cpm22.lst
cpm22.bin: cpm22/* *.h
	bin/c8080 -a cpm22.asm -m cpm22/cpm22.c

CLEAN += make_rom
make_rom: make_rom_file/* *.h Makefile
	g++ -o $@ make_rom_file/make_rom_file.cpp make_rom_file/megalz.cpp

CLEAN += iskra1080cpm.bin
.PHONY: iskra1080cpm.bin
iskra1080cpm.bin: loader.bin make_rom *.h files/* Makefile
	./make_rom

.PHONY: clean
clean:
	rm -f ${CLEAN}

.PHONY: format
format:
	clang-format -i $(shell find . -name "*.c" -or -name "*.cpp" -or -name "*.h")

$F: iskra1080cpm.bin
	echo "const iskra1080extrom = [" >$F
	xxd -i iskra1080cpm.bin | grep , >>$F
	echo "];" >>$F
