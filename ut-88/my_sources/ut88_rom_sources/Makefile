all: files ut88.bin files

files:
	rm -f save1.inc save2.inc
	find . -type f >ut88.files

%.asm: %.c ./bin/cmm
	./bin/cmm $@ $<

%.bin: %.asm
	echo " device zxspectrum48" >__header.asm
	echo " savebin \"$@\", outputFileBegin, $$" >__footer.asm
	./bin/sjasmplus --lst=$@.lst __header.asm $< __footer.asm 1>&2 || rm -f $@
	rm -f __header.asm __footer.asm

testf.asm: testf.c test0.bin common.h

O += testf.asm

testf.bin: testf.asm

O += testf.bin
O += testf.bin.lst

test0.asm: test0.c common.h

O += test0.asm

test0.bin: test0.asm

O += test0.bin
O += test0.bin.lst

bios.asm: bios.c common.h unmlz.h

O += bios.asm

bios.bin: bios.asm

O += bios.bin
O += bios.bin.lst

calcsum: calcsum.cpp
	g++ -o $@ $<

O += calcsum

ut88.bin: ut88.asm testf.bin calcsum bios.bin files/*
	./bin/sjasmplus --lst=$@.lst ut88.asm 1>&2
	printf " " >>$@
	./calcsum $@

O += ut88.bin
O += ut88.bin.lst

clean:
	rm -f $O __header.asm __footer.asm
