all: micro80cpm.bin
	cp micro80cpm.bin ../micro80_emulator
	cd ../micro80_emulator && make

.PHONY: clean
clean:
	rm cpm.lst cpm.bin make_micro80_rom

make_micro80_rom: make_micro80_rom.cpp Makefile
	g++ -o $@ make_micro80_rom.cpp 

micro80cpm.bin: cpm.bin make_micro80_rom files/* Makefile
	./make_micro80_rom

cpm.bin: cpm.asm cpm22.inc Makefile
	wine ./TASM.EXE -t80 cpm.asm -b cpm1.bin
	dd if=cpm1.bin of=cpm2.bin bs=1 count=28
	dd if=cpm1.bin of=cpm3.bin bs=1 skip=50176
	cat cpm2.bin cpm3.bin >cpm.bin
	rm cpm1.bin cpm2.bin cpm3.bin
