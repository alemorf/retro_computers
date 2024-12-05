all: decode_ocean_floppy decode_ocean_floppy.exe

.PHONY: clean
clean:

.PHONY: format
format:
	clang-format -i decode_ocean_floppy.c

decode_ocean_floppy.exe: decode_ocean_floppy.c
	x86_64-w64-mingw32-g++ -O2 -static --std=c++17 -o$@ $<

decode_ocean_floppy: decode_ocean_floppy.c
	g++ -g -static --std=c++17 -o$@ $<

