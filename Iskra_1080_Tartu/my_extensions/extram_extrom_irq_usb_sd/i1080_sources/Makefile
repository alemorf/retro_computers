EMU=../../../my_emulator.html
F=$(EMU)/iskra1080extrom.js
G=$(EMU)/iskra1080extboot.js
SMALL=$(EMU)/floppy/small.js
SC2=$(EMU)/floppy/sc2.js
WS=$(EMU)/floppy/ws.js

all: bios/boot.cpm small.cpm sc2.cpm files $F $G $(SMALL) $(SC2) $(WS)

files: 
	find . -type f >iskra1080.files

CLEAN += bios/font4/font4
bios/font4/font4: bios/font4/font4.c
	gcc $^ -o$@
CLEAN += bios/font4.tmp
bios/font4.tmp: bios/font4.bin bios/font4/font4
	bios/font4/font4 bios/font4.bin bios/font4.tmp

CLEAN += bios/boot.asm
CLEAN += bios/boot.lst
CLEAN += bios/boot.cpm
bios/boot.cpm: bios/*.c bios/*.h bios/cpm22/cpm22.bin bios/font4.tmp
	cd bios && ../bin/c8080 -I../bin/include -o boot.cpm -m entry.c console.c graph.c graph4.c keyboard.c main.c mulu16.c printer.c storage.c uart.c menu.c save.c

CLEAN += bios/cpm22/cpm22.bin
CLEAN += bios/cpm22/cpm22.lst
bios/cpm22/cpm22.bin: bios/cpm22/cpm22.asm bios/cpm22/ipc.inc
	./bin/sjasmplus bios/cpm22/cpm22.asm --raw=bios/cpm22/cpm22.bin --lst=bios/cpm22/cpm22.lst || rm bios/cpm22/cpm22.bin bios/cpm22/cpm22.lst

CLEAN += floppy_header.bin
floppy_header.bin: floppy_header.asm
	./bin/sjasmplus floppy_header.asm

CLEAN += small.cpm
small.cpm: disk_small/* floppy_header.bin
	fallocate -l 819200 small.cpm
	mkfs.cpm -b floppy_header.bin -f i1080 small.cpm
	cpmcp -f i1080 small.cpm disk_small/* 0:

CLEAN += sc2.cpm
sc2.cpm: disk_sc2/* floppy_header.bin
	fallocate -l 819200 sc2.cpm
	mkfs.cpm -b floppy_header.bin -f i1080 sc2.cpm
	cpmcp -f i1080 sc2.cpm disk_sc2/* 0:

CLEAN += ws.cpm
ws.cpm: disk_ws/* floppy_header.bin
	fallocate -l 819200 ws.cpm
	mkfs.cpm -b floppy_header.bin -f i1080 ws.cpm
	cpmcp -f i1080 ws.cpm disk_ws/* 0:

CLEAN += loader/loader.bin
CLEAN += loader/loader.lst
CLEAN += loader/loader.asm
loader/loader.bin: loader/loader.c
	cd loader && ../bin/c8080 -o loader.bin -m loader.c

CLEAN += iskra1080.creator.user
CLEAN += iskra1080.files

clean:
	rm -f ${CLEAN}

format:
	clang-format -i *.h loader/*.c bios/*.h bios/*.c bios/font4/*.c

$F: loader/loader.bin
	echo "const iskra1080extrom = [" >$F
	xxd -i loader/loader.bin | grep , >>$F
	echo "];" >>$F

$G: bios/boot.cpm
	echo "const iskra1080extboot = [" >$G
	xxd -i bios/boot.cpm | grep , >>$G
	echo "];" >>$G

$(SMALL): small.cpm
	echo "loadFloppy([" >$(SMALL)
	xxd -i small.cpm | grep , >>$(SMALL)
	echo "]);" >>$(SMALL)

$(SC2): sc2.cpm
	echo "loadFloppy([" >$(SC2)
	xxd -i sc2.cpm | grep , >>$(SC2)
	echo "]);" >>$(SC2)

$(WS): ws.cpm
	echo "loadFloppy([" >$(WS)
	xxd -i ws.cpm | grep , >>$(WS)
	echo "]);" >>$(WS)

