J=/home/alemorf/a/work/micro80_my_emulator.html/

all: bios.bin

bios.bin: Makefile standard_bios.c micro80.h save.c
	./asm80 --cmm --lst=micro80.lst standard_bios.c save.c

format:
	clang-format -i micro80.c

clean:
	rm micro80.bin

$J: bios.bin Makefile
	cp bios.bin $J
	cd $J && make
