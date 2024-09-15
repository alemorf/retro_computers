EMU_DIR=../../ocean_emu/
EMU_FILE=$(EMU_DIR)/mon.bin

all: keyb.bin full.bin bios.bin cpm.bin bios_512.bin

keyb.bin: keyb.asm Makefile
	wine tasm.exe -85 -b -c keyb.asm keyb.bin || rm keyb.bin

NEW_CODE_0_POS=6
NEW_CODE_0_SIZE=6
NEW_CODE_1_POS=64
NEW_CODE_1_SIZE=3
NEW_CODE_2_POS=7661

full.bin: original_full.bin keyb.bin Makefile
	dd if=original_full.bin of=1.tmp bs=1 count=$$((8192 + $(NEW_CODE_0_POS)))
	dd if=keyb.bin of=2.tmp bs=1 skip=$(NEW_CODE_0_POS) count=$(NEW_CODE_0_SIZE)
	dd if=original_full.bin of=3.tmp bs=1 skip=$$((8192 + $(NEW_CODE_0_POS) + $(NEW_CODE_0_SIZE))) count=$$(($(NEW_CODE_1_POS) - $(NEW_CODE_0_POS) - $(NEW_CODE_0_SIZE)))
	dd if=keyb.bin of=4.tmp bs=1 skip=$(NEW_CODE_1_POS) count=$(NEW_CODE_1_SIZE)
	dd if=original_full.bin of=5.tmp bs=1 skip=$$((8192 + $(NEW_CODE_1_POS) + $(NEW_CODE_1_SIZE))) count=$$(($(NEW_CODE_2_POS) - $(NEW_CODE_1_POS) - $(NEW_CODE_1_SIZE)))
	dd if=keyb.bin of=6.tmp bs=1 skip=$(NEW_CODE_2_POS)
	cat 1.tmp 2.tmp 3.tmp 4.tmp 5.tmp 6.tmp >full.bin
	fallocate -l 16384 full.bin
	rm -f 1.tmp 2.tmp 3.tmp 4.tmp 5.tmp 6.tmp

$(EMU_FILE): full.bin Makefile
	cp full.bin $(EMU_FILE)
	cd $(EMU_DIR) && make

bios.bin: full.bin Makefile
	dd if=full.bin of=bios.bin bs=1 skip=8192 count=8192

bios_512.bin: bios.bin Makefile
	cat bios.bin bios.bin bios.bin bios.bin bios.bin bios.bin bios.bin bios.bin >bios_512.bin

cpm.bin: full.bin
	dd if=full.bin of=cpm.bin bs=1 skip=0 count=8192

clean:
	rm keyb.bin full.bin bios.bin bios_512.bin cpm.bin keyb.lst