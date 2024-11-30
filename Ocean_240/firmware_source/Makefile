EMU_DIR=~/a/work/ocean_emu/
EMU_FILE=$(EMU_DIR)/mon.bin

all: filelist bios.bin disk_bin

.PHONY: clean
clean:
	rm -f makeoceanrom/makeoceanrom bios.txt original.txt bios.lst bios.creator.user
	find . -type f >bios.files

.PHONY: filelist
filelist:
	find . -type f >bios.files

bios.bin: bios.asm Makefile *.inc
	rm -f bios.bin
	wine TASM.EXE -lst -b -85 bios.asm bios.bin
#	hd -v bios.bin >bios.txt
#	hd -v original.bin >original.txt
#	diff bios.txt original.txt

makeoceanrom/makeoceanrom: makeoceanrom/makeoceanrom.cpp makeoceanrom/fs_tools.cpp
	cd makeoceanrom && g++ -static --std=c++17 -o makeoceanrom makeoceanrom.cpp fs_tools.cpp

makeoceanrom/makeoceanrom.exe: makeoceanrom/makeoceanrom.cpp makeoceanrom/fs_tools.cpp
	cd makeoceanrom && x86_64-w64-mingw32-g++ -static --std=c++17 -o makeoceanrom.exe makeoceanrom.cpp fs_tools.cpp

.PHONY: disk_bin
disk_bin: bios.bin makeoceanrom/makeoceanrom makeoceanrom/makeoceanrom.exe
	makeoceanrom/makeoceanrom disk.bin files

.PHONY: $(EMU_FILE)
$(EMU_FILE): disk_bin Makefile
	cp disk.bin $(EMU_FILE)
	cd $(EMU_DIR) && make
