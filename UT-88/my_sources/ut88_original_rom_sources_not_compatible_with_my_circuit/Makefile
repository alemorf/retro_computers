all: files ut88.bin files

files:
	rm -f save1.inc save2.inc
	find . -type f >ut88.files

%.asm: %.cmm ./bin/cmm
	./bin/cmm $@ $<

%.bin: %.asm
	echo " device zxspectrum48" >__header.asm
	echo " savebin \"$@\", outputFileBegin, outputFileEnd - 1" >__footer.asm
	./bin/sjasmplus --lst=$@.lst __header.asm $< __footer.asm 1>&2 || rm -f $@ __header.asm __footer.asm
	rm -f __header.asm __footer.asm
	if [ -e $@.check ]; then cmp $@ $@.check || rm $@; fi
	ls $@

ut88.asm: ut88.cmm

ut88.bin: ut88.asm

clean:
	rm -f ut88.bin ut88.bin.lst __header.asm __footer.asm
