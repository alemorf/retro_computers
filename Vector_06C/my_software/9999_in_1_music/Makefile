all:	vector_music.vec files

files:
	find . -type f >vector_music.files

clean:
	rm -f music.asm

%.asm: %.c ./bin/cmm
	./bin/cmm $@ $<

%.vec: %.asm
	@echo "    device zxspectrum48" > $@.save1.inc
	@echo "    savebin \"$@\", begin, $$ - begin" > $@.save2.inc
	./bin/sjasmplus --lst=$@.lst $@.save1.inc $(filter %.asm, $^) $@.save2.inc || rm $@ $@.save1.inc $@.save2.inc
	rm $@.save1.inc $@.save2.inc

vector_music.vec: vector_music.asm

vector_music.asm: vector_music.c
